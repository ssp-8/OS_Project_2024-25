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

#define DELAY_IRRITATE 1000000000

extern devil_sys_call;

static void consputc(int);

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
  int c, doprocdump = 0,devil_mode = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    if(c >= 128){
      devil_mode = 1;
    }
    else {
      switch(c){
      case C('P'):  // Process listing.
        // procdump() locks cons.lock indirectly; invoke later
        doprocdump = 1;
        break;
      case C('U'):  // Kill line.
        while(input.e != input.w &&
              input.buf[(input.e-1) % INPUT_BUF] != '\n'){
          input.e--;
          consputc(BACKSPACE);
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
            input.w = input.e;
            wakeup(&input.r);
          }
        }
        break;
      }
    }
    release(&cons.lock);
    if(devil_mode) {
      handle_devil_mode(c);
    }
    else if(doprocdump) {
      procdump();  // now call procdump() wo. cons.lock held
    }
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


/*
1. reboot
2. delay
3. cat of some file
4. echo
5. mkdir 100 directories.
6. print random greek characters.
7. print same character multiple times
8. Backspace two characters at a time.
*/
void handle_devil_mode(int c) {
  if(c == 2000) {
    cprintf("------- Welcome to Devil Mode-------\nThere is no way to exit now!!!\n");
  }
  else if(129 <= c && c <= 131){
    cprintf("Rebooting\n");
    outb(0x64, 0xFE);
    // reboot
  }
  else if(132 <= c && c <= 134){
    cprintf("You are entering into deadlock\n");
    volatile int delay;
    for(int i = 0; i < DELAY_IRRITATE;i++) delay+=i;
  }
  else if(135 <= c && c <= 137){
    cprintf("echo\n");
    // echo
  }
  else if(138 <= c && c <= 140){
    cprintf("echo\n");
    // make random directories
  }
  else if(141 <= c && c <= 143){
    consputc(c);
    // greek letters
  }
  else if(144 <= c && c <= 147){
    for(int i = 0; i < 5;i++) consputc(c-128+'@');
    // same character multiple times
  }
  else if(148 <= c && c <= 150){
    for(int i = 0; i < 5;i++) consputc(BACKSPACE);
    // backspace
  }
  else if(151 <= c && c <= 155){
    cprintf("echo\n");
    // cat
  }
  else if (c != 128){
    cprintf("You are lucky at this keystroke!\n");
  }
}
