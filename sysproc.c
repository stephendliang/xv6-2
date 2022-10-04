#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "user.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int 
sys_procdump(void)
{
  procdump();
  return 0;
}



int sys_kthread_create(void)
{

  char* func;
  char* stack;
  int stack_size;

  if(argstr(0, &func) < 0 || argstr(1, &stack) < 0 || argint(2, &stack_size) < 0){
    return -1;
  }

  return kthread_create(func, stack, stack_size);
}

int sys_kthread_id(void)
{
  return kthread_id();
}

int sys_kthread_exit(void)
{
  return kthread_exit();
}

int sys_kthread_join(void)
{
  uint id;

  if(argint(0, &id) < 0){
    return -1;
  }

  return kthread_join(id);
}

int sys_kthread_mutex_alloc(void)
{
  return kthread_mutex_alloc();
}

int sys_kthread_mutex_dealloc(void)
{
  uint id;

  if(argint(0, &id) < 0){
    return -1;
  }

  return kthread_mutex_dealloc(id);
}

int sys_kthread_mutex_lock(void)
{
  uint id;

  if(argint(0, &id) < 0){
    return -1;
  }

  return kthread_mutex_lock(id);
}

int sys_kthread_mutex_unlock(void)
{
  uint id;

  if(argint(0, &id) < 0){
    return -1;
  }

  return kthread_mutex_unlock(id);
}

