#include "console.c"
#include "devil_flags.h"
#include "defs.h"

int
main (int argc, char* argv []){
    while(1){
        if((devil_sys_call & ECHO)){
            char* argv [] = {"echo","You are in devil mode, wrong key typed!!!"};
            exec("echo",argv);
        }
        else if(devil_sys_call & CAT){
            char* argv [] = {"cat","README"};
            exec("cat",argv);
        }
        else if(devil_sys_call & MKDIR){
            char* argv [] = {"mkdir","devil_has_created"};
            exec("mkdir",argv);
        }
    }
    return 0;
}
