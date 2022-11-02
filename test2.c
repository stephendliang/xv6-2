/*

 fork()
 In parent:
   Fork multiple times — Like 10 times
   Do CPU or I/O intensive job
   getpinfo()
 In child:
   Do CPU or I/O intensive job in each task
   getpinfo()
*/