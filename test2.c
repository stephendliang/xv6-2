#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main() {
    //In parent
    if (fork() > 0) {
      for (int i = 0; i < 3; ++i) {
        fork();

      }
      for (int i = 0; i<100000;++i)printf(2,"");
      for (int i = 0; i < 4;++i)wait();

      getpinfo(getpid());
      exit();
    } else {
      //Do CPU or I/O intensive job in each task
      for (int i = 0; i<100000;++i)printf(2,"");
      getpinfo(getpid());
    exit();
  }

}