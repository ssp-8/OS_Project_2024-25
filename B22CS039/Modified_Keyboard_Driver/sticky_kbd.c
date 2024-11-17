#include "types.h"
#include "x86.h"
#include "defs.h"
#include "kbd.h"


#define DOUBLE_PRESS 100  // 2 seconds 
#define SK_tq 500  // 10 seconds 

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
    static uint last_shift_press = 0;  
    static int capsActive = 0;   
    static int sk_enabled = 0;  // to track if sticky keys are enabled
    static uint sk_time = 0;    // time when sticky keys are activated
    uint st, data, c;

    st = inb(KBSTATP);
    if ((st & KBS_DIB) == 0)
        return -1;

    data = inb(KBDATAP);

    if (data == 0xE0) {
        shift |= E0ESC;
        return 0;
    } else if (data & 0x80) {
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    } else if (shift & E0ESC) {
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
        shift &= ~E0ESC;
    }


    // to check if Ctrl+S is pressed for sticky keys
    if (data == 0x1F && (shift & (CTL))) {
        sk_enabled = !sk_enabled;
          
        print_str("\nSticky Keys ");
        if (sk_enabled) {
            print_str("Enabled\n");
            sk_time = ticks;
        } 
        else {
            print_str("Disabled\n");
        }
        
    }


    // if sticky keys were ON and time is more than 10 sec, we'll release them now automatically
    if (sk_enabled && (ticks - sk_time >= SK_tq)) {
        sk_enabled = 0;
        print_str("\nSticky Keys Disabled (Timeout)\n");
    }


    // checking if SHIFT (left: 0x2A or right: 0x36) is pressed
    if ( sk_enabled && (data == 0x2A || data == 0x36)) {  
        uint current_ticks = ticks;  


        if (last_shift_press != 0 && current_ticks - last_shift_press < DOUBLE_PRESS) { // SHIFT pressed twice within 2 sec
            capsActive = 1;
            print_str("Caps Lock Activated\n");
        }

        last_shift_press = current_ticks;
    }

    shift |= shiftcode[data];
    shift ^= togglecode[data];

    c = charcode[shift & (CTL | SHIFT)][data];

    if (capsActive && sk_enabled) {
        if ('a' <= c && c <= 'z') {
            c -= 'a' - 'A';  // Convert to uppercase 
        }
    }
    else{ // nornal functionality
      if(shift & CAPSLOCK){
        if('a' <= c && c <= 'z')
          c += 'A' - 'a';
        else if('A' <= c && c <= 'Z')
          c += 'a' - 'A';
      }
    }

    return c;
}

void
kbdintr(void)
{
    consoleintr(kbdgetc);
}
