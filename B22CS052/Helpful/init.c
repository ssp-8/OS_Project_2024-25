// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char *argv[] = { "sh", 0 };

int
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    printf(1, "------- Welcome to Helpful Keyboard -------\nHere are the new features that we are allowing you to relish!!\n");
    printf(1, "Press CTRL + E to Enter and Exit into Enigma Mode\n");
    printf(1, "Press CTRL + C to Copy last 128 characters\n");
    printf(1, "Press CTRL + V to paste the copied characters\n");
    printf(1, "Press CTRL + S to activate sticky keys\n");
    printf(1, "Press CTRL + D to change keyboard layout\n");
    printf(1, "Press Up Arrow to get previous line\n");
    printf(1, "Press CTRL + SHIFT + P to Enter Pascal Case Mode {Hello World For Example}\n");
    printf(1, "Press CTRL + SHIFT + C to Enter Camel Case Mode {hello World For Example}\n");
    printf(1, "Press CTRL + SHIFT + S to Enter Snale Case Mode {hello_world_for_example}\n");
    printf(1, "Press CTRL + SHIFT + D to Enter Devil Mode (Warning !!!)\n");
    printf(1, "Press CTRL + SHIFT + H to open this guide again\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
