
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 77 10 80       	push   $0x801077a0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 e5 49 00 00       	call   80104a40 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 77 10 80       	push   $0x801077a7
80100097:	50                   	push   %eax
80100098:	e8 73 48 00 00       	call   80104910 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 97 4a 00 00       	call   80104b80 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 d9 4a 00 00       	call   80104c40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 47 00 00       	call   80104950 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 77 10 80       	push   $0x801077ae
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 3d 48 00 00       	call   801049f0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 77 10 80       	push   $0x801077bf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 fc 47 00 00       	call   801049f0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 47 00 00       	call   801049b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 70 49 00 00       	call   80104b80 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 df 49 00 00       	jmp    80104c40 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 77 10 80       	push   $0x801077c6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 ef 48 00 00       	call   80104b80 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 c6 41 00 00       	call   80104490 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 b0 37 00 00       	call   80103a90 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 4c 49 00 00       	call   80104c40 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 ee 48 00 00       	call   80104c40 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 77 10 80       	push   $0x801077cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 9b 81 10 80 	movl   $0x8010819b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 83 46 00 00       	call   80104a60 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 77 10 80       	push   $0x801077e1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 71 5f 00 00       	call   801063b0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 bf 5e 00 00       	call   801063b0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 b3 5e 00 00       	call   801063b0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 a7 5e 00 00       	call   801063b0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 17 48 00 00       	call   80104d40 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 4a 47 00 00       	call   80104c90 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 77 10 80       	push   $0x801077e5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 10 78 10 80 	movzbl -0x7fef87f0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 60 45 00 00       	call   80104b80 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 f4 45 00 00       	call   80104c40 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 1c 45 00 00       	call   80104c40 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba f8 77 10 80       	mov    $0x801077f8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 8b 43 00 00       	call   80104b80 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 77 10 80       	push   $0x801077ff
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 58 43 00 00       	call   80104b80 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100856:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 b3 43 00 00       	call   80104c40 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100911:	68 c0 0f 11 80       	push   $0x80110fc0
80100916:	e8 35 3d 00 00       	call   80104650 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010093d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100964:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 94 3d 00 00       	jmp    80104730 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 08 78 10 80       	push   $0x80107808
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 6b 40 00 00       	call   80104a40 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 6f 30 00 00       	call   80103a90 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 67 6a 00 00       	call   80107500 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 25 68 00 00       	call   80107320 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 33 67 00 00       	call   80107260 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 09 69 00 00       	call   80107480 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 71 67 00 00       	call   80107320 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ba 68 00 00       	call   80107480 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 78 10 80       	push   $0x80107821
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 95 69 00 00       	call   801075a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 72 42 00 00       	call   80104eb0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 5f 42 00 00       	call   80104eb0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 9e 6a 00 00       	call   80107700 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 34 6a 00 00       	call   80107700 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 61 41 00 00       	call   80104e70 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 97 63 00 00       	call   801070d0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 3f 67 00 00       	call   80107480 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 2d 78 10 80       	push   $0x8010782d
80100d6b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d70:	e8 cb 3c 00 00       	call   80104a40 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 0f 11 80       	push   $0x80110fe0
80100d91:	e8 ea 3d 00 00       	call   80104b80 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 0f 11 80       	push   $0x80110fe0
80100dc1:	e8 7a 3e 00 00       	call   80104c40 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 0f 11 80       	push   $0x80110fe0
80100dda:	e8 61 3e 00 00       	call   80104c40 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 0f 11 80       	push   $0x80110fe0
80100dff:	e8 7c 3d 00 00       	call   80104b80 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 0f 11 80       	push   $0x80110fe0
80100e1c:	e8 1f 3e 00 00       	call   80104c40 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 34 78 10 80       	push   $0x80107834
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e51:	e8 2a 3d 00 00       	call   80104b80 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 bf 3d 00 00       	jmp    80104c40 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 93 3d 00 00       	call   80104c40 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 3c 78 10 80       	push   $0x8010783c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 46 78 10 80       	push   $0x80107846
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 4f 78 10 80       	push   $0x8010784f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 55 78 10 80       	push   $0x80107855
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 5f 78 10 80       	push   $0x8010785f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 f8 19 11 80    	add    0x801119f8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 e0 19 11 80       	mov    0x801119e0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 72 78 10 80       	push   $0x80107872
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 26 3a 00 00       	call   80104c90 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 00 1a 11 80       	push   $0x80111a00
801012aa:	e8 d1 38 00 00       	call   80104b80 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 00 1a 11 80       	push   $0x80111a00
8010130f:	e8 2c 39 00 00       	call   80104c40 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 fe 38 00 00       	call   80104c40 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 88 78 10 80       	push   $0x80107888
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 98 78 10 80       	push   $0x80107898
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 da 38 00 00       	call   80104d40 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 ab 78 10 80       	push   $0x801078ab
80101491:	68 00 1a 11 80       	push   $0x80111a00
80101496:	e8 a5 35 00 00       	call   80104a40 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 b2 78 10 80       	push   $0x801078b2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 5c 34 00 00       	call   80104910 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 e0 19 11 80       	push   $0x801119e0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 f8 19 11 80    	pushl  0x801119f8
801014d5:	ff 35 f4 19 11 80    	pushl  0x801119f4
801014db:	ff 35 f0 19 11 80    	pushl  0x801119f0
801014e1:	ff 35 ec 19 11 80    	pushl  0x801119ec
801014e7:	ff 35 e8 19 11 80    	pushl  0x801119e8
801014ed:	ff 35 e4 19 11 80    	pushl  0x801119e4
801014f3:	ff 35 e0 19 11 80    	pushl  0x801119e0
801014f9:	68 18 79 10 80       	push   $0x80107918
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 fd 36 00 00       	call   80104c90 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 b8 78 10 80       	push   $0x801078b8
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 0a 37 00 00       	call   80104d40 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 00 1a 11 80       	push   $0x80111a00
8010165f:	e8 1c 35 00 00       	call   80104b80 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010166f:	e8 cc 35 00 00       	call   80104c40 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 a9 32 00 00       	call   80104950 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 23 36 00 00       	call   80104d40 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 d0 78 10 80       	push   $0x801078d0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ca 78 10 80       	push   $0x801078ca
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 78 32 00 00       	call   801049f0 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 1c 32 00 00       	jmp    801049b0 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 df 78 10 80       	push   $0x801078df
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 8b 31 00 00       	call   80104950 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 d1 31 00 00       	call   801049b0 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017e6:	e8 95 33 00 00       	call   80104b80 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 3b 34 00 00       	jmp    80104c40 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 00 1a 11 80       	push   $0x80111a00
80101810:	e8 6b 33 00 00       	call   80104b80 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010181f:	e8 1c 34 00 00       	call   80104c40 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 34 33 00 00       	call   80104d40 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 38 32 00 00       	call   80104d40 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 0d 32 00 00       	call   80104db0 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 ae 31 00 00       	call   80104db0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 f9 78 10 80       	push   $0x801078f9
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 e7 78 10 80       	push   $0x801078e7
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 12 1e 00 00       	call   80103a90 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 00 1a 11 80       	push   $0x80111a00
80101c89:	e8 f2 2e 00 00       	call   80104b80 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c99:	e8 a2 2f 00 00       	call   80104c40 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 46 30 00 00       	call   80104d40 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 b3 2f 00 00       	call   80104d40 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 8e 2f 00 00       	call   80104e10 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 08 79 10 80       	push   $0x80107908
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 82 7f 10 80       	push   $0x80107f82
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 74 79 10 80       	push   $0x80107974
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 6b 79 10 80       	push   $0x8010796b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 86 79 10 80       	push   $0x80107986
8010200b:	68 80 b5 10 80       	push   $0x8010b580
80102010:	e8 2b 2a 00 00       	call   80104a40 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 80 b5 10 80       	push   $0x8010b580
8010208e:	e8 ed 2a 00 00       	call   80104b80 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 5a 25 00 00       	call   80104650 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 b5 10 80       	push   $0x8010b580
8010210f:	e8 2c 2b 00 00       	call   80104c40 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 bd 28 00 00       	call   801049f0 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 b5 10 80       	push   $0x8010b580
80102168:	e8 13 2a 00 00       	call   80104b80 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 b5 10 80       	push   $0x8010b580
801021b8:	53                   	push   %ebx
801021b9:	e8 d2 22 00 00       	call   80104490 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 65 2a 00 00       	jmp    80104c40 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 a0 79 10 80       	push   $0x801079a0
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 8a 79 10 80       	push   $0x8010798a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 b5 79 10 80       	push   $0x801079b5
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 54 36 11 80       	mov    0x80113654,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 d4 79 10 80       	push   $0x801079d4
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb c8 e1 28 80    	cmp    $0x8028e1c8,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 49 29 00 00       	call   80104c90 <memset>

  if(kmem.use_lock)
80102347:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 98 36 11 80       	mov    0x80113698,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
80102360:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 c0 28 00 00       	jmp    80104c40 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 60 36 11 80       	push   $0x80113660
80102388:	e8 f3 27 00 00       	call   80104b80 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 06 7a 10 80       	push   $0x80107a06
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 0c 7a 10 80       	push   $0x80107a0c
80102400:	68 60 36 11 80       	push   $0x80113660
80102405:	e8 36 26 00 00       	call   80104a40 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 94 36 11 80       	mov    0x80113694,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 98 36 11 80    	mov    %edx,0x80113698
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 60 36 11 80       	push   $0x80113660
801024f3:	e8 88 26 00 00       	call   80104b80 <acquire>
  r = kmem.freelist;
801024f8:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 60 36 11 80       	push   $0x80113660
80102521:	e8 1a 27 00 00       	call   80104c40 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 40 7b 10 80 	movzbl -0x7fef84c0(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 40 7a 10 80 	movzbl -0x7fef85c0(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 20 7a 10 80 	mov    -0x7fef85e0(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 40 7b 10 80 	movzbl -0x7fef84c0(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 a4 23 00 00       	call   80104ce0 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102a44:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 d7 22 00 00       	call   80104d40 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102aae:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 40 7c 10 80       	push   $0x80107c40
80102b0f:	68 a0 36 11 80       	push   $0x801136a0
80102b14:	e8 27 1f 00 00       	call   80104a40 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102b32:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102b38:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 a0 36 11 80       	push   $0x801136a0
80102bab:	e8 d0 1f 00 00       	call   80104b80 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 a0 36 11 80       	push   $0x801136a0
80102bc0:	68 a0 36 11 80       	push   $0x801136a0
80102bc5:	e8 c6 18 00 00       	call   80104490 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102bdb:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102bf7:	68 a0 36 11 80       	push   $0x801136a0
80102bfc:	e8 3f 20 00 00       	call   80104c40 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 a0 36 11 80       	push   $0x801136a0
80102c1e:	e8 5d 1f 00 00       	call   80104b80 <acquire>
  log.outstanding -= 1;
80102c23:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102c28:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 a0 36 11 80       	push   $0x801136a0
80102c5c:	e8 df 1f 00 00       	call   80104c40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102c96:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 85 20 00 00       	call   80104d40 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 a0 36 11 80       	push   $0x801136a0
80102cff:	e8 7c 1e 00 00       	call   80104b80 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102d0b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 36 19 00 00       	call   80104650 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d21:	e8 1a 1f 00 00       	call   80104c40 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 a0 36 11 80       	push   $0x801136a0
80102d40:	e8 0b 19 00 00       	call   80104650 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d4c:	e8 ef 1e 00 00       	call   80104c40 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 44 7c 10 80       	push   $0x80107c44
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 a0 36 11 80       	push   $0x801136a0
80102dae:	e8 cd 1d 00 00       	call   80104b80 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 3e 1e 00 00       	jmp    80104c40 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 53 7c 10 80       	push   $0x80107c53
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 69 7c 10 80       	push   $0x80107c69
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 24 0c 00 00       	call   80103a70 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 1d 0c 00 00       	call   80103a70 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 84 7c 10 80       	push   $0x80107c84
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 e9 30 00 00       	call   80105f50 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 84 0b 00 00       	call   801039f0 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 41 0f 00 00       	call   80103dc0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 25 42 00 00       	call   801070b0 <switchkvm>
  seginit();
80102e8b:	e8 90 41 00 00       	call   80107020 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 c8 e1 28 80       	push   $0x8028e1c8
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 ba 46 00 00       	call   80107580 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 4b 41 00 00       	call   80107020 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 07 34 00 00       	call   801062f0 <uartinit>
  pinit();         // process table
80102ee9:	e8 e2 0a 00 00       	call   801039d0 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 dd 2f 00 00       	call   80105ed0 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 8c b4 10 80       	push   $0x8010b48c
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 27 1e 00 00       	call   80104d40 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f2b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 ab 0a 00 00       	call   801039f0 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f64:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 06 0b 00 00       	call   80103ac0 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 98 7c 10 80       	push   $0x80107c98
80102ff3:	56                   	push   %esi
80102ff4:	e8 e7 1c 00 00       	call   80104ce0 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 b5 7c 10 80       	push   $0x80107cb5
801030b1:	56                   	push   %esi
801030b2:	e8 29 1c 00 00       	call   80104ce0 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 dc 7c 10 80 	jmp    *-0x7fef8324(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 9d 7c 10 80       	push   $0x80107c9d
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 bc 7c 10 80       	push   $0x80107cbc
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 f0 7c 10 80       	push   $0x80107cf0
80103300:	50                   	push   %eax
80103301:	e8 3a 17 00 00       	call   80104a40 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 1c 18 00 00       	call   80104b80 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 cc 12 00 00       	call   80104650 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 97 18 00 00       	jmp    80104c40 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 87 12 00 00       	call   80104650 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 67 18 00 00       	call   80104c40 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 7e 17 00 00       	call   80104b80 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 f7 11 00 00       	call   80104650 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 2e 10 00 00       	call   80104490 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 07 06 00 00       	call   80103a90 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 a7 17 00 00       	call   80104c40 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 68 11 00 00       	call   80104650 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 50 17 00 00       	call   80104c40 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 6b 16 00 00       	call   80104b80 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 46 0f 00 00       	call   80104490 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 22 05 00 00       	call   80103a90 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 bd 16 00 00       	call   80104c40 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 74 10 00 00       	call   80104650 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 5c 16 00 00       	call   80104c40 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
  struct proc *p;
  char *sp; int i;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103606:	bb 74 40 11 80       	mov    $0x80114074,%ebx
{
8010360b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
8010360e:	68 40 40 11 80       	push   $0x80114040
80103613:	e8 68 15 00 00       	call   80104b80 <acquire>
80103618:	83 c4 10             	add    $0x10,%esp
8010361b:	eb 15                	jmp    80103632 <allocproc+0x32>
8010361d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	81 c3 64 5e 00 00    	add    $0x5e64,%ebx
80103626:	81 fb 74 d9 28 80    	cmp    $0x8028d974,%ebx
8010362c:	0f 83 5e 02 00 00    	jae    80103890 <allocproc+0x290>
    if(p->state == UNUSED)
80103632:	8b 53 0c             	mov    0xc(%ebx),%edx
80103635:	85 d2                	test   %edx,%edx
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
  return 0;

found:

  //After found -> Remove from queue:
  if (p->pid >= 0) {
80103639:	8b 43 10             	mov    0x10(%ebx),%eax
8010363c:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80103642:	85 c0                	test   %eax,%eax
80103644:	0f 88 8a 00 00 00    	js     801036d4 <allocproc+0xd4>
    for (i=0;(i<c0); i++) {
8010364a:	85 d2                	test   %edx,%edx
8010364c:	7e 26                	jle    80103674 <allocproc+0x74>
8010364e:	31 c0                	xor    %eax,%eax
      if (p == q0[i]) {
80103650:	39 1d 40 3f 11 80    	cmp    %ebx,0x80113f40
80103656:	75 15                	jne    8010366d <allocproc+0x6d>
80103658:	e9 eb 01 00 00       	jmp    80103848 <allocproc+0x248>
8010365d:	8d 76 00             	lea    0x0(%esi),%esi
80103660:	39 1c 85 40 3f 11 80 	cmp    %ebx,-0x7feec0c0(,%eax,4)
80103667:	0f 84 db 01 00 00    	je     80103848 <allocproc+0x248>
    for (i=0;(i<c0); i++) {
8010366d:	83 c0 01             	add    $0x1,%eax
80103670:	39 d0                	cmp    %edx,%eax
80103672:	75 ec                	jne    80103660 <allocproc+0x60>
        q0[c0 - 1] = 0;
        --c0;
        break;
      }
    }
    for (i=0;(i<c1); i++) {
80103674:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
8010367a:	85 c9                	test   %ecx,%ecx
8010367c:	7e 26                	jle    801036a4 <allocproc+0xa4>
8010367e:	31 c0                	xor    %eax,%eax
      if (p == q1[i]) {
80103680:	39 1d 40 3e 11 80    	cmp    %ebx,0x80113e40
80103686:	75 15                	jne    8010369d <allocproc+0x9d>
80103688:	e9 6b 01 00 00       	jmp    801037f8 <allocproc+0x1f8>
8010368d:	8d 76 00             	lea    0x0(%esi),%esi
80103690:	39 1c 85 40 3e 11 80 	cmp    %ebx,-0x7feec1c0(,%eax,4)
80103697:	0f 84 5b 01 00 00    	je     801037f8 <allocproc+0x1f8>
    for (i=0;(i<c1); i++) {
8010369d:	83 c0 01             	add    $0x1,%eax
801036a0:	39 c1                	cmp    %eax,%ecx
801036a2:	75 ec                	jne    80103690 <allocproc+0x90>
        q1[c1 - 1] = 0;
        --c1;
        break;
      }
    }
    for (i=0;(i<c2); i++) {
801036a4:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
801036aa:	85 c9                	test   %ecx,%ecx
801036ac:	7e 26                	jle    801036d4 <allocproc+0xd4>
801036ae:	31 c0                	xor    %eax,%eax
      if (p == q2[i]) {
801036b0:	39 1d 40 3d 11 80    	cmp    %ebx,0x80113d40
801036b6:	75 15                	jne    801036cd <allocproc+0xcd>
801036b8:	e9 fb 00 00 00       	jmp    801037b8 <allocproc+0x1b8>
801036bd:	8d 76 00             	lea    0x0(%esi),%esi
801036c0:	39 1c 85 40 3d 11 80 	cmp    %ebx,-0x7feec2c0(,%eax,4)
801036c7:	0f 84 eb 00 00 00    	je     801037b8 <allocproc+0x1b8>
    for (i=0;(i<c2); i++) {
801036cd:	83 c0 01             	add    $0x1,%eax
801036d0:	39 c1                	cmp    %eax,%ecx
801036d2:	75 ec                	jne    801036c0 <allocproc+0xc0>
  }

//finshift:

  p->state = EMBRYO;
  p->pid = nextpid++;
801036d4:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->total_ticks = 0; //total number of timer ticks the process has run for
  p->num_stats_used = 0; // count to the end of the array



  q0[c0] = p;
801036d9:	89 1c 95 40 3f 11 80 	mov    %ebx,-0x7feec0c0(,%edx,4)
  ++c0;
801036e0:	83 c2 01             	add    $0x1,%edx
  p->state = EMBRYO;
801036e3:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->times[0] = 0; p->times[1] = 0; p->times[2] = 0; // number of times each process has been scheduled
801036ea:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
801036f1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801036f8:	00 00 00 
801036fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103702:	00 00 00 
  p->pid = nextpid++;
80103705:	8d 48 01             	lea    0x1(%eax),%ecx
80103708:	89 43 10             	mov    %eax,0x10(%ebx)
  p->ticks[0] = 0; p->ticks[1] = 0; p->ticks[2] = 0; // number of ticks each process used the last time
8010370b:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103712:	00 00 00 
80103715:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010371c:	00 00 00 
8010371f:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103726:	00 00 00 
  p->wait_time = 0; // number of ticks each RUNNABLE process waited in the lowest
80103729:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103730:	00 00 00 
  p->num_ticks = 0; //number of timer ticks the process has run for
80103733:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
8010373a:	00 00 00 
  p->total_ticks = 0; //total number of timer ticks the process has run for
8010373d:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80103744:	00 00 00 
  p->num_stats_used = 0; // count to the end of the array
80103747:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
8010374e:	00 00 00 
  p->pid = nextpid++;
80103751:	89 0d 04 b0 10 80    	mov    %ecx,0x8010b004
  ++c0;
80103757:	89 15 c0 b5 10 80    	mov    %edx,0x8010b5c0


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010375d:	e8 5e ed ff ff       	call   801024c0 <kalloc>
80103762:	85 c0                	test   %eax,%eax
80103764:	89 43 08             	mov    %eax,0x8(%ebx)
80103767:	0f 84 3f 01 00 00    	je     801038ac <allocproc+0x2ac>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010376d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103773:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103776:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010377b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010377e:	c7 40 14 bf 5e 10 80 	movl   $0x80105ebf,0x14(%eax)
  p->context = (struct context*)sp;
80103785:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103788:	6a 14                	push   $0x14
8010378a:	6a 00                	push   $0x0
8010378c:	50                   	push   %eax
8010378d:	e8 fe 14 00 00       	call   80104c90 <memset>
  p->context->eip = (uint)forkret;
80103792:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103795:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)

  release(&ptable.lock);
8010379c:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
801037a3:	e8 98 14 00 00       	call   80104c40 <release>
  return p;
801037a8:	83 c4 10             	add    $0x10,%esp
}
801037ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ae:	89 d8                	mov    %ebx,%eax
801037b0:	5b                   	pop    %ebx
801037b1:	5e                   	pop    %esi
801037b2:	5f                   	pop    %edi
801037b3:	5d                   	pop    %ebp
801037b4:	c3                   	ret    
801037b5:	8d 76 00             	lea    0x0(%esi),%esi
        copyover(q2, i, c2);
801037b8:	8d 71 ff             	lea    -0x1(%ecx),%esi
801037bb:	39 c6                	cmp    %eax,%esi
801037bd:	7e 1e                	jle    801037dd <allocproc+0x1dd>
801037bf:	8d 04 85 40 3d 11 80 	lea    -0x7feec2c0(,%eax,4),%eax
801037c6:	8d 3c 8d 3c 3d 11 80 	lea    -0x7feec2c4(,%ecx,4),%edi
801037cd:	8d 76 00             	lea    0x0(%esi),%esi
801037d0:	8b 48 04             	mov    0x4(%eax),%ecx
801037d3:	83 c0 04             	add    $0x4,%eax
801037d6:	89 48 fc             	mov    %ecx,-0x4(%eax)
801037d9:	39 f8                	cmp    %edi,%eax
801037db:	75 f3                	jne    801037d0 <allocproc+0x1d0>
        q2[c2 - 1] = 0;
801037dd:	c7 04 b5 40 3d 11 80 	movl   $0x0,-0x7feec2c0(,%esi,4)
801037e4:	00 00 00 00 
        --c2;
801037e8:	89 35 b8 b5 10 80    	mov    %esi,0x8010b5b8
        break;
801037ee:	e9 e1 fe ff ff       	jmp    801036d4 <allocproc+0xd4>
801037f3:	90                   	nop
801037f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        copyover(q1, i, c1);
801037f8:	8d 71 ff             	lea    -0x1(%ecx),%esi
801037fb:	39 c6                	cmp    %eax,%esi
801037fd:	7e 1e                	jle    8010381d <allocproc+0x21d>
801037ff:	8d 04 85 40 3e 11 80 	lea    -0x7feec1c0(,%eax,4),%eax
80103806:	8d 3c 8d 3c 3e 11 80 	lea    -0x7feec1c4(,%ecx,4),%edi
8010380d:	8d 76 00             	lea    0x0(%esi),%esi
80103810:	8b 48 04             	mov    0x4(%eax),%ecx
80103813:	83 c0 04             	add    $0x4,%eax
80103816:	89 48 fc             	mov    %ecx,-0x4(%eax)
80103819:	39 f8                	cmp    %edi,%eax
8010381b:	75 f3                	jne    80103810 <allocproc+0x210>
    for (i=0;(i<c2); i++) {
8010381d:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
        q1[c1 - 1] = 0;
80103823:	c7 04 b5 40 3e 11 80 	movl   $0x0,-0x7feec1c0(,%esi,4)
8010382a:	00 00 00 00 
        --c1;
8010382e:	89 35 bc b5 10 80    	mov    %esi,0x8010b5bc
    for (i=0;(i<c2); i++) {
80103834:	85 c9                	test   %ecx,%ecx
80103836:	0f 8f 72 fe ff ff    	jg     801036ae <allocproc+0xae>
8010383c:	e9 93 fe ff ff       	jmp    801036d4 <allocproc+0xd4>
80103841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        copyover(q0, i, c0);
80103848:	8d 4a ff             	lea    -0x1(%edx),%ecx
8010384b:	39 c8                	cmp    %ecx,%eax
8010384d:	7d 1e                	jge    8010386d <allocproc+0x26d>
8010384f:	8d 04 85 40 3f 11 80 	lea    -0x7feec0c0(,%eax,4),%eax
80103856:	8d 34 95 3c 3f 11 80 	lea    -0x7feec0c4(,%edx,4),%esi
8010385d:	8d 76 00             	lea    0x0(%esi),%esi
80103860:	8b 50 04             	mov    0x4(%eax),%edx
80103863:	83 c0 04             	add    $0x4,%eax
80103866:	89 50 fc             	mov    %edx,-0x4(%eax)
80103869:	39 f0                	cmp    %esi,%eax
8010386b:	75 f3                	jne    80103860 <allocproc+0x260>
        q0[c0 - 1] = 0;
8010386d:	c7 04 8d 40 3f 11 80 	movl   $0x0,-0x7feec0c0(,%ecx,4)
80103874:	00 00 00 00 
        copyover(q0, i, c0);
80103878:	89 ca                	mov    %ecx,%edx
    for (i=0;(i<c1); i++) {
8010387a:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
80103880:	85 c9                	test   %ecx,%ecx
80103882:	0f 8f f6 fd ff ff    	jg     8010367e <allocproc+0x7e>
80103888:	e9 17 fe ff ff       	jmp    801036a4 <allocproc+0xa4>
8010388d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103893:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103895:	68 40 40 11 80       	push   $0x80114040
8010389a:	e8 a1 13 00 00       	call   80104c40 <release>
  return 0;
8010389f:	83 c4 10             	add    $0x10,%esp
}
801038a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a5:	89 d8                	mov    %ebx,%eax
801038a7:	5b                   	pop    %ebx
801038a8:	5e                   	pop    %esi
801038a9:	5f                   	pop    %edi
801038aa:	5d                   	pop    %ebp
801038ab:	c3                   	ret    
    p->state = UNUSED;
801038ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038b3:	31 db                	xor    %ebx,%ebx
801038b5:	e9 f1 fe ff ff       	jmp    801037ab <allocproc+0x1ab>
801038ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038c6:	68 40 40 11 80       	push   $0x80114040
801038cb:	e8 70 13 00 00       	call   80104c40 <release>

  if (first) {
801038d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	85 c0                	test   %eax,%eax
801038da:	75 04                	jne    801038e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038dc:	c9                   	leave  
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801038e0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801038e3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038ea:	00 00 00 
    iinit(ROOTDEV);
801038ed:	6a 01                	push   $0x1
801038ef:	e8 8c db ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038fb:	e8 00 f2 ff ff       	call   80102b00 <initlog>
80103900:	83 c4 10             	add    $0x10,%esp
}
80103903:	c9                   	leave  
80103904:	c3                   	ret    
80103905:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103910 <boost.part.1>:
void boost(int durations)
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	57                   	push   %edi
80103914:	56                   	push   %esi
80103915:	53                   	push   %ebx
80103916:	83 ec 04             	sub    $0x4,%esp
    for (int i = 0; i < c2; ++i) {
80103919:	8b 1d b8 b5 10 80    	mov    0x8010b5b8,%ebx
8010391f:	85 db                	test   %ebx,%ebx
80103921:	0f 8e 88 00 00 00    	jle    801039af <boost.part.1+0x9f>
80103927:	8b 35 c0 b5 10 80    	mov    0x8010b5c0,%esi
8010392d:	31 ff                	xor    %edi,%edi
8010392f:	31 c9                	xor    %ecx,%ecx
80103931:	eb 0c                	jmp    8010393f <boost.part.1+0x2f>
80103933:	90                   	nop
80103934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103938:	83 c1 01             	add    $0x1,%ecx
8010393b:	39 cb                	cmp    %ecx,%ebx
8010393d:	7e 6a                	jle    801039a9 <boost.part.1+0x99>
      q2[i]->wait_time += durations;
8010393f:	8b 14 8d 40 3d 11 80 	mov    -0x7feec2c0(,%ecx,4),%edx
80103946:	01 82 94 00 00 00    	add    %eax,0x94(%edx)
      if (q2[i]->wait_time >= 50) {
8010394c:	8b 14 8d 40 3d 11 80 	mov    -0x7feec2c0(,%ecx,4),%edx
80103953:	83 ba 94 00 00 00 31 	cmpl   $0x31,0x94(%edx)
8010395a:	76 dc                	jbe    80103938 <boost.part.1+0x28>
        --c2;
8010395c:	8d 7b ff             	lea    -0x1(%ebx),%edi
        q0[c0] = p;
8010395f:	8b 14 bd 40 3d 11 80 	mov    -0x7feec2c0(,%edi,4),%edx
80103966:	89 14 b5 40 3f 11 80 	mov    %edx,-0x7feec0c0(,%esi,4)
        copyover(q2, j, c2);
8010396d:	8d 53 fe             	lea    -0x2(%ebx),%edx
80103970:	39 ca                	cmp    %ecx,%edx
80103972:	7e 24                	jle    80103998 <boost.part.1+0x88>
80103974:	8d 14 8d 40 3d 11 80 	lea    -0x7feec2c0(,%ecx,4),%edx
8010397b:	8d 1c 9d 38 3d 11 80 	lea    -0x7feec2c8(,%ebx,4),%ebx
80103982:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103985:	8d 76 00             	lea    0x0(%esi),%esi
80103988:	8b 42 04             	mov    0x4(%edx),%eax
8010398b:	83 c2 04             	add    $0x4,%edx
8010398e:	89 42 fc             	mov    %eax,-0x4(%edx)
80103991:	39 da                	cmp    %ebx,%edx
80103993:	75 f3                	jne    80103988 <boost.part.1+0x78>
80103995:	8b 45 f0             	mov    -0x10(%ebp),%eax
        --c2;
80103998:	89 fb                	mov    %edi,%ebx
    for (int i = 0; i < c2; ++i) {
8010399a:	83 c1 01             	add    $0x1,%ecx
        ++c0;
8010399d:	83 c6 01             	add    $0x1,%esi
    for (int i = 0; i < c2; ++i) {
801039a0:	39 cb                	cmp    %ecx,%ebx
        ++c0;
801039a2:	bf 01 00 00 00       	mov    $0x1,%edi
    for (int i = 0; i < c2; ++i) {
801039a7:	7f 96                	jg     8010393f <boost.part.1+0x2f>
801039a9:	89 f8                	mov    %edi,%eax
801039ab:	84 c0                	test   %al,%al
801039ad:	75 08                	jne    801039b7 <boost.part.1+0xa7>
}
801039af:	83 c4 04             	add    $0x4,%esp
801039b2:	5b                   	pop    %ebx
801039b3:	5e                   	pop    %esi
801039b4:	5f                   	pop    %edi
801039b5:	5d                   	pop    %ebp
801039b6:	c3                   	ret    
801039b7:	89 1d b8 b5 10 80    	mov    %ebx,0x8010b5b8
801039bd:	89 35 c0 b5 10 80    	mov    %esi,0x8010b5c0
801039c3:	eb ea                	jmp    801039af <boost.part.1+0x9f>
801039c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039d0 <pinit>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039d6:	68 f5 7c 10 80       	push   $0x80107cf5
801039db:	68 40 40 11 80       	push   $0x80114040
801039e0:	e8 5b 10 00 00       	call   80104a40 <initlock>
}
801039e5:	83 c4 10             	add    $0x10,%esp
801039e8:	c9                   	leave  
801039e9:	c3                   	ret    
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039f0 <mycpu>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039f5:	9c                   	pushf  
801039f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039f7:	f6 c4 02             	test   $0x2,%ah
801039fa:	75 5e                	jne    80103a5a <mycpu+0x6a>
  apicid = lapicid();
801039fc:	e8 2f ed ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a01:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103a07:	85 f6                	test   %esi,%esi
80103a09:	7e 42                	jle    80103a4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a0b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103a12:	39 d0                	cmp    %edx,%eax
80103a14:	74 30                	je     80103a46 <mycpu+0x56>
80103a16:	b9 50 38 11 80       	mov    $0x80113850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103a1b:	31 d2                	xor    %edx,%edx
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi
80103a20:	83 c2 01             	add    $0x1,%edx
80103a23:	39 f2                	cmp    %esi,%edx
80103a25:	74 26                	je     80103a4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a27:	0f b6 19             	movzbl (%ecx),%ebx
80103a2a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103a30:	39 c3                	cmp    %eax,%ebx
80103a32:	75 ec                	jne    80103a20 <mycpu+0x30>
80103a34:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103a3a:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
80103a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a42:	5b                   	pop    %ebx
80103a43:	5e                   	pop    %esi
80103a44:	5d                   	pop    %ebp
80103a45:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a46:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
      return &cpus[i];
80103a4b:	eb f2                	jmp    80103a3f <mycpu+0x4f>
  panic("unknown apicid\n");
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	68 fc 7c 10 80       	push   $0x80107cfc
80103a55:	e8 36 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	68 28 7e 10 80       	push   $0x80107e28
80103a62:	e8 29 c9 ff ff       	call   80100390 <panic>
80103a67:	89 f6                	mov    %esi,%esi
80103a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a70 <cpuid>:
cpuid() {
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a76:	e8 75 ff ff ff       	call   801039f0 <mycpu>
80103a7b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103a80:	c9                   	leave  
  return mycpu()-cpus;
80103a81:	c1 f8 04             	sar    $0x4,%eax
80103a84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a8a:	c3                   	ret    
80103a8b:	90                   	nop
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a90 <myproc>:
myproc(void) {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a97:	e8 14 10 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103a9c:	e8 4f ff ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103aa1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa7:	e8 44 10 00 00       	call   80104af0 <popcli>
}
80103aac:	83 c4 04             	add    $0x4,%esp
80103aaf:	89 d8                	mov    %ebx,%eax
80103ab1:	5b                   	pop    %ebx
80103ab2:	5d                   	pop    %ebp
80103ab3:	c3                   	ret    
80103ab4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ac0 <userinit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
80103ac4:	83 ec 08             	sub    $0x8,%esp
  memset(q0, 0, sizeof(struct proc) * NPROC);
80103ac7:	68 00 99 17 00       	push   $0x179900
80103acc:	6a 00                	push   $0x0
80103ace:	68 40 3f 11 80       	push   $0x80113f40
80103ad3:	e8 b8 11 00 00       	call   80104c90 <memset>
  memset(q1, 0, sizeof(struct proc) * NPROC);
80103ad8:	83 c4 0c             	add    $0xc,%esp
80103adb:	68 00 99 17 00       	push   $0x179900
80103ae0:	6a 00                	push   $0x0
80103ae2:	68 40 3e 11 80       	push   $0x80113e40
80103ae7:	e8 a4 11 00 00       	call   80104c90 <memset>
  memset(q2, 0, sizeof(struct proc) * NPROC);
80103aec:	83 c4 0c             	add    $0xc,%esp
80103aef:	68 00 99 17 00       	push   $0x179900
80103af4:	6a 00                	push   $0x0
80103af6:	68 40 3d 11 80       	push   $0x80113d40
80103afb:	e8 90 11 00 00       	call   80104c90 <memset>
  p = allocproc();
80103b00:	e8 fb fa ff ff       	call   80103600 <allocproc>
80103b05:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b07:	a3 c4 b5 10 80       	mov    %eax,0x8010b5c4
  if((p->pgdir = setupkvm()) == 0)
80103b0c:	e8 ef 39 00 00       	call   80107500 <setupkvm>
80103b11:	83 c4 10             	add    $0x10,%esp
80103b14:	85 c0                	test   %eax,%eax
80103b16:	89 43 04             	mov    %eax,0x4(%ebx)
80103b19:	0f 84 bd 00 00 00    	je     80103bdc <userinit+0x11c>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b1f:	83 ec 04             	sub    $0x4,%esp
80103b22:	68 2c 00 00 00       	push   $0x2c
80103b27:	68 60 b4 10 80       	push   $0x8010b460
80103b2c:	50                   	push   %eax
80103b2d:	e8 ae 36 00 00       	call   801071e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b32:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b35:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b3b:	6a 4c                	push   $0x4c
80103b3d:	6a 00                	push   $0x0
80103b3f:	ff 73 18             	pushl  0x18(%ebx)
80103b42:	e8 49 11 00 00       	call   80104c90 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b47:	8b 43 18             	mov    0x18(%ebx),%eax
80103b4a:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b4f:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b54:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b57:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5e:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b62:	8b 43 18             	mov    0x18(%ebx),%eax
80103b65:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b69:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b6d:	8b 43 18             	mov    0x18(%ebx),%eax
80103b70:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b74:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b78:	8b 43 18             	mov    0x18(%ebx),%eax
80103b7b:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b82:	8b 43 18             	mov    0x18(%ebx),%eax
80103b85:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b8f:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b96:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b99:	6a 10                	push   $0x10
80103b9b:	68 25 7d 10 80       	push   $0x80107d25
80103ba0:	50                   	push   %eax
80103ba1:	e8 ca 12 00 00       	call   80104e70 <safestrcpy>
  p->cwd = namei("/");
80103ba6:	c7 04 24 2e 7d 10 80 	movl   $0x80107d2e,(%esp)
80103bad:	e8 2e e3 ff ff       	call   80101ee0 <namei>
80103bb2:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bb5:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80103bbc:	e8 bf 0f 00 00       	call   80104b80 <acquire>
  p->state = RUNNABLE;
80103bc1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bc8:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80103bcf:	e8 6c 10 00 00       	call   80104c40 <release>
}
80103bd4:	83 c4 10             	add    $0x10,%esp
80103bd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bda:	c9                   	leave  
80103bdb:	c3                   	ret    
    panic("userinit: out of memory?");
80103bdc:	83 ec 0c             	sub    $0xc,%esp
80103bdf:	68 0c 7d 10 80       	push   $0x80107d0c
80103be4:	e8 a7 c7 ff ff       	call   80100390 <panic>
80103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <growproc>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx
80103bf5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bf8:	e8 b3 0e 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103bfd:	e8 ee fd ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103c02:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c08:	e8 e3 0e 00 00       	call   80104af0 <popcli>
  if(n > 0){
80103c0d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c10:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c12:	7f 1c                	jg     80103c30 <growproc+0x40>
  } else if(n < 0){
80103c14:	75 3a                	jne    80103c50 <growproc+0x60>
  switchuvm(curproc);
80103c16:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c19:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c1b:	53                   	push   %ebx
80103c1c:	e8 af 34 00 00       	call   801070d0 <switchuvm>
  return 0;
80103c21:	83 c4 10             	add    $0x10,%esp
80103c24:	31 c0                	xor    %eax,%eax
}
80103c26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c29:	5b                   	pop    %ebx
80103c2a:	5e                   	pop    %esi
80103c2b:	5d                   	pop    %ebp
80103c2c:	c3                   	ret    
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c30:	83 ec 04             	sub    $0x4,%esp
80103c33:	01 c6                	add    %eax,%esi
80103c35:	56                   	push   %esi
80103c36:	50                   	push   %eax
80103c37:	ff 73 04             	pushl  0x4(%ebx)
80103c3a:	e8 e1 36 00 00       	call   80107320 <allocuvm>
80103c3f:	83 c4 10             	add    $0x10,%esp
80103c42:	85 c0                	test   %eax,%eax
80103c44:	75 d0                	jne    80103c16 <growproc+0x26>
      return -1;
80103c46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c4b:	eb d9                	jmp    80103c26 <growproc+0x36>
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c50:	83 ec 04             	sub    $0x4,%esp
80103c53:	01 c6                	add    %eax,%esi
80103c55:	56                   	push   %esi
80103c56:	50                   	push   %eax
80103c57:	ff 73 04             	pushl  0x4(%ebx)
80103c5a:	e8 f1 37 00 00       	call   80107450 <deallocuvm>
80103c5f:	83 c4 10             	add    $0x10,%esp
80103c62:	85 c0                	test   %eax,%eax
80103c64:	75 b0                	jne    80103c16 <growproc+0x26>
80103c66:	eb de                	jmp    80103c46 <growproc+0x56>
80103c68:	90                   	nop
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c70 <fork>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c79:	e8 32 0e 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103c7e:	e8 6d fd ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103c83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c89:	e8 62 0e 00 00       	call   80104af0 <popcli>
  if((np = allocproc()) == 0){
80103c8e:	e8 6d f9 ff ff       	call   80103600 <allocproc>
80103c93:	85 c0                	test   %eax,%eax
80103c95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c98:	0f 84 b7 00 00 00    	je     80103d55 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c9e:	83 ec 08             	sub    $0x8,%esp
80103ca1:	ff 33                	pushl  (%ebx)
80103ca3:	ff 73 04             	pushl  0x4(%ebx)
80103ca6:	89 c7                	mov    %eax,%edi
80103ca8:	e8 23 39 00 00       	call   801075d0 <copyuvm>
80103cad:	83 c4 10             	add    $0x10,%esp
80103cb0:	85 c0                	test   %eax,%eax
80103cb2:	89 47 04             	mov    %eax,0x4(%edi)
80103cb5:	0f 84 a1 00 00 00    	je     80103d5c <fork+0xec>
  np->sz = curproc->sz;
80103cbb:	8b 03                	mov    (%ebx),%eax
80103cbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cc0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103cc2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103cc5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103cc7:	8b 79 18             	mov    0x18(%ecx),%edi
80103cca:	8b 73 18             	mov    0x18(%ebx),%esi
80103ccd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cd2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cd4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cd6:	8b 40 18             	mov    0x18(%eax),%eax
80103cd9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ce0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ce4:	85 c0                	test   %eax,%eax
80103ce6:	74 13                	je     80103cfb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ce8:	83 ec 0c             	sub    $0xc,%esp
80103ceb:	50                   	push   %eax
80103cec:	e8 ff d0 ff ff       	call   80100df0 <filedup>
80103cf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cf4:	83 c4 10             	add    $0x10,%esp
80103cf7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cfb:	83 c6 01             	add    $0x1,%esi
80103cfe:	83 fe 10             	cmp    $0x10,%esi
80103d01:	75 dd                	jne    80103ce0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d03:	83 ec 0c             	sub    $0xc,%esp
80103d06:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d0c:	e8 3f d9 ff ff       	call   80101650 <idup>
80103d11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d1d:	6a 10                	push   $0x10
80103d1f:	53                   	push   %ebx
80103d20:	50                   	push   %eax
80103d21:	e8 4a 11 00 00       	call   80104e70 <safestrcpy>
  pid = np->pid;
80103d26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d29:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80103d30:	e8 4b 0e 00 00       	call   80104b80 <acquire>
  np->state = RUNNABLE;
80103d35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d3c:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80103d43:	e8 f8 0e 00 00       	call   80104c40 <release>
  return pid;
80103d48:	83 c4 10             	add    $0x10,%esp
}
80103d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d4e:	89 d8                	mov    %ebx,%eax
80103d50:	5b                   	pop    %ebx
80103d51:	5e                   	pop    %esi
80103d52:	5f                   	pop    %edi
80103d53:	5d                   	pop    %ebp
80103d54:	c3                   	ret    
    return -1;
80103d55:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d5a:	eb ef                	jmp    80103d4b <fork+0xdb>
    kfree(np->kstack);
80103d5c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d5f:	83 ec 0c             	sub    $0xc,%esp
80103d62:	ff 73 08             	pushl  0x8(%ebx)
80103d65:	e8 a6 e5 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103d6a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103d71:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d78:	83 c4 10             	add    $0x10,%esp
80103d7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d80:	eb c9                	jmp    80103d4b <fork+0xdb>
80103d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d90 <boost>:
  if (c2 > 0) {
80103d90:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
{
80103d96:	55                   	push   %ebp
80103d97:	89 e5                	mov    %esp,%ebp
  if (c2 > 0) {
80103d99:	85 d2                	test   %edx,%edx
{
80103d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  if (c2 > 0) {
80103d9e:	7e 10                	jle    80103db0 <boost+0x20>
}
80103da0:	5d                   	pop    %ebp
80103da1:	e9 6a fb ff ff       	jmp    80103910 <boost.part.1>
80103da6:	8d 76 00             	lea    0x0(%esi),%esi
80103da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103db0:	5d                   	pop    %ebp
80103db1:	c3                   	ret    
80103db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dc0 <scheduler>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103dc9:	e8 22 fc ff ff       	call   801039f0 <mycpu>
  c->proc = 0;
80103dce:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103dd5:	00 00 00 
  struct cpu *c = mycpu();
80103dd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ddb:	83 c0 04             	add    $0x4,%eax
80103dde:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103de8:	fb                   	sti    
    acquire(&ptable.lock);
80103de9:	83 ec 0c             	sub    $0xc,%esp
80103dec:	68 40 40 11 80       	push   $0x80114040
80103df1:	e8 8a 0d 00 00       	call   80104b80 <acquire>
    if (c0!=0){
80103df6:	83 c4 10             	add    $0x10,%esp
80103df9:	83 3d c0 b5 10 80 00 	cmpl   $0x0,0x8010b5c0
80103e00:	0f 85 7a 01 00 00    	jne    80103f80 <scheduler+0x1c0>
    if (c1!= 0 && flg == 0) {
80103e06:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103e0b:	85 c0                	test   %eax,%eax
80103e0d:	0f 84 45 01 00 00    	je     80103f58 <scheduler+0x198>
      for (int i=0;i < c1;++i) {
80103e13:	85 c0                	test   %eax,%eax
80103e15:	0f 8e 3d 01 00 00    	jle    80103f58 <scheduler+0x198>
80103e1b:	31 f6                	xor    %esi,%esi
80103e1d:	eb 10                	jmp    80103e2f <scheduler+0x6f>
80103e1f:	90                   	nop
80103e20:	83 c6 01             	add    $0x1,%esi
80103e23:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
80103e29:	0f 8e 29 01 00 00    	jle    80103f58 <scheduler+0x198>
        if (q1[i]->state != RUNNABLE) continue;
80103e2f:	8b 1c b5 40 3e 11 80 	mov    -0x7feec1c0(,%esi,4),%ebx
80103e36:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e3a:	75 e4                	jne    80103e20 <scheduler+0x60>
        c->proc = p;
80103e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        switchuvm(p);
80103e3f:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103e42:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
        switchuvm(p);
80103e48:	53                   	push   %ebx
80103e49:	e8 82 32 00 00       	call   801070d0 <switchuvm>
        p->state = RUNNING;
80103e4e:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        int start = ticks;
80103e55:	8b 3d c0 e1 28 80    	mov    0x8028e1c0,%edi
        swtch(&(c->scheduler), p->context);
80103e5b:	59                   	pop    %ecx
80103e5c:	58                   	pop    %eax
80103e5d:	ff 73 1c             	pushl  0x1c(%ebx)
80103e60:	ff 75 e0             	pushl  -0x20(%ebp)
80103e63:	e8 63 10 00 00       	call   80104ecb <swtch>
        switchkvm();
80103e68:	e8 43 32 00 00       	call   801070b0 <switchkvm>
        p->sched_stats[p->num_stats_used].start_tick = start; //the number of ticks when this process is scheduled
80103e6d:	8b 8b a0 00 00 00    	mov    0xa0(%ebx),%ecx
        int duration = ticks - start;
80103e73:	a1 c0 e1 28 80       	mov    0x8028e1c0,%eax
        if (p->num_ticks >= 2) {
80103e78:	83 c4 10             	add    $0x10,%esp
        p->times[1]++;
80103e7b:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
80103e82:	89 ca                	mov    %ecx,%edx
        int duration = ticks - start;
80103e84:	29 f8                	sub    %edi,%eax
        p->num_stats_used++;
80103e86:	83 c1 01             	add    $0x1,%ecx
80103e89:	c1 e2 04             	shl    $0x4,%edx
        p->total_ticks += duration;
80103e8c:	01 83 9c 00 00 00    	add    %eax,0x9c(%ebx)
80103e92:	01 da                	add    %ebx,%edx
        p->ticks[1] = duration;
80103e94:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
        p->sched_stats[p->num_stats_used].start_tick = start; //the number of ticks when this process is scheduled
80103e9a:	89 ba a8 00 00 00    	mov    %edi,0xa8(%edx)
        p->sched_stats[p->num_stats_used].duration = duration; //number of ticks the process is running before it gives up the CPU
80103ea0:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
        p->sched_stats[p->num_stats_used].priority = 1; //the priority of the process when it's scheduled
80103ea6:	c7 82 b0 00 00 00 01 	movl   $0x1,0xb0(%edx)
80103ead:	00 00 00 
        if (p->num_ticks >= 2) {
80103eb0:	83 bb 98 00 00 00 01 	cmpl   $0x1,0x98(%ebx)
        p->num_stats_used++;
80103eb7:	89 8b a0 00 00 00    	mov    %ecx,0xa0(%ebx)
        p->wait_time = 0;
80103ebd:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103ec4:	00 00 00 
80103ec7:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
        if (p->num_ticks >= 2) {
80103ecd:	7e 60                	jle    80103f2f <scheduler+0x16f>
          q2[c2] = p;
80103ecf:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
          p->num_ticks = 0;
80103ed5:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103edc:	00 00 00 
          q1[i] = 0;
80103edf:	c7 04 b5 40 3e 11 80 	movl   $0x0,-0x7feec1c0(,%esi,4)
80103ee6:	00 00 00 00 
          q2[c2] = p;
80103eea:	89 1c 8d 40 3d 11 80 	mov    %ebx,-0x7feec2c0(,%ecx,4)
          copyover(q1, j, c1)
80103ef1:	8b 1d bc b5 10 80    	mov    0x8010b5bc,%ebx
80103ef7:	8d 7b ff             	lea    -0x1(%ebx),%edi
80103efa:	39 f7                	cmp    %esi,%edi
80103efc:	7e 22                	jle    80103f20 <scheduler+0x160>
80103efe:	8d 14 b5 40 3e 11 80 	lea    -0x7feec1c0(,%esi,4),%edx
80103f05:	8d 1c 9d 3c 3e 11 80 	lea    -0x7feec1c4(,%ebx,4),%ebx
80103f0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103f0f:	90                   	nop
80103f10:	8b 42 04             	mov    0x4(%edx),%eax
80103f13:	83 c2 04             	add    $0x4,%edx
80103f16:	89 42 fc             	mov    %eax,-0x4(%edx)
80103f19:	39 d3                	cmp    %edx,%ebx
80103f1b:	75 f3                	jne    80103f10 <scheduler+0x150>
80103f1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
          ++c2;
80103f20:	83 c1 01             	add    $0x1,%ecx
          --c1;
80103f23:	89 3d bc b5 10 80    	mov    %edi,0x8010b5bc
          ++c2;
80103f29:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
  if (c2 > 0) {
80103f2f:	85 c9                	test   %ecx,%ecx
80103f31:	7e 05                	jle    80103f38 <scheduler+0x178>
80103f33:	e8 d8 f9 ff ff       	call   80103910 <boost.part.1>
      for (int i=0;i < c1;++i) {
80103f38:	83 c6 01             	add    $0x1,%esi
80103f3b:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
        c->proc = 0;
80103f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f44:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f4b:	00 00 00 
      for (int i=0;i < c1;++i) {
80103f4e:	0f 8f db fe ff ff    	jg     80103e2f <scheduler+0x6f>
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (c2!=0 && flg == 0) {
80103f58:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
80103f5e:	85 d2                	test   %edx,%edx
80103f60:	0f 85 9a 01 00 00    	jne    80104100 <scheduler+0x340>
    release(&ptable.lock);
80103f66:	83 ec 0c             	sub    $0xc,%esp
80103f69:	68 40 40 11 80       	push   $0x80114040
80103f6e:	e8 cd 0c 00 00       	call   80104c40 <release>
    sti();
80103f73:	83 c4 10             	add    $0x10,%esp
80103f76:	e9 6d fe ff ff       	jmp    80103de8 <scheduler+0x28>
80103f7b:	90                   	nop
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for (int i=0;i < c0;++i) {
80103f80:	be 00 00 00 00       	mov    $0x0,%esi
    flg = 0;
80103f85:	ba 00 00 00 00       	mov    $0x0,%edx
      for (int i=0;i < c0;++i) {
80103f8a:	7f 1b                	jg     80103fa7 <scheduler+0x1e7>
80103f8c:	e9 9f 02 00 00       	jmp    80104230 <scheduler+0x470>
80103f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f98:	83 c6 01             	add    $0x1,%esi
80103f9b:	39 35 c0 b5 10 80    	cmp    %esi,0x8010b5c0
80103fa1:	0f 8e 28 01 00 00    	jle    801040cf <scheduler+0x30f>
        if (q0[i]->state != RUNNABLE) continue;
80103fa7:	8b 1c b5 40 3f 11 80 	mov    -0x7feec0c0(,%esi,4),%ebx
80103fae:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103fb2:	75 e4                	jne    80103f98 <scheduler+0x1d8>
        c->proc = p;
80103fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        switchuvm(p);
80103fb7:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103fba:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
        switchuvm(p);
80103fc0:	53                   	push   %ebx
80103fc1:	e8 0a 31 00 00       	call   801070d0 <switchuvm>
        p->state = RUNNING;
80103fc6:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        int start = ticks;
80103fcd:	8b 3d c0 e1 28 80    	mov    0x8028e1c0,%edi
        swtch(&(c->scheduler), p->context);
80103fd3:	59                   	pop    %ecx
80103fd4:	58                   	pop    %eax
80103fd5:	ff 73 1c             	pushl  0x1c(%ebx)
80103fd8:	ff 75 e0             	pushl  -0x20(%ebp)
80103fdb:	e8 eb 0e 00 00       	call   80104ecb <swtch>
        switchkvm();
80103fe0:	e8 cb 30 00 00       	call   801070b0 <switchkvm>
        p->sched_stats[p->num_stats_used].start_tick = start; //the number of ticks when this process is scheduled
80103fe5:	8b 8b a0 00 00 00    	mov    0xa0(%ebx),%ecx
        int duration = ticks - start;
80103feb:	a1 c0 e1 28 80       	mov    0x8028e1c0,%eax
        if (p->num_ticks >= 1) {
80103ff0:	83 c4 10             	add    $0x10,%esp
        p->times[0]++;
80103ff3:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
80103ff7:	89 ca                	mov    %ecx,%edx
        int duration = ticks - start;
80103ff9:	29 f8                	sub    %edi,%eax
        p->total_ticks += duration;
80103ffb:	01 83 9c 00 00 00    	add    %eax,0x9c(%ebx)
80104001:	c1 e2 04             	shl    $0x4,%edx
        p->ticks[0] = duration;
80104004:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        p->num_stats_used++;
8010400a:	83 c1 01             	add    $0x1,%ecx
8010400d:	01 da                	add    %ebx,%edx
        p->sched_stats[p->num_stats_used].start_tick = start; //the number of ticks when this process is scheduled
8010400f:	89 ba a8 00 00 00    	mov    %edi,0xa8(%edx)
        p->sched_stats[p->num_stats_used].duration = duration; //number of ticks the process is running before it gives up the CPU
80104015:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
        p->sched_stats[p->num_stats_used].priority = 0; //the priority of the process when it's scheduled
8010401b:	c7 82 b0 00 00 00 00 	movl   $0x0,0xb0(%edx)
80104022:	00 00 00 
        if (p->num_ticks >= 1) {
80104025:	8b 93 98 00 00 00    	mov    0x98(%ebx),%edx
        p->num_stats_used++;
8010402b:	89 8b a0 00 00 00    	mov    %ecx,0xa0(%ebx)
        p->wait_time = 0;
80104031:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80104038:	00 00 00 
        if (p->num_ticks >= 1) {
8010403b:	85 d2                	test   %edx,%edx
8010403d:	7e 60                	jle    8010409f <scheduler+0x2df>
          q1[c1] = p;
8010403f:	8b 3d bc b5 10 80    	mov    0x8010b5bc,%edi
          copyover(q0, j, c0)
80104045:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
          p->num_ticks = 0;
8010404b:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80104052:	00 00 00 
          q0[i] = 0;
80104055:	c7 04 b5 40 3f 11 80 	movl   $0x0,-0x7feec0c0(,%esi,4)
8010405c:	00 00 00 00 
          q1[c1] = p;
80104060:	89 1c bd 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%edi,4)
          copyover(q0, j, c0)
80104067:	8d 59 ff             	lea    -0x1(%ecx),%ebx
8010406a:	39 de                	cmp    %ebx,%esi
8010406c:	7d 22                	jge    80104090 <scheduler+0x2d0>
8010406e:	8d 14 b5 40 3f 11 80 	lea    -0x7feec0c0(,%esi,4),%edx
80104075:	8d 0c 8d 3c 3f 11 80 	lea    -0x7feec0c4(,%ecx,4),%ecx
8010407c:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010407f:	90                   	nop
80104080:	8b 42 04             	mov    0x4(%edx),%eax
80104083:	83 c2 04             	add    $0x4,%edx
80104086:	89 42 fc             	mov    %eax,-0x4(%edx)
80104089:	39 ca                	cmp    %ecx,%edx
8010408b:	75 f3                	jne    80104080 <scheduler+0x2c0>
8010408d:	8b 45 dc             	mov    -0x24(%ebp),%eax
          ++c1;
80104090:	83 c7 01             	add    $0x1,%edi
          --c0;
80104093:	89 1d c0 b5 10 80    	mov    %ebx,0x8010b5c0
          ++c1;
80104099:	89 3d bc b5 10 80    	mov    %edi,0x8010b5bc
  if (c2 > 0) {
8010409f:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
801040a5:	85 d2                	test   %edx,%edx
801040a7:	7e 05                	jle    801040ae <scheduler+0x2ee>
801040a9:	e8 62 f8 ff ff       	call   80103910 <boost.part.1>
      for (int i=0;i < c0;++i) {
801040ae:	83 c6 01             	add    $0x1,%esi
801040b1:	39 35 c0 b5 10 80    	cmp    %esi,0x8010b5c0
        c->proc = 0;
801040b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        flg = 1;
801040ba:	ba 01 00 00 00       	mov    $0x1,%edx
        c->proc = 0;
801040bf:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040c6:	00 00 00 
      for (int i=0;i < c0;++i) {
801040c9:	0f 8f d8 fe ff ff    	jg     80103fa7 <scheduler+0x1e7>
    if (c1!= 0 && flg == 0) {
801040cf:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801040d4:	85 c0                	test   %eax,%eax
801040d6:	0f 85 04 01 00 00    	jne    801041e0 <scheduler+0x420>
801040dc:	89 d0                	mov    %edx,%eax
801040de:	83 f0 01             	xor    $0x1,%eax
    if (c2!=0 && flg == 0) {
801040e1:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
801040e7:	85 d2                	test   %edx,%edx
801040e9:	0f 84 77 fe ff ff    	je     80103f66 <scheduler+0x1a6>
801040ef:	84 c0                	test   %al,%al
801040f1:	0f 84 6f fe ff ff    	je     80103f66 <scheduler+0x1a6>
801040f7:	89 f6                	mov    %esi,%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      for (int i=0;i < c2;++i) {
80104100:	31 f6                	xor    %esi,%esi
80104102:	85 d2                	test   %edx,%edx
80104104:	7f 15                	jg     8010411b <scheduler+0x35b>
80104106:	e9 5b fe ff ff       	jmp    80103f66 <scheduler+0x1a6>
8010410b:	90                   	nop
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104110:	83 c6 01             	add    $0x1,%esi
80104113:	39 f2                	cmp    %esi,%edx
80104115:	0f 8e 4b fe ff ff    	jle    80103f66 <scheduler+0x1a6>
        if (q2[i]->state != RUNNABLE) continue;
8010411b:	8b 1c b5 40 3d 11 80 	mov    -0x7feec2c0(,%esi,4),%ebx
80104122:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104126:	75 e8                	jne    80104110 <scheduler+0x350>
        c->proc = p;
80104128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        switchuvm(p);
8010412b:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
8010412e:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
        switchuvm(p);
80104134:	53                   	push   %ebx
80104135:	e8 96 2f 00 00       	call   801070d0 <switchuvm>
        p->state = RUNNING;
8010413a:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        int start = ticks;
80104141:	8b 3d c0 e1 28 80    	mov    0x8028e1c0,%edi
        swtch(&(c->scheduler), p->context);
80104147:	58                   	pop    %eax
80104148:	5a                   	pop    %edx
80104149:	ff 73 1c             	pushl  0x1c(%ebx)
8010414c:	ff 75 e0             	pushl  -0x20(%ebp)
8010414f:	e8 77 0d 00 00       	call   80104ecb <swtch>
        switchkvm();
80104154:	e8 57 2f 00 00       	call   801070b0 <switchkvm>
        p->sched_stats[p->num_stats_used].start_tick = start; //the number of ticks when this process is scheduled
80104159:	8b 8b a0 00 00 00    	mov    0xa0(%ebx),%ecx
        int duration = ticks - start;
8010415f:	a1 c0 e1 28 80       	mov    0x8028e1c0,%eax
  if (c2 > 0) {
80104164:	83 c4 10             	add    $0x10,%esp
        p->times[2]++;
80104167:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
8010416e:	89 ca                	mov    %ecx,%edx
        int duration = ticks - start;
80104170:	29 f8                	sub    %edi,%eax
        p->total_ticks += duration;
80104172:	01 83 9c 00 00 00    	add    %eax,0x9c(%ebx)
80104178:	c1 e2 04             	shl    $0x4,%edx
        p->ticks[2] = duration;
8010417b:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
        p->num_stats_used++;
80104181:	83 c1 01             	add    $0x1,%ecx
80104184:	01 da                	add    %ebx,%edx
        p->sched_stats[p->num_stats_used].start_tick = start; //the number of ticks when this process is scheduled
80104186:	89 ba a8 00 00 00    	mov    %edi,0xa8(%edx)
        p->sched_stats[p->num_stats_used].duration = duration; //number of ticks the process is running before it gives up the CPU
8010418c:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
        p->sched_stats[p->num_stats_used].priority = 2; //the priority of the process when it's scheduled
80104192:	c7 82 b0 00 00 00 02 	movl   $0x2,0xb0(%edx)
80104199:	00 00 00 
  if (c2 > 0) {
8010419c:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
        p->num_stats_used++;
801041a2:	89 8b a0 00 00 00    	mov    %ecx,0xa0(%ebx)
        p->wait_time = 0;
801041a8:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801041af:	00 00 00 
  if (c2 > 0) {
801041b2:	85 d2                	test   %edx,%edx
801041b4:	7e 0b                	jle    801041c1 <scheduler+0x401>
801041b6:	e8 55 f7 ff ff       	call   80103910 <boost.part.1>
801041bb:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
        if (p->num_ticks >= 8) {
801041c1:	83 bb 98 00 00 00 07 	cmpl   $0x7,0x98(%ebx)
801041c8:	7f 26                	jg     801041f0 <scheduler+0x430>
        c->proc = 0;
801041ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801041cd:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041d4:	00 00 00 
801041d7:	e9 34 ff ff ff       	jmp    80104110 <scheduler+0x350>
801041dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (c1!= 0 && flg == 0) {
801041e0:	85 d2                	test   %edx,%edx
801041e2:	0f 85 7e fd ff ff    	jne    80103f66 <scheduler+0x1a6>
801041e8:	e9 26 fc ff ff       	jmp    80103e13 <scheduler+0x53>
801041ed:	8d 76 00             	lea    0x0(%esi),%esi
          copyover(q2, j, c2)
801041f0:	8d 42 ff             	lea    -0x1(%edx),%eax
          p->num_ticks = 0;
801041f3:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801041fa:	00 00 00 
          copyover(q2, j, c2)
801041fd:	39 f0                	cmp    %esi,%eax
801041ff:	7e 1c                	jle    8010421d <scheduler+0x45d>
80104201:	8d 04 b5 40 3d 11 80 	lea    -0x7feec2c0(,%esi,4),%eax
80104208:	8d 0c 95 3c 3d 11 80 	lea    -0x7feec2c4(,%edx,4),%ecx
8010420f:	90                   	nop
80104210:	8b 78 04             	mov    0x4(%eax),%edi
80104213:	83 c0 04             	add    $0x4,%eax
80104216:	89 78 fc             	mov    %edi,-0x4(%eax)
80104219:	39 c1                	cmp    %eax,%ecx
8010421b:	75 f3                	jne    80104210 <scheduler+0x450>
          q2[c2] = p;
8010421d:	89 1c 95 40 3d 11 80 	mov    %ebx,-0x7feec2c0(,%edx,4)
80104224:	eb a4                	jmp    801041ca <scheduler+0x40a>
80104226:	8d 76 00             	lea    0x0(%esi),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (c1!= 0 && flg == 0) {
80104230:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80104235:	85 c0                	test   %eax,%eax
80104237:	0f 85 d6 fb ff ff    	jne    80103e13 <scheduler+0x53>
8010423d:	b8 01 00 00 00       	mov    $0x1,%eax
80104242:	e9 9a fe ff ff       	jmp    801040e1 <scheduler+0x321>
80104247:	89 f6                	mov    %esi,%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <sched>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
  pushcli();
80104255:	e8 56 08 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
8010425a:	e8 91 f7 ff ff       	call   801039f0 <mycpu>
  p = c->proc;
8010425f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104265:	e8 86 08 00 00       	call   80104af0 <popcli>
  if(!holding(&ptable.lock))
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	68 40 40 11 80       	push   $0x80114040
80104272:	e8 d9 08 00 00       	call   80104b50 <holding>
80104277:	83 c4 10             	add    $0x10,%esp
8010427a:	85 c0                	test   %eax,%eax
8010427c:	74 4f                	je     801042cd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010427e:	e8 6d f7 ff ff       	call   801039f0 <mycpu>
80104283:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010428a:	75 68                	jne    801042f4 <sched+0xa4>
  if(p->state == RUNNING)
8010428c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104290:	74 55                	je     801042e7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104292:	9c                   	pushf  
80104293:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104294:	f6 c4 02             	test   $0x2,%ah
80104297:	75 41                	jne    801042da <sched+0x8a>
  intena = mycpu()->intena;
80104299:	e8 52 f7 ff ff       	call   801039f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010429e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801042a1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801042a7:	e8 44 f7 ff ff       	call   801039f0 <mycpu>
801042ac:	83 ec 08             	sub    $0x8,%esp
801042af:	ff 70 04             	pushl  0x4(%eax)
801042b2:	53                   	push   %ebx
801042b3:	e8 13 0c 00 00       	call   80104ecb <swtch>
  mycpu()->intena = intena;
801042b8:	e8 33 f7 ff ff       	call   801039f0 <mycpu>
}
801042bd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042c0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042c9:	5b                   	pop    %ebx
801042ca:	5e                   	pop    %esi
801042cb:	5d                   	pop    %ebp
801042cc:	c3                   	ret    
    panic("sched ptable.lock");
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	68 30 7d 10 80       	push   $0x80107d30
801042d5:	e8 b6 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801042da:	83 ec 0c             	sub    $0xc,%esp
801042dd:	68 5c 7d 10 80       	push   $0x80107d5c
801042e2:	e8 a9 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
801042e7:	83 ec 0c             	sub    $0xc,%esp
801042ea:	68 4e 7d 10 80       	push   $0x80107d4e
801042ef:	e8 9c c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
801042f4:	83 ec 0c             	sub    $0xc,%esp
801042f7:	68 42 7d 10 80       	push   $0x80107d42
801042fc:	e8 8f c0 ff ff       	call   80100390 <panic>
80104301:	eb 0d                	jmp    80104310 <exit>
80104303:	90                   	nop
80104304:	90                   	nop
80104305:	90                   	nop
80104306:	90                   	nop
80104307:	90                   	nop
80104308:	90                   	nop
80104309:	90                   	nop
8010430a:	90                   	nop
8010430b:	90                   	nop
8010430c:	90                   	nop
8010430d:	90                   	nop
8010430e:	90                   	nop
8010430f:	90                   	nop

80104310 <exit>:
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	53                   	push   %ebx
80104316:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104319:	e8 92 07 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
8010431e:	e8 cd f6 ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80104323:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104329:	e8 c2 07 00 00       	call   80104af0 <popcli>
  if(curproc == initproc)
8010432e:	39 35 c4 b5 10 80    	cmp    %esi,0x8010b5c4
80104334:	8d 5e 28             	lea    0x28(%esi),%ebx
80104337:	8d 7e 68             	lea    0x68(%esi),%edi
8010433a:	0f 84 f1 00 00 00    	je     80104431 <exit+0x121>
    if(curproc->ofile[fd]){
80104340:	8b 03                	mov    (%ebx),%eax
80104342:	85 c0                	test   %eax,%eax
80104344:	74 12                	je     80104358 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	50                   	push   %eax
8010434a:	e8 f1 ca ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
8010434f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104355:	83 c4 10             	add    $0x10,%esp
80104358:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010435b:	39 fb                	cmp    %edi,%ebx
8010435d:	75 e1                	jne    80104340 <exit+0x30>
  begin_op();
8010435f:	e8 3c e8 ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	ff 76 68             	pushl  0x68(%esi)
8010436a:	e8 41 d4 ff ff       	call   801017b0 <iput>
  end_op();
8010436f:	e8 9c e8 ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80104374:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010437b:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80104382:	e8 f9 07 00 00       	call   80104b80 <acquire>
  wakeup1(curproc->parent);
80104387:	8b 56 14             	mov    0x14(%esi),%edx
8010438a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010438d:	b8 74 40 11 80       	mov    $0x80114074,%eax
80104392:	eb 10                	jmp    801043a4 <exit+0x94>
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104398:	05 64 5e 00 00       	add    $0x5e64,%eax
8010439d:	3d 74 d9 28 80       	cmp    $0x8028d974,%eax
801043a2:	73 1e                	jae    801043c2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
801043a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043a8:	75 ee                	jne    80104398 <exit+0x88>
801043aa:	3b 50 20             	cmp    0x20(%eax),%edx
801043ad:	75 e9                	jne    80104398 <exit+0x88>
      p->state = RUNNABLE;
801043af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043b6:	05 64 5e 00 00       	add    $0x5e64,%eax
801043bb:	3d 74 d9 28 80       	cmp    $0x8028d974,%eax
801043c0:	72 e2                	jb     801043a4 <exit+0x94>
      p->parent = initproc;
801043c2:	8b 0d c4 b5 10 80    	mov    0x8010b5c4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c8:	ba 74 40 11 80       	mov    $0x80114074,%edx
801043cd:	eb 0f                	jmp    801043de <exit+0xce>
801043cf:	90                   	nop
801043d0:	81 c2 64 5e 00 00    	add    $0x5e64,%edx
801043d6:	81 fa 74 d9 28 80    	cmp    $0x8028d974,%edx
801043dc:	73 3a                	jae    80104418 <exit+0x108>
    if(p->parent == curproc){
801043de:	39 72 14             	cmp    %esi,0x14(%edx)
801043e1:	75 ed                	jne    801043d0 <exit+0xc0>
      if(p->state == ZOMBIE)
801043e3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801043e7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801043ea:	75 e4                	jne    801043d0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ec:	b8 74 40 11 80       	mov    $0x80114074,%eax
801043f1:	eb 11                	jmp    80104404 <exit+0xf4>
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f8:	05 64 5e 00 00       	add    $0x5e64,%eax
801043fd:	3d 74 d9 28 80       	cmp    $0x8028d974,%eax
80104402:	73 cc                	jae    801043d0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104404:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104408:	75 ee                	jne    801043f8 <exit+0xe8>
8010440a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010440d:	75 e9                	jne    801043f8 <exit+0xe8>
      p->state = RUNNABLE;
8010440f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104416:	eb e0                	jmp    801043f8 <exit+0xe8>
  curproc->state = ZOMBIE;
80104418:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010441f:	e8 2c fe ff ff       	call   80104250 <sched>
  panic("zombie exit");
80104424:	83 ec 0c             	sub    $0xc,%esp
80104427:	68 7d 7d 10 80       	push   $0x80107d7d
8010442c:	e8 5f bf ff ff       	call   80100390 <panic>
    panic("init exiting");
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 70 7d 10 80       	push   $0x80107d70
80104439:	e8 52 bf ff ff       	call   80100390 <panic>
8010443e:	66 90                	xchg   %ax,%ax

80104440 <yield>:
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104447:	68 40 40 11 80       	push   $0x80114040
8010444c:	e8 2f 07 00 00       	call   80104b80 <acquire>
  pushcli();
80104451:	e8 5a 06 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80104456:	e8 95 f5 ff ff       	call   801039f0 <mycpu>
  p = c->proc;
8010445b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104461:	e8 8a 06 00 00       	call   80104af0 <popcli>
  myproc()->state = RUNNABLE;
80104466:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010446d:	e8 de fd ff ff       	call   80104250 <sched>
  release(&ptable.lock);
80104472:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80104479:	e8 c2 07 00 00       	call   80104c40 <release>
}
8010447e:	83 c4 10             	add    $0x10,%esp
80104481:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104484:	c9                   	leave  
80104485:	c3                   	ret    
80104486:	8d 76 00             	lea    0x0(%esi),%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104490 <sleep>:
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	8b 7d 08             	mov    0x8(%ebp),%edi
8010449c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010449f:	e8 0c 06 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
801044a4:	e8 47 f5 ff ff       	call   801039f0 <mycpu>
  p = c->proc;
801044a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044af:	e8 3c 06 00 00       	call   80104af0 <popcli>
  if(p == 0)
801044b4:	85 db                	test   %ebx,%ebx
801044b6:	0f 84 87 00 00 00    	je     80104543 <sleep+0xb3>
  if(lk == 0)
801044bc:	85 f6                	test   %esi,%esi
801044be:	74 76                	je     80104536 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801044c0:	81 fe 40 40 11 80    	cmp    $0x80114040,%esi
801044c6:	74 50                	je     80104518 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801044c8:	83 ec 0c             	sub    $0xc,%esp
801044cb:	68 40 40 11 80       	push   $0x80114040
801044d0:	e8 ab 06 00 00       	call   80104b80 <acquire>
    release(lk);
801044d5:	89 34 24             	mov    %esi,(%esp)
801044d8:	e8 63 07 00 00       	call   80104c40 <release>
  p->chan = chan;
801044dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044e7:	e8 64 fd ff ff       	call   80104250 <sched>
  p->chan = 0;
801044ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801044f3:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
801044fa:	e8 41 07 00 00       	call   80104c40 <release>
    acquire(lk);
801044ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104502:	83 c4 10             	add    $0x10,%esp
}
80104505:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104508:	5b                   	pop    %ebx
80104509:	5e                   	pop    %esi
8010450a:	5f                   	pop    %edi
8010450b:	5d                   	pop    %ebp
    acquire(lk);
8010450c:	e9 6f 06 00 00       	jmp    80104b80 <acquire>
80104511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104518:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010451b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104522:	e8 29 fd ff ff       	call   80104250 <sched>
  p->chan = 0;
80104527:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010452e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104531:	5b                   	pop    %ebx
80104532:	5e                   	pop    %esi
80104533:	5f                   	pop    %edi
80104534:	5d                   	pop    %ebp
80104535:	c3                   	ret    
    panic("sleep without lk");
80104536:	83 ec 0c             	sub    $0xc,%esp
80104539:	68 8f 7d 10 80       	push   $0x80107d8f
8010453e:	e8 4d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104543:	83 ec 0c             	sub    $0xc,%esp
80104546:	68 89 7d 10 80       	push   $0x80107d89
8010454b:	e8 40 be ff ff       	call   80100390 <panic>

80104550 <wait>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
  pushcli();
80104555:	e8 56 05 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
8010455a:	e8 91 f4 ff ff       	call   801039f0 <mycpu>
  p = c->proc;
8010455f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104565:	e8 86 05 00 00       	call   80104af0 <popcli>
  acquire(&ptable.lock);
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 40 40 11 80       	push   $0x80114040
80104572:	e8 09 06 00 00       	call   80104b80 <acquire>
80104577:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010457a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010457c:	bb 74 40 11 80       	mov    $0x80114074,%ebx
80104581:	eb 13                	jmp    80104596 <wait+0x46>
80104583:	90                   	nop
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104588:	81 c3 64 5e 00 00    	add    $0x5e64,%ebx
8010458e:	81 fb 74 d9 28 80    	cmp    $0x8028d974,%ebx
80104594:	73 1e                	jae    801045b4 <wait+0x64>
      if(p->parent != curproc)
80104596:	39 73 14             	cmp    %esi,0x14(%ebx)
80104599:	75 ed                	jne    80104588 <wait+0x38>
      if(p->state == ZOMBIE){
8010459b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010459f:	74 37                	je     801045d8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045a1:	81 c3 64 5e 00 00    	add    $0x5e64,%ebx
      havekids = 1;
801045a7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045ac:	81 fb 74 d9 28 80    	cmp    $0x8028d974,%ebx
801045b2:	72 e2                	jb     80104596 <wait+0x46>
    if(!havekids || curproc->killed){
801045b4:	85 c0                	test   %eax,%eax
801045b6:	74 76                	je     8010462e <wait+0xde>
801045b8:	8b 46 24             	mov    0x24(%esi),%eax
801045bb:	85 c0                	test   %eax,%eax
801045bd:	75 6f                	jne    8010462e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801045bf:	83 ec 08             	sub    $0x8,%esp
801045c2:	68 40 40 11 80       	push   $0x80114040
801045c7:	56                   	push   %esi
801045c8:	e8 c3 fe ff ff       	call   80104490 <sleep>
    havekids = 0;
801045cd:	83 c4 10             	add    $0x10,%esp
801045d0:	eb a8                	jmp    8010457a <wait+0x2a>
801045d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801045de:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801045e1:	e8 2a dd ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
801045e6:	5a                   	pop    %edx
801045e7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801045ea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045f1:	e8 8a 2e 00 00       	call   80107480 <freevm>
        release(&ptable.lock);
801045f6:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
        p->pid = 0;
801045fd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104604:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010460b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010460f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104616:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010461d:	e8 1e 06 00 00       	call   80104c40 <release>
        return pid;
80104622:	83 c4 10             	add    $0x10,%esp
}
80104625:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104628:	89 f0                	mov    %esi,%eax
8010462a:	5b                   	pop    %ebx
8010462b:	5e                   	pop    %esi
8010462c:	5d                   	pop    %ebp
8010462d:	c3                   	ret    
      release(&ptable.lock);
8010462e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104631:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104636:	68 40 40 11 80       	push   $0x80114040
8010463b:	e8 00 06 00 00       	call   80104c40 <release>
      return -1;
80104640:	83 c4 10             	add    $0x10,%esp
80104643:	eb e0                	jmp    80104625 <wait+0xd5>
80104645:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	53                   	push   %ebx
80104654:	83 ec 10             	sub    $0x10,%esp
80104657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010465a:	68 40 40 11 80       	push   $0x80114040
8010465f:	e8 1c 05 00 00       	call   80104b80 <acquire>
80104664:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104667:	b8 74 40 11 80       	mov    $0x80114074,%eax
8010466c:	eb 0e                	jmp    8010467c <wakeup+0x2c>
8010466e:	66 90                	xchg   %ax,%ax
80104670:	05 64 5e 00 00       	add    $0x5e64,%eax
80104675:	3d 74 d9 28 80       	cmp    $0x8028d974,%eax
8010467a:	73 1e                	jae    8010469a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010467c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104680:	75 ee                	jne    80104670 <wakeup+0x20>
80104682:	3b 58 20             	cmp    0x20(%eax),%ebx
80104685:	75 e9                	jne    80104670 <wakeup+0x20>
      p->state = RUNNABLE;
80104687:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010468e:	05 64 5e 00 00       	add    $0x5e64,%eax
80104693:	3d 74 d9 28 80       	cmp    $0x8028d974,%eax
80104698:	72 e2                	jb     8010467c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010469a:	c7 45 08 40 40 11 80 	movl   $0x80114040,0x8(%ebp)
}
801046a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a4:	c9                   	leave  
  release(&ptable.lock);
801046a5:	e9 96 05 00 00       	jmp    80104c40 <release>
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 10             	sub    $0x10,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801046ba:	68 40 40 11 80       	push   $0x80114040
801046bf:	e8 bc 04 00 00       	call   80104b80 <acquire>
801046c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c7:	b8 74 40 11 80       	mov    $0x80114074,%eax
801046cc:	eb 0e                	jmp    801046dc <kill+0x2c>
801046ce:	66 90                	xchg   %ax,%ax
801046d0:	05 64 5e 00 00       	add    $0x5e64,%eax
801046d5:	3d 74 d9 28 80       	cmp    $0x8028d974,%eax
801046da:	73 34                	jae    80104710 <kill+0x60>
    if(p->pid == pid){
801046dc:	39 58 10             	cmp    %ebx,0x10(%eax)
801046df:	75 ef                	jne    801046d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046e1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801046e5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801046ec:	75 07                	jne    801046f5 <kill+0x45>
        p->state = RUNNABLE;
801046ee:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046f5:	83 ec 0c             	sub    $0xc,%esp
801046f8:	68 40 40 11 80       	push   $0x80114040
801046fd:	e8 3e 05 00 00       	call   80104c40 <release>
      return 0;
80104702:	83 c4 10             	add    $0x10,%esp
80104705:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010470a:	c9                   	leave  
8010470b:	c3                   	ret    
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104710:	83 ec 0c             	sub    $0xc,%esp
80104713:	68 40 40 11 80       	push   $0x80114040
80104718:	e8 23 05 00 00       	call   80104c40 <release>
  return -1;
8010471d:	83 c4 10             	add    $0x10,%esp
80104720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104728:	c9                   	leave  
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	53                   	push   %ebx
80104736:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104739:	bb 74 40 11 80       	mov    $0x80114074,%ebx
{
8010473e:	83 ec 3c             	sub    $0x3c,%esp
80104741:	eb 27                	jmp    8010476a <procdump+0x3a>
80104743:	90                   	nop
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	68 9b 81 10 80       	push   $0x8010819b
80104750:	e8 0b bf ff ff       	call   80100660 <cprintf>
80104755:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104758:	81 c3 64 5e 00 00    	add    $0x5e64,%ebx
8010475e:	81 fb 74 d9 28 80    	cmp    $0x8028d974,%ebx
80104764:	0f 83 86 00 00 00    	jae    801047f0 <procdump+0xc0>
    if(p->state == UNUSED)
8010476a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010476d:	85 c0                	test   %eax,%eax
8010476f:	74 e7                	je     80104758 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104771:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104774:	ba a0 7d 10 80       	mov    $0x80107da0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104779:	77 11                	ja     8010478c <procdump+0x5c>
8010477b:	8b 14 85 74 7e 10 80 	mov    -0x7fef818c(,%eax,4),%edx
      state = "???";
80104782:	b8 a0 7d 10 80       	mov    $0x80107da0,%eax
80104787:	85 d2                	test   %edx,%edx
80104789:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010478c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010478f:	50                   	push   %eax
80104790:	52                   	push   %edx
80104791:	ff 73 10             	pushl  0x10(%ebx)
80104794:	68 a4 7d 10 80       	push   $0x80107da4
80104799:	e8 c2 be ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010479e:	83 c4 10             	add    $0x10,%esp
801047a1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801047a5:	75 a1                	jne    80104748 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047a7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047aa:	83 ec 08             	sub    $0x8,%esp
801047ad:	8d 7d c0             	lea    -0x40(%ebp),%edi
801047b0:	50                   	push   %eax
801047b1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801047b4:	8b 40 0c             	mov    0xc(%eax),%eax
801047b7:	83 c0 08             	add    $0x8,%eax
801047ba:	50                   	push   %eax
801047bb:	e8 a0 02 00 00       	call   80104a60 <getcallerpcs>
801047c0:	83 c4 10             	add    $0x10,%esp
801047c3:	90                   	nop
801047c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801047c8:	8b 17                	mov    (%edi),%edx
801047ca:	85 d2                	test   %edx,%edx
801047cc:	0f 84 76 ff ff ff    	je     80104748 <procdump+0x18>
        cprintf(" %p", pc[i]);
801047d2:	83 ec 08             	sub    $0x8,%esp
801047d5:	83 c7 04             	add    $0x4,%edi
801047d8:	52                   	push   %edx
801047d9:	68 e1 77 10 80       	push   $0x801077e1
801047de:	e8 7d be ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801047e3:	83 c4 10             	add    $0x10,%esp
801047e6:	39 fe                	cmp    %edi,%esi
801047e8:	75 de                	jne    801047c8 <procdump+0x98>
801047ea:	e9 59 ff ff ff       	jmp    80104748 <procdump+0x18>
801047ef:	90                   	nop
  }
}
801047f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047f3:	5b                   	pop    %ebx
801047f4:	5e                   	pop    %esi
801047f5:	5f                   	pop    %edi
801047f6:	5d                   	pop    %ebp
801047f7:	c3                   	ret    
801047f8:	90                   	nop
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <getpinfo>:

int
getpinfo(int pid)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	57                   	push   %edi
80104804:	56                   	push   %esi
80104805:	53                   	push   %ebx
  struct proc *p;
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104806:	bb 74 40 11 80       	mov    $0x80114074,%ebx
{
8010480b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
8010480e:	68 40 40 11 80       	push   $0x80114040
80104813:	e8 68 03 00 00       	call   80104b80 <acquire>
80104818:	83 c4 10             	add    $0x10,%esp
8010481b:	eb 15                	jmp    80104832 <getpinfo+0x32>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104820:	81 c3 64 5e 00 00    	add    $0x5e64,%ebx
80104826:	81 fb 74 d9 28 80    	cmp    $0x8028d974,%ebx
8010482c:	0f 83 c3 00 00 00    	jae    801048f5 <getpinfo+0xf5>
    if(p->state == UNUSED)
80104832:	8b 73 0c             	mov    0xc(%ebx),%esi
80104835:	85 f6                	test   %esi,%esi
80104837:	74 e7                	je     80104820 <getpinfo+0x20>
      continue;

    if (p->pid == pid) {
80104839:	8b 45 08             	mov    0x8(%ebp),%eax
8010483c:	39 43 10             	cmp    %eax,0x10(%ebx)
8010483f:	75 df                	jne    80104820 <getpinfo+0x20>
      cprintf("name = %s, pid = %d\n", p->name, p->pid);
80104841:	83 ec 04             	sub    $0x4,%esp
80104844:	50                   	push   %eax
80104845:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104848:	50                   	push   %eax
80104849:	68 ad 7d 10 80       	push   $0x80107dad
8010484e:	e8 0d be ff ff       	call   80100660 <cprintf>
      cprintf("wait_time = %d\n", p->wait_time);
80104853:	58                   	pop    %eax
80104854:	5a                   	pop    %edx
80104855:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
8010485b:	68 c2 7d 10 80       	push   $0x80107dc2
80104860:	e8 fb bd ff ff       	call   80100660 <cprintf>
      cprintf("ticks = {%d, %d, %d}\n", p->ticks[0], p->ticks[1], p->ticks[2]);
80104865:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
8010486b:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104871:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80104877:	68 d2 7d 10 80       	push   $0x80107dd2
8010487c:	e8 df bd ff ff       	call   80100660 <cprintf>
      cprintf("times = {%d, %d, %d}\n", p->times[0], p->times[1], p->times[2]);
80104881:	83 c4 20             	add    $0x20,%esp
80104884:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
8010488a:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104890:	ff 73 7c             	pushl  0x7c(%ebx)
80104893:	68 e8 7d 10 80       	push   $0x80107de8
80104898:	e8 c3 bd ff ff       	call   80100660 <cprintf>

      // for each stat
      //For each stat until num_of_stats
      for (int i = 0; i < p->num_stats_used; ++i) {
8010489d:	8b 8b a0 00 00 00    	mov    0xa0(%ebx),%ecx
801048a3:	83 c4 10             	add    $0x10,%esp
801048a6:	85 c9                	test   %ecx,%ecx
801048a8:	0f 8e 72 ff ff ff    	jle    80104820 <getpinfo+0x20>
801048ae:	8d b3 a8 00 00 00    	lea    0xa8(%ebx),%esi
801048b4:	31 ff                	xor    %edi,%edi
801048b6:	8d 76 00             	lea    0x0(%esi),%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          cprintf("start=%d, duration=%d, priority=%d\n",
801048c0:	ff 76 08             	pushl  0x8(%esi)
801048c3:	ff 76 04             	pushl  0x4(%esi)
      for (int i = 0; i < p->num_stats_used; ++i) {
801048c6:	83 c7 01             	add    $0x1,%edi
          cprintf("start=%d, duration=%d, priority=%d\n",
801048c9:	ff 36                	pushl  (%esi)
801048cb:	68 50 7e 10 80       	push   $0x80107e50
801048d0:	83 c6 10             	add    $0x10,%esi
801048d3:	e8 88 bd ff ff       	call   80100660 <cprintf>
      for (int i = 0; i < p->num_stats_used; ++i) {
801048d8:	83 c4 10             	add    $0x10,%esp
801048db:	39 bb a0 00 00 00    	cmp    %edi,0xa0(%ebx)
801048e1:	7f dd                	jg     801048c0 <getpinfo+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048e3:	81 c3 64 5e 00 00    	add    $0x5e64,%ebx
801048e9:	81 fb 74 d9 28 80    	cmp    $0x8028d974,%ebx
801048ef:	0f 82 3d ff ff ff    	jb     80104832 <getpinfo+0x32>
          p->sched_stats[i].start_tick,p->sched_stats[i].duration,p->sched_stats[i].priority);// from each valid item in sched_stats 
        }
    }
  }
  
  release(&ptable.lock);
801048f5:	83 ec 0c             	sub    $0xc,%esp
801048f8:	68 40 40 11 80       	push   $0x80114040
801048fd:	e8 3e 03 00 00       	call   80104c40 <release>
  return 0;
}
80104902:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104905:	31 c0                	xor    %eax,%eax
80104907:	5b                   	pop    %ebx
80104908:	5e                   	pop    %esi
80104909:	5f                   	pop    %edi
8010490a:	5d                   	pop    %ebp
8010490b:	c3                   	ret    
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010491a:	68 8c 7e 10 80       	push   $0x80107e8c
8010491f:	8d 43 04             	lea    0x4(%ebx),%eax
80104922:	50                   	push   %eax
80104923:	e8 18 01 00 00       	call   80104a40 <initlock>
  lk->name = name;
80104928:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010492b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104931:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104934:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010493b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010493e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104941:	c9                   	leave  
80104942:	c3                   	ret    
80104943:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
80104955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104958:	83 ec 0c             	sub    $0xc,%esp
8010495b:	8d 73 04             	lea    0x4(%ebx),%esi
8010495e:	56                   	push   %esi
8010495f:	e8 1c 02 00 00       	call   80104b80 <acquire>
  while (lk->locked) {
80104964:	8b 13                	mov    (%ebx),%edx
80104966:	83 c4 10             	add    $0x10,%esp
80104969:	85 d2                	test   %edx,%edx
8010496b:	74 16                	je     80104983 <acquiresleep+0x33>
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104970:	83 ec 08             	sub    $0x8,%esp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
80104975:	e8 16 fb ff ff       	call   80104490 <sleep>
  while (lk->locked) {
8010497a:	8b 03                	mov    (%ebx),%eax
8010497c:	83 c4 10             	add    $0x10,%esp
8010497f:	85 c0                	test   %eax,%eax
80104981:	75 ed                	jne    80104970 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104983:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104989:	e8 02 f1 ff ff       	call   80103a90 <myproc>
8010498e:	8b 40 10             	mov    0x10(%eax),%eax
80104991:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104994:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104997:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010499a:	5b                   	pop    %ebx
8010499b:	5e                   	pop    %esi
8010499c:	5d                   	pop    %ebp
  release(&lk->lk);
8010499d:	e9 9e 02 00 00       	jmp    80104c40 <release>
801049a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049b8:	83 ec 0c             	sub    $0xc,%esp
801049bb:	8d 73 04             	lea    0x4(%ebx),%esi
801049be:	56                   	push   %esi
801049bf:	e8 bc 01 00 00       	call   80104b80 <acquire>
  lk->locked = 0;
801049c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049d1:	89 1c 24             	mov    %ebx,(%esp)
801049d4:	e8 77 fc ff ff       	call   80104650 <wakeup>
  release(&lk->lk);
801049d9:	89 75 08             	mov    %esi,0x8(%ebp)
801049dc:	83 c4 10             	add    $0x10,%esp
}
801049df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049e2:	5b                   	pop    %ebx
801049e3:	5e                   	pop    %esi
801049e4:	5d                   	pop    %ebp
  release(&lk->lk);
801049e5:	e9 56 02 00 00       	jmp    80104c40 <release>
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	53                   	push   %ebx
801049f6:	31 ff                	xor    %edi,%edi
801049f8:	83 ec 18             	sub    $0x18,%esp
801049fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801049fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104a01:	56                   	push   %esi
80104a02:	e8 79 01 00 00       	call   80104b80 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a07:	8b 03                	mov    (%ebx),%eax
80104a09:	83 c4 10             	add    $0x10,%esp
80104a0c:	85 c0                	test   %eax,%eax
80104a0e:	74 13                	je     80104a23 <holdingsleep+0x33>
80104a10:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a13:	e8 78 f0 ff ff       	call   80103a90 <myproc>
80104a18:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a1b:	0f 94 c0             	sete   %al
80104a1e:	0f b6 c0             	movzbl %al,%eax
80104a21:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104a23:	83 ec 0c             	sub    $0xc,%esp
80104a26:	56                   	push   %esi
80104a27:	e8 14 02 00 00       	call   80104c40 <release>
  return r;
}
80104a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a2f:	89 f8                	mov    %edi,%eax
80104a31:	5b                   	pop    %ebx
80104a32:	5e                   	pop    %esi
80104a33:	5f                   	pop    %edi
80104a34:	5d                   	pop    %ebp
80104a35:	c3                   	ret    
80104a36:	66 90                	xchg   %ax,%ax
80104a38:	66 90                	xchg   %ax,%ax
80104a3a:	66 90                	xchg   %ax,%ax
80104a3c:	66 90                	xchg   %ax,%ax
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a59:	5d                   	pop    %ebp
80104a5a:	c3                   	ret    
80104a5b:	90                   	nop
80104a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a60:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a61:	31 d2                	xor    %edx,%edx
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a66:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a6c:	83 e8 08             	sub    $0x8,%eax
80104a6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a7c:	77 1a                	ja     80104a98 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a7e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a81:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a84:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a87:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a89:	83 fa 0a             	cmp    $0xa,%edx
80104a8c:	75 e2                	jne    80104a70 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a8e:	5b                   	pop    %ebx
80104a8f:	5d                   	pop    %ebp
80104a90:	c3                   	ret    
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a98:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a9b:	83 c1 28             	add    $0x28,%ecx
80104a9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104aa6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104aa9:	39 c1                	cmp    %eax,%ecx
80104aab:	75 f3                	jne    80104aa0 <getcallerpcs+0x40>
}
80104aad:	5b                   	pop    %ebx
80104aae:	5d                   	pop    %ebp
80104aaf:	c3                   	ret    

80104ab0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 04             	sub    $0x4,%esp
80104ab7:	9c                   	pushf  
80104ab8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ab9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104aba:	e8 31 ef ff ff       	call   801039f0 <mycpu>
80104abf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ac5:	85 c0                	test   %eax,%eax
80104ac7:	75 11                	jne    80104ada <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104ac9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104acf:	e8 1c ef ff ff       	call   801039f0 <mycpu>
80104ad4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104ada:	e8 11 ef ff ff       	call   801039f0 <mycpu>
80104adf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ae6:	83 c4 04             	add    $0x4,%esp
80104ae9:	5b                   	pop    %ebx
80104aea:	5d                   	pop    %ebp
80104aeb:	c3                   	ret    
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <popcli>:

void
popcli(void)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104af6:	9c                   	pushf  
80104af7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104af8:	f6 c4 02             	test   $0x2,%ah
80104afb:	75 35                	jne    80104b32 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104afd:	e8 ee ee ff ff       	call   801039f0 <mycpu>
80104b02:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b09:	78 34                	js     80104b3f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b0b:	e8 e0 ee ff ff       	call   801039f0 <mycpu>
80104b10:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b16:	85 d2                	test   %edx,%edx
80104b18:	74 06                	je     80104b20 <popcli+0x30>
    sti();
}
80104b1a:	c9                   	leave  
80104b1b:	c3                   	ret    
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b20:	e8 cb ee ff ff       	call   801039f0 <mycpu>
80104b25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b2b:	85 c0                	test   %eax,%eax
80104b2d:	74 eb                	je     80104b1a <popcli+0x2a>
  asm volatile("sti");
80104b2f:	fb                   	sti    
}
80104b30:	c9                   	leave  
80104b31:	c3                   	ret    
    panic("popcli - interruptible");
80104b32:	83 ec 0c             	sub    $0xc,%esp
80104b35:	68 97 7e 10 80       	push   $0x80107e97
80104b3a:	e8 51 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b3f:	83 ec 0c             	sub    $0xc,%esp
80104b42:	68 ae 7e 10 80       	push   $0x80107eae
80104b47:	e8 44 b8 ff ff       	call   80100390 <panic>
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <holding>:
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
80104b55:	8b 75 08             	mov    0x8(%ebp),%esi
80104b58:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b5a:	e8 51 ff ff ff       	call   80104ab0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b5f:	8b 06                	mov    (%esi),%eax
80104b61:	85 c0                	test   %eax,%eax
80104b63:	74 10                	je     80104b75 <holding+0x25>
80104b65:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b68:	e8 83 ee ff ff       	call   801039f0 <mycpu>
80104b6d:	39 c3                	cmp    %eax,%ebx
80104b6f:	0f 94 c3             	sete   %bl
80104b72:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104b75:	e8 76 ff ff ff       	call   80104af0 <popcli>
}
80104b7a:	89 d8                	mov    %ebx,%eax
80104b7c:	5b                   	pop    %ebx
80104b7d:	5e                   	pop    %esi
80104b7e:	5d                   	pop    %ebp
80104b7f:	c3                   	ret    

80104b80 <acquire>:
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b85:	e8 26 ff ff ff       	call   80104ab0 <pushcli>
  if(holding(lk))
80104b8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b8d:	83 ec 0c             	sub    $0xc,%esp
80104b90:	53                   	push   %ebx
80104b91:	e8 ba ff ff ff       	call   80104b50 <holding>
80104b96:	83 c4 10             	add    $0x10,%esp
80104b99:	85 c0                	test   %eax,%eax
80104b9b:	0f 85 83 00 00 00    	jne    80104c24 <acquire+0xa4>
80104ba1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104ba3:	ba 01 00 00 00       	mov    $0x1,%edx
80104ba8:	eb 09                	jmp    80104bb3 <acquire+0x33>
80104baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bb3:	89 d0                	mov    %edx,%eax
80104bb5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104bb8:	85 c0                	test   %eax,%eax
80104bba:	75 f4                	jne    80104bb0 <acquire+0x30>
  __sync_synchronize();
80104bbc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104bc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bc4:	e8 27 ee ff ff       	call   801039f0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104bc9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104bcc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104bcf:	89 e8                	mov    %ebp,%eax
80104bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bd8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104bde:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104be4:	77 1a                	ja     80104c00 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104be6:	8b 48 04             	mov    0x4(%eax),%ecx
80104be9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104bec:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104bef:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bf1:	83 fe 0a             	cmp    $0xa,%esi
80104bf4:	75 e2                	jne    80104bd8 <acquire+0x58>
}
80104bf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5d                   	pop    %ebp
80104bfc:	c3                   	ret    
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi
80104c00:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104c03:	83 c2 28             	add    $0x28,%edx
80104c06:	8d 76 00             	lea    0x0(%esi),%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c16:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c19:	39 d0                	cmp    %edx,%eax
80104c1b:	75 f3                	jne    80104c10 <acquire+0x90>
}
80104c1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c20:	5b                   	pop    %ebx
80104c21:	5e                   	pop    %esi
80104c22:	5d                   	pop    %ebp
80104c23:	c3                   	ret    
    panic("acquire");
80104c24:	83 ec 0c             	sub    $0xc,%esp
80104c27:	68 b5 7e 10 80       	push   $0x80107eb5
80104c2c:	e8 5f b7 ff ff       	call   80100390 <panic>
80104c31:	eb 0d                	jmp    80104c40 <release>
80104c33:	90                   	nop
80104c34:	90                   	nop
80104c35:	90                   	nop
80104c36:	90                   	nop
80104c37:	90                   	nop
80104c38:	90                   	nop
80104c39:	90                   	nop
80104c3a:	90                   	nop
80104c3b:	90                   	nop
80104c3c:	90                   	nop
80104c3d:	90                   	nop
80104c3e:	90                   	nop
80104c3f:	90                   	nop

80104c40 <release>:
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	53                   	push   %ebx
80104c44:	83 ec 10             	sub    $0x10,%esp
80104c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c4a:	53                   	push   %ebx
80104c4b:	e8 00 ff ff ff       	call   80104b50 <holding>
80104c50:	83 c4 10             	add    $0x10,%esp
80104c53:	85 c0                	test   %eax,%eax
80104c55:	74 22                	je     80104c79 <release+0x39>
  lk->pcs[0] = 0;
80104c57:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c5e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c65:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c6a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c73:	c9                   	leave  
  popcli();
80104c74:	e9 77 fe ff ff       	jmp    80104af0 <popcli>
    panic("release");
80104c79:	83 ec 0c             	sub    $0xc,%esp
80104c7c:	68 bd 7e 10 80       	push   $0x80107ebd
80104c81:	e8 0a b7 ff ff       	call   80100390 <panic>
80104c86:	66 90                	xchg   %ax,%ax
80104c88:	66 90                	xchg   %ax,%ax
80104c8a:	66 90                	xchg   %ax,%ax
80104c8c:	66 90                	xchg   %ax,%ax
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	53                   	push   %ebx
80104c95:	8b 55 08             	mov    0x8(%ebp),%edx
80104c98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c9b:	f6 c2 03             	test   $0x3,%dl
80104c9e:	75 05                	jne    80104ca5 <memset+0x15>
80104ca0:	f6 c1 03             	test   $0x3,%cl
80104ca3:	74 13                	je     80104cb8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ca5:	89 d7                	mov    %edx,%edi
80104ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104caa:	fc                   	cld    
80104cab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cad:	5b                   	pop    %ebx
80104cae:	89 d0                	mov    %edx,%eax
80104cb0:	5f                   	pop    %edi
80104cb1:	5d                   	pop    %ebp
80104cb2:	c3                   	ret    
80104cb3:	90                   	nop
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104cb8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cbc:	c1 e9 02             	shr    $0x2,%ecx
80104cbf:	89 f8                	mov    %edi,%eax
80104cc1:	89 fb                	mov    %edi,%ebx
80104cc3:	c1 e0 18             	shl    $0x18,%eax
80104cc6:	c1 e3 10             	shl    $0x10,%ebx
80104cc9:	09 d8                	or     %ebx,%eax
80104ccb:	09 f8                	or     %edi,%eax
80104ccd:	c1 e7 08             	shl    $0x8,%edi
80104cd0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104cd2:	89 d7                	mov    %edx,%edi
80104cd4:	fc                   	cld    
80104cd5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104cd7:	5b                   	pop    %ebx
80104cd8:	89 d0                	mov    %edx,%eax
80104cda:	5f                   	pop    %edi
80104cdb:	5d                   	pop    %ebp
80104cdc:	c3                   	ret    
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi

80104ce0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
80104ce5:	53                   	push   %ebx
80104ce6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ce9:	8b 75 08             	mov    0x8(%ebp),%esi
80104cec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104cef:	85 db                	test   %ebx,%ebx
80104cf1:	74 29                	je     80104d1c <memcmp+0x3c>
    if(*s1 != *s2)
80104cf3:	0f b6 16             	movzbl (%esi),%edx
80104cf6:	0f b6 0f             	movzbl (%edi),%ecx
80104cf9:	38 d1                	cmp    %dl,%cl
80104cfb:	75 2b                	jne    80104d28 <memcmp+0x48>
80104cfd:	b8 01 00 00 00       	mov    $0x1,%eax
80104d02:	eb 14                	jmp    80104d18 <memcmp+0x38>
80104d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d08:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d0c:	83 c0 01             	add    $0x1,%eax
80104d0f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d14:	38 ca                	cmp    %cl,%dl
80104d16:	75 10                	jne    80104d28 <memcmp+0x48>
  while(n-- > 0){
80104d18:	39 d8                	cmp    %ebx,%eax
80104d1a:	75 ec                	jne    80104d08 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d1c:	5b                   	pop    %ebx
  return 0;
80104d1d:	31 c0                	xor    %eax,%eax
}
80104d1f:	5e                   	pop    %esi
80104d20:	5f                   	pop    %edi
80104d21:	5d                   	pop    %ebp
80104d22:	c3                   	ret    
80104d23:	90                   	nop
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d28:	0f b6 c2             	movzbl %dl,%eax
}
80104d2b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d2c:	29 c8                	sub    %ecx,%eax
}
80104d2e:	5e                   	pop    %esi
80104d2f:	5f                   	pop    %edi
80104d30:	5d                   	pop    %ebp
80104d31:	c3                   	ret    
80104d32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 45 08             	mov    0x8(%ebp),%eax
80104d48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d4b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d4e:	39 c3                	cmp    %eax,%ebx
80104d50:	73 26                	jae    80104d78 <memmove+0x38>
80104d52:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104d55:	39 c8                	cmp    %ecx,%eax
80104d57:	73 1f                	jae    80104d78 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104d59:	85 f6                	test   %esi,%esi
80104d5b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104d5e:	74 0f                	je     80104d6f <memmove+0x2f>
      *--d = *--s;
80104d60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104d67:	83 ea 01             	sub    $0x1,%edx
80104d6a:	83 fa ff             	cmp    $0xffffffff,%edx
80104d6d:	75 f1                	jne    80104d60 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d6f:	5b                   	pop    %ebx
80104d70:	5e                   	pop    %esi
80104d71:	5d                   	pop    %ebp
80104d72:	c3                   	ret    
80104d73:	90                   	nop
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104d78:	31 d2                	xor    %edx,%edx
80104d7a:	85 f6                	test   %esi,%esi
80104d7c:	74 f1                	je     80104d6f <memmove+0x2f>
80104d7e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104d80:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d84:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d87:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104d8a:	39 d6                	cmp    %edx,%esi
80104d8c:	75 f2                	jne    80104d80 <memmove+0x40>
}
80104d8e:	5b                   	pop    %ebx
80104d8f:	5e                   	pop    %esi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    
80104d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104da3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104da4:	eb 9a                	jmp    80104d40 <memmove>
80104da6:	8d 76 00             	lea    0x0(%esi),%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	57                   	push   %edi
80104db4:	56                   	push   %esi
80104db5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104db8:	53                   	push   %ebx
80104db9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104dbf:	85 ff                	test   %edi,%edi
80104dc1:	74 2f                	je     80104df2 <strncmp+0x42>
80104dc3:	0f b6 01             	movzbl (%ecx),%eax
80104dc6:	0f b6 1e             	movzbl (%esi),%ebx
80104dc9:	84 c0                	test   %al,%al
80104dcb:	74 37                	je     80104e04 <strncmp+0x54>
80104dcd:	38 c3                	cmp    %al,%bl
80104dcf:	75 33                	jne    80104e04 <strncmp+0x54>
80104dd1:	01 f7                	add    %esi,%edi
80104dd3:	eb 13                	jmp    80104de8 <strncmp+0x38>
80104dd5:	8d 76 00             	lea    0x0(%esi),%esi
80104dd8:	0f b6 01             	movzbl (%ecx),%eax
80104ddb:	84 c0                	test   %al,%al
80104ddd:	74 21                	je     80104e00 <strncmp+0x50>
80104ddf:	0f b6 1a             	movzbl (%edx),%ebx
80104de2:	89 d6                	mov    %edx,%esi
80104de4:	38 d8                	cmp    %bl,%al
80104de6:	75 1c                	jne    80104e04 <strncmp+0x54>
    n--, p++, q++;
80104de8:	8d 56 01             	lea    0x1(%esi),%edx
80104deb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104dee:	39 fa                	cmp    %edi,%edx
80104df0:	75 e6                	jne    80104dd8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104df2:	5b                   	pop    %ebx
    return 0;
80104df3:	31 c0                	xor    %eax,%eax
}
80104df5:	5e                   	pop    %esi
80104df6:	5f                   	pop    %edi
80104df7:	5d                   	pop    %ebp
80104df8:	c3                   	ret    
80104df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e00:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e04:	29 d8                	sub    %ebx,%eax
}
80104e06:	5b                   	pop    %ebx
80104e07:	5e                   	pop    %esi
80104e08:	5f                   	pop    %edi
80104e09:	5d                   	pop    %ebp
80104e0a:	c3                   	ret    
80104e0b:	90                   	nop
80104e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	53                   	push   %ebx
80104e15:	8b 45 08             	mov    0x8(%ebp),%eax
80104e18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e1e:	89 c2                	mov    %eax,%edx
80104e20:	eb 19                	jmp    80104e3b <strncpy+0x2b>
80104e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e28:	83 c3 01             	add    $0x1,%ebx
80104e2b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e2f:	83 c2 01             	add    $0x1,%edx
80104e32:	84 c9                	test   %cl,%cl
80104e34:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e37:	74 09                	je     80104e42 <strncpy+0x32>
80104e39:	89 f1                	mov    %esi,%ecx
80104e3b:	85 c9                	test   %ecx,%ecx
80104e3d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e40:	7f e6                	jg     80104e28 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e42:	31 c9                	xor    %ecx,%ecx
80104e44:	85 f6                	test   %esi,%esi
80104e46:	7e 17                	jle    80104e5f <strncpy+0x4f>
80104e48:	90                   	nop
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e50:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e54:	89 f3                	mov    %esi,%ebx
80104e56:	83 c1 01             	add    $0x1,%ecx
80104e59:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104e5b:	85 db                	test   %ebx,%ebx
80104e5d:	7f f1                	jg     80104e50 <strncpy+0x40>
  return os;
}
80104e5f:	5b                   	pop    %ebx
80104e60:	5e                   	pop    %esi
80104e61:	5d                   	pop    %ebp
80104e62:	c3                   	ret    
80104e63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
80104e75:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e78:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104e7e:	85 c9                	test   %ecx,%ecx
80104e80:	7e 26                	jle    80104ea8 <safestrcpy+0x38>
80104e82:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e86:	89 c1                	mov    %eax,%ecx
80104e88:	eb 17                	jmp    80104ea1 <safestrcpy+0x31>
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e90:	83 c2 01             	add    $0x1,%edx
80104e93:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e97:	83 c1 01             	add    $0x1,%ecx
80104e9a:	84 db                	test   %bl,%bl
80104e9c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e9f:	74 04                	je     80104ea5 <safestrcpy+0x35>
80104ea1:	39 f2                	cmp    %esi,%edx
80104ea3:	75 eb                	jne    80104e90 <safestrcpy+0x20>
    ;
  *s = 0;
80104ea5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ea8:	5b                   	pop    %ebx
80104ea9:	5e                   	pop    %esi
80104eaa:	5d                   	pop    %ebp
80104eab:	c3                   	ret    
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <strlen>:

int
strlen(const char *s)
{
80104eb0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104eb1:	31 c0                	xor    %eax,%eax
{
80104eb3:	89 e5                	mov    %esp,%ebp
80104eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104eb8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ebb:	74 0c                	je     80104ec9 <strlen+0x19>
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
80104ec0:	83 c0 01             	add    $0x1,%eax
80104ec3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ec7:	75 f7                	jne    80104ec0 <strlen+0x10>
    ;
  return n;
}
80104ec9:	5d                   	pop    %ebp
80104eca:	c3                   	ret    

80104ecb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ecb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ecf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ed3:	55                   	push   %ebp
  pushl %ebx
80104ed4:	53                   	push   %ebx
  pushl %esi
80104ed5:	56                   	push   %esi
  pushl %edi
80104ed6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ed7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ed9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104edb:	5f                   	pop    %edi
  popl %esi
80104edc:	5e                   	pop    %esi
  popl %ebx
80104edd:	5b                   	pop    %ebx
  popl %ebp
80104ede:	5d                   	pop    %ebp
  ret
80104edf:	c3                   	ret    

80104ee0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
80104ee4:	83 ec 04             	sub    $0x4,%esp
80104ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104eea:	e8 a1 eb ff ff       	call   80103a90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eef:	8b 00                	mov    (%eax),%eax
80104ef1:	39 d8                	cmp    %ebx,%eax
80104ef3:	76 1b                	jbe    80104f10 <fetchint+0x30>
80104ef5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ef8:	39 d0                	cmp    %edx,%eax
80104efa:	72 14                	jb     80104f10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104efc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eff:	8b 13                	mov    (%ebx),%edx
80104f01:	89 10                	mov    %edx,(%eax)
  return 0;
80104f03:	31 c0                	xor    %eax,%eax
}
80104f05:	83 c4 04             	add    $0x4,%esp
80104f08:	5b                   	pop    %ebx
80104f09:	5d                   	pop    %ebp
80104f0a:	c3                   	ret    
80104f0b:	90                   	nop
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f15:	eb ee                	jmp    80104f05 <fetchint+0x25>
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 04             	sub    $0x4,%esp
80104f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f2a:	e8 61 eb ff ff       	call   80103a90 <myproc>

  if(addr >= curproc->sz)
80104f2f:	39 18                	cmp    %ebx,(%eax)
80104f31:	76 29                	jbe    80104f5c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f36:	89 da                	mov    %ebx,%edx
80104f38:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f3a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f3c:	39 c3                	cmp    %eax,%ebx
80104f3e:	73 1c                	jae    80104f5c <fetchstr+0x3c>
    if(*s == 0)
80104f40:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f43:	75 10                	jne    80104f55 <fetchstr+0x35>
80104f45:	eb 39                	jmp    80104f80 <fetchstr+0x60>
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f50:	80 3a 00             	cmpb   $0x0,(%edx)
80104f53:	74 1b                	je     80104f70 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104f55:	83 c2 01             	add    $0x1,%edx
80104f58:	39 d0                	cmp    %edx,%eax
80104f5a:	77 f4                	ja     80104f50 <fetchstr+0x30>
    return -1;
80104f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104f61:	83 c4 04             	add    $0x4,%esp
80104f64:	5b                   	pop    %ebx
80104f65:	5d                   	pop    %ebp
80104f66:	c3                   	ret    
80104f67:	89 f6                	mov    %esi,%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f70:	83 c4 04             	add    $0x4,%esp
80104f73:	89 d0                	mov    %edx,%eax
80104f75:	29 d8                	sub    %ebx,%eax
80104f77:	5b                   	pop    %ebx
80104f78:	5d                   	pop    %ebp
80104f79:	c3                   	ret    
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104f80:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104f82:	eb dd                	jmp    80104f61 <fetchstr+0x41>
80104f84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f95:	e8 f6 ea ff ff       	call   80103a90 <myproc>
80104f9a:	8b 40 18             	mov    0x18(%eax),%eax
80104f9d:	8b 55 08             	mov    0x8(%ebp),%edx
80104fa0:	8b 40 44             	mov    0x44(%eax),%eax
80104fa3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fa6:	e8 e5 ea ff ff       	call   80103a90 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fab:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fad:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fb0:	39 c6                	cmp    %eax,%esi
80104fb2:	73 1c                	jae    80104fd0 <argint+0x40>
80104fb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fb7:	39 d0                	cmp    %edx,%eax
80104fb9:	72 15                	jb     80104fd0 <argint+0x40>
  *ip = *(int*)(addr);
80104fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fbe:	8b 53 04             	mov    0x4(%ebx),%edx
80104fc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fc3:	31 c0                	xor    %eax,%eax
}
80104fc5:	5b                   	pop    %ebx
80104fc6:	5e                   	pop    %esi
80104fc7:	5d                   	pop    %ebp
80104fc8:	c3                   	ret    
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fd5:	eb ee                	jmp    80104fc5 <argint+0x35>
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
80104fe5:	83 ec 10             	sub    $0x10,%esp
80104fe8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104feb:	e8 a0 ea ff ff       	call   80103a90 <myproc>
80104ff0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ff2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ff5:	83 ec 08             	sub    $0x8,%esp
80104ff8:	50                   	push   %eax
80104ff9:	ff 75 08             	pushl  0x8(%ebp)
80104ffc:	e8 8f ff ff ff       	call   80104f90 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105001:	83 c4 10             	add    $0x10,%esp
80105004:	85 c0                	test   %eax,%eax
80105006:	78 28                	js     80105030 <argptr+0x50>
80105008:	85 db                	test   %ebx,%ebx
8010500a:	78 24                	js     80105030 <argptr+0x50>
8010500c:	8b 16                	mov    (%esi),%edx
8010500e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105011:	39 c2                	cmp    %eax,%edx
80105013:	76 1b                	jbe    80105030 <argptr+0x50>
80105015:	01 c3                	add    %eax,%ebx
80105017:	39 da                	cmp    %ebx,%edx
80105019:	72 15                	jb     80105030 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010501b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010501e:	89 02                	mov    %eax,(%edx)
  return 0;
80105020:	31 c0                	xor    %eax,%eax
}
80105022:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105025:	5b                   	pop    %ebx
80105026:	5e                   	pop    %esi
80105027:	5d                   	pop    %ebp
80105028:	c3                   	ret    
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	eb eb                	jmp    80105022 <argptr+0x42>
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105046:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105049:	50                   	push   %eax
8010504a:	ff 75 08             	pushl  0x8(%ebp)
8010504d:	e8 3e ff ff ff       	call   80104f90 <argint>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	85 c0                	test   %eax,%eax
80105057:	78 17                	js     80105070 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105059:	83 ec 08             	sub    $0x8,%esp
8010505c:	ff 75 0c             	pushl  0xc(%ebp)
8010505f:	ff 75 f4             	pushl  -0xc(%ebp)
80105062:	e8 b9 fe ff ff       	call   80104f20 <fetchstr>
80105067:	83 c4 10             	add    $0x10,%esp
}
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105075:	c9                   	leave  
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <syscall>:
[SYS_getpinfo] sys_getpinfo
};

void
syscall(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	53                   	push   %ebx
80105084:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105087:	e8 04 ea ff ff       	call   80103a90 <myproc>
8010508c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010508e:	8b 40 18             	mov    0x18(%eax),%eax
80105091:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105094:	8d 50 ff             	lea    -0x1(%eax),%edx
80105097:	83 fa 15             	cmp    $0x15,%edx
8010509a:	77 1c                	ja     801050b8 <syscall+0x38>
8010509c:	8b 14 85 00 7f 10 80 	mov    -0x7fef8100(,%eax,4),%edx
801050a3:	85 d2                	test   %edx,%edx
801050a5:	74 11                	je     801050b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050a7:	ff d2                	call   *%edx
801050a9:	8b 53 18             	mov    0x18(%ebx),%edx
801050ac:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050b2:	c9                   	leave  
801050b3:	c3                   	ret    
801050b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050bc:	50                   	push   %eax
801050bd:	ff 73 10             	pushl  0x10(%ebx)
801050c0:	68 c5 7e 10 80       	push   $0x80107ec5
801050c5:	e8 96 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801050ca:	8b 43 18             	mov    0x18(%ebx),%eax
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801050d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050da:	c9                   	leave  
801050db:	c3                   	ret    
801050dc:	66 90                	xchg   %ax,%ax
801050de:	66 90                	xchg   %ax,%ax

801050e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
801050e5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801050e6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801050e9:	83 ec 34             	sub    $0x34,%esp
801050ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801050ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801050f2:	56                   	push   %esi
801050f3:	50                   	push   %eax
{
801050f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801050f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801050fa:	e8 01 ce ff ff       	call   80101f00 <nameiparent>
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	85 c0                	test   %eax,%eax
80105104:	0f 84 46 01 00 00    	je     80105250 <create+0x170>
    return 0;
  ilock(dp);
8010510a:	83 ec 0c             	sub    $0xc,%esp
8010510d:	89 c3                	mov    %eax,%ebx
8010510f:	50                   	push   %eax
80105110:	e8 6b c5 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105115:	83 c4 0c             	add    $0xc,%esp
80105118:	6a 00                	push   $0x0
8010511a:	56                   	push   %esi
8010511b:	53                   	push   %ebx
8010511c:	e8 8f ca ff ff       	call   80101bb0 <dirlookup>
80105121:	83 c4 10             	add    $0x10,%esp
80105124:	85 c0                	test   %eax,%eax
80105126:	89 c7                	mov    %eax,%edi
80105128:	74 36                	je     80105160 <create+0x80>
    iunlockput(dp);
8010512a:	83 ec 0c             	sub    $0xc,%esp
8010512d:	53                   	push   %ebx
8010512e:	e8 dd c7 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105133:	89 3c 24             	mov    %edi,(%esp)
80105136:	e8 45 c5 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010513b:	83 c4 10             	add    $0x10,%esp
8010513e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105143:	0f 85 97 00 00 00    	jne    801051e0 <create+0x100>
80105149:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010514e:	0f 85 8c 00 00 00    	jne    801051e0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105157:	89 f8                	mov    %edi,%eax
80105159:	5b                   	pop    %ebx
8010515a:	5e                   	pop    %esi
8010515b:	5f                   	pop    %edi
8010515c:	5d                   	pop    %ebp
8010515d:	c3                   	ret    
8010515e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105160:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105164:	83 ec 08             	sub    $0x8,%esp
80105167:	50                   	push   %eax
80105168:	ff 33                	pushl  (%ebx)
8010516a:	e8 a1 c3 ff ff       	call   80101510 <ialloc>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	85 c0                	test   %eax,%eax
80105174:	89 c7                	mov    %eax,%edi
80105176:	0f 84 e8 00 00 00    	je     80105264 <create+0x184>
  ilock(ip);
8010517c:	83 ec 0c             	sub    $0xc,%esp
8010517f:	50                   	push   %eax
80105180:	e8 fb c4 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105185:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105189:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010518d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105191:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105195:	b8 01 00 00 00       	mov    $0x1,%eax
8010519a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010519e:	89 3c 24             	mov    %edi,(%esp)
801051a1:	e8 2a c4 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801051a6:	83 c4 10             	add    $0x10,%esp
801051a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801051ae:	74 50                	je     80105200 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801051b0:	83 ec 04             	sub    $0x4,%esp
801051b3:	ff 77 04             	pushl  0x4(%edi)
801051b6:	56                   	push   %esi
801051b7:	53                   	push   %ebx
801051b8:	e8 63 cc ff ff       	call   80101e20 <dirlink>
801051bd:	83 c4 10             	add    $0x10,%esp
801051c0:	85 c0                	test   %eax,%eax
801051c2:	0f 88 8f 00 00 00    	js     80105257 <create+0x177>
  iunlockput(dp);
801051c8:	83 ec 0c             	sub    $0xc,%esp
801051cb:	53                   	push   %ebx
801051cc:	e8 3f c7 ff ff       	call   80101910 <iunlockput>
  return ip;
801051d1:	83 c4 10             	add    $0x10,%esp
}
801051d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051d7:	89 f8                	mov    %edi,%eax
801051d9:	5b                   	pop    %ebx
801051da:	5e                   	pop    %esi
801051db:	5f                   	pop    %edi
801051dc:	5d                   	pop    %ebp
801051dd:	c3                   	ret    
801051de:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	57                   	push   %edi
    return 0;
801051e4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801051e6:	e8 25 c7 ff ff       	call   80101910 <iunlockput>
    return 0;
801051eb:	83 c4 10             	add    $0x10,%esp
}
801051ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051f1:	89 f8                	mov    %edi,%eax
801051f3:	5b                   	pop    %ebx
801051f4:	5e                   	pop    %esi
801051f5:	5f                   	pop    %edi
801051f6:	5d                   	pop    %ebp
801051f7:	c3                   	ret    
801051f8:	90                   	nop
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105200:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105205:	83 ec 0c             	sub    $0xc,%esp
80105208:	53                   	push   %ebx
80105209:	e8 c2 c3 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010520e:	83 c4 0c             	add    $0xc,%esp
80105211:	ff 77 04             	pushl  0x4(%edi)
80105214:	68 78 7f 10 80       	push   $0x80107f78
80105219:	57                   	push   %edi
8010521a:	e8 01 cc ff ff       	call   80101e20 <dirlink>
8010521f:	83 c4 10             	add    $0x10,%esp
80105222:	85 c0                	test   %eax,%eax
80105224:	78 1c                	js     80105242 <create+0x162>
80105226:	83 ec 04             	sub    $0x4,%esp
80105229:	ff 73 04             	pushl  0x4(%ebx)
8010522c:	68 77 7f 10 80       	push   $0x80107f77
80105231:	57                   	push   %edi
80105232:	e8 e9 cb ff ff       	call   80101e20 <dirlink>
80105237:	83 c4 10             	add    $0x10,%esp
8010523a:	85 c0                	test   %eax,%eax
8010523c:	0f 89 6e ff ff ff    	jns    801051b0 <create+0xd0>
      panic("create dots");
80105242:	83 ec 0c             	sub    $0xc,%esp
80105245:	68 6b 7f 10 80       	push   $0x80107f6b
8010524a:	e8 41 b1 ff ff       	call   80100390 <panic>
8010524f:	90                   	nop
    return 0;
80105250:	31 ff                	xor    %edi,%edi
80105252:	e9 fd fe ff ff       	jmp    80105154 <create+0x74>
    panic("create: dirlink");
80105257:	83 ec 0c             	sub    $0xc,%esp
8010525a:	68 7a 7f 10 80       	push   $0x80107f7a
8010525f:	e8 2c b1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	68 5c 7f 10 80       	push   $0x80107f5c
8010526c:	e8 1f b1 ff ff       	call   80100390 <panic>
80105271:	eb 0d                	jmp    80105280 <argfd.constprop.0>
80105273:	90                   	nop
80105274:	90                   	nop
80105275:	90                   	nop
80105276:	90                   	nop
80105277:	90                   	nop
80105278:	90                   	nop
80105279:	90                   	nop
8010527a:	90                   	nop
8010527b:	90                   	nop
8010527c:	90                   	nop
8010527d:	90                   	nop
8010527e:	90                   	nop
8010527f:	90                   	nop

80105280 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	56                   	push   %esi
80105284:	53                   	push   %ebx
80105285:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105287:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010528a:	89 d6                	mov    %edx,%esi
8010528c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010528f:	50                   	push   %eax
80105290:	6a 00                	push   $0x0
80105292:	e8 f9 fc ff ff       	call   80104f90 <argint>
80105297:	83 c4 10             	add    $0x10,%esp
8010529a:	85 c0                	test   %eax,%eax
8010529c:	78 2a                	js     801052c8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010529e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052a2:	77 24                	ja     801052c8 <argfd.constprop.0+0x48>
801052a4:	e8 e7 e7 ff ff       	call   80103a90 <myproc>
801052a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801052b0:	85 c0                	test   %eax,%eax
801052b2:	74 14                	je     801052c8 <argfd.constprop.0+0x48>
  if(pfd)
801052b4:	85 db                	test   %ebx,%ebx
801052b6:	74 02                	je     801052ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801052b8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801052ba:	89 06                	mov    %eax,(%esi)
  return 0;
801052bc:	31 c0                	xor    %eax,%eax
}
801052be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c1:	5b                   	pop    %ebx
801052c2:	5e                   	pop    %esi
801052c3:	5d                   	pop    %ebp
801052c4:	c3                   	ret    
801052c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052cd:	eb ef                	jmp    801052be <argfd.constprop.0+0x3e>
801052cf:	90                   	nop

801052d0 <sys_dup>:
{
801052d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801052d1:	31 c0                	xor    %eax,%eax
{
801052d3:	89 e5                	mov    %esp,%ebp
801052d5:	56                   	push   %esi
801052d6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801052d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801052da:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801052dd:	e8 9e ff ff ff       	call   80105280 <argfd.constprop.0>
801052e2:	85 c0                	test   %eax,%eax
801052e4:	78 42                	js     80105328 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801052e6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801052e9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801052eb:	e8 a0 e7 ff ff       	call   80103a90 <myproc>
801052f0:	eb 0e                	jmp    80105300 <sys_dup+0x30>
801052f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801052f8:	83 c3 01             	add    $0x1,%ebx
801052fb:	83 fb 10             	cmp    $0x10,%ebx
801052fe:	74 28                	je     80105328 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105300:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105304:	85 d2                	test   %edx,%edx
80105306:	75 f0                	jne    801052f8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105308:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	ff 75 f4             	pushl  -0xc(%ebp)
80105312:	e8 d9 ba ff ff       	call   80100df0 <filedup>
  return fd;
80105317:	83 c4 10             	add    $0x10,%esp
}
8010531a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010531d:	89 d8                	mov    %ebx,%eax
8010531f:	5b                   	pop    %ebx
80105320:	5e                   	pop    %esi
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret    
80105323:	90                   	nop
80105324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105328:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010532b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105330:	89 d8                	mov    %ebx,%eax
80105332:	5b                   	pop    %ebx
80105333:	5e                   	pop    %esi
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d 76 00             	lea    0x0(%esi),%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_read>:
{
80105340:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105341:	31 c0                	xor    %eax,%eax
{
80105343:	89 e5                	mov    %esp,%ebp
80105345:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105348:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010534b:	e8 30 ff ff ff       	call   80105280 <argfd.constprop.0>
80105350:	85 c0                	test   %eax,%eax
80105352:	78 4c                	js     801053a0 <sys_read+0x60>
80105354:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105357:	83 ec 08             	sub    $0x8,%esp
8010535a:	50                   	push   %eax
8010535b:	6a 02                	push   $0x2
8010535d:	e8 2e fc ff ff       	call   80104f90 <argint>
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	85 c0                	test   %eax,%eax
80105367:	78 37                	js     801053a0 <sys_read+0x60>
80105369:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536c:	83 ec 04             	sub    $0x4,%esp
8010536f:	ff 75 f0             	pushl  -0x10(%ebp)
80105372:	50                   	push   %eax
80105373:	6a 01                	push   $0x1
80105375:	e8 66 fc ff ff       	call   80104fe0 <argptr>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	85 c0                	test   %eax,%eax
8010537f:	78 1f                	js     801053a0 <sys_read+0x60>
  return fileread(f, p, n);
80105381:	83 ec 04             	sub    $0x4,%esp
80105384:	ff 75 f0             	pushl  -0x10(%ebp)
80105387:	ff 75 f4             	pushl  -0xc(%ebp)
8010538a:	ff 75 ec             	pushl  -0x14(%ebp)
8010538d:	e8 ce bb ff ff       	call   80100f60 <fileread>
80105392:	83 c4 10             	add    $0x10,%esp
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053a5:	c9                   	leave  
801053a6:	c3                   	ret    
801053a7:	89 f6                	mov    %esi,%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <sys_write>:
{
801053b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053b1:	31 c0                	xor    %eax,%eax
{
801053b3:	89 e5                	mov    %esp,%ebp
801053b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053bb:	e8 c0 fe ff ff       	call   80105280 <argfd.constprop.0>
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 4c                	js     80105410 <sys_write+0x60>
801053c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c7:	83 ec 08             	sub    $0x8,%esp
801053ca:	50                   	push   %eax
801053cb:	6a 02                	push   $0x2
801053cd:	e8 be fb ff ff       	call   80104f90 <argint>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	85 c0                	test   %eax,%eax
801053d7:	78 37                	js     80105410 <sys_write+0x60>
801053d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053dc:	83 ec 04             	sub    $0x4,%esp
801053df:	ff 75 f0             	pushl  -0x10(%ebp)
801053e2:	50                   	push   %eax
801053e3:	6a 01                	push   $0x1
801053e5:	e8 f6 fb ff ff       	call   80104fe0 <argptr>
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	85 c0                	test   %eax,%eax
801053ef:	78 1f                	js     80105410 <sys_write+0x60>
  return filewrite(f, p, n);
801053f1:	83 ec 04             	sub    $0x4,%esp
801053f4:	ff 75 f0             	pushl  -0x10(%ebp)
801053f7:	ff 75 f4             	pushl  -0xc(%ebp)
801053fa:	ff 75 ec             	pushl  -0x14(%ebp)
801053fd:	e8 ee bb ff ff       	call   80100ff0 <filewrite>
80105402:	83 c4 10             	add    $0x10,%esp
}
80105405:	c9                   	leave  
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105415:	c9                   	leave  
80105416:	c3                   	ret    
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <sys_close>:
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105426:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105429:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010542c:	e8 4f fe ff ff       	call   80105280 <argfd.constprop.0>
80105431:	85 c0                	test   %eax,%eax
80105433:	78 2b                	js     80105460 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105435:	e8 56 e6 ff ff       	call   80103a90 <myproc>
8010543a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010543d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105440:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105447:	00 
  fileclose(f);
80105448:	ff 75 f4             	pushl  -0xc(%ebp)
8010544b:	e8 f0 b9 ff ff       	call   80100e40 <fileclose>
  return 0;
80105450:	83 c4 10             	add    $0x10,%esp
80105453:	31 c0                	xor    %eax,%eax
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    
80105467:	89 f6                	mov    %esi,%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <sys_fstat>:
{
80105470:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105471:	31 c0                	xor    %eax,%eax
{
80105473:	89 e5                	mov    %esp,%ebp
80105475:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105478:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010547b:	e8 00 fe ff ff       	call   80105280 <argfd.constprop.0>
80105480:	85 c0                	test   %eax,%eax
80105482:	78 2c                	js     801054b0 <sys_fstat+0x40>
80105484:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105487:	83 ec 04             	sub    $0x4,%esp
8010548a:	6a 14                	push   $0x14
8010548c:	50                   	push   %eax
8010548d:	6a 01                	push   $0x1
8010548f:	e8 4c fb ff ff       	call   80104fe0 <argptr>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	85 c0                	test   %eax,%eax
80105499:	78 15                	js     801054b0 <sys_fstat+0x40>
  return filestat(f, st);
8010549b:	83 ec 08             	sub    $0x8,%esp
8010549e:	ff 75 f4             	pushl  -0xc(%ebp)
801054a1:	ff 75 f0             	pushl  -0x10(%ebp)
801054a4:	e8 67 ba ff ff       	call   80100f10 <filestat>
801054a9:	83 c4 10             	add    $0x10,%esp
}
801054ac:	c9                   	leave  
801054ad:	c3                   	ret    
801054ae:	66 90                	xchg   %ax,%ax
    return -1;
801054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b5:	c9                   	leave  
801054b6:	c3                   	ret    
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <sys_link>:
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	56                   	push   %esi
801054c5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801054c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054cc:	50                   	push   %eax
801054cd:	6a 00                	push   $0x0
801054cf:	e8 6c fb ff ff       	call   80105040 <argstr>
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	85 c0                	test   %eax,%eax
801054d9:	0f 88 fb 00 00 00    	js     801055da <sys_link+0x11a>
801054df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801054e2:	83 ec 08             	sub    $0x8,%esp
801054e5:	50                   	push   %eax
801054e6:	6a 01                	push   $0x1
801054e8:	e8 53 fb ff ff       	call   80105040 <argstr>
801054ed:	83 c4 10             	add    $0x10,%esp
801054f0:	85 c0                	test   %eax,%eax
801054f2:	0f 88 e2 00 00 00    	js     801055da <sys_link+0x11a>
  begin_op();
801054f8:	e8 a3 d6 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
801054fd:	83 ec 0c             	sub    $0xc,%esp
80105500:	ff 75 d4             	pushl  -0x2c(%ebp)
80105503:	e8 d8 c9 ff ff       	call   80101ee0 <namei>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	89 c3                	mov    %eax,%ebx
8010550f:	0f 84 ea 00 00 00    	je     801055ff <sys_link+0x13f>
  ilock(ip);
80105515:	83 ec 0c             	sub    $0xc,%esp
80105518:	50                   	push   %eax
80105519:	e8 62 c1 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105526:	0f 84 bb 00 00 00    	je     801055e7 <sys_link+0x127>
  ip->nlink++;
8010552c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105531:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105534:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105537:	53                   	push   %ebx
80105538:	e8 93 c0 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010553d:	89 1c 24             	mov    %ebx,(%esp)
80105540:	e8 1b c2 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105545:	58                   	pop    %eax
80105546:	5a                   	pop    %edx
80105547:	57                   	push   %edi
80105548:	ff 75 d0             	pushl  -0x30(%ebp)
8010554b:	e8 b0 c9 ff ff       	call   80101f00 <nameiparent>
80105550:	83 c4 10             	add    $0x10,%esp
80105553:	85 c0                	test   %eax,%eax
80105555:	89 c6                	mov    %eax,%esi
80105557:	74 5b                	je     801055b4 <sys_link+0xf4>
  ilock(dp);
80105559:	83 ec 0c             	sub    $0xc,%esp
8010555c:	50                   	push   %eax
8010555d:	e8 1e c1 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	8b 03                	mov    (%ebx),%eax
80105567:	39 06                	cmp    %eax,(%esi)
80105569:	75 3d                	jne    801055a8 <sys_link+0xe8>
8010556b:	83 ec 04             	sub    $0x4,%esp
8010556e:	ff 73 04             	pushl  0x4(%ebx)
80105571:	57                   	push   %edi
80105572:	56                   	push   %esi
80105573:	e8 a8 c8 ff ff       	call   80101e20 <dirlink>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	85 c0                	test   %eax,%eax
8010557d:	78 29                	js     801055a8 <sys_link+0xe8>
  iunlockput(dp);
8010557f:	83 ec 0c             	sub    $0xc,%esp
80105582:	56                   	push   %esi
80105583:	e8 88 c3 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105588:	89 1c 24             	mov    %ebx,(%esp)
8010558b:	e8 20 c2 ff ff       	call   801017b0 <iput>
  end_op();
80105590:	e8 7b d6 ff ff       	call   80102c10 <end_op>
  return 0;
80105595:	83 c4 10             	add    $0x10,%esp
80105598:	31 c0                	xor    %eax,%eax
}
8010559a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010559d:	5b                   	pop    %ebx
8010559e:	5e                   	pop    %esi
8010559f:	5f                   	pop    %edi
801055a0:	5d                   	pop    %ebp
801055a1:	c3                   	ret    
801055a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	56                   	push   %esi
801055ac:	e8 5f c3 ff ff       	call   80101910 <iunlockput>
    goto bad;
801055b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801055b4:	83 ec 0c             	sub    $0xc,%esp
801055b7:	53                   	push   %ebx
801055b8:	e8 c3 c0 ff ff       	call   80101680 <ilock>
  ip->nlink--;
801055bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055c2:	89 1c 24             	mov    %ebx,(%esp)
801055c5:	e8 06 c0 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801055ca:	89 1c 24             	mov    %ebx,(%esp)
801055cd:	e8 3e c3 ff ff       	call   80101910 <iunlockput>
  end_op();
801055d2:	e8 39 d6 ff ff       	call   80102c10 <end_op>
  return -1;
801055d7:	83 c4 10             	add    $0x10,%esp
}
801055da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801055dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055e2:	5b                   	pop    %ebx
801055e3:	5e                   	pop    %esi
801055e4:	5f                   	pop    %edi
801055e5:	5d                   	pop    %ebp
801055e6:	c3                   	ret    
    iunlockput(ip);
801055e7:	83 ec 0c             	sub    $0xc,%esp
801055ea:	53                   	push   %ebx
801055eb:	e8 20 c3 ff ff       	call   80101910 <iunlockput>
    end_op();
801055f0:	e8 1b d6 ff ff       	call   80102c10 <end_op>
    return -1;
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fd:	eb 9b                	jmp    8010559a <sys_link+0xda>
    end_op();
801055ff:	e8 0c d6 ff ff       	call   80102c10 <end_op>
    return -1;
80105604:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105609:	eb 8f                	jmp    8010559a <sys_link+0xda>
8010560b:	90                   	nop
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_unlink>:
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105616:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105619:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010561c:	50                   	push   %eax
8010561d:	6a 00                	push   $0x0
8010561f:	e8 1c fa ff ff       	call   80105040 <argstr>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	0f 88 77 01 00 00    	js     801057a6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010562f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105632:	e8 69 d5 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105637:	83 ec 08             	sub    $0x8,%esp
8010563a:	53                   	push   %ebx
8010563b:	ff 75 c0             	pushl  -0x40(%ebp)
8010563e:	e8 bd c8 ff ff       	call   80101f00 <nameiparent>
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	89 c6                	mov    %eax,%esi
8010564a:	0f 84 60 01 00 00    	je     801057b0 <sys_unlink+0x1a0>
  ilock(dp);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	50                   	push   %eax
80105654:	e8 27 c0 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105659:	58                   	pop    %eax
8010565a:	5a                   	pop    %edx
8010565b:	68 78 7f 10 80       	push   $0x80107f78
80105660:	53                   	push   %ebx
80105661:	e8 2a c5 ff ff       	call   80101b90 <namecmp>
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	85 c0                	test   %eax,%eax
8010566b:	0f 84 03 01 00 00    	je     80105774 <sys_unlink+0x164>
80105671:	83 ec 08             	sub    $0x8,%esp
80105674:	68 77 7f 10 80       	push   $0x80107f77
80105679:	53                   	push   %ebx
8010567a:	e8 11 c5 ff ff       	call   80101b90 <namecmp>
8010567f:	83 c4 10             	add    $0x10,%esp
80105682:	85 c0                	test   %eax,%eax
80105684:	0f 84 ea 00 00 00    	je     80105774 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010568a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010568d:	83 ec 04             	sub    $0x4,%esp
80105690:	50                   	push   %eax
80105691:	53                   	push   %ebx
80105692:	56                   	push   %esi
80105693:	e8 18 c5 ff ff       	call   80101bb0 <dirlookup>
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	85 c0                	test   %eax,%eax
8010569d:	89 c3                	mov    %eax,%ebx
8010569f:	0f 84 cf 00 00 00    	je     80105774 <sys_unlink+0x164>
  ilock(ip);
801056a5:	83 ec 0c             	sub    $0xc,%esp
801056a8:	50                   	push   %eax
801056a9:	e8 d2 bf ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801056b6:	0f 8e 10 01 00 00    	jle    801057cc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801056bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056c1:	74 6d                	je     80105730 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801056c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056c6:	83 ec 04             	sub    $0x4,%esp
801056c9:	6a 10                	push   $0x10
801056cb:	6a 00                	push   $0x0
801056cd:	50                   	push   %eax
801056ce:	e8 bd f5 ff ff       	call   80104c90 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056d6:	6a 10                	push   $0x10
801056d8:	ff 75 c4             	pushl  -0x3c(%ebp)
801056db:	50                   	push   %eax
801056dc:	56                   	push   %esi
801056dd:	e8 7e c3 ff ff       	call   80101a60 <writei>
801056e2:	83 c4 20             	add    $0x20,%esp
801056e5:	83 f8 10             	cmp    $0x10,%eax
801056e8:	0f 85 eb 00 00 00    	jne    801057d9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801056ee:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056f3:	0f 84 97 00 00 00    	je     80105790 <sys_unlink+0x180>
  iunlockput(dp);
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	56                   	push   %esi
801056fd:	e8 0e c2 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105702:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105707:	89 1c 24             	mov    %ebx,(%esp)
8010570a:	e8 c1 be ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010570f:	89 1c 24             	mov    %ebx,(%esp)
80105712:	e8 f9 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
80105717:	e8 f4 d4 ff ff       	call   80102c10 <end_op>
  return 0;
8010571c:	83 c4 10             	add    $0x10,%esp
8010571f:	31 c0                	xor    %eax,%eax
}
80105721:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105724:	5b                   	pop    %ebx
80105725:	5e                   	pop    %esi
80105726:	5f                   	pop    %edi
80105727:	5d                   	pop    %ebp
80105728:	c3                   	ret    
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105730:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105734:	76 8d                	jbe    801056c3 <sys_unlink+0xb3>
80105736:	bf 20 00 00 00       	mov    $0x20,%edi
8010573b:	eb 0f                	jmp    8010574c <sys_unlink+0x13c>
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
80105740:	83 c7 10             	add    $0x10,%edi
80105743:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105746:	0f 83 77 ff ff ff    	jae    801056c3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010574c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010574f:	6a 10                	push   $0x10
80105751:	57                   	push   %edi
80105752:	50                   	push   %eax
80105753:	53                   	push   %ebx
80105754:	e8 07 c2 ff ff       	call   80101960 <readi>
80105759:	83 c4 10             	add    $0x10,%esp
8010575c:	83 f8 10             	cmp    $0x10,%eax
8010575f:	75 5e                	jne    801057bf <sys_unlink+0x1af>
    if(de.inum != 0)
80105761:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105766:	74 d8                	je     80105740 <sys_unlink+0x130>
    iunlockput(ip);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	53                   	push   %ebx
8010576c:	e8 9f c1 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105771:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105774:	83 ec 0c             	sub    $0xc,%esp
80105777:	56                   	push   %esi
80105778:	e8 93 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
8010577d:	e8 8e d4 ff ff       	call   80102c10 <end_op>
  return -1;
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010578a:	eb 95                	jmp    80105721 <sys_unlink+0x111>
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105790:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105795:	83 ec 0c             	sub    $0xc,%esp
80105798:	56                   	push   %esi
80105799:	e8 32 be ff ff       	call   801015d0 <iupdate>
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	e9 53 ff ff ff       	jmp    801056f9 <sys_unlink+0xe9>
    return -1;
801057a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ab:	e9 71 ff ff ff       	jmp    80105721 <sys_unlink+0x111>
    end_op();
801057b0:	e8 5b d4 ff ff       	call   80102c10 <end_op>
    return -1;
801057b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ba:	e9 62 ff ff ff       	jmp    80105721 <sys_unlink+0x111>
      panic("isdirempty: readi");
801057bf:	83 ec 0c             	sub    $0xc,%esp
801057c2:	68 9c 7f 10 80       	push   $0x80107f9c
801057c7:	e8 c4 ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	68 8a 7f 10 80       	push   $0x80107f8a
801057d4:	e8 b7 ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	68 ae 7f 10 80       	push   $0x80107fae
801057e1:	e8 aa ab ff ff       	call   80100390 <panic>
801057e6:	8d 76 00             	lea    0x0(%esi),%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_open>:

int
sys_open(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
801057f5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801057f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057fc:	50                   	push   %eax
801057fd:	6a 00                	push   $0x0
801057ff:	e8 3c f8 ff ff       	call   80105040 <argstr>
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	85 c0                	test   %eax,%eax
80105809:	0f 88 1d 01 00 00    	js     8010592c <sys_open+0x13c>
8010580f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105812:	83 ec 08             	sub    $0x8,%esp
80105815:	50                   	push   %eax
80105816:	6a 01                	push   $0x1
80105818:	e8 73 f7 ff ff       	call   80104f90 <argint>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	0f 88 04 01 00 00    	js     8010592c <sys_open+0x13c>
    return -1;

  begin_op();
80105828:	e8 73 d3 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
8010582d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105831:	0f 85 a9 00 00 00    	jne    801058e0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105837:	83 ec 0c             	sub    $0xc,%esp
8010583a:	ff 75 e0             	pushl  -0x20(%ebp)
8010583d:	e8 9e c6 ff ff       	call   80101ee0 <namei>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	89 c6                	mov    %eax,%esi
80105849:	0f 84 b2 00 00 00    	je     80105901 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010584f:	83 ec 0c             	sub    $0xc,%esp
80105852:	50                   	push   %eax
80105853:	e8 28 be ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105858:	83 c4 10             	add    $0x10,%esp
8010585b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105860:	0f 84 aa 00 00 00    	je     80105910 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105866:	e8 15 b5 ff ff       	call   80100d80 <filealloc>
8010586b:	85 c0                	test   %eax,%eax
8010586d:	89 c7                	mov    %eax,%edi
8010586f:	0f 84 a6 00 00 00    	je     8010591b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105875:	e8 16 e2 ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010587a:	31 db                	xor    %ebx,%ebx
8010587c:	eb 0e                	jmp    8010588c <sys_open+0x9c>
8010587e:	66 90                	xchg   %ax,%ax
80105880:	83 c3 01             	add    $0x1,%ebx
80105883:	83 fb 10             	cmp    $0x10,%ebx
80105886:	0f 84 ac 00 00 00    	je     80105938 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010588c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105890:	85 d2                	test   %edx,%edx
80105892:	75 ec                	jne    80105880 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105894:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105897:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010589b:	56                   	push   %esi
8010589c:	e8 bf be ff ff       	call   80101760 <iunlock>
  end_op();
801058a1:	e8 6a d3 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
801058a6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801058ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058af:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801058b2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801058b5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801058bc:	89 d0                	mov    %edx,%eax
801058be:	f7 d0                	not    %eax
801058c0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058c3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801058c6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058c9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801058cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d0:	89 d8                	mov    %ebx,%eax
801058d2:	5b                   	pop    %ebx
801058d3:	5e                   	pop    %esi
801058d4:	5f                   	pop    %edi
801058d5:	5d                   	pop    %ebp
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801058e6:	31 c9                	xor    %ecx,%ecx
801058e8:	6a 00                	push   $0x0
801058ea:	ba 02 00 00 00       	mov    $0x2,%edx
801058ef:	e8 ec f7 ff ff       	call   801050e0 <create>
    if(ip == 0){
801058f4:	83 c4 10             	add    $0x10,%esp
801058f7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801058f9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801058fb:	0f 85 65 ff ff ff    	jne    80105866 <sys_open+0x76>
      end_op();
80105901:	e8 0a d3 ff ff       	call   80102c10 <end_op>
      return -1;
80105906:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010590b:	eb c0                	jmp    801058cd <sys_open+0xdd>
8010590d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105910:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105913:	85 c9                	test   %ecx,%ecx
80105915:	0f 84 4b ff ff ff    	je     80105866 <sys_open+0x76>
    iunlockput(ip);
8010591b:	83 ec 0c             	sub    $0xc,%esp
8010591e:	56                   	push   %esi
8010591f:	e8 ec bf ff ff       	call   80101910 <iunlockput>
    end_op();
80105924:	e8 e7 d2 ff ff       	call   80102c10 <end_op>
    return -1;
80105929:	83 c4 10             	add    $0x10,%esp
8010592c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105931:	eb 9a                	jmp    801058cd <sys_open+0xdd>
80105933:	90                   	nop
80105934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105938:	83 ec 0c             	sub    $0xc,%esp
8010593b:	57                   	push   %edi
8010593c:	e8 ff b4 ff ff       	call   80100e40 <fileclose>
80105941:	83 c4 10             	add    $0x10,%esp
80105944:	eb d5                	jmp    8010591b <sys_open+0x12b>
80105946:	8d 76 00             	lea    0x0(%esi),%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105950 <sys_mkdir>:

int
sys_mkdir(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105956:	e8 45 d2 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010595b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010595e:	83 ec 08             	sub    $0x8,%esp
80105961:	50                   	push   %eax
80105962:	6a 00                	push   $0x0
80105964:	e8 d7 f6 ff ff       	call   80105040 <argstr>
80105969:	83 c4 10             	add    $0x10,%esp
8010596c:	85 c0                	test   %eax,%eax
8010596e:	78 30                	js     801059a0 <sys_mkdir+0x50>
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105976:	31 c9                	xor    %ecx,%ecx
80105978:	6a 00                	push   $0x0
8010597a:	ba 01 00 00 00       	mov    $0x1,%edx
8010597f:	e8 5c f7 ff ff       	call   801050e0 <create>
80105984:	83 c4 10             	add    $0x10,%esp
80105987:	85 c0                	test   %eax,%eax
80105989:	74 15                	je     801059a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010598b:	83 ec 0c             	sub    $0xc,%esp
8010598e:	50                   	push   %eax
8010598f:	e8 7c bf ff ff       	call   80101910 <iunlockput>
  end_op();
80105994:	e8 77 d2 ff ff       	call   80102c10 <end_op>
  return 0;
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	31 c0                	xor    %eax,%eax
}
8010599e:	c9                   	leave  
8010599f:	c3                   	ret    
    end_op();
801059a0:	e8 6b d2 ff ff       	call   80102c10 <end_op>
    return -1;
801059a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059aa:	c9                   	leave  
801059ab:	c3                   	ret    
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_mknod>:

int
sys_mknod(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059b6:	e8 e5 d1 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059be:	83 ec 08             	sub    $0x8,%esp
801059c1:	50                   	push   %eax
801059c2:	6a 00                	push   $0x0
801059c4:	e8 77 f6 ff ff       	call   80105040 <argstr>
801059c9:	83 c4 10             	add    $0x10,%esp
801059cc:	85 c0                	test   %eax,%eax
801059ce:	78 60                	js     80105a30 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801059d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059d3:	83 ec 08             	sub    $0x8,%esp
801059d6:	50                   	push   %eax
801059d7:	6a 01                	push   $0x1
801059d9:	e8 b2 f5 ff ff       	call   80104f90 <argint>
  if((argstr(0, &path)) < 0 ||
801059de:	83 c4 10             	add    $0x10,%esp
801059e1:	85 c0                	test   %eax,%eax
801059e3:	78 4b                	js     80105a30 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801059e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e8:	83 ec 08             	sub    $0x8,%esp
801059eb:	50                   	push   %eax
801059ec:	6a 02                	push   $0x2
801059ee:	e8 9d f5 ff ff       	call   80104f90 <argint>
     argint(1, &major) < 0 ||
801059f3:	83 c4 10             	add    $0x10,%esp
801059f6:	85 c0                	test   %eax,%eax
801059f8:	78 36                	js     80105a30 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801059fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801059fe:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a01:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105a05:	ba 03 00 00 00       	mov    $0x3,%edx
80105a0a:	50                   	push   %eax
80105a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a0e:	e8 cd f6 ff ff       	call   801050e0 <create>
80105a13:	83 c4 10             	add    $0x10,%esp
80105a16:	85 c0                	test   %eax,%eax
80105a18:	74 16                	je     80105a30 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a1a:	83 ec 0c             	sub    $0xc,%esp
80105a1d:	50                   	push   %eax
80105a1e:	e8 ed be ff ff       	call   80101910 <iunlockput>
  end_op();
80105a23:	e8 e8 d1 ff ff       	call   80102c10 <end_op>
  return 0;
80105a28:	83 c4 10             	add    $0x10,%esp
80105a2b:	31 c0                	xor    %eax,%eax
}
80105a2d:	c9                   	leave  
80105a2e:	c3                   	ret    
80105a2f:	90                   	nop
    end_op();
80105a30:	e8 db d1 ff ff       	call   80102c10 <end_op>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a3a:	c9                   	leave  
80105a3b:	c3                   	ret    
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_chdir>:

int
sys_chdir(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	56                   	push   %esi
80105a44:	53                   	push   %ebx
80105a45:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a48:	e8 43 e0 ff ff       	call   80103a90 <myproc>
80105a4d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a4f:	e8 4c d1 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a57:	83 ec 08             	sub    $0x8,%esp
80105a5a:	50                   	push   %eax
80105a5b:	6a 00                	push   $0x0
80105a5d:	e8 de f5 ff ff       	call   80105040 <argstr>
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	85 c0                	test   %eax,%eax
80105a67:	78 77                	js     80105ae0 <sys_chdir+0xa0>
80105a69:	83 ec 0c             	sub    $0xc,%esp
80105a6c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a6f:	e8 6c c4 ff ff       	call   80101ee0 <namei>
80105a74:	83 c4 10             	add    $0x10,%esp
80105a77:	85 c0                	test   %eax,%eax
80105a79:	89 c3                	mov    %eax,%ebx
80105a7b:	74 63                	je     80105ae0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	50                   	push   %eax
80105a81:	e8 fa bb ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105a86:	83 c4 10             	add    $0x10,%esp
80105a89:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a8e:	75 30                	jne    80105ac0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	53                   	push   %ebx
80105a94:	e8 c7 bc ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105a99:	58                   	pop    %eax
80105a9a:	ff 76 68             	pushl  0x68(%esi)
80105a9d:	e8 0e bd ff ff       	call   801017b0 <iput>
  end_op();
80105aa2:	e8 69 d1 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105aa7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	31 c0                	xor    %eax,%eax
}
80105aaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ab2:	5b                   	pop    %ebx
80105ab3:	5e                   	pop    %esi
80105ab4:	5d                   	pop    %ebp
80105ab5:	c3                   	ret    
80105ab6:	8d 76 00             	lea    0x0(%esi),%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	53                   	push   %ebx
80105ac4:	e8 47 be ff ff       	call   80101910 <iunlockput>
    end_op();
80105ac9:	e8 42 d1 ff ff       	call   80102c10 <end_op>
    return -1;
80105ace:	83 c4 10             	add    $0x10,%esp
80105ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad6:	eb d7                	jmp    80105aaf <sys_chdir+0x6f>
80105ad8:	90                   	nop
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ae0:	e8 2b d1 ff ff       	call   80102c10 <end_op>
    return -1;
80105ae5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aea:	eb c3                	jmp    80105aaf <sys_chdir+0x6f>
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105af0 <sys_exec>:

int
sys_exec(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105af6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105afc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b02:	50                   	push   %eax
80105b03:	6a 00                	push   $0x0
80105b05:	e8 36 f5 ff ff       	call   80105040 <argstr>
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	85 c0                	test   %eax,%eax
80105b0f:	0f 88 87 00 00 00    	js     80105b9c <sys_exec+0xac>
80105b15:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b1b:	83 ec 08             	sub    $0x8,%esp
80105b1e:	50                   	push   %eax
80105b1f:	6a 01                	push   $0x1
80105b21:	e8 6a f4 ff ff       	call   80104f90 <argint>
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	78 6f                	js     80105b9c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b2d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b33:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105b36:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b38:	68 80 00 00 00       	push   $0x80
80105b3d:	6a 00                	push   $0x0
80105b3f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b45:	50                   	push   %eax
80105b46:	e8 45 f1 ff ff       	call   80104c90 <memset>
80105b4b:	83 c4 10             	add    $0x10,%esp
80105b4e:	eb 2c                	jmp    80105b7c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105b50:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b56:	85 c0                	test   %eax,%eax
80105b58:	74 56                	je     80105bb0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b5a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105b60:	83 ec 08             	sub    $0x8,%esp
80105b63:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105b66:	52                   	push   %edx
80105b67:	50                   	push   %eax
80105b68:	e8 b3 f3 ff ff       	call   80104f20 <fetchstr>
80105b6d:	83 c4 10             	add    $0x10,%esp
80105b70:	85 c0                	test   %eax,%eax
80105b72:	78 28                	js     80105b9c <sys_exec+0xac>
  for(i=0;; i++){
80105b74:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b77:	83 fb 20             	cmp    $0x20,%ebx
80105b7a:	74 20                	je     80105b9c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b7c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b82:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b89:	83 ec 08             	sub    $0x8,%esp
80105b8c:	57                   	push   %edi
80105b8d:	01 f0                	add    %esi,%eax
80105b8f:	50                   	push   %eax
80105b90:	e8 4b f3 ff ff       	call   80104ee0 <fetchint>
80105b95:	83 c4 10             	add    $0x10,%esp
80105b98:	85 c0                	test   %eax,%eax
80105b9a:	79 b4                	jns    80105b50 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
80105ba8:	c3                   	ret    
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105bb0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bb6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105bb9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105bc0:	00 00 00 00 
  return exec(path, argv);
80105bc4:	50                   	push   %eax
80105bc5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bcb:	e8 40 ae ff ff       	call   80100a10 <exec>
80105bd0:	83 c4 10             	add    $0x10,%esp
}
80105bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bd6:	5b                   	pop    %ebx
80105bd7:	5e                   	pop    %esi
80105bd8:	5f                   	pop    %edi
80105bd9:	5d                   	pop    %ebp
80105bda:	c3                   	ret    
80105bdb:	90                   	nop
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105be0 <sys_pipe>:

int
sys_pipe(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
80105be5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105be6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105be9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bec:	6a 08                	push   $0x8
80105bee:	50                   	push   %eax
80105bef:	6a 00                	push   $0x0
80105bf1:	e8 ea f3 ff ff       	call   80104fe0 <argptr>
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	0f 88 ae 00 00 00    	js     80105caf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c04:	83 ec 08             	sub    $0x8,%esp
80105c07:	50                   	push   %eax
80105c08:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c0b:	50                   	push   %eax
80105c0c:	e8 2f d6 ff ff       	call   80103240 <pipealloc>
80105c11:	83 c4 10             	add    $0x10,%esp
80105c14:	85 c0                	test   %eax,%eax
80105c16:	0f 88 93 00 00 00    	js     80105caf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c1c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c1f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c21:	e8 6a de ff ff       	call   80103a90 <myproc>
80105c26:	eb 10                	jmp    80105c38 <sys_pipe+0x58>
80105c28:	90                   	nop
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105c30:	83 c3 01             	add    $0x1,%ebx
80105c33:	83 fb 10             	cmp    $0x10,%ebx
80105c36:	74 60                	je     80105c98 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105c38:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c3c:	85 f6                	test   %esi,%esi
80105c3e:	75 f0                	jne    80105c30 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105c40:	8d 73 08             	lea    0x8(%ebx),%esi
80105c43:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105c4a:	e8 41 de ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c4f:	31 d2                	xor    %edx,%edx
80105c51:	eb 0d                	jmp    80105c60 <sys_pipe+0x80>
80105c53:	90                   	nop
80105c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c58:	83 c2 01             	add    $0x1,%edx
80105c5b:	83 fa 10             	cmp    $0x10,%edx
80105c5e:	74 28                	je     80105c88 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105c60:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c64:	85 c9                	test   %ecx,%ecx
80105c66:	75 f0                	jne    80105c58 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105c68:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105c6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c6f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c74:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c77:	31 c0                	xor    %eax,%eax
}
80105c79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c7c:	5b                   	pop    %ebx
80105c7d:	5e                   	pop    %esi
80105c7e:	5f                   	pop    %edi
80105c7f:	5d                   	pop    %ebp
80105c80:	c3                   	ret    
80105c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105c88:	e8 03 de ff ff       	call   80103a90 <myproc>
80105c8d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c94:	00 
80105c95:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105c98:	83 ec 0c             	sub    $0xc,%esp
80105c9b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c9e:	e8 9d b1 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105ca3:	58                   	pop    %eax
80105ca4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ca7:	e8 94 b1 ff ff       	call   80100e40 <fileclose>
    return -1;
80105cac:	83 c4 10             	add    $0x10,%esp
80105caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb4:	eb c3                	jmp    80105c79 <sys_pipe+0x99>
80105cb6:	66 90                	xchg   %ax,%ax
80105cb8:	66 90                	xchg   %ax,%ax
80105cba:	66 90                	xchg   %ax,%ax
80105cbc:	66 90                	xchg   %ax,%ax
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105cc3:	5d                   	pop    %ebp
  return fork();
80105cc4:	e9 a7 df ff ff       	jmp    80103c70 <fork>
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <sys_exit>:

int
sys_exit(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105cd6:	e8 35 e6 ff ff       	call   80104310 <exit>
  return 0;  // not reached
}
80105cdb:	31 c0                	xor    %eax,%eax
80105cdd:	c9                   	leave  
80105cde:	c3                   	ret    
80105cdf:	90                   	nop

80105ce0 <sys_wait>:

int
sys_wait(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ce3:	5d                   	pop    %ebp
  return wait();
80105ce4:	e9 67 e8 ff ff       	jmp    80104550 <wait>
80105ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_kill>:

int
sys_kill(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105cf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cf9:	50                   	push   %eax
80105cfa:	6a 00                	push   $0x0
80105cfc:	e8 8f f2 ff ff       	call   80104f90 <argint>
80105d01:	83 c4 10             	add    $0x10,%esp
80105d04:	85 c0                	test   %eax,%eax
80105d06:	78 18                	js     80105d20 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d08:	83 ec 0c             	sub    $0xc,%esp
80105d0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d0e:	e8 9d e9 ff ff       	call   801046b0 <kill>
80105d13:	83 c4 10             	add    $0x10,%esp
}
80105d16:	c9                   	leave  
80105d17:	c3                   	ret    
80105d18:	90                   	nop
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <sys_getpid>:

int
sys_getpid(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d36:	e8 55 dd ff ff       	call   80103a90 <myproc>
80105d3b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d3e:	c9                   	leave  
80105d3f:	c3                   	ret    

80105d40 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d4a:	50                   	push   %eax
80105d4b:	6a 00                	push   $0x0
80105d4d:	e8 3e f2 ff ff       	call   80104f90 <argint>
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	85 c0                	test   %eax,%eax
80105d57:	78 27                	js     80105d80 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105d59:	e8 32 dd ff ff       	call   80103a90 <myproc>
  if(growproc(n) < 0)
80105d5e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d61:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d63:	ff 75 f4             	pushl  -0xc(%ebp)
80105d66:	e8 85 de ff ff       	call   80103bf0 <growproc>
80105d6b:	83 c4 10             	add    $0x10,%esp
80105d6e:	85 c0                	test   %eax,%eax
80105d70:	78 0e                	js     80105d80 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d72:	89 d8                	mov    %ebx,%eax
80105d74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d77:	c9                   	leave  
80105d78:	c3                   	ret    
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d85:	eb eb                	jmp    80105d72 <sys_sbrk+0x32>
80105d87:	89 f6                	mov    %esi,%esi
80105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d90 <sys_sleep>:

int
sys_sleep(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d9a:	50                   	push   %eax
80105d9b:	6a 00                	push   $0x0
80105d9d:	e8 ee f1 ff ff       	call   80104f90 <argint>
80105da2:	83 c4 10             	add    $0x10,%esp
80105da5:	85 c0                	test   %eax,%eax
80105da7:	0f 88 8a 00 00 00    	js     80105e37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	68 80 d9 28 80       	push   $0x8028d980
80105db5:	e8 c6 ed ff ff       	call   80104b80 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dbd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105dc0:	8b 1d c0 e1 28 80    	mov    0x8028e1c0,%ebx
  while(ticks - ticks0 < n){
80105dc6:	85 d2                	test   %edx,%edx
80105dc8:	75 27                	jne    80105df1 <sys_sleep+0x61>
80105dca:	eb 54                	jmp    80105e20 <sys_sleep+0x90>
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105dd0:	83 ec 08             	sub    $0x8,%esp
80105dd3:	68 80 d9 28 80       	push   $0x8028d980
80105dd8:	68 c0 e1 28 80       	push   $0x8028e1c0
80105ddd:	e8 ae e6 ff ff       	call   80104490 <sleep>
  while(ticks - ticks0 < n){
80105de2:	a1 c0 e1 28 80       	mov    0x8028e1c0,%eax
80105de7:	83 c4 10             	add    $0x10,%esp
80105dea:	29 d8                	sub    %ebx,%eax
80105dec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105def:	73 2f                	jae    80105e20 <sys_sleep+0x90>
    if(myproc()->killed){
80105df1:	e8 9a dc ff ff       	call   80103a90 <myproc>
80105df6:	8b 40 24             	mov    0x24(%eax),%eax
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	74 d3                	je     80105dd0 <sys_sleep+0x40>
      release(&tickslock);
80105dfd:	83 ec 0c             	sub    $0xc,%esp
80105e00:	68 80 d9 28 80       	push   $0x8028d980
80105e05:	e8 36 ee ff ff       	call   80104c40 <release>
      return -1;
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e15:	c9                   	leave  
80105e16:	c3                   	ret    
80105e17:	89 f6                	mov    %esi,%esi
80105e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105e20:	83 ec 0c             	sub    $0xc,%esp
80105e23:	68 80 d9 28 80       	push   $0x8028d980
80105e28:	e8 13 ee ff ff       	call   80104c40 <release>
  return 0;
80105e2d:	83 c4 10             	add    $0x10,%esp
80105e30:	31 c0                	xor    %eax,%eax
}
80105e32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
    return -1;
80105e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3c:	eb f4                	jmp    80105e32 <sys_sleep+0xa2>
80105e3e:	66 90                	xchg   %ax,%ax

80105e40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	53                   	push   %ebx
80105e44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105e47:	68 80 d9 28 80       	push   $0x8028d980
80105e4c:	e8 2f ed ff ff       	call   80104b80 <acquire>
  xticks = ticks;
80105e51:	8b 1d c0 e1 28 80    	mov    0x8028e1c0,%ebx
  release(&tickslock);
80105e57:	c7 04 24 80 d9 28 80 	movl   $0x8028d980,(%esp)
80105e5e:	e8 dd ed ff ff       	call   80104c40 <release>
  return xticks;
}
80105e63:	89 d8                	mov    %ebx,%eax
80105e65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e68:	c9                   	leave  
80105e69:	c3                   	ret    
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e70 <sys_getpinfo>:



int
sys_getpinfo(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0)
80105e76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e79:	50                   	push   %eax
80105e7a:	6a 00                	push   $0x0
80105e7c:	e8 0f f1 ff ff       	call   80104f90 <argint>
80105e81:	83 c4 10             	add    $0x10,%esp
80105e84:	85 c0                	test   %eax,%eax
80105e86:	78 18                	js     80105ea0 <sys_getpinfo+0x30>
    return -1;
  return getpinfo(pid);
80105e88:	83 ec 0c             	sub    $0xc,%esp
80105e8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8e:	e8 6d e9 ff ff       	call   80104800 <getpinfo>
80105e93:	83 c4 10             	add    $0x10,%esp
}
80105e96:	c9                   	leave  
80105e97:	c3                   	ret    
80105e98:	90                   	nop
80105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ea5:	c9                   	leave  
80105ea6:	c3                   	ret    

80105ea7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ea7:	1e                   	push   %ds
  pushl %es
80105ea8:	06                   	push   %es
  pushl %fs
80105ea9:	0f a0                	push   %fs
  pushl %gs
80105eab:	0f a8                	push   %gs
  pushal
80105ead:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105eae:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105eb2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105eb4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105eb6:	54                   	push   %esp
  call trap
80105eb7:	e8 c4 00 00 00       	call   80105f80 <trap>
  addl $4, %esp
80105ebc:	83 c4 04             	add    $0x4,%esp

80105ebf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ebf:	61                   	popa   
  popl %gs
80105ec0:	0f a9                	pop    %gs
  popl %fs
80105ec2:	0f a1                	pop    %fs
  popl %es
80105ec4:	07                   	pop    %es
  popl %ds
80105ec5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ec6:	83 c4 08             	add    $0x8,%esp
  iret
80105ec9:	cf                   	iret   
80105eca:	66 90                	xchg   %ax,%ax
80105ecc:	66 90                	xchg   %ax,%ax
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ed0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ed1:	31 c0                	xor    %eax,%eax
{
80105ed3:	89 e5                	mov    %esp,%ebp
80105ed5:	83 ec 08             	sub    $0x8,%esp
80105ed8:	90                   	nop
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ee0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ee7:	c7 04 c5 c2 d9 28 80 	movl   $0x8e000008,-0x7fd7263e(,%eax,8)
80105eee:	08 00 00 8e 
80105ef2:	66 89 14 c5 c0 d9 28 	mov    %dx,-0x7fd72640(,%eax,8)
80105ef9:	80 
80105efa:	c1 ea 10             	shr    $0x10,%edx
80105efd:	66 89 14 c5 c6 d9 28 	mov    %dx,-0x7fd7263a(,%eax,8)
80105f04:	80 
  for(i = 0; i < 256; i++)
80105f05:	83 c0 01             	add    $0x1,%eax
80105f08:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f0d:	75 d1                	jne    80105ee0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f0f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105f14:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f17:	c7 05 c2 db 28 80 08 	movl   $0xef000008,0x8028dbc2
80105f1e:	00 00 ef 
  initlock(&tickslock, "time");
80105f21:	68 bd 7f 10 80       	push   $0x80107fbd
80105f26:	68 80 d9 28 80       	push   $0x8028d980
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f2b:	66 a3 c0 db 28 80    	mov    %ax,0x8028dbc0
80105f31:	c1 e8 10             	shr    $0x10,%eax
80105f34:	66 a3 c6 db 28 80    	mov    %ax,0x8028dbc6
  initlock(&tickslock, "time");
80105f3a:	e8 01 eb ff ff       	call   80104a40 <initlock>
}
80105f3f:	83 c4 10             	add    $0x10,%esp
80105f42:	c9                   	leave  
80105f43:	c3                   	ret    
80105f44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f50 <idtinit>:

void
idtinit(void)
{
80105f50:	55                   	push   %ebp
  pd[0] = size-1;
80105f51:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f56:	89 e5                	mov    %esp,%ebp
80105f58:	83 ec 10             	sub    $0x10,%esp
80105f5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f5f:	b8 c0 d9 28 80       	mov    $0x8028d9c0,%eax
80105f64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f68:	c1 e8 10             	shr    $0x10,%eax
80105f6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f72:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f75:	c9                   	leave  
80105f76:	c3                   	ret    
80105f77:	89 f6                	mov    %esi,%esi
80105f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f80 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	57                   	push   %edi
80105f84:	56                   	push   %esi
80105f85:	53                   	push   %ebx
80105f86:	83 ec 1c             	sub    $0x1c,%esp
80105f89:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f8c:	8b 47 30             	mov    0x30(%edi),%eax
80105f8f:	83 f8 40             	cmp    $0x40,%eax
80105f92:	0f 84 f0 00 00 00    	je     80106088 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f98:	83 e8 20             	sub    $0x20,%eax
80105f9b:	83 f8 1f             	cmp    $0x1f,%eax
80105f9e:	77 10                	ja     80105fb0 <trap+0x30>
80105fa0:	ff 24 85 64 80 10 80 	jmp    *-0x7fef7f9c(,%eax,4)
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105fb0:	e8 db da ff ff       	call   80103a90 <myproc>
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105fba:	0f 84 7d 02 00 00    	je     8010623d <trap+0x2bd>
80105fc0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105fc4:	0f 84 73 02 00 00    	je     8010623d <trap+0x2bd>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fca:	0f 20 d1             	mov    %cr2,%ecx
80105fcd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fd0:	e8 9b da ff ff       	call   80103a70 <cpuid>
80105fd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105fd8:	8b 47 34             	mov    0x34(%edi),%eax
80105fdb:	8b 77 30             	mov    0x30(%edi),%esi
80105fde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fe1:	e8 aa da ff ff       	call   80103a90 <myproc>
80105fe6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fe9:	e8 a2 da ff ff       	call   80103a90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ff4:	51                   	push   %ecx
80105ff5:	53                   	push   %ebx
80105ff6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ff7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ffa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ffd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ffe:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106001:	52                   	push   %edx
80106002:	ff 70 10             	pushl  0x10(%eax)
80106005:	68 20 80 10 80       	push   $0x80108020
8010600a:	e8 51 a6 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010600f:	83 c4 20             	add    $0x20,%esp
80106012:	e8 79 da ff ff       	call   80103a90 <myproc>
80106017:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010601e:	e8 6d da ff ff       	call   80103a90 <myproc>
80106023:	85 c0                	test   %eax,%eax
80106025:	74 1d                	je     80106044 <trap+0xc4>
80106027:	e8 64 da ff ff       	call   80103a90 <myproc>
8010602c:	8b 50 24             	mov    0x24(%eax),%edx
8010602f:	85 d2                	test   %edx,%edx
80106031:	74 11                	je     80106044 <trap+0xc4>
80106033:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106037:	83 e0 03             	and    $0x3,%eax
8010603a:	66 83 f8 03          	cmp    $0x3,%ax
8010603e:	0f 84 8c 01 00 00    	je     801061d0 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106044:	e8 47 da ff ff       	call   80103a90 <myproc>
80106049:	85 c0                	test   %eax,%eax
8010604b:	74 0b                	je     80106058 <trap+0xd8>
8010604d:	e8 3e da ff ff       	call   80103a90 <myproc>
80106052:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106056:	74 68                	je     801060c0 <trap+0x140>
    else if (priority == 2 && duration >= 8) yield();

  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106058:	e8 33 da ff ff       	call   80103a90 <myproc>
8010605d:	85 c0                	test   %eax,%eax
8010605f:	74 19                	je     8010607a <trap+0xfa>
80106061:	e8 2a da ff ff       	call   80103a90 <myproc>
80106066:	8b 40 24             	mov    0x24(%eax),%eax
80106069:	85 c0                	test   %eax,%eax
8010606b:	74 0d                	je     8010607a <trap+0xfa>
8010606d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106071:	83 e0 03             	and    $0x3,%eax
80106074:	66 83 f8 03          	cmp    $0x3,%ax
80106078:	74 37                	je     801060b1 <trap+0x131>
    exit();
}
8010607a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010607d:	5b                   	pop    %ebx
8010607e:	5e                   	pop    %esi
8010607f:	5f                   	pop    %edi
80106080:	5d                   	pop    %ebp
80106081:	c3                   	ret    
80106082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106088:	e8 03 da ff ff       	call   80103a90 <myproc>
8010608d:	8b 58 24             	mov    0x24(%eax),%ebx
80106090:	85 db                	test   %ebx,%ebx
80106092:	0f 85 28 01 00 00    	jne    801061c0 <trap+0x240>
    myproc()->tf = tf;
80106098:	e8 f3 d9 ff ff       	call   80103a90 <myproc>
8010609d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801060a0:	e8 db ef ff ff       	call   80105080 <syscall>
    if(myproc()->killed)
801060a5:	e8 e6 d9 ff ff       	call   80103a90 <myproc>
801060aa:	8b 48 24             	mov    0x24(%eax),%ecx
801060ad:	85 c9                	test   %ecx,%ecx
801060af:	74 c9                	je     8010607a <trap+0xfa>
}
801060b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b4:	5b                   	pop    %ebx
801060b5:	5e                   	pop    %esi
801060b6:	5f                   	pop    %edi
801060b7:	5d                   	pop    %ebp
      exit();
801060b8:	e9 53 e2 ff ff       	jmp    80104310 <exit>
801060bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801060c0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801060c4:	75 92                	jne    80106058 <trap+0xd8>
    struct proc* p = myproc();
801060c6:	e8 c5 d9 ff ff       	call   80103a90 <myproc>
801060cb:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
    p->num_ticks++;
801060d1:	83 80 98 00 00 00 01 	addl   $0x1,0x98(%eax)
801060d8:	c1 e2 04             	shl    $0x4,%edx
801060db:	01 d0                	add    %edx,%eax
    int duration = ticks - p->sched_stats[p->num_stats_used - 1].start_tick;
801060dd:	8b 15 c0 e1 28 80    	mov    0x8028e1c0,%edx
    int priority = p->sched_stats[p->num_stats_used - 1].priority;
801060e3:	8b 88 a0 00 00 00    	mov    0xa0(%eax),%ecx
    int duration = ticks - p->sched_stats[p->num_stats_used - 1].start_tick;
801060e9:	2b 90 98 00 00 00    	sub    0x98(%eax),%edx
    if (priority == 0 && duration >= 1){ yield();}
801060ef:	85 c9                	test   %ecx,%ecx
    int duration = ticks - p->sched_stats[p->num_stats_used - 1].start_tick;
801060f1:	89 d0                	mov    %edx,%eax
    if (priority == 0 && duration >= 1){ yield();}
801060f3:	0f 85 1f 01 00 00    	jne    80106218 <trap+0x298>
801060f9:	85 d2                	test   %edx,%edx
801060fb:	0f 8e 17 01 00 00    	jle    80106218 <trap+0x298>
80106101:	e8 3a e3 ff ff       	call   80104440 <yield>
80106106:	e9 4d ff ff ff       	jmp    80106058 <trap+0xd8>
8010610b:	90                   	nop
8010610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106110:	e8 5b d9 ff ff       	call   80103a70 <cpuid>
80106115:	85 c0                	test   %eax,%eax
80106117:	0f 84 c3 00 00 00    	je     801061e0 <trap+0x260>
    lapiceoi();
8010611d:	e8 2e c6 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106122:	e8 69 d9 ff ff       	call   80103a90 <myproc>
80106127:	85 c0                	test   %eax,%eax
80106129:	0f 85 f8 fe ff ff    	jne    80106027 <trap+0xa7>
8010612f:	e9 10 ff ff ff       	jmp    80106044 <trap+0xc4>
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106138:	e8 d3 c4 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
8010613d:	e8 0e c6 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106142:	e8 49 d9 ff ff       	call   80103a90 <myproc>
80106147:	85 c0                	test   %eax,%eax
80106149:	0f 85 d8 fe ff ff    	jne    80106027 <trap+0xa7>
8010614f:	e9 f0 fe ff ff       	jmp    80106044 <trap+0xc4>
80106154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106158:	e8 83 02 00 00       	call   801063e0 <uartintr>
    lapiceoi();
8010615d:	e8 ee c5 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106162:	e8 29 d9 ff ff       	call   80103a90 <myproc>
80106167:	85 c0                	test   %eax,%eax
80106169:	0f 85 b8 fe ff ff    	jne    80106027 <trap+0xa7>
8010616f:	e9 d0 fe ff ff       	jmp    80106044 <trap+0xc4>
80106174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106178:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010617c:	8b 77 38             	mov    0x38(%edi),%esi
8010617f:	e8 ec d8 ff ff       	call   80103a70 <cpuid>
80106184:	56                   	push   %esi
80106185:	53                   	push   %ebx
80106186:	50                   	push   %eax
80106187:	68 c8 7f 10 80       	push   $0x80107fc8
8010618c:	e8 cf a4 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106191:	e8 ba c5 ff ff       	call   80102750 <lapiceoi>
    break;
80106196:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106199:	e8 f2 d8 ff ff       	call   80103a90 <myproc>
8010619e:	85 c0                	test   %eax,%eax
801061a0:	0f 85 81 fe ff ff    	jne    80106027 <trap+0xa7>
801061a6:	e9 99 fe ff ff       	jmp    80106044 <trap+0xc4>
801061ab:	90                   	nop
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801061b0:	e8 cb be ff ff       	call   80102080 <ideintr>
801061b5:	e9 63 ff ff ff       	jmp    8010611d <trap+0x19d>
801061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801061c0:	e8 4b e1 ff ff       	call   80104310 <exit>
801061c5:	e9 ce fe ff ff       	jmp    80106098 <trap+0x118>
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801061d0:	e8 3b e1 ff ff       	call   80104310 <exit>
801061d5:	e9 6a fe ff ff       	jmp    80106044 <trap+0xc4>
801061da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801061e0:	83 ec 0c             	sub    $0xc,%esp
801061e3:	68 80 d9 28 80       	push   $0x8028d980
801061e8:	e8 93 e9 ff ff       	call   80104b80 <acquire>
      wakeup(&ticks);
801061ed:	c7 04 24 c0 e1 28 80 	movl   $0x8028e1c0,(%esp)
      ticks++;
801061f4:	83 05 c0 e1 28 80 01 	addl   $0x1,0x8028e1c0
      wakeup(&ticks);
801061fb:	e8 50 e4 ff ff       	call   80104650 <wakeup>
      release(&tickslock);
80106200:	c7 04 24 80 d9 28 80 	movl   $0x8028d980,(%esp)
80106207:	e8 34 ea ff ff       	call   80104c40 <release>
8010620c:	83 c4 10             	add    $0x10,%esp
8010620f:	e9 09 ff ff ff       	jmp    8010611d <trap+0x19d>
80106214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if (priority == 1 && duration >= 2) yield();
80106218:	83 f9 01             	cmp    $0x1,%ecx
8010621b:	75 09                	jne    80106226 <trap+0x2a6>
8010621d:	83 f8 01             	cmp    $0x1,%eax
80106220:	0f 8f db fe ff ff    	jg     80106101 <trap+0x181>
    else if (priority == 2 && duration >= 8) yield();
80106226:	83 f9 02             	cmp    $0x2,%ecx
80106229:	0f 85 29 fe ff ff    	jne    80106058 <trap+0xd8>
8010622f:	83 f8 07             	cmp    $0x7,%eax
80106232:	0f 8e 20 fe ff ff    	jle    80106058 <trap+0xd8>
80106238:	e9 c4 fe ff ff       	jmp    80106101 <trap+0x181>
8010623d:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106240:	e8 2b d8 ff ff       	call   80103a70 <cpuid>
80106245:	83 ec 0c             	sub    $0xc,%esp
80106248:	56                   	push   %esi
80106249:	53                   	push   %ebx
8010624a:	50                   	push   %eax
8010624b:	ff 77 30             	pushl  0x30(%edi)
8010624e:	68 ec 7f 10 80       	push   $0x80107fec
80106253:	e8 08 a4 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106258:	83 c4 14             	add    $0x14,%esp
8010625b:	68 c2 7f 10 80       	push   $0x80107fc2
80106260:	e8 2b a1 ff ff       	call   80100390 <panic>
80106265:	66 90                	xchg   %ax,%ax
80106267:	66 90                	xchg   %ax,%ax
80106269:	66 90                	xchg   %ax,%ax
8010626b:	66 90                	xchg   %ax,%ax
8010626d:	66 90                	xchg   %ax,%ax
8010626f:	90                   	nop

80106270 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106270:	a1 c8 b5 10 80       	mov    0x8010b5c8,%eax
{
80106275:	55                   	push   %ebp
80106276:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106278:	85 c0                	test   %eax,%eax
8010627a:	74 1c                	je     80106298 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010627c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106281:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106282:	a8 01                	test   $0x1,%al
80106284:	74 12                	je     80106298 <uartgetc+0x28>
80106286:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010628b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010628c:	0f b6 c0             	movzbl %al,%eax
}
8010628f:	5d                   	pop    %ebp
80106290:	c3                   	ret    
80106291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010629d:	5d                   	pop    %ebp
8010629e:	c3                   	ret    
8010629f:	90                   	nop

801062a0 <uartputc.part.0>:
uartputc(int c)
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	57                   	push   %edi
801062a4:	56                   	push   %esi
801062a5:	53                   	push   %ebx
801062a6:	89 c7                	mov    %eax,%edi
801062a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801062ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801062b2:	83 ec 0c             	sub    $0xc,%esp
801062b5:	eb 1b                	jmp    801062d2 <uartputc.part.0+0x32>
801062b7:	89 f6                	mov    %esi,%esi
801062b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801062c0:	83 ec 0c             	sub    $0xc,%esp
801062c3:	6a 0a                	push   $0xa
801062c5:	e8 a6 c4 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062ca:	83 c4 10             	add    $0x10,%esp
801062cd:	83 eb 01             	sub    $0x1,%ebx
801062d0:	74 07                	je     801062d9 <uartputc.part.0+0x39>
801062d2:	89 f2                	mov    %esi,%edx
801062d4:	ec                   	in     (%dx),%al
801062d5:	a8 20                	test   $0x20,%al
801062d7:	74 e7                	je     801062c0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062de:	89 f8                	mov    %edi,%eax
801062e0:	ee                   	out    %al,(%dx)
}
801062e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062e4:	5b                   	pop    %ebx
801062e5:	5e                   	pop    %esi
801062e6:	5f                   	pop    %edi
801062e7:	5d                   	pop    %ebp
801062e8:	c3                   	ret    
801062e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062f0 <uartinit>:
{
801062f0:	55                   	push   %ebp
801062f1:	31 c9                	xor    %ecx,%ecx
801062f3:	89 c8                	mov    %ecx,%eax
801062f5:	89 e5                	mov    %esp,%ebp
801062f7:	57                   	push   %edi
801062f8:	56                   	push   %esi
801062f9:	53                   	push   %ebx
801062fa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801062ff:	89 da                	mov    %ebx,%edx
80106301:	83 ec 0c             	sub    $0xc,%esp
80106304:	ee                   	out    %al,(%dx)
80106305:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010630a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010630f:	89 fa                	mov    %edi,%edx
80106311:	ee                   	out    %al,(%dx)
80106312:	b8 0c 00 00 00       	mov    $0xc,%eax
80106317:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010631c:	ee                   	out    %al,(%dx)
8010631d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106322:	89 c8                	mov    %ecx,%eax
80106324:	89 f2                	mov    %esi,%edx
80106326:	ee                   	out    %al,(%dx)
80106327:	b8 03 00 00 00       	mov    $0x3,%eax
8010632c:	89 fa                	mov    %edi,%edx
8010632e:	ee                   	out    %al,(%dx)
8010632f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106334:	89 c8                	mov    %ecx,%eax
80106336:	ee                   	out    %al,(%dx)
80106337:	b8 01 00 00 00       	mov    $0x1,%eax
8010633c:	89 f2                	mov    %esi,%edx
8010633e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010633f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106344:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106345:	3c ff                	cmp    $0xff,%al
80106347:	74 5a                	je     801063a3 <uartinit+0xb3>
  uart = 1;
80106349:	c7 05 c8 b5 10 80 01 	movl   $0x1,0x8010b5c8
80106350:	00 00 00 
80106353:	89 da                	mov    %ebx,%edx
80106355:	ec                   	in     (%dx),%al
80106356:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010635b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010635c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010635f:	bb e4 80 10 80       	mov    $0x801080e4,%ebx
  ioapicenable(IRQ_COM1, 0);
80106364:	6a 00                	push   $0x0
80106366:	6a 04                	push   $0x4
80106368:	e8 63 bf ff ff       	call   801022d0 <ioapicenable>
8010636d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106370:	b8 78 00 00 00       	mov    $0x78,%eax
80106375:	eb 13                	jmp    8010638a <uartinit+0x9a>
80106377:	89 f6                	mov    %esi,%esi
80106379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106380:	83 c3 01             	add    $0x1,%ebx
80106383:	0f be 03             	movsbl (%ebx),%eax
80106386:	84 c0                	test   %al,%al
80106388:	74 19                	je     801063a3 <uartinit+0xb3>
  if(!uart)
8010638a:	8b 15 c8 b5 10 80    	mov    0x8010b5c8,%edx
80106390:	85 d2                	test   %edx,%edx
80106392:	74 ec                	je     80106380 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106394:	83 c3 01             	add    $0x1,%ebx
80106397:	e8 04 ff ff ff       	call   801062a0 <uartputc.part.0>
8010639c:	0f be 03             	movsbl (%ebx),%eax
8010639f:	84 c0                	test   %al,%al
801063a1:	75 e7                	jne    8010638a <uartinit+0x9a>
}
801063a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a6:	5b                   	pop    %ebx
801063a7:	5e                   	pop    %esi
801063a8:	5f                   	pop    %edi
801063a9:	5d                   	pop    %ebp
801063aa:	c3                   	ret    
801063ab:	90                   	nop
801063ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063b0 <uartputc>:
  if(!uart)
801063b0:	8b 15 c8 b5 10 80    	mov    0x8010b5c8,%edx
{
801063b6:	55                   	push   %ebp
801063b7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801063b9:	85 d2                	test   %edx,%edx
{
801063bb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063be:	74 10                	je     801063d0 <uartputc+0x20>
}
801063c0:	5d                   	pop    %ebp
801063c1:	e9 da fe ff ff       	jmp    801062a0 <uartputc.part.0>
801063c6:	8d 76 00             	lea    0x0(%esi),%esi
801063c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063d0:	5d                   	pop    %ebp
801063d1:	c3                   	ret    
801063d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063e0 <uartintr>:

void
uartintr(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063e6:	68 70 62 10 80       	push   $0x80106270
801063eb:	e8 20 a4 ff ff       	call   80100810 <consoleintr>
}
801063f0:	83 c4 10             	add    $0x10,%esp
801063f3:	c9                   	leave  
801063f4:	c3                   	ret    

801063f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $0
801063f7:	6a 00                	push   $0x0
  jmp alltraps
801063f9:	e9 a9 fa ff ff       	jmp    80105ea7 <alltraps>

801063fe <vector1>:
.globl vector1
vector1:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $1
80106400:	6a 01                	push   $0x1
  jmp alltraps
80106402:	e9 a0 fa ff ff       	jmp    80105ea7 <alltraps>

80106407 <vector2>:
.globl vector2
vector2:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $2
80106409:	6a 02                	push   $0x2
  jmp alltraps
8010640b:	e9 97 fa ff ff       	jmp    80105ea7 <alltraps>

80106410 <vector3>:
.globl vector3
vector3:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $3
80106412:	6a 03                	push   $0x3
  jmp alltraps
80106414:	e9 8e fa ff ff       	jmp    80105ea7 <alltraps>

80106419 <vector4>:
.globl vector4
vector4:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $4
8010641b:	6a 04                	push   $0x4
  jmp alltraps
8010641d:	e9 85 fa ff ff       	jmp    80105ea7 <alltraps>

80106422 <vector5>:
.globl vector5
vector5:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $5
80106424:	6a 05                	push   $0x5
  jmp alltraps
80106426:	e9 7c fa ff ff       	jmp    80105ea7 <alltraps>

8010642b <vector6>:
.globl vector6
vector6:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $6
8010642d:	6a 06                	push   $0x6
  jmp alltraps
8010642f:	e9 73 fa ff ff       	jmp    80105ea7 <alltraps>

80106434 <vector7>:
.globl vector7
vector7:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $7
80106436:	6a 07                	push   $0x7
  jmp alltraps
80106438:	e9 6a fa ff ff       	jmp    80105ea7 <alltraps>

8010643d <vector8>:
.globl vector8
vector8:
  pushl $8
8010643d:	6a 08                	push   $0x8
  jmp alltraps
8010643f:	e9 63 fa ff ff       	jmp    80105ea7 <alltraps>

80106444 <vector9>:
.globl vector9
vector9:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $9
80106446:	6a 09                	push   $0x9
  jmp alltraps
80106448:	e9 5a fa ff ff       	jmp    80105ea7 <alltraps>

8010644d <vector10>:
.globl vector10
vector10:
  pushl $10
8010644d:	6a 0a                	push   $0xa
  jmp alltraps
8010644f:	e9 53 fa ff ff       	jmp    80105ea7 <alltraps>

80106454 <vector11>:
.globl vector11
vector11:
  pushl $11
80106454:	6a 0b                	push   $0xb
  jmp alltraps
80106456:	e9 4c fa ff ff       	jmp    80105ea7 <alltraps>

8010645b <vector12>:
.globl vector12
vector12:
  pushl $12
8010645b:	6a 0c                	push   $0xc
  jmp alltraps
8010645d:	e9 45 fa ff ff       	jmp    80105ea7 <alltraps>

80106462 <vector13>:
.globl vector13
vector13:
  pushl $13
80106462:	6a 0d                	push   $0xd
  jmp alltraps
80106464:	e9 3e fa ff ff       	jmp    80105ea7 <alltraps>

80106469 <vector14>:
.globl vector14
vector14:
  pushl $14
80106469:	6a 0e                	push   $0xe
  jmp alltraps
8010646b:	e9 37 fa ff ff       	jmp    80105ea7 <alltraps>

80106470 <vector15>:
.globl vector15
vector15:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $15
80106472:	6a 0f                	push   $0xf
  jmp alltraps
80106474:	e9 2e fa ff ff       	jmp    80105ea7 <alltraps>

80106479 <vector16>:
.globl vector16
vector16:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $16
8010647b:	6a 10                	push   $0x10
  jmp alltraps
8010647d:	e9 25 fa ff ff       	jmp    80105ea7 <alltraps>

80106482 <vector17>:
.globl vector17
vector17:
  pushl $17
80106482:	6a 11                	push   $0x11
  jmp alltraps
80106484:	e9 1e fa ff ff       	jmp    80105ea7 <alltraps>

80106489 <vector18>:
.globl vector18
vector18:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $18
8010648b:	6a 12                	push   $0x12
  jmp alltraps
8010648d:	e9 15 fa ff ff       	jmp    80105ea7 <alltraps>

80106492 <vector19>:
.globl vector19
vector19:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $19
80106494:	6a 13                	push   $0x13
  jmp alltraps
80106496:	e9 0c fa ff ff       	jmp    80105ea7 <alltraps>

8010649b <vector20>:
.globl vector20
vector20:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $20
8010649d:	6a 14                	push   $0x14
  jmp alltraps
8010649f:	e9 03 fa ff ff       	jmp    80105ea7 <alltraps>

801064a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $21
801064a6:	6a 15                	push   $0x15
  jmp alltraps
801064a8:	e9 fa f9 ff ff       	jmp    80105ea7 <alltraps>

801064ad <vector22>:
.globl vector22
vector22:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $22
801064af:	6a 16                	push   $0x16
  jmp alltraps
801064b1:	e9 f1 f9 ff ff       	jmp    80105ea7 <alltraps>

801064b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $23
801064b8:	6a 17                	push   $0x17
  jmp alltraps
801064ba:	e9 e8 f9 ff ff       	jmp    80105ea7 <alltraps>

801064bf <vector24>:
.globl vector24
vector24:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $24
801064c1:	6a 18                	push   $0x18
  jmp alltraps
801064c3:	e9 df f9 ff ff       	jmp    80105ea7 <alltraps>

801064c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $25
801064ca:	6a 19                	push   $0x19
  jmp alltraps
801064cc:	e9 d6 f9 ff ff       	jmp    80105ea7 <alltraps>

801064d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $26
801064d3:	6a 1a                	push   $0x1a
  jmp alltraps
801064d5:	e9 cd f9 ff ff       	jmp    80105ea7 <alltraps>

801064da <vector27>:
.globl vector27
vector27:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $27
801064dc:	6a 1b                	push   $0x1b
  jmp alltraps
801064de:	e9 c4 f9 ff ff       	jmp    80105ea7 <alltraps>

801064e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $28
801064e5:	6a 1c                	push   $0x1c
  jmp alltraps
801064e7:	e9 bb f9 ff ff       	jmp    80105ea7 <alltraps>

801064ec <vector29>:
.globl vector29
vector29:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $29
801064ee:	6a 1d                	push   $0x1d
  jmp alltraps
801064f0:	e9 b2 f9 ff ff       	jmp    80105ea7 <alltraps>

801064f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $30
801064f7:	6a 1e                	push   $0x1e
  jmp alltraps
801064f9:	e9 a9 f9 ff ff       	jmp    80105ea7 <alltraps>

801064fe <vector31>:
.globl vector31
vector31:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $31
80106500:	6a 1f                	push   $0x1f
  jmp alltraps
80106502:	e9 a0 f9 ff ff       	jmp    80105ea7 <alltraps>

80106507 <vector32>:
.globl vector32
vector32:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $32
80106509:	6a 20                	push   $0x20
  jmp alltraps
8010650b:	e9 97 f9 ff ff       	jmp    80105ea7 <alltraps>

80106510 <vector33>:
.globl vector33
vector33:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $33
80106512:	6a 21                	push   $0x21
  jmp alltraps
80106514:	e9 8e f9 ff ff       	jmp    80105ea7 <alltraps>

80106519 <vector34>:
.globl vector34
vector34:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $34
8010651b:	6a 22                	push   $0x22
  jmp alltraps
8010651d:	e9 85 f9 ff ff       	jmp    80105ea7 <alltraps>

80106522 <vector35>:
.globl vector35
vector35:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $35
80106524:	6a 23                	push   $0x23
  jmp alltraps
80106526:	e9 7c f9 ff ff       	jmp    80105ea7 <alltraps>

8010652b <vector36>:
.globl vector36
vector36:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $36
8010652d:	6a 24                	push   $0x24
  jmp alltraps
8010652f:	e9 73 f9 ff ff       	jmp    80105ea7 <alltraps>

80106534 <vector37>:
.globl vector37
vector37:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $37
80106536:	6a 25                	push   $0x25
  jmp alltraps
80106538:	e9 6a f9 ff ff       	jmp    80105ea7 <alltraps>

8010653d <vector38>:
.globl vector38
vector38:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $38
8010653f:	6a 26                	push   $0x26
  jmp alltraps
80106541:	e9 61 f9 ff ff       	jmp    80105ea7 <alltraps>

80106546 <vector39>:
.globl vector39
vector39:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $39
80106548:	6a 27                	push   $0x27
  jmp alltraps
8010654a:	e9 58 f9 ff ff       	jmp    80105ea7 <alltraps>

8010654f <vector40>:
.globl vector40
vector40:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $40
80106551:	6a 28                	push   $0x28
  jmp alltraps
80106553:	e9 4f f9 ff ff       	jmp    80105ea7 <alltraps>

80106558 <vector41>:
.globl vector41
vector41:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $41
8010655a:	6a 29                	push   $0x29
  jmp alltraps
8010655c:	e9 46 f9 ff ff       	jmp    80105ea7 <alltraps>

80106561 <vector42>:
.globl vector42
vector42:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $42
80106563:	6a 2a                	push   $0x2a
  jmp alltraps
80106565:	e9 3d f9 ff ff       	jmp    80105ea7 <alltraps>

8010656a <vector43>:
.globl vector43
vector43:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $43
8010656c:	6a 2b                	push   $0x2b
  jmp alltraps
8010656e:	e9 34 f9 ff ff       	jmp    80105ea7 <alltraps>

80106573 <vector44>:
.globl vector44
vector44:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $44
80106575:	6a 2c                	push   $0x2c
  jmp alltraps
80106577:	e9 2b f9 ff ff       	jmp    80105ea7 <alltraps>

8010657c <vector45>:
.globl vector45
vector45:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $45
8010657e:	6a 2d                	push   $0x2d
  jmp alltraps
80106580:	e9 22 f9 ff ff       	jmp    80105ea7 <alltraps>

80106585 <vector46>:
.globl vector46
vector46:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $46
80106587:	6a 2e                	push   $0x2e
  jmp alltraps
80106589:	e9 19 f9 ff ff       	jmp    80105ea7 <alltraps>

8010658e <vector47>:
.globl vector47
vector47:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $47
80106590:	6a 2f                	push   $0x2f
  jmp alltraps
80106592:	e9 10 f9 ff ff       	jmp    80105ea7 <alltraps>

80106597 <vector48>:
.globl vector48
vector48:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $48
80106599:	6a 30                	push   $0x30
  jmp alltraps
8010659b:	e9 07 f9 ff ff       	jmp    80105ea7 <alltraps>

801065a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $49
801065a2:	6a 31                	push   $0x31
  jmp alltraps
801065a4:	e9 fe f8 ff ff       	jmp    80105ea7 <alltraps>

801065a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $50
801065ab:	6a 32                	push   $0x32
  jmp alltraps
801065ad:	e9 f5 f8 ff ff       	jmp    80105ea7 <alltraps>

801065b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $51
801065b4:	6a 33                	push   $0x33
  jmp alltraps
801065b6:	e9 ec f8 ff ff       	jmp    80105ea7 <alltraps>

801065bb <vector52>:
.globl vector52
vector52:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $52
801065bd:	6a 34                	push   $0x34
  jmp alltraps
801065bf:	e9 e3 f8 ff ff       	jmp    80105ea7 <alltraps>

801065c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $53
801065c6:	6a 35                	push   $0x35
  jmp alltraps
801065c8:	e9 da f8 ff ff       	jmp    80105ea7 <alltraps>

801065cd <vector54>:
.globl vector54
vector54:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $54
801065cf:	6a 36                	push   $0x36
  jmp alltraps
801065d1:	e9 d1 f8 ff ff       	jmp    80105ea7 <alltraps>

801065d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $55
801065d8:	6a 37                	push   $0x37
  jmp alltraps
801065da:	e9 c8 f8 ff ff       	jmp    80105ea7 <alltraps>

801065df <vector56>:
.globl vector56
vector56:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $56
801065e1:	6a 38                	push   $0x38
  jmp alltraps
801065e3:	e9 bf f8 ff ff       	jmp    80105ea7 <alltraps>

801065e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $57
801065ea:	6a 39                	push   $0x39
  jmp alltraps
801065ec:	e9 b6 f8 ff ff       	jmp    80105ea7 <alltraps>

801065f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $58
801065f3:	6a 3a                	push   $0x3a
  jmp alltraps
801065f5:	e9 ad f8 ff ff       	jmp    80105ea7 <alltraps>

801065fa <vector59>:
.globl vector59
vector59:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $59
801065fc:	6a 3b                	push   $0x3b
  jmp alltraps
801065fe:	e9 a4 f8 ff ff       	jmp    80105ea7 <alltraps>

80106603 <vector60>:
.globl vector60
vector60:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $60
80106605:	6a 3c                	push   $0x3c
  jmp alltraps
80106607:	e9 9b f8 ff ff       	jmp    80105ea7 <alltraps>

8010660c <vector61>:
.globl vector61
vector61:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $61
8010660e:	6a 3d                	push   $0x3d
  jmp alltraps
80106610:	e9 92 f8 ff ff       	jmp    80105ea7 <alltraps>

80106615 <vector62>:
.globl vector62
vector62:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $62
80106617:	6a 3e                	push   $0x3e
  jmp alltraps
80106619:	e9 89 f8 ff ff       	jmp    80105ea7 <alltraps>

8010661e <vector63>:
.globl vector63
vector63:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $63
80106620:	6a 3f                	push   $0x3f
  jmp alltraps
80106622:	e9 80 f8 ff ff       	jmp    80105ea7 <alltraps>

80106627 <vector64>:
.globl vector64
vector64:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $64
80106629:	6a 40                	push   $0x40
  jmp alltraps
8010662b:	e9 77 f8 ff ff       	jmp    80105ea7 <alltraps>

80106630 <vector65>:
.globl vector65
vector65:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $65
80106632:	6a 41                	push   $0x41
  jmp alltraps
80106634:	e9 6e f8 ff ff       	jmp    80105ea7 <alltraps>

80106639 <vector66>:
.globl vector66
vector66:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $66
8010663b:	6a 42                	push   $0x42
  jmp alltraps
8010663d:	e9 65 f8 ff ff       	jmp    80105ea7 <alltraps>

80106642 <vector67>:
.globl vector67
vector67:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $67
80106644:	6a 43                	push   $0x43
  jmp alltraps
80106646:	e9 5c f8 ff ff       	jmp    80105ea7 <alltraps>

8010664b <vector68>:
.globl vector68
vector68:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $68
8010664d:	6a 44                	push   $0x44
  jmp alltraps
8010664f:	e9 53 f8 ff ff       	jmp    80105ea7 <alltraps>

80106654 <vector69>:
.globl vector69
vector69:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $69
80106656:	6a 45                	push   $0x45
  jmp alltraps
80106658:	e9 4a f8 ff ff       	jmp    80105ea7 <alltraps>

8010665d <vector70>:
.globl vector70
vector70:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $70
8010665f:	6a 46                	push   $0x46
  jmp alltraps
80106661:	e9 41 f8 ff ff       	jmp    80105ea7 <alltraps>

80106666 <vector71>:
.globl vector71
vector71:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $71
80106668:	6a 47                	push   $0x47
  jmp alltraps
8010666a:	e9 38 f8 ff ff       	jmp    80105ea7 <alltraps>

8010666f <vector72>:
.globl vector72
vector72:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $72
80106671:	6a 48                	push   $0x48
  jmp alltraps
80106673:	e9 2f f8 ff ff       	jmp    80105ea7 <alltraps>

80106678 <vector73>:
.globl vector73
vector73:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $73
8010667a:	6a 49                	push   $0x49
  jmp alltraps
8010667c:	e9 26 f8 ff ff       	jmp    80105ea7 <alltraps>

80106681 <vector74>:
.globl vector74
vector74:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $74
80106683:	6a 4a                	push   $0x4a
  jmp alltraps
80106685:	e9 1d f8 ff ff       	jmp    80105ea7 <alltraps>

8010668a <vector75>:
.globl vector75
vector75:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $75
8010668c:	6a 4b                	push   $0x4b
  jmp alltraps
8010668e:	e9 14 f8 ff ff       	jmp    80105ea7 <alltraps>

80106693 <vector76>:
.globl vector76
vector76:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $76
80106695:	6a 4c                	push   $0x4c
  jmp alltraps
80106697:	e9 0b f8 ff ff       	jmp    80105ea7 <alltraps>

8010669c <vector77>:
.globl vector77
vector77:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $77
8010669e:	6a 4d                	push   $0x4d
  jmp alltraps
801066a0:	e9 02 f8 ff ff       	jmp    80105ea7 <alltraps>

801066a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $78
801066a7:	6a 4e                	push   $0x4e
  jmp alltraps
801066a9:	e9 f9 f7 ff ff       	jmp    80105ea7 <alltraps>

801066ae <vector79>:
.globl vector79
vector79:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $79
801066b0:	6a 4f                	push   $0x4f
  jmp alltraps
801066b2:	e9 f0 f7 ff ff       	jmp    80105ea7 <alltraps>

801066b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $80
801066b9:	6a 50                	push   $0x50
  jmp alltraps
801066bb:	e9 e7 f7 ff ff       	jmp    80105ea7 <alltraps>

801066c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $81
801066c2:	6a 51                	push   $0x51
  jmp alltraps
801066c4:	e9 de f7 ff ff       	jmp    80105ea7 <alltraps>

801066c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $82
801066cb:	6a 52                	push   $0x52
  jmp alltraps
801066cd:	e9 d5 f7 ff ff       	jmp    80105ea7 <alltraps>

801066d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $83
801066d4:	6a 53                	push   $0x53
  jmp alltraps
801066d6:	e9 cc f7 ff ff       	jmp    80105ea7 <alltraps>

801066db <vector84>:
.globl vector84
vector84:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $84
801066dd:	6a 54                	push   $0x54
  jmp alltraps
801066df:	e9 c3 f7 ff ff       	jmp    80105ea7 <alltraps>

801066e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $85
801066e6:	6a 55                	push   $0x55
  jmp alltraps
801066e8:	e9 ba f7 ff ff       	jmp    80105ea7 <alltraps>

801066ed <vector86>:
.globl vector86
vector86:
  pushl $0
801066ed:	6a 00                	push   $0x0
  pushl $86
801066ef:	6a 56                	push   $0x56
  jmp alltraps
801066f1:	e9 b1 f7 ff ff       	jmp    80105ea7 <alltraps>

801066f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $87
801066f8:	6a 57                	push   $0x57
  jmp alltraps
801066fa:	e9 a8 f7 ff ff       	jmp    80105ea7 <alltraps>

801066ff <vector88>:
.globl vector88
vector88:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $88
80106701:	6a 58                	push   $0x58
  jmp alltraps
80106703:	e9 9f f7 ff ff       	jmp    80105ea7 <alltraps>

80106708 <vector89>:
.globl vector89
vector89:
  pushl $0
80106708:	6a 00                	push   $0x0
  pushl $89
8010670a:	6a 59                	push   $0x59
  jmp alltraps
8010670c:	e9 96 f7 ff ff       	jmp    80105ea7 <alltraps>

80106711 <vector90>:
.globl vector90
vector90:
  pushl $0
80106711:	6a 00                	push   $0x0
  pushl $90
80106713:	6a 5a                	push   $0x5a
  jmp alltraps
80106715:	e9 8d f7 ff ff       	jmp    80105ea7 <alltraps>

8010671a <vector91>:
.globl vector91
vector91:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $91
8010671c:	6a 5b                	push   $0x5b
  jmp alltraps
8010671e:	e9 84 f7 ff ff       	jmp    80105ea7 <alltraps>

80106723 <vector92>:
.globl vector92
vector92:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $92
80106725:	6a 5c                	push   $0x5c
  jmp alltraps
80106727:	e9 7b f7 ff ff       	jmp    80105ea7 <alltraps>

8010672c <vector93>:
.globl vector93
vector93:
  pushl $0
8010672c:	6a 00                	push   $0x0
  pushl $93
8010672e:	6a 5d                	push   $0x5d
  jmp alltraps
80106730:	e9 72 f7 ff ff       	jmp    80105ea7 <alltraps>

80106735 <vector94>:
.globl vector94
vector94:
  pushl $0
80106735:	6a 00                	push   $0x0
  pushl $94
80106737:	6a 5e                	push   $0x5e
  jmp alltraps
80106739:	e9 69 f7 ff ff       	jmp    80105ea7 <alltraps>

8010673e <vector95>:
.globl vector95
vector95:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $95
80106740:	6a 5f                	push   $0x5f
  jmp alltraps
80106742:	e9 60 f7 ff ff       	jmp    80105ea7 <alltraps>

80106747 <vector96>:
.globl vector96
vector96:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $96
80106749:	6a 60                	push   $0x60
  jmp alltraps
8010674b:	e9 57 f7 ff ff       	jmp    80105ea7 <alltraps>

80106750 <vector97>:
.globl vector97
vector97:
  pushl $0
80106750:	6a 00                	push   $0x0
  pushl $97
80106752:	6a 61                	push   $0x61
  jmp alltraps
80106754:	e9 4e f7 ff ff       	jmp    80105ea7 <alltraps>

80106759 <vector98>:
.globl vector98
vector98:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $98
8010675b:	6a 62                	push   $0x62
  jmp alltraps
8010675d:	e9 45 f7 ff ff       	jmp    80105ea7 <alltraps>

80106762 <vector99>:
.globl vector99
vector99:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $99
80106764:	6a 63                	push   $0x63
  jmp alltraps
80106766:	e9 3c f7 ff ff       	jmp    80105ea7 <alltraps>

8010676b <vector100>:
.globl vector100
vector100:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $100
8010676d:	6a 64                	push   $0x64
  jmp alltraps
8010676f:	e9 33 f7 ff ff       	jmp    80105ea7 <alltraps>

80106774 <vector101>:
.globl vector101
vector101:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $101
80106776:	6a 65                	push   $0x65
  jmp alltraps
80106778:	e9 2a f7 ff ff       	jmp    80105ea7 <alltraps>

8010677d <vector102>:
.globl vector102
vector102:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $102
8010677f:	6a 66                	push   $0x66
  jmp alltraps
80106781:	e9 21 f7 ff ff       	jmp    80105ea7 <alltraps>

80106786 <vector103>:
.globl vector103
vector103:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $103
80106788:	6a 67                	push   $0x67
  jmp alltraps
8010678a:	e9 18 f7 ff ff       	jmp    80105ea7 <alltraps>

8010678f <vector104>:
.globl vector104
vector104:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $104
80106791:	6a 68                	push   $0x68
  jmp alltraps
80106793:	e9 0f f7 ff ff       	jmp    80105ea7 <alltraps>

80106798 <vector105>:
.globl vector105
vector105:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $105
8010679a:	6a 69                	push   $0x69
  jmp alltraps
8010679c:	e9 06 f7 ff ff       	jmp    80105ea7 <alltraps>

801067a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $106
801067a3:	6a 6a                	push   $0x6a
  jmp alltraps
801067a5:	e9 fd f6 ff ff       	jmp    80105ea7 <alltraps>

801067aa <vector107>:
.globl vector107
vector107:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $107
801067ac:	6a 6b                	push   $0x6b
  jmp alltraps
801067ae:	e9 f4 f6 ff ff       	jmp    80105ea7 <alltraps>

801067b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $108
801067b5:	6a 6c                	push   $0x6c
  jmp alltraps
801067b7:	e9 eb f6 ff ff       	jmp    80105ea7 <alltraps>

801067bc <vector109>:
.globl vector109
vector109:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $109
801067be:	6a 6d                	push   $0x6d
  jmp alltraps
801067c0:	e9 e2 f6 ff ff       	jmp    80105ea7 <alltraps>

801067c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $110
801067c7:	6a 6e                	push   $0x6e
  jmp alltraps
801067c9:	e9 d9 f6 ff ff       	jmp    80105ea7 <alltraps>

801067ce <vector111>:
.globl vector111
vector111:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $111
801067d0:	6a 6f                	push   $0x6f
  jmp alltraps
801067d2:	e9 d0 f6 ff ff       	jmp    80105ea7 <alltraps>

801067d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $112
801067d9:	6a 70                	push   $0x70
  jmp alltraps
801067db:	e9 c7 f6 ff ff       	jmp    80105ea7 <alltraps>

801067e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $113
801067e2:	6a 71                	push   $0x71
  jmp alltraps
801067e4:	e9 be f6 ff ff       	jmp    80105ea7 <alltraps>

801067e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $114
801067eb:	6a 72                	push   $0x72
  jmp alltraps
801067ed:	e9 b5 f6 ff ff       	jmp    80105ea7 <alltraps>

801067f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $115
801067f4:	6a 73                	push   $0x73
  jmp alltraps
801067f6:	e9 ac f6 ff ff       	jmp    80105ea7 <alltraps>

801067fb <vector116>:
.globl vector116
vector116:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $116
801067fd:	6a 74                	push   $0x74
  jmp alltraps
801067ff:	e9 a3 f6 ff ff       	jmp    80105ea7 <alltraps>

80106804 <vector117>:
.globl vector117
vector117:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $117
80106806:	6a 75                	push   $0x75
  jmp alltraps
80106808:	e9 9a f6 ff ff       	jmp    80105ea7 <alltraps>

8010680d <vector118>:
.globl vector118
vector118:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $118
8010680f:	6a 76                	push   $0x76
  jmp alltraps
80106811:	e9 91 f6 ff ff       	jmp    80105ea7 <alltraps>

80106816 <vector119>:
.globl vector119
vector119:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $119
80106818:	6a 77                	push   $0x77
  jmp alltraps
8010681a:	e9 88 f6 ff ff       	jmp    80105ea7 <alltraps>

8010681f <vector120>:
.globl vector120
vector120:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $120
80106821:	6a 78                	push   $0x78
  jmp alltraps
80106823:	e9 7f f6 ff ff       	jmp    80105ea7 <alltraps>

80106828 <vector121>:
.globl vector121
vector121:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $121
8010682a:	6a 79                	push   $0x79
  jmp alltraps
8010682c:	e9 76 f6 ff ff       	jmp    80105ea7 <alltraps>

80106831 <vector122>:
.globl vector122
vector122:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $122
80106833:	6a 7a                	push   $0x7a
  jmp alltraps
80106835:	e9 6d f6 ff ff       	jmp    80105ea7 <alltraps>

8010683a <vector123>:
.globl vector123
vector123:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $123
8010683c:	6a 7b                	push   $0x7b
  jmp alltraps
8010683e:	e9 64 f6 ff ff       	jmp    80105ea7 <alltraps>

80106843 <vector124>:
.globl vector124
vector124:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $124
80106845:	6a 7c                	push   $0x7c
  jmp alltraps
80106847:	e9 5b f6 ff ff       	jmp    80105ea7 <alltraps>

8010684c <vector125>:
.globl vector125
vector125:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $125
8010684e:	6a 7d                	push   $0x7d
  jmp alltraps
80106850:	e9 52 f6 ff ff       	jmp    80105ea7 <alltraps>

80106855 <vector126>:
.globl vector126
vector126:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $126
80106857:	6a 7e                	push   $0x7e
  jmp alltraps
80106859:	e9 49 f6 ff ff       	jmp    80105ea7 <alltraps>

8010685e <vector127>:
.globl vector127
vector127:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $127
80106860:	6a 7f                	push   $0x7f
  jmp alltraps
80106862:	e9 40 f6 ff ff       	jmp    80105ea7 <alltraps>

80106867 <vector128>:
.globl vector128
vector128:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $128
80106869:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010686e:	e9 34 f6 ff ff       	jmp    80105ea7 <alltraps>

80106873 <vector129>:
.globl vector129
vector129:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $129
80106875:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010687a:	e9 28 f6 ff ff       	jmp    80105ea7 <alltraps>

8010687f <vector130>:
.globl vector130
vector130:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $130
80106881:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106886:	e9 1c f6 ff ff       	jmp    80105ea7 <alltraps>

8010688b <vector131>:
.globl vector131
vector131:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $131
8010688d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106892:	e9 10 f6 ff ff       	jmp    80105ea7 <alltraps>

80106897 <vector132>:
.globl vector132
vector132:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $132
80106899:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010689e:	e9 04 f6 ff ff       	jmp    80105ea7 <alltraps>

801068a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $133
801068a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068aa:	e9 f8 f5 ff ff       	jmp    80105ea7 <alltraps>

801068af <vector134>:
.globl vector134
vector134:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $134
801068b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068b6:	e9 ec f5 ff ff       	jmp    80105ea7 <alltraps>

801068bb <vector135>:
.globl vector135
vector135:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $135
801068bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068c2:	e9 e0 f5 ff ff       	jmp    80105ea7 <alltraps>

801068c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $136
801068c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068ce:	e9 d4 f5 ff ff       	jmp    80105ea7 <alltraps>

801068d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $137
801068d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068da:	e9 c8 f5 ff ff       	jmp    80105ea7 <alltraps>

801068df <vector138>:
.globl vector138
vector138:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $138
801068e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068e6:	e9 bc f5 ff ff       	jmp    80105ea7 <alltraps>

801068eb <vector139>:
.globl vector139
vector139:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $139
801068ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801068f2:	e9 b0 f5 ff ff       	jmp    80105ea7 <alltraps>

801068f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $140
801068f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801068fe:	e9 a4 f5 ff ff       	jmp    80105ea7 <alltraps>

80106903 <vector141>:
.globl vector141
vector141:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $141
80106905:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010690a:	e9 98 f5 ff ff       	jmp    80105ea7 <alltraps>

8010690f <vector142>:
.globl vector142
vector142:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $142
80106911:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106916:	e9 8c f5 ff ff       	jmp    80105ea7 <alltraps>

8010691b <vector143>:
.globl vector143
vector143:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $143
8010691d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106922:	e9 80 f5 ff ff       	jmp    80105ea7 <alltraps>

80106927 <vector144>:
.globl vector144
vector144:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $144
80106929:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010692e:	e9 74 f5 ff ff       	jmp    80105ea7 <alltraps>

80106933 <vector145>:
.globl vector145
vector145:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $145
80106935:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010693a:	e9 68 f5 ff ff       	jmp    80105ea7 <alltraps>

8010693f <vector146>:
.globl vector146
vector146:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $146
80106941:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106946:	e9 5c f5 ff ff       	jmp    80105ea7 <alltraps>

8010694b <vector147>:
.globl vector147
vector147:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $147
8010694d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106952:	e9 50 f5 ff ff       	jmp    80105ea7 <alltraps>

80106957 <vector148>:
.globl vector148
vector148:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $148
80106959:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010695e:	e9 44 f5 ff ff       	jmp    80105ea7 <alltraps>

80106963 <vector149>:
.globl vector149
vector149:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $149
80106965:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010696a:	e9 38 f5 ff ff       	jmp    80105ea7 <alltraps>

8010696f <vector150>:
.globl vector150
vector150:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $150
80106971:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106976:	e9 2c f5 ff ff       	jmp    80105ea7 <alltraps>

8010697b <vector151>:
.globl vector151
vector151:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $151
8010697d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106982:	e9 20 f5 ff ff       	jmp    80105ea7 <alltraps>

80106987 <vector152>:
.globl vector152
vector152:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $152
80106989:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010698e:	e9 14 f5 ff ff       	jmp    80105ea7 <alltraps>

80106993 <vector153>:
.globl vector153
vector153:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $153
80106995:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010699a:	e9 08 f5 ff ff       	jmp    80105ea7 <alltraps>

8010699f <vector154>:
.globl vector154
vector154:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $154
801069a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069a6:	e9 fc f4 ff ff       	jmp    80105ea7 <alltraps>

801069ab <vector155>:
.globl vector155
vector155:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $155
801069ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069b2:	e9 f0 f4 ff ff       	jmp    80105ea7 <alltraps>

801069b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $156
801069b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069be:	e9 e4 f4 ff ff       	jmp    80105ea7 <alltraps>

801069c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $157
801069c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069ca:	e9 d8 f4 ff ff       	jmp    80105ea7 <alltraps>

801069cf <vector158>:
.globl vector158
vector158:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $158
801069d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069d6:	e9 cc f4 ff ff       	jmp    80105ea7 <alltraps>

801069db <vector159>:
.globl vector159
vector159:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $159
801069dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069e2:	e9 c0 f4 ff ff       	jmp    80105ea7 <alltraps>

801069e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $160
801069e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801069ee:	e9 b4 f4 ff ff       	jmp    80105ea7 <alltraps>

801069f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $161
801069f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801069fa:	e9 a8 f4 ff ff       	jmp    80105ea7 <alltraps>

801069ff <vector162>:
.globl vector162
vector162:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $162
80106a01:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a06:	e9 9c f4 ff ff       	jmp    80105ea7 <alltraps>

80106a0b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $163
80106a0d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a12:	e9 90 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a17 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $164
80106a19:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a1e:	e9 84 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a23 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $165
80106a25:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a2a:	e9 78 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a2f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $166
80106a31:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a36:	e9 6c f4 ff ff       	jmp    80105ea7 <alltraps>

80106a3b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $167
80106a3d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a42:	e9 60 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a47 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $168
80106a49:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a4e:	e9 54 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a53 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $169
80106a55:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a5a:	e9 48 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a5f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $170
80106a61:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a66:	e9 3c f4 ff ff       	jmp    80105ea7 <alltraps>

80106a6b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $171
80106a6d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a72:	e9 30 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a77 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $172
80106a79:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a7e:	e9 24 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a83 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $173
80106a85:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a8a:	e9 18 f4 ff ff       	jmp    80105ea7 <alltraps>

80106a8f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $174
80106a91:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a96:	e9 0c f4 ff ff       	jmp    80105ea7 <alltraps>

80106a9b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $175
80106a9d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106aa2:	e9 00 f4 ff ff       	jmp    80105ea7 <alltraps>

80106aa7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $176
80106aa9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106aae:	e9 f4 f3 ff ff       	jmp    80105ea7 <alltraps>

80106ab3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $177
80106ab5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aba:	e9 e8 f3 ff ff       	jmp    80105ea7 <alltraps>

80106abf <vector178>:
.globl vector178
vector178:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $178
80106ac1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ac6:	e9 dc f3 ff ff       	jmp    80105ea7 <alltraps>

80106acb <vector179>:
.globl vector179
vector179:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $179
80106acd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ad2:	e9 d0 f3 ff ff       	jmp    80105ea7 <alltraps>

80106ad7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $180
80106ad9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ade:	e9 c4 f3 ff ff       	jmp    80105ea7 <alltraps>

80106ae3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $181
80106ae5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106aea:	e9 b8 f3 ff ff       	jmp    80105ea7 <alltraps>

80106aef <vector182>:
.globl vector182
vector182:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $182
80106af1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106af6:	e9 ac f3 ff ff       	jmp    80105ea7 <alltraps>

80106afb <vector183>:
.globl vector183
vector183:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $183
80106afd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b02:	e9 a0 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b07 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $184
80106b09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b0e:	e9 94 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b13 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $185
80106b15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b1a:	e9 88 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b1f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $186
80106b21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b26:	e9 7c f3 ff ff       	jmp    80105ea7 <alltraps>

80106b2b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $187
80106b2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b32:	e9 70 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b37 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $188
80106b39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b3e:	e9 64 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b43 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $189
80106b45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b4a:	e9 58 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b4f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $190
80106b51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b56:	e9 4c f3 ff ff       	jmp    80105ea7 <alltraps>

80106b5b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $191
80106b5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b62:	e9 40 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b67 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $192
80106b69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b6e:	e9 34 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b73 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $193
80106b75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b7a:	e9 28 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b7f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $194
80106b81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b86:	e9 1c f3 ff ff       	jmp    80105ea7 <alltraps>

80106b8b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $195
80106b8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b92:	e9 10 f3 ff ff       	jmp    80105ea7 <alltraps>

80106b97 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $196
80106b99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b9e:	e9 04 f3 ff ff       	jmp    80105ea7 <alltraps>

80106ba3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $197
80106ba5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106baa:	e9 f8 f2 ff ff       	jmp    80105ea7 <alltraps>

80106baf <vector198>:
.globl vector198
vector198:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $198
80106bb1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106bb6:	e9 ec f2 ff ff       	jmp    80105ea7 <alltraps>

80106bbb <vector199>:
.globl vector199
vector199:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $199
80106bbd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bc2:	e9 e0 f2 ff ff       	jmp    80105ea7 <alltraps>

80106bc7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $200
80106bc9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bce:	e9 d4 f2 ff ff       	jmp    80105ea7 <alltraps>

80106bd3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $201
80106bd5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bda:	e9 c8 f2 ff ff       	jmp    80105ea7 <alltraps>

80106bdf <vector202>:
.globl vector202
vector202:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $202
80106be1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106be6:	e9 bc f2 ff ff       	jmp    80105ea7 <alltraps>

80106beb <vector203>:
.globl vector203
vector203:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $203
80106bed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106bf2:	e9 b0 f2 ff ff       	jmp    80105ea7 <alltraps>

80106bf7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $204
80106bf9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106bfe:	e9 a4 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c03 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $205
80106c05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c0a:	e9 98 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c0f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $206
80106c11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c16:	e9 8c f2 ff ff       	jmp    80105ea7 <alltraps>

80106c1b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $207
80106c1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c22:	e9 80 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c27 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $208
80106c29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c2e:	e9 74 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c33 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $209
80106c35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c3a:	e9 68 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c3f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $210
80106c41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c46:	e9 5c f2 ff ff       	jmp    80105ea7 <alltraps>

80106c4b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $211
80106c4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c52:	e9 50 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c57 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $212
80106c59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c5e:	e9 44 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c63 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $213
80106c65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c6a:	e9 38 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c6f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $214
80106c71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c76:	e9 2c f2 ff ff       	jmp    80105ea7 <alltraps>

80106c7b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $215
80106c7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c82:	e9 20 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c87 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $216
80106c89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c8e:	e9 14 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c93 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $217
80106c95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c9a:	e9 08 f2 ff ff       	jmp    80105ea7 <alltraps>

80106c9f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $218
80106ca1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ca6:	e9 fc f1 ff ff       	jmp    80105ea7 <alltraps>

80106cab <vector219>:
.globl vector219
vector219:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $219
80106cad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106cb2:	e9 f0 f1 ff ff       	jmp    80105ea7 <alltraps>

80106cb7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $220
80106cb9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cbe:	e9 e4 f1 ff ff       	jmp    80105ea7 <alltraps>

80106cc3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $221
80106cc5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cca:	e9 d8 f1 ff ff       	jmp    80105ea7 <alltraps>

80106ccf <vector222>:
.globl vector222
vector222:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $222
80106cd1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106cd6:	e9 cc f1 ff ff       	jmp    80105ea7 <alltraps>

80106cdb <vector223>:
.globl vector223
vector223:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $223
80106cdd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ce2:	e9 c0 f1 ff ff       	jmp    80105ea7 <alltraps>

80106ce7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $224
80106ce9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106cee:	e9 b4 f1 ff ff       	jmp    80105ea7 <alltraps>

80106cf3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $225
80106cf5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106cfa:	e9 a8 f1 ff ff       	jmp    80105ea7 <alltraps>

80106cff <vector226>:
.globl vector226
vector226:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $226
80106d01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d06:	e9 9c f1 ff ff       	jmp    80105ea7 <alltraps>

80106d0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $227
80106d0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d12:	e9 90 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $228
80106d19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d1e:	e9 84 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $229
80106d25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d2a:	e9 78 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $230
80106d31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d36:	e9 6c f1 ff ff       	jmp    80105ea7 <alltraps>

80106d3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $231
80106d3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d42:	e9 60 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $232
80106d49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d4e:	e9 54 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $233
80106d55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d5a:	e9 48 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $234
80106d61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d66:	e9 3c f1 ff ff       	jmp    80105ea7 <alltraps>

80106d6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $235
80106d6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d72:	e9 30 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $236
80106d79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d7e:	e9 24 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $237
80106d85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d8a:	e9 18 f1 ff ff       	jmp    80105ea7 <alltraps>

80106d8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $238
80106d91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d96:	e9 0c f1 ff ff       	jmp    80105ea7 <alltraps>

80106d9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $239
80106d9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106da2:	e9 00 f1 ff ff       	jmp    80105ea7 <alltraps>

80106da7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $240
80106da9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dae:	e9 f4 f0 ff ff       	jmp    80105ea7 <alltraps>

80106db3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $241
80106db5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dba:	e9 e8 f0 ff ff       	jmp    80105ea7 <alltraps>

80106dbf <vector242>:
.globl vector242
vector242:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $242
80106dc1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106dc6:	e9 dc f0 ff ff       	jmp    80105ea7 <alltraps>

80106dcb <vector243>:
.globl vector243
vector243:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $243
80106dcd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106dd2:	e9 d0 f0 ff ff       	jmp    80105ea7 <alltraps>

80106dd7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $244
80106dd9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106dde:	e9 c4 f0 ff ff       	jmp    80105ea7 <alltraps>

80106de3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $245
80106de5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dea:	e9 b8 f0 ff ff       	jmp    80105ea7 <alltraps>

80106def <vector246>:
.globl vector246
vector246:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $246
80106df1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106df6:	e9 ac f0 ff ff       	jmp    80105ea7 <alltraps>

80106dfb <vector247>:
.globl vector247
vector247:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $247
80106dfd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e02:	e9 a0 f0 ff ff       	jmp    80105ea7 <alltraps>

80106e07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $248
80106e09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e0e:	e9 94 f0 ff ff       	jmp    80105ea7 <alltraps>

80106e13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $249
80106e15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e1a:	e9 88 f0 ff ff       	jmp    80105ea7 <alltraps>

80106e1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $250
80106e21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e26:	e9 7c f0 ff ff       	jmp    80105ea7 <alltraps>

80106e2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $251
80106e2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e32:	e9 70 f0 ff ff       	jmp    80105ea7 <alltraps>

80106e37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $252
80106e39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e3e:	e9 64 f0 ff ff       	jmp    80105ea7 <alltraps>

80106e43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $253
80106e45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e4a:	e9 58 f0 ff ff       	jmp    80105ea7 <alltraps>

80106e4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $254
80106e51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e56:	e9 4c f0 ff ff       	jmp    80105ea7 <alltraps>

80106e5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $255
80106e5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e62:	e9 40 f0 ff ff       	jmp    80105ea7 <alltraps>
80106e67:	66 90                	xchg   %ax,%ax
80106e69:	66 90                	xchg   %ax,%ax
80106e6b:	66 90                	xchg   %ax,%ax
80106e6d:	66 90                	xchg   %ax,%ax
80106e6f:	90                   	nop

80106e70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e76:	89 d3                	mov    %edx,%ebx
{
80106e78:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106e7a:	c1 eb 16             	shr    $0x16,%ebx
80106e7d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106e80:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e83:	8b 06                	mov    (%esi),%eax
80106e85:	a8 01                	test   $0x1,%al
80106e87:	74 27                	je     80106eb0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e8e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e94:	c1 ef 0a             	shr    $0xa,%edi
}
80106e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e9a:	89 fa                	mov    %edi,%edx
80106e9c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ea2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ea5:	5b                   	pop    %ebx
80106ea6:	5e                   	pop    %esi
80106ea7:	5f                   	pop    %edi
80106ea8:	5d                   	pop    %ebp
80106ea9:	c3                   	ret    
80106eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106eb0:	85 c9                	test   %ecx,%ecx
80106eb2:	74 2c                	je     80106ee0 <walkpgdir+0x70>
80106eb4:	e8 07 b6 ff ff       	call   801024c0 <kalloc>
80106eb9:	85 c0                	test   %eax,%eax
80106ebb:	89 c3                	mov    %eax,%ebx
80106ebd:	74 21                	je     80106ee0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106ebf:	83 ec 04             	sub    $0x4,%esp
80106ec2:	68 00 10 00 00       	push   $0x1000
80106ec7:	6a 00                	push   $0x0
80106ec9:	50                   	push   %eax
80106eca:	e8 c1 dd ff ff       	call   80104c90 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ecf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ed5:	83 c4 10             	add    $0x10,%esp
80106ed8:	83 c8 07             	or     $0x7,%eax
80106edb:	89 06                	mov    %eax,(%esi)
80106edd:	eb b5                	jmp    80106e94 <walkpgdir+0x24>
80106edf:	90                   	nop
}
80106ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ee3:	31 c0                	xor    %eax,%eax
}
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5f                   	pop    %edi
80106ee8:	5d                   	pop    %ebp
80106ee9:	c3                   	ret    
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ef0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ef6:	89 d3                	mov    %edx,%ebx
80106ef8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106efe:	83 ec 1c             	sub    $0x1c,%esp
80106f01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f16:	29 df                	sub    %ebx,%edi
80106f18:	83 c8 01             	or     $0x1,%eax
80106f1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f1e:	eb 15                	jmp    80106f35 <mappages+0x45>
    if(*pte & PTE_P)
80106f20:	f6 00 01             	testb  $0x1,(%eax)
80106f23:	75 45                	jne    80106f6a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106f25:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106f28:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106f2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f2d:	74 31                	je     80106f60 <mappages+0x70>
      break;
    a += PGSIZE;
80106f2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f38:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f3d:	89 da                	mov    %ebx,%edx
80106f3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f42:	e8 29 ff ff ff       	call   80106e70 <walkpgdir>
80106f47:	85 c0                	test   %eax,%eax
80106f49:	75 d5                	jne    80106f20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f53:	5b                   	pop    %ebx
80106f54:	5e                   	pop    %esi
80106f55:	5f                   	pop    %edi
80106f56:	5d                   	pop    %ebp
80106f57:	c3                   	ret    
80106f58:	90                   	nop
80106f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f63:	31 c0                	xor    %eax,%eax
}
80106f65:	5b                   	pop    %ebx
80106f66:	5e                   	pop    %esi
80106f67:	5f                   	pop    %edi
80106f68:	5d                   	pop    %ebp
80106f69:	c3                   	ret    
      panic("remap");
80106f6a:	83 ec 0c             	sub    $0xc,%esp
80106f6d:	68 ec 80 10 80       	push   $0x801080ec
80106f72:	e8 19 94 ff ff       	call   80100390 <panic>
80106f77:	89 f6                	mov    %esi,%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f8c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106f8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f94:	83 ec 1c             	sub    $0x1c,%esp
80106f97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f9a:	39 d3                	cmp    %edx,%ebx
80106f9c:	73 66                	jae    80107004 <deallocuvm.part.0+0x84>
80106f9e:	89 d6                	mov    %edx,%esi
80106fa0:	eb 3d                	jmp    80106fdf <deallocuvm.part.0+0x5f>
80106fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106fa8:	8b 10                	mov    (%eax),%edx
80106faa:	f6 c2 01             	test   $0x1,%dl
80106fad:	74 26                	je     80106fd5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106faf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106fb5:	74 58                	je     8010700f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106fb7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106fba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106fc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106fc3:	52                   	push   %edx
80106fc4:	e8 47 b3 ff ff       	call   80102310 <kfree>
      *pte = 0;
80106fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fcc:	83 c4 10             	add    $0x10,%esp
80106fcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106fd5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fdb:	39 f3                	cmp    %esi,%ebx
80106fdd:	73 25                	jae    80107004 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106fdf:	31 c9                	xor    %ecx,%ecx
80106fe1:	89 da                	mov    %ebx,%edx
80106fe3:	89 f8                	mov    %edi,%eax
80106fe5:	e8 86 fe ff ff       	call   80106e70 <walkpgdir>
    if(!pte)
80106fea:	85 c0                	test   %eax,%eax
80106fec:	75 ba                	jne    80106fa8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106fee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ff4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ffa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107000:	39 f3                	cmp    %esi,%ebx
80107002:	72 db                	jb     80106fdf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107004:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107007:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010700a:	5b                   	pop    %ebx
8010700b:	5e                   	pop    %esi
8010700c:	5f                   	pop    %edi
8010700d:	5d                   	pop    %ebp
8010700e:	c3                   	ret    
        panic("kfree");
8010700f:	83 ec 0c             	sub    $0xc,%esp
80107012:	68 06 7a 10 80       	push   $0x80107a06
80107017:	e8 74 93 ff ff       	call   80100390 <panic>
8010701c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107020 <seginit>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107026:	e8 45 ca ff ff       	call   80103a70 <cpuid>
8010702b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107031:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107036:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010703a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107041:	ff 00 00 
80107044:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010704b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010704e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107055:	ff 00 00 
80107058:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
8010705f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107062:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107069:	ff 00 00 
8010706c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107073:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107076:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010707d:	ff 00 00 
80107080:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107087:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010708a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010708f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107093:	c1 e8 10             	shr    $0x10,%eax
80107096:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010709a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010709d:	0f 01 10             	lgdtl  (%eax)
}
801070a0:	c9                   	leave  
801070a1:	c3                   	ret    
801070a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070b0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070b0:	a1 c4 e1 28 80       	mov    0x8028e1c4,%eax
{
801070b5:	55                   	push   %ebp
801070b6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070b8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070bd:	0f 22 d8             	mov    %eax,%cr3
}
801070c0:	5d                   	pop    %ebp
801070c1:	c3                   	ret    
801070c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070d0 <switchuvm>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
801070d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801070dc:	85 db                	test   %ebx,%ebx
801070de:	0f 84 cb 00 00 00    	je     801071af <switchuvm+0xdf>
  if(p->kstack == 0)
801070e4:	8b 43 08             	mov    0x8(%ebx),%eax
801070e7:	85 c0                	test   %eax,%eax
801070e9:	0f 84 da 00 00 00    	je     801071c9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801070ef:	8b 43 04             	mov    0x4(%ebx),%eax
801070f2:	85 c0                	test   %eax,%eax
801070f4:	0f 84 c2 00 00 00    	je     801071bc <switchuvm+0xec>
  pushcli();
801070fa:	e8 b1 d9 ff ff       	call   80104ab0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070ff:	e8 ec c8 ff ff       	call   801039f0 <mycpu>
80107104:	89 c6                	mov    %eax,%esi
80107106:	e8 e5 c8 ff ff       	call   801039f0 <mycpu>
8010710b:	89 c7                	mov    %eax,%edi
8010710d:	e8 de c8 ff ff       	call   801039f0 <mycpu>
80107112:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107115:	83 c7 08             	add    $0x8,%edi
80107118:	e8 d3 c8 ff ff       	call   801039f0 <mycpu>
8010711d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107120:	83 c0 08             	add    $0x8,%eax
80107123:	ba 67 00 00 00       	mov    $0x67,%edx
80107128:	c1 e8 18             	shr    $0x18,%eax
8010712b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107132:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107139:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010713f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107144:	83 c1 08             	add    $0x8,%ecx
80107147:	c1 e9 10             	shr    $0x10,%ecx
8010714a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107150:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107155:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010715c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107161:	e8 8a c8 ff ff       	call   801039f0 <mycpu>
80107166:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010716d:	e8 7e c8 ff ff       	call   801039f0 <mycpu>
80107172:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107176:	8b 73 08             	mov    0x8(%ebx),%esi
80107179:	e8 72 c8 ff ff       	call   801039f0 <mycpu>
8010717e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107184:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107187:	e8 64 c8 ff ff       	call   801039f0 <mycpu>
8010718c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107190:	b8 28 00 00 00       	mov    $0x28,%eax
80107195:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107198:	8b 43 04             	mov    0x4(%ebx),%eax
8010719b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071a0:	0f 22 d8             	mov    %eax,%cr3
}
801071a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071a6:	5b                   	pop    %ebx
801071a7:	5e                   	pop    %esi
801071a8:	5f                   	pop    %edi
801071a9:	5d                   	pop    %ebp
  popcli();
801071aa:	e9 41 d9 ff ff       	jmp    80104af0 <popcli>
    panic("switchuvm: no process");
801071af:	83 ec 0c             	sub    $0xc,%esp
801071b2:	68 f2 80 10 80       	push   $0x801080f2
801071b7:	e8 d4 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801071bc:	83 ec 0c             	sub    $0xc,%esp
801071bf:	68 1d 81 10 80       	push   $0x8010811d
801071c4:	e8 c7 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801071c9:	83 ec 0c             	sub    $0xc,%esp
801071cc:	68 08 81 10 80       	push   $0x80108108
801071d1:	e8 ba 91 ff ff       	call   80100390 <panic>
801071d6:	8d 76 00             	lea    0x0(%esi),%esi
801071d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071e0 <inituvm>:
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 1c             	sub    $0x1c,%esp
801071e9:	8b 75 10             	mov    0x10(%ebp),%esi
801071ec:	8b 45 08             	mov    0x8(%ebp),%eax
801071ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801071f2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801071f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801071fb:	77 49                	ja     80107246 <inituvm+0x66>
  mem = kalloc();
801071fd:	e8 be b2 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107202:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107205:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107207:	68 00 10 00 00       	push   $0x1000
8010720c:	6a 00                	push   $0x0
8010720e:	50                   	push   %eax
8010720f:	e8 7c da ff ff       	call   80104c90 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107214:	58                   	pop    %eax
80107215:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010721b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107220:	5a                   	pop    %edx
80107221:	6a 06                	push   $0x6
80107223:	50                   	push   %eax
80107224:	31 d2                	xor    %edx,%edx
80107226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107229:	e8 c2 fc ff ff       	call   80106ef0 <mappages>
  memmove(mem, init, sz);
8010722e:	89 75 10             	mov    %esi,0x10(%ebp)
80107231:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107234:	83 c4 10             	add    $0x10,%esp
80107237:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010723a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723d:	5b                   	pop    %ebx
8010723e:	5e                   	pop    %esi
8010723f:	5f                   	pop    %edi
80107240:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107241:	e9 fa da ff ff       	jmp    80104d40 <memmove>
    panic("inituvm: more than a page");
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	68 31 81 10 80       	push   $0x80108131
8010724e:	e8 3d 91 ff ff       	call   80100390 <panic>
80107253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107260 <loaduvm>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
80107266:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107269:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107270:	0f 85 91 00 00 00    	jne    80107307 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107276:	8b 75 18             	mov    0x18(%ebp),%esi
80107279:	31 db                	xor    %ebx,%ebx
8010727b:	85 f6                	test   %esi,%esi
8010727d:	75 1a                	jne    80107299 <loaduvm+0x39>
8010727f:	eb 6f                	jmp    801072f0 <loaduvm+0x90>
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107288:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010728e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107294:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107297:	76 57                	jbe    801072f0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107299:	8b 55 0c             	mov    0xc(%ebp),%edx
8010729c:	8b 45 08             	mov    0x8(%ebp),%eax
8010729f:	31 c9                	xor    %ecx,%ecx
801072a1:	01 da                	add    %ebx,%edx
801072a3:	e8 c8 fb ff ff       	call   80106e70 <walkpgdir>
801072a8:	85 c0                	test   %eax,%eax
801072aa:	74 4e                	je     801072fa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801072ac:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801072b1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801072b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072bb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801072c1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072c4:	01 d9                	add    %ebx,%ecx
801072c6:	05 00 00 00 80       	add    $0x80000000,%eax
801072cb:	57                   	push   %edi
801072cc:	51                   	push   %ecx
801072cd:	50                   	push   %eax
801072ce:	ff 75 10             	pushl  0x10(%ebp)
801072d1:	e8 8a a6 ff ff       	call   80101960 <readi>
801072d6:	83 c4 10             	add    $0x10,%esp
801072d9:	39 f8                	cmp    %edi,%eax
801072db:	74 ab                	je     80107288 <loaduvm+0x28>
}
801072dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072e5:	5b                   	pop    %ebx
801072e6:	5e                   	pop    %esi
801072e7:	5f                   	pop    %edi
801072e8:	5d                   	pop    %ebp
801072e9:	c3                   	ret    
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072f3:	31 c0                	xor    %eax,%eax
}
801072f5:	5b                   	pop    %ebx
801072f6:	5e                   	pop    %esi
801072f7:	5f                   	pop    %edi
801072f8:	5d                   	pop    %ebp
801072f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801072fa:	83 ec 0c             	sub    $0xc,%esp
801072fd:	68 4b 81 10 80       	push   $0x8010814b
80107302:	e8 89 90 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107307:	83 ec 0c             	sub    $0xc,%esp
8010730a:	68 ec 81 10 80       	push   $0x801081ec
8010730f:	e8 7c 90 ff ff       	call   80100390 <panic>
80107314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010731a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107320 <allocuvm>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107329:	8b 7d 10             	mov    0x10(%ebp),%edi
8010732c:	85 ff                	test   %edi,%edi
8010732e:	0f 88 8e 00 00 00    	js     801073c2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107334:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107337:	0f 82 93 00 00 00    	jb     801073d0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010733d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107340:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107346:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010734c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010734f:	0f 86 7e 00 00 00    	jbe    801073d3 <allocuvm+0xb3>
80107355:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107358:	8b 7d 08             	mov    0x8(%ebp),%edi
8010735b:	eb 42                	jmp    8010739f <allocuvm+0x7f>
8010735d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107360:	83 ec 04             	sub    $0x4,%esp
80107363:	68 00 10 00 00       	push   $0x1000
80107368:	6a 00                	push   $0x0
8010736a:	50                   	push   %eax
8010736b:	e8 20 d9 ff ff       	call   80104c90 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107370:	58                   	pop    %eax
80107371:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107377:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010737c:	5a                   	pop    %edx
8010737d:	6a 06                	push   $0x6
8010737f:	50                   	push   %eax
80107380:	89 da                	mov    %ebx,%edx
80107382:	89 f8                	mov    %edi,%eax
80107384:	e8 67 fb ff ff       	call   80106ef0 <mappages>
80107389:	83 c4 10             	add    $0x10,%esp
8010738c:	85 c0                	test   %eax,%eax
8010738e:	78 50                	js     801073e0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107390:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107396:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107399:	0f 86 81 00 00 00    	jbe    80107420 <allocuvm+0x100>
    mem = kalloc();
8010739f:	e8 1c b1 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
801073a4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801073a6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801073a8:	75 b6                	jne    80107360 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073aa:	83 ec 0c             	sub    $0xc,%esp
801073ad:	68 69 81 10 80       	push   $0x80108169
801073b2:	e8 a9 92 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801073b7:	83 c4 10             	add    $0x10,%esp
801073ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801073bd:	39 45 10             	cmp    %eax,0x10(%ebp)
801073c0:	77 6e                	ja     80107430 <allocuvm+0x110>
}
801073c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801073c5:	31 ff                	xor    %edi,%edi
}
801073c7:	89 f8                	mov    %edi,%eax
801073c9:	5b                   	pop    %ebx
801073ca:	5e                   	pop    %esi
801073cb:	5f                   	pop    %edi
801073cc:	5d                   	pop    %ebp
801073cd:	c3                   	ret    
801073ce:	66 90                	xchg   %ax,%ax
    return oldsz;
801073d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801073d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d6:	89 f8                	mov    %edi,%eax
801073d8:	5b                   	pop    %ebx
801073d9:	5e                   	pop    %esi
801073da:	5f                   	pop    %edi
801073db:	5d                   	pop    %ebp
801073dc:	c3                   	ret    
801073dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	68 81 81 10 80       	push   $0x80108181
801073e8:	e8 73 92 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801073ed:	83 c4 10             	add    $0x10,%esp
801073f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f3:	39 45 10             	cmp    %eax,0x10(%ebp)
801073f6:	76 0d                	jbe    80107405 <allocuvm+0xe5>
801073f8:	89 c1                	mov    %eax,%ecx
801073fa:	8b 55 10             	mov    0x10(%ebp),%edx
801073fd:	8b 45 08             	mov    0x8(%ebp),%eax
80107400:	e8 7b fb ff ff       	call   80106f80 <deallocuvm.part.0>
      kfree(mem);
80107405:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107408:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010740a:	56                   	push   %esi
8010740b:	e8 00 af ff ff       	call   80102310 <kfree>
      return 0;
80107410:	83 c4 10             	add    $0x10,%esp
}
80107413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107416:	89 f8                	mov    %edi,%eax
80107418:	5b                   	pop    %ebx
80107419:	5e                   	pop    %esi
8010741a:	5f                   	pop    %edi
8010741b:	5d                   	pop    %ebp
8010741c:	c3                   	ret    
8010741d:	8d 76 00             	lea    0x0(%esi),%esi
80107420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107423:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107426:	5b                   	pop    %ebx
80107427:	89 f8                	mov    %edi,%eax
80107429:	5e                   	pop    %esi
8010742a:	5f                   	pop    %edi
8010742b:	5d                   	pop    %ebp
8010742c:	c3                   	ret    
8010742d:	8d 76 00             	lea    0x0(%esi),%esi
80107430:	89 c1                	mov    %eax,%ecx
80107432:	8b 55 10             	mov    0x10(%ebp),%edx
80107435:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107438:	31 ff                	xor    %edi,%edi
8010743a:	e8 41 fb ff ff       	call   80106f80 <deallocuvm.part.0>
8010743f:	eb 92                	jmp    801073d3 <allocuvm+0xb3>
80107441:	eb 0d                	jmp    80107450 <deallocuvm>
80107443:	90                   	nop
80107444:	90                   	nop
80107445:	90                   	nop
80107446:	90                   	nop
80107447:	90                   	nop
80107448:	90                   	nop
80107449:	90                   	nop
8010744a:	90                   	nop
8010744b:	90                   	nop
8010744c:	90                   	nop
8010744d:	90                   	nop
8010744e:	90                   	nop
8010744f:	90                   	nop

80107450 <deallocuvm>:
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	8b 55 0c             	mov    0xc(%ebp),%edx
80107456:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107459:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010745c:	39 d1                	cmp    %edx,%ecx
8010745e:	73 10                	jae    80107470 <deallocuvm+0x20>
}
80107460:	5d                   	pop    %ebp
80107461:	e9 1a fb ff ff       	jmp    80106f80 <deallocuvm.part.0>
80107466:	8d 76 00             	lea    0x0(%esi),%esi
80107469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107470:	89 d0                	mov    %edx,%eax
80107472:	5d                   	pop    %ebp
80107473:	c3                   	ret    
80107474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010747a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107480 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 0c             	sub    $0xc,%esp
80107489:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010748c:	85 f6                	test   %esi,%esi
8010748e:	74 59                	je     801074e9 <freevm+0x69>
80107490:	31 c9                	xor    %ecx,%ecx
80107492:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107497:	89 f0                	mov    %esi,%eax
80107499:	e8 e2 fa ff ff       	call   80106f80 <deallocuvm.part.0>
8010749e:	89 f3                	mov    %esi,%ebx
801074a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074a6:	eb 0f                	jmp    801074b7 <freevm+0x37>
801074a8:	90                   	nop
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074b0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074b3:	39 fb                	cmp    %edi,%ebx
801074b5:	74 23                	je     801074da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074b7:	8b 03                	mov    (%ebx),%eax
801074b9:	a8 01                	test   $0x1,%al
801074bb:	74 f3                	je     801074b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801074c2:	83 ec 0c             	sub    $0xc,%esp
801074c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801074cd:	50                   	push   %eax
801074ce:	e8 3d ae ff ff       	call   80102310 <kfree>
801074d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074d6:	39 fb                	cmp    %edi,%ebx
801074d8:	75 dd                	jne    801074b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801074da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074e0:	5b                   	pop    %ebx
801074e1:	5e                   	pop    %esi
801074e2:	5f                   	pop    %edi
801074e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801074e4:	e9 27 ae ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
801074e9:	83 ec 0c             	sub    $0xc,%esp
801074ec:	68 9d 81 10 80       	push   $0x8010819d
801074f1:	e8 9a 8e ff ff       	call   80100390 <panic>
801074f6:	8d 76 00             	lea    0x0(%esi),%esi
801074f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107500 <setupkvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	56                   	push   %esi
80107504:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107505:	e8 b6 af ff ff       	call   801024c0 <kalloc>
8010750a:	85 c0                	test   %eax,%eax
8010750c:	89 c6                	mov    %eax,%esi
8010750e:	74 42                	je     80107552 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107510:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107513:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107518:	68 00 10 00 00       	push   $0x1000
8010751d:	6a 00                	push   $0x0
8010751f:	50                   	push   %eax
80107520:	e8 6b d7 ff ff       	call   80104c90 <memset>
80107525:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107528:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010752b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010752e:	83 ec 08             	sub    $0x8,%esp
80107531:	8b 13                	mov    (%ebx),%edx
80107533:	ff 73 0c             	pushl  0xc(%ebx)
80107536:	50                   	push   %eax
80107537:	29 c1                	sub    %eax,%ecx
80107539:	89 f0                	mov    %esi,%eax
8010753b:	e8 b0 f9 ff ff       	call   80106ef0 <mappages>
80107540:	83 c4 10             	add    $0x10,%esp
80107543:	85 c0                	test   %eax,%eax
80107545:	78 19                	js     80107560 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107547:	83 c3 10             	add    $0x10,%ebx
8010754a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107550:	75 d6                	jne    80107528 <setupkvm+0x28>
}
80107552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107555:	89 f0                	mov    %esi,%eax
80107557:	5b                   	pop    %ebx
80107558:	5e                   	pop    %esi
80107559:	5d                   	pop    %ebp
8010755a:	c3                   	ret    
8010755b:	90                   	nop
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107560:	83 ec 0c             	sub    $0xc,%esp
80107563:	56                   	push   %esi
      return 0;
80107564:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107566:	e8 15 ff ff ff       	call   80107480 <freevm>
      return 0;
8010756b:	83 c4 10             	add    $0x10,%esp
}
8010756e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107571:	89 f0                	mov    %esi,%eax
80107573:	5b                   	pop    %ebx
80107574:	5e                   	pop    %esi
80107575:	5d                   	pop    %ebp
80107576:	c3                   	ret    
80107577:	89 f6                	mov    %esi,%esi
80107579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107580 <kvmalloc>:
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107586:	e8 75 ff ff ff       	call   80107500 <setupkvm>
8010758b:	a3 c4 e1 28 80       	mov    %eax,0x8028e1c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107590:	05 00 00 00 80       	add    $0x80000000,%eax
80107595:	0f 22 d8             	mov    %eax,%cr3
}
80107598:	c9                   	leave  
80107599:	c3                   	ret    
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075a1:	31 c9                	xor    %ecx,%ecx
{
801075a3:	89 e5                	mov    %esp,%ebp
801075a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075ab:	8b 45 08             	mov    0x8(%ebp),%eax
801075ae:	e8 bd f8 ff ff       	call   80106e70 <walkpgdir>
  if(pte == 0)
801075b3:	85 c0                	test   %eax,%eax
801075b5:	74 05                	je     801075bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801075b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075ba:	c9                   	leave  
801075bb:	c3                   	ret    
    panic("clearpteu");
801075bc:	83 ec 0c             	sub    $0xc,%esp
801075bf:	68 ae 81 10 80       	push   $0x801081ae
801075c4:	e8 c7 8d ff ff       	call   80100390 <panic>
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	57                   	push   %edi
801075d4:	56                   	push   %esi
801075d5:	53                   	push   %ebx
801075d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801075d9:	e8 22 ff ff ff       	call   80107500 <setupkvm>
801075de:	85 c0                	test   %eax,%eax
801075e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075e3:	0f 84 9f 00 00 00    	je     80107688 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801075e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075ec:	85 c9                	test   %ecx,%ecx
801075ee:	0f 84 94 00 00 00    	je     80107688 <copyuvm+0xb8>
801075f4:	31 ff                	xor    %edi,%edi
801075f6:	eb 4a                	jmp    80107642 <copyuvm+0x72>
801075f8:	90                   	nop
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107600:	83 ec 04             	sub    $0x4,%esp
80107603:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107609:	68 00 10 00 00       	push   $0x1000
8010760e:	53                   	push   %ebx
8010760f:	50                   	push   %eax
80107610:	e8 2b d7 ff ff       	call   80104d40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107615:	58                   	pop    %eax
80107616:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010761c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107621:	5a                   	pop    %edx
80107622:	ff 75 e4             	pushl  -0x1c(%ebp)
80107625:	50                   	push   %eax
80107626:	89 fa                	mov    %edi,%edx
80107628:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010762b:	e8 c0 f8 ff ff       	call   80106ef0 <mappages>
80107630:	83 c4 10             	add    $0x10,%esp
80107633:	85 c0                	test   %eax,%eax
80107635:	78 61                	js     80107698 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107637:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010763d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107640:	76 46                	jbe    80107688 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107642:	8b 45 08             	mov    0x8(%ebp),%eax
80107645:	31 c9                	xor    %ecx,%ecx
80107647:	89 fa                	mov    %edi,%edx
80107649:	e8 22 f8 ff ff       	call   80106e70 <walkpgdir>
8010764e:	85 c0                	test   %eax,%eax
80107650:	74 61                	je     801076b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107652:	8b 00                	mov    (%eax),%eax
80107654:	a8 01                	test   $0x1,%al
80107656:	74 4e                	je     801076a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107658:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010765a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010765f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107665:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107668:	e8 53 ae ff ff       	call   801024c0 <kalloc>
8010766d:	85 c0                	test   %eax,%eax
8010766f:	89 c6                	mov    %eax,%esi
80107671:	75 8d                	jne    80107600 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107673:	83 ec 0c             	sub    $0xc,%esp
80107676:	ff 75 e0             	pushl  -0x20(%ebp)
80107679:	e8 02 fe ff ff       	call   80107480 <freevm>
  return 0;
8010767e:	83 c4 10             	add    $0x10,%esp
80107681:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107688:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010768b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010768e:	5b                   	pop    %ebx
8010768f:	5e                   	pop    %esi
80107690:	5f                   	pop    %edi
80107691:	5d                   	pop    %ebp
80107692:	c3                   	ret    
80107693:	90                   	nop
80107694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107698:	83 ec 0c             	sub    $0xc,%esp
8010769b:	56                   	push   %esi
8010769c:	e8 6f ac ff ff       	call   80102310 <kfree>
      goto bad;
801076a1:	83 c4 10             	add    $0x10,%esp
801076a4:	eb cd                	jmp    80107673 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801076a6:	83 ec 0c             	sub    $0xc,%esp
801076a9:	68 d2 81 10 80       	push   $0x801081d2
801076ae:	e8 dd 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801076b3:	83 ec 0c             	sub    $0xc,%esp
801076b6:	68 b8 81 10 80       	push   $0x801081b8
801076bb:	e8 d0 8c ff ff       	call   80100390 <panic>

801076c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076c1:	31 c9                	xor    %ecx,%ecx
{
801076c3:	89 e5                	mov    %esp,%ebp
801076c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801076c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801076cb:	8b 45 08             	mov    0x8(%ebp),%eax
801076ce:	e8 9d f7 ff ff       	call   80106e70 <walkpgdir>
  if((*pte & PTE_P) == 0)
801076d3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801076d5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801076d6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801076dd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076e0:	05 00 00 00 80       	add    $0x80000000,%eax
801076e5:	83 fa 05             	cmp    $0x5,%edx
801076e8:	ba 00 00 00 00       	mov    $0x0,%edx
801076ed:	0f 45 c2             	cmovne %edx,%eax
}
801076f0:	c3                   	ret    
801076f1:	eb 0d                	jmp    80107700 <copyout>
801076f3:	90                   	nop
801076f4:	90                   	nop
801076f5:	90                   	nop
801076f6:	90                   	nop
801076f7:	90                   	nop
801076f8:	90                   	nop
801076f9:	90                   	nop
801076fa:	90                   	nop
801076fb:	90                   	nop
801076fc:	90                   	nop
801076fd:	90                   	nop
801076fe:	90                   	nop
801076ff:	90                   	nop

80107700 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	57                   	push   %edi
80107704:	56                   	push   %esi
80107705:	53                   	push   %ebx
80107706:	83 ec 1c             	sub    $0x1c,%esp
80107709:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010770c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010770f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107712:	85 db                	test   %ebx,%ebx
80107714:	75 40                	jne    80107756 <copyout+0x56>
80107716:	eb 70                	jmp    80107788 <copyout+0x88>
80107718:	90                   	nop
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107723:	89 f1                	mov    %esi,%ecx
80107725:	29 d1                	sub    %edx,%ecx
80107727:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010772d:	39 d9                	cmp    %ebx,%ecx
8010772f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107732:	29 f2                	sub    %esi,%edx
80107734:	83 ec 04             	sub    $0x4,%esp
80107737:	01 d0                	add    %edx,%eax
80107739:	51                   	push   %ecx
8010773a:	57                   	push   %edi
8010773b:	50                   	push   %eax
8010773c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010773f:	e8 fc d5 ff ff       	call   80104d40 <memmove>
    len -= n;
    buf += n;
80107744:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107747:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010774a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107750:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107752:	29 cb                	sub    %ecx,%ebx
80107754:	74 32                	je     80107788 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107756:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107758:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010775b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010775e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107764:	56                   	push   %esi
80107765:	ff 75 08             	pushl  0x8(%ebp)
80107768:	e8 53 ff ff ff       	call   801076c0 <uva2ka>
    if(pa0 == 0)
8010776d:	83 c4 10             	add    $0x10,%esp
80107770:	85 c0                	test   %eax,%eax
80107772:	75 ac                	jne    80107720 <copyout+0x20>
  }
  return 0;
}
80107774:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010777c:	5b                   	pop    %ebx
8010777d:	5e                   	pop    %esi
8010777e:	5f                   	pop    %edi
8010777f:	5d                   	pop    %ebp
80107780:	c3                   	ret    
80107781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107788:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010778b:	31 c0                	xor    %eax,%eax
}
8010778d:	5b                   	pop    %ebx
8010778e:	5e                   	pop    %esi
8010778f:	5f                   	pop    %edi
80107790:	5d                   	pop    %ebp
80107791:	c3                   	ret    
