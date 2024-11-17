#include "types.h"
#include "x86.h"
#include "defs.h"
#include "kbd.h"
#include "console.h"

static int is_dvorak = 0;  // 0 for QWERTY keyboard, 1 for Dvorak keyboard

static unsigned char qwerty_to_dvorak_char[128] = {
    // Number row (without shift)
    ['1'] = '1',
    ['2'] = '2',
    ['3'] = '3',
    ['4'] = '4',
    ['5'] = '5',
    ['6'] = '6',
    ['7'] = '7',
    ['8'] = '8',
    ['9'] = '9',
    ['0'] = '0',
    ['-'] = '[',
    ['='] = ']',

    // Number row (with shift)
    ['!'] = '!',
    ['@'] = '@',
    ['#'] = '#',
    ['$'] = '$',
    ['%'] = '%',
    ['^'] = '^',
    ['&'] = '&',
    ['*'] = '*',
    ['('] = '(',
    [')'] = ')',
    ['_'] = '{',
    ['+'] = '}',

    // Symbols
    ['['] = '/',
    [']'] = '=',
    ['\\'] = '\\',
    [';'] = 's',
    ['\''] = '-',
    [','] = 'w',
    ['.'] = 'v',
    ['/'] = 'z',
    ['<'] = 'W',
    ['>'] = 'V',
    ['?'] = 'Z',
    [':'] = 'S',
    ['"'] = '_',
    ['{'] = '?',
    ['}'] = '+',
    ['|'] = '|',

    // Letter mappings (lowercase)
    ['q'] = '\'',
    ['w'] = ',',
    ['e'] = '.',
    ['r'] = 'p',
    ['t'] = 'y',
    ['y'] = 'f',
    ['u'] = 'g',
    ['i'] = 'c',
    ['o'] = 'r',
    ['p'] = 'l',
    
    ['a'] = 'a',
    ['s'] = 'o',
    ['d'] = 'e',
    ['f'] = 'u',
    ['g'] = 'i',
    ['h'] = 'd',
    ['j'] = 'h',
    ['k'] = 't',
    ['l'] = 'n',
    
    ['z'] = ';',
    ['x'] = 'q',
    ['c'] = 'j',
    ['v'] = 'k',
    ['b'] = 'x',
    ['n'] = 'b',
    ['m'] = 'm',

    // Letter mappings (uppercase)
    ['Q'] = '"',
    ['W'] = '<',
    ['E'] = '>',
    ['R'] = 'P',
    ['T'] = 'Y',
    ['Y'] = 'F',
    ['U'] = 'G',
    ['I'] = 'C',
    ['O'] = 'R',
    ['P'] = 'L',
    
    ['A'] = 'A',
    ['S'] = 'O',
    ['D'] = 'E',
    ['F'] = 'U',
    ['G'] = 'I',
    ['H'] = 'D',
    ['J'] = 'H',
    ['K'] = 'T',
    ['L'] = 'N',
    
    ['Z'] = ':',
    ['X'] = 'Q',
    ['C'] = 'J',
    ['V'] = 'K',
    ['B'] = 'X',
    ['N'] = 'B',
    ['M'] = 'M'
};

void print_str(char *str) {
    while(*str) {
        consputc(*str++);
    }
}

int kbdgetc(void) {
    static uint shift;
    static uchar *charcode[4] = {normalmap, shiftmap, ctlmap, ctlmap};
    uint st, data, c;

    st = inb(KBSTATP);
    if ((st & KBS_DIB) == 0)
        return -1;
    data = inb(KBDATAP);

    // Handle extended keys
    if (data == 0xE0) {
        shift |= E0ESC;
        return 0;
    } else if (data & 0x80) {
        data = (shift & E0ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    } else if (shift & E0ESC) {
        data |= 0x80;
        shift &= ~E0ESC;
    }

    shift |= shiftcode[data];
    shift ^= togglecode[data];

    // getting ASCII character
    c = charcode[shift & (CTL | SHIFT)][data];

    if (is_dvorak && c >= 0x20 && c < 0x7F) {
        unsigned char mapped = qwerty_to_dvorak_char[c];
        if (mapped != 0) {  // Only use mapping if it exists
            c = mapped;
        }
    }

    // handling CAPSLOCK
    if (shift & CAPSLOCK) {
        if ('a' <= c && c <= 'z')
            c += 'A' - 'a';
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }

    return c;
}

void kbdintr(void) {
    int c = kbdgetc();
    if (c != -1) {
        if ((c & 0xff) == 4) {  // Ctrl+D
            consputc('\n');
            print_str("Keyboard layout switched to ");
            is_dvorak = !is_dvorak;
            if (is_dvorak) {
                print_str("Dvorak");
            } else {
                print_str("QWERTY");
            }
            consputc('\n');
        } else {
            consputc(c);
        }
    }
}
