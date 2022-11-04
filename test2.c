#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void compute_intense()
{
  int j = 0;
  for (int I = 0; I < 200000; ++I)
    j += (I % 69) * 7 / 42;
  j %= ((1 << 16) + 1);
  for (int I = 0; I < 200000; ++I)
    j += (I % 9381) * 3 / 17;
  j %= ((1 << 16) + 1);
  for (int I = 0; I < 200000; ++I)
    j += (I % 197) * 7 / 29;
  j %= ((1 << 16) + 1);
}

void io_intense()
{
  for (int I = 0; I < 200000; ++I)
    printf(1,"abcdefghijklmnop %i,\n", I);
}

int main() {
    //In parent
    if (fork() > 0) {
      for (int i = 0; i < 3; ++i) {
        fork();

      }
      for (int i = 0; i<10000000;++i)printf(2,"");
      for (int i = 0; i < 4;++i)wait();

      getpinfo(getpid());
      exit();
    } else {
      //Do CPU or I/O intensive job in each task
      for (int i = 0; i<10000000;++i)printf(2,"");
      getpinfo(getpid());
    exit();
  }

}