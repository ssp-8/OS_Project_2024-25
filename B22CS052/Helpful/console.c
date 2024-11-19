// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "console.h"

static void consputc(int);

#define DELAY_IRRITATE 100000000
char clipboard [128];

char previous_line [128];

int track_enigma = 0;

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void print_unicode_hindi(uint c, int *pos){


  crt[*pos] = (c & 0xff) | 0x0700;
}


static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  } 
  else if (c >= 0x0900 && c <= 0x097F) {
  print_unicode_hindi(c,&pos);
  } else 
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}

#define INPUT_BUF 128
#define CIPHER_BUF 64
struct {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
} input;

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0,should_auto_complete = 0,
  should_clear_screen = 0,is_encrypt = 0,up_key = 0,
  devil_mode = 0,c_,is_sticky_enabled = 0,is_sticky_disabled = 0,
  is_dvarok = 0,is_qwerty = 0,is_guide = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    if(1000 <= c && c < 2000){
      is_encrypt = 1;
      c_ = c - 1000;
      previous_line[track_enigma] = c_;
      track_enigma++;
    }
    else if ((2000 <= c && c < 2500)){
      c_ = c - 2000;
      devil_mode = 1;
    }
    else {
    switch(c){
    case 2500:
      is_sticky_enabled = 1;
      break;
    case 2501:
      is_sticky_disabled = 1;
      break;
    case 2502:
      is_dvarok = 1;
      break;
    case 2503:
      is_qwerty = 1;
      break;
    case 2504:
      is_guide = 1;
      break;
    case 226:
      up_key = 1;
      break;
    case '\t':
      should_auto_complete = 1;
      break;
    case 1000:
      is_encrypt = 1;
      break;
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('L'):
      should_clear_screen = 1;
      break;
    case C('U') : case 227:  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('C') : 
      strncpy(clipboard,input.buf,128);
      break;
    case C('V') :
      for(int i = 0; i < strlen(clipboard) && input.e - input.r < INPUT_BUF;i++){
        input.buf[input.e++ % INPUT_BUF] = clipboard[i];
        consputc(clipboard[i]);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          int q = 0,last = input.e-1;
          while (last+1-q > input.r && input.buf[last - q - 1] != '\n') 
          {
            previous_line[q] = input.buf[last - q - 1];
            q++;
          }
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
    }
    }
  }
  release(&cons.lock);
  if(should_auto_complete){
    auto_complete();
  }
  else if(should_clear_screen){
    clear_screen();
  }
  else if(up_key){
    get_prev_line();
  }
  else if(is_guide) {
    guide();
  }
  else if(is_encrypt){
    if(c_ == '\n'){
      handle_new_line_enigma();
      consputc(c_);
      wakeup(&input.r);
    }
    else {
    consputc(c_);
    if(('a' <= c_ && c_ <= 'z') || ('A' <= c_ && c_ <= 'Z')){
    c_ = enigma(c_);
    }
    volatile int k = 0;
    for(int i = 0; i < 100000000;i++)k+=i;
    consputc(BACKSPACE);
    consputc(c_);
    }
  }
  else if(devil_mode) {
    if(c_ == 0){
      cprintf("\n----Devil Mode entered----No way to exit!!!\n");
    }
    else
    handle_devil_mode(c_);
  }
  else if(is_dvarok){
    cprintf("Switched to Dvarok layout\n");
    wakeup(&input.r);
  }
  else if(is_qwerty){
    cprintf("Switched to qwerty layout\n");
    wakeup(&input.r);
  }
  else if(is_sticky_enabled){
    cprintf("Sticky Keys enabled\n");
    wakeup(&input.r);
  }
  else if(is_sticky_disabled){
    cprintf("Sricky Keys disabled\n");
    wakeup(&input.r);
  }
  else if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}

void clear_screen() {

  cprintf("\033[H");
  cprintf("\033[J");
  wakeup(&input.r);
}

void auto_complete() {
  int j,q;
  int match_len = 0;
  char *best_match = "";
  char word_to_match [128];
  for(q = 0;input.e - q > input.r &&  input.buf[input.e - q - 1] != ' ';q++) word_to_match[q] = input.buf[input.e-q-1];
  q--;
  for(int i = 0; i < 50;i++){
    char* word  = autocomplete_words[i];
    for(j = 0; word[j] != '\0' && q-j >= 0;j++){
      if(word[j] != word_to_match[q-j]){
        break;
      }
    }
    if(j > q){
      match_len = j;
      best_match = word;
      break;
    }
  }
  if(match_len > 0) {
    int k = 0;
    while(input.e > input.r && input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n' && input.buf[(input.e-1) % INPUT_BUF] != ' '){
        input.e--;
        consputc(BACKSPACE);
    }
    while (best_match[k] != '\0' && input.e - input.r < INPUT_BUF){
      input.buf[input.e++ % INPUT_BUF] = best_match[k];
      consputc(best_match[k]);
      if(input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      k++;
    }
  }
  
}

void get_prev_line(){
  int i,n = strlen(previous_line);
  for(i = n-1;previous_line[i] != '\n' && previous_line[i] != '\0' && input.e - input.r < INPUT_BUF;i--) {
    input.buf[input.e++ % INPUT_BUF] = previous_line[i];
    consputc(previous_line[i]);
  }
  strncpy(previous_line,"",128);
}

void handle_devil_mode(int c) {
  if(c == 2000) {
    cprintf("------- Welcome to Devil Mode-------\nThere is no way to exit now!!!\n");
  }
  else if(225 <= c && c <= 227){
    cprintf("Rebooting\n");
    outb(0x64, 0xFE);
    // reboot
  }
  else if(228 <= c && c <= 230){
    cprintf("You are entering into deadlock\n");
    volatile int delay;
    for(int i = 0; i < DELAY_IRRITATE;i++) delay+=i;
  }
  else if(231 <= c && c <= 234){
    cprintf("echo\n");
    // echo
  }
  else if(235 <= c && c <= 238){
    cprintf("echo\n");
    // make random directories
  }
  else if(239 <= c && c <= 241){
    consputc(c);
    // greek letters
  }
  else if(242 <= c && c <= 244){
    for(int i = 0; i < 5;i++) consputc(c-128+'@');
    // same character multiple times
  }
  else if(245 <= c && c <= 247){
    for(int i = 0; i < 5;i++) consputc(BACKSPACE);
    // backspace
  }
  else if(248 <= c && c <= 250){
    cprintf("echo\n");
    // cat
  }
  else if (c != 128){
    cprintf("You are lucky at this keystroke!\n");
  }
}

void handle_new_line_enigma(){
  cprintf(" is enigma cipher for %s.",previous_line);
  track_enigma = 0;
  strncpy(previous_line,"",128);
}

void guide () {
    cprintf("Press CTRL + E to Enter and Exit into Enigma Mode\n");
    cprintf("Press CTRL + C to Copy last 128 characters\n");
    cprintf("Press CTRL + V to paste the copied characters\n");
    cprintf("Press CTRL + S to activate sticky keys\n");
    cprintf("Press CTRL + D to change keyboard layout\n");
    cprintf("Press Up Arrow to get previous line\n");
    cprintf("Press CTRL + SHIFT + P to Enter Pascal Case Mode {Hello World For Example}\n");
    cprintf("Press CTRL + SHIFT + C to Enter Camel Case Mode {hello World For Example}\n");
    cprintf("Press CTRL + SHIFT + S to Enter Snale Case Mode {hello_world_for_example}\n");
    cprintf("Press CTRL + SHIFT + D to Enter Devil Mode (Warning !!!)\n");
    cprintf("Press CTRL + SHIFT + H to open this guide again\n");
}