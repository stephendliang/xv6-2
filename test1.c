/*Fork()
 If (pid > 0) {
   Do I/O instensive job
   wait();
   getpinfo(getpid());
 }
 Else {
  Do CPU intensive job
  exit()
 }
*/

#include "types.h"
#include "date.h"
#include "user.h"

int main() {
    int pid = fork();
    if (pid > 0) {
        nice(0);
        sleep(1);
        getpri();
      wait();
    } else {
      nice(2);
        sleep(1);
        getpri();
    }
    exit();
}

