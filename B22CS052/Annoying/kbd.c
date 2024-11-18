#include "types.h"
#include "x86.h"
#include "defs.h"
#include "kbd.h"

int devil_mode = 0;

int
kbdgetc(void)
{
  static uint shift;
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }
  else if ((shift & CTL) && (data == 0x39)){
    devil_mode = 1;
    return 2000;
  }
  else if((shift & CTL) && (data == 0x0F)){
    devil_mode = 0;
    return 0;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK & !devil_mode){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  else if(devil_mode){
  //   volatile int delay_var;
  //   for(int i = 0;i < DELAY_IRRITATE;i++){
  //   delay_var+=i;
  // }
  if((shift & SHIFT)) c = C(c);
  else if((shift & CTL)) {
    return c += 128;
  }
  }
  return c;
}

void
kbdintr(void)
{
  consoleintr(kbdgetc);
}
