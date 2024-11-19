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
extern uint encryption_mode = 0;
extern uint up_key_used = 0;
extern uint devil_mode = 0;

#define DOUBLE_PRESS 100  // 2 seconds 
#define SK_tq 500        // 10 seconds 

// Mode flags
static uint is_dvorak = 0;  // 0 for QWERTY keyboard, 1 for Dvorak keyboard
static uint A_mode = 0;     // 0 for normal mode, 1 for Anomaly mode
static uint capsActive = 0; // For sticky keys caps lock
static uint sk_enabled = 0; // Sticky keys enabled/disabled

// Timing variables
static uint last_shift_press = 0;
static uint sk_time = 0;


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

  if((shift & CTL) && (shift & SHIFT) && data == 0x23){
    return 2504;
  }
  else if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } 
  else if(data == 0xE2){
    if(up_key_used == 0) {
    up_key_used = 1;
    return 226;
    }
    return 0;
  }
  else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }
  else if ((shift & CTL) && (shift & SHIFT) && data == 0x19) {
    pascal_case = !pascal_case;
    if(camel_case) camel_case = 0;
    if(snake_case) snake_case = 0;
    new_line_pressed = 1;
    return 0;
  }
  else if ((shift & CTL) && (shift & SHIFT) && data == 0x2E) {
    camel_case = !camel_case;
    pascal_case = 0;
    snake_case = 0;
    return 0;
  }
  else if((shift & CTL) && (shift & SHIFT) && data == 0x1F){
    snake_case = !snake_case;
    pascal_case = 0;
    camel_case = 0;
    return 0;
  }
  else if((shift & CTL) && (shift & SHIFT) && data == 0x20){
    snake_case = 0;
    pascal_case = 0;
    camel_case = 0;
    encryption_mode = 0;
    up_key_used = 0;
    devil_mode = !devil_mode;
    A_mode = !A_mode;
    return 2000;
  }
  else if((shift & CTL) && data == 0x12){
    camel_case = 0;
    pascal_case = 0;
    snake_case = 0;
    encryption_mode = !encryption_mode;
  }
  else if((shift & CTL) && (shift & SHIFT) && (shift & ALT) && data == 0x39) {
    pascal_case = 0;
    camel_case = 0;
    snake_case = 0;
    devil_mode = 0;
    A_mode = 0;
    sk_enabled = 0;
    is_dvorak = 0;
    up_key_used = 0;
    new_line_pressed = 0;
    encryption_mode = 0;
    return '\n';
  }
  // Check for Ctrl+S (Sticky Keys toggle)
  else if (data == 0x1F && (shift & CTL)) {
        sk_enabled = !sk_enabled;
        if (sk_enabled) {
           return 2500;
            sk_time = ticks;
        } else {
            return 2501;
        }
        return 0;
    }

    // Check for Ctrl+D (Dvorak Mode toggle)
  else if ((shift & CTL) && (data == 0x20)) {  // 0x20 is scancode for 'D'
        is_dvorak = !is_dvorak;
        return is_dvorak? 2502 : 2503;
    }

    // Sticky Keys timeout check
  else if (sk_enabled && (ticks - sk_time >= SK_tq)) {
        sk_enabled = 0;
    }

    // Sticky Keys double-SHIFT detection
  else if (sk_enabled && (data == 0x2A || data == 0x36)) {
        uint current_ticks = ticks;
        if (last_shift_press != 0 && current_ticks - last_shift_press < DOUBLE_PRESS) {
            capsActive = !capsActive;  // Toggle caps lock
        }
        last_shift_press = current_ticks;
    }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];

  if(devil_mode) {
    c = normalmap[data];
    // Handle Anomaly Mode key swaps
    if (A_mode) {
        if (data == 0x39) {         // Space to Tab
            c = '\t';
            return c;
        }
        else if (data == 0x0F) {    // Tab to Space
            c = ' ';
            return c;
        }
        else if (data == 0x0E) {    // Backspace to Enter
            c = '\n';
            return c;
        }
        else if (data == 0x1C) {    // Enter to Backspace
            c = '\b';
            return c;
        }
    }
    if ((shift & CTL)&& ('a' <= c && c <= 'z')) c = c+=2128;
        // Apply Anomaly Mode case reversal (after all other case modifications)
    else if (A_mode) {
        if ('a' <= c && c <= 'z')
            c += 'A' - 'a';
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }

    return c;
  }

  else if(encryption_mode){
     return c + 1000;
  }

  else if(pascal_case) {

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
  if (c == '\n') {
    new_line_pressed = 1;
    up_key_used = 0;
  }
  else new_line_pressed = 0;
  if (is_dvorak && c >= 0x20 && c < 0x7F) {
        unsigned char mapped = qwerty_to_dvorak_char[c];
        if (mapped != 0) {
            c = mapped;
        }
    }

    // Handle regular CAPSLOCK
    if (!sk_enabled && (shift & CAPSLOCK)) {
        if ('a' <= c && c <= 'z')
            c += 'A' - 'a';
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }

    // Handle Sticky Keys CAPSLOCK
    if (capsActive && sk_enabled) {
        if ('a' <= c && c <= 'z')
            c += 'A' - 'a';
    }
  return c;
}

void
kbdintr(void)
{
  consoleintr(kbdgetc);
}
