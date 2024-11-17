#include "types.h"
#include "x86.h"
#include "defs.h"
#include "kbd.h"

extern uint language = 0; // 0: English, 1: Hindi
extern uint pascal_case = 0;
extern uint camel_case = 0;
extern uint space_pressed = 0;
extern uint new_line_pressed = 0;
extern uint snake_case = 0;

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
  else if ((shift & ALT) && (shift & SHIFT) && data == 0x19) {
    pascal_case = !pascal_case;
    if(camel_case) camel_case = 0;
    if(snake_case) snake_case = 0;
    return 0;
  }
  else if ((shift & ALT) && (shift & SHIFT) && data == 0x2E) {
    camel_case = !camel_case;
    if(pascal_case) pascal_case = 0;
    if(snake_case) snake_case = 0;
    return 0;
  }
  else if((shift & ALT) && (shift & SHIFT) && data == 0x1F){
    snake_case = !snake_case;
    if(pascal_case) pascal_case = 0;
    if(camel_case) camel_case = 0;
    return 0;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];

  if(pascal_case) {

    if((space_pressed || new_line_pressed) && ('a' <= c && c <= 'z')) 
      c += 'A'-'a';
    else if('A' <= c && c <= 'Z') 
      c += 'a' - 'A';
  }
  else if(camel_case) {
    if(space_pressed && ('a' <= c && c <= 'z')) 
      c += 'A' - 'a'; 
    else if('A' <= c && c <= 'Z') 
      c += 'a' - 'A';
  } 
  else if(shift & CAPSLOCK && !pascal_case && !camel_case){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  if (c == ' ') {
    space_pressed = 1;
    if(snake_case) c = '_';
  }
  else space_pressed = 0;
  if (c == '\n') new_line_pressed = 1;
  else new_line_pressed = 0;
  return c;
}

void
kbdintr(void)
{
  consoleintr(kbdgetc);
}
