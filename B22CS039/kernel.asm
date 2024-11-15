
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 31 10 80       	mov    $0x80103180,%eax
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
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 72 10 80       	push   $0x801072c0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 a5 44 00 00       	call   80104500 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 72 10 80       	push   $0x801072c7
80100097:	50                   	push   %eax
80100098:	e8 33 43 00 00       	call   801043d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 07 46 00 00       	call   801046f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
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
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 29 45 00 00       	call   80104690 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 42 00 00       	call   80104410 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 21 00 00       	call   801022f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ce 72 10 80       	push   $0x801072ce
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 42 00 00       	call   801044b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 17 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 72 10 80       	push   $0x801072df
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 42 00 00       	call   801044b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 42 00 00       	call   80104470 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 d0 44 00 00       	call   801046f0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 22 44 00 00       	jmp    80104690 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 e6 72 10 80       	push   $0x801072e6
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 07 16 00 00       	call   801018a0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 4b 44 00 00       	call   801046f0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 9e 3e 00 00       	call   80104170 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 37 00 00       	call   80103ab0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 95 43 00 00       	call   80104690 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 bc 14 00 00       	call   801017c0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 3f 43 00 00       	call   80104690 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 66 14 00 00       	call   801017c0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 82 26 00 00       	call   80102a20 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 72 10 80       	push   $0x801072ed
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 9a 77 10 80 	movl   $0x8010779a,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 41 00 00       	call   80104520 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 73 10 80       	push   $0x80107301
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 dc 59 00 00       	call   80105e00 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 11 59 00 00       	call   80105e00 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 05 59 00 00       	call   80105e00 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 f9 58 00 00       	call   80105e00 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 1a 43 00 00       	call   80104880 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 75 42 00 00       	call   801047f0 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 05 73 10 80       	push   $0x80107305
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 dc 12 00 00       	call   801018a0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 20 41 00 00       	call   801046f0 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 87 40 00 00       	call   80104690 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 ae 11 00 00       	call   801017c0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 ec 77 10 80 	movzbl -0x7fef8814(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ef 10 80       	push   $0x8010ef20
801007d8:	e8 13 3f 00 00       	call   801046f0 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ef 10 80       	push   $0x8010ef20
801007fb:	e8 90 3e 00 00       	call   80104690 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 18 73 10 80       	mov    $0x80107318,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010084e:	66 90                	xchg   %ax,%ax
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100857:	90                   	nop
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 1f 73 10 80       	push   $0x8010731f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010089d:	8d 76 00             	lea    0x0(%esi),%esi

801008a0 <consputc>:
{
801008a0:	55                   	push   %ebp
  if(panicked){
801008a1:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
{
801008a7:	89 e5                	mov    %esp,%ebp
801008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(panicked){
801008ac:	85 d2                	test   %edx,%edx
801008ae:	74 08                	je     801008b8 <consputc+0x18>
801008b0:	fa                   	cli
    for(;;)
801008b1:	eb fe                	jmp    801008b1 <consputc+0x11>
801008b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008b7:	90                   	nop
}
801008b8:	5d                   	pop    %ebp
801008b9:	e9 42 fb ff ff       	jmp    80100400 <consputc.part.0>
801008be:	66 90                	xchg   %ax,%ax

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
  int c, doprocdump = 0;
801008c4:	31 ff                	xor    %edi,%edi
{
801008c6:	56                   	push   %esi
801008c7:	53                   	push   %ebx
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ce:	68 20 ef 10 80       	push   $0x8010ef20
801008d3:	e8 18 3e 00 00       	call   801046f0 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	ff d6                	call   *%esi
801008dd:	89 c3                	mov    %eax,%ebx
801008df:	85 c0                	test   %eax,%eax
801008e1:	78 22                	js     80100905 <consoleintr+0x45>
    switch(c){
801008e3:	83 fb 15             	cmp    $0x15,%ebx
801008e6:	74 47                	je     8010092f <consoleintr+0x6f>
801008e8:	7f 76                	jg     80100960 <consoleintr+0xa0>
801008ea:	83 fb 08             	cmp    $0x8,%ebx
801008ed:	74 76                	je     80100965 <consoleintr+0xa5>
801008ef:	83 fb 10             	cmp    $0x10,%ebx
801008f2:	0f 85 f8 00 00 00    	jne    801009f0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008f8:	ff d6                	call   *%esi
    switch(c){
801008fa:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008ff:	89 c3                	mov    %eax,%ebx
80100901:	85 c0                	test   %eax,%eax
80100903:	79 de                	jns    801008e3 <consoleintr+0x23>
  release(&cons.lock);
80100905:	83 ec 0c             	sub    $0xc,%esp
80100908:	68 20 ef 10 80       	push   $0x8010ef20
8010090d:	e8 7e 3d 00 00       	call   80104690 <release>
  if(doprocdump) {
80100912:	83 c4 10             	add    $0x10,%esp
80100915:	85 ff                	test   %edi,%edi
80100917:	0f 85 4b 01 00 00    	jne    80100a68 <consoleintr+0x1a8>
}
8010091d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100920:	5b                   	pop    %ebx
80100921:	5e                   	pop    %esi
80100922:	5f                   	pop    %edi
80100923:	5d                   	pop    %ebp
80100924:	c3                   	ret
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 d1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010092f:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100934:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010093a:	74 9f                	je     801008db <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010093c:	83 e8 01             	sub    $0x1,%eax
8010093f:	89 c2                	mov    %eax,%edx
80100941:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100944:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010094b:	74 8e                	je     801008db <consoleintr+0x1b>
  if(panicked){
8010094d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100953:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100958:	85 d2                	test   %edx,%edx
8010095a:	74 c9                	je     80100925 <consoleintr+0x65>
8010095c:	fa                   	cli
    for(;;)
8010095d:	eb fe                	jmp    8010095d <consoleintr+0x9d>
8010095f:	90                   	nop
    switch(c){
80100960:	83 fb 7f             	cmp    $0x7f,%ebx
80100963:	75 2b                	jne    80100990 <consoleintr+0xd0>
      if(input.e != input.w){
80100965:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010096a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100970:	0f 84 65 ff ff ff    	je     801008db <consoleintr+0x1b>
        input.e--;
80100976:	83 e8 01             	sub    $0x1,%eax
80100979:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010097e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100983:	85 c0                	test   %eax,%eax
80100985:	0f 84 ce 00 00 00    	je     80100a59 <consoleintr+0x199>
8010098b:	fa                   	cli
    for(;;)
8010098c:	eb fe                	jmp    8010098c <consoleintr+0xcc>
8010098e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100990:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100995:	89 c2                	mov    %eax,%edx
80100997:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
8010099d:	83 fa 7f             	cmp    $0x7f,%edx
801009a0:	0f 87 35 ff ff ff    	ja     801008db <consoleintr+0x1b>
  if(panicked){
801009a6:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009ac:	8d 50 01             	lea    0x1(%eax),%edx
801009af:	83 e0 7f             	and    $0x7f,%eax
801009b2:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
801009b8:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
801009be:	85 c9                	test   %ecx,%ecx
801009c0:	0f 85 ae 00 00 00    	jne    80100a74 <consoleintr+0x1b4>
801009c6:	89 d8                	mov    %ebx,%eax
801009c8:	e8 33 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009cd:	83 fb 0a             	cmp    $0xa,%ebx
801009d0:	74 68                	je     80100a3a <consoleintr+0x17a>
801009d2:	83 fb 04             	cmp    $0x4,%ebx
801009d5:	74 63                	je     80100a3a <consoleintr+0x17a>
801009d7:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009dc:	83 e8 80             	sub    $0xffffff80,%eax
801009df:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009e5:	0f 85 f0 fe ff ff    	jne    801008db <consoleintr+0x1b>
801009eb:	eb 52                	jmp    80100a3f <consoleintr+0x17f>
801009ed:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009f0:	85 db                	test   %ebx,%ebx
801009f2:	0f 84 e3 fe ff ff    	je     801008db <consoleintr+0x1b>
801009f8:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009fd:	89 c2                	mov    %eax,%edx
801009ff:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a05:	83 fa 7f             	cmp    $0x7f,%edx
80100a08:	0f 87 cd fe ff ff    	ja     801008db <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a0e:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a11:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a17:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a1a:	83 fb 0d             	cmp    $0xd,%ebx
80100a1d:	75 93                	jne    801009b2 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a1f:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a25:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a2c:	85 c9                	test   %ecx,%ecx
80100a2e:	75 44                	jne    80100a74 <consoleintr+0x1b4>
80100a30:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a35:	e8 c6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a3a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a3f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a42:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a47:	68 00 ef 10 80       	push   $0x8010ef00
80100a4c:	e8 df 37 00 00       	call   80104230 <wakeup>
80100a51:	83 c4 10             	add    $0x10,%esp
80100a54:	e9 82 fe ff ff       	jmp    801008db <consoleintr+0x1b>
80100a59:	b8 00 01 00 00       	mov    $0x100,%eax
80100a5e:	e8 9d f9 ff ff       	call   80100400 <consputc.part.0>
80100a63:	e9 73 fe ff ff       	jmp    801008db <consoleintr+0x1b>
}
80100a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a6b:	5b                   	pop    %ebx
80100a6c:	5e                   	pop    %esi
80100a6d:	5f                   	pop    %edi
80100a6e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a6f:	e9 9c 38 00 00       	jmp    80104310 <procdump>
80100a74:	fa                   	cli
    for(;;)
80100a75:	eb fe                	jmp    80100a75 <consoleintr+0x1b5>
80100a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a7e:	66 90                	xchg   %ax,%ax

80100a80 <consoleinit>:

void
consoleinit(void)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a86:	68 28 73 10 80       	push   $0x80107328
80100a8b:	68 20 ef 10 80       	push   $0x8010ef20
80100a90:	e8 6b 3a 00 00       	call   80104500 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a95:	58                   	pop    %eax
80100a96:	5a                   	pop    %edx
80100a97:	6a 00                	push   $0x0
80100a99:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a9b:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100aa2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100aa5:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100aac:	02 10 80 
  cons.locking = 1;
80100aaf:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100ab6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100ab9:	e8 c2 19 00 00       	call   80102480 <ioapicenable>
}
80100abe:	83 c4 10             	add    $0x10,%esp
80100ac1:	c9                   	leave
80100ac2:	c3                   	ret
80100ac3:	66 90                	xchg   %ax,%ax
80100ac5:	66 90                	xchg   %ax,%ax
80100ac7:	66 90                	xchg   %ax,%ax
80100ac9:	66 90                	xchg   %ax,%ax
80100acb:	66 90                	xchg   %ax,%ax
80100acd:	66 90                	xchg   %ax,%ax
80100acf:	90                   	nop

80100ad0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	57                   	push   %edi
80100ad4:	56                   	push   %esi
80100ad5:	53                   	push   %ebx
80100ad6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100adc:	e8 cf 2f 00 00       	call   80103ab0 <myproc>
80100ae1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ae7:	e8 a4 23 00 00       	call   80102e90 <begin_op>

  if((ip = namei(path)) == 0){
80100aec:	83 ec 0c             	sub    $0xc,%esp
80100aef:	ff 75 08             	push   0x8(%ebp)
80100af2:	e8 a9 15 00 00       	call   801020a0 <namei>
80100af7:	83 c4 10             	add    $0x10,%esp
80100afa:	85 c0                	test   %eax,%eax
80100afc:	0f 84 30 03 00 00    	je     80100e32 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b02:	83 ec 0c             	sub    $0xc,%esp
80100b05:	89 c7                	mov    %eax,%edi
80100b07:	50                   	push   %eax
80100b08:	e8 b3 0c 00 00       	call   801017c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b0d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b13:	6a 34                	push   $0x34
80100b15:	6a 00                	push   $0x0
80100b17:	50                   	push   %eax
80100b18:	57                   	push   %edi
80100b19:	e8 b2 0f 00 00       	call   80101ad0 <readi>
80100b1e:	83 c4 20             	add    $0x20,%esp
80100b21:	83 f8 34             	cmp    $0x34,%eax
80100b24:	0f 85 01 01 00 00    	jne    80100c2b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b2a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b31:	45 4c 46 
80100b34:	0f 85 f1 00 00 00    	jne    80100c2b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b3a:	e8 31 64 00 00       	call   80106f70 <setupkvm>
80100b3f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b45:	85 c0                	test   %eax,%eax
80100b47:	0f 84 de 00 00 00    	je     80100c2b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b54:	00 
80100b55:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b5b:	0f 84 a1 02 00 00    	je     80100e02 <exec+0x332>
  sz = 0;
80100b61:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b68:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b6b:	31 db                	xor    %ebx,%ebx
80100b6d:	e9 8c 00 00 00       	jmp    80100bfe <exec+0x12e>
80100b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b78:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b7f:	75 6c                	jne    80100bed <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b81:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b87:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b8d:	0f 82 87 00 00 00    	jb     80100c1a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b93:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b99:	72 7f                	jb     80100c1a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b9b:	83 ec 04             	sub    $0x4,%esp
80100b9e:	50                   	push   %eax
80100b9f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100ba5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bab:	e8 f0 61 00 00       	call   80106da0 <allocuvm>
80100bb0:	83 c4 10             	add    $0x10,%esp
80100bb3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb9:	85 c0                	test   %eax,%eax
80100bbb:	74 5d                	je     80100c1a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bbd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bc3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc8:	75 50                	jne    80100c1a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bca:	83 ec 0c             	sub    $0xc,%esp
80100bcd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bd3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd9:	57                   	push   %edi
80100bda:	50                   	push   %eax
80100bdb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100be1:	e8 ea 60 00 00       	call   80106cd0 <loaduvm>
80100be6:	83 c4 20             	add    $0x20,%esp
80100be9:	85 c0                	test   %eax,%eax
80100beb:	78 2d                	js     80100c1a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bed:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bf4:	83 c3 01             	add    $0x1,%ebx
80100bf7:	83 c6 20             	add    $0x20,%esi
80100bfa:	39 d8                	cmp    %ebx,%eax
80100bfc:	7e 52                	jle    80100c50 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bfe:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c04:	6a 20                	push   $0x20
80100c06:	56                   	push   %esi
80100c07:	50                   	push   %eax
80100c08:	57                   	push   %edi
80100c09:	e8 c2 0e 00 00       	call   80101ad0 <readi>
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	83 f8 20             	cmp    $0x20,%eax
80100c14:	0f 84 5e ff ff ff    	je     80100b78 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c1a:	83 ec 0c             	sub    $0xc,%esp
80100c1d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c23:	e8 c8 62 00 00       	call   80106ef0 <freevm>
  if(ip){
80100c28:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c2b:	83 ec 0c             	sub    $0xc,%esp
80100c2e:	57                   	push   %edi
80100c2f:	e8 1c 0e 00 00       	call   80101a50 <iunlockput>
    end_op();
80100c34:	e8 c7 22 00 00       	call   80102f00 <end_op>
80100c39:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c44:	5b                   	pop    %ebx
80100c45:	5e                   	pop    %esi
80100c46:	5f                   	pop    %edi
80100c47:	5d                   	pop    %ebp
80100c48:	c3                   	ret
80100c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c50:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c56:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c5c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c62:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c68:	83 ec 0c             	sub    $0xc,%esp
80100c6b:	57                   	push   %edi
80100c6c:	e8 df 0d 00 00       	call   80101a50 <iunlockput>
  end_op();
80100c71:	e8 8a 22 00 00       	call   80102f00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c76:	83 c4 0c             	add    $0xc,%esp
80100c79:	53                   	push   %ebx
80100c7a:	56                   	push   %esi
80100c7b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c81:	56                   	push   %esi
80100c82:	e8 19 61 00 00       	call   80106da0 <allocuvm>
80100c87:	83 c4 10             	add    $0x10,%esp
80100c8a:	89 c7                	mov    %eax,%edi
80100c8c:	85 c0                	test   %eax,%eax
80100c8e:	0f 84 86 00 00 00    	je     80100d1a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c94:	83 ec 08             	sub    $0x8,%esp
80100c97:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c9d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c9f:	50                   	push   %eax
80100ca0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100ca1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca3:	e8 68 63 00 00       	call   80107010 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cab:	83 c4 10             	add    $0x10,%esp
80100cae:	8b 10                	mov    (%eax),%edx
80100cb0:	85 d2                	test   %edx,%edx
80100cb2:	0f 84 56 01 00 00    	je     80100e0e <exec+0x33e>
80100cb8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cbe:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cc1:	eb 23                	jmp    80100ce6 <exec+0x216>
80100cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cc7:	90                   	nop
80100cc8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100ccb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cd2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cd8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cdb:	85 d2                	test   %edx,%edx
80100cdd:	74 51                	je     80100d30 <exec+0x260>
    if(argc >= MAXARG)
80100cdf:	83 f8 20             	cmp    $0x20,%eax
80100ce2:	74 36                	je     80100d1a <exec+0x24a>
80100ce4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce6:	83 ec 0c             	sub    $0xc,%esp
80100ce9:	52                   	push   %edx
80100cea:	e8 f1 3c 00 00       	call   801049e0 <strlen>
80100cef:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cf1:	58                   	pop    %eax
80100cf2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf5:	83 eb 01             	sub    $0x1,%ebx
80100cf8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cfb:	e8 e0 3c 00 00       	call   801049e0 <strlen>
80100d00:	83 c0 01             	add    $0x1,%eax
80100d03:	50                   	push   %eax
80100d04:	ff 34 b7             	push   (%edi,%esi,4)
80100d07:	53                   	push   %ebx
80100d08:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d0e:	e8 cd 64 00 00       	call   801071e0 <copyout>
80100d13:	83 c4 20             	add    $0x20,%esp
80100d16:	85 c0                	test   %eax,%eax
80100d18:	79 ae                	jns    80100cc8 <exec+0x1f8>
    freevm(pgdir);
80100d1a:	83 ec 0c             	sub    $0xc,%esp
80100d1d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d23:	e8 c8 61 00 00       	call   80106ef0 <freevm>
80100d28:	83 c4 10             	add    $0x10,%esp
80100d2b:	e9 0c ff ff ff       	jmp    80100c3c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d30:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d37:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d3d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d43:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d46:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d49:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d50:	00 00 00 00 
  ustack[1] = argc;
80100d54:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d5a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d61:	ff ff ff 
  ustack[1] = argc;
80100d64:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d6a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d6c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d6e:	29 d0                	sub    %edx,%eax
80100d70:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d76:	56                   	push   %esi
80100d77:	51                   	push   %ecx
80100d78:	53                   	push   %ebx
80100d79:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d7f:	e8 5c 64 00 00       	call   801071e0 <copyout>
80100d84:	83 c4 10             	add    $0x10,%esp
80100d87:	85 c0                	test   %eax,%eax
80100d89:	78 8f                	js     80100d1a <exec+0x24a>
  for(last=s=path; *s; s++)
80100d8b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d8e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d91:	0f b6 00             	movzbl (%eax),%eax
80100d94:	84 c0                	test   %al,%al
80100d96:	74 17                	je     80100daf <exec+0x2df>
80100d98:	89 d1                	mov    %edx,%ecx
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100da0:	83 c1 01             	add    $0x1,%ecx
80100da3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100da5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100da8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dab:	84 c0                	test   %al,%al
80100dad:	75 f1                	jne    80100da0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100daf:	83 ec 04             	sub    $0x4,%esp
80100db2:	6a 10                	push   $0x10
80100db4:	52                   	push   %edx
80100db5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dbb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dbe:	50                   	push   %eax
80100dbf:	e8 dc 3b 00 00       	call   801049a0 <safestrcpy>
  curproc->pgdir = pgdir;
80100dc4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dca:	89 f0                	mov    %esi,%eax
80100dcc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100dcf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100dd1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dd4:	89 c1                	mov    %eax,%ecx
80100dd6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ddc:	8b 40 18             	mov    0x18(%eax),%eax
80100ddf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100de2:	8b 41 18             	mov    0x18(%ecx),%eax
80100de5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100de8:	89 0c 24             	mov    %ecx,(%esp)
80100deb:	e8 50 5d 00 00       	call   80106b40 <switchuvm>
  freevm(oldpgdir);
80100df0:	89 34 24             	mov    %esi,(%esp)
80100df3:	e8 f8 60 00 00       	call   80106ef0 <freevm>
  return 0;
80100df8:	83 c4 10             	add    $0x10,%esp
80100dfb:	31 c0                	xor    %eax,%eax
80100dfd:	e9 3f fe ff ff       	jmp    80100c41 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e02:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e07:	31 f6                	xor    %esi,%esi
80100e09:	e9 5a fe ff ff       	jmp    80100c68 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e0e:	be 10 00 00 00       	mov    $0x10,%esi
80100e13:	ba 04 00 00 00       	mov    $0x4,%edx
80100e18:	b8 03 00 00 00       	mov    $0x3,%eax
80100e1d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e24:	00 00 00 
80100e27:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e2d:	e9 17 ff ff ff       	jmp    80100d49 <exec+0x279>
    end_op();
80100e32:	e8 c9 20 00 00       	call   80102f00 <end_op>
    cprintf("exec: fail\n");
80100e37:	83 ec 0c             	sub    $0xc,%esp
80100e3a:	68 30 73 10 80       	push   $0x80107330
80100e3f:	e8 6c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e44:	83 c4 10             	add    $0x10,%esp
80100e47:	e9 f0 fd ff ff       	jmp    80100c3c <exec+0x16c>
80100e4c:	66 90                	xchg   %ax,%ax
80100e4e:	66 90                	xchg   %ax,%ax

80100e50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e56:	68 3c 73 10 80       	push   $0x8010733c
80100e5b:	68 60 ef 10 80       	push   $0x8010ef60
80100e60:	e8 9b 36 00 00       	call   80104500 <initlock>
}
80100e65:	83 c4 10             	add    $0x10,%esp
80100e68:	c9                   	leave
80100e69:	c3                   	ret
80100e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e74:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e7c:	68 60 ef 10 80       	push   $0x8010ef60
80100e81:	e8 6a 38 00 00       	call   801046f0 <acquire>
80100e86:	83 c4 10             	add    $0x10,%esp
80100e89:	eb 10                	jmp    80100e9b <filealloc+0x2b>
80100e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e8f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e90:	83 c3 18             	add    $0x18,%ebx
80100e93:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e99:	74 25                	je     80100ec0 <filealloc+0x50>
    if(f->ref == 0){
80100e9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	75 ee                	jne    80100e90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ea2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ea5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100eac:	68 60 ef 10 80       	push   $0x8010ef60
80100eb1:	e8 da 37 00 00       	call   80104690 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100eb6:	89 d8                	mov    %ebx,%eax
      return f;
80100eb8:	83 c4 10             	add    $0x10,%esp
}
80100ebb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ebe:	c9                   	leave
80100ebf:	c3                   	ret
  release(&ftable.lock);
80100ec0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ec3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ec5:	68 60 ef 10 80       	push   $0x8010ef60
80100eca:	e8 c1 37 00 00       	call   80104690 <release>
}
80100ecf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ed1:	83 c4 10             	add    $0x10,%esp
}
80100ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed7:	c9                   	leave
80100ed8:	c3                   	ret
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 10             	sub    $0x10,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eea:	68 60 ef 10 80       	push   $0x8010ef60
80100eef:	e8 fc 37 00 00       	call   801046f0 <acquire>
  if(f->ref < 1)
80100ef4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ef7:	83 c4 10             	add    $0x10,%esp
80100efa:	85 c0                	test   %eax,%eax
80100efc:	7e 1a                	jle    80100f18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100efe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f01:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f07:	68 60 ef 10 80       	push   $0x8010ef60
80100f0c:	e8 7f 37 00 00       	call   80104690 <release>
  return f;
}
80100f11:	89 d8                	mov    %ebx,%eax
80100f13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f16:	c9                   	leave
80100f17:	c3                   	ret
    panic("filedup");
80100f18:	83 ec 0c             	sub    $0xc,%esp
80100f1b:	68 43 73 10 80       	push   $0x80107343
80100f20:	e8 5b f4 ff ff       	call   80100380 <panic>
80100f25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 28             	sub    $0x28,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f3c:	68 60 ef 10 80       	push   $0x8010ef60
80100f41:	e8 aa 37 00 00       	call   801046f0 <acquire>
  if(f->ref < 1)
80100f46:	8b 53 04             	mov    0x4(%ebx),%edx
80100f49:	83 c4 10             	add    $0x10,%esp
80100f4c:	85 d2                	test   %edx,%edx
80100f4e:	0f 8e a5 00 00 00    	jle    80100ff9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f54:	83 ea 01             	sub    $0x1,%edx
80100f57:	89 53 04             	mov    %edx,0x4(%ebx)
80100f5a:	75 44                	jne    80100fa0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f5c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f60:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f63:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f65:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f6b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f6e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f71:	8b 43 10             	mov    0x10(%ebx),%eax
80100f74:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f77:	68 60 ef 10 80       	push   $0x8010ef60
80100f7c:	e8 0f 37 00 00       	call   80104690 <release>

  if(ff.type == FD_PIPE)
80100f81:	83 c4 10             	add    $0x10,%esp
80100f84:	83 ff 01             	cmp    $0x1,%edi
80100f87:	74 57                	je     80100fe0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f89:	83 ff 02             	cmp    $0x2,%edi
80100f8c:	74 2a                	je     80100fb8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f91:	5b                   	pop    %ebx
80100f92:	5e                   	pop    %esi
80100f93:	5f                   	pop    %edi
80100f94:	5d                   	pop    %ebp
80100f95:	c3                   	ret
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fa0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100faa:	5b                   	pop    %ebx
80100fab:	5e                   	pop    %esi
80100fac:	5f                   	pop    %edi
80100fad:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fae:	e9 dd 36 00 00       	jmp    80104690 <release>
80100fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fb7:	90                   	nop
    begin_op();
80100fb8:	e8 d3 1e 00 00       	call   80102e90 <begin_op>
    iput(ff.ip);
80100fbd:	83 ec 0c             	sub    $0xc,%esp
80100fc0:	ff 75 e0             	push   -0x20(%ebp)
80100fc3:	e8 28 09 00 00       	call   801018f0 <iput>
    end_op();
80100fc8:	83 c4 10             	add    $0x10,%esp
}
80100fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fce:	5b                   	pop    %ebx
80100fcf:	5e                   	pop    %esi
80100fd0:	5f                   	pop    %edi
80100fd1:	5d                   	pop    %ebp
    end_op();
80100fd2:	e9 29 1f 00 00       	jmp    80102f00 <end_op>
80100fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fde:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fe0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fe4:	83 ec 08             	sub    $0x8,%esp
80100fe7:	53                   	push   %ebx
80100fe8:	56                   	push   %esi
80100fe9:	e8 62 26 00 00       	call   80103650 <pipeclose>
80100fee:	83 c4 10             	add    $0x10,%esp
}
80100ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff4:	5b                   	pop    %ebx
80100ff5:	5e                   	pop    %esi
80100ff6:	5f                   	pop    %edi
80100ff7:	5d                   	pop    %ebp
80100ff8:	c3                   	ret
    panic("fileclose");
80100ff9:	83 ec 0c             	sub    $0xc,%esp
80100ffc:	68 4b 73 10 80       	push   $0x8010734b
80101001:	e8 7a f3 ff ff       	call   80100380 <panic>
80101006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010100d:	8d 76 00             	lea    0x0(%esi),%esi

80101010 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	53                   	push   %ebx
80101014:	83 ec 04             	sub    $0x4,%esp
80101017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010101a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010101d:	75 31                	jne    80101050 <filestat+0x40>
    ilock(f->ip);
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	ff 73 10             	push   0x10(%ebx)
80101025:	e8 96 07 00 00       	call   801017c0 <ilock>
    stati(f->ip, st);
8010102a:	58                   	pop    %eax
8010102b:	5a                   	pop    %edx
8010102c:	ff 75 0c             	push   0xc(%ebp)
8010102f:	ff 73 10             	push   0x10(%ebx)
80101032:	e8 69 0a 00 00       	call   80101aa0 <stati>
    iunlock(f->ip);
80101037:	59                   	pop    %ecx
80101038:	ff 73 10             	push   0x10(%ebx)
8010103b:	e8 60 08 00 00       	call   801018a0 <iunlock>
    return 0;
  }
  return -1;
}
80101040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101043:	83 c4 10             	add    $0x10,%esp
80101046:	31 c0                	xor    %eax,%eax
}
80101048:	c9                   	leave
80101049:	c3                   	ret
8010104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101053:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101060 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	57                   	push   %edi
80101064:	56                   	push   %esi
80101065:	53                   	push   %ebx
80101066:	83 ec 0c             	sub    $0xc,%esp
80101069:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010106c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010106f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101072:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101076:	74 60                	je     801010d8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101078:	8b 03                	mov    (%ebx),%eax
8010107a:	83 f8 01             	cmp    $0x1,%eax
8010107d:	74 41                	je     801010c0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010107f:	83 f8 02             	cmp    $0x2,%eax
80101082:	75 5b                	jne    801010df <fileread+0x7f>
    ilock(f->ip);
80101084:	83 ec 0c             	sub    $0xc,%esp
80101087:	ff 73 10             	push   0x10(%ebx)
8010108a:	e8 31 07 00 00       	call   801017c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010108f:	57                   	push   %edi
80101090:	ff 73 14             	push   0x14(%ebx)
80101093:	56                   	push   %esi
80101094:	ff 73 10             	push   0x10(%ebx)
80101097:	e8 34 0a 00 00       	call   80101ad0 <readi>
8010109c:	83 c4 20             	add    $0x20,%esp
8010109f:	89 c6                	mov    %eax,%esi
801010a1:	85 c0                	test   %eax,%eax
801010a3:	7e 03                	jle    801010a8 <fileread+0x48>
      f->off += r;
801010a5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010a8:	83 ec 0c             	sub    $0xc,%esp
801010ab:	ff 73 10             	push   0x10(%ebx)
801010ae:	e8 ed 07 00 00       	call   801018a0 <iunlock>
    return r;
801010b3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b9:	89 f0                	mov    %esi,%eax
801010bb:	5b                   	pop    %ebx
801010bc:	5e                   	pop    %esi
801010bd:	5f                   	pop    %edi
801010be:	5d                   	pop    %ebp
801010bf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010c0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	5b                   	pop    %ebx
801010ca:	5e                   	pop    %esi
801010cb:	5f                   	pop    %edi
801010cc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010cd:	e9 3e 27 00 00       	jmp    80103810 <piperead>
801010d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010dd:	eb d7                	jmp    801010b6 <fileread+0x56>
  panic("fileread");
801010df:	83 ec 0c             	sub    $0xc,%esp
801010e2:	68 55 73 10 80       	push   $0x80107355
801010e7:	e8 94 f2 ff ff       	call   80100380 <panic>
801010ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 1c             	sub    $0x1c,%esp
801010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101102:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101105:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010110c:	0f 84 bb 00 00 00    	je     801011cd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101112:	8b 03                	mov    (%ebx),%eax
80101114:	83 f8 01             	cmp    $0x1,%eax
80101117:	0f 84 bf 00 00 00    	je     801011dc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010111d:	83 f8 02             	cmp    $0x2,%eax
80101120:	0f 85 c8 00 00 00    	jne    801011ee <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101129:	31 f6                	xor    %esi,%esi
    while(i < n){
8010112b:	85 c0                	test   %eax,%eax
8010112d:	7f 30                	jg     8010115f <filewrite+0x6f>
8010112f:	e9 94 00 00 00       	jmp    801011c8 <filewrite+0xd8>
80101134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101138:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010113b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010113e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101141:	ff 73 10             	push   0x10(%ebx)
80101144:	e8 57 07 00 00       	call   801018a0 <iunlock>
      end_op();
80101149:	e8 b2 1d 00 00       	call   80102f00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010114e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101151:	83 c4 10             	add    $0x10,%esp
80101154:	39 c7                	cmp    %eax,%edi
80101156:	75 5c                	jne    801011b4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101158:	01 fe                	add    %edi,%esi
    while(i < n){
8010115a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010115d:	7e 69                	jle    801011c8 <filewrite+0xd8>
      int n1 = n - i;
8010115f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101162:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101167:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101169:	39 c7                	cmp    %eax,%edi
8010116b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010116e:	e8 1d 1d 00 00       	call   80102e90 <begin_op>
      ilock(f->ip);
80101173:	83 ec 0c             	sub    $0xc,%esp
80101176:	ff 73 10             	push   0x10(%ebx)
80101179:	e8 42 06 00 00       	call   801017c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010117e:	57                   	push   %edi
8010117f:	ff 73 14             	push   0x14(%ebx)
80101182:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101185:	01 f0                	add    %esi,%eax
80101187:	50                   	push   %eax
80101188:	ff 73 10             	push   0x10(%ebx)
8010118b:	e8 40 0a 00 00       	call   80101bd0 <writei>
80101190:	83 c4 20             	add    $0x20,%esp
80101193:	85 c0                	test   %eax,%eax
80101195:	7f a1                	jg     80101138 <filewrite+0x48>
80101197:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010119a:	83 ec 0c             	sub    $0xc,%esp
8010119d:	ff 73 10             	push   0x10(%ebx)
801011a0:	e8 fb 06 00 00       	call   801018a0 <iunlock>
      end_op();
801011a5:	e8 56 1d 00 00       	call   80102f00 <end_op>
      if(r < 0)
801011aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011ad:	83 c4 10             	add    $0x10,%esp
801011b0:	85 c0                	test   %eax,%eax
801011b2:	75 14                	jne    801011c8 <filewrite+0xd8>
        panic("short filewrite");
801011b4:	83 ec 0c             	sub    $0xc,%esp
801011b7:	68 5e 73 10 80       	push   $0x8010735e
801011bc:	e8 bf f1 ff ff       	call   80100380 <panic>
801011c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011c8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011cb:	74 05                	je     801011d2 <filewrite+0xe2>
801011cd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d5:	89 f0                	mov    %esi,%eax
801011d7:	5b                   	pop    %ebx
801011d8:	5e                   	pop    %esi
801011d9:	5f                   	pop    %edi
801011da:	5d                   	pop    %ebp
801011db:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011dc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011df:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	5b                   	pop    %ebx
801011e6:	5e                   	pop    %esi
801011e7:	5f                   	pop    %edi
801011e8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011e9:	e9 02 25 00 00       	jmp    801036f0 <pipewrite>
  panic("filewrite");
801011ee:	83 ec 0c             	sub    $0xc,%esp
801011f1:	68 64 73 10 80       	push   $0x80107364
801011f6:	e8 85 f1 ff ff       	call   80100380 <panic>
801011fb:	66 90                	xchg   %ax,%ax
801011fd:	66 90                	xchg   %ax,%ax
801011ff:	90                   	nop

80101200 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101209:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010120f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101212:	85 c9                	test   %ecx,%ecx
80101214:	0f 84 8c 00 00 00    	je     801012a6 <balloc+0xa6>
8010121a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010121c:	89 f8                	mov    %edi,%eax
8010121e:	83 ec 08             	sub    $0x8,%esp
80101221:	89 fe                	mov    %edi,%esi
80101223:	c1 f8 0c             	sar    $0xc,%eax
80101226:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010122c:	50                   	push   %eax
8010122d:	ff 75 dc             	push   -0x24(%ebp)
80101230:	e8 9b ee ff ff       	call   801000d0 <bread>
80101235:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101238:	83 c4 10             	add    $0x10,%esp
8010123b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010123e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101243:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101246:	31 c0                	xor    %eax,%eax
80101248:	eb 32                	jmp    8010127c <balloc+0x7c>
8010124a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101250:	89 c1                	mov    %eax,%ecx
80101252:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101257:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010125a:	83 e1 07             	and    $0x7,%ecx
8010125d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010125f:	89 c1                	mov    %eax,%ecx
80101261:	c1 f9 03             	sar    $0x3,%ecx
80101264:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101269:	89 fa                	mov    %edi,%edx
8010126b:	85 df                	test   %ebx,%edi
8010126d:	74 49                	je     801012b8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010126f:	83 c0 01             	add    $0x1,%eax
80101272:	83 c6 01             	add    $0x1,%esi
80101275:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010127a:	74 07                	je     80101283 <balloc+0x83>
8010127c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010127f:	39 d6                	cmp    %edx,%esi
80101281:	72 cd                	jb     80101250 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101283:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010128c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101292:	e8 59 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101297:	83 c4 10             	add    $0x10,%esp
8010129a:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012a0:	0f 82 76 ff ff ff    	jb     8010121c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012a6:	83 ec 0c             	sub    $0xc,%esp
801012a9:	68 6e 73 10 80       	push   $0x8010736e
801012ae:	e8 cd f0 ff ff       	call   80100380 <panic>
801012b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012b7:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
801012b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012bb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012be:	09 da                	or     %ebx,%edx
801012c0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012c4:	57                   	push   %edi
801012c5:	e8 a6 1d 00 00       	call   80103070 <log_write>
        brelse(bp);
801012ca:	89 3c 24             	mov    %edi,(%esp)
801012cd:	e8 1e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012d2:	58                   	pop    %eax
801012d3:	5a                   	pop    %edx
801012d4:	56                   	push   %esi
801012d5:	ff 75 dc             	push   -0x24(%ebp)
801012d8:	e8 f3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012dd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012e0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012e2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012e5:	68 00 02 00 00       	push   $0x200
801012ea:	6a 00                	push   $0x0
801012ec:	50                   	push   %eax
801012ed:	e8 fe 34 00 00       	call   801047f0 <memset>
  log_write(bp);
801012f2:	89 1c 24             	mov    %ebx,(%esp)
801012f5:	e8 76 1d 00 00       	call   80103070 <log_write>
  brelse(bp);
801012fa:	89 1c 24             	mov    %ebx,(%esp)
801012fd:	e8 ee ee ff ff       	call   801001f0 <brelse>
}
80101302:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101305:	89 f0                	mov    %esi,%eax
80101307:	5b                   	pop    %ebx
80101308:	5e                   	pop    %esi
80101309:	5f                   	pop    %edi
8010130a:	5d                   	pop    %ebp
8010130b:	c3                   	ret
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101310 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101314:	31 ff                	xor    %edi,%edi
{
80101316:	56                   	push   %esi
80101317:	89 c6                	mov    %eax,%esi
80101319:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010131f:	83 ec 28             	sub    $0x28,%esp
80101322:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101325:	68 60 f9 10 80       	push   $0x8010f960
8010132a:	e8 c1 33 00 00       	call   801046f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101332:	83 c4 10             	add    $0x10,%esp
80101335:	eb 1b                	jmp    80101352 <iget+0x42>
80101337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101340:	39 33                	cmp    %esi,(%ebx)
80101342:	74 6c                	je     801013b0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101344:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010134a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101350:	74 26                	je     80101378 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101352:	8b 43 08             	mov    0x8(%ebx),%eax
80101355:	85 c0                	test   %eax,%eax
80101357:	7f e7                	jg     80101340 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101359:	85 ff                	test   %edi,%edi
8010135b:	75 e7                	jne    80101344 <iget+0x34>
8010135d:	85 c0                	test   %eax,%eax
8010135f:	75 76                	jne    801013d7 <iget+0xc7>
      empty = ip;
80101361:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101363:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101369:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010136f:	75 e1                	jne    80101352 <iget+0x42>
80101371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101378:	85 ff                	test   %edi,%edi
8010137a:	74 79                	je     801013f5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010137c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010137f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101381:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101384:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010138b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101392:	68 60 f9 10 80       	push   $0x8010f960
80101397:	e8 f4 32 00 00       	call   80104690 <release>

  return ip;
8010139c:	83 c4 10             	add    $0x10,%esp
}
8010139f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a2:	89 f8                	mov    %edi,%eax
801013a4:	5b                   	pop    %ebx
801013a5:	5e                   	pop    %esi
801013a6:	5f                   	pop    %edi
801013a7:	5d                   	pop    %ebp
801013a8:	c3                   	ret
801013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013b3:	75 8f                	jne    80101344 <iget+0x34>
      ip->ref++;
801013b5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013b8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013bb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013bd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013c0:	68 60 f9 10 80       	push   $0x8010f960
801013c5:	e8 c6 32 00 00       	call   80104690 <release>
      return ip;
801013ca:	83 c4 10             	add    $0x10,%esp
}
801013cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d0:	89 f8                	mov    %edi,%eax
801013d2:	5b                   	pop    %ebx
801013d3:	5e                   	pop    %esi
801013d4:	5f                   	pop    %edi
801013d5:	5d                   	pop    %ebp
801013d6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013d7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013dd:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013e3:	74 10                	je     801013f5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e5:	8b 43 08             	mov    0x8(%ebx),%eax
801013e8:	85 c0                	test   %eax,%eax
801013ea:	0f 8f 50 ff ff ff    	jg     80101340 <iget+0x30>
801013f0:	e9 68 ff ff ff       	jmp    8010135d <iget+0x4d>
    panic("iget: no inodes");
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	68 84 73 10 80       	push   $0x80107384
801013fd:	e8 7e ef ff ff       	call   80100380 <panic>
80101402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101413:	89 d0                	mov    %edx,%eax
80101415:	c1 e8 0c             	shr    $0xc,%eax
{
80101418:	89 e5                	mov    %esp,%ebp
8010141a:	56                   	push   %esi
8010141b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010141c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101422:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101424:	83 ec 08             	sub    $0x8,%esp
80101427:	50                   	push   %eax
80101428:	51                   	push   %ecx
80101429:	e8 a2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010142e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101430:	c1 fb 03             	sar    $0x3,%ebx
80101433:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101436:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101438:	83 e1 07             	and    $0x7,%ecx
8010143b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101440:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101446:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101448:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010144d:	85 c1                	test   %eax,%ecx
8010144f:	74 23                	je     80101474 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101451:	f7 d0                	not    %eax
  log_write(bp);
80101453:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101456:	21 c8                	and    %ecx,%eax
80101458:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010145c:	56                   	push   %esi
8010145d:	e8 0e 1c 00 00       	call   80103070 <log_write>
  brelse(bp);
80101462:	89 34 24             	mov    %esi,(%esp)
80101465:	e8 86 ed ff ff       	call   801001f0 <brelse>
}
8010146a:	83 c4 10             	add    $0x10,%esp
8010146d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101470:	5b                   	pop    %ebx
80101471:	5e                   	pop    %esi
80101472:	5d                   	pop    %ebp
80101473:	c3                   	ret
    panic("freeing free block");
80101474:	83 ec 0c             	sub    $0xc,%esp
80101477:	68 94 73 10 80       	push   $0x80107394
8010147c:	e8 ff ee ff ff       	call   80100380 <panic>
80101481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop

80101490 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	57                   	push   %edi
80101494:	56                   	push   %esi
80101495:	89 c6                	mov    %eax,%esi
80101497:	53                   	push   %ebx
80101498:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010149b:	83 fa 0b             	cmp    $0xb,%edx
8010149e:	0f 86 8c 00 00 00    	jbe    80101530 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014a7:	83 fb 7f             	cmp    $0x7f,%ebx
801014aa:	0f 87 a2 00 00 00    	ja     80101552 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014b0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014b6:	85 c0                	test   %eax,%eax
801014b8:	74 5e                	je     80101518 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ba:	83 ec 08             	sub    $0x8,%esp
801014bd:	50                   	push   %eax
801014be:	ff 36                	push   (%esi)
801014c0:	e8 0b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014c5:	83 c4 10             	add    $0x10,%esp
801014c8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014cc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ce:	8b 3b                	mov    (%ebx),%edi
801014d0:	85 ff                	test   %edi,%edi
801014d2:	74 1c                	je     801014f0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014d4:	83 ec 0c             	sub    $0xc,%esp
801014d7:	52                   	push   %edx
801014d8:	e8 13 ed ff ff       	call   801001f0 <brelse>
801014dd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e3:	89 f8                	mov    %edi,%eax
801014e5:	5b                   	pop    %ebx
801014e6:	5e                   	pop    %esi
801014e7:	5f                   	pop    %edi
801014e8:	5d                   	pop    %ebp
801014e9:	c3                   	ret
801014ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014f3:	8b 06                	mov    (%esi),%eax
801014f5:	e8 06 fd ff ff       	call   80101200 <balloc>
      log_write(bp);
801014fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014fd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101500:	89 03                	mov    %eax,(%ebx)
80101502:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101504:	52                   	push   %edx
80101505:	e8 66 1b 00 00       	call   80103070 <log_write>
8010150a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010150d:	83 c4 10             	add    $0x10,%esp
80101510:	eb c2                	jmp    801014d4 <bmap+0x44>
80101512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101518:	8b 06                	mov    (%esi),%eax
8010151a:	e8 e1 fc ff ff       	call   80101200 <balloc>
8010151f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101525:	eb 93                	jmp    801014ba <bmap+0x2a>
80101527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010152e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101530:	8d 5a 14             	lea    0x14(%edx),%ebx
80101533:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101537:	85 ff                	test   %edi,%edi
80101539:	75 a5                	jne    801014e0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010153b:	8b 00                	mov    (%eax),%eax
8010153d:	e8 be fc ff ff       	call   80101200 <balloc>
80101542:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101546:	89 c7                	mov    %eax,%edi
}
80101548:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010154b:	5b                   	pop    %ebx
8010154c:	89 f8                	mov    %edi,%eax
8010154e:	5e                   	pop    %esi
8010154f:	5f                   	pop    %edi
80101550:	5d                   	pop    %ebp
80101551:	c3                   	ret
  panic("bmap: out of range");
80101552:	83 ec 0c             	sub    $0xc,%esp
80101555:	68 a7 73 10 80       	push   $0x801073a7
8010155a:	e8 21 ee ff ff       	call   80100380 <panic>
8010155f:	90                   	nop

80101560 <readsb>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	56                   	push   %esi
80101564:	53                   	push   %ebx
80101565:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	6a 01                	push   $0x1
8010156d:	ff 75 08             	push   0x8(%ebp)
80101570:	e8 5b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101575:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101578:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010157a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010157d:	6a 1c                	push   $0x1c
8010157f:	50                   	push   %eax
80101580:	56                   	push   %esi
80101581:	e8 fa 32 00 00       	call   80104880 <memmove>
  brelse(bp);
80101586:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101589:	83 c4 10             	add    $0x10,%esp
}
8010158c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010158f:	5b                   	pop    %ebx
80101590:	5e                   	pop    %esi
80101591:	5d                   	pop    %ebp
  brelse(bp);
80101592:	e9 59 ec ff ff       	jmp    801001f0 <brelse>
80101597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010159e:	66 90                	xchg   %ax,%ax

801015a0 <iinit>:
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	53                   	push   %ebx
801015a4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801015a9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015ac:	68 ba 73 10 80       	push   $0x801073ba
801015b1:	68 60 f9 10 80       	push   $0x8010f960
801015b6:	e8 45 2f 00 00       	call   80104500 <initlock>
  for(i = 0; i < NINODE; i++) {
801015bb:	83 c4 10             	add    $0x10,%esp
801015be:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015c0:	83 ec 08             	sub    $0x8,%esp
801015c3:	68 c1 73 10 80       	push   $0x801073c1
801015c8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015cf:	e8 fc 2d 00 00       	call   801043d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015d4:	83 c4 10             	add    $0x10,%esp
801015d7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015dd:	75 e1                	jne    801015c0 <iinit+0x20>
  bp = bread(dev, 1);
801015df:	83 ec 08             	sub    $0x8,%esp
801015e2:	6a 01                	push   $0x1
801015e4:	ff 75 08             	push   0x8(%ebp)
801015e7:	e8 e4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ec:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015ef:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015f1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015f4:	6a 1c                	push   $0x1c
801015f6:	50                   	push   %eax
801015f7:	68 b4 15 11 80       	push   $0x801115b4
801015fc:	e8 7f 32 00 00       	call   80104880 <memmove>
  brelse(bp);
80101601:	89 1c 24             	mov    %ebx,(%esp)
80101604:	e8 e7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101609:	ff 35 cc 15 11 80    	push   0x801115cc
8010160f:	ff 35 c8 15 11 80    	push   0x801115c8
80101615:	ff 35 c4 15 11 80    	push   0x801115c4
8010161b:	ff 35 c0 15 11 80    	push   0x801115c0
80101621:	ff 35 bc 15 11 80    	push   0x801115bc
80101627:	ff 35 b8 15 11 80    	push   0x801115b8
8010162d:	ff 35 b4 15 11 80    	push   0x801115b4
80101633:	68 00 78 10 80       	push   $0x80107800
80101638:	e8 73 f0 ff ff       	call   801006b0 <cprintf>
}
8010163d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101640:	83 c4 30             	add    $0x30,%esp
80101643:	c9                   	leave
80101644:	c3                   	ret
80101645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101650 <ialloc>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	57                   	push   %edi
80101654:	56                   	push   %esi
80101655:	53                   	push   %ebx
80101656:	83 ec 1c             	sub    $0x1c,%esp
80101659:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101663:	8b 75 08             	mov    0x8(%ebp),%esi
80101666:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101669:	0f 86 91 00 00 00    	jbe    80101700 <ialloc+0xb0>
8010166f:	bf 01 00 00 00       	mov    $0x1,%edi
80101674:	eb 21                	jmp    80101697 <ialloc+0x47>
80101676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101680:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101683:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101686:	53                   	push   %ebx
80101687:	e8 64 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 c4 10             	add    $0x10,%esp
8010168f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101695:	73 69                	jae    80101700 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101697:	89 f8                	mov    %edi,%eax
80101699:	83 ec 08             	sub    $0x8,%esp
8010169c:	c1 e8 03             	shr    $0x3,%eax
8010169f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016a5:	50                   	push   %eax
801016a6:	56                   	push   %esi
801016a7:	e8 24 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016ac:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016af:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016b1:	89 f8                	mov    %edi,%eax
801016b3:	83 e0 07             	and    $0x7,%eax
801016b6:	c1 e0 06             	shl    $0x6,%eax
801016b9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016c1:	75 bd                	jne    80101680 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016c3:	83 ec 04             	sub    $0x4,%esp
801016c6:	6a 40                	push   $0x40
801016c8:	6a 00                	push   $0x0
801016ca:	51                   	push   %ecx
801016cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ce:	e8 1d 31 00 00       	call   801047f0 <memset>
      dip->type = type;
801016d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016dd:	89 1c 24             	mov    %ebx,(%esp)
801016e0:	e8 8b 19 00 00       	call   80103070 <log_write>
      brelse(bp);
801016e5:	89 1c 24             	mov    %ebx,(%esp)
801016e8:	e8 03 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ed:	83 c4 10             	add    $0x10,%esp
}
801016f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016f3:	89 fa                	mov    %edi,%edx
}
801016f5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016f6:	89 f0                	mov    %esi,%eax
}
801016f8:	5e                   	pop    %esi
801016f9:	5f                   	pop    %edi
801016fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801016fb:	e9 10 fc ff ff       	jmp    80101310 <iget>
  panic("ialloc: no inodes");
80101700:	83 ec 0c             	sub    $0xc,%esp
80101703:	68 c7 73 10 80       	push   $0x801073c7
80101708:	e8 73 ec ff ff       	call   80100380 <panic>
8010170d:	8d 76 00             	lea    0x0(%esi),%esi

80101710 <iupdate>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101718:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010171b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171e:	83 ec 08             	sub    $0x8,%esp
80101721:	c1 e8 03             	shr    $0x3,%eax
80101724:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010172a:	50                   	push   %eax
8010172b:	ff 73 a4             	push   -0x5c(%ebx)
8010172e:	e8 9d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101733:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101737:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010173c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010173f:	83 e0 07             	and    $0x7,%eax
80101742:	c1 e0 06             	shl    $0x6,%eax
80101745:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101749:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010174c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101750:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101753:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101757:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010175b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010175f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101763:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101767:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010176a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176d:	6a 34                	push   $0x34
8010176f:	53                   	push   %ebx
80101770:	50                   	push   %eax
80101771:	e8 0a 31 00 00       	call   80104880 <memmove>
  log_write(bp);
80101776:	89 34 24             	mov    %esi,(%esp)
80101779:	e8 f2 18 00 00       	call   80103070 <log_write>
  brelse(bp);
8010177e:	89 75 08             	mov    %esi,0x8(%ebp)
80101781:	83 c4 10             	add    $0x10,%esp
}
80101784:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101787:	5b                   	pop    %ebx
80101788:	5e                   	pop    %esi
80101789:	5d                   	pop    %ebp
  brelse(bp);
8010178a:	e9 61 ea ff ff       	jmp    801001f0 <brelse>
8010178f:	90                   	nop

80101790 <idup>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	53                   	push   %ebx
80101794:	83 ec 10             	sub    $0x10,%esp
80101797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010179a:	68 60 f9 10 80       	push   $0x8010f960
8010179f:	e8 4c 2f 00 00       	call   801046f0 <acquire>
  ip->ref++;
801017a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017a8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801017af:	e8 dc 2e 00 00       	call   80104690 <release>
}
801017b4:	89 d8                	mov    %ebx,%eax
801017b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017b9:	c9                   	leave
801017ba:	c3                   	ret
801017bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop

801017c0 <ilock>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017c8:	85 db                	test   %ebx,%ebx
801017ca:	0f 84 b7 00 00 00    	je     80101887 <ilock+0xc7>
801017d0:	8b 53 08             	mov    0x8(%ebx),%edx
801017d3:	85 d2                	test   %edx,%edx
801017d5:	0f 8e ac 00 00 00    	jle    80101887 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017db:	83 ec 0c             	sub    $0xc,%esp
801017de:	8d 43 0c             	lea    0xc(%ebx),%eax
801017e1:	50                   	push   %eax
801017e2:	e8 29 2c 00 00       	call   80104410 <acquiresleep>
  if(ip->valid == 0){
801017e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ea:	83 c4 10             	add    $0x10,%esp
801017ed:	85 c0                	test   %eax,%eax
801017ef:	74 0f                	je     80101800 <ilock+0x40>
}
801017f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017f4:	5b                   	pop    %ebx
801017f5:	5e                   	pop    %esi
801017f6:	5d                   	pop    %ebp
801017f7:	c3                   	ret
801017f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017ff:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101800:	8b 43 04             	mov    0x4(%ebx),%eax
80101803:	83 ec 08             	sub    $0x8,%esp
80101806:	c1 e8 03             	shr    $0x3,%eax
80101809:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010180f:	50                   	push   %eax
80101810:	ff 33                	push   (%ebx)
80101812:	e8 b9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101817:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010181a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010181c:	8b 43 04             	mov    0x4(%ebx),%eax
8010181f:	83 e0 07             	and    $0x7,%eax
80101822:	c1 e0 06             	shl    $0x6,%eax
80101825:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101829:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010182c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010182f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101833:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101837:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010183b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010183f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101843:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101847:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010184b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010184e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101851:	6a 34                	push   $0x34
80101853:	50                   	push   %eax
80101854:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101857:	50                   	push   %eax
80101858:	e8 23 30 00 00       	call   80104880 <memmove>
    brelse(bp);
8010185d:	89 34 24             	mov    %esi,(%esp)
80101860:	e8 8b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101865:	83 c4 10             	add    $0x10,%esp
80101868:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010186d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101874:	0f 85 77 ff ff ff    	jne    801017f1 <ilock+0x31>
      panic("ilock: no type");
8010187a:	83 ec 0c             	sub    $0xc,%esp
8010187d:	68 df 73 10 80       	push   $0x801073df
80101882:	e8 f9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101887:	83 ec 0c             	sub    $0xc,%esp
8010188a:	68 d9 73 10 80       	push   $0x801073d9
8010188f:	e8 ec ea ff ff       	call   80100380 <panic>
80101894:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010189f:	90                   	nop

801018a0 <iunlock>:
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	56                   	push   %esi
801018a4:	53                   	push   %ebx
801018a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018a8:	85 db                	test   %ebx,%ebx
801018aa:	74 28                	je     801018d4 <iunlock+0x34>
801018ac:	83 ec 0c             	sub    $0xc,%esp
801018af:	8d 73 0c             	lea    0xc(%ebx),%esi
801018b2:	56                   	push   %esi
801018b3:	e8 f8 2b 00 00       	call   801044b0 <holdingsleep>
801018b8:	83 c4 10             	add    $0x10,%esp
801018bb:	85 c0                	test   %eax,%eax
801018bd:	74 15                	je     801018d4 <iunlock+0x34>
801018bf:	8b 43 08             	mov    0x8(%ebx),%eax
801018c2:	85 c0                	test   %eax,%eax
801018c4:	7e 0e                	jle    801018d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018cc:	5b                   	pop    %ebx
801018cd:	5e                   	pop    %esi
801018ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018cf:	e9 9c 2b 00 00       	jmp    80104470 <releasesleep>
    panic("iunlock");
801018d4:	83 ec 0c             	sub    $0xc,%esp
801018d7:	68 ee 73 10 80       	push   $0x801073ee
801018dc:	e8 9f ea ff ff       	call   80100380 <panic>
801018e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ef:	90                   	nop

801018f0 <iput>:
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	57                   	push   %edi
801018f4:	56                   	push   %esi
801018f5:	53                   	push   %ebx
801018f6:	83 ec 28             	sub    $0x28,%esp
801018f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018ff:	57                   	push   %edi
80101900:	e8 0b 2b 00 00       	call   80104410 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101905:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101908:	83 c4 10             	add    $0x10,%esp
8010190b:	85 d2                	test   %edx,%edx
8010190d:	74 07                	je     80101916 <iput+0x26>
8010190f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101914:	74 32                	je     80101948 <iput+0x58>
  releasesleep(&ip->lock);
80101916:	83 ec 0c             	sub    $0xc,%esp
80101919:	57                   	push   %edi
8010191a:	e8 51 2b 00 00       	call   80104470 <releasesleep>
  acquire(&icache.lock);
8010191f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101926:	e8 c5 2d 00 00       	call   801046f0 <acquire>
  ip->ref--;
8010192b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010192f:	83 c4 10             	add    $0x10,%esp
80101932:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101939:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010193c:	5b                   	pop    %ebx
8010193d:	5e                   	pop    %esi
8010193e:	5f                   	pop    %edi
8010193f:	5d                   	pop    %ebp
  release(&icache.lock);
80101940:	e9 4b 2d 00 00       	jmp    80104690 <release>
80101945:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101948:	83 ec 0c             	sub    $0xc,%esp
8010194b:	68 60 f9 10 80       	push   $0x8010f960
80101950:	e8 9b 2d 00 00       	call   801046f0 <acquire>
    int r = ip->ref;
80101955:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101958:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010195f:	e8 2c 2d 00 00       	call   80104690 <release>
    if(r == 1){
80101964:	83 c4 10             	add    $0x10,%esp
80101967:	83 fe 01             	cmp    $0x1,%esi
8010196a:	75 aa                	jne    80101916 <iput+0x26>
8010196c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101972:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101975:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101978:	89 df                	mov    %ebx,%edi
8010197a:	89 cb                	mov    %ecx,%ebx
8010197c:	eb 09                	jmp    80101987 <iput+0x97>
8010197e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101980:	83 c6 04             	add    $0x4,%esi
80101983:	39 de                	cmp    %ebx,%esi
80101985:	74 19                	je     801019a0 <iput+0xb0>
    if(ip->addrs[i]){
80101987:	8b 16                	mov    (%esi),%edx
80101989:	85 d2                	test   %edx,%edx
8010198b:	74 f3                	je     80101980 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010198d:	8b 07                	mov    (%edi),%eax
8010198f:	e8 7c fa ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101994:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010199a:	eb e4                	jmp    80101980 <iput+0x90>
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019a0:	89 fb                	mov    %edi,%ebx
801019a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019a5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019ab:	85 c0                	test   %eax,%eax
801019ad:	75 2d                	jne    801019dc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019af:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019b2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019b9:	53                   	push   %ebx
801019ba:	e8 51 fd ff ff       	call   80101710 <iupdate>
      ip->type = 0;
801019bf:	31 c0                	xor    %eax,%eax
801019c1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019c5:	89 1c 24             	mov    %ebx,(%esp)
801019c8:	e8 43 fd ff ff       	call   80101710 <iupdate>
      ip->valid = 0;
801019cd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019d4:	83 c4 10             	add    $0x10,%esp
801019d7:	e9 3a ff ff ff       	jmp    80101916 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019dc:	83 ec 08             	sub    $0x8,%esp
801019df:	50                   	push   %eax
801019e0:	ff 33                	push   (%ebx)
801019e2:	e8 e9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019e7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019ea:	83 c4 10             	add    $0x10,%esp
801019ed:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019f6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019f9:	89 cf                	mov    %ecx,%edi
801019fb:	eb 0a                	jmp    80101a07 <iput+0x117>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi
80101a00:	83 c6 04             	add    $0x4,%esi
80101a03:	39 fe                	cmp    %edi,%esi
80101a05:	74 0f                	je     80101a16 <iput+0x126>
      if(a[j])
80101a07:	8b 16                	mov    (%esi),%edx
80101a09:	85 d2                	test   %edx,%edx
80101a0b:	74 f3                	je     80101a00 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a0d:	8b 03                	mov    (%ebx),%eax
80101a0f:	e8 fc f9 ff ff       	call   80101410 <bfree>
80101a14:	eb ea                	jmp    80101a00 <iput+0x110>
    brelse(bp);
80101a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a19:	83 ec 0c             	sub    $0xc,%esp
80101a1c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a1f:	50                   	push   %eax
80101a20:	e8 cb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a25:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a2b:	8b 03                	mov    (%ebx),%eax
80101a2d:	e8 de f9 ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a32:	83 c4 10             	add    $0x10,%esp
80101a35:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a3c:	00 00 00 
80101a3f:	e9 6b ff ff ff       	jmp    801019af <iput+0xbf>
80101a44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a4f:	90                   	nop

80101a50 <iunlockput>:
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	56                   	push   %esi
80101a54:	53                   	push   %ebx
80101a55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a58:	85 db                	test   %ebx,%ebx
80101a5a:	74 34                	je     80101a90 <iunlockput+0x40>
80101a5c:	83 ec 0c             	sub    $0xc,%esp
80101a5f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a62:	56                   	push   %esi
80101a63:	e8 48 2a 00 00       	call   801044b0 <holdingsleep>
80101a68:	83 c4 10             	add    $0x10,%esp
80101a6b:	85 c0                	test   %eax,%eax
80101a6d:	74 21                	je     80101a90 <iunlockput+0x40>
80101a6f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a72:	85 c0                	test   %eax,%eax
80101a74:	7e 1a                	jle    80101a90 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a76:	83 ec 0c             	sub    $0xc,%esp
80101a79:	56                   	push   %esi
80101a7a:	e8 f1 29 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101a7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a82:	83 c4 10             	add    $0x10,%esp
}
80101a85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a88:	5b                   	pop    %ebx
80101a89:	5e                   	pop    %esi
80101a8a:	5d                   	pop    %ebp
  iput(ip);
80101a8b:	e9 60 fe ff ff       	jmp    801018f0 <iput>
    panic("iunlock");
80101a90:	83 ec 0c             	sub    $0xc,%esp
80101a93:	68 ee 73 10 80       	push   $0x801073ee
80101a98:	e8 e3 e8 ff ff       	call   80100380 <panic>
80101a9d:	8d 76 00             	lea    0x0(%esi),%esi

80101aa0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	8b 55 08             	mov    0x8(%ebp),%edx
80101aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101aa9:	8b 0a                	mov    (%edx),%ecx
80101aab:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101aae:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ab1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ab4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ab8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101abb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101abf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ac3:	8b 52 58             	mov    0x58(%edx),%edx
80101ac6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ac9:	5d                   	pop    %ebp
80101aca:	c3                   	ret
80101acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101acf:	90                   	nop

80101ad0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	53                   	push   %ebx
80101ad6:	83 ec 1c             	sub    $0x1c,%esp
80101ad9:	8b 75 08             	mov    0x8(%ebp),%esi
80101adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101adf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ae2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ae7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aea:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101aed:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101af0:	0f 84 aa 00 00 00    	je     80101ba0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101af6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101af9:	8b 56 58             	mov    0x58(%esi),%edx
80101afc:	39 fa                	cmp    %edi,%edx
80101afe:	0f 82 bd 00 00 00    	jb     80101bc1 <readi+0xf1>
80101b04:	89 f9                	mov    %edi,%ecx
80101b06:	31 db                	xor    %ebx,%ebx
80101b08:	01 c1                	add    %eax,%ecx
80101b0a:	0f 92 c3             	setb   %bl
80101b0d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b10:	0f 82 ab 00 00 00    	jb     80101bc1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b16:	89 d3                	mov    %edx,%ebx
80101b18:	29 fb                	sub    %edi,%ebx
80101b1a:	39 ca                	cmp    %ecx,%edx
80101b1c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b1f:	85 c0                	test   %eax,%eax
80101b21:	74 73                	je     80101b96 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b23:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b30:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b33:	89 fa                	mov    %edi,%edx
80101b35:	c1 ea 09             	shr    $0x9,%edx
80101b38:	89 d8                	mov    %ebx,%eax
80101b3a:	e8 51 f9 ff ff       	call   80101490 <bmap>
80101b3f:	83 ec 08             	sub    $0x8,%esp
80101b42:	50                   	push   %eax
80101b43:	ff 33                	push   (%ebx)
80101b45:	e8 86 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b4d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b52:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b54:	89 f8                	mov    %edi,%eax
80101b56:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b5b:	29 f3                	sub    %esi,%ebx
80101b5d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b5f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b63:	39 d9                	cmp    %ebx,%ecx
80101b65:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b68:	83 c4 0c             	add    $0xc,%esp
80101b6b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b6c:	01 de                	add    %ebx,%esi
80101b6e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b70:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b73:	50                   	push   %eax
80101b74:	ff 75 e0             	push   -0x20(%ebp)
80101b77:	e8 04 2d 00 00       	call   80104880 <memmove>
    brelse(bp);
80101b7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b7f:	89 14 24             	mov    %edx,(%esp)
80101b82:	e8 69 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b87:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b8d:	83 c4 10             	add    $0x10,%esp
80101b90:	39 de                	cmp    %ebx,%esi
80101b92:	72 9c                	jb     80101b30 <readi+0x60>
80101b94:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b99:	5b                   	pop    %ebx
80101b9a:	5e                   	pop    %esi
80101b9b:	5f                   	pop    %edi
80101b9c:	5d                   	pop    %ebp
80101b9d:	c3                   	ret
80101b9e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ba0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101ba4:	66 83 fa 09          	cmp    $0x9,%dx
80101ba8:	77 17                	ja     80101bc1 <readi+0xf1>
80101baa:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101bb1:	85 d2                	test   %edx,%edx
80101bb3:	74 0c                	je     80101bc1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bb5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bbb:	5b                   	pop    %ebx
80101bbc:	5e                   	pop    %esi
80101bbd:	5f                   	pop    %edi
80101bbe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bbf:	ff e2                	jmp    *%edx
      return -1;
80101bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bc6:	eb ce                	jmp    80101b96 <readi+0xc6>
80101bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bcf:	90                   	nop

80101bd0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 1c             	sub    $0x1c,%esp
80101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bdf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101be2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101be7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bea:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bed:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bf0:	0f 84 ba 00 00 00    	je     80101cb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bf6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bf9:	0f 82 ea 00 00 00    	jb     80101ce9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bff:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c02:	89 f2                	mov    %esi,%edx
80101c04:	01 fa                	add    %edi,%edx
80101c06:	0f 82 dd 00 00 00    	jb     80101ce9 <writei+0x119>
80101c0c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c12:	0f 87 d1 00 00 00    	ja     80101ce9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	85 f6                	test   %esi,%esi
80101c1a:	0f 84 85 00 00 00    	je     80101ca5 <writei+0xd5>
80101c20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c30:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c33:	89 fa                	mov    %edi,%edx
80101c35:	c1 ea 09             	shr    $0x9,%edx
80101c38:	89 f0                	mov    %esi,%eax
80101c3a:	e8 51 f8 ff ff       	call   80101490 <bmap>
80101c3f:	83 ec 08             	sub    $0x8,%esp
80101c42:	50                   	push   %eax
80101c43:	ff 36                	push   (%esi)
80101c45:	e8 86 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c4d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c50:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c55:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c57:	89 f8                	mov    %edi,%eax
80101c59:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c5e:	29 d3                	sub    %edx,%ebx
80101c60:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c62:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c66:	39 d9                	cmp    %ebx,%ecx
80101c68:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c6b:	83 c4 0c             	add    $0xc,%esp
80101c6e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c71:	ff 75 dc             	push   -0x24(%ebp)
80101c74:	50                   	push   %eax
80101c75:	e8 06 2c 00 00       	call   80104880 <memmove>
    log_write(bp);
80101c7a:	89 34 24             	mov    %esi,(%esp)
80101c7d:	e8 ee 13 00 00       	call   80103070 <log_write>
    brelse(bp);
80101c82:	89 34 24             	mov    %esi,(%esp)
80101c85:	e8 66 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c8a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c90:	83 c4 10             	add    $0x10,%esp
80101c93:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c96:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c99:	39 d8                	cmp    %ebx,%eax
80101c9b:	72 93                	jb     80101c30 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ca0:	39 78 58             	cmp    %edi,0x58(%eax)
80101ca3:	72 33                	jb     80101cd8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
80101caf:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cb4:	66 83 f8 09          	cmp    $0x9,%ax
80101cb8:	77 2f                	ja     80101ce9 <writei+0x119>
80101cba:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101cc1:	85 c0                	test   %eax,%eax
80101cc3:	74 24                	je     80101ce9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101cc5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ccb:	5b                   	pop    %ebx
80101ccc:	5e                   	pop    %esi
80101ccd:	5f                   	pop    %edi
80101cce:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101ccf:	ff e0                	jmp    *%eax
80101cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cd8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cdb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cde:	50                   	push   %eax
80101cdf:	e8 2c fa ff ff       	call   80101710 <iupdate>
80101ce4:	83 c4 10             	add    $0x10,%esp
80101ce7:	eb bc                	jmp    80101ca5 <writei+0xd5>
      return -1;
80101ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cee:	eb b8                	jmp    80101ca8 <writei+0xd8>

80101cf0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cf6:	6a 0e                	push   $0xe
80101cf8:	ff 75 0c             	push   0xc(%ebp)
80101cfb:	ff 75 08             	push   0x8(%ebp)
80101cfe:	e8 ed 2b 00 00       	call   801048f0 <strncmp>
}
80101d03:	c9                   	leave
80101d04:	c3                   	ret
80101d05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	53                   	push   %ebx
80101d16:	83 ec 1c             	sub    $0x1c,%esp
80101d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d21:	0f 85 85 00 00 00    	jne    80101dac <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d27:	8b 53 58             	mov    0x58(%ebx),%edx
80101d2a:	31 ff                	xor    %edi,%edi
80101d2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d2f:	85 d2                	test   %edx,%edx
80101d31:	74 3e                	je     80101d71 <dirlookup+0x61>
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d38:	6a 10                	push   $0x10
80101d3a:	57                   	push   %edi
80101d3b:	56                   	push   %esi
80101d3c:	53                   	push   %ebx
80101d3d:	e8 8e fd ff ff       	call   80101ad0 <readi>
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	83 f8 10             	cmp    $0x10,%eax
80101d48:	75 55                	jne    80101d9f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d4f:	74 18                	je     80101d69 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d51:	83 ec 04             	sub    $0x4,%esp
80101d54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d57:	6a 0e                	push   $0xe
80101d59:	50                   	push   %eax
80101d5a:	ff 75 0c             	push   0xc(%ebp)
80101d5d:	e8 8e 2b 00 00       	call   801048f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d62:	83 c4 10             	add    $0x10,%esp
80101d65:	85 c0                	test   %eax,%eax
80101d67:	74 17                	je     80101d80 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d69:	83 c7 10             	add    $0x10,%edi
80101d6c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d6f:	72 c7                	jb     80101d38 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d74:	31 c0                	xor    %eax,%eax
}
80101d76:	5b                   	pop    %ebx
80101d77:	5e                   	pop    %esi
80101d78:	5f                   	pop    %edi
80101d79:	5d                   	pop    %ebp
80101d7a:	c3                   	ret
80101d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop
      if(poff)
80101d80:	8b 45 10             	mov    0x10(%ebp),%eax
80101d83:	85 c0                	test   %eax,%eax
80101d85:	74 05                	je     80101d8c <dirlookup+0x7c>
        *poff = off;
80101d87:	8b 45 10             	mov    0x10(%ebp),%eax
80101d8a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d8c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d90:	8b 03                	mov    (%ebx),%eax
80101d92:	e8 79 f5 ff ff       	call   80101310 <iget>
}
80101d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9a:	5b                   	pop    %ebx
80101d9b:	5e                   	pop    %esi
80101d9c:	5f                   	pop    %edi
80101d9d:	5d                   	pop    %ebp
80101d9e:	c3                   	ret
      panic("dirlookup read");
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	68 08 74 10 80       	push   $0x80107408
80101da7:	e8 d4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dac:	83 ec 0c             	sub    $0xc,%esp
80101daf:	68 f6 73 10 80       	push   $0x801073f6
80101db4:	e8 c7 e5 ff ff       	call   80100380 <panic>
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dc0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	53                   	push   %ebx
80101dc6:	89 c3                	mov    %eax,%ebx
80101dc8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dcb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dce:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dd1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dd4:	0f 84 9e 01 00 00    	je     80101f78 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dda:	e8 d1 1c 00 00       	call   80103ab0 <myproc>
  acquire(&icache.lock);
80101ddf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101de2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101de5:	68 60 f9 10 80       	push   $0x8010f960
80101dea:	e8 01 29 00 00       	call   801046f0 <acquire>
  ip->ref++;
80101def:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101df3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dfa:	e8 91 28 00 00       	call   80104690 <release>
80101dff:	83 c4 10             	add    $0x10,%esp
80101e02:	eb 07                	jmp    80101e0b <namex+0x4b>
80101e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e08:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e0b:	0f b6 03             	movzbl (%ebx),%eax
80101e0e:	3c 2f                	cmp    $0x2f,%al
80101e10:	74 f6                	je     80101e08 <namex+0x48>
  if(*path == 0)
80101e12:	84 c0                	test   %al,%al
80101e14:	0f 84 06 01 00 00    	je     80101f20 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e1a:	0f b6 03             	movzbl (%ebx),%eax
80101e1d:	84 c0                	test   %al,%al
80101e1f:	0f 84 10 01 00 00    	je     80101f35 <namex+0x175>
80101e25:	89 df                	mov    %ebx,%edi
80101e27:	3c 2f                	cmp    $0x2f,%al
80101e29:	0f 84 06 01 00 00    	je     80101f35 <namex+0x175>
80101e2f:	90                   	nop
80101e30:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e34:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e37:	3c 2f                	cmp    $0x2f,%al
80101e39:	74 04                	je     80101e3f <namex+0x7f>
80101e3b:	84 c0                	test   %al,%al
80101e3d:	75 f1                	jne    80101e30 <namex+0x70>
  len = path - s;
80101e3f:	89 f8                	mov    %edi,%eax
80101e41:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e43:	83 f8 0d             	cmp    $0xd,%eax
80101e46:	0f 8e ac 00 00 00    	jle    80101ef8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e4c:	83 ec 04             	sub    $0x4,%esp
80101e4f:	6a 0e                	push   $0xe
80101e51:	53                   	push   %ebx
80101e52:	89 fb                	mov    %edi,%ebx
80101e54:	ff 75 e4             	push   -0x1c(%ebp)
80101e57:	e8 24 2a 00 00       	call   80104880 <memmove>
80101e5c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e5f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e62:	75 0c                	jne    80101e70 <namex+0xb0>
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e6b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e6e:	74 f8                	je     80101e68 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e70:	83 ec 0c             	sub    $0xc,%esp
80101e73:	56                   	push   %esi
80101e74:	e8 47 f9 ff ff       	call   801017c0 <ilock>
    if(ip->type != T_DIR){
80101e79:	83 c4 10             	add    $0x10,%esp
80101e7c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e81:	0f 85 b7 00 00 00    	jne    80101f3e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	74 09                	je     80101e97 <namex+0xd7>
80101e8e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e91:	0f 84 f7 00 00 00    	je     80101f8e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e97:	83 ec 04             	sub    $0x4,%esp
80101e9a:	6a 00                	push   $0x0
80101e9c:	ff 75 e4             	push   -0x1c(%ebp)
80101e9f:	56                   	push   %esi
80101ea0:	e8 6b fe ff ff       	call   80101d10 <dirlookup>
80101ea5:	83 c4 10             	add    $0x10,%esp
80101ea8:	89 c7                	mov    %eax,%edi
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	0f 84 8c 00 00 00    	je     80101f3e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101eb2:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	51                   	push   %ecx
80101eb9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ebc:	e8 ef 25 00 00       	call   801044b0 <holdingsleep>
80101ec1:	83 c4 10             	add    $0x10,%esp
80101ec4:	85 c0                	test   %eax,%eax
80101ec6:	0f 84 02 01 00 00    	je     80101fce <namex+0x20e>
80101ecc:	8b 56 08             	mov    0x8(%esi),%edx
80101ecf:	85 d2                	test   %edx,%edx
80101ed1:	0f 8e f7 00 00 00    	jle    80101fce <namex+0x20e>
  releasesleep(&ip->lock);
80101ed7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eda:	83 ec 0c             	sub    $0xc,%esp
80101edd:	51                   	push   %ecx
80101ede:	e8 8d 25 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101ee3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ee6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ee8:	e8 03 fa ff ff       	call   801018f0 <iput>
80101eed:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ef0:	e9 16 ff ff ff       	jmp    80101e0b <namex+0x4b>
80101ef5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ef8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101efb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101efe:	83 ec 04             	sub    $0x4,%esp
80101f01:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f04:	50                   	push   %eax
80101f05:	53                   	push   %ebx
    name[len] = 0;
80101f06:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f08:	ff 75 e4             	push   -0x1c(%ebp)
80101f0b:	e8 70 29 00 00       	call   80104880 <memmove>
    name[len] = 0;
80101f10:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f13:	83 c4 10             	add    $0x10,%esp
80101f16:	c6 01 00             	movb   $0x0,(%ecx)
80101f19:	e9 41 ff ff ff       	jmp    80101e5f <namex+0x9f>
80101f1e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f20:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f23:	85 c0                	test   %eax,%eax
80101f25:	0f 85 93 00 00 00    	jne    80101fbe <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f2e:	89 f0                	mov    %esi,%eax
80101f30:	5b                   	pop    %ebx
80101f31:	5e                   	pop    %esi
80101f32:	5f                   	pop    %edi
80101f33:	5d                   	pop    %ebp
80101f34:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f35:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f38:	89 df                	mov    %ebx,%edi
80101f3a:	31 c0                	xor    %eax,%eax
80101f3c:	eb c0                	jmp    80101efe <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f3e:	83 ec 0c             	sub    $0xc,%esp
80101f41:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f44:	53                   	push   %ebx
80101f45:	e8 66 25 00 00       	call   801044b0 <holdingsleep>
80101f4a:	83 c4 10             	add    $0x10,%esp
80101f4d:	85 c0                	test   %eax,%eax
80101f4f:	74 7d                	je     80101fce <namex+0x20e>
80101f51:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f54:	85 c9                	test   %ecx,%ecx
80101f56:	7e 76                	jle    80101fce <namex+0x20e>
  releasesleep(&ip->lock);
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	53                   	push   %ebx
80101f5c:	e8 0f 25 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101f61:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f64:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f66:	e8 85 f9 ff ff       	call   801018f0 <iput>
      return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
}
80101f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f71:	89 f0                	mov    %esi,%eax
80101f73:	5b                   	pop    %ebx
80101f74:	5e                   	pop    %esi
80101f75:	5f                   	pop    %edi
80101f76:	5d                   	pop    %ebp
80101f77:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f78:	ba 01 00 00 00       	mov    $0x1,%edx
80101f7d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f82:	e8 89 f3 ff ff       	call   80101310 <iget>
80101f87:	89 c6                	mov    %eax,%esi
80101f89:	e9 7d fe ff ff       	jmp    80101e0b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f8e:	83 ec 0c             	sub    $0xc,%esp
80101f91:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f94:	53                   	push   %ebx
80101f95:	e8 16 25 00 00       	call   801044b0 <holdingsleep>
80101f9a:	83 c4 10             	add    $0x10,%esp
80101f9d:	85 c0                	test   %eax,%eax
80101f9f:	74 2d                	je     80101fce <namex+0x20e>
80101fa1:	8b 7e 08             	mov    0x8(%esi),%edi
80101fa4:	85 ff                	test   %edi,%edi
80101fa6:	7e 26                	jle    80101fce <namex+0x20e>
  releasesleep(&ip->lock);
80101fa8:	83 ec 0c             	sub    $0xc,%esp
80101fab:	53                   	push   %ebx
80101fac:	e8 bf 24 00 00       	call   80104470 <releasesleep>
}
80101fb1:	83 c4 10             	add    $0x10,%esp
}
80101fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb7:	89 f0                	mov    %esi,%eax
80101fb9:	5b                   	pop    %ebx
80101fba:	5e                   	pop    %esi
80101fbb:	5f                   	pop    %edi
80101fbc:	5d                   	pop    %ebp
80101fbd:	c3                   	ret
    iput(ip);
80101fbe:	83 ec 0c             	sub    $0xc,%esp
80101fc1:	56                   	push   %esi
      return 0;
80101fc2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fc4:	e8 27 f9 ff ff       	call   801018f0 <iput>
    return 0;
80101fc9:	83 c4 10             	add    $0x10,%esp
80101fcc:	eb a0                	jmp    80101f6e <namex+0x1ae>
    panic("iunlock");
80101fce:	83 ec 0c             	sub    $0xc,%esp
80101fd1:	68 ee 73 10 80       	push   $0x801073ee
80101fd6:	e8 a5 e3 ff ff       	call   80100380 <panic>
80101fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fdf:	90                   	nop

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 19 fd ff ff       	call   80101d10 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 ae fa ff ff       	call   80101ad0 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 fe 28 00 00       	call   80104940 <strncpy>
  de.inum = inum;
80102042:	8b 45 10             	mov    0x10(%ebp),%eax
80102045:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102049:	6a 10                	push   $0x10
8010204b:	57                   	push   %edi
8010204c:	56                   	push   %esi
8010204d:	53                   	push   %ebx
8010204e:	e8 7d fb ff ff       	call   80101bd0 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 82 f8 ff ff       	call   801018f0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 17 74 10 80       	push   $0x80107417
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 9e 76 10 80       	push   $0x8010769e
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 0d fd ff ff       	call   80101dc0 <namex>
}
801020b3:	c9                   	leave
801020b4:	c3                   	ret
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 ec fc ff ff       	jmp    80101dc0 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 2d 74 10 80       	push   $0x8010742d
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 24 74 10 80       	push   $0x80107424
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 3f 74 10 80       	push   $0x8010743f
801021cb:	68 00 16 11 80       	push   $0x80111600
801021d0:	e8 2b 23 00 00       	call   80104500 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021ef:	90                   	nop
801021f0:	89 ca                	mov    %ecx,%edx
801021f2:	ec                   	in     (%dx),%al
801021f3:	83 e0 c0             	and    $0xffffffc0,%eax
801021f6:	3c 40                	cmp    $0x40,%al
801021f8:	75 f6                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021ff:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102204:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102205:	89 ca                	mov    %ecx,%edx
80102207:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102208:	84 c0                	test   %al,%al
8010220a:	75 1e                	jne    8010222a <ideinit+0x6a>
8010220c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102211:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010221d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x74>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x60>
      havedisk1 = 1;
8010222a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave
80102240:	c3                   	ret
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 00 16 11 80       	push   $0x80111600
8010225e:	e8 8d 24 00 00       	call   801046f0 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 63                	je     801022d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 33                	mov    (%ebx),%esi
8010227a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102280:	75 2f                	jne    801022b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 12                	jne    801022b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b7:	83 ce 02             	or     $0x2,%esi
801022ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022bc:	53                   	push   %ebx
801022bd:	e8 6e 1f 00 00       	call   80104230 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	74 05                	je     801022d3 <ideintr+0x83>
    idestart(idequeue);
801022ce:	e8 0d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	68 00 16 11 80       	push   $0x80111600
801022db:	e8 b0 23 00 00       	call   80104690 <release>

  release(&idelock);
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 ad 21 00 00       	call   801044b0 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c3 00 00 00    	je     801023d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 a8 00 00 00    	je     801023c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 87 00 00 00    	je     801023b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 00 16 11 80       	push   $0x80111600
80102338:	e8 b3 23 00 00       	call   801046f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102342:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 c0                	test   %eax,%eax
8010234e:	74 60                	je     801023b0 <iderw+0xc0>
80102350:	89 c2                	mov    %eax,%edx
80102352:	8b 40 58             	mov    0x58(%eax),%eax
80102355:	85 c0                	test   %eax,%eax
80102357:	75 f7                	jne    80102350 <iderw+0x60>
80102359:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010235c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010235e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102364:	74 3a                	je     801023a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102366:	8b 03                	mov    (%ebx),%eax
80102368:	83 e0 06             	and    $0x6,%eax
8010236b:	83 f8 02             	cmp    $0x2,%eax
8010236e:	74 1b                	je     8010238b <iderw+0x9b>
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 00 16 11 80       	push   $0x80111600
80102378:	53                   	push   %ebx
80102379:	e8 f2 1d 00 00       	call   80104170 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x80>
  }


  release(&idelock);
8010238b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave
  release(&idelock);
80102396:	e9 f5 22 00 00       	jmp    80104690 <release>
8010239b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 39 fd ff ff       	call   801020e0 <idestart>
801023a7:	eb bd                	jmp    80102366 <iderw+0x76>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023b5:	eb a5                	jmp    8010235c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 6e 74 10 80       	push   $0x8010746e
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 59 74 10 80       	push   $0x80107459
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 43 74 10 80       	push   $0x80107443
801023d9:	e8 a2 df ff ff       	call   80100380 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e5:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023ec:	00 c0 fe 
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102402:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102408:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102415:	c1 ee 10             	shr    $0x10,%esi
80102418:	89 f0                	mov    %esi,%eax
8010241a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010241d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102420:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102423:	39 c2                	cmp    %eax,%edx
80102425:	74 16                	je     8010243d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 54 78 10 80       	push   $0x80107854
8010242f:	e8 7c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102434:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010243a:	83 c4 10             	add    $0x10,%esp
{
8010243d:	ba 10 00 00 00       	mov    $0x10,%edx
80102442:	31 c0                	xor    %eax,%eax
80102444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102448:	89 13                	mov    %edx,(%ebx)
8010244a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010244d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102453:	83 c0 01             	add    $0x1,%eax
80102456:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010245c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010245f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102462:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102465:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102467:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010246d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102474:	39 c6                	cmp    %eax,%esi
80102476:	7d d0                	jge    80102448 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102478:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010247b:	5b                   	pop    %ebx
8010247c:	5e                   	pop    %esi
8010247d:	5d                   	pop    %ebp
8010247e:	c3                   	ret
8010247f:	90                   	nop

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 f9 22 00 00       	call   801047f0 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 16 11 80       	mov    0x80111678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave
8010251e:	c3                   	ret
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 16 11 80       	push   $0x80111640
80102528:	e8 c3 21 00 00       	call   801046f0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave
    release(&kmem.lock);
80102543:	e9 48 21 00 00       	jmp    80104690 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 8c 74 10 80       	push   $0x8010748c
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
80102564:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102565:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102568:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	73 e4                	jae    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
801025b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 92 74 10 80       	push   $0x80107492
80102620:	68 40 16 11 80       	push   $0x80111640
80102625:	e8 d6 1e 00 00       	call   80104500 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	53                   	push   %ebx
80102684:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102687:	a1 74 16 11 80       	mov    0x80111674,%eax
8010268c:	85 c0                	test   %eax,%eax
8010268e:	75 20                	jne    801026b0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102690:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
80102696:	85 db                	test   %ebx,%ebx
80102698:	74 07                	je     801026a1 <kalloc+0x21>
    kmem.freelist = r->next;
8010269a:	8b 03                	mov    (%ebx),%eax
8010269c:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026a1:	89 d8                	mov    %ebx,%eax
801026a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026a6:	c9                   	leave
801026a7:	c3                   	ret
801026a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop
    acquire(&kmem.lock);
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	68 40 16 11 80       	push   $0x80111640
801026b8:	e8 33 20 00 00       	call   801046f0 <acquire>
  r = kmem.freelist;
801026bd:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
801026c3:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
801026c8:	83 c4 10             	add    $0x10,%esp
801026cb:	85 db                	test   %ebx,%ebx
801026cd:	74 08                	je     801026d7 <kalloc+0x57>
    kmem.freelist = r->next;
801026cf:	8b 13                	mov    (%ebx),%edx
801026d1:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801026d7:	85 c0                	test   %eax,%eax
801026d9:	74 c6                	je     801026a1 <kalloc+0x21>
    release(&kmem.lock);
801026db:	83 ec 0c             	sub    $0xc,%esp
801026de:	68 40 16 11 80       	push   $0x80111640
801026e3:	e8 a8 1f 00 00       	call   80104690 <release>
}
801026e8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026ea:	83 c4 10             	add    $0x10,%esp
}
801026ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026f0:	c9                   	leave
801026f1:	c3                   	ret
801026f2:	66 90                	xchg   %ax,%ax
801026f4:	66 90                	xchg   %ax,%ax
801026f6:	66 90                	xchg   %ax,%ax
801026f8:	66 90                	xchg   %ax,%ax
801026fa:	66 90                	xchg   %ax,%ax
801026fc:	66 90                	xchg   %ax,%ax
801026fe:	66 90                	xchg   %ax,%ax

80102700 <print_str>:
    ['N'] = 'B',
    ['M'] = 'M'
};

// Helper function to print a string
void print_str(char *str) {
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
80102707:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while(*str) {
8010270a:	0f be 03             	movsbl (%ebx),%eax
8010270d:	84 c0                	test   %al,%al
8010270f:	74 1d                	je     8010272e <print_str+0x2e>
80102711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        consputc(*str++);
80102718:	83 ec 0c             	sub    $0xc,%esp
8010271b:	83 c3 01             	add    $0x1,%ebx
8010271e:	50                   	push   %eax
8010271f:	e8 7c e1 ff ff       	call   801008a0 <consputc>
    while(*str) {
80102724:	0f be 03             	movsbl (%ebx),%eax
80102727:	83 c4 10             	add    $0x10,%esp
8010272a:	84 c0                	test   %al,%al
8010272c:	75 ea                	jne    80102718 <print_str+0x18>
    }
}
8010272e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102731:	c9                   	leave
80102732:	c3                   	ret
80102733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102740 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102740:	ba 64 00 00 00       	mov    $0x64,%edx
80102745:	ec                   	in     (%dx),%al
    static uint shift;
    static uchar *charcode[4] = {normalmap, shiftmap, ctlmap, ctlmap};
    uint st, data, c;

    st = inb(KBSTATP);
    if ((st & KBS_DIB) == 0)
80102746:	a8 01                	test   $0x1,%al
80102748:	0f 84 f2 00 00 00    	je     80102840 <kbdgetc+0x100>
int kbdgetc(void) {
8010274e:	55                   	push   %ebp
8010274f:	ba 60 00 00 00       	mov    $0x60,%edx
80102754:	89 e5                	mov    %esp,%ebp
80102756:	53                   	push   %ebx
80102757:	ec                   	in     (%dx),%al
        return -1;
    data = inb(KBDATAP);

    // Handle extended keys
    if (data == 0xE0) {
        shift |= E0ESC;
80102758:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
    data = inb(KBDATAP);
8010275e:	0f b6 c8             	movzbl %al,%ecx
    if (data == 0xE0) {
80102761:	3c e0                	cmp    $0xe0,%al
80102763:	0f 84 87 00 00 00    	je     801027f0 <kbdgetc+0xb0>
        return 0;
    } else if (data & 0x80) {
        data = (shift & E0ESC ? data : data & 0x7F);
80102769:	89 da                	mov    %ebx,%edx
8010276b:	83 e2 40             	and    $0x40,%edx
    } else if (data & 0x80) {
8010276e:	84 c0                	test   %al,%al
80102770:	0f 88 8a 00 00 00    	js     80102800 <kbdgetc+0xc0>
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    } else if (shift & E0ESC) {
80102776:	85 d2                	test   %edx,%edx
80102778:	74 09                	je     80102783 <kbdgetc+0x43>
        data |= 0x80;
8010277a:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
8010277d:	83 e3 bf             	and    $0xffffffbf,%ebx
        data |= 0x80;
80102780:	0f b6 c8             	movzbl %al,%ecx
    }

    shift |= shiftcode[data];
80102783:	0f b6 91 40 7b 10 80 	movzbl -0x7fef84c0(%ecx),%edx
    shift ^= togglecode[data];
8010278a:	0f b6 81 40 7a 10 80 	movzbl -0x7fef85c0(%ecx),%eax
    shift |= shiftcode[data];
80102791:	09 da                	or     %ebx,%edx
    shift ^= togglecode[data];
80102793:	31 c2                	xor    %eax,%edx

    // Get the ASCII character
    c = charcode[shift & (CTL | SHIFT)][data];
80102795:	89 d0                	mov    %edx,%eax
    shift ^= togglecode[data];
80102797:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
            c = mapped;
        }
    }

    // Handle CAPSLOCK
    if (shift & CAPSLOCK) {
8010279d:	83 e2 08             	and    $0x8,%edx
    c = charcode[shift & (CTL | SHIFT)][data];
801027a0:	83 e0 03             	and    $0x3,%eax
801027a3:	8b 04 85 a0 79 10 80 	mov    -0x7fef8660(,%eax,4),%eax
801027aa:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
    if (is_dvorak && c >= 0x20 && c < 0x7F) {
801027ae:	8b 0d 80 16 11 80    	mov    0x80111680,%ecx
801027b4:	85 c9                	test   %ecx,%ecx
801027b6:	75 18                	jne    801027d0 <kbdgetc+0x90>
    if (shift & CAPSLOCK) {
801027b8:	85 d2                	test   %edx,%edx
801027ba:	74 0b                	je     801027c7 <kbdgetc+0x87>
        if ('a' <= c && c <= 'z')
801027bc:	8d 50 9f             	lea    -0x61(%eax),%edx
801027bf:	83 fa 19             	cmp    $0x19,%edx
801027c2:	77 64                	ja     80102828 <kbdgetc+0xe8>
            c += 'A' - 'a';
801027c4:	83 e8 20             	sub    $0x20,%eax
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }

    return c;
}
801027c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ca:	c9                   	leave
801027cb:	c3                   	ret
801027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (is_dvorak && c >= 0x20 && c < 0x7F) {
801027d0:	8d 48 e0             	lea    -0x20(%eax),%ecx
801027d3:	83 f9 5e             	cmp    $0x5e,%ecx
801027d6:	77 ef                	ja     801027c7 <kbdgetc+0x87>
        unsigned char mapped = qwerty_to_dvorak_char[c];
801027d8:	0f b6 98 c0 79 10 80 	movzbl -0x7fef8640(%eax),%ebx
            c = mapped;
801027df:	84 db                	test   %bl,%bl
801027e1:	0f 45 c3             	cmovne %ebx,%eax
801027e4:	eb d2                	jmp    801027b8 <kbdgetc+0x78>
801027e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ed:	8d 76 00             	lea    0x0(%esi),%esi
        shift |= E0ESC;
801027f0:	83 cb 40             	or     $0x40,%ebx
        return 0;
801027f3:	31 c0                	xor    %eax,%eax
        shift |= E0ESC;
801027f5:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
801027fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027fe:	c9                   	leave
801027ff:	c3                   	ret
        data = (shift & E0ESC ? data : data & 0x7F);
80102800:	83 e0 7f             	and    $0x7f,%eax
80102803:	85 d2                	test   %edx,%edx
80102805:	0f 44 c8             	cmove  %eax,%ecx
        shift &= ~(shiftcode[data] | E0ESC);
80102808:	0f b6 81 40 7b 10 80 	movzbl -0x7fef84c0(%ecx),%eax
8010280f:	83 c8 40             	or     $0x40,%eax
80102812:	0f b6 c0             	movzbl %al,%eax
80102815:	f7 d0                	not    %eax
80102817:	21 d8                	and    %ebx,%eax
80102819:	a3 7c 16 11 80       	mov    %eax,0x8011167c
        return 0;
8010281e:	31 c0                	xor    %eax,%eax
80102820:	eb d9                	jmp    801027fb <kbdgetc+0xbb>
80102822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        else if ('A' <= c && c <= 'Z')
80102828:	8d 48 bf             	lea    -0x41(%eax),%ecx
            c += 'a' - 'A';
8010282b:	8d 50 20             	lea    0x20(%eax),%edx
8010282e:	83 f9 1a             	cmp    $0x1a,%ecx
80102831:	0f 42 c2             	cmovb  %edx,%eax
    return c;
80102834:	eb 91                	jmp    801027c7 <kbdgetc+0x87>
80102836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283d:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80102840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102845:	c3                   	ret
80102846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <kbdintr>:

void kbdintr(void) {
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	53                   	push   %ebx
80102854:	83 ec 04             	sub    $0x4,%esp
    int c = kbdgetc();
80102857:	e8 e4 fe ff ff       	call   80102740 <kbdgetc>
    if (c != -1) {
8010285c:	83 f8 ff             	cmp    $0xffffffff,%eax
8010285f:	74 10                	je     80102871 <kbdintr+0x21>
        if ((c & 0xff) == 4) {  // Ctrl+D
80102861:	3c 04                	cmp    $0x4,%al
80102863:	74 1b                	je     80102880 <kbdintr+0x30>
            } else {
                print_str("QWERTY");
            }
            consputc('\n');
        } else {
            consputc(c);
80102865:	83 ec 0c             	sub    $0xc,%esp
80102868:	50                   	push   %eax
80102869:	e8 32 e0 ff ff       	call   801008a0 <consputc>
8010286e:	83 c4 10             	add    $0x10,%esp
        }
    }
}
80102871:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102874:	c9                   	leave
80102875:	c3                   	ret
80102876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287d:	8d 76 00             	lea    0x0(%esi),%esi
            consputc('\n');
80102880:	83 ec 0c             	sub    $0xc,%esp
80102883:	bb 97 74 10 80       	mov    $0x80107497,%ebx
80102888:	6a 0a                	push   $0xa
8010288a:	e8 11 e0 ff ff       	call   801008a0 <consputc>
8010288f:	83 c4 10             	add    $0x10,%esp
    while(*str) {
80102892:	b8 4b 00 00 00       	mov    $0x4b,%eax
80102897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289e:	66 90                	xchg   %ax,%ax
        consputc(*str++);
801028a0:	83 ec 0c             	sub    $0xc,%esp
801028a3:	83 c3 01             	add    $0x1,%ebx
801028a6:	50                   	push   %eax
801028a7:	e8 f4 df ff ff       	call   801008a0 <consputc>
    while(*str) {
801028ac:	0f be 03             	movsbl (%ebx),%eax
801028af:	83 c4 10             	add    $0x10,%esp
801028b2:	84 c0                	test   %al,%al
801028b4:	75 ea                	jne    801028a0 <kbdintr+0x50>
            is_dvorak = !is_dvorak;
801028b6:	8b 15 80 16 11 80    	mov    0x80111680,%edx
801028bc:	31 c0                	xor    %eax,%eax
801028be:	85 d2                	test   %edx,%edx
801028c0:	0f 94 c0             	sete   %al
801028c3:	a3 80 16 11 80       	mov    %eax,0x80111680
            if (is_dvorak) {
801028c8:	75 36                	jne    80102900 <kbdintr+0xb0>
    while(*str) {
801028ca:	b8 44 00 00 00       	mov    $0x44,%eax
801028cf:	bb b4 74 10 80       	mov    $0x801074b4,%ebx
801028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        consputc(*str++);
801028d8:	83 ec 0c             	sub    $0xc,%esp
801028db:	83 c3 01             	add    $0x1,%ebx
801028de:	50                   	push   %eax
801028df:	e8 bc df ff ff       	call   801008a0 <consputc>
    while(*str) {
801028e4:	0f be 03             	movsbl (%ebx),%eax
801028e7:	83 c4 10             	add    $0x10,%esp
801028ea:	84 c0                	test   %al,%al
801028ec:	75 ea                	jne    801028d8 <kbdintr+0x88>
            consputc('\n');
801028ee:	83 ec 0c             	sub    $0xc,%esp
801028f1:	6a 0a                	push   $0xa
801028f3:	e8 a8 df ff ff       	call   801008a0 <consputc>
}
801028f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028fb:	83 c4 10             	add    $0x10,%esp
801028fe:	c9                   	leave
801028ff:	c3                   	ret
    while(*str) {
80102900:	b8 51 00 00 00       	mov    $0x51,%eax
80102905:	bb bb 74 10 80       	mov    $0x801074bb,%ebx
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        consputc(*str++);
80102910:	83 ec 0c             	sub    $0xc,%esp
80102913:	83 c3 01             	add    $0x1,%ebx
80102916:	50                   	push   %eax
80102917:	e8 84 df ff ff       	call   801008a0 <consputc>
    while(*str) {
8010291c:	0f be 03             	movsbl (%ebx),%eax
8010291f:	83 c4 10             	add    $0x10,%esp
80102922:	84 c0                	test   %al,%al
80102924:	75 ea                	jne    80102910 <kbdintr+0xc0>
80102926:	eb c6                	jmp    801028ee <kbdintr+0x9e>
80102928:	66 90                	xchg   %ax,%ax
8010292a:	66 90                	xchg   %ax,%ax
8010292c:	66 90                	xchg   %ax,%ax
8010292e:	66 90                	xchg   %ax,%ax

80102930 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102930:	a1 84 16 11 80       	mov    0x80111684,%eax
80102935:	85 c0                	test   %eax,%eax
80102937:	0f 84 c3 00 00 00    	je     80102a00 <lapicinit+0xd0>
  lapic[index] = value;
8010293d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102944:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102947:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102951:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102954:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102957:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010295e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102961:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102964:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010296b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010296e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102971:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102978:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010297b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010297e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102985:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102988:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010298b:	8b 50 30             	mov    0x30(%eax),%edx
8010298e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102994:	75 72                	jne    80102a08 <lapicinit+0xd8>
  lapic[index] = value;
80102996:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010299d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029bd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ca:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029d1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029de:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029e8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029ee:	80 e6 10             	and    $0x10,%dh
801029f1:	75 f5                	jne    801029e8 <lapicinit+0xb8>
  lapic[index] = value;
801029f3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029fd:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a00:	c3                   	ret
80102a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a08:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a0f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a12:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a15:	e9 7c ff ff ff       	jmp    80102996 <lapicinit+0x66>
80102a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a20 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a20:	a1 84 16 11 80       	mov    0x80111684,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 07                	je     80102a30 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a29:	8b 40 20             	mov    0x20(%eax),%eax
80102a2c:	c1 e8 18             	shr    $0x18,%eax
80102a2f:	c3                   	ret
    return 0;
80102a30:	31 c0                	xor    %eax,%eax
}
80102a32:	c3                   	ret
80102a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a40 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a40:	a1 84 16 11 80       	mov    0x80111684,%eax
80102a45:	85 c0                	test   %eax,%eax
80102a47:	74 0d                	je     80102a56 <lapiceoi+0x16>
  lapic[index] = value;
80102a49:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a53:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a56:	c3                   	ret
80102a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5e:	66 90                	xchg   %ax,%ax

80102a60 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a60:	c3                   	ret
80102a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a6f:	90                   	nop

80102a70 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a71:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a76:	ba 70 00 00 00       	mov    $0x70,%edx
80102a7b:	89 e5                	mov    %esp,%ebp
80102a7d:	53                   	push   %ebx
80102a7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a84:	ee                   	out    %al,(%dx)
80102a85:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a8a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a8f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a90:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102a92:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a95:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a9b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a9d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102aa0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102aa2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102aa5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102aa8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102aae:	a1 84 16 11 80       	mov    0x80111684,%eax
80102ab3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ab9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102abc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ac3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ad0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ad6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102adc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102adf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ae5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ae8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102af1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102af7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102afd:	c9                   	leave
80102afe:	c3                   	ret
80102aff:	90                   	nop

80102b00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b00:	55                   	push   %ebp
80102b01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b06:	ba 70 00 00 00       	mov    $0x70,%edx
80102b0b:	89 e5                	mov    %esp,%ebp
80102b0d:	57                   	push   %edi
80102b0e:	56                   	push   %esi
80102b0f:	53                   	push   %ebx
80102b10:	83 ec 4c             	sub    $0x4c,%esp
80102b13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b14:	ba 71 00 00 00       	mov    $0x71,%edx
80102b19:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1d:	bf 70 00 00 00       	mov    $0x70,%edi
80102b22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b25:	8d 76 00             	lea    0x0(%esi),%esi
80102b28:	31 c0                	xor    %eax,%eax
80102b2a:	89 fa                	mov    %edi,%edx
80102b2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b32:	89 ca                	mov    %ecx,%edx
80102b34:	ec                   	in     (%dx),%al
80102b35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b38:	89 fa                	mov    %edi,%edx
80102b3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b40:	89 ca                	mov    %ecx,%edx
80102b42:	ec                   	in     (%dx),%al
80102b43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b46:	89 fa                	mov    %edi,%edx
80102b48:	b8 04 00 00 00       	mov    $0x4,%eax
80102b4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4e:	89 ca                	mov    %ecx,%edx
80102b50:	ec                   	in     (%dx),%al
80102b51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b54:	89 fa                	mov    %edi,%edx
80102b56:	b8 07 00 00 00       	mov    $0x7,%eax
80102b5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5c:	89 ca                	mov    %ecx,%edx
80102b5e:	ec                   	in     (%dx),%al
80102b5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b62:	89 fa                	mov    %edi,%edx
80102b64:	b8 08 00 00 00       	mov    $0x8,%eax
80102b69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6a:	89 ca                	mov    %ecx,%edx
80102b6c:	ec                   	in     (%dx),%al
80102b6d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6f:	89 fa                	mov    %edi,%edx
80102b71:	b8 09 00 00 00       	mov    $0x9,%eax
80102b76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b77:	89 ca                	mov    %ecx,%edx
80102b79:	ec                   	in     (%dx),%al
80102b7a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b7d:	89 fa                	mov    %edi,%edx
80102b7f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b85:	89 ca                	mov    %ecx,%edx
80102b87:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b88:	84 c0                	test   %al,%al
80102b8a:	78 9c                	js     80102b28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b8c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b90:	89 f2                	mov    %esi,%edx
80102b92:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102b95:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b98:	89 fa                	mov    %edi,%edx
80102b9a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b9d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ba1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102ba4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ba7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bab:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bae:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102bb2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bb5:	31 c0                	xor    %eax,%eax
80102bb7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb8:	89 ca                	mov    %ecx,%edx
80102bba:	ec                   	in     (%dx),%al
80102bbb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bbe:	89 fa                	mov    %edi,%edx
80102bc0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bc3:	b8 02 00 00 00       	mov    $0x2,%eax
80102bc8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc9:	89 ca                	mov    %ecx,%edx
80102bcb:	ec                   	in     (%dx),%al
80102bcc:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcf:	89 fa                	mov    %edi,%edx
80102bd1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bd4:	b8 04 00 00 00       	mov    $0x4,%eax
80102bd9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bda:	89 ca                	mov    %ecx,%edx
80102bdc:	ec                   	in     (%dx),%al
80102bdd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be0:	89 fa                	mov    %edi,%edx
80102be2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102be5:	b8 07 00 00 00       	mov    $0x7,%eax
80102bea:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102beb:	89 ca                	mov    %ecx,%edx
80102bed:	ec                   	in     (%dx),%al
80102bee:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf1:	89 fa                	mov    %edi,%edx
80102bf3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bf6:	b8 08 00 00 00       	mov    $0x8,%eax
80102bfb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfc:	89 ca                	mov    %ecx,%edx
80102bfe:	ec                   	in     (%dx),%al
80102bff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c02:	89 fa                	mov    %edi,%edx
80102c04:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c07:	b8 09 00 00 00       	mov    $0x9,%eax
80102c0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0d:	89 ca                	mov    %ecx,%edx
80102c0f:	ec                   	in     (%dx),%al
80102c10:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c13:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c19:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c1c:	6a 18                	push   $0x18
80102c1e:	50                   	push   %eax
80102c1f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c22:	50                   	push   %eax
80102c23:	e8 08 1c 00 00       	call   80104830 <memcmp>
80102c28:	83 c4 10             	add    $0x10,%esp
80102c2b:	85 c0                	test   %eax,%eax
80102c2d:	0f 85 f5 fe ff ff    	jne    80102b28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c33:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c3a:	89 f0                	mov    %esi,%eax
80102c3c:	84 c0                	test   %al,%al
80102c3e:	75 78                	jne    80102cb8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c40:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c43:	89 c2                	mov    %eax,%edx
80102c45:	83 e0 0f             	and    $0xf,%eax
80102c48:	c1 ea 04             	shr    $0x4,%edx
80102c4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c51:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c54:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c57:	89 c2                	mov    %eax,%edx
80102c59:	83 e0 0f             	and    $0xf,%eax
80102c5c:	c1 ea 04             	shr    $0x4,%edx
80102c5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c65:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c68:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c6b:	89 c2                	mov    %eax,%edx
80102c6d:	83 e0 0f             	and    $0xf,%eax
80102c70:	c1 ea 04             	shr    $0x4,%edx
80102c73:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c76:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c79:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c7c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c7f:	89 c2                	mov    %eax,%edx
80102c81:	83 e0 0f             	and    $0xf,%eax
80102c84:	c1 ea 04             	shr    $0x4,%edx
80102c87:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c8d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c90:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c93:	89 c2                	mov    %eax,%edx
80102c95:	83 e0 0f             	and    $0xf,%eax
80102c98:	c1 ea 04             	shr    $0x4,%edx
80102c9b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c9e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ca1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ca4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ca7:	89 c2                	mov    %eax,%edx
80102ca9:	83 e0 0f             	and    $0xf,%eax
80102cac:	c1 ea 04             	shr    $0x4,%edx
80102caf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cb2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cb5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102cb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cbb:	89 03                	mov    %eax,(%ebx)
80102cbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cc0:	89 43 04             	mov    %eax,0x4(%ebx)
80102cc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cc6:	89 43 08             	mov    %eax,0x8(%ebx)
80102cc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ccc:	89 43 0c             	mov    %eax,0xc(%ebx)
80102ccf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cd2:	89 43 10             	mov    %eax,0x10(%ebx)
80102cd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cd8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102cdb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce5:	5b                   	pop    %ebx
80102ce6:	5e                   	pop    %esi
80102ce7:	5f                   	pop    %edi
80102ce8:	5d                   	pop    %ebp
80102ce9:	c3                   	ret
80102cea:	66 90                	xchg   %ax,%ax
80102cec:	66 90                	xchg   %ax,%ax
80102cee:	66 90                	xchg   %ax,%ax

80102cf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cf0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102cf6:	85 c9                	test   %ecx,%ecx
80102cf8:	0f 8e 8a 00 00 00    	jle    80102d88 <install_trans+0x98>
{
80102cfe:	55                   	push   %ebp
80102cff:	89 e5                	mov    %esp,%ebp
80102d01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d02:	31 ff                	xor    %edi,%edi
{
80102d04:	56                   	push   %esi
80102d05:	53                   	push   %ebx
80102d06:	83 ec 0c             	sub    $0xc,%esp
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d10:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102d15:	83 ec 08             	sub    $0x8,%esp
80102d18:	01 f8                	add    %edi,%eax
80102d1a:	83 c0 01             	add    $0x1,%eax
80102d1d:	50                   	push   %eax
80102d1e:	ff 35 e4 16 11 80    	push   0x801116e4
80102d24:	e8 a7 d3 ff ff       	call   801000d0 <bread>
80102d29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d2b:	58                   	pop    %eax
80102d2c:	5a                   	pop    %edx
80102d2d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102d34:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d3d:	e8 8e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d4a:	68 00 02 00 00       	push   $0x200
80102d4f:	50                   	push   %eax
80102d50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d53:	50                   	push   %eax
80102d54:	e8 27 1b 00 00       	call   80104880 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d59:	89 1c 24             	mov    %ebx,(%esp)
80102d5c:	e8 4f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d61:	89 34 24             	mov    %esi,(%esp)
80102d64:	e8 87 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d69:	89 1c 24             	mov    %ebx,(%esp)
80102d6c:	e8 7f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d71:	83 c4 10             	add    $0x10,%esp
80102d74:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102d7a:	7f 94                	jg     80102d10 <install_trans+0x20>
  }
}
80102d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d7f:	5b                   	pop    %ebx
80102d80:	5e                   	pop    %esi
80102d81:	5f                   	pop    %edi
80102d82:	5d                   	pop    %ebp
80102d83:	c3                   	ret
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d88:	c3                   	ret
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d97:	ff 35 d4 16 11 80    	push   0x801116d4
80102d9d:	ff 35 e4 16 11 80    	push   0x801116e4
80102da3:	e8 28 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102da8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102dad:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102db2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102db5:	85 c0                	test   %eax,%eax
80102db7:	7e 19                	jle    80102dd2 <write_head+0x42>
80102db9:	31 d2                	xor    %edx,%edx
80102dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dbf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102dc0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102dc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dcb:	83 c2 01             	add    $0x1,%edx
80102dce:	39 d0                	cmp    %edx,%eax
80102dd0:	75 ee                	jne    80102dc0 <write_head+0x30>
  }
  bwrite(buf);
80102dd2:	83 ec 0c             	sub    $0xc,%esp
80102dd5:	53                   	push   %ebx
80102dd6:	e8 d5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ddb:	89 1c 24             	mov    %ebx,(%esp)
80102dde:	e8 0d d4 ff ff       	call   801001f0 <brelse>
}
80102de3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102de6:	83 c4 10             	add    $0x10,%esp
80102de9:	c9                   	leave
80102dea:	c3                   	ret
80102deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102def:	90                   	nop

80102df0 <initlog>:
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 2c             	sub    $0x2c,%esp
80102df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dfa:	68 c2 74 10 80       	push   $0x801074c2
80102dff:	68 a0 16 11 80       	push   $0x801116a0
80102e04:	e8 f7 16 00 00       	call   80104500 <initlock>
  readsb(dev, &sb);
80102e09:	58                   	pop    %eax
80102e0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e0d:	5a                   	pop    %edx
80102e0e:	50                   	push   %eax
80102e0f:	53                   	push   %ebx
80102e10:	e8 4b e7 ff ff       	call   80101560 <readsb>
  log.start = sb.logstart;
80102e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e18:	59                   	pop    %ecx
  log.dev = dev;
80102e19:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102e1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e22:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102e27:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102e2d:	5a                   	pop    %edx
80102e2e:	50                   	push   %eax
80102e2f:	53                   	push   %ebx
80102e30:	e8 9b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e38:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e3b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102e41:	85 db                	test   %ebx,%ebx
80102e43:	7e 1d                	jle    80102e62 <initlog+0x72>
80102e45:	31 d2                	xor    %edx,%edx
80102e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102e50:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e54:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e5b:	83 c2 01             	add    $0x1,%edx
80102e5e:	39 d3                	cmp    %edx,%ebx
80102e60:	75 ee                	jne    80102e50 <initlog+0x60>
  brelse(buf);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	50                   	push   %eax
80102e66:	e8 85 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e6b:	e8 80 fe ff ff       	call   80102cf0 <install_trans>
  log.lh.n = 0;
80102e70:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102e77:	00 00 00 
  write_head(); // clear the log
80102e7a:	e8 11 ff ff ff       	call   80102d90 <write_head>
}
80102e7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e82:	83 c4 10             	add    $0x10,%esp
80102e85:	c9                   	leave
80102e86:	c3                   	ret
80102e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e8e:	66 90                	xchg   %ax,%ax

80102e90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e96:	68 a0 16 11 80       	push   $0x801116a0
80102e9b:	e8 50 18 00 00       	call   801046f0 <acquire>
80102ea0:	83 c4 10             	add    $0x10,%esp
80102ea3:	eb 18                	jmp    80102ebd <begin_op+0x2d>
80102ea5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ea8:	83 ec 08             	sub    $0x8,%esp
80102eab:	68 a0 16 11 80       	push   $0x801116a0
80102eb0:	68 a0 16 11 80       	push   $0x801116a0
80102eb5:	e8 b6 12 00 00       	call   80104170 <sleep>
80102eba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ebd:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102ec2:	85 c0                	test   %eax,%eax
80102ec4:	75 e2                	jne    80102ea8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ec6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102ecb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102ed1:	83 c0 01             	add    $0x1,%eax
80102ed4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ed7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eda:	83 fa 1e             	cmp    $0x1e,%edx
80102edd:	7f c9                	jg     80102ea8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102edf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ee2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102ee7:	68 a0 16 11 80       	push   $0x801116a0
80102eec:	e8 9f 17 00 00       	call   80104690 <release>
      break;
    }
  }
}
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	c9                   	leave
80102ef5:	c3                   	ret
80102ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102efd:	8d 76 00             	lea    0x0(%esi),%esi

80102f00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	57                   	push   %edi
80102f04:	56                   	push   %esi
80102f05:	53                   	push   %ebx
80102f06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f09:	68 a0 16 11 80       	push   $0x801116a0
80102f0e:	e8 dd 17 00 00       	call   801046f0 <acquire>
  log.outstanding -= 1;
80102f13:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102f18:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102f1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f24:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102f2a:	85 f6                	test   %esi,%esi
80102f2c:	0f 85 22 01 00 00    	jne    80103054 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f32:	85 db                	test   %ebx,%ebx
80102f34:	0f 85 f6 00 00 00    	jne    80103030 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f3a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102f41:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 a0 16 11 80       	push   $0x801116a0
80102f4c:	e8 3f 17 00 00       	call   80104690 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f51:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102f57:	83 c4 10             	add    $0x10,%esp
80102f5a:	85 c9                	test   %ecx,%ecx
80102f5c:	7f 42                	jg     80102fa0 <end_op+0xa0>
    acquire(&log.lock);
80102f5e:	83 ec 0c             	sub    $0xc,%esp
80102f61:	68 a0 16 11 80       	push   $0x801116a0
80102f66:	e8 85 17 00 00       	call   801046f0 <acquire>
    log.committing = 0;
80102f6b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102f72:	00 00 00 
    wakeup(&log);
80102f75:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f7c:	e8 af 12 00 00       	call   80104230 <wakeup>
    release(&log.lock);
80102f81:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f88:	e8 03 17 00 00       	call   80104690 <release>
80102f8d:	83 c4 10             	add    $0x10,%esp
}
80102f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f93:	5b                   	pop    %ebx
80102f94:	5e                   	pop    %esi
80102f95:	5f                   	pop    %edi
80102f96:	5d                   	pop    %ebp
80102f97:	c3                   	ret
80102f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fa0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102fa5:	83 ec 08             	sub    $0x8,%esp
80102fa8:	01 d8                	add    %ebx,%eax
80102faa:	83 c0 01             	add    $0x1,%eax
80102fad:	50                   	push   %eax
80102fae:	ff 35 e4 16 11 80    	push   0x801116e4
80102fb4:	e8 17 d1 ff ff       	call   801000d0 <bread>
80102fb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fbb:	58                   	pop    %eax
80102fbc:	5a                   	pop    %edx
80102fbd:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102fc4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102fca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fcd:	e8 fe d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102fd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fd5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fd7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fda:	68 00 02 00 00       	push   $0x200
80102fdf:	50                   	push   %eax
80102fe0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fe3:	50                   	push   %eax
80102fe4:	e8 97 18 00 00       	call   80104880 <memmove>
    bwrite(to);  // write the log
80102fe9:	89 34 24             	mov    %esi,(%esp)
80102fec:	e8 bf d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ff1:	89 3c 24             	mov    %edi,(%esp)
80102ff4:	e8 f7 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ff9:	89 34 24             	mov    %esi,(%esp)
80102ffc:	e8 ef d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103001:	83 c4 10             	add    $0x10,%esp
80103004:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
8010300a:	7c 94                	jl     80102fa0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010300c:	e8 7f fd ff ff       	call   80102d90 <write_head>
    install_trans(); // Now install writes to home locations
80103011:	e8 da fc ff ff       	call   80102cf0 <install_trans>
    log.lh.n = 0;
80103016:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010301d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103020:	e8 6b fd ff ff       	call   80102d90 <write_head>
80103025:	e9 34 ff ff ff       	jmp    80102f5e <end_op+0x5e>
8010302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103030:	83 ec 0c             	sub    $0xc,%esp
80103033:	68 a0 16 11 80       	push   $0x801116a0
80103038:	e8 f3 11 00 00       	call   80104230 <wakeup>
  release(&log.lock);
8010303d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103044:	e8 47 16 00 00       	call   80104690 <release>
80103049:	83 c4 10             	add    $0x10,%esp
}
8010304c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304f:	5b                   	pop    %ebx
80103050:	5e                   	pop    %esi
80103051:	5f                   	pop    %edi
80103052:	5d                   	pop    %ebp
80103053:	c3                   	ret
    panic("log.committing");
80103054:	83 ec 0c             	sub    $0xc,%esp
80103057:	68 c6 74 10 80       	push   $0x801074c6
8010305c:	e8 1f d3 ff ff       	call   80100380 <panic>
80103061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010306f:	90                   	nop

80103070 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103077:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
8010307d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103080:	83 fa 1d             	cmp    $0x1d,%edx
80103083:	7f 7d                	jg     80103102 <log_write+0x92>
80103085:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010308a:	83 e8 01             	sub    $0x1,%eax
8010308d:	39 c2                	cmp    %eax,%edx
8010308f:	7d 71                	jge    80103102 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103091:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80103096:	85 c0                	test   %eax,%eax
80103098:	7e 75                	jle    8010310f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010309a:	83 ec 0c             	sub    $0xc,%esp
8010309d:	68 a0 16 11 80       	push   $0x801116a0
801030a2:	e8 49 16 00 00       	call   801046f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030a7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030aa:	83 c4 10             	add    $0x10,%esp
801030ad:	31 c0                	xor    %eax,%eax
801030af:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801030b5:	85 d2                	test   %edx,%edx
801030b7:	7f 0e                	jg     801030c7 <log_write+0x57>
801030b9:	eb 15                	jmp    801030d0 <log_write+0x60>
801030bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030bf:	90                   	nop
801030c0:	83 c0 01             	add    $0x1,%eax
801030c3:	39 c2                	cmp    %eax,%edx
801030c5:	74 29                	je     801030f0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030c7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
801030ce:	75 f0                	jne    801030c0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
801030d7:	39 c2                	cmp    %eax,%edx
801030d9:	74 1c                	je     801030f7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030db:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030e1:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
801030e8:	c9                   	leave
  release(&log.lock);
801030e9:	e9 a2 15 00 00       	jmp    80104690 <release>
801030ee:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
801030f0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
801030f7:	83 c2 01             	add    $0x1,%edx
801030fa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103100:	eb d9                	jmp    801030db <log_write+0x6b>
    panic("too big a transaction");
80103102:	83 ec 0c             	sub    $0xc,%esp
80103105:	68 d5 74 10 80       	push   $0x801074d5
8010310a:	e8 71 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010310f:	83 ec 0c             	sub    $0xc,%esp
80103112:	68 eb 74 10 80       	push   $0x801074eb
80103117:	e8 64 d2 ff ff       	call   80100380 <panic>
8010311c:	66 90                	xchg   %ax,%ax
8010311e:	66 90                	xchg   %ax,%ax

80103120 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103127:	e8 64 09 00 00       	call   80103a90 <cpuid>
8010312c:	89 c3                	mov    %eax,%ebx
8010312e:	e8 5d 09 00 00       	call   80103a90 <cpuid>
80103133:	83 ec 04             	sub    $0x4,%esp
80103136:	53                   	push   %ebx
80103137:	50                   	push   %eax
80103138:	68 06 75 10 80       	push   $0x80107506
8010313d:	e8 6e d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103142:	e8 e9 28 00 00       	call   80105a30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103147:	e8 e4 08 00 00       	call   80103a30 <mycpu>
8010314c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010314e:	b8 01 00 00 00       	mov    $0x1,%eax
80103153:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010315a:	e8 01 0c 00 00       	call   80103d60 <scheduler>
8010315f:	90                   	nop

80103160 <mpenter>:
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103166:	e8 c5 39 00 00       	call   80106b30 <switchkvm>
  seginit();
8010316b:	e8 30 39 00 00       	call   80106aa0 <seginit>
  lapicinit();
80103170:	e8 bb f7 ff ff       	call   80102930 <lapicinit>
  mpmain();
80103175:	e8 a6 ff ff ff       	call   80103120 <mpmain>
8010317a:	66 90                	xchg   %ax,%ax
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <main>:
{
80103180:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103184:	83 e4 f0             	and    $0xfffffff0,%esp
80103187:	ff 71 fc             	push   -0x4(%ecx)
8010318a:	55                   	push   %ebp
8010318b:	89 e5                	mov    %esp,%ebp
8010318d:	53                   	push   %ebx
8010318e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010318f:	83 ec 08             	sub    $0x8,%esp
80103192:	68 00 00 40 80       	push   $0x80400000
80103197:	68 d0 54 11 80       	push   $0x801154d0
8010319c:	e8 6f f4 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
801031a1:	e8 4a 3e 00 00       	call   80106ff0 <kvmalloc>
  mpinit();        // detect other processors
801031a6:	e8 85 01 00 00       	call   80103330 <mpinit>
  lapicinit();     // interrupt controller
801031ab:	e8 80 f7 ff ff       	call   80102930 <lapicinit>
  seginit();       // segment descriptors
801031b0:	e8 eb 38 00 00       	call   80106aa0 <seginit>
  picinit();       // disable pic
801031b5:	e8 86 03 00 00       	call   80103540 <picinit>
  ioapicinit();    // another interrupt controller
801031ba:	e8 21 f2 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801031bf:	e8 bc d8 ff ff       	call   80100a80 <consoleinit>
  uartinit();      // serial port
801031c4:	e8 47 2b 00 00       	call   80105d10 <uartinit>
  pinit();         // process table
801031c9:	e8 42 08 00 00       	call   80103a10 <pinit>
  tvinit();        // trap vectors
801031ce:	e8 dd 27 00 00       	call   801059b0 <tvinit>
  binit();         // buffer cache
801031d3:	e8 68 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031d8:	e8 73 dc ff ff       	call   80100e50 <fileinit>
  ideinit();       // disk 
801031dd:	e8 de ef ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031e2:	83 c4 0c             	add    $0xc,%esp
801031e5:	68 8a 00 00 00       	push   $0x8a
801031ea:	68 8c a4 10 80       	push   $0x8010a48c
801031ef:	68 00 70 00 80       	push   $0x80007000
801031f4:	e8 87 16 00 00       	call   80104880 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103203:	00 00 00 
80103206:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010320b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103210:	76 7e                	jbe    80103290 <main+0x110>
80103212:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103217:	eb 20                	jmp    80103239 <main+0xb9>
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103220:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103227:	00 00 00 
8010322a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103230:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103235:	39 c3                	cmp    %eax,%ebx
80103237:	73 57                	jae    80103290 <main+0x110>
    if(c == mycpu())  // We've started already.
80103239:	e8 f2 07 00 00       	call   80103a30 <mycpu>
8010323e:	39 c3                	cmp    %eax,%ebx
80103240:	74 de                	je     80103220 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103242:	e8 39 f4 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103247:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010324a:	c7 05 f8 6f 00 80 60 	movl   $0x80103160,0x80006ff8
80103251:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103254:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010325b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010325e:	05 00 10 00 00       	add    $0x1000,%eax
80103263:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103268:	0f b6 03             	movzbl (%ebx),%eax
8010326b:	68 00 70 00 00       	push   $0x7000
80103270:	50                   	push   %eax
80103271:	e8 fa f7 ff ff       	call   80102a70 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103276:	83 c4 10             	add    $0x10,%esp
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103280:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103286:	85 c0                	test   %eax,%eax
80103288:	74 f6                	je     80103280 <main+0x100>
8010328a:	eb 94                	jmp    80103220 <main+0xa0>
8010328c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103290:	83 ec 08             	sub    $0x8,%esp
80103293:	68 00 00 00 8e       	push   $0x8e000000
80103298:	68 00 00 40 80       	push   $0x80400000
8010329d:	e8 0e f3 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
801032a2:	e8 39 08 00 00       	call   80103ae0 <userinit>
  mpmain();        // finish this processor's setup
801032a7:	e8 74 fe ff ff       	call   80103120 <mpmain>
801032ac:	66 90                	xchg   %ax,%ax
801032ae:	66 90                	xchg   %ax,%ax

801032b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032bb:	53                   	push   %ebx
  e = addr+len;
801032bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032c2:	39 de                	cmp    %ebx,%esi
801032c4:	72 10                	jb     801032d6 <mpsearch1+0x26>
801032c6:	eb 50                	jmp    80103318 <mpsearch1+0x68>
801032c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032cf:	90                   	nop
801032d0:	89 fe                	mov    %edi,%esi
801032d2:	39 df                	cmp    %ebx,%edi
801032d4:	73 42                	jae    80103318 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032d6:	83 ec 04             	sub    $0x4,%esp
801032d9:	8d 7e 10             	lea    0x10(%esi),%edi
801032dc:	6a 04                	push   $0x4
801032de:	68 1a 75 10 80       	push   $0x8010751a
801032e3:	56                   	push   %esi
801032e4:	e8 47 15 00 00       	call   80104830 <memcmp>
801032e9:	83 c4 10             	add    $0x10,%esp
801032ec:	85 c0                	test   %eax,%eax
801032ee:	75 e0                	jne    801032d0 <mpsearch1+0x20>
801032f0:	89 f2                	mov    %esi,%edx
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032f8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801032fb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801032fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103300:	39 fa                	cmp    %edi,%edx
80103302:	75 f4                	jne    801032f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103304:	84 c0                	test   %al,%al
80103306:	75 c8                	jne    801032d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103308:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010330b:	89 f0                	mov    %esi,%eax
8010330d:	5b                   	pop    %ebx
8010330e:	5e                   	pop    %esi
8010330f:	5f                   	pop    %edi
80103310:	5d                   	pop    %ebp
80103311:	c3                   	ret
80103312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010331b:	31 f6                	xor    %esi,%esi
}
8010331d:	5b                   	pop    %ebx
8010331e:	89 f0                	mov    %esi,%eax
80103320:	5e                   	pop    %esi
80103321:	5f                   	pop    %edi
80103322:	5d                   	pop    %ebp
80103323:	c3                   	ret
80103324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010332f:	90                   	nop

80103330 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	57                   	push   %edi
80103334:	56                   	push   %esi
80103335:	53                   	push   %ebx
80103336:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103339:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103340:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103347:	c1 e0 08             	shl    $0x8,%eax
8010334a:	09 d0                	or     %edx,%eax
8010334c:	c1 e0 04             	shl    $0x4,%eax
8010334f:	75 1b                	jne    8010336c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103351:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103358:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010335f:	c1 e0 08             	shl    $0x8,%eax
80103362:	09 d0                	or     %edx,%eax
80103364:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103367:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010336c:	ba 00 04 00 00       	mov    $0x400,%edx
80103371:	e8 3a ff ff ff       	call   801032b0 <mpsearch1>
80103376:	89 c3                	mov    %eax,%ebx
80103378:	85 c0                	test   %eax,%eax
8010337a:	0f 84 58 01 00 00    	je     801034d8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103380:	8b 73 04             	mov    0x4(%ebx),%esi
80103383:	85 f6                	test   %esi,%esi
80103385:	0f 84 3d 01 00 00    	je     801034c8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010338b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010338e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103397:	6a 04                	push   $0x4
80103399:	68 1f 75 10 80       	push   $0x8010751f
8010339e:	50                   	push   %eax
8010339f:	e8 8c 14 00 00       	call   80104830 <memcmp>
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 c0                	test   %eax,%eax
801033a9:	0f 85 19 01 00 00    	jne    801034c8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801033af:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033b6:	3c 01                	cmp    $0x1,%al
801033b8:	74 08                	je     801033c2 <mpinit+0x92>
801033ba:	3c 04                	cmp    $0x4,%al
801033bc:	0f 85 06 01 00 00    	jne    801034c8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801033c2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033c9:	66 85 d2             	test   %dx,%dx
801033cc:	74 22                	je     801033f0 <mpinit+0xc0>
801033ce:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033d1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033d3:	31 d2                	xor    %edx,%edx
801033d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033df:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033e4:	39 f8                	cmp    %edi,%eax
801033e6:	75 f0                	jne    801033d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033e8:	84 d2                	test   %dl,%dl
801033ea:	0f 85 d8 00 00 00    	jne    801034c8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033f0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801033f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801033fc:	a3 84 16 11 80       	mov    %eax,0x80111684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103401:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103408:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010340e:	01 d7                	add    %edx,%edi
80103410:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103412:	bf 01 00 00 00       	mov    $0x1,%edi
80103417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010341e:	66 90                	xchg   %ax,%ax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103420:	39 d0                	cmp    %edx,%eax
80103422:	73 19                	jae    8010343d <mpinit+0x10d>
    switch(*p){
80103424:	0f b6 08             	movzbl (%eax),%ecx
80103427:	80 f9 02             	cmp    $0x2,%cl
8010342a:	0f 84 80 00 00 00    	je     801034b0 <mpinit+0x180>
80103430:	77 6e                	ja     801034a0 <mpinit+0x170>
80103432:	84 c9                	test   %cl,%cl
80103434:	74 3a                	je     80103470 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103436:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103439:	39 d0                	cmp    %edx,%eax
8010343b:	72 e7                	jb     80103424 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010343d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103440:	85 ff                	test   %edi,%edi
80103442:	0f 84 dd 00 00 00    	je     80103525 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103448:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010344c:	74 15                	je     80103463 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010344e:	b8 70 00 00 00       	mov    $0x70,%eax
80103453:	ba 22 00 00 00       	mov    $0x22,%edx
80103458:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103459:	ba 23 00 00 00       	mov    $0x23,%edx
8010345e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010345f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103462:	ee                   	out    %al,(%dx)
  }
}
80103463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103466:	5b                   	pop    %ebx
80103467:	5e                   	pop    %esi
80103468:	5f                   	pop    %edi
80103469:	5d                   	pop    %ebp
8010346a:	c3                   	ret
8010346b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010346f:	90                   	nop
      if(ncpu < NCPU) {
80103470:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
      p += sizeof(struct mpproc);
80103494:	83 c0 14             	add    $0x14,%eax
      continue;
80103497:	eb 87                	jmp    80103420 <mpinit+0xf0>
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801034a0:	83 e9 03             	sub    $0x3,%ecx
801034a3:	80 f9 01             	cmp    $0x1,%cl
801034a6:	76 8e                	jbe    80103436 <mpinit+0x106>
801034a8:	31 ff                	xor    %edi,%edi
801034aa:	e9 71 ff ff ff       	jmp    80103420 <mpinit+0xf0>
801034af:	90                   	nop
      ioapicid = ioapic->apicno;
801034b0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801034b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034b7:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
801034bd:	e9 5e ff ff ff       	jmp    80103420 <mpinit+0xf0>
801034c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801034c8:	83 ec 0c             	sub    $0xc,%esp
801034cb:	68 24 75 10 80       	push   $0x80107524
801034d0:	e8 ab ce ff ff       	call   80100380 <panic>
801034d5:	8d 76 00             	lea    0x0(%esi),%esi
{
801034d8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034dd:	eb 0b                	jmp    801034ea <mpinit+0x1ba>
801034df:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801034e0:	89 f3                	mov    %esi,%ebx
801034e2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034e8:	74 de                	je     801034c8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ea:	83 ec 04             	sub    $0x4,%esp
801034ed:	8d 73 10             	lea    0x10(%ebx),%esi
801034f0:	6a 04                	push   $0x4
801034f2:	68 1a 75 10 80       	push   $0x8010751a
801034f7:	53                   	push   %ebx
801034f8:	e8 33 13 00 00       	call   80104830 <memcmp>
801034fd:	83 c4 10             	add    $0x10,%esp
80103500:	85 c0                	test   %eax,%eax
80103502:	75 dc                	jne    801034e0 <mpinit+0x1b0>
80103504:	89 da                	mov    %ebx,%edx
80103506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103510:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103513:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103516:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103518:	39 d6                	cmp    %edx,%esi
8010351a:	75 f4                	jne    80103510 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010351c:	84 c0                	test   %al,%al
8010351e:	75 c0                	jne    801034e0 <mpinit+0x1b0>
80103520:	e9 5b fe ff ff       	jmp    80103380 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103525:	83 ec 0c             	sub    $0xc,%esp
80103528:	68 88 78 10 80       	push   $0x80107888
8010352d:	e8 4e ce ff ff       	call   80100380 <panic>
80103532:	66 90                	xchg   %ax,%ax
80103534:	66 90                	xchg   %ax,%ax
80103536:	66 90                	xchg   %ax,%ax
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <picinit>:
80103540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103545:	ba 21 00 00 00       	mov    $0x21,%edx
8010354a:	ee                   	out    %al,(%dx)
8010354b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103550:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103551:	c3                   	ret
80103552:	66 90                	xchg   %ax,%ax
80103554:	66 90                	xchg   %ax,%ax
80103556:	66 90                	xchg   %ax,%ax
80103558:	66 90                	xchg   %ax,%ax
8010355a:	66 90                	xchg   %ax,%ax
8010355c:	66 90                	xchg   %ax,%ax
8010355e:	66 90                	xchg   %ax,%ax

80103560 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
80103566:	83 ec 0c             	sub    $0xc,%esp
80103569:	8b 75 08             	mov    0x8(%ebp),%esi
8010356c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010356f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103575:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010357b:	e8 f0 d8 ff ff       	call   80100e70 <filealloc>
80103580:	89 06                	mov    %eax,(%esi)
80103582:	85 c0                	test   %eax,%eax
80103584:	0f 84 a5 00 00 00    	je     8010362f <pipealloc+0xcf>
8010358a:	e8 e1 d8 ff ff       	call   80100e70 <filealloc>
8010358f:	89 07                	mov    %eax,(%edi)
80103591:	85 c0                	test   %eax,%eax
80103593:	0f 84 84 00 00 00    	je     8010361d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103599:	e8 e2 f0 ff ff       	call   80102680 <kalloc>
8010359e:	89 c3                	mov    %eax,%ebx
801035a0:	85 c0                	test   %eax,%eax
801035a2:	0f 84 a0 00 00 00    	je     80103648 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801035a8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035af:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035b2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035bc:	00 00 00 
  p->nwrite = 0;
801035bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035c6:	00 00 00 
  p->nread = 0;
801035c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035d0:	00 00 00 
  initlock(&p->lock, "pipe");
801035d3:	68 3c 75 10 80       	push   $0x8010753c
801035d8:	50                   	push   %eax
801035d9:	e8 22 0f 00 00       	call   80104500 <initlock>
  (*f0)->type = FD_PIPE;
801035de:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035e0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035e9:	8b 06                	mov    (%esi),%eax
801035eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035ef:	8b 06                	mov    (%esi),%eax
801035f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035f5:	8b 06                	mov    (%esi),%eax
801035f7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035fa:	8b 07                	mov    (%edi),%eax
801035fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103602:	8b 07                	mov    (%edi),%eax
80103604:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103608:	8b 07                	mov    (%edi),%eax
8010360a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010360e:	8b 07                	mov    (%edi),%eax
80103610:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103613:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103615:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103618:	5b                   	pop    %ebx
80103619:	5e                   	pop    %esi
8010361a:	5f                   	pop    %edi
8010361b:	5d                   	pop    %ebp
8010361c:	c3                   	ret
  if(*f0)
8010361d:	8b 06                	mov    (%esi),%eax
8010361f:	85 c0                	test   %eax,%eax
80103621:	74 1e                	je     80103641 <pipealloc+0xe1>
    fileclose(*f0);
80103623:	83 ec 0c             	sub    $0xc,%esp
80103626:	50                   	push   %eax
80103627:	e8 04 d9 ff ff       	call   80100f30 <fileclose>
8010362c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010362f:	8b 07                	mov    (%edi),%eax
80103631:	85 c0                	test   %eax,%eax
80103633:	74 0c                	je     80103641 <pipealloc+0xe1>
    fileclose(*f1);
80103635:	83 ec 0c             	sub    $0xc,%esp
80103638:	50                   	push   %eax
80103639:	e8 f2 d8 ff ff       	call   80100f30 <fileclose>
8010363e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103646:	eb cd                	jmp    80103615 <pipealloc+0xb5>
  if(*f0)
80103648:	8b 06                	mov    (%esi),%eax
8010364a:	85 c0                	test   %eax,%eax
8010364c:	75 d5                	jne    80103623 <pipealloc+0xc3>
8010364e:	eb df                	jmp    8010362f <pipealloc+0xcf>

80103650 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	56                   	push   %esi
80103654:	53                   	push   %ebx
80103655:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103658:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	53                   	push   %ebx
8010365f:	e8 8c 10 00 00       	call   801046f0 <acquire>
  if(writable){
80103664:	83 c4 10             	add    $0x10,%esp
80103667:	85 f6                	test   %esi,%esi
80103669:	74 65                	je     801036d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010366b:	83 ec 0c             	sub    $0xc,%esp
8010366e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103674:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010367b:	00 00 00 
    wakeup(&p->nread);
8010367e:	50                   	push   %eax
8010367f:	e8 ac 0b 00 00       	call   80104230 <wakeup>
80103684:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103687:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010368d:	85 d2                	test   %edx,%edx
8010368f:	75 0a                	jne    8010369b <pipeclose+0x4b>
80103691:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103697:	85 c0                	test   %eax,%eax
80103699:	74 15                	je     801036b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010369b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010369e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036a1:	5b                   	pop    %ebx
801036a2:	5e                   	pop    %esi
801036a3:	5d                   	pop    %ebp
    release(&p->lock);
801036a4:	e9 e7 0f 00 00       	jmp    80104690 <release>
801036a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	53                   	push   %ebx
801036b4:	e8 d7 0f 00 00       	call   80104690 <release>
    kfree((char*)p);
801036b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036bc:	83 c4 10             	add    $0x10,%esp
}
801036bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036c2:	5b                   	pop    %ebx
801036c3:	5e                   	pop    %esi
801036c4:	5d                   	pop    %ebp
    kfree((char*)p);
801036c5:	e9 f6 ed ff ff       	jmp    801024c0 <kfree>
801036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036e0:	00 00 00 
    wakeup(&p->nwrite);
801036e3:	50                   	push   %eax
801036e4:	e8 47 0b 00 00       	call   80104230 <wakeup>
801036e9:	83 c4 10             	add    $0x10,%esp
801036ec:	eb 99                	jmp    80103687 <pipeclose+0x37>
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 28             	sub    $0x28,%esp
801036f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036fc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ff:	53                   	push   %ebx
80103700:	e8 eb 0f 00 00       	call   801046f0 <acquire>
  for(i = 0; i < n; i++){
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 ff                	test   %edi,%edi
8010370a:	0f 8e ce 00 00 00    	jle    801037de <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103710:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103716:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103719:	89 7d 10             	mov    %edi,0x10(%ebp)
8010371c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010371f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103722:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103725:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010372b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103731:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103737:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010373d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103740:	0f 85 b6 00 00 00    	jne    801037fc <pipewrite+0x10c>
80103746:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103749:	eb 3b                	jmp    80103786 <pipewrite+0x96>
8010374b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010374f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103750:	e8 5b 03 00 00       	call   80103ab0 <myproc>
80103755:	8b 48 24             	mov    0x24(%eax),%ecx
80103758:	85 c9                	test   %ecx,%ecx
8010375a:	75 34                	jne    80103790 <pipewrite+0xa0>
      wakeup(&p->nread);
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	56                   	push   %esi
80103760:	e8 cb 0a 00 00       	call   80104230 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103765:	58                   	pop    %eax
80103766:	5a                   	pop    %edx
80103767:	53                   	push   %ebx
80103768:	57                   	push   %edi
80103769:	e8 02 0a 00 00       	call   80104170 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010376e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103774:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010377a:	83 c4 10             	add    $0x10,%esp
8010377d:	05 00 02 00 00       	add    $0x200,%eax
80103782:	39 c2                	cmp    %eax,%edx
80103784:	75 2a                	jne    801037b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103786:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010378c:	85 c0                	test   %eax,%eax
8010378e:	75 c0                	jne    80103750 <pipewrite+0x60>
        release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	53                   	push   %ebx
80103794:	e8 f7 0e 00 00       	call   80104690 <release>
        return -1;
80103799:	83 c4 10             	add    $0x10,%esp
8010379c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	5b                   	pop    %ebx
801037a5:	5e                   	pop    %esi
801037a6:	5f                   	pop    %edi
801037a7:	5d                   	pop    %ebp
801037a8:	c3                   	ret
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037b3:	8d 42 01             	lea    0x1(%edx),%eax
801037b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801037bc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037bf:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037c8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801037cc:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801037d3:	39 c1                	cmp    %eax,%ecx
801037d5:	0f 85 50 ff ff ff    	jne    8010372b <pipewrite+0x3b>
801037db:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037de:	83 ec 0c             	sub    $0xc,%esp
801037e1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037e7:	50                   	push   %eax
801037e8:	e8 43 0a 00 00       	call   80104230 <wakeup>
  release(&p->lock);
801037ed:	89 1c 24             	mov    %ebx,(%esp)
801037f0:	e8 9b 0e 00 00       	call   80104690 <release>
  return n;
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	89 f8                	mov    %edi,%eax
801037fa:	eb a5                	jmp    801037a1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801037ff:	eb b2                	jmp    801037b3 <pipewrite+0xc3>
80103801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop

80103810 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	57                   	push   %edi
80103814:	56                   	push   %esi
80103815:	53                   	push   %ebx
80103816:	83 ec 18             	sub    $0x18,%esp
80103819:	8b 75 08             	mov    0x8(%ebp),%esi
8010381c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010381f:	56                   	push   %esi
80103820:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103826:	e8 c5 0e 00 00       	call   801046f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010382b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103831:	83 c4 10             	add    $0x10,%esp
80103834:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010383a:	74 2f                	je     8010386b <piperead+0x5b>
8010383c:	eb 37                	jmp    80103875 <piperead+0x65>
8010383e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103840:	e8 6b 02 00 00       	call   80103ab0 <myproc>
80103845:	8b 40 24             	mov    0x24(%eax),%eax
80103848:	85 c0                	test   %eax,%eax
8010384a:	0f 85 80 00 00 00    	jne    801038d0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103850:	83 ec 08             	sub    $0x8,%esp
80103853:	56                   	push   %esi
80103854:	53                   	push   %ebx
80103855:	e8 16 09 00 00       	call   80104170 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010385a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103860:	83 c4 10             	add    $0x10,%esp
80103863:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103869:	75 0a                	jne    80103875 <piperead+0x65>
8010386b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103871:	85 d2                	test   %edx,%edx
80103873:	75 cb                	jne    80103840 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103875:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103878:	31 db                	xor    %ebx,%ebx
8010387a:	85 c9                	test   %ecx,%ecx
8010387c:	7f 26                	jg     801038a4 <piperead+0x94>
8010387e:	eb 2c                	jmp    801038ac <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103880:	8d 48 01             	lea    0x1(%eax),%ecx
80103883:	25 ff 01 00 00       	and    $0x1ff,%eax
80103888:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010388e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103893:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103896:	83 c3 01             	add    $0x1,%ebx
80103899:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010389c:	74 0e                	je     801038ac <piperead+0x9c>
8010389e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801038a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038aa:	75 d4                	jne    80103880 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038ac:	83 ec 0c             	sub    $0xc,%esp
801038af:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038b5:	50                   	push   %eax
801038b6:	e8 75 09 00 00       	call   80104230 <wakeup>
  release(&p->lock);
801038bb:	89 34 24             	mov    %esi,(%esp)
801038be:	e8 cd 0d 00 00       	call   80104690 <release>
  return i;
801038c3:	83 c4 10             	add    $0x10,%esp
}
801038c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038c9:	89 d8                	mov    %ebx,%eax
801038cb:	5b                   	pop    %ebx
801038cc:	5e                   	pop    %esi
801038cd:	5f                   	pop    %edi
801038ce:	5d                   	pop    %ebp
801038cf:	c3                   	ret
      release(&p->lock);
801038d0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038d8:	56                   	push   %esi
801038d9:	e8 b2 0d 00 00       	call   80104690 <release>
      return -1;
801038de:	83 c4 10             	add    $0x10,%esp
}
801038e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038e4:	89 d8                	mov    %ebx,%eax
801038e6:	5b                   	pop    %ebx
801038e7:	5e                   	pop    %esi
801038e8:	5f                   	pop    %edi
801038e9:	5d                   	pop    %ebp
801038ea:	c3                   	ret
801038eb:	66 90                	xchg   %ax,%ax
801038ed:	66 90                	xchg   %ax,%ax
801038ef:	90                   	nop

801038f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038f4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801038f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038fc:	68 20 1d 11 80       	push   $0x80111d20
80103901:	e8 ea 0d 00 00       	call   801046f0 <acquire>
80103906:	83 c4 10             	add    $0x10,%esp
80103909:	eb 10                	jmp    8010391b <allocproc+0x2b>
8010390b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010390f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103910:	83 c3 7c             	add    $0x7c,%ebx
80103913:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103919:	74 75                	je     80103990 <allocproc+0xa0>
    if(p->state == UNUSED)
8010391b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010391e:	85 c0                	test   %eax,%eax
80103920:	75 ee                	jne    80103910 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103922:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103927:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010392a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103931:	89 43 10             	mov    %eax,0x10(%ebx)
80103934:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103937:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
8010393c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103942:	e8 49 0d 00 00       	call   80104690 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103947:	e8 34 ed ff ff       	call   80102680 <kalloc>
8010394c:	83 c4 10             	add    $0x10,%esp
8010394f:	89 43 08             	mov    %eax,0x8(%ebx)
80103952:	85 c0                	test   %eax,%eax
80103954:	74 53                	je     801039a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103956:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010395c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010395f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103964:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103967:	c7 40 14 a2 59 10 80 	movl   $0x801059a2,0x14(%eax)
  p->context = (struct context*)sp;
8010396e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103971:	6a 14                	push   $0x14
80103973:	6a 00                	push   $0x0
80103975:	50                   	push   %eax
80103976:	e8 75 0e 00 00       	call   801047f0 <memset>
  p->context->eip = (uint)forkret;
8010397b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010397e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103981:	c7 40 10 c0 39 10 80 	movl   $0x801039c0,0x10(%eax)
}
80103988:	89 d8                	mov    %ebx,%eax
8010398a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398d:	c9                   	leave
8010398e:	c3                   	ret
8010398f:	90                   	nop
  release(&ptable.lock);
80103990:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103993:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103995:	68 20 1d 11 80       	push   $0x80111d20
8010399a:	e8 f1 0c 00 00       	call   80104690 <release>
  return 0;
8010399f:	83 c4 10             	add    $0x10,%esp
}
801039a2:	89 d8                	mov    %ebx,%eax
801039a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a7:	c9                   	leave
801039a8:	c3                   	ret
    p->state = UNUSED;
801039a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801039b0:	31 db                	xor    %ebx,%ebx
801039b2:	eb ee                	jmp    801039a2 <allocproc+0xb2>
801039b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop

801039c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039c6:	68 20 1d 11 80       	push   $0x80111d20
801039cb:	e8 c0 0c 00 00       	call   80104690 <release>

  if (first) {
801039d0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	85 c0                	test   %eax,%eax
801039da:	75 04                	jne    801039e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039dc:	c9                   	leave
801039dd:	c3                   	ret
801039de:	66 90                	xchg   %ax,%ax
    first = 0;
801039e0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039e7:	00 00 00 
    iinit(ROOTDEV);
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	6a 01                	push   $0x1
801039ef:	e8 ac db ff ff       	call   801015a0 <iinit>
    initlog(ROOTDEV);
801039f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039fb:	e8 f0 f3 ff ff       	call   80102df0 <initlog>
}
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	c9                   	leave
80103a04:	c3                   	ret
80103a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a10 <pinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a16:	68 41 75 10 80       	push   $0x80107541
80103a1b:	68 20 1d 11 80       	push   $0x80111d20
80103a20:	e8 db 0a 00 00       	call   80104500 <initlock>
}
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	c9                   	leave
80103a29:	c3                   	ret
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a30 <mycpu>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a35:	9c                   	pushf
80103a36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a37:	f6 c4 02             	test   $0x2,%ah
80103a3a:	75 46                	jne    80103a82 <mycpu+0x52>
  apicid = lapicid();
80103a3c:	e8 df ef ff ff       	call   80102a20 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a41:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103a47:	85 f6                	test   %esi,%esi
80103a49:	7e 2a                	jle    80103a75 <mycpu+0x45>
80103a4b:	31 d2                	xor    %edx,%edx
80103a4d:	eb 08                	jmp    80103a57 <mycpu+0x27>
80103a4f:	90                   	nop
80103a50:	83 c2 01             	add    $0x1,%edx
80103a53:	39 f2                	cmp    %esi,%edx
80103a55:	74 1e                	je     80103a75 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a5d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103a64:	39 c3                	cmp    %eax,%ebx
80103a66:	75 e8                	jne    80103a50 <mycpu+0x20>
}
80103a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a6b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103a71:	5b                   	pop    %ebx
80103a72:	5e                   	pop    %esi
80103a73:	5d                   	pop    %ebp
80103a74:	c3                   	ret
  panic("unknown apicid\n");
80103a75:	83 ec 0c             	sub    $0xc,%esp
80103a78:	68 48 75 10 80       	push   $0x80107548
80103a7d:	e8 fe c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a82:	83 ec 0c             	sub    $0xc,%esp
80103a85:	68 a8 78 10 80       	push   $0x801078a8
80103a8a:	e8 f1 c8 ff ff       	call   80100380 <panic>
80103a8f:	90                   	nop

80103a90 <cpuid>:
cpuid() {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a96:	e8 95 ff ff ff       	call   80103a30 <mycpu>
}
80103a9b:	c9                   	leave
  return mycpu()-cpus;
80103a9c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103aa1:	c1 f8 04             	sar    $0x4,%eax
80103aa4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aaa:	c3                   	ret
80103aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <myproc>:
myproc(void) {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ab7:	e8 e4 0a 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103abc:	e8 6f ff ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103ac1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac7:	e8 24 0b 00 00       	call   801045f0 <popcli>
}
80103acc:	89 d8                	mov    %ebx,%eax
80103ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad1:	c9                   	leave
80103ad2:	c3                   	ret
80103ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ae0 <userinit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ae7:	e8 04 fe ff ff       	call   801038f0 <allocproc>
80103aec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103aee:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103af3:	e8 78 34 00 00       	call   80106f70 <setupkvm>
80103af8:	89 43 04             	mov    %eax,0x4(%ebx)
80103afb:	85 c0                	test   %eax,%eax
80103afd:	0f 84 bd 00 00 00    	je     80103bc0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b03:	83 ec 04             	sub    $0x4,%esp
80103b06:	68 2c 00 00 00       	push   $0x2c
80103b0b:	68 60 a4 10 80       	push   $0x8010a460
80103b10:	50                   	push   %eax
80103b11:	e8 3a 31 00 00       	call   80106c50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b1f:	6a 4c                	push   $0x4c
80103b21:	6a 00                	push   $0x0
80103b23:	ff 73 18             	push   0x18(%ebx)
80103b26:	e8 c5 0c 00 00       	call   801047f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b46:	8b 43 18             	mov    0x18(%ebx),%eax
80103b49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b51:	8b 43 18             	mov    0x18(%ebx),%eax
80103b54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b66:	8b 43 18             	mov    0x18(%ebx),%eax
80103b69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b70:	8b 43 18             	mov    0x18(%ebx),%eax
80103b73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b7d:	6a 10                	push   $0x10
80103b7f:	68 71 75 10 80       	push   $0x80107571
80103b84:	50                   	push   %eax
80103b85:	e8 16 0e 00 00       	call   801049a0 <safestrcpy>
  p->cwd = namei("/");
80103b8a:	c7 04 24 7a 75 10 80 	movl   $0x8010757a,(%esp)
80103b91:	e8 0a e5 ff ff       	call   801020a0 <namei>
80103b96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b99:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ba0:	e8 4b 0b 00 00       	call   801046f0 <acquire>
  p->state = RUNNABLE;
80103ba5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bac:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bb3:	e8 d8 0a 00 00       	call   80104690 <release>
}
80103bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bbb:	83 c4 10             	add    $0x10,%esp
80103bbe:	c9                   	leave
80103bbf:	c3                   	ret
    panic("userinit: out of memory?");
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	68 58 75 10 80       	push   $0x80107558
80103bc8:	e8 b3 c7 ff ff       	call   80100380 <panic>
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi

80103bd0 <growproc>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	56                   	push   %esi
80103bd4:	53                   	push   %ebx
80103bd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bd8:	e8 c3 09 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103bdd:	e8 4e fe ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103be2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103be8:	e8 03 0a 00 00       	call   801045f0 <popcli>
  sz = curproc->sz;
80103bed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bef:	85 f6                	test   %esi,%esi
80103bf1:	7f 1d                	jg     80103c10 <growproc+0x40>
  } else if(n < 0){
80103bf3:	75 3b                	jne    80103c30 <growproc+0x60>
  switchuvm(curproc);
80103bf5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bf8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bfa:	53                   	push   %ebx
80103bfb:	e8 40 2f 00 00       	call   80106b40 <switchuvm>
  return 0;
80103c00:	83 c4 10             	add    $0x10,%esp
80103c03:	31 c0                	xor    %eax,%eax
}
80103c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c08:	5b                   	pop    %ebx
80103c09:	5e                   	pop    %esi
80103c0a:	5d                   	pop    %ebp
80103c0b:	c3                   	ret
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	01 c6                	add    %eax,%esi
80103c15:	56                   	push   %esi
80103c16:	50                   	push   %eax
80103c17:	ff 73 04             	push   0x4(%ebx)
80103c1a:	e8 81 31 00 00       	call   80106da0 <allocuvm>
80103c1f:	83 c4 10             	add    $0x10,%esp
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 cf                	jne    80103bf5 <growproc+0x25>
      return -1;
80103c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c2b:	eb d8                	jmp    80103c05 <growproc+0x35>
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c30:	83 ec 04             	sub    $0x4,%esp
80103c33:	01 c6                	add    %eax,%esi
80103c35:	56                   	push   %esi
80103c36:	50                   	push   %eax
80103c37:	ff 73 04             	push   0x4(%ebx)
80103c3a:	e8 81 32 00 00       	call   80106ec0 <deallocuvm>
80103c3f:	83 c4 10             	add    $0x10,%esp
80103c42:	85 c0                	test   %eax,%eax
80103c44:	75 af                	jne    80103bf5 <growproc+0x25>
80103c46:	eb de                	jmp    80103c26 <growproc+0x56>
80103c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4f:	90                   	nop

80103c50 <fork>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c59:	e8 42 09 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103c5e:	e8 cd fd ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103c63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c69:	e8 82 09 00 00       	call   801045f0 <popcli>
  if((np = allocproc()) == 0){
80103c6e:	e8 7d fc ff ff       	call   801038f0 <allocproc>
80103c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c76:	85 c0                	test   %eax,%eax
80103c78:	0f 84 d6 00 00 00    	je     80103d54 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c7e:	83 ec 08             	sub    $0x8,%esp
80103c81:	ff 33                	push   (%ebx)
80103c83:	89 c7                	mov    %eax,%edi
80103c85:	ff 73 04             	push   0x4(%ebx)
80103c88:	e8 d3 33 00 00       	call   80107060 <copyuvm>
80103c8d:	83 c4 10             	add    $0x10,%esp
80103c90:	89 47 04             	mov    %eax,0x4(%edi)
80103c93:	85 c0                	test   %eax,%eax
80103c95:	0f 84 9a 00 00 00    	je     80103d35 <fork+0xe5>
  np->sz = curproc->sz;
80103c9b:	8b 03                	mov    (%ebx),%eax
80103c9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ca0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ca2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ca5:	89 c8                	mov    %ecx,%eax
80103ca7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103caa:	b9 13 00 00 00       	mov    $0x13,%ecx
80103caf:	8b 73 18             	mov    0x18(%ebx),%esi
80103cb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cb4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cb6:	8b 40 18             	mov    0x18(%eax),%eax
80103cb9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103cc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cc4:	85 c0                	test   %eax,%eax
80103cc6:	74 13                	je     80103cdb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	50                   	push   %eax
80103ccc:	e8 0f d2 ff ff       	call   80100ee0 <filedup>
80103cd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cd4:	83 c4 10             	add    $0x10,%esp
80103cd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cdb:	83 c6 01             	add    $0x1,%esi
80103cde:	83 fe 10             	cmp    $0x10,%esi
80103ce1:	75 dd                	jne    80103cc0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ce3:	83 ec 0c             	sub    $0xc,%esp
80103ce6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ce9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cec:	e8 9f da ff ff       	call   80101790 <idup>
80103cf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cf7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103cfd:	6a 10                	push   $0x10
80103cff:	53                   	push   %ebx
80103d00:	50                   	push   %eax
80103d01:	e8 9a 0c 00 00       	call   801049a0 <safestrcpy>
  pid = np->pid;
80103d06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d09:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103d10:	e8 db 09 00 00       	call   801046f0 <acquire>
  np->state = RUNNABLE;
80103d15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d1c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103d23:	e8 68 09 00 00       	call   80104690 <release>
  return pid;
80103d28:	83 c4 10             	add    $0x10,%esp
}
80103d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d2e:	89 d8                	mov    %ebx,%eax
80103d30:	5b                   	pop    %ebx
80103d31:	5e                   	pop    %esi
80103d32:	5f                   	pop    %edi
80103d33:	5d                   	pop    %ebp
80103d34:	c3                   	ret
    kfree(np->kstack);
80103d35:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d38:	83 ec 0c             	sub    $0xc,%esp
80103d3b:	ff 73 08             	push   0x8(%ebx)
80103d3e:	e8 7d e7 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103d43:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d4a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d4d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d54:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d59:	eb d0                	jmp    80103d2b <fork+0xdb>
80103d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d5f:	90                   	nop

80103d60 <scheduler>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d69:	e8 c2 fc ff ff       	call   80103a30 <mycpu>
  c->proc = 0;
80103d6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d75:	00 00 00 
  struct cpu *c = mycpu();
80103d78:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d7a:	8d 78 04             	lea    0x4(%eax),%edi
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d80:	fb                   	sti
    acquire(&ptable.lock);
80103d81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d84:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103d89:	68 20 1d 11 80       	push   $0x80111d20
80103d8e:	e8 5d 09 00 00       	call   801046f0 <acquire>
80103d93:	83 c4 10             	add    $0x10,%esp
80103d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103da0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103da4:	75 33                	jne    80103dd9 <scheduler+0x79>
      switchuvm(p);
80103da6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103da9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103daf:	53                   	push   %ebx
80103db0:	e8 8b 2d 00 00       	call   80106b40 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103db5:	58                   	pop    %eax
80103db6:	5a                   	pop    %edx
80103db7:	ff 73 1c             	push   0x1c(%ebx)
80103dba:	57                   	push   %edi
      p->state = RUNNING;
80103dbb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103dc2:	e8 34 0c 00 00       	call   801049fb <swtch>
      switchkvm();
80103dc7:	e8 64 2d 00 00       	call   80106b30 <switchkvm>
      c->proc = 0;
80103dcc:	83 c4 10             	add    $0x10,%esp
80103dcf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103dd6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd9:	83 c3 7c             	add    $0x7c,%ebx
80103ddc:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103de2:	75 bc                	jne    80103da0 <scheduler+0x40>
    release(&ptable.lock);
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	68 20 1d 11 80       	push   $0x80111d20
80103dec:	e8 9f 08 00 00       	call   80104690 <release>
    sti();
80103df1:	83 c4 10             	add    $0x10,%esp
80103df4:	eb 8a                	jmp    80103d80 <scheduler+0x20>
80103df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi

80103e00 <sched>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	56                   	push   %esi
80103e04:	53                   	push   %ebx
  pushcli();
80103e05:	e8 96 07 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103e0a:	e8 21 fc ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103e0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e15:	e8 d6 07 00 00       	call   801045f0 <popcli>
  if(!holding(&ptable.lock))
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 20 1d 11 80       	push   $0x80111d20
80103e22:	e8 29 08 00 00       	call   80104650 <holding>
80103e27:	83 c4 10             	add    $0x10,%esp
80103e2a:	85 c0                	test   %eax,%eax
80103e2c:	74 4f                	je     80103e7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e2e:	e8 fd fb ff ff       	call   80103a30 <mycpu>
80103e33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e3a:	75 68                	jne    80103ea4 <sched+0xa4>
  if(p->state == RUNNING)
80103e3c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e40:	74 55                	je     80103e97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e42:	9c                   	pushf
80103e43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e44:	f6 c4 02             	test   $0x2,%ah
80103e47:	75 41                	jne    80103e8a <sched+0x8a>
  intena = mycpu()->intena;
80103e49:	e8 e2 fb ff ff       	call   80103a30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e4e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e57:	e8 d4 fb ff ff       	call   80103a30 <mycpu>
80103e5c:	83 ec 08             	sub    $0x8,%esp
80103e5f:	ff 70 04             	push   0x4(%eax)
80103e62:	53                   	push   %ebx
80103e63:	e8 93 0b 00 00       	call   801049fb <swtch>
  mycpu()->intena = intena;
80103e68:	e8 c3 fb ff ff       	call   80103a30 <mycpu>
}
80103e6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e79:	5b                   	pop    %ebx
80103e7a:	5e                   	pop    %esi
80103e7b:	5d                   	pop    %ebp
80103e7c:	c3                   	ret
    panic("sched ptable.lock");
80103e7d:	83 ec 0c             	sub    $0xc,%esp
80103e80:	68 7c 75 10 80       	push   $0x8010757c
80103e85:	e8 f6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	68 a8 75 10 80       	push   $0x801075a8
80103e92:	e8 e9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e97:	83 ec 0c             	sub    $0xc,%esp
80103e9a:	68 9a 75 10 80       	push   $0x8010759a
80103e9f:	e8 dc c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ea4:	83 ec 0c             	sub    $0xc,%esp
80103ea7:	68 8e 75 10 80       	push   $0x8010758e
80103eac:	e8 cf c4 ff ff       	call   80100380 <panic>
80103eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebf:	90                   	nop

80103ec0 <exit>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ec9:	e8 e2 fb ff ff       	call   80103ab0 <myproc>
  if(curproc == initproc)
80103ece:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103ed4:	0f 84 fd 00 00 00    	je     80103fd7 <exit+0x117>
80103eda:	89 c3                	mov    %eax,%ebx
80103edc:	8d 70 28             	lea    0x28(%eax),%esi
80103edf:	8d 78 68             	lea    0x68(%eax),%edi
80103ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ee8:	8b 06                	mov    (%esi),%eax
80103eea:	85 c0                	test   %eax,%eax
80103eec:	74 12                	je     80103f00 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103eee:	83 ec 0c             	sub    $0xc,%esp
80103ef1:	50                   	push   %eax
80103ef2:	e8 39 d0 ff ff       	call   80100f30 <fileclose>
      curproc->ofile[fd] = 0;
80103ef7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103efd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f00:	83 c6 04             	add    $0x4,%esi
80103f03:	39 f7                	cmp    %esi,%edi
80103f05:	75 e1                	jne    80103ee8 <exit+0x28>
  begin_op();
80103f07:	e8 84 ef ff ff       	call   80102e90 <begin_op>
  iput(curproc->cwd);
80103f0c:	83 ec 0c             	sub    $0xc,%esp
80103f0f:	ff 73 68             	push   0x68(%ebx)
80103f12:	e8 d9 d9 ff ff       	call   801018f0 <iput>
  end_op();
80103f17:	e8 e4 ef ff ff       	call   80102f00 <end_op>
  curproc->cwd = 0;
80103f1c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f23:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103f2a:	e8 c1 07 00 00       	call   801046f0 <acquire>
  wakeup1(curproc->parent);
80103f2f:	8b 53 14             	mov    0x14(%ebx),%edx
80103f32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f35:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f3a:	eb 0e                	jmp    80103f4a <exit+0x8a>
80103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f40:	83 c0 7c             	add    $0x7c,%eax
80103f43:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f48:	74 1c                	je     80103f66 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103f4a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f4e:	75 f0                	jne    80103f40 <exit+0x80>
80103f50:	3b 50 20             	cmp    0x20(%eax),%edx
80103f53:	75 eb                	jne    80103f40 <exit+0x80>
      p->state = RUNNABLE;
80103f55:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f5c:	83 c0 7c             	add    $0x7c,%eax
80103f5f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f64:	75 e4                	jne    80103f4a <exit+0x8a>
      p->parent = initproc;
80103f66:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103f71:	eb 10                	jmp    80103f83 <exit+0xc3>
80103f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f77:	90                   	nop
80103f78:	83 c2 7c             	add    $0x7c,%edx
80103f7b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103f81:	74 3b                	je     80103fbe <exit+0xfe>
    if(p->parent == curproc){
80103f83:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f86:	75 f0                	jne    80103f78 <exit+0xb8>
      if(p->state == ZOMBIE)
80103f88:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f8c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f8f:	75 e7                	jne    80103f78 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f91:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f96:	eb 12                	jmp    80103faa <exit+0xea>
80103f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop
80103fa0:	83 c0 7c             	add    $0x7c,%eax
80103fa3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103fa8:	74 ce                	je     80103f78 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103faa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fae:	75 f0                	jne    80103fa0 <exit+0xe0>
80103fb0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fb3:	75 eb                	jne    80103fa0 <exit+0xe0>
      p->state = RUNNABLE;
80103fb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fbc:	eb e2                	jmp    80103fa0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fbe:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fc5:	e8 36 fe ff ff       	call   80103e00 <sched>
  panic("zombie exit");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 c9 75 10 80       	push   $0x801075c9
80103fd2:	e8 a9 c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 bc 75 10 80       	push   $0x801075bc
80103fdf:	e8 9c c3 ff ff       	call   80100380 <panic>
80103fe4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fef:	90                   	nop

80103ff0 <wait>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
  pushcli();
80103ff5:	e8 a6 05 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103ffa:	e8 31 fa ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103fff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104005:	e8 e6 05 00 00       	call   801045f0 <popcli>
  acquire(&ptable.lock);
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	68 20 1d 11 80       	push   $0x80111d20
80104012:	e8 d9 06 00 00       	call   801046f0 <acquire>
80104017:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010401a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104021:	eb 10                	jmp    80104033 <wait+0x43>
80104023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104027:	90                   	nop
80104028:	83 c3 7c             	add    $0x7c,%ebx
8010402b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80104031:	74 1b                	je     8010404e <wait+0x5e>
      if(p->parent != curproc)
80104033:	39 73 14             	cmp    %esi,0x14(%ebx)
80104036:	75 f0                	jne    80104028 <wait+0x38>
      if(p->state == ZOMBIE){
80104038:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010403c:	74 62                	je     801040a0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104041:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104046:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010404c:	75 e5                	jne    80104033 <wait+0x43>
    if(!havekids || curproc->killed){
8010404e:	85 c0                	test   %eax,%eax
80104050:	0f 84 a0 00 00 00    	je     801040f6 <wait+0x106>
80104056:	8b 46 24             	mov    0x24(%esi),%eax
80104059:	85 c0                	test   %eax,%eax
8010405b:	0f 85 95 00 00 00    	jne    801040f6 <wait+0x106>
  pushcli();
80104061:	e8 3a 05 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80104066:	e8 c5 f9 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010406b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104071:	e8 7a 05 00 00       	call   801045f0 <popcli>
  if(p == 0)
80104076:	85 db                	test   %ebx,%ebx
80104078:	0f 84 8f 00 00 00    	je     8010410d <wait+0x11d>
  p->chan = chan;
8010407e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104081:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104088:	e8 73 fd ff ff       	call   80103e00 <sched>
  p->chan = 0;
8010408d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104094:	eb 84                	jmp    8010401a <wait+0x2a>
80104096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801040a0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040a3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040a6:	ff 73 08             	push   0x8(%ebx)
801040a9:	e8 12 e4 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801040ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040b5:	5a                   	pop    %edx
801040b6:	ff 73 04             	push   0x4(%ebx)
801040b9:	e8 32 2e 00 00       	call   80106ef0 <freevm>
        p->pid = 0;
801040be:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040c5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040cc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040d0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040de:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040e5:	e8 a6 05 00 00       	call   80104690 <release>
        return pid;
801040ea:	83 c4 10             	add    $0x10,%esp
}
801040ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f0:	89 f0                	mov    %esi,%eax
801040f2:	5b                   	pop    %ebx
801040f3:	5e                   	pop    %esi
801040f4:	5d                   	pop    %ebp
801040f5:	c3                   	ret
      release(&ptable.lock);
801040f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040fe:	68 20 1d 11 80       	push   $0x80111d20
80104103:	e8 88 05 00 00       	call   80104690 <release>
      return -1;
80104108:	83 c4 10             	add    $0x10,%esp
8010410b:	eb e0                	jmp    801040ed <wait+0xfd>
    panic("sleep");
8010410d:	83 ec 0c             	sub    $0xc,%esp
80104110:	68 d5 75 10 80       	push   $0x801075d5
80104115:	e8 66 c2 ff ff       	call   80100380 <panic>
8010411a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104120 <yield>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104127:	68 20 1d 11 80       	push   $0x80111d20
8010412c:	e8 bf 05 00 00       	call   801046f0 <acquire>
  pushcli();
80104131:	e8 6a 04 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80104136:	e8 f5 f8 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010413b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104141:	e8 aa 04 00 00       	call   801045f0 <popcli>
  myproc()->state = RUNNABLE;
80104146:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010414d:	e8 ae fc ff ff       	call   80103e00 <sched>
  release(&ptable.lock);
80104152:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104159:	e8 32 05 00 00       	call   80104690 <release>
}
8010415e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104161:	83 c4 10             	add    $0x10,%esp
80104164:	c9                   	leave
80104165:	c3                   	ret
80104166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416d:	8d 76 00             	lea    0x0(%esi),%esi

80104170 <sleep>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	57                   	push   %edi
80104174:	56                   	push   %esi
80104175:	53                   	push   %ebx
80104176:	83 ec 0c             	sub    $0xc,%esp
80104179:	8b 7d 08             	mov    0x8(%ebp),%edi
8010417c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010417f:	e8 1c 04 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80104184:	e8 a7 f8 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104189:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010418f:	e8 5c 04 00 00       	call   801045f0 <popcli>
  if(p == 0)
80104194:	85 db                	test   %ebx,%ebx
80104196:	0f 84 87 00 00 00    	je     80104223 <sleep+0xb3>
  if(lk == 0)
8010419c:	85 f6                	test   %esi,%esi
8010419e:	74 76                	je     80104216 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041a0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801041a6:	74 50                	je     801041f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	68 20 1d 11 80       	push   $0x80111d20
801041b0:	e8 3b 05 00 00       	call   801046f0 <acquire>
    release(lk);
801041b5:	89 34 24             	mov    %esi,(%esp)
801041b8:	e8 d3 04 00 00       	call   80104690 <release>
  p->chan = chan;
801041bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041c7:	e8 34 fc ff ff       	call   80103e00 <sched>
  p->chan = 0;
801041cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041d3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041da:	e8 b1 04 00 00       	call   80104690 <release>
    acquire(lk);
801041df:	89 75 08             	mov    %esi,0x8(%ebp)
801041e2:	83 c4 10             	add    $0x10,%esp
}
801041e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041e8:	5b                   	pop    %ebx
801041e9:	5e                   	pop    %esi
801041ea:	5f                   	pop    %edi
801041eb:	5d                   	pop    %ebp
    acquire(lk);
801041ec:	e9 ff 04 00 00       	jmp    801046f0 <acquire>
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104202:	e8 f9 fb ff ff       	call   80103e00 <sched>
  p->chan = 0;
80104207:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010420e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104211:	5b                   	pop    %ebx
80104212:	5e                   	pop    %esi
80104213:	5f                   	pop    %edi
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret
    panic("sleep without lk");
80104216:	83 ec 0c             	sub    $0xc,%esp
80104219:	68 db 75 10 80       	push   $0x801075db
8010421e:	e8 5d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104223:	83 ec 0c             	sub    $0xc,%esp
80104226:	68 d5 75 10 80       	push   $0x801075d5
8010422b:	e8 50 c1 ff ff       	call   80100380 <panic>

80104230 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 10             	sub    $0x10,%esp
80104237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010423a:	68 20 1d 11 80       	push   $0x80111d20
8010423f:	e8 ac 04 00 00       	call   801046f0 <acquire>
80104244:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104247:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010424c:	eb 0c                	jmp    8010425a <wakeup+0x2a>
8010424e:	66 90                	xchg   %ax,%ax
80104250:	83 c0 7c             	add    $0x7c,%eax
80104253:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104258:	74 1c                	je     80104276 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010425a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010425e:	75 f0                	jne    80104250 <wakeup+0x20>
80104260:	3b 58 20             	cmp    0x20(%eax),%ebx
80104263:	75 eb                	jne    80104250 <wakeup+0x20>
      p->state = RUNNABLE;
80104265:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010426c:	83 c0 7c             	add    $0x7c,%eax
8010426f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104274:	75 e4                	jne    8010425a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104276:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010427d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104280:	c9                   	leave
  release(&ptable.lock);
80104281:	e9 0a 04 00 00       	jmp    80104690 <release>
80104286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428d:	8d 76 00             	lea    0x0(%esi),%esi

80104290 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 10             	sub    $0x10,%esp
80104297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010429a:	68 20 1d 11 80       	push   $0x80111d20
8010429f:	e8 4c 04 00 00       	call   801046f0 <acquire>
801042a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801042ac:	eb 0c                	jmp    801042ba <kill+0x2a>
801042ae:	66 90                	xchg   %ax,%ax
801042b0:	83 c0 7c             	add    $0x7c,%eax
801042b3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801042b8:	74 36                	je     801042f0 <kill+0x60>
    if(p->pid == pid){
801042ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801042bd:	75 f1                	jne    801042b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042ca:	75 07                	jne    801042d3 <kill+0x43>
        p->state = RUNNABLE;
801042cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042d3:	83 ec 0c             	sub    $0xc,%esp
801042d6:	68 20 1d 11 80       	push   $0x80111d20
801042db:	e8 b0 03 00 00       	call   80104690 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042e3:	83 c4 10             	add    $0x10,%esp
801042e6:	31 c0                	xor    %eax,%eax
}
801042e8:	c9                   	leave
801042e9:	c3                   	ret
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801042f0:	83 ec 0c             	sub    $0xc,%esp
801042f3:	68 20 1d 11 80       	push   $0x80111d20
801042f8:	e8 93 03 00 00       	call   80104690 <release>
}
801042fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104300:	83 c4 10             	add    $0x10,%esp
80104303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104308:	c9                   	leave
80104309:	c3                   	ret
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104310 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104318:	53                   	push   %ebx
80104319:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010431e:	83 ec 3c             	sub    $0x3c,%esp
80104321:	eb 24                	jmp    80104347 <procdump+0x37>
80104323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104327:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 9a 77 10 80       	push   $0x8010779a
80104330:	e8 7b c3 ff ff       	call   801006b0 <cprintf>
80104335:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104338:	83 c3 7c             	add    $0x7c,%ebx
8010433b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104341:	0f 84 81 00 00 00    	je     801043c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104347:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010434a:	85 c0                	test   %eax,%eax
8010434c:	74 ea                	je     80104338 <procdump+0x28>
      state = "???";
8010434e:	ba ec 75 10 80       	mov    $0x801075ec,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104353:	83 f8 05             	cmp    $0x5,%eax
80104356:	77 11                	ja     80104369 <procdump+0x59>
80104358:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
      state = "???";
8010435f:	b8 ec 75 10 80       	mov    $0x801075ec,%eax
80104364:	85 d2                	test   %edx,%edx
80104366:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104369:	53                   	push   %ebx
8010436a:	52                   	push   %edx
8010436b:	ff 73 a4             	push   -0x5c(%ebx)
8010436e:	68 f0 75 10 80       	push   $0x801075f0
80104373:	e8 38 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104378:	83 c4 10             	add    $0x10,%esp
8010437b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010437f:	75 a7                	jne    80104328 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104381:	83 ec 08             	sub    $0x8,%esp
80104384:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104387:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010438a:	50                   	push   %eax
8010438b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010438e:	8b 40 0c             	mov    0xc(%eax),%eax
80104391:	83 c0 08             	add    $0x8,%eax
80104394:	50                   	push   %eax
80104395:	e8 86 01 00 00       	call   80104520 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010439a:	83 c4 10             	add    $0x10,%esp
8010439d:	8d 76 00             	lea    0x0(%esi),%esi
801043a0:	8b 17                	mov    (%edi),%edx
801043a2:	85 d2                	test   %edx,%edx
801043a4:	74 82                	je     80104328 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043ac:	52                   	push   %edx
801043ad:	68 01 73 10 80       	push   $0x80107301
801043b2:	e8 f9 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043b7:	83 c4 10             	add    $0x10,%esp
801043ba:	39 f7                	cmp    %esi,%edi
801043bc:	75 e2                	jne    801043a0 <procdump+0x90>
801043be:	e9 65 ff ff ff       	jmp    80104328 <procdump+0x18>
801043c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c7:	90                   	nop
  }
}
801043c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043cb:	5b                   	pop    %ebx
801043cc:	5e                   	pop    %esi
801043cd:	5f                   	pop    %edi
801043ce:	5d                   	pop    %ebp
801043cf:	c3                   	ret

801043d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
801043d4:	83 ec 0c             	sub    $0xc,%esp
801043d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043da:	68 23 76 10 80       	push   $0x80107623
801043df:	8d 43 04             	lea    0x4(%ebx),%eax
801043e2:	50                   	push   %eax
801043e3:	e8 18 01 00 00       	call   80104500 <initlock>
  lk->name = name;
801043e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104401:	c9                   	leave
80104402:	c3                   	ret
80104403:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104418:	8d 73 04             	lea    0x4(%ebx),%esi
8010441b:	83 ec 0c             	sub    $0xc,%esp
8010441e:	56                   	push   %esi
8010441f:	e8 cc 02 00 00       	call   801046f0 <acquire>
  while (lk->locked) {
80104424:	8b 13                	mov    (%ebx),%edx
80104426:	83 c4 10             	add    $0x10,%esp
80104429:	85 d2                	test   %edx,%edx
8010442b:	74 16                	je     80104443 <acquiresleep+0x33>
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104430:	83 ec 08             	sub    $0x8,%esp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	e8 36 fd ff ff       	call   80104170 <sleep>
  while (lk->locked) {
8010443a:	8b 03                	mov    (%ebx),%eax
8010443c:	83 c4 10             	add    $0x10,%esp
8010443f:	85 c0                	test   %eax,%eax
80104441:	75 ed                	jne    80104430 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104443:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104449:	e8 62 f6 ff ff       	call   80103ab0 <myproc>
8010444e:	8b 40 10             	mov    0x10(%eax),%eax
80104451:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104454:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104457:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445a:	5b                   	pop    %ebx
8010445b:	5e                   	pop    %esi
8010445c:	5d                   	pop    %ebp
  release(&lk->lk);
8010445d:	e9 2e 02 00 00       	jmp    80104690 <release>
80104462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104470 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104478:	8d 73 04             	lea    0x4(%ebx),%esi
8010447b:	83 ec 0c             	sub    $0xc,%esp
8010447e:	56                   	push   %esi
8010447f:	e8 6c 02 00 00       	call   801046f0 <acquire>
  lk->locked = 0;
80104484:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010448a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104491:	89 1c 24             	mov    %ebx,(%esp)
80104494:	e8 97 fd ff ff       	call   80104230 <wakeup>
  release(&lk->lk);
80104499:	89 75 08             	mov    %esi,0x8(%ebp)
8010449c:	83 c4 10             	add    $0x10,%esp
}
8010449f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a2:	5b                   	pop    %ebx
801044a3:	5e                   	pop    %esi
801044a4:	5d                   	pop    %ebp
  release(&lk->lk);
801044a5:	e9 e6 01 00 00       	jmp    80104690 <release>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	31 ff                	xor    %edi,%edi
801044b6:	56                   	push   %esi
801044b7:	53                   	push   %ebx
801044b8:	83 ec 18             	sub    $0x18,%esp
801044bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044be:	8d 73 04             	lea    0x4(%ebx),%esi
801044c1:	56                   	push   %esi
801044c2:	e8 29 02 00 00       	call   801046f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044c7:	8b 03                	mov    (%ebx),%eax
801044c9:	83 c4 10             	add    $0x10,%esp
801044cc:	85 c0                	test   %eax,%eax
801044ce:	75 18                	jne    801044e8 <holdingsleep+0x38>
  release(&lk->lk);
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	56                   	push   %esi
801044d4:	e8 b7 01 00 00       	call   80104690 <release>
  return r;
}
801044d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044dc:	89 f8                	mov    %edi,%eax
801044de:	5b                   	pop    %ebx
801044df:	5e                   	pop    %esi
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801044e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044eb:	e8 c0 f5 ff ff       	call   80103ab0 <myproc>
801044f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801044f3:	0f 94 c0             	sete   %al
801044f6:	0f b6 c0             	movzbl %al,%eax
801044f9:	89 c7                	mov    %eax,%edi
801044fb:	eb d3                	jmp    801044d0 <holdingsleep+0x20>
801044fd:	66 90                	xchg   %ax,%ax
801044ff:	90                   	nop

80104500 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104506:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010450f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104512:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret
8010451b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010451f:	90                   	nop

80104520 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	8b 45 08             	mov    0x8(%ebp),%eax
80104527:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010452a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010452d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104532:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104537:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010453c:	76 10                	jbe    8010454e <getcallerpcs+0x2e>
8010453e:	eb 28                	jmp    80104568 <getcallerpcs+0x48>
80104540:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104546:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010454c:	77 1a                	ja     80104568 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010454e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104551:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104554:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104557:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104559:	83 f8 0a             	cmp    $0xa,%eax
8010455c:	75 e2                	jne    80104540 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010455e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104561:	c9                   	leave
80104562:	c3                   	ret
80104563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104567:	90                   	nop
80104568:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010456b:	83 c1 28             	add    $0x28,%ecx
8010456e:	89 ca                	mov    %ecx,%edx
80104570:	29 c2                	sub    %eax,%edx
80104572:	83 e2 04             	and    $0x4,%edx
80104575:	74 11                	je     80104588 <getcallerpcs+0x68>
    pcs[i] = 0;
80104577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010457d:	83 c0 04             	add    $0x4,%eax
80104580:	39 c1                	cmp    %eax,%ecx
80104582:	74 da                	je     8010455e <getcallerpcs+0x3e>
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104588:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010458e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104591:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104598:	39 c1                	cmp    %eax,%ecx
8010459a:	75 ec                	jne    80104588 <getcallerpcs+0x68>
8010459c:	eb c0                	jmp    8010455e <getcallerpcs+0x3e>
8010459e:	66 90                	xchg   %ax,%ax

801045a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 04             	sub    $0x4,%esp
801045a7:	9c                   	pushf
801045a8:	5b                   	pop    %ebx
  asm volatile("cli");
801045a9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045aa:	e8 81 f4 ff ff       	call   80103a30 <mycpu>
801045af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045b5:	85 c0                	test   %eax,%eax
801045b7:	74 17                	je     801045d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045b9:	e8 72 f4 ff ff       	call   80103a30 <mycpu>
801045be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c8:	c9                   	leave
801045c9:	c3                   	ret
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045d0:	e8 5b f4 ff ff       	call   80103a30 <mycpu>
801045d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045e1:	eb d6                	jmp    801045b9 <pushcli+0x19>
801045e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <popcli>:

void
popcli(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045f6:	9c                   	pushf
801045f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045f8:	f6 c4 02             	test   $0x2,%ah
801045fb:	75 35                	jne    80104632 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045fd:	e8 2e f4 ff ff       	call   80103a30 <mycpu>
80104602:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104609:	78 34                	js     8010463f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010460b:	e8 20 f4 ff ff       	call   80103a30 <mycpu>
80104610:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104616:	85 d2                	test   %edx,%edx
80104618:	74 06                	je     80104620 <popcli+0x30>
    sti();
}
8010461a:	c9                   	leave
8010461b:	c3                   	ret
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104620:	e8 0b f4 ff ff       	call   80103a30 <mycpu>
80104625:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010462b:	85 c0                	test   %eax,%eax
8010462d:	74 eb                	je     8010461a <popcli+0x2a>
  asm volatile("sti");
8010462f:	fb                   	sti
}
80104630:	c9                   	leave
80104631:	c3                   	ret
    panic("popcli - interruptible");
80104632:	83 ec 0c             	sub    $0xc,%esp
80104635:	68 2e 76 10 80       	push   $0x8010762e
8010463a:	e8 41 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010463f:	83 ec 0c             	sub    $0xc,%esp
80104642:	68 45 76 10 80       	push   $0x80107645
80104647:	e8 34 bd ff ff       	call   80100380 <panic>
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104650 <holding>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 75 08             	mov    0x8(%ebp),%esi
80104658:	31 db                	xor    %ebx,%ebx
  pushcli();
8010465a:	e8 41 ff ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010465f:	8b 06                	mov    (%esi),%eax
80104661:	85 c0                	test   %eax,%eax
80104663:	75 0b                	jne    80104670 <holding+0x20>
  popcli();
80104665:	e8 86 ff ff ff       	call   801045f0 <popcli>
}
8010466a:	89 d8                	mov    %ebx,%eax
8010466c:	5b                   	pop    %ebx
8010466d:	5e                   	pop    %esi
8010466e:	5d                   	pop    %ebp
8010466f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104670:	8b 5e 08             	mov    0x8(%esi),%ebx
80104673:	e8 b8 f3 ff ff       	call   80103a30 <mycpu>
80104678:	39 c3                	cmp    %eax,%ebx
8010467a:	0f 94 c3             	sete   %bl
  popcli();
8010467d:	e8 6e ff ff ff       	call   801045f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104682:	0f b6 db             	movzbl %bl,%ebx
}
80104685:	89 d8                	mov    %ebx,%eax
80104687:	5b                   	pop    %ebx
80104688:	5e                   	pop    %esi
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret
8010468b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop

80104690 <release>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104698:	e8 03 ff ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010469d:	8b 03                	mov    (%ebx),%eax
8010469f:	85 c0                	test   %eax,%eax
801046a1:	75 15                	jne    801046b8 <release+0x28>
  popcli();
801046a3:	e8 48 ff ff ff       	call   801045f0 <popcli>
    panic("release");
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	68 4c 76 10 80       	push   $0x8010764c
801046b0:	e8 cb bc ff ff       	call   80100380 <panic>
801046b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046b8:	8b 73 08             	mov    0x8(%ebx),%esi
801046bb:	e8 70 f3 ff ff       	call   80103a30 <mycpu>
801046c0:	39 c6                	cmp    %eax,%esi
801046c2:	75 df                	jne    801046a3 <release+0x13>
  popcli();
801046c4:	e8 27 ff ff ff       	call   801045f0 <popcli>
  lk->pcs[0] = 0;
801046c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046e5:	5b                   	pop    %ebx
801046e6:	5e                   	pop    %esi
801046e7:	5d                   	pop    %ebp
  popcli();
801046e8:	e9 03 ff ff ff       	jmp    801045f0 <popcli>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi

801046f0 <acquire>:
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046f7:	e8 a4 fe ff ff       	call   801045a0 <pushcli>
  if(holding(lk))
801046fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046ff:	e8 9c fe ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104704:	8b 03                	mov    (%ebx),%eax
80104706:	85 c0                	test   %eax,%eax
80104708:	0f 85 b2 00 00 00    	jne    801047c0 <acquire+0xd0>
  popcli();
8010470e:	e8 dd fe ff ff       	call   801045f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104713:	b9 01 00 00 00       	mov    $0x1,%ecx
80104718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104720:	8b 55 08             	mov    0x8(%ebp),%edx
80104723:	89 c8                	mov    %ecx,%eax
80104725:	f0 87 02             	lock xchg %eax,(%edx)
80104728:	85 c0                	test   %eax,%eax
8010472a:	75 f4                	jne    80104720 <acquire+0x30>
  __sync_synchronize();
8010472c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104731:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104734:	e8 f7 f2 ff ff       	call   80103a30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010473c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010473e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104741:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104747:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010474c:	77 32                	ja     80104780 <acquire+0x90>
  ebp = (uint*)v - 2;
8010474e:	89 e8                	mov    %ebp,%eax
80104750:	eb 14                	jmp    80104766 <acquire+0x76>
80104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104758:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010475e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104764:	77 1a                	ja     80104780 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104766:	8b 58 04             	mov    0x4(%eax),%ebx
80104769:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010476d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104770:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104772:	83 fa 0a             	cmp    $0xa,%edx
80104775:	75 e1                	jne    80104758 <acquire+0x68>
}
80104777:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010477a:	c9                   	leave
8010477b:	c3                   	ret
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104780:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104784:	83 c1 34             	add    $0x34,%ecx
80104787:	89 ca                	mov    %ecx,%edx
80104789:	29 c2                	sub    %eax,%edx
8010478b:	83 e2 04             	and    $0x4,%edx
8010478e:	74 10                	je     801047a0 <acquire+0xb0>
    pcs[i] = 0;
80104790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104796:	83 c0 04             	add    $0x4,%eax
80104799:	39 c1                	cmp    %eax,%ecx
8010479b:	74 da                	je     80104777 <acquire+0x87>
8010479d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801047a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047a6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801047a9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801047b0:	39 c1                	cmp    %eax,%ecx
801047b2:	75 ec                	jne    801047a0 <acquire+0xb0>
801047b4:	eb c1                	jmp    80104777 <acquire+0x87>
801047b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047c0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801047c3:	e8 68 f2 ff ff       	call   80103a30 <mycpu>
801047c8:	39 c3                	cmp    %eax,%ebx
801047ca:	0f 85 3e ff ff ff    	jne    8010470e <acquire+0x1e>
  popcli();
801047d0:	e8 1b fe ff ff       	call   801045f0 <popcli>
    panic("acquire");
801047d5:	83 ec 0c             	sub    $0xc,%esp
801047d8:	68 54 76 10 80       	push   $0x80107654
801047dd:	e8 9e bb ff ff       	call   80100380 <panic>
801047e2:	66 90                	xchg   %ax,%ax
801047e4:	66 90                	xchg   %ax,%ax
801047e6:	66 90                	xchg   %ax,%ax
801047e8:	66 90                	xchg   %ax,%ax
801047ea:	66 90                	xchg   %ax,%ax
801047ec:	66 90                	xchg   %ax,%ax
801047ee:	66 90                	xchg   %ax,%ax

801047f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	8b 55 08             	mov    0x8(%ebp),%edx
801047f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801047fa:	89 d0                	mov    %edx,%eax
801047fc:	09 c8                	or     %ecx,%eax
801047fe:	a8 03                	test   $0x3,%al
80104800:	75 1e                	jne    80104820 <memset+0x30>
    c &= 0xFF;
80104802:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104806:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104809:	89 d7                	mov    %edx,%edi
8010480b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104811:	fc                   	cld
80104812:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104814:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104817:	89 d0                	mov    %edx,%eax
80104819:	c9                   	leave
8010481a:	c3                   	ret
8010481b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104820:	8b 45 0c             	mov    0xc(%ebp),%eax
80104823:	89 d7                	mov    %edx,%edi
80104825:	fc                   	cld
80104826:	f3 aa                	rep stos %al,%es:(%edi)
80104828:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010482b:	89 d0                	mov    %edx,%eax
8010482d:	c9                   	leave
8010482e:	c3                   	ret
8010482f:	90                   	nop

80104830 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	8b 75 10             	mov    0x10(%ebp),%esi
80104837:	8b 45 08             	mov    0x8(%ebp),%eax
8010483a:	53                   	push   %ebx
8010483b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010483e:	85 f6                	test   %esi,%esi
80104840:	74 2e                	je     80104870 <memcmp+0x40>
80104842:	01 c6                	add    %eax,%esi
80104844:	eb 14                	jmp    8010485a <memcmp+0x2a>
80104846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104850:	83 c0 01             	add    $0x1,%eax
80104853:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104856:	39 f0                	cmp    %esi,%eax
80104858:	74 16                	je     80104870 <memcmp+0x40>
    if(*s1 != *s2)
8010485a:	0f b6 08             	movzbl (%eax),%ecx
8010485d:	0f b6 1a             	movzbl (%edx),%ebx
80104860:	38 d9                	cmp    %bl,%cl
80104862:	74 ec                	je     80104850 <memcmp+0x20>
      return *s1 - *s2;
80104864:	0f b6 c1             	movzbl %cl,%eax
80104867:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104869:	5b                   	pop    %ebx
8010486a:	5e                   	pop    %esi
8010486b:	5d                   	pop    %ebp
8010486c:	c3                   	ret
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
80104870:	5b                   	pop    %ebx
  return 0;
80104871:	31 c0                	xor    %eax,%eax
}
80104873:	5e                   	pop    %esi
80104874:	5d                   	pop    %ebp
80104875:	c3                   	ret
80104876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010487d:	8d 76 00             	lea    0x0(%esi),%esi

80104880 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	8b 55 08             	mov    0x8(%ebp),%edx
80104887:	8b 45 10             	mov    0x10(%ebp),%eax
8010488a:	56                   	push   %esi
8010488b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010488e:	39 d6                	cmp    %edx,%esi
80104890:	73 26                	jae    801048b8 <memmove+0x38>
80104892:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104895:	39 ca                	cmp    %ecx,%edx
80104897:	73 1f                	jae    801048b8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104899:	85 c0                	test   %eax,%eax
8010489b:	74 0f                	je     801048ac <memmove+0x2c>
8010489d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801048a0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048a4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048a7:	83 e8 01             	sub    $0x1,%eax
801048aa:	73 f4                	jae    801048a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048ac:	5e                   	pop    %esi
801048ad:	89 d0                	mov    %edx,%eax
801048af:	5f                   	pop    %edi
801048b0:	5d                   	pop    %ebp
801048b1:	c3                   	ret
801048b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801048b8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048bb:	89 d7                	mov    %edx,%edi
801048bd:	85 c0                	test   %eax,%eax
801048bf:	74 eb                	je     801048ac <memmove+0x2c>
801048c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048c8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048c9:	39 ce                	cmp    %ecx,%esi
801048cb:	75 fb                	jne    801048c8 <memmove+0x48>
}
801048cd:	5e                   	pop    %esi
801048ce:	89 d0                	mov    %edx,%eax
801048d0:	5f                   	pop    %edi
801048d1:	5d                   	pop    %ebp
801048d2:	c3                   	ret
801048d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048e0:	eb 9e                	jmp    80104880 <memmove>
801048e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	8b 55 10             	mov    0x10(%ebp),%edx
801048f7:	8b 45 08             	mov    0x8(%ebp),%eax
801048fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801048fd:	85 d2                	test   %edx,%edx
801048ff:	75 16                	jne    80104917 <strncmp+0x27>
80104901:	eb 2d                	jmp    80104930 <strncmp+0x40>
80104903:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104907:	90                   	nop
80104908:	3a 19                	cmp    (%ecx),%bl
8010490a:	75 12                	jne    8010491e <strncmp+0x2e>
    n--, p++, q++;
8010490c:	83 c0 01             	add    $0x1,%eax
8010490f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104912:	83 ea 01             	sub    $0x1,%edx
80104915:	74 19                	je     80104930 <strncmp+0x40>
80104917:	0f b6 18             	movzbl (%eax),%ebx
8010491a:	84 db                	test   %bl,%bl
8010491c:	75 ea                	jne    80104908 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010491e:	0f b6 00             	movzbl (%eax),%eax
80104921:	0f b6 11             	movzbl (%ecx),%edx
}
80104924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104927:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104928:	29 d0                	sub    %edx,%eax
}
8010492a:	c3                   	ret
8010492b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010492f:	90                   	nop
80104930:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104933:	31 c0                	xor    %eax,%eax
}
80104935:	c9                   	leave
80104936:	c3                   	ret
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax

80104940 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	56                   	push   %esi
80104945:	8b 75 08             	mov    0x8(%ebp),%esi
80104948:	53                   	push   %ebx
80104949:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010494c:	89 f0                	mov    %esi,%eax
8010494e:	eb 15                	jmp    80104965 <strncpy+0x25>
80104950:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104954:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104957:	83 c0 01             	add    $0x1,%eax
8010495a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010495e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104961:	84 c9                	test   %cl,%cl
80104963:	74 13                	je     80104978 <strncpy+0x38>
80104965:	89 d3                	mov    %edx,%ebx
80104967:	83 ea 01             	sub    $0x1,%edx
8010496a:	85 db                	test   %ebx,%ebx
8010496c:	7f e2                	jg     80104950 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010496e:	5b                   	pop    %ebx
8010496f:	89 f0                	mov    %esi,%eax
80104971:	5e                   	pop    %esi
80104972:	5f                   	pop    %edi
80104973:	5d                   	pop    %ebp
80104974:	c3                   	ret
80104975:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104978:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010497b:	83 e9 01             	sub    $0x1,%ecx
8010497e:	85 d2                	test   %edx,%edx
80104980:	74 ec                	je     8010496e <strncpy+0x2e>
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104988:	83 c0 01             	add    $0x1,%eax
8010498b:	89 ca                	mov    %ecx,%edx
8010498d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104991:	29 c2                	sub    %eax,%edx
80104993:	85 d2                	test   %edx,%edx
80104995:	7f f1                	jg     80104988 <strncpy+0x48>
}
80104997:	5b                   	pop    %ebx
80104998:	89 f0                	mov    %esi,%eax
8010499a:	5e                   	pop    %esi
8010499b:	5f                   	pop    %edi
8010499c:	5d                   	pop    %ebp
8010499d:	c3                   	ret
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	8b 55 10             	mov    0x10(%ebp),%edx
801049a7:	8b 75 08             	mov    0x8(%ebp),%esi
801049aa:	53                   	push   %ebx
801049ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049ae:	85 d2                	test   %edx,%edx
801049b0:	7e 25                	jle    801049d7 <safestrcpy+0x37>
801049b2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801049b6:	89 f2                	mov    %esi,%edx
801049b8:	eb 16                	jmp    801049d0 <safestrcpy+0x30>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049c0:	0f b6 08             	movzbl (%eax),%ecx
801049c3:	83 c0 01             	add    $0x1,%eax
801049c6:	83 c2 01             	add    $0x1,%edx
801049c9:	88 4a ff             	mov    %cl,-0x1(%edx)
801049cc:	84 c9                	test   %cl,%cl
801049ce:	74 04                	je     801049d4 <safestrcpy+0x34>
801049d0:	39 d8                	cmp    %ebx,%eax
801049d2:	75 ec                	jne    801049c0 <safestrcpy+0x20>
    ;
  *s = 0;
801049d4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049d7:	89 f0                	mov    %esi,%eax
801049d9:	5b                   	pop    %ebx
801049da:	5e                   	pop    %esi
801049db:	5d                   	pop    %ebp
801049dc:	c3                   	ret
801049dd:	8d 76 00             	lea    0x0(%esi),%esi

801049e0 <strlen>:

int
strlen(const char *s)
{
801049e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049e1:	31 c0                	xor    %eax,%eax
{
801049e3:	89 e5                	mov    %esp,%ebp
801049e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049e8:	80 3a 00             	cmpb   $0x0,(%edx)
801049eb:	74 0c                	je     801049f9 <strlen+0x19>
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
801049f0:	83 c0 01             	add    $0x1,%eax
801049f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049f7:	75 f7                	jne    801049f0 <strlen+0x10>
    ;
  return n;
}
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret

801049fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a03:	55                   	push   %ebp
  pushl %ebx
80104a04:	53                   	push   %ebx
  pushl %esi
80104a05:	56                   	push   %esi
  pushl %edi
80104a06:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a07:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a09:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a0b:	5f                   	pop    %edi
  popl %esi
80104a0c:	5e                   	pop    %esi
  popl %ebx
80104a0d:	5b                   	pop    %ebx
  popl %ebp
80104a0e:	5d                   	pop    %ebp
  ret
80104a0f:	c3                   	ret

80104a10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
80104a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a1a:	e8 91 f0 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a1f:	8b 00                	mov    (%eax),%eax
80104a21:	39 c3                	cmp    %eax,%ebx
80104a23:	73 1b                	jae    80104a40 <fetchint+0x30>
80104a25:	8d 53 04             	lea    0x4(%ebx),%edx
80104a28:	39 d0                	cmp    %edx,%eax
80104a2a:	72 14                	jb     80104a40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a2f:	8b 13                	mov    (%ebx),%edx
80104a31:	89 10                	mov    %edx,(%eax)
  return 0;
80104a33:	31 c0                	xor    %eax,%eax
}
80104a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a38:	c9                   	leave
80104a39:	c3                   	ret
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a45:	eb ee                	jmp    80104a35 <fetchint+0x25>
80104a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 04             	sub    $0x4,%esp
80104a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a5a:	e8 51 f0 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz)
80104a5f:	3b 18                	cmp    (%eax),%ebx
80104a61:	73 2d                	jae    80104a90 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a63:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a66:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a68:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a6a:	39 d3                	cmp    %edx,%ebx
80104a6c:	73 22                	jae    80104a90 <fetchstr+0x40>
80104a6e:	89 d8                	mov    %ebx,%eax
80104a70:	eb 0d                	jmp    80104a7f <fetchstr+0x2f>
80104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a78:	83 c0 01             	add    $0x1,%eax
80104a7b:	39 d0                	cmp    %edx,%eax
80104a7d:	73 11                	jae    80104a90 <fetchstr+0x40>
    if(*s == 0)
80104a7f:	80 38 00             	cmpb   $0x0,(%eax)
80104a82:	75 f4                	jne    80104a78 <fetchstr+0x28>
      return s - *pp;
80104a84:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a89:	c9                   	leave
80104a8a:	c3                   	ret
80104a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop
80104a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a98:	c9                   	leave
80104a99:	c3                   	ret
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aa5:	e8 06 f0 ff ff       	call   80103ab0 <myproc>
80104aaa:	8b 55 08             	mov    0x8(%ebp),%edx
80104aad:	8b 40 18             	mov    0x18(%eax),%eax
80104ab0:	8b 40 44             	mov    0x44(%eax),%eax
80104ab3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ab6:	e8 f5 ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104abb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104abe:	8b 00                	mov    (%eax),%eax
80104ac0:	39 c6                	cmp    %eax,%esi
80104ac2:	73 1c                	jae    80104ae0 <argint+0x40>
80104ac4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ac7:	39 d0                	cmp    %edx,%eax
80104ac9:	72 15                	jb     80104ae0 <argint+0x40>
  *ip = *(int*)(addr);
80104acb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ace:	8b 53 04             	mov    0x4(%ebx),%edx
80104ad1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ad3:	31 c0                	xor    %eax,%eax
}
80104ad5:	5b                   	pop    %ebx
80104ad6:	5e                   	pop    %esi
80104ad7:	5d                   	pop    %ebp
80104ad8:	c3                   	ret
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ae5:	eb ee                	jmp    80104ad5 <argint+0x35>
80104ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	53                   	push   %ebx
80104af6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104af9:	e8 b2 ef ff ff       	call   80103ab0 <myproc>
80104afe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b00:	e8 ab ef ff ff       	call   80103ab0 <myproc>
80104b05:	8b 55 08             	mov    0x8(%ebp),%edx
80104b08:	8b 40 18             	mov    0x18(%eax),%eax
80104b0b:	8b 40 44             	mov    0x44(%eax),%eax
80104b0e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b11:	e8 9a ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b16:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b19:	8b 00                	mov    (%eax),%eax
80104b1b:	39 c7                	cmp    %eax,%edi
80104b1d:	73 31                	jae    80104b50 <argptr+0x60>
80104b1f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b22:	39 c8                	cmp    %ecx,%eax
80104b24:	72 2a                	jb     80104b50 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b26:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b29:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b2c:	85 d2                	test   %edx,%edx
80104b2e:	78 20                	js     80104b50 <argptr+0x60>
80104b30:	8b 16                	mov    (%esi),%edx
80104b32:	39 d0                	cmp    %edx,%eax
80104b34:	73 1a                	jae    80104b50 <argptr+0x60>
80104b36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b39:	01 c3                	add    %eax,%ebx
80104b3b:	39 da                	cmp    %ebx,%edx
80104b3d:	72 11                	jb     80104b50 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b42:	89 02                	mov    %eax,(%edx)
  return 0;
80104b44:	31 c0                	xor    %eax,%eax
}
80104b46:	83 c4 0c             	add    $0xc,%esp
80104b49:	5b                   	pop    %ebx
80104b4a:	5e                   	pop    %esi
80104b4b:	5f                   	pop    %edi
80104b4c:	5d                   	pop    %ebp
80104b4d:	c3                   	ret
80104b4e:	66 90                	xchg   %ax,%ax
    return -1;
80104b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b55:	eb ef                	jmp    80104b46 <argptr+0x56>
80104b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b65:	e8 46 ef ff ff       	call   80103ab0 <myproc>
80104b6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b6d:	8b 40 18             	mov    0x18(%eax),%eax
80104b70:	8b 40 44             	mov    0x44(%eax),%eax
80104b73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b76:	e8 35 ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b7e:	8b 00                	mov    (%eax),%eax
80104b80:	39 c6                	cmp    %eax,%esi
80104b82:	73 44                	jae    80104bc8 <argstr+0x68>
80104b84:	8d 53 08             	lea    0x8(%ebx),%edx
80104b87:	39 d0                	cmp    %edx,%eax
80104b89:	72 3d                	jb     80104bc8 <argstr+0x68>
  *ip = *(int*)(addr);
80104b8b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b8e:	e8 1d ef ff ff       	call   80103ab0 <myproc>
  if(addr >= curproc->sz)
80104b93:	3b 18                	cmp    (%eax),%ebx
80104b95:	73 31                	jae    80104bc8 <argstr+0x68>
  *pp = (char*)addr;
80104b97:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b9e:	39 d3                	cmp    %edx,%ebx
80104ba0:	73 26                	jae    80104bc8 <argstr+0x68>
80104ba2:	89 d8                	mov    %ebx,%eax
80104ba4:	eb 11                	jmp    80104bb7 <argstr+0x57>
80104ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
80104bb0:	83 c0 01             	add    $0x1,%eax
80104bb3:	39 d0                	cmp    %edx,%eax
80104bb5:	73 11                	jae    80104bc8 <argstr+0x68>
    if(*s == 0)
80104bb7:	80 38 00             	cmpb   $0x0,(%eax)
80104bba:	75 f4                	jne    80104bb0 <argstr+0x50>
      return s - *pp;
80104bbc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104bbe:	5b                   	pop    %ebx
80104bbf:	5e                   	pop    %esi
80104bc0:	5d                   	pop    %ebp
80104bc1:	c3                   	ret
80104bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bc8:	5b                   	pop    %ebx
    return -1;
80104bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bce:	5e                   	pop    %esi
80104bcf:	5d                   	pop    %ebp
80104bd0:	c3                   	ret
80104bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bdf:	90                   	nop

80104be0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	53                   	push   %ebx
80104be4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104be7:	e8 c4 ee ff ff       	call   80103ab0 <myproc>
80104bec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bee:	8b 40 18             	mov    0x18(%eax),%eax
80104bf1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104bf4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bf7:	83 fa 14             	cmp    $0x14,%edx
80104bfa:	77 24                	ja     80104c20 <syscall+0x40>
80104bfc:	8b 14 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%edx
80104c03:	85 d2                	test   %edx,%edx
80104c05:	74 19                	je     80104c20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c07:	ff d2                	call   *%edx
80104c09:	89 c2                	mov    %eax,%edx
80104c0b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c0e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c14:	c9                   	leave
80104c15:	c3                   	ret
80104c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c20:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c21:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c24:	50                   	push   %eax
80104c25:	ff 73 10             	push   0x10(%ebx)
80104c28:	68 5c 76 10 80       	push   $0x8010765c
80104c2d:	e8 7e ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104c32:	8b 43 18             	mov    0x18(%ebx),%eax
80104c35:	83 c4 10             	add    $0x10,%esp
80104c38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c42:	c9                   	leave
80104c43:	c3                   	ret
80104c44:	66 90                	xchg   %ax,%ax
80104c46:	66 90                	xchg   %ax,%ax
80104c48:	66 90                	xchg   %ax,%ax
80104c4a:	66 90                	xchg   %ax,%ax
80104c4c:	66 90                	xchg   %ax,%ax
80104c4e:	66 90                	xchg   %ax,%ax

80104c50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	57                   	push   %edi
80104c54:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c58:	53                   	push   %ebx
80104c59:	83 ec 34             	sub    $0x34,%esp
80104c5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c62:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c65:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c68:	57                   	push   %edi
80104c69:	50                   	push   %eax
80104c6a:	e8 51 d4 ff ff       	call   801020c0 <nameiparent>
80104c6f:	83 c4 10             	add    $0x10,%esp
80104c72:	85 c0                	test   %eax,%eax
80104c74:	74 5e                	je     80104cd4 <create+0x84>
    return 0;
  ilock(dp);
80104c76:	83 ec 0c             	sub    $0xc,%esp
80104c79:	89 c3                	mov    %eax,%ebx
80104c7b:	50                   	push   %eax
80104c7c:	e8 3f cb ff ff       	call   801017c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c81:	83 c4 0c             	add    $0xc,%esp
80104c84:	6a 00                	push   $0x0
80104c86:	57                   	push   %edi
80104c87:	53                   	push   %ebx
80104c88:	e8 83 d0 ff ff       	call   80101d10 <dirlookup>
80104c8d:	83 c4 10             	add    $0x10,%esp
80104c90:	89 c6                	mov    %eax,%esi
80104c92:	85 c0                	test   %eax,%eax
80104c94:	74 4a                	je     80104ce0 <create+0x90>
    iunlockput(dp);
80104c96:	83 ec 0c             	sub    $0xc,%esp
80104c99:	53                   	push   %ebx
80104c9a:	e8 b1 cd ff ff       	call   80101a50 <iunlockput>
    ilock(ip);
80104c9f:	89 34 24             	mov    %esi,(%esp)
80104ca2:	e8 19 cb ff ff       	call   801017c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ca7:	83 c4 10             	add    $0x10,%esp
80104caa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104caf:	75 17                	jne    80104cc8 <create+0x78>
80104cb1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104cb6:	75 10                	jne    80104cc8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cbb:	89 f0                	mov    %esi,%eax
80104cbd:	5b                   	pop    %ebx
80104cbe:	5e                   	pop    %esi
80104cbf:	5f                   	pop    %edi
80104cc0:	5d                   	pop    %ebp
80104cc1:	c3                   	ret
80104cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	56                   	push   %esi
80104ccc:	e8 7f cd ff ff       	call   80101a50 <iunlockput>
    return 0;
80104cd1:	83 c4 10             	add    $0x10,%esp
}
80104cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104cd7:	31 f6                	xor    %esi,%esi
}
80104cd9:	5b                   	pop    %ebx
80104cda:	89 f0                	mov    %esi,%eax
80104cdc:	5e                   	pop    %esi
80104cdd:	5f                   	pop    %edi
80104cde:	5d                   	pop    %ebp
80104cdf:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104ce0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ce4:	83 ec 08             	sub    $0x8,%esp
80104ce7:	50                   	push   %eax
80104ce8:	ff 33                	push   (%ebx)
80104cea:	e8 61 c9 ff ff       	call   80101650 <ialloc>
80104cef:	83 c4 10             	add    $0x10,%esp
80104cf2:	89 c6                	mov    %eax,%esi
80104cf4:	85 c0                	test   %eax,%eax
80104cf6:	0f 84 bc 00 00 00    	je     80104db8 <create+0x168>
  ilock(ip);
80104cfc:	83 ec 0c             	sub    $0xc,%esp
80104cff:	50                   	push   %eax
80104d00:	e8 bb ca ff ff       	call   801017c0 <ilock>
  ip->major = major;
80104d05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d15:	b8 01 00 00 00       	mov    $0x1,%eax
80104d1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d1e:	89 34 24             	mov    %esi,(%esp)
80104d21:	e8 ea c9 ff ff       	call   80101710 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d26:	83 c4 10             	add    $0x10,%esp
80104d29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d2e:	74 30                	je     80104d60 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104d30:	83 ec 04             	sub    $0x4,%esp
80104d33:	ff 76 04             	push   0x4(%esi)
80104d36:	57                   	push   %edi
80104d37:	53                   	push   %ebx
80104d38:	e8 a3 d2 ff ff       	call   80101fe0 <dirlink>
80104d3d:	83 c4 10             	add    $0x10,%esp
80104d40:	85 c0                	test   %eax,%eax
80104d42:	78 67                	js     80104dab <create+0x15b>
  iunlockput(dp);
80104d44:	83 ec 0c             	sub    $0xc,%esp
80104d47:	53                   	push   %ebx
80104d48:	e8 03 cd ff ff       	call   80101a50 <iunlockput>
  return ip;
80104d4d:	83 c4 10             	add    $0x10,%esp
}
80104d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d53:	89 f0                	mov    %esi,%eax
80104d55:	5b                   	pop    %ebx
80104d56:	5e                   	pop    %esi
80104d57:	5f                   	pop    %edi
80104d58:	5d                   	pop    %ebp
80104d59:	c3                   	ret
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d68:	53                   	push   %ebx
80104d69:	e8 a2 c9 ff ff       	call   80101710 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d6e:	83 c4 0c             	add    $0xc,%esp
80104d71:	ff 76 04             	push   0x4(%esi)
80104d74:	68 94 76 10 80       	push   $0x80107694
80104d79:	56                   	push   %esi
80104d7a:	e8 61 d2 ff ff       	call   80101fe0 <dirlink>
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	85 c0                	test   %eax,%eax
80104d84:	78 18                	js     80104d9e <create+0x14e>
80104d86:	83 ec 04             	sub    $0x4,%esp
80104d89:	ff 73 04             	push   0x4(%ebx)
80104d8c:	68 93 76 10 80       	push   $0x80107693
80104d91:	56                   	push   %esi
80104d92:	e8 49 d2 ff ff       	call   80101fe0 <dirlink>
80104d97:	83 c4 10             	add    $0x10,%esp
80104d9a:	85 c0                	test   %eax,%eax
80104d9c:	79 92                	jns    80104d30 <create+0xe0>
      panic("create dots");
80104d9e:	83 ec 0c             	sub    $0xc,%esp
80104da1:	68 87 76 10 80       	push   $0x80107687
80104da6:	e8 d5 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104dab:	83 ec 0c             	sub    $0xc,%esp
80104dae:	68 96 76 10 80       	push   $0x80107696
80104db3:	e8 c8 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104db8:	83 ec 0c             	sub    $0xc,%esp
80104dbb:	68 78 76 10 80       	push   $0x80107678
80104dc0:	e8 bb b5 ff ff       	call   80100380 <panic>
80104dc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <sys_dup>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104dd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104dd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ddb:	50                   	push   %eax
80104ddc:	6a 00                	push   $0x0
80104dde:	e8 bd fc ff ff       	call   80104aa0 <argint>
80104de3:	83 c4 10             	add    $0x10,%esp
80104de6:	85 c0                	test   %eax,%eax
80104de8:	78 36                	js     80104e20 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dee:	77 30                	ja     80104e20 <sys_dup+0x50>
80104df0:	e8 bb ec ff ff       	call   80103ab0 <myproc>
80104df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104df8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dfc:	85 f6                	test   %esi,%esi
80104dfe:	74 20                	je     80104e20 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e00:	e8 ab ec ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e05:	31 db                	xor    %ebx,%ebx
80104e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104e10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e14:	85 d2                	test   %edx,%edx
80104e16:	74 18                	je     80104e30 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e18:	83 c3 01             	add    $0x1,%ebx
80104e1b:	83 fb 10             	cmp    $0x10,%ebx
80104e1e:	75 f0                	jne    80104e10 <sys_dup+0x40>
}
80104e20:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e28:	89 d8                	mov    %ebx,%eax
80104e2a:	5b                   	pop    %ebx
80104e2b:	5e                   	pop    %esi
80104e2c:	5d                   	pop    %ebp
80104e2d:	c3                   	ret
80104e2e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e30:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e33:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e37:	56                   	push   %esi
80104e38:	e8 a3 c0 ff ff       	call   80100ee0 <filedup>
  return fd;
80104e3d:	83 c4 10             	add    $0x10,%esp
}
80104e40:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e43:	89 d8                	mov    %ebx,%eax
80104e45:	5b                   	pop    %ebx
80104e46:	5e                   	pop    %esi
80104e47:	5d                   	pop    %ebp
80104e48:	c3                   	ret
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e50 <sys_read>:
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e5b:	53                   	push   %ebx
80104e5c:	6a 00                	push   $0x0
80104e5e:	e8 3d fc ff ff       	call   80104aa0 <argint>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	85 c0                	test   %eax,%eax
80104e68:	78 5e                	js     80104ec8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e6e:	77 58                	ja     80104ec8 <sys_read+0x78>
80104e70:	e8 3b ec ff ff       	call   80103ab0 <myproc>
80104e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e7c:	85 f6                	test   %esi,%esi
80104e7e:	74 48                	je     80104ec8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e80:	83 ec 08             	sub    $0x8,%esp
80104e83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e86:	50                   	push   %eax
80104e87:	6a 02                	push   $0x2
80104e89:	e8 12 fc ff ff       	call   80104aa0 <argint>
80104e8e:	83 c4 10             	add    $0x10,%esp
80104e91:	85 c0                	test   %eax,%eax
80104e93:	78 33                	js     80104ec8 <sys_read+0x78>
80104e95:	83 ec 04             	sub    $0x4,%esp
80104e98:	ff 75 f0             	push   -0x10(%ebp)
80104e9b:	53                   	push   %ebx
80104e9c:	6a 01                	push   $0x1
80104e9e:	e8 4d fc ff ff       	call   80104af0 <argptr>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	78 1e                	js     80104ec8 <sys_read+0x78>
  return fileread(f, p, n);
80104eaa:	83 ec 04             	sub    $0x4,%esp
80104ead:	ff 75 f0             	push   -0x10(%ebp)
80104eb0:	ff 75 f4             	push   -0xc(%ebp)
80104eb3:	56                   	push   %esi
80104eb4:	e8 a7 c1 ff ff       	call   80101060 <fileread>
80104eb9:	83 c4 10             	add    $0x10,%esp
}
80104ebc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ebf:	5b                   	pop    %ebx
80104ec0:	5e                   	pop    %esi
80104ec1:	5d                   	pop    %ebp
80104ec2:	c3                   	ret
80104ec3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ec7:	90                   	nop
    return -1;
80104ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ecd:	eb ed                	jmp    80104ebc <sys_read+0x6c>
80104ecf:	90                   	nop

80104ed0 <sys_write>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ed5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ed8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104edb:	53                   	push   %ebx
80104edc:	6a 00                	push   $0x0
80104ede:	e8 bd fb ff ff       	call   80104aa0 <argint>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	78 5e                	js     80104f48 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eee:	77 58                	ja     80104f48 <sys_write+0x78>
80104ef0:	e8 bb eb ff ff       	call   80103ab0 <myproc>
80104ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ef8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104efc:	85 f6                	test   %esi,%esi
80104efe:	74 48                	je     80104f48 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f00:	83 ec 08             	sub    $0x8,%esp
80104f03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f06:	50                   	push   %eax
80104f07:	6a 02                	push   $0x2
80104f09:	e8 92 fb ff ff       	call   80104aa0 <argint>
80104f0e:	83 c4 10             	add    $0x10,%esp
80104f11:	85 c0                	test   %eax,%eax
80104f13:	78 33                	js     80104f48 <sys_write+0x78>
80104f15:	83 ec 04             	sub    $0x4,%esp
80104f18:	ff 75 f0             	push   -0x10(%ebp)
80104f1b:	53                   	push   %ebx
80104f1c:	6a 01                	push   $0x1
80104f1e:	e8 cd fb ff ff       	call   80104af0 <argptr>
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	85 c0                	test   %eax,%eax
80104f28:	78 1e                	js     80104f48 <sys_write+0x78>
  return filewrite(f, p, n);
80104f2a:	83 ec 04             	sub    $0x4,%esp
80104f2d:	ff 75 f0             	push   -0x10(%ebp)
80104f30:	ff 75 f4             	push   -0xc(%ebp)
80104f33:	56                   	push   %esi
80104f34:	e8 b7 c1 ff ff       	call   801010f0 <filewrite>
80104f39:	83 c4 10             	add    $0x10,%esp
}
80104f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f3f:	5b                   	pop    %ebx
80104f40:	5e                   	pop    %esi
80104f41:	5d                   	pop    %ebp
80104f42:	c3                   	ret
80104f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f47:	90                   	nop
    return -1;
80104f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4d:	eb ed                	jmp    80104f3c <sys_write+0x6c>
80104f4f:	90                   	nop

80104f50 <sys_close>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f5b:	50                   	push   %eax
80104f5c:	6a 00                	push   $0x0
80104f5e:	e8 3d fb ff ff       	call   80104aa0 <argint>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 3e                	js     80104fa8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f6e:	77 38                	ja     80104fa8 <sys_close+0x58>
80104f70:	e8 3b eb ff ff       	call   80103ab0 <myproc>
80104f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f78:	8d 5a 08             	lea    0x8(%edx),%ebx
80104f7b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104f7f:	85 f6                	test   %esi,%esi
80104f81:	74 25                	je     80104fa8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104f83:	e8 28 eb ff ff       	call   80103ab0 <myproc>
  fileclose(f);
80104f88:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f8b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104f92:	00 
  fileclose(f);
80104f93:	56                   	push   %esi
80104f94:	e8 97 bf ff ff       	call   80100f30 <fileclose>
  return 0;
80104f99:	83 c4 10             	add    $0x10,%esp
80104f9c:	31 c0                	xor    %eax,%eax
}
80104f9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa1:	5b                   	pop    %ebx
80104fa2:	5e                   	pop    %esi
80104fa3:	5d                   	pop    %ebp
80104fa4:	c3                   	ret
80104fa5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fad:	eb ef                	jmp    80104f9e <sys_close+0x4e>
80104faf:	90                   	nop

80104fb0 <sys_fstat>:
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fbb:	53                   	push   %ebx
80104fbc:	6a 00                	push   $0x0
80104fbe:	e8 dd fa ff ff       	call   80104aa0 <argint>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 46                	js     80105010 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fce:	77 40                	ja     80105010 <sys_fstat+0x60>
80104fd0:	e8 db ea ff ff       	call   80103ab0 <myproc>
80104fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fdc:	85 f6                	test   %esi,%esi
80104fde:	74 30                	je     80105010 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fe0:	83 ec 04             	sub    $0x4,%esp
80104fe3:	6a 14                	push   $0x14
80104fe5:	53                   	push   %ebx
80104fe6:	6a 01                	push   $0x1
80104fe8:	e8 03 fb ff ff       	call   80104af0 <argptr>
80104fed:	83 c4 10             	add    $0x10,%esp
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	78 1c                	js     80105010 <sys_fstat+0x60>
  return filestat(f, st);
80104ff4:	83 ec 08             	sub    $0x8,%esp
80104ff7:	ff 75 f4             	push   -0xc(%ebp)
80104ffa:	56                   	push   %esi
80104ffb:	e8 10 c0 ff ff       	call   80101010 <filestat>
80105000:	83 c4 10             	add    $0x10,%esp
}
80105003:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105006:	5b                   	pop    %ebx
80105007:	5e                   	pop    %esi
80105008:	5d                   	pop    %ebp
80105009:	c3                   	ret
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105015:	eb ec                	jmp    80105003 <sys_fstat+0x53>
80105017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501e:	66 90                	xchg   %ax,%ax

80105020 <sys_link>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105025:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105028:	53                   	push   %ebx
80105029:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010502c:	50                   	push   %eax
8010502d:	6a 00                	push   $0x0
8010502f:	e8 2c fb ff ff       	call   80104b60 <argstr>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	85 c0                	test   %eax,%eax
80105039:	0f 88 fb 00 00 00    	js     8010513a <sys_link+0x11a>
8010503f:	83 ec 08             	sub    $0x8,%esp
80105042:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105045:	50                   	push   %eax
80105046:	6a 01                	push   $0x1
80105048:	e8 13 fb ff ff       	call   80104b60 <argstr>
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	85 c0                	test   %eax,%eax
80105052:	0f 88 e2 00 00 00    	js     8010513a <sys_link+0x11a>
  begin_op();
80105058:	e8 33 de ff ff       	call   80102e90 <begin_op>
  if((ip = namei(old)) == 0){
8010505d:	83 ec 0c             	sub    $0xc,%esp
80105060:	ff 75 d4             	push   -0x2c(%ebp)
80105063:	e8 38 d0 ff ff       	call   801020a0 <namei>
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	89 c3                	mov    %eax,%ebx
8010506d:	85 c0                	test   %eax,%eax
8010506f:	0f 84 df 00 00 00    	je     80105154 <sys_link+0x134>
  ilock(ip);
80105075:	83 ec 0c             	sub    $0xc,%esp
80105078:	50                   	push   %eax
80105079:	e8 42 c7 ff ff       	call   801017c0 <ilock>
  if(ip->type == T_DIR){
8010507e:	83 c4 10             	add    $0x10,%esp
80105081:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105086:	0f 84 b5 00 00 00    	je     80105141 <sys_link+0x121>
  iupdate(ip);
8010508c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010508f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105094:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105097:	53                   	push   %ebx
80105098:	e8 73 c6 ff ff       	call   80101710 <iupdate>
  iunlock(ip);
8010509d:	89 1c 24             	mov    %ebx,(%esp)
801050a0:	e8 fb c7 ff ff       	call   801018a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050a5:	58                   	pop    %eax
801050a6:	5a                   	pop    %edx
801050a7:	57                   	push   %edi
801050a8:	ff 75 d0             	push   -0x30(%ebp)
801050ab:	e8 10 d0 ff ff       	call   801020c0 <nameiparent>
801050b0:	83 c4 10             	add    $0x10,%esp
801050b3:	89 c6                	mov    %eax,%esi
801050b5:	85 c0                	test   %eax,%eax
801050b7:	74 5b                	je     80105114 <sys_link+0xf4>
  ilock(dp);
801050b9:	83 ec 0c             	sub    $0xc,%esp
801050bc:	50                   	push   %eax
801050bd:	e8 fe c6 ff ff       	call   801017c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050c2:	8b 03                	mov    (%ebx),%eax
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	39 06                	cmp    %eax,(%esi)
801050c9:	75 3d                	jne    80105108 <sys_link+0xe8>
801050cb:	83 ec 04             	sub    $0x4,%esp
801050ce:	ff 73 04             	push   0x4(%ebx)
801050d1:	57                   	push   %edi
801050d2:	56                   	push   %esi
801050d3:	e8 08 cf ff ff       	call   80101fe0 <dirlink>
801050d8:	83 c4 10             	add    $0x10,%esp
801050db:	85 c0                	test   %eax,%eax
801050dd:	78 29                	js     80105108 <sys_link+0xe8>
  iunlockput(dp);
801050df:	83 ec 0c             	sub    $0xc,%esp
801050e2:	56                   	push   %esi
801050e3:	e8 68 c9 ff ff       	call   80101a50 <iunlockput>
  iput(ip);
801050e8:	89 1c 24             	mov    %ebx,(%esp)
801050eb:	e8 00 c8 ff ff       	call   801018f0 <iput>
  end_op();
801050f0:	e8 0b de ff ff       	call   80102f00 <end_op>
  return 0;
801050f5:	83 c4 10             	add    $0x10,%esp
801050f8:	31 c0                	xor    %eax,%eax
}
801050fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050fd:	5b                   	pop    %ebx
801050fe:	5e                   	pop    %esi
801050ff:	5f                   	pop    %edi
80105100:	5d                   	pop    %ebp
80105101:	c3                   	ret
80105102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105108:	83 ec 0c             	sub    $0xc,%esp
8010510b:	56                   	push   %esi
8010510c:	e8 3f c9 ff ff       	call   80101a50 <iunlockput>
    goto bad;
80105111:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105114:	83 ec 0c             	sub    $0xc,%esp
80105117:	53                   	push   %ebx
80105118:	e8 a3 c6 ff ff       	call   801017c0 <ilock>
  ip->nlink--;
8010511d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105122:	89 1c 24             	mov    %ebx,(%esp)
80105125:	e8 e6 c5 ff ff       	call   80101710 <iupdate>
  iunlockput(ip);
8010512a:	89 1c 24             	mov    %ebx,(%esp)
8010512d:	e8 1e c9 ff ff       	call   80101a50 <iunlockput>
  end_op();
80105132:	e8 c9 dd ff ff       	call   80102f00 <end_op>
  return -1;
80105137:	83 c4 10             	add    $0x10,%esp
    return -1;
8010513a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513f:	eb b9                	jmp    801050fa <sys_link+0xda>
    iunlockput(ip);
80105141:	83 ec 0c             	sub    $0xc,%esp
80105144:	53                   	push   %ebx
80105145:	e8 06 c9 ff ff       	call   80101a50 <iunlockput>
    end_op();
8010514a:	e8 b1 dd ff ff       	call   80102f00 <end_op>
    return -1;
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	eb e6                	jmp    8010513a <sys_link+0x11a>
    end_op();
80105154:	e8 a7 dd ff ff       	call   80102f00 <end_op>
    return -1;
80105159:	eb df                	jmp    8010513a <sys_link+0x11a>
8010515b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010515f:	90                   	nop

80105160 <sys_unlink>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105165:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105168:	53                   	push   %ebx
80105169:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 ec f9 ff ff       	call   80104b60 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 54 01 00 00    	js     801052d3 <sys_unlink+0x173>
  begin_op();
8010517f:	e8 0c dd ff ff       	call   80102e90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105184:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105187:	83 ec 08             	sub    $0x8,%esp
8010518a:	53                   	push   %ebx
8010518b:	ff 75 c0             	push   -0x40(%ebp)
8010518e:	e8 2d cf ff ff       	call   801020c0 <nameiparent>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105199:	85 c0                	test   %eax,%eax
8010519b:	0f 84 58 01 00 00    	je     801052f9 <sys_unlink+0x199>
  ilock(dp);
801051a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	57                   	push   %edi
801051a8:	e8 13 c6 ff ff       	call   801017c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051ad:	58                   	pop    %eax
801051ae:	5a                   	pop    %edx
801051af:	68 94 76 10 80       	push   $0x80107694
801051b4:	53                   	push   %ebx
801051b5:	e8 36 cb ff ff       	call   80101cf0 <namecmp>
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	85 c0                	test   %eax,%eax
801051bf:	0f 84 fb 00 00 00    	je     801052c0 <sys_unlink+0x160>
801051c5:	83 ec 08             	sub    $0x8,%esp
801051c8:	68 93 76 10 80       	push   $0x80107693
801051cd:	53                   	push   %ebx
801051ce:	e8 1d cb ff ff       	call   80101cf0 <namecmp>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	85 c0                	test   %eax,%eax
801051d8:	0f 84 e2 00 00 00    	je     801052c0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801051de:	83 ec 04             	sub    $0x4,%esp
801051e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051e4:	50                   	push   %eax
801051e5:	53                   	push   %ebx
801051e6:	57                   	push   %edi
801051e7:	e8 24 cb ff ff       	call   80101d10 <dirlookup>
801051ec:	83 c4 10             	add    $0x10,%esp
801051ef:	89 c3                	mov    %eax,%ebx
801051f1:	85 c0                	test   %eax,%eax
801051f3:	0f 84 c7 00 00 00    	je     801052c0 <sys_unlink+0x160>
  ilock(ip);
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	50                   	push   %eax
801051fd:	e8 be c5 ff ff       	call   801017c0 <ilock>
  if(ip->nlink < 1)
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010520a:	0f 8e 0a 01 00 00    	jle    8010531a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105210:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105215:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105218:	74 66                	je     80105280 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010521a:	83 ec 04             	sub    $0x4,%esp
8010521d:	6a 10                	push   $0x10
8010521f:	6a 00                	push   $0x0
80105221:	57                   	push   %edi
80105222:	e8 c9 f5 ff ff       	call   801047f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105227:	6a 10                	push   $0x10
80105229:	ff 75 c4             	push   -0x3c(%ebp)
8010522c:	57                   	push   %edi
8010522d:	ff 75 b4             	push   -0x4c(%ebp)
80105230:	e8 9b c9 ff ff       	call   80101bd0 <writei>
80105235:	83 c4 20             	add    $0x20,%esp
80105238:	83 f8 10             	cmp    $0x10,%eax
8010523b:	0f 85 cc 00 00 00    	jne    8010530d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105241:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105246:	0f 84 94 00 00 00    	je     801052e0 <sys_unlink+0x180>
  iunlockput(dp);
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	ff 75 b4             	push   -0x4c(%ebp)
80105252:	e8 f9 c7 ff ff       	call   80101a50 <iunlockput>
  ip->nlink--;
80105257:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010525c:	89 1c 24             	mov    %ebx,(%esp)
8010525f:	e8 ac c4 ff ff       	call   80101710 <iupdate>
  iunlockput(ip);
80105264:	89 1c 24             	mov    %ebx,(%esp)
80105267:	e8 e4 c7 ff ff       	call   80101a50 <iunlockput>
  end_op();
8010526c:	e8 8f dc ff ff       	call   80102f00 <end_op>
  return 0;
80105271:	83 c4 10             	add    $0x10,%esp
80105274:	31 c0                	xor    %eax,%eax
}
80105276:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5f                   	pop    %edi
8010527c:	5d                   	pop    %ebp
8010527d:	c3                   	ret
8010527e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105280:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105284:	76 94                	jbe    8010521a <sys_unlink+0xba>
80105286:	be 20 00 00 00       	mov    $0x20,%esi
8010528b:	eb 0b                	jmp    80105298 <sys_unlink+0x138>
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
80105290:	83 c6 10             	add    $0x10,%esi
80105293:	3b 73 58             	cmp    0x58(%ebx),%esi
80105296:	73 82                	jae    8010521a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105298:	6a 10                	push   $0x10
8010529a:	56                   	push   %esi
8010529b:	57                   	push   %edi
8010529c:	53                   	push   %ebx
8010529d:	e8 2e c8 ff ff       	call   80101ad0 <readi>
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	83 f8 10             	cmp    $0x10,%eax
801052a8:	75 56                	jne    80105300 <sys_unlink+0x1a0>
    if(de.inum != 0)
801052aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052af:	74 df                	je     80105290 <sys_unlink+0x130>
    iunlockput(ip);
801052b1:	83 ec 0c             	sub    $0xc,%esp
801052b4:	53                   	push   %ebx
801052b5:	e8 96 c7 ff ff       	call   80101a50 <iunlockput>
    goto bad;
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	ff 75 b4             	push   -0x4c(%ebp)
801052c6:	e8 85 c7 ff ff       	call   80101a50 <iunlockput>
  end_op();
801052cb:	e8 30 dc ff ff       	call   80102f00 <end_op>
  return -1;
801052d0:	83 c4 10             	add    $0x10,%esp
    return -1;
801052d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d8:	eb 9c                	jmp    80105276 <sys_unlink+0x116>
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801052e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801052e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801052e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801052eb:	50                   	push   %eax
801052ec:	e8 1f c4 ff ff       	call   80101710 <iupdate>
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	e9 53 ff ff ff       	jmp    8010524c <sys_unlink+0xec>
    end_op();
801052f9:	e8 02 dc ff ff       	call   80102f00 <end_op>
    return -1;
801052fe:	eb d3                	jmp    801052d3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	68 b8 76 10 80       	push   $0x801076b8
80105308:	e8 73 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	68 ca 76 10 80       	push   $0x801076ca
80105315:	e8 66 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010531a:	83 ec 0c             	sub    $0xc,%esp
8010531d:	68 a6 76 10 80       	push   $0x801076a6
80105322:	e8 59 b0 ff ff       	call   80100380 <panic>
80105327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532e:	66 90                	xchg   %ax,%ax

80105330 <sys_open>:

int
sys_open(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105335:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105338:	53                   	push   %ebx
80105339:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010533c:	50                   	push   %eax
8010533d:	6a 00                	push   $0x0
8010533f:	e8 1c f8 ff ff       	call   80104b60 <argstr>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
80105349:	0f 88 8e 00 00 00    	js     801053dd <sys_open+0xad>
8010534f:	83 ec 08             	sub    $0x8,%esp
80105352:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105355:	50                   	push   %eax
80105356:	6a 01                	push   $0x1
80105358:	e8 43 f7 ff ff       	call   80104aa0 <argint>
8010535d:	83 c4 10             	add    $0x10,%esp
80105360:	85 c0                	test   %eax,%eax
80105362:	78 79                	js     801053dd <sys_open+0xad>
    return -1;

  begin_op();
80105364:	e8 27 db ff ff       	call   80102e90 <begin_op>

  if(omode & O_CREATE){
80105369:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010536d:	75 79                	jne    801053e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010536f:	83 ec 0c             	sub    $0xc,%esp
80105372:	ff 75 e0             	push   -0x20(%ebp)
80105375:	e8 26 cd ff ff       	call   801020a0 <namei>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	89 c6                	mov    %eax,%esi
8010537f:	85 c0                	test   %eax,%eax
80105381:	0f 84 7e 00 00 00    	je     80105405 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105387:	83 ec 0c             	sub    $0xc,%esp
8010538a:	50                   	push   %eax
8010538b:	e8 30 c4 ff ff       	call   801017c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105390:	83 c4 10             	add    $0x10,%esp
80105393:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105398:	0f 84 ba 00 00 00    	je     80105458 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010539e:	e8 cd ba ff ff       	call   80100e70 <filealloc>
801053a3:	89 c7                	mov    %eax,%edi
801053a5:	85 c0                	test   %eax,%eax
801053a7:	74 23                	je     801053cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801053a9:	e8 02 e7 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801053b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053b4:	85 d2                	test   %edx,%edx
801053b6:	74 58                	je     80105410 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801053b8:	83 c3 01             	add    $0x1,%ebx
801053bb:	83 fb 10             	cmp    $0x10,%ebx
801053be:	75 f0                	jne    801053b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	57                   	push   %edi
801053c4:	e8 67 bb ff ff       	call   80100f30 <fileclose>
801053c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053cc:	83 ec 0c             	sub    $0xc,%esp
801053cf:	56                   	push   %esi
801053d0:	e8 7b c6 ff ff       	call   80101a50 <iunlockput>
    end_op();
801053d5:	e8 26 db ff ff       	call   80102f00 <end_op>
    return -1;
801053da:	83 c4 10             	add    $0x10,%esp
    return -1;
801053dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053e2:	eb 65                	jmp    80105449 <sys_open+0x119>
801053e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801053e8:	83 ec 0c             	sub    $0xc,%esp
801053eb:	31 c9                	xor    %ecx,%ecx
801053ed:	ba 02 00 00 00       	mov    $0x2,%edx
801053f2:	6a 00                	push   $0x0
801053f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053f7:	e8 54 f8 ff ff       	call   80104c50 <create>
    if(ip == 0){
801053fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801053ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105401:	85 c0                	test   %eax,%eax
80105403:	75 99                	jne    8010539e <sys_open+0x6e>
      end_op();
80105405:	e8 f6 da ff ff       	call   80102f00 <end_op>
      return -1;
8010540a:	eb d1                	jmp    801053dd <sys_open+0xad>
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105410:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105413:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105417:	56                   	push   %esi
80105418:	e8 83 c4 ff ff       	call   801018a0 <iunlock>
  end_op();
8010541d:	e8 de da ff ff       	call   80102f00 <end_op>

  f->type = FD_INODE;
80105422:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105428:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010542b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010542e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105431:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105433:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010543a:	f7 d0                	not    %eax
8010543c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010543f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105442:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105445:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105449:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010544c:	89 d8                	mov    %ebx,%eax
8010544e:	5b                   	pop    %ebx
8010544f:	5e                   	pop    %esi
80105450:	5f                   	pop    %edi
80105451:	5d                   	pop    %ebp
80105452:	c3                   	ret
80105453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105457:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105458:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010545b:	85 c9                	test   %ecx,%ecx
8010545d:	0f 84 3b ff ff ff    	je     8010539e <sys_open+0x6e>
80105463:	e9 64 ff ff ff       	jmp    801053cc <sys_open+0x9c>
80105468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop

80105470 <sys_mkdir>:

int
sys_mkdir(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105476:	e8 15 da ff ff       	call   80102e90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010547b:	83 ec 08             	sub    $0x8,%esp
8010547e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105481:	50                   	push   %eax
80105482:	6a 00                	push   $0x0
80105484:	e8 d7 f6 ff ff       	call   80104b60 <argstr>
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	85 c0                	test   %eax,%eax
8010548e:	78 30                	js     801054c0 <sys_mkdir+0x50>
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105496:	31 c9                	xor    %ecx,%ecx
80105498:	ba 01 00 00 00       	mov    $0x1,%edx
8010549d:	6a 00                	push   $0x0
8010549f:	e8 ac f7 ff ff       	call   80104c50 <create>
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
801054a9:	74 15                	je     801054c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054ab:	83 ec 0c             	sub    $0xc,%esp
801054ae:	50                   	push   %eax
801054af:	e8 9c c5 ff ff       	call   80101a50 <iunlockput>
  end_op();
801054b4:	e8 47 da ff ff       	call   80102f00 <end_op>
  return 0;
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	31 c0                	xor    %eax,%eax
}
801054be:	c9                   	leave
801054bf:	c3                   	ret
    end_op();
801054c0:	e8 3b da ff ff       	call   80102f00 <end_op>
    return -1;
801054c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ca:	c9                   	leave
801054cb:	c3                   	ret
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054d0 <sys_mknod>:

int
sys_mknod(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054d6:	e8 b5 d9 ff ff       	call   80102e90 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054db:	83 ec 08             	sub    $0x8,%esp
801054de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054e1:	50                   	push   %eax
801054e2:	6a 00                	push   $0x0
801054e4:	e8 77 f6 ff ff       	call   80104b60 <argstr>
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	85 c0                	test   %eax,%eax
801054ee:	78 60                	js     80105550 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801054f0:	83 ec 08             	sub    $0x8,%esp
801054f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054f6:	50                   	push   %eax
801054f7:	6a 01                	push   $0x1
801054f9:	e8 a2 f5 ff ff       	call   80104aa0 <argint>
  if((argstr(0, &path)) < 0 ||
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	85 c0                	test   %eax,%eax
80105503:	78 4b                	js     80105550 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105505:	83 ec 08             	sub    $0x8,%esp
80105508:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010550b:	50                   	push   %eax
8010550c:	6a 02                	push   $0x2
8010550e:	e8 8d f5 ff ff       	call   80104aa0 <argint>
     argint(1, &major) < 0 ||
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	78 36                	js     80105550 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010551a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010551e:	83 ec 0c             	sub    $0xc,%esp
80105521:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105525:	ba 03 00 00 00       	mov    $0x3,%edx
8010552a:	50                   	push   %eax
8010552b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010552e:	e8 1d f7 ff ff       	call   80104c50 <create>
     argint(2, &minor) < 0 ||
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	74 16                	je     80105550 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010553a:	83 ec 0c             	sub    $0xc,%esp
8010553d:	50                   	push   %eax
8010553e:	e8 0d c5 ff ff       	call   80101a50 <iunlockput>
  end_op();
80105543:	e8 b8 d9 ff ff       	call   80102f00 <end_op>
  return 0;
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	31 c0                	xor    %eax,%eax
}
8010554d:	c9                   	leave
8010554e:	c3                   	ret
8010554f:	90                   	nop
    end_op();
80105550:	e8 ab d9 ff ff       	call   80102f00 <end_op>
    return -1;
80105555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010555a:	c9                   	leave
8010555b:	c3                   	ret
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_chdir>:

int
sys_chdir(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
80105565:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105568:	e8 43 e5 ff ff       	call   80103ab0 <myproc>
8010556d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010556f:	e8 1c d9 ff ff       	call   80102e90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105574:	83 ec 08             	sub    $0x8,%esp
80105577:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557a:	50                   	push   %eax
8010557b:	6a 00                	push   $0x0
8010557d:	e8 de f5 ff ff       	call   80104b60 <argstr>
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	85 c0                	test   %eax,%eax
80105587:	78 77                	js     80105600 <sys_chdir+0xa0>
80105589:	83 ec 0c             	sub    $0xc,%esp
8010558c:	ff 75 f4             	push   -0xc(%ebp)
8010558f:	e8 0c cb ff ff       	call   801020a0 <namei>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	89 c3                	mov    %eax,%ebx
80105599:	85 c0                	test   %eax,%eax
8010559b:	74 63                	je     80105600 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	50                   	push   %eax
801055a1:	e8 1a c2 ff ff       	call   801017c0 <ilock>
  if(ip->type != T_DIR){
801055a6:	83 c4 10             	add    $0x10,%esp
801055a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055ae:	75 30                	jne    801055e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055b0:	83 ec 0c             	sub    $0xc,%esp
801055b3:	53                   	push   %ebx
801055b4:	e8 e7 c2 ff ff       	call   801018a0 <iunlock>
  iput(curproc->cwd);
801055b9:	58                   	pop    %eax
801055ba:	ff 76 68             	push   0x68(%esi)
801055bd:	e8 2e c3 ff ff       	call   801018f0 <iput>
  end_op();
801055c2:	e8 39 d9 ff ff       	call   80102f00 <end_op>
  curproc->cwd = ip;
801055c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	31 c0                	xor    %eax,%eax
}
801055cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055d2:	5b                   	pop    %ebx
801055d3:	5e                   	pop    %esi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	53                   	push   %ebx
801055e4:	e8 67 c4 ff ff       	call   80101a50 <iunlockput>
    end_op();
801055e9:	e8 12 d9 ff ff       	call   80102f00 <end_op>
    return -1;
801055ee:	83 c4 10             	add    $0x10,%esp
    return -1;
801055f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f6:	eb d7                	jmp    801055cf <sys_chdir+0x6f>
801055f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
    end_op();
80105600:	e8 fb d8 ff ff       	call   80102f00 <end_op>
    return -1;
80105605:	eb ea                	jmp    801055f1 <sys_chdir+0x91>
80105607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560e:	66 90                	xchg   %ax,%ax

80105610 <sys_exec>:

int
sys_exec(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105615:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010561b:	53                   	push   %ebx
8010561c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105622:	50                   	push   %eax
80105623:	6a 00                	push   $0x0
80105625:	e8 36 f5 ff ff       	call   80104b60 <argstr>
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	85 c0                	test   %eax,%eax
8010562f:	0f 88 87 00 00 00    	js     801056bc <sys_exec+0xac>
80105635:	83 ec 08             	sub    $0x8,%esp
80105638:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010563e:	50                   	push   %eax
8010563f:	6a 01                	push   $0x1
80105641:	e8 5a f4 ff ff       	call   80104aa0 <argint>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	85 c0                	test   %eax,%eax
8010564b:	78 6f                	js     801056bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010564d:	83 ec 04             	sub    $0x4,%esp
80105650:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105656:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105658:	68 80 00 00 00       	push   $0x80
8010565d:	6a 00                	push   $0x0
8010565f:	56                   	push   %esi
80105660:	e8 8b f1 ff ff       	call   801047f0 <memset>
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105670:	83 ec 08             	sub    $0x8,%esp
80105673:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105679:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105680:	50                   	push   %eax
80105681:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105687:	01 f8                	add    %edi,%eax
80105689:	50                   	push   %eax
8010568a:	e8 81 f3 ff ff       	call   80104a10 <fetchint>
8010568f:	83 c4 10             	add    $0x10,%esp
80105692:	85 c0                	test   %eax,%eax
80105694:	78 26                	js     801056bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105696:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010569c:	85 c0                	test   %eax,%eax
8010569e:	74 30                	je     801056d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801056a6:	52                   	push   %edx
801056a7:	50                   	push   %eax
801056a8:	e8 a3 f3 ff ff       	call   80104a50 <fetchstr>
801056ad:	83 c4 10             	add    $0x10,%esp
801056b0:	85 c0                	test   %eax,%eax
801056b2:	78 08                	js     801056bc <sys_exec+0xac>
  for(i=0;; i++){
801056b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056b7:	83 fb 20             	cmp    $0x20,%ebx
801056ba:	75 b4                	jne    80105670 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c4:	5b                   	pop    %ebx
801056c5:	5e                   	pop    %esi
801056c6:	5f                   	pop    %edi
801056c7:	5d                   	pop    %ebp
801056c8:	c3                   	ret
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801056d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056d7:	00 00 00 00 
  return exec(path, argv);
801056db:	83 ec 08             	sub    $0x8,%esp
801056de:	56                   	push   %esi
801056df:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801056e5:	e8 e6 b3 ff ff       	call   80100ad0 <exec>
801056ea:	83 c4 10             	add    $0x10,%esp
}
801056ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f0:	5b                   	pop    %ebx
801056f1:	5e                   	pop    %esi
801056f2:	5f                   	pop    %edi
801056f3:	5d                   	pop    %ebp
801056f4:	c3                   	ret
801056f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_pipe>:

int
sys_pipe(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105705:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105708:	53                   	push   %ebx
80105709:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010570c:	6a 08                	push   $0x8
8010570e:	50                   	push   %eax
8010570f:	6a 00                	push   $0x0
80105711:	e8 da f3 ff ff       	call   80104af0 <argptr>
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	85 c0                	test   %eax,%eax
8010571b:	0f 88 8b 00 00 00    	js     801057ac <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105721:	83 ec 08             	sub    $0x8,%esp
80105724:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105727:	50                   	push   %eax
80105728:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010572b:	50                   	push   %eax
8010572c:	e8 2f de ff ff       	call   80103560 <pipealloc>
80105731:	83 c4 10             	add    $0x10,%esp
80105734:	85 c0                	test   %eax,%eax
80105736:	78 74                	js     801057ac <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105738:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010573b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010573d:	e8 6e e3 ff ff       	call   80103ab0 <myproc>
    if(curproc->ofile[fd] == 0){
80105742:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105746:	85 f6                	test   %esi,%esi
80105748:	74 16                	je     80105760 <sys_pipe+0x60>
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105750:	83 c3 01             	add    $0x1,%ebx
80105753:	83 fb 10             	cmp    $0x10,%ebx
80105756:	74 3d                	je     80105795 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105758:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010575c:	85 f6                	test   %esi,%esi
8010575e:	75 f0                	jne    80105750 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105760:	8d 73 08             	lea    0x8(%ebx),%esi
80105763:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105767:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010576a:	e8 41 e3 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010576f:	31 d2                	xor    %edx,%edx
80105771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105778:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010577c:	85 c9                	test   %ecx,%ecx
8010577e:	74 38                	je     801057b8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105780:	83 c2 01             	add    $0x1,%edx
80105783:	83 fa 10             	cmp    $0x10,%edx
80105786:	75 f0                	jne    80105778 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105788:	e8 23 e3 ff ff       	call   80103ab0 <myproc>
8010578d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105794:	00 
    fileclose(rf);
80105795:	83 ec 0c             	sub    $0xc,%esp
80105798:	ff 75 e0             	push   -0x20(%ebp)
8010579b:	e8 90 b7 ff ff       	call   80100f30 <fileclose>
    fileclose(wf);
801057a0:	58                   	pop    %eax
801057a1:	ff 75 e4             	push   -0x1c(%ebp)
801057a4:	e8 87 b7 ff ff       	call   80100f30 <fileclose>
    return -1;
801057a9:	83 c4 10             	add    $0x10,%esp
    return -1;
801057ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b1:	eb 16                	jmp    801057c9 <sys_pipe+0xc9>
801057b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057b7:	90                   	nop
      curproc->ofile[fd] = f;
801057b8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057bf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057c4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057c7:	31 c0                	xor    %eax,%eax
}
801057c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057cc:	5b                   	pop    %ebx
801057cd:	5e                   	pop    %esi
801057ce:	5f                   	pop    %edi
801057cf:	5d                   	pop    %ebp
801057d0:	c3                   	ret
801057d1:	66 90                	xchg   %ax,%ax
801057d3:	66 90                	xchg   %ax,%ax
801057d5:	66 90                	xchg   %ax,%ax
801057d7:	66 90                	xchg   %ax,%ax
801057d9:	66 90                	xchg   %ax,%ax
801057db:	66 90                	xchg   %ax,%ax
801057dd:	66 90                	xchg   %ax,%ax
801057df:	90                   	nop

801057e0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801057e0:	e9 6b e4 ff ff       	jmp    80103c50 <fork>
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_exit>:
}

int
sys_exit(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801057f6:	e8 c5 e6 ff ff       	call   80103ec0 <exit>
  return 0;  // not reached
}
801057fb:	31 c0                	xor    %eax,%eax
801057fd:	c9                   	leave
801057fe:	c3                   	ret
801057ff:	90                   	nop

80105800 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105800:	e9 eb e7 ff ff       	jmp    80103ff0 <wait>
80105805:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_kill>:
}

int
sys_kill(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105816:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105819:	50                   	push   %eax
8010581a:	6a 00                	push   $0x0
8010581c:	e8 7f f2 ff ff       	call   80104aa0 <argint>
80105821:	83 c4 10             	add    $0x10,%esp
80105824:	85 c0                	test   %eax,%eax
80105826:	78 18                	js     80105840 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	ff 75 f4             	push   -0xc(%ebp)
8010582e:	e8 5d ea ff ff       	call   80104290 <kill>
80105833:	83 c4 10             	add    $0x10,%esp
}
80105836:	c9                   	leave
80105837:	c3                   	ret
80105838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop
80105840:	c9                   	leave
    return -1;
80105841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105846:	c3                   	ret
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax

80105850 <sys_getpid>:

int
sys_getpid(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105856:	e8 55 e2 ff ff       	call   80103ab0 <myproc>
8010585b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010585e:	c9                   	leave
8010585f:	c3                   	ret

80105860 <sys_sbrk>:

int
sys_sbrk(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105864:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105867:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010586a:	50                   	push   %eax
8010586b:	6a 00                	push   $0x0
8010586d:	e8 2e f2 ff ff       	call   80104aa0 <argint>
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	85 c0                	test   %eax,%eax
80105877:	78 27                	js     801058a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105879:	e8 32 e2 ff ff       	call   80103ab0 <myproc>
  if(growproc(n) < 0)
8010587e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105881:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105883:	ff 75 f4             	push   -0xc(%ebp)
80105886:	e8 45 e3 ff ff       	call   80103bd0 <growproc>
8010588b:	83 c4 10             	add    $0x10,%esp
8010588e:	85 c0                	test   %eax,%eax
80105890:	78 0e                	js     801058a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105892:	89 d8                	mov    %ebx,%eax
80105894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105897:	c9                   	leave
80105898:	c3                   	ret
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058a5:	eb eb                	jmp    80105892 <sys_sbrk+0x32>
801058a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ae:	66 90                	xchg   %ax,%ax

801058b0 <sys_sleep>:

int
sys_sleep(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ba:	50                   	push   %eax
801058bb:	6a 00                	push   $0x0
801058bd:	e8 de f1 ff ff       	call   80104aa0 <argint>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	85 c0                	test   %eax,%eax
801058c7:	78 64                	js     8010592d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
801058c9:	83 ec 0c             	sub    $0xc,%esp
801058cc:	68 80 3c 11 80       	push   $0x80113c80
801058d1:	e8 1a ee ff ff       	call   801046f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801058d9:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
801058df:	83 c4 10             	add    $0x10,%esp
801058e2:	85 d2                	test   %edx,%edx
801058e4:	75 2b                	jne    80105911 <sys_sleep+0x61>
801058e6:	eb 58                	jmp    80105940 <sys_sleep+0x90>
801058e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ef:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058f0:	83 ec 08             	sub    $0x8,%esp
801058f3:	68 80 3c 11 80       	push   $0x80113c80
801058f8:	68 60 3c 11 80       	push   $0x80113c60
801058fd:	e8 6e e8 ff ff       	call   80104170 <sleep>
  while(ticks - ticks0 < n){
80105902:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105907:	83 c4 10             	add    $0x10,%esp
8010590a:	29 d8                	sub    %ebx,%eax
8010590c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010590f:	73 2f                	jae    80105940 <sys_sleep+0x90>
    if(myproc()->killed){
80105911:	e8 9a e1 ff ff       	call   80103ab0 <myproc>
80105916:	8b 40 24             	mov    0x24(%eax),%eax
80105919:	85 c0                	test   %eax,%eax
8010591b:	74 d3                	je     801058f0 <sys_sleep+0x40>
      release(&tickslock);
8010591d:	83 ec 0c             	sub    $0xc,%esp
80105920:	68 80 3c 11 80       	push   $0x80113c80
80105925:	e8 66 ed ff ff       	call   80104690 <release>
      return -1;
8010592a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010592d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105935:	c9                   	leave
80105936:	c3                   	ret
80105937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	68 80 3c 11 80       	push   $0x80113c80
80105948:	e8 43 ed ff ff       	call   80104690 <release>
}
8010594d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105950:	83 c4 10             	add    $0x10,%esp
80105953:	31 c0                	xor    %eax,%eax
}
80105955:	c9                   	leave
80105956:	c3                   	ret
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax

80105960 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
80105964:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105967:	68 80 3c 11 80       	push   $0x80113c80
8010596c:	e8 7f ed ff ff       	call   801046f0 <acquire>
  xticks = ticks;
80105971:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
80105977:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
8010597e:	e8 0d ed ff ff       	call   80104690 <release>
  return xticks;
}
80105983:	89 d8                	mov    %ebx,%eax
80105985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105988:	c9                   	leave
80105989:	c3                   	ret

8010598a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010598a:	1e                   	push   %ds
  pushl %es
8010598b:	06                   	push   %es
  pushl %fs
8010598c:	0f a0                	push   %fs
  pushl %gs
8010598e:	0f a8                	push   %gs
  pushal
80105990:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105991:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105995:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105997:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105999:	54                   	push   %esp
  call trap
8010599a:	e8 c1 00 00 00       	call   80105a60 <trap>
  addl $4, %esp
8010599f:	83 c4 04             	add    $0x4,%esp

801059a2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801059a2:	61                   	popa
  popl %gs
801059a3:	0f a9                	pop    %gs
  popl %fs
801059a5:	0f a1                	pop    %fs
  popl %es
801059a7:	07                   	pop    %es
  popl %ds
801059a8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801059a9:	83 c4 08             	add    $0x8,%esp
  iret
801059ac:	cf                   	iret
801059ad:	66 90                	xchg   %ax,%ax
801059af:	90                   	nop

801059b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801059b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801059b1:	31 c0                	xor    %eax,%eax
{
801059b3:	89 e5                	mov    %esp,%ebp
801059b5:	83 ec 08             	sub    $0x8,%esp
801059b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801059c0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801059c7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
801059ce:	08 00 00 8e 
801059d2:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
801059d9:	80 
801059da:	c1 ea 10             	shr    $0x10,%edx
801059dd:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
801059e4:	80 
  for(i = 0; i < 256; i++)
801059e5:	83 c0 01             	add    $0x1,%eax
801059e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801059ed:	75 d1                	jne    801059c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801059ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059f2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801059f7:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
801059fe:	00 00 ef 
  initlock(&tickslock, "time");
80105a01:	68 d9 76 10 80       	push   $0x801076d9
80105a06:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a0b:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105a11:	c1 e8 10             	shr    $0x10,%eax
80105a14:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105a1a:	e8 e1 ea ff ff       	call   80104500 <initlock>
}
80105a1f:	83 c4 10             	add    $0x10,%esp
80105a22:	c9                   	leave
80105a23:	c3                   	ret
80105a24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a2f:	90                   	nop

80105a30 <idtinit>:

void
idtinit(void)
{
80105a30:	55                   	push   %ebp
  pd[0] = size-1;
80105a31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a36:	89 e5                	mov    %esp,%ebp
80105a38:	83 ec 10             	sub    $0x10,%esp
80105a3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a3f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105a44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a48:	c1 e8 10             	shr    $0x10,%eax
80105a4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a55:	c9                   	leave
80105a56:	c3                   	ret
80105a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5e:	66 90                	xchg   %ax,%ax

80105a60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	56                   	push   %esi
80105a65:	53                   	push   %ebx
80105a66:	83 ec 1c             	sub    $0x1c,%esp
80105a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105a6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105a6f:	83 f8 40             	cmp    $0x40,%eax
80105a72:	0f 84 58 01 00 00    	je     80105bd0 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a78:	83 e8 20             	sub    $0x20,%eax
80105a7b:	83 f8 1f             	cmp    $0x1f,%eax
80105a7e:	0f 87 7c 00 00 00    	ja     80105b00 <trap+0xa0>
80105a84:	ff 24 85 b8 7c 10 80 	jmp    *-0x7fef8348(,%eax,4)
80105a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105a90:	e8 bb c7 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105a95:	e8 a6 cf ff ff       	call   80102a40 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a9a:	e8 11 e0 ff ff       	call   80103ab0 <myproc>
80105a9f:	85 c0                	test   %eax,%eax
80105aa1:	74 1a                	je     80105abd <trap+0x5d>
80105aa3:	e8 08 e0 ff ff       	call   80103ab0 <myproc>
80105aa8:	8b 50 24             	mov    0x24(%eax),%edx
80105aab:	85 d2                	test   %edx,%edx
80105aad:	74 0e                	je     80105abd <trap+0x5d>
80105aaf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ab3:	f7 d0                	not    %eax
80105ab5:	a8 03                	test   $0x3,%al
80105ab7:	0f 84 db 01 00 00    	je     80105c98 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105abd:	e8 ee df ff ff       	call   80103ab0 <myproc>
80105ac2:	85 c0                	test   %eax,%eax
80105ac4:	74 0f                	je     80105ad5 <trap+0x75>
80105ac6:	e8 e5 df ff ff       	call   80103ab0 <myproc>
80105acb:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105acf:	0f 84 ab 00 00 00    	je     80105b80 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ad5:	e8 d6 df ff ff       	call   80103ab0 <myproc>
80105ada:	85 c0                	test   %eax,%eax
80105adc:	74 1a                	je     80105af8 <trap+0x98>
80105ade:	e8 cd df ff ff       	call   80103ab0 <myproc>
80105ae3:	8b 40 24             	mov    0x24(%eax),%eax
80105ae6:	85 c0                	test   %eax,%eax
80105ae8:	74 0e                	je     80105af8 <trap+0x98>
80105aea:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105aee:	f7 d0                	not    %eax
80105af0:	a8 03                	test   $0x3,%al
80105af2:	0f 84 05 01 00 00    	je     80105bfd <trap+0x19d>
    exit();
}
80105af8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105afb:	5b                   	pop    %ebx
80105afc:	5e                   	pop    %esi
80105afd:	5f                   	pop    %edi
80105afe:	5d                   	pop    %ebp
80105aff:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b00:	e8 ab df ff ff       	call   80103ab0 <myproc>
80105b05:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b08:	85 c0                	test   %eax,%eax
80105b0a:	0f 84 a2 01 00 00    	je     80105cb2 <trap+0x252>
80105b10:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b14:	0f 84 98 01 00 00    	je     80105cb2 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b1a:	0f 20 d1             	mov    %cr2,%ecx
80105b1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b20:	e8 6b df ff ff       	call   80103a90 <cpuid>
80105b25:	8b 73 30             	mov    0x30(%ebx),%esi
80105b28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b2b:	8b 43 34             	mov    0x34(%ebx),%eax
80105b2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105b31:	e8 7a df ff ff       	call   80103ab0 <myproc>
80105b36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b39:	e8 72 df ff ff       	call   80103ab0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b41:	51                   	push   %ecx
80105b42:	57                   	push   %edi
80105b43:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b46:	52                   	push   %edx
80105b47:	ff 75 e4             	push   -0x1c(%ebp)
80105b4a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105b4b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105b4e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b51:	56                   	push   %esi
80105b52:	ff 70 10             	push   0x10(%eax)
80105b55:	68 28 79 10 80       	push   $0x80107928
80105b5a:	e8 51 ab ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105b5f:	83 c4 20             	add    $0x20,%esp
80105b62:	e8 49 df ff ff       	call   80103ab0 <myproc>
80105b67:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b6e:	e8 3d df ff ff       	call   80103ab0 <myproc>
80105b73:	85 c0                	test   %eax,%eax
80105b75:	0f 85 28 ff ff ff    	jne    80105aa3 <trap+0x43>
80105b7b:	e9 3d ff ff ff       	jmp    80105abd <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105b80:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b84:	0f 85 4b ff ff ff    	jne    80105ad5 <trap+0x75>
    yield();
80105b8a:	e8 91 e5 ff ff       	call   80104120 <yield>
80105b8f:	e9 41 ff ff ff       	jmp    80105ad5 <trap+0x75>
80105b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b98:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b9b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b9f:	e8 ec de ff ff       	call   80103a90 <cpuid>
80105ba4:	57                   	push   %edi
80105ba5:	56                   	push   %esi
80105ba6:	50                   	push   %eax
80105ba7:	68 d0 78 10 80       	push   $0x801078d0
80105bac:	e8 ff aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105bb1:	e8 8a ce ff ff       	call   80102a40 <lapiceoi>
    break;
80105bb6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bb9:	e8 f2 de ff ff       	call   80103ab0 <myproc>
80105bbe:	85 c0                	test   %eax,%eax
80105bc0:	0f 85 dd fe ff ff    	jne    80105aa3 <trap+0x43>
80105bc6:	e9 f2 fe ff ff       	jmp    80105abd <trap+0x5d>
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop
    if(myproc()->killed)
80105bd0:	e8 db de ff ff       	call   80103ab0 <myproc>
80105bd5:	8b 70 24             	mov    0x24(%eax),%esi
80105bd8:	85 f6                	test   %esi,%esi
80105bda:	0f 85 c8 00 00 00    	jne    80105ca8 <trap+0x248>
    myproc()->tf = tf;
80105be0:	e8 cb de ff ff       	call   80103ab0 <myproc>
80105be5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105be8:	e8 f3 ef ff ff       	call   80104be0 <syscall>
    if(myproc()->killed)
80105bed:	e8 be de ff ff       	call   80103ab0 <myproc>
80105bf2:	8b 48 24             	mov    0x24(%eax),%ecx
80105bf5:	85 c9                	test   %ecx,%ecx
80105bf7:	0f 84 fb fe ff ff    	je     80105af8 <trap+0x98>
}
80105bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c00:	5b                   	pop    %ebx
80105c01:	5e                   	pop    %esi
80105c02:	5f                   	pop    %edi
80105c03:	5d                   	pop    %ebp
      exit();
80105c04:	e9 b7 e2 ff ff       	jmp    80103ec0 <exit>
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c10:	e8 4b 02 00 00       	call   80105e60 <uartintr>
    lapiceoi();
80105c15:	e8 26 ce ff ff       	call   80102a40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c1a:	e8 91 de ff ff       	call   80103ab0 <myproc>
80105c1f:	85 c0                	test   %eax,%eax
80105c21:	0f 85 7c fe ff ff    	jne    80105aa3 <trap+0x43>
80105c27:	e9 91 fe ff ff       	jmp    80105abd <trap+0x5d>
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c30:	e8 1b cc ff ff       	call   80102850 <kbdintr>
    lapiceoi();
80105c35:	e8 06 ce ff ff       	call   80102a40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c3a:	e8 71 de ff ff       	call   80103ab0 <myproc>
80105c3f:	85 c0                	test   %eax,%eax
80105c41:	0f 85 5c fe ff ff    	jne    80105aa3 <trap+0x43>
80105c47:	e9 71 fe ff ff       	jmp    80105abd <trap+0x5d>
80105c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105c50:	e8 3b de ff ff       	call   80103a90 <cpuid>
80105c55:	85 c0                	test   %eax,%eax
80105c57:	0f 85 38 fe ff ff    	jne    80105a95 <trap+0x35>
      acquire(&tickslock);
80105c5d:	83 ec 0c             	sub    $0xc,%esp
80105c60:	68 80 3c 11 80       	push   $0x80113c80
80105c65:	e8 86 ea ff ff       	call   801046f0 <acquire>
      ticks++;
80105c6a:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105c71:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105c78:	e8 b3 e5 ff ff       	call   80104230 <wakeup>
      release(&tickslock);
80105c7d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105c84:	e8 07 ea ff ff       	call   80104690 <release>
80105c89:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105c8c:	e9 04 fe ff ff       	jmp    80105a95 <trap+0x35>
80105c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105c98:	e8 23 e2 ff ff       	call   80103ec0 <exit>
80105c9d:	e9 1b fe ff ff       	jmp    80105abd <trap+0x5d>
80105ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ca8:	e8 13 e2 ff ff       	call   80103ec0 <exit>
80105cad:	e9 2e ff ff ff       	jmp    80105be0 <trap+0x180>
80105cb2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105cb5:	e8 d6 dd ff ff       	call   80103a90 <cpuid>
80105cba:	83 ec 0c             	sub    $0xc,%esp
80105cbd:	56                   	push   %esi
80105cbe:	57                   	push   %edi
80105cbf:	50                   	push   %eax
80105cc0:	ff 73 30             	push   0x30(%ebx)
80105cc3:	68 f4 78 10 80       	push   $0x801078f4
80105cc8:	e8 e3 a9 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105ccd:	83 c4 14             	add    $0x14,%esp
80105cd0:	68 de 76 10 80       	push   $0x801076de
80105cd5:	e8 a6 a6 ff ff       	call   80100380 <panic>
80105cda:	66 90                	xchg   %ax,%ax
80105cdc:	66 90                	xchg   %ax,%ax
80105cde:	66 90                	xchg   %ax,%ax

80105ce0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ce0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	74 17                	je     80105d00 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ce9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105cef:	a8 01                	test   $0x1,%al
80105cf1:	74 0d                	je     80105d00 <uartgetc+0x20>
80105cf3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cf8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105cf9:	0f b6 c0             	movzbl %al,%eax
80105cfc:	c3                   	ret
80105cfd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d05:	c3                   	ret
80105d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi

80105d10 <uartinit>:
{
80105d10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d11:	31 c9                	xor    %ecx,%ecx
80105d13:	89 c8                	mov    %ecx,%eax
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	57                   	push   %edi
80105d18:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105d1d:	56                   	push   %esi
80105d1e:	89 fa                	mov    %edi,%edx
80105d20:	53                   	push   %ebx
80105d21:	83 ec 1c             	sub    $0x1c,%esp
80105d24:	ee                   	out    %al,(%dx)
80105d25:	be fb 03 00 00       	mov    $0x3fb,%esi
80105d2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d2f:	89 f2                	mov    %esi,%edx
80105d31:	ee                   	out    %al,(%dx)
80105d32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d3c:	ee                   	out    %al,(%dx)
80105d3d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105d42:	89 c8                	mov    %ecx,%eax
80105d44:	89 da                	mov    %ebx,%edx
80105d46:	ee                   	out    %al,(%dx)
80105d47:	b8 03 00 00 00       	mov    $0x3,%eax
80105d4c:	89 f2                	mov    %esi,%edx
80105d4e:	ee                   	out    %al,(%dx)
80105d4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d54:	89 c8                	mov    %ecx,%eax
80105d56:	ee                   	out    %al,(%dx)
80105d57:	b8 01 00 00 00       	mov    $0x1,%eax
80105d5c:	89 da                	mov    %ebx,%edx
80105d5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d65:	3c ff                	cmp    $0xff,%al
80105d67:	0f 84 7c 00 00 00    	je     80105de9 <uartinit+0xd9>
  uart = 1;
80105d6d:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105d74:	00 00 00 
80105d77:	89 fa                	mov    %edi,%edx
80105d79:	ec                   	in     (%dx),%al
80105d7a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d7f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d80:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d83:	bf e3 76 10 80       	mov    $0x801076e3,%edi
80105d88:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105d8d:	6a 00                	push   $0x0
80105d8f:	6a 04                	push   $0x4
80105d91:	e8 ea c6 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105d96:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105d9a:	83 c4 10             	add    $0x10,%esp
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105da0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105da5:	85 c0                	test   %eax,%eax
80105da7:	74 32                	je     80105ddb <uartinit+0xcb>
80105da9:	89 f2                	mov    %esi,%edx
80105dab:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dac:	a8 20                	test   $0x20,%al
80105dae:	75 21                	jne    80105dd1 <uartinit+0xc1>
80105db0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105db5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105db8:	83 ec 0c             	sub    $0xc,%esp
80105dbb:	6a 0a                	push   $0xa
80105dbd:	e8 9e cc ff ff       	call   80102a60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dc2:	83 c4 10             	add    $0x10,%esp
80105dc5:	83 eb 01             	sub    $0x1,%ebx
80105dc8:	74 07                	je     80105dd1 <uartinit+0xc1>
80105dca:	89 f2                	mov    %esi,%edx
80105dcc:	ec                   	in     (%dx),%al
80105dcd:	a8 20                	test   $0x20,%al
80105dcf:	74 e7                	je     80105db8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dd1:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dd6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105dda:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105ddb:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105ddf:	83 c7 01             	add    $0x1,%edi
80105de2:	88 45 e7             	mov    %al,-0x19(%ebp)
80105de5:	84 c0                	test   %al,%al
80105de7:	75 b7                	jne    80105da0 <uartinit+0x90>
}
80105de9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dec:	5b                   	pop    %ebx
80105ded:	5e                   	pop    %esi
80105dee:	5f                   	pop    %edi
80105def:	5d                   	pop    %ebp
80105df0:	c3                   	ret
80105df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dff:	90                   	nop

80105e00 <uartputc>:
  if(!uart)
80105e00:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105e05:	85 c0                	test   %eax,%eax
80105e07:	74 4f                	je     80105e58 <uartputc+0x58>
{
80105e09:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e0a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e0f:	89 e5                	mov    %esp,%ebp
80105e11:	56                   	push   %esi
80105e12:	53                   	push   %ebx
80105e13:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e14:	a8 20                	test   $0x20,%al
80105e16:	75 29                	jne    80105e41 <uartputc+0x41>
80105e18:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105e28:	83 ec 0c             	sub    $0xc,%esp
80105e2b:	6a 0a                	push   $0xa
80105e2d:	e8 2e cc ff ff       	call   80102a60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e32:	83 c4 10             	add    $0x10,%esp
80105e35:	83 eb 01             	sub    $0x1,%ebx
80105e38:	74 07                	je     80105e41 <uartputc+0x41>
80105e3a:	89 f2                	mov    %esi,%edx
80105e3c:	ec                   	in     (%dx),%al
80105e3d:	a8 20                	test   $0x20,%al
80105e3f:	74 e7                	je     80105e28 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e41:	8b 45 08             	mov    0x8(%ebp),%eax
80105e44:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e49:	ee                   	out    %al,(%dx)
}
80105e4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e4d:	5b                   	pop    %ebx
80105e4e:	5e                   	pop    %esi
80105e4f:	5d                   	pop    %ebp
80105e50:	c3                   	ret
80105e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e58:	c3                   	ret
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e60 <uartintr>:

void
uartintr(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e66:	68 e0 5c 10 80       	push   $0x80105ce0
80105e6b:	e8 50 aa ff ff       	call   801008c0 <consoleintr>
}
80105e70:	83 c4 10             	add    $0x10,%esp
80105e73:	c9                   	leave
80105e74:	c3                   	ret

80105e75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $0
80105e77:	6a 00                	push   $0x0
  jmp alltraps
80105e79:	e9 0c fb ff ff       	jmp    8010598a <alltraps>

80105e7e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $1
80105e80:	6a 01                	push   $0x1
  jmp alltraps
80105e82:	e9 03 fb ff ff       	jmp    8010598a <alltraps>

80105e87 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $2
80105e89:	6a 02                	push   $0x2
  jmp alltraps
80105e8b:	e9 fa fa ff ff       	jmp    8010598a <alltraps>

80105e90 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $3
80105e92:	6a 03                	push   $0x3
  jmp alltraps
80105e94:	e9 f1 fa ff ff       	jmp    8010598a <alltraps>

80105e99 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $4
80105e9b:	6a 04                	push   $0x4
  jmp alltraps
80105e9d:	e9 e8 fa ff ff       	jmp    8010598a <alltraps>

80105ea2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $5
80105ea4:	6a 05                	push   $0x5
  jmp alltraps
80105ea6:	e9 df fa ff ff       	jmp    8010598a <alltraps>

80105eab <vector6>:
.globl vector6
vector6:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $6
80105ead:	6a 06                	push   $0x6
  jmp alltraps
80105eaf:	e9 d6 fa ff ff       	jmp    8010598a <alltraps>

80105eb4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $7
80105eb6:	6a 07                	push   $0x7
  jmp alltraps
80105eb8:	e9 cd fa ff ff       	jmp    8010598a <alltraps>

80105ebd <vector8>:
.globl vector8
vector8:
  pushl $8
80105ebd:	6a 08                	push   $0x8
  jmp alltraps
80105ebf:	e9 c6 fa ff ff       	jmp    8010598a <alltraps>

80105ec4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $9
80105ec6:	6a 09                	push   $0x9
  jmp alltraps
80105ec8:	e9 bd fa ff ff       	jmp    8010598a <alltraps>

80105ecd <vector10>:
.globl vector10
vector10:
  pushl $10
80105ecd:	6a 0a                	push   $0xa
  jmp alltraps
80105ecf:	e9 b6 fa ff ff       	jmp    8010598a <alltraps>

80105ed4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105ed4:	6a 0b                	push   $0xb
  jmp alltraps
80105ed6:	e9 af fa ff ff       	jmp    8010598a <alltraps>

80105edb <vector12>:
.globl vector12
vector12:
  pushl $12
80105edb:	6a 0c                	push   $0xc
  jmp alltraps
80105edd:	e9 a8 fa ff ff       	jmp    8010598a <alltraps>

80105ee2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ee2:	6a 0d                	push   $0xd
  jmp alltraps
80105ee4:	e9 a1 fa ff ff       	jmp    8010598a <alltraps>

80105ee9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ee9:	6a 0e                	push   $0xe
  jmp alltraps
80105eeb:	e9 9a fa ff ff       	jmp    8010598a <alltraps>

80105ef0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $15
80105ef2:	6a 0f                	push   $0xf
  jmp alltraps
80105ef4:	e9 91 fa ff ff       	jmp    8010598a <alltraps>

80105ef9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $16
80105efb:	6a 10                	push   $0x10
  jmp alltraps
80105efd:	e9 88 fa ff ff       	jmp    8010598a <alltraps>

80105f02 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f02:	6a 11                	push   $0x11
  jmp alltraps
80105f04:	e9 81 fa ff ff       	jmp    8010598a <alltraps>

80105f09 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $18
80105f0b:	6a 12                	push   $0x12
  jmp alltraps
80105f0d:	e9 78 fa ff ff       	jmp    8010598a <alltraps>

80105f12 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $19
80105f14:	6a 13                	push   $0x13
  jmp alltraps
80105f16:	e9 6f fa ff ff       	jmp    8010598a <alltraps>

80105f1b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $20
80105f1d:	6a 14                	push   $0x14
  jmp alltraps
80105f1f:	e9 66 fa ff ff       	jmp    8010598a <alltraps>

80105f24 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $21
80105f26:	6a 15                	push   $0x15
  jmp alltraps
80105f28:	e9 5d fa ff ff       	jmp    8010598a <alltraps>

80105f2d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $22
80105f2f:	6a 16                	push   $0x16
  jmp alltraps
80105f31:	e9 54 fa ff ff       	jmp    8010598a <alltraps>

80105f36 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $23
80105f38:	6a 17                	push   $0x17
  jmp alltraps
80105f3a:	e9 4b fa ff ff       	jmp    8010598a <alltraps>

80105f3f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $24
80105f41:	6a 18                	push   $0x18
  jmp alltraps
80105f43:	e9 42 fa ff ff       	jmp    8010598a <alltraps>

80105f48 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $25
80105f4a:	6a 19                	push   $0x19
  jmp alltraps
80105f4c:	e9 39 fa ff ff       	jmp    8010598a <alltraps>

80105f51 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $26
80105f53:	6a 1a                	push   $0x1a
  jmp alltraps
80105f55:	e9 30 fa ff ff       	jmp    8010598a <alltraps>

80105f5a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $27
80105f5c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f5e:	e9 27 fa ff ff       	jmp    8010598a <alltraps>

80105f63 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $28
80105f65:	6a 1c                	push   $0x1c
  jmp alltraps
80105f67:	e9 1e fa ff ff       	jmp    8010598a <alltraps>

80105f6c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $29
80105f6e:	6a 1d                	push   $0x1d
  jmp alltraps
80105f70:	e9 15 fa ff ff       	jmp    8010598a <alltraps>

80105f75 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $30
80105f77:	6a 1e                	push   $0x1e
  jmp alltraps
80105f79:	e9 0c fa ff ff       	jmp    8010598a <alltraps>

80105f7e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $31
80105f80:	6a 1f                	push   $0x1f
  jmp alltraps
80105f82:	e9 03 fa ff ff       	jmp    8010598a <alltraps>

80105f87 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $32
80105f89:	6a 20                	push   $0x20
  jmp alltraps
80105f8b:	e9 fa f9 ff ff       	jmp    8010598a <alltraps>

80105f90 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $33
80105f92:	6a 21                	push   $0x21
  jmp alltraps
80105f94:	e9 f1 f9 ff ff       	jmp    8010598a <alltraps>

80105f99 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $34
80105f9b:	6a 22                	push   $0x22
  jmp alltraps
80105f9d:	e9 e8 f9 ff ff       	jmp    8010598a <alltraps>

80105fa2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $35
80105fa4:	6a 23                	push   $0x23
  jmp alltraps
80105fa6:	e9 df f9 ff ff       	jmp    8010598a <alltraps>

80105fab <vector36>:
.globl vector36
vector36:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $36
80105fad:	6a 24                	push   $0x24
  jmp alltraps
80105faf:	e9 d6 f9 ff ff       	jmp    8010598a <alltraps>

80105fb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $37
80105fb6:	6a 25                	push   $0x25
  jmp alltraps
80105fb8:	e9 cd f9 ff ff       	jmp    8010598a <alltraps>

80105fbd <vector38>:
.globl vector38
vector38:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $38
80105fbf:	6a 26                	push   $0x26
  jmp alltraps
80105fc1:	e9 c4 f9 ff ff       	jmp    8010598a <alltraps>

80105fc6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $39
80105fc8:	6a 27                	push   $0x27
  jmp alltraps
80105fca:	e9 bb f9 ff ff       	jmp    8010598a <alltraps>

80105fcf <vector40>:
.globl vector40
vector40:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $40
80105fd1:	6a 28                	push   $0x28
  jmp alltraps
80105fd3:	e9 b2 f9 ff ff       	jmp    8010598a <alltraps>

80105fd8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $41
80105fda:	6a 29                	push   $0x29
  jmp alltraps
80105fdc:	e9 a9 f9 ff ff       	jmp    8010598a <alltraps>

80105fe1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $42
80105fe3:	6a 2a                	push   $0x2a
  jmp alltraps
80105fe5:	e9 a0 f9 ff ff       	jmp    8010598a <alltraps>

80105fea <vector43>:
.globl vector43
vector43:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $43
80105fec:	6a 2b                	push   $0x2b
  jmp alltraps
80105fee:	e9 97 f9 ff ff       	jmp    8010598a <alltraps>

80105ff3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $44
80105ff5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ff7:	e9 8e f9 ff ff       	jmp    8010598a <alltraps>

80105ffc <vector45>:
.globl vector45
vector45:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $45
80105ffe:	6a 2d                	push   $0x2d
  jmp alltraps
80106000:	e9 85 f9 ff ff       	jmp    8010598a <alltraps>

80106005 <vector46>:
.globl vector46
vector46:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $46
80106007:	6a 2e                	push   $0x2e
  jmp alltraps
80106009:	e9 7c f9 ff ff       	jmp    8010598a <alltraps>

8010600e <vector47>:
.globl vector47
vector47:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $47
80106010:	6a 2f                	push   $0x2f
  jmp alltraps
80106012:	e9 73 f9 ff ff       	jmp    8010598a <alltraps>

80106017 <vector48>:
.globl vector48
vector48:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $48
80106019:	6a 30                	push   $0x30
  jmp alltraps
8010601b:	e9 6a f9 ff ff       	jmp    8010598a <alltraps>

80106020 <vector49>:
.globl vector49
vector49:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $49
80106022:	6a 31                	push   $0x31
  jmp alltraps
80106024:	e9 61 f9 ff ff       	jmp    8010598a <alltraps>

80106029 <vector50>:
.globl vector50
vector50:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $50
8010602b:	6a 32                	push   $0x32
  jmp alltraps
8010602d:	e9 58 f9 ff ff       	jmp    8010598a <alltraps>

80106032 <vector51>:
.globl vector51
vector51:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $51
80106034:	6a 33                	push   $0x33
  jmp alltraps
80106036:	e9 4f f9 ff ff       	jmp    8010598a <alltraps>

8010603b <vector52>:
.globl vector52
vector52:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $52
8010603d:	6a 34                	push   $0x34
  jmp alltraps
8010603f:	e9 46 f9 ff ff       	jmp    8010598a <alltraps>

80106044 <vector53>:
.globl vector53
vector53:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $53
80106046:	6a 35                	push   $0x35
  jmp alltraps
80106048:	e9 3d f9 ff ff       	jmp    8010598a <alltraps>

8010604d <vector54>:
.globl vector54
vector54:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $54
8010604f:	6a 36                	push   $0x36
  jmp alltraps
80106051:	e9 34 f9 ff ff       	jmp    8010598a <alltraps>

80106056 <vector55>:
.globl vector55
vector55:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $55
80106058:	6a 37                	push   $0x37
  jmp alltraps
8010605a:	e9 2b f9 ff ff       	jmp    8010598a <alltraps>

8010605f <vector56>:
.globl vector56
vector56:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $56
80106061:	6a 38                	push   $0x38
  jmp alltraps
80106063:	e9 22 f9 ff ff       	jmp    8010598a <alltraps>

80106068 <vector57>:
.globl vector57
vector57:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $57
8010606a:	6a 39                	push   $0x39
  jmp alltraps
8010606c:	e9 19 f9 ff ff       	jmp    8010598a <alltraps>

80106071 <vector58>:
.globl vector58
vector58:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $58
80106073:	6a 3a                	push   $0x3a
  jmp alltraps
80106075:	e9 10 f9 ff ff       	jmp    8010598a <alltraps>

8010607a <vector59>:
.globl vector59
vector59:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $59
8010607c:	6a 3b                	push   $0x3b
  jmp alltraps
8010607e:	e9 07 f9 ff ff       	jmp    8010598a <alltraps>

80106083 <vector60>:
.globl vector60
vector60:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $60
80106085:	6a 3c                	push   $0x3c
  jmp alltraps
80106087:	e9 fe f8 ff ff       	jmp    8010598a <alltraps>

8010608c <vector61>:
.globl vector61
vector61:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $61
8010608e:	6a 3d                	push   $0x3d
  jmp alltraps
80106090:	e9 f5 f8 ff ff       	jmp    8010598a <alltraps>

80106095 <vector62>:
.globl vector62
vector62:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $62
80106097:	6a 3e                	push   $0x3e
  jmp alltraps
80106099:	e9 ec f8 ff ff       	jmp    8010598a <alltraps>

8010609e <vector63>:
.globl vector63
vector63:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $63
801060a0:	6a 3f                	push   $0x3f
  jmp alltraps
801060a2:	e9 e3 f8 ff ff       	jmp    8010598a <alltraps>

801060a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $64
801060a9:	6a 40                	push   $0x40
  jmp alltraps
801060ab:	e9 da f8 ff ff       	jmp    8010598a <alltraps>

801060b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $65
801060b2:	6a 41                	push   $0x41
  jmp alltraps
801060b4:	e9 d1 f8 ff ff       	jmp    8010598a <alltraps>

801060b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $66
801060bb:	6a 42                	push   $0x42
  jmp alltraps
801060bd:	e9 c8 f8 ff ff       	jmp    8010598a <alltraps>

801060c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $67
801060c4:	6a 43                	push   $0x43
  jmp alltraps
801060c6:	e9 bf f8 ff ff       	jmp    8010598a <alltraps>

801060cb <vector68>:
.globl vector68
vector68:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $68
801060cd:	6a 44                	push   $0x44
  jmp alltraps
801060cf:	e9 b6 f8 ff ff       	jmp    8010598a <alltraps>

801060d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $69
801060d6:	6a 45                	push   $0x45
  jmp alltraps
801060d8:	e9 ad f8 ff ff       	jmp    8010598a <alltraps>

801060dd <vector70>:
.globl vector70
vector70:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $70
801060df:	6a 46                	push   $0x46
  jmp alltraps
801060e1:	e9 a4 f8 ff ff       	jmp    8010598a <alltraps>

801060e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $71
801060e8:	6a 47                	push   $0x47
  jmp alltraps
801060ea:	e9 9b f8 ff ff       	jmp    8010598a <alltraps>

801060ef <vector72>:
.globl vector72
vector72:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $72
801060f1:	6a 48                	push   $0x48
  jmp alltraps
801060f3:	e9 92 f8 ff ff       	jmp    8010598a <alltraps>

801060f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $73
801060fa:	6a 49                	push   $0x49
  jmp alltraps
801060fc:	e9 89 f8 ff ff       	jmp    8010598a <alltraps>

80106101 <vector74>:
.globl vector74
vector74:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $74
80106103:	6a 4a                	push   $0x4a
  jmp alltraps
80106105:	e9 80 f8 ff ff       	jmp    8010598a <alltraps>

8010610a <vector75>:
.globl vector75
vector75:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $75
8010610c:	6a 4b                	push   $0x4b
  jmp alltraps
8010610e:	e9 77 f8 ff ff       	jmp    8010598a <alltraps>

80106113 <vector76>:
.globl vector76
vector76:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $76
80106115:	6a 4c                	push   $0x4c
  jmp alltraps
80106117:	e9 6e f8 ff ff       	jmp    8010598a <alltraps>

8010611c <vector77>:
.globl vector77
vector77:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $77
8010611e:	6a 4d                	push   $0x4d
  jmp alltraps
80106120:	e9 65 f8 ff ff       	jmp    8010598a <alltraps>

80106125 <vector78>:
.globl vector78
vector78:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $78
80106127:	6a 4e                	push   $0x4e
  jmp alltraps
80106129:	e9 5c f8 ff ff       	jmp    8010598a <alltraps>

8010612e <vector79>:
.globl vector79
vector79:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $79
80106130:	6a 4f                	push   $0x4f
  jmp alltraps
80106132:	e9 53 f8 ff ff       	jmp    8010598a <alltraps>

80106137 <vector80>:
.globl vector80
vector80:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $80
80106139:	6a 50                	push   $0x50
  jmp alltraps
8010613b:	e9 4a f8 ff ff       	jmp    8010598a <alltraps>

80106140 <vector81>:
.globl vector81
vector81:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $81
80106142:	6a 51                	push   $0x51
  jmp alltraps
80106144:	e9 41 f8 ff ff       	jmp    8010598a <alltraps>

80106149 <vector82>:
.globl vector82
vector82:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $82
8010614b:	6a 52                	push   $0x52
  jmp alltraps
8010614d:	e9 38 f8 ff ff       	jmp    8010598a <alltraps>

80106152 <vector83>:
.globl vector83
vector83:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $83
80106154:	6a 53                	push   $0x53
  jmp alltraps
80106156:	e9 2f f8 ff ff       	jmp    8010598a <alltraps>

8010615b <vector84>:
.globl vector84
vector84:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $84
8010615d:	6a 54                	push   $0x54
  jmp alltraps
8010615f:	e9 26 f8 ff ff       	jmp    8010598a <alltraps>

80106164 <vector85>:
.globl vector85
vector85:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $85
80106166:	6a 55                	push   $0x55
  jmp alltraps
80106168:	e9 1d f8 ff ff       	jmp    8010598a <alltraps>

8010616d <vector86>:
.globl vector86
vector86:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $86
8010616f:	6a 56                	push   $0x56
  jmp alltraps
80106171:	e9 14 f8 ff ff       	jmp    8010598a <alltraps>

80106176 <vector87>:
.globl vector87
vector87:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $87
80106178:	6a 57                	push   $0x57
  jmp alltraps
8010617a:	e9 0b f8 ff ff       	jmp    8010598a <alltraps>

8010617f <vector88>:
.globl vector88
vector88:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $88
80106181:	6a 58                	push   $0x58
  jmp alltraps
80106183:	e9 02 f8 ff ff       	jmp    8010598a <alltraps>

80106188 <vector89>:
.globl vector89
vector89:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $89
8010618a:	6a 59                	push   $0x59
  jmp alltraps
8010618c:	e9 f9 f7 ff ff       	jmp    8010598a <alltraps>

80106191 <vector90>:
.globl vector90
vector90:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $90
80106193:	6a 5a                	push   $0x5a
  jmp alltraps
80106195:	e9 f0 f7 ff ff       	jmp    8010598a <alltraps>

8010619a <vector91>:
.globl vector91
vector91:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $91
8010619c:	6a 5b                	push   $0x5b
  jmp alltraps
8010619e:	e9 e7 f7 ff ff       	jmp    8010598a <alltraps>

801061a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $92
801061a5:	6a 5c                	push   $0x5c
  jmp alltraps
801061a7:	e9 de f7 ff ff       	jmp    8010598a <alltraps>

801061ac <vector93>:
.globl vector93
vector93:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $93
801061ae:	6a 5d                	push   $0x5d
  jmp alltraps
801061b0:	e9 d5 f7 ff ff       	jmp    8010598a <alltraps>

801061b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $94
801061b7:	6a 5e                	push   $0x5e
  jmp alltraps
801061b9:	e9 cc f7 ff ff       	jmp    8010598a <alltraps>

801061be <vector95>:
.globl vector95
vector95:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $95
801061c0:	6a 5f                	push   $0x5f
  jmp alltraps
801061c2:	e9 c3 f7 ff ff       	jmp    8010598a <alltraps>

801061c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $96
801061c9:	6a 60                	push   $0x60
  jmp alltraps
801061cb:	e9 ba f7 ff ff       	jmp    8010598a <alltraps>

801061d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $97
801061d2:	6a 61                	push   $0x61
  jmp alltraps
801061d4:	e9 b1 f7 ff ff       	jmp    8010598a <alltraps>

801061d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $98
801061db:	6a 62                	push   $0x62
  jmp alltraps
801061dd:	e9 a8 f7 ff ff       	jmp    8010598a <alltraps>

801061e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $99
801061e4:	6a 63                	push   $0x63
  jmp alltraps
801061e6:	e9 9f f7 ff ff       	jmp    8010598a <alltraps>

801061eb <vector100>:
.globl vector100
vector100:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $100
801061ed:	6a 64                	push   $0x64
  jmp alltraps
801061ef:	e9 96 f7 ff ff       	jmp    8010598a <alltraps>

801061f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $101
801061f6:	6a 65                	push   $0x65
  jmp alltraps
801061f8:	e9 8d f7 ff ff       	jmp    8010598a <alltraps>

801061fd <vector102>:
.globl vector102
vector102:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $102
801061ff:	6a 66                	push   $0x66
  jmp alltraps
80106201:	e9 84 f7 ff ff       	jmp    8010598a <alltraps>

80106206 <vector103>:
.globl vector103
vector103:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $103
80106208:	6a 67                	push   $0x67
  jmp alltraps
8010620a:	e9 7b f7 ff ff       	jmp    8010598a <alltraps>

8010620f <vector104>:
.globl vector104
vector104:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $104
80106211:	6a 68                	push   $0x68
  jmp alltraps
80106213:	e9 72 f7 ff ff       	jmp    8010598a <alltraps>

80106218 <vector105>:
.globl vector105
vector105:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $105
8010621a:	6a 69                	push   $0x69
  jmp alltraps
8010621c:	e9 69 f7 ff ff       	jmp    8010598a <alltraps>

80106221 <vector106>:
.globl vector106
vector106:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $106
80106223:	6a 6a                	push   $0x6a
  jmp alltraps
80106225:	e9 60 f7 ff ff       	jmp    8010598a <alltraps>

8010622a <vector107>:
.globl vector107
vector107:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $107
8010622c:	6a 6b                	push   $0x6b
  jmp alltraps
8010622e:	e9 57 f7 ff ff       	jmp    8010598a <alltraps>

80106233 <vector108>:
.globl vector108
vector108:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $108
80106235:	6a 6c                	push   $0x6c
  jmp alltraps
80106237:	e9 4e f7 ff ff       	jmp    8010598a <alltraps>

8010623c <vector109>:
.globl vector109
vector109:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $109
8010623e:	6a 6d                	push   $0x6d
  jmp alltraps
80106240:	e9 45 f7 ff ff       	jmp    8010598a <alltraps>

80106245 <vector110>:
.globl vector110
vector110:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $110
80106247:	6a 6e                	push   $0x6e
  jmp alltraps
80106249:	e9 3c f7 ff ff       	jmp    8010598a <alltraps>

8010624e <vector111>:
.globl vector111
vector111:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $111
80106250:	6a 6f                	push   $0x6f
  jmp alltraps
80106252:	e9 33 f7 ff ff       	jmp    8010598a <alltraps>

80106257 <vector112>:
.globl vector112
vector112:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $112
80106259:	6a 70                	push   $0x70
  jmp alltraps
8010625b:	e9 2a f7 ff ff       	jmp    8010598a <alltraps>

80106260 <vector113>:
.globl vector113
vector113:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $113
80106262:	6a 71                	push   $0x71
  jmp alltraps
80106264:	e9 21 f7 ff ff       	jmp    8010598a <alltraps>

80106269 <vector114>:
.globl vector114
vector114:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $114
8010626b:	6a 72                	push   $0x72
  jmp alltraps
8010626d:	e9 18 f7 ff ff       	jmp    8010598a <alltraps>

80106272 <vector115>:
.globl vector115
vector115:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $115
80106274:	6a 73                	push   $0x73
  jmp alltraps
80106276:	e9 0f f7 ff ff       	jmp    8010598a <alltraps>

8010627b <vector116>:
.globl vector116
vector116:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $116
8010627d:	6a 74                	push   $0x74
  jmp alltraps
8010627f:	e9 06 f7 ff ff       	jmp    8010598a <alltraps>

80106284 <vector117>:
.globl vector117
vector117:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $117
80106286:	6a 75                	push   $0x75
  jmp alltraps
80106288:	e9 fd f6 ff ff       	jmp    8010598a <alltraps>

8010628d <vector118>:
.globl vector118
vector118:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $118
8010628f:	6a 76                	push   $0x76
  jmp alltraps
80106291:	e9 f4 f6 ff ff       	jmp    8010598a <alltraps>

80106296 <vector119>:
.globl vector119
vector119:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $119
80106298:	6a 77                	push   $0x77
  jmp alltraps
8010629a:	e9 eb f6 ff ff       	jmp    8010598a <alltraps>

8010629f <vector120>:
.globl vector120
vector120:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $120
801062a1:	6a 78                	push   $0x78
  jmp alltraps
801062a3:	e9 e2 f6 ff ff       	jmp    8010598a <alltraps>

801062a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $121
801062aa:	6a 79                	push   $0x79
  jmp alltraps
801062ac:	e9 d9 f6 ff ff       	jmp    8010598a <alltraps>

801062b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $122
801062b3:	6a 7a                	push   $0x7a
  jmp alltraps
801062b5:	e9 d0 f6 ff ff       	jmp    8010598a <alltraps>

801062ba <vector123>:
.globl vector123
vector123:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $123
801062bc:	6a 7b                	push   $0x7b
  jmp alltraps
801062be:	e9 c7 f6 ff ff       	jmp    8010598a <alltraps>

801062c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $124
801062c5:	6a 7c                	push   $0x7c
  jmp alltraps
801062c7:	e9 be f6 ff ff       	jmp    8010598a <alltraps>

801062cc <vector125>:
.globl vector125
vector125:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $125
801062ce:	6a 7d                	push   $0x7d
  jmp alltraps
801062d0:	e9 b5 f6 ff ff       	jmp    8010598a <alltraps>

801062d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $126
801062d7:	6a 7e                	push   $0x7e
  jmp alltraps
801062d9:	e9 ac f6 ff ff       	jmp    8010598a <alltraps>

801062de <vector127>:
.globl vector127
vector127:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $127
801062e0:	6a 7f                	push   $0x7f
  jmp alltraps
801062e2:	e9 a3 f6 ff ff       	jmp    8010598a <alltraps>

801062e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $128
801062e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801062ee:	e9 97 f6 ff ff       	jmp    8010598a <alltraps>

801062f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $129
801062f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801062fa:	e9 8b f6 ff ff       	jmp    8010598a <alltraps>

801062ff <vector130>:
.globl vector130
vector130:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $130
80106301:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106306:	e9 7f f6 ff ff       	jmp    8010598a <alltraps>

8010630b <vector131>:
.globl vector131
vector131:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $131
8010630d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106312:	e9 73 f6 ff ff       	jmp    8010598a <alltraps>

80106317 <vector132>:
.globl vector132
vector132:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $132
80106319:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010631e:	e9 67 f6 ff ff       	jmp    8010598a <alltraps>

80106323 <vector133>:
.globl vector133
vector133:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $133
80106325:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010632a:	e9 5b f6 ff ff       	jmp    8010598a <alltraps>

8010632f <vector134>:
.globl vector134
vector134:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $134
80106331:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106336:	e9 4f f6 ff ff       	jmp    8010598a <alltraps>

8010633b <vector135>:
.globl vector135
vector135:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $135
8010633d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106342:	e9 43 f6 ff ff       	jmp    8010598a <alltraps>

80106347 <vector136>:
.globl vector136
vector136:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $136
80106349:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010634e:	e9 37 f6 ff ff       	jmp    8010598a <alltraps>

80106353 <vector137>:
.globl vector137
vector137:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $137
80106355:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010635a:	e9 2b f6 ff ff       	jmp    8010598a <alltraps>

8010635f <vector138>:
.globl vector138
vector138:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $138
80106361:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106366:	e9 1f f6 ff ff       	jmp    8010598a <alltraps>

8010636b <vector139>:
.globl vector139
vector139:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $139
8010636d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106372:	e9 13 f6 ff ff       	jmp    8010598a <alltraps>

80106377 <vector140>:
.globl vector140
vector140:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $140
80106379:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010637e:	e9 07 f6 ff ff       	jmp    8010598a <alltraps>

80106383 <vector141>:
.globl vector141
vector141:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $141
80106385:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010638a:	e9 fb f5 ff ff       	jmp    8010598a <alltraps>

8010638f <vector142>:
.globl vector142
vector142:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $142
80106391:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106396:	e9 ef f5 ff ff       	jmp    8010598a <alltraps>

8010639b <vector143>:
.globl vector143
vector143:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $143
8010639d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063a2:	e9 e3 f5 ff ff       	jmp    8010598a <alltraps>

801063a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $144
801063a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063ae:	e9 d7 f5 ff ff       	jmp    8010598a <alltraps>

801063b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $145
801063b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801063ba:	e9 cb f5 ff ff       	jmp    8010598a <alltraps>

801063bf <vector146>:
.globl vector146
vector146:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $146
801063c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801063c6:	e9 bf f5 ff ff       	jmp    8010598a <alltraps>

801063cb <vector147>:
.globl vector147
vector147:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $147
801063cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801063d2:	e9 b3 f5 ff ff       	jmp    8010598a <alltraps>

801063d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $148
801063d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801063de:	e9 a7 f5 ff ff       	jmp    8010598a <alltraps>

801063e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $149
801063e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801063ea:	e9 9b f5 ff ff       	jmp    8010598a <alltraps>

801063ef <vector150>:
.globl vector150
vector150:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $150
801063f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801063f6:	e9 8f f5 ff ff       	jmp    8010598a <alltraps>

801063fb <vector151>:
.globl vector151
vector151:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $151
801063fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106402:	e9 83 f5 ff ff       	jmp    8010598a <alltraps>

80106407 <vector152>:
.globl vector152
vector152:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $152
80106409:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010640e:	e9 77 f5 ff ff       	jmp    8010598a <alltraps>

80106413 <vector153>:
.globl vector153
vector153:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $153
80106415:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010641a:	e9 6b f5 ff ff       	jmp    8010598a <alltraps>

8010641f <vector154>:
.globl vector154
vector154:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $154
80106421:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106426:	e9 5f f5 ff ff       	jmp    8010598a <alltraps>

8010642b <vector155>:
.globl vector155
vector155:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $155
8010642d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106432:	e9 53 f5 ff ff       	jmp    8010598a <alltraps>

80106437 <vector156>:
.globl vector156
vector156:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $156
80106439:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010643e:	e9 47 f5 ff ff       	jmp    8010598a <alltraps>

80106443 <vector157>:
.globl vector157
vector157:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $157
80106445:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010644a:	e9 3b f5 ff ff       	jmp    8010598a <alltraps>

8010644f <vector158>:
.globl vector158
vector158:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $158
80106451:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106456:	e9 2f f5 ff ff       	jmp    8010598a <alltraps>

8010645b <vector159>:
.globl vector159
vector159:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $159
8010645d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106462:	e9 23 f5 ff ff       	jmp    8010598a <alltraps>

80106467 <vector160>:
.globl vector160
vector160:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $160
80106469:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010646e:	e9 17 f5 ff ff       	jmp    8010598a <alltraps>

80106473 <vector161>:
.globl vector161
vector161:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $161
80106475:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010647a:	e9 0b f5 ff ff       	jmp    8010598a <alltraps>

8010647f <vector162>:
.globl vector162
vector162:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $162
80106481:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106486:	e9 ff f4 ff ff       	jmp    8010598a <alltraps>

8010648b <vector163>:
.globl vector163
vector163:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $163
8010648d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106492:	e9 f3 f4 ff ff       	jmp    8010598a <alltraps>

80106497 <vector164>:
.globl vector164
vector164:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $164
80106499:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010649e:	e9 e7 f4 ff ff       	jmp    8010598a <alltraps>

801064a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $165
801064a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064aa:	e9 db f4 ff ff       	jmp    8010598a <alltraps>

801064af <vector166>:
.globl vector166
vector166:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $166
801064b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801064b6:	e9 cf f4 ff ff       	jmp    8010598a <alltraps>

801064bb <vector167>:
.globl vector167
vector167:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $167
801064bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801064c2:	e9 c3 f4 ff ff       	jmp    8010598a <alltraps>

801064c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $168
801064c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801064ce:	e9 b7 f4 ff ff       	jmp    8010598a <alltraps>

801064d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $169
801064d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801064da:	e9 ab f4 ff ff       	jmp    8010598a <alltraps>

801064df <vector170>:
.globl vector170
vector170:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $170
801064e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801064e6:	e9 9f f4 ff ff       	jmp    8010598a <alltraps>

801064eb <vector171>:
.globl vector171
vector171:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $171
801064ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801064f2:	e9 93 f4 ff ff       	jmp    8010598a <alltraps>

801064f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $172
801064f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064fe:	e9 87 f4 ff ff       	jmp    8010598a <alltraps>

80106503 <vector173>:
.globl vector173
vector173:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $173
80106505:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010650a:	e9 7b f4 ff ff       	jmp    8010598a <alltraps>

8010650f <vector174>:
.globl vector174
vector174:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $174
80106511:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106516:	e9 6f f4 ff ff       	jmp    8010598a <alltraps>

8010651b <vector175>:
.globl vector175
vector175:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $175
8010651d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106522:	e9 63 f4 ff ff       	jmp    8010598a <alltraps>

80106527 <vector176>:
.globl vector176
vector176:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $176
80106529:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010652e:	e9 57 f4 ff ff       	jmp    8010598a <alltraps>

80106533 <vector177>:
.globl vector177
vector177:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $177
80106535:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010653a:	e9 4b f4 ff ff       	jmp    8010598a <alltraps>

8010653f <vector178>:
.globl vector178
vector178:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $178
80106541:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106546:	e9 3f f4 ff ff       	jmp    8010598a <alltraps>

8010654b <vector179>:
.globl vector179
vector179:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $179
8010654d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106552:	e9 33 f4 ff ff       	jmp    8010598a <alltraps>

80106557 <vector180>:
.globl vector180
vector180:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $180
80106559:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010655e:	e9 27 f4 ff ff       	jmp    8010598a <alltraps>

80106563 <vector181>:
.globl vector181
vector181:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $181
80106565:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010656a:	e9 1b f4 ff ff       	jmp    8010598a <alltraps>

8010656f <vector182>:
.globl vector182
vector182:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $182
80106571:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106576:	e9 0f f4 ff ff       	jmp    8010598a <alltraps>

8010657b <vector183>:
.globl vector183
vector183:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $183
8010657d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106582:	e9 03 f4 ff ff       	jmp    8010598a <alltraps>

80106587 <vector184>:
.globl vector184
vector184:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $184
80106589:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010658e:	e9 f7 f3 ff ff       	jmp    8010598a <alltraps>

80106593 <vector185>:
.globl vector185
vector185:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $185
80106595:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010659a:	e9 eb f3 ff ff       	jmp    8010598a <alltraps>

8010659f <vector186>:
.globl vector186
vector186:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $186
801065a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065a6:	e9 df f3 ff ff       	jmp    8010598a <alltraps>

801065ab <vector187>:
.globl vector187
vector187:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $187
801065ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801065b2:	e9 d3 f3 ff ff       	jmp    8010598a <alltraps>

801065b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $188
801065b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801065be:	e9 c7 f3 ff ff       	jmp    8010598a <alltraps>

801065c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $189
801065c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801065ca:	e9 bb f3 ff ff       	jmp    8010598a <alltraps>

801065cf <vector190>:
.globl vector190
vector190:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $190
801065d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801065d6:	e9 af f3 ff ff       	jmp    8010598a <alltraps>

801065db <vector191>:
.globl vector191
vector191:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $191
801065dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801065e2:	e9 a3 f3 ff ff       	jmp    8010598a <alltraps>

801065e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $192
801065e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801065ee:	e9 97 f3 ff ff       	jmp    8010598a <alltraps>

801065f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $193
801065f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801065fa:	e9 8b f3 ff ff       	jmp    8010598a <alltraps>

801065ff <vector194>:
.globl vector194
vector194:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $194
80106601:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106606:	e9 7f f3 ff ff       	jmp    8010598a <alltraps>

8010660b <vector195>:
.globl vector195
vector195:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $195
8010660d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106612:	e9 73 f3 ff ff       	jmp    8010598a <alltraps>

80106617 <vector196>:
.globl vector196
vector196:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $196
80106619:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010661e:	e9 67 f3 ff ff       	jmp    8010598a <alltraps>

80106623 <vector197>:
.globl vector197
vector197:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $197
80106625:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010662a:	e9 5b f3 ff ff       	jmp    8010598a <alltraps>

8010662f <vector198>:
.globl vector198
vector198:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $198
80106631:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106636:	e9 4f f3 ff ff       	jmp    8010598a <alltraps>

8010663b <vector199>:
.globl vector199
vector199:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $199
8010663d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106642:	e9 43 f3 ff ff       	jmp    8010598a <alltraps>

80106647 <vector200>:
.globl vector200
vector200:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $200
80106649:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010664e:	e9 37 f3 ff ff       	jmp    8010598a <alltraps>

80106653 <vector201>:
.globl vector201
vector201:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $201
80106655:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010665a:	e9 2b f3 ff ff       	jmp    8010598a <alltraps>

8010665f <vector202>:
.globl vector202
vector202:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $202
80106661:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106666:	e9 1f f3 ff ff       	jmp    8010598a <alltraps>

8010666b <vector203>:
.globl vector203
vector203:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $203
8010666d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106672:	e9 13 f3 ff ff       	jmp    8010598a <alltraps>

80106677 <vector204>:
.globl vector204
vector204:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $204
80106679:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010667e:	e9 07 f3 ff ff       	jmp    8010598a <alltraps>

80106683 <vector205>:
.globl vector205
vector205:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $205
80106685:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010668a:	e9 fb f2 ff ff       	jmp    8010598a <alltraps>

8010668f <vector206>:
.globl vector206
vector206:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $206
80106691:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106696:	e9 ef f2 ff ff       	jmp    8010598a <alltraps>

8010669b <vector207>:
.globl vector207
vector207:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $207
8010669d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066a2:	e9 e3 f2 ff ff       	jmp    8010598a <alltraps>

801066a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $208
801066a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066ae:	e9 d7 f2 ff ff       	jmp    8010598a <alltraps>

801066b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $209
801066b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801066ba:	e9 cb f2 ff ff       	jmp    8010598a <alltraps>

801066bf <vector210>:
.globl vector210
vector210:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $210
801066c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801066c6:	e9 bf f2 ff ff       	jmp    8010598a <alltraps>

801066cb <vector211>:
.globl vector211
vector211:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $211
801066cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801066d2:	e9 b3 f2 ff ff       	jmp    8010598a <alltraps>

801066d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $212
801066d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801066de:	e9 a7 f2 ff ff       	jmp    8010598a <alltraps>

801066e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $213
801066e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801066ea:	e9 9b f2 ff ff       	jmp    8010598a <alltraps>

801066ef <vector214>:
.globl vector214
vector214:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $214
801066f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801066f6:	e9 8f f2 ff ff       	jmp    8010598a <alltraps>

801066fb <vector215>:
.globl vector215
vector215:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $215
801066fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106702:	e9 83 f2 ff ff       	jmp    8010598a <alltraps>

80106707 <vector216>:
.globl vector216
vector216:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $216
80106709:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010670e:	e9 77 f2 ff ff       	jmp    8010598a <alltraps>

80106713 <vector217>:
.globl vector217
vector217:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $217
80106715:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010671a:	e9 6b f2 ff ff       	jmp    8010598a <alltraps>

8010671f <vector218>:
.globl vector218
vector218:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $218
80106721:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106726:	e9 5f f2 ff ff       	jmp    8010598a <alltraps>

8010672b <vector219>:
.globl vector219
vector219:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $219
8010672d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106732:	e9 53 f2 ff ff       	jmp    8010598a <alltraps>

80106737 <vector220>:
.globl vector220
vector220:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $220
80106739:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010673e:	e9 47 f2 ff ff       	jmp    8010598a <alltraps>

80106743 <vector221>:
.globl vector221
vector221:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $221
80106745:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010674a:	e9 3b f2 ff ff       	jmp    8010598a <alltraps>

8010674f <vector222>:
.globl vector222
vector222:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $222
80106751:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106756:	e9 2f f2 ff ff       	jmp    8010598a <alltraps>

8010675b <vector223>:
.globl vector223
vector223:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $223
8010675d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106762:	e9 23 f2 ff ff       	jmp    8010598a <alltraps>

80106767 <vector224>:
.globl vector224
vector224:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $224
80106769:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010676e:	e9 17 f2 ff ff       	jmp    8010598a <alltraps>

80106773 <vector225>:
.globl vector225
vector225:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $225
80106775:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010677a:	e9 0b f2 ff ff       	jmp    8010598a <alltraps>

8010677f <vector226>:
.globl vector226
vector226:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $226
80106781:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106786:	e9 ff f1 ff ff       	jmp    8010598a <alltraps>

8010678b <vector227>:
.globl vector227
vector227:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $227
8010678d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106792:	e9 f3 f1 ff ff       	jmp    8010598a <alltraps>

80106797 <vector228>:
.globl vector228
vector228:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $228
80106799:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010679e:	e9 e7 f1 ff ff       	jmp    8010598a <alltraps>

801067a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $229
801067a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067aa:	e9 db f1 ff ff       	jmp    8010598a <alltraps>

801067af <vector230>:
.globl vector230
vector230:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $230
801067b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801067b6:	e9 cf f1 ff ff       	jmp    8010598a <alltraps>

801067bb <vector231>:
.globl vector231
vector231:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $231
801067bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801067c2:	e9 c3 f1 ff ff       	jmp    8010598a <alltraps>

801067c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $232
801067c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801067ce:	e9 b7 f1 ff ff       	jmp    8010598a <alltraps>

801067d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $233
801067d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801067da:	e9 ab f1 ff ff       	jmp    8010598a <alltraps>

801067df <vector234>:
.globl vector234
vector234:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $234
801067e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801067e6:	e9 9f f1 ff ff       	jmp    8010598a <alltraps>

801067eb <vector235>:
.globl vector235
vector235:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $235
801067ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801067f2:	e9 93 f1 ff ff       	jmp    8010598a <alltraps>

801067f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $236
801067f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067fe:	e9 87 f1 ff ff       	jmp    8010598a <alltraps>

80106803 <vector237>:
.globl vector237
vector237:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $237
80106805:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010680a:	e9 7b f1 ff ff       	jmp    8010598a <alltraps>

8010680f <vector238>:
.globl vector238
vector238:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $238
80106811:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106816:	e9 6f f1 ff ff       	jmp    8010598a <alltraps>

8010681b <vector239>:
.globl vector239
vector239:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $239
8010681d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106822:	e9 63 f1 ff ff       	jmp    8010598a <alltraps>

80106827 <vector240>:
.globl vector240
vector240:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $240
80106829:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010682e:	e9 57 f1 ff ff       	jmp    8010598a <alltraps>

80106833 <vector241>:
.globl vector241
vector241:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $241
80106835:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010683a:	e9 4b f1 ff ff       	jmp    8010598a <alltraps>

8010683f <vector242>:
.globl vector242
vector242:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $242
80106841:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106846:	e9 3f f1 ff ff       	jmp    8010598a <alltraps>

8010684b <vector243>:
.globl vector243
vector243:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $243
8010684d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106852:	e9 33 f1 ff ff       	jmp    8010598a <alltraps>

80106857 <vector244>:
.globl vector244
vector244:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $244
80106859:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010685e:	e9 27 f1 ff ff       	jmp    8010598a <alltraps>

80106863 <vector245>:
.globl vector245
vector245:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $245
80106865:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010686a:	e9 1b f1 ff ff       	jmp    8010598a <alltraps>

8010686f <vector246>:
.globl vector246
vector246:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $246
80106871:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106876:	e9 0f f1 ff ff       	jmp    8010598a <alltraps>

8010687b <vector247>:
.globl vector247
vector247:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $247
8010687d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106882:	e9 03 f1 ff ff       	jmp    8010598a <alltraps>

80106887 <vector248>:
.globl vector248
vector248:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $248
80106889:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010688e:	e9 f7 f0 ff ff       	jmp    8010598a <alltraps>

80106893 <vector249>:
.globl vector249
vector249:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $249
80106895:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010689a:	e9 eb f0 ff ff       	jmp    8010598a <alltraps>

8010689f <vector250>:
.globl vector250
vector250:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $250
801068a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068a6:	e9 df f0 ff ff       	jmp    8010598a <alltraps>

801068ab <vector251>:
.globl vector251
vector251:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $251
801068ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801068b2:	e9 d3 f0 ff ff       	jmp    8010598a <alltraps>

801068b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $252
801068b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801068be:	e9 c7 f0 ff ff       	jmp    8010598a <alltraps>

801068c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $253
801068c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801068ca:	e9 bb f0 ff ff       	jmp    8010598a <alltraps>

801068cf <vector254>:
.globl vector254
vector254:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $254
801068d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801068d6:	e9 af f0 ff ff       	jmp    8010598a <alltraps>

801068db <vector255>:
.globl vector255
vector255:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $255
801068dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801068e2:	e9 a3 f0 ff ff       	jmp    8010598a <alltraps>
801068e7:	66 90                	xchg   %ax,%ax
801068e9:	66 90                	xchg   %ax,%ax
801068eb:	66 90                	xchg   %ax,%ax
801068ed:	66 90                	xchg   %ax,%ax
801068ef:	90                   	nop

801068f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801068f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801068fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106902:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106905:	39 d3                	cmp    %edx,%ebx
80106907:	73 56                	jae    8010695f <deallocuvm.part.0+0x6f>
80106909:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010690c:	89 c6                	mov    %eax,%esi
8010690e:	89 d7                	mov    %edx,%edi
80106910:	eb 12                	jmp    80106924 <deallocuvm.part.0+0x34>
80106912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106918:	83 c2 01             	add    $0x1,%edx
8010691b:	89 d3                	mov    %edx,%ebx
8010691d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106920:	39 fb                	cmp    %edi,%ebx
80106922:	73 38                	jae    8010695c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106924:	89 da                	mov    %ebx,%edx
80106926:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106929:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010692c:	a8 01                	test   $0x1,%al
8010692e:	74 e8                	je     80106918 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106930:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106932:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106937:	c1 e9 0a             	shr    $0xa,%ecx
8010693a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106940:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106947:	85 c0                	test   %eax,%eax
80106949:	74 cd                	je     80106918 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
8010694b:	8b 10                	mov    (%eax),%edx
8010694d:	f6 c2 01             	test   $0x1,%dl
80106950:	75 1e                	jne    80106970 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106952:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106958:	39 fb                	cmp    %edi,%ebx
8010695a:	72 c8                	jb     80106924 <deallocuvm.part.0+0x34>
8010695c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010695f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106962:	89 c8                	mov    %ecx,%eax
80106964:	5b                   	pop    %ebx
80106965:	5e                   	pop    %esi
80106966:	5f                   	pop    %edi
80106967:	5d                   	pop    %ebp
80106968:	c3                   	ret
80106969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106970:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106976:	74 26                	je     8010699e <deallocuvm.part.0+0xae>
      kfree(v);
80106978:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010697b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106984:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010698a:	52                   	push   %edx
8010698b:	e8 30 bb ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106993:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010699c:	eb 82                	jmp    80106920 <deallocuvm.part.0+0x30>
        panic("kfree");
8010699e:	83 ec 0c             	sub    $0xc,%esp
801069a1:	68 8c 74 10 80       	push   $0x8010748c
801069a6:	e8 d5 99 ff ff       	call   80100380 <panic>
801069ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069af:	90                   	nop

801069b0 <mappages>:
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801069b6:	89 d3                	mov    %edx,%ebx
801069b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801069be:	83 ec 1c             	sub    $0x1c,%esp
801069c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801069c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069d0:	8b 45 08             	mov    0x8(%ebp),%eax
801069d3:	29 d8                	sub    %ebx,%eax
801069d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069d8:	eb 3f                	jmp    80106a19 <mappages+0x69>
801069da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801069e0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801069e7:	c1 ea 0a             	shr    $0xa,%edx
801069ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801069f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801069f7:	85 c0                	test   %eax,%eax
801069f9:	74 75                	je     80106a70 <mappages+0xc0>
    if(*pte & PTE_P)
801069fb:	f6 00 01             	testb  $0x1,(%eax)
801069fe:	0f 85 86 00 00 00    	jne    80106a8a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106a04:	0b 75 0c             	or     0xc(%ebp),%esi
80106a07:	83 ce 01             	or     $0x1,%esi
80106a0a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a0f:	39 c3                	cmp    %eax,%ebx
80106a11:	74 6d                	je     80106a80 <mappages+0xd0>
    a += PGSIZE;
80106a13:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106a1c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106a1f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106a22:	89 d8                	mov    %ebx,%eax
80106a24:	c1 e8 16             	shr    $0x16,%eax
80106a27:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106a2a:	8b 07                	mov    (%edi),%eax
80106a2c:	a8 01                	test   $0x1,%al
80106a2e:	75 b0                	jne    801069e0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a30:	e8 4b bc ff ff       	call   80102680 <kalloc>
80106a35:	85 c0                	test   %eax,%eax
80106a37:	74 37                	je     80106a70 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106a39:	83 ec 04             	sub    $0x4,%esp
80106a3c:	68 00 10 00 00       	push   $0x1000
80106a41:	6a 00                	push   $0x0
80106a43:	50                   	push   %eax
80106a44:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106a47:	e8 a4 dd ff ff       	call   801047f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a4c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106a4f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a52:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106a58:	83 c8 07             	or     $0x7,%eax
80106a5b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106a5d:	89 d8                	mov    %ebx,%eax
80106a5f:	c1 e8 0a             	shr    $0xa,%eax
80106a62:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a67:	01 d0                	add    %edx,%eax
80106a69:	eb 90                	jmp    801069fb <mappages+0x4b>
80106a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a6f:	90                   	nop
}
80106a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a78:	5b                   	pop    %ebx
80106a79:	5e                   	pop    %esi
80106a7a:	5f                   	pop    %edi
80106a7b:	5d                   	pop    %ebp
80106a7c:	c3                   	ret
80106a7d:	8d 76 00             	lea    0x0(%esi),%esi
80106a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a83:	31 c0                	xor    %eax,%eax
}
80106a85:	5b                   	pop    %ebx
80106a86:	5e                   	pop    %esi
80106a87:	5f                   	pop    %edi
80106a88:	5d                   	pop    %ebp
80106a89:	c3                   	ret
      panic("remap");
80106a8a:	83 ec 0c             	sub    $0xc,%esp
80106a8d:	68 eb 76 10 80       	push   $0x801076eb
80106a92:	e8 e9 98 ff ff       	call   80100380 <panic>
80106a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9e:	66 90                	xchg   %ax,%ax

80106aa0 <seginit>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106aa6:	e8 e5 cf ff ff       	call   80103a90 <cpuid>
  pd[0] = size-1;
80106aab:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ab0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ab6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106aba:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106ac1:	ff 00 00 
80106ac4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106acb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ace:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106ad5:	ff 00 00 
80106ad8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106adf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ae2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106ae9:	ff 00 00 
80106aec:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106af3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106af6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106afd:	ff 00 00 
80106b00:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106b07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b0a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106b0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b13:	c1 e8 10             	shr    $0x10,%eax
80106b16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b1d:	0f 01 10             	lgdtl  (%eax)
}
80106b20:	c9                   	leave
80106b21:	c3                   	ret
80106b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b30:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106b35:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b3a:	0f 22 d8             	mov    %eax,%cr3
}
80106b3d:	c3                   	ret
80106b3e:	66 90                	xchg   %ax,%ax

80106b40 <switchuvm>:
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
80106b46:	83 ec 1c             	sub    $0x1c,%esp
80106b49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b4c:	85 f6                	test   %esi,%esi
80106b4e:	0f 84 cb 00 00 00    	je     80106c1f <switchuvm+0xdf>
  if(p->kstack == 0)
80106b54:	8b 46 08             	mov    0x8(%esi),%eax
80106b57:	85 c0                	test   %eax,%eax
80106b59:	0f 84 da 00 00 00    	je     80106c39 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b5f:	8b 46 04             	mov    0x4(%esi),%eax
80106b62:	85 c0                	test   %eax,%eax
80106b64:	0f 84 c2 00 00 00    	je     80106c2c <switchuvm+0xec>
  pushcli();
80106b6a:	e8 31 da ff ff       	call   801045a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b6f:	e8 bc ce ff ff       	call   80103a30 <mycpu>
80106b74:	89 c3                	mov    %eax,%ebx
80106b76:	e8 b5 ce ff ff       	call   80103a30 <mycpu>
80106b7b:	89 c7                	mov    %eax,%edi
80106b7d:	e8 ae ce ff ff       	call   80103a30 <mycpu>
80106b82:	83 c7 08             	add    $0x8,%edi
80106b85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b88:	e8 a3 ce ff ff       	call   80103a30 <mycpu>
80106b8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b90:	ba 67 00 00 00       	mov    $0x67,%edx
80106b95:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b9c:	83 c0 08             	add    $0x8,%eax
80106b9f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ba6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106bab:	83 c1 08             	add    $0x8,%ecx
80106bae:	c1 e8 18             	shr    $0x18,%eax
80106bb1:	c1 e9 10             	shr    $0x10,%ecx
80106bb4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106bba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106bc0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106bc5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bcc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106bd1:	e8 5a ce ff ff       	call   80103a30 <mycpu>
80106bd6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bdd:	e8 4e ce ff ff       	call   80103a30 <mycpu>
80106be2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106be6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106be9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bef:	e8 3c ce ff ff       	call   80103a30 <mycpu>
80106bf4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bf7:	e8 34 ce ff ff       	call   80103a30 <mycpu>
80106bfc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106c00:	b8 28 00 00 00       	mov    $0x28,%eax
80106c05:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c08:	8b 46 04             	mov    0x4(%esi),%eax
80106c0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c10:	0f 22 d8             	mov    %eax,%cr3
}
80106c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c16:	5b                   	pop    %ebx
80106c17:	5e                   	pop    %esi
80106c18:	5f                   	pop    %edi
80106c19:	5d                   	pop    %ebp
  popcli();
80106c1a:	e9 d1 d9 ff ff       	jmp    801045f0 <popcli>
    panic("switchuvm: no process");
80106c1f:	83 ec 0c             	sub    $0xc,%esp
80106c22:	68 f1 76 10 80       	push   $0x801076f1
80106c27:	e8 54 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106c2c:	83 ec 0c             	sub    $0xc,%esp
80106c2f:	68 1c 77 10 80       	push   $0x8010771c
80106c34:	e8 47 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106c39:	83 ec 0c             	sub    $0xc,%esp
80106c3c:	68 07 77 10 80       	push   $0x80107707
80106c41:	e8 3a 97 ff ff       	call   80100380 <panic>
80106c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c4d:	8d 76 00             	lea    0x0(%esi),%esi

80106c50 <inituvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
80106c59:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5c:	8b 75 10             	mov    0x10(%ebp),%esi
80106c5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106c62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c65:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c6b:	77 49                	ja     80106cb6 <inituvm+0x66>
  mem = kalloc();
80106c6d:	e8 0e ba ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80106c72:	83 ec 04             	sub    $0x4,%esp
80106c75:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106c7a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c7c:	6a 00                	push   $0x0
80106c7e:	50                   	push   %eax
80106c7f:	e8 6c db ff ff       	call   801047f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c84:	58                   	pop    %eax
80106c85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c8b:	5a                   	pop    %edx
80106c8c:	6a 06                	push   $0x6
80106c8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c93:	31 d2                	xor    %edx,%edx
80106c95:	50                   	push   %eax
80106c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c99:	e8 12 fd ff ff       	call   801069b0 <mappages>
  memmove(mem, init, sz);
80106c9e:	89 75 10             	mov    %esi,0x10(%ebp)
80106ca1:	83 c4 10             	add    $0x10,%esp
80106ca4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106ca7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cad:	5b                   	pop    %ebx
80106cae:	5e                   	pop    %esi
80106caf:	5f                   	pop    %edi
80106cb0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106cb1:	e9 ca db ff ff       	jmp    80104880 <memmove>
    panic("inituvm: more than a page");
80106cb6:	83 ec 0c             	sub    $0xc,%esp
80106cb9:	68 30 77 10 80       	push   $0x80107730
80106cbe:	e8 bd 96 ff ff       	call   80100380 <panic>
80106cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cd0 <loaduvm>:
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106cd9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106cdc:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106cdf:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106ce5:	0f 85 a2 00 00 00    	jne    80106d8d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106ceb:	85 ff                	test   %edi,%edi
80106ced:	74 7d                	je     80106d6c <loaduvm+0x9c>
80106cef:	90                   	nop
  pde = &pgdir[PDX(va)];
80106cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106cf3:	8b 55 08             	mov    0x8(%ebp),%edx
80106cf6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106cf8:	89 c1                	mov    %eax,%ecx
80106cfa:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106cfd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106d00:	f6 c1 01             	test   $0x1,%cl
80106d03:	75 13                	jne    80106d18 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106d05:	83 ec 0c             	sub    $0xc,%esp
80106d08:	68 4a 77 10 80       	push   $0x8010774a
80106d0d:	e8 6e 96 ff ff       	call   80100380 <panic>
80106d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d18:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d1b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d21:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d26:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d2d:	85 c9                	test   %ecx,%ecx
80106d2f:	74 d4                	je     80106d05 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106d31:	89 fb                	mov    %edi,%ebx
80106d33:	b8 00 10 00 00       	mov    $0x1000,%eax
80106d38:	29 f3                	sub    %esi,%ebx
80106d3a:	39 c3                	cmp    %eax,%ebx
80106d3c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d3f:	53                   	push   %ebx
80106d40:	8b 45 14             	mov    0x14(%ebp),%eax
80106d43:	01 f0                	add    %esi,%eax
80106d45:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106d46:	8b 01                	mov    (%ecx),%eax
80106d48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d4d:	05 00 00 00 80       	add    $0x80000000,%eax
80106d52:	50                   	push   %eax
80106d53:	ff 75 10             	push   0x10(%ebp)
80106d56:	e8 75 ad ff ff       	call   80101ad0 <readi>
80106d5b:	83 c4 10             	add    $0x10,%esp
80106d5e:	39 d8                	cmp    %ebx,%eax
80106d60:	75 1e                	jne    80106d80 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106d62:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d68:	39 fe                	cmp    %edi,%esi
80106d6a:	72 84                	jb     80106cf0 <loaduvm+0x20>
}
80106d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d6f:	31 c0                	xor    %eax,%eax
}
80106d71:	5b                   	pop    %ebx
80106d72:	5e                   	pop    %esi
80106d73:	5f                   	pop    %edi
80106d74:	5d                   	pop    %ebp
80106d75:	c3                   	ret
80106d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d7d:	8d 76 00             	lea    0x0(%esi),%esi
80106d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d88:	5b                   	pop    %ebx
80106d89:	5e                   	pop    %esi
80106d8a:	5f                   	pop    %edi
80106d8b:	5d                   	pop    %ebp
80106d8c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106d8d:	83 ec 0c             	sub    $0xc,%esp
80106d90:	68 6c 79 10 80       	push   $0x8010796c
80106d95:	e8 e6 95 ff ff       	call   80100380 <panic>
80106d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106da0 <allocuvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 1c             	sub    $0x1c,%esp
80106da9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106dac:	85 f6                	test   %esi,%esi
80106dae:	0f 88 98 00 00 00    	js     80106e4c <allocuvm+0xac>
80106db4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106db6:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106db9:	0f 82 a1 00 00 00    	jb     80106e60 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dc2:	05 ff 0f 00 00       	add    $0xfff,%eax
80106dc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dcc:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106dce:	39 f0                	cmp    %esi,%eax
80106dd0:	0f 83 8d 00 00 00    	jae    80106e63 <allocuvm+0xc3>
80106dd6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106dd9:	eb 44                	jmp    80106e1f <allocuvm+0x7f>
80106ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ddf:	90                   	nop
    memset(mem, 0, PGSIZE);
80106de0:	83 ec 04             	sub    $0x4,%esp
80106de3:	68 00 10 00 00       	push   $0x1000
80106de8:	6a 00                	push   $0x0
80106dea:	50                   	push   %eax
80106deb:	e8 00 da ff ff       	call   801047f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106df0:	58                   	pop    %eax
80106df1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106df7:	5a                   	pop    %edx
80106df8:	6a 06                	push   $0x6
80106dfa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dff:	89 fa                	mov    %edi,%edx
80106e01:	50                   	push   %eax
80106e02:	8b 45 08             	mov    0x8(%ebp),%eax
80106e05:	e8 a6 fb ff ff       	call   801069b0 <mappages>
80106e0a:	83 c4 10             	add    $0x10,%esp
80106e0d:	85 c0                	test   %eax,%eax
80106e0f:	78 5f                	js     80106e70 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106e11:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e17:	39 f7                	cmp    %esi,%edi
80106e19:	0f 83 89 00 00 00    	jae    80106ea8 <allocuvm+0x108>
    mem = kalloc();
80106e1f:	e8 5c b8 ff ff       	call   80102680 <kalloc>
80106e24:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106e26:	85 c0                	test   %eax,%eax
80106e28:	75 b6                	jne    80106de0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106e2a:	83 ec 0c             	sub    $0xc,%esp
80106e2d:	68 68 77 10 80       	push   $0x80107768
80106e32:	e8 79 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e37:	83 c4 10             	add    $0x10,%esp
80106e3a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106e3d:	74 0d                	je     80106e4c <allocuvm+0xac>
80106e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e42:	8b 45 08             	mov    0x8(%ebp),%eax
80106e45:	89 f2                	mov    %esi,%edx
80106e47:	e8 a4 fa ff ff       	call   801068f0 <deallocuvm.part.0>
    return 0;
80106e4c:	31 d2                	xor    %edx,%edx
}
80106e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e51:	89 d0                	mov    %edx,%eax
80106e53:	5b                   	pop    %ebx
80106e54:	5e                   	pop    %esi
80106e55:	5f                   	pop    %edi
80106e56:	5d                   	pop    %ebp
80106e57:	c3                   	ret
80106e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e5f:	90                   	nop
    return oldsz;
80106e60:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e66:	89 d0                	mov    %edx,%eax
80106e68:	5b                   	pop    %ebx
80106e69:	5e                   	pop    %esi
80106e6a:	5f                   	pop    %edi
80106e6b:	5d                   	pop    %ebp
80106e6c:	c3                   	ret
80106e6d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e70:	83 ec 0c             	sub    $0xc,%esp
80106e73:	68 80 77 10 80       	push   $0x80107780
80106e78:	e8 33 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e7d:	83 c4 10             	add    $0x10,%esp
80106e80:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106e83:	74 0d                	je     80106e92 <allocuvm+0xf2>
80106e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e88:	8b 45 08             	mov    0x8(%ebp),%eax
80106e8b:	89 f2                	mov    %esi,%edx
80106e8d:	e8 5e fa ff ff       	call   801068f0 <deallocuvm.part.0>
      kfree(mem);
80106e92:	83 ec 0c             	sub    $0xc,%esp
80106e95:	53                   	push   %ebx
80106e96:	e8 25 b6 ff ff       	call   801024c0 <kfree>
      return 0;
80106e9b:	83 c4 10             	add    $0x10,%esp
    return 0;
80106e9e:	31 d2                	xor    %edx,%edx
80106ea0:	eb ac                	jmp    80106e4e <allocuvm+0xae>
80106ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ea8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eae:	5b                   	pop    %ebx
80106eaf:	5e                   	pop    %esi
80106eb0:	89 d0                	mov    %edx,%eax
80106eb2:	5f                   	pop    %edi
80106eb3:	5d                   	pop    %ebp
80106eb4:	c3                   	ret
80106eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <deallocuvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ec6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106ecc:	39 d1                	cmp    %edx,%ecx
80106ece:	73 10                	jae    80106ee0 <deallocuvm+0x20>
}
80106ed0:	5d                   	pop    %ebp
80106ed1:	e9 1a fa ff ff       	jmp    801068f0 <deallocuvm.part.0>
80106ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106edd:	8d 76 00             	lea    0x0(%esi),%esi
80106ee0:	89 d0                	mov    %edx,%eax
80106ee2:	5d                   	pop    %ebp
80106ee3:	c3                   	ret
80106ee4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106eef:	90                   	nop

80106ef0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 0c             	sub    $0xc,%esp
80106ef9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106efc:	85 f6                	test   %esi,%esi
80106efe:	74 59                	je     80106f59 <freevm+0x69>
  if(newsz >= oldsz)
80106f00:	31 c9                	xor    %ecx,%ecx
80106f02:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f07:	89 f0                	mov    %esi,%eax
80106f09:	89 f3                	mov    %esi,%ebx
80106f0b:	e8 e0 f9 ff ff       	call   801068f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f10:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f16:	eb 0f                	jmp    80106f27 <freevm+0x37>
80106f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1f:	90                   	nop
80106f20:	83 c3 04             	add    $0x4,%ebx
80106f23:	39 fb                	cmp    %edi,%ebx
80106f25:	74 23                	je     80106f4a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f27:	8b 03                	mov    (%ebx),%eax
80106f29:	a8 01                	test   $0x1,%al
80106f2b:	74 f3                	je     80106f20 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f32:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f35:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f38:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f3d:	50                   	push   %eax
80106f3e:	e8 7d b5 ff ff       	call   801024c0 <kfree>
80106f43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f46:	39 fb                	cmp    %edi,%ebx
80106f48:	75 dd                	jne    80106f27 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f50:	5b                   	pop    %ebx
80106f51:	5e                   	pop    %esi
80106f52:	5f                   	pop    %edi
80106f53:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f54:	e9 67 b5 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80106f59:	83 ec 0c             	sub    $0xc,%esp
80106f5c:	68 9c 77 10 80       	push   $0x8010779c
80106f61:	e8 1a 94 ff ff       	call   80100380 <panic>
80106f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi

80106f70 <setupkvm>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	56                   	push   %esi
80106f74:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f75:	e8 06 b7 ff ff       	call   80102680 <kalloc>
80106f7a:	85 c0                	test   %eax,%eax
80106f7c:	74 5e                	je     80106fdc <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106f7e:	83 ec 04             	sub    $0x4,%esp
80106f81:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f83:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f88:	68 00 10 00 00       	push   $0x1000
80106f8d:	6a 00                	push   $0x0
80106f8f:	50                   	push   %eax
80106f90:	e8 5b d8 ff ff       	call   801047f0 <memset>
80106f95:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f98:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f9b:	83 ec 08             	sub    $0x8,%esp
80106f9e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106fa1:	8b 13                	mov    (%ebx),%edx
80106fa3:	ff 73 0c             	push   0xc(%ebx)
80106fa6:	50                   	push   %eax
80106fa7:	29 c1                	sub    %eax,%ecx
80106fa9:	89 f0                	mov    %esi,%eax
80106fab:	e8 00 fa ff ff       	call   801069b0 <mappages>
80106fb0:	83 c4 10             	add    $0x10,%esp
80106fb3:	85 c0                	test   %eax,%eax
80106fb5:	78 19                	js     80106fd0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fb7:	83 c3 10             	add    $0x10,%ebx
80106fba:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106fc0:	75 d6                	jne    80106f98 <setupkvm+0x28>
}
80106fc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fc5:	89 f0                	mov    %esi,%eax
80106fc7:	5b                   	pop    %ebx
80106fc8:	5e                   	pop    %esi
80106fc9:	5d                   	pop    %ebp
80106fca:	c3                   	ret
80106fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fcf:	90                   	nop
      freevm(pgdir);
80106fd0:	83 ec 0c             	sub    $0xc,%esp
80106fd3:	56                   	push   %esi
80106fd4:	e8 17 ff ff ff       	call   80106ef0 <freevm>
      return 0;
80106fd9:	83 c4 10             	add    $0x10,%esp
}
80106fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106fdf:	31 f6                	xor    %esi,%esi
}
80106fe1:	89 f0                	mov    %esi,%eax
80106fe3:	5b                   	pop    %ebx
80106fe4:	5e                   	pop    %esi
80106fe5:	5d                   	pop    %ebp
80106fe6:	c3                   	ret
80106fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fee:	66 90                	xchg   %ax,%ax

80106ff0 <kvmalloc>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ff6:	e8 75 ff ff ff       	call   80106f70 <setupkvm>
80106ffb:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107000:	05 00 00 00 80       	add    $0x80000000,%eax
80107005:	0f 22 d8             	mov    %eax,%cr3
}
80107008:	c9                   	leave
80107009:	c3                   	ret
8010700a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107010 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 08             	sub    $0x8,%esp
80107016:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107019:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010701c:	89 c1                	mov    %eax,%ecx
8010701e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107021:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107024:	f6 c2 01             	test   $0x1,%dl
80107027:	75 17                	jne    80107040 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107029:	83 ec 0c             	sub    $0xc,%esp
8010702c:	68 ad 77 10 80       	push   $0x801077ad
80107031:	e8 4a 93 ff ff       	call   80100380 <panic>
80107036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107040:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107043:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107049:	25 fc 0f 00 00       	and    $0xffc,%eax
8010704e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107055:	85 c0                	test   %eax,%eax
80107057:	74 d0                	je     80107029 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107059:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010705c:	c9                   	leave
8010705d:	c3                   	ret
8010705e:	66 90                	xchg   %ax,%ax

80107060 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107069:	e8 02 ff ff ff       	call   80106f70 <setupkvm>
8010706e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107071:	85 c0                	test   %eax,%eax
80107073:	0f 84 e9 00 00 00    	je     80107162 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010707c:	85 c9                	test   %ecx,%ecx
8010707e:	0f 84 b2 00 00 00    	je     80107136 <copyuvm+0xd6>
80107084:	31 f6                	xor    %esi,%esi
80107086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107090:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107093:	89 f0                	mov    %esi,%eax
80107095:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107098:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010709b:	a8 01                	test   $0x1,%al
8010709d:	75 11                	jne    801070b0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010709f:	83 ec 0c             	sub    $0xc,%esp
801070a2:	68 b7 77 10 80       	push   $0x801077b7
801070a7:	e8 d4 92 ff ff       	call   80100380 <panic>
801070ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801070b0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070b7:	c1 ea 0a             	shr    $0xa,%edx
801070ba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070c0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070c7:	85 c0                	test   %eax,%eax
801070c9:	74 d4                	je     8010709f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801070cb:	8b 00                	mov    (%eax),%eax
801070cd:	a8 01                	test   $0x1,%al
801070cf:	0f 84 9f 00 00 00    	je     80107174 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070d5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801070d7:	25 ff 0f 00 00       	and    $0xfff,%eax
801070dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801070df:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801070e5:	e8 96 b5 ff ff       	call   80102680 <kalloc>
801070ea:	89 c3                	mov    %eax,%ebx
801070ec:	85 c0                	test   %eax,%eax
801070ee:	74 64                	je     80107154 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801070f0:	83 ec 04             	sub    $0x4,%esp
801070f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801070f9:	68 00 10 00 00       	push   $0x1000
801070fe:	57                   	push   %edi
801070ff:	50                   	push   %eax
80107100:	e8 7b d7 ff ff       	call   80104880 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107105:	58                   	pop    %eax
80107106:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010710c:	5a                   	pop    %edx
8010710d:	ff 75 e4             	push   -0x1c(%ebp)
80107110:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107115:	89 f2                	mov    %esi,%edx
80107117:	50                   	push   %eax
80107118:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010711b:	e8 90 f8 ff ff       	call   801069b0 <mappages>
80107120:	83 c4 10             	add    $0x10,%esp
80107123:	85 c0                	test   %eax,%eax
80107125:	78 21                	js     80107148 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107127:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010712d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107130:	0f 82 5a ff ff ff    	jb     80107090 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107136:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107139:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010713c:	5b                   	pop    %ebx
8010713d:	5e                   	pop    %esi
8010713e:	5f                   	pop    %edi
8010713f:	5d                   	pop    %ebp
80107140:	c3                   	ret
80107141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107148:	83 ec 0c             	sub    $0xc,%esp
8010714b:	53                   	push   %ebx
8010714c:	e8 6f b3 ff ff       	call   801024c0 <kfree>
      goto bad;
80107151:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107154:	83 ec 0c             	sub    $0xc,%esp
80107157:	ff 75 e0             	push   -0x20(%ebp)
8010715a:	e8 91 fd ff ff       	call   80106ef0 <freevm>
  return 0;
8010715f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107162:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107169:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010716c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010716f:	5b                   	pop    %ebx
80107170:	5e                   	pop    %esi
80107171:	5f                   	pop    %edi
80107172:	5d                   	pop    %ebp
80107173:	c3                   	ret
      panic("copyuvm: page not present");
80107174:	83 ec 0c             	sub    $0xc,%esp
80107177:	68 d1 77 10 80       	push   $0x801077d1
8010717c:	e8 ff 91 ff ff       	call   80100380 <panic>
80107181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718f:	90                   	nop

80107190 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107196:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107199:	89 c1                	mov    %eax,%ecx
8010719b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010719e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071a1:	f6 c2 01             	test   $0x1,%dl
801071a4:	0f 84 f8 00 00 00    	je     801072a2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801071aa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071ad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071b3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801071b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801071b9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071c0:	89 d0                	mov    %edx,%eax
801071c2:	f7 d2                	not    %edx
801071c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071c9:	05 00 00 00 80       	add    $0x80000000,%eax
801071ce:	83 e2 05             	and    $0x5,%edx
801071d1:	ba 00 00 00 00       	mov    $0x0,%edx
801071d6:	0f 45 c2             	cmovne %edx,%eax
}
801071d9:	c3                   	ret
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 0c             	sub    $0xc,%esp
801071e9:	8b 75 14             	mov    0x14(%ebp),%esi
801071ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801071ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071f2:	85 f6                	test   %esi,%esi
801071f4:	75 51                	jne    80107247 <copyout+0x67>
801071f6:	e9 9d 00 00 00       	jmp    80107298 <copyout+0xb8>
801071fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071ff:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107200:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107206:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010720c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107212:	74 74                	je     80107288 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107214:	89 fb                	mov    %edi,%ebx
80107216:	29 c3                	sub    %eax,%ebx
80107218:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010721e:	39 f3                	cmp    %esi,%ebx
80107220:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107223:	29 f8                	sub    %edi,%eax
80107225:	83 ec 04             	sub    $0x4,%esp
80107228:	01 c1                	add    %eax,%ecx
8010722a:	53                   	push   %ebx
8010722b:	52                   	push   %edx
8010722c:	89 55 10             	mov    %edx,0x10(%ebp)
8010722f:	51                   	push   %ecx
80107230:	e8 4b d6 ff ff       	call   80104880 <memmove>
    len -= n;
    buf += n;
80107235:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107238:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010723e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107241:	01 da                	add    %ebx,%edx
  while(len > 0){
80107243:	29 de                	sub    %ebx,%esi
80107245:	74 51                	je     80107298 <copyout+0xb8>
  if(*pde & PTE_P){
80107247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010724a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010724c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010724e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107251:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107257:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010725a:	f6 c1 01             	test   $0x1,%cl
8010725d:	0f 84 46 00 00 00    	je     801072a9 <copyout.cold>
  return &pgtab[PTX(va)];
80107263:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107265:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010726b:	c1 eb 0c             	shr    $0xc,%ebx
8010726e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107274:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010727b:	89 d9                	mov    %ebx,%ecx
8010727d:	f7 d1                	not    %ecx
8010727f:	83 e1 05             	and    $0x5,%ecx
80107282:	0f 84 78 ff ff ff    	je     80107200 <copyout+0x20>
  }
  return 0;
}
80107288:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010728b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107290:	5b                   	pop    %ebx
80107291:	5e                   	pop    %esi
80107292:	5f                   	pop    %edi
80107293:	5d                   	pop    %ebp
80107294:	c3                   	ret
80107295:	8d 76 00             	lea    0x0(%esi),%esi
80107298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010729b:	31 c0                	xor    %eax,%eax
}
8010729d:	5b                   	pop    %ebx
8010729e:	5e                   	pop    %esi
8010729f:	5f                   	pop    %edi
801072a0:	5d                   	pop    %ebp
801072a1:	c3                   	ret

801072a2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801072a2:	a1 00 00 00 00       	mov    0x0,%eax
801072a7:	0f 0b                	ud2

801072a9 <copyout.cold>:
801072a9:	a1 00 00 00 00       	mov    0x0,%eax
801072ae:	0f 0b                	ud2
