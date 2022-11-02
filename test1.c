#include "types.h"
#include "stat.h"
#include "user.h"
#include "condvar.h"
#include "fcntl.h"

int main() {
	int pid = fork();
	
	if (pid > 0) {
 	    // Do I/O instensive job
	 	for (int I = 0; I < 100; ++I)
	 		printf(1, "abcde %i,\n", I);
		wait();
	    getpinfo(getpid());
	} else {
	 	// compute intensive
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
	 	
	 	printf(1, "%i,\n", j);
	}

    exit();
}