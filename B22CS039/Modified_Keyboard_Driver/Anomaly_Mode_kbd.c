#include "types.h"
#include "x86.h"
#include "defs.h"
#include "kbd.h"

void print_str(char *str) {
    while (*str) {
        consputc(*str++);
    }
}

int
kbdgetc(void)
{
  static uint shift;
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  static int A_mode = 0; // to check if we are in Anomaly mode
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
  

  // checking for Ctrl+A (0x1E)
  if ((data == 0x1E) && (shift & CTL)) {  
  
    A_mode = !A_mode;  // Toggle A_mode
    
    if (A_mode) {
      print_str("ANOMALY MODE ENABLED!!\n");
    } 
    else {
      print_str("ANOMALY MODE DISABLED!!\n");
    }
    return 0;  
  }


  
  if (A_mode) { // inside Anomaly Mode
    
    //1. Swapping Spacebar (0x39) with Tab (0x0F)
    if (data == 0x39) {  
      data = 0x0F;  
    } 
    else if (data == 0x0F) {  
      data = 0x39;  
    }
        
    //2. Swapping Backspace (0x0E) with Enter (0x1C)
    if (data == 0x0E) {  
      data = 0x1C;  
    } 
    else if (data == 0x1C) {  
      data = 0x0E;  
    }
  } 
  
  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];

  // normal functionality
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }


  // 3. Reversing capsLock
  if(A_mode) {
    if('a' <= c && c <= 'z')
      c = c - 'a' + 'A';  // Convert to uppercase
    else if('A' <= c && c <= 'Z')
      c = c - 'A' + 'a';  // Convert to lowercase
  }

  return c;
}

void
kbdintr(void)
{
  consoleintr(kbdgetc);
}
