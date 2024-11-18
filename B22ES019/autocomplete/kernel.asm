
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
8010002d:	b8 b0 31 10 80       	mov    $0x801031b0,%eax
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
8010004c:	68 e0 72 10 80       	push   $0x801072e0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 d5 44 00 00       	call   80104530 <initlock>
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
80100092:	68 e7 72 10 80       	push   $0x801072e7
80100097:	50                   	push   %eax
80100098:	e8 63 43 00 00       	call   80104400 <initsleeplock>
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
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

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
801000e4:	e8 37 46 00 00       	call   80104720 <acquire>
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
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
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
80100162:	e8 59 45 00 00       	call   801046c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 42 00 00       	call   80104440 <acquiresleep>
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
8010018c:	e8 bf 22 00 00       	call   80102450 <iderw>
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
801001a1:	68 ee 72 10 80       	push   $0x801072ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

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
801001be:	e8 1d 43 00 00       	call   801044e0 <holdingsleep>
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
801001d4:	e9 77 22 00 00       	jmp    80102450 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 72 10 80       	push   $0x801072ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

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
801001ff:	e8 dc 42 00 00       	call   801044e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 42 00 00       	call   801044a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 00 45 00 00       	call   80104720 <acquire>
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
80100269:	e9 52 44 00 00       	jmp    801046c0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 06 73 10 80       	push   $0x80107306
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
80100294:	e8 67 17 00 00       	call   80101a00 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 7b 44 00 00       	call   80104720 <acquire>
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
801002cd:	e8 ce 3e 00 00       	call   801041a0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 f9 37 00 00       	call   80103ae0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 c5 43 00 00       	call   801046c0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 1c 16 00 00       	call   80101920 <ilock>
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
8010034c:	e8 6f 43 00 00       	call   801046c0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 c6 15 00 00       	call   80101920 <ilock>
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
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
80100399:	e8 b2 26 00 00       	call   80102a50 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 73 10 80       	push   $0x8010730d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 d8 77 10 80 	movl   $0x801077d8,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 83 41 00 00       	call   80104550 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 73 10 80       	push   $0x80107321
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
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

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
8010041f:	e8 0c 5a 00 00       	call   80105e30 <uartputc>
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
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 41 59 00 00       	call   80105e30 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 35 59 00 00       	call   80105e30 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 29 59 00 00       	call   80105e30 <uartputc>
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
80100561:	e8 4a 43 00 00       	call   801048b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 a5 42 00 00       	call   80104820 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 25 73 10 80       	push   $0x80107325
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
801005bf:	e8 3c 14 00 00       	call   80101a00 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 50 41 00 00       	call   80104720 <acquire>
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
80100604:	e8 b7 40 00 00       	call   801046c0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 0e 13 00 00       	call   80101920 <ilock>

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
8010064b:	0f b6 92 40 78 10 80 	movzbl -0x7fef87c0(%edx),%edx
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
801007d8:	e8 43 3f 00 00       	call   80104720 <acquire>
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
801007fb:	e8 c0 3e 00 00       	call   801046c0 <release>
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
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 38 73 10 80       	mov    $0x80107338,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
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
8010088c:	68 3f 73 10 80       	push   $0x8010733f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <autocomplete>:
void autocomplete() {
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
801008a4:	56                   	push   %esi
801008a5:	53                   	push   %ebx
801008a6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
    int start = input.e - 1;      // Position to find the start of the current word
801008ac:	8b 3d 08 ef 10 80    	mov    0x8010ef08,%edi
    while (start >= input.r && input.buf[start % INPUT_BUF] != ' ') {
801008b2:	8b 1d 00 ef 10 80    	mov    0x8010ef00,%ebx
    int start = input.e - 1;      // Position to find the start of the current word
801008b8:	8d 47 ff             	lea    -0x1(%edi),%eax
    while (start >= input.r && input.buf[start % INPUT_BUF] != ' ') {
801008bb:	39 d8                	cmp    %ebx,%eax
801008bd:	73 12                	jae    801008d1 <autocomplete+0x31>
801008bf:	e9 f5 00 00 00       	jmp    801009b9 <autocomplete+0x119>
801008c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        start--;
801008c8:	8d 50 ff             	lea    -0x1(%eax),%edx
    while (start >= input.r && input.buf[start % INPUT_BUF] != ' ') {
801008cb:	39 da                	cmp    %ebx,%edx
801008cd:	72 1e                	jb     801008ed <autocomplete+0x4d>
801008cf:	89 d0                	mov    %edx,%eax
801008d1:	89 c1                	mov    %eax,%ecx
801008d3:	c1 f9 1f             	sar    $0x1f,%ecx
801008d6:	c1 e9 19             	shr    $0x19,%ecx
801008d9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
801008dc:	83 e2 7f             	and    $0x7f,%edx
801008df:	29 ca                	sub    %ecx,%edx
801008e1:	80 ba 80 ee 10 80 20 	cmpb   $0x20,-0x7fef1180(%edx)
801008e8:	75 de                	jne    801008c8 <autocomplete+0x28>
    start++;  // Move to the first character of the current word
801008ea:	83 c0 01             	add    $0x1,%eax
    int word_len = input.e - start;
801008ed:	89 fe                	mov    %edi,%esi
        buf[i] = input.buf[(start + i) % INPUT_BUF];
801008ef:	8d 9d 68 ff ff ff    	lea    -0x98(%ebp),%ebx
    int word_len = input.e - start;
801008f5:	29 c6                	sub    %eax,%esi
        buf[i] = input.buf[(start + i) % INPUT_BUF];
801008f7:	29 c3                	sub    %eax,%ebx
    for (int i = 0; i < word_len; i++) {
801008f9:	85 f6                	test   %esi,%esi
801008fb:	7e 24                	jle    80100921 <autocomplete+0x81>
801008fd:	8d 76 00             	lea    0x0(%esi),%esi
        buf[i] = input.buf[(start + i) % INPUT_BUF];
80100900:	89 c1                	mov    %eax,%ecx
80100902:	c1 f9 1f             	sar    $0x1f,%ecx
80100905:	c1 e9 19             	shr    $0x19,%ecx
80100908:	8d 14 08             	lea    (%eax,%ecx,1),%edx
8010090b:	83 e2 7f             	and    $0x7f,%edx
8010090e:	29 ca                	sub    %ecx,%edx
80100910:	0f b6 92 80 ee 10 80 	movzbl -0x7fef1180(%edx),%edx
80100917:	88 14 03             	mov    %dl,(%ebx,%eax,1)
    for (int i = 0; i < word_len; i++) {
8010091a:	83 c0 01             	add    $0x1,%eax
8010091d:	39 c7                	cmp    %eax,%edi
8010091f:	75 df                	jne    80100900 <autocomplete+0x60>
    buf[word_len] = '\0';
80100921:	c6 84 35 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%esi,1)
80100928:	00 
    for (int i = 0; i < NUM_COMMANDS; i++) {
80100929:	31 ff                	xor    %edi,%edi
8010092b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        if (strncmp(buf, commands[i], word_len) == 0) {
80100930:	8b 1c bd 60 78 10 80 	mov    -0x7fef87a0(,%edi,4),%ebx
80100937:	83 ec 04             	sub    $0x4,%esp
8010093a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80100940:	56                   	push   %esi
80100941:	53                   	push   %ebx
80100942:	50                   	push   %eax
80100943:	e8 d8 3f 00 00       	call   80104920 <strncmp>
80100948:	83 c4 10             	add    $0x10,%esp
8010094b:	85 c0                	test   %eax,%eax
8010094d:	74 11                	je     80100960 <autocomplete+0xc0>
    for (int i = 0; i < NUM_COMMANDS; i++) {
8010094f:	83 c7 01             	add    $0x1,%edi
80100952:	83 ff 10             	cmp    $0x10,%edi
80100955:	75 d9                	jne    80100930 <autocomplete+0x90>
}
80100957:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010095a:	5b                   	pop    %ebx
8010095b:	5e                   	pop    %esi
8010095c:	5f                   	pop    %edi
8010095d:	5d                   	pop    %ebp
8010095e:	c3                   	ret
8010095f:	90                   	nop
    if (match) {
80100960:	85 db                	test   %ebx,%ebx
80100962:	74 f3                	je     80100957 <autocomplete+0xb7>
        int match_len = strlen(match);
80100964:	83 ec 0c             	sub    $0xc,%esp
80100967:	53                   	push   %ebx
80100968:	e8 a3 40 00 00       	call   80104a10 <strlen>
        for (int i = word_len; i < match_len; i++) {
8010096d:	83 c4 10             	add    $0x10,%esp
80100970:	39 c6                	cmp    %eax,%esi
80100972:	7d e3                	jge    80100957 <autocomplete+0xb7>
80100974:	01 de                	add    %ebx,%esi
80100976:	01 c3                	add    %eax,%ebx
  if(panicked){
80100978:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
            consputc(match[i]);
8010097e:	0f be 06             	movsbl (%esi),%eax
  if(panicked){
80100981:	85 d2                	test   %edx,%edx
80100983:	74 0b                	je     80100990 <autocomplete+0xf0>
80100985:	fa                   	cli
    for(;;)
80100986:	eb fe                	jmp    80100986 <autocomplete+0xe6>
80100988:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010098f:	00 
80100990:	e8 6b fa ff ff       	call   80100400 <consputc.part.0>
            input.buf[(input.e++) % INPUT_BUF] = match[i];
80100995:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
        for (int i = word_len; i < match_len; i++) {
8010099a:	83 c6 01             	add    $0x1,%esi
            input.buf[(input.e++) % INPUT_BUF] = match[i];
8010099d:	8d 50 01             	lea    0x1(%eax),%edx
801009a0:	83 e0 7f             	and    $0x7f,%eax
801009a3:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
801009a9:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
801009ad:	88 90 80 ee 10 80    	mov    %dl,-0x7fef1180(%eax)
        for (int i = word_len; i < match_len; i++) {
801009b3:	39 f3                	cmp    %esi,%ebx
801009b5:	75 c1                	jne    80100978 <autocomplete+0xd8>
801009b7:	eb 9e                	jmp    80100957 <autocomplete+0xb7>
    start++;  // Move to the first character of the current word
801009b9:	89 f8                	mov    %edi,%eax
801009bb:	e9 2d ff ff ff       	jmp    801008ed <autocomplete+0x4d>

801009c0 <consoleintr>:
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	57                   	push   %edi
  int c, doprocdump = 0;
801009c4:	31 ff                	xor    %edi,%edi
{
801009c6:	56                   	push   %esi
801009c7:	53                   	push   %ebx
801009c8:	83 ec 18             	sub    $0x18,%esp
801009cb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801009ce:	68 20 ef 10 80       	push   $0x8010ef20
801009d3:	e8 48 3d 00 00       	call   80104720 <acquire>
  while((c = getc()) >= 0){
801009d8:	83 c4 10             	add    $0x10,%esp
801009db:	ff d6                	call   *%esi
801009dd:	89 c3                	mov    %eax,%ebx
801009df:	85 c0                	test   %eax,%eax
801009e1:	78 2a                	js     80100a0d <consoleintr+0x4d>
    switch(c){
801009e3:	83 fb 10             	cmp    $0x10,%ebx
801009e6:	0f 84 cc 01 00 00    	je     80100bb8 <consoleintr+0x1f8>
801009ec:	7f 42                	jg     80100a30 <consoleintr+0x70>
801009ee:	83 fb 08             	cmp    $0x8,%ebx
801009f1:	0f 84 89 01 00 00    	je     80100b80 <consoleintr+0x1c0>
801009f7:	83 fb 09             	cmp    $0x9,%ebx
801009fa:	0f 85 b0 00 00 00    	jne    80100ab0 <consoleintr+0xf0>
      autocomplete();
80100a00:	e8 9b fe ff ff       	call   801008a0 <autocomplete>
  while((c = getc()) >= 0){
80100a05:	ff d6                	call   *%esi
80100a07:	89 c3                	mov    %eax,%ebx
80100a09:	85 c0                	test   %eax,%eax
80100a0b:	79 d6                	jns    801009e3 <consoleintr+0x23>
  release(&cons.lock);
80100a0d:	83 ec 0c             	sub    $0xc,%esp
80100a10:	68 20 ef 10 80       	push   $0x8010ef20
80100a15:	e8 a6 3c 00 00       	call   801046c0 <release>
  if(doprocdump) {
80100a1a:	83 c4 10             	add    $0x10,%esp
80100a1d:	85 ff                	test   %edi,%edi
80100a1f:	0f 85 ab 01 00 00    	jne    80100bd0 <consoleintr+0x210>
}
80100a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a28:	5b                   	pop    %ebx
80100a29:	5e                   	pop    %esi
80100a2a:	5f                   	pop    %edi
80100a2b:	5d                   	pop    %ebp
80100a2c:	c3                   	ret
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100a30:	83 fb 15             	cmp    $0x15,%ebx
80100a33:	74 3d                	je     80100a72 <consoleintr+0xb2>
80100a35:	83 fb 7f             	cmp    $0x7f,%ebx
80100a38:	0f 85 df 00 00 00    	jne    80100b1d <consoleintr+0x15d>
        if (input.e != input.w) {
80100a3e:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a43:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a49:	74 90                	je     801009db <consoleintr+0x1b>
  if(panicked){
80100a4b:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100a51:	83 e8 01             	sub    $0x1,%eax
80100a54:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a59:	85 d2                	test   %edx,%edx
80100a5b:	0f 84 41 01 00 00    	je     80100ba2 <consoleintr+0x1e2>
80100a61:	fa                   	cli
    for(;;)
80100a62:	eb fe                	jmp    80100a62 <consoleintr+0xa2>
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a68:	b8 00 01 00 00       	mov    $0x100,%eax
80100a6d:	e8 8e f9 ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100a72:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a77:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a7d:	0f 84 58 ff ff ff    	je     801009db <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a83:	83 e8 01             	sub    $0x1,%eax
80100a86:	89 c2                	mov    %eax,%edx
80100a88:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a8b:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100a92:	0f 84 43 ff ff ff    	je     801009db <consoleintr+0x1b>
  if(panicked){
80100a98:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.e--;
80100a9e:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100aa3:	85 c9                	test   %ecx,%ecx
80100aa5:	74 c1                	je     80100a68 <consoleintr+0xa8>
80100aa7:	fa                   	cli
    for(;;)
80100aa8:	eb fe                	jmp    80100aa8 <consoleintr+0xe8>
80100aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100ab0:	85 db                	test   %ebx,%ebx
80100ab2:	0f 84 23 ff ff ff    	je     801009db <consoleintr+0x1b>
80100ab8:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100abd:	89 c2                	mov    %eax,%edx
80100abf:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100ac5:	83 fa 7f             	cmp    $0x7f,%edx
80100ac8:	0f 87 0d ff ff ff    	ja     801009db <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100ace:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100ad1:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100ad7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100ada:	83 fb 0d             	cmp    $0xd,%ebx
80100add:	75 60                	jne    80100b3f <consoleintr+0x17f>
        input.buf[input.e++ % INPUT_BUF] = c;
80100adf:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100ae5:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100aec:	85 c9                	test   %ecx,%ecx
80100aee:	0f 85 d4 00 00 00    	jne    80100bc8 <consoleintr+0x208>
80100af4:	b8 0a 00 00 00       	mov    $0xa,%eax
80100af9:	e8 02 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100afe:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100b03:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100b06:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100b0b:	68 00 ef 10 80       	push   $0x8010ef00
80100b10:	e8 4b 37 00 00       	call   80104260 <wakeup>
80100b15:	83 c4 10             	add    $0x10,%esp
80100b18:	e9 be fe ff ff       	jmp    801009db <consoleintr+0x1b>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100b1d:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b22:	89 c2                	mov    %eax,%edx
80100b24:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100b2a:	83 fa 7f             	cmp    $0x7f,%edx
80100b2d:	0f 87 a8 fe ff ff    	ja     801009db <consoleintr+0x1b>
  if(panicked){
80100b33:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100b39:	8d 50 01             	lea    0x1(%eax),%edx
80100b3c:	83 e0 7f             	and    $0x7f,%eax
80100b3f:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100b45:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100b4b:	85 c9                	test   %ecx,%ecx
80100b4d:	75 79                	jne    80100bc8 <consoleintr+0x208>
80100b4f:	89 d8                	mov    %ebx,%eax
80100b51:	e8 aa f8 ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b56:	83 fb 0a             	cmp    $0xa,%ebx
80100b59:	74 a3                	je     80100afe <consoleintr+0x13e>
80100b5b:	83 fb 04             	cmp    $0x4,%ebx
80100b5e:	74 9e                	je     80100afe <consoleintr+0x13e>
80100b60:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100b65:	83 e8 80             	sub    $0xffffff80,%eax
80100b68:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100b6e:	0f 85 67 fe ff ff    	jne    801009db <consoleintr+0x1b>
80100b74:	eb 8d                	jmp    80100b03 <consoleintr+0x143>
80100b76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100b7d:	00 
80100b7e:	66 90                	xchg   %ax,%ax
      if(input.e != input.w){
80100b80:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b85:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100b8b:	0f 84 4a fe ff ff    	je     801009db <consoleintr+0x1b>
        input.e--;
80100b91:	83 e8 01             	sub    $0x1,%eax
80100b94:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100b99:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100b9e:	85 c0                	test   %eax,%eax
80100ba0:	75 20                	jne    80100bc2 <consoleintr+0x202>
80100ba2:	b8 00 01 00 00       	mov    $0x100,%eax
80100ba7:	e8 54 f8 ff ff       	call   80100400 <consputc.part.0>
80100bac:	e9 2a fe ff ff       	jmp    801009db <consoleintr+0x1b>
80100bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100bb8:	bf 01 00 00 00       	mov    $0x1,%edi
80100bbd:	e9 19 fe ff ff       	jmp    801009db <consoleintr+0x1b>
80100bc2:	fa                   	cli
    for(;;)
80100bc3:	eb fe                	jmp    80100bc3 <consoleintr+0x203>
80100bc5:	8d 76 00             	lea    0x0(%esi),%esi
80100bc8:	fa                   	cli
80100bc9:	eb fe                	jmp    80100bc9 <consoleintr+0x209>
80100bcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80100bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100bd3:	5b                   	pop    %ebx
80100bd4:	5e                   	pop    %esi
80100bd5:	5f                   	pop    %edi
80100bd6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100bd7:	e9 64 37 00 00       	jmp    80104340 <procdump>
80100bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100be0 <consoleinit>:

void
consoleinit(void)
{
80100be0:	55                   	push   %ebp
80100be1:	89 e5                	mov    %esp,%ebp
80100be3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100be6:	68 48 73 10 80       	push   $0x80107348
80100beb:	68 20 ef 10 80       	push   $0x8010ef20
80100bf0:	e8 3b 39 00 00       	call   80104530 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100bf5:	58                   	pop    %eax
80100bf6:	5a                   	pop    %edx
80100bf7:	6a 00                	push   $0x0
80100bf9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100bfb:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100c02:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100c05:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100c0c:	02 10 80 
  cons.locking = 1;
80100c0f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100c16:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100c19:	e8 c2 19 00 00       	call   801025e0 <ioapicenable>
}
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	c9                   	leave
80100c22:	c3                   	ret
80100c23:	66 90                	xchg   %ax,%ax
80100c25:	66 90                	xchg   %ax,%ax
80100c27:	66 90                	xchg   %ax,%ax
80100c29:	66 90                	xchg   %ax,%ax
80100c2b:	66 90                	xchg   %ax,%ax
80100c2d:	66 90                	xchg   %ax,%ax
80100c2f:	90                   	nop

80100c30 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c30:	55                   	push   %ebp
80100c31:	89 e5                	mov    %esp,%ebp
80100c33:	57                   	push   %edi
80100c34:	56                   	push   %esi
80100c35:	53                   	push   %ebx
80100c36:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c3c:	e8 9f 2e 00 00       	call   80103ae0 <myproc>
80100c41:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100c47:	e8 74 22 00 00       	call   80102ec0 <begin_op>

  if((ip = namei(path)) == 0){
80100c4c:	83 ec 0c             	sub    $0xc,%esp
80100c4f:	ff 75 08             	push   0x8(%ebp)
80100c52:	e8 a9 15 00 00       	call   80102200 <namei>
80100c57:	83 c4 10             	add    $0x10,%esp
80100c5a:	85 c0                	test   %eax,%eax
80100c5c:	0f 84 30 03 00 00    	je     80100f92 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c62:	83 ec 0c             	sub    $0xc,%esp
80100c65:	89 c7                	mov    %eax,%edi
80100c67:	50                   	push   %eax
80100c68:	e8 b3 0c 00 00       	call   80101920 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c6d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c73:	6a 34                	push   $0x34
80100c75:	6a 00                	push   $0x0
80100c77:	50                   	push   %eax
80100c78:	57                   	push   %edi
80100c79:	e8 b2 0f 00 00       	call   80101c30 <readi>
80100c7e:	83 c4 20             	add    $0x20,%esp
80100c81:	83 f8 34             	cmp    $0x34,%eax
80100c84:	0f 85 01 01 00 00    	jne    80100d8b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c8a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c91:	45 4c 46 
80100c94:	0f 85 f1 00 00 00    	jne    80100d8b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c9a:	e8 01 63 00 00       	call   80106fa0 <setupkvm>
80100c9f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ca5:	85 c0                	test   %eax,%eax
80100ca7:	0f 84 de 00 00 00    	je     80100d8b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cad:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100cb4:	00 
80100cb5:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100cbb:	0f 84 a1 02 00 00    	je     80100f62 <exec+0x332>
  sz = 0;
80100cc1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100cc8:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ccb:	31 db                	xor    %ebx,%ebx
80100ccd:	e9 8c 00 00 00       	jmp    80100d5e <exec+0x12e>
80100cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cd8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100cdf:	75 6c                	jne    80100d4d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100ce1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ce7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ced:	0f 82 87 00 00 00    	jb     80100d7a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cf3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cf9:	72 7f                	jb     80100d7a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cfb:	83 ec 04             	sub    $0x4,%esp
80100cfe:	50                   	push   %eax
80100cff:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100d05:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d0b:	e8 c0 60 00 00       	call   80106dd0 <allocuvm>
80100d10:	83 c4 10             	add    $0x10,%esp
80100d13:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d19:	85 c0                	test   %eax,%eax
80100d1b:	74 5d                	je     80100d7a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d1d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100d23:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d28:	75 50                	jne    80100d7a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100d33:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100d39:	57                   	push   %edi
80100d3a:	50                   	push   %eax
80100d3b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d41:	e8 ba 5f 00 00       	call   80106d00 <loaduvm>
80100d46:	83 c4 20             	add    $0x20,%esp
80100d49:	85 c0                	test   %eax,%eax
80100d4b:	78 2d                	js     80100d7a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d54:	83 c3 01             	add    $0x1,%ebx
80100d57:	83 c6 20             	add    $0x20,%esi
80100d5a:	39 d8                	cmp    %ebx,%eax
80100d5c:	7e 52                	jle    80100db0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d5e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d64:	6a 20                	push   $0x20
80100d66:	56                   	push   %esi
80100d67:	50                   	push   %eax
80100d68:	57                   	push   %edi
80100d69:	e8 c2 0e 00 00       	call   80101c30 <readi>
80100d6e:	83 c4 10             	add    $0x10,%esp
80100d71:	83 f8 20             	cmp    $0x20,%eax
80100d74:	0f 84 5e ff ff ff    	je     80100cd8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100d7a:	83 ec 0c             	sub    $0xc,%esp
80100d7d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d83:	e8 98 61 00 00       	call   80106f20 <freevm>
  if(ip){
80100d88:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100d8b:	83 ec 0c             	sub    $0xc,%esp
80100d8e:	57                   	push   %edi
80100d8f:	e8 1c 0e 00 00       	call   80101bb0 <iunlockput>
    end_op();
80100d94:	e8 97 21 00 00       	call   80102f30 <end_op>
80100d99:	83 c4 10             	add    $0x10,%esp
    return -1;
80100d9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100da4:	5b                   	pop    %ebx
80100da5:	5e                   	pop    %esi
80100da6:	5f                   	pop    %edi
80100da7:	5d                   	pop    %ebp
80100da8:	c3                   	ret
80100da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100db0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100db6:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100dbc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100dc2:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100dc8:	83 ec 0c             	sub    $0xc,%esp
80100dcb:	57                   	push   %edi
80100dcc:	e8 df 0d 00 00       	call   80101bb0 <iunlockput>
  end_op();
80100dd1:	e8 5a 21 00 00       	call   80102f30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100dd6:	83 c4 0c             	add    $0xc,%esp
80100dd9:	53                   	push   %ebx
80100dda:	56                   	push   %esi
80100ddb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100de1:	56                   	push   %esi
80100de2:	e8 e9 5f 00 00       	call   80106dd0 <allocuvm>
80100de7:	83 c4 10             	add    $0x10,%esp
80100dea:	89 c7                	mov    %eax,%edi
80100dec:	85 c0                	test   %eax,%eax
80100dee:	0f 84 86 00 00 00    	je     80100e7a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100df4:	83 ec 08             	sub    $0x8,%esp
80100df7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100dfd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dff:	50                   	push   %eax
80100e00:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100e01:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e03:	e8 38 62 00 00       	call   80107040 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100e08:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e0b:	83 c4 10             	add    $0x10,%esp
80100e0e:	8b 10                	mov    (%eax),%edx
80100e10:	85 d2                	test   %edx,%edx
80100e12:	0f 84 56 01 00 00    	je     80100f6e <exec+0x33e>
80100e18:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100e1e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100e21:	eb 23                	jmp    80100e46 <exec+0x216>
80100e23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e28:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100e2b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100e32:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100e38:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100e3b:	85 d2                	test   %edx,%edx
80100e3d:	74 51                	je     80100e90 <exec+0x260>
    if(argc >= MAXARG)
80100e3f:	83 f8 20             	cmp    $0x20,%eax
80100e42:	74 36                	je     80100e7a <exec+0x24a>
80100e44:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e46:	83 ec 0c             	sub    $0xc,%esp
80100e49:	52                   	push   %edx
80100e4a:	e8 c1 3b 00 00       	call   80104a10 <strlen>
80100e4f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e51:	58                   	pop    %eax
80100e52:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e55:	83 eb 01             	sub    $0x1,%ebx
80100e58:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e5b:	e8 b0 3b 00 00       	call   80104a10 <strlen>
80100e60:	83 c0 01             	add    $0x1,%eax
80100e63:	50                   	push   %eax
80100e64:	ff 34 b7             	push   (%edi,%esi,4)
80100e67:	53                   	push   %ebx
80100e68:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e6e:	e8 9d 63 00 00       	call   80107210 <copyout>
80100e73:	83 c4 20             	add    $0x20,%esp
80100e76:	85 c0                	test   %eax,%eax
80100e78:	79 ae                	jns    80100e28 <exec+0x1f8>
    freevm(pgdir);
80100e7a:	83 ec 0c             	sub    $0xc,%esp
80100e7d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e83:	e8 98 60 00 00       	call   80106f20 <freevm>
80100e88:	83 c4 10             	add    $0x10,%esp
80100e8b:	e9 0c ff ff ff       	jmp    80100d9c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e90:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100e97:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100e9d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ea3:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100ea6:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100ea9:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100eb0:	00 00 00 00 
  ustack[1] = argc;
80100eb4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100eba:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ec1:	ff ff ff 
  ustack[1] = argc;
80100ec4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100eca:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100ecc:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ece:	29 d0                	sub    %edx,%eax
80100ed0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ed6:	56                   	push   %esi
80100ed7:	51                   	push   %ecx
80100ed8:	53                   	push   %ebx
80100ed9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100edf:	e8 2c 63 00 00       	call   80107210 <copyout>
80100ee4:	83 c4 10             	add    $0x10,%esp
80100ee7:	85 c0                	test   %eax,%eax
80100ee9:	78 8f                	js     80100e7a <exec+0x24a>
  for(last=s=path; *s; s++)
80100eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80100eee:	8b 55 08             	mov    0x8(%ebp),%edx
80100ef1:	0f b6 00             	movzbl (%eax),%eax
80100ef4:	84 c0                	test   %al,%al
80100ef6:	74 17                	je     80100f0f <exec+0x2df>
80100ef8:	89 d1                	mov    %edx,%ecx
80100efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100f00:	83 c1 01             	add    $0x1,%ecx
80100f03:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100f05:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100f08:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100f0b:	84 c0                	test   %al,%al
80100f0d:	75 f1                	jne    80100f00 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f0f:	83 ec 04             	sub    $0x4,%esp
80100f12:	6a 10                	push   $0x10
80100f14:	52                   	push   %edx
80100f15:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100f1b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100f1e:	50                   	push   %eax
80100f1f:	e8 ac 3a 00 00       	call   801049d0 <safestrcpy>
  curproc->pgdir = pgdir;
80100f24:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100f2a:	89 f0                	mov    %esi,%eax
80100f2c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100f2f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100f31:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f34:	89 c1                	mov    %eax,%ecx
80100f36:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100f3c:	8b 40 18             	mov    0x18(%eax),%eax
80100f3f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f42:	8b 41 18             	mov    0x18(%ecx),%eax
80100f45:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100f48:	89 0c 24             	mov    %ecx,(%esp)
80100f4b:	e8 20 5c 00 00       	call   80106b70 <switchuvm>
  freevm(oldpgdir);
80100f50:	89 34 24             	mov    %esi,(%esp)
80100f53:	e8 c8 5f 00 00       	call   80106f20 <freevm>
  return 0;
80100f58:	83 c4 10             	add    $0x10,%esp
80100f5b:	31 c0                	xor    %eax,%eax
80100f5d:	e9 3f fe ff ff       	jmp    80100da1 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f62:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100f67:	31 f6                	xor    %esi,%esi
80100f69:	e9 5a fe ff ff       	jmp    80100dc8 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100f6e:	be 10 00 00 00       	mov    $0x10,%esi
80100f73:	ba 04 00 00 00       	mov    $0x4,%edx
80100f78:	b8 03 00 00 00       	mov    $0x3,%eax
80100f7d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100f84:	00 00 00 
80100f87:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100f8d:	e9 17 ff ff ff       	jmp    80100ea9 <exec+0x279>
    end_op();
80100f92:	e8 99 1f 00 00       	call   80102f30 <end_op>
    cprintf("exec: fail\n");
80100f97:	83 ec 0c             	sub    $0xc,%esp
80100f9a:	68 a0 73 10 80       	push   $0x801073a0
80100f9f:	e8 0c f7 ff ff       	call   801006b0 <cprintf>
    return -1;
80100fa4:	83 c4 10             	add    $0x10,%esp
80100fa7:	e9 f0 fd ff ff       	jmp    80100d9c <exec+0x16c>
80100fac:	66 90                	xchg   %ax,%ax
80100fae:	66 90                	xchg   %ax,%ax

80100fb0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100fb6:	68 ac 73 10 80       	push   $0x801073ac
80100fbb:	68 60 ef 10 80       	push   $0x8010ef60
80100fc0:	e8 6b 35 00 00       	call   80104530 <initlock>
}
80100fc5:	83 c4 10             	add    $0x10,%esp
80100fc8:	c9                   	leave
80100fc9:	c3                   	ret
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100fd0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fd4:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100fd9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100fdc:	68 60 ef 10 80       	push   $0x8010ef60
80100fe1:	e8 3a 37 00 00       	call   80104720 <acquire>
80100fe6:	83 c4 10             	add    $0x10,%esp
80100fe9:	eb 10                	jmp    80100ffb <filealloc+0x2b>
80100feb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ff0:	83 c3 18             	add    $0x18,%ebx
80100ff3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ff9:	74 25                	je     80101020 <filealloc+0x50>
    if(f->ref == 0){
80100ffb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ffe:	85 c0                	test   %eax,%eax
80101000:	75 ee                	jne    80100ff0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101002:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101005:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010100c:	68 60 ef 10 80       	push   $0x8010ef60
80101011:	e8 aa 36 00 00       	call   801046c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101016:	89 d8                	mov    %ebx,%eax
      return f;
80101018:	83 c4 10             	add    $0x10,%esp
}
8010101b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010101e:	c9                   	leave
8010101f:	c3                   	ret
  release(&ftable.lock);
80101020:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101023:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101025:	68 60 ef 10 80       	push   $0x8010ef60
8010102a:	e8 91 36 00 00       	call   801046c0 <release>
}
8010102f:	89 d8                	mov    %ebx,%eax
  return 0;
80101031:	83 c4 10             	add    $0x10,%esp
}
80101034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101037:	c9                   	leave
80101038:	c3                   	ret
80101039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101040 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 10             	sub    $0x10,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010104a:	68 60 ef 10 80       	push   $0x8010ef60
8010104f:	e8 cc 36 00 00       	call   80104720 <acquire>
  if(f->ref < 1)
80101054:	8b 43 04             	mov    0x4(%ebx),%eax
80101057:	83 c4 10             	add    $0x10,%esp
8010105a:	85 c0                	test   %eax,%eax
8010105c:	7e 1a                	jle    80101078 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010105e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101061:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101064:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101067:	68 60 ef 10 80       	push   $0x8010ef60
8010106c:	e8 4f 36 00 00       	call   801046c0 <release>
  return f;
}
80101071:	89 d8                	mov    %ebx,%eax
80101073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101076:	c9                   	leave
80101077:	c3                   	ret
    panic("filedup");
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	68 b3 73 10 80       	push   $0x801073b3
80101080:	e8 fb f2 ff ff       	call   80100380 <panic>
80101085:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010108c:	00 
8010108d:	8d 76 00             	lea    0x0(%esi),%esi

80101090 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 28             	sub    $0x28,%esp
80101099:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010109c:	68 60 ef 10 80       	push   $0x8010ef60
801010a1:	e8 7a 36 00 00       	call   80104720 <acquire>
  if(f->ref < 1)
801010a6:	8b 53 04             	mov    0x4(%ebx),%edx
801010a9:	83 c4 10             	add    $0x10,%esp
801010ac:	85 d2                	test   %edx,%edx
801010ae:	0f 8e a5 00 00 00    	jle    80101159 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801010b4:	83 ea 01             	sub    $0x1,%edx
801010b7:	89 53 04             	mov    %edx,0x4(%ebx)
801010ba:	75 44                	jne    80101100 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801010bc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801010c0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801010c3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801010c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801010cb:	8b 73 0c             	mov    0xc(%ebx),%esi
801010ce:	88 45 e7             	mov    %al,-0x19(%ebp)
801010d1:	8b 43 10             	mov    0x10(%ebx),%eax
801010d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801010d7:	68 60 ef 10 80       	push   $0x8010ef60
801010dc:	e8 df 35 00 00       	call   801046c0 <release>

  if(ff.type == FD_PIPE)
801010e1:	83 c4 10             	add    $0x10,%esp
801010e4:	83 ff 01             	cmp    $0x1,%edi
801010e7:	74 57                	je     80101140 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801010e9:	83 ff 02             	cmp    $0x2,%edi
801010ec:	74 2a                	je     80101118 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801010ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f1:	5b                   	pop    %ebx
801010f2:	5e                   	pop    %esi
801010f3:	5f                   	pop    %edi
801010f4:	5d                   	pop    %ebp
801010f5:	c3                   	ret
801010f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801010fd:	00 
801010fe:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101100:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80101107:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010110e:	e9 ad 35 00 00       	jmp    801046c0 <release>
80101113:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101118:	e8 a3 1d 00 00       	call   80102ec0 <begin_op>
    iput(ff.ip);
8010111d:	83 ec 0c             	sub    $0xc,%esp
80101120:	ff 75 e0             	push   -0x20(%ebp)
80101123:	e8 28 09 00 00       	call   80101a50 <iput>
    end_op();
80101128:	83 c4 10             	add    $0x10,%esp
}
8010112b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010112e:	5b                   	pop    %ebx
8010112f:	5e                   	pop    %esi
80101130:	5f                   	pop    %edi
80101131:	5d                   	pop    %ebp
    end_op();
80101132:	e9 f9 1d 00 00       	jmp    80102f30 <end_op>
80101137:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010113e:	00 
8010113f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101140:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101144:	83 ec 08             	sub    $0x8,%esp
80101147:	53                   	push   %ebx
80101148:	56                   	push   %esi
80101149:	e8 32 25 00 00       	call   80103680 <pipeclose>
8010114e:	83 c4 10             	add    $0x10,%esp
}
80101151:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101154:	5b                   	pop    %ebx
80101155:	5e                   	pop    %esi
80101156:	5f                   	pop    %edi
80101157:	5d                   	pop    %ebp
80101158:	c3                   	ret
    panic("fileclose");
80101159:	83 ec 0c             	sub    $0xc,%esp
8010115c:	68 bb 73 10 80       	push   $0x801073bb
80101161:	e8 1a f2 ff ff       	call   80100380 <panic>
80101166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010116d:	00 
8010116e:	66 90                	xchg   %ax,%ax

80101170 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	53                   	push   %ebx
80101174:	83 ec 04             	sub    $0x4,%esp
80101177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010117a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010117d:	75 31                	jne    801011b0 <filestat+0x40>
    ilock(f->ip);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 73 10             	push   0x10(%ebx)
80101185:	e8 96 07 00 00       	call   80101920 <ilock>
    stati(f->ip, st);
8010118a:	58                   	pop    %eax
8010118b:	5a                   	pop    %edx
8010118c:	ff 75 0c             	push   0xc(%ebp)
8010118f:	ff 73 10             	push   0x10(%ebx)
80101192:	e8 69 0a 00 00       	call   80101c00 <stati>
    iunlock(f->ip);
80101197:	59                   	pop    %ecx
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 60 08 00 00       	call   80101a00 <iunlock>
    return 0;
  }
  return -1;
}
801011a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	31 c0                	xor    %eax,%eax
}
801011a8:	c9                   	leave
801011a9:	c3                   	ret
801011aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801011b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011b8:	c9                   	leave
801011b9:	c3                   	ret
801011ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011c0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 0c             	sub    $0xc,%esp
801011c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011cc:	8b 75 0c             	mov    0xc(%ebp),%esi
801011cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801011d2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801011d6:	74 60                	je     80101238 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801011d8:	8b 03                	mov    (%ebx),%eax
801011da:	83 f8 01             	cmp    $0x1,%eax
801011dd:	74 41                	je     80101220 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011df:	83 f8 02             	cmp    $0x2,%eax
801011e2:	75 5b                	jne    8010123f <fileread+0x7f>
    ilock(f->ip);
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	ff 73 10             	push   0x10(%ebx)
801011ea:	e8 31 07 00 00       	call   80101920 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011ef:	57                   	push   %edi
801011f0:	ff 73 14             	push   0x14(%ebx)
801011f3:	56                   	push   %esi
801011f4:	ff 73 10             	push   0x10(%ebx)
801011f7:	e8 34 0a 00 00       	call   80101c30 <readi>
801011fc:	83 c4 20             	add    $0x20,%esp
801011ff:	89 c6                	mov    %eax,%esi
80101201:	85 c0                	test   %eax,%eax
80101203:	7e 03                	jle    80101208 <fileread+0x48>
      f->off += r;
80101205:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101208:	83 ec 0c             	sub    $0xc,%esp
8010120b:	ff 73 10             	push   0x10(%ebx)
8010120e:	e8 ed 07 00 00       	call   80101a00 <iunlock>
    return r;
80101213:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101219:	89 f0                	mov    %esi,%eax
8010121b:	5b                   	pop    %ebx
8010121c:	5e                   	pop    %esi
8010121d:	5f                   	pop    %edi
8010121e:	5d                   	pop    %ebp
8010121f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101220:	8b 43 0c             	mov    0xc(%ebx),%eax
80101223:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101226:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101229:	5b                   	pop    %ebx
8010122a:	5e                   	pop    %esi
8010122b:	5f                   	pop    %edi
8010122c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010122d:	e9 0e 26 00 00       	jmp    80103840 <piperead>
80101232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101238:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010123d:	eb d7                	jmp    80101216 <fileread+0x56>
  panic("fileread");
8010123f:	83 ec 0c             	sub    $0xc,%esp
80101242:	68 c5 73 10 80       	push   $0x801073c5
80101247:	e8 34 f1 ff ff       	call   80100380 <panic>
8010124c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101250 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
80101259:	8b 45 0c             	mov    0xc(%ebp),%eax
8010125c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010125f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101262:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101265:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010126c:	0f 84 bb 00 00 00    	je     8010132d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101272:	8b 03                	mov    (%ebx),%eax
80101274:	83 f8 01             	cmp    $0x1,%eax
80101277:	0f 84 bf 00 00 00    	je     8010133c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010127d:	83 f8 02             	cmp    $0x2,%eax
80101280:	0f 85 c8 00 00 00    	jne    8010134e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101289:	31 f6                	xor    %esi,%esi
    while(i < n){
8010128b:	85 c0                	test   %eax,%eax
8010128d:	7f 30                	jg     801012bf <filewrite+0x6f>
8010128f:	e9 94 00 00 00       	jmp    80101328 <filewrite+0xd8>
80101294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101298:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010129e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801012a1:	ff 73 10             	push   0x10(%ebx)
801012a4:	e8 57 07 00 00       	call   80101a00 <iunlock>
      end_op();
801012a9:	e8 82 1c 00 00       	call   80102f30 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801012ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012b1:	83 c4 10             	add    $0x10,%esp
801012b4:	39 c7                	cmp    %eax,%edi
801012b6:	75 5c                	jne    80101314 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801012b8:	01 fe                	add    %edi,%esi
    while(i < n){
801012ba:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801012bd:	7e 69                	jle    80101328 <filewrite+0xd8>
      int n1 = n - i;
801012bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
801012c2:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801012c7:	29 f7                	sub    %esi,%edi
      if(n1 > max)
801012c9:	39 c7                	cmp    %eax,%edi
801012cb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801012ce:	e8 ed 1b 00 00       	call   80102ec0 <begin_op>
      ilock(f->ip);
801012d3:	83 ec 0c             	sub    $0xc,%esp
801012d6:	ff 73 10             	push   0x10(%ebx)
801012d9:	e8 42 06 00 00       	call   80101920 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012de:	57                   	push   %edi
801012df:	ff 73 14             	push   0x14(%ebx)
801012e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e5:	01 f0                	add    %esi,%eax
801012e7:	50                   	push   %eax
801012e8:	ff 73 10             	push   0x10(%ebx)
801012eb:	e8 40 0a 00 00       	call   80101d30 <writei>
801012f0:	83 c4 20             	add    $0x20,%esp
801012f3:	85 c0                	test   %eax,%eax
801012f5:	7f a1                	jg     80101298 <filewrite+0x48>
801012f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801012fa:	83 ec 0c             	sub    $0xc,%esp
801012fd:	ff 73 10             	push   0x10(%ebx)
80101300:	e8 fb 06 00 00       	call   80101a00 <iunlock>
      end_op();
80101305:	e8 26 1c 00 00       	call   80102f30 <end_op>
      if(r < 0)
8010130a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010130d:	83 c4 10             	add    $0x10,%esp
80101310:	85 c0                	test   %eax,%eax
80101312:	75 14                	jne    80101328 <filewrite+0xd8>
        panic("short filewrite");
80101314:	83 ec 0c             	sub    $0xc,%esp
80101317:	68 ce 73 10 80       	push   $0x801073ce
8010131c:	e8 5f f0 ff ff       	call   80100380 <panic>
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101328:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010132b:	74 05                	je     80101332 <filewrite+0xe2>
8010132d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101332:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101335:	89 f0                	mov    %esi,%eax
80101337:	5b                   	pop    %ebx
80101338:	5e                   	pop    %esi
80101339:	5f                   	pop    %edi
8010133a:	5d                   	pop    %ebp
8010133b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010133c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010133f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101342:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101345:	5b                   	pop    %ebx
80101346:	5e                   	pop    %esi
80101347:	5f                   	pop    %edi
80101348:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101349:	e9 d2 23 00 00       	jmp    80103720 <pipewrite>
  panic("filewrite");
8010134e:	83 ec 0c             	sub    $0xc,%esp
80101351:	68 d4 73 10 80       	push   $0x801073d4
80101356:	e8 25 f0 ff ff       	call   80100380 <panic>
8010135b:	66 90                	xchg   %ax,%ax
8010135d:	66 90                	xchg   %ax,%ax
8010135f:	90                   	nop

80101360 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101369:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010136f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101372:	85 c9                	test   %ecx,%ecx
80101374:	0f 84 8c 00 00 00    	je     80101406 <balloc+0xa6>
8010137a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010137c:	89 f8                	mov    %edi,%eax
8010137e:	83 ec 08             	sub    $0x8,%esp
80101381:	89 fe                	mov    %edi,%esi
80101383:	c1 f8 0c             	sar    $0xc,%eax
80101386:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010138c:	50                   	push   %eax
8010138d:	ff 75 dc             	push   -0x24(%ebp)
80101390:	e8 3b ed ff ff       	call   801000d0 <bread>
80101395:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101398:	83 c4 10             	add    $0x10,%esp
8010139b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010139e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
801013a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013a6:	31 c0                	xor    %eax,%eax
801013a8:	eb 32                	jmp    801013dc <balloc+0x7c>
801013aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013b0:	89 c1                	mov    %eax,%ecx
801013b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801013ba:	83 e1 07             	and    $0x7,%ecx
801013bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013bf:	89 c1                	mov    %eax,%ecx
801013c1:	c1 f9 03             	sar    $0x3,%ecx
801013c4:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
801013c9:	89 fa                	mov    %edi,%edx
801013cb:	85 df                	test   %ebx,%edi
801013cd:	74 49                	je     80101418 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013cf:	83 c0 01             	add    $0x1,%eax
801013d2:	83 c6 01             	add    $0x1,%esi
801013d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013da:	74 07                	je     801013e3 <balloc+0x83>
801013dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013df:	39 d6                	cmp    %edx,%esi
801013e1:	72 cd                	jb     801013b0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801013e3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801013e6:	83 ec 0c             	sub    $0xc,%esp
801013e9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013ec:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801013f2:	e8 f9 ed ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013f7:	83 c4 10             	add    $0x10,%esp
801013fa:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
80101400:	0f 82 76 ff ff ff    	jb     8010137c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101406:	83 ec 0c             	sub    $0xc,%esp
80101409:	68 de 73 10 80       	push   $0x801073de
8010140e:	e8 6d ef ff ff       	call   80100380 <panic>
80101413:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010141b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010141e:	09 da                	or     %ebx,%edx
80101420:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101424:	57                   	push   %edi
80101425:	e8 76 1c 00 00       	call   801030a0 <log_write>
        brelse(bp);
8010142a:	89 3c 24             	mov    %edi,(%esp)
8010142d:	e8 be ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101432:	58                   	pop    %eax
80101433:	5a                   	pop    %edx
80101434:	56                   	push   %esi
80101435:	ff 75 dc             	push   -0x24(%ebp)
80101438:	e8 93 ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010143d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101440:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101442:	8d 40 5c             	lea    0x5c(%eax),%eax
80101445:	68 00 02 00 00       	push   $0x200
8010144a:	6a 00                	push   $0x0
8010144c:	50                   	push   %eax
8010144d:	e8 ce 33 00 00       	call   80104820 <memset>
  log_write(bp);
80101452:	89 1c 24             	mov    %ebx,(%esp)
80101455:	e8 46 1c 00 00       	call   801030a0 <log_write>
  brelse(bp);
8010145a:	89 1c 24             	mov    %ebx,(%esp)
8010145d:	e8 8e ed ff ff       	call   801001f0 <brelse>
}
80101462:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101465:	89 f0                	mov    %esi,%eax
80101467:	5b                   	pop    %ebx
80101468:	5e                   	pop    %esi
80101469:	5f                   	pop    %edi
8010146a:	5d                   	pop    %ebp
8010146b:	c3                   	ret
8010146c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101470 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101474:	31 ff                	xor    %edi,%edi
{
80101476:	56                   	push   %esi
80101477:	89 c6                	mov    %eax,%esi
80101479:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010147a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010147f:	83 ec 28             	sub    $0x28,%esp
80101482:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101485:	68 60 f9 10 80       	push   $0x8010f960
8010148a:	e8 91 32 00 00       	call   80104720 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010148f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101492:	83 c4 10             	add    $0x10,%esp
80101495:	eb 1b                	jmp    801014b2 <iget+0x42>
80101497:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010149e:	00 
8010149f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014a0:	39 33                	cmp    %esi,(%ebx)
801014a2:	74 6c                	je     80101510 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014aa:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014b0:	74 26                	je     801014d8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014b2:	8b 43 08             	mov    0x8(%ebx),%eax
801014b5:	85 c0                	test   %eax,%eax
801014b7:	7f e7                	jg     801014a0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014b9:	85 ff                	test   %edi,%edi
801014bb:	75 e7                	jne    801014a4 <iget+0x34>
801014bd:	85 c0                	test   %eax,%eax
801014bf:	75 76                	jne    80101537 <iget+0xc7>
      empty = ip;
801014c1:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014c9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014cf:	75 e1                	jne    801014b2 <iget+0x42>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014d8:	85 ff                	test   %edi,%edi
801014da:	74 79                	je     80101555 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014dc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014df:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801014e1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801014e4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801014eb:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801014f2:	68 60 f9 10 80       	push   $0x8010f960
801014f7:	e8 c4 31 00 00       	call   801046c0 <release>

  return ip;
801014fc:	83 c4 10             	add    $0x10,%esp
}
801014ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101502:	89 f8                	mov    %edi,%eax
80101504:	5b                   	pop    %ebx
80101505:	5e                   	pop    %esi
80101506:	5f                   	pop    %edi
80101507:	5d                   	pop    %ebp
80101508:	c3                   	ret
80101509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101510:	39 53 04             	cmp    %edx,0x4(%ebx)
80101513:	75 8f                	jne    801014a4 <iget+0x34>
      ip->ref++;
80101515:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101518:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010151b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010151d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101520:	68 60 f9 10 80       	push   $0x8010f960
80101525:	e8 96 31 00 00       	call   801046c0 <release>
      return ip;
8010152a:	83 c4 10             	add    $0x10,%esp
}
8010152d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101530:	89 f8                	mov    %edi,%eax
80101532:	5b                   	pop    %ebx
80101533:	5e                   	pop    %esi
80101534:	5f                   	pop    %edi
80101535:	5d                   	pop    %ebp
80101536:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101537:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010153d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101543:	74 10                	je     80101555 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101545:	8b 43 08             	mov    0x8(%ebx),%eax
80101548:	85 c0                	test   %eax,%eax
8010154a:	0f 8f 50 ff ff ff    	jg     801014a0 <iget+0x30>
80101550:	e9 68 ff ff ff       	jmp    801014bd <iget+0x4d>
    panic("iget: no inodes");
80101555:	83 ec 0c             	sub    $0xc,%esp
80101558:	68 f4 73 10 80       	push   $0x801073f4
8010155d:	e8 1e ee ff ff       	call   80100380 <panic>
80101562:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101569:	00 
8010156a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101570 <bfree>:
{
80101570:	55                   	push   %ebp
80101571:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101573:	89 d0                	mov    %edx,%eax
80101575:	c1 e8 0c             	shr    $0xc,%eax
{
80101578:	89 e5                	mov    %esp,%ebp
8010157a:	56                   	push   %esi
8010157b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010157c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101582:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101584:	83 ec 08             	sub    $0x8,%esp
80101587:	50                   	push   %eax
80101588:	51                   	push   %ecx
80101589:	e8 42 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010158e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101590:	c1 fb 03             	sar    $0x3,%ebx
80101593:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101596:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101598:	83 e1 07             	and    $0x7,%ecx
8010159b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801015a0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801015a6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801015a8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801015ad:	85 c1                	test   %eax,%ecx
801015af:	74 23                	je     801015d4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801015b1:	f7 d0                	not    %eax
  log_write(bp);
801015b3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801015b6:	21 c8                	and    %ecx,%eax
801015b8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801015bc:	56                   	push   %esi
801015bd:	e8 de 1a 00 00       	call   801030a0 <log_write>
  brelse(bp);
801015c2:	89 34 24             	mov    %esi,(%esp)
801015c5:	e8 26 ec ff ff       	call   801001f0 <brelse>
}
801015ca:	83 c4 10             	add    $0x10,%esp
801015cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015d0:	5b                   	pop    %ebx
801015d1:	5e                   	pop    %esi
801015d2:	5d                   	pop    %ebp
801015d3:	c3                   	ret
    panic("freeing free block");
801015d4:	83 ec 0c             	sub    $0xc,%esp
801015d7:	68 04 74 10 80       	push   $0x80107404
801015dc:	e8 9f ed ff ff       	call   80100380 <panic>
801015e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015e8:	00 
801015e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801015f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	89 c6                	mov    %eax,%esi
801015f7:	53                   	push   %ebx
801015f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801015fb:	83 fa 0b             	cmp    $0xb,%edx
801015fe:	0f 86 8c 00 00 00    	jbe    80101690 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101604:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101607:	83 fb 7f             	cmp    $0x7f,%ebx
8010160a:	0f 87 a2 00 00 00    	ja     801016b2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101610:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101616:	85 c0                	test   %eax,%eax
80101618:	74 5e                	je     80101678 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010161a:	83 ec 08             	sub    $0x8,%esp
8010161d:	50                   	push   %eax
8010161e:	ff 36                	push   (%esi)
80101620:	e8 ab ea ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101625:	83 c4 10             	add    $0x10,%esp
80101628:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010162c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010162e:	8b 3b                	mov    (%ebx),%edi
80101630:	85 ff                	test   %edi,%edi
80101632:	74 1c                	je     80101650 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101634:	83 ec 0c             	sub    $0xc,%esp
80101637:	52                   	push   %edx
80101638:	e8 b3 eb ff ff       	call   801001f0 <brelse>
8010163d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101640:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101643:	89 f8                	mov    %edi,%eax
80101645:	5b                   	pop    %ebx
80101646:	5e                   	pop    %esi
80101647:	5f                   	pop    %edi
80101648:	5d                   	pop    %ebp
80101649:	c3                   	ret
8010164a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101650:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101653:	8b 06                	mov    (%esi),%eax
80101655:	e8 06 fd ff ff       	call   80101360 <balloc>
      log_write(bp);
8010165a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010165d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101660:	89 03                	mov    %eax,(%ebx)
80101662:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101664:	52                   	push   %edx
80101665:	e8 36 1a 00 00       	call   801030a0 <log_write>
8010166a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010166d:	83 c4 10             	add    $0x10,%esp
80101670:	eb c2                	jmp    80101634 <bmap+0x44>
80101672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101678:	8b 06                	mov    (%esi),%eax
8010167a:	e8 e1 fc ff ff       	call   80101360 <balloc>
8010167f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101685:	eb 93                	jmp    8010161a <bmap+0x2a>
80101687:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010168e:	00 
8010168f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101690:	8d 5a 14             	lea    0x14(%edx),%ebx
80101693:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101697:	85 ff                	test   %edi,%edi
80101699:	75 a5                	jne    80101640 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010169b:	8b 00                	mov    (%eax),%eax
8010169d:	e8 be fc ff ff       	call   80101360 <balloc>
801016a2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801016a6:	89 c7                	mov    %eax,%edi
}
801016a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ab:	5b                   	pop    %ebx
801016ac:	89 f8                	mov    %edi,%eax
801016ae:	5e                   	pop    %esi
801016af:	5f                   	pop    %edi
801016b0:	5d                   	pop    %ebp
801016b1:	c3                   	ret
  panic("bmap: out of range");
801016b2:	83 ec 0c             	sub    $0xc,%esp
801016b5:	68 17 74 10 80       	push   $0x80107417
801016ba:	e8 c1 ec ff ff       	call   80100380 <panic>
801016bf:	90                   	nop

801016c0 <readsb>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801016c8:	83 ec 08             	sub    $0x8,%esp
801016cb:	6a 01                	push   $0x1
801016cd:	ff 75 08             	push   0x8(%ebp)
801016d0:	e8 fb e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016d8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016da:	8d 40 5c             	lea    0x5c(%eax),%eax
801016dd:	6a 1c                	push   $0x1c
801016df:	50                   	push   %eax
801016e0:	56                   	push   %esi
801016e1:	e8 ca 31 00 00       	call   801048b0 <memmove>
  brelse(bp);
801016e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801016e9:	83 c4 10             	add    $0x10,%esp
}
801016ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016ef:	5b                   	pop    %ebx
801016f0:	5e                   	pop    %esi
801016f1:	5d                   	pop    %ebp
  brelse(bp);
801016f2:	e9 f9 ea ff ff       	jmp    801001f0 <brelse>
801016f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016fe:	00 
801016ff:	90                   	nop

80101700 <iinit>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	53                   	push   %ebx
80101704:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101709:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010170c:	68 2a 74 10 80       	push   $0x8010742a
80101711:	68 60 f9 10 80       	push   $0x8010f960
80101716:	e8 15 2e 00 00       	call   80104530 <initlock>
  for(i = 0; i < NINODE; i++) {
8010171b:	83 c4 10             	add    $0x10,%esp
8010171e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101720:	83 ec 08             	sub    $0x8,%esp
80101723:	68 31 74 10 80       	push   $0x80107431
80101728:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101729:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010172f:	e8 cc 2c 00 00       	call   80104400 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101734:	83 c4 10             	add    $0x10,%esp
80101737:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010173d:	75 e1                	jne    80101720 <iinit+0x20>
  bp = bread(dev, 1);
8010173f:	83 ec 08             	sub    $0x8,%esp
80101742:	6a 01                	push   $0x1
80101744:	ff 75 08             	push   0x8(%ebp)
80101747:	e8 84 e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010174c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010174f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101751:	8d 40 5c             	lea    0x5c(%eax),%eax
80101754:	6a 1c                	push   $0x1c
80101756:	50                   	push   %eax
80101757:	68 b4 15 11 80       	push   $0x801115b4
8010175c:	e8 4f 31 00 00       	call   801048b0 <memmove>
  brelse(bp);
80101761:	89 1c 24             	mov    %ebx,(%esp)
80101764:	e8 87 ea ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101769:	ff 35 cc 15 11 80    	push   0x801115cc
8010176f:	ff 35 c8 15 11 80    	push   0x801115c8
80101775:	ff 35 c4 15 11 80    	push   0x801115c4
8010177b:	ff 35 c0 15 11 80    	push   0x801115c0
80101781:	ff 35 bc 15 11 80    	push   0x801115bc
80101787:	ff 35 b8 15 11 80    	push   0x801115b8
8010178d:	ff 35 b4 15 11 80    	push   0x801115b4
80101793:	68 a0 78 10 80       	push   $0x801078a0
80101798:	e8 13 ef ff ff       	call   801006b0 <cprintf>
}
8010179d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017a0:	83 c4 30             	add    $0x30,%esp
801017a3:	c9                   	leave
801017a4:	c3                   	ret
801017a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017ac:	00 
801017ad:	8d 76 00             	lea    0x0(%esi),%esi

801017b0 <ialloc>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 1c             	sub    $0x1c,%esp
801017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801017bc:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
801017c3:	8b 75 08             	mov    0x8(%ebp),%esi
801017c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801017c9:	0f 86 91 00 00 00    	jbe    80101860 <ialloc+0xb0>
801017cf:	bf 01 00 00 00       	mov    $0x1,%edi
801017d4:	eb 21                	jmp    801017f7 <ialloc+0x47>
801017d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017dd:	00 
801017de:	66 90                	xchg   %ax,%ax
    brelse(bp);
801017e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017e3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801017e6:	53                   	push   %ebx
801017e7:	e8 04 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801017ec:	83 c4 10             	add    $0x10,%esp
801017ef:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801017f5:	73 69                	jae    80101860 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801017f7:	89 f8                	mov    %edi,%eax
801017f9:	83 ec 08             	sub    $0x8,%esp
801017fc:	c1 e8 03             	shr    $0x3,%eax
801017ff:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101805:	50                   	push   %eax
80101806:	56                   	push   %esi
80101807:	e8 c4 e8 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010180c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010180f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101811:	89 f8                	mov    %edi,%eax
80101813:	83 e0 07             	and    $0x7,%eax
80101816:	c1 e0 06             	shl    $0x6,%eax
80101819:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010181d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101821:	75 bd                	jne    801017e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101823:	83 ec 04             	sub    $0x4,%esp
80101826:	6a 40                	push   $0x40
80101828:	6a 00                	push   $0x0
8010182a:	51                   	push   %ecx
8010182b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010182e:	e8 ed 2f 00 00       	call   80104820 <memset>
      dip->type = type;
80101833:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101837:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010183a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010183d:	89 1c 24             	mov    %ebx,(%esp)
80101840:	e8 5b 18 00 00       	call   801030a0 <log_write>
      brelse(bp);
80101845:	89 1c 24             	mov    %ebx,(%esp)
80101848:	e8 a3 e9 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010184d:	83 c4 10             	add    $0x10,%esp
}
80101850:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101853:	89 fa                	mov    %edi,%edx
}
80101855:	5b                   	pop    %ebx
      return iget(dev, inum);
80101856:	89 f0                	mov    %esi,%eax
}
80101858:	5e                   	pop    %esi
80101859:	5f                   	pop    %edi
8010185a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010185b:	e9 10 fc ff ff       	jmp    80101470 <iget>
  panic("ialloc: no inodes");
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	68 37 74 10 80       	push   $0x80107437
80101868:	e8 13 eb ff ff       	call   80100380 <panic>
8010186d:	8d 76 00             	lea    0x0(%esi),%esi

80101870 <iupdate>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101878:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010187b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010187e:	83 ec 08             	sub    $0x8,%esp
80101881:	c1 e8 03             	shr    $0x3,%eax
80101884:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010188a:	50                   	push   %eax
8010188b:	ff 73 a4             	push   -0x5c(%ebx)
8010188e:	e8 3d e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101893:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101897:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010189a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010189c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010189f:	83 e0 07             	and    $0x7,%eax
801018a2:	c1 e0 06             	shl    $0x6,%eax
801018a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801018a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801018b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801018b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801018bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801018bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801018c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801018c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801018ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018cd:	6a 34                	push   $0x34
801018cf:	53                   	push   %ebx
801018d0:	50                   	push   %eax
801018d1:	e8 da 2f 00 00       	call   801048b0 <memmove>
  log_write(bp);
801018d6:	89 34 24             	mov    %esi,(%esp)
801018d9:	e8 c2 17 00 00       	call   801030a0 <log_write>
  brelse(bp);
801018de:	89 75 08             	mov    %esi,0x8(%ebp)
801018e1:	83 c4 10             	add    $0x10,%esp
}
801018e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018e7:	5b                   	pop    %ebx
801018e8:	5e                   	pop    %esi
801018e9:	5d                   	pop    %ebp
  brelse(bp);
801018ea:	e9 01 e9 ff ff       	jmp    801001f0 <brelse>
801018ef:	90                   	nop

801018f0 <idup>:
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 10             	sub    $0x10,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801018fa:	68 60 f9 10 80       	push   $0x8010f960
801018ff:	e8 1c 2e 00 00       	call   80104720 <acquire>
  ip->ref++;
80101904:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101908:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010190f:	e8 ac 2d 00 00       	call   801046c0 <release>
}
80101914:	89 d8                	mov    %ebx,%eax
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave
8010191a:	c3                   	ret
8010191b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101920 <ilock>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	56                   	push   %esi
80101924:	53                   	push   %ebx
80101925:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101928:	85 db                	test   %ebx,%ebx
8010192a:	0f 84 b7 00 00 00    	je     801019e7 <ilock+0xc7>
80101930:	8b 53 08             	mov    0x8(%ebx),%edx
80101933:	85 d2                	test   %edx,%edx
80101935:	0f 8e ac 00 00 00    	jle    801019e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010193b:	83 ec 0c             	sub    $0xc,%esp
8010193e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101941:	50                   	push   %eax
80101942:	e8 f9 2a 00 00       	call   80104440 <acquiresleep>
  if(ip->valid == 0){
80101947:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010194a:	83 c4 10             	add    $0x10,%esp
8010194d:	85 c0                	test   %eax,%eax
8010194f:	74 0f                	je     80101960 <ilock+0x40>
}
80101951:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101954:	5b                   	pop    %ebx
80101955:	5e                   	pop    %esi
80101956:	5d                   	pop    %ebp
80101957:	c3                   	ret
80101958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010195f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101960:	8b 43 04             	mov    0x4(%ebx),%eax
80101963:	83 ec 08             	sub    $0x8,%esp
80101966:	c1 e8 03             	shr    $0x3,%eax
80101969:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010196f:	50                   	push   %eax
80101970:	ff 33                	push   (%ebx)
80101972:	e8 59 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101977:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010197a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010197c:	8b 43 04             	mov    0x4(%ebx),%eax
8010197f:	83 e0 07             	and    $0x7,%eax
80101982:	c1 e0 06             	shl    $0x6,%eax
80101985:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101989:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010198c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010198f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101993:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101997:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010199b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010199f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801019a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801019a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801019ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801019ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019b1:	6a 34                	push   $0x34
801019b3:	50                   	push   %eax
801019b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801019b7:	50                   	push   %eax
801019b8:	e8 f3 2e 00 00       	call   801048b0 <memmove>
    brelse(bp);
801019bd:	89 34 24             	mov    %esi,(%esp)
801019c0:	e8 2b e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801019c5:	83 c4 10             	add    $0x10,%esp
801019c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801019cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801019d4:	0f 85 77 ff ff ff    	jne    80101951 <ilock+0x31>
      panic("ilock: no type");
801019da:	83 ec 0c             	sub    $0xc,%esp
801019dd:	68 4f 74 10 80       	push   $0x8010744f
801019e2:	e8 99 e9 ff ff       	call   80100380 <panic>
    panic("ilock");
801019e7:	83 ec 0c             	sub    $0xc,%esp
801019ea:	68 49 74 10 80       	push   $0x80107449
801019ef:	e8 8c e9 ff ff       	call   80100380 <panic>
801019f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019fb:	00 
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a00 <iunlock>:
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	56                   	push   %esi
80101a04:	53                   	push   %ebx
80101a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a08:	85 db                	test   %ebx,%ebx
80101a0a:	74 28                	je     80101a34 <iunlock+0x34>
80101a0c:	83 ec 0c             	sub    $0xc,%esp
80101a0f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a12:	56                   	push   %esi
80101a13:	e8 c8 2a 00 00       	call   801044e0 <holdingsleep>
80101a18:	83 c4 10             	add    $0x10,%esp
80101a1b:	85 c0                	test   %eax,%eax
80101a1d:	74 15                	je     80101a34 <iunlock+0x34>
80101a1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a22:	85 c0                	test   %eax,%eax
80101a24:	7e 0e                	jle    80101a34 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a26:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a2c:	5b                   	pop    %ebx
80101a2d:	5e                   	pop    %esi
80101a2e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a2f:	e9 6c 2a 00 00       	jmp    801044a0 <releasesleep>
    panic("iunlock");
80101a34:	83 ec 0c             	sub    $0xc,%esp
80101a37:	68 5e 74 10 80       	push   $0x8010745e
80101a3c:	e8 3f e9 ff ff       	call   80100380 <panic>
80101a41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a48:	00 
80101a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a50 <iput>:
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 28             	sub    $0x28,%esp
80101a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a5c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a5f:	57                   	push   %edi
80101a60:	e8 db 29 00 00       	call   80104440 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a65:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a68:	83 c4 10             	add    $0x10,%esp
80101a6b:	85 d2                	test   %edx,%edx
80101a6d:	74 07                	je     80101a76 <iput+0x26>
80101a6f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a74:	74 32                	je     80101aa8 <iput+0x58>
  releasesleep(&ip->lock);
80101a76:	83 ec 0c             	sub    $0xc,%esp
80101a79:	57                   	push   %edi
80101a7a:	e8 21 2a 00 00       	call   801044a0 <releasesleep>
  acquire(&icache.lock);
80101a7f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a86:	e8 95 2c 00 00       	call   80104720 <acquire>
  ip->ref--;
80101a8b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a8f:	83 c4 10             	add    $0x10,%esp
80101a92:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a9c:	5b                   	pop    %ebx
80101a9d:	5e                   	pop    %esi
80101a9e:	5f                   	pop    %edi
80101a9f:	5d                   	pop    %ebp
  release(&icache.lock);
80101aa0:	e9 1b 2c 00 00       	jmp    801046c0 <release>
80101aa5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101aa8:	83 ec 0c             	sub    $0xc,%esp
80101aab:	68 60 f9 10 80       	push   $0x8010f960
80101ab0:	e8 6b 2c 00 00       	call   80104720 <acquire>
    int r = ip->ref;
80101ab5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101ab8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101abf:	e8 fc 2b 00 00       	call   801046c0 <release>
    if(r == 1){
80101ac4:	83 c4 10             	add    $0x10,%esp
80101ac7:	83 fe 01             	cmp    $0x1,%esi
80101aca:	75 aa                	jne    80101a76 <iput+0x26>
80101acc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101ad2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ad5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ad8:	89 df                	mov    %ebx,%edi
80101ada:	89 cb                	mov    %ecx,%ebx
80101adc:	eb 09                	jmp    80101ae7 <iput+0x97>
80101ade:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ae0:	83 c6 04             	add    $0x4,%esi
80101ae3:	39 de                	cmp    %ebx,%esi
80101ae5:	74 19                	je     80101b00 <iput+0xb0>
    if(ip->addrs[i]){
80101ae7:	8b 16                	mov    (%esi),%edx
80101ae9:	85 d2                	test   %edx,%edx
80101aeb:	74 f3                	je     80101ae0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101aed:	8b 07                	mov    (%edi),%eax
80101aef:	e8 7c fa ff ff       	call   80101570 <bfree>
      ip->addrs[i] = 0;
80101af4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101afa:	eb e4                	jmp    80101ae0 <iput+0x90>
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b00:	89 fb                	mov    %edi,%ebx
80101b02:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b05:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b0b:	85 c0                	test   %eax,%eax
80101b0d:	75 2d                	jne    80101b3c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b0f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b12:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b19:	53                   	push   %ebx
80101b1a:	e8 51 fd ff ff       	call   80101870 <iupdate>
      ip->type = 0;
80101b1f:	31 c0                	xor    %eax,%eax
80101b21:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b25:	89 1c 24             	mov    %ebx,(%esp)
80101b28:	e8 43 fd ff ff       	call   80101870 <iupdate>
      ip->valid = 0;
80101b2d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b34:	83 c4 10             	add    $0x10,%esp
80101b37:	e9 3a ff ff ff       	jmp    80101a76 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b3c:	83 ec 08             	sub    $0x8,%esp
80101b3f:	50                   	push   %eax
80101b40:	ff 33                	push   (%ebx)
80101b42:	e8 89 e5 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101b47:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b53:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b56:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b59:	89 cf                	mov    %ecx,%edi
80101b5b:	eb 0a                	jmp    80101b67 <iput+0x117>
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
80101b60:	83 c6 04             	add    $0x4,%esi
80101b63:	39 fe                	cmp    %edi,%esi
80101b65:	74 0f                	je     80101b76 <iput+0x126>
      if(a[j])
80101b67:	8b 16                	mov    (%esi),%edx
80101b69:	85 d2                	test   %edx,%edx
80101b6b:	74 f3                	je     80101b60 <iput+0x110>
        bfree(ip->dev, a[j]);
80101b6d:	8b 03                	mov    (%ebx),%eax
80101b6f:	e8 fc f9 ff ff       	call   80101570 <bfree>
80101b74:	eb ea                	jmp    80101b60 <iput+0x110>
    brelse(bp);
80101b76:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b79:	83 ec 0c             	sub    $0xc,%esp
80101b7c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b7f:	50                   	push   %eax
80101b80:	e8 6b e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b85:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b8b:	8b 03                	mov    (%ebx),%eax
80101b8d:	e8 de f9 ff ff       	call   80101570 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b92:	83 c4 10             	add    $0x10,%esp
80101b95:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b9c:	00 00 00 
80101b9f:	e9 6b ff ff ff       	jmp    80101b0f <iput+0xbf>
80101ba4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bab:	00 
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bb0 <iunlockput>:
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	56                   	push   %esi
80101bb4:	53                   	push   %ebx
80101bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bb8:	85 db                	test   %ebx,%ebx
80101bba:	74 34                	je     80101bf0 <iunlockput+0x40>
80101bbc:	83 ec 0c             	sub    $0xc,%esp
80101bbf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101bc2:	56                   	push   %esi
80101bc3:	e8 18 29 00 00       	call   801044e0 <holdingsleep>
80101bc8:	83 c4 10             	add    $0x10,%esp
80101bcb:	85 c0                	test   %eax,%eax
80101bcd:	74 21                	je     80101bf0 <iunlockput+0x40>
80101bcf:	8b 43 08             	mov    0x8(%ebx),%eax
80101bd2:	85 c0                	test   %eax,%eax
80101bd4:	7e 1a                	jle    80101bf0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101bd6:	83 ec 0c             	sub    $0xc,%esp
80101bd9:	56                   	push   %esi
80101bda:	e8 c1 28 00 00       	call   801044a0 <releasesleep>
  iput(ip);
80101bdf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101be2:	83 c4 10             	add    $0x10,%esp
}
80101be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101be8:	5b                   	pop    %ebx
80101be9:	5e                   	pop    %esi
80101bea:	5d                   	pop    %ebp
  iput(ip);
80101beb:	e9 60 fe ff ff       	jmp    80101a50 <iput>
    panic("iunlock");
80101bf0:	83 ec 0c             	sub    $0xc,%esp
80101bf3:	68 5e 74 10 80       	push   $0x8010745e
80101bf8:	e8 83 e7 ff ff       	call   80100380 <panic>
80101bfd:	8d 76 00             	lea    0x0(%esi),%esi

80101c00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	8b 55 08             	mov    0x8(%ebp),%edx
80101c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c09:	8b 0a                	mov    (%edx),%ecx
80101c0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c23:	8b 52 58             	mov    0x58(%edx),%edx
80101c26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret
80101c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101c30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	83 ec 1c             	sub    $0x1c,%esp
80101c39:	8b 75 08             	mov    0x8(%ebp),%esi
80101c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c42:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101c4a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101c4d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101c50:	0f 84 aa 00 00 00    	je     80101d00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c56:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c59:	8b 56 58             	mov    0x58(%esi),%edx
80101c5c:	39 fa                	cmp    %edi,%edx
80101c5e:	0f 82 bd 00 00 00    	jb     80101d21 <readi+0xf1>
80101c64:	89 f9                	mov    %edi,%ecx
80101c66:	31 db                	xor    %ebx,%ebx
80101c68:	01 c1                	add    %eax,%ecx
80101c6a:	0f 92 c3             	setb   %bl
80101c6d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101c70:	0f 82 ab 00 00 00    	jb     80101d21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c76:	89 d3                	mov    %edx,%ebx
80101c78:	29 fb                	sub    %edi,%ebx
80101c7a:	39 ca                	cmp    %ecx,%edx
80101c7c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c7f:	85 c0                	test   %eax,%eax
80101c81:	74 73                	je     80101cf6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c83:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101c86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c93:	89 fa                	mov    %edi,%edx
80101c95:	c1 ea 09             	shr    $0x9,%edx
80101c98:	89 d8                	mov    %ebx,%eax
80101c9a:	e8 51 f9 ff ff       	call   801015f0 <bmap>
80101c9f:	83 ec 08             	sub    $0x8,%esp
80101ca2:	50                   	push   %eax
80101ca3:	ff 33                	push   (%ebx)
80101ca5:	e8 26 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101caa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101cad:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb4:	89 f8                	mov    %edi,%eax
80101cb6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cbb:	29 f3                	sub    %esi,%ebx
80101cbd:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101cbf:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cc3:	39 d9                	cmp    %ebx,%ecx
80101cc5:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101cc8:	83 c4 0c             	add    $0xc,%esp
80101ccb:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ccc:	01 de                	add    %ebx,%esi
80101cce:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101cd0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101cd3:	50                   	push   %eax
80101cd4:	ff 75 e0             	push   -0x20(%ebp)
80101cd7:	e8 d4 2b 00 00       	call   801048b0 <memmove>
    brelse(bp);
80101cdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101cdf:	89 14 24             	mov    %edx,(%esp)
80101ce2:	e8 09 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ce7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ced:	83 c4 10             	add    $0x10,%esp
80101cf0:	39 de                	cmp    %ebx,%esi
80101cf2:	72 9c                	jb     80101c90 <readi+0x60>
80101cf4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cf9:	5b                   	pop    %ebx
80101cfa:	5e                   	pop    %esi
80101cfb:	5f                   	pop    %edi
80101cfc:	5d                   	pop    %ebp
80101cfd:	c3                   	ret
80101cfe:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d00:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101d04:	66 83 fa 09          	cmp    $0x9,%dx
80101d08:	77 17                	ja     80101d21 <readi+0xf1>
80101d0a:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101d11:	85 d2                	test   %edx,%edx
80101d13:	74 0c                	je     80101d21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d15:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d1b:	5b                   	pop    %ebx
80101d1c:	5e                   	pop    %esi
80101d1d:	5f                   	pop    %edi
80101d1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d1f:	ff e2                	jmp    *%edx
      return -1;
80101d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d26:	eb ce                	jmp    80101cf6 <readi+0xc6>
80101d28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d2f:	00 

80101d30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	83 ec 1c             	sub    $0x1c,%esp
80101d39:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101d3f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d47:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101d4a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101d4d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101d50:	0f 84 ba 00 00 00    	je     80101e10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d56:	39 78 58             	cmp    %edi,0x58(%eax)
80101d59:	0f 82 ea 00 00 00    	jb     80101e49 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d5f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101d62:	89 f2                	mov    %esi,%edx
80101d64:	01 fa                	add    %edi,%edx
80101d66:	0f 82 dd 00 00 00    	jb     80101e49 <writei+0x119>
80101d6c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101d72:	0f 87 d1 00 00 00    	ja     80101e49 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d78:	85 f6                	test   %esi,%esi
80101d7a:	0f 84 85 00 00 00    	je     80101e05 <writei+0xd5>
80101d80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101d87:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d90:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101d93:	89 fa                	mov    %edi,%edx
80101d95:	c1 ea 09             	shr    $0x9,%edx
80101d98:	89 f0                	mov    %esi,%eax
80101d9a:	e8 51 f8 ff ff       	call   801015f0 <bmap>
80101d9f:	83 ec 08             	sub    $0x8,%esp
80101da2:	50                   	push   %eax
80101da3:	ff 36                	push   (%esi)
80101da5:	e8 26 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101daa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101dad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101db0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101db5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101db7:	89 f8                	mov    %edi,%eax
80101db9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101dbe:	29 d3                	sub    %edx,%ebx
80101dc0:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101dc2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101dc6:	39 d9                	cmp    %ebx,%ecx
80101dc8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101dcb:	83 c4 0c             	add    $0xc,%esp
80101dce:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dcf:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101dd1:	ff 75 dc             	push   -0x24(%ebp)
80101dd4:	50                   	push   %eax
80101dd5:	e8 d6 2a 00 00       	call   801048b0 <memmove>
    log_write(bp);
80101dda:	89 34 24             	mov    %esi,(%esp)
80101ddd:	e8 be 12 00 00       	call   801030a0 <log_write>
    brelse(bp);
80101de2:	89 34 24             	mov    %esi,(%esp)
80101de5:	e8 06 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dea:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ded:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101df0:	83 c4 10             	add    $0x10,%esp
80101df3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101df6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101df9:	39 d8                	cmp    %ebx,%eax
80101dfb:	72 93                	jb     80101d90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101dfd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e00:	39 78 58             	cmp    %edi,0x58(%eax)
80101e03:	72 33                	jb     80101e38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e05:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e0b:	5b                   	pop    %ebx
80101e0c:	5e                   	pop    %esi
80101e0d:	5f                   	pop    %edi
80101e0e:	5d                   	pop    %ebp
80101e0f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e14:	66 83 f8 09          	cmp    $0x9,%ax
80101e18:	77 2f                	ja     80101e49 <writei+0x119>
80101e1a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101e21:	85 c0                	test   %eax,%eax
80101e23:	74 24                	je     80101e49 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101e25:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e2b:	5b                   	pop    %ebx
80101e2c:	5e                   	pop    %esi
80101e2d:	5f                   	pop    %edi
80101e2e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e2f:	ff e0                	jmp    *%eax
80101e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101e38:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e3b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101e3e:	50                   	push   %eax
80101e3f:	e8 2c fa ff ff       	call   80101870 <iupdate>
80101e44:	83 c4 10             	add    $0x10,%esp
80101e47:	eb bc                	jmp    80101e05 <writei+0xd5>
      return -1;
80101e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e4e:	eb b8                	jmp    80101e08 <writei+0xd8>

80101e50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e56:	6a 0e                	push   $0xe
80101e58:	ff 75 0c             	push   0xc(%ebp)
80101e5b:	ff 75 08             	push   0x8(%ebp)
80101e5e:	e8 bd 2a 00 00       	call   80104920 <strncmp>
}
80101e63:	c9                   	leave
80101e64:	c3                   	ret
80101e65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e6c:	00 
80101e6d:	8d 76 00             	lea    0x0(%esi),%esi

80101e70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	83 ec 1c             	sub    $0x1c,%esp
80101e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e81:	0f 85 85 00 00 00    	jne    80101f0c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e87:	8b 53 58             	mov    0x58(%ebx),%edx
80101e8a:	31 ff                	xor    %edi,%edi
80101e8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8f:	85 d2                	test   %edx,%edx
80101e91:	74 3e                	je     80101ed1 <dirlookup+0x61>
80101e93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 8e fd ff ff       	call   80101c30 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 55                	jne    80101eff <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	74 18                	je     80101ec9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101eb1:	83 ec 04             	sub    $0x4,%esp
80101eb4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb7:	6a 0e                	push   $0xe
80101eb9:	50                   	push   %eax
80101eba:	ff 75 0c             	push   0xc(%ebp)
80101ebd:	e8 5e 2a 00 00       	call   80104920 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	85 c0                	test   %eax,%eax
80101ec7:	74 17                	je     80101ee0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ec9:	83 c7 10             	add    $0x10,%edi
80101ecc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ecf:	72 c7                	jb     80101e98 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ed4:	31 c0                	xor    %eax,%eax
}
80101ed6:	5b                   	pop    %ebx
80101ed7:	5e                   	pop    %esi
80101ed8:	5f                   	pop    %edi
80101ed9:	5d                   	pop    %ebp
80101eda:	c3                   	ret
80101edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101ee0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ee3:	85 c0                	test   %eax,%eax
80101ee5:	74 05                	je     80101eec <dirlookup+0x7c>
        *poff = off;
80101ee7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eea:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101eec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ef0:	8b 03                	mov    (%ebx),%eax
80101ef2:	e8 79 f5 ff ff       	call   80101470 <iget>
}
80101ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efa:	5b                   	pop    %ebx
80101efb:	5e                   	pop    %esi
80101efc:	5f                   	pop    %edi
80101efd:	5d                   	pop    %ebp
80101efe:	c3                   	ret
      panic("dirlookup read");
80101eff:	83 ec 0c             	sub    $0xc,%esp
80101f02:	68 78 74 10 80       	push   $0x80107478
80101f07:	e8 74 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101f0c:	83 ec 0c             	sub    $0xc,%esp
80101f0f:	68 66 74 10 80       	push   $0x80107466
80101f14:	e8 67 e4 ff ff       	call   80100380 <panic>
80101f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	89 c3                	mov    %eax,%ebx
80101f28:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f2b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f2e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f31:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101f34:	0f 84 9e 01 00 00    	je     801020d8 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f3a:	e8 a1 1b 00 00       	call   80103ae0 <myproc>
  acquire(&icache.lock);
80101f3f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f42:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f45:	68 60 f9 10 80       	push   $0x8010f960
80101f4a:	e8 d1 27 00 00       	call   80104720 <acquire>
  ip->ref++;
80101f4f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f53:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101f5a:	e8 61 27 00 00       	call   801046c0 <release>
80101f5f:	83 c4 10             	add    $0x10,%esp
80101f62:	eb 07                	jmp    80101f6b <namex+0x4b>
80101f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f6b:	0f b6 03             	movzbl (%ebx),%eax
80101f6e:	3c 2f                	cmp    $0x2f,%al
80101f70:	74 f6                	je     80101f68 <namex+0x48>
  if(*path == 0)
80101f72:	84 c0                	test   %al,%al
80101f74:	0f 84 06 01 00 00    	je     80102080 <namex+0x160>
  while(*path != '/' && *path != 0)
80101f7a:	0f b6 03             	movzbl (%ebx),%eax
80101f7d:	84 c0                	test   %al,%al
80101f7f:	0f 84 10 01 00 00    	je     80102095 <namex+0x175>
80101f85:	89 df                	mov    %ebx,%edi
80101f87:	3c 2f                	cmp    $0x2f,%al
80101f89:	0f 84 06 01 00 00    	je     80102095 <namex+0x175>
80101f8f:	90                   	nop
80101f90:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f94:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f97:	3c 2f                	cmp    $0x2f,%al
80101f99:	74 04                	je     80101f9f <namex+0x7f>
80101f9b:	84 c0                	test   %al,%al
80101f9d:	75 f1                	jne    80101f90 <namex+0x70>
  len = path - s;
80101f9f:	89 f8                	mov    %edi,%eax
80101fa1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101fa3:	83 f8 0d             	cmp    $0xd,%eax
80101fa6:	0f 8e ac 00 00 00    	jle    80102058 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101fac:	83 ec 04             	sub    $0x4,%esp
80101faf:	6a 0e                	push   $0xe
80101fb1:	53                   	push   %ebx
80101fb2:	89 fb                	mov    %edi,%ebx
80101fb4:	ff 75 e4             	push   -0x1c(%ebp)
80101fb7:	e8 f4 28 00 00       	call   801048b0 <memmove>
80101fbc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101fbf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101fc2:	75 0c                	jne    80101fd0 <namex+0xb0>
80101fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101fc8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fcb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fce:	74 f8                	je     80101fc8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101fd0:	83 ec 0c             	sub    $0xc,%esp
80101fd3:	56                   	push   %esi
80101fd4:	e8 47 f9 ff ff       	call   80101920 <ilock>
    if(ip->type != T_DIR){
80101fd9:	83 c4 10             	add    $0x10,%esp
80101fdc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fe1:	0f 85 b7 00 00 00    	jne    8010209e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101fe7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fea:	85 c0                	test   %eax,%eax
80101fec:	74 09                	je     80101ff7 <namex+0xd7>
80101fee:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ff1:	0f 84 f7 00 00 00    	je     801020ee <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ff7:	83 ec 04             	sub    $0x4,%esp
80101ffa:	6a 00                	push   $0x0
80101ffc:	ff 75 e4             	push   -0x1c(%ebp)
80101fff:	56                   	push   %esi
80102000:	e8 6b fe ff ff       	call   80101e70 <dirlookup>
80102005:	83 c4 10             	add    $0x10,%esp
80102008:	89 c7                	mov    %eax,%edi
8010200a:	85 c0                	test   %eax,%eax
8010200c:	0f 84 8c 00 00 00    	je     8010209e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102012:	8d 4e 0c             	lea    0xc(%esi),%ecx
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	51                   	push   %ecx
80102019:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010201c:	e8 bf 24 00 00       	call   801044e0 <holdingsleep>
80102021:	83 c4 10             	add    $0x10,%esp
80102024:	85 c0                	test   %eax,%eax
80102026:	0f 84 02 01 00 00    	je     8010212e <namex+0x20e>
8010202c:	8b 56 08             	mov    0x8(%esi),%edx
8010202f:	85 d2                	test   %edx,%edx
80102031:	0f 8e f7 00 00 00    	jle    8010212e <namex+0x20e>
  releasesleep(&ip->lock);
80102037:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010203a:	83 ec 0c             	sub    $0xc,%esp
8010203d:	51                   	push   %ecx
8010203e:	e8 5d 24 00 00       	call   801044a0 <releasesleep>
  iput(ip);
80102043:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80102046:	89 fe                	mov    %edi,%esi
  iput(ip);
80102048:	e8 03 fa ff ff       	call   80101a50 <iput>
8010204d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80102050:	e9 16 ff ff ff       	jmp    80101f6b <namex+0x4b>
80102055:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102058:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010205b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
8010205e:	83 ec 04             	sub    $0x4,%esp
80102061:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102064:	50                   	push   %eax
80102065:	53                   	push   %ebx
    name[len] = 0;
80102066:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102068:	ff 75 e4             	push   -0x1c(%ebp)
8010206b:	e8 40 28 00 00       	call   801048b0 <memmove>
    name[len] = 0;
80102070:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102073:	83 c4 10             	add    $0x10,%esp
80102076:	c6 01 00             	movb   $0x0,(%ecx)
80102079:	e9 41 ff ff ff       	jmp    80101fbf <namex+0x9f>
8010207e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80102080:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102083:	85 c0                	test   %eax,%eax
80102085:	0f 85 93 00 00 00    	jne    8010211e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
8010208b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208e:	89 f0                	mov    %esi,%eax
80102090:	5b                   	pop    %ebx
80102091:	5e                   	pop    %esi
80102092:	5f                   	pop    %edi
80102093:	5d                   	pop    %ebp
80102094:	c3                   	ret
  while(*path != '/' && *path != 0)
80102095:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102098:	89 df                	mov    %ebx,%edi
8010209a:	31 c0                	xor    %eax,%eax
8010209c:	eb c0                	jmp    8010205e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010209e:	83 ec 0c             	sub    $0xc,%esp
801020a1:	8d 5e 0c             	lea    0xc(%esi),%ebx
801020a4:	53                   	push   %ebx
801020a5:	e8 36 24 00 00       	call   801044e0 <holdingsleep>
801020aa:	83 c4 10             	add    $0x10,%esp
801020ad:	85 c0                	test   %eax,%eax
801020af:	74 7d                	je     8010212e <namex+0x20e>
801020b1:	8b 4e 08             	mov    0x8(%esi),%ecx
801020b4:	85 c9                	test   %ecx,%ecx
801020b6:	7e 76                	jle    8010212e <namex+0x20e>
  releasesleep(&ip->lock);
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	53                   	push   %ebx
801020bc:	e8 df 23 00 00       	call   801044a0 <releasesleep>
  iput(ip);
801020c1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020c4:	31 f6                	xor    %esi,%esi
  iput(ip);
801020c6:	e8 85 f9 ff ff       	call   80101a50 <iput>
      return 0;
801020cb:	83 c4 10             	add    $0x10,%esp
}
801020ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020d1:	89 f0                	mov    %esi,%eax
801020d3:	5b                   	pop    %ebx
801020d4:	5e                   	pop    %esi
801020d5:	5f                   	pop    %edi
801020d6:	5d                   	pop    %ebp
801020d7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
801020d8:	ba 01 00 00 00       	mov    $0x1,%edx
801020dd:	b8 01 00 00 00       	mov    $0x1,%eax
801020e2:	e8 89 f3 ff ff       	call   80101470 <iget>
801020e7:	89 c6                	mov    %eax,%esi
801020e9:	e9 7d fe ff ff       	jmp    80101f6b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020ee:	83 ec 0c             	sub    $0xc,%esp
801020f1:	8d 5e 0c             	lea    0xc(%esi),%ebx
801020f4:	53                   	push   %ebx
801020f5:	e8 e6 23 00 00       	call   801044e0 <holdingsleep>
801020fa:	83 c4 10             	add    $0x10,%esp
801020fd:	85 c0                	test   %eax,%eax
801020ff:	74 2d                	je     8010212e <namex+0x20e>
80102101:	8b 7e 08             	mov    0x8(%esi),%edi
80102104:	85 ff                	test   %edi,%edi
80102106:	7e 26                	jle    8010212e <namex+0x20e>
  releasesleep(&ip->lock);
80102108:	83 ec 0c             	sub    $0xc,%esp
8010210b:	53                   	push   %ebx
8010210c:	e8 8f 23 00 00       	call   801044a0 <releasesleep>
}
80102111:	83 c4 10             	add    $0x10,%esp
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	89 f0                	mov    %esi,%eax
80102119:	5b                   	pop    %ebx
8010211a:	5e                   	pop    %esi
8010211b:	5f                   	pop    %edi
8010211c:	5d                   	pop    %ebp
8010211d:	c3                   	ret
    iput(ip);
8010211e:	83 ec 0c             	sub    $0xc,%esp
80102121:	56                   	push   %esi
      return 0;
80102122:	31 f6                	xor    %esi,%esi
    iput(ip);
80102124:	e8 27 f9 ff ff       	call   80101a50 <iput>
    return 0;
80102129:	83 c4 10             	add    $0x10,%esp
8010212c:	eb a0                	jmp    801020ce <namex+0x1ae>
    panic("iunlock");
8010212e:	83 ec 0c             	sub    $0xc,%esp
80102131:	68 5e 74 10 80       	push   $0x8010745e
80102136:	e8 45 e2 ff ff       	call   80100380 <panic>
8010213b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102140 <dirlink>:
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 20             	sub    $0x20,%esp
80102149:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010214c:	6a 00                	push   $0x0
8010214e:	ff 75 0c             	push   0xc(%ebp)
80102151:	53                   	push   %ebx
80102152:	e8 19 fd ff ff       	call   80101e70 <dirlookup>
80102157:	83 c4 10             	add    $0x10,%esp
8010215a:	85 c0                	test   %eax,%eax
8010215c:	75 67                	jne    801021c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010215e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102161:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102164:	85 ff                	test   %edi,%edi
80102166:	74 29                	je     80102191 <dirlink+0x51>
80102168:	31 ff                	xor    %edi,%edi
8010216a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010216d:	eb 09                	jmp    80102178 <dirlink+0x38>
8010216f:	90                   	nop
80102170:	83 c7 10             	add    $0x10,%edi
80102173:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102176:	73 19                	jae    80102191 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102178:	6a 10                	push   $0x10
8010217a:	57                   	push   %edi
8010217b:	56                   	push   %esi
8010217c:	53                   	push   %ebx
8010217d:	e8 ae fa ff ff       	call   80101c30 <readi>
80102182:	83 c4 10             	add    $0x10,%esp
80102185:	83 f8 10             	cmp    $0x10,%eax
80102188:	75 4e                	jne    801021d8 <dirlink+0x98>
    if(de.inum == 0)
8010218a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010218f:	75 df                	jne    80102170 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102191:	83 ec 04             	sub    $0x4,%esp
80102194:	8d 45 da             	lea    -0x26(%ebp),%eax
80102197:	6a 0e                	push   $0xe
80102199:	ff 75 0c             	push   0xc(%ebp)
8010219c:	50                   	push   %eax
8010219d:	e8 ce 27 00 00       	call   80104970 <strncpy>
  de.inum = inum;
801021a2:	8b 45 10             	mov    0x10(%ebp),%eax
801021a5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021a9:	6a 10                	push   $0x10
801021ab:	57                   	push   %edi
801021ac:	56                   	push   %esi
801021ad:	53                   	push   %ebx
801021ae:	e8 7d fb ff ff       	call   80101d30 <writei>
801021b3:	83 c4 20             	add    $0x20,%esp
801021b6:	83 f8 10             	cmp    $0x10,%eax
801021b9:	75 2a                	jne    801021e5 <dirlink+0xa5>
  return 0;
801021bb:	31 c0                	xor    %eax,%eax
}
801021bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c0:	5b                   	pop    %ebx
801021c1:	5e                   	pop    %esi
801021c2:	5f                   	pop    %edi
801021c3:	5d                   	pop    %ebp
801021c4:	c3                   	ret
    iput(ip);
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	50                   	push   %eax
801021c9:	e8 82 f8 ff ff       	call   80101a50 <iput>
    return -1;
801021ce:	83 c4 10             	add    $0x10,%esp
801021d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021d6:	eb e5                	jmp    801021bd <dirlink+0x7d>
      panic("dirlink read");
801021d8:	83 ec 0c             	sub    $0xc,%esp
801021db:	68 87 74 10 80       	push   $0x80107487
801021e0:	e8 9b e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
801021e5:	83 ec 0c             	sub    $0xc,%esp
801021e8:	68 dc 76 10 80       	push   $0x801076dc
801021ed:	e8 8e e1 ff ff       	call   80100380 <panic>
801021f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021f9:	00 
801021fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102200 <namei>:

struct inode*
namei(char *path)
{
80102200:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102201:	31 d2                	xor    %edx,%edx
{
80102203:	89 e5                	mov    %esp,%ebp
80102205:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102208:	8b 45 08             	mov    0x8(%ebp),%eax
8010220b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010220e:	e8 0d fd ff ff       	call   80101f20 <namex>
}
80102213:	c9                   	leave
80102214:	c3                   	ret
80102215:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010221c:	00 
8010221d:	8d 76 00             	lea    0x0(%esi),%esi

80102220 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102220:	55                   	push   %ebp
  return namex(path, 1, name);
80102221:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102226:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010222b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010222e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010222f:	e9 ec fc ff ff       	jmp    80101f20 <namex>
80102234:	66 90                	xchg   %ax,%ax
80102236:	66 90                	xchg   %ax,%ax
80102238:	66 90                	xchg   %ax,%ax
8010223a:	66 90                	xchg   %ax,%ax
8010223c:	66 90                	xchg   %ax,%ax
8010223e:	66 90                	xchg   %ax,%ax

80102240 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102249:	85 c0                	test   %eax,%eax
8010224b:	0f 84 b4 00 00 00    	je     80102305 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102251:	8b 70 08             	mov    0x8(%eax),%esi
80102254:	89 c3                	mov    %eax,%ebx
80102256:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010225c:	0f 87 96 00 00 00    	ja     801022f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
80102270:	89 ca                	mov    %ecx,%edx
80102272:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102273:	83 e0 c0             	and    $0xffffffc0,%eax
80102276:	3c 40                	cmp    $0x40,%al
80102278:	75 f6                	jne    80102270 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010227a:	31 ff                	xor    %edi,%edi
8010227c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102281:	89 f8                	mov    %edi,%eax
80102283:	ee                   	out    %al,(%dx)
80102284:	b8 01 00 00 00       	mov    $0x1,%eax
80102289:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010228e:	ee                   	out    %al,(%dx)
8010228f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102294:	89 f0                	mov    %esi,%eax
80102296:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102297:	89 f0                	mov    %esi,%eax
80102299:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010229e:	c1 f8 08             	sar    $0x8,%eax
801022a1:	ee                   	out    %al,(%dx)
801022a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022a7:	89 f8                	mov    %edi,%eax
801022a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801022ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022b3:	c1 e0 04             	shl    $0x4,%eax
801022b6:	83 e0 10             	and    $0x10,%eax
801022b9:	83 c8 e0             	or     $0xffffffe0,%eax
801022bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801022bd:	f6 03 04             	testb  $0x4,(%ebx)
801022c0:	75 16                	jne    801022d8 <idestart+0x98>
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	89 ca                	mov    %ecx,%edx
801022c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801022ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022cd:	5b                   	pop    %ebx
801022ce:	5e                   	pop    %esi
801022cf:	5f                   	pop    %edi
801022d0:	5d                   	pop    %ebp
801022d1:	c3                   	ret
801022d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022d8:	b8 30 00 00 00       	mov    $0x30,%eax
801022dd:	89 ca                	mov    %ecx,%edx
801022df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801022e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ed:	fc                   	cld
801022ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret
    panic("incorrect blockno");
801022f8:	83 ec 0c             	sub    $0xc,%esp
801022fb:	68 9d 74 10 80       	push   $0x8010749d
80102300:	e8 7b e0 ff ff       	call   80100380 <panic>
    panic("idestart");
80102305:	83 ec 0c             	sub    $0xc,%esp
80102308:	68 94 74 10 80       	push   $0x80107494
8010230d:	e8 6e e0 ff ff       	call   80100380 <panic>
80102312:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102319:	00 
8010231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102320 <ideinit>:
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102326:	68 af 74 10 80       	push   $0x801074af
8010232b:	68 00 16 11 80       	push   $0x80111600
80102330:	e8 fb 21 00 00       	call   80104530 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102335:	58                   	pop    %eax
80102336:	a1 84 17 11 80       	mov    0x80111784,%eax
8010233b:	5a                   	pop    %edx
8010233c:	83 e8 01             	sub    $0x1,%eax
8010233f:	50                   	push   %eax
80102340:	6a 0e                	push   $0xe
80102342:	e8 99 02 00 00       	call   801025e0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102347:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010234a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010234f:	90                   	nop
80102350:	89 ca                	mov    %ecx,%edx
80102352:	ec                   	in     (%dx),%al
80102353:	83 e0 c0             	and    $0xffffffc0,%eax
80102356:	3c 40                	cmp    $0x40,%al
80102358:	75 f6                	jne    80102350 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010235a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010235f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102364:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102365:	89 ca                	mov    %ecx,%edx
80102367:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102368:	84 c0                	test   %al,%al
8010236a:	75 1e                	jne    8010238a <ideinit+0x6a>
8010236c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102371:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102376:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010237d:	00 
8010237e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102380:	83 e9 01             	sub    $0x1,%ecx
80102383:	74 0f                	je     80102394 <ideinit+0x74>
80102385:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102386:	84 c0                	test   %al,%al
80102388:	74 f6                	je     80102380 <ideinit+0x60>
      havedisk1 = 1;
8010238a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102391:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102394:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102399:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010239e:	ee                   	out    %al,(%dx)
}
8010239f:	c9                   	leave
801023a0:	c3                   	ret
801023a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801023a8:	00 
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	57                   	push   %edi
801023b4:	56                   	push   %esi
801023b5:	53                   	push   %ebx
801023b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023b9:	68 00 16 11 80       	push   $0x80111600
801023be:	e8 5d 23 00 00       	call   80104720 <acquire>

  if((b = idequeue) == 0){
801023c3:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801023c9:	83 c4 10             	add    $0x10,%esp
801023cc:	85 db                	test   %ebx,%ebx
801023ce:	74 63                	je     80102433 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801023d0:	8b 43 58             	mov    0x58(%ebx),%eax
801023d3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801023d8:	8b 33                	mov    (%ebx),%esi
801023da:	f7 c6 04 00 00 00    	test   $0x4,%esi
801023e0:	75 2f                	jne    80102411 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801023ee:	00 
801023ef:	90                   	nop
801023f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023f1:	89 c1                	mov    %eax,%ecx
801023f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801023f6:	80 f9 40             	cmp    $0x40,%cl
801023f9:	75 f5                	jne    801023f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023fb:	a8 21                	test   $0x21,%al
801023fd:	75 12                	jne    80102411 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801023ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102402:	b9 80 00 00 00       	mov    $0x80,%ecx
80102407:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010240c:	fc                   	cld
8010240d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010240f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102411:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102414:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102417:	83 ce 02             	or     $0x2,%esi
8010241a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010241c:	53                   	push   %ebx
8010241d:	e8 3e 1e 00 00       	call   80104260 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102422:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102427:	83 c4 10             	add    $0x10,%esp
8010242a:	85 c0                	test   %eax,%eax
8010242c:	74 05                	je     80102433 <ideintr+0x83>
    idestart(idequeue);
8010242e:	e8 0d fe ff ff       	call   80102240 <idestart>
    release(&idelock);
80102433:	83 ec 0c             	sub    $0xc,%esp
80102436:	68 00 16 11 80       	push   $0x80111600
8010243b:	e8 80 22 00 00       	call   801046c0 <release>

  release(&idelock);
}
80102440:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102443:	5b                   	pop    %ebx
80102444:	5e                   	pop    %esi
80102445:	5f                   	pop    %edi
80102446:	5d                   	pop    %ebp
80102447:	c3                   	ret
80102448:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010244f:	00 

80102450 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	53                   	push   %ebx
80102454:	83 ec 10             	sub    $0x10,%esp
80102457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010245a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010245d:	50                   	push   %eax
8010245e:	e8 7d 20 00 00       	call   801044e0 <holdingsleep>
80102463:	83 c4 10             	add    $0x10,%esp
80102466:	85 c0                	test   %eax,%eax
80102468:	0f 84 c3 00 00 00    	je     80102531 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010246e:	8b 03                	mov    (%ebx),%eax
80102470:	83 e0 06             	and    $0x6,%eax
80102473:	83 f8 02             	cmp    $0x2,%eax
80102476:	0f 84 a8 00 00 00    	je     80102524 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010247c:	8b 53 04             	mov    0x4(%ebx),%edx
8010247f:	85 d2                	test   %edx,%edx
80102481:	74 0d                	je     80102490 <iderw+0x40>
80102483:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102488:	85 c0                	test   %eax,%eax
8010248a:	0f 84 87 00 00 00    	je     80102517 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102490:	83 ec 0c             	sub    $0xc,%esp
80102493:	68 00 16 11 80       	push   $0x80111600
80102498:	e8 83 22 00 00       	call   80104720 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010249d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
801024a2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024a9:	83 c4 10             	add    $0x10,%esp
801024ac:	85 c0                	test   %eax,%eax
801024ae:	74 60                	je     80102510 <iderw+0xc0>
801024b0:	89 c2                	mov    %eax,%edx
801024b2:	8b 40 58             	mov    0x58(%eax),%eax
801024b5:	85 c0                	test   %eax,%eax
801024b7:	75 f7                	jne    801024b0 <iderw+0x60>
801024b9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801024bc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801024be:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801024c4:	74 3a                	je     80102500 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024c6:	8b 03                	mov    (%ebx),%eax
801024c8:	83 e0 06             	and    $0x6,%eax
801024cb:	83 f8 02             	cmp    $0x2,%eax
801024ce:	74 1b                	je     801024eb <iderw+0x9b>
    sleep(b, &idelock);
801024d0:	83 ec 08             	sub    $0x8,%esp
801024d3:	68 00 16 11 80       	push   $0x80111600
801024d8:	53                   	push   %ebx
801024d9:	e8 c2 1c 00 00       	call   801041a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024de:	8b 03                	mov    (%ebx),%eax
801024e0:	83 c4 10             	add    $0x10,%esp
801024e3:	83 e0 06             	and    $0x6,%eax
801024e6:	83 f8 02             	cmp    $0x2,%eax
801024e9:	75 e5                	jne    801024d0 <iderw+0x80>
  }


  release(&idelock);
801024eb:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801024f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024f5:	c9                   	leave
  release(&idelock);
801024f6:	e9 c5 21 00 00       	jmp    801046c0 <release>
801024fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102500:	89 d8                	mov    %ebx,%eax
80102502:	e8 39 fd ff ff       	call   80102240 <idestart>
80102507:	eb bd                	jmp    801024c6 <iderw+0x76>
80102509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102510:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102515:	eb a5                	jmp    801024bc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102517:	83 ec 0c             	sub    $0xc,%esp
8010251a:	68 de 74 10 80       	push   $0x801074de
8010251f:	e8 5c de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102524:	83 ec 0c             	sub    $0xc,%esp
80102527:	68 c9 74 10 80       	push   $0x801074c9
8010252c:	e8 4f de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102531:	83 ec 0c             	sub    $0xc,%esp
80102534:	68 b3 74 10 80       	push   $0x801074b3
80102539:	e8 42 de ff ff       	call   80100380 <panic>
8010253e:	66 90                	xchg   %ax,%ax

80102540 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102545:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010254c:	00 c0 fe 
  ioapic->reg = reg;
8010254f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102556:	00 00 00 
  return ioapic->data;
80102559:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010255f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102562:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102568:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010256e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102575:	c1 ee 10             	shr    $0x10,%esi
80102578:	89 f0                	mov    %esi,%eax
8010257a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010257d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102580:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102583:	39 c2                	cmp    %eax,%edx
80102585:	74 16                	je     8010259d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102587:	83 ec 0c             	sub    $0xc,%esp
8010258a:	68 f4 78 10 80       	push   $0x801078f4
8010258f:	e8 1c e1 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102594:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010259a:	83 c4 10             	add    $0x10,%esp
{
8010259d:	ba 10 00 00 00       	mov    $0x10,%edx
801025a2:	31 c0                	xor    %eax,%eax
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801025a8:	89 13                	mov    %edx,(%ebx)
801025aa:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801025ad:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801025b3:	83 c0 01             	add    $0x1,%eax
801025b6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801025bc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801025bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801025c2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801025c5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801025c7:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801025cd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801025d4:	39 c6                	cmp    %eax,%esi
801025d6:	7d d0                	jge    801025a8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801025d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025db:	5b                   	pop    %ebx
801025dc:	5e                   	pop    %esi
801025dd:	5d                   	pop    %ebp
801025de:	c3                   	ret
801025df:	90                   	nop

801025e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801025e0:	55                   	push   %ebp
  ioapic->reg = reg;
801025e1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801025e7:	89 e5                	mov    %esp,%ebp
801025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801025ec:	8d 50 20             	lea    0x20(%eax),%edx
801025ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025f5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102601:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102604:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102606:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010260b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010260e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102611:	5d                   	pop    %ebp
80102612:	c3                   	ret
80102613:	66 90                	xchg   %ax,%ax
80102615:	66 90                	xchg   %ax,%ax
80102617:	66 90                	xchg   %ax,%ax
80102619:	66 90                	xchg   %ax,%ax
8010261b:	66 90                	xchg   %ax,%ax
8010261d:	66 90                	xchg   %ax,%ax
8010261f:	90                   	nop

80102620 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	53                   	push   %ebx
80102624:	83 ec 04             	sub    $0x4,%esp
80102627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010262a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102630:	75 76                	jne    801026a8 <kfree+0x88>
80102632:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
80102638:	72 6e                	jb     801026a8 <kfree+0x88>
8010263a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102640:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102645:	77 61                	ja     801026a8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102647:	83 ec 04             	sub    $0x4,%esp
8010264a:	68 00 10 00 00       	push   $0x1000
8010264f:	6a 01                	push   $0x1
80102651:	53                   	push   %ebx
80102652:	e8 c9 21 00 00       	call   80104820 <memset>

  if(kmem.use_lock)
80102657:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	85 d2                	test   %edx,%edx
80102662:	75 1c                	jne    80102680 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102664:	a1 78 16 11 80       	mov    0x80111678,%eax
80102669:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010266b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102670:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102676:	85 c0                	test   %eax,%eax
80102678:	75 1e                	jne    80102698 <kfree+0x78>
    release(&kmem.lock);
}
8010267a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010267d:	c9                   	leave
8010267e:	c3                   	ret
8010267f:	90                   	nop
    acquire(&kmem.lock);
80102680:	83 ec 0c             	sub    $0xc,%esp
80102683:	68 40 16 11 80       	push   $0x80111640
80102688:	e8 93 20 00 00       	call   80104720 <acquire>
8010268d:	83 c4 10             	add    $0x10,%esp
80102690:	eb d2                	jmp    80102664 <kfree+0x44>
80102692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102698:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010269f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026a2:	c9                   	leave
    release(&kmem.lock);
801026a3:	e9 18 20 00 00       	jmp    801046c0 <release>
    panic("kfree");
801026a8:	83 ec 0c             	sub    $0xc,%esp
801026ab:	68 fc 74 10 80       	push   $0x801074fc
801026b0:	e8 cb dc ff ff       	call   80100380 <panic>
801026b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026bc:	00 
801026bd:	8d 76 00             	lea    0x0(%esi),%esi

801026c0 <freerange>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
801026c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dd:	39 de                	cmp    %ebx,%esi
801026df:	72 23                	jb     80102704 <freerange+0x44>
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026e8:	83 ec 0c             	sub    $0xc,%esp
801026eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026f7:	50                   	push   %eax
801026f8:	e8 23 ff ff ff       	call   80102620 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	39 de                	cmp    %ebx,%esi
80102702:	73 e4                	jae    801026e8 <freerange+0x28>
}
80102704:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102707:	5b                   	pop    %ebx
80102708:	5e                   	pop    %esi
80102709:	5d                   	pop    %ebp
8010270a:	c3                   	ret
8010270b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102710 <kinit2>:
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	56                   	push   %esi
80102714:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102715:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102718:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010271b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102721:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102727:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010272d:	39 de                	cmp    %ebx,%esi
8010272f:	72 23                	jb     80102754 <kinit2+0x44>
80102731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102738:	83 ec 0c             	sub    $0xc,%esp
8010273b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102741:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102747:	50                   	push   %eax
80102748:	e8 d3 fe ff ff       	call   80102620 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	39 de                	cmp    %ebx,%esi
80102752:	73 e4                	jae    80102738 <kinit2+0x28>
  kmem.use_lock = 1;
80102754:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010275b:	00 00 00 
}
8010275e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102761:	5b                   	pop    %ebx
80102762:	5e                   	pop    %esi
80102763:	5d                   	pop    %ebp
80102764:	c3                   	ret
80102765:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010276c:	00 
8010276d:	8d 76 00             	lea    0x0(%esi),%esi

80102770 <kinit1>:
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	56                   	push   %esi
80102774:	53                   	push   %ebx
80102775:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102778:	83 ec 08             	sub    $0x8,%esp
8010277b:	68 02 75 10 80       	push   $0x80107502
80102780:	68 40 16 11 80       	push   $0x80111640
80102785:	e8 a6 1d 00 00       	call   80104530 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010278a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010278d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102790:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102797:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010279a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ac:	39 de                	cmp    %ebx,%esi
801027ae:	72 1c                	jb     801027cc <kinit1+0x5c>
    kfree(p);
801027b0:	83 ec 0c             	sub    $0xc,%esp
801027b3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027bf:	50                   	push   %eax
801027c0:	e8 5b fe ff ff       	call   80102620 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c5:	83 c4 10             	add    $0x10,%esp
801027c8:	39 de                	cmp    %ebx,%esi
801027ca:	73 e4                	jae    801027b0 <kinit1+0x40>
}
801027cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027cf:	5b                   	pop    %ebx
801027d0:	5e                   	pop    %esi
801027d1:	5d                   	pop    %ebp
801027d2:	c3                   	ret
801027d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027da:	00 
801027db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801027e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	53                   	push   %ebx
801027e4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801027e7:	a1 74 16 11 80       	mov    0x80111674,%eax
801027ec:	85 c0                	test   %eax,%eax
801027ee:	75 20                	jne    80102810 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027f0:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801027f6:	85 db                	test   %ebx,%ebx
801027f8:	74 07                	je     80102801 <kalloc+0x21>
    kmem.freelist = r->next;
801027fa:	8b 03                	mov    (%ebx),%eax
801027fc:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102801:	89 d8                	mov    %ebx,%eax
80102803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102806:	c9                   	leave
80102807:	c3                   	ret
80102808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010280f:	00 
    acquire(&kmem.lock);
80102810:	83 ec 0c             	sub    $0xc,%esp
80102813:	68 40 16 11 80       	push   $0x80111640
80102818:	e8 03 1f 00 00       	call   80104720 <acquire>
  r = kmem.freelist;
8010281d:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
80102823:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
80102828:	83 c4 10             	add    $0x10,%esp
8010282b:	85 db                	test   %ebx,%ebx
8010282d:	74 08                	je     80102837 <kalloc+0x57>
    kmem.freelist = r->next;
8010282f:	8b 13                	mov    (%ebx),%edx
80102831:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102837:	85 c0                	test   %eax,%eax
80102839:	74 c6                	je     80102801 <kalloc+0x21>
    release(&kmem.lock);
8010283b:	83 ec 0c             	sub    $0xc,%esp
8010283e:	68 40 16 11 80       	push   $0x80111640
80102843:	e8 78 1e 00 00       	call   801046c0 <release>
}
80102848:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010284a:	83 c4 10             	add    $0x10,%esp
}
8010284d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102850:	c9                   	leave
80102851:	c3                   	ret
80102852:	66 90                	xchg   %ax,%ax
80102854:	66 90                	xchg   %ax,%ax
80102856:	66 90                	xchg   %ax,%ax
80102858:	66 90                	xchg   %ax,%ax
8010285a:	66 90                	xchg   %ax,%ax
8010285c:	66 90                	xchg   %ax,%ax
8010285e:	66 90                	xchg   %ax,%ax

80102860 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	ba 64 00 00 00       	mov    $0x64,%edx
80102865:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102866:	a8 01                	test   $0x1,%al
80102868:	0f 84 c2 00 00 00    	je     80102930 <kbdgetc+0xd0>
{
8010286e:	55                   	push   %ebp
8010286f:	ba 60 00 00 00       	mov    $0x60,%edx
80102874:	89 e5                	mov    %esp,%ebp
80102876:	53                   	push   %ebx
80102877:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102878:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010287e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102881:	3c e0                	cmp    $0xe0,%al
80102883:	74 5b                	je     801028e0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102885:	89 da                	mov    %ebx,%edx
80102887:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010288a:	84 c0                	test   %al,%al
8010288c:	78 62                	js     801028f0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010288e:	85 d2                	test   %edx,%edx
80102890:	74 09                	je     8010289b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102892:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102895:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102898:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010289b:	0f b6 91 60 7b 10 80 	movzbl -0x7fef84a0(%ecx),%edx
  shift ^= togglecode[data];
801028a2:	0f b6 81 60 7a 10 80 	movzbl -0x7fef85a0(%ecx),%eax
  shift |= shiftcode[data];
801028a9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028ab:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ad:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028af:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801028b5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028b8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028bb:	8b 04 85 40 7a 10 80 	mov    -0x7fef85c0(,%eax,4),%eax
801028c2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801028c6:	74 0b                	je     801028d3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801028c8:	8d 50 9f             	lea    -0x61(%eax),%edx
801028cb:	83 fa 19             	cmp    $0x19,%edx
801028ce:	77 48                	ja     80102918 <kbdgetc+0xb8>
      c += 'A' - 'a';
801028d0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028d6:	c9                   	leave
801028d7:	c3                   	ret
801028d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028df:	00 
    shift |= E0ESC;
801028e0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801028e3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028e5:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
801028eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ee:	c9                   	leave
801028ef:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801028f0:	83 e0 7f             	and    $0x7f,%eax
801028f3:	85 d2                	test   %edx,%edx
801028f5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801028f8:	0f b6 81 60 7b 10 80 	movzbl -0x7fef84a0(%ecx),%eax
801028ff:	83 c8 40             	or     $0x40,%eax
80102902:	0f b6 c0             	movzbl %al,%eax
80102905:	f7 d0                	not    %eax
80102907:	21 d8                	and    %ebx,%eax
80102909:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
8010290e:	31 c0                	xor    %eax,%eax
80102910:	eb d9                	jmp    801028eb <kbdgetc+0x8b>
80102912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102918:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010291b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010291e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102921:	c9                   	leave
      c += 'a' - 'A';
80102922:	83 f9 1a             	cmp    $0x1a,%ecx
80102925:	0f 42 c2             	cmovb  %edx,%eax
}
80102928:	c3                   	ret
80102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102935:	c3                   	ret
80102936:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010293d:	00 
8010293e:	66 90                	xchg   %ax,%ax

80102940 <kbdintr>:

void
kbdintr(void)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102946:	68 60 28 10 80       	push   $0x80102860
8010294b:	e8 70 e0 ff ff       	call   801009c0 <consoleintr>
}
80102950:	83 c4 10             	add    $0x10,%esp
80102953:	c9                   	leave
80102954:	c3                   	ret
80102955:	66 90                	xchg   %ax,%ax
80102957:	66 90                	xchg   %ax,%ax
80102959:	66 90                	xchg   %ax,%ax
8010295b:	66 90                	xchg   %ax,%ax
8010295d:	66 90                	xchg   %ax,%ax
8010295f:	90                   	nop

80102960 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102960:	a1 80 16 11 80       	mov    0x80111680,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	0f 84 c3 00 00 00    	je     80102a30 <lapicinit+0xd0>
  lapic[index] = value;
8010296d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102974:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102977:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010297a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102981:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102984:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102987:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010298e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102991:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102994:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010299b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ae:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029b5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029bb:	8b 50 30             	mov    0x30(%eax),%edx
801029be:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
801029c4:	75 72                	jne    80102a38 <lapicinit+0xd8>
  lapic[index] = value;
801029c6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ed:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fa:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a01:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a07:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a0e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a11:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a18:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a1e:	80 e6 10             	and    $0x10,%dh
80102a21:	75 f5                	jne    80102a18 <lapicinit+0xb8>
  lapic[index] = value;
80102a23:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a30:	c3                   	ret
80102a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a38:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a3f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a42:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a45:	e9 7c ff ff ff       	jmp    801029c6 <lapicinit+0x66>
80102a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a50 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a50:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a55:	85 c0                	test   %eax,%eax
80102a57:	74 07                	je     80102a60 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a59:	8b 40 20             	mov    0x20(%eax),%eax
80102a5c:	c1 e8 18             	shr    $0x18,%eax
80102a5f:	c3                   	ret
    return 0;
80102a60:	31 c0                	xor    %eax,%eax
}
80102a62:	c3                   	ret
80102a63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a6a:	00 
80102a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102a70 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a70:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a75:	85 c0                	test   %eax,%eax
80102a77:	74 0d                	je     80102a86 <lapiceoi+0x16>
  lapic[index] = value;
80102a79:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a80:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a86:	c3                   	ret
80102a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a8e:	00 
80102a8f:	90                   	nop

80102a90 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a90:	c3                   	ret
80102a91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a98:	00 
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102aa0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102aa0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102aa6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aab:	89 e5                	mov    %esp,%ebp
80102aad:	53                   	push   %ebx
80102aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ab1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ab4:	ee                   	out    %al,(%dx)
80102ab5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aba:	ba 71 00 00 00       	mov    $0x71,%edx
80102abf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ac0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102ac2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ac5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102acb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102acd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102ad0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102ad2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ad5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ad8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102ade:	a1 80 16 11 80       	mov    0x80111680,%eax
80102ae3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ae9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102af3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102af9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b00:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b03:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b06:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b0c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b0f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b15:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b18:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b21:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b27:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b2d:	c9                   	leave
80102b2e:	c3                   	ret
80102b2f:	90                   	nop

80102b30 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b30:	55                   	push   %ebp
80102b31:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b36:	ba 70 00 00 00       	mov    $0x70,%edx
80102b3b:	89 e5                	mov    %esp,%ebp
80102b3d:	57                   	push   %edi
80102b3e:	56                   	push   %esi
80102b3f:	53                   	push   %ebx
80102b40:	83 ec 4c             	sub    $0x4c,%esp
80102b43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b44:	ba 71 00 00 00       	mov    $0x71,%edx
80102b49:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b4a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4d:	bf 70 00 00 00       	mov    $0x70,%edi
80102b52:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b55:	8d 76 00             	lea    0x0(%esi),%esi
80102b58:	31 c0                	xor    %eax,%eax
80102b5a:	89 fa                	mov    %edi,%edx
80102b5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b62:	89 ca                	mov    %ecx,%edx
80102b64:	ec                   	in     (%dx),%al
80102b65:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b68:	89 fa                	mov    %edi,%edx
80102b6a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b70:	89 ca                	mov    %ecx,%edx
80102b72:	ec                   	in     (%dx),%al
80102b73:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b76:	89 fa                	mov    %edi,%edx
80102b78:	b8 04 00 00 00       	mov    $0x4,%eax
80102b7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7e:	89 ca                	mov    %ecx,%edx
80102b80:	ec                   	in     (%dx),%al
80102b81:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b84:	89 fa                	mov    %edi,%edx
80102b86:	b8 07 00 00 00       	mov    $0x7,%eax
80102b8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8c:	89 ca                	mov    %ecx,%edx
80102b8e:	ec                   	in     (%dx),%al
80102b8f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b92:	89 fa                	mov    %edi,%edx
80102b94:	b8 08 00 00 00       	mov    $0x8,%eax
80102b99:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9a:	89 ca                	mov    %ecx,%edx
80102b9c:	ec                   	in     (%dx),%al
80102b9d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9f:	89 fa                	mov    %edi,%edx
80102ba1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ba6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba7:	89 ca                	mov    %ecx,%edx
80102ba9:	ec                   	in     (%dx),%al
80102baa:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bad:	89 fa                	mov    %edi,%edx
80102baf:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bb4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb5:	89 ca                	mov    %ecx,%edx
80102bb7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102bb8:	84 c0                	test   %al,%al
80102bba:	78 9c                	js     80102b58 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bbc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102bc0:	89 f2                	mov    %esi,%edx
80102bc2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102bc5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc8:	89 fa                	mov    %edi,%edx
80102bca:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bcd:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102bd1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102bd4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bd7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bdb:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bde:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102be2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102be5:	31 c0                	xor    %eax,%eax
80102be7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be8:	89 ca                	mov    %ecx,%edx
80102bea:	ec                   	in     (%dx),%al
80102beb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bee:	89 fa                	mov    %edi,%edx
80102bf0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bf3:	b8 02 00 00 00       	mov    $0x2,%eax
80102bf8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf9:	89 ca                	mov    %ecx,%edx
80102bfb:	ec                   	in     (%dx),%al
80102bfc:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bff:	89 fa                	mov    %edi,%edx
80102c01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c04:	b8 04 00 00 00       	mov    $0x4,%eax
80102c09:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0a:	89 ca                	mov    %ecx,%edx
80102c0c:	ec                   	in     (%dx),%al
80102c0d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c10:	89 fa                	mov    %edi,%edx
80102c12:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c15:	b8 07 00 00 00       	mov    $0x7,%eax
80102c1a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1b:	89 ca                	mov    %ecx,%edx
80102c1d:	ec                   	in     (%dx),%al
80102c1e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c21:	89 fa                	mov    %edi,%edx
80102c23:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c26:	b8 08 00 00 00       	mov    $0x8,%eax
80102c2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2c:	89 ca                	mov    %ecx,%edx
80102c2e:	ec                   	in     (%dx),%al
80102c2f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c32:	89 fa                	mov    %edi,%edx
80102c34:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c37:	b8 09 00 00 00       	mov    $0x9,%eax
80102c3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3d:	89 ca                	mov    %ecx,%edx
80102c3f:	ec                   	in     (%dx),%al
80102c40:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c43:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c49:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c4c:	6a 18                	push   $0x18
80102c4e:	50                   	push   %eax
80102c4f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c52:	50                   	push   %eax
80102c53:	e8 08 1c 00 00       	call   80104860 <memcmp>
80102c58:	83 c4 10             	add    $0x10,%esp
80102c5b:	85 c0                	test   %eax,%eax
80102c5d:	0f 85 f5 fe ff ff    	jne    80102b58 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c63:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102c67:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c6a:	89 f0                	mov    %esi,%eax
80102c6c:	84 c0                	test   %al,%al
80102c6e:	75 78                	jne    80102ce8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c70:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c73:	89 c2                	mov    %eax,%edx
80102c75:	83 e0 0f             	and    $0xf,%eax
80102c78:	c1 ea 04             	shr    $0x4,%edx
80102c7b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c81:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c84:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c87:	89 c2                	mov    %eax,%edx
80102c89:	83 e0 0f             	and    $0xf,%eax
80102c8c:	c1 ea 04             	shr    $0x4,%edx
80102c8f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c92:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c95:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c98:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c9b:	89 c2                	mov    %eax,%edx
80102c9d:	83 e0 0f             	and    $0xf,%eax
80102ca0:	c1 ea 04             	shr    $0x4,%edx
80102ca3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ca6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ca9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102caf:	89 c2                	mov    %eax,%edx
80102cb1:	83 e0 0f             	and    $0xf,%eax
80102cb4:	c1 ea 04             	shr    $0x4,%edx
80102cb7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cba:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cbd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cc0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cc3:	89 c2                	mov    %eax,%edx
80102cc5:	83 e0 0f             	and    $0xf,%eax
80102cc8:	c1 ea 04             	shr    $0x4,%edx
80102ccb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cce:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cd7:	89 c2                	mov    %eax,%edx
80102cd9:	83 e0 0f             	and    $0xf,%eax
80102cdc:	c1 ea 04             	shr    $0x4,%edx
80102cdf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ce2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ce8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ceb:	89 03                	mov    %eax,(%ebx)
80102ced:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cf0:	89 43 04             	mov    %eax,0x4(%ebx)
80102cf3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cf6:	89 43 08             	mov    %eax,0x8(%ebx)
80102cf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cfc:	89 43 0c             	mov    %eax,0xc(%ebx)
80102cff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d02:	89 43 10             	mov    %eax,0x10(%ebx)
80102d05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d08:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102d0b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d15:	5b                   	pop    %ebx
80102d16:	5e                   	pop    %esi
80102d17:	5f                   	pop    %edi
80102d18:	5d                   	pop    %ebp
80102d19:	c3                   	ret
80102d1a:	66 90                	xchg   %ax,%ax
80102d1c:	66 90                	xchg   %ax,%ax
80102d1e:	66 90                	xchg   %ax,%ax

80102d20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d20:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102d26:	85 c9                	test   %ecx,%ecx
80102d28:	0f 8e 8a 00 00 00    	jle    80102db8 <install_trans+0x98>
{
80102d2e:	55                   	push   %ebp
80102d2f:	89 e5                	mov    %esp,%ebp
80102d31:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d32:	31 ff                	xor    %edi,%edi
{
80102d34:	56                   	push   %esi
80102d35:	53                   	push   %ebx
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d40:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102d45:	83 ec 08             	sub    $0x8,%esp
80102d48:	01 f8                	add    %edi,%eax
80102d4a:	83 c0 01             	add    $0x1,%eax
80102d4d:	50                   	push   %eax
80102d4e:	ff 35 e4 16 11 80    	push   0x801116e4
80102d54:	e8 77 d3 ff ff       	call   801000d0 <bread>
80102d59:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d5b:	58                   	pop    %eax
80102d5c:	5a                   	pop    %edx
80102d5d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102d64:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d6a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d6d:	e8 5e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d72:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d75:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d77:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d7a:	68 00 02 00 00       	push   $0x200
80102d7f:	50                   	push   %eax
80102d80:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d83:	50                   	push   %eax
80102d84:	e8 27 1b 00 00       	call   801048b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d89:	89 1c 24             	mov    %ebx,(%esp)
80102d8c:	e8 1f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d91:	89 34 24             	mov    %esi,(%esp)
80102d94:	e8 57 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d99:	89 1c 24             	mov    %ebx,(%esp)
80102d9c:	e8 4f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102daa:	7f 94                	jg     80102d40 <install_trans+0x20>
  }
}
80102dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102daf:	5b                   	pop    %ebx
80102db0:	5e                   	pop    %esi
80102db1:	5f                   	pop    %edi
80102db2:	5d                   	pop    %ebp
80102db3:	c3                   	ret
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102db8:	c3                   	ret
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dc7:	ff 35 d4 16 11 80    	push   0x801116d4
80102dcd:	ff 35 e4 16 11 80    	push   0x801116e4
80102dd3:	e8 f8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102dd8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ddb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ddd:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102de2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102de5:	85 c0                	test   %eax,%eax
80102de7:	7e 19                	jle    80102e02 <write_head+0x42>
80102de9:	31 d2                	xor    %edx,%edx
80102deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102df0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102df7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dfb:	83 c2 01             	add    $0x1,%edx
80102dfe:	39 d0                	cmp    %edx,%eax
80102e00:	75 ee                	jne    80102df0 <write_head+0x30>
  }
  bwrite(buf);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	53                   	push   %ebx
80102e06:	e8 a5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e0b:	89 1c 24             	mov    %ebx,(%esp)
80102e0e:	e8 dd d3 ff ff       	call   801001f0 <brelse>
}
80102e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e16:	83 c4 10             	add    $0x10,%esp
80102e19:	c9                   	leave
80102e1a:	c3                   	ret
80102e1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102e20 <initlog>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 2c             	sub    $0x2c,%esp
80102e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e2a:	68 07 75 10 80       	push   $0x80107507
80102e2f:	68 a0 16 11 80       	push   $0x801116a0
80102e34:	e8 f7 16 00 00       	call   80104530 <initlock>
  readsb(dev, &sb);
80102e39:	58                   	pop    %eax
80102e3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e3d:	5a                   	pop    %edx
80102e3e:	50                   	push   %eax
80102e3f:	53                   	push   %ebx
80102e40:	e8 7b e8 ff ff       	call   801016c0 <readsb>
  log.start = sb.logstart;
80102e45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e48:	59                   	pop    %ecx
  log.dev = dev;
80102e49:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102e4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e52:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102e57:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102e5d:	5a                   	pop    %edx
80102e5e:	50                   	push   %eax
80102e5f:	53                   	push   %ebx
80102e60:	e8 6b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e65:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e68:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e6b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102e71:	85 db                	test   %ebx,%ebx
80102e73:	7e 1d                	jle    80102e92 <initlog+0x72>
80102e75:	31 d2                	xor    %edx,%edx
80102e77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e7e:	00 
80102e7f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102e80:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e84:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e8b:	83 c2 01             	add    $0x1,%edx
80102e8e:	39 d3                	cmp    %edx,%ebx
80102e90:	75 ee                	jne    80102e80 <initlog+0x60>
  brelse(buf);
80102e92:	83 ec 0c             	sub    $0xc,%esp
80102e95:	50                   	push   %eax
80102e96:	e8 55 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e9b:	e8 80 fe ff ff       	call   80102d20 <install_trans>
  log.lh.n = 0;
80102ea0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102ea7:	00 00 00 
  write_head(); // clear the log
80102eaa:	e8 11 ff ff ff       	call   80102dc0 <write_head>
}
80102eaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eb2:	83 c4 10             	add    $0x10,%esp
80102eb5:	c9                   	leave
80102eb6:	c3                   	ret
80102eb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ebe:	00 
80102ebf:	90                   	nop

80102ec0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ec6:	68 a0 16 11 80       	push   $0x801116a0
80102ecb:	e8 50 18 00 00       	call   80104720 <acquire>
80102ed0:	83 c4 10             	add    $0x10,%esp
80102ed3:	eb 18                	jmp    80102eed <begin_op+0x2d>
80102ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ed8:	83 ec 08             	sub    $0x8,%esp
80102edb:	68 a0 16 11 80       	push   $0x801116a0
80102ee0:	68 a0 16 11 80       	push   $0x801116a0
80102ee5:	e8 b6 12 00 00       	call   801041a0 <sleep>
80102eea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102eed:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102ef2:	85 c0                	test   %eax,%eax
80102ef4:	75 e2                	jne    80102ed8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ef6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102efb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f01:	83 c0 01             	add    $0x1,%eax
80102f04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f0a:	83 fa 1e             	cmp    $0x1e,%edx
80102f0d:	7f c9                	jg     80102ed8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f12:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102f17:	68 a0 16 11 80       	push   $0x801116a0
80102f1c:	e8 9f 17 00 00       	call   801046c0 <release>
      break;
    }
  }
}
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	c9                   	leave
80102f25:	c3                   	ret
80102f26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f2d:	00 
80102f2e:	66 90                	xchg   %ax,%ax

80102f30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	57                   	push   %edi
80102f34:	56                   	push   %esi
80102f35:	53                   	push   %ebx
80102f36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f39:	68 a0 16 11 80       	push   $0x801116a0
80102f3e:	e8 dd 17 00 00       	call   80104720 <acquire>
  log.outstanding -= 1;
80102f43:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102f48:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102f4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f51:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f54:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102f5a:	85 f6                	test   %esi,%esi
80102f5c:	0f 85 22 01 00 00    	jne    80103084 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f62:	85 db                	test   %ebx,%ebx
80102f64:	0f 85 f6 00 00 00    	jne    80103060 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f6a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102f71:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f74:	83 ec 0c             	sub    $0xc,%esp
80102f77:	68 a0 16 11 80       	push   $0x801116a0
80102f7c:	e8 3f 17 00 00       	call   801046c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f81:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102f87:	83 c4 10             	add    $0x10,%esp
80102f8a:	85 c9                	test   %ecx,%ecx
80102f8c:	7f 42                	jg     80102fd0 <end_op+0xa0>
    acquire(&log.lock);
80102f8e:	83 ec 0c             	sub    $0xc,%esp
80102f91:	68 a0 16 11 80       	push   $0x801116a0
80102f96:	e8 85 17 00 00       	call   80104720 <acquire>
    log.committing = 0;
80102f9b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102fa2:	00 00 00 
    wakeup(&log);
80102fa5:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102fac:	e8 af 12 00 00       	call   80104260 <wakeup>
    release(&log.lock);
80102fb1:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102fb8:	e8 03 17 00 00       	call   801046c0 <release>
80102fbd:	83 c4 10             	add    $0x10,%esp
}
80102fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fc3:	5b                   	pop    %ebx
80102fc4:	5e                   	pop    %esi
80102fc5:	5f                   	pop    %edi
80102fc6:	5d                   	pop    %ebp
80102fc7:	c3                   	ret
80102fc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fcf:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fd0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102fd5:	83 ec 08             	sub    $0x8,%esp
80102fd8:	01 d8                	add    %ebx,%eax
80102fda:	83 c0 01             	add    $0x1,%eax
80102fdd:	50                   	push   %eax
80102fde:	ff 35 e4 16 11 80    	push   0x801116e4
80102fe4:	e8 e7 d0 ff ff       	call   801000d0 <bread>
80102fe9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102feb:	58                   	pop    %eax
80102fec:	5a                   	pop    %edx
80102fed:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102ff4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102ffa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ffd:	e8 ce d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103002:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103005:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103007:	8d 40 5c             	lea    0x5c(%eax),%eax
8010300a:	68 00 02 00 00       	push   $0x200
8010300f:	50                   	push   %eax
80103010:	8d 46 5c             	lea    0x5c(%esi),%eax
80103013:	50                   	push   %eax
80103014:	e8 97 18 00 00       	call   801048b0 <memmove>
    bwrite(to);  // write the log
80103019:	89 34 24             	mov    %esi,(%esp)
8010301c:	e8 8f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103021:	89 3c 24             	mov    %edi,(%esp)
80103024:	e8 c7 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103029:	89 34 24             	mov    %esi,(%esp)
8010302c:	e8 bf d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103031:	83 c4 10             	add    $0x10,%esp
80103034:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
8010303a:	7c 94                	jl     80102fd0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010303c:	e8 7f fd ff ff       	call   80102dc0 <write_head>
    install_trans(); // Now install writes to home locations
80103041:	e8 da fc ff ff       	call   80102d20 <install_trans>
    log.lh.n = 0;
80103046:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010304d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103050:	e8 6b fd ff ff       	call   80102dc0 <write_head>
80103055:	e9 34 ff ff ff       	jmp    80102f8e <end_op+0x5e>
8010305a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103060:	83 ec 0c             	sub    $0xc,%esp
80103063:	68 a0 16 11 80       	push   $0x801116a0
80103068:	e8 f3 11 00 00       	call   80104260 <wakeup>
  release(&log.lock);
8010306d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103074:	e8 47 16 00 00       	call   801046c0 <release>
80103079:	83 c4 10             	add    $0x10,%esp
}
8010307c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010307f:	5b                   	pop    %ebx
80103080:	5e                   	pop    %esi
80103081:	5f                   	pop    %edi
80103082:	5d                   	pop    %ebp
80103083:	c3                   	ret
    panic("log.committing");
80103084:	83 ec 0c             	sub    $0xc,%esp
80103087:	68 0b 75 10 80       	push   $0x8010750b
8010308c:	e8 ef d2 ff ff       	call   80100380 <panic>
80103091:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103098:	00 
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	53                   	push   %ebx
801030a4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030a7:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
801030ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030b0:	83 fa 1d             	cmp    $0x1d,%edx
801030b3:	7f 7d                	jg     80103132 <log_write+0x92>
801030b5:	a1 d8 16 11 80       	mov    0x801116d8,%eax
801030ba:	83 e8 01             	sub    $0x1,%eax
801030bd:	39 c2                	cmp    %eax,%edx
801030bf:	7d 71                	jge    80103132 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030c1:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801030c6:	85 c0                	test   %eax,%eax
801030c8:	7e 75                	jle    8010313f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030ca:	83 ec 0c             	sub    $0xc,%esp
801030cd:	68 a0 16 11 80       	push   $0x801116a0
801030d2:	e8 49 16 00 00       	call   80104720 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030d7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030da:	83 c4 10             	add    $0x10,%esp
801030dd:	31 c0                	xor    %eax,%eax
801030df:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801030e5:	85 d2                	test   %edx,%edx
801030e7:	7f 0e                	jg     801030f7 <log_write+0x57>
801030e9:	eb 15                	jmp    80103100 <log_write+0x60>
801030eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801030f0:	83 c0 01             	add    $0x1,%eax
801030f3:	39 c2                	cmp    %eax,%edx
801030f5:	74 29                	je     80103120 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030f7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
801030fe:	75 f0                	jne    801030f0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103100:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80103107:	39 c2                	cmp    %eax,%edx
80103109:	74 1c                	je     80103127 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010310b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010310e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103111:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103118:	c9                   	leave
  release(&log.lock);
80103119:	e9 a2 15 00 00       	jmp    801046c0 <release>
8010311e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103120:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80103127:	83 c2 01             	add    $0x1,%edx
8010312a:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103130:	eb d9                	jmp    8010310b <log_write+0x6b>
    panic("too big a transaction");
80103132:	83 ec 0c             	sub    $0xc,%esp
80103135:	68 1a 75 10 80       	push   $0x8010751a
8010313a:	e8 41 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010313f:	83 ec 0c             	sub    $0xc,%esp
80103142:	68 30 75 10 80       	push   $0x80107530
80103147:	e8 34 d2 ff ff       	call   80100380 <panic>
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103157:	e8 64 09 00 00       	call   80103ac0 <cpuid>
8010315c:	89 c3                	mov    %eax,%ebx
8010315e:	e8 5d 09 00 00       	call   80103ac0 <cpuid>
80103163:	83 ec 04             	sub    $0x4,%esp
80103166:	53                   	push   %ebx
80103167:	50                   	push   %eax
80103168:	68 4b 75 10 80       	push   $0x8010754b
8010316d:	e8 3e d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103172:	e8 e9 28 00 00       	call   80105a60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103177:	e8 e4 08 00 00       	call   80103a60 <mycpu>
8010317c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010317e:	b8 01 00 00 00       	mov    $0x1,%eax
80103183:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010318a:	e8 01 0c 00 00       	call   80103d90 <scheduler>
8010318f:	90                   	nop

80103190 <mpenter>:
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103196:	e8 c5 39 00 00       	call   80106b60 <switchkvm>
  seginit();
8010319b:	e8 30 39 00 00       	call   80106ad0 <seginit>
  lapicinit();
801031a0:	e8 bb f7 ff ff       	call   80102960 <lapicinit>
  mpmain();
801031a5:	e8 a6 ff ff ff       	call   80103150 <mpmain>
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <main>:
{
801031b0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031b4:	83 e4 f0             	and    $0xfffffff0,%esp
801031b7:	ff 71 fc             	push   -0x4(%ecx)
801031ba:	55                   	push   %ebp
801031bb:	89 e5                	mov    %esp,%ebp
801031bd:	53                   	push   %ebx
801031be:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031bf:	83 ec 08             	sub    $0x8,%esp
801031c2:	68 00 00 40 80       	push   $0x80400000
801031c7:	68 d0 54 11 80       	push   $0x801154d0
801031cc:	e8 9f f5 ff ff       	call   80102770 <kinit1>
  kvmalloc();      // kernel page table
801031d1:	e8 4a 3e 00 00       	call   80107020 <kvmalloc>
  mpinit();        // detect other processors
801031d6:	e8 85 01 00 00       	call   80103360 <mpinit>
  lapicinit();     // interrupt controller
801031db:	e8 80 f7 ff ff       	call   80102960 <lapicinit>
  seginit();       // segment descriptors
801031e0:	e8 eb 38 00 00       	call   80106ad0 <seginit>
  picinit();       // disable pic
801031e5:	e8 86 03 00 00       	call   80103570 <picinit>
  ioapicinit();    // another interrupt controller
801031ea:	e8 51 f3 ff ff       	call   80102540 <ioapicinit>
  consoleinit();   // console hardware
801031ef:	e8 ec d9 ff ff       	call   80100be0 <consoleinit>
  uartinit();      // serial port
801031f4:	e8 47 2b 00 00       	call   80105d40 <uartinit>
  pinit();         // process table
801031f9:	e8 42 08 00 00       	call   80103a40 <pinit>
  tvinit();        // trap vectors
801031fe:	e8 dd 27 00 00       	call   801059e0 <tvinit>
  binit();         // buffer cache
80103203:	e8 38 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103208:	e8 a3 dd ff ff       	call   80100fb0 <fileinit>
  ideinit();       // disk 
8010320d:	e8 0e f1 ff ff       	call   80102320 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103212:	83 c4 0c             	add    $0xc,%esp
80103215:	68 8a 00 00 00       	push   $0x8a
8010321a:	68 8c a4 10 80       	push   $0x8010a48c
8010321f:	68 00 70 00 80       	push   $0x80007000
80103224:	e8 87 16 00 00       	call   801048b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103229:	83 c4 10             	add    $0x10,%esp
8010322c:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103233:	00 00 00 
80103236:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010323b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103240:	76 7e                	jbe    801032c0 <main+0x110>
80103242:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103247:	eb 20                	jmp    80103269 <main+0xb9>
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103250:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103257:	00 00 00 
8010325a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103260:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103265:	39 c3                	cmp    %eax,%ebx
80103267:	73 57                	jae    801032c0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103269:	e8 f2 07 00 00       	call   80103a60 <mycpu>
8010326e:	39 c3                	cmp    %eax,%ebx
80103270:	74 de                	je     80103250 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103272:	e8 69 f5 ff ff       	call   801027e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103277:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010327a:	c7 05 f8 6f 00 80 90 	movl   $0x80103190,0x80006ff8
80103281:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103284:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010328b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010328e:	05 00 10 00 00       	add    $0x1000,%eax
80103293:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103298:	0f b6 03             	movzbl (%ebx),%eax
8010329b:	68 00 70 00 00       	push   $0x7000
801032a0:	50                   	push   %eax
801032a1:	e8 fa f7 ff ff       	call   80102aa0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032a6:	83 c4 10             	add    $0x10,%esp
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032b6:	85 c0                	test   %eax,%eax
801032b8:	74 f6                	je     801032b0 <main+0x100>
801032ba:	eb 94                	jmp    80103250 <main+0xa0>
801032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032c0:	83 ec 08             	sub    $0x8,%esp
801032c3:	68 00 00 00 8e       	push   $0x8e000000
801032c8:	68 00 00 40 80       	push   $0x80400000
801032cd:	e8 3e f4 ff ff       	call   80102710 <kinit2>
  userinit();      // first user process
801032d2:	e8 39 08 00 00       	call   80103b10 <userinit>
  mpmain();        // finish this processor's setup
801032d7:	e8 74 fe ff ff       	call   80103150 <mpmain>
801032dc:	66 90                	xchg   %ax,%ax
801032de:	66 90                	xchg   %ax,%ax

801032e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032eb:	53                   	push   %ebx
  e = addr+len;
801032ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032f2:	39 de                	cmp    %ebx,%esi
801032f4:	72 10                	jb     80103306 <mpsearch1+0x26>
801032f6:	eb 50                	jmp    80103348 <mpsearch1+0x68>
801032f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032ff:	00 
80103300:	89 fe                	mov    %edi,%esi
80103302:	39 df                	cmp    %ebx,%edi
80103304:	73 42                	jae    80103348 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103306:	83 ec 04             	sub    $0x4,%esp
80103309:	8d 7e 10             	lea    0x10(%esi),%edi
8010330c:	6a 04                	push   $0x4
8010330e:	68 5f 75 10 80       	push   $0x8010755f
80103313:	56                   	push   %esi
80103314:	e8 47 15 00 00       	call   80104860 <memcmp>
80103319:	83 c4 10             	add    $0x10,%esp
8010331c:	85 c0                	test   %eax,%eax
8010331e:	75 e0                	jne    80103300 <mpsearch1+0x20>
80103320:	89 f2                	mov    %esi,%edx
80103322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103328:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010332b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010332e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103330:	39 fa                	cmp    %edi,%edx
80103332:	75 f4                	jne    80103328 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103334:	84 c0                	test   %al,%al
80103336:	75 c8                	jne    80103300 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103338:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333b:	89 f0                	mov    %esi,%eax
8010333d:	5b                   	pop    %ebx
8010333e:	5e                   	pop    %esi
8010333f:	5f                   	pop    %edi
80103340:	5d                   	pop    %ebp
80103341:	c3                   	ret
80103342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103348:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010334b:	31 f6                	xor    %esi,%esi
}
8010334d:	5b                   	pop    %ebx
8010334e:	89 f0                	mov    %esi,%eax
80103350:	5e                   	pop    %esi
80103351:	5f                   	pop    %edi
80103352:	5d                   	pop    %ebp
80103353:	c3                   	ret
80103354:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010335b:	00 
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103360 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
80103365:	53                   	push   %ebx
80103366:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103369:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103370:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103377:	c1 e0 08             	shl    $0x8,%eax
8010337a:	09 d0                	or     %edx,%eax
8010337c:	c1 e0 04             	shl    $0x4,%eax
8010337f:	75 1b                	jne    8010339c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103381:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103388:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010338f:	c1 e0 08             	shl    $0x8,%eax
80103392:	09 d0                	or     %edx,%eax
80103394:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103397:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010339c:	ba 00 04 00 00       	mov    $0x400,%edx
801033a1:	e8 3a ff ff ff       	call   801032e0 <mpsearch1>
801033a6:	89 c3                	mov    %eax,%ebx
801033a8:	85 c0                	test   %eax,%eax
801033aa:	0f 84 58 01 00 00    	je     80103508 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b0:	8b 73 04             	mov    0x4(%ebx),%esi
801033b3:	85 f6                	test   %esi,%esi
801033b5:	0f 84 3d 01 00 00    	je     801034f8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801033bb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033be:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801033c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801033c7:	6a 04                	push   $0x4
801033c9:	68 64 75 10 80       	push   $0x80107564
801033ce:	50                   	push   %eax
801033cf:	e8 8c 14 00 00       	call   80104860 <memcmp>
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	85 c0                	test   %eax,%eax
801033d9:	0f 85 19 01 00 00    	jne    801034f8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801033df:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033e6:	3c 01                	cmp    $0x1,%al
801033e8:	74 08                	je     801033f2 <mpinit+0x92>
801033ea:	3c 04                	cmp    $0x4,%al
801033ec:	0f 85 06 01 00 00    	jne    801034f8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801033f2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033f9:	66 85 d2             	test   %dx,%dx
801033fc:	74 22                	je     80103420 <mpinit+0xc0>
801033fe:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103401:	89 f0                	mov    %esi,%eax
  sum = 0;
80103403:	31 d2                	xor    %edx,%edx
80103405:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103408:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010340f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103412:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103414:	39 f8                	cmp    %edi,%eax
80103416:	75 f0                	jne    80103408 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103418:	84 d2                	test   %dl,%dl
8010341a:	0f 85 d8 00 00 00    	jne    801034f8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103420:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103426:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103429:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010342c:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103431:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103438:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010343e:	01 d7                	add    %edx,%edi
80103440:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103442:	bf 01 00 00 00       	mov    $0x1,%edi
80103447:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010344e:	00 
8010344f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103450:	39 d0                	cmp    %edx,%eax
80103452:	73 19                	jae    8010346d <mpinit+0x10d>
    switch(*p){
80103454:	0f b6 08             	movzbl (%eax),%ecx
80103457:	80 f9 02             	cmp    $0x2,%cl
8010345a:	0f 84 80 00 00 00    	je     801034e0 <mpinit+0x180>
80103460:	77 6e                	ja     801034d0 <mpinit+0x170>
80103462:	84 c9                	test   %cl,%cl
80103464:	74 3a                	je     801034a0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103466:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103469:	39 d0                	cmp    %edx,%eax
8010346b:	72 e7                	jb     80103454 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010346d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103470:	85 ff                	test   %edi,%edi
80103472:	0f 84 dd 00 00 00    	je     80103555 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103478:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010347c:	74 15                	je     80103493 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010347e:	b8 70 00 00 00       	mov    $0x70,%eax
80103483:	ba 22 00 00 00       	mov    $0x22,%edx
80103488:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103489:	ba 23 00 00 00       	mov    $0x23,%edx
8010348e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010348f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103492:	ee                   	out    %al,(%dx)
  }
}
80103493:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103496:	5b                   	pop    %ebx
80103497:	5e                   	pop    %esi
80103498:	5f                   	pop    %edi
80103499:	5d                   	pop    %ebp
8010349a:	c3                   	ret
8010349b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801034a0:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
801034a6:	83 f9 07             	cmp    $0x7,%ecx
801034a9:	7f 19                	jg     801034c4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034ab:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801034b1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801034b5:	83 c1 01             	add    $0x1,%ecx
801034b8:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034be:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
      p += sizeof(struct mpproc);
801034c4:	83 c0 14             	add    $0x14,%eax
      continue;
801034c7:	eb 87                	jmp    80103450 <mpinit+0xf0>
801034c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801034d0:	83 e9 03             	sub    $0x3,%ecx
801034d3:	80 f9 01             	cmp    $0x1,%cl
801034d6:	76 8e                	jbe    80103466 <mpinit+0x106>
801034d8:	31 ff                	xor    %edi,%edi
801034da:	e9 71 ff ff ff       	jmp    80103450 <mpinit+0xf0>
801034df:	90                   	nop
      ioapicid = ioapic->apicno;
801034e0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801034e4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034e7:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
801034ed:	e9 5e ff ff ff       	jmp    80103450 <mpinit+0xf0>
801034f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801034f8:	83 ec 0c             	sub    $0xc,%esp
801034fb:	68 69 75 10 80       	push   $0x80107569
80103500:	e8 7b ce ff ff       	call   80100380 <panic>
80103505:	8d 76 00             	lea    0x0(%esi),%esi
{
80103508:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010350d:	eb 0b                	jmp    8010351a <mpinit+0x1ba>
8010350f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103510:	89 f3                	mov    %esi,%ebx
80103512:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103518:	74 de                	je     801034f8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010351a:	83 ec 04             	sub    $0x4,%esp
8010351d:	8d 73 10             	lea    0x10(%ebx),%esi
80103520:	6a 04                	push   $0x4
80103522:	68 5f 75 10 80       	push   $0x8010755f
80103527:	53                   	push   %ebx
80103528:	e8 33 13 00 00       	call   80104860 <memcmp>
8010352d:	83 c4 10             	add    $0x10,%esp
80103530:	85 c0                	test   %eax,%eax
80103532:	75 dc                	jne    80103510 <mpinit+0x1b0>
80103534:	89 da                	mov    %ebx,%edx
80103536:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010353d:	00 
8010353e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103540:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103543:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103546:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103548:	39 d6                	cmp    %edx,%esi
8010354a:	75 f4                	jne    80103540 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010354c:	84 c0                	test   %al,%al
8010354e:	75 c0                	jne    80103510 <mpinit+0x1b0>
80103550:	e9 5b fe ff ff       	jmp    801033b0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103555:	83 ec 0c             	sub    $0xc,%esp
80103558:	68 28 79 10 80       	push   $0x80107928
8010355d:	e8 1e ce ff ff       	call   80100380 <panic>
80103562:	66 90                	xchg   %ax,%ax
80103564:	66 90                	xchg   %ax,%ax
80103566:	66 90                	xchg   %ax,%ax
80103568:	66 90                	xchg   %ax,%ax
8010356a:	66 90                	xchg   %ax,%ax
8010356c:	66 90                	xchg   %ax,%ax
8010356e:	66 90                	xchg   %ax,%ax

80103570 <picinit>:
80103570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103575:	ba 21 00 00 00       	mov    $0x21,%edx
8010357a:	ee                   	out    %al,(%dx)
8010357b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103580:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103581:	c3                   	ret
80103582:	66 90                	xchg   %ax,%ax
80103584:	66 90                	xchg   %ax,%ax
80103586:	66 90                	xchg   %ax,%ax
80103588:	66 90                	xchg   %ax,%ax
8010358a:	66 90                	xchg   %ax,%ax
8010358c:	66 90                	xchg   %ax,%ax
8010358e:	66 90                	xchg   %ax,%ax

80103590 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 0c             	sub    $0xc,%esp
80103599:	8b 75 08             	mov    0x8(%ebp),%esi
8010359c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010359f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801035a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035ab:	e8 20 da ff ff       	call   80100fd0 <filealloc>
801035b0:	89 06                	mov    %eax,(%esi)
801035b2:	85 c0                	test   %eax,%eax
801035b4:	0f 84 a5 00 00 00    	je     8010365f <pipealloc+0xcf>
801035ba:	e8 11 da ff ff       	call   80100fd0 <filealloc>
801035bf:	89 07                	mov    %eax,(%edi)
801035c1:	85 c0                	test   %eax,%eax
801035c3:	0f 84 84 00 00 00    	je     8010364d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035c9:	e8 12 f2 ff ff       	call   801027e0 <kalloc>
801035ce:	89 c3                	mov    %eax,%ebx
801035d0:	85 c0                	test   %eax,%eax
801035d2:	0f 84 a0 00 00 00    	je     80103678 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801035d8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035df:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035e2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035e5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035ec:	00 00 00 
  p->nwrite = 0;
801035ef:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035f6:	00 00 00 
  p->nread = 0;
801035f9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103600:	00 00 00 
  initlock(&p->lock, "pipe");
80103603:	68 81 75 10 80       	push   $0x80107581
80103608:	50                   	push   %eax
80103609:	e8 22 0f 00 00       	call   80104530 <initlock>
  (*f0)->type = FD_PIPE;
8010360e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103610:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103613:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103619:	8b 06                	mov    (%esi),%eax
8010361b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010361f:	8b 06                	mov    (%esi),%eax
80103621:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103625:	8b 06                	mov    (%esi),%eax
80103627:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010362a:	8b 07                	mov    (%edi),%eax
8010362c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103632:	8b 07                	mov    (%edi),%eax
80103634:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103638:	8b 07                	mov    (%edi),%eax
8010363a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010363e:	8b 07                	mov    (%edi),%eax
80103640:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103643:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103645:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103648:	5b                   	pop    %ebx
80103649:	5e                   	pop    %esi
8010364a:	5f                   	pop    %edi
8010364b:	5d                   	pop    %ebp
8010364c:	c3                   	ret
  if(*f0)
8010364d:	8b 06                	mov    (%esi),%eax
8010364f:	85 c0                	test   %eax,%eax
80103651:	74 1e                	je     80103671 <pipealloc+0xe1>
    fileclose(*f0);
80103653:	83 ec 0c             	sub    $0xc,%esp
80103656:	50                   	push   %eax
80103657:	e8 34 da ff ff       	call   80101090 <fileclose>
8010365c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010365f:	8b 07                	mov    (%edi),%eax
80103661:	85 c0                	test   %eax,%eax
80103663:	74 0c                	je     80103671 <pipealloc+0xe1>
    fileclose(*f1);
80103665:	83 ec 0c             	sub    $0xc,%esp
80103668:	50                   	push   %eax
80103669:	e8 22 da ff ff       	call   80101090 <fileclose>
8010366e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103676:	eb cd                	jmp    80103645 <pipealloc+0xb5>
  if(*f0)
80103678:	8b 06                	mov    (%esi),%eax
8010367a:	85 c0                	test   %eax,%eax
8010367c:	75 d5                	jne    80103653 <pipealloc+0xc3>
8010367e:	eb df                	jmp    8010365f <pipealloc+0xcf>

80103680 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
80103685:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103688:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	53                   	push   %ebx
8010368f:	e8 8c 10 00 00       	call   80104720 <acquire>
  if(writable){
80103694:	83 c4 10             	add    $0x10,%esp
80103697:	85 f6                	test   %esi,%esi
80103699:	74 65                	je     80103700 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010369b:	83 ec 0c             	sub    $0xc,%esp
8010369e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801036a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036ab:	00 00 00 
    wakeup(&p->nread);
801036ae:	50                   	push   %eax
801036af:	e8 ac 0b 00 00       	call   80104260 <wakeup>
801036b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036bd:	85 d2                	test   %edx,%edx
801036bf:	75 0a                	jne    801036cb <pipeclose+0x4b>
801036c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	74 15                	je     801036e0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d1:	5b                   	pop    %ebx
801036d2:	5e                   	pop    %esi
801036d3:	5d                   	pop    %ebp
    release(&p->lock);
801036d4:	e9 e7 0f 00 00       	jmp    801046c0 <release>
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	53                   	push   %ebx
801036e4:	e8 d7 0f 00 00       	call   801046c0 <release>
    kfree((char*)p);
801036e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ec:	83 c4 10             	add    $0x10,%esp
}
801036ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f2:	5b                   	pop    %ebx
801036f3:	5e                   	pop    %esi
801036f4:	5d                   	pop    %ebp
    kfree((char*)p);
801036f5:	e9 26 ef ff ff       	jmp    80102620 <kfree>
801036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103709:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103710:	00 00 00 
    wakeup(&p->nwrite);
80103713:	50                   	push   %eax
80103714:	e8 47 0b 00 00       	call   80104260 <wakeup>
80103719:	83 c4 10             	add    $0x10,%esp
8010371c:	eb 99                	jmp    801036b7 <pipeclose+0x37>
8010371e:	66 90                	xchg   %ax,%ax

80103720 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 28             	sub    $0x28,%esp
80103729:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010372c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010372f:	53                   	push   %ebx
80103730:	e8 eb 0f 00 00       	call   80104720 <acquire>
  for(i = 0; i < n; i++){
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	85 ff                	test   %edi,%edi
8010373a:	0f 8e ce 00 00 00    	jle    8010380e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103740:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103746:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103749:	89 7d 10             	mov    %edi,0x10(%ebp)
8010374c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010374f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103752:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103755:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010375b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103761:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103767:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010376d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103770:	0f 85 b6 00 00 00    	jne    8010382c <pipewrite+0x10c>
80103776:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103779:	eb 3b                	jmp    801037b6 <pipewrite+0x96>
8010377b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103780:	e8 5b 03 00 00       	call   80103ae0 <myproc>
80103785:	8b 48 24             	mov    0x24(%eax),%ecx
80103788:	85 c9                	test   %ecx,%ecx
8010378a:	75 34                	jne    801037c0 <pipewrite+0xa0>
      wakeup(&p->nread);
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	56                   	push   %esi
80103790:	e8 cb 0a 00 00       	call   80104260 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103795:	58                   	pop    %eax
80103796:	5a                   	pop    %edx
80103797:	53                   	push   %ebx
80103798:	57                   	push   %edi
80103799:	e8 02 0a 00 00       	call   801041a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010379e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037a4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037aa:	83 c4 10             	add    $0x10,%esp
801037ad:	05 00 02 00 00       	add    $0x200,%eax
801037b2:	39 c2                	cmp    %eax,%edx
801037b4:	75 2a                	jne    801037e0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801037b6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037bc:	85 c0                	test   %eax,%eax
801037be:	75 c0                	jne    80103780 <pipewrite+0x60>
        release(&p->lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	53                   	push   %ebx
801037c4:	e8 f7 0e 00 00       	call   801046c0 <release>
        return -1;
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	5b                   	pop    %ebx
801037d5:	5e                   	pop    %esi
801037d6:	5f                   	pop    %edi
801037d7:	5d                   	pop    %ebp
801037d8:	c3                   	ret
801037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037e3:	8d 42 01             	lea    0x1(%edx),%eax
801037e6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801037ec:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037ef:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037f8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801037fc:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103800:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103803:	39 c1                	cmp    %eax,%ecx
80103805:	0f 85 50 ff ff ff    	jne    8010375b <pipewrite+0x3b>
8010380b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010380e:	83 ec 0c             	sub    $0xc,%esp
80103811:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103817:	50                   	push   %eax
80103818:	e8 43 0a 00 00       	call   80104260 <wakeup>
  release(&p->lock);
8010381d:	89 1c 24             	mov    %ebx,(%esp)
80103820:	e8 9b 0e 00 00       	call   801046c0 <release>
  return n;
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	89 f8                	mov    %edi,%eax
8010382a:	eb a5                	jmp    801037d1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010382c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010382f:	eb b2                	jmp    801037e3 <pipewrite+0xc3>
80103831:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103838:	00 
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103840 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 18             	sub    $0x18,%esp
80103849:	8b 75 08             	mov    0x8(%ebp),%esi
8010384c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010384f:	56                   	push   %esi
80103850:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103856:	e8 c5 0e 00 00       	call   80104720 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010385b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103861:	83 c4 10             	add    $0x10,%esp
80103864:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010386a:	74 2f                	je     8010389b <piperead+0x5b>
8010386c:	eb 37                	jmp    801038a5 <piperead+0x65>
8010386e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103870:	e8 6b 02 00 00       	call   80103ae0 <myproc>
80103875:	8b 40 24             	mov    0x24(%eax),%eax
80103878:	85 c0                	test   %eax,%eax
8010387a:	0f 85 80 00 00 00    	jne    80103900 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103880:	83 ec 08             	sub    $0x8,%esp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
80103885:	e8 16 09 00 00       	call   801041a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010388a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103890:	83 c4 10             	add    $0x10,%esp
80103893:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103899:	75 0a                	jne    801038a5 <piperead+0x65>
8010389b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801038a1:	85 d2                	test   %edx,%edx
801038a3:	75 cb                	jne    80103870 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801038a8:	31 db                	xor    %ebx,%ebx
801038aa:	85 c9                	test   %ecx,%ecx
801038ac:	7f 26                	jg     801038d4 <piperead+0x94>
801038ae:	eb 2c                	jmp    801038dc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038b0:	8d 48 01             	lea    0x1(%eax),%ecx
801038b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801038b8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801038be:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801038c3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038c6:	83 c3 01             	add    $0x1,%ebx
801038c9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801038cc:	74 0e                	je     801038dc <piperead+0x9c>
801038ce:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801038d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038da:	75 d4                	jne    801038b0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038dc:	83 ec 0c             	sub    $0xc,%esp
801038df:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038e5:	50                   	push   %eax
801038e6:	e8 75 09 00 00       	call   80104260 <wakeup>
  release(&p->lock);
801038eb:	89 34 24             	mov    %esi,(%esp)
801038ee:	e8 cd 0d 00 00       	call   801046c0 <release>
  return i;
801038f3:	83 c4 10             	add    $0x10,%esp
}
801038f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038f9:	89 d8                	mov    %ebx,%eax
801038fb:	5b                   	pop    %ebx
801038fc:	5e                   	pop    %esi
801038fd:	5f                   	pop    %edi
801038fe:	5d                   	pop    %ebp
801038ff:	c3                   	ret
      release(&p->lock);
80103900:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103903:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103908:	56                   	push   %esi
80103909:	e8 b2 0d 00 00       	call   801046c0 <release>
      return -1;
8010390e:	83 c4 10             	add    $0x10,%esp
}
80103911:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103914:	89 d8                	mov    %ebx,%eax
80103916:	5b                   	pop    %ebx
80103917:	5e                   	pop    %esi
80103918:	5f                   	pop    %edi
80103919:	5d                   	pop    %ebp
8010391a:	c3                   	ret
8010391b:	66 90                	xchg   %ax,%ax
8010391d:	66 90                	xchg   %ax,%ax
8010391f:	90                   	nop

80103920 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103924:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
80103929:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010392c:	68 20 1d 11 80       	push   $0x80111d20
80103931:	e8 ea 0d 00 00       	call   80104720 <acquire>
80103936:	83 c4 10             	add    $0x10,%esp
80103939:	eb 10                	jmp    8010394b <allocproc+0x2b>
8010393b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103940:	83 c3 7c             	add    $0x7c,%ebx
80103943:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103949:	74 75                	je     801039c0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010394b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010394e:	85 c0                	test   %eax,%eax
80103950:	75 ee                	jne    80103940 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103952:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103957:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010395a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103961:	89 43 10             	mov    %eax,0x10(%ebx)
80103964:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103967:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
8010396c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103972:	e8 49 0d 00 00       	call   801046c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103977:	e8 64 ee ff ff       	call   801027e0 <kalloc>
8010397c:	83 c4 10             	add    $0x10,%esp
8010397f:	89 43 08             	mov    %eax,0x8(%ebx)
80103982:	85 c0                	test   %eax,%eax
80103984:	74 53                	je     801039d9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103986:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010398c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010398f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103994:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103997:	c7 40 14 d2 59 10 80 	movl   $0x801059d2,0x14(%eax)
  p->context = (struct context*)sp;
8010399e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039a1:	6a 14                	push   $0x14
801039a3:	6a 00                	push   $0x0
801039a5:	50                   	push   %eax
801039a6:	e8 75 0e 00 00       	call   80104820 <memset>
  p->context->eip = (uint)forkret;
801039ab:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039ae:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039b1:	c7 40 10 f0 39 10 80 	movl   $0x801039f0,0x10(%eax)
}
801039b8:	89 d8                	mov    %ebx,%eax
801039ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039bd:	c9                   	leave
801039be:	c3                   	ret
801039bf:	90                   	nop
  release(&ptable.lock);
801039c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039c5:	68 20 1d 11 80       	push   $0x80111d20
801039ca:	e8 f1 0c 00 00       	call   801046c0 <release>
  return 0;
801039cf:	83 c4 10             	add    $0x10,%esp
}
801039d2:	89 d8                	mov    %ebx,%eax
801039d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039d7:	c9                   	leave
801039d8:	c3                   	ret
    p->state = UNUSED;
801039d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801039e0:	31 db                	xor    %ebx,%ebx
801039e2:	eb ee                	jmp    801039d2 <allocproc+0xb2>
801039e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039eb:	00 
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039f6:	68 20 1d 11 80       	push   $0x80111d20
801039fb:	e8 c0 0c 00 00       	call   801046c0 <release>

  if (first) {
80103a00:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a05:	83 c4 10             	add    $0x10,%esp
80103a08:	85 c0                	test   %eax,%eax
80103a0a:	75 04                	jne    80103a10 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a0c:	c9                   	leave
80103a0d:	c3                   	ret
80103a0e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a10:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a17:	00 00 00 
    iinit(ROOTDEV);
80103a1a:	83 ec 0c             	sub    $0xc,%esp
80103a1d:	6a 01                	push   $0x1
80103a1f:	e8 dc dc ff ff       	call   80101700 <iinit>
    initlog(ROOTDEV);
80103a24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a2b:	e8 f0 f3 ff ff       	call   80102e20 <initlog>
}
80103a30:	83 c4 10             	add    $0x10,%esp
80103a33:	c9                   	leave
80103a34:	c3                   	ret
80103a35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a3c:	00 
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi

80103a40 <pinit>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a46:	68 86 75 10 80       	push   $0x80107586
80103a4b:	68 20 1d 11 80       	push   $0x80111d20
80103a50:	e8 db 0a 00 00       	call   80104530 <initlock>
}
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	c9                   	leave
80103a59:	c3                   	ret
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a60 <mycpu>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a65:	9c                   	pushf
80103a66:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a67:	f6 c4 02             	test   $0x2,%ah
80103a6a:	75 46                	jne    80103ab2 <mycpu+0x52>
  apicid = lapicid();
80103a6c:	e8 df ef ff ff       	call   80102a50 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a71:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103a77:	85 f6                	test   %esi,%esi
80103a79:	7e 2a                	jle    80103aa5 <mycpu+0x45>
80103a7b:	31 d2                	xor    %edx,%edx
80103a7d:	eb 08                	jmp    80103a87 <mycpu+0x27>
80103a7f:	90                   	nop
80103a80:	83 c2 01             	add    $0x1,%edx
80103a83:	39 f2                	cmp    %esi,%edx
80103a85:	74 1e                	je     80103aa5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a87:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a8d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103a94:	39 c3                	cmp    %eax,%ebx
80103a96:	75 e8                	jne    80103a80 <mycpu+0x20>
}
80103a98:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a9b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103aa1:	5b                   	pop    %ebx
80103aa2:	5e                   	pop    %esi
80103aa3:	5d                   	pop    %ebp
80103aa4:	c3                   	ret
  panic("unknown apicid\n");
80103aa5:	83 ec 0c             	sub    $0xc,%esp
80103aa8:	68 8d 75 10 80       	push   $0x8010758d
80103aad:	e8 ce c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ab2:	83 ec 0c             	sub    $0xc,%esp
80103ab5:	68 48 79 10 80       	push   $0x80107948
80103aba:	e8 c1 c8 ff ff       	call   80100380 <panic>
80103abf:	90                   	nop

80103ac0 <cpuid>:
cpuid() {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ac6:	e8 95 ff ff ff       	call   80103a60 <mycpu>
}
80103acb:	c9                   	leave
  return mycpu()-cpus;
80103acc:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103ad1:	c1 f8 04             	sar    $0x4,%eax
80103ad4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103ada:	c3                   	ret
80103adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ae0 <myproc>:
myproc(void) {
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ae7:	e8 e4 0a 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103aec:	e8 6f ff ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103af1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af7:	e8 24 0b 00 00       	call   80104620 <popcli>
}
80103afc:	89 d8                	mov    %ebx,%eax
80103afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b01:	c9                   	leave
80103b02:	c3                   	ret
80103b03:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b0a:	00 
80103b0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b10 <userinit>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
80103b14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b17:	e8 04 fe ff ff       	call   80103920 <allocproc>
80103b1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b1e:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103b23:	e8 78 34 00 00       	call   80106fa0 <setupkvm>
80103b28:	89 43 04             	mov    %eax,0x4(%ebx)
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	0f 84 bd 00 00 00    	je     80103bf0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b33:	83 ec 04             	sub    $0x4,%esp
80103b36:	68 2c 00 00 00       	push   $0x2c
80103b3b:	68 60 a4 10 80       	push   $0x8010a460
80103b40:	50                   	push   %eax
80103b41:	e8 3a 31 00 00       	call   80106c80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b4f:	6a 4c                	push   $0x4c
80103b51:	6a 00                	push   $0x0
80103b53:	ff 73 18             	push   0x18(%ebx)
80103b56:	e8 c5 0c 00 00       	call   80104820 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b63:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b66:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b6b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b72:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b76:	8b 43 18             	mov    0x18(%ebx),%eax
80103b79:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b7d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b81:	8b 43 18             	mov    0x18(%ebx),%eax
80103b84:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b88:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b8f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b96:	8b 43 18             	mov    0x18(%ebx),%eax
80103b99:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ba0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ba3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103baa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bad:	6a 10                	push   $0x10
80103baf:	68 b6 75 10 80       	push   $0x801075b6
80103bb4:	50                   	push   %eax
80103bb5:	e8 16 0e 00 00       	call   801049d0 <safestrcpy>
  p->cwd = namei("/");
80103bba:	c7 04 24 bf 75 10 80 	movl   $0x801075bf,(%esp)
80103bc1:	e8 3a e6 ff ff       	call   80102200 <namei>
80103bc6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bc9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bd0:	e8 4b 0b 00 00       	call   80104720 <acquire>
  p->state = RUNNABLE;
80103bd5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bdc:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103be3:	e8 d8 0a 00 00       	call   801046c0 <release>
}
80103be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103beb:	83 c4 10             	add    $0x10,%esp
80103bee:	c9                   	leave
80103bef:	c3                   	ret
    panic("userinit: out of memory?");
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	68 9d 75 10 80       	push   $0x8010759d
80103bf8:	e8 83 c7 ff ff       	call   80100380 <panic>
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi

80103c00 <growproc>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
80103c05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c08:	e8 c3 09 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103c0d:	e8 4e fe ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103c12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c18:	e8 03 0a 00 00       	call   80104620 <popcli>
  sz = curproc->sz;
80103c1d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c1f:	85 f6                	test   %esi,%esi
80103c21:	7f 1d                	jg     80103c40 <growproc+0x40>
  } else if(n < 0){
80103c23:	75 3b                	jne    80103c60 <growproc+0x60>
  switchuvm(curproc);
80103c25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c2a:	53                   	push   %ebx
80103c2b:	e8 40 2f 00 00       	call   80106b70 <switchuvm>
  return 0;
80103c30:	83 c4 10             	add    $0x10,%esp
80103c33:	31 c0                	xor    %eax,%eax
}
80103c35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c38:	5b                   	pop    %ebx
80103c39:	5e                   	pop    %esi
80103c3a:	5d                   	pop    %ebp
80103c3b:	c3                   	ret
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	push   0x4(%ebx)
80103c4a:	e8 81 31 00 00       	call   80106dd0 <allocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 cf                	jne    80103c25 <growproc+0x25>
      return -1;
80103c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c5b:	eb d8                	jmp    80103c35 <growproc+0x35>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c60:	83 ec 04             	sub    $0x4,%esp
80103c63:	01 c6                	add    %eax,%esi
80103c65:	56                   	push   %esi
80103c66:	50                   	push   %eax
80103c67:	ff 73 04             	push   0x4(%ebx)
80103c6a:	e8 81 32 00 00       	call   80106ef0 <deallocuvm>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	85 c0                	test   %eax,%eax
80103c74:	75 af                	jne    80103c25 <growproc+0x25>
80103c76:	eb de                	jmp    80103c56 <growproc+0x56>
80103c78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c7f:	00 

80103c80 <fork>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c89:	e8 42 09 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103c8e:	e8 cd fd ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103c93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c99:	e8 82 09 00 00       	call   80104620 <popcli>
  if((np = allocproc()) == 0){
80103c9e:	e8 7d fc ff ff       	call   80103920 <allocproc>
80103ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ca6:	85 c0                	test   %eax,%eax
80103ca8:	0f 84 d6 00 00 00    	je     80103d84 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cae:	83 ec 08             	sub    $0x8,%esp
80103cb1:	ff 33                	push   (%ebx)
80103cb3:	89 c7                	mov    %eax,%edi
80103cb5:	ff 73 04             	push   0x4(%ebx)
80103cb8:	e8 d3 33 00 00       	call   80107090 <copyuvm>
80103cbd:	83 c4 10             	add    $0x10,%esp
80103cc0:	89 47 04             	mov    %eax,0x4(%edi)
80103cc3:	85 c0                	test   %eax,%eax
80103cc5:	0f 84 9a 00 00 00    	je     80103d65 <fork+0xe5>
  np->sz = curproc->sz;
80103ccb:	8b 03                	mov    (%ebx),%eax
80103ccd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cd0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103cd2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103cd5:	89 c8                	mov    %ecx,%eax
80103cd7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103cda:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cdf:	8b 73 18             	mov    0x18(%ebx),%esi
80103ce2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ce4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ce6:	8b 40 18             	mov    0x18(%eax),%eax
80103ce9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103cf0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	74 13                	je     80103d0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cf8:	83 ec 0c             	sub    $0xc,%esp
80103cfb:	50                   	push   %eax
80103cfc:	e8 3f d3 ff ff       	call   80101040 <filedup>
80103d01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d04:	83 c4 10             	add    $0x10,%esp
80103d07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d0b:	83 c6 01             	add    $0x1,%esi
80103d0e:	83 fe 10             	cmp    $0x10,%esi
80103d11:	75 dd                	jne    80103cf0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d13:	83 ec 0c             	sub    $0xc,%esp
80103d16:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d1c:	e8 cf db ff ff       	call   801018f0 <idup>
80103d21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d2d:	6a 10                	push   $0x10
80103d2f:	53                   	push   %ebx
80103d30:	50                   	push   %eax
80103d31:	e8 9a 0c 00 00       	call   801049d0 <safestrcpy>
  pid = np->pid;
80103d36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d39:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103d40:	e8 db 09 00 00       	call   80104720 <acquire>
  np->state = RUNNABLE;
80103d45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d4c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103d53:	e8 68 09 00 00       	call   801046c0 <release>
  return pid;
80103d58:	83 c4 10             	add    $0x10,%esp
}
80103d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d5e:	89 d8                	mov    %ebx,%eax
80103d60:	5b                   	pop    %ebx
80103d61:	5e                   	pop    %esi
80103d62:	5f                   	pop    %edi
80103d63:	5d                   	pop    %ebp
80103d64:	c3                   	ret
    kfree(np->kstack);
80103d65:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d68:	83 ec 0c             	sub    $0xc,%esp
80103d6b:	ff 73 08             	push   0x8(%ebx)
80103d6e:	e8 ad e8 ff ff       	call   80102620 <kfree>
    np->kstack = 0;
80103d73:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d7a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d7d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d84:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d89:	eb d0                	jmp    80103d5b <fork+0xdb>
80103d8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103d90 <scheduler>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d99:	e8 c2 fc ff ff       	call   80103a60 <mycpu>
  c->proc = 0;
80103d9e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103da5:	00 00 00 
  struct cpu *c = mycpu();
80103da8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103daa:	8d 78 04             	lea    0x4(%eax),%edi
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103db0:	fb                   	sti
    acquire(&ptable.lock);
80103db1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103db9:	68 20 1d 11 80       	push   $0x80111d20
80103dbe:	e8 5d 09 00 00       	call   80104720 <acquire>
80103dc3:	83 c4 10             	add    $0x10,%esp
80103dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dcd:	00 
80103dce:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103dd0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103dd4:	75 33                	jne    80103e09 <scheduler+0x79>
      switchuvm(p);
80103dd6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103dd9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ddf:	53                   	push   %ebx
80103de0:	e8 8b 2d 00 00       	call   80106b70 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103de5:	58                   	pop    %eax
80103de6:	5a                   	pop    %edx
80103de7:	ff 73 1c             	push   0x1c(%ebx)
80103dea:	57                   	push   %edi
      p->state = RUNNING;
80103deb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103df2:	e8 34 0c 00 00       	call   80104a2b <swtch>
      switchkvm();
80103df7:	e8 64 2d 00 00       	call   80106b60 <switchkvm>
      c->proc = 0;
80103dfc:	83 c4 10             	add    $0x10,%esp
80103dff:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e06:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e09:	83 c3 7c             	add    $0x7c,%ebx
80103e0c:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103e12:	75 bc                	jne    80103dd0 <scheduler+0x40>
    release(&ptable.lock);
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	68 20 1d 11 80       	push   $0x80111d20
80103e1c:	e8 9f 08 00 00       	call   801046c0 <release>
    sti();
80103e21:	83 c4 10             	add    $0x10,%esp
80103e24:	eb 8a                	jmp    80103db0 <scheduler+0x20>
80103e26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e2d:	00 
80103e2e:	66 90                	xchg   %ax,%ax

80103e30 <sched>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
  pushcli();
80103e35:	e8 96 07 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103e3a:	e8 21 fc ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103e3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e45:	e8 d6 07 00 00       	call   80104620 <popcli>
  if(!holding(&ptable.lock))
80103e4a:	83 ec 0c             	sub    $0xc,%esp
80103e4d:	68 20 1d 11 80       	push   $0x80111d20
80103e52:	e8 29 08 00 00       	call   80104680 <holding>
80103e57:	83 c4 10             	add    $0x10,%esp
80103e5a:	85 c0                	test   %eax,%eax
80103e5c:	74 4f                	je     80103ead <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e5e:	e8 fd fb ff ff       	call   80103a60 <mycpu>
80103e63:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e6a:	75 68                	jne    80103ed4 <sched+0xa4>
  if(p->state == RUNNING)
80103e6c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e70:	74 55                	je     80103ec7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e72:	9c                   	pushf
80103e73:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e74:	f6 c4 02             	test   $0x2,%ah
80103e77:	75 41                	jne    80103eba <sched+0x8a>
  intena = mycpu()->intena;
80103e79:	e8 e2 fb ff ff       	call   80103a60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e7e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e81:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e87:	e8 d4 fb ff ff       	call   80103a60 <mycpu>
80103e8c:	83 ec 08             	sub    $0x8,%esp
80103e8f:	ff 70 04             	push   0x4(%eax)
80103e92:	53                   	push   %ebx
80103e93:	e8 93 0b 00 00       	call   80104a2b <swtch>
  mycpu()->intena = intena;
80103e98:	e8 c3 fb ff ff       	call   80103a60 <mycpu>
}
80103e9d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ea0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ea6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ea9:	5b                   	pop    %ebx
80103eaa:	5e                   	pop    %esi
80103eab:	5d                   	pop    %ebp
80103eac:	c3                   	ret
    panic("sched ptable.lock");
80103ead:	83 ec 0c             	sub    $0xc,%esp
80103eb0:	68 c1 75 10 80       	push   $0x801075c1
80103eb5:	e8 c6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 ed 75 10 80       	push   $0x801075ed
80103ec2:	e8 b9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103ec7:	83 ec 0c             	sub    $0xc,%esp
80103eca:	68 df 75 10 80       	push   $0x801075df
80103ecf:	e8 ac c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 d3 75 10 80       	push   $0x801075d3
80103edc:	e8 9f c4 ff ff       	call   80100380 <panic>
80103ee1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ee8:	00 
80103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ef0 <exit>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ef9:	e8 e2 fb ff ff       	call   80103ae0 <myproc>
  if(curproc == initproc)
80103efe:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103f04:	0f 84 fd 00 00 00    	je     80104007 <exit+0x117>
80103f0a:	89 c3                	mov    %eax,%ebx
80103f0c:	8d 70 28             	lea    0x28(%eax),%esi
80103f0f:	8d 78 68             	lea    0x68(%eax),%edi
80103f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103f18:	8b 06                	mov    (%esi),%eax
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 12                	je     80103f30 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103f1e:	83 ec 0c             	sub    $0xc,%esp
80103f21:	50                   	push   %eax
80103f22:	e8 69 d1 ff ff       	call   80101090 <fileclose>
      curproc->ofile[fd] = 0;
80103f27:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f2d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f30:	83 c6 04             	add    $0x4,%esi
80103f33:	39 f7                	cmp    %esi,%edi
80103f35:	75 e1                	jne    80103f18 <exit+0x28>
  begin_op();
80103f37:	e8 84 ef ff ff       	call   80102ec0 <begin_op>
  iput(curproc->cwd);
80103f3c:	83 ec 0c             	sub    $0xc,%esp
80103f3f:	ff 73 68             	push   0x68(%ebx)
80103f42:	e8 09 db ff ff       	call   80101a50 <iput>
  end_op();
80103f47:	e8 e4 ef ff ff       	call   80102f30 <end_op>
  curproc->cwd = 0;
80103f4c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f53:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103f5a:	e8 c1 07 00 00       	call   80104720 <acquire>
  wakeup1(curproc->parent);
80103f5f:	8b 53 14             	mov    0x14(%ebx),%edx
80103f62:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f65:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f6a:	eb 0e                	jmp    80103f7a <exit+0x8a>
80103f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f70:	83 c0 7c             	add    $0x7c,%eax
80103f73:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f78:	74 1c                	je     80103f96 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103f7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f7e:	75 f0                	jne    80103f70 <exit+0x80>
80103f80:	3b 50 20             	cmp    0x20(%eax),%edx
80103f83:	75 eb                	jne    80103f70 <exit+0x80>
      p->state = RUNNABLE;
80103f85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f8c:	83 c0 7c             	add    $0x7c,%eax
80103f8f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f94:	75 e4                	jne    80103f7a <exit+0x8a>
      p->parent = initproc;
80103f96:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103fa1:	eb 10                	jmp    80103fb3 <exit+0xc3>
80103fa3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fa8:	83 c2 7c             	add    $0x7c,%edx
80103fab:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103fb1:	74 3b                	je     80103fee <exit+0xfe>
    if(p->parent == curproc){
80103fb3:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103fb6:	75 f0                	jne    80103fa8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103fb8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fbc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fbf:	75 e7                	jne    80103fa8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fc1:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103fc6:	eb 12                	jmp    80103fda <exit+0xea>
80103fc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fcf:	00 
80103fd0:	83 c0 7c             	add    $0x7c,%eax
80103fd3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103fd8:	74 ce                	je     80103fa8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103fda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fde:	75 f0                	jne    80103fd0 <exit+0xe0>
80103fe0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fe3:	75 eb                	jne    80103fd0 <exit+0xe0>
      p->state = RUNNABLE;
80103fe5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fec:	eb e2                	jmp    80103fd0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fee:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ff5:	e8 36 fe ff ff       	call   80103e30 <sched>
  panic("zombie exit");
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 0e 76 10 80       	push   $0x8010760e
80104002:	e8 79 c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104007:	83 ec 0c             	sub    $0xc,%esp
8010400a:	68 01 76 10 80       	push   $0x80107601
8010400f:	e8 6c c3 ff ff       	call   80100380 <panic>
80104014:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010401b:	00 
8010401c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104020 <wait>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
  pushcli();
80104025:	e8 a6 05 00 00       	call   801045d0 <pushcli>
  c = mycpu();
8010402a:	e8 31 fa ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010402f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104035:	e8 e6 05 00 00       	call   80104620 <popcli>
  acquire(&ptable.lock);
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 20 1d 11 80       	push   $0x80111d20
80104042:	e8 d9 06 00 00       	call   80104720 <acquire>
80104047:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010404a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104051:	eb 10                	jmp    80104063 <wait+0x43>
80104053:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104058:	83 c3 7c             	add    $0x7c,%ebx
8010405b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80104061:	74 1b                	je     8010407e <wait+0x5e>
      if(p->parent != curproc)
80104063:	39 73 14             	cmp    %esi,0x14(%ebx)
80104066:	75 f0                	jne    80104058 <wait+0x38>
      if(p->state == ZOMBIE){
80104068:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010406c:	74 62                	je     801040d0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010406e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104071:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104076:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010407c:	75 e5                	jne    80104063 <wait+0x43>
    if(!havekids || curproc->killed){
8010407e:	85 c0                	test   %eax,%eax
80104080:	0f 84 a0 00 00 00    	je     80104126 <wait+0x106>
80104086:	8b 46 24             	mov    0x24(%esi),%eax
80104089:	85 c0                	test   %eax,%eax
8010408b:	0f 85 95 00 00 00    	jne    80104126 <wait+0x106>
  pushcli();
80104091:	e8 3a 05 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80104096:	e8 c5 f9 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010409b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a1:	e8 7a 05 00 00       	call   80104620 <popcli>
  if(p == 0)
801040a6:	85 db                	test   %ebx,%ebx
801040a8:	0f 84 8f 00 00 00    	je     8010413d <wait+0x11d>
  p->chan = chan;
801040ae:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801040b1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040b8:	e8 73 fd ff ff       	call   80103e30 <sched>
  p->chan = 0;
801040bd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040c4:	eb 84                	jmp    8010404a <wait+0x2a>
801040c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040cd:	00 
801040ce:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801040d0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040d3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040d6:	ff 73 08             	push   0x8(%ebx)
801040d9:	e8 42 e5 ff ff       	call   80102620 <kfree>
        p->kstack = 0;
801040de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040e5:	5a                   	pop    %edx
801040e6:	ff 73 04             	push   0x4(%ebx)
801040e9:	e8 32 2e 00 00       	call   80106f20 <freevm>
        p->pid = 0;
801040ee:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040f5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040fc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104100:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104107:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010410e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104115:	e8 a6 05 00 00       	call   801046c0 <release>
        return pid;
8010411a:	83 c4 10             	add    $0x10,%esp
}
8010411d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104120:	89 f0                	mov    %esi,%eax
80104122:	5b                   	pop    %ebx
80104123:	5e                   	pop    %esi
80104124:	5d                   	pop    %ebp
80104125:	c3                   	ret
      release(&ptable.lock);
80104126:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104129:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010412e:	68 20 1d 11 80       	push   $0x80111d20
80104133:	e8 88 05 00 00       	call   801046c0 <release>
      return -1;
80104138:	83 c4 10             	add    $0x10,%esp
8010413b:	eb e0                	jmp    8010411d <wait+0xfd>
    panic("sleep");
8010413d:	83 ec 0c             	sub    $0xc,%esp
80104140:	68 1a 76 10 80       	push   $0x8010761a
80104145:	e8 36 c2 ff ff       	call   80100380 <panic>
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <yield>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104157:	68 20 1d 11 80       	push   $0x80111d20
8010415c:	e8 bf 05 00 00       	call   80104720 <acquire>
  pushcli();
80104161:	e8 6a 04 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80104166:	e8 f5 f8 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 aa 04 00 00       	call   80104620 <popcli>
  myproc()->state = RUNNABLE;
80104176:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010417d:	e8 ae fc ff ff       	call   80103e30 <sched>
  release(&ptable.lock);
80104182:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104189:	e8 32 05 00 00       	call   801046c0 <release>
}
8010418e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104191:	83 c4 10             	add    $0x10,%esp
80104194:	c9                   	leave
80104195:	c3                   	ret
80104196:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010419d:	00 
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <sleep>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041af:	e8 1c 04 00 00       	call   801045d0 <pushcli>
  c = mycpu();
801041b4:	e8 a7 f8 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
801041b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041bf:	e8 5c 04 00 00       	call   80104620 <popcli>
  if(p == 0)
801041c4:	85 db                	test   %ebx,%ebx
801041c6:	0f 84 87 00 00 00    	je     80104253 <sleep+0xb3>
  if(lk == 0)
801041cc:	85 f6                	test   %esi,%esi
801041ce:	74 76                	je     80104246 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041d0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801041d6:	74 50                	je     80104228 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 20 1d 11 80       	push   $0x80111d20
801041e0:	e8 3b 05 00 00       	call   80104720 <acquire>
    release(lk);
801041e5:	89 34 24             	mov    %esi,(%esp)
801041e8:	e8 d3 04 00 00       	call   801046c0 <release>
  p->chan = chan;
801041ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041f7:	e8 34 fc ff ff       	call   80103e30 <sched>
  p->chan = 0;
801041fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104203:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010420a:	e8 b1 04 00 00       	call   801046c0 <release>
    acquire(lk);
8010420f:	89 75 08             	mov    %esi,0x8(%ebp)
80104212:	83 c4 10             	add    $0x10,%esp
}
80104215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104218:	5b                   	pop    %ebx
80104219:	5e                   	pop    %esi
8010421a:	5f                   	pop    %edi
8010421b:	5d                   	pop    %ebp
    acquire(lk);
8010421c:	e9 ff 04 00 00       	jmp    80104720 <acquire>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104228:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010422b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104232:	e8 f9 fb ff ff       	call   80103e30 <sched>
  p->chan = 0;
80104237:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010423e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104241:	5b                   	pop    %ebx
80104242:	5e                   	pop    %esi
80104243:	5f                   	pop    %edi
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret
    panic("sleep without lk");
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	68 20 76 10 80       	push   $0x80107620
8010424e:	e8 2d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104253:	83 ec 0c             	sub    $0xc,%esp
80104256:	68 1a 76 10 80       	push   $0x8010761a
8010425b:	e8 20 c1 ff ff       	call   80100380 <panic>

80104260 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 10             	sub    $0x10,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010426a:	68 20 1d 11 80       	push   $0x80111d20
8010426f:	e8 ac 04 00 00       	call   80104720 <acquire>
80104274:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104277:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010427c:	eb 0c                	jmp    8010428a <wakeup+0x2a>
8010427e:	66 90                	xchg   %ax,%ax
80104280:	83 c0 7c             	add    $0x7c,%eax
80104283:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104288:	74 1c                	je     801042a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010428a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010428e:	75 f0                	jne    80104280 <wakeup+0x20>
80104290:	3b 58 20             	cmp    0x20(%eax),%ebx
80104293:	75 eb                	jne    80104280 <wakeup+0x20>
      p->state = RUNNABLE;
80104295:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010429c:	83 c0 7c             	add    $0x7c,%eax
8010429f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801042a4:	75 e4                	jne    8010428a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801042a6:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
801042ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b0:	c9                   	leave
  release(&ptable.lock);
801042b1:	e9 0a 04 00 00       	jmp    801046c0 <release>
801042b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042bd:	00 
801042be:	66 90                	xchg   %ax,%ax

801042c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ca:	68 20 1d 11 80       	push   $0x80111d20
801042cf:	e8 4c 04 00 00       	call   80104720 <acquire>
801042d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801042dc:	eb 0c                	jmp    801042ea <kill+0x2a>
801042de:	66 90                	xchg   %ax,%ax
801042e0:	83 c0 7c             	add    $0x7c,%eax
801042e3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801042e8:	74 36                	je     80104320 <kill+0x60>
    if(p->pid == pid){
801042ea:	39 58 10             	cmp    %ebx,0x10(%eax)
801042ed:	75 f1                	jne    801042e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042ef:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042f3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042fa:	75 07                	jne    80104303 <kill+0x43>
        p->state = RUNNABLE;
801042fc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	68 20 1d 11 80       	push   $0x80111d20
8010430b:	e8 b0 03 00 00       	call   801046c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104313:	83 c4 10             	add    $0x10,%esp
80104316:	31 c0                	xor    %eax,%eax
}
80104318:	c9                   	leave
80104319:	c3                   	ret
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	68 20 1d 11 80       	push   $0x80111d20
80104328:	e8 93 03 00 00       	call   801046c0 <release>
}
8010432d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104330:	83 c4 10             	add    $0x10,%esp
80104333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104338:	c9                   	leave
80104339:	c3                   	ret
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104348:	53                   	push   %ebx
80104349:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010434e:	83 ec 3c             	sub    $0x3c,%esp
80104351:	eb 24                	jmp    80104377 <procdump+0x37>
80104353:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 d8 77 10 80       	push   $0x801077d8
80104360:	e8 4b c3 ff ff       	call   801006b0 <cprintf>
80104365:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104368:	83 c3 7c             	add    $0x7c,%ebx
8010436b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104371:	0f 84 81 00 00 00    	je     801043f8 <procdump+0xb8>
    if(p->state == UNUSED)
80104377:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	74 ea                	je     80104368 <procdump+0x28>
      state = "???";
8010437e:	ba 31 76 10 80       	mov    $0x80107631,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104383:	83 f8 05             	cmp    $0x5,%eax
80104386:	77 11                	ja     80104399 <procdump+0x59>
80104388:	8b 14 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%edx
      state = "???";
8010438f:	b8 31 76 10 80       	mov    $0x80107631,%eax
80104394:	85 d2                	test   %edx,%edx
80104396:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104399:	53                   	push   %ebx
8010439a:	52                   	push   %edx
8010439b:	ff 73 a4             	push   -0x5c(%ebx)
8010439e:	68 35 76 10 80       	push   $0x80107635
801043a3:	e8 08 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801043a8:	83 c4 10             	add    $0x10,%esp
801043ab:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801043af:	75 a7                	jne    80104358 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043b1:	83 ec 08             	sub    $0x8,%esp
801043b4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043b7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043ba:	50                   	push   %eax
801043bb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043be:	8b 40 0c             	mov    0xc(%eax),%eax
801043c1:	83 c0 08             	add    $0x8,%eax
801043c4:	50                   	push   %eax
801043c5:	e8 86 01 00 00       	call   80104550 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043ca:	83 c4 10             	add    $0x10,%esp
801043cd:	8d 76 00             	lea    0x0(%esi),%esi
801043d0:	8b 17                	mov    (%edi),%edx
801043d2:	85 d2                	test   %edx,%edx
801043d4:	74 82                	je     80104358 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043dc:	52                   	push   %edx
801043dd:	68 21 73 10 80       	push   $0x80107321
801043e2:	e8 c9 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043e7:	83 c4 10             	add    $0x10,%esp
801043ea:	39 f7                	cmp    %esi,%edi
801043ec:	75 e2                	jne    801043d0 <procdump+0x90>
801043ee:	e9 65 ff ff ff       	jmp    80104358 <procdump+0x18>
801043f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801043f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043fb:	5b                   	pop    %ebx
801043fc:	5e                   	pop    %esi
801043fd:	5f                   	pop    %edi
801043fe:	5d                   	pop    %ebp
801043ff:	c3                   	ret

80104400 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010440a:	68 61 76 10 80       	push   $0x80107661
8010440f:	8d 43 04             	lea    0x4(%ebx),%eax
80104412:	50                   	push   %eax
80104413:	e8 18 01 00 00       	call   80104530 <initlock>
  lk->name = name;
80104418:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010441b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104421:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104424:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010442b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010442e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104431:	c9                   	leave
80104432:	c3                   	ret
80104433:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010443a:	00 
8010443b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104440 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104448:	8d 73 04             	lea    0x4(%ebx),%esi
8010444b:	83 ec 0c             	sub    $0xc,%esp
8010444e:	56                   	push   %esi
8010444f:	e8 cc 02 00 00       	call   80104720 <acquire>
  while (lk->locked) {
80104454:	8b 13                	mov    (%ebx),%edx
80104456:	83 c4 10             	add    $0x10,%esp
80104459:	85 d2                	test   %edx,%edx
8010445b:	74 16                	je     80104473 <acquiresleep+0x33>
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104460:	83 ec 08             	sub    $0x8,%esp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	e8 36 fd ff ff       	call   801041a0 <sleep>
  while (lk->locked) {
8010446a:	8b 03                	mov    (%ebx),%eax
8010446c:	83 c4 10             	add    $0x10,%esp
8010446f:	85 c0                	test   %eax,%eax
80104471:	75 ed                	jne    80104460 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104473:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104479:	e8 62 f6 ff ff       	call   80103ae0 <myproc>
8010447e:	8b 40 10             	mov    0x10(%eax),%eax
80104481:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104484:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104487:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010448a:	5b                   	pop    %ebx
8010448b:	5e                   	pop    %esi
8010448c:	5d                   	pop    %ebp
  release(&lk->lk);
8010448d:	e9 2e 02 00 00       	jmp    801046c0 <release>
80104492:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104499:	00 
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044a8:	8d 73 04             	lea    0x4(%ebx),%esi
801044ab:	83 ec 0c             	sub    $0xc,%esp
801044ae:	56                   	push   %esi
801044af:	e8 6c 02 00 00       	call   80104720 <acquire>
  lk->locked = 0;
801044b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044c1:	89 1c 24             	mov    %ebx,(%esp)
801044c4:	e8 97 fd ff ff       	call   80104260 <wakeup>
  release(&lk->lk);
801044c9:	89 75 08             	mov    %esi,0x8(%ebp)
801044cc:	83 c4 10             	add    $0x10,%esp
}
801044cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044d2:	5b                   	pop    %ebx
801044d3:	5e                   	pop    %esi
801044d4:	5d                   	pop    %ebp
  release(&lk->lk);
801044d5:	e9 e6 01 00 00       	jmp    801046c0 <release>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	31 ff                	xor    %edi,%edi
801044e6:	56                   	push   %esi
801044e7:	53                   	push   %ebx
801044e8:	83 ec 18             	sub    $0x18,%esp
801044eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044ee:	8d 73 04             	lea    0x4(%ebx),%esi
801044f1:	56                   	push   %esi
801044f2:	e8 29 02 00 00       	call   80104720 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044f7:	8b 03                	mov    (%ebx),%eax
801044f9:	83 c4 10             	add    $0x10,%esp
801044fc:	85 c0                	test   %eax,%eax
801044fe:	75 18                	jne    80104518 <holdingsleep+0x38>
  release(&lk->lk);
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	56                   	push   %esi
80104504:	e8 b7 01 00 00       	call   801046c0 <release>
  return r;
}
80104509:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010450c:	89 f8                	mov    %edi,%eax
8010450e:	5b                   	pop    %ebx
8010450f:	5e                   	pop    %esi
80104510:	5f                   	pop    %edi
80104511:	5d                   	pop    %ebp
80104512:	c3                   	ret
80104513:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104518:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010451b:	e8 c0 f5 ff ff       	call   80103ae0 <myproc>
80104520:	39 58 10             	cmp    %ebx,0x10(%eax)
80104523:	0f 94 c0             	sete   %al
80104526:	0f b6 c0             	movzbl %al,%eax
80104529:	89 c7                	mov    %eax,%edi
8010452b:	eb d3                	jmp    80104500 <holdingsleep+0x20>
8010452d:	66 90                	xchg   %ax,%ax
8010452f:	90                   	nop

80104530 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104536:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010453f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104542:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104549:	5d                   	pop    %ebp
8010454a:	c3                   	ret
8010454b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104550 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	8b 45 08             	mov    0x8(%ebp),%eax
80104557:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010455a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010455d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104562:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104567:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010456c:	76 10                	jbe    8010457e <getcallerpcs+0x2e>
8010456e:	eb 28                	jmp    80104598 <getcallerpcs+0x48>
80104570:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104576:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010457c:	77 1a                	ja     80104598 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010457e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104581:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104584:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104587:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104589:	83 f8 0a             	cmp    $0xa,%eax
8010458c:	75 e2                	jne    80104570 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010458e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104591:	c9                   	leave
80104592:	c3                   	ret
80104593:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104598:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010459b:	83 c1 28             	add    $0x28,%ecx
8010459e:	89 ca                	mov    %ecx,%edx
801045a0:	29 c2                	sub    %eax,%edx
801045a2:	83 e2 04             	and    $0x4,%edx
801045a5:	74 11                	je     801045b8 <getcallerpcs+0x68>
    pcs[i] = 0;
801045a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045ad:	83 c0 04             	add    $0x4,%eax
801045b0:	39 c1                	cmp    %eax,%ecx
801045b2:	74 da                	je     8010458e <getcallerpcs+0x3e>
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801045b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045be:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801045c1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801045c8:	39 c1                	cmp    %eax,%ecx
801045ca:	75 ec                	jne    801045b8 <getcallerpcs+0x68>
801045cc:	eb c0                	jmp    8010458e <getcallerpcs+0x3e>
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
801045d7:	9c                   	pushf
801045d8:	5b                   	pop    %ebx
  asm volatile("cli");
801045d9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045da:	e8 81 f4 ff ff       	call   80103a60 <mycpu>
801045df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045e5:	85 c0                	test   %eax,%eax
801045e7:	74 17                	je     80104600 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045e9:	e8 72 f4 ff ff       	call   80103a60 <mycpu>
801045ee:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f8:	c9                   	leave
801045f9:	c3                   	ret
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104600:	e8 5b f4 ff ff       	call   80103a60 <mycpu>
80104605:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010460b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104611:	eb d6                	jmp    801045e9 <pushcli+0x19>
80104613:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010461a:	00 
8010461b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104620 <popcli>:

void
popcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104626:	9c                   	pushf
80104627:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104628:	f6 c4 02             	test   $0x2,%ah
8010462b:	75 35                	jne    80104662 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010462d:	e8 2e f4 ff ff       	call   80103a60 <mycpu>
80104632:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104639:	78 34                	js     8010466f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010463b:	e8 20 f4 ff ff       	call   80103a60 <mycpu>
80104640:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104646:	85 d2                	test   %edx,%edx
80104648:	74 06                	je     80104650 <popcli+0x30>
    sti();
}
8010464a:	c9                   	leave
8010464b:	c3                   	ret
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104650:	e8 0b f4 ff ff       	call   80103a60 <mycpu>
80104655:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010465b:	85 c0                	test   %eax,%eax
8010465d:	74 eb                	je     8010464a <popcli+0x2a>
  asm volatile("sti");
8010465f:	fb                   	sti
}
80104660:	c9                   	leave
80104661:	c3                   	ret
    panic("popcli - interruptible");
80104662:	83 ec 0c             	sub    $0xc,%esp
80104665:	68 6c 76 10 80       	push   $0x8010766c
8010466a:	e8 11 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010466f:	83 ec 0c             	sub    $0xc,%esp
80104672:	68 83 76 10 80       	push   $0x80107683
80104677:	e8 04 bd ff ff       	call   80100380 <panic>
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <holding>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 75 08             	mov    0x8(%ebp),%esi
80104688:	31 db                	xor    %ebx,%ebx
  pushcli();
8010468a:	e8 41 ff ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010468f:	8b 06                	mov    (%esi),%eax
80104691:	85 c0                	test   %eax,%eax
80104693:	75 0b                	jne    801046a0 <holding+0x20>
  popcli();
80104695:	e8 86 ff ff ff       	call   80104620 <popcli>
}
8010469a:	89 d8                	mov    %ebx,%eax
8010469c:	5b                   	pop    %ebx
8010469d:	5e                   	pop    %esi
8010469e:	5d                   	pop    %ebp
8010469f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801046a0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046a3:	e8 b8 f3 ff ff       	call   80103a60 <mycpu>
801046a8:	39 c3                	cmp    %eax,%ebx
801046aa:	0f 94 c3             	sete   %bl
  popcli();
801046ad:	e8 6e ff ff ff       	call   80104620 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801046b2:	0f b6 db             	movzbl %bl,%ebx
}
801046b5:	89 d8                	mov    %ebx,%eax
801046b7:	5b                   	pop    %ebx
801046b8:	5e                   	pop    %esi
801046b9:	5d                   	pop    %ebp
801046ba:	c3                   	ret
801046bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046c0 <release>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046c8:	e8 03 ff ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046cd:	8b 03                	mov    (%ebx),%eax
801046cf:	85 c0                	test   %eax,%eax
801046d1:	75 15                	jne    801046e8 <release+0x28>
  popcli();
801046d3:	e8 48 ff ff ff       	call   80104620 <popcli>
    panic("release");
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 8a 76 10 80       	push   $0x8010768a
801046e0:	e8 9b bc ff ff       	call   80100380 <panic>
801046e5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046e8:	8b 73 08             	mov    0x8(%ebx),%esi
801046eb:	e8 70 f3 ff ff       	call   80103a60 <mycpu>
801046f0:	39 c6                	cmp    %eax,%esi
801046f2:	75 df                	jne    801046d3 <release+0x13>
  popcli();
801046f4:	e8 27 ff ff ff       	call   80104620 <popcli>
  lk->pcs[0] = 0;
801046f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104700:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104707:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010470c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104712:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104715:	5b                   	pop    %ebx
80104716:	5e                   	pop    %esi
80104717:	5d                   	pop    %ebp
  popcli();
80104718:	e9 03 ff ff ff       	jmp    80104620 <popcli>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi

80104720 <acquire>:
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104727:	e8 a4 fe ff ff       	call   801045d0 <pushcli>
  if(holding(lk))
8010472c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010472f:	e8 9c fe ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104734:	8b 03                	mov    (%ebx),%eax
80104736:	85 c0                	test   %eax,%eax
80104738:	0f 85 b2 00 00 00    	jne    801047f0 <acquire+0xd0>
  popcli();
8010473e:	e8 dd fe ff ff       	call   80104620 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104743:	b9 01 00 00 00       	mov    $0x1,%ecx
80104748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010474f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104750:	8b 55 08             	mov    0x8(%ebp),%edx
80104753:	89 c8                	mov    %ecx,%eax
80104755:	f0 87 02             	lock xchg %eax,(%edx)
80104758:	85 c0                	test   %eax,%eax
8010475a:	75 f4                	jne    80104750 <acquire+0x30>
  __sync_synchronize();
8010475c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104761:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104764:	e8 f7 f2 ff ff       	call   80103a60 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104769:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010476c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010476e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104771:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104777:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010477c:	77 32                	ja     801047b0 <acquire+0x90>
  ebp = (uint*)v - 2;
8010477e:	89 e8                	mov    %ebp,%eax
80104780:	eb 14                	jmp    80104796 <acquire+0x76>
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104788:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010478e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104794:	77 1a                	ja     801047b0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104796:	8b 58 04             	mov    0x4(%eax),%ebx
80104799:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010479d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047a0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047a2:	83 fa 0a             	cmp    $0xa,%edx
801047a5:	75 e1                	jne    80104788 <acquire+0x68>
}
801047a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047aa:	c9                   	leave
801047ab:	c3                   	ret
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047b0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801047b4:	83 c1 34             	add    $0x34,%ecx
801047b7:	89 ca                	mov    %ecx,%edx
801047b9:	29 c2                	sub    %eax,%edx
801047bb:	83 e2 04             	and    $0x4,%edx
801047be:	74 10                	je     801047d0 <acquire+0xb0>
    pcs[i] = 0;
801047c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047c6:	83 c0 04             	add    $0x4,%eax
801047c9:	39 c1                	cmp    %eax,%ecx
801047cb:	74 da                	je     801047a7 <acquire+0x87>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801047d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047d6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801047d9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801047e0:	39 c1                	cmp    %eax,%ecx
801047e2:	75 ec                	jne    801047d0 <acquire+0xb0>
801047e4:	eb c1                	jmp    801047a7 <acquire+0x87>
801047e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047ed:	00 
801047ee:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801047f0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801047f3:	e8 68 f2 ff ff       	call   80103a60 <mycpu>
801047f8:	39 c3                	cmp    %eax,%ebx
801047fa:	0f 85 3e ff ff ff    	jne    8010473e <acquire+0x1e>
  popcli();
80104800:	e8 1b fe ff ff       	call   80104620 <popcli>
    panic("acquire");
80104805:	83 ec 0c             	sub    $0xc,%esp
80104808:	68 92 76 10 80       	push   $0x80107692
8010480d:	e8 6e bb ff ff       	call   80100380 <panic>
80104812:	66 90                	xchg   %ax,%ax
80104814:	66 90                	xchg   %ax,%ax
80104816:	66 90                	xchg   %ax,%ax
80104818:	66 90                	xchg   %ax,%ax
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	8b 55 08             	mov    0x8(%ebp),%edx
80104827:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010482a:	89 d0                	mov    %edx,%eax
8010482c:	09 c8                	or     %ecx,%eax
8010482e:	a8 03                	test   $0x3,%al
80104830:	75 1e                	jne    80104850 <memset+0x30>
    c &= 0xFF;
80104832:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104836:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104839:	89 d7                	mov    %edx,%edi
8010483b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104841:	fc                   	cld
80104842:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104844:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104847:	89 d0                	mov    %edx,%eax
80104849:	c9                   	leave
8010484a:	c3                   	ret
8010484b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104850:	8b 45 0c             	mov    0xc(%ebp),%eax
80104853:	89 d7                	mov    %edx,%edi
80104855:	fc                   	cld
80104856:	f3 aa                	rep stos %al,%es:(%edi)
80104858:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010485b:	89 d0                	mov    %edx,%eax
8010485d:	c9                   	leave
8010485e:	c3                   	ret
8010485f:	90                   	nop

80104860 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	8b 75 10             	mov    0x10(%ebp),%esi
80104867:	8b 45 08             	mov    0x8(%ebp),%eax
8010486a:	53                   	push   %ebx
8010486b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010486e:	85 f6                	test   %esi,%esi
80104870:	74 2e                	je     801048a0 <memcmp+0x40>
80104872:	01 c6                	add    %eax,%esi
80104874:	eb 14                	jmp    8010488a <memcmp+0x2a>
80104876:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010487d:	00 
8010487e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104880:	83 c0 01             	add    $0x1,%eax
80104883:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104886:	39 f0                	cmp    %esi,%eax
80104888:	74 16                	je     801048a0 <memcmp+0x40>
    if(*s1 != *s2)
8010488a:	0f b6 08             	movzbl (%eax),%ecx
8010488d:	0f b6 1a             	movzbl (%edx),%ebx
80104890:	38 d9                	cmp    %bl,%cl
80104892:	74 ec                	je     80104880 <memcmp+0x20>
      return *s1 - *s2;
80104894:	0f b6 c1             	movzbl %cl,%eax
80104897:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104899:	5b                   	pop    %ebx
8010489a:	5e                   	pop    %esi
8010489b:	5d                   	pop    %ebp
8010489c:	c3                   	ret
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
801048a0:	5b                   	pop    %ebx
  return 0;
801048a1:	31 c0                	xor    %eax,%eax
}
801048a3:	5e                   	pop    %esi
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret
801048a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ad:	00 
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	8b 55 08             	mov    0x8(%ebp),%edx
801048b7:	8b 45 10             	mov    0x10(%ebp),%eax
801048ba:	56                   	push   %esi
801048bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048be:	39 d6                	cmp    %edx,%esi
801048c0:	73 26                	jae    801048e8 <memmove+0x38>
801048c2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048c5:	39 ca                	cmp    %ecx,%edx
801048c7:	73 1f                	jae    801048e8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801048c9:	85 c0                	test   %eax,%eax
801048cb:	74 0f                	je     801048dc <memmove+0x2c>
801048cd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801048d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048d4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048d7:	83 e8 01             	sub    $0x1,%eax
801048da:	73 f4                	jae    801048d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048dc:	5e                   	pop    %esi
801048dd:	89 d0                	mov    %edx,%eax
801048df:	5f                   	pop    %edi
801048e0:	5d                   	pop    %ebp
801048e1:	c3                   	ret
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801048e8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048eb:	89 d7                	mov    %edx,%edi
801048ed:	85 c0                	test   %eax,%eax
801048ef:	74 eb                	je     801048dc <memmove+0x2c>
801048f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048f9:	39 ce                	cmp    %ecx,%esi
801048fb:	75 fb                	jne    801048f8 <memmove+0x48>
}
801048fd:	5e                   	pop    %esi
801048fe:	89 d0                	mov    %edx,%eax
80104900:	5f                   	pop    %edi
80104901:	5d                   	pop    %ebp
80104902:	c3                   	ret
80104903:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010490a:	00 
8010490b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104910 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104910:	eb 9e                	jmp    801048b0 <memmove>
80104912:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104919:	00 
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104920 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	8b 55 10             	mov    0x10(%ebp),%edx
80104927:	8b 45 08             	mov    0x8(%ebp),%eax
8010492a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010492d:	85 d2                	test   %edx,%edx
8010492f:	75 16                	jne    80104947 <strncmp+0x27>
80104931:	eb 2d                	jmp    80104960 <strncmp+0x40>
80104933:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104938:	3a 19                	cmp    (%ecx),%bl
8010493a:	75 12                	jne    8010494e <strncmp+0x2e>
    n--, p++, q++;
8010493c:	83 c0 01             	add    $0x1,%eax
8010493f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104942:	83 ea 01             	sub    $0x1,%edx
80104945:	74 19                	je     80104960 <strncmp+0x40>
80104947:	0f b6 18             	movzbl (%eax),%ebx
8010494a:	84 db                	test   %bl,%bl
8010494c:	75 ea                	jne    80104938 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010494e:	0f b6 00             	movzbl (%eax),%eax
80104951:	0f b6 11             	movzbl (%ecx),%edx
}
80104954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104957:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104958:	29 d0                	sub    %edx,%eax
}
8010495a:	c3                   	ret
8010495b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104963:	31 c0                	xor    %eax,%eax
}
80104965:	c9                   	leave
80104966:	c3                   	ret
80104967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010496e:	00 
8010496f:	90                   	nop

80104970 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	8b 75 08             	mov    0x8(%ebp),%esi
80104978:	53                   	push   %ebx
80104979:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010497c:	89 f0                	mov    %esi,%eax
8010497e:	eb 15                	jmp    80104995 <strncpy+0x25>
80104980:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104984:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104987:	83 c0 01             	add    $0x1,%eax
8010498a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010498e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104991:	84 c9                	test   %cl,%cl
80104993:	74 13                	je     801049a8 <strncpy+0x38>
80104995:	89 d3                	mov    %edx,%ebx
80104997:	83 ea 01             	sub    $0x1,%edx
8010499a:	85 db                	test   %ebx,%ebx
8010499c:	7f e2                	jg     80104980 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010499e:	5b                   	pop    %ebx
8010499f:	89 f0                	mov    %esi,%eax
801049a1:	5e                   	pop    %esi
801049a2:	5f                   	pop    %edi
801049a3:	5d                   	pop    %ebp
801049a4:	c3                   	ret
801049a5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
801049a8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
801049ab:	83 e9 01             	sub    $0x1,%ecx
801049ae:	85 d2                	test   %edx,%edx
801049b0:	74 ec                	je     8010499e <strncpy+0x2e>
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
801049b8:	83 c0 01             	add    $0x1,%eax
801049bb:	89 ca                	mov    %ecx,%edx
801049bd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
801049c1:	29 c2                	sub    %eax,%edx
801049c3:	85 d2                	test   %edx,%edx
801049c5:	7f f1                	jg     801049b8 <strncpy+0x48>
}
801049c7:	5b                   	pop    %ebx
801049c8:	89 f0                	mov    %esi,%eax
801049ca:	5e                   	pop    %esi
801049cb:	5f                   	pop    %edi
801049cc:	5d                   	pop    %ebp
801049cd:	c3                   	ret
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	8b 55 10             	mov    0x10(%ebp),%edx
801049d7:	8b 75 08             	mov    0x8(%ebp),%esi
801049da:	53                   	push   %ebx
801049db:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049de:	85 d2                	test   %edx,%edx
801049e0:	7e 25                	jle    80104a07 <safestrcpy+0x37>
801049e2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801049e6:	89 f2                	mov    %esi,%edx
801049e8:	eb 16                	jmp    80104a00 <safestrcpy+0x30>
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049f0:	0f b6 08             	movzbl (%eax),%ecx
801049f3:	83 c0 01             	add    $0x1,%eax
801049f6:	83 c2 01             	add    $0x1,%edx
801049f9:	88 4a ff             	mov    %cl,-0x1(%edx)
801049fc:	84 c9                	test   %cl,%cl
801049fe:	74 04                	je     80104a04 <safestrcpy+0x34>
80104a00:	39 d8                	cmp    %ebx,%eax
80104a02:	75 ec                	jne    801049f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104a04:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a07:	89 f0                	mov    %esi,%eax
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5d                   	pop    %ebp
80104a0c:	c3                   	ret
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <strlen>:

int
strlen(const char *s)
{
80104a10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a11:	31 c0                	xor    %eax,%eax
{
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a18:	80 3a 00             	cmpb   $0x0,(%edx)
80104a1b:	74 0c                	je     80104a29 <strlen+0x19>
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
80104a20:	83 c0 01             	add    $0x1,%eax
80104a23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a27:	75 f7                	jne    80104a20 <strlen+0x10>
    ;
  return n;
}
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret

80104a2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a33:	55                   	push   %ebp
  pushl %ebx
80104a34:	53                   	push   %ebx
  pushl %esi
80104a35:	56                   	push   %esi
  pushl %edi
80104a36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a39:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a3b:	5f                   	pop    %edi
  popl %esi
80104a3c:	5e                   	pop    %esi
  popl %ebx
80104a3d:	5b                   	pop    %ebx
  popl %ebp
80104a3e:	5d                   	pop    %ebp
  ret
80104a3f:	c3                   	ret

80104a40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a4a:	e8 91 f0 ff ff       	call   80103ae0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a4f:	8b 00                	mov    (%eax),%eax
80104a51:	39 c3                	cmp    %eax,%ebx
80104a53:	73 1b                	jae    80104a70 <fetchint+0x30>
80104a55:	8d 53 04             	lea    0x4(%ebx),%edx
80104a58:	39 d0                	cmp    %edx,%eax
80104a5a:	72 14                	jb     80104a70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a5f:	8b 13                	mov    (%ebx),%edx
80104a61:	89 10                	mov    %edx,(%eax)
  return 0;
80104a63:	31 c0                	xor    %eax,%eax
}
80104a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a68:	c9                   	leave
80104a69:	c3                   	ret
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a75:	eb ee                	jmp    80104a65 <fetchint+0x25>
80104a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a7e:	00 
80104a7f:	90                   	nop

80104a80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
80104a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a8a:	e8 51 f0 ff ff       	call   80103ae0 <myproc>

  if(addr >= curproc->sz)
80104a8f:	3b 18                	cmp    (%eax),%ebx
80104a91:	73 2d                	jae    80104ac0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a93:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a96:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a98:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a9a:	39 d3                	cmp    %edx,%ebx
80104a9c:	73 22                	jae    80104ac0 <fetchstr+0x40>
80104a9e:	89 d8                	mov    %ebx,%eax
80104aa0:	eb 0d                	jmp    80104aaf <fetchstr+0x2f>
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa8:	83 c0 01             	add    $0x1,%eax
80104aab:	39 d0                	cmp    %edx,%eax
80104aad:	73 11                	jae    80104ac0 <fetchstr+0x40>
    if(*s == 0)
80104aaf:	80 38 00             	cmpb   $0x0,(%eax)
80104ab2:	75 f4                	jne    80104aa8 <fetchstr+0x28>
      return s - *pp;
80104ab4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab9:	c9                   	leave
80104aba:	c3                   	ret
80104abb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ac3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ac8:	c9                   	leave
80104ac9:	c3                   	ret
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ad5:	e8 06 f0 ff ff       	call   80103ae0 <myproc>
80104ada:	8b 55 08             	mov    0x8(%ebp),%edx
80104add:	8b 40 18             	mov    0x18(%eax),%eax
80104ae0:	8b 40 44             	mov    0x44(%eax),%eax
80104ae3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ae6:	e8 f5 ef ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aeb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aee:	8b 00                	mov    (%eax),%eax
80104af0:	39 c6                	cmp    %eax,%esi
80104af2:	73 1c                	jae    80104b10 <argint+0x40>
80104af4:	8d 53 08             	lea    0x8(%ebx),%edx
80104af7:	39 d0                	cmp    %edx,%eax
80104af9:	72 15                	jb     80104b10 <argint+0x40>
  *ip = *(int*)(addr);
80104afb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104afe:	8b 53 04             	mov    0x4(%ebx),%edx
80104b01:	89 10                	mov    %edx,(%eax)
  return 0;
80104b03:	31 c0                	xor    %eax,%eax
}
80104b05:	5b                   	pop    %ebx
80104b06:	5e                   	pop    %esi
80104b07:	5d                   	pop    %ebp
80104b08:	c3                   	ret
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b15:	eb ee                	jmp    80104b05 <argint+0x35>
80104b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b1e:	00 
80104b1f:	90                   	nop

80104b20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	57                   	push   %edi
80104b24:	56                   	push   %esi
80104b25:	53                   	push   %ebx
80104b26:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b29:	e8 b2 ef ff ff       	call   80103ae0 <myproc>
80104b2e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b30:	e8 ab ef ff ff       	call   80103ae0 <myproc>
80104b35:	8b 55 08             	mov    0x8(%ebp),%edx
80104b38:	8b 40 18             	mov    0x18(%eax),%eax
80104b3b:	8b 40 44             	mov    0x44(%eax),%eax
80104b3e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b41:	e8 9a ef ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b46:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b49:	8b 00                	mov    (%eax),%eax
80104b4b:	39 c7                	cmp    %eax,%edi
80104b4d:	73 31                	jae    80104b80 <argptr+0x60>
80104b4f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b52:	39 c8                	cmp    %ecx,%eax
80104b54:	72 2a                	jb     80104b80 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b56:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b59:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b5c:	85 d2                	test   %edx,%edx
80104b5e:	78 20                	js     80104b80 <argptr+0x60>
80104b60:	8b 16                	mov    (%esi),%edx
80104b62:	39 d0                	cmp    %edx,%eax
80104b64:	73 1a                	jae    80104b80 <argptr+0x60>
80104b66:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b69:	01 c3                	add    %eax,%ebx
80104b6b:	39 da                	cmp    %ebx,%edx
80104b6d:	72 11                	jb     80104b80 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b72:	89 02                	mov    %eax,(%edx)
  return 0;
80104b74:	31 c0                	xor    %eax,%eax
}
80104b76:	83 c4 0c             	add    $0xc,%esp
80104b79:	5b                   	pop    %ebx
80104b7a:	5e                   	pop    %esi
80104b7b:	5f                   	pop    %edi
80104b7c:	5d                   	pop    %ebp
80104b7d:	c3                   	ret
80104b7e:	66 90                	xchg   %ax,%ax
    return -1;
80104b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b85:	eb ef                	jmp    80104b76 <argptr+0x56>
80104b87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b8e:	00 
80104b8f:	90                   	nop

80104b90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	e8 46 ef ff ff       	call   80103ae0 <myproc>
80104b9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ba0:	8b 40 44             	mov    0x44(%eax),%eax
80104ba3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ba6:	e8 35 ef ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bae:	8b 00                	mov    (%eax),%eax
80104bb0:	39 c6                	cmp    %eax,%esi
80104bb2:	73 44                	jae    80104bf8 <argstr+0x68>
80104bb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bb7:	39 d0                	cmp    %edx,%eax
80104bb9:	72 3d                	jb     80104bf8 <argstr+0x68>
  *ip = *(int*)(addr);
80104bbb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bbe:	e8 1d ef ff ff       	call   80103ae0 <myproc>
  if(addr >= curproc->sz)
80104bc3:	3b 18                	cmp    (%eax),%ebx
80104bc5:	73 31                	jae    80104bf8 <argstr+0x68>
  *pp = (char*)addr;
80104bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bcc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bce:	39 d3                	cmp    %edx,%ebx
80104bd0:	73 26                	jae    80104bf8 <argstr+0x68>
80104bd2:	89 d8                	mov    %ebx,%eax
80104bd4:	eb 11                	jmp    80104be7 <argstr+0x57>
80104bd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bdd:	00 
80104bde:	66 90                	xchg   %ax,%ax
80104be0:	83 c0 01             	add    $0x1,%eax
80104be3:	39 d0                	cmp    %edx,%eax
80104be5:	73 11                	jae    80104bf8 <argstr+0x68>
    if(*s == 0)
80104be7:	80 38 00             	cmpb   $0x0,(%eax)
80104bea:	75 f4                	jne    80104be0 <argstr+0x50>
      return s - *pp;
80104bec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104bee:	5b                   	pop    %ebx
80104bef:	5e                   	pop    %esi
80104bf0:	5d                   	pop    %ebp
80104bf1:	c3                   	ret
80104bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf8:	5b                   	pop    %ebx
    return -1;
80104bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bfe:	5e                   	pop    %esi
80104bff:	5d                   	pop    %ebp
80104c00:	c3                   	ret
80104c01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c08:	00 
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c10 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c17:	e8 c4 ee ff ff       	call   80103ae0 <myproc>
80104c1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c1e:	8b 40 18             	mov    0x18(%eax),%eax
80104c21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c27:	83 fa 14             	cmp    $0x14,%edx
80104c2a:	77 24                	ja     80104c50 <syscall+0x40>
80104c2c:	8b 14 85 80 7c 10 80 	mov    -0x7fef8380(,%eax,4),%edx
80104c33:	85 d2                	test   %edx,%edx
80104c35:	74 19                	je     80104c50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c37:	ff d2                	call   *%edx
80104c39:	89 c2                	mov    %eax,%edx
80104c3b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c3e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c44:	c9                   	leave
80104c45:	c3                   	ret
80104c46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c4d:	00 
80104c4e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104c50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c51:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c54:	50                   	push   %eax
80104c55:	ff 73 10             	push   0x10(%ebx)
80104c58:	68 9a 76 10 80       	push   $0x8010769a
80104c5d:	e8 4e ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104c62:	8b 43 18             	mov    0x18(%ebx),%eax
80104c65:	83 c4 10             	add    $0x10,%esp
80104c68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c72:	c9                   	leave
80104c73:	c3                   	ret
80104c74:	66 90                	xchg   %ax,%ax
80104c76:	66 90                	xchg   %ax,%ax
80104c78:	66 90                	xchg   %ax,%ax
80104c7a:	66 90                	xchg   %ax,%ax
80104c7c:	66 90                	xchg   %ax,%ax
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c88:	53                   	push   %ebx
80104c89:	83 ec 34             	sub    $0x34,%esp
80104c8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c92:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c95:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c98:	57                   	push   %edi
80104c99:	50                   	push   %eax
80104c9a:	e8 81 d5 ff ff       	call   80102220 <nameiparent>
80104c9f:	83 c4 10             	add    $0x10,%esp
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	74 5e                	je     80104d04 <create+0x84>
    return 0;
  ilock(dp);
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	89 c3                	mov    %eax,%ebx
80104cab:	50                   	push   %eax
80104cac:	e8 6f cc ff ff       	call   80101920 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cb1:	83 c4 0c             	add    $0xc,%esp
80104cb4:	6a 00                	push   $0x0
80104cb6:	57                   	push   %edi
80104cb7:	53                   	push   %ebx
80104cb8:	e8 b3 d1 ff ff       	call   80101e70 <dirlookup>
80104cbd:	83 c4 10             	add    $0x10,%esp
80104cc0:	89 c6                	mov    %eax,%esi
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	74 4a                	je     80104d10 <create+0x90>
    iunlockput(dp);
80104cc6:	83 ec 0c             	sub    $0xc,%esp
80104cc9:	53                   	push   %ebx
80104cca:	e8 e1 ce ff ff       	call   80101bb0 <iunlockput>
    ilock(ip);
80104ccf:	89 34 24             	mov    %esi,(%esp)
80104cd2:	e8 49 cc ff ff       	call   80101920 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104cdf:	75 17                	jne    80104cf8 <create+0x78>
80104ce1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104ce6:	75 10                	jne    80104cf8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ceb:	89 f0                	mov    %esi,%eax
80104ced:	5b                   	pop    %ebx
80104cee:	5e                   	pop    %esi
80104cef:	5f                   	pop    %edi
80104cf0:	5d                   	pop    %ebp
80104cf1:	c3                   	ret
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	56                   	push   %esi
80104cfc:	e8 af ce ff ff       	call   80101bb0 <iunlockput>
    return 0;
80104d01:	83 c4 10             	add    $0x10,%esp
}
80104d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d07:	31 f6                	xor    %esi,%esi
}
80104d09:	5b                   	pop    %ebx
80104d0a:	89 f0                	mov    %esi,%eax
80104d0c:	5e                   	pop    %esi
80104d0d:	5f                   	pop    %edi
80104d0e:	5d                   	pop    %ebp
80104d0f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104d10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d14:	83 ec 08             	sub    $0x8,%esp
80104d17:	50                   	push   %eax
80104d18:	ff 33                	push   (%ebx)
80104d1a:	e8 91 ca ff ff       	call   801017b0 <ialloc>
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	89 c6                	mov    %eax,%esi
80104d24:	85 c0                	test   %eax,%eax
80104d26:	0f 84 bc 00 00 00    	je     80104de8 <create+0x168>
  ilock(ip);
80104d2c:	83 ec 0c             	sub    $0xc,%esp
80104d2f:	50                   	push   %eax
80104d30:	e8 eb cb ff ff       	call   80101920 <ilock>
  ip->major = major;
80104d35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d39:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d41:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d45:	b8 01 00 00 00       	mov    $0x1,%eax
80104d4a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d4e:	89 34 24             	mov    %esi,(%esp)
80104d51:	e8 1a cb ff ff       	call   80101870 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d5e:	74 30                	je     80104d90 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104d60:	83 ec 04             	sub    $0x4,%esp
80104d63:	ff 76 04             	push   0x4(%esi)
80104d66:	57                   	push   %edi
80104d67:	53                   	push   %ebx
80104d68:	e8 d3 d3 ff ff       	call   80102140 <dirlink>
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	85 c0                	test   %eax,%eax
80104d72:	78 67                	js     80104ddb <create+0x15b>
  iunlockput(dp);
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	53                   	push   %ebx
80104d78:	e8 33 ce ff ff       	call   80101bb0 <iunlockput>
  return ip;
80104d7d:	83 c4 10             	add    $0x10,%esp
}
80104d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d83:	89 f0                	mov    %esi,%eax
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5f                   	pop    %edi
80104d88:	5d                   	pop    %ebp
80104d89:	c3                   	ret
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d93:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d98:	53                   	push   %ebx
80104d99:	e8 d2 ca ff ff       	call   80101870 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d9e:	83 c4 0c             	add    $0xc,%esp
80104da1:	ff 76 04             	push   0x4(%esi)
80104da4:	68 d2 76 10 80       	push   $0x801076d2
80104da9:	56                   	push   %esi
80104daa:	e8 91 d3 ff ff       	call   80102140 <dirlink>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	85 c0                	test   %eax,%eax
80104db4:	78 18                	js     80104dce <create+0x14e>
80104db6:	83 ec 04             	sub    $0x4,%esp
80104db9:	ff 73 04             	push   0x4(%ebx)
80104dbc:	68 d1 76 10 80       	push   $0x801076d1
80104dc1:	56                   	push   %esi
80104dc2:	e8 79 d3 ff ff       	call   80102140 <dirlink>
80104dc7:	83 c4 10             	add    $0x10,%esp
80104dca:	85 c0                	test   %eax,%eax
80104dcc:	79 92                	jns    80104d60 <create+0xe0>
      panic("create dots");
80104dce:	83 ec 0c             	sub    $0xc,%esp
80104dd1:	68 c5 76 10 80       	push   $0x801076c5
80104dd6:	e8 a5 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104ddb:	83 ec 0c             	sub    $0xc,%esp
80104dde:	68 d4 76 10 80       	push   $0x801076d4
80104de3:	e8 98 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104de8:	83 ec 0c             	sub    $0xc,%esp
80104deb:	68 b6 76 10 80       	push   $0x801076b6
80104df0:	e8 8b b5 ff ff       	call   80100380 <panic>
80104df5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dfc:	00 
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi

80104e00 <sys_dup>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e0b:	50                   	push   %eax
80104e0c:	6a 00                	push   $0x0
80104e0e:	e8 bd fc ff ff       	call   80104ad0 <argint>
80104e13:	83 c4 10             	add    $0x10,%esp
80104e16:	85 c0                	test   %eax,%eax
80104e18:	78 36                	js     80104e50 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e1e:	77 30                	ja     80104e50 <sys_dup+0x50>
80104e20:	e8 bb ec ff ff       	call   80103ae0 <myproc>
80104e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e2c:	85 f6                	test   %esi,%esi
80104e2e:	74 20                	je     80104e50 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e30:	e8 ab ec ff ff       	call   80103ae0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e35:	31 db                	xor    %ebx,%ebx
80104e37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e3e:	00 
80104e3f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104e40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e44:	85 d2                	test   %edx,%edx
80104e46:	74 18                	je     80104e60 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e48:	83 c3 01             	add    $0x1,%ebx
80104e4b:	83 fb 10             	cmp    $0x10,%ebx
80104e4e:	75 f0                	jne    80104e40 <sys_dup+0x40>
}
80104e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e58:	89 d8                	mov    %ebx,%eax
80104e5a:	5b                   	pop    %ebx
80104e5b:	5e                   	pop    %esi
80104e5c:	5d                   	pop    %ebp
80104e5d:	c3                   	ret
80104e5e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e60:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e63:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e67:	56                   	push   %esi
80104e68:	e8 d3 c1 ff ff       	call   80101040 <filedup>
  return fd;
80104e6d:	83 c4 10             	add    $0x10,%esp
}
80104e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e73:	89 d8                	mov    %ebx,%eax
80104e75:	5b                   	pop    %ebx
80104e76:	5e                   	pop    %esi
80104e77:	5d                   	pop    %ebp
80104e78:	c3                   	ret
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e80 <sys_read>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e8b:	53                   	push   %ebx
80104e8c:	6a 00                	push   $0x0
80104e8e:	e8 3d fc ff ff       	call   80104ad0 <argint>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 5e                	js     80104ef8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e9e:	77 58                	ja     80104ef8 <sys_read+0x78>
80104ea0:	e8 3b ec ff ff       	call   80103ae0 <myproc>
80104ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ea8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eac:	85 f6                	test   %esi,%esi
80104eae:	74 48                	je     80104ef8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eb0:	83 ec 08             	sub    $0x8,%esp
80104eb3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104eb6:	50                   	push   %eax
80104eb7:	6a 02                	push   $0x2
80104eb9:	e8 12 fc ff ff       	call   80104ad0 <argint>
80104ebe:	83 c4 10             	add    $0x10,%esp
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	78 33                	js     80104ef8 <sys_read+0x78>
80104ec5:	83 ec 04             	sub    $0x4,%esp
80104ec8:	ff 75 f0             	push   -0x10(%ebp)
80104ecb:	53                   	push   %ebx
80104ecc:	6a 01                	push   $0x1
80104ece:	e8 4d fc ff ff       	call   80104b20 <argptr>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 1e                	js     80104ef8 <sys_read+0x78>
  return fileread(f, p, n);
80104eda:	83 ec 04             	sub    $0x4,%esp
80104edd:	ff 75 f0             	push   -0x10(%ebp)
80104ee0:	ff 75 f4             	push   -0xc(%ebp)
80104ee3:	56                   	push   %esi
80104ee4:	e8 d7 c2 ff ff       	call   801011c0 <fileread>
80104ee9:	83 c4 10             	add    $0x10,%esp
}
80104eec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eef:	5b                   	pop    %ebx
80104ef0:	5e                   	pop    %esi
80104ef1:	5d                   	pop    %ebp
80104ef2:	c3                   	ret
80104ef3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104efd:	eb ed                	jmp    80104eec <sys_read+0x6c>
80104eff:	90                   	nop

80104f00 <sys_write>:
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f0b:	53                   	push   %ebx
80104f0c:	6a 00                	push   $0x0
80104f0e:	e8 bd fb ff ff       	call   80104ad0 <argint>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	78 5e                	js     80104f78 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f1e:	77 58                	ja     80104f78 <sys_write+0x78>
80104f20:	e8 bb eb ff ff       	call   80103ae0 <myproc>
80104f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f2c:	85 f6                	test   %esi,%esi
80104f2e:	74 48                	je     80104f78 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f30:	83 ec 08             	sub    $0x8,%esp
80104f33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f36:	50                   	push   %eax
80104f37:	6a 02                	push   $0x2
80104f39:	e8 92 fb ff ff       	call   80104ad0 <argint>
80104f3e:	83 c4 10             	add    $0x10,%esp
80104f41:	85 c0                	test   %eax,%eax
80104f43:	78 33                	js     80104f78 <sys_write+0x78>
80104f45:	83 ec 04             	sub    $0x4,%esp
80104f48:	ff 75 f0             	push   -0x10(%ebp)
80104f4b:	53                   	push   %ebx
80104f4c:	6a 01                	push   $0x1
80104f4e:	e8 cd fb ff ff       	call   80104b20 <argptr>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 1e                	js     80104f78 <sys_write+0x78>
  return filewrite(f, p, n);
80104f5a:	83 ec 04             	sub    $0x4,%esp
80104f5d:	ff 75 f0             	push   -0x10(%ebp)
80104f60:	ff 75 f4             	push   -0xc(%ebp)
80104f63:	56                   	push   %esi
80104f64:	e8 e7 c2 ff ff       	call   80101250 <filewrite>
80104f69:	83 c4 10             	add    $0x10,%esp
}
80104f6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6f:	5b                   	pop    %ebx
80104f70:	5e                   	pop    %esi
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret
80104f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7d:	eb ed                	jmp    80104f6c <sys_write+0x6c>
80104f7f:	90                   	nop

80104f80 <sys_close>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f8b:	50                   	push   %eax
80104f8c:	6a 00                	push   $0x0
80104f8e:	e8 3d fb ff ff       	call   80104ad0 <argint>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	78 3e                	js     80104fd8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f9e:	77 38                	ja     80104fd8 <sys_close+0x58>
80104fa0:	e8 3b eb ff ff       	call   80103ae0 <myproc>
80104fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fa8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104fab:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104faf:	85 f6                	test   %esi,%esi
80104fb1:	74 25                	je     80104fd8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104fb3:	e8 28 eb ff ff       	call   80103ae0 <myproc>
  fileclose(f);
80104fb8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104fbb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104fc2:	00 
  fileclose(f);
80104fc3:	56                   	push   %esi
80104fc4:	e8 c7 c0 ff ff       	call   80101090 <fileclose>
  return 0;
80104fc9:	83 c4 10             	add    $0x10,%esp
80104fcc:	31 c0                	xor    %eax,%eax
}
80104fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd1:	5b                   	pop    %ebx
80104fd2:	5e                   	pop    %esi
80104fd3:	5d                   	pop    %ebp
80104fd4:	c3                   	ret
80104fd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ef                	jmp    80104fce <sys_close+0x4e>
80104fdf:	90                   	nop

80104fe0 <sys_fstat>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	53                   	push   %ebx
80104fec:	6a 00                	push   $0x0
80104fee:	e8 dd fa ff ff       	call   80104ad0 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 46                	js     80105040 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 40                	ja     80105040 <sys_fstat+0x60>
80105000:	e8 db ea ff ff       	call   80103ae0 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010500c:	85 f6                	test   %esi,%esi
8010500e:	74 30                	je     80105040 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105010:	83 ec 04             	sub    $0x4,%esp
80105013:	6a 14                	push   $0x14
80105015:	53                   	push   %ebx
80105016:	6a 01                	push   $0x1
80105018:	e8 03 fb ff ff       	call   80104b20 <argptr>
8010501d:	83 c4 10             	add    $0x10,%esp
80105020:	85 c0                	test   %eax,%eax
80105022:	78 1c                	js     80105040 <sys_fstat+0x60>
  return filestat(f, st);
80105024:	83 ec 08             	sub    $0x8,%esp
80105027:	ff 75 f4             	push   -0xc(%ebp)
8010502a:	56                   	push   %esi
8010502b:	e8 40 c1 ff ff       	call   80101170 <filestat>
80105030:	83 c4 10             	add    $0x10,%esp
}
80105033:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105036:	5b                   	pop    %ebx
80105037:	5e                   	pop    %esi
80105038:	5d                   	pop    %ebp
80105039:	c3                   	ret
8010503a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105045:	eb ec                	jmp    80105033 <sys_fstat+0x53>
80105047:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010504e:	00 
8010504f:	90                   	nop

80105050 <sys_link>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	57                   	push   %edi
80105054:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105055:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105058:	53                   	push   %ebx
80105059:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010505c:	50                   	push   %eax
8010505d:	6a 00                	push   $0x0
8010505f:	e8 2c fb ff ff       	call   80104b90 <argstr>
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	85 c0                	test   %eax,%eax
80105069:	0f 88 fb 00 00 00    	js     8010516a <sys_link+0x11a>
8010506f:	83 ec 08             	sub    $0x8,%esp
80105072:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105075:	50                   	push   %eax
80105076:	6a 01                	push   $0x1
80105078:	e8 13 fb ff ff       	call   80104b90 <argstr>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	0f 88 e2 00 00 00    	js     8010516a <sys_link+0x11a>
  begin_op();
80105088:	e8 33 de ff ff       	call   80102ec0 <begin_op>
  if((ip = namei(old)) == 0){
8010508d:	83 ec 0c             	sub    $0xc,%esp
80105090:	ff 75 d4             	push   -0x2c(%ebp)
80105093:	e8 68 d1 ff ff       	call   80102200 <namei>
80105098:	83 c4 10             	add    $0x10,%esp
8010509b:	89 c3                	mov    %eax,%ebx
8010509d:	85 c0                	test   %eax,%eax
8010509f:	0f 84 df 00 00 00    	je     80105184 <sys_link+0x134>
  ilock(ip);
801050a5:	83 ec 0c             	sub    $0xc,%esp
801050a8:	50                   	push   %eax
801050a9:	e8 72 c8 ff ff       	call   80101920 <ilock>
  if(ip->type == T_DIR){
801050ae:	83 c4 10             	add    $0x10,%esp
801050b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050b6:	0f 84 b5 00 00 00    	je     80105171 <sys_link+0x121>
  iupdate(ip);
801050bc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801050bf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801050c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050c7:	53                   	push   %ebx
801050c8:	e8 a3 c7 ff ff       	call   80101870 <iupdate>
  iunlock(ip);
801050cd:	89 1c 24             	mov    %ebx,(%esp)
801050d0:	e8 2b c9 ff ff       	call   80101a00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050d5:	58                   	pop    %eax
801050d6:	5a                   	pop    %edx
801050d7:	57                   	push   %edi
801050d8:	ff 75 d0             	push   -0x30(%ebp)
801050db:	e8 40 d1 ff ff       	call   80102220 <nameiparent>
801050e0:	83 c4 10             	add    $0x10,%esp
801050e3:	89 c6                	mov    %eax,%esi
801050e5:	85 c0                	test   %eax,%eax
801050e7:	74 5b                	je     80105144 <sys_link+0xf4>
  ilock(dp);
801050e9:	83 ec 0c             	sub    $0xc,%esp
801050ec:	50                   	push   %eax
801050ed:	e8 2e c8 ff ff       	call   80101920 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050f2:	8b 03                	mov    (%ebx),%eax
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	39 06                	cmp    %eax,(%esi)
801050f9:	75 3d                	jne    80105138 <sys_link+0xe8>
801050fb:	83 ec 04             	sub    $0x4,%esp
801050fe:	ff 73 04             	push   0x4(%ebx)
80105101:	57                   	push   %edi
80105102:	56                   	push   %esi
80105103:	e8 38 d0 ff ff       	call   80102140 <dirlink>
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	85 c0                	test   %eax,%eax
8010510d:	78 29                	js     80105138 <sys_link+0xe8>
  iunlockput(dp);
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	56                   	push   %esi
80105113:	e8 98 ca ff ff       	call   80101bb0 <iunlockput>
  iput(ip);
80105118:	89 1c 24             	mov    %ebx,(%esp)
8010511b:	e8 30 c9 ff ff       	call   80101a50 <iput>
  end_op();
80105120:	e8 0b de ff ff       	call   80102f30 <end_op>
  return 0;
80105125:	83 c4 10             	add    $0x10,%esp
80105128:	31 c0                	xor    %eax,%eax
}
8010512a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010512d:	5b                   	pop    %ebx
8010512e:	5e                   	pop    %esi
8010512f:	5f                   	pop    %edi
80105130:	5d                   	pop    %ebp
80105131:	c3                   	ret
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	56                   	push   %esi
8010513c:	e8 6f ca ff ff       	call   80101bb0 <iunlockput>
    goto bad;
80105141:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	53                   	push   %ebx
80105148:	e8 d3 c7 ff ff       	call   80101920 <ilock>
  ip->nlink--;
8010514d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105152:	89 1c 24             	mov    %ebx,(%esp)
80105155:	e8 16 c7 ff ff       	call   80101870 <iupdate>
  iunlockput(ip);
8010515a:	89 1c 24             	mov    %ebx,(%esp)
8010515d:	e8 4e ca ff ff       	call   80101bb0 <iunlockput>
  end_op();
80105162:	e8 c9 dd ff ff       	call   80102f30 <end_op>
  return -1;
80105167:	83 c4 10             	add    $0x10,%esp
    return -1;
8010516a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516f:	eb b9                	jmp    8010512a <sys_link+0xda>
    iunlockput(ip);
80105171:	83 ec 0c             	sub    $0xc,%esp
80105174:	53                   	push   %ebx
80105175:	e8 36 ca ff ff       	call   80101bb0 <iunlockput>
    end_op();
8010517a:	e8 b1 dd ff ff       	call   80102f30 <end_op>
    return -1;
8010517f:	83 c4 10             	add    $0x10,%esp
80105182:	eb e6                	jmp    8010516a <sys_link+0x11a>
    end_op();
80105184:	e8 a7 dd ff ff       	call   80102f30 <end_op>
    return -1;
80105189:	eb df                	jmp    8010516a <sys_link+0x11a>
8010518b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105190 <sys_unlink>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105195:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105198:	53                   	push   %ebx
80105199:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010519c:	50                   	push   %eax
8010519d:	6a 00                	push   $0x0
8010519f:	e8 ec f9 ff ff       	call   80104b90 <argstr>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	0f 88 54 01 00 00    	js     80105303 <sys_unlink+0x173>
  begin_op();
801051af:	e8 0c dd ff ff       	call   80102ec0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051b4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801051b7:	83 ec 08             	sub    $0x8,%esp
801051ba:	53                   	push   %ebx
801051bb:	ff 75 c0             	push   -0x40(%ebp)
801051be:	e8 5d d0 ff ff       	call   80102220 <nameiparent>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801051c9:	85 c0                	test   %eax,%eax
801051cb:	0f 84 58 01 00 00    	je     80105329 <sys_unlink+0x199>
  ilock(dp);
801051d1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801051d4:	83 ec 0c             	sub    $0xc,%esp
801051d7:	57                   	push   %edi
801051d8:	e8 43 c7 ff ff       	call   80101920 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051dd:	58                   	pop    %eax
801051de:	5a                   	pop    %edx
801051df:	68 d2 76 10 80       	push   $0x801076d2
801051e4:	53                   	push   %ebx
801051e5:	e8 66 cc ff ff       	call   80101e50 <namecmp>
801051ea:	83 c4 10             	add    $0x10,%esp
801051ed:	85 c0                	test   %eax,%eax
801051ef:	0f 84 fb 00 00 00    	je     801052f0 <sys_unlink+0x160>
801051f5:	83 ec 08             	sub    $0x8,%esp
801051f8:	68 d1 76 10 80       	push   $0x801076d1
801051fd:	53                   	push   %ebx
801051fe:	e8 4d cc ff ff       	call   80101e50 <namecmp>
80105203:	83 c4 10             	add    $0x10,%esp
80105206:	85 c0                	test   %eax,%eax
80105208:	0f 84 e2 00 00 00    	je     801052f0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010520e:	83 ec 04             	sub    $0x4,%esp
80105211:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105214:	50                   	push   %eax
80105215:	53                   	push   %ebx
80105216:	57                   	push   %edi
80105217:	e8 54 cc ff ff       	call   80101e70 <dirlookup>
8010521c:	83 c4 10             	add    $0x10,%esp
8010521f:	89 c3                	mov    %eax,%ebx
80105221:	85 c0                	test   %eax,%eax
80105223:	0f 84 c7 00 00 00    	je     801052f0 <sys_unlink+0x160>
  ilock(ip);
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	50                   	push   %eax
8010522d:	e8 ee c6 ff ff       	call   80101920 <ilock>
  if(ip->nlink < 1)
80105232:	83 c4 10             	add    $0x10,%esp
80105235:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010523a:	0f 8e 0a 01 00 00    	jle    8010534a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105240:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105245:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105248:	74 66                	je     801052b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010524a:	83 ec 04             	sub    $0x4,%esp
8010524d:	6a 10                	push   $0x10
8010524f:	6a 00                	push   $0x0
80105251:	57                   	push   %edi
80105252:	e8 c9 f5 ff ff       	call   80104820 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105257:	6a 10                	push   $0x10
80105259:	ff 75 c4             	push   -0x3c(%ebp)
8010525c:	57                   	push   %edi
8010525d:	ff 75 b4             	push   -0x4c(%ebp)
80105260:	e8 cb ca ff ff       	call   80101d30 <writei>
80105265:	83 c4 20             	add    $0x20,%esp
80105268:	83 f8 10             	cmp    $0x10,%eax
8010526b:	0f 85 cc 00 00 00    	jne    8010533d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105271:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105276:	0f 84 94 00 00 00    	je     80105310 <sys_unlink+0x180>
  iunlockput(dp);
8010527c:	83 ec 0c             	sub    $0xc,%esp
8010527f:	ff 75 b4             	push   -0x4c(%ebp)
80105282:	e8 29 c9 ff ff       	call   80101bb0 <iunlockput>
  ip->nlink--;
80105287:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010528c:	89 1c 24             	mov    %ebx,(%esp)
8010528f:	e8 dc c5 ff ff       	call   80101870 <iupdate>
  iunlockput(ip);
80105294:	89 1c 24             	mov    %ebx,(%esp)
80105297:	e8 14 c9 ff ff       	call   80101bb0 <iunlockput>
  end_op();
8010529c:	e8 8f dc ff ff       	call   80102f30 <end_op>
  return 0;
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	31 c0                	xor    %eax,%eax
}
801052a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a9:	5b                   	pop    %ebx
801052aa:	5e                   	pop    %esi
801052ab:	5f                   	pop    %edi
801052ac:	5d                   	pop    %ebp
801052ad:	c3                   	ret
801052ae:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052b4:	76 94                	jbe    8010524a <sys_unlink+0xba>
801052b6:	be 20 00 00 00       	mov    $0x20,%esi
801052bb:	eb 0b                	jmp    801052c8 <sys_unlink+0x138>
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
801052c0:	83 c6 10             	add    $0x10,%esi
801052c3:	3b 73 58             	cmp    0x58(%ebx),%esi
801052c6:	73 82                	jae    8010524a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052c8:	6a 10                	push   $0x10
801052ca:	56                   	push   %esi
801052cb:	57                   	push   %edi
801052cc:	53                   	push   %ebx
801052cd:	e8 5e c9 ff ff       	call   80101c30 <readi>
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	83 f8 10             	cmp    $0x10,%eax
801052d8:	75 56                	jne    80105330 <sys_unlink+0x1a0>
    if(de.inum != 0)
801052da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052df:	74 df                	je     801052c0 <sys_unlink+0x130>
    iunlockput(ip);
801052e1:	83 ec 0c             	sub    $0xc,%esp
801052e4:	53                   	push   %ebx
801052e5:	e8 c6 c8 ff ff       	call   80101bb0 <iunlockput>
    goto bad;
801052ea:	83 c4 10             	add    $0x10,%esp
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	ff 75 b4             	push   -0x4c(%ebp)
801052f6:	e8 b5 c8 ff ff       	call   80101bb0 <iunlockput>
  end_op();
801052fb:	e8 30 dc ff ff       	call   80102f30 <end_op>
  return -1;
80105300:	83 c4 10             	add    $0x10,%esp
    return -1;
80105303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105308:	eb 9c                	jmp    801052a6 <sys_unlink+0x116>
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105310:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105313:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105316:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010531b:	50                   	push   %eax
8010531c:	e8 4f c5 ff ff       	call   80101870 <iupdate>
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	e9 53 ff ff ff       	jmp    8010527c <sys_unlink+0xec>
    end_op();
80105329:	e8 02 dc ff ff       	call   80102f30 <end_op>
    return -1;
8010532e:	eb d3                	jmp    80105303 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	68 f6 76 10 80       	push   $0x801076f6
80105338:	e8 43 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010533d:	83 ec 0c             	sub    $0xc,%esp
80105340:	68 08 77 10 80       	push   $0x80107708
80105345:	e8 36 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010534a:	83 ec 0c             	sub    $0xc,%esp
8010534d:	68 e4 76 10 80       	push   $0x801076e4
80105352:	e8 29 b0 ff ff       	call   80100380 <panic>
80105357:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010535e:	00 
8010535f:	90                   	nop

80105360 <sys_open>:

int
sys_open(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105365:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105368:	53                   	push   %ebx
80105369:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010536c:	50                   	push   %eax
8010536d:	6a 00                	push   $0x0
8010536f:	e8 1c f8 ff ff       	call   80104b90 <argstr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	0f 88 8e 00 00 00    	js     8010540d <sys_open+0xad>
8010537f:	83 ec 08             	sub    $0x8,%esp
80105382:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105385:	50                   	push   %eax
80105386:	6a 01                	push   $0x1
80105388:	e8 43 f7 ff ff       	call   80104ad0 <argint>
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	85 c0                	test   %eax,%eax
80105392:	78 79                	js     8010540d <sys_open+0xad>
    return -1;

  begin_op();
80105394:	e8 27 db ff ff       	call   80102ec0 <begin_op>

  if(omode & O_CREATE){
80105399:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010539d:	75 79                	jne    80105418 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	ff 75 e0             	push   -0x20(%ebp)
801053a5:	e8 56 ce ff ff       	call   80102200 <namei>
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	89 c6                	mov    %eax,%esi
801053af:	85 c0                	test   %eax,%eax
801053b1:	0f 84 7e 00 00 00    	je     80105435 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801053b7:	83 ec 0c             	sub    $0xc,%esp
801053ba:	50                   	push   %eax
801053bb:	e8 60 c5 ff ff       	call   80101920 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801053c0:	83 c4 10             	add    $0x10,%esp
801053c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801053c8:	0f 84 ba 00 00 00    	je     80105488 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053ce:	e8 fd bb ff ff       	call   80100fd0 <filealloc>
801053d3:	89 c7                	mov    %eax,%edi
801053d5:	85 c0                	test   %eax,%eax
801053d7:	74 23                	je     801053fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801053d9:	e8 02 e7 ff ff       	call   80103ae0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801053e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053e4:	85 d2                	test   %edx,%edx
801053e6:	74 58                	je     80105440 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801053e8:	83 c3 01             	add    $0x1,%ebx
801053eb:	83 fb 10             	cmp    $0x10,%ebx
801053ee:	75 f0                	jne    801053e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	57                   	push   %edi
801053f4:	e8 97 bc ff ff       	call   80101090 <fileclose>
801053f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	56                   	push   %esi
80105400:	e8 ab c7 ff ff       	call   80101bb0 <iunlockput>
    end_op();
80105405:	e8 26 db ff ff       	call   80102f30 <end_op>
    return -1;
8010540a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010540d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105412:	eb 65                	jmp    80105479 <sys_open+0x119>
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	31 c9                	xor    %ecx,%ecx
8010541d:	ba 02 00 00 00       	mov    $0x2,%edx
80105422:	6a 00                	push   $0x0
80105424:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105427:	e8 54 f8 ff ff       	call   80104c80 <create>
    if(ip == 0){
8010542c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010542f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105431:	85 c0                	test   %eax,%eax
80105433:	75 99                	jne    801053ce <sys_open+0x6e>
      end_op();
80105435:	e8 f6 da ff ff       	call   80102f30 <end_op>
      return -1;
8010543a:	eb d1                	jmp    8010540d <sys_open+0xad>
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105440:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105443:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105447:	56                   	push   %esi
80105448:	e8 b3 c5 ff ff       	call   80101a00 <iunlock>
  end_op();
8010544d:	e8 de da ff ff       	call   80102f30 <end_op>

  f->type = FD_INODE;
80105452:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105458:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010545b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010545e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105461:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105463:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010546a:	f7 d0                	not    %eax
8010546c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010546f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105472:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105475:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105479:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010547c:	89 d8                	mov    %ebx,%eax
8010547e:	5b                   	pop    %ebx
8010547f:	5e                   	pop    %esi
80105480:	5f                   	pop    %edi
80105481:	5d                   	pop    %ebp
80105482:	c3                   	ret
80105483:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105488:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010548b:	85 c9                	test   %ecx,%ecx
8010548d:	0f 84 3b ff ff ff    	je     801053ce <sys_open+0x6e>
80105493:	e9 64 ff ff ff       	jmp    801053fc <sys_open+0x9c>
80105498:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010549f:	00 

801054a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054a6:	e8 15 da ff ff       	call   80102ec0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054ab:	83 ec 08             	sub    $0x8,%esp
801054ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b1:	50                   	push   %eax
801054b2:	6a 00                	push   $0x0
801054b4:	e8 d7 f6 ff ff       	call   80104b90 <argstr>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	85 c0                	test   %eax,%eax
801054be:	78 30                	js     801054f0 <sys_mkdir+0x50>
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c6:	31 c9                	xor    %ecx,%ecx
801054c8:	ba 01 00 00 00       	mov    $0x1,%edx
801054cd:	6a 00                	push   $0x0
801054cf:	e8 ac f7 ff ff       	call   80104c80 <create>
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	85 c0                	test   %eax,%eax
801054d9:	74 15                	je     801054f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054db:	83 ec 0c             	sub    $0xc,%esp
801054de:	50                   	push   %eax
801054df:	e8 cc c6 ff ff       	call   80101bb0 <iunlockput>
  end_op();
801054e4:	e8 47 da ff ff       	call   80102f30 <end_op>
  return 0;
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	31 c0                	xor    %eax,%eax
}
801054ee:	c9                   	leave
801054ef:	c3                   	ret
    end_op();
801054f0:	e8 3b da ff ff       	call   80102f30 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fa:	c9                   	leave
801054fb:	c3                   	ret
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_mknod>:

int
sys_mknod(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105506:	e8 b5 d9 ff ff       	call   80102ec0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010550b:	83 ec 08             	sub    $0x8,%esp
8010550e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105511:	50                   	push   %eax
80105512:	6a 00                	push   $0x0
80105514:	e8 77 f6 ff ff       	call   80104b90 <argstr>
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	85 c0                	test   %eax,%eax
8010551e:	78 60                	js     80105580 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105520:	83 ec 08             	sub    $0x8,%esp
80105523:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105526:	50                   	push   %eax
80105527:	6a 01                	push   $0x1
80105529:	e8 a2 f5 ff ff       	call   80104ad0 <argint>
  if((argstr(0, &path)) < 0 ||
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	85 c0                	test   %eax,%eax
80105533:	78 4b                	js     80105580 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105535:	83 ec 08             	sub    $0x8,%esp
80105538:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553b:	50                   	push   %eax
8010553c:	6a 02                	push   $0x2
8010553e:	e8 8d f5 ff ff       	call   80104ad0 <argint>
     argint(1, &major) < 0 ||
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	78 36                	js     80105580 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010554a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010554e:	83 ec 0c             	sub    $0xc,%esp
80105551:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105555:	ba 03 00 00 00       	mov    $0x3,%edx
8010555a:	50                   	push   %eax
8010555b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010555e:	e8 1d f7 ff ff       	call   80104c80 <create>
     argint(2, &minor) < 0 ||
80105563:	83 c4 10             	add    $0x10,%esp
80105566:	85 c0                	test   %eax,%eax
80105568:	74 16                	je     80105580 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010556a:	83 ec 0c             	sub    $0xc,%esp
8010556d:	50                   	push   %eax
8010556e:	e8 3d c6 ff ff       	call   80101bb0 <iunlockput>
  end_op();
80105573:	e8 b8 d9 ff ff       	call   80102f30 <end_op>
  return 0;
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	31 c0                	xor    %eax,%eax
}
8010557d:	c9                   	leave
8010557e:	c3                   	ret
8010557f:	90                   	nop
    end_op();
80105580:	e8 ab d9 ff ff       	call   80102f30 <end_op>
    return -1;
80105585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010558a:	c9                   	leave
8010558b:	c3                   	ret
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_chdir>:

int
sys_chdir(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
80105595:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105598:	e8 43 e5 ff ff       	call   80103ae0 <myproc>
8010559d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010559f:	e8 1c d9 ff ff       	call   80102ec0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055a4:	83 ec 08             	sub    $0x8,%esp
801055a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055aa:	50                   	push   %eax
801055ab:	6a 00                	push   $0x0
801055ad:	e8 de f5 ff ff       	call   80104b90 <argstr>
801055b2:	83 c4 10             	add    $0x10,%esp
801055b5:	85 c0                	test   %eax,%eax
801055b7:	78 77                	js     80105630 <sys_chdir+0xa0>
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	ff 75 f4             	push   -0xc(%ebp)
801055bf:	e8 3c cc ff ff       	call   80102200 <namei>
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	89 c3                	mov    %eax,%ebx
801055c9:	85 c0                	test   %eax,%eax
801055cb:	74 63                	je     80105630 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055cd:	83 ec 0c             	sub    $0xc,%esp
801055d0:	50                   	push   %eax
801055d1:	e8 4a c3 ff ff       	call   80101920 <ilock>
  if(ip->type != T_DIR){
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055de:	75 30                	jne    80105610 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	53                   	push   %ebx
801055e4:	e8 17 c4 ff ff       	call   80101a00 <iunlock>
  iput(curproc->cwd);
801055e9:	58                   	pop    %eax
801055ea:	ff 76 68             	push   0x68(%esi)
801055ed:	e8 5e c4 ff ff       	call   80101a50 <iput>
  end_op();
801055f2:	e8 39 d9 ff ff       	call   80102f30 <end_op>
  curproc->cwd = ip;
801055f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	31 c0                	xor    %eax,%eax
}
801055ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105602:	5b                   	pop    %ebx
80105603:	5e                   	pop    %esi
80105604:	5d                   	pop    %ebp
80105605:	c3                   	ret
80105606:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010560d:	00 
8010560e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	53                   	push   %ebx
80105614:	e8 97 c5 ff ff       	call   80101bb0 <iunlockput>
    end_op();
80105619:	e8 12 d9 ff ff       	call   80102f30 <end_op>
    return -1;
8010561e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105626:	eb d7                	jmp    801055ff <sys_chdir+0x6f>
80105628:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010562f:	00 
    end_op();
80105630:	e8 fb d8 ff ff       	call   80102f30 <end_op>
    return -1;
80105635:	eb ea                	jmp    80105621 <sys_chdir+0x91>
80105637:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010563e:	00 
8010563f:	90                   	nop

80105640 <sys_exec>:

int
sys_exec(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105645:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010564b:	53                   	push   %ebx
8010564c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105652:	50                   	push   %eax
80105653:	6a 00                	push   $0x0
80105655:	e8 36 f5 ff ff       	call   80104b90 <argstr>
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	85 c0                	test   %eax,%eax
8010565f:	0f 88 87 00 00 00    	js     801056ec <sys_exec+0xac>
80105665:	83 ec 08             	sub    $0x8,%esp
80105668:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010566e:	50                   	push   %eax
8010566f:	6a 01                	push   $0x1
80105671:	e8 5a f4 ff ff       	call   80104ad0 <argint>
80105676:	83 c4 10             	add    $0x10,%esp
80105679:	85 c0                	test   %eax,%eax
8010567b:	78 6f                	js     801056ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010567d:	83 ec 04             	sub    $0x4,%esp
80105680:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105686:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105688:	68 80 00 00 00       	push   $0x80
8010568d:	6a 00                	push   $0x0
8010568f:	56                   	push   %esi
80105690:	e8 8b f1 ff ff       	call   80104820 <memset>
80105695:	83 c4 10             	add    $0x10,%esp
80105698:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010569f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801056a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801056b0:	50                   	push   %eax
801056b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056b7:	01 f8                	add    %edi,%eax
801056b9:	50                   	push   %eax
801056ba:	e8 81 f3 ff ff       	call   80104a40 <fetchint>
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	85 c0                	test   %eax,%eax
801056c4:	78 26                	js     801056ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801056c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801056cc:	85 c0                	test   %eax,%eax
801056ce:	74 30                	je     80105700 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056d0:	83 ec 08             	sub    $0x8,%esp
801056d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801056d6:	52                   	push   %edx
801056d7:	50                   	push   %eax
801056d8:	e8 a3 f3 ff ff       	call   80104a80 <fetchstr>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	78 08                	js     801056ec <sys_exec+0xac>
  for(i=0;; i++){
801056e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056e7:	83 fb 20             	cmp    $0x20,%ebx
801056ea:	75 b4                	jne    801056a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105700:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105707:	00 00 00 00 
  return exec(path, argv);
8010570b:	83 ec 08             	sub    $0x8,%esp
8010570e:	56                   	push   %esi
8010570f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105715:	e8 16 b5 ff ff       	call   80100c30 <exec>
8010571a:	83 c4 10             	add    $0x10,%esp
}
8010571d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105720:	5b                   	pop    %ebx
80105721:	5e                   	pop    %esi
80105722:	5f                   	pop    %edi
80105723:	5d                   	pop    %ebp
80105724:	c3                   	ret
80105725:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010572c:	00 
8010572d:	8d 76 00             	lea    0x0(%esi),%esi

80105730 <sys_pipe>:

int
sys_pipe(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105735:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105738:	53                   	push   %ebx
80105739:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010573c:	6a 08                	push   $0x8
8010573e:	50                   	push   %eax
8010573f:	6a 00                	push   $0x0
80105741:	e8 da f3 ff ff       	call   80104b20 <argptr>
80105746:	83 c4 10             	add    $0x10,%esp
80105749:	85 c0                	test   %eax,%eax
8010574b:	0f 88 8b 00 00 00    	js     801057dc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105751:	83 ec 08             	sub    $0x8,%esp
80105754:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105757:	50                   	push   %eax
80105758:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010575b:	50                   	push   %eax
8010575c:	e8 2f de ff ff       	call   80103590 <pipealloc>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	85 c0                	test   %eax,%eax
80105766:	78 74                	js     801057dc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105768:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010576b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010576d:	e8 6e e3 ff ff       	call   80103ae0 <myproc>
    if(curproc->ofile[fd] == 0){
80105772:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105776:	85 f6                	test   %esi,%esi
80105778:	74 16                	je     80105790 <sys_pipe+0x60>
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105780:	83 c3 01             	add    $0x1,%ebx
80105783:	83 fb 10             	cmp    $0x10,%ebx
80105786:	74 3d                	je     801057c5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105788:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010578c:	85 f6                	test   %esi,%esi
8010578e:	75 f0                	jne    80105780 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105790:	8d 73 08             	lea    0x8(%ebx),%esi
80105793:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105797:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010579a:	e8 41 e3 ff ff       	call   80103ae0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010579f:	31 d2                	xor    %edx,%edx
801057a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801057a8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057ac:	85 c9                	test   %ecx,%ecx
801057ae:	74 38                	je     801057e8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801057b0:	83 c2 01             	add    $0x1,%edx
801057b3:	83 fa 10             	cmp    $0x10,%edx
801057b6:	75 f0                	jne    801057a8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801057b8:	e8 23 e3 ff ff       	call   80103ae0 <myproc>
801057bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057c4:	00 
    fileclose(rf);
801057c5:	83 ec 0c             	sub    $0xc,%esp
801057c8:	ff 75 e0             	push   -0x20(%ebp)
801057cb:	e8 c0 b8 ff ff       	call   80101090 <fileclose>
    fileclose(wf);
801057d0:	58                   	pop    %eax
801057d1:	ff 75 e4             	push   -0x1c(%ebp)
801057d4:	e8 b7 b8 ff ff       	call   80101090 <fileclose>
    return -1;
801057d9:	83 c4 10             	add    $0x10,%esp
    return -1;
801057dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e1:	eb 16                	jmp    801057f9 <sys_pipe+0xc9>
801057e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801057e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057f7:	31 c0                	xor    %eax,%eax
}
801057f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057fc:	5b                   	pop    %ebx
801057fd:	5e                   	pop    %esi
801057fe:	5f                   	pop    %edi
801057ff:	5d                   	pop    %ebp
80105800:	c3                   	ret
80105801:	66 90                	xchg   %ax,%ax
80105803:	66 90                	xchg   %ax,%ax
80105805:	66 90                	xchg   %ax,%ax
80105807:	66 90                	xchg   %ax,%ax
80105809:	66 90                	xchg   %ax,%ax
8010580b:	66 90                	xchg   %ax,%ax
8010580d:	66 90                	xchg   %ax,%ax
8010580f:	90                   	nop

80105810 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105810:	e9 6b e4 ff ff       	jmp    80103c80 <fork>
80105815:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010581c:	00 
8010581d:	8d 76 00             	lea    0x0(%esi),%esi

80105820 <sys_exit>:
}

int
sys_exit(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	83 ec 08             	sub    $0x8,%esp
  exit();
80105826:	e8 c5 e6 ff ff       	call   80103ef0 <exit>
  return 0;  // not reached
}
8010582b:	31 c0                	xor    %eax,%eax
8010582d:	c9                   	leave
8010582e:	c3                   	ret
8010582f:	90                   	nop

80105830 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105830:	e9 eb e7 ff ff       	jmp    80104020 <wait>
80105835:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010583c:	00 
8010583d:	8d 76 00             	lea    0x0(%esi),%esi

80105840 <sys_kill>:
}

int
sys_kill(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105846:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105849:	50                   	push   %eax
8010584a:	6a 00                	push   $0x0
8010584c:	e8 7f f2 ff ff       	call   80104ad0 <argint>
80105851:	83 c4 10             	add    $0x10,%esp
80105854:	85 c0                	test   %eax,%eax
80105856:	78 18                	js     80105870 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105858:	83 ec 0c             	sub    $0xc,%esp
8010585b:	ff 75 f4             	push   -0xc(%ebp)
8010585e:	e8 5d ea ff ff       	call   801042c0 <kill>
80105863:	83 c4 10             	add    $0x10,%esp
}
80105866:	c9                   	leave
80105867:	c3                   	ret
80105868:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010586f:	00 
80105870:	c9                   	leave
    return -1;
80105871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105876:	c3                   	ret
80105877:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010587e:	00 
8010587f:	90                   	nop

80105880 <sys_getpid>:

int
sys_getpid(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105886:	e8 55 e2 ff ff       	call   80103ae0 <myproc>
8010588b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010588e:	c9                   	leave
8010588f:	c3                   	ret

80105890 <sys_sbrk>:

int
sys_sbrk(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105894:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105897:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010589a:	50                   	push   %eax
8010589b:	6a 00                	push   $0x0
8010589d:	e8 2e f2 ff ff       	call   80104ad0 <argint>
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	85 c0                	test   %eax,%eax
801058a7:	78 27                	js     801058d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801058a9:	e8 32 e2 ff ff       	call   80103ae0 <myproc>
  if(growproc(n) < 0)
801058ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801058b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058b3:	ff 75 f4             	push   -0xc(%ebp)
801058b6:	e8 45 e3 ff ff       	call   80103c00 <growproc>
801058bb:	83 c4 10             	add    $0x10,%esp
801058be:	85 c0                	test   %eax,%eax
801058c0:	78 0e                	js     801058d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801058c2:	89 d8                	mov    %ebx,%eax
801058c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c7:	c9                   	leave
801058c8:	c3                   	ret
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058d5:	eb eb                	jmp    801058c2 <sys_sbrk+0x32>
801058d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058de:	00 
801058df:	90                   	nop

801058e0 <sys_sleep>:

int
sys_sleep(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ea:	50                   	push   %eax
801058eb:	6a 00                	push   $0x0
801058ed:	e8 de f1 ff ff       	call   80104ad0 <argint>
801058f2:	83 c4 10             	add    $0x10,%esp
801058f5:	85 c0                	test   %eax,%eax
801058f7:	78 64                	js     8010595d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
801058f9:	83 ec 0c             	sub    $0xc,%esp
801058fc:	68 80 3c 11 80       	push   $0x80113c80
80105901:	e8 1a ee ff ff       	call   80104720 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105906:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105909:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
8010590f:	83 c4 10             	add    $0x10,%esp
80105912:	85 d2                	test   %edx,%edx
80105914:	75 2b                	jne    80105941 <sys_sleep+0x61>
80105916:	eb 58                	jmp    80105970 <sys_sleep+0x90>
80105918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010591f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	68 80 3c 11 80       	push   $0x80113c80
80105928:	68 60 3c 11 80       	push   $0x80113c60
8010592d:	e8 6e e8 ff ff       	call   801041a0 <sleep>
  while(ticks - ticks0 < n){
80105932:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105937:	83 c4 10             	add    $0x10,%esp
8010593a:	29 d8                	sub    %ebx,%eax
8010593c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010593f:	73 2f                	jae    80105970 <sys_sleep+0x90>
    if(myproc()->killed){
80105941:	e8 9a e1 ff ff       	call   80103ae0 <myproc>
80105946:	8b 40 24             	mov    0x24(%eax),%eax
80105949:	85 c0                	test   %eax,%eax
8010594b:	74 d3                	je     80105920 <sys_sleep+0x40>
      release(&tickslock);
8010594d:	83 ec 0c             	sub    $0xc,%esp
80105950:	68 80 3c 11 80       	push   $0x80113c80
80105955:	e8 66 ed ff ff       	call   801046c0 <release>
      return -1;
8010595a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010595d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105965:	c9                   	leave
80105966:	c3                   	ret
80105967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010596e:	00 
8010596f:	90                   	nop
  release(&tickslock);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	68 80 3c 11 80       	push   $0x80113c80
80105978:	e8 43 ed ff ff       	call   801046c0 <release>
}
8010597d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105980:	83 c4 10             	add    $0x10,%esp
80105983:	31 c0                	xor    %eax,%eax
}
80105985:	c9                   	leave
80105986:	c3                   	ret
80105987:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010598e:	00 
8010598f:	90                   	nop

80105990 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	53                   	push   %ebx
80105994:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105997:	68 80 3c 11 80       	push   $0x80113c80
8010599c:	e8 7f ed ff ff       	call   80104720 <acquire>
  xticks = ticks;
801059a1:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
801059a7:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
801059ae:	e8 0d ed ff ff       	call   801046c0 <release>
  return xticks;
}
801059b3:	89 d8                	mov    %ebx,%eax
801059b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059b8:	c9                   	leave
801059b9:	c3                   	ret

801059ba <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801059ba:	1e                   	push   %ds
  pushl %es
801059bb:	06                   	push   %es
  pushl %fs
801059bc:	0f a0                	push   %fs
  pushl %gs
801059be:	0f a8                	push   %gs
  pushal
801059c0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801059c1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801059c5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801059c7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801059c9:	54                   	push   %esp
  call trap
801059ca:	e8 c1 00 00 00       	call   80105a90 <trap>
  addl $4, %esp
801059cf:	83 c4 04             	add    $0x4,%esp

801059d2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801059d2:	61                   	popa
  popl %gs
801059d3:	0f a9                	pop    %gs
  popl %fs
801059d5:	0f a1                	pop    %fs
  popl %es
801059d7:	07                   	pop    %es
  popl %ds
801059d8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801059d9:	83 c4 08             	add    $0x8,%esp
  iret
801059dc:	cf                   	iret
801059dd:	66 90                	xchg   %ax,%ax
801059df:	90                   	nop

801059e0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801059e0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801059e1:	31 c0                	xor    %eax,%eax
{
801059e3:	89 e5                	mov    %esp,%ebp
801059e5:	83 ec 08             	sub    $0x8,%esp
801059e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ef:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801059f0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801059f7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
801059fe:	08 00 00 8e 
80105a02:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
80105a09:	80 
80105a0a:	c1 ea 10             	shr    $0x10,%edx
80105a0d:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
80105a14:	80 
  for(i = 0; i < 256; i++)
80105a15:	83 c0 01             	add    $0x1,%eax
80105a18:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a1d:	75 d1                	jne    801059f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105a1f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a22:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105a27:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
80105a2e:	00 00 ef 
  initlock(&tickslock, "time");
80105a31:	68 17 77 10 80       	push   $0x80107717
80105a36:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a3b:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105a41:	c1 e8 10             	shr    $0x10,%eax
80105a44:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105a4a:	e8 e1 ea ff ff       	call   80104530 <initlock>
}
80105a4f:	83 c4 10             	add    $0x10,%esp
80105a52:	c9                   	leave
80105a53:	c3                   	ret
80105a54:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a5b:	00 
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <idtinit>:

void
idtinit(void)
{
80105a60:	55                   	push   %ebp
  pd[0] = size-1;
80105a61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a66:	89 e5                	mov    %esp,%ebp
80105a68:	83 ec 10             	sub    $0x10,%esp
80105a6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a6f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105a74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a78:	c1 e8 10             	shr    $0x10,%eax
80105a7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a82:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a85:	c9                   	leave
80105a86:	c3                   	ret
80105a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a8e:	00 
80105a8f:	90                   	nop

80105a90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	57                   	push   %edi
80105a94:	56                   	push   %esi
80105a95:	53                   	push   %ebx
80105a96:	83 ec 1c             	sub    $0x1c,%esp
80105a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105a9c:	8b 43 30             	mov    0x30(%ebx),%eax
80105a9f:	83 f8 40             	cmp    $0x40,%eax
80105aa2:	0f 84 58 01 00 00    	je     80105c00 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105aa8:	83 e8 20             	sub    $0x20,%eax
80105aab:	83 f8 1f             	cmp    $0x1f,%eax
80105aae:	0f 87 7c 00 00 00    	ja     80105b30 <trap+0xa0>
80105ab4:	ff 24 85 d8 7c 10 80 	jmp    *-0x7fef8328(,%eax,4)
80105abb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ac0:	e8 eb c8 ff ff       	call   801023b0 <ideintr>
    lapiceoi();
80105ac5:	e8 a6 cf ff ff       	call   80102a70 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aca:	e8 11 e0 ff ff       	call   80103ae0 <myproc>
80105acf:	85 c0                	test   %eax,%eax
80105ad1:	74 1a                	je     80105aed <trap+0x5d>
80105ad3:	e8 08 e0 ff ff       	call   80103ae0 <myproc>
80105ad8:	8b 50 24             	mov    0x24(%eax),%edx
80105adb:	85 d2                	test   %edx,%edx
80105add:	74 0e                	je     80105aed <trap+0x5d>
80105adf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ae3:	f7 d0                	not    %eax
80105ae5:	a8 03                	test   $0x3,%al
80105ae7:	0f 84 db 01 00 00    	je     80105cc8 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105aed:	e8 ee df ff ff       	call   80103ae0 <myproc>
80105af2:	85 c0                	test   %eax,%eax
80105af4:	74 0f                	je     80105b05 <trap+0x75>
80105af6:	e8 e5 df ff ff       	call   80103ae0 <myproc>
80105afb:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105aff:	0f 84 ab 00 00 00    	je     80105bb0 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b05:	e8 d6 df ff ff       	call   80103ae0 <myproc>
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	74 1a                	je     80105b28 <trap+0x98>
80105b0e:	e8 cd df ff ff       	call   80103ae0 <myproc>
80105b13:	8b 40 24             	mov    0x24(%eax),%eax
80105b16:	85 c0                	test   %eax,%eax
80105b18:	74 0e                	je     80105b28 <trap+0x98>
80105b1a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b1e:	f7 d0                	not    %eax
80105b20:	a8 03                	test   $0x3,%al
80105b22:	0f 84 05 01 00 00    	je     80105c2d <trap+0x19d>
    exit();
}
80105b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b2b:	5b                   	pop    %ebx
80105b2c:	5e                   	pop    %esi
80105b2d:	5f                   	pop    %edi
80105b2e:	5d                   	pop    %ebp
80105b2f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b30:	e8 ab df ff ff       	call   80103ae0 <myproc>
80105b35:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b38:	85 c0                	test   %eax,%eax
80105b3a:	0f 84 a2 01 00 00    	je     80105ce2 <trap+0x252>
80105b40:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b44:	0f 84 98 01 00 00    	je     80105ce2 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b4a:	0f 20 d1             	mov    %cr2,%ecx
80105b4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b50:	e8 6b df ff ff       	call   80103ac0 <cpuid>
80105b55:	8b 73 30             	mov    0x30(%ebx),%esi
80105b58:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b5b:	8b 43 34             	mov    0x34(%ebx),%eax
80105b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105b61:	e8 7a df ff ff       	call   80103ae0 <myproc>
80105b66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b69:	e8 72 df ff ff       	call   80103ae0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b71:	51                   	push   %ecx
80105b72:	57                   	push   %edi
80105b73:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b76:	52                   	push   %edx
80105b77:	ff 75 e4             	push   -0x1c(%ebp)
80105b7a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105b7b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105b7e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b81:	56                   	push   %esi
80105b82:	ff 70 10             	push   0x10(%eax)
80105b85:	68 c8 79 10 80       	push   $0x801079c8
80105b8a:	e8 21 ab ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105b8f:	83 c4 20             	add    $0x20,%esp
80105b92:	e8 49 df ff ff       	call   80103ae0 <myproc>
80105b97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b9e:	e8 3d df ff ff       	call   80103ae0 <myproc>
80105ba3:	85 c0                	test   %eax,%eax
80105ba5:	0f 85 28 ff ff ff    	jne    80105ad3 <trap+0x43>
80105bab:	e9 3d ff ff ff       	jmp    80105aed <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105bb0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105bb4:	0f 85 4b ff ff ff    	jne    80105b05 <trap+0x75>
    yield();
80105bba:	e8 91 e5 ff ff       	call   80104150 <yield>
80105bbf:	e9 41 ff ff ff       	jmp    80105b05 <trap+0x75>
80105bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bc8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bcb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105bcf:	e8 ec de ff ff       	call   80103ac0 <cpuid>
80105bd4:	57                   	push   %edi
80105bd5:	56                   	push   %esi
80105bd6:	50                   	push   %eax
80105bd7:	68 70 79 10 80       	push   $0x80107970
80105bdc:	e8 cf aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105be1:	e8 8a ce ff ff       	call   80102a70 <lapiceoi>
    break;
80105be6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105be9:	e8 f2 de ff ff       	call   80103ae0 <myproc>
80105bee:	85 c0                	test   %eax,%eax
80105bf0:	0f 85 dd fe ff ff    	jne    80105ad3 <trap+0x43>
80105bf6:	e9 f2 fe ff ff       	jmp    80105aed <trap+0x5d>
80105bfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105c00:	e8 db de ff ff       	call   80103ae0 <myproc>
80105c05:	8b 70 24             	mov    0x24(%eax),%esi
80105c08:	85 f6                	test   %esi,%esi
80105c0a:	0f 85 c8 00 00 00    	jne    80105cd8 <trap+0x248>
    myproc()->tf = tf;
80105c10:	e8 cb de ff ff       	call   80103ae0 <myproc>
80105c15:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c18:	e8 f3 ef ff ff       	call   80104c10 <syscall>
    if(myproc()->killed)
80105c1d:	e8 be de ff ff       	call   80103ae0 <myproc>
80105c22:	8b 48 24             	mov    0x24(%eax),%ecx
80105c25:	85 c9                	test   %ecx,%ecx
80105c27:	0f 84 fb fe ff ff    	je     80105b28 <trap+0x98>
}
80105c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c30:	5b                   	pop    %ebx
80105c31:	5e                   	pop    %esi
80105c32:	5f                   	pop    %edi
80105c33:	5d                   	pop    %ebp
      exit();
80105c34:	e9 b7 e2 ff ff       	jmp    80103ef0 <exit>
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c40:	e8 4b 02 00 00       	call   80105e90 <uartintr>
    lapiceoi();
80105c45:	e8 26 ce ff ff       	call   80102a70 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c4a:	e8 91 de ff ff       	call   80103ae0 <myproc>
80105c4f:	85 c0                	test   %eax,%eax
80105c51:	0f 85 7c fe ff ff    	jne    80105ad3 <trap+0x43>
80105c57:	e9 91 fe ff ff       	jmp    80105aed <trap+0x5d>
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c60:	e8 db cc ff ff       	call   80102940 <kbdintr>
    lapiceoi();
80105c65:	e8 06 ce ff ff       	call   80102a70 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c6a:	e8 71 de ff ff       	call   80103ae0 <myproc>
80105c6f:	85 c0                	test   %eax,%eax
80105c71:	0f 85 5c fe ff ff    	jne    80105ad3 <trap+0x43>
80105c77:	e9 71 fe ff ff       	jmp    80105aed <trap+0x5d>
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105c80:	e8 3b de ff ff       	call   80103ac0 <cpuid>
80105c85:	85 c0                	test   %eax,%eax
80105c87:	0f 85 38 fe ff ff    	jne    80105ac5 <trap+0x35>
      acquire(&tickslock);
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	68 80 3c 11 80       	push   $0x80113c80
80105c95:	e8 86 ea ff ff       	call   80104720 <acquire>
      ticks++;
80105c9a:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105ca1:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105ca8:	e8 b3 e5 ff ff       	call   80104260 <wakeup>
      release(&tickslock);
80105cad:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105cb4:	e8 07 ea ff ff       	call   801046c0 <release>
80105cb9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105cbc:	e9 04 fe ff ff       	jmp    80105ac5 <trap+0x35>
80105cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105cc8:	e8 23 e2 ff ff       	call   80103ef0 <exit>
80105ccd:	e9 1b fe ff ff       	jmp    80105aed <trap+0x5d>
80105cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105cd8:	e8 13 e2 ff ff       	call   80103ef0 <exit>
80105cdd:	e9 2e ff ff ff       	jmp    80105c10 <trap+0x180>
80105ce2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ce5:	e8 d6 dd ff ff       	call   80103ac0 <cpuid>
80105cea:	83 ec 0c             	sub    $0xc,%esp
80105ced:	56                   	push   %esi
80105cee:	57                   	push   %edi
80105cef:	50                   	push   %eax
80105cf0:	ff 73 30             	push   0x30(%ebx)
80105cf3:	68 94 79 10 80       	push   $0x80107994
80105cf8:	e8 b3 a9 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105cfd:	83 c4 14             	add    $0x14,%esp
80105d00:	68 1c 77 10 80       	push   $0x8010771c
80105d05:	e8 76 a6 ff ff       	call   80100380 <panic>
80105d0a:	66 90                	xchg   %ax,%ax
80105d0c:	66 90                	xchg   %ax,%ax
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d10:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105d15:	85 c0                	test   %eax,%eax
80105d17:	74 17                	je     80105d30 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d19:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d1e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d1f:	a8 01                	test   $0x1,%al
80105d21:	74 0d                	je     80105d30 <uartgetc+0x20>
80105d23:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d28:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d29:	0f b6 c0             	movzbl %al,%eax
80105d2c:	c3                   	ret
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d35:	c3                   	ret
80105d36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d3d:	00 
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <uartinit>:
{
80105d40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d41:	31 c9                	xor    %ecx,%ecx
80105d43:	89 c8                	mov    %ecx,%eax
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	57                   	push   %edi
80105d48:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105d4d:	56                   	push   %esi
80105d4e:	89 fa                	mov    %edi,%edx
80105d50:	53                   	push   %ebx
80105d51:	83 ec 1c             	sub    $0x1c,%esp
80105d54:	ee                   	out    %al,(%dx)
80105d55:	be fb 03 00 00       	mov    $0x3fb,%esi
80105d5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d5f:	89 f2                	mov    %esi,%edx
80105d61:	ee                   	out    %al,(%dx)
80105d62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d6c:	ee                   	out    %al,(%dx)
80105d6d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105d72:	89 c8                	mov    %ecx,%eax
80105d74:	89 da                	mov    %ebx,%edx
80105d76:	ee                   	out    %al,(%dx)
80105d77:	b8 03 00 00 00       	mov    $0x3,%eax
80105d7c:	89 f2                	mov    %esi,%edx
80105d7e:	ee                   	out    %al,(%dx)
80105d7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d84:	89 c8                	mov    %ecx,%eax
80105d86:	ee                   	out    %al,(%dx)
80105d87:	b8 01 00 00 00       	mov    $0x1,%eax
80105d8c:	89 da                	mov    %ebx,%edx
80105d8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d94:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d95:	3c ff                	cmp    $0xff,%al
80105d97:	0f 84 7c 00 00 00    	je     80105e19 <uartinit+0xd9>
  uart = 1;
80105d9d:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105da4:	00 00 00 
80105da7:	89 fa                	mov    %edi,%edx
80105da9:	ec                   	in     (%dx),%al
80105daa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105daf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105db0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105db3:	bf 21 77 10 80       	mov    $0x80107721,%edi
80105db8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105dbd:	6a 00                	push   $0x0
80105dbf:	6a 04                	push   $0x4
80105dc1:	e8 1a c8 ff ff       	call   801025e0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105dc6:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105dca:	83 c4 10             	add    $0x10,%esp
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105dd0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	74 32                	je     80105e0b <uartinit+0xcb>
80105dd9:	89 f2                	mov    %esi,%edx
80105ddb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ddc:	a8 20                	test   $0x20,%al
80105dde:	75 21                	jne    80105e01 <uartinit+0xc1>
80105de0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105de5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105de8:	83 ec 0c             	sub    $0xc,%esp
80105deb:	6a 0a                	push   $0xa
80105ded:	e8 9e cc ff ff       	call   80102a90 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	83 eb 01             	sub    $0x1,%ebx
80105df8:	74 07                	je     80105e01 <uartinit+0xc1>
80105dfa:	89 f2                	mov    %esi,%edx
80105dfc:	ec                   	in     (%dx),%al
80105dfd:	a8 20                	test   $0x20,%al
80105dff:	74 e7                	je     80105de8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e01:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e06:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105e0a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105e0b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105e0f:	83 c7 01             	add    $0x1,%edi
80105e12:	88 45 e7             	mov    %al,-0x19(%ebp)
80105e15:	84 c0                	test   %al,%al
80105e17:	75 b7                	jne    80105dd0 <uartinit+0x90>
}
80105e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e1c:	5b                   	pop    %ebx
80105e1d:	5e                   	pop    %esi
80105e1e:	5f                   	pop    %edi
80105e1f:	5d                   	pop    %ebp
80105e20:	c3                   	ret
80105e21:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e28:	00 
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e30 <uartputc>:
  if(!uart)
80105e30:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105e35:	85 c0                	test   %eax,%eax
80105e37:	74 4f                	je     80105e88 <uartputc+0x58>
{
80105e39:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e3a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e3f:	89 e5                	mov    %esp,%ebp
80105e41:	56                   	push   %esi
80105e42:	53                   	push   %ebx
80105e43:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e44:	a8 20                	test   $0x20,%al
80105e46:	75 29                	jne    80105e71 <uartputc+0x41>
80105e48:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e4d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105e58:	83 ec 0c             	sub    $0xc,%esp
80105e5b:	6a 0a                	push   $0xa
80105e5d:	e8 2e cc ff ff       	call   80102a90 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e62:	83 c4 10             	add    $0x10,%esp
80105e65:	83 eb 01             	sub    $0x1,%ebx
80105e68:	74 07                	je     80105e71 <uartputc+0x41>
80105e6a:	89 f2                	mov    %esi,%edx
80105e6c:	ec                   	in     (%dx),%al
80105e6d:	a8 20                	test   $0x20,%al
80105e6f:	74 e7                	je     80105e58 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e71:	8b 45 08             	mov    0x8(%ebp),%eax
80105e74:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e79:	ee                   	out    %al,(%dx)
}
80105e7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e7d:	5b                   	pop    %ebx
80105e7e:	5e                   	pop    %esi
80105e7f:	5d                   	pop    %ebp
80105e80:	c3                   	ret
80105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e88:	c3                   	ret
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e90 <uartintr>:

void
uartintr(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e96:	68 10 5d 10 80       	push   $0x80105d10
80105e9b:	e8 20 ab ff ff       	call   801009c0 <consoleintr>
}
80105ea0:	83 c4 10             	add    $0x10,%esp
80105ea3:	c9                   	leave
80105ea4:	c3                   	ret

80105ea5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $0
80105ea7:	6a 00                	push   $0x0
  jmp alltraps
80105ea9:	e9 0c fb ff ff       	jmp    801059ba <alltraps>

80105eae <vector1>:
.globl vector1
vector1:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $1
80105eb0:	6a 01                	push   $0x1
  jmp alltraps
80105eb2:	e9 03 fb ff ff       	jmp    801059ba <alltraps>

80105eb7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $2
80105eb9:	6a 02                	push   $0x2
  jmp alltraps
80105ebb:	e9 fa fa ff ff       	jmp    801059ba <alltraps>

80105ec0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $3
80105ec2:	6a 03                	push   $0x3
  jmp alltraps
80105ec4:	e9 f1 fa ff ff       	jmp    801059ba <alltraps>

80105ec9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $4
80105ecb:	6a 04                	push   $0x4
  jmp alltraps
80105ecd:	e9 e8 fa ff ff       	jmp    801059ba <alltraps>

80105ed2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $5
80105ed4:	6a 05                	push   $0x5
  jmp alltraps
80105ed6:	e9 df fa ff ff       	jmp    801059ba <alltraps>

80105edb <vector6>:
.globl vector6
vector6:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $6
80105edd:	6a 06                	push   $0x6
  jmp alltraps
80105edf:	e9 d6 fa ff ff       	jmp    801059ba <alltraps>

80105ee4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $7
80105ee6:	6a 07                	push   $0x7
  jmp alltraps
80105ee8:	e9 cd fa ff ff       	jmp    801059ba <alltraps>

80105eed <vector8>:
.globl vector8
vector8:
  pushl $8
80105eed:	6a 08                	push   $0x8
  jmp alltraps
80105eef:	e9 c6 fa ff ff       	jmp    801059ba <alltraps>

80105ef4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $9
80105ef6:	6a 09                	push   $0x9
  jmp alltraps
80105ef8:	e9 bd fa ff ff       	jmp    801059ba <alltraps>

80105efd <vector10>:
.globl vector10
vector10:
  pushl $10
80105efd:	6a 0a                	push   $0xa
  jmp alltraps
80105eff:	e9 b6 fa ff ff       	jmp    801059ba <alltraps>

80105f04 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f04:	6a 0b                	push   $0xb
  jmp alltraps
80105f06:	e9 af fa ff ff       	jmp    801059ba <alltraps>

80105f0b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f0b:	6a 0c                	push   $0xc
  jmp alltraps
80105f0d:	e9 a8 fa ff ff       	jmp    801059ba <alltraps>

80105f12 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f12:	6a 0d                	push   $0xd
  jmp alltraps
80105f14:	e9 a1 fa ff ff       	jmp    801059ba <alltraps>

80105f19 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f19:	6a 0e                	push   $0xe
  jmp alltraps
80105f1b:	e9 9a fa ff ff       	jmp    801059ba <alltraps>

80105f20 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $15
80105f22:	6a 0f                	push   $0xf
  jmp alltraps
80105f24:	e9 91 fa ff ff       	jmp    801059ba <alltraps>

80105f29 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $16
80105f2b:	6a 10                	push   $0x10
  jmp alltraps
80105f2d:	e9 88 fa ff ff       	jmp    801059ba <alltraps>

80105f32 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f32:	6a 11                	push   $0x11
  jmp alltraps
80105f34:	e9 81 fa ff ff       	jmp    801059ba <alltraps>

80105f39 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $18
80105f3b:	6a 12                	push   $0x12
  jmp alltraps
80105f3d:	e9 78 fa ff ff       	jmp    801059ba <alltraps>

80105f42 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $19
80105f44:	6a 13                	push   $0x13
  jmp alltraps
80105f46:	e9 6f fa ff ff       	jmp    801059ba <alltraps>

80105f4b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $20
80105f4d:	6a 14                	push   $0x14
  jmp alltraps
80105f4f:	e9 66 fa ff ff       	jmp    801059ba <alltraps>

80105f54 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $21
80105f56:	6a 15                	push   $0x15
  jmp alltraps
80105f58:	e9 5d fa ff ff       	jmp    801059ba <alltraps>

80105f5d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $22
80105f5f:	6a 16                	push   $0x16
  jmp alltraps
80105f61:	e9 54 fa ff ff       	jmp    801059ba <alltraps>

80105f66 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $23
80105f68:	6a 17                	push   $0x17
  jmp alltraps
80105f6a:	e9 4b fa ff ff       	jmp    801059ba <alltraps>

80105f6f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $24
80105f71:	6a 18                	push   $0x18
  jmp alltraps
80105f73:	e9 42 fa ff ff       	jmp    801059ba <alltraps>

80105f78 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $25
80105f7a:	6a 19                	push   $0x19
  jmp alltraps
80105f7c:	e9 39 fa ff ff       	jmp    801059ba <alltraps>

80105f81 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $26
80105f83:	6a 1a                	push   $0x1a
  jmp alltraps
80105f85:	e9 30 fa ff ff       	jmp    801059ba <alltraps>

80105f8a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $27
80105f8c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f8e:	e9 27 fa ff ff       	jmp    801059ba <alltraps>

80105f93 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $28
80105f95:	6a 1c                	push   $0x1c
  jmp alltraps
80105f97:	e9 1e fa ff ff       	jmp    801059ba <alltraps>

80105f9c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $29
80105f9e:	6a 1d                	push   $0x1d
  jmp alltraps
80105fa0:	e9 15 fa ff ff       	jmp    801059ba <alltraps>

80105fa5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $30
80105fa7:	6a 1e                	push   $0x1e
  jmp alltraps
80105fa9:	e9 0c fa ff ff       	jmp    801059ba <alltraps>

80105fae <vector31>:
.globl vector31
vector31:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $31
80105fb0:	6a 1f                	push   $0x1f
  jmp alltraps
80105fb2:	e9 03 fa ff ff       	jmp    801059ba <alltraps>

80105fb7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $32
80105fb9:	6a 20                	push   $0x20
  jmp alltraps
80105fbb:	e9 fa f9 ff ff       	jmp    801059ba <alltraps>

80105fc0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $33
80105fc2:	6a 21                	push   $0x21
  jmp alltraps
80105fc4:	e9 f1 f9 ff ff       	jmp    801059ba <alltraps>

80105fc9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $34
80105fcb:	6a 22                	push   $0x22
  jmp alltraps
80105fcd:	e9 e8 f9 ff ff       	jmp    801059ba <alltraps>

80105fd2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $35
80105fd4:	6a 23                	push   $0x23
  jmp alltraps
80105fd6:	e9 df f9 ff ff       	jmp    801059ba <alltraps>

80105fdb <vector36>:
.globl vector36
vector36:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $36
80105fdd:	6a 24                	push   $0x24
  jmp alltraps
80105fdf:	e9 d6 f9 ff ff       	jmp    801059ba <alltraps>

80105fe4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $37
80105fe6:	6a 25                	push   $0x25
  jmp alltraps
80105fe8:	e9 cd f9 ff ff       	jmp    801059ba <alltraps>

80105fed <vector38>:
.globl vector38
vector38:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $38
80105fef:	6a 26                	push   $0x26
  jmp alltraps
80105ff1:	e9 c4 f9 ff ff       	jmp    801059ba <alltraps>

80105ff6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $39
80105ff8:	6a 27                	push   $0x27
  jmp alltraps
80105ffa:	e9 bb f9 ff ff       	jmp    801059ba <alltraps>

80105fff <vector40>:
.globl vector40
vector40:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $40
80106001:	6a 28                	push   $0x28
  jmp alltraps
80106003:	e9 b2 f9 ff ff       	jmp    801059ba <alltraps>

80106008 <vector41>:
.globl vector41
vector41:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $41
8010600a:	6a 29                	push   $0x29
  jmp alltraps
8010600c:	e9 a9 f9 ff ff       	jmp    801059ba <alltraps>

80106011 <vector42>:
.globl vector42
vector42:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $42
80106013:	6a 2a                	push   $0x2a
  jmp alltraps
80106015:	e9 a0 f9 ff ff       	jmp    801059ba <alltraps>

8010601a <vector43>:
.globl vector43
vector43:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $43
8010601c:	6a 2b                	push   $0x2b
  jmp alltraps
8010601e:	e9 97 f9 ff ff       	jmp    801059ba <alltraps>

80106023 <vector44>:
.globl vector44
vector44:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $44
80106025:	6a 2c                	push   $0x2c
  jmp alltraps
80106027:	e9 8e f9 ff ff       	jmp    801059ba <alltraps>

8010602c <vector45>:
.globl vector45
vector45:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $45
8010602e:	6a 2d                	push   $0x2d
  jmp alltraps
80106030:	e9 85 f9 ff ff       	jmp    801059ba <alltraps>

80106035 <vector46>:
.globl vector46
vector46:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $46
80106037:	6a 2e                	push   $0x2e
  jmp alltraps
80106039:	e9 7c f9 ff ff       	jmp    801059ba <alltraps>

8010603e <vector47>:
.globl vector47
vector47:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $47
80106040:	6a 2f                	push   $0x2f
  jmp alltraps
80106042:	e9 73 f9 ff ff       	jmp    801059ba <alltraps>

80106047 <vector48>:
.globl vector48
vector48:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $48
80106049:	6a 30                	push   $0x30
  jmp alltraps
8010604b:	e9 6a f9 ff ff       	jmp    801059ba <alltraps>

80106050 <vector49>:
.globl vector49
vector49:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $49
80106052:	6a 31                	push   $0x31
  jmp alltraps
80106054:	e9 61 f9 ff ff       	jmp    801059ba <alltraps>

80106059 <vector50>:
.globl vector50
vector50:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $50
8010605b:	6a 32                	push   $0x32
  jmp alltraps
8010605d:	e9 58 f9 ff ff       	jmp    801059ba <alltraps>

80106062 <vector51>:
.globl vector51
vector51:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $51
80106064:	6a 33                	push   $0x33
  jmp alltraps
80106066:	e9 4f f9 ff ff       	jmp    801059ba <alltraps>

8010606b <vector52>:
.globl vector52
vector52:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $52
8010606d:	6a 34                	push   $0x34
  jmp alltraps
8010606f:	e9 46 f9 ff ff       	jmp    801059ba <alltraps>

80106074 <vector53>:
.globl vector53
vector53:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $53
80106076:	6a 35                	push   $0x35
  jmp alltraps
80106078:	e9 3d f9 ff ff       	jmp    801059ba <alltraps>

8010607d <vector54>:
.globl vector54
vector54:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $54
8010607f:	6a 36                	push   $0x36
  jmp alltraps
80106081:	e9 34 f9 ff ff       	jmp    801059ba <alltraps>

80106086 <vector55>:
.globl vector55
vector55:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $55
80106088:	6a 37                	push   $0x37
  jmp alltraps
8010608a:	e9 2b f9 ff ff       	jmp    801059ba <alltraps>

8010608f <vector56>:
.globl vector56
vector56:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $56
80106091:	6a 38                	push   $0x38
  jmp alltraps
80106093:	e9 22 f9 ff ff       	jmp    801059ba <alltraps>

80106098 <vector57>:
.globl vector57
vector57:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $57
8010609a:	6a 39                	push   $0x39
  jmp alltraps
8010609c:	e9 19 f9 ff ff       	jmp    801059ba <alltraps>

801060a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $58
801060a3:	6a 3a                	push   $0x3a
  jmp alltraps
801060a5:	e9 10 f9 ff ff       	jmp    801059ba <alltraps>

801060aa <vector59>:
.globl vector59
vector59:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $59
801060ac:	6a 3b                	push   $0x3b
  jmp alltraps
801060ae:	e9 07 f9 ff ff       	jmp    801059ba <alltraps>

801060b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $60
801060b5:	6a 3c                	push   $0x3c
  jmp alltraps
801060b7:	e9 fe f8 ff ff       	jmp    801059ba <alltraps>

801060bc <vector61>:
.globl vector61
vector61:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $61
801060be:	6a 3d                	push   $0x3d
  jmp alltraps
801060c0:	e9 f5 f8 ff ff       	jmp    801059ba <alltraps>

801060c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $62
801060c7:	6a 3e                	push   $0x3e
  jmp alltraps
801060c9:	e9 ec f8 ff ff       	jmp    801059ba <alltraps>

801060ce <vector63>:
.globl vector63
vector63:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $63
801060d0:	6a 3f                	push   $0x3f
  jmp alltraps
801060d2:	e9 e3 f8 ff ff       	jmp    801059ba <alltraps>

801060d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $64
801060d9:	6a 40                	push   $0x40
  jmp alltraps
801060db:	e9 da f8 ff ff       	jmp    801059ba <alltraps>

801060e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $65
801060e2:	6a 41                	push   $0x41
  jmp alltraps
801060e4:	e9 d1 f8 ff ff       	jmp    801059ba <alltraps>

801060e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $66
801060eb:	6a 42                	push   $0x42
  jmp alltraps
801060ed:	e9 c8 f8 ff ff       	jmp    801059ba <alltraps>

801060f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $67
801060f4:	6a 43                	push   $0x43
  jmp alltraps
801060f6:	e9 bf f8 ff ff       	jmp    801059ba <alltraps>

801060fb <vector68>:
.globl vector68
vector68:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $68
801060fd:	6a 44                	push   $0x44
  jmp alltraps
801060ff:	e9 b6 f8 ff ff       	jmp    801059ba <alltraps>

80106104 <vector69>:
.globl vector69
vector69:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $69
80106106:	6a 45                	push   $0x45
  jmp alltraps
80106108:	e9 ad f8 ff ff       	jmp    801059ba <alltraps>

8010610d <vector70>:
.globl vector70
vector70:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $70
8010610f:	6a 46                	push   $0x46
  jmp alltraps
80106111:	e9 a4 f8 ff ff       	jmp    801059ba <alltraps>

80106116 <vector71>:
.globl vector71
vector71:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $71
80106118:	6a 47                	push   $0x47
  jmp alltraps
8010611a:	e9 9b f8 ff ff       	jmp    801059ba <alltraps>

8010611f <vector72>:
.globl vector72
vector72:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $72
80106121:	6a 48                	push   $0x48
  jmp alltraps
80106123:	e9 92 f8 ff ff       	jmp    801059ba <alltraps>

80106128 <vector73>:
.globl vector73
vector73:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $73
8010612a:	6a 49                	push   $0x49
  jmp alltraps
8010612c:	e9 89 f8 ff ff       	jmp    801059ba <alltraps>

80106131 <vector74>:
.globl vector74
vector74:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $74
80106133:	6a 4a                	push   $0x4a
  jmp alltraps
80106135:	e9 80 f8 ff ff       	jmp    801059ba <alltraps>

8010613a <vector75>:
.globl vector75
vector75:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $75
8010613c:	6a 4b                	push   $0x4b
  jmp alltraps
8010613e:	e9 77 f8 ff ff       	jmp    801059ba <alltraps>

80106143 <vector76>:
.globl vector76
vector76:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $76
80106145:	6a 4c                	push   $0x4c
  jmp alltraps
80106147:	e9 6e f8 ff ff       	jmp    801059ba <alltraps>

8010614c <vector77>:
.globl vector77
vector77:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $77
8010614e:	6a 4d                	push   $0x4d
  jmp alltraps
80106150:	e9 65 f8 ff ff       	jmp    801059ba <alltraps>

80106155 <vector78>:
.globl vector78
vector78:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $78
80106157:	6a 4e                	push   $0x4e
  jmp alltraps
80106159:	e9 5c f8 ff ff       	jmp    801059ba <alltraps>

8010615e <vector79>:
.globl vector79
vector79:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $79
80106160:	6a 4f                	push   $0x4f
  jmp alltraps
80106162:	e9 53 f8 ff ff       	jmp    801059ba <alltraps>

80106167 <vector80>:
.globl vector80
vector80:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $80
80106169:	6a 50                	push   $0x50
  jmp alltraps
8010616b:	e9 4a f8 ff ff       	jmp    801059ba <alltraps>

80106170 <vector81>:
.globl vector81
vector81:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $81
80106172:	6a 51                	push   $0x51
  jmp alltraps
80106174:	e9 41 f8 ff ff       	jmp    801059ba <alltraps>

80106179 <vector82>:
.globl vector82
vector82:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $82
8010617b:	6a 52                	push   $0x52
  jmp alltraps
8010617d:	e9 38 f8 ff ff       	jmp    801059ba <alltraps>

80106182 <vector83>:
.globl vector83
vector83:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $83
80106184:	6a 53                	push   $0x53
  jmp alltraps
80106186:	e9 2f f8 ff ff       	jmp    801059ba <alltraps>

8010618b <vector84>:
.globl vector84
vector84:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $84
8010618d:	6a 54                	push   $0x54
  jmp alltraps
8010618f:	e9 26 f8 ff ff       	jmp    801059ba <alltraps>

80106194 <vector85>:
.globl vector85
vector85:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $85
80106196:	6a 55                	push   $0x55
  jmp alltraps
80106198:	e9 1d f8 ff ff       	jmp    801059ba <alltraps>

8010619d <vector86>:
.globl vector86
vector86:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $86
8010619f:	6a 56                	push   $0x56
  jmp alltraps
801061a1:	e9 14 f8 ff ff       	jmp    801059ba <alltraps>

801061a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $87
801061a8:	6a 57                	push   $0x57
  jmp alltraps
801061aa:	e9 0b f8 ff ff       	jmp    801059ba <alltraps>

801061af <vector88>:
.globl vector88
vector88:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $88
801061b1:	6a 58                	push   $0x58
  jmp alltraps
801061b3:	e9 02 f8 ff ff       	jmp    801059ba <alltraps>

801061b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $89
801061ba:	6a 59                	push   $0x59
  jmp alltraps
801061bc:	e9 f9 f7 ff ff       	jmp    801059ba <alltraps>

801061c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $90
801061c3:	6a 5a                	push   $0x5a
  jmp alltraps
801061c5:	e9 f0 f7 ff ff       	jmp    801059ba <alltraps>

801061ca <vector91>:
.globl vector91
vector91:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $91
801061cc:	6a 5b                	push   $0x5b
  jmp alltraps
801061ce:	e9 e7 f7 ff ff       	jmp    801059ba <alltraps>

801061d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $92
801061d5:	6a 5c                	push   $0x5c
  jmp alltraps
801061d7:	e9 de f7 ff ff       	jmp    801059ba <alltraps>

801061dc <vector93>:
.globl vector93
vector93:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $93
801061de:	6a 5d                	push   $0x5d
  jmp alltraps
801061e0:	e9 d5 f7 ff ff       	jmp    801059ba <alltraps>

801061e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $94
801061e7:	6a 5e                	push   $0x5e
  jmp alltraps
801061e9:	e9 cc f7 ff ff       	jmp    801059ba <alltraps>

801061ee <vector95>:
.globl vector95
vector95:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $95
801061f0:	6a 5f                	push   $0x5f
  jmp alltraps
801061f2:	e9 c3 f7 ff ff       	jmp    801059ba <alltraps>

801061f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $96
801061f9:	6a 60                	push   $0x60
  jmp alltraps
801061fb:	e9 ba f7 ff ff       	jmp    801059ba <alltraps>

80106200 <vector97>:
.globl vector97
vector97:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $97
80106202:	6a 61                	push   $0x61
  jmp alltraps
80106204:	e9 b1 f7 ff ff       	jmp    801059ba <alltraps>

80106209 <vector98>:
.globl vector98
vector98:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $98
8010620b:	6a 62                	push   $0x62
  jmp alltraps
8010620d:	e9 a8 f7 ff ff       	jmp    801059ba <alltraps>

80106212 <vector99>:
.globl vector99
vector99:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $99
80106214:	6a 63                	push   $0x63
  jmp alltraps
80106216:	e9 9f f7 ff ff       	jmp    801059ba <alltraps>

8010621b <vector100>:
.globl vector100
vector100:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $100
8010621d:	6a 64                	push   $0x64
  jmp alltraps
8010621f:	e9 96 f7 ff ff       	jmp    801059ba <alltraps>

80106224 <vector101>:
.globl vector101
vector101:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $101
80106226:	6a 65                	push   $0x65
  jmp alltraps
80106228:	e9 8d f7 ff ff       	jmp    801059ba <alltraps>

8010622d <vector102>:
.globl vector102
vector102:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $102
8010622f:	6a 66                	push   $0x66
  jmp alltraps
80106231:	e9 84 f7 ff ff       	jmp    801059ba <alltraps>

80106236 <vector103>:
.globl vector103
vector103:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $103
80106238:	6a 67                	push   $0x67
  jmp alltraps
8010623a:	e9 7b f7 ff ff       	jmp    801059ba <alltraps>

8010623f <vector104>:
.globl vector104
vector104:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $104
80106241:	6a 68                	push   $0x68
  jmp alltraps
80106243:	e9 72 f7 ff ff       	jmp    801059ba <alltraps>

80106248 <vector105>:
.globl vector105
vector105:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $105
8010624a:	6a 69                	push   $0x69
  jmp alltraps
8010624c:	e9 69 f7 ff ff       	jmp    801059ba <alltraps>

80106251 <vector106>:
.globl vector106
vector106:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $106
80106253:	6a 6a                	push   $0x6a
  jmp alltraps
80106255:	e9 60 f7 ff ff       	jmp    801059ba <alltraps>

8010625a <vector107>:
.globl vector107
vector107:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $107
8010625c:	6a 6b                	push   $0x6b
  jmp alltraps
8010625e:	e9 57 f7 ff ff       	jmp    801059ba <alltraps>

80106263 <vector108>:
.globl vector108
vector108:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $108
80106265:	6a 6c                	push   $0x6c
  jmp alltraps
80106267:	e9 4e f7 ff ff       	jmp    801059ba <alltraps>

8010626c <vector109>:
.globl vector109
vector109:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $109
8010626e:	6a 6d                	push   $0x6d
  jmp alltraps
80106270:	e9 45 f7 ff ff       	jmp    801059ba <alltraps>

80106275 <vector110>:
.globl vector110
vector110:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $110
80106277:	6a 6e                	push   $0x6e
  jmp alltraps
80106279:	e9 3c f7 ff ff       	jmp    801059ba <alltraps>

8010627e <vector111>:
.globl vector111
vector111:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $111
80106280:	6a 6f                	push   $0x6f
  jmp alltraps
80106282:	e9 33 f7 ff ff       	jmp    801059ba <alltraps>

80106287 <vector112>:
.globl vector112
vector112:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $112
80106289:	6a 70                	push   $0x70
  jmp alltraps
8010628b:	e9 2a f7 ff ff       	jmp    801059ba <alltraps>

80106290 <vector113>:
.globl vector113
vector113:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $113
80106292:	6a 71                	push   $0x71
  jmp alltraps
80106294:	e9 21 f7 ff ff       	jmp    801059ba <alltraps>

80106299 <vector114>:
.globl vector114
vector114:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $114
8010629b:	6a 72                	push   $0x72
  jmp alltraps
8010629d:	e9 18 f7 ff ff       	jmp    801059ba <alltraps>

801062a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $115
801062a4:	6a 73                	push   $0x73
  jmp alltraps
801062a6:	e9 0f f7 ff ff       	jmp    801059ba <alltraps>

801062ab <vector116>:
.globl vector116
vector116:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $116
801062ad:	6a 74                	push   $0x74
  jmp alltraps
801062af:	e9 06 f7 ff ff       	jmp    801059ba <alltraps>

801062b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $117
801062b6:	6a 75                	push   $0x75
  jmp alltraps
801062b8:	e9 fd f6 ff ff       	jmp    801059ba <alltraps>

801062bd <vector118>:
.globl vector118
vector118:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $118
801062bf:	6a 76                	push   $0x76
  jmp alltraps
801062c1:	e9 f4 f6 ff ff       	jmp    801059ba <alltraps>

801062c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $119
801062c8:	6a 77                	push   $0x77
  jmp alltraps
801062ca:	e9 eb f6 ff ff       	jmp    801059ba <alltraps>

801062cf <vector120>:
.globl vector120
vector120:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $120
801062d1:	6a 78                	push   $0x78
  jmp alltraps
801062d3:	e9 e2 f6 ff ff       	jmp    801059ba <alltraps>

801062d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $121
801062da:	6a 79                	push   $0x79
  jmp alltraps
801062dc:	e9 d9 f6 ff ff       	jmp    801059ba <alltraps>

801062e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $122
801062e3:	6a 7a                	push   $0x7a
  jmp alltraps
801062e5:	e9 d0 f6 ff ff       	jmp    801059ba <alltraps>

801062ea <vector123>:
.globl vector123
vector123:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $123
801062ec:	6a 7b                	push   $0x7b
  jmp alltraps
801062ee:	e9 c7 f6 ff ff       	jmp    801059ba <alltraps>

801062f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $124
801062f5:	6a 7c                	push   $0x7c
  jmp alltraps
801062f7:	e9 be f6 ff ff       	jmp    801059ba <alltraps>

801062fc <vector125>:
.globl vector125
vector125:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $125
801062fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106300:	e9 b5 f6 ff ff       	jmp    801059ba <alltraps>

80106305 <vector126>:
.globl vector126
vector126:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $126
80106307:	6a 7e                	push   $0x7e
  jmp alltraps
80106309:	e9 ac f6 ff ff       	jmp    801059ba <alltraps>

8010630e <vector127>:
.globl vector127
vector127:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $127
80106310:	6a 7f                	push   $0x7f
  jmp alltraps
80106312:	e9 a3 f6 ff ff       	jmp    801059ba <alltraps>

80106317 <vector128>:
.globl vector128
vector128:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $128
80106319:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010631e:	e9 97 f6 ff ff       	jmp    801059ba <alltraps>

80106323 <vector129>:
.globl vector129
vector129:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $129
80106325:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010632a:	e9 8b f6 ff ff       	jmp    801059ba <alltraps>

8010632f <vector130>:
.globl vector130
vector130:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $130
80106331:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106336:	e9 7f f6 ff ff       	jmp    801059ba <alltraps>

8010633b <vector131>:
.globl vector131
vector131:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $131
8010633d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106342:	e9 73 f6 ff ff       	jmp    801059ba <alltraps>

80106347 <vector132>:
.globl vector132
vector132:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $132
80106349:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010634e:	e9 67 f6 ff ff       	jmp    801059ba <alltraps>

80106353 <vector133>:
.globl vector133
vector133:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $133
80106355:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010635a:	e9 5b f6 ff ff       	jmp    801059ba <alltraps>

8010635f <vector134>:
.globl vector134
vector134:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $134
80106361:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106366:	e9 4f f6 ff ff       	jmp    801059ba <alltraps>

8010636b <vector135>:
.globl vector135
vector135:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $135
8010636d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106372:	e9 43 f6 ff ff       	jmp    801059ba <alltraps>

80106377 <vector136>:
.globl vector136
vector136:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $136
80106379:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010637e:	e9 37 f6 ff ff       	jmp    801059ba <alltraps>

80106383 <vector137>:
.globl vector137
vector137:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $137
80106385:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010638a:	e9 2b f6 ff ff       	jmp    801059ba <alltraps>

8010638f <vector138>:
.globl vector138
vector138:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $138
80106391:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106396:	e9 1f f6 ff ff       	jmp    801059ba <alltraps>

8010639b <vector139>:
.globl vector139
vector139:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $139
8010639d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063a2:	e9 13 f6 ff ff       	jmp    801059ba <alltraps>

801063a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $140
801063a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063ae:	e9 07 f6 ff ff       	jmp    801059ba <alltraps>

801063b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $141
801063b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801063ba:	e9 fb f5 ff ff       	jmp    801059ba <alltraps>

801063bf <vector142>:
.globl vector142
vector142:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $142
801063c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801063c6:	e9 ef f5 ff ff       	jmp    801059ba <alltraps>

801063cb <vector143>:
.globl vector143
vector143:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $143
801063cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063d2:	e9 e3 f5 ff ff       	jmp    801059ba <alltraps>

801063d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $144
801063d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063de:	e9 d7 f5 ff ff       	jmp    801059ba <alltraps>

801063e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $145
801063e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801063ea:	e9 cb f5 ff ff       	jmp    801059ba <alltraps>

801063ef <vector146>:
.globl vector146
vector146:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $146
801063f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801063f6:	e9 bf f5 ff ff       	jmp    801059ba <alltraps>

801063fb <vector147>:
.globl vector147
vector147:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $147
801063fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106402:	e9 b3 f5 ff ff       	jmp    801059ba <alltraps>

80106407 <vector148>:
.globl vector148
vector148:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $148
80106409:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010640e:	e9 a7 f5 ff ff       	jmp    801059ba <alltraps>

80106413 <vector149>:
.globl vector149
vector149:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $149
80106415:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010641a:	e9 9b f5 ff ff       	jmp    801059ba <alltraps>

8010641f <vector150>:
.globl vector150
vector150:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $150
80106421:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106426:	e9 8f f5 ff ff       	jmp    801059ba <alltraps>

8010642b <vector151>:
.globl vector151
vector151:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $151
8010642d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106432:	e9 83 f5 ff ff       	jmp    801059ba <alltraps>

80106437 <vector152>:
.globl vector152
vector152:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $152
80106439:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010643e:	e9 77 f5 ff ff       	jmp    801059ba <alltraps>

80106443 <vector153>:
.globl vector153
vector153:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $153
80106445:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010644a:	e9 6b f5 ff ff       	jmp    801059ba <alltraps>

8010644f <vector154>:
.globl vector154
vector154:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $154
80106451:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106456:	e9 5f f5 ff ff       	jmp    801059ba <alltraps>

8010645b <vector155>:
.globl vector155
vector155:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $155
8010645d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106462:	e9 53 f5 ff ff       	jmp    801059ba <alltraps>

80106467 <vector156>:
.globl vector156
vector156:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $156
80106469:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010646e:	e9 47 f5 ff ff       	jmp    801059ba <alltraps>

80106473 <vector157>:
.globl vector157
vector157:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $157
80106475:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010647a:	e9 3b f5 ff ff       	jmp    801059ba <alltraps>

8010647f <vector158>:
.globl vector158
vector158:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $158
80106481:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106486:	e9 2f f5 ff ff       	jmp    801059ba <alltraps>

8010648b <vector159>:
.globl vector159
vector159:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $159
8010648d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106492:	e9 23 f5 ff ff       	jmp    801059ba <alltraps>

80106497 <vector160>:
.globl vector160
vector160:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $160
80106499:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010649e:	e9 17 f5 ff ff       	jmp    801059ba <alltraps>

801064a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $161
801064a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064aa:	e9 0b f5 ff ff       	jmp    801059ba <alltraps>

801064af <vector162>:
.globl vector162
vector162:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $162
801064b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801064b6:	e9 ff f4 ff ff       	jmp    801059ba <alltraps>

801064bb <vector163>:
.globl vector163
vector163:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $163
801064bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801064c2:	e9 f3 f4 ff ff       	jmp    801059ba <alltraps>

801064c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $164
801064c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801064ce:	e9 e7 f4 ff ff       	jmp    801059ba <alltraps>

801064d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $165
801064d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064da:	e9 db f4 ff ff       	jmp    801059ba <alltraps>

801064df <vector166>:
.globl vector166
vector166:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $166
801064e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801064e6:	e9 cf f4 ff ff       	jmp    801059ba <alltraps>

801064eb <vector167>:
.globl vector167
vector167:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $167
801064ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801064f2:	e9 c3 f4 ff ff       	jmp    801059ba <alltraps>

801064f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $168
801064f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801064fe:	e9 b7 f4 ff ff       	jmp    801059ba <alltraps>

80106503 <vector169>:
.globl vector169
vector169:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $169
80106505:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010650a:	e9 ab f4 ff ff       	jmp    801059ba <alltraps>

8010650f <vector170>:
.globl vector170
vector170:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $170
80106511:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106516:	e9 9f f4 ff ff       	jmp    801059ba <alltraps>

8010651b <vector171>:
.globl vector171
vector171:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $171
8010651d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106522:	e9 93 f4 ff ff       	jmp    801059ba <alltraps>

80106527 <vector172>:
.globl vector172
vector172:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $172
80106529:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010652e:	e9 87 f4 ff ff       	jmp    801059ba <alltraps>

80106533 <vector173>:
.globl vector173
vector173:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $173
80106535:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010653a:	e9 7b f4 ff ff       	jmp    801059ba <alltraps>

8010653f <vector174>:
.globl vector174
vector174:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $174
80106541:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106546:	e9 6f f4 ff ff       	jmp    801059ba <alltraps>

8010654b <vector175>:
.globl vector175
vector175:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $175
8010654d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106552:	e9 63 f4 ff ff       	jmp    801059ba <alltraps>

80106557 <vector176>:
.globl vector176
vector176:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $176
80106559:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010655e:	e9 57 f4 ff ff       	jmp    801059ba <alltraps>

80106563 <vector177>:
.globl vector177
vector177:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $177
80106565:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010656a:	e9 4b f4 ff ff       	jmp    801059ba <alltraps>

8010656f <vector178>:
.globl vector178
vector178:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $178
80106571:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106576:	e9 3f f4 ff ff       	jmp    801059ba <alltraps>

8010657b <vector179>:
.globl vector179
vector179:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $179
8010657d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106582:	e9 33 f4 ff ff       	jmp    801059ba <alltraps>

80106587 <vector180>:
.globl vector180
vector180:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $180
80106589:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010658e:	e9 27 f4 ff ff       	jmp    801059ba <alltraps>

80106593 <vector181>:
.globl vector181
vector181:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $181
80106595:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010659a:	e9 1b f4 ff ff       	jmp    801059ba <alltraps>

8010659f <vector182>:
.globl vector182
vector182:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $182
801065a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065a6:	e9 0f f4 ff ff       	jmp    801059ba <alltraps>

801065ab <vector183>:
.globl vector183
vector183:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $183
801065ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801065b2:	e9 03 f4 ff ff       	jmp    801059ba <alltraps>

801065b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $184
801065b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801065be:	e9 f7 f3 ff ff       	jmp    801059ba <alltraps>

801065c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $185
801065c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801065ca:	e9 eb f3 ff ff       	jmp    801059ba <alltraps>

801065cf <vector186>:
.globl vector186
vector186:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $186
801065d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065d6:	e9 df f3 ff ff       	jmp    801059ba <alltraps>

801065db <vector187>:
.globl vector187
vector187:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $187
801065dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801065e2:	e9 d3 f3 ff ff       	jmp    801059ba <alltraps>

801065e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $188
801065e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801065ee:	e9 c7 f3 ff ff       	jmp    801059ba <alltraps>

801065f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $189
801065f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801065fa:	e9 bb f3 ff ff       	jmp    801059ba <alltraps>

801065ff <vector190>:
.globl vector190
vector190:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $190
80106601:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106606:	e9 af f3 ff ff       	jmp    801059ba <alltraps>

8010660b <vector191>:
.globl vector191
vector191:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $191
8010660d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106612:	e9 a3 f3 ff ff       	jmp    801059ba <alltraps>

80106617 <vector192>:
.globl vector192
vector192:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $192
80106619:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010661e:	e9 97 f3 ff ff       	jmp    801059ba <alltraps>

80106623 <vector193>:
.globl vector193
vector193:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $193
80106625:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010662a:	e9 8b f3 ff ff       	jmp    801059ba <alltraps>

8010662f <vector194>:
.globl vector194
vector194:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $194
80106631:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106636:	e9 7f f3 ff ff       	jmp    801059ba <alltraps>

8010663b <vector195>:
.globl vector195
vector195:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $195
8010663d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106642:	e9 73 f3 ff ff       	jmp    801059ba <alltraps>

80106647 <vector196>:
.globl vector196
vector196:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $196
80106649:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010664e:	e9 67 f3 ff ff       	jmp    801059ba <alltraps>

80106653 <vector197>:
.globl vector197
vector197:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $197
80106655:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010665a:	e9 5b f3 ff ff       	jmp    801059ba <alltraps>

8010665f <vector198>:
.globl vector198
vector198:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $198
80106661:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106666:	e9 4f f3 ff ff       	jmp    801059ba <alltraps>

8010666b <vector199>:
.globl vector199
vector199:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $199
8010666d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106672:	e9 43 f3 ff ff       	jmp    801059ba <alltraps>

80106677 <vector200>:
.globl vector200
vector200:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $200
80106679:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010667e:	e9 37 f3 ff ff       	jmp    801059ba <alltraps>

80106683 <vector201>:
.globl vector201
vector201:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $201
80106685:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010668a:	e9 2b f3 ff ff       	jmp    801059ba <alltraps>

8010668f <vector202>:
.globl vector202
vector202:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $202
80106691:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106696:	e9 1f f3 ff ff       	jmp    801059ba <alltraps>

8010669b <vector203>:
.globl vector203
vector203:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $203
8010669d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066a2:	e9 13 f3 ff ff       	jmp    801059ba <alltraps>

801066a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $204
801066a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066ae:	e9 07 f3 ff ff       	jmp    801059ba <alltraps>

801066b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $205
801066b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801066ba:	e9 fb f2 ff ff       	jmp    801059ba <alltraps>

801066bf <vector206>:
.globl vector206
vector206:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $206
801066c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801066c6:	e9 ef f2 ff ff       	jmp    801059ba <alltraps>

801066cb <vector207>:
.globl vector207
vector207:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $207
801066cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066d2:	e9 e3 f2 ff ff       	jmp    801059ba <alltraps>

801066d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $208
801066d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066de:	e9 d7 f2 ff ff       	jmp    801059ba <alltraps>

801066e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $209
801066e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801066ea:	e9 cb f2 ff ff       	jmp    801059ba <alltraps>

801066ef <vector210>:
.globl vector210
vector210:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $210
801066f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801066f6:	e9 bf f2 ff ff       	jmp    801059ba <alltraps>

801066fb <vector211>:
.globl vector211
vector211:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $211
801066fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106702:	e9 b3 f2 ff ff       	jmp    801059ba <alltraps>

80106707 <vector212>:
.globl vector212
vector212:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $212
80106709:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010670e:	e9 a7 f2 ff ff       	jmp    801059ba <alltraps>

80106713 <vector213>:
.globl vector213
vector213:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $213
80106715:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010671a:	e9 9b f2 ff ff       	jmp    801059ba <alltraps>

8010671f <vector214>:
.globl vector214
vector214:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $214
80106721:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106726:	e9 8f f2 ff ff       	jmp    801059ba <alltraps>

8010672b <vector215>:
.globl vector215
vector215:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $215
8010672d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106732:	e9 83 f2 ff ff       	jmp    801059ba <alltraps>

80106737 <vector216>:
.globl vector216
vector216:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $216
80106739:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010673e:	e9 77 f2 ff ff       	jmp    801059ba <alltraps>

80106743 <vector217>:
.globl vector217
vector217:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $217
80106745:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010674a:	e9 6b f2 ff ff       	jmp    801059ba <alltraps>

8010674f <vector218>:
.globl vector218
vector218:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $218
80106751:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106756:	e9 5f f2 ff ff       	jmp    801059ba <alltraps>

8010675b <vector219>:
.globl vector219
vector219:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $219
8010675d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106762:	e9 53 f2 ff ff       	jmp    801059ba <alltraps>

80106767 <vector220>:
.globl vector220
vector220:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $220
80106769:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010676e:	e9 47 f2 ff ff       	jmp    801059ba <alltraps>

80106773 <vector221>:
.globl vector221
vector221:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $221
80106775:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010677a:	e9 3b f2 ff ff       	jmp    801059ba <alltraps>

8010677f <vector222>:
.globl vector222
vector222:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $222
80106781:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106786:	e9 2f f2 ff ff       	jmp    801059ba <alltraps>

8010678b <vector223>:
.globl vector223
vector223:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $223
8010678d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106792:	e9 23 f2 ff ff       	jmp    801059ba <alltraps>

80106797 <vector224>:
.globl vector224
vector224:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $224
80106799:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010679e:	e9 17 f2 ff ff       	jmp    801059ba <alltraps>

801067a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $225
801067a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067aa:	e9 0b f2 ff ff       	jmp    801059ba <alltraps>

801067af <vector226>:
.globl vector226
vector226:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $226
801067b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801067b6:	e9 ff f1 ff ff       	jmp    801059ba <alltraps>

801067bb <vector227>:
.globl vector227
vector227:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $227
801067bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801067c2:	e9 f3 f1 ff ff       	jmp    801059ba <alltraps>

801067c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $228
801067c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801067ce:	e9 e7 f1 ff ff       	jmp    801059ba <alltraps>

801067d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $229
801067d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067da:	e9 db f1 ff ff       	jmp    801059ba <alltraps>

801067df <vector230>:
.globl vector230
vector230:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $230
801067e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801067e6:	e9 cf f1 ff ff       	jmp    801059ba <alltraps>

801067eb <vector231>:
.globl vector231
vector231:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $231
801067ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801067f2:	e9 c3 f1 ff ff       	jmp    801059ba <alltraps>

801067f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $232
801067f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801067fe:	e9 b7 f1 ff ff       	jmp    801059ba <alltraps>

80106803 <vector233>:
.globl vector233
vector233:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $233
80106805:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010680a:	e9 ab f1 ff ff       	jmp    801059ba <alltraps>

8010680f <vector234>:
.globl vector234
vector234:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $234
80106811:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106816:	e9 9f f1 ff ff       	jmp    801059ba <alltraps>

8010681b <vector235>:
.globl vector235
vector235:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $235
8010681d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106822:	e9 93 f1 ff ff       	jmp    801059ba <alltraps>

80106827 <vector236>:
.globl vector236
vector236:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $236
80106829:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010682e:	e9 87 f1 ff ff       	jmp    801059ba <alltraps>

80106833 <vector237>:
.globl vector237
vector237:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $237
80106835:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010683a:	e9 7b f1 ff ff       	jmp    801059ba <alltraps>

8010683f <vector238>:
.globl vector238
vector238:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $238
80106841:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106846:	e9 6f f1 ff ff       	jmp    801059ba <alltraps>

8010684b <vector239>:
.globl vector239
vector239:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $239
8010684d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106852:	e9 63 f1 ff ff       	jmp    801059ba <alltraps>

80106857 <vector240>:
.globl vector240
vector240:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $240
80106859:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010685e:	e9 57 f1 ff ff       	jmp    801059ba <alltraps>

80106863 <vector241>:
.globl vector241
vector241:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $241
80106865:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010686a:	e9 4b f1 ff ff       	jmp    801059ba <alltraps>

8010686f <vector242>:
.globl vector242
vector242:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $242
80106871:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106876:	e9 3f f1 ff ff       	jmp    801059ba <alltraps>

8010687b <vector243>:
.globl vector243
vector243:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $243
8010687d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106882:	e9 33 f1 ff ff       	jmp    801059ba <alltraps>

80106887 <vector244>:
.globl vector244
vector244:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $244
80106889:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010688e:	e9 27 f1 ff ff       	jmp    801059ba <alltraps>

80106893 <vector245>:
.globl vector245
vector245:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $245
80106895:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010689a:	e9 1b f1 ff ff       	jmp    801059ba <alltraps>

8010689f <vector246>:
.globl vector246
vector246:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $246
801068a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068a6:	e9 0f f1 ff ff       	jmp    801059ba <alltraps>

801068ab <vector247>:
.globl vector247
vector247:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $247
801068ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801068b2:	e9 03 f1 ff ff       	jmp    801059ba <alltraps>

801068b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $248
801068b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801068be:	e9 f7 f0 ff ff       	jmp    801059ba <alltraps>

801068c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $249
801068c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801068ca:	e9 eb f0 ff ff       	jmp    801059ba <alltraps>

801068cf <vector250>:
.globl vector250
vector250:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $250
801068d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068d6:	e9 df f0 ff ff       	jmp    801059ba <alltraps>

801068db <vector251>:
.globl vector251
vector251:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $251
801068dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801068e2:	e9 d3 f0 ff ff       	jmp    801059ba <alltraps>

801068e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $252
801068e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801068ee:	e9 c7 f0 ff ff       	jmp    801059ba <alltraps>

801068f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $253
801068f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801068fa:	e9 bb f0 ff ff       	jmp    801059ba <alltraps>

801068ff <vector254>:
.globl vector254
vector254:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $254
80106901:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106906:	e9 af f0 ff ff       	jmp    801059ba <alltraps>

8010690b <vector255>:
.globl vector255
vector255:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $255
8010690d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106912:	e9 a3 f0 ff ff       	jmp    801059ba <alltraps>
80106917:	66 90                	xchg   %ax,%ax
80106919:	66 90                	xchg   %ax,%ax
8010691b:	66 90                	xchg   %ax,%ax
8010691d:	66 90                	xchg   %ax,%ax
8010691f:	90                   	nop

80106920 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	57                   	push   %edi
80106924:	56                   	push   %esi
80106925:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106926:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010692c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106932:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106935:	39 d3                	cmp    %edx,%ebx
80106937:	73 56                	jae    8010698f <deallocuvm.part.0+0x6f>
80106939:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010693c:	89 c6                	mov    %eax,%esi
8010693e:	89 d7                	mov    %edx,%edi
80106940:	eb 12                	jmp    80106954 <deallocuvm.part.0+0x34>
80106942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106948:	83 c2 01             	add    $0x1,%edx
8010694b:	89 d3                	mov    %edx,%ebx
8010694d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106950:	39 fb                	cmp    %edi,%ebx
80106952:	73 38                	jae    8010698c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106954:	89 da                	mov    %ebx,%edx
80106956:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106959:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010695c:	a8 01                	test   $0x1,%al
8010695e:	74 e8                	je     80106948 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106960:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106962:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106967:	c1 e9 0a             	shr    $0xa,%ecx
8010696a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106970:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106977:	85 c0                	test   %eax,%eax
80106979:	74 cd                	je     80106948 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
8010697b:	8b 10                	mov    (%eax),%edx
8010697d:	f6 c2 01             	test   $0x1,%dl
80106980:	75 1e                	jne    801069a0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106982:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106988:	39 fb                	cmp    %edi,%ebx
8010698a:	72 c8                	jb     80106954 <deallocuvm.part.0+0x34>
8010698c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010698f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106992:	89 c8                	mov    %ecx,%eax
80106994:	5b                   	pop    %ebx
80106995:	5e                   	pop    %esi
80106996:	5f                   	pop    %edi
80106997:	5d                   	pop    %ebp
80106998:	c3                   	ret
80106999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801069a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801069a6:	74 26                	je     801069ce <deallocuvm.part.0+0xae>
      kfree(v);
801069a8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801069ab:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801069b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069b4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801069ba:	52                   	push   %edx
801069bb:	e8 60 bc ff ff       	call   80102620 <kfree>
      *pte = 0;
801069c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
801069c3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801069c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801069cc:	eb 82                	jmp    80106950 <deallocuvm.part.0+0x30>
        panic("kfree");
801069ce:	83 ec 0c             	sub    $0xc,%esp
801069d1:	68 fc 74 10 80       	push   $0x801074fc
801069d6:	e8 a5 99 ff ff       	call   80100380 <panic>
801069db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801069e0 <mappages>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	57                   	push   %edi
801069e4:	56                   	push   %esi
801069e5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801069e6:	89 d3                	mov    %edx,%ebx
801069e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801069ee:	83 ec 1c             	sub    $0x1c,%esp
801069f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801069f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a00:	8b 45 08             	mov    0x8(%ebp),%eax
80106a03:	29 d8                	sub    %ebx,%eax
80106a05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a08:	eb 3f                	jmp    80106a49 <mappages+0x69>
80106a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106a10:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a17:	c1 ea 0a             	shr    $0xa,%edx
80106a1a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a20:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a27:	85 c0                	test   %eax,%eax
80106a29:	74 75                	je     80106aa0 <mappages+0xc0>
    if(*pte & PTE_P)
80106a2b:	f6 00 01             	testb  $0x1,(%eax)
80106a2e:	0f 85 86 00 00 00    	jne    80106aba <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106a34:	0b 75 0c             	or     0xc(%ebp),%esi
80106a37:	83 ce 01             	or     $0x1,%esi
80106a3a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a3f:	39 c3                	cmp    %eax,%ebx
80106a41:	74 6d                	je     80106ab0 <mappages+0xd0>
    a += PGSIZE;
80106a43:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106a4c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106a4f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106a52:	89 d8                	mov    %ebx,%eax
80106a54:	c1 e8 16             	shr    $0x16,%eax
80106a57:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106a5a:	8b 07                	mov    (%edi),%eax
80106a5c:	a8 01                	test   $0x1,%al
80106a5e:	75 b0                	jne    80106a10 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a60:	e8 7b bd ff ff       	call   801027e0 <kalloc>
80106a65:	85 c0                	test   %eax,%eax
80106a67:	74 37                	je     80106aa0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106a69:	83 ec 04             	sub    $0x4,%esp
80106a6c:	68 00 10 00 00       	push   $0x1000
80106a71:	6a 00                	push   $0x0
80106a73:	50                   	push   %eax
80106a74:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106a77:	e8 a4 dd ff ff       	call   80104820 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a7c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106a7f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a82:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106a88:	83 c8 07             	or     $0x7,%eax
80106a8b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106a8d:	89 d8                	mov    %ebx,%eax
80106a8f:	c1 e8 0a             	shr    $0xa,%eax
80106a92:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a97:	01 d0                	add    %edx,%eax
80106a99:	eb 90                	jmp    80106a2b <mappages+0x4b>
80106a9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106aa8:	5b                   	pop    %ebx
80106aa9:	5e                   	pop    %esi
80106aaa:	5f                   	pop    %edi
80106aab:	5d                   	pop    %ebp
80106aac:	c3                   	ret
80106aad:	8d 76 00             	lea    0x0(%esi),%esi
80106ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ab3:	31 c0                	xor    %eax,%eax
}
80106ab5:	5b                   	pop    %ebx
80106ab6:	5e                   	pop    %esi
80106ab7:	5f                   	pop    %edi
80106ab8:	5d                   	pop    %ebp
80106ab9:	c3                   	ret
      panic("remap");
80106aba:	83 ec 0c             	sub    $0xc,%esp
80106abd:	68 29 77 10 80       	push   $0x80107729
80106ac2:	e8 b9 98 ff ff       	call   80100380 <panic>
80106ac7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ace:	00 
80106acf:	90                   	nop

80106ad0 <seginit>:
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ad6:	e8 e5 cf ff ff       	call   80103ac0 <cpuid>
  pd[0] = size-1;
80106adb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ae0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ae6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106aea:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106af1:	ff 00 00 
80106af4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106afb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106afe:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106b05:	ff 00 00 
80106b08:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106b0f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b12:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106b19:	ff 00 00 
80106b1c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106b23:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b26:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106b2d:	ff 00 00 
80106b30:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106b37:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b3a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106b3f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b43:	c1 e8 10             	shr    $0x10,%eax
80106b46:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b4a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b4d:	0f 01 10             	lgdtl  (%eax)
}
80106b50:	c9                   	leave
80106b51:	c3                   	ret
80106b52:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b59:	00 
80106b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b60 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b60:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106b65:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b6a:	0f 22 d8             	mov    %eax,%cr3
}
80106b6d:	c3                   	ret
80106b6e:	66 90                	xchg   %ax,%ax

80106b70 <switchuvm>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	83 ec 1c             	sub    $0x1c,%esp
80106b79:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b7c:	85 f6                	test   %esi,%esi
80106b7e:	0f 84 cb 00 00 00    	je     80106c4f <switchuvm+0xdf>
  if(p->kstack == 0)
80106b84:	8b 46 08             	mov    0x8(%esi),%eax
80106b87:	85 c0                	test   %eax,%eax
80106b89:	0f 84 da 00 00 00    	je     80106c69 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b8f:	8b 46 04             	mov    0x4(%esi),%eax
80106b92:	85 c0                	test   %eax,%eax
80106b94:	0f 84 c2 00 00 00    	je     80106c5c <switchuvm+0xec>
  pushcli();
80106b9a:	e8 31 da ff ff       	call   801045d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b9f:	e8 bc ce ff ff       	call   80103a60 <mycpu>
80106ba4:	89 c3                	mov    %eax,%ebx
80106ba6:	e8 b5 ce ff ff       	call   80103a60 <mycpu>
80106bab:	89 c7                	mov    %eax,%edi
80106bad:	e8 ae ce ff ff       	call   80103a60 <mycpu>
80106bb2:	83 c7 08             	add    $0x8,%edi
80106bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bb8:	e8 a3 ce ff ff       	call   80103a60 <mycpu>
80106bbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bc0:	ba 67 00 00 00       	mov    $0x67,%edx
80106bc5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106bcc:	83 c0 08             	add    $0x8,%eax
80106bcf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bd6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106bdb:	83 c1 08             	add    $0x8,%ecx
80106bde:	c1 e8 18             	shr    $0x18,%eax
80106be1:	c1 e9 10             	shr    $0x10,%ecx
80106be4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106bea:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106bf0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106bf5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bfc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c01:	e8 5a ce ff ff       	call   80103a60 <mycpu>
80106c06:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c0d:	e8 4e ce ff ff       	call   80103a60 <mycpu>
80106c12:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c16:	8b 5e 08             	mov    0x8(%esi),%ebx
80106c19:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c1f:	e8 3c ce ff ff       	call   80103a60 <mycpu>
80106c24:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c27:	e8 34 ce ff ff       	call   80103a60 <mycpu>
80106c2c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106c30:	b8 28 00 00 00       	mov    $0x28,%eax
80106c35:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c38:	8b 46 04             	mov    0x4(%esi),%eax
80106c3b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c40:	0f 22 d8             	mov    %eax,%cr3
}
80106c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c46:	5b                   	pop    %ebx
80106c47:	5e                   	pop    %esi
80106c48:	5f                   	pop    %edi
80106c49:	5d                   	pop    %ebp
  popcli();
80106c4a:	e9 d1 d9 ff ff       	jmp    80104620 <popcli>
    panic("switchuvm: no process");
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	68 2f 77 10 80       	push   $0x8010772f
80106c57:	e8 24 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106c5c:	83 ec 0c             	sub    $0xc,%esp
80106c5f:	68 5a 77 10 80       	push   $0x8010775a
80106c64:	e8 17 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106c69:	83 ec 0c             	sub    $0xc,%esp
80106c6c:	68 45 77 10 80       	push   $0x80107745
80106c71:	e8 0a 97 ff ff       	call   80100380 <panic>
80106c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c7d:	00 
80106c7e:	66 90                	xchg   %ax,%ax

80106c80 <inituvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 1c             	sub    $0x1c,%esp
80106c89:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8c:	8b 75 10             	mov    0x10(%ebp),%esi
80106c8f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106c92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c95:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c9b:	77 49                	ja     80106ce6 <inituvm+0x66>
  mem = kalloc();
80106c9d:	e8 3e bb ff ff       	call   801027e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106ca2:	83 ec 04             	sub    $0x4,%esp
80106ca5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106caa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106cac:	6a 00                	push   $0x0
80106cae:	50                   	push   %eax
80106caf:	e8 6c db ff ff       	call   80104820 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106cb4:	58                   	pop    %eax
80106cb5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cbb:	5a                   	pop    %edx
80106cbc:	6a 06                	push   $0x6
80106cbe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cc3:	31 d2                	xor    %edx,%edx
80106cc5:	50                   	push   %eax
80106cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cc9:	e8 12 fd ff ff       	call   801069e0 <mappages>
  memmove(mem, init, sz);
80106cce:	89 75 10             	mov    %esi,0x10(%ebp)
80106cd1:	83 c4 10             	add    $0x10,%esp
80106cd4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106cd7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cdd:	5b                   	pop    %ebx
80106cde:	5e                   	pop    %esi
80106cdf:	5f                   	pop    %edi
80106ce0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ce1:	e9 ca db ff ff       	jmp    801048b0 <memmove>
    panic("inituvm: more than a page");
80106ce6:	83 ec 0c             	sub    $0xc,%esp
80106ce9:	68 6e 77 10 80       	push   $0x8010776e
80106cee:	e8 8d 96 ff ff       	call   80100380 <panic>
80106cf3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106cfa:	00 
80106cfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106d00 <loaduvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106d09:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106d0c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106d0f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106d15:	0f 85 a2 00 00 00    	jne    80106dbd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106d1b:	85 ff                	test   %edi,%edi
80106d1d:	74 7d                	je     80106d9c <loaduvm+0x9c>
80106d1f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106d23:	8b 55 08             	mov    0x8(%ebp),%edx
80106d26:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106d28:	89 c1                	mov    %eax,%ecx
80106d2a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106d2d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106d30:	f6 c1 01             	test   $0x1,%cl
80106d33:	75 13                	jne    80106d48 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106d35:	83 ec 0c             	sub    $0xc,%esp
80106d38:	68 88 77 10 80       	push   $0x80107788
80106d3d:	e8 3e 96 ff ff       	call   80100380 <panic>
80106d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d48:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d4b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d51:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d56:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d5d:	85 c9                	test   %ecx,%ecx
80106d5f:	74 d4                	je     80106d35 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106d61:	89 fb                	mov    %edi,%ebx
80106d63:	b8 00 10 00 00       	mov    $0x1000,%eax
80106d68:	29 f3                	sub    %esi,%ebx
80106d6a:	39 c3                	cmp    %eax,%ebx
80106d6c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d6f:	53                   	push   %ebx
80106d70:	8b 45 14             	mov    0x14(%ebp),%eax
80106d73:	01 f0                	add    %esi,%eax
80106d75:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106d76:	8b 01                	mov    (%ecx),%eax
80106d78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d7d:	05 00 00 00 80       	add    $0x80000000,%eax
80106d82:	50                   	push   %eax
80106d83:	ff 75 10             	push   0x10(%ebp)
80106d86:	e8 a5 ae ff ff       	call   80101c30 <readi>
80106d8b:	83 c4 10             	add    $0x10,%esp
80106d8e:	39 d8                	cmp    %ebx,%eax
80106d90:	75 1e                	jne    80106db0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106d92:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d98:	39 fe                	cmp    %edi,%esi
80106d9a:	72 84                	jb     80106d20 <loaduvm+0x20>
}
80106d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d9f:	31 c0                	xor    %eax,%eax
}
80106da1:	5b                   	pop    %ebx
80106da2:	5e                   	pop    %esi
80106da3:	5f                   	pop    %edi
80106da4:	5d                   	pop    %ebp
80106da5:	c3                   	ret
80106da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dad:	00 
80106dae:	66 90                	xchg   %ax,%ax
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106db3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106db8:	5b                   	pop    %ebx
80106db9:	5e                   	pop    %esi
80106dba:	5f                   	pop    %edi
80106dbb:	5d                   	pop    %ebp
80106dbc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106dbd:	83 ec 0c             	sub    $0xc,%esp
80106dc0:	68 0c 7a 10 80       	push   $0x80107a0c
80106dc5:	e8 b6 95 ff ff       	call   80100380 <panic>
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dd0 <allocuvm>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106ddc:	85 f6                	test   %esi,%esi
80106dde:	0f 88 98 00 00 00    	js     80106e7c <allocuvm+0xac>
80106de4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106de6:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106de9:	0f 82 a1 00 00 00    	jb     80106e90 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106def:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df2:	05 ff 0f 00 00       	add    $0xfff,%eax
80106df7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dfc:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106dfe:	39 f0                	cmp    %esi,%eax
80106e00:	0f 83 8d 00 00 00    	jae    80106e93 <allocuvm+0xc3>
80106e06:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106e09:	eb 44                	jmp    80106e4f <allocuvm+0x7f>
80106e0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106e10:	83 ec 04             	sub    $0x4,%esp
80106e13:	68 00 10 00 00       	push   $0x1000
80106e18:	6a 00                	push   $0x0
80106e1a:	50                   	push   %eax
80106e1b:	e8 00 da ff ff       	call   80104820 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e20:	58                   	pop    %eax
80106e21:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e27:	5a                   	pop    %edx
80106e28:	6a 06                	push   $0x6
80106e2a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e2f:	89 fa                	mov    %edi,%edx
80106e31:	50                   	push   %eax
80106e32:	8b 45 08             	mov    0x8(%ebp),%eax
80106e35:	e8 a6 fb ff ff       	call   801069e0 <mappages>
80106e3a:	83 c4 10             	add    $0x10,%esp
80106e3d:	85 c0                	test   %eax,%eax
80106e3f:	78 5f                	js     80106ea0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106e41:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e47:	39 f7                	cmp    %esi,%edi
80106e49:	0f 83 89 00 00 00    	jae    80106ed8 <allocuvm+0x108>
    mem = kalloc();
80106e4f:	e8 8c b9 ff ff       	call   801027e0 <kalloc>
80106e54:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106e56:	85 c0                	test   %eax,%eax
80106e58:	75 b6                	jne    80106e10 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106e5a:	83 ec 0c             	sub    $0xc,%esp
80106e5d:	68 a6 77 10 80       	push   $0x801077a6
80106e62:	e8 49 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e67:	83 c4 10             	add    $0x10,%esp
80106e6a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106e6d:	74 0d                	je     80106e7c <allocuvm+0xac>
80106e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e72:	8b 45 08             	mov    0x8(%ebp),%eax
80106e75:	89 f2                	mov    %esi,%edx
80106e77:	e8 a4 fa ff ff       	call   80106920 <deallocuvm.part.0>
    return 0;
80106e7c:	31 d2                	xor    %edx,%edx
}
80106e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e81:	89 d0                	mov    %edx,%eax
80106e83:	5b                   	pop    %ebx
80106e84:	5e                   	pop    %esi
80106e85:	5f                   	pop    %edi
80106e86:	5d                   	pop    %ebp
80106e87:	c3                   	ret
80106e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e8f:	00 
    return oldsz;
80106e90:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e96:	89 d0                	mov    %edx,%eax
80106e98:	5b                   	pop    %ebx
80106e99:	5e                   	pop    %esi
80106e9a:	5f                   	pop    %edi
80106e9b:	5d                   	pop    %ebp
80106e9c:	c3                   	ret
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ea0:	83 ec 0c             	sub    $0xc,%esp
80106ea3:	68 be 77 10 80       	push   $0x801077be
80106ea8:	e8 03 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106ead:	83 c4 10             	add    $0x10,%esp
80106eb0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106eb3:	74 0d                	je     80106ec2 <allocuvm+0xf2>
80106eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80106ebb:	89 f2                	mov    %esi,%edx
80106ebd:	e8 5e fa ff ff       	call   80106920 <deallocuvm.part.0>
      kfree(mem);
80106ec2:	83 ec 0c             	sub    $0xc,%esp
80106ec5:	53                   	push   %ebx
80106ec6:	e8 55 b7 ff ff       	call   80102620 <kfree>
      return 0;
80106ecb:	83 c4 10             	add    $0x10,%esp
    return 0;
80106ece:	31 d2                	xor    %edx,%edx
80106ed0:	eb ac                	jmp    80106e7e <allocuvm+0xae>
80106ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ede:	5b                   	pop    %ebx
80106edf:	5e                   	pop    %esi
80106ee0:	89 d0                	mov    %edx,%eax
80106ee2:	5f                   	pop    %edi
80106ee3:	5d                   	pop    %ebp
80106ee4:	c3                   	ret
80106ee5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106eec:	00 
80106eed:	8d 76 00             	lea    0x0(%esi),%esi

80106ef0 <deallocuvm>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ef6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106efc:	39 d1                	cmp    %edx,%ecx
80106efe:	73 10                	jae    80106f10 <deallocuvm+0x20>
}
80106f00:	5d                   	pop    %ebp
80106f01:	e9 1a fa ff ff       	jmp    80106920 <deallocuvm.part.0>
80106f06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f0d:	00 
80106f0e:	66 90                	xchg   %ax,%ax
80106f10:	89 d0                	mov    %edx,%eax
80106f12:	5d                   	pop    %ebp
80106f13:	c3                   	ret
80106f14:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f1b:	00 
80106f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 0c             	sub    $0xc,%esp
80106f29:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f2c:	85 f6                	test   %esi,%esi
80106f2e:	74 59                	je     80106f89 <freevm+0x69>
  if(newsz >= oldsz)
80106f30:	31 c9                	xor    %ecx,%ecx
80106f32:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f37:	89 f0                	mov    %esi,%eax
80106f39:	89 f3                	mov    %esi,%ebx
80106f3b:	e8 e0 f9 ff ff       	call   80106920 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f40:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f46:	eb 0f                	jmp    80106f57 <freevm+0x37>
80106f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f4f:	00 
80106f50:	83 c3 04             	add    $0x4,%ebx
80106f53:	39 fb                	cmp    %edi,%ebx
80106f55:	74 23                	je     80106f7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f57:	8b 03                	mov    (%ebx),%eax
80106f59:	a8 01                	test   $0x1,%al
80106f5b:	74 f3                	je     80106f50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f62:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f65:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f68:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f6d:	50                   	push   %eax
80106f6e:	e8 ad b6 ff ff       	call   80102620 <kfree>
80106f73:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f76:	39 fb                	cmp    %edi,%ebx
80106f78:	75 dd                	jne    80106f57 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f80:	5b                   	pop    %ebx
80106f81:	5e                   	pop    %esi
80106f82:	5f                   	pop    %edi
80106f83:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f84:	e9 97 b6 ff ff       	jmp    80102620 <kfree>
    panic("freevm: no pgdir");
80106f89:	83 ec 0c             	sub    $0xc,%esp
80106f8c:	68 da 77 10 80       	push   $0x801077da
80106f91:	e8 ea 93 ff ff       	call   80100380 <panic>
80106f96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f9d:	00 
80106f9e:	66 90                	xchg   %ax,%ax

80106fa0 <setupkvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	56                   	push   %esi
80106fa4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106fa5:	e8 36 b8 ff ff       	call   801027e0 <kalloc>
80106faa:	85 c0                	test   %eax,%eax
80106fac:	74 5e                	je     8010700c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106fae:	83 ec 04             	sub    $0x4,%esp
80106fb1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fb3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106fb8:	68 00 10 00 00       	push   $0x1000
80106fbd:	6a 00                	push   $0x0
80106fbf:	50                   	push   %eax
80106fc0:	e8 5b d8 ff ff       	call   80104820 <memset>
80106fc5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106fc8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106fcb:	83 ec 08             	sub    $0x8,%esp
80106fce:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106fd1:	8b 13                	mov    (%ebx),%edx
80106fd3:	ff 73 0c             	push   0xc(%ebx)
80106fd6:	50                   	push   %eax
80106fd7:	29 c1                	sub    %eax,%ecx
80106fd9:	89 f0                	mov    %esi,%eax
80106fdb:	e8 00 fa ff ff       	call   801069e0 <mappages>
80106fe0:	83 c4 10             	add    $0x10,%esp
80106fe3:	85 c0                	test   %eax,%eax
80106fe5:	78 19                	js     80107000 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fe7:	83 c3 10             	add    $0x10,%ebx
80106fea:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ff0:	75 d6                	jne    80106fc8 <setupkvm+0x28>
}
80106ff2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ff5:	89 f0                	mov    %esi,%eax
80106ff7:	5b                   	pop    %ebx
80106ff8:	5e                   	pop    %esi
80106ff9:	5d                   	pop    %ebp
80106ffa:	c3                   	ret
80106ffb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107000:	83 ec 0c             	sub    $0xc,%esp
80107003:	56                   	push   %esi
80107004:	e8 17 ff ff ff       	call   80106f20 <freevm>
      return 0;
80107009:	83 c4 10             	add    $0x10,%esp
}
8010700c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010700f:	31 f6                	xor    %esi,%esi
}
80107011:	89 f0                	mov    %esi,%eax
80107013:	5b                   	pop    %ebx
80107014:	5e                   	pop    %esi
80107015:	5d                   	pop    %ebp
80107016:	c3                   	ret
80107017:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010701e:	00 
8010701f:	90                   	nop

80107020 <kvmalloc>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107026:	e8 75 ff ff ff       	call   80106fa0 <setupkvm>
8010702b:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107030:	05 00 00 00 80       	add    $0x80000000,%eax
80107035:	0f 22 d8             	mov    %eax,%cr3
}
80107038:	c9                   	leave
80107039:	c3                   	ret
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107040 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	83 ec 08             	sub    $0x8,%esp
80107046:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107049:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010704c:	89 c1                	mov    %eax,%ecx
8010704e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107051:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107054:	f6 c2 01             	test   $0x1,%dl
80107057:	75 17                	jne    80107070 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107059:	83 ec 0c             	sub    $0xc,%esp
8010705c:	68 eb 77 10 80       	push   $0x801077eb
80107061:	e8 1a 93 ff ff       	call   80100380 <panic>
80107066:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010706d:	00 
8010706e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107070:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107073:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107079:	25 fc 0f 00 00       	and    $0xffc,%eax
8010707e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107085:	85 c0                	test   %eax,%eax
80107087:	74 d0                	je     80107059 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107089:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010708c:	c9                   	leave
8010708d:	c3                   	ret
8010708e:	66 90                	xchg   %ax,%ax

80107090 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
80107096:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107099:	e8 02 ff ff ff       	call   80106fa0 <setupkvm>
8010709e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070a1:	85 c0                	test   %eax,%eax
801070a3:	0f 84 e9 00 00 00    	je     80107192 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070ac:	85 c9                	test   %ecx,%ecx
801070ae:	0f 84 b2 00 00 00    	je     80107166 <copyuvm+0xd6>
801070b4:	31 f6                	xor    %esi,%esi
801070b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070bd:	00 
801070be:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801070c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801070c3:	89 f0                	mov    %esi,%eax
801070c5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070c8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801070cb:	a8 01                	test   $0x1,%al
801070cd:	75 11                	jne    801070e0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801070cf:	83 ec 0c             	sub    $0xc,%esp
801070d2:	68 f5 77 10 80       	push   $0x801077f5
801070d7:	e8 a4 92 ff ff       	call   80100380 <panic>
801070dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801070e0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070e7:	c1 ea 0a             	shr    $0xa,%edx
801070ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070f7:	85 c0                	test   %eax,%eax
801070f9:	74 d4                	je     801070cf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801070fb:	8b 00                	mov    (%eax),%eax
801070fd:	a8 01                	test   $0x1,%al
801070ff:	0f 84 9f 00 00 00    	je     801071a4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107105:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107107:	25 ff 0f 00 00       	and    $0xfff,%eax
8010710c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010710f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107115:	e8 c6 b6 ff ff       	call   801027e0 <kalloc>
8010711a:	89 c3                	mov    %eax,%ebx
8010711c:	85 c0                	test   %eax,%eax
8010711e:	74 64                	je     80107184 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107120:	83 ec 04             	sub    $0x4,%esp
80107123:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107129:	68 00 10 00 00       	push   $0x1000
8010712e:	57                   	push   %edi
8010712f:	50                   	push   %eax
80107130:	e8 7b d7 ff ff       	call   801048b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107135:	58                   	pop    %eax
80107136:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010713c:	5a                   	pop    %edx
8010713d:	ff 75 e4             	push   -0x1c(%ebp)
80107140:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107145:	89 f2                	mov    %esi,%edx
80107147:	50                   	push   %eax
80107148:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010714b:	e8 90 f8 ff ff       	call   801069e0 <mappages>
80107150:	83 c4 10             	add    $0x10,%esp
80107153:	85 c0                	test   %eax,%eax
80107155:	78 21                	js     80107178 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107157:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010715d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107160:	0f 82 5a ff ff ff    	jb     801070c0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107166:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107169:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010716c:	5b                   	pop    %ebx
8010716d:	5e                   	pop    %esi
8010716e:	5f                   	pop    %edi
8010716f:	5d                   	pop    %ebp
80107170:	c3                   	ret
80107171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107178:	83 ec 0c             	sub    $0xc,%esp
8010717b:	53                   	push   %ebx
8010717c:	e8 9f b4 ff ff       	call   80102620 <kfree>
      goto bad;
80107181:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107184:	83 ec 0c             	sub    $0xc,%esp
80107187:	ff 75 e0             	push   -0x20(%ebp)
8010718a:	e8 91 fd ff ff       	call   80106f20 <freevm>
  return 0;
8010718f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107192:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107199:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010719c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010719f:	5b                   	pop    %ebx
801071a0:	5e                   	pop    %esi
801071a1:	5f                   	pop    %edi
801071a2:	5d                   	pop    %ebp
801071a3:	c3                   	ret
      panic("copyuvm: page not present");
801071a4:	83 ec 0c             	sub    $0xc,%esp
801071a7:	68 0f 78 10 80       	push   $0x8010780f
801071ac:	e8 cf 91 ff ff       	call   80100380 <panic>
801071b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071b8:	00 
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071c6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071c9:	89 c1                	mov    %eax,%ecx
801071cb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071ce:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071d1:	f6 c2 01             	test   $0x1,%dl
801071d4:	0f 84 f8 00 00 00    	je     801072d2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801071da:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071dd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071e3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801071e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801071e9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071f0:	89 d0                	mov    %edx,%eax
801071f2:	f7 d2                	not    %edx
801071f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071f9:	05 00 00 00 80       	add    $0x80000000,%eax
801071fe:	83 e2 05             	and    $0x5,%edx
80107201:	ba 00 00 00 00       	mov    $0x0,%edx
80107206:	0f 45 c2             	cmovne %edx,%eax
}
80107209:	c3                   	ret
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107210 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 0c             	sub    $0xc,%esp
80107219:	8b 75 14             	mov    0x14(%ebp),%esi
8010721c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010721f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107222:	85 f6                	test   %esi,%esi
80107224:	75 51                	jne    80107277 <copyout+0x67>
80107226:	e9 9d 00 00 00       	jmp    801072c8 <copyout+0xb8>
8010722b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107230:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107236:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010723c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107242:	74 74                	je     801072b8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107244:	89 fb                	mov    %edi,%ebx
80107246:	29 c3                	sub    %eax,%ebx
80107248:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010724e:	39 f3                	cmp    %esi,%ebx
80107250:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107253:	29 f8                	sub    %edi,%eax
80107255:	83 ec 04             	sub    $0x4,%esp
80107258:	01 c1                	add    %eax,%ecx
8010725a:	53                   	push   %ebx
8010725b:	52                   	push   %edx
8010725c:	89 55 10             	mov    %edx,0x10(%ebp)
8010725f:	51                   	push   %ecx
80107260:	e8 4b d6 ff ff       	call   801048b0 <memmove>
    len -= n;
    buf += n;
80107265:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107268:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010726e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107271:	01 da                	add    %ebx,%edx
  while(len > 0){
80107273:	29 de                	sub    %ebx,%esi
80107275:	74 51                	je     801072c8 <copyout+0xb8>
  if(*pde & PTE_P){
80107277:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010727a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010727c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010727e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107281:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107287:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010728a:	f6 c1 01             	test   $0x1,%cl
8010728d:	0f 84 46 00 00 00    	je     801072d9 <copyout.cold>
  return &pgtab[PTX(va)];
80107293:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107295:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010729b:	c1 eb 0c             	shr    $0xc,%ebx
8010729e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801072a4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801072ab:	89 d9                	mov    %ebx,%ecx
801072ad:	f7 d1                	not    %ecx
801072af:	83 e1 05             	and    $0x5,%ecx
801072b2:	0f 84 78 ff ff ff    	je     80107230 <copyout+0x20>
  }
  return 0;
}
801072b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072c0:	5b                   	pop    %ebx
801072c1:	5e                   	pop    %esi
801072c2:	5f                   	pop    %edi
801072c3:	5d                   	pop    %ebp
801072c4:	c3                   	ret
801072c5:	8d 76 00             	lea    0x0(%esi),%esi
801072c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072cb:	31 c0                	xor    %eax,%eax
}
801072cd:	5b                   	pop    %ebx
801072ce:	5e                   	pop    %esi
801072cf:	5f                   	pop    %edi
801072d0:	5d                   	pop    %ebp
801072d1:	c3                   	ret

801072d2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801072d2:	a1 00 00 00 00       	mov    0x0,%eax
801072d7:	0f 0b                	ud2

801072d9 <copyout.cold>:
801072d9:	a1 00 00 00 00       	mov    0x0,%eax
801072de:	0f 0b                	ud2
