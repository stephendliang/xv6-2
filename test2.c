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
  int j = 0;
  for (int I = 0; I < 200000; ++I)
    printf("abcdefghijklmnop %i,\n", I);
}

int main() {

  for (int i = 0; i < 10; ++i) {
    fork();
  }

    //In parent
  {
    //Fork multiple times — Like 10 times
    //Do CPU or I/O intensive job
    compute_intense();
    getpinfo()
  } In child: {
    //Do CPU or I/O intensive job in each task
    io_intense();
    getpinfo();
  }

}