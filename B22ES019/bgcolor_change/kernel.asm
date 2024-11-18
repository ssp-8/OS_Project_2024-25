
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
8010002d:	b8 80 30 10 80       	mov    $0x80103080,%eax
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
8010004c:	68 c0 71 10 80       	push   $0x801071c0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 a5 43 00 00       	call   80104400 <initlock>
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
80100092:	68 c7 71 10 80       	push   $0x801071c7
80100097:	50                   	push   %eax
80100098:	e8 33 42 00 00       	call   801042d0 <initsleeplock>
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
801000e4:	e8 07 45 00 00       	call   801045f0 <acquire>
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
80100162:	e8 29 44 00 00       	call   80104590 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 41 00 00       	call   80104310 <acquiresleep>
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
8010018c:	e8 8f 21 00 00       	call   80102320 <iderw>
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
801001a1:	68 ce 71 10 80       	push   $0x801071ce
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
801001be:	e8 ed 41 00 00       	call   801043b0 <holdingsleep>
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
801001d4:	e9 47 21 00 00       	jmp    80102320 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 71 10 80       	push   $0x801071df
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
801001ff:	e8 ac 41 00 00       	call   801043b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 41 00 00       	call   80104370 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 d0 43 00 00       	call   801045f0 <acquire>
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
80100269:	e9 22 43 00 00       	jmp    80104590 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 e6 71 10 80       	push   $0x801071e6
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
80100294:	e8 37 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 4b 43 00 00       	call   801045f0 <acquire>
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
801002cd:	e8 9e 3d 00 00       	call   80104070 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 36 00 00       	call   801039b0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 95 42 00 00       	call   80104590 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 ec 14 00 00       	call   801017f0 <ilock>
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
8010034c:	e8 3f 42 00 00       	call   80104590 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 96 14 00 00       	call   801017f0 <ilock>
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
80100399:	e8 82 25 00 00       	call   80102920 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 71 10 80       	push   $0x801071ed
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 47 72 10 80 	movl   $0x80107247,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 40 00 00       	call   80104420 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 72 10 80       	push   $0x80107201
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
8010041f:	e8 dc 58 00 00       	call   80105d00 <uartputc>
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
    crt[pos++] = (c & 0xff) | bg_color;
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	66 0b 1d 00 80 10 80 	or     0x80108000,%bx
801004d2:	8d 70 01             	lea    0x1(%eax),%esi
801004d5:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004dc:	80 
801004dd:	eb 86                	jmp    80100465 <consputc.part.0+0x65>
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 11 58 00 00       	call   80105d00 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 05 58 00 00       	call   80105d00 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 f9 57 00 00       	call   80105d00 <uartputc>
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
80100561:	e8 1a 42 00 00       	call   80104780 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 75 41 00 00       	call   801046f0 <memset>
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
801005a3:	68 05 72 10 80       	push   $0x80107205
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
801005bf:	e8 0c 13 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 20 40 00 00       	call   801045f0 <acquire>
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
80100604:	e8 87 3f 00 00       	call   80104590 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 de 11 00 00       	call   801017f0 <ilock>

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
8010064b:	0f b6 92 dc 76 10 80 	movzbl -0x7fef8924(%edx),%edx
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
801007d8:	e8 13 3e 00 00       	call   801045f0 <acquire>
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
801007fb:	e8 90 3d 00 00       	call   80104590 <release>
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
8010083d:	bf 18 72 10 80       	mov    $0x80107218,%edi
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
8010088c:	68 1f 72 10 80       	push   $0x8010721f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
    int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&cons.lock);
801008ae:	68 20 ef 10 80       	push   $0x8010ef20
801008b3:	e8 38 3d 00 00       	call   801045f0 <acquire>
    while ((c = getc()) >= 0) {
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	0f 88 39 01 00 00    	js     80100a00 <consoleintr+0x160>
        switch (c) {
801008c7:	83 fb 10             	cmp    $0x10,%ebx
801008ca:	0f 84 50 01 00 00    	je     80100a20 <consoleintr+0x180>
801008d0:	7f 7e                	jg     80100950 <consoleintr+0xb0>
801008d2:	83 fb 02             	cmp    $0x2,%ebx
801008d5:	0f 84 fd 00 00 00    	je     801009d8 <consoleintr+0x138>
801008db:	83 fb 08             	cmp    $0x8,%ebx
801008de:	74 7e                	je     8010095e <consoleintr+0xbe>
            if (c != 0 && input.e - input.r < INPUT_BUF) {
801008e0:	85 db                	test   %ebx,%ebx
801008e2:	74 d7                	je     801008bb <consoleintr+0x1b>
801008e4:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008e9:	89 c2                	mov    %eax,%edx
801008eb:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008f1:	83 fa 7f             	cmp    $0x7f,%edx
801008f4:	77 c5                	ja     801008bb <consoleintr+0x1b>
                input.buf[input.e++ % INPUT_BUF] = c;
801008f6:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801008f9:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
                input.buf[input.e++ % INPUT_BUF] = c;
801008ff:	83 e0 7f             	and    $0x7f,%eax
                c = (c == '\r') ? '\n' : c;
80100902:	83 fb 0d             	cmp    $0xd,%ebx
80100905:	0f 85 41 01 00 00    	jne    80100a4c <consoleintr+0x1ac>
                input.buf[input.e++ % INPUT_BUF] = c;
8010090b:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100911:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100918:	85 c9                	test   %ecx,%ecx
8010091a:	0f 85 7d 01 00 00    	jne    80100a9d <consoleintr+0x1fd>
80100920:	b8 0a 00 00 00       	mov    $0xa,%eax
80100925:	e8 d6 fa ff ff       	call   80100400 <consputc.part.0>
                    input.w = input.e;
8010092a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
                    wakeup(&input.r);
8010092f:	83 ec 0c             	sub    $0xc,%esp
                    input.w = input.e;
80100932:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
                    wakeup(&input.r);
80100937:	68 00 ef 10 80       	push   $0x8010ef00
8010093c:	e8 ef 37 00 00       	call   80104130 <wakeup>
80100941:	83 c4 10             	add    $0x10,%esp
80100944:	e9 72 ff ff ff       	jmp    801008bb <consoleintr+0x1b>
80100949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        switch (c) {
80100950:	83 fb 15             	cmp    $0x15,%ebx
80100953:	74 45                	je     8010099a <consoleintr+0xfa>
80100955:	83 fb 7f             	cmp    $0x7f,%ebx
80100958:	0f 85 cc 00 00 00    	jne    80100a2a <consoleintr+0x18a>
            if (input.e != input.w) {
8010095e:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100963:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100969:	0f 84 4c ff ff ff    	je     801008bb <consoleintr+0x1b>
                input.e--;
8010096f:	83 e8 01             	sub    $0x1,%eax
80100972:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100977:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010097c:	85 c0                	test   %eax,%eax
8010097e:	0f 84 0a 01 00 00    	je     80100a8e <consoleintr+0x1ee>
80100984:	fa                   	cli
    for(;;)
80100985:	eb fe                	jmp    80100985 <consoleintr+0xe5>
80100987:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010098e:	00 
8010098f:	90                   	nop
80100990:	b8 00 01 00 00       	mov    $0x100,%eax
80100995:	e8 66 fa ff ff       	call   80100400 <consputc.part.0>
            while (input.e != input.w &&
8010099a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010099f:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009a5:	0f 84 10 ff ff ff    	je     801008bb <consoleintr+0x1b>
                   input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
801009ab:	83 e8 01             	sub    $0x1,%eax
801009ae:	89 c2                	mov    %eax,%edx
801009b0:	83 e2 7f             	and    $0x7f,%edx
            while (input.e != input.w &&
801009b3:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801009ba:	0f 84 fb fe ff ff    	je     801008bb <consoleintr+0x1b>
  if(panicked){
801009c0:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
                input.e--;
801009c6:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009cb:	85 d2                	test   %edx,%edx
801009cd:	74 c1                	je     80100990 <consoleintr+0xf0>
801009cf:	fa                   	cli
    for(;;)
801009d0:	eb fe                	jmp    801009d0 <consoleintr+0x130>
801009d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            bg_color = (bg_color == 0x0700) ? 0x1000 : 0x0700; // Toggle black/blue
801009d8:	81 3d 00 80 10 80 00 	cmpl   $0x700,0x80108000
801009df:	07 00 00 
801009e2:	ba 00 10 00 00       	mov    $0x1000,%edx
801009e7:	b8 00 07 00 00       	mov    $0x700,%eax
801009ec:	0f 44 c2             	cmove  %edx,%eax
801009ef:	a3 00 80 10 80       	mov    %eax,0x80108000
    while ((c = getc()) >= 0) {
801009f4:	ff d6                	call   *%esi
801009f6:	89 c3                	mov    %eax,%ebx
801009f8:	85 c0                	test   %eax,%eax
801009fa:	0f 89 c7 fe ff ff    	jns    801008c7 <consoleintr+0x27>
    release(&cons.lock);
80100a00:	83 ec 0c             	sub    $0xc,%esp
80100a03:	68 20 ef 10 80       	push   $0x8010ef20
80100a08:	e8 83 3b 00 00       	call   80104590 <release>
    if (doprocdump) {
80100a0d:	83 c4 10             	add    $0x10,%esp
80100a10:	85 ff                	test   %edi,%edi
80100a12:	0f 85 88 00 00 00    	jne    80100aa0 <consoleintr+0x200>
}
80100a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1b:	5b                   	pop    %ebx
80100a1c:	5e                   	pop    %esi
80100a1d:	5f                   	pop    %edi
80100a1e:	5d                   	pop    %ebp
80100a1f:	c3                   	ret
        switch (c) {
80100a20:	bf 01 00 00 00       	mov    $0x1,%edi
80100a25:	e9 91 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
            if (c != 0 && input.e - input.r < INPUT_BUF) {
80100a2a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a2f:	89 c2                	mov    %eax,%edx
80100a31:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a37:	83 fa 7f             	cmp    $0x7f,%edx
80100a3a:	0f 87 7b fe ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100a40:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
                input.buf[input.e++ % INPUT_BUF] = c;
80100a46:	8d 50 01             	lea    0x1(%eax),%edx
80100a49:	83 e0 7f             	and    $0x7f,%eax
80100a4c:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a52:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100a58:	85 c9                	test   %ecx,%ecx
80100a5a:	75 41                	jne    80100a9d <consoleintr+0x1fd>
80100a5c:	89 d8                	mov    %ebx,%eax
80100a5e:	e8 9d f9 ff ff       	call   80100400 <consputc.part.0>
                if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
80100a63:	83 fb 0a             	cmp    $0xa,%ebx
80100a66:	0f 84 be fe ff ff    	je     8010092a <consoleintr+0x8a>
80100a6c:	83 fb 04             	cmp    $0x4,%ebx
80100a6f:	0f 84 b5 fe ff ff    	je     8010092a <consoleintr+0x8a>
80100a75:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100a7a:	83 e8 80             	sub    $0xffffff80,%eax
80100a7d:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100a83:	0f 85 32 fe ff ff    	jne    801008bb <consoleintr+0x1b>
80100a89:	e9 a1 fe ff ff       	jmp    8010092f <consoleintr+0x8f>
80100a8e:	b8 00 01 00 00       	mov    $0x100,%eax
80100a93:	e8 68 f9 ff ff       	call   80100400 <consputc.part.0>
80100a98:	e9 1e fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a9d:	fa                   	cli
    for(;;)
80100a9e:	eb fe                	jmp    80100a9e <consoleintr+0x1fe>
}
80100aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa3:	5b                   	pop    %ebx
80100aa4:	5e                   	pop    %esi
80100aa5:	5f                   	pop    %edi
80100aa6:	5d                   	pop    %ebp
        procdump();  // now call procdump() wo. cons.lock held
80100aa7:	e9 64 37 00 00       	jmp    80104210 <procdump>
80100aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ab0 <consoleinit>:

void
consoleinit(void)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ab6:	68 28 72 10 80       	push   $0x80107228
80100abb:	68 20 ef 10 80       	push   $0x8010ef20
80100ac0:	e8 3b 39 00 00       	call   80104400 <initlock>
  cprintf("Console is initialized!\n");
80100ac5:	c7 04 24 30 72 10 80 	movl   $0x80107230,(%esp)
80100acc:	e8 df fb ff ff       	call   801006b0 <cprintf>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ad1:	58                   	pop    %eax
80100ad2:	5a                   	pop    %edx
80100ad3:	6a 00                	push   $0x0
80100ad5:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100ad7:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100ade:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ae1:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100ae8:	02 10 80 
  cons.locking = 1;
80100aeb:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100af2:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100af5:	e8 b6 19 00 00       	call   801024b0 <ioapicenable>
}
80100afa:	83 c4 10             	add    $0x10,%esp
80100afd:	c9                   	leave
80100afe:	c3                   	ret
80100aff:	90                   	nop

80100b00 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b00:	55                   	push   %ebp
80100b01:	89 e5                	mov    %esp,%ebp
80100b03:	57                   	push   %edi
80100b04:	56                   	push   %esi
80100b05:	53                   	push   %ebx
80100b06:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b0c:	e8 9f 2e 00 00       	call   801039b0 <myproc>
80100b11:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b17:	e8 74 22 00 00       	call   80102d90 <begin_op>

  if((ip = namei(path)) == 0){
80100b1c:	83 ec 0c             	sub    $0xc,%esp
80100b1f:	ff 75 08             	push   0x8(%ebp)
80100b22:	e8 a9 15 00 00       	call   801020d0 <namei>
80100b27:	83 c4 10             	add    $0x10,%esp
80100b2a:	85 c0                	test   %eax,%eax
80100b2c:	0f 84 30 03 00 00    	je     80100e62 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b32:	83 ec 0c             	sub    $0xc,%esp
80100b35:	89 c7                	mov    %eax,%edi
80100b37:	50                   	push   %eax
80100b38:	e8 b3 0c 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b3d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b43:	6a 34                	push   $0x34
80100b45:	6a 00                	push   $0x0
80100b47:	50                   	push   %eax
80100b48:	57                   	push   %edi
80100b49:	e8 b2 0f 00 00       	call   80101b00 <readi>
80100b4e:	83 c4 20             	add    $0x20,%esp
80100b51:	83 f8 34             	cmp    $0x34,%eax
80100b54:	0f 85 01 01 00 00    	jne    80100c5b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b5a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b61:	45 4c 46 
80100b64:	0f 85 f1 00 00 00    	jne    80100c5b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b6a:	e8 01 63 00 00       	call   80106e70 <setupkvm>
80100b6f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b75:	85 c0                	test   %eax,%eax
80100b77:	0f 84 de 00 00 00    	je     80100c5b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b84:	00 
80100b85:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b8b:	0f 84 a1 02 00 00    	je     80100e32 <exec+0x332>
  sz = 0;
80100b91:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b98:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b9b:	31 db                	xor    %ebx,%ebx
80100b9d:	e9 8c 00 00 00       	jmp    80100c2e <exec+0x12e>
80100ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ba8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100baf:	75 6c                	jne    80100c1d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100bb1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bb7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bbd:	0f 82 87 00 00 00    	jb     80100c4a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bc3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bc9:	72 7f                	jb     80100c4a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bcb:	83 ec 04             	sub    $0x4,%esp
80100bce:	50                   	push   %eax
80100bcf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bd5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bdb:	e8 c0 60 00 00       	call   80106ca0 <allocuvm>
80100be0:	83 c4 10             	add    $0x10,%esp
80100be3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100be9:	85 c0                	test   %eax,%eax
80100beb:	74 5d                	je     80100c4a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bed:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bf3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bf8:	75 50                	jne    80100c4a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c03:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c09:	57                   	push   %edi
80100c0a:	50                   	push   %eax
80100c0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c11:	e8 ba 5f 00 00       	call   80106bd0 <loaduvm>
80100c16:	83 c4 20             	add    $0x20,%esp
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	78 2d                	js     80100c4a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c1d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c24:	83 c3 01             	add    $0x1,%ebx
80100c27:	83 c6 20             	add    $0x20,%esi
80100c2a:	39 d8                	cmp    %ebx,%eax
80100c2c:	7e 52                	jle    80100c80 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c2e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c34:	6a 20                	push   $0x20
80100c36:	56                   	push   %esi
80100c37:	50                   	push   %eax
80100c38:	57                   	push   %edi
80100c39:	e8 c2 0e 00 00       	call   80101b00 <readi>
80100c3e:	83 c4 10             	add    $0x10,%esp
80100c41:	83 f8 20             	cmp    $0x20,%eax
80100c44:	0f 84 5e ff ff ff    	je     80100ba8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c4a:	83 ec 0c             	sub    $0xc,%esp
80100c4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c53:	e8 98 61 00 00       	call   80106df0 <freevm>
  if(ip){
80100c58:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c5b:	83 ec 0c             	sub    $0xc,%esp
80100c5e:	57                   	push   %edi
80100c5f:	e8 1c 0e 00 00       	call   80101a80 <iunlockput>
    end_op();
80100c64:	e8 97 21 00 00       	call   80102e00 <end_op>
80100c69:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c74:	5b                   	pop    %ebx
80100c75:	5e                   	pop    %esi
80100c76:	5f                   	pop    %edi
80100c77:	5d                   	pop    %ebp
80100c78:	c3                   	ret
80100c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c80:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c86:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c8c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c92:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c98:	83 ec 0c             	sub    $0xc,%esp
80100c9b:	57                   	push   %edi
80100c9c:	e8 df 0d 00 00       	call   80101a80 <iunlockput>
  end_op();
80100ca1:	e8 5a 21 00 00       	call   80102e00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca6:	83 c4 0c             	add    $0xc,%esp
80100ca9:	53                   	push   %ebx
80100caa:	56                   	push   %esi
80100cab:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cb1:	56                   	push   %esi
80100cb2:	e8 e9 5f 00 00       	call   80106ca0 <allocuvm>
80100cb7:	83 c4 10             	add    $0x10,%esp
80100cba:	89 c7                	mov    %eax,%edi
80100cbc:	85 c0                	test   %eax,%eax
80100cbe:	0f 84 86 00 00 00    	je     80100d4a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc4:	83 ec 08             	sub    $0x8,%esp
80100cc7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100ccd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ccf:	50                   	push   %eax
80100cd0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cd1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	e8 38 62 00 00       	call   80106f10 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cdb:	83 c4 10             	add    $0x10,%esp
80100cde:	8b 10                	mov    (%eax),%edx
80100ce0:	85 d2                	test   %edx,%edx
80100ce2:	0f 84 56 01 00 00    	je     80100e3e <exec+0x33e>
80100ce8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cee:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cf1:	eb 23                	jmp    80100d16 <exec+0x216>
80100cf3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100cf8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cfb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100d02:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100d08:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100d0b:	85 d2                	test   %edx,%edx
80100d0d:	74 51                	je     80100d60 <exec+0x260>
    if(argc >= MAXARG)
80100d0f:	83 f8 20             	cmp    $0x20,%eax
80100d12:	74 36                	je     80100d4a <exec+0x24a>
80100d14:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d16:	83 ec 0c             	sub    $0xc,%esp
80100d19:	52                   	push   %edx
80100d1a:	e8 c1 3b 00 00       	call   801048e0 <strlen>
80100d1f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d21:	58                   	pop    %eax
80100d22:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d25:	83 eb 01             	sub    $0x1,%ebx
80100d28:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d2b:	e8 b0 3b 00 00       	call   801048e0 <strlen>
80100d30:	83 c0 01             	add    $0x1,%eax
80100d33:	50                   	push   %eax
80100d34:	ff 34 b7             	push   (%edi,%esi,4)
80100d37:	53                   	push   %ebx
80100d38:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d3e:	e8 9d 63 00 00       	call   801070e0 <copyout>
80100d43:	83 c4 20             	add    $0x20,%esp
80100d46:	85 c0                	test   %eax,%eax
80100d48:	79 ae                	jns    80100cf8 <exec+0x1f8>
    freevm(pgdir);
80100d4a:	83 ec 0c             	sub    $0xc,%esp
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d53:	e8 98 60 00 00       	call   80106df0 <freevm>
80100d58:	83 c4 10             	add    $0x10,%esp
80100d5b:	e9 0c ff ff ff       	jmp    80100c6c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d60:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d67:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d6d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d73:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d76:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d79:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d80:	00 00 00 00 
  ustack[1] = argc;
80100d84:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d8a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d91:	ff ff ff 
  ustack[1] = argc;
80100d94:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d9a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d9c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d9e:	29 d0                	sub    %edx,%eax
80100da0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100da6:	56                   	push   %esi
80100da7:	51                   	push   %ecx
80100da8:	53                   	push   %ebx
80100da9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100daf:	e8 2c 63 00 00       	call   801070e0 <copyout>
80100db4:	83 c4 10             	add    $0x10,%esp
80100db7:	85 c0                	test   %eax,%eax
80100db9:	78 8f                	js     80100d4a <exec+0x24a>
  for(last=s=path; *s; s++)
80100dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80100dbe:	8b 55 08             	mov    0x8(%ebp),%edx
80100dc1:	0f b6 00             	movzbl (%eax),%eax
80100dc4:	84 c0                	test   %al,%al
80100dc6:	74 17                	je     80100ddf <exec+0x2df>
80100dc8:	89 d1                	mov    %edx,%ecx
80100dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100dd0:	83 c1 01             	add    $0x1,%ecx
80100dd3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100dd5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100dd8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100ddb:	84 c0                	test   %al,%al
80100ddd:	75 f1                	jne    80100dd0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ddf:	83 ec 04             	sub    $0x4,%esp
80100de2:	6a 10                	push   $0x10
80100de4:	52                   	push   %edx
80100de5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100deb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dee:	50                   	push   %eax
80100def:	e8 ac 3a 00 00       	call   801048a0 <safestrcpy>
  curproc->pgdir = pgdir;
80100df4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dfa:	89 f0                	mov    %esi,%eax
80100dfc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100dff:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100e01:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e04:	89 c1                	mov    %eax,%ecx
80100e06:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e0c:	8b 40 18             	mov    0x18(%eax),%eax
80100e0f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e12:	8b 41 18             	mov    0x18(%ecx),%eax
80100e15:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e18:	89 0c 24             	mov    %ecx,(%esp)
80100e1b:	e8 20 5c 00 00       	call   80106a40 <switchuvm>
  freevm(oldpgdir);
80100e20:	89 34 24             	mov    %esi,(%esp)
80100e23:	e8 c8 5f 00 00       	call   80106df0 <freevm>
  return 0;
80100e28:	83 c4 10             	add    $0x10,%esp
80100e2b:	31 c0                	xor    %eax,%eax
80100e2d:	e9 3f fe ff ff       	jmp    80100c71 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e32:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e37:	31 f6                	xor    %esi,%esi
80100e39:	e9 5a fe ff ff       	jmp    80100c98 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e3e:	be 10 00 00 00       	mov    $0x10,%esi
80100e43:	ba 04 00 00 00       	mov    $0x4,%edx
80100e48:	b8 03 00 00 00       	mov    $0x3,%eax
80100e4d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e54:	00 00 00 
80100e57:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e5d:	e9 17 ff ff ff       	jmp    80100d79 <exec+0x279>
    end_op();
80100e62:	e8 99 1f 00 00       	call   80102e00 <end_op>
    cprintf("exec: fail\n");
80100e67:	83 ec 0c             	sub    $0xc,%esp
80100e6a:	68 49 72 10 80       	push   $0x80107249
80100e6f:	e8 3c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e74:	83 c4 10             	add    $0x10,%esp
80100e77:	e9 f0 fd ff ff       	jmp    80100c6c <exec+0x16c>
80100e7c:	66 90                	xchg   %ax,%ax
80100e7e:	66 90                	xchg   %ax,%ax

80100e80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e86:	68 55 72 10 80       	push   $0x80107255
80100e8b:	68 60 ef 10 80       	push   $0x8010ef60
80100e90:	e8 6b 35 00 00       	call   80104400 <initlock>
}
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	c9                   	leave
80100e99:	c3                   	ret
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ea0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea4:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100ea9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100eac:	68 60 ef 10 80       	push   $0x8010ef60
80100eb1:	e8 3a 37 00 00       	call   801045f0 <acquire>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb 10                	jmp    80100ecb <filealloc+0x2b>
80100ebb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec0:	83 c3 18             	add    $0x18,%ebx
80100ec3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ec9:	74 25                	je     80100ef0 <filealloc+0x50>
    if(f->ref == 0){
80100ecb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	75 ee                	jne    80100ec0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ed2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ed5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100edc:	68 60 ef 10 80       	push   $0x8010ef60
80100ee1:	e8 aa 36 00 00       	call   80104590 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ee6:	89 d8                	mov    %ebx,%eax
      return f;
80100ee8:	83 c4 10             	add    $0x10,%esp
}
80100eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eee:	c9                   	leave
80100eef:	c3                   	ret
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ef3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ef5:	68 60 ef 10 80       	push   $0x8010ef60
80100efa:	e8 91 36 00 00       	call   80104590 <release>
}
80100eff:	89 d8                	mov    %ebx,%eax
  return 0;
80100f01:	83 c4 10             	add    $0x10,%esp
}
80100f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f07:	c9                   	leave
80100f08:	c3                   	ret
80100f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 10             	sub    $0x10,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f1a:	68 60 ef 10 80       	push   $0x8010ef60
80100f1f:	e8 cc 36 00 00       	call   801045f0 <acquire>
  if(f->ref < 1)
80100f24:	8b 43 04             	mov    0x4(%ebx),%eax
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	85 c0                	test   %eax,%eax
80100f2c:	7e 1a                	jle    80100f48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f37:	68 60 ef 10 80       	push   $0x8010ef60
80100f3c:	e8 4f 36 00 00       	call   80104590 <release>
  return f;
}
80100f41:	89 d8                	mov    %ebx,%eax
80100f43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f46:	c9                   	leave
80100f47:	c3                   	ret
    panic("filedup");
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	68 5c 72 10 80       	push   $0x8010725c
80100f50:	e8 2b f4 ff ff       	call   80100380 <panic>
80100f55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f5c:	00 
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi

80100f60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 28             	sub    $0x28,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f6c:	68 60 ef 10 80       	push   $0x8010ef60
80100f71:	e8 7a 36 00 00       	call   801045f0 <acquire>
  if(f->ref < 1)
80100f76:	8b 53 04             	mov    0x4(%ebx),%edx
80100f79:	83 c4 10             	add    $0x10,%esp
80100f7c:	85 d2                	test   %edx,%edx
80100f7e:	0f 8e a5 00 00 00    	jle    80101029 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f84:	83 ea 01             	sub    $0x1,%edx
80100f87:	89 53 04             	mov    %edx,0x4(%ebx)
80100f8a:	75 44                	jne    80100fd0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f8c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f90:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f93:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f95:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f9b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f9e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fa1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fa7:	68 60 ef 10 80       	push   $0x8010ef60
80100fac:	e8 df 35 00 00       	call   80104590 <release>

  if(ff.type == FD_PIPE)
80100fb1:	83 c4 10             	add    $0x10,%esp
80100fb4:	83 ff 01             	cmp    $0x1,%edi
80100fb7:	74 57                	je     80101010 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fb9:	83 ff 02             	cmp    $0x2,%edi
80100fbc:	74 2a                	je     80100fe8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
80100fc5:	c3                   	ret
80100fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fcd:	00 
80100fce:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100fd0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fda:	5b                   	pop    %ebx
80100fdb:	5e                   	pop    %esi
80100fdc:	5f                   	pop    %edi
80100fdd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fde:	e9 ad 35 00 00       	jmp    80104590 <release>
80100fe3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100fe8:	e8 a3 1d 00 00       	call   80102d90 <begin_op>
    iput(ff.ip);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	ff 75 e0             	push   -0x20(%ebp)
80100ff3:	e8 28 09 00 00       	call   80101920 <iput>
    end_op();
80100ff8:	83 c4 10             	add    $0x10,%esp
}
80100ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffe:	5b                   	pop    %ebx
80100fff:	5e                   	pop    %esi
80101000:	5f                   	pop    %edi
80101001:	5d                   	pop    %ebp
    end_op();
80101002:	e9 f9 1d 00 00       	jmp    80102e00 <end_op>
80101007:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010100e:	00 
8010100f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101010:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101014:	83 ec 08             	sub    $0x8,%esp
80101017:	53                   	push   %ebx
80101018:	56                   	push   %esi
80101019:	e8 32 25 00 00       	call   80103550 <pipeclose>
8010101e:	83 c4 10             	add    $0x10,%esp
}
80101021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101024:	5b                   	pop    %ebx
80101025:	5e                   	pop    %esi
80101026:	5f                   	pop    %edi
80101027:	5d                   	pop    %ebp
80101028:	c3                   	ret
    panic("fileclose");
80101029:	83 ec 0c             	sub    $0xc,%esp
8010102c:	68 64 72 10 80       	push   $0x80107264
80101031:	e8 4a f3 ff ff       	call   80100380 <panic>
80101036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010103d:	00 
8010103e:	66 90                	xchg   %ax,%ax

80101040 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 04             	sub    $0x4,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010104a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010104d:	75 31                	jne    80101080 <filestat+0x40>
    ilock(f->ip);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	ff 73 10             	push   0x10(%ebx)
80101055:	e8 96 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010105a:	58                   	pop    %eax
8010105b:	5a                   	pop    %edx
8010105c:	ff 75 0c             	push   0xc(%ebp)
8010105f:	ff 73 10             	push   0x10(%ebx)
80101062:	e8 69 0a 00 00       	call   80101ad0 <stati>
    iunlock(f->ip);
80101067:	59                   	pop    %ecx
80101068:	ff 73 10             	push   0x10(%ebx)
8010106b:	e8 60 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101073:	83 c4 10             	add    $0x10,%esp
80101076:	31 c0                	xor    %eax,%eax
}
80101078:	c9                   	leave
80101079:	c3                   	ret
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101088:	c9                   	leave
80101089:	c3                   	ret
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101090 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010109c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010109f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010a2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010a6:	74 60                	je     80101108 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010a8:	8b 03                	mov    (%ebx),%eax
801010aa:	83 f8 01             	cmp    $0x1,%eax
801010ad:	74 41                	je     801010f0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 5b                	jne    8010110f <fileread+0x7f>
    ilock(f->ip);
801010b4:	83 ec 0c             	sub    $0xc,%esp
801010b7:	ff 73 10             	push   0x10(%ebx)
801010ba:	e8 31 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010bf:	57                   	push   %edi
801010c0:	ff 73 14             	push   0x14(%ebx)
801010c3:	56                   	push   %esi
801010c4:	ff 73 10             	push   0x10(%ebx)
801010c7:	e8 34 0a 00 00       	call   80101b00 <readi>
801010cc:	83 c4 20             	add    $0x20,%esp
801010cf:	89 c6                	mov    %eax,%esi
801010d1:	85 c0                	test   %eax,%eax
801010d3:	7e 03                	jle    801010d8 <fileread+0x48>
      f->off += r;
801010d5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010d8:	83 ec 0c             	sub    $0xc,%esp
801010db:	ff 73 10             	push   0x10(%ebx)
801010de:	e8 ed 07 00 00       	call   801018d0 <iunlock>
    return r;
801010e3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	89 f0                	mov    %esi,%eax
801010eb:	5b                   	pop    %ebx
801010ec:	5e                   	pop    %esi
801010ed:	5f                   	pop    %edi
801010ee:	5d                   	pop    %ebp
801010ef:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010f0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	5b                   	pop    %ebx
801010fa:	5e                   	pop    %esi
801010fb:	5f                   	pop    %edi
801010fc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010fd:	e9 0e 26 00 00       	jmp    80103710 <piperead>
80101102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101108:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010110d:	eb d7                	jmp    801010e6 <fileread+0x56>
  panic("fileread");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 6e 72 10 80       	push   $0x8010726e
80101117:	e8 64 f2 ff ff       	call   80100380 <panic>
8010111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101120 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
80101129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010112c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010112f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101132:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101135:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010113c:	0f 84 bb 00 00 00    	je     801011fd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101142:	8b 03                	mov    (%ebx),%eax
80101144:	83 f8 01             	cmp    $0x1,%eax
80101147:	0f 84 bf 00 00 00    	je     8010120c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114d:	83 f8 02             	cmp    $0x2,%eax
80101150:	0f 85 c8 00 00 00    	jne    8010121e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101159:	31 f6                	xor    %esi,%esi
    while(i < n){
8010115b:	85 c0                	test   %eax,%eax
8010115d:	7f 30                	jg     8010118f <filewrite+0x6f>
8010115f:	e9 94 00 00 00       	jmp    801011f8 <filewrite+0xd8>
80101164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101168:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010116b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010116e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101171:	ff 73 10             	push   0x10(%ebx)
80101174:	e8 57 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101179:	e8 82 1c 00 00       	call   80102e00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010117e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101181:	83 c4 10             	add    $0x10,%esp
80101184:	39 c7                	cmp    %eax,%edi
80101186:	75 5c                	jne    801011e4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101188:	01 fe                	add    %edi,%esi
    while(i < n){
8010118a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010118d:	7e 69                	jle    801011f8 <filewrite+0xd8>
      int n1 = n - i;
8010118f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101192:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101197:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101199:	39 c7                	cmp    %eax,%edi
8010119b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010119e:	e8 ed 1b 00 00       	call   80102d90 <begin_op>
      ilock(f->ip);
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	ff 73 10             	push   0x10(%ebx)
801011a9:	e8 42 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ae:	57                   	push   %edi
801011af:	ff 73 14             	push   0x14(%ebx)
801011b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b5:	01 f0                	add    %esi,%eax
801011b7:	50                   	push   %eax
801011b8:	ff 73 10             	push   0x10(%ebx)
801011bb:	e8 40 0a 00 00       	call   80101c00 <writei>
801011c0:	83 c4 20             	add    $0x20,%esp
801011c3:	85 c0                	test   %eax,%eax
801011c5:	7f a1                	jg     80101168 <filewrite+0x48>
801011c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011ca:	83 ec 0c             	sub    $0xc,%esp
801011cd:	ff 73 10             	push   0x10(%ebx)
801011d0:	e8 fb 06 00 00       	call   801018d0 <iunlock>
      end_op();
801011d5:	e8 26 1c 00 00       	call   80102e00 <end_op>
      if(r < 0)
801011da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011dd:	83 c4 10             	add    $0x10,%esp
801011e0:	85 c0                	test   %eax,%eax
801011e2:	75 14                	jne    801011f8 <filewrite+0xd8>
        panic("short filewrite");
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	68 77 72 10 80       	push   $0x80107277
801011ec:	e8 8f f1 ff ff       	call   80100380 <panic>
801011f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011f8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011fb:	74 05                	je     80101202 <filewrite+0xe2>
801011fd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101202:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101205:	89 f0                	mov    %esi,%eax
80101207:	5b                   	pop    %ebx
80101208:	5e                   	pop    %esi
80101209:	5f                   	pop    %edi
8010120a:	5d                   	pop    %ebp
8010120b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010120c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010120f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101212:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101215:	5b                   	pop    %ebx
80101216:	5e                   	pop    %esi
80101217:	5f                   	pop    %edi
80101218:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101219:	e9 d2 23 00 00       	jmp    801035f0 <pipewrite>
  panic("filewrite");
8010121e:	83 ec 0c             	sub    $0xc,%esp
80101221:	68 7d 72 10 80       	push   $0x8010727d
80101226:	e8 55 f1 ff ff       	call   80100380 <panic>
8010122b:	66 90                	xchg   %ax,%ax
8010122d:	66 90                	xchg   %ax,%ax
8010122f:	90                   	nop

80101230 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010123f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 8c 00 00 00    	je     801012d6 <balloc+0xa6>
8010124a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010124c:	89 f8                	mov    %edi,%eax
8010124e:	83 ec 08             	sub    $0x8,%esp
80101251:	89 fe                	mov    %edi,%esi
80101253:	c1 f8 0c             	sar    $0xc,%eax
80101256:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010125c:	50                   	push   %eax
8010125d:	ff 75 dc             	push   -0x24(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
80101265:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101268:	83 c4 10             	add    $0x10,%esp
8010126b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010126e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101273:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101276:	31 c0                	xor    %eax,%eax
80101278:	eb 32                	jmp    801012ac <balloc+0x7c>
8010127a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 49                	je     801012e8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 07                	je     801012b3 <balloc+0x83>
801012ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
801012af:	39 d6                	cmp    %edx,%esi
801012b1:	72 cd                	jb     80101280 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012b3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012c2:	e8 29 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012c7:	83 c4 10             	add    $0x10,%esp
801012ca:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012d0:	0f 82 76 ff ff ff    	jb     8010124c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012d6:	83 ec 0c             	sub    $0xc,%esp
801012d9:	68 87 72 10 80       	push   $0x80107287
801012de:	e8 9d f0 ff ff       	call   80100380 <panic>
801012e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801012e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012eb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ee:	09 da                	or     %ebx,%edx
801012f0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012f4:	57                   	push   %edi
801012f5:	e8 76 1c 00 00       	call   80102f70 <log_write>
        brelse(bp);
801012fa:	89 3c 24             	mov    %edi,(%esp)
801012fd:	e8 ee ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101302:	58                   	pop    %eax
80101303:	5a                   	pop    %edx
80101304:	56                   	push   %esi
80101305:	ff 75 dc             	push   -0x24(%ebp)
80101308:	e8 c3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010130d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101310:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101312:	8d 40 5c             	lea    0x5c(%eax),%eax
80101315:	68 00 02 00 00       	push   $0x200
8010131a:	6a 00                	push   $0x0
8010131c:	50                   	push   %eax
8010131d:	e8 ce 33 00 00       	call   801046f0 <memset>
  log_write(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 46 1c 00 00       	call   80102f70 <log_write>
  brelse(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 be ee ff ff       	call   801001f0 <brelse>
}
80101332:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101335:	89 f0                	mov    %esi,%eax
80101337:	5b                   	pop    %ebx
80101338:	5e                   	pop    %esi
80101339:	5f                   	pop    %edi
8010133a:	5d                   	pop    %ebp
8010133b:	c3                   	ret
8010133c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101344:	31 ff                	xor    %edi,%edi
{
80101346:	56                   	push   %esi
80101347:	89 c6                	mov    %eax,%esi
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 60 f9 10 80       	push   $0x8010f960
8010135a:	e8 91 32 00 00       	call   801045f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010136e:	00 
8010136f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 33                	cmp    %esi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010137a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101380:	74 26                	je     801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 43 08             	mov    0x8(%ebx),%eax
80101385:	85 c0                	test   %eax,%eax
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 ff                	test   %edi,%edi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	85 c0                	test   %eax,%eax
8010138f:	75 76                	jne    80101407 <iget+0xc7>
      empty = ip;
80101391:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101393:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101399:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010139f:	75 e1                	jne    80101382 <iget+0x42>
801013a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 ff                	test   %edi,%edi
801013aa:	74 79                	je     80101425 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801013b1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801013b4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801013bb:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013c2:	68 60 f9 10 80       	push   $0x8010f960
801013c7:	e8 c4 31 00 00       	call   80104590 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f8                	mov    %edi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      ip->ref++;
801013e5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013e8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013eb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013ed:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013f0:	68 60 f9 10 80       	push   $0x8010f960
801013f5:	e8 96 31 00 00       	call   80104590 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f8                	mov    %edi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010140d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101413:	74 10                	je     80101425 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101415:	8b 43 08             	mov    0x8(%ebx),%eax
80101418:	85 c0                	test   %eax,%eax
8010141a:	0f 8f 50 ff ff ff    	jg     80101370 <iget+0x30>
80101420:	e9 68 ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
80101425:	83 ec 0c             	sub    $0xc,%esp
80101428:	68 9d 72 10 80       	push   $0x8010729d
8010142d:	e8 4e ef ff ff       	call   80100380 <panic>
80101432:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101439:	00 
8010143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101440 <bfree>:
{
80101440:	55                   	push   %ebp
80101441:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101443:	89 d0                	mov    %edx,%eax
80101445:	c1 e8 0c             	shr    $0xc,%eax
{
80101448:	89 e5                	mov    %esp,%ebp
8010144a:	56                   	push   %esi
8010144b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010144c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101452:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101454:	83 ec 08             	sub    $0x8,%esp
80101457:	50                   	push   %eax
80101458:	51                   	push   %ecx
80101459:	e8 72 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010145e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101460:	c1 fb 03             	sar    $0x3,%ebx
80101463:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101466:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101468:	83 e1 07             	and    $0x7,%ecx
8010146b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101470:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101476:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101478:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010147d:	85 c1                	test   %eax,%ecx
8010147f:	74 23                	je     801014a4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101481:	f7 d0                	not    %eax
  log_write(bp);
80101483:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101486:	21 c8                	and    %ecx,%eax
80101488:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010148c:	56                   	push   %esi
8010148d:	e8 de 1a 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101492:	89 34 24             	mov    %esi,(%esp)
80101495:	e8 56 ed ff ff       	call   801001f0 <brelse>
}
8010149a:	83 c4 10             	add    $0x10,%esp
8010149d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014a0:	5b                   	pop    %ebx
801014a1:	5e                   	pop    %esi
801014a2:	5d                   	pop    %ebp
801014a3:	c3                   	ret
    panic("freeing free block");
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	68 ad 72 10 80       	push   $0x801072ad
801014ac:	e8 cf ee ff ff       	call   80100380 <panic>
801014b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014b8:	00 
801014b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	89 c6                	mov    %eax,%esi
801014c7:	53                   	push   %ebx
801014c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014cb:	83 fa 0b             	cmp    $0xb,%edx
801014ce:	0f 86 8c 00 00 00    	jbe    80101560 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014d4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014d7:	83 fb 7f             	cmp    $0x7f,%ebx
801014da:	0f 87 a2 00 00 00    	ja     80101582 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014e0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014e6:	85 c0                	test   %eax,%eax
801014e8:	74 5e                	je     80101548 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ea:	83 ec 08             	sub    $0x8,%esp
801014ed:	50                   	push   %eax
801014ee:	ff 36                	push   (%esi)
801014f0:	e8 db eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014f5:	83 c4 10             	add    $0x10,%esp
801014f8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014fc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014fe:	8b 3b                	mov    (%ebx),%edi
80101500:	85 ff                	test   %edi,%edi
80101502:	74 1c                	je     80101520 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	52                   	push   %edx
80101508:	e8 e3 ec ff ff       	call   801001f0 <brelse>
8010150d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101510:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101513:	89 f8                	mov    %edi,%eax
80101515:	5b                   	pop    %ebx
80101516:	5e                   	pop    %esi
80101517:	5f                   	pop    %edi
80101518:	5d                   	pop    %ebp
80101519:	c3                   	ret
8010151a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101523:	8b 06                	mov    (%esi),%eax
80101525:	e8 06 fd ff ff       	call   80101230 <balloc>
      log_write(bp);
8010152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010152d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101530:	89 03                	mov    %eax,(%ebx)
80101532:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101534:	52                   	push   %edx
80101535:	e8 36 1a 00 00       	call   80102f70 <log_write>
8010153a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010153d:	83 c4 10             	add    $0x10,%esp
80101540:	eb c2                	jmp    80101504 <bmap+0x44>
80101542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101548:	8b 06                	mov    (%esi),%eax
8010154a:	e8 e1 fc ff ff       	call   80101230 <balloc>
8010154f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101555:	eb 93                	jmp    801014ea <bmap+0x2a>
80101557:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010155e:	00 
8010155f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101560:	8d 5a 14             	lea    0x14(%edx),%ebx
80101563:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101567:	85 ff                	test   %edi,%edi
80101569:	75 a5                	jne    80101510 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010156b:	8b 00                	mov    (%eax),%eax
8010156d:	e8 be fc ff ff       	call   80101230 <balloc>
80101572:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101576:	89 c7                	mov    %eax,%edi
}
80101578:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010157b:	5b                   	pop    %ebx
8010157c:	89 f8                	mov    %edi,%eax
8010157e:	5e                   	pop    %esi
8010157f:	5f                   	pop    %edi
80101580:	5d                   	pop    %ebp
80101581:	c3                   	ret
  panic("bmap: out of range");
80101582:	83 ec 0c             	sub    $0xc,%esp
80101585:	68 c0 72 10 80       	push   $0x801072c0
8010158a:	e8 f1 ed ff ff       	call   80100380 <panic>
8010158f:	90                   	nop

80101590 <readsb>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	6a 01                	push   $0x1
8010159d:	ff 75 08             	push   0x8(%ebp)
801015a0:	e8 2b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015a8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801015ad:	6a 1c                	push   $0x1c
801015af:	50                   	push   %eax
801015b0:	56                   	push   %esi
801015b1:	e8 ca 31 00 00       	call   80104780 <memmove>
  brelse(bp);
801015b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015b9:	83 c4 10             	add    $0x10,%esp
}
801015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5d                   	pop    %ebp
  brelse(bp);
801015c2:	e9 29 ec ff ff       	jmp    801001f0 <brelse>
801015c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ce:	00 
801015cf:	90                   	nop

801015d0 <iinit>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801015d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015dc:	68 d3 72 10 80       	push   $0x801072d3
801015e1:	68 60 f9 10 80       	push   $0x8010f960
801015e6:	e8 15 2e 00 00       	call   80104400 <initlock>
  for(i = 0; i < NINODE; i++) {
801015eb:	83 c4 10             	add    $0x10,%esp
801015ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	83 ec 08             	sub    $0x8,%esp
801015f3:	68 da 72 10 80       	push   $0x801072da
801015f8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ff:	e8 cc 2c 00 00       	call   801042d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x20>
  bp = bread(dev, 1);
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	6a 01                	push   $0x1
80101614:	ff 75 08             	push   0x8(%ebp)
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010161c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010161f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101621:	8d 40 5c             	lea    0x5c(%eax),%eax
80101624:	6a 1c                	push   $0x1c
80101626:	50                   	push   %eax
80101627:	68 b4 15 11 80       	push   $0x801115b4
8010162c:	e8 4f 31 00 00       	call   80104780 <memmove>
  brelse(bp);
80101631:	89 1c 24             	mov    %ebx,(%esp)
80101634:	e8 b7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101639:	ff 35 cc 15 11 80    	push   0x801115cc
8010163f:	ff 35 c8 15 11 80    	push   0x801115c8
80101645:	ff 35 c4 15 11 80    	push   0x801115c4
8010164b:	ff 35 c0 15 11 80    	push   0x801115c0
80101651:	ff 35 bc 15 11 80    	push   0x801115bc
80101657:	ff 35 b8 15 11 80    	push   0x801115b8
8010165d:	ff 35 b4 15 11 80    	push   0x801115b4
80101663:	68 f0 76 10 80       	push   $0x801076f0
80101668:	e8 43 f0 ff ff       	call   801006b0 <cprintf>
}
8010166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101670:	83 c4 30             	add    $0x30,%esp
80101673:	c9                   	leave
80101674:	c3                   	ret
80101675:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010167c:	00 
8010167d:	8d 76 00             	lea    0x0(%esi),%esi

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 1c             	sub    $0x1c,%esp
80101689:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101693:	8b 75 08             	mov    0x8(%ebp),%esi
80101696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101699:	0f 86 91 00 00 00    	jbe    80101730 <ialloc+0xb0>
8010169f:	bf 01 00 00 00       	mov    $0x1,%edi
801016a4:	eb 21                	jmp    801016c7 <ialloc+0x47>
801016a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016ad:	00 
801016ae:	66 90                	xchg   %ax,%ax
    brelse(bp);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016b6:	53                   	push   %ebx
801016b7:	e8 34 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801016c5:	73 69                	jae    80101730 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016c7:	89 f8                	mov    %edi,%eax
801016c9:	83 ec 08             	sub    $0x8,%esp
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016d5:	50                   	push   %eax
801016d6:	56                   	push   %esi
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016dc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016df:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016e1:	89 f8                	mov    %edi,%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016f1:	75 bd                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016f3:	83 ec 04             	sub    $0x4,%esp
801016f6:	6a 40                	push   $0x40
801016f8:	6a 00                	push   $0x0
801016fa:	51                   	push   %ecx
801016fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016fe:	e8 ed 2f 00 00       	call   801046f0 <memset>
      dip->type = type;
80101703:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101707:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010170d:	89 1c 24             	mov    %ebx,(%esp)
80101710:	e8 5b 18 00 00       	call   80102f70 <log_write>
      brelse(bp);
80101715:	89 1c 24             	mov    %ebx,(%esp)
80101718:	e8 d3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010171d:	83 c4 10             	add    $0x10,%esp
}
80101720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101723:	89 fa                	mov    %edi,%edx
}
80101725:	5b                   	pop    %ebx
      return iget(dev, inum);
80101726:	89 f0                	mov    %esi,%eax
}
80101728:	5e                   	pop    %esi
80101729:	5f                   	pop    %edi
8010172a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172b:	e9 10 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	68 e0 72 10 80       	push   $0x801072e0
80101738:	e8 43 ec ff ff       	call   80100380 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010175a:	50                   	push   %eax
8010175b:	ff 73 a4             	push   -0x5c(%ebx)
8010175e:	e8 6d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101763:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101779:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010177c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101780:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101783:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101787:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010178b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010178f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101793:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101797:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010179a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010179d:	6a 34                	push   $0x34
8010179f:	53                   	push   %ebx
801017a0:	50                   	push   %eax
801017a1:	e8 da 2f 00 00       	call   80104780 <memmove>
  log_write(bp);
801017a6:	89 34 24             	mov    %esi,(%esp)
801017a9:	e8 c2 17 00 00       	call   80102f70 <log_write>
  brelse(bp);
801017ae:	89 75 08             	mov    %esi,0x8(%ebp)
801017b1:	83 c4 10             	add    $0x10,%esp
}
801017b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b7:	5b                   	pop    %ebx
801017b8:	5e                   	pop    %esi
801017b9:	5d                   	pop    %ebp
  brelse(bp);
801017ba:	e9 31 ea ff ff       	jmp    801001f0 <brelse>
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 60 f9 10 80       	push   $0x8010f960
801017cf:	e8 1c 2e 00 00       	call   801045f0 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801017df:	e8 ac 2d 00 00       	call   80104590 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave
801017ea:	c3                   	ret
801017eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 b7 00 00 00    	je     801018b7 <ilock+0xc7>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e ac 00 00 00    	jle    801018b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 f9 2a 00 00       	call   80104310 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	85 c0                	test   %eax,%eax
8010181f:	74 0f                	je     80101830 <ilock+0x40>
}
80101821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101824:	5b                   	pop    %ebx
80101825:	5e                   	pop    %esi
80101826:	5d                   	pop    %ebp
80101827:	c3                   	ret
80101828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010182f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010185f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101867:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101877:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	50                   	push   %eax
80101884:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101887:	50                   	push   %eax
80101888:	e8 f3 2e 00 00       	call   80104780 <memmove>
    brelse(bp);
8010188d:	89 34 24             	mov    %esi,(%esp)
80101890:	e8 5b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101895:	83 c4 10             	add    $0x10,%esp
80101898:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010189d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018a4:	0f 85 77 ff ff ff    	jne    80101821 <ilock+0x31>
      panic("ilock: no type");
801018aa:	83 ec 0c             	sub    $0xc,%esp
801018ad:	68 f8 72 10 80       	push   $0x801072f8
801018b2:	e8 c9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 f2 72 10 80       	push   $0x801072f2
801018bf:	e8 bc ea ff ff       	call   80100380 <panic>
801018c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018cb:	00 
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iunlock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	74 28                	je     80101904 <iunlock+0x34>
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e2:	56                   	push   %esi
801018e3:	e8 c8 2a 00 00       	call   801043b0 <holdingsleep>
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 c0                	test   %eax,%eax
801018ed:	74 15                	je     80101904 <iunlock+0x34>
801018ef:	8b 43 08             	mov    0x8(%ebx),%eax
801018f2:	85 c0                	test   %eax,%eax
801018f4:	7e 0e                	jle    80101904 <iunlock+0x34>
  releasesleep(&ip->lock);
801018f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ff:	e9 6c 2a 00 00       	jmp    80104370 <releasesleep>
    panic("iunlock");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 07 73 10 80       	push   $0x80107307
8010190c:	e8 6f ea ff ff       	call   80100380 <panic>
80101911:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101918:	00 
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010192c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010192f:	57                   	push   %edi
80101930:	e8 db 29 00 00       	call   80104310 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101935:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 d2                	test   %edx,%edx
8010193d:	74 07                	je     80101946 <iput+0x26>
8010193f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101944:	74 32                	je     80101978 <iput+0x58>
  releasesleep(&ip->lock);
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	57                   	push   %edi
8010194a:	e8 21 2a 00 00       	call   80104370 <releasesleep>
  acquire(&icache.lock);
8010194f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101956:	e8 95 2c 00 00       	call   801045f0 <acquire>
  ip->ref--;
8010195b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010195f:	83 c4 10             	add    $0x10,%esp
80101962:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010196c:	5b                   	pop    %ebx
8010196d:	5e                   	pop    %esi
8010196e:	5f                   	pop    %edi
8010196f:	5d                   	pop    %ebp
  release(&icache.lock);
80101970:	e9 1b 2c 00 00       	jmp    80104590 <release>
80101975:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 60 f9 10 80       	push   $0x8010f960
80101980:	e8 6b 2c 00 00       	call   801045f0 <acquire>
    int r = ip->ref;
80101985:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101988:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010198f:	e8 fc 2b 00 00       	call   80104590 <release>
    if(r == 1){
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	83 fe 01             	cmp    $0x1,%esi
8010199a:	75 aa                	jne    80101946 <iput+0x26>
8010199c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019a8:	89 df                	mov    %ebx,%edi
801019aa:	89 cb                	mov    %ecx,%ebx
801019ac:	eb 09                	jmp    801019b7 <iput+0x97>
801019ae:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 de                	cmp    %ebx,%esi
801019b5:	74 19                	je     801019d0 <iput+0xb0>
    if(ip->addrs[i]){
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019bd:	8b 07                	mov    (%edi),%eax
801019bf:	e8 7c fa ff ff       	call   80101440 <bfree>
      ip->addrs[i] = 0;
801019c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ca:	eb e4                	jmp    801019b0 <iput+0x90>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d0:	89 fb                	mov    %edi,%ebx
801019d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019db:	85 c0                	test   %eax,%eax
801019dd:	75 2d                	jne    80101a0c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019df:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019e9:	53                   	push   %ebx
801019ea:	e8 51 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019ef:	31 c0                	xor    %eax,%eax
801019f1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019f5:	89 1c 24             	mov    %ebx,(%esp)
801019f8:	e8 43 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
801019fd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a04:	83 c4 10             	add    $0x10,%esp
80101a07:	e9 3a ff ff ff       	jmp    80101946 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a0c:	83 ec 08             	sub    $0x8,%esp
80101a0f:	50                   	push   %eax
80101a10:	ff 33                	push   (%ebx)
80101a12:	e8 b9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a17:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a26:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a29:	89 cf                	mov    %ecx,%edi
80101a2b:	eb 0a                	jmp    80101a37 <iput+0x117>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 fc f9 ff ff       	call   80101440 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a49:	83 ec 0c             	sub    $0xc,%esp
80101a4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4f:	50                   	push   %eax
80101a50:	e8 9b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a55:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a5b:	8b 03                	mov    (%ebx),%eax
80101a5d:	e8 de f9 ff ff       	call   80101440 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a6c:	00 00 00 
80101a6f:	e9 6b ff ff ff       	jmp    801019df <iput+0xbf>
80101a74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a7b:	00 
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	74 34                	je     80101ac0 <iunlockput+0x40>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a92:	56                   	push   %esi
80101a93:	e8 18 29 00 00       	call   801043b0 <holdingsleep>
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 21                	je     80101ac0 <iunlockput+0x40>
80101a9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7e 1a                	jle    80101ac0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 c1 28 00 00       	call   80104370 <releasesleep>
  iput(ip);
80101aaf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ab2:	83 c4 10             	add    $0x10,%esp
}
80101ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5d                   	pop    %ebp
  iput(ip);
80101abb:	e9 60 fe ff ff       	jmp    80101920 <iput>
    panic("iunlock");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 07 73 10 80       	push   $0x80107307
80101ac8:	e8 b3 e8 ff ff       	call   80100380 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ad9:	8b 0a                	mov    (%edx),%ecx
80101adb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ade:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ae1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ae4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ae8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aeb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101af3:	8b 52 58             	mov    0x58(%edx),%edx
80101af6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101af9:	5d                   	pop    %ebp
80101afa:	c3                   	ret
80101afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 75 08             	mov    0x8(%ebp),%esi
80101b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b1a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b20:	0f 84 aa 00 00 00    	je     80101bd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b26:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b29:	8b 56 58             	mov    0x58(%esi),%edx
80101b2c:	39 fa                	cmp    %edi,%edx
80101b2e:	0f 82 bd 00 00 00    	jb     80101bf1 <readi+0xf1>
80101b34:	89 f9                	mov    %edi,%ecx
80101b36:	31 db                	xor    %ebx,%ebx
80101b38:	01 c1                	add    %eax,%ecx
80101b3a:	0f 92 c3             	setb   %bl
80101b3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b40:	0f 82 ab 00 00 00    	jb     80101bf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b46:	89 d3                	mov    %edx,%ebx
80101b48:	29 fb                	sub    %edi,%ebx
80101b4a:	39 ca                	cmp    %ecx,%edx
80101b4c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	74 73                	je     80101bc6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b53:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b63:	89 fa                	mov    %edi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 d8                	mov    %ebx,%eax
80101b6a:	e8 51 f9 ff ff       	call   801014c0 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 33                	push   (%ebx)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b7d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b82:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b84:	89 f8                	mov    %edi,%eax
80101b86:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b8b:	29 f3                	sub    %esi,%ebx
80101b8d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b93:	39 d9                	cmp    %ebx,%ecx
80101b95:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b98:	83 c4 0c             	add    $0xc,%esp
80101b9b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9c:	01 de                	add    %ebx,%esi
80101b9e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ba3:	50                   	push   %eax
80101ba4:	ff 75 e0             	push   -0x20(%ebp)
80101ba7:	e8 d4 2b 00 00       	call   80104780 <memmove>
    brelse(bp);
80101bac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101baf:	89 14 24             	mov    %edx,(%esp)
80101bb2:	e8 39 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bbd:	83 c4 10             	add    $0x10,%esp
80101bc0:	39 de                	cmp    %ebx,%esi
80101bc2:	72 9c                	jb     80101b60 <readi+0x60>
80101bc4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc9:	5b                   	pop    %ebx
80101bca:	5e                   	pop    %esi
80101bcb:	5f                   	pop    %edi
80101bcc:	5d                   	pop    %ebp
80101bcd:	c3                   	ret
80101bce:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bd0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bd4:	66 83 fa 09          	cmp    $0x9,%dx
80101bd8:	77 17                	ja     80101bf1 <readi+0xf1>
80101bda:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101be1:	85 d2                	test   %edx,%edx
80101be3:	74 0c                	je     80101bf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101be5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bef:	ff e2                	jmp    *%edx
      return -1;
80101bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf6:	eb ce                	jmp    80101bc6 <readi+0xc6>
80101bf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bff:	00 

80101c00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c0f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c17:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c1a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c1d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c20:	0f 84 ba 00 00 00    	je     80101ce0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c26:	39 78 58             	cmp    %edi,0x58(%eax)
80101c29:	0f 82 ea 00 00 00    	jb     80101d19 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c2f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c32:	89 f2                	mov    %esi,%edx
80101c34:	01 fa                	add    %edi,%edx
80101c36:	0f 82 dd 00 00 00    	jb     80101d19 <writei+0x119>
80101c3c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c42:	0f 87 d1 00 00 00    	ja     80101d19 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	85 f6                	test   %esi,%esi
80101c4a:	0f 84 85 00 00 00    	je     80101cd5 <writei+0xd5>
80101c50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c57:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c60:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c63:	89 fa                	mov    %edi,%edx
80101c65:	c1 ea 09             	shr    $0x9,%edx
80101c68:	89 f0                	mov    %esi,%eax
80101c6a:	e8 51 f8 ff ff       	call   801014c0 <bmap>
80101c6f:	83 ec 08             	sub    $0x8,%esp
80101c72:	50                   	push   %eax
80101c73:	ff 36                	push   (%esi)
80101c75:	e8 56 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c7d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c80:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c85:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c87:	89 f8                	mov    %edi,%eax
80101c89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c8e:	29 d3                	sub    %edx,%ebx
80101c90:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c92:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c96:	39 d9                	cmp    %ebx,%ecx
80101c98:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c9b:	83 c4 0c             	add    $0xc,%esp
80101c9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c9f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101ca1:	ff 75 dc             	push   -0x24(%ebp)
80101ca4:	50                   	push   %eax
80101ca5:	e8 d6 2a 00 00       	call   80104780 <memmove>
    log_write(bp);
80101caa:	89 34 24             	mov    %esi,(%esp)
80101cad:	e8 be 12 00 00       	call   80102f70 <log_write>
    brelse(bp);
80101cb2:	89 34 24             	mov    %esi,(%esp)
80101cb5:	e8 36 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cba:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cc0:	83 c4 10             	add    $0x10,%esp
80101cc3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cc6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cc9:	39 d8                	cmp    %ebx,%eax
80101ccb:	72 93                	jb     80101c60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ccd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cd0:	39 78 58             	cmp    %edi,0x58(%eax)
80101cd3:	72 33                	jb     80101d08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cdb:	5b                   	pop    %ebx
80101cdc:	5e                   	pop    %esi
80101cdd:	5f                   	pop    %edi
80101cde:	5d                   	pop    %ebp
80101cdf:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ce0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ce4:	66 83 f8 09          	cmp    $0x9,%ax
80101ce8:	77 2f                	ja     80101d19 <writei+0x119>
80101cea:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101cf1:	85 c0                	test   %eax,%eax
80101cf3:	74 24                	je     80101d19 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101cf5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfb:	5b                   	pop    %ebx
80101cfc:	5e                   	pop    %esi
80101cfd:	5f                   	pop    %edi
80101cfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cff:	ff e0                	jmp    *%eax
80101d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d0b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d0e:	50                   	push   %eax
80101d0f:	e8 2c fa ff ff       	call   80101740 <iupdate>
80101d14:	83 c4 10             	add    $0x10,%esp
80101d17:	eb bc                	jmp    80101cd5 <writei+0xd5>
      return -1;
80101d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d1e:	eb b8                	jmp    80101cd8 <writei+0xd8>

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d26:	6a 0e                	push   $0xe
80101d28:	ff 75 0c             	push   0xc(%ebp)
80101d2b:	ff 75 08             	push   0x8(%ebp)
80101d2e:	e8 bd 2a 00 00       	call   801047f0 <strncmp>
}
80101d33:	c9                   	leave
80101d34:	c3                   	ret
80101d35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d3c:	00 
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi

80101d40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d51:	0f 85 85 00 00 00    	jne    80101ddc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d57:	8b 53 58             	mov    0x58(%ebx),%edx
80101d5a:	31 ff                	xor    %edi,%edi
80101d5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d5f:	85 d2                	test   %edx,%edx
80101d61:	74 3e                	je     80101da1 <dirlookup+0x61>
80101d63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d68:	6a 10                	push   $0x10
80101d6a:	57                   	push   %edi
80101d6b:	56                   	push   %esi
80101d6c:	53                   	push   %ebx
80101d6d:	e8 8e fd ff ff       	call   80101b00 <readi>
80101d72:	83 c4 10             	add    $0x10,%esp
80101d75:	83 f8 10             	cmp    $0x10,%eax
80101d78:	75 55                	jne    80101dcf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d7f:	74 18                	je     80101d99 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d81:	83 ec 04             	sub    $0x4,%esp
80101d84:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d87:	6a 0e                	push   $0xe
80101d89:	50                   	push   %eax
80101d8a:	ff 75 0c             	push   0xc(%ebp)
80101d8d:	e8 5e 2a 00 00       	call   801047f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	85 c0                	test   %eax,%eax
80101d97:	74 17                	je     80101db0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d99:	83 c7 10             	add    $0x10,%edi
80101d9c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d9f:	72 c7                	jb     80101d68 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101da4:	31 c0                	xor    %eax,%eax
}
80101da6:	5b                   	pop    %ebx
80101da7:	5e                   	pop    %esi
80101da8:	5f                   	pop    %edi
80101da9:	5d                   	pop    %ebp
80101daa:	c3                   	ret
80101dab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101db0:	8b 45 10             	mov    0x10(%ebp),%eax
80101db3:	85 c0                	test   %eax,%eax
80101db5:	74 05                	je     80101dbc <dirlookup+0x7c>
        *poff = off;
80101db7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dbc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dc0:	8b 03                	mov    (%ebx),%eax
80101dc2:	e8 79 f5 ff ff       	call   80101340 <iget>
}
80101dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dca:	5b                   	pop    %ebx
80101dcb:	5e                   	pop    %esi
80101dcc:	5f                   	pop    %edi
80101dcd:	5d                   	pop    %ebp
80101dce:	c3                   	ret
      panic("dirlookup read");
80101dcf:	83 ec 0c             	sub    $0xc,%esp
80101dd2:	68 21 73 10 80       	push   $0x80107321
80101dd7:	e8 a4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101ddc:	83 ec 0c             	sub    $0xc,%esp
80101ddf:	68 0f 73 10 80       	push   $0x8010730f
80101de4:	e8 97 e5 ff ff       	call   80100380 <panic>
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	89 c3                	mov    %eax,%ebx
80101df8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dfb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dfe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e01:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e04:	0f 84 9e 01 00 00    	je     80101fa8 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e0a:	e8 a1 1b 00 00       	call   801039b0 <myproc>
  acquire(&icache.lock);
80101e0f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e12:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e15:	68 60 f9 10 80       	push   $0x8010f960
80101e1a:	e8 d1 27 00 00       	call   801045f0 <acquire>
  ip->ref++;
80101e1f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e23:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101e2a:	e8 61 27 00 00       	call   80104590 <release>
80101e2f:	83 c4 10             	add    $0x10,%esp
80101e32:	eb 07                	jmp    80101e3b <namex+0x4b>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	0f b6 03             	movzbl (%ebx),%eax
80101e3e:	3c 2f                	cmp    $0x2f,%al
80101e40:	74 f6                	je     80101e38 <namex+0x48>
  if(*path == 0)
80101e42:	84 c0                	test   %al,%al
80101e44:	0f 84 06 01 00 00    	je     80101f50 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e4a:	0f b6 03             	movzbl (%ebx),%eax
80101e4d:	84 c0                	test   %al,%al
80101e4f:	0f 84 10 01 00 00    	je     80101f65 <namex+0x175>
80101e55:	89 df                	mov    %ebx,%edi
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	0f 84 06 01 00 00    	je     80101f65 <namex+0x175>
80101e5f:	90                   	nop
80101e60:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e64:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e67:	3c 2f                	cmp    $0x2f,%al
80101e69:	74 04                	je     80101e6f <namex+0x7f>
80101e6b:	84 c0                	test   %al,%al
80101e6d:	75 f1                	jne    80101e60 <namex+0x70>
  len = path - s;
80101e6f:	89 f8                	mov    %edi,%eax
80101e71:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e73:	83 f8 0d             	cmp    $0xd,%eax
80101e76:	0f 8e ac 00 00 00    	jle    80101f28 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e7c:	83 ec 04             	sub    $0x4,%esp
80101e7f:	6a 0e                	push   $0xe
80101e81:	53                   	push   %ebx
80101e82:	89 fb                	mov    %edi,%ebx
80101e84:	ff 75 e4             	push   -0x1c(%ebp)
80101e87:	e8 f4 28 00 00       	call   80104780 <memmove>
80101e8c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e8f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e92:	75 0c                	jne    80101ea0 <namex+0xb0>
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e98:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e9b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e9e:	74 f8                	je     80101e98 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
80101ea3:	56                   	push   %esi
80101ea4:	e8 47 f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101ea9:	83 c4 10             	add    $0x10,%esp
80101eac:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101eb1:	0f 85 b7 00 00 00    	jne    80101f6e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101eb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	74 09                	je     80101ec7 <namex+0xd7>
80101ebe:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ec1:	0f 84 f7 00 00 00    	je     80101fbe <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ec7:	83 ec 04             	sub    $0x4,%esp
80101eca:	6a 00                	push   $0x0
80101ecc:	ff 75 e4             	push   -0x1c(%ebp)
80101ecf:	56                   	push   %esi
80101ed0:	e8 6b fe ff ff       	call   80101d40 <dirlookup>
80101ed5:	83 c4 10             	add    $0x10,%esp
80101ed8:	89 c7                	mov    %eax,%edi
80101eda:	85 c0                	test   %eax,%eax
80101edc:	0f 84 8c 00 00 00    	je     80101f6e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ee2:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	51                   	push   %ecx
80101ee9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101eec:	e8 bf 24 00 00       	call   801043b0 <holdingsleep>
80101ef1:	83 c4 10             	add    $0x10,%esp
80101ef4:	85 c0                	test   %eax,%eax
80101ef6:	0f 84 02 01 00 00    	je     80101ffe <namex+0x20e>
80101efc:	8b 56 08             	mov    0x8(%esi),%edx
80101eff:	85 d2                	test   %edx,%edx
80101f01:	0f 8e f7 00 00 00    	jle    80101ffe <namex+0x20e>
  releasesleep(&ip->lock);
80101f07:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f0a:	83 ec 0c             	sub    $0xc,%esp
80101f0d:	51                   	push   %ecx
80101f0e:	e8 5d 24 00 00       	call   80104370 <releasesleep>
  iput(ip);
80101f13:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f16:	89 fe                	mov    %edi,%esi
  iput(ip);
80101f18:	e8 03 fa ff ff       	call   80101920 <iput>
80101f1d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f20:	e9 16 ff ff ff       	jmp    80101e3b <namex+0x4b>
80101f25:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f2b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f2e:	83 ec 04             	sub    $0x4,%esp
80101f31:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f34:	50                   	push   %eax
80101f35:	53                   	push   %ebx
    name[len] = 0;
80101f36:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f38:	ff 75 e4             	push   -0x1c(%ebp)
80101f3b:	e8 40 28 00 00       	call   80104780 <memmove>
    name[len] = 0;
80101f40:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f43:	83 c4 10             	add    $0x10,%esp
80101f46:	c6 01 00             	movb   $0x0,(%ecx)
80101f49:	e9 41 ff ff ff       	jmp    80101e8f <namex+0x9f>
80101f4e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f50:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 85 93 00 00 00    	jne    80101fee <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f65:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f68:	89 df                	mov    %ebx,%edi
80101f6a:	31 c0                	xor    %eax,%eax
80101f6c:	eb c0                	jmp    80101f2e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 36 24 00 00       	call   801043b0 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 7d                	je     80101ffe <namex+0x20e>
80101f81:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f84:	85 c9                	test   %ecx,%ecx
80101f86:	7e 76                	jle    80101ffe <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 df 23 00 00       	call   80104370 <releasesleep>
  iput(ip);
80101f91:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f94:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f96:	e8 85 f9 ff ff       	call   80101920 <iput>
      return 0;
80101f9b:	83 c4 10             	add    $0x10,%esp
}
80101f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa1:	89 f0                	mov    %esi,%eax
80101fa3:	5b                   	pop    %ebx
80101fa4:	5e                   	pop    %esi
80101fa5:	5f                   	pop    %edi
80101fa6:	5d                   	pop    %ebp
80101fa7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101fa8:	ba 01 00 00 00       	mov    $0x1,%edx
80101fad:	b8 01 00 00 00       	mov    $0x1,%eax
80101fb2:	e8 89 f3 ff ff       	call   80101340 <iget>
80101fb7:	89 c6                	mov    %eax,%esi
80101fb9:	e9 7d fe ff ff       	jmp    80101e3b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fbe:	83 ec 0c             	sub    $0xc,%esp
80101fc1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fc4:	53                   	push   %ebx
80101fc5:	e8 e6 23 00 00       	call   801043b0 <holdingsleep>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	85 c0                	test   %eax,%eax
80101fcf:	74 2d                	je     80101ffe <namex+0x20e>
80101fd1:	8b 7e 08             	mov    0x8(%esi),%edi
80101fd4:	85 ff                	test   %edi,%edi
80101fd6:	7e 26                	jle    80101ffe <namex+0x20e>
  releasesleep(&ip->lock);
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	53                   	push   %ebx
80101fdc:	e8 8f 23 00 00       	call   80104370 <releasesleep>
}
80101fe1:	83 c4 10             	add    $0x10,%esp
}
80101fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe7:	89 f0                	mov    %esi,%eax
80101fe9:	5b                   	pop    %ebx
80101fea:	5e                   	pop    %esi
80101feb:	5f                   	pop    %edi
80101fec:	5d                   	pop    %ebp
80101fed:	c3                   	ret
    iput(ip);
80101fee:	83 ec 0c             	sub    $0xc,%esp
80101ff1:	56                   	push   %esi
      return 0;
80101ff2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ff4:	e8 27 f9 ff ff       	call   80101920 <iput>
    return 0;
80101ff9:	83 c4 10             	add    $0x10,%esp
80101ffc:	eb a0                	jmp    80101f9e <namex+0x1ae>
    panic("iunlock");
80101ffe:	83 ec 0c             	sub    $0xc,%esp
80102001:	68 07 73 10 80       	push   $0x80107307
80102006:	e8 75 e3 ff ff       	call   80100380 <panic>
8010200b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102010 <dirlink>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	57                   	push   %edi
80102014:	56                   	push   %esi
80102015:	53                   	push   %ebx
80102016:	83 ec 20             	sub    $0x20,%esp
80102019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010201c:	6a 00                	push   $0x0
8010201e:	ff 75 0c             	push   0xc(%ebp)
80102021:	53                   	push   %ebx
80102022:	e8 19 fd ff ff       	call   80101d40 <dirlookup>
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	85 c0                	test   %eax,%eax
8010202c:	75 67                	jne    80102095 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010202e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102031:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102034:	85 ff                	test   %edi,%edi
80102036:	74 29                	je     80102061 <dirlink+0x51>
80102038:	31 ff                	xor    %edi,%edi
8010203a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010203d:	eb 09                	jmp    80102048 <dirlink+0x38>
8010203f:	90                   	nop
80102040:	83 c7 10             	add    $0x10,%edi
80102043:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102046:	73 19                	jae    80102061 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102048:	6a 10                	push   $0x10
8010204a:	57                   	push   %edi
8010204b:	56                   	push   %esi
8010204c:	53                   	push   %ebx
8010204d:	e8 ae fa ff ff       	call   80101b00 <readi>
80102052:	83 c4 10             	add    $0x10,%esp
80102055:	83 f8 10             	cmp    $0x10,%eax
80102058:	75 4e                	jne    801020a8 <dirlink+0x98>
    if(de.inum == 0)
8010205a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010205f:	75 df                	jne    80102040 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102061:	83 ec 04             	sub    $0x4,%esp
80102064:	8d 45 da             	lea    -0x26(%ebp),%eax
80102067:	6a 0e                	push   $0xe
80102069:	ff 75 0c             	push   0xc(%ebp)
8010206c:	50                   	push   %eax
8010206d:	e8 ce 27 00 00       	call   80104840 <strncpy>
  de.inum = inum;
80102072:	8b 45 10             	mov    0x10(%ebp),%eax
80102075:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102079:	6a 10                	push   $0x10
8010207b:	57                   	push   %edi
8010207c:	56                   	push   %esi
8010207d:	53                   	push   %ebx
8010207e:	e8 7d fb ff ff       	call   80101c00 <writei>
80102083:	83 c4 20             	add    $0x20,%esp
80102086:	83 f8 10             	cmp    $0x10,%eax
80102089:	75 2a                	jne    801020b5 <dirlink+0xa5>
  return 0;
8010208b:	31 c0                	xor    %eax,%eax
}
8010208d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102090:	5b                   	pop    %ebx
80102091:	5e                   	pop    %esi
80102092:	5f                   	pop    %edi
80102093:	5d                   	pop    %ebp
80102094:	c3                   	ret
    iput(ip);
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	50                   	push   %eax
80102099:	e8 82 f8 ff ff       	call   80101920 <iput>
    return -1;
8010209e:	83 c4 10             	add    $0x10,%esp
801020a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a6:	eb e5                	jmp    8010208d <dirlink+0x7d>
      panic("dirlink read");
801020a8:	83 ec 0c             	sub    $0xc,%esp
801020ab:	68 30 73 10 80       	push   $0x80107330
801020b0:	e8 cb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	68 8c 75 10 80       	push   $0x8010758c
801020bd:	e8 be e2 ff ff       	call   80100380 <panic>
801020c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020c9:	00 
801020ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020d0 <namei>:

struct inode*
namei(char *path)
{
801020d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020d1:	31 d2                	xor    %edx,%edx
{
801020d3:	89 e5                	mov    %esp,%ebp
801020d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020d8:	8b 45 08             	mov    0x8(%ebp),%eax
801020db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020de:	e8 0d fd ff ff       	call   80101df0 <namex>
}
801020e3:	c9                   	leave
801020e4:	c3                   	ret
801020e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ec:	00 
801020ed:	8d 76 00             	lea    0x0(%esi),%esi

801020f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020f0:	55                   	push   %ebp
  return namex(path, 1, name);
801020f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020ff:	e9 ec fc ff ff       	jmp    80101df0 <namex>
80102104:	66 90                	xchg   %ax,%ax
80102106:	66 90                	xchg   %ax,%ax
80102108:	66 90                	xchg   %ax,%ax
8010210a:	66 90                	xchg   %ax,%ax
8010210c:	66 90                	xchg   %ax,%ax
8010210e:	66 90                	xchg   %ax,%ax

80102110 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102119:	85 c0                	test   %eax,%eax
8010211b:	0f 84 b4 00 00 00    	je     801021d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102121:	8b 70 08             	mov    0x8(%eax),%esi
80102124:	89 c3                	mov    %eax,%ebx
80102126:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010212c:	0f 87 96 00 00 00    	ja     801021c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102132:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102137:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010213e:	00 
8010213f:	90                   	nop
80102140:	89 ca                	mov    %ecx,%edx
80102142:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102143:	83 e0 c0             	and    $0xffffffc0,%eax
80102146:	3c 40                	cmp    $0x40,%al
80102148:	75 f6                	jne    80102140 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010214a:	31 ff                	xor    %edi,%edi
8010214c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102151:	89 f8                	mov    %edi,%eax
80102153:	ee                   	out    %al,(%dx)
80102154:	b8 01 00 00 00       	mov    $0x1,%eax
80102159:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010215e:	ee                   	out    %al,(%dx)
8010215f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102164:	89 f0                	mov    %esi,%eax
80102166:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102167:	89 f0                	mov    %esi,%eax
80102169:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010216e:	c1 f8 08             	sar    $0x8,%eax
80102171:	ee                   	out    %al,(%dx)
80102172:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102177:	89 f8                	mov    %edi,%eax
80102179:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010217a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010217e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102183:	c1 e0 04             	shl    $0x4,%eax
80102186:	83 e0 10             	and    $0x10,%eax
80102189:	83 c8 e0             	or     $0xffffffe0,%eax
8010218c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010218d:	f6 03 04             	testb  $0x4,(%ebx)
80102190:	75 16                	jne    801021a8 <idestart+0x98>
80102192:	b8 20 00 00 00       	mov    $0x20,%eax
80102197:	89 ca                	mov    %ecx,%edx
80102199:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010219a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010219d:	5b                   	pop    %ebx
8010219e:	5e                   	pop    %esi
8010219f:	5f                   	pop    %edi
801021a0:	5d                   	pop    %ebp
801021a1:	c3                   	ret
801021a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021a8:	b8 30 00 00 00       	mov    $0x30,%eax
801021ad:	89 ca                	mov    %ecx,%edx
801021af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021bd:	fc                   	cld
801021be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c3:	5b                   	pop    %ebx
801021c4:	5e                   	pop    %esi
801021c5:	5f                   	pop    %edi
801021c6:	5d                   	pop    %ebp
801021c7:	c3                   	ret
    panic("incorrect blockno");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 46 73 10 80       	push   $0x80107346
801021d0:	e8 ab e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 3d 73 10 80       	push   $0x8010733d
801021dd:	e8 9e e1 ff ff       	call   80100380 <panic>
801021e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021e9:	00 
801021ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021f0 <ideinit>:
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021f6:	68 58 73 10 80       	push   $0x80107358
801021fb:	68 00 16 11 80       	push   $0x80111600
80102200:	e8 fb 21 00 00       	call   80104400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102205:	58                   	pop    %eax
80102206:	a1 84 17 11 80       	mov    0x80111784,%eax
8010220b:	5a                   	pop    %edx
8010220c:	83 e8 01             	sub    $0x1,%eax
8010220f:	50                   	push   %eax
80102210:	6a 0e                	push   $0xe
80102212:	e8 99 02 00 00       	call   801024b0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102217:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010221a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010221f:	90                   	nop
80102220:	89 ca                	mov    %ecx,%edx
80102222:	ec                   	in     (%dx),%al
80102223:	83 e0 c0             	and    $0xffffffc0,%eax
80102226:	3c 40                	cmp    $0x40,%al
80102228:	75 f6                	jne    80102220 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010222a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010222f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102234:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102235:	89 ca                	mov    %ecx,%edx
80102237:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102238:	84 c0                	test   %al,%al
8010223a:	75 1e                	jne    8010225a <ideinit+0x6a>
8010223c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102241:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010224d:	00 
8010224e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102250:	83 e9 01             	sub    $0x1,%ecx
80102253:	74 0f                	je     80102264 <ideinit+0x74>
80102255:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102256:	84 c0                	test   %al,%al
80102258:	74 f6                	je     80102250 <ideinit+0x60>
      havedisk1 = 1;
8010225a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102261:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102264:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102269:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010226e:	ee                   	out    %al,(%dx)
}
8010226f:	c9                   	leave
80102270:	c3                   	ret
80102271:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102278:	00 
80102279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102280 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	57                   	push   %edi
80102284:	56                   	push   %esi
80102285:	53                   	push   %ebx
80102286:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102289:	68 00 16 11 80       	push   $0x80111600
8010228e:	e8 5d 23 00 00       	call   801045f0 <acquire>

  if((b = idequeue) == 0){
80102293:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102299:	83 c4 10             	add    $0x10,%esp
8010229c:	85 db                	test   %ebx,%ebx
8010229e:	74 63                	je     80102303 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022a0:	8b 43 58             	mov    0x58(%ebx),%eax
801022a3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022a8:	8b 33                	mov    (%ebx),%esi
801022aa:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022b0:	75 2f                	jne    801022e1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022be:	00 
801022bf:	90                   	nop
801022c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c1:	89 c1                	mov    %eax,%ecx
801022c3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022c6:	80 f9 40             	cmp    $0x40,%cl
801022c9:	75 f5                	jne    801022c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022cb:	a8 21                	test   $0x21,%al
801022cd:	75 12                	jne    801022e1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022cf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022d2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022d7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022dc:	fc                   	cld
801022dd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022df:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022e1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022e4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022e7:	83 ce 02             	or     $0x2,%esi
801022ea:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ec:	53                   	push   %ebx
801022ed:	e8 3e 1e 00 00       	call   80104130 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022f2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022f7:	83 c4 10             	add    $0x10,%esp
801022fa:	85 c0                	test   %eax,%eax
801022fc:	74 05                	je     80102303 <ideintr+0x83>
    idestart(idequeue);
801022fe:	e8 0d fe ff ff       	call   80102110 <idestart>
    release(&idelock);
80102303:	83 ec 0c             	sub    $0xc,%esp
80102306:	68 00 16 11 80       	push   $0x80111600
8010230b:	e8 80 22 00 00       	call   80104590 <release>

  release(&idelock);
}
80102310:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102313:	5b                   	pop    %ebx
80102314:	5e                   	pop    %esi
80102315:	5f                   	pop    %edi
80102316:	5d                   	pop    %ebp
80102317:	c3                   	ret
80102318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010231f:	00 

80102320 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 10             	sub    $0x10,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010232a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010232d:	50                   	push   %eax
8010232e:	e8 7d 20 00 00       	call   801043b0 <holdingsleep>
80102333:	83 c4 10             	add    $0x10,%esp
80102336:	85 c0                	test   %eax,%eax
80102338:	0f 84 c3 00 00 00    	je     80102401 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 e0 06             	and    $0x6,%eax
80102343:	83 f8 02             	cmp    $0x2,%eax
80102346:	0f 84 a8 00 00 00    	je     801023f4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010234c:	8b 53 04             	mov    0x4(%ebx),%edx
8010234f:	85 d2                	test   %edx,%edx
80102351:	74 0d                	je     80102360 <iderw+0x40>
80102353:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102358:	85 c0                	test   %eax,%eax
8010235a:	0f 84 87 00 00 00    	je     801023e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 00 16 11 80       	push   $0x80111600
80102368:	e8 83 22 00 00       	call   801045f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010236d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102372:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102379:	83 c4 10             	add    $0x10,%esp
8010237c:	85 c0                	test   %eax,%eax
8010237e:	74 60                	je     801023e0 <iderw+0xc0>
80102380:	89 c2                	mov    %eax,%edx
80102382:	8b 40 58             	mov    0x58(%eax),%eax
80102385:	85 c0                	test   %eax,%eax
80102387:	75 f7                	jne    80102380 <iderw+0x60>
80102389:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010238c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010238e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102394:	74 3a                	je     801023d0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102396:	8b 03                	mov    (%ebx),%eax
80102398:	83 e0 06             	and    $0x6,%eax
8010239b:	83 f8 02             	cmp    $0x2,%eax
8010239e:	74 1b                	je     801023bb <iderw+0x9b>
    sleep(b, &idelock);
801023a0:	83 ec 08             	sub    $0x8,%esp
801023a3:	68 00 16 11 80       	push   $0x80111600
801023a8:	53                   	push   %ebx
801023a9:	e8 c2 1c 00 00       	call   80104070 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ae:	8b 03                	mov    (%ebx),%eax
801023b0:	83 c4 10             	add    $0x10,%esp
801023b3:	83 e0 06             	and    $0x6,%eax
801023b6:	83 f8 02             	cmp    $0x2,%eax
801023b9:	75 e5                	jne    801023a0 <iderw+0x80>
  }


  release(&idelock);
801023bb:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801023c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023c5:	c9                   	leave
  release(&idelock);
801023c6:	e9 c5 21 00 00       	jmp    80104590 <release>
801023cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023d0:	89 d8                	mov    %ebx,%eax
801023d2:	e8 39 fd ff ff       	call   80102110 <idestart>
801023d7:	eb bd                	jmp    80102396 <iderw+0x76>
801023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023e5:	eb a5                	jmp    8010238c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	68 87 73 10 80       	push   $0x80107387
801023ef:	e8 8c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	68 72 73 10 80       	push   $0x80107372
801023fc:	e8 7f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102401:	83 ec 0c             	sub    $0xc,%esp
80102404:	68 5c 73 10 80       	push   $0x8010735c
80102409:	e8 72 df ff ff       	call   80100380 <panic>
8010240e:	66 90                	xchg   %ax,%ax

80102410 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102415:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010241c:	00 c0 fe 
  ioapic->reg = reg;
8010241f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102426:	00 00 00 
  return ioapic->data;
80102429:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010242f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102432:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102438:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010243e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102445:	c1 ee 10             	shr    $0x10,%esi
80102448:	89 f0                	mov    %esi,%eax
8010244a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010244d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102450:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102453:	39 c2                	cmp    %eax,%edx
80102455:	74 16                	je     8010246d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102457:	83 ec 0c             	sub    $0xc,%esp
8010245a:	68 44 77 10 80       	push   $0x80107744
8010245f:	e8 4c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102464:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010246a:	83 c4 10             	add    $0x10,%esp
{
8010246d:	ba 10 00 00 00       	mov    $0x10,%edx
80102472:	31 c0                	xor    %eax,%eax
80102474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102478:	89 13                	mov    %edx,(%ebx)
8010247a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010247d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102483:	83 c0 01             	add    $0x1,%eax
80102486:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010248c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010248f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102492:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102495:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102497:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010249d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024a4:	39 c6                	cmp    %eax,%esi
801024a6:	7d d0                	jge    80102478 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret
801024af:	90                   	nop

801024b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024b0:	55                   	push   %ebp
  ioapic->reg = reg;
801024b1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801024b7:	89 e5                	mov    %esp,%ebp
801024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024bc:	8d 50 20             	lea    0x20(%eax),%edx
801024bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024d6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024de:	89 50 10             	mov    %edx,0x10(%eax)
}
801024e1:	5d                   	pop    %ebp
801024e2:	c3                   	ret
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	53                   	push   %ebx
801024f4:	83 ec 04             	sub    $0x4,%esp
801024f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102500:	75 76                	jne    80102578 <kfree+0x88>
80102502:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
80102508:	72 6e                	jb     80102578 <kfree+0x88>
8010250a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102510:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102515:	77 61                	ja     80102578 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102517:	83 ec 04             	sub    $0x4,%esp
8010251a:	68 00 10 00 00       	push   $0x1000
8010251f:	6a 01                	push   $0x1
80102521:	53                   	push   %ebx
80102522:	e8 c9 21 00 00       	call   801046f0 <memset>

  if(kmem.use_lock)
80102527:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	85 d2                	test   %edx,%edx
80102532:	75 1c                	jne    80102550 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102534:	a1 78 16 11 80       	mov    0x80111678,%eax
80102539:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010253b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102540:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102546:	85 c0                	test   %eax,%eax
80102548:	75 1e                	jne    80102568 <kfree+0x78>
    release(&kmem.lock);
}
8010254a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010254d:	c9                   	leave
8010254e:	c3                   	ret
8010254f:	90                   	nop
    acquire(&kmem.lock);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 40 16 11 80       	push   $0x80111640
80102558:	e8 93 20 00 00       	call   801045f0 <acquire>
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	eb d2                	jmp    80102534 <kfree+0x44>
80102562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102568:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010256f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102572:	c9                   	leave
    release(&kmem.lock);
80102573:	e9 18 20 00 00       	jmp    80104590 <release>
    panic("kfree");
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	68 a5 73 10 80       	push   $0x801073a5
80102580:	e8 fb dd ff ff       	call   80100380 <panic>
80102585:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010258c:	00 
8010258d:	8d 76 00             	lea    0x0(%esi),%esi

80102590 <freerange>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102595:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <freerange+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 23 ff ff ff       	call   801024f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <freerange+0x28>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret
801025db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025e0 <kinit2>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <kinit2+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 d3 fe ff ff       	call   801024f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret
80102635:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010263c:	00 
8010263d:	8d 76 00             	lea    0x0(%esi),%esi

80102640 <kinit1>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
80102645:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102648:	83 ec 08             	sub    $0x8,%esp
8010264b:	68 ab 73 10 80       	push   $0x801073ab
80102650:	68 40 16 11 80       	push   $0x80111640
80102655:	e8 a6 1d 00 00       	call   80104400 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102660:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102667:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010266a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102670:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102676:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267c:	39 de                	cmp    %ebx,%esi
8010267e:	72 1c                	jb     8010269c <kinit1+0x5c>
    kfree(p);
80102680:	83 ec 0c             	sub    $0xc,%esp
80102683:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102689:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010268f:	50                   	push   %eax
80102690:	e8 5b fe ff ff       	call   801024f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102695:	83 c4 10             	add    $0x10,%esp
80102698:	39 de                	cmp    %ebx,%esi
8010269a:	73 e4                	jae    80102680 <kinit1+0x40>
}
8010269c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010269f:	5b                   	pop    %ebx
801026a0:	5e                   	pop    %esi
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret
801026a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026aa:	00 
801026ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026b7:	a1 74 16 11 80       	mov    0x80111674,%eax
801026bc:	85 c0                	test   %eax,%eax
801026be:	75 20                	jne    801026e0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026c0:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801026c6:	85 db                	test   %ebx,%ebx
801026c8:	74 07                	je     801026d1 <kalloc+0x21>
    kmem.freelist = r->next;
801026ca:	8b 03                	mov    (%ebx),%eax
801026cc:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026d1:	89 d8                	mov    %ebx,%eax
801026d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d6:	c9                   	leave
801026d7:	c3                   	ret
801026d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026df:	00 
    acquire(&kmem.lock);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	68 40 16 11 80       	push   $0x80111640
801026e8:	e8 03 1f 00 00       	call   801045f0 <acquire>
  r = kmem.freelist;
801026ed:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
801026f3:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
801026f8:	83 c4 10             	add    $0x10,%esp
801026fb:	85 db                	test   %ebx,%ebx
801026fd:	74 08                	je     80102707 <kalloc+0x57>
    kmem.freelist = r->next;
801026ff:	8b 13                	mov    (%ebx),%edx
80102701:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102707:	85 c0                	test   %eax,%eax
80102709:	74 c6                	je     801026d1 <kalloc+0x21>
    release(&kmem.lock);
8010270b:	83 ec 0c             	sub    $0xc,%esp
8010270e:	68 40 16 11 80       	push   $0x80111640
80102713:	e8 78 1e 00 00       	call   80104590 <release>
}
80102718:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010271a:	83 c4 10             	add    $0x10,%esp
}
8010271d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102720:	c9                   	leave
80102721:	c3                   	ret
80102722:	66 90                	xchg   %ax,%ax
80102724:	66 90                	xchg   %ax,%ax
80102726:	66 90                	xchg   %ax,%ax
80102728:	66 90                	xchg   %ax,%ax
8010272a:	66 90                	xchg   %ax,%ax
8010272c:	66 90                	xchg   %ax,%ax
8010272e:	66 90                	xchg   %ax,%ax

80102730 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102730:	ba 64 00 00 00       	mov    $0x64,%edx
80102735:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102736:	a8 01                	test   $0x1,%al
80102738:	0f 84 c2 00 00 00    	je     80102800 <kbdgetc+0xd0>
{
8010273e:	55                   	push   %ebp
8010273f:	ba 60 00 00 00       	mov    $0x60,%edx
80102744:	89 e5                	mov    %esp,%ebp
80102746:	53                   	push   %ebx
80102747:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102748:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010274e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102751:	3c e0                	cmp    $0xe0,%al
80102753:	74 5b                	je     801027b0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102755:	89 da                	mov    %ebx,%edx
80102757:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010275a:	84 c0                	test   %al,%al
8010275c:	78 62                	js     801027c0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010275e:	85 d2                	test   %edx,%edx
80102760:	74 09                	je     8010276b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102762:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102765:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102768:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010276b:	0f b6 91 a0 79 10 80 	movzbl -0x7fef8660(%ecx),%edx
  shift ^= togglecode[data];
80102772:	0f b6 81 a0 78 10 80 	movzbl -0x7fef8760(%ecx),%eax
  shift |= shiftcode[data];
80102779:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010277b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010277d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010277f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102785:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102788:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010278b:	8b 04 85 80 78 10 80 	mov    -0x7fef8780(,%eax,4),%eax
80102792:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102796:	74 0b                	je     801027a3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102798:	8d 50 9f             	lea    -0x61(%eax),%edx
8010279b:	83 fa 19             	cmp    $0x19,%edx
8010279e:	77 48                	ja     801027e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027a0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a6:	c9                   	leave
801027a7:	c3                   	ret
801027a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027af:	00 
    shift |= E0ESC;
801027b0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027b3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027b5:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
801027bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027be:	c9                   	leave
801027bf:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801027c0:	83 e0 7f             	and    $0x7f,%eax
801027c3:	85 d2                	test   %edx,%edx
801027c5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027c8:	0f b6 81 a0 79 10 80 	movzbl -0x7fef8660(%ecx),%eax
801027cf:	83 c8 40             	or     $0x40,%eax
801027d2:	0f b6 c0             	movzbl %al,%eax
801027d5:	f7 d0                	not    %eax
801027d7:	21 d8                	and    %ebx,%eax
801027d9:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027de:	31 c0                	xor    %eax,%eax
801027e0:	eb d9                	jmp    801027bb <kbdgetc+0x8b>
801027e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027f1:	c9                   	leave
      c += 'a' - 'A';
801027f2:	83 f9 1a             	cmp    $0x1a,%ecx
801027f5:	0f 42 c2             	cmovb  %edx,%eax
}
801027f8:	c3                   	ret
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102805:	c3                   	ret
80102806:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010280d:	00 
8010280e:	66 90                	xchg   %ax,%ax

80102810 <kbdintr>:

void
kbdintr(void)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102816:	68 30 27 10 80       	push   $0x80102730
8010281b:	e8 80 e0 ff ff       	call   801008a0 <consoleintr>
}
80102820:	83 c4 10             	add    $0x10,%esp
80102823:	c9                   	leave
80102824:	c3                   	ret
80102825:	66 90                	xchg   %ax,%ax
80102827:	66 90                	xchg   %ax,%ax
80102829:	66 90                	xchg   %ax,%ax
8010282b:	66 90                	xchg   %ax,%ax
8010282d:	66 90                	xchg   %ax,%ax
8010282f:	90                   	nop

80102830 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102830:	a1 80 16 11 80       	mov    0x80111680,%eax
80102835:	85 c0                	test   %eax,%eax
80102837:	0f 84 c3 00 00 00    	je     80102900 <lapicinit+0xd0>
  lapic[index] = value;
8010283d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102844:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102851:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102854:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102857:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010285e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102861:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102864:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010286b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102871:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102878:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102885:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102888:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010288b:	8b 50 30             	mov    0x30(%eax),%edx
8010288e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102894:	75 72                	jne    80102908 <lapicinit+0xd8>
  lapic[index] = value;
80102896:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010289d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028bd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ca:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028d1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028de:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028e8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028ee:	80 e6 10             	and    $0x10,%dh
801028f1:	75 f5                	jne    801028e8 <lapicinit+0xb8>
  lapic[index] = value;
801028f3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fd:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102900:	c3                   	ret
80102901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102908:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010290f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102912:	8b 50 20             	mov    0x20(%eax),%edx
}
80102915:	e9 7c ff ff ff       	jmp    80102896 <lapicinit+0x66>
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102920 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102920:	a1 80 16 11 80       	mov    0x80111680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 07                	je     80102930 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102929:	8b 40 20             	mov    0x20(%eax),%eax
8010292c:	c1 e8 18             	shr    $0x18,%eax
8010292f:	c3                   	ret
    return 0;
80102930:	31 c0                	xor    %eax,%eax
}
80102932:	c3                   	ret
80102933:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010293a:	00 
8010293b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102940 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102940:	a1 80 16 11 80       	mov    0x80111680,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	74 0d                	je     80102956 <lapiceoi+0x16>
  lapic[index] = value;
80102949:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102950:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102953:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102956:	c3                   	ret
80102957:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010295e:	00 
8010295f:	90                   	nop

80102960 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102960:	c3                   	ret
80102961:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102968:	00 
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102970 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102970:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102971:	b8 0f 00 00 00       	mov    $0xf,%eax
80102976:	ba 70 00 00 00       	mov    $0x70,%edx
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	53                   	push   %ebx
8010297e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102981:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102984:	ee                   	out    %al,(%dx)
80102985:	b8 0a 00 00 00       	mov    $0xa,%eax
8010298a:	ba 71 00 00 00       	mov    $0x71,%edx
8010298f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102990:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102992:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102995:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010299b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010299d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
801029a0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029a2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029a5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029a8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ae:	a1 80 16 11 80       	mov    0x80111680,%eax
801029b3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029c3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029d0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029dc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029df:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029fd:	c9                   	leave
801029fe:	c3                   	ret
801029ff:	90                   	nop

80102a00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a00:	55                   	push   %ebp
80102a01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a06:	ba 70 00 00 00       	mov    $0x70,%edx
80102a0b:	89 e5                	mov    %esp,%ebp
80102a0d:	57                   	push   %edi
80102a0e:	56                   	push   %esi
80102a0f:	53                   	push   %ebx
80102a10:	83 ec 4c             	sub    $0x4c,%esp
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	ba 71 00 00 00       	mov    $0x71,%edx
80102a19:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a25:	8d 76 00             	lea    0x0(%esi),%esi
80102a28:	31 c0                	xor    %eax,%eax
80102a2a:	89 fa                	mov    %edi,%edx
80102a2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a32:	89 ca                	mov    %ecx,%edx
80102a34:	ec                   	in     (%dx),%al
80102a35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 fa                	mov    %edi,%edx
80102a3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a40:	89 ca                	mov    %ecx,%edx
80102a42:	ec                   	in     (%dx),%al
80102a43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a46:	89 fa                	mov    %edi,%edx
80102a48:	b8 04 00 00 00       	mov    $0x4,%eax
80102a4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4e:	89 ca                	mov    %ecx,%edx
80102a50:	ec                   	in     (%dx),%al
80102a51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a54:	89 fa                	mov    %edi,%edx
80102a56:	b8 07 00 00 00       	mov    $0x7,%eax
80102a5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5c:	89 ca                	mov    %ecx,%edx
80102a5e:	ec                   	in     (%dx),%al
80102a5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a62:	89 fa                	mov    %edi,%edx
80102a64:	b8 08 00 00 00       	mov    $0x8,%eax
80102a69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6a:	89 ca                	mov    %ecx,%edx
80102a6c:	ec                   	in     (%dx),%al
80102a6d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	b8 09 00 00 00       	mov    $0x9,%eax
80102a76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a77:	89 ca                	mov    %ecx,%edx
80102a79:	ec                   	in     (%dx),%al
80102a7a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7d:	89 fa                	mov    %edi,%edx
80102a7f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a85:	89 ca                	mov    %ecx,%edx
80102a87:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a88:	84 c0                	test   %al,%al
80102a8a:	78 9c                	js     80102a28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a8c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a90:	89 f2                	mov    %esi,%edx
80102a92:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a95:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a98:	89 fa                	mov    %edi,%edx
80102a9a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a9d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102aa1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102aa4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102aa7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aab:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aae:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ab2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ab5:	31 c0                	xor    %eax,%eax
80102ab7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab8:	89 ca                	mov    %ecx,%edx
80102aba:	ec                   	in     (%dx),%al
80102abb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abe:	89 fa                	mov    %edi,%edx
80102ac0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ac3:	b8 02 00 00 00       	mov    $0x2,%eax
80102ac8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac9:	89 ca                	mov    %ecx,%edx
80102acb:	ec                   	in     (%dx),%al
80102acc:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acf:	89 fa                	mov    %edi,%edx
80102ad1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ad4:	b8 04 00 00 00       	mov    $0x4,%eax
80102ad9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ada:	89 ca                	mov    %ecx,%edx
80102adc:	ec                   	in     (%dx),%al
80102add:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae0:	89 fa                	mov    %edi,%edx
80102ae2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ae5:	b8 07 00 00 00       	mov    $0x7,%eax
80102aea:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aeb:	89 ca                	mov    %ecx,%edx
80102aed:	ec                   	in     (%dx),%al
80102aee:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af1:	89 fa                	mov    %edi,%edx
80102af3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102af6:	b8 08 00 00 00       	mov    $0x8,%eax
80102afb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afc:	89 ca                	mov    %ecx,%edx
80102afe:	ec                   	in     (%dx),%al
80102aff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b02:	89 fa                	mov    %edi,%edx
80102b04:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b07:	b8 09 00 00 00       	mov    $0x9,%eax
80102b0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0d:	89 ca                	mov    %ecx,%edx
80102b0f:	ec                   	in     (%dx),%al
80102b10:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b13:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b19:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b1c:	6a 18                	push   $0x18
80102b1e:	50                   	push   %eax
80102b1f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b22:	50                   	push   %eax
80102b23:	e8 08 1c 00 00       	call   80104730 <memcmp>
80102b28:	83 c4 10             	add    $0x10,%esp
80102b2b:	85 c0                	test   %eax,%eax
80102b2d:	0f 85 f5 fe ff ff    	jne    80102a28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b33:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b3a:	89 f0                	mov    %esi,%eax
80102b3c:	84 c0                	test   %al,%al
80102b3e:	75 78                	jne    80102bb8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b40:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b43:	89 c2                	mov    %eax,%edx
80102b45:	83 e0 0f             	and    $0xf,%eax
80102b48:	c1 ea 04             	shr    $0x4,%edx
80102b4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b51:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b54:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b57:	89 c2                	mov    %eax,%edx
80102b59:	83 e0 0f             	and    $0xf,%eax
80102b5c:	c1 ea 04             	shr    $0x4,%edx
80102b5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b65:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b68:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6b:	89 c2                	mov    %eax,%edx
80102b6d:	83 e0 0f             	and    $0xf,%eax
80102b70:	c1 ea 04             	shr    $0x4,%edx
80102b73:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b76:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b79:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b7c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7f:	89 c2                	mov    %eax,%edx
80102b81:	83 e0 0f             	and    $0xf,%eax
80102b84:	c1 ea 04             	shr    $0x4,%edx
80102b87:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b90:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b93:	89 c2                	mov    %eax,%edx
80102b95:	83 e0 0f             	and    $0xf,%eax
80102b98:	c1 ea 04             	shr    $0x4,%edx
80102b9b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ba4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba7:	89 c2                	mov    %eax,%edx
80102ba9:	83 e0 0f             	and    $0xf,%eax
80102bac:	c1 ea 04             	shr    $0x4,%edx
80102baf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bbb:	89 03                	mov    %eax,(%ebx)
80102bbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bc0:	89 43 04             	mov    %eax,0x4(%ebx)
80102bc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bc6:	89 43 08             	mov    %eax,0x8(%ebx)
80102bc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bcc:	89 43 0c             	mov    %eax,0xc(%ebx)
80102bcf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bd2:	89 43 10             	mov    %eax,0x10(%ebx)
80102bd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102bdb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102be5:	5b                   	pop    %ebx
80102be6:	5e                   	pop    %esi
80102be7:	5f                   	pop    %edi
80102be8:	5d                   	pop    %ebp
80102be9:	c3                   	ret
80102bea:	66 90                	xchg   %ax,%ax
80102bec:	66 90                	xchg   %ax,%ax
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bf6:	85 c9                	test   %ecx,%ecx
80102bf8:	0f 8e 8a 00 00 00    	jle    80102c88 <install_trans+0x98>
{
80102bfe:	55                   	push   %ebp
80102bff:	89 e5                	mov    %esp,%ebp
80102c01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c02:	31 ff                	xor    %edi,%edi
{
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c10:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102c15:	83 ec 08             	sub    $0x8,%esp
80102c18:	01 f8                	add    %edi,%eax
80102c1a:	83 c0 01             	add    $0x1,%eax
80102c1d:	50                   	push   %eax
80102c1e:	ff 35 e4 16 11 80    	push   0x801116e4
80102c24:	e8 a7 d4 ff ff       	call   801000d0 <bread>
80102c29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2b:	58                   	pop    %eax
80102c2c:	5a                   	pop    %edx
80102c2d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c34:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3d:	e8 8e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4a:	68 00 02 00 00       	push   $0x200
80102c4f:	50                   	push   %eax
80102c50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c53:	50                   	push   %eax
80102c54:	e8 27 1b 00 00       	call   80104780 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 4f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 87 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c69:	89 1c 24             	mov    %ebx,(%esp)
80102c6c:	e8 7f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c7a:	7f 94                	jg     80102c10 <install_trans+0x20>
  }
}
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c88:	c3                   	ret
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	53                   	push   %ebx
80102c94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c97:	ff 35 d4 16 11 80    	push   0x801116d4
80102c9d:	ff 35 e4 16 11 80    	push   0x801116e4
80102ca3:	e8 28 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ca8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cad:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102cb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	7e 19                	jle    80102cd2 <write_head+0x42>
80102cb9:	31 d2                	xor    %edx,%edx
80102cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102cc0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102cc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ccb:	83 c2 01             	add    $0x1,%edx
80102cce:	39 d0                	cmp    %edx,%eax
80102cd0:	75 ee                	jne    80102cc0 <write_head+0x30>
  }
  bwrite(buf);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	53                   	push   %ebx
80102cd6:	e8 d5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cdb:	89 1c 24             	mov    %ebx,(%esp)
80102cde:	e8 0d d5 ff ff       	call   801001f0 <brelse>
}
80102ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce6:	83 c4 10             	add    $0x10,%esp
80102ce9:	c9                   	leave
80102cea:	c3                   	ret
80102ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102cf0 <initlog>:
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 2c             	sub    $0x2c,%esp
80102cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cfa:	68 b0 73 10 80       	push   $0x801073b0
80102cff:	68 a0 16 11 80       	push   $0x801116a0
80102d04:	e8 f7 16 00 00       	call   80104400 <initlock>
  readsb(dev, &sb);
80102d09:	58                   	pop    %eax
80102d0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 7b e8 ff ff       	call   80101590 <readsb>
  log.start = sb.logstart;
80102d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d18:	59                   	pop    %ecx
  log.dev = dev;
80102d19:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102d1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d22:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d27:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d2d:	5a                   	pop    %edx
80102d2e:	50                   	push   %eax
80102d2f:	53                   	push   %ebx
80102d30:	e8 9b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d38:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d3b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d41:	85 db                	test   %ebx,%ebx
80102d43:	7e 1d                	jle    80102d62 <initlog+0x72>
80102d45:	31 d2                	xor    %edx,%edx
80102d47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d4e:	00 
80102d4f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d50:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d54:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	39 d3                	cmp    %edx,%ebx
80102d60:	75 ee                	jne    80102d50 <initlog+0x60>
  brelse(buf);
80102d62:	83 ec 0c             	sub    $0xc,%esp
80102d65:	50                   	push   %eax
80102d66:	e8 85 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d6b:	e8 80 fe ff ff       	call   80102bf0 <install_trans>
  log.lh.n = 0;
80102d70:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d77:	00 00 00 
  write_head(); // clear the log
80102d7a:	e8 11 ff ff ff       	call   80102c90 <write_head>
}
80102d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d82:	83 c4 10             	add    $0x10,%esp
80102d85:	c9                   	leave
80102d86:	c3                   	ret
80102d87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d8e:	00 
80102d8f:	90                   	nop

80102d90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d96:	68 a0 16 11 80       	push   $0x801116a0
80102d9b:	e8 50 18 00 00       	call   801045f0 <acquire>
80102da0:	83 c4 10             	add    $0x10,%esp
80102da3:	eb 18                	jmp    80102dbd <begin_op+0x2d>
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102da8:	83 ec 08             	sub    $0x8,%esp
80102dab:	68 a0 16 11 80       	push   $0x801116a0
80102db0:	68 a0 16 11 80       	push   $0x801116a0
80102db5:	e8 b6 12 00 00       	call   80104070 <sleep>
80102dba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dbd:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102dc2:	85 c0                	test   %eax,%eax
80102dc4:	75 e2                	jne    80102da8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dc6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102dcb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102dd1:	83 c0 01             	add    $0x1,%eax
80102dd4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dd7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dda:	83 fa 1e             	cmp    $0x1e,%edx
80102ddd:	7f c9                	jg     80102da8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ddf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102de2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102de7:	68 a0 16 11 80       	push   $0x801116a0
80102dec:	e8 9f 17 00 00       	call   80104590 <release>
      break;
    }
  }
}
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	c9                   	leave
80102df5:	c3                   	ret
80102df6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dfd:	00 
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	57                   	push   %edi
80102e04:	56                   	push   %esi
80102e05:	53                   	push   %ebx
80102e06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e09:	68 a0 16 11 80       	push   $0x801116a0
80102e0e:	e8 dd 17 00 00       	call   801045f0 <acquire>
  log.outstanding -= 1;
80102e13:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102e18:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102e1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e24:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e2a:	85 f6                	test   %esi,%esi
80102e2c:	0f 85 22 01 00 00    	jne    80102f54 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e32:	85 db                	test   %ebx,%ebx
80102e34:	0f 85 f6 00 00 00    	jne    80102f30 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e3a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e41:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e44:	83 ec 0c             	sub    $0xc,%esp
80102e47:	68 a0 16 11 80       	push   $0x801116a0
80102e4c:	e8 3f 17 00 00       	call   80104590 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e51:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e57:	83 c4 10             	add    $0x10,%esp
80102e5a:	85 c9                	test   %ecx,%ecx
80102e5c:	7f 42                	jg     80102ea0 <end_op+0xa0>
    acquire(&log.lock);
80102e5e:	83 ec 0c             	sub    $0xc,%esp
80102e61:	68 a0 16 11 80       	push   $0x801116a0
80102e66:	e8 85 17 00 00       	call   801045f0 <acquire>
    log.committing = 0;
80102e6b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e72:	00 00 00 
    wakeup(&log);
80102e75:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e7c:	e8 af 12 00 00       	call   80104130 <wakeup>
    release(&log.lock);
80102e81:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e88:	e8 03 17 00 00       	call   80104590 <release>
80102e8d:	83 c4 10             	add    $0x10,%esp
}
80102e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e93:	5b                   	pop    %ebx
80102e94:	5e                   	pop    %esi
80102e95:	5f                   	pop    %edi
80102e96:	5d                   	pop    %ebp
80102e97:	c3                   	ret
80102e98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e9f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ea0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	01 d8                	add    %ebx,%eax
80102eaa:	83 c0 01             	add    $0x1,%eax
80102ead:	50                   	push   %eax
80102eae:	ff 35 e4 16 11 80    	push   0x801116e4
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
80102eb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebb:	58                   	pop    %eax
80102ebc:	5a                   	pop    %edx
80102ebd:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102ec4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ecd:	e8 fe d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ed2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ed5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ed7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eda:	68 00 02 00 00       	push   $0x200
80102edf:	50                   	push   %eax
80102ee0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ee3:	50                   	push   %eax
80102ee4:	e8 97 18 00 00       	call   80104780 <memmove>
    bwrite(to);  // write the log
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 bf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ef1:	89 3c 24             	mov    %edi,(%esp)
80102ef4:	e8 f7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ef9:	89 34 24             	mov    %esi,(%esp)
80102efc:	e8 ef d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f01:	83 c4 10             	add    $0x10,%esp
80102f04:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102f0a:	7c 94                	jl     80102ea0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f0c:	e8 7f fd ff ff       	call   80102c90 <write_head>
    install_trans(); // Now install writes to home locations
80102f11:	e8 da fc ff ff       	call   80102bf0 <install_trans>
    log.lh.n = 0;
80102f16:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f1d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f20:	e8 6b fd ff ff       	call   80102c90 <write_head>
80102f25:	e9 34 ff ff ff       	jmp    80102e5e <end_op+0x5e>
80102f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f30:	83 ec 0c             	sub    $0xc,%esp
80102f33:	68 a0 16 11 80       	push   $0x801116a0
80102f38:	e8 f3 11 00 00       	call   80104130 <wakeup>
  release(&log.lock);
80102f3d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f44:	e8 47 16 00 00       	call   80104590 <release>
80102f49:	83 c4 10             	add    $0x10,%esp
}
80102f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5f                   	pop    %edi
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret
    panic("log.committing");
80102f54:	83 ec 0c             	sub    $0xc,%esp
80102f57:	68 b4 73 10 80       	push   $0x801073b4
80102f5c:	e8 1f d4 ff ff       	call   80100380 <panic>
80102f61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f68:	00 
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	53                   	push   %ebx
80102f74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f77:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f80:	83 fa 1d             	cmp    $0x1d,%edx
80102f83:	7f 7d                	jg     80103002 <log_write+0x92>
80102f85:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f8a:	83 e8 01             	sub    $0x1,%eax
80102f8d:	39 c2                	cmp    %eax,%edx
80102f8f:	7d 71                	jge    80103002 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f91:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	7e 75                	jle    8010300f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f9a:	83 ec 0c             	sub    $0xc,%esp
80102f9d:	68 a0 16 11 80       	push   $0x801116a0
80102fa2:	e8 49 16 00 00       	call   801045f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102faa:	83 c4 10             	add    $0x10,%esp
80102fad:	31 c0                	xor    %eax,%eax
80102faf:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102fb5:	85 d2                	test   %edx,%edx
80102fb7:	7f 0e                	jg     80102fc7 <log_write+0x57>
80102fb9:	eb 15                	jmp    80102fd0 <log_write+0x60>
80102fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fc0:	83 c0 01             	add    $0x1,%eax
80102fc3:	39 c2                	cmp    %eax,%edx
80102fc5:	74 29                	je     80102ff0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102fce:	75 f0                	jne    80102fc0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102fd7:	39 c2                	cmp    %eax,%edx
80102fd9:	74 1c                	je     80102ff7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fdb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fe1:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fe8:	c9                   	leave
  release(&log.lock);
80102fe9:	e9 a2 15 00 00       	jmp    80104590 <release>
80102fee:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102ff7:	83 c2 01             	add    $0x1,%edx
80102ffa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103000:	eb d9                	jmp    80102fdb <log_write+0x6b>
    panic("too big a transaction");
80103002:	83 ec 0c             	sub    $0xc,%esp
80103005:	68 c3 73 10 80       	push   $0x801073c3
8010300a:	e8 71 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010300f:	83 ec 0c             	sub    $0xc,%esp
80103012:	68 d9 73 10 80       	push   $0x801073d9
80103017:	e8 64 d3 ff ff       	call   80100380 <panic>
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103027:	e8 64 09 00 00       	call   80103990 <cpuid>
8010302c:	89 c3                	mov    %eax,%ebx
8010302e:	e8 5d 09 00 00       	call   80103990 <cpuid>
80103033:	83 ec 04             	sub    $0x4,%esp
80103036:	53                   	push   %ebx
80103037:	50                   	push   %eax
80103038:	68 f4 73 10 80       	push   $0x801073f4
8010303d:	e8 6e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103042:	e8 e9 28 00 00       	call   80105930 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103047:	e8 e4 08 00 00       	call   80103930 <mycpu>
8010304c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010304e:	b8 01 00 00 00       	mov    $0x1,%eax
80103053:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010305a:	e8 01 0c 00 00       	call   80103c60 <scheduler>
8010305f:	90                   	nop

80103060 <mpenter>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103066:	e8 c5 39 00 00       	call   80106a30 <switchkvm>
  seginit();
8010306b:	e8 30 39 00 00       	call   801069a0 <seginit>
  lapicinit();
80103070:	e8 bb f7 ff ff       	call   80102830 <lapicinit>
  mpmain();
80103075:	e8 a6 ff ff ff       	call   80103020 <mpmain>
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <main>:
{
80103080:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103084:	83 e4 f0             	and    $0xfffffff0,%esp
80103087:	ff 71 fc             	push   -0x4(%ecx)
8010308a:	55                   	push   %ebp
8010308b:	89 e5                	mov    %esp,%ebp
8010308d:	53                   	push   %ebx
8010308e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010308f:	83 ec 08             	sub    $0x8,%esp
80103092:	68 00 00 40 80       	push   $0x80400000
80103097:	68 d0 54 11 80       	push   $0x801154d0
8010309c:	e8 9f f5 ff ff       	call   80102640 <kinit1>
  kvmalloc();      // kernel page table
801030a1:	e8 4a 3e 00 00       	call   80106ef0 <kvmalloc>
  mpinit();        // detect other processors
801030a6:	e8 85 01 00 00       	call   80103230 <mpinit>
  lapicinit();     // interrupt controller
801030ab:	e8 80 f7 ff ff       	call   80102830 <lapicinit>
  seginit();       // segment descriptors
801030b0:	e8 eb 38 00 00       	call   801069a0 <seginit>
  picinit();       // disable pic
801030b5:	e8 86 03 00 00       	call   80103440 <picinit>
  ioapicinit();    // another interrupt controller
801030ba:	e8 51 f3 ff ff       	call   80102410 <ioapicinit>
  consoleinit();   // console hardware
801030bf:	e8 ec d9 ff ff       	call   80100ab0 <consoleinit>
  uartinit();      // serial port
801030c4:	e8 47 2b 00 00       	call   80105c10 <uartinit>
  pinit();         // process table
801030c9:	e8 42 08 00 00       	call   80103910 <pinit>
  tvinit();        // trap vectors
801030ce:	e8 dd 27 00 00       	call   801058b0 <tvinit>
  binit();         // buffer cache
801030d3:	e8 68 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030d8:	e8 a3 dd ff ff       	call   80100e80 <fileinit>
  ideinit();       // disk 
801030dd:	e8 0e f1 ff ff       	call   801021f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030e2:	83 c4 0c             	add    $0xc,%esp
801030e5:	68 8a 00 00 00       	push   $0x8a
801030ea:	68 8c a4 10 80       	push   $0x8010a48c
801030ef:	68 00 70 00 80       	push   $0x80007000
801030f4:	e8 87 16 00 00       	call   80104780 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030f9:	83 c4 10             	add    $0x10,%esp
801030fc:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103103:	00 00 00 
80103106:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010310b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103110:	76 7e                	jbe    80103190 <main+0x110>
80103112:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103117:	eb 20                	jmp    80103139 <main+0xb9>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103120:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103127:	00 00 00 
8010312a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103130:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103135:	39 c3                	cmp    %eax,%ebx
80103137:	73 57                	jae    80103190 <main+0x110>
    if(c == mycpu())  // We've started already.
80103139:	e8 f2 07 00 00       	call   80103930 <mycpu>
8010313e:	39 c3                	cmp    %eax,%ebx
80103140:	74 de                	je     80103120 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103142:	e8 69 f5 ff ff       	call   801026b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103147:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010314a:	c7 05 f8 6f 00 80 60 	movl   $0x80103060,0x80006ff8
80103151:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103154:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010315b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010315e:	05 00 10 00 00       	add    $0x1000,%eax
80103163:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103168:	0f b6 03             	movzbl (%ebx),%eax
8010316b:	68 00 70 00 00       	push   $0x7000
80103170:	50                   	push   %eax
80103171:	e8 fa f7 ff ff       	call   80102970 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	74 f6                	je     80103180 <main+0x100>
8010318a:	eb 94                	jmp    80103120 <main+0xa0>
8010318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103190:	83 ec 08             	sub    $0x8,%esp
80103193:	68 00 00 00 8e       	push   $0x8e000000
80103198:	68 00 00 40 80       	push   $0x80400000
8010319d:	e8 3e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
801031a2:	e8 39 08 00 00       	call   801039e0 <userinit>
  mpmain();        // finish this processor's setup
801031a7:	e8 74 fe ff ff       	call   80103020 <mpmain>
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031bb:	53                   	push   %ebx
  e = addr+len;
801031bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031c2:	39 de                	cmp    %ebx,%esi
801031c4:	72 10                	jb     801031d6 <mpsearch1+0x26>
801031c6:	eb 50                	jmp    80103218 <mpsearch1+0x68>
801031c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031cf:	00 
801031d0:	89 fe                	mov    %edi,%esi
801031d2:	39 df                	cmp    %ebx,%edi
801031d4:	73 42                	jae    80103218 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d6:	83 ec 04             	sub    $0x4,%esp
801031d9:	8d 7e 10             	lea    0x10(%esi),%edi
801031dc:	6a 04                	push   $0x4
801031de:	68 08 74 10 80       	push   $0x80107408
801031e3:	56                   	push   %esi
801031e4:	e8 47 15 00 00       	call   80104730 <memcmp>
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	85 c0                	test   %eax,%eax
801031ee:	75 e0                	jne    801031d0 <mpsearch1+0x20>
801031f0:	89 f2                	mov    %esi,%edx
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031f8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031fb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103200:	39 fa                	cmp    %edi,%edx
80103202:	75 f4                	jne    801031f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103204:	84 c0                	test   %al,%al
80103206:	75 c8                	jne    801031d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320b:	89 f0                	mov    %esi,%eax
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5f                   	pop    %edi
80103210:	5d                   	pop    %ebp
80103211:	c3                   	ret
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010321b:	31 f6                	xor    %esi,%esi
}
8010321d:	5b                   	pop    %ebx
8010321e:	89 f0                	mov    %esi,%eax
80103220:	5e                   	pop    %esi
80103221:	5f                   	pop    %edi
80103222:	5d                   	pop    %ebp
80103223:	c3                   	ret
80103224:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010322b:	00 
8010322c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103230 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103239:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103240:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103247:	c1 e0 08             	shl    $0x8,%eax
8010324a:	09 d0                	or     %edx,%eax
8010324c:	c1 e0 04             	shl    $0x4,%eax
8010324f:	75 1b                	jne    8010326c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103251:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103258:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010325f:	c1 e0 08             	shl    $0x8,%eax
80103262:	09 d0                	or     %edx,%eax
80103264:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103267:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010326c:	ba 00 04 00 00       	mov    $0x400,%edx
80103271:	e8 3a ff ff ff       	call   801031b0 <mpsearch1>
80103276:	89 c3                	mov    %eax,%ebx
80103278:	85 c0                	test   %eax,%eax
8010327a:	0f 84 58 01 00 00    	je     801033d8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103280:	8b 73 04             	mov    0x4(%ebx),%esi
80103283:	85 f6                	test   %esi,%esi
80103285:	0f 84 3d 01 00 00    	je     801033c8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010328b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103294:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103297:	6a 04                	push   $0x4
80103299:	68 0d 74 10 80       	push   $0x8010740d
8010329e:	50                   	push   %eax
8010329f:	e8 8c 14 00 00       	call   80104730 <memcmp>
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	85 c0                	test   %eax,%eax
801032a9:	0f 85 19 01 00 00    	jne    801033c8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801032af:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032b6:	3c 01                	cmp    $0x1,%al
801032b8:	74 08                	je     801032c2 <mpinit+0x92>
801032ba:	3c 04                	cmp    $0x4,%al
801032bc:	0f 85 06 01 00 00    	jne    801033c8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801032c2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032c9:	66 85 d2             	test   %dx,%dx
801032cc:	74 22                	je     801032f0 <mpinit+0xc0>
801032ce:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032d1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032d3:	31 d2                	xor    %edx,%edx
801032d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032df:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032e4:	39 f8                	cmp    %edi,%eax
801032e6:	75 f0                	jne    801032d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032e8:	84 d2                	test   %dl,%dl
801032ea:	0f 85 d8 00 00 00    	jne    801033c8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032f0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801032f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801032fc:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103301:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103308:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010330e:	01 d7                	add    %edx,%edi
80103310:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103312:	bf 01 00 00 00       	mov    $0x1,%edi
80103317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010331e:	00 
8010331f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103320:	39 d0                	cmp    %edx,%eax
80103322:	73 19                	jae    8010333d <mpinit+0x10d>
    switch(*p){
80103324:	0f b6 08             	movzbl (%eax),%ecx
80103327:	80 f9 02             	cmp    $0x2,%cl
8010332a:	0f 84 80 00 00 00    	je     801033b0 <mpinit+0x180>
80103330:	77 6e                	ja     801033a0 <mpinit+0x170>
80103332:	84 c9                	test   %cl,%cl
80103334:	74 3a                	je     80103370 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103336:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103339:	39 d0                	cmp    %edx,%eax
8010333b:	72 e7                	jb     80103324 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010333d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103340:	85 ff                	test   %edi,%edi
80103342:	0f 84 dd 00 00 00    	je     80103425 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103348:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010334c:	74 15                	je     80103363 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010334e:	b8 70 00 00 00       	mov    $0x70,%eax
80103353:	ba 22 00 00 00       	mov    $0x22,%edx
80103358:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103359:	ba 23 00 00 00       	mov    $0x23,%edx
8010335e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010335f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103362:	ee                   	out    %al,(%dx)
  }
}
80103363:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103366:	5b                   	pop    %ebx
80103367:	5e                   	pop    %esi
80103368:	5f                   	pop    %edi
80103369:	5d                   	pop    %ebp
8010336a:	c3                   	ret
8010336b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103370:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	eb 87                	jmp    80103320 <mpinit+0xf0>
80103399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801033a0:	83 e9 03             	sub    $0x3,%ecx
801033a3:	80 f9 01             	cmp    $0x1,%cl
801033a6:	76 8e                	jbe    80103336 <mpinit+0x106>
801033a8:	31 ff                	xor    %edi,%edi
801033aa:	e9 71 ff ff ff       	jmp    80103320 <mpinit+0xf0>
801033af:	90                   	nop
      ioapicid = ioapic->apicno;
801033b0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033b7:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
801033bd:	e9 5e ff ff ff       	jmp    80103320 <mpinit+0xf0>
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033c8:	83 ec 0c             	sub    $0xc,%esp
801033cb:	68 12 74 10 80       	push   $0x80107412
801033d0:	e8 ab cf ff ff       	call   80100380 <panic>
801033d5:	8d 76 00             	lea    0x0(%esi),%esi
{
801033d8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033dd:	eb 0b                	jmp    801033ea <mpinit+0x1ba>
801033df:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801033e0:	89 f3                	mov    %esi,%ebx
801033e2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033e8:	74 de                	je     801033c8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ea:	83 ec 04             	sub    $0x4,%esp
801033ed:	8d 73 10             	lea    0x10(%ebx),%esi
801033f0:	6a 04                	push   $0x4
801033f2:	68 08 74 10 80       	push   $0x80107408
801033f7:	53                   	push   %ebx
801033f8:	e8 33 13 00 00       	call   80104730 <memcmp>
801033fd:	83 c4 10             	add    $0x10,%esp
80103400:	85 c0                	test   %eax,%eax
80103402:	75 dc                	jne    801033e0 <mpinit+0x1b0>
80103404:	89 da                	mov    %ebx,%edx
80103406:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010340d:	00 
8010340e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103410:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103413:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103416:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103418:	39 d6                	cmp    %edx,%esi
8010341a:	75 f4                	jne    80103410 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010341c:	84 c0                	test   %al,%al
8010341e:	75 c0                	jne    801033e0 <mpinit+0x1b0>
80103420:	e9 5b fe ff ff       	jmp    80103280 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103425:	83 ec 0c             	sub    $0xc,%esp
80103428:	68 78 77 10 80       	push   $0x80107778
8010342d:	e8 4e cf ff ff       	call   80100380 <panic>
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <picinit>:
80103440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103445:	ba 21 00 00 00       	mov    $0x21,%edx
8010344a:	ee                   	out    %al,(%dx)
8010344b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103450:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103451:	c3                   	ret
80103452:	66 90                	xchg   %ax,%ax
80103454:	66 90                	xchg   %ax,%ax
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8b 75 08             	mov    0x8(%ebp),%esi
8010346c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010346f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103475:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010347b:	e8 20 da ff ff       	call   80100ea0 <filealloc>
80103480:	89 06                	mov    %eax,(%esi)
80103482:	85 c0                	test   %eax,%eax
80103484:	0f 84 a5 00 00 00    	je     8010352f <pipealloc+0xcf>
8010348a:	e8 11 da ff ff       	call   80100ea0 <filealloc>
8010348f:	89 07                	mov    %eax,(%edi)
80103491:	85 c0                	test   %eax,%eax
80103493:	0f 84 84 00 00 00    	je     8010351d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103499:	e8 12 f2 ff ff       	call   801026b0 <kalloc>
8010349e:	89 c3                	mov    %eax,%ebx
801034a0:	85 c0                	test   %eax,%eax
801034a2:	0f 84 a0 00 00 00    	je     80103548 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801034a8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034af:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034b2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034bc:	00 00 00 
  p->nwrite = 0;
801034bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034c6:	00 00 00 
  p->nread = 0;
801034c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034d0:	00 00 00 
  initlock(&p->lock, "pipe");
801034d3:	68 2a 74 10 80       	push   $0x8010742a
801034d8:	50                   	push   %eax
801034d9:	e8 22 0f 00 00       	call   80104400 <initlock>
  (*f0)->type = FD_PIPE;
801034de:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034e0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034e9:	8b 06                	mov    (%esi),%eax
801034eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034ef:	8b 06                	mov    (%esi),%eax
801034f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034f5:	8b 06                	mov    (%esi),%eax
801034f7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034fa:	8b 07                	mov    (%edi),%eax
801034fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103502:	8b 07                	mov    (%edi),%eax
80103504:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103508:	8b 07                	mov    (%edi),%eax
8010350a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010350e:	8b 07                	mov    (%edi),%eax
80103510:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103513:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103515:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103518:	5b                   	pop    %ebx
80103519:	5e                   	pop    %esi
8010351a:	5f                   	pop    %edi
8010351b:	5d                   	pop    %ebp
8010351c:	c3                   	ret
  if(*f0)
8010351d:	8b 06                	mov    (%esi),%eax
8010351f:	85 c0                	test   %eax,%eax
80103521:	74 1e                	je     80103541 <pipealloc+0xe1>
    fileclose(*f0);
80103523:	83 ec 0c             	sub    $0xc,%esp
80103526:	50                   	push   %eax
80103527:	e8 34 da ff ff       	call   80100f60 <fileclose>
8010352c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010352f:	8b 07                	mov    (%edi),%eax
80103531:	85 c0                	test   %eax,%eax
80103533:	74 0c                	je     80103541 <pipealloc+0xe1>
    fileclose(*f1);
80103535:	83 ec 0c             	sub    $0xc,%esp
80103538:	50                   	push   %eax
80103539:	e8 22 da ff ff       	call   80100f60 <fileclose>
8010353e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103546:	eb cd                	jmp    80103515 <pipealloc+0xb5>
  if(*f0)
80103548:	8b 06                	mov    (%esi),%eax
8010354a:	85 c0                	test   %eax,%eax
8010354c:	75 d5                	jne    80103523 <pipealloc+0xc3>
8010354e:	eb df                	jmp    8010352f <pipealloc+0xcf>

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103558:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	53                   	push   %ebx
8010355f:	e8 8c 10 00 00       	call   801045f0 <acquire>
  if(writable){
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	85 f6                	test   %esi,%esi
80103569:	74 65                	je     801035d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103574:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357b:	00 00 00 
    wakeup(&p->nread);
8010357e:	50                   	push   %eax
8010357f:	e8 ac 0b 00 00       	call   80104130 <wakeup>
80103584:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103587:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010358d:	85 d2                	test   %edx,%edx
8010358f:	75 0a                	jne    8010359b <pipeclose+0x4b>
80103591:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	74 15                	je     801035b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010359e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a1:	5b                   	pop    %ebx
801035a2:	5e                   	pop    %esi
801035a3:	5d                   	pop    %ebp
    release(&p->lock);
801035a4:	e9 e7 0f 00 00       	jmp    80104590 <release>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 d7 0f 00 00       	call   80104590 <release>
    kfree((char*)p);
801035b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035bc:	83 c4 10             	add    $0x10,%esp
}
801035bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c2:	5b                   	pop    %ebx
801035c3:	5e                   	pop    %esi
801035c4:	5d                   	pop    %ebp
    kfree((char*)p);
801035c5:	e9 26 ef ff ff       	jmp    801024f0 <kfree>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035e0:	00 00 00 
    wakeup(&p->nwrite);
801035e3:	50                   	push   %eax
801035e4:	e8 47 0b 00 00       	call   80104130 <wakeup>
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	eb 99                	jmp    80103587 <pipeclose+0x37>
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 28             	sub    $0x28,%esp
801035f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035fc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801035ff:	53                   	push   %ebx
80103600:	e8 eb 0f 00 00       	call   801045f0 <acquire>
  for(i = 0; i < n; i++){
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	85 ff                	test   %edi,%edi
8010360a:	0f 8e ce 00 00 00    	jle    801036de <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103610:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103616:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103619:	89 7d 10             	mov    %edi,0x10(%ebp)
8010361c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010361f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103622:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103625:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010362b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103631:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103637:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010363d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103640:	0f 85 b6 00 00 00    	jne    801036fc <pipewrite+0x10c>
80103646:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103649:	eb 3b                	jmp    80103686 <pipewrite+0x96>
8010364b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103650:	e8 5b 03 00 00       	call   801039b0 <myproc>
80103655:	8b 48 24             	mov    0x24(%eax),%ecx
80103658:	85 c9                	test   %ecx,%ecx
8010365a:	75 34                	jne    80103690 <pipewrite+0xa0>
      wakeup(&p->nread);
8010365c:	83 ec 0c             	sub    $0xc,%esp
8010365f:	56                   	push   %esi
80103660:	e8 cb 0a 00 00       	call   80104130 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103665:	58                   	pop    %eax
80103666:	5a                   	pop    %edx
80103667:	53                   	push   %ebx
80103668:	57                   	push   %edi
80103669:	e8 02 0a 00 00       	call   80104070 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010366e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103674:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	05 00 02 00 00       	add    $0x200,%eax
80103682:	39 c2                	cmp    %eax,%edx
80103684:	75 2a                	jne    801036b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103686:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010368c:	85 c0                	test   %eax,%eax
8010368e:	75 c0                	jne    80103650 <pipewrite+0x60>
        release(&p->lock);
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	53                   	push   %ebx
80103694:	e8 f7 0e 00 00       	call   80104590 <release>
        return -1;
80103699:	83 c4 10             	add    $0x10,%esp
8010369c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036a4:	5b                   	pop    %ebx
801036a5:	5e                   	pop    %esi
801036a6:	5f                   	pop    %edi
801036a7:	5d                   	pop    %ebp
801036a8:	c3                   	ret
801036a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b3:	8d 42 01             	lea    0x1(%edx),%eax
801036b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801036bc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036bf:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036c8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801036cc:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036d3:	39 c1                	cmp    %eax,%ecx
801036d5:	0f 85 50 ff ff ff    	jne    8010362b <pipewrite+0x3b>
801036db:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036de:	83 ec 0c             	sub    $0xc,%esp
801036e1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036e7:	50                   	push   %eax
801036e8:	e8 43 0a 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801036ed:	89 1c 24             	mov    %ebx,(%esp)
801036f0:	e8 9b 0e 00 00       	call   80104590 <release>
  return n;
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	89 f8                	mov    %edi,%eax
801036fa:	eb a5                	jmp    801036a1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036ff:	eb b2                	jmp    801036b3 <pipewrite+0xc3>
80103701:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103708:	00 
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103710 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	57                   	push   %edi
80103714:	56                   	push   %esi
80103715:	53                   	push   %ebx
80103716:	83 ec 18             	sub    $0x18,%esp
80103719:	8b 75 08             	mov    0x8(%ebp),%esi
8010371c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010371f:	56                   	push   %esi
80103720:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103726:	e8 c5 0e 00 00       	call   801045f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103731:	83 c4 10             	add    $0x10,%esp
80103734:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010373a:	74 2f                	je     8010376b <piperead+0x5b>
8010373c:	eb 37                	jmp    80103775 <piperead+0x65>
8010373e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103740:	e8 6b 02 00 00       	call   801039b0 <myproc>
80103745:	8b 40 24             	mov    0x24(%eax),%eax
80103748:	85 c0                	test   %eax,%eax
8010374a:	0f 85 80 00 00 00    	jne    801037d0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103750:	83 ec 08             	sub    $0x8,%esp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx
80103755:	e8 16 09 00 00       	call   80104070 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010375a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103760:	83 c4 10             	add    $0x10,%esp
80103763:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103769:	75 0a                	jne    80103775 <piperead+0x65>
8010376b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103771:	85 d2                	test   %edx,%edx
80103773:	75 cb                	jne    80103740 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103775:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103778:	31 db                	xor    %ebx,%ebx
8010377a:	85 c9                	test   %ecx,%ecx
8010377c:	7f 26                	jg     801037a4 <piperead+0x94>
8010377e:	eb 2c                	jmp    801037ac <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103780:	8d 48 01             	lea    0x1(%eax),%ecx
80103783:	25 ff 01 00 00       	and    $0x1ff,%eax
80103788:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010378e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103793:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103796:	83 c3 01             	add    $0x1,%ebx
80103799:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010379c:	74 0e                	je     801037ac <piperead+0x9c>
8010379e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801037a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037aa:	75 d4                	jne    80103780 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037ac:	83 ec 0c             	sub    $0xc,%esp
801037af:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037b5:	50                   	push   %eax
801037b6:	e8 75 09 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801037bb:	89 34 24             	mov    %esi,(%esp)
801037be:	e8 cd 0d 00 00       	call   80104590 <release>
  return i;
801037c3:	83 c4 10             	add    $0x10,%esp
}
801037c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c9:	89 d8                	mov    %ebx,%eax
801037cb:	5b                   	pop    %ebx
801037cc:	5e                   	pop    %esi
801037cd:	5f                   	pop    %edi
801037ce:	5d                   	pop    %ebp
801037cf:	c3                   	ret
      release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037d8:	56                   	push   %esi
801037d9:	e8 b2 0d 00 00       	call   80104590 <release>
      return -1;
801037de:	83 c4 10             	add    $0x10,%esp
}
801037e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e4:	89 d8                	mov    %ebx,%eax
801037e6:	5b                   	pop    %ebx
801037e7:	5e                   	pop    %esi
801037e8:	5f                   	pop    %edi
801037e9:	5d                   	pop    %ebp
801037ea:	c3                   	ret
801037eb:	66 90                	xchg   %ax,%ax
801037ed:	66 90                	xchg   %ax,%ax
801037ef:	90                   	nop

801037f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037fc:	68 20 1d 11 80       	push   $0x80111d20
80103801:	e8 ea 0d 00 00       	call   801045f0 <acquire>
80103806:	83 c4 10             	add    $0x10,%esp
80103809:	eb 10                	jmp    8010381b <allocproc+0x2b>
8010380b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103810:	83 c3 7c             	add    $0x7c,%ebx
80103813:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103819:	74 75                	je     80103890 <allocproc+0xa0>
    if(p->state == UNUSED)
8010381b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010381e:	85 c0                	test   %eax,%eax
80103820:	75 ee                	jne    80103810 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103822:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103827:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010382a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103831:	89 43 10             	mov    %eax,0x10(%ebx)
80103834:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103837:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
8010383c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103842:	e8 49 0d 00 00       	call   80104590 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103847:	e8 64 ee ff ff       	call   801026b0 <kalloc>
8010384c:	83 c4 10             	add    $0x10,%esp
8010384f:	89 43 08             	mov    %eax,0x8(%ebx)
80103852:	85 c0                	test   %eax,%eax
80103854:	74 53                	je     801038a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103856:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010385c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010385f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103864:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103867:	c7 40 14 a2 58 10 80 	movl   $0x801058a2,0x14(%eax)
  p->context = (struct context*)sp;
8010386e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103871:	6a 14                	push   $0x14
80103873:	6a 00                	push   $0x0
80103875:	50                   	push   %eax
80103876:	e8 75 0e 00 00       	call   801046f0 <memset>
  p->context->eip = (uint)forkret;
8010387b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010387e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103881:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)
}
80103888:	89 d8                	mov    %ebx,%eax
8010388a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010388d:	c9                   	leave
8010388e:	c3                   	ret
8010388f:	90                   	nop
  release(&ptable.lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103893:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103895:	68 20 1d 11 80       	push   $0x80111d20
8010389a:	e8 f1 0c 00 00       	call   80104590 <release>
  return 0;
8010389f:	83 c4 10             	add    $0x10,%esp
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave
801038a8:	c3                   	ret
    p->state = UNUSED;
801038a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801038b0:	31 db                	xor    %ebx,%ebx
801038b2:	eb ee                	jmp    801038a2 <allocproc+0xb2>
801038b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038bb:	00 
801038bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
801038c6:	68 20 1d 11 80       	push   $0x80111d20
801038cb:	e8 c0 0c 00 00       	call   80104590 <release>

  if (first) {
801038d0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
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
    first = 0;
801038e0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038e7:	00 00 00 
    iinit(ROOTDEV);
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	6a 01                	push   $0x1
801038ef:	e8 dc dc ff ff       	call   801015d0 <iinit>
    initlog(ROOTDEV);
801038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038fb:	e8 f0 f3 ff ff       	call   80102cf0 <initlog>
}
80103900:	83 c4 10             	add    $0x10,%esp
80103903:	c9                   	leave
80103904:	c3                   	ret
80103905:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010390c:	00 
8010390d:	8d 76 00             	lea    0x0(%esi),%esi

80103910 <pinit>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103916:	68 2f 74 10 80       	push   $0x8010742f
8010391b:	68 20 1d 11 80       	push   $0x80111d20
80103920:	e8 db 0a 00 00       	call   80104400 <initlock>
}
80103925:	83 c4 10             	add    $0x10,%esp
80103928:	c9                   	leave
80103929:	c3                   	ret
8010392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103930 <mycpu>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103935:	9c                   	pushf
80103936:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103937:	f6 c4 02             	test   $0x2,%ah
8010393a:	75 46                	jne    80103982 <mycpu+0x52>
  apicid = lapicid();
8010393c:	e8 df ef ff ff       	call   80102920 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103941:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103947:	85 f6                	test   %esi,%esi
80103949:	7e 2a                	jle    80103975 <mycpu+0x45>
8010394b:	31 d2                	xor    %edx,%edx
8010394d:	eb 08                	jmp    80103957 <mycpu+0x27>
8010394f:	90                   	nop
80103950:	83 c2 01             	add    $0x1,%edx
80103953:	39 f2                	cmp    %esi,%edx
80103955:	74 1e                	je     80103975 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103957:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010395d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103964:	39 c3                	cmp    %eax,%ebx
80103966:	75 e8                	jne    80103950 <mycpu+0x20>
}
80103968:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010396b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103971:	5b                   	pop    %ebx
80103972:	5e                   	pop    %esi
80103973:	5d                   	pop    %ebp
80103974:	c3                   	ret
  panic("unknown apicid\n");
80103975:	83 ec 0c             	sub    $0xc,%esp
80103978:	68 36 74 10 80       	push   $0x80107436
8010397d:	e8 fe c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103982:	83 ec 0c             	sub    $0xc,%esp
80103985:	68 98 77 10 80       	push   $0x80107798
8010398a:	e8 f1 c9 ff ff       	call   80100380 <panic>
8010398f:	90                   	nop

80103990 <cpuid>:
cpuid() {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103996:	e8 95 ff ff ff       	call   80103930 <mycpu>
}
8010399b:	c9                   	leave
  return mycpu()-cpus;
8010399c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801039a1:	c1 f8 04             	sar    $0x4,%eax
801039a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039aa:	c3                   	ret
801039ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039b0 <myproc>:
myproc(void) {
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039b7:	e8 e4 0a 00 00       	call   801044a0 <pushcli>
  c = mycpu();
801039bc:	e8 6f ff ff ff       	call   80103930 <mycpu>
  p = c->proc;
801039c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039c7:	e8 24 0b 00 00       	call   801044f0 <popcli>
}
801039cc:	89 d8                	mov    %ebx,%eax
801039ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039d1:	c9                   	leave
801039d2:	c3                   	ret
801039d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039da:	00 
801039db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039e0 <userinit>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039e7:	e8 04 fe ff ff       	call   801037f0 <allocproc>
801039ec:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ee:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
801039f3:	e8 78 34 00 00       	call   80106e70 <setupkvm>
801039f8:	89 43 04             	mov    %eax,0x4(%ebx)
801039fb:	85 c0                	test   %eax,%eax
801039fd:	0f 84 bd 00 00 00    	je     80103ac0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a03:	83 ec 04             	sub    $0x4,%esp
80103a06:	68 2c 00 00 00       	push   $0x2c
80103a0b:	68 60 a4 10 80       	push   $0x8010a460
80103a10:	50                   	push   %eax
80103a11:	e8 3a 31 00 00       	call   80106b50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a1f:	6a 4c                	push   $0x4c
80103a21:	6a 00                	push   $0x0
80103a23:	ff 73 18             	push   0x18(%ebx)
80103a26:	e8 c5 0c 00 00       	call   801046f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a51:	8b 43 18             	mov    0x18(%ebx),%eax
80103a54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a66:	8b 43 18             	mov    0x18(%ebx),%eax
80103a69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a70:	8b 43 18             	mov    0x18(%ebx),%eax
80103a73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a7d:	6a 10                	push   $0x10
80103a7f:	68 5f 74 10 80       	push   $0x8010745f
80103a84:	50                   	push   %eax
80103a85:	e8 16 0e 00 00       	call   801048a0 <safestrcpy>
  p->cwd = namei("/");
80103a8a:	c7 04 24 68 74 10 80 	movl   $0x80107468,(%esp)
80103a91:	e8 3a e6 ff ff       	call   801020d0 <namei>
80103a96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a99:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103aa0:	e8 4b 0b 00 00       	call   801045f0 <acquire>
  p->state = RUNNABLE;
80103aa5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aac:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ab3:	e8 d8 0a 00 00       	call   80104590 <release>
}
80103ab8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103abb:	83 c4 10             	add    $0x10,%esp
80103abe:	c9                   	leave
80103abf:	c3                   	ret
    panic("userinit: out of memory?");
80103ac0:	83 ec 0c             	sub    $0xc,%esp
80103ac3:	68 46 74 10 80       	push   $0x80107446
80103ac8:	e8 b3 c8 ff ff       	call   80100380 <panic>
80103acd:	8d 76 00             	lea    0x0(%esi),%esi

80103ad0 <growproc>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ad8:	e8 c3 09 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103add:	e8 4e fe ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103ae2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae8:	e8 03 0a 00 00       	call   801044f0 <popcli>
  sz = curproc->sz;
80103aed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aef:	85 f6                	test   %esi,%esi
80103af1:	7f 1d                	jg     80103b10 <growproc+0x40>
  } else if(n < 0){
80103af3:	75 3b                	jne    80103b30 <growproc+0x60>
  switchuvm(curproc);
80103af5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103af8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103afa:	53                   	push   %ebx
80103afb:	e8 40 2f 00 00       	call   80106a40 <switchuvm>
  return 0;
80103b00:	83 c4 10             	add    $0x10,%esp
80103b03:	31 c0                	xor    %eax,%eax
}
80103b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b08:	5b                   	pop    %ebx
80103b09:	5e                   	pop    %esi
80103b0a:	5d                   	pop    %ebp
80103b0b:	c3                   	ret
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	push   0x4(%ebx)
80103b1a:	e8 81 31 00 00       	call   80106ca0 <allocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 cf                	jne    80103af5 <growproc+0x25>
      return -1;
80103b26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b2b:	eb d8                	jmp    80103b05 <growproc+0x35>
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	push   0x4(%ebx)
80103b3a:	e8 81 32 00 00       	call   80106dc0 <deallocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 af                	jne    80103af5 <growproc+0x25>
80103b46:	eb de                	jmp    80103b26 <growproc+0x56>
80103b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b4f:	00 

80103b50 <fork>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b59:	e8 42 09 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103b5e:	e8 cd fd ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103b63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b69:	e8 82 09 00 00       	call   801044f0 <popcli>
  if((np = allocproc()) == 0){
80103b6e:	e8 7d fc ff ff       	call   801037f0 <allocproc>
80103b73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b76:	85 c0                	test   %eax,%eax
80103b78:	0f 84 d6 00 00 00    	je     80103c54 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b7e:	83 ec 08             	sub    $0x8,%esp
80103b81:	ff 33                	push   (%ebx)
80103b83:	89 c7                	mov    %eax,%edi
80103b85:	ff 73 04             	push   0x4(%ebx)
80103b88:	e8 d3 33 00 00       	call   80106f60 <copyuvm>
80103b8d:	83 c4 10             	add    $0x10,%esp
80103b90:	89 47 04             	mov    %eax,0x4(%edi)
80103b93:	85 c0                	test   %eax,%eax
80103b95:	0f 84 9a 00 00 00    	je     80103c35 <fork+0xe5>
  np->sz = curproc->sz;
80103b9b:	8b 03                	mov    (%ebx),%eax
80103b9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ba0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ba2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ba5:	89 c8                	mov    %ecx,%eax
80103ba7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103baa:	b9 13 00 00 00       	mov    $0x13,%ecx
80103baf:	8b 73 18             	mov    0x18(%ebx),%esi
80103bb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bb4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bb6:	8b 40 18             	mov    0x18(%eax),%eax
80103bb9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bc4:	85 c0                	test   %eax,%eax
80103bc6:	74 13                	je     80103bdb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bc8:	83 ec 0c             	sub    $0xc,%esp
80103bcb:	50                   	push   %eax
80103bcc:	e8 3f d3 ff ff       	call   80100f10 <filedup>
80103bd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bd4:	83 c4 10             	add    $0x10,%esp
80103bd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bdb:	83 c6 01             	add    $0x1,%esi
80103bde:	83 fe 10             	cmp    $0x10,%esi
80103be1:	75 dd                	jne    80103bc0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103be3:	83 ec 0c             	sub    $0xc,%esp
80103be6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bec:	e8 cf db ff ff       	call   801017c0 <idup>
80103bf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bf7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	53                   	push   %ebx
80103c00:	50                   	push   %eax
80103c01:	e8 9a 0c 00 00       	call   801048a0 <safestrcpy>
  pid = np->pid;
80103c06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c09:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c10:	e8 db 09 00 00       	call   801045f0 <acquire>
  np->state = RUNNABLE;
80103c15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c1c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c23:	e8 68 09 00 00       	call   80104590 <release>
  return pid;
80103c28:	83 c4 10             	add    $0x10,%esp
}
80103c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c2e:	89 d8                	mov    %ebx,%eax
80103c30:	5b                   	pop    %ebx
80103c31:	5e                   	pop    %esi
80103c32:	5f                   	pop    %edi
80103c33:	5d                   	pop    %ebp
80103c34:	c3                   	ret
    kfree(np->kstack);
80103c35:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c38:	83 ec 0c             	sub    $0xc,%esp
80103c3b:	ff 73 08             	push   0x8(%ebx)
80103c3e:	e8 ad e8 ff ff       	call   801024f0 <kfree>
    np->kstack = 0;
80103c43:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c4a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c4d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c54:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c59:	eb d0                	jmp    80103c2b <fork+0xdb>
80103c5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c60 <scheduler>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c69:	e8 c2 fc ff ff       	call   80103930 <mycpu>
  c->proc = 0;
80103c6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c75:	00 00 00 
  struct cpu *c = mycpu();
80103c78:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c7a:	8d 78 04             	lea    0x4(%eax),%edi
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c80:	fb                   	sti
    acquire(&ptable.lock);
80103c81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c84:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103c89:	68 20 1d 11 80       	push   $0x80111d20
80103c8e:	e8 5d 09 00 00       	call   801045f0 <acquire>
80103c93:	83 c4 10             	add    $0x10,%esp
80103c96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c9d:	00 
80103c9e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103ca0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ca4:	75 33                	jne    80103cd9 <scheduler+0x79>
      switchuvm(p);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ca9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103caf:	53                   	push   %ebx
80103cb0:	e8 8b 2d 00 00       	call   80106a40 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cb5:	58                   	pop    %eax
80103cb6:	5a                   	pop    %edx
80103cb7:	ff 73 1c             	push   0x1c(%ebx)
80103cba:	57                   	push   %edi
      p->state = RUNNING;
80103cbb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cc2:	e8 34 0c 00 00       	call   801048fb <swtch>
      switchkvm();
80103cc7:	e8 64 2d 00 00       	call   80106a30 <switchkvm>
      c->proc = 0;
80103ccc:	83 c4 10             	add    $0x10,%esp
80103ccf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cd6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cd9:	83 c3 7c             	add    $0x7c,%ebx
80103cdc:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103ce2:	75 bc                	jne    80103ca0 <scheduler+0x40>
    release(&ptable.lock);
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	68 20 1d 11 80       	push   $0x80111d20
80103cec:	e8 9f 08 00 00       	call   80104590 <release>
    sti();
80103cf1:	83 c4 10             	add    $0x10,%esp
80103cf4:	eb 8a                	jmp    80103c80 <scheduler+0x20>
80103cf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cfd:	00 
80103cfe:	66 90                	xchg   %ax,%ax

80103d00 <sched>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
  pushcli();
80103d05:	e8 96 07 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103d0a:	e8 21 fc ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103d0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d15:	e8 d6 07 00 00       	call   801044f0 <popcli>
  if(!holding(&ptable.lock))
80103d1a:	83 ec 0c             	sub    $0xc,%esp
80103d1d:	68 20 1d 11 80       	push   $0x80111d20
80103d22:	e8 29 08 00 00       	call   80104550 <holding>
80103d27:	83 c4 10             	add    $0x10,%esp
80103d2a:	85 c0                	test   %eax,%eax
80103d2c:	74 4f                	je     80103d7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d2e:	e8 fd fb ff ff       	call   80103930 <mycpu>
80103d33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d3a:	75 68                	jne    80103da4 <sched+0xa4>
  if(p->state == RUNNING)
80103d3c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d40:	74 55                	je     80103d97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d42:	9c                   	pushf
80103d43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d44:	f6 c4 02             	test   $0x2,%ah
80103d47:	75 41                	jne    80103d8a <sched+0x8a>
  intena = mycpu()->intena;
80103d49:	e8 e2 fb ff ff       	call   80103930 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d4e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d57:	e8 d4 fb ff ff       	call   80103930 <mycpu>
80103d5c:	83 ec 08             	sub    $0x8,%esp
80103d5f:	ff 70 04             	push   0x4(%eax)
80103d62:	53                   	push   %ebx
80103d63:	e8 93 0b 00 00       	call   801048fb <swtch>
  mycpu()->intena = intena;
80103d68:	e8 c3 fb ff ff       	call   80103930 <mycpu>
}
80103d6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d79:	5b                   	pop    %ebx
80103d7a:	5e                   	pop    %esi
80103d7b:	5d                   	pop    %ebp
80103d7c:	c3                   	ret
    panic("sched ptable.lock");
80103d7d:	83 ec 0c             	sub    $0xc,%esp
80103d80:	68 6a 74 10 80       	push   $0x8010746a
80103d85:	e8 f6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	68 96 74 10 80       	push   $0x80107496
80103d92:	e8 e9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d97:	83 ec 0c             	sub    $0xc,%esp
80103d9a:	68 88 74 10 80       	push   $0x80107488
80103d9f:	e8 dc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	68 7c 74 10 80       	push   $0x8010747c
80103dac:	e8 cf c5 ff ff       	call   80100380 <panic>
80103db1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103db8:	00 
80103db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dc0 <exit>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103dc9:	e8 e2 fb ff ff       	call   801039b0 <myproc>
  if(curproc == initproc)
80103dce:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103dd4:	0f 84 fd 00 00 00    	je     80103ed7 <exit+0x117>
80103dda:	89 c3                	mov    %eax,%ebx
80103ddc:	8d 70 28             	lea    0x28(%eax),%esi
80103ddf:	8d 78 68             	lea    0x68(%eax),%edi
80103de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103de8:	8b 06                	mov    (%esi),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 12                	je     80103e00 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	50                   	push   %eax
80103df2:	e8 69 d1 ff ff       	call   80100f60 <fileclose>
      curproc->ofile[fd] = 0;
80103df7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dfd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e00:	83 c6 04             	add    $0x4,%esi
80103e03:	39 f7                	cmp    %esi,%edi
80103e05:	75 e1                	jne    80103de8 <exit+0x28>
  begin_op();
80103e07:	e8 84 ef ff ff       	call   80102d90 <begin_op>
  iput(curproc->cwd);
80103e0c:	83 ec 0c             	sub    $0xc,%esp
80103e0f:	ff 73 68             	push   0x68(%ebx)
80103e12:	e8 09 db ff ff       	call   80101920 <iput>
  end_op();
80103e17:	e8 e4 ef ff ff       	call   80102e00 <end_op>
  curproc->cwd = 0;
80103e1c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e23:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e2a:	e8 c1 07 00 00       	call   801045f0 <acquire>
  wakeup1(curproc->parent);
80103e2f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e35:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e3a:	eb 0e                	jmp    80103e4a <exit+0x8a>
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e40:	83 c0 7c             	add    $0x7c,%eax
80103e43:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e48:	74 1c                	je     80103e66 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e4a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e4e:	75 f0                	jne    80103e40 <exit+0x80>
80103e50:	3b 50 20             	cmp    0x20(%eax),%edx
80103e53:	75 eb                	jne    80103e40 <exit+0x80>
      p->state = RUNNABLE;
80103e55:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e5c:	83 c0 7c             	add    $0x7c,%eax
80103e5f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e64:	75 e4                	jne    80103e4a <exit+0x8a>
      p->parent = initproc;
80103e66:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103e71:	eb 10                	jmp    80103e83 <exit+0xc3>
80103e73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e78:	83 c2 7c             	add    $0x7c,%edx
80103e7b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103e81:	74 3b                	je     80103ebe <exit+0xfe>
    if(p->parent == curproc){
80103e83:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e86:	75 f0                	jne    80103e78 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e88:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e8c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e8f:	75 e7                	jne    80103e78 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e91:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e96:	eb 12                	jmp    80103eaa <exit+0xea>
80103e98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e9f:	00 
80103ea0:	83 c0 7c             	add    $0x7c,%eax
80103ea3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103ea8:	74 ce                	je     80103e78 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103eaa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eae:	75 f0                	jne    80103ea0 <exit+0xe0>
80103eb0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103eb3:	75 eb                	jne    80103ea0 <exit+0xe0>
      p->state = RUNNABLE;
80103eb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ebc:	eb e2                	jmp    80103ea0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103ebe:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ec5:	e8 36 fe ff ff       	call   80103d00 <sched>
  panic("zombie exit");
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 b7 74 10 80       	push   $0x801074b7
80103ed2:	e8 a9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ed7:	83 ec 0c             	sub    $0xc,%esp
80103eda:	68 aa 74 10 80       	push   $0x801074aa
80103edf:	e8 9c c4 ff ff       	call   80100380 <panic>
80103ee4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103eeb:	00 
80103eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ef0 <wait>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
  pushcli();
80103ef5:	e8 a6 05 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103efa:	e8 31 fa ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103eff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f05:	e8 e6 05 00 00       	call   801044f0 <popcli>
  acquire(&ptable.lock);
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 20 1d 11 80       	push   $0x80111d20
80103f12:	e8 d9 06 00 00       	call   801045f0 <acquire>
80103f17:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f1a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f1c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103f21:	eb 10                	jmp    80103f33 <wait+0x43>
80103f23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f28:	83 c3 7c             	add    $0x7c,%ebx
80103f2b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103f31:	74 1b                	je     80103f4e <wait+0x5e>
      if(p->parent != curproc)
80103f33:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f36:	75 f0                	jne    80103f28 <wait+0x38>
      if(p->state == ZOMBIE){
80103f38:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f3c:	74 62                	je     80103fa0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f41:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f46:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103f4c:	75 e5                	jne    80103f33 <wait+0x43>
    if(!havekids || curproc->killed){
80103f4e:	85 c0                	test   %eax,%eax
80103f50:	0f 84 a0 00 00 00    	je     80103ff6 <wait+0x106>
80103f56:	8b 46 24             	mov    0x24(%esi),%eax
80103f59:	85 c0                	test   %eax,%eax
80103f5b:	0f 85 95 00 00 00    	jne    80103ff6 <wait+0x106>
  pushcli();
80103f61:	e8 3a 05 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103f66:	e8 c5 f9 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103f6b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f71:	e8 7a 05 00 00       	call   801044f0 <popcli>
  if(p == 0)
80103f76:	85 db                	test   %ebx,%ebx
80103f78:	0f 84 8f 00 00 00    	je     8010400d <wait+0x11d>
  p->chan = chan;
80103f7e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f81:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f88:	e8 73 fd ff ff       	call   80103d00 <sched>
  p->chan = 0;
80103f8d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f94:	eb 84                	jmp    80103f1a <wait+0x2a>
80103f96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f9d:	00 
80103f9e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80103fa0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fa3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fa6:	ff 73 08             	push   0x8(%ebx)
80103fa9:	e8 42 e5 ff ff       	call   801024f0 <kfree>
        p->kstack = 0;
80103fae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fb5:	5a                   	pop    %edx
80103fb6:	ff 73 04             	push   0x4(%ebx)
80103fb9:	e8 32 2e 00 00       	call   80106df0 <freevm>
        p->pid = 0;
80103fbe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fc5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fcc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fd0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fd7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fde:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fe5:	e8 a6 05 00 00       	call   80104590 <release>
        return pid;
80103fea:	83 c4 10             	add    $0x10,%esp
}
80103fed:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff0:	89 f0                	mov    %esi,%eax
80103ff2:	5b                   	pop    %ebx
80103ff3:	5e                   	pop    %esi
80103ff4:	5d                   	pop    %ebp
80103ff5:	c3                   	ret
      release(&ptable.lock);
80103ff6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ff9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103ffe:	68 20 1d 11 80       	push   $0x80111d20
80104003:	e8 88 05 00 00       	call   80104590 <release>
      return -1;
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	eb e0                	jmp    80103fed <wait+0xfd>
    panic("sleep");
8010400d:	83 ec 0c             	sub    $0xc,%esp
80104010:	68 c3 74 10 80       	push   $0x801074c3
80104015:	e8 66 c3 ff ff       	call   80100380 <panic>
8010401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104020 <yield>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	53                   	push   %ebx
80104024:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104027:	68 20 1d 11 80       	push   $0x80111d20
8010402c:	e8 bf 05 00 00       	call   801045f0 <acquire>
  pushcli();
80104031:	e8 6a 04 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80104036:	e8 f5 f8 ff ff       	call   80103930 <mycpu>
  p = c->proc;
8010403b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104041:	e8 aa 04 00 00       	call   801044f0 <popcli>
  myproc()->state = RUNNABLE;
80104046:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010404d:	e8 ae fc ff ff       	call   80103d00 <sched>
  release(&ptable.lock);
80104052:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104059:	e8 32 05 00 00       	call   80104590 <release>
}
8010405e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104061:	83 c4 10             	add    $0x10,%esp
80104064:	c9                   	leave
80104065:	c3                   	ret
80104066:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010406d:	00 
8010406e:	66 90                	xchg   %ax,%ax

80104070 <sleep>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 0c             	sub    $0xc,%esp
80104079:	8b 7d 08             	mov    0x8(%ebp),%edi
8010407c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010407f:	e8 1c 04 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80104084:	e8 a7 f8 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80104089:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010408f:	e8 5c 04 00 00       	call   801044f0 <popcli>
  if(p == 0)
80104094:	85 db                	test   %ebx,%ebx
80104096:	0f 84 87 00 00 00    	je     80104123 <sleep+0xb3>
  if(lk == 0)
8010409c:	85 f6                	test   %esi,%esi
8010409e:	74 76                	je     80104116 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040a0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801040a6:	74 50                	je     801040f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 20 1d 11 80       	push   $0x80111d20
801040b0:	e8 3b 05 00 00       	call   801045f0 <acquire>
    release(lk);
801040b5:	89 34 24             	mov    %esi,(%esp)
801040b8:	e8 d3 04 00 00       	call   80104590 <release>
  p->chan = chan;
801040bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040c7:	e8 34 fc ff ff       	call   80103d00 <sched>
  p->chan = 0;
801040cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040d3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040da:	e8 b1 04 00 00       	call   80104590 <release>
    acquire(lk);
801040df:	89 75 08             	mov    %esi,0x8(%ebp)
801040e2:	83 c4 10             	add    $0x10,%esp
}
801040e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e8:	5b                   	pop    %ebx
801040e9:	5e                   	pop    %esi
801040ea:	5f                   	pop    %edi
801040eb:	5d                   	pop    %ebp
    acquire(lk);
801040ec:	e9 ff 04 00 00       	jmp    801045f0 <acquire>
801040f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104102:	e8 f9 fb ff ff       	call   80103d00 <sched>
  p->chan = 0;
80104107:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010410e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104111:	5b                   	pop    %ebx
80104112:	5e                   	pop    %esi
80104113:	5f                   	pop    %edi
80104114:	5d                   	pop    %ebp
80104115:	c3                   	ret
    panic("sleep without lk");
80104116:	83 ec 0c             	sub    $0xc,%esp
80104119:	68 c9 74 10 80       	push   $0x801074c9
8010411e:	e8 5d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104123:	83 ec 0c             	sub    $0xc,%esp
80104126:	68 c3 74 10 80       	push   $0x801074c3
8010412b:	e8 50 c2 ff ff       	call   80100380 <panic>

80104130 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
80104137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010413a:	68 20 1d 11 80       	push   $0x80111d20
8010413f:	e8 ac 04 00 00       	call   801045f0 <acquire>
80104144:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104147:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010414c:	eb 0c                	jmp    8010415a <wakeup+0x2a>
8010414e:	66 90                	xchg   %ax,%ax
80104150:	83 c0 7c             	add    $0x7c,%eax
80104153:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104158:	74 1c                	je     80104176 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010415a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010415e:	75 f0                	jne    80104150 <wakeup+0x20>
80104160:	3b 58 20             	cmp    0x20(%eax),%ebx
80104163:	75 eb                	jne    80104150 <wakeup+0x20>
      p->state = RUNNABLE;
80104165:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416c:	83 c0 7c             	add    $0x7c,%eax
8010416f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104174:	75 e4                	jne    8010415a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104176:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010417d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104180:	c9                   	leave
  release(&ptable.lock);
80104181:	e9 0a 04 00 00       	jmp    80104590 <release>
80104186:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010418d:	00 
8010418e:	66 90                	xchg   %ax,%ax

80104190 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
80104197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010419a:	68 20 1d 11 80       	push   $0x80111d20
8010419f:	e8 4c 04 00 00       	call   801045f0 <acquire>
801041a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801041ac:	eb 0c                	jmp    801041ba <kill+0x2a>
801041ae:	66 90                	xchg   %ax,%ax
801041b0:	83 c0 7c             	add    $0x7c,%eax
801041b3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801041b8:	74 36                	je     801041f0 <kill+0x60>
    if(p->pid == pid){
801041ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801041bd:	75 f1                	jne    801041b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041ca:	75 07                	jne    801041d3 <kill+0x43>
        p->state = RUNNABLE;
801041cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	68 20 1d 11 80       	push   $0x80111d20
801041db:	e8 b0 03 00 00       	call   80104590 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041e3:	83 c4 10             	add    $0x10,%esp
801041e6:	31 c0                	xor    %eax,%eax
}
801041e8:	c9                   	leave
801041e9:	c3                   	ret
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	68 20 1d 11 80       	push   $0x80111d20
801041f8:	e8 93 03 00 00       	call   80104590 <release>
}
801041fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104200:	83 c4 10             	add    $0x10,%esp
80104203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104208:	c9                   	leave
80104209:	c3                   	ret
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104218:	53                   	push   %ebx
80104219:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010421e:	83 ec 3c             	sub    $0x3c,%esp
80104221:	eb 24                	jmp    80104247 <procdump+0x37>
80104223:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 47 72 10 80       	push   $0x80107247
80104230:	e8 7b c4 ff ff       	call   801006b0 <cprintf>
80104235:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104238:	83 c3 7c             	add    $0x7c,%ebx
8010423b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104241:	0f 84 81 00 00 00    	je     801042c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104247:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010424a:	85 c0                	test   %eax,%eax
8010424c:	74 ea                	je     80104238 <procdump+0x28>
      state = "???";
8010424e:	ba da 74 10 80       	mov    $0x801074da,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104253:	83 f8 05             	cmp    $0x5,%eax
80104256:	77 11                	ja     80104269 <procdump+0x59>
80104258:	8b 14 85 a0 7a 10 80 	mov    -0x7fef8560(,%eax,4),%edx
      state = "???";
8010425f:	b8 da 74 10 80       	mov    $0x801074da,%eax
80104264:	85 d2                	test   %edx,%edx
80104266:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104269:	53                   	push   %ebx
8010426a:	52                   	push   %edx
8010426b:	ff 73 a4             	push   -0x5c(%ebx)
8010426e:	68 de 74 10 80       	push   $0x801074de
80104273:	e8 38 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104278:	83 c4 10             	add    $0x10,%esp
8010427b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010427f:	75 a7                	jne    80104228 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104281:	83 ec 08             	sub    $0x8,%esp
80104284:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104287:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010428a:	50                   	push   %eax
8010428b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010428e:	8b 40 0c             	mov    0xc(%eax),%eax
80104291:	83 c0 08             	add    $0x8,%eax
80104294:	50                   	push   %eax
80104295:	e8 86 01 00 00       	call   80104420 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010429a:	83 c4 10             	add    $0x10,%esp
8010429d:	8d 76 00             	lea    0x0(%esi),%esi
801042a0:	8b 17                	mov    (%edi),%edx
801042a2:	85 d2                	test   %edx,%edx
801042a4:	74 82                	je     80104228 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042ac:	52                   	push   %edx
801042ad:	68 01 72 10 80       	push   $0x80107201
801042b2:	e8 f9 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042b7:	83 c4 10             	add    $0x10,%esp
801042ba:	39 f7                	cmp    %esi,%edi
801042bc:	75 e2                	jne    801042a0 <procdump+0x90>
801042be:	e9 65 ff ff ff       	jmp    80104228 <procdump+0x18>
801042c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801042c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042cb:	5b                   	pop    %ebx
801042cc:	5e                   	pop    %esi
801042cd:	5f                   	pop    %edi
801042ce:	5d                   	pop    %ebp
801042cf:	c3                   	ret

801042d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042da:	68 11 75 10 80       	push   $0x80107511
801042df:	8d 43 04             	lea    0x4(%ebx),%eax
801042e2:	50                   	push   %eax
801042e3:	e8 18 01 00 00       	call   80104400 <initlock>
  lk->name = name;
801042e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104301:	c9                   	leave
80104302:	c3                   	ret
80104303:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010430a:	00 
8010430b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104310 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104318:	8d 73 04             	lea    0x4(%ebx),%esi
8010431b:	83 ec 0c             	sub    $0xc,%esp
8010431e:	56                   	push   %esi
8010431f:	e8 cc 02 00 00       	call   801045f0 <acquire>
  while (lk->locked) {
80104324:	8b 13                	mov    (%ebx),%edx
80104326:	83 c4 10             	add    $0x10,%esp
80104329:	85 d2                	test   %edx,%edx
8010432b:	74 16                	je     80104343 <acquiresleep+0x33>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104330:	83 ec 08             	sub    $0x8,%esp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	e8 36 fd ff ff       	call   80104070 <sleep>
  while (lk->locked) {
8010433a:	8b 03                	mov    (%ebx),%eax
8010433c:	83 c4 10             	add    $0x10,%esp
8010433f:	85 c0                	test   %eax,%eax
80104341:	75 ed                	jne    80104330 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104343:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104349:	e8 62 f6 ff ff       	call   801039b0 <myproc>
8010434e:	8b 40 10             	mov    0x10(%eax),%eax
80104351:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104354:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104357:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010435a:	5b                   	pop    %ebx
8010435b:	5e                   	pop    %esi
8010435c:	5d                   	pop    %ebp
  release(&lk->lk);
8010435d:	e9 2e 02 00 00       	jmp    80104590 <release>
80104362:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104369:	00 
8010436a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104370 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104378:	8d 73 04             	lea    0x4(%ebx),%esi
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	56                   	push   %esi
8010437f:	e8 6c 02 00 00       	call   801045f0 <acquire>
  lk->locked = 0;
80104384:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010438a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104391:	89 1c 24             	mov    %ebx,(%esp)
80104394:	e8 97 fd ff ff       	call   80104130 <wakeup>
  release(&lk->lk);
80104399:	89 75 08             	mov    %esi,0x8(%ebp)
8010439c:	83 c4 10             	add    $0x10,%esp
}
8010439f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a2:	5b                   	pop    %ebx
801043a3:	5e                   	pop    %esi
801043a4:	5d                   	pop    %ebp
  release(&lk->lk);
801043a5:	e9 e6 01 00 00       	jmp    80104590 <release>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	31 ff                	xor    %edi,%edi
801043b6:	56                   	push   %esi
801043b7:	53                   	push   %ebx
801043b8:	83 ec 18             	sub    $0x18,%esp
801043bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043be:	8d 73 04             	lea    0x4(%ebx),%esi
801043c1:	56                   	push   %esi
801043c2:	e8 29 02 00 00       	call   801045f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043c7:	8b 03                	mov    (%ebx),%eax
801043c9:	83 c4 10             	add    $0x10,%esp
801043cc:	85 c0                	test   %eax,%eax
801043ce:	75 18                	jne    801043e8 <holdingsleep+0x38>
  release(&lk->lk);
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	56                   	push   %esi
801043d4:	e8 b7 01 00 00       	call   80104590 <release>
  return r;
}
801043d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043dc:	89 f8                	mov    %edi,%eax
801043de:	5b                   	pop    %ebx
801043df:	5e                   	pop    %esi
801043e0:	5f                   	pop    %edi
801043e1:	5d                   	pop    %ebp
801043e2:	c3                   	ret
801043e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801043e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043eb:	e8 c0 f5 ff ff       	call   801039b0 <myproc>
801043f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801043f3:	0f 94 c0             	sete   %al
801043f6:	0f b6 c0             	movzbl %al,%eax
801043f9:	89 c7                	mov    %eax,%edi
801043fb:	eb d3                	jmp    801043d0 <holdingsleep+0x20>
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104406:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010440f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104412:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104419:	5d                   	pop    %ebp
8010441a:	c3                   	ret
8010441b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	8b 45 08             	mov    0x8(%ebp),%eax
80104427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010442a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010442d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104432:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104437:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010443c:	76 10                	jbe    8010444e <getcallerpcs+0x2e>
8010443e:	eb 28                	jmp    80104468 <getcallerpcs+0x48>
80104440:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104446:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010444c:	77 1a                	ja     80104468 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010444e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104451:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104454:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104457:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104459:	83 f8 0a             	cmp    $0xa,%eax
8010445c:	75 e2                	jne    80104440 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010445e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104461:	c9                   	leave
80104462:	c3                   	ret
80104463:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104468:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010446b:	83 c1 28             	add    $0x28,%ecx
8010446e:	89 ca                	mov    %ecx,%edx
80104470:	29 c2                	sub    %eax,%edx
80104472:	83 e2 04             	and    $0x4,%edx
80104475:	74 11                	je     80104488 <getcallerpcs+0x68>
    pcs[i] = 0;
80104477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010447d:	83 c0 04             	add    $0x4,%eax
80104480:	39 c1                	cmp    %eax,%ecx
80104482:	74 da                	je     8010445e <getcallerpcs+0x3e>
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010448e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104491:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104498:	39 c1                	cmp    %eax,%ecx
8010449a:	75 ec                	jne    80104488 <getcallerpcs+0x68>
8010449c:	eb c0                	jmp    8010445e <getcallerpcs+0x3e>
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 04             	sub    $0x4,%esp
801044a7:	9c                   	pushf
801044a8:	5b                   	pop    %ebx
  asm volatile("cli");
801044a9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044aa:	e8 81 f4 ff ff       	call   80103930 <mycpu>
801044af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044b5:	85 c0                	test   %eax,%eax
801044b7:	74 17                	je     801044d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044b9:	e8 72 f4 ff ff       	call   80103930 <mycpu>
801044be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c8:	c9                   	leave
801044c9:	c3                   	ret
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044d0:	e8 5b f4 ff ff       	call   80103930 <mycpu>
801044d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044e1:	eb d6                	jmp    801044b9 <pushcli+0x19>
801044e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044ea:	00 
801044eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801044f0 <popcli>:

void
popcli(void)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044f6:	9c                   	pushf
801044f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044f8:	f6 c4 02             	test   $0x2,%ah
801044fb:	75 35                	jne    80104532 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044fd:	e8 2e f4 ff ff       	call   80103930 <mycpu>
80104502:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104509:	78 34                	js     8010453f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010450b:	e8 20 f4 ff ff       	call   80103930 <mycpu>
80104510:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104516:	85 d2                	test   %edx,%edx
80104518:	74 06                	je     80104520 <popcli+0x30>
    sti();
}
8010451a:	c9                   	leave
8010451b:	c3                   	ret
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104520:	e8 0b f4 ff ff       	call   80103930 <mycpu>
80104525:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010452b:	85 c0                	test   %eax,%eax
8010452d:	74 eb                	je     8010451a <popcli+0x2a>
  asm volatile("sti");
8010452f:	fb                   	sti
}
80104530:	c9                   	leave
80104531:	c3                   	ret
    panic("popcli - interruptible");
80104532:	83 ec 0c             	sub    $0xc,%esp
80104535:	68 1c 75 10 80       	push   $0x8010751c
8010453a:	e8 41 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010453f:	83 ec 0c             	sub    $0xc,%esp
80104542:	68 33 75 10 80       	push   $0x80107533
80104547:	e8 34 be ff ff       	call   80100380 <panic>
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104550 <holding>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 75 08             	mov    0x8(%ebp),%esi
80104558:	31 db                	xor    %ebx,%ebx
  pushcli();
8010455a:	e8 41 ff ff ff       	call   801044a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010455f:	8b 06                	mov    (%esi),%eax
80104561:	85 c0                	test   %eax,%eax
80104563:	75 0b                	jne    80104570 <holding+0x20>
  popcli();
80104565:	e8 86 ff ff ff       	call   801044f0 <popcli>
}
8010456a:	89 d8                	mov    %ebx,%eax
8010456c:	5b                   	pop    %ebx
8010456d:	5e                   	pop    %esi
8010456e:	5d                   	pop    %ebp
8010456f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104570:	8b 5e 08             	mov    0x8(%esi),%ebx
80104573:	e8 b8 f3 ff ff       	call   80103930 <mycpu>
80104578:	39 c3                	cmp    %eax,%ebx
8010457a:	0f 94 c3             	sete   %bl
  popcli();
8010457d:	e8 6e ff ff ff       	call   801044f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104582:	0f b6 db             	movzbl %bl,%ebx
}
80104585:	89 d8                	mov    %ebx,%eax
80104587:	5b                   	pop    %ebx
80104588:	5e                   	pop    %esi
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret
8010458b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104590 <release>:
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104598:	e8 03 ff ff ff       	call   801044a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010459d:	8b 03                	mov    (%ebx),%eax
8010459f:	85 c0                	test   %eax,%eax
801045a1:	75 15                	jne    801045b8 <release+0x28>
  popcli();
801045a3:	e8 48 ff ff ff       	call   801044f0 <popcli>
    panic("release");
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	68 3a 75 10 80       	push   $0x8010753a
801045b0:	e8 cb bd ff ff       	call   80100380 <panic>
801045b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801045b8:	8b 73 08             	mov    0x8(%ebx),%esi
801045bb:	e8 70 f3 ff ff       	call   80103930 <mycpu>
801045c0:	39 c6                	cmp    %eax,%esi
801045c2:	75 df                	jne    801045a3 <release+0x13>
  popcli();
801045c4:	e8 27 ff ff ff       	call   801044f0 <popcli>
  lk->pcs[0] = 0;
801045c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045e5:	5b                   	pop    %ebx
801045e6:	5e                   	pop    %esi
801045e7:	5d                   	pop    %ebp
  popcli();
801045e8:	e9 03 ff ff ff       	jmp    801044f0 <popcli>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi

801045f0 <acquire>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045f7:	e8 a4 fe ff ff       	call   801044a0 <pushcli>
  if(holding(lk))
801045fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045ff:	e8 9c fe ff ff       	call   801044a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104604:	8b 03                	mov    (%ebx),%eax
80104606:	85 c0                	test   %eax,%eax
80104608:	0f 85 b2 00 00 00    	jne    801046c0 <acquire+0xd0>
  popcli();
8010460e:	e8 dd fe ff ff       	call   801044f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104613:	b9 01 00 00 00       	mov    $0x1,%ecx
80104618:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010461f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104620:	8b 55 08             	mov    0x8(%ebp),%edx
80104623:	89 c8                	mov    %ecx,%eax
80104625:	f0 87 02             	lock xchg %eax,(%edx)
80104628:	85 c0                	test   %eax,%eax
8010462a:	75 f4                	jne    80104620 <acquire+0x30>
  __sync_synchronize();
8010462c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104631:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104634:	e8 f7 f2 ff ff       	call   80103930 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104639:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010463c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010463e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104641:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104647:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010464c:	77 32                	ja     80104680 <acquire+0x90>
  ebp = (uint*)v - 2;
8010464e:	89 e8                	mov    %ebp,%eax
80104650:	eb 14                	jmp    80104666 <acquire+0x76>
80104652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104658:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010465e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104664:	77 1a                	ja     80104680 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104666:	8b 58 04             	mov    0x4(%eax),%ebx
80104669:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010466d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104670:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104672:	83 fa 0a             	cmp    $0xa,%edx
80104675:	75 e1                	jne    80104658 <acquire+0x68>
}
80104677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010467a:	c9                   	leave
8010467b:	c3                   	ret
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104680:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104684:	83 c1 34             	add    $0x34,%ecx
80104687:	89 ca                	mov    %ecx,%edx
80104689:	29 c2                	sub    %eax,%edx
8010468b:	83 e2 04             	and    $0x4,%edx
8010468e:	74 10                	je     801046a0 <acquire+0xb0>
    pcs[i] = 0;
80104690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104696:	83 c0 04             	add    $0x4,%eax
80104699:	39 c1                	cmp    %eax,%ecx
8010469b:	74 da                	je     80104677 <acquire+0x87>
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801046a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046a6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801046a9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801046b0:	39 c1                	cmp    %eax,%ecx
801046b2:	75 ec                	jne    801046a0 <acquire+0xb0>
801046b4:	eb c1                	jmp    80104677 <acquire+0x87>
801046b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046bd:	00 
801046be:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801046c0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801046c3:	e8 68 f2 ff ff       	call   80103930 <mycpu>
801046c8:	39 c3                	cmp    %eax,%ebx
801046ca:	0f 85 3e ff ff ff    	jne    8010460e <acquire+0x1e>
  popcli();
801046d0:	e8 1b fe ff ff       	call   801044f0 <popcli>
    panic("acquire");
801046d5:	83 ec 0c             	sub    $0xc,%esp
801046d8:	68 42 75 10 80       	push   $0x80107542
801046dd:	e8 9e bc ff ff       	call   80100380 <panic>
801046e2:	66 90                	xchg   %ax,%ax
801046e4:	66 90                	xchg   %ax,%ax
801046e6:	66 90                	xchg   %ax,%ax
801046e8:	66 90                	xchg   %ax,%ax
801046ea:	66 90                	xchg   %ax,%ax
801046ec:	66 90                	xchg   %ax,%ax
801046ee:	66 90                	xchg   %ax,%ax

801046f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	8b 55 08             	mov    0x8(%ebp),%edx
801046f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801046fa:	89 d0                	mov    %edx,%eax
801046fc:	09 c8                	or     %ecx,%eax
801046fe:	a8 03                	test   $0x3,%al
80104700:	75 1e                	jne    80104720 <memset+0x30>
    c &= 0xFF;
80104702:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104706:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104709:	89 d7                	mov    %edx,%edi
8010470b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104711:	fc                   	cld
80104712:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104714:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104717:	89 d0                	mov    %edx,%eax
80104719:	c9                   	leave
8010471a:	c3                   	ret
8010471b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104720:	8b 45 0c             	mov    0xc(%ebp),%eax
80104723:	89 d7                	mov    %edx,%edi
80104725:	fc                   	cld
80104726:	f3 aa                	rep stos %al,%es:(%edi)
80104728:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010472b:	89 d0                	mov    %edx,%eax
8010472d:	c9                   	leave
8010472e:	c3                   	ret
8010472f:	90                   	nop

80104730 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	8b 75 10             	mov    0x10(%ebp),%esi
80104737:	8b 45 08             	mov    0x8(%ebp),%eax
8010473a:	53                   	push   %ebx
8010473b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010473e:	85 f6                	test   %esi,%esi
80104740:	74 2e                	je     80104770 <memcmp+0x40>
80104742:	01 c6                	add    %eax,%esi
80104744:	eb 14                	jmp    8010475a <memcmp+0x2a>
80104746:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010474d:	00 
8010474e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104750:	83 c0 01             	add    $0x1,%eax
80104753:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104756:	39 f0                	cmp    %esi,%eax
80104758:	74 16                	je     80104770 <memcmp+0x40>
    if(*s1 != *s2)
8010475a:	0f b6 08             	movzbl (%eax),%ecx
8010475d:	0f b6 1a             	movzbl (%edx),%ebx
80104760:	38 d9                	cmp    %bl,%cl
80104762:	74 ec                	je     80104750 <memcmp+0x20>
      return *s1 - *s2;
80104764:	0f b6 c1             	movzbl %cl,%eax
80104767:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104769:	5b                   	pop    %ebx
8010476a:	5e                   	pop    %esi
8010476b:	5d                   	pop    %ebp
8010476c:	c3                   	ret
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
80104770:	5b                   	pop    %ebx
  return 0;
80104771:	31 c0                	xor    %eax,%eax
}
80104773:	5e                   	pop    %esi
80104774:	5d                   	pop    %ebp
80104775:	c3                   	ret
80104776:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010477d:	00 
8010477e:	66 90                	xchg   %ax,%ax

80104780 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	8b 55 08             	mov    0x8(%ebp),%edx
80104787:	8b 45 10             	mov    0x10(%ebp),%eax
8010478a:	56                   	push   %esi
8010478b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010478e:	39 d6                	cmp    %edx,%esi
80104790:	73 26                	jae    801047b8 <memmove+0x38>
80104792:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104795:	39 ca                	cmp    %ecx,%edx
80104797:	73 1f                	jae    801047b8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104799:	85 c0                	test   %eax,%eax
8010479b:	74 0f                	je     801047ac <memmove+0x2c>
8010479d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801047a0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801047a4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801047a7:	83 e8 01             	sub    $0x1,%eax
801047aa:	73 f4                	jae    801047a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047ac:	5e                   	pop    %esi
801047ad:	89 d0                	mov    %edx,%eax
801047af:	5f                   	pop    %edi
801047b0:	5d                   	pop    %ebp
801047b1:	c3                   	ret
801047b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801047b8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801047bb:	89 d7                	mov    %edx,%edi
801047bd:	85 c0                	test   %eax,%eax
801047bf:	74 eb                	je     801047ac <memmove+0x2c>
801047c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047c8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047c9:	39 ce                	cmp    %ecx,%esi
801047cb:	75 fb                	jne    801047c8 <memmove+0x48>
}
801047cd:	5e                   	pop    %esi
801047ce:	89 d0                	mov    %edx,%eax
801047d0:	5f                   	pop    %edi
801047d1:	5d                   	pop    %ebp
801047d2:	c3                   	ret
801047d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047da:	00 
801047db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801047e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047e0:	eb 9e                	jmp    80104780 <memmove>
801047e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047e9:	00 
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	8b 55 10             	mov    0x10(%ebp),%edx
801047f7:	8b 45 08             	mov    0x8(%ebp),%eax
801047fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801047fd:	85 d2                	test   %edx,%edx
801047ff:	75 16                	jne    80104817 <strncmp+0x27>
80104801:	eb 2d                	jmp    80104830 <strncmp+0x40>
80104803:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104808:	3a 19                	cmp    (%ecx),%bl
8010480a:	75 12                	jne    8010481e <strncmp+0x2e>
    n--, p++, q++;
8010480c:	83 c0 01             	add    $0x1,%eax
8010480f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104812:	83 ea 01             	sub    $0x1,%edx
80104815:	74 19                	je     80104830 <strncmp+0x40>
80104817:	0f b6 18             	movzbl (%eax),%ebx
8010481a:	84 db                	test   %bl,%bl
8010481c:	75 ea                	jne    80104808 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010481e:	0f b6 00             	movzbl (%eax),%eax
80104821:	0f b6 11             	movzbl (%ecx),%edx
}
80104824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104827:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104828:	29 d0                	sub    %edx,%eax
}
8010482a:	c3                   	ret
8010482b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104830:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104833:	31 c0                	xor    %eax,%eax
}
80104835:	c9                   	leave
80104836:	c3                   	ret
80104837:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010483e:	00 
8010483f:	90                   	nop

80104840 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	8b 75 08             	mov    0x8(%ebp),%esi
80104848:	53                   	push   %ebx
80104849:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010484c:	89 f0                	mov    %esi,%eax
8010484e:	eb 15                	jmp    80104865 <strncpy+0x25>
80104850:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104854:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104857:	83 c0 01             	add    $0x1,%eax
8010485a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010485e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104861:	84 c9                	test   %cl,%cl
80104863:	74 13                	je     80104878 <strncpy+0x38>
80104865:	89 d3                	mov    %edx,%ebx
80104867:	83 ea 01             	sub    $0x1,%edx
8010486a:	85 db                	test   %ebx,%ebx
8010486c:	7f e2                	jg     80104850 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010486e:	5b                   	pop    %ebx
8010486f:	89 f0                	mov    %esi,%eax
80104871:	5e                   	pop    %esi
80104872:	5f                   	pop    %edi
80104873:	5d                   	pop    %ebp
80104874:	c3                   	ret
80104875:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104878:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010487b:	83 e9 01             	sub    $0x1,%ecx
8010487e:	85 d2                	test   %edx,%edx
80104880:	74 ec                	je     8010486e <strncpy+0x2e>
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104888:	83 c0 01             	add    $0x1,%eax
8010488b:	89 ca                	mov    %ecx,%edx
8010488d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104891:	29 c2                	sub    %eax,%edx
80104893:	85 d2                	test   %edx,%edx
80104895:	7f f1                	jg     80104888 <strncpy+0x48>
}
80104897:	5b                   	pop    %ebx
80104898:	89 f0                	mov    %esi,%eax
8010489a:	5e                   	pop    %esi
8010489b:	5f                   	pop    %edi
8010489c:	5d                   	pop    %ebp
8010489d:	c3                   	ret
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	8b 55 10             	mov    0x10(%ebp),%edx
801048a7:	8b 75 08             	mov    0x8(%ebp),%esi
801048aa:	53                   	push   %ebx
801048ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048ae:	85 d2                	test   %edx,%edx
801048b0:	7e 25                	jle    801048d7 <safestrcpy+0x37>
801048b2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801048b6:	89 f2                	mov    %esi,%edx
801048b8:	eb 16                	jmp    801048d0 <safestrcpy+0x30>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048c0:	0f b6 08             	movzbl (%eax),%ecx
801048c3:	83 c0 01             	add    $0x1,%eax
801048c6:	83 c2 01             	add    $0x1,%edx
801048c9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048cc:	84 c9                	test   %cl,%cl
801048ce:	74 04                	je     801048d4 <safestrcpy+0x34>
801048d0:	39 d8                	cmp    %ebx,%eax
801048d2:	75 ec                	jne    801048c0 <safestrcpy+0x20>
    ;
  *s = 0;
801048d4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048d7:	89 f0                	mov    %esi,%eax
801048d9:	5b                   	pop    %ebx
801048da:	5e                   	pop    %esi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret
801048dd:	8d 76 00             	lea    0x0(%esi),%esi

801048e0 <strlen>:

int
strlen(const char *s)
{
801048e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048e1:	31 c0                	xor    %eax,%eax
{
801048e3:	89 e5                	mov    %esp,%ebp
801048e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048e8:	80 3a 00             	cmpb   $0x0,(%edx)
801048eb:	74 0c                	je     801048f9 <strlen+0x19>
801048ed:	8d 76 00             	lea    0x0(%esi),%esi
801048f0:	83 c0 01             	add    $0x1,%eax
801048f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048f7:	75 f7                	jne    801048f0 <strlen+0x10>
    ;
  return n;
}
801048f9:	5d                   	pop    %ebp
801048fa:	c3                   	ret

801048fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104903:	55                   	push   %ebp
  pushl %ebx
80104904:	53                   	push   %ebx
  pushl %esi
80104905:	56                   	push   %esi
  pushl %edi
80104906:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104907:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104909:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010490b:	5f                   	pop    %edi
  popl %esi
8010490c:	5e                   	pop    %esi
  popl %ebx
8010490d:	5b                   	pop    %ebx
  popl %ebp
8010490e:	5d                   	pop    %ebp
  ret
8010490f:	c3                   	ret

80104910 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 04             	sub    $0x4,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010491a:	e8 91 f0 ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010491f:	8b 00                	mov    (%eax),%eax
80104921:	39 c3                	cmp    %eax,%ebx
80104923:	73 1b                	jae    80104940 <fetchint+0x30>
80104925:	8d 53 04             	lea    0x4(%ebx),%edx
80104928:	39 d0                	cmp    %edx,%eax
8010492a:	72 14                	jb     80104940 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010492c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010492f:	8b 13                	mov    (%ebx),%edx
80104931:	89 10                	mov    %edx,(%eax)
  return 0;
80104933:	31 c0                	xor    %eax,%eax
}
80104935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104938:	c9                   	leave
80104939:	c3                   	ret
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104945:	eb ee                	jmp    80104935 <fetchint+0x25>
80104947:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010494e:	00 
8010494f:	90                   	nop

80104950 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
80104957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010495a:	e8 51 f0 ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz)
8010495f:	3b 18                	cmp    (%eax),%ebx
80104961:	73 2d                	jae    80104990 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104963:	8b 55 0c             	mov    0xc(%ebp),%edx
80104966:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104968:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010496a:	39 d3                	cmp    %edx,%ebx
8010496c:	73 22                	jae    80104990 <fetchstr+0x40>
8010496e:	89 d8                	mov    %ebx,%eax
80104970:	eb 0d                	jmp    8010497f <fetchstr+0x2f>
80104972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104978:	83 c0 01             	add    $0x1,%eax
8010497b:	39 d0                	cmp    %edx,%eax
8010497d:	73 11                	jae    80104990 <fetchstr+0x40>
    if(*s == 0)
8010497f:	80 38 00             	cmpb   $0x0,(%eax)
80104982:	75 f4                	jne    80104978 <fetchstr+0x28>
      return s - *pp;
80104984:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104986:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104989:	c9                   	leave
8010498a:	c3                   	ret
8010498b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104990:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104998:	c9                   	leave
80104999:	c3                   	ret
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049a5:	e8 06 f0 ff ff       	call   801039b0 <myproc>
801049aa:	8b 55 08             	mov    0x8(%ebp),%edx
801049ad:	8b 40 18             	mov    0x18(%eax),%eax
801049b0:	8b 40 44             	mov    0x44(%eax),%eax
801049b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049b6:	e8 f5 ef ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049bb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049be:	8b 00                	mov    (%eax),%eax
801049c0:	39 c6                	cmp    %eax,%esi
801049c2:	73 1c                	jae    801049e0 <argint+0x40>
801049c4:	8d 53 08             	lea    0x8(%ebx),%edx
801049c7:	39 d0                	cmp    %edx,%eax
801049c9:	72 15                	jb     801049e0 <argint+0x40>
  *ip = *(int*)(addr);
801049cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ce:	8b 53 04             	mov    0x4(%ebx),%edx
801049d1:	89 10                	mov    %edx,(%eax)
  return 0;
801049d3:	31 c0                	xor    %eax,%eax
}
801049d5:	5b                   	pop    %ebx
801049d6:	5e                   	pop    %esi
801049d7:	5d                   	pop    %ebp
801049d8:	c3                   	ret
801049d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e5:	eb ee                	jmp    801049d5 <argint+0x35>
801049e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049ee:	00 
801049ef:	90                   	nop

801049f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	53                   	push   %ebx
801049f6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049f9:	e8 b2 ef ff ff       	call   801039b0 <myproc>
801049fe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a00:	e8 ab ef ff ff       	call   801039b0 <myproc>
80104a05:	8b 55 08             	mov    0x8(%ebp),%edx
80104a08:	8b 40 18             	mov    0x18(%eax),%eax
80104a0b:	8b 40 44             	mov    0x44(%eax),%eax
80104a0e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a11:	e8 9a ef ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a16:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a19:	8b 00                	mov    (%eax),%eax
80104a1b:	39 c7                	cmp    %eax,%edi
80104a1d:	73 31                	jae    80104a50 <argptr+0x60>
80104a1f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104a22:	39 c8                	cmp    %ecx,%eax
80104a24:	72 2a                	jb     80104a50 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a26:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104a29:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a2c:	85 d2                	test   %edx,%edx
80104a2e:	78 20                	js     80104a50 <argptr+0x60>
80104a30:	8b 16                	mov    (%esi),%edx
80104a32:	39 d0                	cmp    %edx,%eax
80104a34:	73 1a                	jae    80104a50 <argptr+0x60>
80104a36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a39:	01 c3                	add    %eax,%ebx
80104a3b:	39 da                	cmp    %ebx,%edx
80104a3d:	72 11                	jb     80104a50 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a42:	89 02                	mov    %eax,(%edx)
  return 0;
80104a44:	31 c0                	xor    %eax,%eax
}
80104a46:	83 c4 0c             	add    $0xc,%esp
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5f                   	pop    %edi
80104a4c:	5d                   	pop    %ebp
80104a4d:	c3                   	ret
80104a4e:	66 90                	xchg   %ax,%ax
    return -1;
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a55:	eb ef                	jmp    80104a46 <argptr+0x56>
80104a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a5e:	00 
80104a5f:	90                   	nop

80104a60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a65:	e8 46 ef ff ff       	call   801039b0 <myproc>
80104a6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a6d:	8b 40 18             	mov    0x18(%eax),%eax
80104a70:	8b 40 44             	mov    0x44(%eax),%eax
80104a73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a76:	e8 35 ef ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a7e:	8b 00                	mov    (%eax),%eax
80104a80:	39 c6                	cmp    %eax,%esi
80104a82:	73 44                	jae    80104ac8 <argstr+0x68>
80104a84:	8d 53 08             	lea    0x8(%ebx),%edx
80104a87:	39 d0                	cmp    %edx,%eax
80104a89:	72 3d                	jb     80104ac8 <argstr+0x68>
  *ip = *(int*)(addr);
80104a8b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a8e:	e8 1d ef ff ff       	call   801039b0 <myproc>
  if(addr >= curproc->sz)
80104a93:	3b 18                	cmp    (%eax),%ebx
80104a95:	73 31                	jae    80104ac8 <argstr+0x68>
  *pp = (char*)addr;
80104a97:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a9e:	39 d3                	cmp    %edx,%ebx
80104aa0:	73 26                	jae    80104ac8 <argstr+0x68>
80104aa2:	89 d8                	mov    %ebx,%eax
80104aa4:	eb 11                	jmp    80104ab7 <argstr+0x57>
80104aa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aad:	00 
80104aae:	66 90                	xchg   %ax,%ax
80104ab0:	83 c0 01             	add    $0x1,%eax
80104ab3:	39 d0                	cmp    %edx,%eax
80104ab5:	73 11                	jae    80104ac8 <argstr+0x68>
    if(*s == 0)
80104ab7:	80 38 00             	cmpb   $0x0,(%eax)
80104aba:	75 f4                	jne    80104ab0 <argstr+0x50>
      return s - *pp;
80104abc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104abe:	5b                   	pop    %ebx
80104abf:	5e                   	pop    %esi
80104ac0:	5d                   	pop    %ebp
80104ac1:	c3                   	ret
80104ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac8:	5b                   	pop    %ebx
    return -1;
80104ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ace:	5e                   	pop    %esi
80104acf:	5d                   	pop    %ebp
80104ad0:	c3                   	ret
80104ad1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ad8:	00 
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ae7:	e8 c4 ee ff ff       	call   801039b0 <myproc>
80104aec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104aee:	8b 40 18             	mov    0x18(%eax),%eax
80104af1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104af4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104af7:	83 fa 14             	cmp    $0x14,%edx
80104afa:	77 24                	ja     80104b20 <syscall+0x40>
80104afc:	8b 14 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%edx
80104b03:	85 d2                	test   %edx,%edx
80104b05:	74 19                	je     80104b20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104b07:	ff d2                	call   *%edx
80104b09:	89 c2                	mov    %eax,%edx
80104b0b:	8b 43 18             	mov    0x18(%ebx),%eax
80104b0e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b14:	c9                   	leave
80104b15:	c3                   	ret
80104b16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b1d:	00 
80104b1e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104b20:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b21:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b24:	50                   	push   %eax
80104b25:	ff 73 10             	push   0x10(%ebx)
80104b28:	68 4a 75 10 80       	push   $0x8010754a
80104b2d:	e8 7e bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104b32:	8b 43 18             	mov    0x18(%ebx),%eax
80104b35:	83 c4 10             	add    $0x10,%esp
80104b38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b42:	c9                   	leave
80104b43:	c3                   	ret
80104b44:	66 90                	xchg   %ax,%ax
80104b46:	66 90                	xchg   %ax,%ax
80104b48:	66 90                	xchg   %ax,%ax
80104b4a:	66 90                	xchg   %ax,%ax
80104b4c:	66 90                	xchg   %ax,%ax
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b58:	53                   	push   %ebx
80104b59:	83 ec 34             	sub    $0x34,%esp
80104b5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b62:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b65:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b68:	57                   	push   %edi
80104b69:	50                   	push   %eax
80104b6a:	e8 81 d5 ff ff       	call   801020f0 <nameiparent>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	85 c0                	test   %eax,%eax
80104b74:	74 5e                	je     80104bd4 <create+0x84>
    return 0;
  ilock(dp);
80104b76:	83 ec 0c             	sub    $0xc,%esp
80104b79:	89 c3                	mov    %eax,%ebx
80104b7b:	50                   	push   %eax
80104b7c:	e8 6f cc ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b81:	83 c4 0c             	add    $0xc,%esp
80104b84:	6a 00                	push   $0x0
80104b86:	57                   	push   %edi
80104b87:	53                   	push   %ebx
80104b88:	e8 b3 d1 ff ff       	call   80101d40 <dirlookup>
80104b8d:	83 c4 10             	add    $0x10,%esp
80104b90:	89 c6                	mov    %eax,%esi
80104b92:	85 c0                	test   %eax,%eax
80104b94:	74 4a                	je     80104be0 <create+0x90>
    iunlockput(dp);
80104b96:	83 ec 0c             	sub    $0xc,%esp
80104b99:	53                   	push   %ebx
80104b9a:	e8 e1 ce ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
80104b9f:	89 34 24             	mov    %esi,(%esp)
80104ba2:	e8 49 cc ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ba7:	83 c4 10             	add    $0x10,%esp
80104baa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104baf:	75 17                	jne    80104bc8 <create+0x78>
80104bb1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104bb6:	75 10                	jne    80104bc8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bbb:	89 f0                	mov    %esi,%eax
80104bbd:	5b                   	pop    %ebx
80104bbe:	5e                   	pop    %esi
80104bbf:	5f                   	pop    %edi
80104bc0:	5d                   	pop    %ebp
80104bc1:	c3                   	ret
80104bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104bc8:	83 ec 0c             	sub    $0xc,%esp
80104bcb:	56                   	push   %esi
80104bcc:	e8 af ce ff ff       	call   80101a80 <iunlockput>
    return 0;
80104bd1:	83 c4 10             	add    $0x10,%esp
}
80104bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104bd7:	31 f6                	xor    %esi,%esi
}
80104bd9:	5b                   	pop    %ebx
80104bda:	89 f0                	mov    %esi,%eax
80104bdc:	5e                   	pop    %esi
80104bdd:	5f                   	pop    %edi
80104bde:	5d                   	pop    %ebp
80104bdf:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104be0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104be4:	83 ec 08             	sub    $0x8,%esp
80104be7:	50                   	push   %eax
80104be8:	ff 33                	push   (%ebx)
80104bea:	e8 91 ca ff ff       	call   80101680 <ialloc>
80104bef:	83 c4 10             	add    $0x10,%esp
80104bf2:	89 c6                	mov    %eax,%esi
80104bf4:	85 c0                	test   %eax,%eax
80104bf6:	0f 84 bc 00 00 00    	je     80104cb8 <create+0x168>
  ilock(ip);
80104bfc:	83 ec 0c             	sub    $0xc,%esp
80104bff:	50                   	push   %eax
80104c00:	e8 eb cb ff ff       	call   801017f0 <ilock>
  ip->major = major;
80104c05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104c09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104c11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c15:	b8 01 00 00 00       	mov    $0x1,%eax
80104c1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c1e:	89 34 24             	mov    %esi,(%esp)
80104c21:	e8 1a cb ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c26:	83 c4 10             	add    $0x10,%esp
80104c29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c2e:	74 30                	je     80104c60 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104c30:	83 ec 04             	sub    $0x4,%esp
80104c33:	ff 76 04             	push   0x4(%esi)
80104c36:	57                   	push   %edi
80104c37:	53                   	push   %ebx
80104c38:	e8 d3 d3 ff ff       	call   80102010 <dirlink>
80104c3d:	83 c4 10             	add    $0x10,%esp
80104c40:	85 c0                	test   %eax,%eax
80104c42:	78 67                	js     80104cab <create+0x15b>
  iunlockput(dp);
80104c44:	83 ec 0c             	sub    $0xc,%esp
80104c47:	53                   	push   %ebx
80104c48:	e8 33 ce ff ff       	call   80101a80 <iunlockput>
  return ip;
80104c4d:	83 c4 10             	add    $0x10,%esp
}
80104c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c53:	89 f0                	mov    %esi,%eax
80104c55:	5b                   	pop    %ebx
80104c56:	5e                   	pop    %esi
80104c57:	5f                   	pop    %edi
80104c58:	5d                   	pop    %ebp
80104c59:	c3                   	ret
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c68:	53                   	push   %ebx
80104c69:	e8 d2 ca ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c6e:	83 c4 0c             	add    $0xc,%esp
80104c71:	ff 76 04             	push   0x4(%esi)
80104c74:	68 82 75 10 80       	push   $0x80107582
80104c79:	56                   	push   %esi
80104c7a:	e8 91 d3 ff ff       	call   80102010 <dirlink>
80104c7f:	83 c4 10             	add    $0x10,%esp
80104c82:	85 c0                	test   %eax,%eax
80104c84:	78 18                	js     80104c9e <create+0x14e>
80104c86:	83 ec 04             	sub    $0x4,%esp
80104c89:	ff 73 04             	push   0x4(%ebx)
80104c8c:	68 81 75 10 80       	push   $0x80107581
80104c91:	56                   	push   %esi
80104c92:	e8 79 d3 ff ff       	call   80102010 <dirlink>
80104c97:	83 c4 10             	add    $0x10,%esp
80104c9a:	85 c0                	test   %eax,%eax
80104c9c:	79 92                	jns    80104c30 <create+0xe0>
      panic("create dots");
80104c9e:	83 ec 0c             	sub    $0xc,%esp
80104ca1:	68 75 75 10 80       	push   $0x80107575
80104ca6:	e8 d5 b6 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104cab:	83 ec 0c             	sub    $0xc,%esp
80104cae:	68 84 75 10 80       	push   $0x80107584
80104cb3:	e8 c8 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104cb8:	83 ec 0c             	sub    $0xc,%esp
80104cbb:	68 66 75 10 80       	push   $0x80107566
80104cc0:	e8 bb b6 ff ff       	call   80100380 <panic>
80104cc5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ccc:	00 
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi

80104cd0 <sys_dup>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104cd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cdb:	50                   	push   %eax
80104cdc:	6a 00                	push   $0x0
80104cde:	e8 bd fc ff ff       	call   801049a0 <argint>
80104ce3:	83 c4 10             	add    $0x10,%esp
80104ce6:	85 c0                	test   %eax,%eax
80104ce8:	78 36                	js     80104d20 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cee:	77 30                	ja     80104d20 <sys_dup+0x50>
80104cf0:	e8 bb ec ff ff       	call   801039b0 <myproc>
80104cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cf8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104cfc:	85 f6                	test   %esi,%esi
80104cfe:	74 20                	je     80104d20 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104d00:	e8 ab ec ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d05:	31 db                	xor    %ebx,%ebx
80104d07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d0e:	00 
80104d0f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104d10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d14:	85 d2                	test   %edx,%edx
80104d16:	74 18                	je     80104d30 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104d18:	83 c3 01             	add    $0x1,%ebx
80104d1b:	83 fb 10             	cmp    $0x10,%ebx
80104d1e:	75 f0                	jne    80104d10 <sys_dup+0x40>
}
80104d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d28:	89 d8                	mov    %ebx,%eax
80104d2a:	5b                   	pop    %ebx
80104d2b:	5e                   	pop    %esi
80104d2c:	5d                   	pop    %ebp
80104d2d:	c3                   	ret
80104d2e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d30:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d33:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d37:	56                   	push   %esi
80104d38:	e8 d3 c1 ff ff       	call   80100f10 <filedup>
  return fd;
80104d3d:	83 c4 10             	add    $0x10,%esp
}
80104d40:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d43:	89 d8                	mov    %ebx,%eax
80104d45:	5b                   	pop    %ebx
80104d46:	5e                   	pop    %esi
80104d47:	5d                   	pop    %ebp
80104d48:	c3                   	ret
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d50 <sys_read>:
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d5b:	53                   	push   %ebx
80104d5c:	6a 00                	push   $0x0
80104d5e:	e8 3d fc ff ff       	call   801049a0 <argint>
80104d63:	83 c4 10             	add    $0x10,%esp
80104d66:	85 c0                	test   %eax,%eax
80104d68:	78 5e                	js     80104dc8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d6e:	77 58                	ja     80104dc8 <sys_read+0x78>
80104d70:	e8 3b ec ff ff       	call   801039b0 <myproc>
80104d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d7c:	85 f6                	test   %esi,%esi
80104d7e:	74 48                	je     80104dc8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d80:	83 ec 08             	sub    $0x8,%esp
80104d83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d86:	50                   	push   %eax
80104d87:	6a 02                	push   $0x2
80104d89:	e8 12 fc ff ff       	call   801049a0 <argint>
80104d8e:	83 c4 10             	add    $0x10,%esp
80104d91:	85 c0                	test   %eax,%eax
80104d93:	78 33                	js     80104dc8 <sys_read+0x78>
80104d95:	83 ec 04             	sub    $0x4,%esp
80104d98:	ff 75 f0             	push   -0x10(%ebp)
80104d9b:	53                   	push   %ebx
80104d9c:	6a 01                	push   $0x1
80104d9e:	e8 4d fc ff ff       	call   801049f0 <argptr>
80104da3:	83 c4 10             	add    $0x10,%esp
80104da6:	85 c0                	test   %eax,%eax
80104da8:	78 1e                	js     80104dc8 <sys_read+0x78>
  return fileread(f, p, n);
80104daa:	83 ec 04             	sub    $0x4,%esp
80104dad:	ff 75 f0             	push   -0x10(%ebp)
80104db0:	ff 75 f4             	push   -0xc(%ebp)
80104db3:	56                   	push   %esi
80104db4:	e8 d7 c2 ff ff       	call   80101090 <fileread>
80104db9:	83 c4 10             	add    $0x10,%esp
}
80104dbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dbf:	5b                   	pop    %ebx
80104dc0:	5e                   	pop    %esi
80104dc1:	5d                   	pop    %ebp
80104dc2:	c3                   	ret
80104dc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104dc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dcd:	eb ed                	jmp    80104dbc <sys_read+0x6c>
80104dcf:	90                   	nop

80104dd0 <sys_write>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104dd5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104dd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ddb:	53                   	push   %ebx
80104ddc:	6a 00                	push   $0x0
80104dde:	e8 bd fb ff ff       	call   801049a0 <argint>
80104de3:	83 c4 10             	add    $0x10,%esp
80104de6:	85 c0                	test   %eax,%eax
80104de8:	78 5e                	js     80104e48 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dee:	77 58                	ja     80104e48 <sys_write+0x78>
80104df0:	e8 bb eb ff ff       	call   801039b0 <myproc>
80104df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104df8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dfc:	85 f6                	test   %esi,%esi
80104dfe:	74 48                	je     80104e48 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e00:	83 ec 08             	sub    $0x8,%esp
80104e03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e06:	50                   	push   %eax
80104e07:	6a 02                	push   $0x2
80104e09:	e8 92 fb ff ff       	call   801049a0 <argint>
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	85 c0                	test   %eax,%eax
80104e13:	78 33                	js     80104e48 <sys_write+0x78>
80104e15:	83 ec 04             	sub    $0x4,%esp
80104e18:	ff 75 f0             	push   -0x10(%ebp)
80104e1b:	53                   	push   %ebx
80104e1c:	6a 01                	push   $0x1
80104e1e:	e8 cd fb ff ff       	call   801049f0 <argptr>
80104e23:	83 c4 10             	add    $0x10,%esp
80104e26:	85 c0                	test   %eax,%eax
80104e28:	78 1e                	js     80104e48 <sys_write+0x78>
  return filewrite(f, p, n);
80104e2a:	83 ec 04             	sub    $0x4,%esp
80104e2d:	ff 75 f0             	push   -0x10(%ebp)
80104e30:	ff 75 f4             	push   -0xc(%ebp)
80104e33:	56                   	push   %esi
80104e34:	e8 e7 c2 ff ff       	call   80101120 <filewrite>
80104e39:	83 c4 10             	add    $0x10,%esp
}
80104e3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e3f:	5b                   	pop    %ebx
80104e40:	5e                   	pop    %esi
80104e41:	5d                   	pop    %ebp
80104e42:	c3                   	ret
80104e43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e4d:	eb ed                	jmp    80104e3c <sys_write+0x6c>
80104e4f:	90                   	nop

80104e50 <sys_close>:
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e5b:	50                   	push   %eax
80104e5c:	6a 00                	push   $0x0
80104e5e:	e8 3d fb ff ff       	call   801049a0 <argint>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	85 c0                	test   %eax,%eax
80104e68:	78 3e                	js     80104ea8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e6e:	77 38                	ja     80104ea8 <sys_close+0x58>
80104e70:	e8 3b eb ff ff       	call   801039b0 <myproc>
80104e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e78:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e7b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e7f:	85 f6                	test   %esi,%esi
80104e81:	74 25                	je     80104ea8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e83:	e8 28 eb ff ff       	call   801039b0 <myproc>
  fileclose(f);
80104e88:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e8b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104e92:	00 
  fileclose(f);
80104e93:	56                   	push   %esi
80104e94:	e8 c7 c0 ff ff       	call   80100f60 <fileclose>
  return 0;
80104e99:	83 c4 10             	add    $0x10,%esp
80104e9c:	31 c0                	xor    %eax,%eax
}
80104e9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea1:	5b                   	pop    %ebx
80104ea2:	5e                   	pop    %esi
80104ea3:	5d                   	pop    %ebp
80104ea4:	c3                   	ret
80104ea5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ead:	eb ef                	jmp    80104e9e <sys_close+0x4e>
80104eaf:	90                   	nop

80104eb0 <sys_fstat>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104eb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104eb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ebb:	53                   	push   %ebx
80104ebc:	6a 00                	push   $0x0
80104ebe:	e8 dd fa ff ff       	call   801049a0 <argint>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	78 46                	js     80104f10 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ece:	77 40                	ja     80104f10 <sys_fstat+0x60>
80104ed0:	e8 db ea ff ff       	call   801039b0 <myproc>
80104ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ed8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104edc:	85 f6                	test   %esi,%esi
80104ede:	74 30                	je     80104f10 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ee0:	83 ec 04             	sub    $0x4,%esp
80104ee3:	6a 14                	push   $0x14
80104ee5:	53                   	push   %ebx
80104ee6:	6a 01                	push   $0x1
80104ee8:	e8 03 fb ff ff       	call   801049f0 <argptr>
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	78 1c                	js     80104f10 <sys_fstat+0x60>
  return filestat(f, st);
80104ef4:	83 ec 08             	sub    $0x8,%esp
80104ef7:	ff 75 f4             	push   -0xc(%ebp)
80104efa:	56                   	push   %esi
80104efb:	e8 40 c1 ff ff       	call   80101040 <filestat>
80104f00:	83 c4 10             	add    $0x10,%esp
}
80104f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f06:	5b                   	pop    %ebx
80104f07:	5e                   	pop    %esi
80104f08:	5d                   	pop    %ebp
80104f09:	c3                   	ret
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f15:	eb ec                	jmp    80104f03 <sys_fstat+0x53>
80104f17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f1e:	00 
80104f1f:	90                   	nop

80104f20 <sys_link>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f25:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f28:	53                   	push   %ebx
80104f29:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f2c:	50                   	push   %eax
80104f2d:	6a 00                	push   $0x0
80104f2f:	e8 2c fb ff ff       	call   80104a60 <argstr>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	0f 88 fb 00 00 00    	js     8010503a <sys_link+0x11a>
80104f3f:	83 ec 08             	sub    $0x8,%esp
80104f42:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f45:	50                   	push   %eax
80104f46:	6a 01                	push   $0x1
80104f48:	e8 13 fb ff ff       	call   80104a60 <argstr>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	85 c0                	test   %eax,%eax
80104f52:	0f 88 e2 00 00 00    	js     8010503a <sys_link+0x11a>
  begin_op();
80104f58:	e8 33 de ff ff       	call   80102d90 <begin_op>
  if((ip = namei(old)) == 0){
80104f5d:	83 ec 0c             	sub    $0xc,%esp
80104f60:	ff 75 d4             	push   -0x2c(%ebp)
80104f63:	e8 68 d1 ff ff       	call   801020d0 <namei>
80104f68:	83 c4 10             	add    $0x10,%esp
80104f6b:	89 c3                	mov    %eax,%ebx
80104f6d:	85 c0                	test   %eax,%eax
80104f6f:	0f 84 df 00 00 00    	je     80105054 <sys_link+0x134>
  ilock(ip);
80104f75:	83 ec 0c             	sub    $0xc,%esp
80104f78:	50                   	push   %eax
80104f79:	e8 72 c8 ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
80104f7e:	83 c4 10             	add    $0x10,%esp
80104f81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f86:	0f 84 b5 00 00 00    	je     80105041 <sys_link+0x121>
  iupdate(ip);
80104f8c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f8f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f94:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f97:	53                   	push   %ebx
80104f98:	e8 a3 c7 ff ff       	call   80101740 <iupdate>
  iunlock(ip);
80104f9d:	89 1c 24             	mov    %ebx,(%esp)
80104fa0:	e8 2b c9 ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fa5:	58                   	pop    %eax
80104fa6:	5a                   	pop    %edx
80104fa7:	57                   	push   %edi
80104fa8:	ff 75 d0             	push   -0x30(%ebp)
80104fab:	e8 40 d1 ff ff       	call   801020f0 <nameiparent>
80104fb0:	83 c4 10             	add    $0x10,%esp
80104fb3:	89 c6                	mov    %eax,%esi
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	74 5b                	je     80105014 <sys_link+0xf4>
  ilock(dp);
80104fb9:	83 ec 0c             	sub    $0xc,%esp
80104fbc:	50                   	push   %eax
80104fbd:	e8 2e c8 ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fc2:	8b 03                	mov    (%ebx),%eax
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	39 06                	cmp    %eax,(%esi)
80104fc9:	75 3d                	jne    80105008 <sys_link+0xe8>
80104fcb:	83 ec 04             	sub    $0x4,%esp
80104fce:	ff 73 04             	push   0x4(%ebx)
80104fd1:	57                   	push   %edi
80104fd2:	56                   	push   %esi
80104fd3:	e8 38 d0 ff ff       	call   80102010 <dirlink>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	78 29                	js     80105008 <sys_link+0xe8>
  iunlockput(dp);
80104fdf:	83 ec 0c             	sub    $0xc,%esp
80104fe2:	56                   	push   %esi
80104fe3:	e8 98 ca ff ff       	call   80101a80 <iunlockput>
  iput(ip);
80104fe8:	89 1c 24             	mov    %ebx,(%esp)
80104feb:	e8 30 c9 ff ff       	call   80101920 <iput>
  end_op();
80104ff0:	e8 0b de ff ff       	call   80102e00 <end_op>
  return 0;
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	31 c0                	xor    %eax,%eax
}
80104ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ffd:	5b                   	pop    %ebx
80104ffe:	5e                   	pop    %esi
80104fff:	5f                   	pop    %edi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	56                   	push   %esi
8010500c:	e8 6f ca ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105011:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	53                   	push   %ebx
80105018:	e8 d3 c7 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
8010501d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105022:	89 1c 24             	mov    %ebx,(%esp)
80105025:	e8 16 c7 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
8010502a:	89 1c 24             	mov    %ebx,(%esp)
8010502d:	e8 4e ca ff ff       	call   80101a80 <iunlockput>
  end_op();
80105032:	e8 c9 dd ff ff       	call   80102e00 <end_op>
  return -1;
80105037:	83 c4 10             	add    $0x10,%esp
    return -1;
8010503a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503f:	eb b9                	jmp    80104ffa <sys_link+0xda>
    iunlockput(ip);
80105041:	83 ec 0c             	sub    $0xc,%esp
80105044:	53                   	push   %ebx
80105045:	e8 36 ca ff ff       	call   80101a80 <iunlockput>
    end_op();
8010504a:	e8 b1 dd ff ff       	call   80102e00 <end_op>
    return -1;
8010504f:	83 c4 10             	add    $0x10,%esp
80105052:	eb e6                	jmp    8010503a <sys_link+0x11a>
    end_op();
80105054:	e8 a7 dd ff ff       	call   80102e00 <end_op>
    return -1;
80105059:	eb df                	jmp    8010503a <sys_link+0x11a>
8010505b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105060 <sys_unlink>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105065:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105068:	53                   	push   %ebx
80105069:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010506c:	50                   	push   %eax
8010506d:	6a 00                	push   $0x0
8010506f:	e8 ec f9 ff ff       	call   80104a60 <argstr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	0f 88 54 01 00 00    	js     801051d3 <sys_unlink+0x173>
  begin_op();
8010507f:	e8 0c dd ff ff       	call   80102d90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105084:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105087:	83 ec 08             	sub    $0x8,%esp
8010508a:	53                   	push   %ebx
8010508b:	ff 75 c0             	push   -0x40(%ebp)
8010508e:	e8 5d d0 ff ff       	call   801020f0 <nameiparent>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105099:	85 c0                	test   %eax,%eax
8010509b:	0f 84 58 01 00 00    	je     801051f9 <sys_unlink+0x199>
  ilock(dp);
801050a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	57                   	push   %edi
801050a8:	e8 43 c7 ff ff       	call   801017f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050ad:	58                   	pop    %eax
801050ae:	5a                   	pop    %edx
801050af:	68 82 75 10 80       	push   $0x80107582
801050b4:	53                   	push   %ebx
801050b5:	e8 66 cc ff ff       	call   80101d20 <namecmp>
801050ba:	83 c4 10             	add    $0x10,%esp
801050bd:	85 c0                	test   %eax,%eax
801050bf:	0f 84 fb 00 00 00    	je     801051c0 <sys_unlink+0x160>
801050c5:	83 ec 08             	sub    $0x8,%esp
801050c8:	68 81 75 10 80       	push   $0x80107581
801050cd:	53                   	push   %ebx
801050ce:	e8 4d cc ff ff       	call   80101d20 <namecmp>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	0f 84 e2 00 00 00    	je     801051c0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050de:	83 ec 04             	sub    $0x4,%esp
801050e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050e4:	50                   	push   %eax
801050e5:	53                   	push   %ebx
801050e6:	57                   	push   %edi
801050e7:	e8 54 cc ff ff       	call   80101d40 <dirlookup>
801050ec:	83 c4 10             	add    $0x10,%esp
801050ef:	89 c3                	mov    %eax,%ebx
801050f1:	85 c0                	test   %eax,%eax
801050f3:	0f 84 c7 00 00 00    	je     801051c0 <sys_unlink+0x160>
  ilock(ip);
801050f9:	83 ec 0c             	sub    $0xc,%esp
801050fc:	50                   	push   %eax
801050fd:	e8 ee c6 ff ff       	call   801017f0 <ilock>
  if(ip->nlink < 1)
80105102:	83 c4 10             	add    $0x10,%esp
80105105:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010510a:	0f 8e 0a 01 00 00    	jle    8010521a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105110:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105115:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105118:	74 66                	je     80105180 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010511a:	83 ec 04             	sub    $0x4,%esp
8010511d:	6a 10                	push   $0x10
8010511f:	6a 00                	push   $0x0
80105121:	57                   	push   %edi
80105122:	e8 c9 f5 ff ff       	call   801046f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105127:	6a 10                	push   $0x10
80105129:	ff 75 c4             	push   -0x3c(%ebp)
8010512c:	57                   	push   %edi
8010512d:	ff 75 b4             	push   -0x4c(%ebp)
80105130:	e8 cb ca ff ff       	call   80101c00 <writei>
80105135:	83 c4 20             	add    $0x20,%esp
80105138:	83 f8 10             	cmp    $0x10,%eax
8010513b:	0f 85 cc 00 00 00    	jne    8010520d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105141:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105146:	0f 84 94 00 00 00    	je     801051e0 <sys_unlink+0x180>
  iunlockput(dp);
8010514c:	83 ec 0c             	sub    $0xc,%esp
8010514f:	ff 75 b4             	push   -0x4c(%ebp)
80105152:	e8 29 c9 ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
80105157:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010515c:	89 1c 24             	mov    %ebx,(%esp)
8010515f:	e8 dc c5 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
80105164:	89 1c 24             	mov    %ebx,(%esp)
80105167:	e8 14 c9 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010516c:	e8 8f dc ff ff       	call   80102e00 <end_op>
  return 0;
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	31 c0                	xor    %eax,%eax
}
80105176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5f                   	pop    %edi
8010517c:	5d                   	pop    %ebp
8010517d:	c3                   	ret
8010517e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105180:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105184:	76 94                	jbe    8010511a <sys_unlink+0xba>
80105186:	be 20 00 00 00       	mov    $0x20,%esi
8010518b:	eb 0b                	jmp    80105198 <sys_unlink+0x138>
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
80105190:	83 c6 10             	add    $0x10,%esi
80105193:	3b 73 58             	cmp    0x58(%ebx),%esi
80105196:	73 82                	jae    8010511a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105198:	6a 10                	push   $0x10
8010519a:	56                   	push   %esi
8010519b:	57                   	push   %edi
8010519c:	53                   	push   %ebx
8010519d:	e8 5e c9 ff ff       	call   80101b00 <readi>
801051a2:	83 c4 10             	add    $0x10,%esp
801051a5:	83 f8 10             	cmp    $0x10,%eax
801051a8:	75 56                	jne    80105200 <sys_unlink+0x1a0>
    if(de.inum != 0)
801051aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051af:	74 df                	je     80105190 <sys_unlink+0x130>
    iunlockput(ip);
801051b1:	83 ec 0c             	sub    $0xc,%esp
801051b4:	53                   	push   %ebx
801051b5:	e8 c6 c8 ff ff       	call   80101a80 <iunlockput>
    goto bad;
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801051c0:	83 ec 0c             	sub    $0xc,%esp
801051c3:	ff 75 b4             	push   -0x4c(%ebp)
801051c6:	e8 b5 c8 ff ff       	call   80101a80 <iunlockput>
  end_op();
801051cb:	e8 30 dc ff ff       	call   80102e00 <end_op>
  return -1;
801051d0:	83 c4 10             	add    $0x10,%esp
    return -1;
801051d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d8:	eb 9c                	jmp    80105176 <sys_unlink+0x116>
801051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801051e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051eb:	50                   	push   %eax
801051ec:	e8 4f c5 ff ff       	call   80101740 <iupdate>
801051f1:	83 c4 10             	add    $0x10,%esp
801051f4:	e9 53 ff ff ff       	jmp    8010514c <sys_unlink+0xec>
    end_op();
801051f9:	e8 02 dc ff ff       	call   80102e00 <end_op>
    return -1;
801051fe:	eb d3                	jmp    801051d3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	68 a6 75 10 80       	push   $0x801075a6
80105208:	e8 73 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010520d:	83 ec 0c             	sub    $0xc,%esp
80105210:	68 b8 75 10 80       	push   $0x801075b8
80105215:	e8 66 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010521a:	83 ec 0c             	sub    $0xc,%esp
8010521d:	68 94 75 10 80       	push   $0x80107594
80105222:	e8 59 b1 ff ff       	call   80100380 <panic>
80105227:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010522e:	00 
8010522f:	90                   	nop

80105230 <sys_open>:

int
sys_open(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105235:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105238:	53                   	push   %ebx
80105239:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010523c:	50                   	push   %eax
8010523d:	6a 00                	push   $0x0
8010523f:	e8 1c f8 ff ff       	call   80104a60 <argstr>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	0f 88 8e 00 00 00    	js     801052dd <sys_open+0xad>
8010524f:	83 ec 08             	sub    $0x8,%esp
80105252:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105255:	50                   	push   %eax
80105256:	6a 01                	push   $0x1
80105258:	e8 43 f7 ff ff       	call   801049a0 <argint>
8010525d:	83 c4 10             	add    $0x10,%esp
80105260:	85 c0                	test   %eax,%eax
80105262:	78 79                	js     801052dd <sys_open+0xad>
    return -1;

  begin_op();
80105264:	e8 27 db ff ff       	call   80102d90 <begin_op>

  if(omode & O_CREATE){
80105269:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010526d:	75 79                	jne    801052e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010526f:	83 ec 0c             	sub    $0xc,%esp
80105272:	ff 75 e0             	push   -0x20(%ebp)
80105275:	e8 56 ce ff ff       	call   801020d0 <namei>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	89 c6                	mov    %eax,%esi
8010527f:	85 c0                	test   %eax,%eax
80105281:	0f 84 7e 00 00 00    	je     80105305 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	50                   	push   %eax
8010528b:	e8 60 c5 ff ff       	call   801017f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105290:	83 c4 10             	add    $0x10,%esp
80105293:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105298:	0f 84 ba 00 00 00    	je     80105358 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010529e:	e8 fd bb ff ff       	call   80100ea0 <filealloc>
801052a3:	89 c7                	mov    %eax,%edi
801052a5:	85 c0                	test   %eax,%eax
801052a7:	74 23                	je     801052cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801052a9:	e8 02 e7 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052b4:	85 d2                	test   %edx,%edx
801052b6:	74 58                	je     80105310 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801052b8:	83 c3 01             	add    $0x1,%ebx
801052bb:	83 fb 10             	cmp    $0x10,%ebx
801052be:	75 f0                	jne    801052b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	57                   	push   %edi
801052c4:	e8 97 bc ff ff       	call   80100f60 <fileclose>
801052c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052cc:	83 ec 0c             	sub    $0xc,%esp
801052cf:	56                   	push   %esi
801052d0:	e8 ab c7 ff ff       	call   80101a80 <iunlockput>
    end_op();
801052d5:	e8 26 db ff ff       	call   80102e00 <end_op>
    return -1;
801052da:	83 c4 10             	add    $0x10,%esp
    return -1;
801052dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052e2:	eb 65                	jmp    80105349 <sys_open+0x119>
801052e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052e8:	83 ec 0c             	sub    $0xc,%esp
801052eb:	31 c9                	xor    %ecx,%ecx
801052ed:	ba 02 00 00 00       	mov    $0x2,%edx
801052f2:	6a 00                	push   $0x0
801052f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052f7:	e8 54 f8 ff ff       	call   80104b50 <create>
    if(ip == 0){
801052fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105301:	85 c0                	test   %eax,%eax
80105303:	75 99                	jne    8010529e <sys_open+0x6e>
      end_op();
80105305:	e8 f6 da ff ff       	call   80102e00 <end_op>
      return -1;
8010530a:	eb d1                	jmp    801052dd <sys_open+0xad>
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105310:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105313:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105317:	56                   	push   %esi
80105318:	e8 b3 c5 ff ff       	call   801018d0 <iunlock>
  end_op();
8010531d:	e8 de da ff ff       	call   80102e00 <end_op>

  f->type = FD_INODE;
80105322:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105328:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010532b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010532e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105331:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105333:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010533a:	f7 d0                	not    %eax
8010533c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010533f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105342:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105345:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105349:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010534c:	89 d8                	mov    %ebx,%eax
8010534e:	5b                   	pop    %ebx
8010534f:	5e                   	pop    %esi
80105350:	5f                   	pop    %edi
80105351:	5d                   	pop    %ebp
80105352:	c3                   	ret
80105353:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105358:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010535b:	85 c9                	test   %ecx,%ecx
8010535d:	0f 84 3b ff ff ff    	je     8010529e <sys_open+0x6e>
80105363:	e9 64 ff ff ff       	jmp    801052cc <sys_open+0x9c>
80105368:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010536f:	00 

80105370 <sys_mkdir>:

int
sys_mkdir(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105376:	e8 15 da ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010537b:	83 ec 08             	sub    $0x8,%esp
8010537e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105381:	50                   	push   %eax
80105382:	6a 00                	push   $0x0
80105384:	e8 d7 f6 ff ff       	call   80104a60 <argstr>
80105389:	83 c4 10             	add    $0x10,%esp
8010538c:	85 c0                	test   %eax,%eax
8010538e:	78 30                	js     801053c0 <sys_mkdir+0x50>
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105396:	31 c9                	xor    %ecx,%ecx
80105398:	ba 01 00 00 00       	mov    $0x1,%edx
8010539d:	6a 00                	push   $0x0
8010539f:	e8 ac f7 ff ff       	call   80104b50 <create>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	74 15                	je     801053c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053ab:	83 ec 0c             	sub    $0xc,%esp
801053ae:	50                   	push   %eax
801053af:	e8 cc c6 ff ff       	call   80101a80 <iunlockput>
  end_op();
801053b4:	e8 47 da ff ff       	call   80102e00 <end_op>
  return 0;
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	31 c0                	xor    %eax,%eax
}
801053be:	c9                   	leave
801053bf:	c3                   	ret
    end_op();
801053c0:	e8 3b da ff ff       	call   80102e00 <end_op>
    return -1;
801053c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ca:	c9                   	leave
801053cb:	c3                   	ret
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053d0 <sys_mknod>:

int
sys_mknod(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053d6:	e8 b5 d9 ff ff       	call   80102d90 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053db:	83 ec 08             	sub    $0x8,%esp
801053de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053e1:	50                   	push   %eax
801053e2:	6a 00                	push   $0x0
801053e4:	e8 77 f6 ff ff       	call   80104a60 <argstr>
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	85 c0                	test   %eax,%eax
801053ee:	78 60                	js     80105450 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053f0:	83 ec 08             	sub    $0x8,%esp
801053f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053f6:	50                   	push   %eax
801053f7:	6a 01                	push   $0x1
801053f9:	e8 a2 f5 ff ff       	call   801049a0 <argint>
  if((argstr(0, &path)) < 0 ||
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	78 4b                	js     80105450 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105405:	83 ec 08             	sub    $0x8,%esp
80105408:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540b:	50                   	push   %eax
8010540c:	6a 02                	push   $0x2
8010540e:	e8 8d f5 ff ff       	call   801049a0 <argint>
     argint(1, &major) < 0 ||
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	78 36                	js     80105450 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010541a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105425:	ba 03 00 00 00       	mov    $0x3,%edx
8010542a:	50                   	push   %eax
8010542b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010542e:	e8 1d f7 ff ff       	call   80104b50 <create>
     argint(2, &minor) < 0 ||
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	74 16                	je     80105450 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010543a:	83 ec 0c             	sub    $0xc,%esp
8010543d:	50                   	push   %eax
8010543e:	e8 3d c6 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105443:	e8 b8 d9 ff ff       	call   80102e00 <end_op>
  return 0;
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	31 c0                	xor    %eax,%eax
}
8010544d:	c9                   	leave
8010544e:	c3                   	ret
8010544f:	90                   	nop
    end_op();
80105450:	e8 ab d9 ff ff       	call   80102e00 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010545a:	c9                   	leave
8010545b:	c3                   	ret
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_chdir>:

int
sys_chdir(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
80105465:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105468:	e8 43 e5 ff ff       	call   801039b0 <myproc>
8010546d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010546f:	e8 1c d9 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105474:	83 ec 08             	sub    $0x8,%esp
80105477:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010547a:	50                   	push   %eax
8010547b:	6a 00                	push   $0x0
8010547d:	e8 de f5 ff ff       	call   80104a60 <argstr>
80105482:	83 c4 10             	add    $0x10,%esp
80105485:	85 c0                	test   %eax,%eax
80105487:	78 77                	js     80105500 <sys_chdir+0xa0>
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	ff 75 f4             	push   -0xc(%ebp)
8010548f:	e8 3c cc ff ff       	call   801020d0 <namei>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	89 c3                	mov    %eax,%ebx
80105499:	85 c0                	test   %eax,%eax
8010549b:	74 63                	je     80105500 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	50                   	push   %eax
801054a1:	e8 4a c3 ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054ae:	75 30                	jne    801054e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	53                   	push   %ebx
801054b4:	e8 17 c4 ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
801054b9:	58                   	pop    %eax
801054ba:	ff 76 68             	push   0x68(%esi)
801054bd:	e8 5e c4 ff ff       	call   80101920 <iput>
  end_op();
801054c2:	e8 39 d9 ff ff       	call   80102e00 <end_op>
  curproc->cwd = ip;
801054c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	31 c0                	xor    %eax,%eax
}
801054cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d2:	5b                   	pop    %ebx
801054d3:	5e                   	pop    %esi
801054d4:	5d                   	pop    %ebp
801054d5:	c3                   	ret
801054d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054dd:	00 
801054de:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 97 c5 ff ff       	call   80101a80 <iunlockput>
    end_op();
801054e9:	e8 12 d9 ff ff       	call   80102e00 <end_op>
    return -1;
801054ee:	83 c4 10             	add    $0x10,%esp
    return -1;
801054f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f6:	eb d7                	jmp    801054cf <sys_chdir+0x6f>
801054f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054ff:	00 
    end_op();
80105500:	e8 fb d8 ff ff       	call   80102e00 <end_op>
    return -1;
80105505:	eb ea                	jmp    801054f1 <sys_chdir+0x91>
80105507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010550e:	00 
8010550f:	90                   	nop

80105510 <sys_exec>:

int
sys_exec(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105515:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010551b:	53                   	push   %ebx
8010551c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105522:	50                   	push   %eax
80105523:	6a 00                	push   $0x0
80105525:	e8 36 f5 ff ff       	call   80104a60 <argstr>
8010552a:	83 c4 10             	add    $0x10,%esp
8010552d:	85 c0                	test   %eax,%eax
8010552f:	0f 88 87 00 00 00    	js     801055bc <sys_exec+0xac>
80105535:	83 ec 08             	sub    $0x8,%esp
80105538:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010553e:	50                   	push   %eax
8010553f:	6a 01                	push   $0x1
80105541:	e8 5a f4 ff ff       	call   801049a0 <argint>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	78 6f                	js     801055bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010554d:	83 ec 04             	sub    $0x4,%esp
80105550:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105556:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105558:	68 80 00 00 00       	push   $0x80
8010555d:	6a 00                	push   $0x0
8010555f:	56                   	push   %esi
80105560:	e8 8b f1 ff ff       	call   801046f0 <memset>
80105565:	83 c4 10             	add    $0x10,%esp
80105568:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010556f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105579:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105580:	50                   	push   %eax
80105581:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105587:	01 f8                	add    %edi,%eax
80105589:	50                   	push   %eax
8010558a:	e8 81 f3 ff ff       	call   80104910 <fetchint>
8010558f:	83 c4 10             	add    $0x10,%esp
80105592:	85 c0                	test   %eax,%eax
80105594:	78 26                	js     801055bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105596:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010559c:	85 c0                	test   %eax,%eax
8010559e:	74 30                	je     801055d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055a0:	83 ec 08             	sub    $0x8,%esp
801055a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055a6:	52                   	push   %edx
801055a7:	50                   	push   %eax
801055a8:	e8 a3 f3 ff ff       	call   80104950 <fetchstr>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	78 08                	js     801055bc <sys_exec+0xac>
  for(i=0;; i++){
801055b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055b7:	83 fb 20             	cmp    $0x20,%ebx
801055ba:	75 b4                	jne    80105570 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055c4:	5b                   	pop    %ebx
801055c5:	5e                   	pop    %esi
801055c6:	5f                   	pop    %edi
801055c7:	5d                   	pop    %ebp
801055c8:	c3                   	ret
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801055d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055d7:	00 00 00 00 
  return exec(path, argv);
801055db:	83 ec 08             	sub    $0x8,%esp
801055de:	56                   	push   %esi
801055df:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801055e5:	e8 16 b5 ff ff       	call   80100b00 <exec>
801055ea:	83 c4 10             	add    $0x10,%esp
}
801055ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f0:	5b                   	pop    %ebx
801055f1:	5e                   	pop    %esi
801055f2:	5f                   	pop    %edi
801055f3:	5d                   	pop    %ebp
801055f4:	c3                   	ret
801055f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055fc:	00 
801055fd:	8d 76 00             	lea    0x0(%esi),%esi

80105600 <sys_pipe>:

int
sys_pipe(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	57                   	push   %edi
80105604:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105605:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105608:	53                   	push   %ebx
80105609:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010560c:	6a 08                	push   $0x8
8010560e:	50                   	push   %eax
8010560f:	6a 00                	push   $0x0
80105611:	e8 da f3 ff ff       	call   801049f0 <argptr>
80105616:	83 c4 10             	add    $0x10,%esp
80105619:	85 c0                	test   %eax,%eax
8010561b:	0f 88 8b 00 00 00    	js     801056ac <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105621:	83 ec 08             	sub    $0x8,%esp
80105624:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105627:	50                   	push   %eax
80105628:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010562b:	50                   	push   %eax
8010562c:	e8 2f de ff ff       	call   80103460 <pipealloc>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	85 c0                	test   %eax,%eax
80105636:	78 74                	js     801056ac <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105638:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010563b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010563d:	e8 6e e3 ff ff       	call   801039b0 <myproc>
    if(curproc->ofile[fd] == 0){
80105642:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105646:	85 f6                	test   %esi,%esi
80105648:	74 16                	je     80105660 <sys_pipe+0x60>
8010564a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105650:	83 c3 01             	add    $0x1,%ebx
80105653:	83 fb 10             	cmp    $0x10,%ebx
80105656:	74 3d                	je     80105695 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105658:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010565c:	85 f6                	test   %esi,%esi
8010565e:	75 f0                	jne    80105650 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105660:	8d 73 08             	lea    0x8(%ebx),%esi
80105663:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010566a:	e8 41 e3 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010566f:	31 d2                	xor    %edx,%edx
80105671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105678:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010567c:	85 c9                	test   %ecx,%ecx
8010567e:	74 38                	je     801056b8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105680:	83 c2 01             	add    $0x1,%edx
80105683:	83 fa 10             	cmp    $0x10,%edx
80105686:	75 f0                	jne    80105678 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105688:	e8 23 e3 ff ff       	call   801039b0 <myproc>
8010568d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105694:	00 
    fileclose(rf);
80105695:	83 ec 0c             	sub    $0xc,%esp
80105698:	ff 75 e0             	push   -0x20(%ebp)
8010569b:	e8 c0 b8 ff ff       	call   80100f60 <fileclose>
    fileclose(wf);
801056a0:	58                   	pop    %eax
801056a1:	ff 75 e4             	push   -0x1c(%ebp)
801056a4:	e8 b7 b8 ff ff       	call   80100f60 <fileclose>
    return -1;
801056a9:	83 c4 10             	add    $0x10,%esp
    return -1;
801056ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b1:	eb 16                	jmp    801056c9 <sys_pipe+0xc9>
801056b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801056b8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056bf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056c4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056c7:	31 c0                	xor    %eax,%eax
}
801056c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056cc:	5b                   	pop    %ebx
801056cd:	5e                   	pop    %esi
801056ce:	5f                   	pop    %edi
801056cf:	5d                   	pop    %ebp
801056d0:	c3                   	ret
801056d1:	66 90                	xchg   %ax,%ax
801056d3:	66 90                	xchg   %ax,%ax
801056d5:	66 90                	xchg   %ax,%ax
801056d7:	66 90                	xchg   %ax,%ax
801056d9:	66 90                	xchg   %ax,%ax
801056db:	66 90                	xchg   %ax,%ax
801056dd:	66 90                	xchg   %ax,%ax
801056df:	90                   	nop

801056e0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801056e0:	e9 6b e4 ff ff       	jmp    80103b50 <fork>
801056e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ec:	00 
801056ed:	8d 76 00             	lea    0x0(%esi),%esi

801056f0 <sys_exit>:
}

int
sys_exit(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056f6:	e8 c5 e6 ff ff       	call   80103dc0 <exit>
  return 0;  // not reached
}
801056fb:	31 c0                	xor    %eax,%eax
801056fd:	c9                   	leave
801056fe:	c3                   	ret
801056ff:	90                   	nop

80105700 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105700:	e9 eb e7 ff ff       	jmp    80103ef0 <wait>
80105705:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010570c:	00 
8010570d:	8d 76 00             	lea    0x0(%esi),%esi

80105710 <sys_kill>:
}

int
sys_kill(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105716:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105719:	50                   	push   %eax
8010571a:	6a 00                	push   $0x0
8010571c:	e8 7f f2 ff ff       	call   801049a0 <argint>
80105721:	83 c4 10             	add    $0x10,%esp
80105724:	85 c0                	test   %eax,%eax
80105726:	78 18                	js     80105740 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	ff 75 f4             	push   -0xc(%ebp)
8010572e:	e8 5d ea ff ff       	call   80104190 <kill>
80105733:	83 c4 10             	add    $0x10,%esp
}
80105736:	c9                   	leave
80105737:	c3                   	ret
80105738:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010573f:	00 
80105740:	c9                   	leave
    return -1;
80105741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105746:	c3                   	ret
80105747:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010574e:	00 
8010574f:	90                   	nop

80105750 <sys_getpid>:

int
sys_getpid(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105756:	e8 55 e2 ff ff       	call   801039b0 <myproc>
8010575b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010575e:	c9                   	leave
8010575f:	c3                   	ret

80105760 <sys_sbrk>:

int
sys_sbrk(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105764:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105767:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010576a:	50                   	push   %eax
8010576b:	6a 00                	push   $0x0
8010576d:	e8 2e f2 ff ff       	call   801049a0 <argint>
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	85 c0                	test   %eax,%eax
80105777:	78 27                	js     801057a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105779:	e8 32 e2 ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
8010577e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105781:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105783:	ff 75 f4             	push   -0xc(%ebp)
80105786:	e8 45 e3 ff ff       	call   80103ad0 <growproc>
8010578b:	83 c4 10             	add    $0x10,%esp
8010578e:	85 c0                	test   %eax,%eax
80105790:	78 0e                	js     801057a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105792:	89 d8                	mov    %ebx,%eax
80105794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105797:	c9                   	leave
80105798:	c3                   	ret
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057a5:	eb eb                	jmp    80105792 <sys_sbrk+0x32>
801057a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057ae:	00 
801057af:	90                   	nop

801057b0 <sys_sleep>:

int
sys_sleep(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ba:	50                   	push   %eax
801057bb:	6a 00                	push   $0x0
801057bd:	e8 de f1 ff ff       	call   801049a0 <argint>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	85 c0                	test   %eax,%eax
801057c7:	78 64                	js     8010582d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	68 80 3c 11 80       	push   $0x80113c80
801057d1:	e8 1a ee ff ff       	call   801045f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801057d9:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	85 d2                	test   %edx,%edx
801057e4:	75 2b                	jne    80105811 <sys_sleep+0x61>
801057e6:	eb 58                	jmp    80105840 <sys_sleep+0x90>
801057e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057ef:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	68 80 3c 11 80       	push   $0x80113c80
801057f8:	68 60 3c 11 80       	push   $0x80113c60
801057fd:	e8 6e e8 ff ff       	call   80104070 <sleep>
  while(ticks - ticks0 < n){
80105802:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	29 d8                	sub    %ebx,%eax
8010580c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010580f:	73 2f                	jae    80105840 <sys_sleep+0x90>
    if(myproc()->killed){
80105811:	e8 9a e1 ff ff       	call   801039b0 <myproc>
80105816:	8b 40 24             	mov    0x24(%eax),%eax
80105819:	85 c0                	test   %eax,%eax
8010581b:	74 d3                	je     801057f0 <sys_sleep+0x40>
      release(&tickslock);
8010581d:	83 ec 0c             	sub    $0xc,%esp
80105820:	68 80 3c 11 80       	push   $0x80113c80
80105825:	e8 66 ed ff ff       	call   80104590 <release>
      return -1;
8010582a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010582d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105835:	c9                   	leave
80105836:	c3                   	ret
80105837:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010583e:	00 
8010583f:	90                   	nop
  release(&tickslock);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	68 80 3c 11 80       	push   $0x80113c80
80105848:	e8 43 ed ff ff       	call   80104590 <release>
}
8010584d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105850:	83 c4 10             	add    $0x10,%esp
80105853:	31 c0                	xor    %eax,%eax
}
80105855:	c9                   	leave
80105856:	c3                   	ret
80105857:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010585e:	00 
8010585f:	90                   	nop

80105860 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	53                   	push   %ebx
80105864:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105867:	68 80 3c 11 80       	push   $0x80113c80
8010586c:	e8 7f ed ff ff       	call   801045f0 <acquire>
  xticks = ticks;
80105871:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
80105877:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
8010587e:	e8 0d ed ff ff       	call   80104590 <release>
  return xticks;
}
80105883:	89 d8                	mov    %ebx,%eax
80105885:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105888:	c9                   	leave
80105889:	c3                   	ret

8010588a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010588a:	1e                   	push   %ds
  pushl %es
8010588b:	06                   	push   %es
  pushl %fs
8010588c:	0f a0                	push   %fs
  pushl %gs
8010588e:	0f a8                	push   %gs
  pushal
80105890:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105891:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105895:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105897:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105899:	54                   	push   %esp
  call trap
8010589a:	e8 c1 00 00 00       	call   80105960 <trap>
  addl $4, %esp
8010589f:	83 c4 04             	add    $0x4,%esp

801058a2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058a2:	61                   	popa
  popl %gs
801058a3:	0f a9                	pop    %gs
  popl %fs
801058a5:	0f a1                	pop    %fs
  popl %es
801058a7:	07                   	pop    %es
  popl %ds
801058a8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058a9:	83 c4 08             	add    $0x8,%esp
  iret
801058ac:	cf                   	iret
801058ad:	66 90                	xchg   %ax,%ax
801058af:	90                   	nop

801058b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058b1:	31 c0                	xor    %eax,%eax
{
801058b3:	89 e5                	mov    %esp,%ebp
801058b5:	83 ec 08             	sub    $0x8,%esp
801058b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058bf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058c0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801058c7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
801058ce:	08 00 00 8e 
801058d2:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
801058d9:	80 
801058da:	c1 ea 10             	shr    $0x10,%edx
801058dd:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
801058e4:	80 
  for(i = 0; i < 256; i++)
801058e5:	83 c0 01             	add    $0x1,%eax
801058e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801058ed:	75 d1                	jne    801058c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801058ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058f2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801058f7:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
801058fe:	00 00 ef 
  initlock(&tickslock, "time");
80105901:	68 c7 75 10 80       	push   $0x801075c7
80105906:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010590b:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105911:	c1 e8 10             	shr    $0x10,%eax
80105914:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
8010591a:	e8 e1 ea ff ff       	call   80104400 <initlock>
}
8010591f:	83 c4 10             	add    $0x10,%esp
80105922:	c9                   	leave
80105923:	c3                   	ret
80105924:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010592b:	00 
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <idtinit>:

void
idtinit(void)
{
80105930:	55                   	push   %ebp
  pd[0] = size-1;
80105931:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105936:	89 e5                	mov    %esp,%ebp
80105938:	83 ec 10             	sub    $0x10,%esp
8010593b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010593f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105944:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105948:	c1 e8 10             	shr    $0x10,%eax
8010594b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010594f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105952:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105955:	c9                   	leave
80105956:	c3                   	ret
80105957:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010595e:	00 
8010595f:	90                   	nop

80105960 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
80105965:	53                   	push   %ebx
80105966:	83 ec 1c             	sub    $0x1c,%esp
80105969:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010596c:	8b 43 30             	mov    0x30(%ebx),%eax
8010596f:	83 f8 40             	cmp    $0x40,%eax
80105972:	0f 84 58 01 00 00    	je     80105ad0 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105978:	83 e8 20             	sub    $0x20,%eax
8010597b:	83 f8 1f             	cmp    $0x1f,%eax
8010597e:	0f 87 7c 00 00 00    	ja     80105a00 <trap+0xa0>
80105984:	ff 24 85 18 7b 10 80 	jmp    *-0x7fef84e8(,%eax,4)
8010598b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105990:	e8 eb c8 ff ff       	call   80102280 <ideintr>
    lapiceoi();
80105995:	e8 a6 cf ff ff       	call   80102940 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010599a:	e8 11 e0 ff ff       	call   801039b0 <myproc>
8010599f:	85 c0                	test   %eax,%eax
801059a1:	74 1a                	je     801059bd <trap+0x5d>
801059a3:	e8 08 e0 ff ff       	call   801039b0 <myproc>
801059a8:	8b 50 24             	mov    0x24(%eax),%edx
801059ab:	85 d2                	test   %edx,%edx
801059ad:	74 0e                	je     801059bd <trap+0x5d>
801059af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059b3:	f7 d0                	not    %eax
801059b5:	a8 03                	test   $0x3,%al
801059b7:	0f 84 db 01 00 00    	je     80105b98 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059bd:	e8 ee df ff ff       	call   801039b0 <myproc>
801059c2:	85 c0                	test   %eax,%eax
801059c4:	74 0f                	je     801059d5 <trap+0x75>
801059c6:	e8 e5 df ff ff       	call   801039b0 <myproc>
801059cb:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059cf:	0f 84 ab 00 00 00    	je     80105a80 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d5:	e8 d6 df ff ff       	call   801039b0 <myproc>
801059da:	85 c0                	test   %eax,%eax
801059dc:	74 1a                	je     801059f8 <trap+0x98>
801059de:	e8 cd df ff ff       	call   801039b0 <myproc>
801059e3:	8b 40 24             	mov    0x24(%eax),%eax
801059e6:	85 c0                	test   %eax,%eax
801059e8:	74 0e                	je     801059f8 <trap+0x98>
801059ea:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059ee:	f7 d0                	not    %eax
801059f0:	a8 03                	test   $0x3,%al
801059f2:	0f 84 05 01 00 00    	je     80105afd <trap+0x19d>
    exit();
}
801059f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059fb:	5b                   	pop    %ebx
801059fc:	5e                   	pop    %esi
801059fd:	5f                   	pop    %edi
801059fe:	5d                   	pop    %ebp
801059ff:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a00:	e8 ab df ff ff       	call   801039b0 <myproc>
80105a05:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a08:	85 c0                	test   %eax,%eax
80105a0a:	0f 84 a2 01 00 00    	je     80105bb2 <trap+0x252>
80105a10:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a14:	0f 84 98 01 00 00    	je     80105bb2 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a1a:	0f 20 d1             	mov    %cr2,%ecx
80105a1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a20:	e8 6b df ff ff       	call   80103990 <cpuid>
80105a25:	8b 73 30             	mov    0x30(%ebx),%esi
80105a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a2b:	8b 43 34             	mov    0x34(%ebx),%eax
80105a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a31:	e8 7a df ff ff       	call   801039b0 <myproc>
80105a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a39:	e8 72 df ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a41:	51                   	push   %ecx
80105a42:	57                   	push   %edi
80105a43:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a46:	52                   	push   %edx
80105a47:	ff 75 e4             	push   -0x1c(%ebp)
80105a4a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a4b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a4e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a51:	56                   	push   %esi
80105a52:	ff 70 10             	push   0x10(%eax)
80105a55:	68 18 78 10 80       	push   $0x80107818
80105a5a:	e8 51 ac ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105a5f:	83 c4 20             	add    $0x20,%esp
80105a62:	e8 49 df ff ff       	call   801039b0 <myproc>
80105a67:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a6e:	e8 3d df ff ff       	call   801039b0 <myproc>
80105a73:	85 c0                	test   %eax,%eax
80105a75:	0f 85 28 ff ff ff    	jne    801059a3 <trap+0x43>
80105a7b:	e9 3d ff ff ff       	jmp    801059bd <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105a80:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105a84:	0f 85 4b ff ff ff    	jne    801059d5 <trap+0x75>
    yield();
80105a8a:	e8 91 e5 ff ff       	call   80104020 <yield>
80105a8f:	e9 41 ff ff ff       	jmp    801059d5 <trap+0x75>
80105a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a98:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a9b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105a9f:	e8 ec de ff ff       	call   80103990 <cpuid>
80105aa4:	57                   	push   %edi
80105aa5:	56                   	push   %esi
80105aa6:	50                   	push   %eax
80105aa7:	68 c0 77 10 80       	push   $0x801077c0
80105aac:	e8 ff ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105ab1:	e8 8a ce ff ff       	call   80102940 <lapiceoi>
    break;
80105ab6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ab9:	e8 f2 de ff ff       	call   801039b0 <myproc>
80105abe:	85 c0                	test   %eax,%eax
80105ac0:	0f 85 dd fe ff ff    	jne    801059a3 <trap+0x43>
80105ac6:	e9 f2 fe ff ff       	jmp    801059bd <trap+0x5d>
80105acb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ad0:	e8 db de ff ff       	call   801039b0 <myproc>
80105ad5:	8b 70 24             	mov    0x24(%eax),%esi
80105ad8:	85 f6                	test   %esi,%esi
80105ada:	0f 85 c8 00 00 00    	jne    80105ba8 <trap+0x248>
    myproc()->tf = tf;
80105ae0:	e8 cb de ff ff       	call   801039b0 <myproc>
80105ae5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105ae8:	e8 f3 ef ff ff       	call   80104ae0 <syscall>
    if(myproc()->killed)
80105aed:	e8 be de ff ff       	call   801039b0 <myproc>
80105af2:	8b 48 24             	mov    0x24(%eax),%ecx
80105af5:	85 c9                	test   %ecx,%ecx
80105af7:	0f 84 fb fe ff ff    	je     801059f8 <trap+0x98>
}
80105afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b00:	5b                   	pop    %ebx
80105b01:	5e                   	pop    %esi
80105b02:	5f                   	pop    %edi
80105b03:	5d                   	pop    %ebp
      exit();
80105b04:	e9 b7 e2 ff ff       	jmp    80103dc0 <exit>
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105b10:	e8 4b 02 00 00       	call   80105d60 <uartintr>
    lapiceoi();
80105b15:	e8 26 ce ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b1a:	e8 91 de ff ff       	call   801039b0 <myproc>
80105b1f:	85 c0                	test   %eax,%eax
80105b21:	0f 85 7c fe ff ff    	jne    801059a3 <trap+0x43>
80105b27:	e9 91 fe ff ff       	jmp    801059bd <trap+0x5d>
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b30:	e8 db cc ff ff       	call   80102810 <kbdintr>
    lapiceoi();
80105b35:	e8 06 ce ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b3a:	e8 71 de ff ff       	call   801039b0 <myproc>
80105b3f:	85 c0                	test   %eax,%eax
80105b41:	0f 85 5c fe ff ff    	jne    801059a3 <trap+0x43>
80105b47:	e9 71 fe ff ff       	jmp    801059bd <trap+0x5d>
80105b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105b50:	e8 3b de ff ff       	call   80103990 <cpuid>
80105b55:	85 c0                	test   %eax,%eax
80105b57:	0f 85 38 fe ff ff    	jne    80105995 <trap+0x35>
      acquire(&tickslock);
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	68 80 3c 11 80       	push   $0x80113c80
80105b65:	e8 86 ea ff ff       	call   801045f0 <acquire>
      ticks++;
80105b6a:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105b71:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105b78:	e8 b3 e5 ff ff       	call   80104130 <wakeup>
      release(&tickslock);
80105b7d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105b84:	e8 07 ea ff ff       	call   80104590 <release>
80105b89:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105b8c:	e9 04 fe ff ff       	jmp    80105995 <trap+0x35>
80105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105b98:	e8 23 e2 ff ff       	call   80103dc0 <exit>
80105b9d:	e9 1b fe ff ff       	jmp    801059bd <trap+0x5d>
80105ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ba8:	e8 13 e2 ff ff       	call   80103dc0 <exit>
80105bad:	e9 2e ff ff ff       	jmp    80105ae0 <trap+0x180>
80105bb2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bb5:	e8 d6 dd ff ff       	call   80103990 <cpuid>
80105bba:	83 ec 0c             	sub    $0xc,%esp
80105bbd:	56                   	push   %esi
80105bbe:	57                   	push   %edi
80105bbf:	50                   	push   %eax
80105bc0:	ff 73 30             	push   0x30(%ebx)
80105bc3:	68 e4 77 10 80       	push   $0x801077e4
80105bc8:	e8 e3 aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105bcd:	83 c4 14             	add    $0x14,%esp
80105bd0:	68 cc 75 10 80       	push   $0x801075cc
80105bd5:	e8 a6 a7 ff ff       	call   80100380 <panic>
80105bda:	66 90                	xchg   %ax,%ax
80105bdc:	66 90                	xchg   %ax,%ax
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105be0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105be5:	85 c0                	test   %eax,%eax
80105be7:	74 17                	je     80105c00 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105be9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105bee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105bef:	a8 01                	test   $0x1,%al
80105bf1:	74 0d                	je     80105c00 <uartgetc+0x20>
80105bf3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bf8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105bf9:	0f b6 c0             	movzbl %al,%eax
80105bfc:	c3                   	ret
80105bfd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c05:	c3                   	ret
80105c06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c0d:	00 
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <uartinit>:
{
80105c10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c11:	31 c9                	xor    %ecx,%ecx
80105c13:	89 c8                	mov    %ecx,%eax
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	57                   	push   %edi
80105c18:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c1d:	56                   	push   %esi
80105c1e:	89 fa                	mov    %edi,%edx
80105c20:	53                   	push   %ebx
80105c21:	83 ec 1c             	sub    $0x1c,%esp
80105c24:	ee                   	out    %al,(%dx)
80105c25:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c2f:	89 f2                	mov    %esi,%edx
80105c31:	ee                   	out    %al,(%dx)
80105c32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c3c:	ee                   	out    %al,(%dx)
80105c3d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c42:	89 c8                	mov    %ecx,%eax
80105c44:	89 da                	mov    %ebx,%edx
80105c46:	ee                   	out    %al,(%dx)
80105c47:	b8 03 00 00 00       	mov    $0x3,%eax
80105c4c:	89 f2                	mov    %esi,%edx
80105c4e:	ee                   	out    %al,(%dx)
80105c4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c54:	89 c8                	mov    %ecx,%eax
80105c56:	ee                   	out    %al,(%dx)
80105c57:	b8 01 00 00 00       	mov    $0x1,%eax
80105c5c:	89 da                	mov    %ebx,%edx
80105c5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c65:	3c ff                	cmp    $0xff,%al
80105c67:	0f 84 7c 00 00 00    	je     80105ce9 <uartinit+0xd9>
  uart = 1;
80105c6d:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105c74:	00 00 00 
80105c77:	89 fa                	mov    %edi,%edx
80105c79:	ec                   	in     (%dx),%al
80105c7a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c7f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c80:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105c83:	bf d1 75 10 80       	mov    $0x801075d1,%edi
80105c88:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105c8d:	6a 00                	push   $0x0
80105c8f:	6a 04                	push   $0x4
80105c91:	e8 1a c8 ff ff       	call   801024b0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105c96:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105ca0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	74 32                	je     80105cdb <uartinit+0xcb>
80105ca9:	89 f2                	mov    %esi,%edx
80105cab:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cac:	a8 20                	test   $0x20,%al
80105cae:	75 21                	jne    80105cd1 <uartinit+0xc1>
80105cb0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105cb5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	6a 0a                	push   $0xa
80105cbd:	e8 9e cc ff ff       	call   80102960 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cc2:	83 c4 10             	add    $0x10,%esp
80105cc5:	83 eb 01             	sub    $0x1,%ebx
80105cc8:	74 07                	je     80105cd1 <uartinit+0xc1>
80105cca:	89 f2                	mov    %esi,%edx
80105ccc:	ec                   	in     (%dx),%al
80105ccd:	a8 20                	test   $0x20,%al
80105ccf:	74 e7                	je     80105cb8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cd1:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cd6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105cda:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105cdb:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105cdf:	83 c7 01             	add    $0x1,%edi
80105ce2:	88 45 e7             	mov    %al,-0x19(%ebp)
80105ce5:	84 c0                	test   %al,%al
80105ce7:	75 b7                	jne    80105ca0 <uartinit+0x90>
}
80105ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cec:	5b                   	pop    %ebx
80105ced:	5e                   	pop    %esi
80105cee:	5f                   	pop    %edi
80105cef:	5d                   	pop    %ebp
80105cf0:	c3                   	ret
80105cf1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cf8:	00 
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d00 <uartputc>:
  if(!uart)
80105d00:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105d05:	85 c0                	test   %eax,%eax
80105d07:	74 4f                	je     80105d58 <uartputc+0x58>
{
80105d09:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d0a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d0f:	89 e5                	mov    %esp,%ebp
80105d11:	56                   	push   %esi
80105d12:	53                   	push   %ebx
80105d13:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d14:	a8 20                	test   $0x20,%al
80105d16:	75 29                	jne    80105d41 <uartputc+0x41>
80105d18:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105d28:	83 ec 0c             	sub    $0xc,%esp
80105d2b:	6a 0a                	push   $0xa
80105d2d:	e8 2e cc ff ff       	call   80102960 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	83 eb 01             	sub    $0x1,%ebx
80105d38:	74 07                	je     80105d41 <uartputc+0x41>
80105d3a:	89 f2                	mov    %esi,%edx
80105d3c:	ec                   	in     (%dx),%al
80105d3d:	a8 20                	test   $0x20,%al
80105d3f:	74 e7                	je     80105d28 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d41:	8b 45 08             	mov    0x8(%ebp),%eax
80105d44:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d49:	ee                   	out    %al,(%dx)
}
80105d4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d4d:	5b                   	pop    %ebx
80105d4e:	5e                   	pop    %esi
80105d4f:	5d                   	pop    %ebp
80105d50:	c3                   	ret
80105d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d58:	c3                   	ret
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <uartintr>:

void
uartintr(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d66:	68 e0 5b 10 80       	push   $0x80105be0
80105d6b:	e8 30 ab ff ff       	call   801008a0 <consoleintr>
}
80105d70:	83 c4 10             	add    $0x10,%esp
80105d73:	c9                   	leave
80105d74:	c3                   	ret

80105d75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $0
80105d77:	6a 00                	push   $0x0
  jmp alltraps
80105d79:	e9 0c fb ff ff       	jmp    8010588a <alltraps>

80105d7e <vector1>:
.globl vector1
vector1:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $1
80105d80:	6a 01                	push   $0x1
  jmp alltraps
80105d82:	e9 03 fb ff ff       	jmp    8010588a <alltraps>

80105d87 <vector2>:
.globl vector2
vector2:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $2
80105d89:	6a 02                	push   $0x2
  jmp alltraps
80105d8b:	e9 fa fa ff ff       	jmp    8010588a <alltraps>

80105d90 <vector3>:
.globl vector3
vector3:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $3
80105d92:	6a 03                	push   $0x3
  jmp alltraps
80105d94:	e9 f1 fa ff ff       	jmp    8010588a <alltraps>

80105d99 <vector4>:
.globl vector4
vector4:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $4
80105d9b:	6a 04                	push   $0x4
  jmp alltraps
80105d9d:	e9 e8 fa ff ff       	jmp    8010588a <alltraps>

80105da2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $5
80105da4:	6a 05                	push   $0x5
  jmp alltraps
80105da6:	e9 df fa ff ff       	jmp    8010588a <alltraps>

80105dab <vector6>:
.globl vector6
vector6:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $6
80105dad:	6a 06                	push   $0x6
  jmp alltraps
80105daf:	e9 d6 fa ff ff       	jmp    8010588a <alltraps>

80105db4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $7
80105db6:	6a 07                	push   $0x7
  jmp alltraps
80105db8:	e9 cd fa ff ff       	jmp    8010588a <alltraps>

80105dbd <vector8>:
.globl vector8
vector8:
  pushl $8
80105dbd:	6a 08                	push   $0x8
  jmp alltraps
80105dbf:	e9 c6 fa ff ff       	jmp    8010588a <alltraps>

80105dc4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $9
80105dc6:	6a 09                	push   $0x9
  jmp alltraps
80105dc8:	e9 bd fa ff ff       	jmp    8010588a <alltraps>

80105dcd <vector10>:
.globl vector10
vector10:
  pushl $10
80105dcd:	6a 0a                	push   $0xa
  jmp alltraps
80105dcf:	e9 b6 fa ff ff       	jmp    8010588a <alltraps>

80105dd4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105dd4:	6a 0b                	push   $0xb
  jmp alltraps
80105dd6:	e9 af fa ff ff       	jmp    8010588a <alltraps>

80105ddb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ddb:	6a 0c                	push   $0xc
  jmp alltraps
80105ddd:	e9 a8 fa ff ff       	jmp    8010588a <alltraps>

80105de2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105de2:	6a 0d                	push   $0xd
  jmp alltraps
80105de4:	e9 a1 fa ff ff       	jmp    8010588a <alltraps>

80105de9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105de9:	6a 0e                	push   $0xe
  jmp alltraps
80105deb:	e9 9a fa ff ff       	jmp    8010588a <alltraps>

80105df0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105df0:	6a 00                	push   $0x0
  pushl $15
80105df2:	6a 0f                	push   $0xf
  jmp alltraps
80105df4:	e9 91 fa ff ff       	jmp    8010588a <alltraps>

80105df9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105df9:	6a 00                	push   $0x0
  pushl $16
80105dfb:	6a 10                	push   $0x10
  jmp alltraps
80105dfd:	e9 88 fa ff ff       	jmp    8010588a <alltraps>

80105e02 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e02:	6a 11                	push   $0x11
  jmp alltraps
80105e04:	e9 81 fa ff ff       	jmp    8010588a <alltraps>

80105e09 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $18
80105e0b:	6a 12                	push   $0x12
  jmp alltraps
80105e0d:	e9 78 fa ff ff       	jmp    8010588a <alltraps>

80105e12 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $19
80105e14:	6a 13                	push   $0x13
  jmp alltraps
80105e16:	e9 6f fa ff ff       	jmp    8010588a <alltraps>

80105e1b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $20
80105e1d:	6a 14                	push   $0x14
  jmp alltraps
80105e1f:	e9 66 fa ff ff       	jmp    8010588a <alltraps>

80105e24 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $21
80105e26:	6a 15                	push   $0x15
  jmp alltraps
80105e28:	e9 5d fa ff ff       	jmp    8010588a <alltraps>

80105e2d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $22
80105e2f:	6a 16                	push   $0x16
  jmp alltraps
80105e31:	e9 54 fa ff ff       	jmp    8010588a <alltraps>

80105e36 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $23
80105e38:	6a 17                	push   $0x17
  jmp alltraps
80105e3a:	e9 4b fa ff ff       	jmp    8010588a <alltraps>

80105e3f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $24
80105e41:	6a 18                	push   $0x18
  jmp alltraps
80105e43:	e9 42 fa ff ff       	jmp    8010588a <alltraps>

80105e48 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $25
80105e4a:	6a 19                	push   $0x19
  jmp alltraps
80105e4c:	e9 39 fa ff ff       	jmp    8010588a <alltraps>

80105e51 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $26
80105e53:	6a 1a                	push   $0x1a
  jmp alltraps
80105e55:	e9 30 fa ff ff       	jmp    8010588a <alltraps>

80105e5a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $27
80105e5c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e5e:	e9 27 fa ff ff       	jmp    8010588a <alltraps>

80105e63 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $28
80105e65:	6a 1c                	push   $0x1c
  jmp alltraps
80105e67:	e9 1e fa ff ff       	jmp    8010588a <alltraps>

80105e6c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $29
80105e6e:	6a 1d                	push   $0x1d
  jmp alltraps
80105e70:	e9 15 fa ff ff       	jmp    8010588a <alltraps>

80105e75 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $30
80105e77:	6a 1e                	push   $0x1e
  jmp alltraps
80105e79:	e9 0c fa ff ff       	jmp    8010588a <alltraps>

80105e7e <vector31>:
.globl vector31
vector31:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $31
80105e80:	6a 1f                	push   $0x1f
  jmp alltraps
80105e82:	e9 03 fa ff ff       	jmp    8010588a <alltraps>

80105e87 <vector32>:
.globl vector32
vector32:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $32
80105e89:	6a 20                	push   $0x20
  jmp alltraps
80105e8b:	e9 fa f9 ff ff       	jmp    8010588a <alltraps>

80105e90 <vector33>:
.globl vector33
vector33:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $33
80105e92:	6a 21                	push   $0x21
  jmp alltraps
80105e94:	e9 f1 f9 ff ff       	jmp    8010588a <alltraps>

80105e99 <vector34>:
.globl vector34
vector34:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $34
80105e9b:	6a 22                	push   $0x22
  jmp alltraps
80105e9d:	e9 e8 f9 ff ff       	jmp    8010588a <alltraps>

80105ea2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $35
80105ea4:	6a 23                	push   $0x23
  jmp alltraps
80105ea6:	e9 df f9 ff ff       	jmp    8010588a <alltraps>

80105eab <vector36>:
.globl vector36
vector36:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $36
80105ead:	6a 24                	push   $0x24
  jmp alltraps
80105eaf:	e9 d6 f9 ff ff       	jmp    8010588a <alltraps>

80105eb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $37
80105eb6:	6a 25                	push   $0x25
  jmp alltraps
80105eb8:	e9 cd f9 ff ff       	jmp    8010588a <alltraps>

80105ebd <vector38>:
.globl vector38
vector38:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $38
80105ebf:	6a 26                	push   $0x26
  jmp alltraps
80105ec1:	e9 c4 f9 ff ff       	jmp    8010588a <alltraps>

80105ec6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $39
80105ec8:	6a 27                	push   $0x27
  jmp alltraps
80105eca:	e9 bb f9 ff ff       	jmp    8010588a <alltraps>

80105ecf <vector40>:
.globl vector40
vector40:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $40
80105ed1:	6a 28                	push   $0x28
  jmp alltraps
80105ed3:	e9 b2 f9 ff ff       	jmp    8010588a <alltraps>

80105ed8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $41
80105eda:	6a 29                	push   $0x29
  jmp alltraps
80105edc:	e9 a9 f9 ff ff       	jmp    8010588a <alltraps>

80105ee1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $42
80105ee3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ee5:	e9 a0 f9 ff ff       	jmp    8010588a <alltraps>

80105eea <vector43>:
.globl vector43
vector43:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $43
80105eec:	6a 2b                	push   $0x2b
  jmp alltraps
80105eee:	e9 97 f9 ff ff       	jmp    8010588a <alltraps>

80105ef3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $44
80105ef5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ef7:	e9 8e f9 ff ff       	jmp    8010588a <alltraps>

80105efc <vector45>:
.globl vector45
vector45:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $45
80105efe:	6a 2d                	push   $0x2d
  jmp alltraps
80105f00:	e9 85 f9 ff ff       	jmp    8010588a <alltraps>

80105f05 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $46
80105f07:	6a 2e                	push   $0x2e
  jmp alltraps
80105f09:	e9 7c f9 ff ff       	jmp    8010588a <alltraps>

80105f0e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $47
80105f10:	6a 2f                	push   $0x2f
  jmp alltraps
80105f12:	e9 73 f9 ff ff       	jmp    8010588a <alltraps>

80105f17 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $48
80105f19:	6a 30                	push   $0x30
  jmp alltraps
80105f1b:	e9 6a f9 ff ff       	jmp    8010588a <alltraps>

80105f20 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $49
80105f22:	6a 31                	push   $0x31
  jmp alltraps
80105f24:	e9 61 f9 ff ff       	jmp    8010588a <alltraps>

80105f29 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $50
80105f2b:	6a 32                	push   $0x32
  jmp alltraps
80105f2d:	e9 58 f9 ff ff       	jmp    8010588a <alltraps>

80105f32 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $51
80105f34:	6a 33                	push   $0x33
  jmp alltraps
80105f36:	e9 4f f9 ff ff       	jmp    8010588a <alltraps>

80105f3b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $52
80105f3d:	6a 34                	push   $0x34
  jmp alltraps
80105f3f:	e9 46 f9 ff ff       	jmp    8010588a <alltraps>

80105f44 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $53
80105f46:	6a 35                	push   $0x35
  jmp alltraps
80105f48:	e9 3d f9 ff ff       	jmp    8010588a <alltraps>

80105f4d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $54
80105f4f:	6a 36                	push   $0x36
  jmp alltraps
80105f51:	e9 34 f9 ff ff       	jmp    8010588a <alltraps>

80105f56 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $55
80105f58:	6a 37                	push   $0x37
  jmp alltraps
80105f5a:	e9 2b f9 ff ff       	jmp    8010588a <alltraps>

80105f5f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $56
80105f61:	6a 38                	push   $0x38
  jmp alltraps
80105f63:	e9 22 f9 ff ff       	jmp    8010588a <alltraps>

80105f68 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $57
80105f6a:	6a 39                	push   $0x39
  jmp alltraps
80105f6c:	e9 19 f9 ff ff       	jmp    8010588a <alltraps>

80105f71 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $58
80105f73:	6a 3a                	push   $0x3a
  jmp alltraps
80105f75:	e9 10 f9 ff ff       	jmp    8010588a <alltraps>

80105f7a <vector59>:
.globl vector59
vector59:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $59
80105f7c:	6a 3b                	push   $0x3b
  jmp alltraps
80105f7e:	e9 07 f9 ff ff       	jmp    8010588a <alltraps>

80105f83 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $60
80105f85:	6a 3c                	push   $0x3c
  jmp alltraps
80105f87:	e9 fe f8 ff ff       	jmp    8010588a <alltraps>

80105f8c <vector61>:
.globl vector61
vector61:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $61
80105f8e:	6a 3d                	push   $0x3d
  jmp alltraps
80105f90:	e9 f5 f8 ff ff       	jmp    8010588a <alltraps>

80105f95 <vector62>:
.globl vector62
vector62:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $62
80105f97:	6a 3e                	push   $0x3e
  jmp alltraps
80105f99:	e9 ec f8 ff ff       	jmp    8010588a <alltraps>

80105f9e <vector63>:
.globl vector63
vector63:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $63
80105fa0:	6a 3f                	push   $0x3f
  jmp alltraps
80105fa2:	e9 e3 f8 ff ff       	jmp    8010588a <alltraps>

80105fa7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $64
80105fa9:	6a 40                	push   $0x40
  jmp alltraps
80105fab:	e9 da f8 ff ff       	jmp    8010588a <alltraps>

80105fb0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $65
80105fb2:	6a 41                	push   $0x41
  jmp alltraps
80105fb4:	e9 d1 f8 ff ff       	jmp    8010588a <alltraps>

80105fb9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $66
80105fbb:	6a 42                	push   $0x42
  jmp alltraps
80105fbd:	e9 c8 f8 ff ff       	jmp    8010588a <alltraps>

80105fc2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $67
80105fc4:	6a 43                	push   $0x43
  jmp alltraps
80105fc6:	e9 bf f8 ff ff       	jmp    8010588a <alltraps>

80105fcb <vector68>:
.globl vector68
vector68:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $68
80105fcd:	6a 44                	push   $0x44
  jmp alltraps
80105fcf:	e9 b6 f8 ff ff       	jmp    8010588a <alltraps>

80105fd4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $69
80105fd6:	6a 45                	push   $0x45
  jmp alltraps
80105fd8:	e9 ad f8 ff ff       	jmp    8010588a <alltraps>

80105fdd <vector70>:
.globl vector70
vector70:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $70
80105fdf:	6a 46                	push   $0x46
  jmp alltraps
80105fe1:	e9 a4 f8 ff ff       	jmp    8010588a <alltraps>

80105fe6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $71
80105fe8:	6a 47                	push   $0x47
  jmp alltraps
80105fea:	e9 9b f8 ff ff       	jmp    8010588a <alltraps>

80105fef <vector72>:
.globl vector72
vector72:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $72
80105ff1:	6a 48                	push   $0x48
  jmp alltraps
80105ff3:	e9 92 f8 ff ff       	jmp    8010588a <alltraps>

80105ff8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $73
80105ffa:	6a 49                	push   $0x49
  jmp alltraps
80105ffc:	e9 89 f8 ff ff       	jmp    8010588a <alltraps>

80106001 <vector74>:
.globl vector74
vector74:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $74
80106003:	6a 4a                	push   $0x4a
  jmp alltraps
80106005:	e9 80 f8 ff ff       	jmp    8010588a <alltraps>

8010600a <vector75>:
.globl vector75
vector75:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $75
8010600c:	6a 4b                	push   $0x4b
  jmp alltraps
8010600e:	e9 77 f8 ff ff       	jmp    8010588a <alltraps>

80106013 <vector76>:
.globl vector76
vector76:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $76
80106015:	6a 4c                	push   $0x4c
  jmp alltraps
80106017:	e9 6e f8 ff ff       	jmp    8010588a <alltraps>

8010601c <vector77>:
.globl vector77
vector77:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $77
8010601e:	6a 4d                	push   $0x4d
  jmp alltraps
80106020:	e9 65 f8 ff ff       	jmp    8010588a <alltraps>

80106025 <vector78>:
.globl vector78
vector78:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $78
80106027:	6a 4e                	push   $0x4e
  jmp alltraps
80106029:	e9 5c f8 ff ff       	jmp    8010588a <alltraps>

8010602e <vector79>:
.globl vector79
vector79:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $79
80106030:	6a 4f                	push   $0x4f
  jmp alltraps
80106032:	e9 53 f8 ff ff       	jmp    8010588a <alltraps>

80106037 <vector80>:
.globl vector80
vector80:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $80
80106039:	6a 50                	push   $0x50
  jmp alltraps
8010603b:	e9 4a f8 ff ff       	jmp    8010588a <alltraps>

80106040 <vector81>:
.globl vector81
vector81:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $81
80106042:	6a 51                	push   $0x51
  jmp alltraps
80106044:	e9 41 f8 ff ff       	jmp    8010588a <alltraps>

80106049 <vector82>:
.globl vector82
vector82:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $82
8010604b:	6a 52                	push   $0x52
  jmp alltraps
8010604d:	e9 38 f8 ff ff       	jmp    8010588a <alltraps>

80106052 <vector83>:
.globl vector83
vector83:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $83
80106054:	6a 53                	push   $0x53
  jmp alltraps
80106056:	e9 2f f8 ff ff       	jmp    8010588a <alltraps>

8010605b <vector84>:
.globl vector84
vector84:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $84
8010605d:	6a 54                	push   $0x54
  jmp alltraps
8010605f:	e9 26 f8 ff ff       	jmp    8010588a <alltraps>

80106064 <vector85>:
.globl vector85
vector85:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $85
80106066:	6a 55                	push   $0x55
  jmp alltraps
80106068:	e9 1d f8 ff ff       	jmp    8010588a <alltraps>

8010606d <vector86>:
.globl vector86
vector86:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $86
8010606f:	6a 56                	push   $0x56
  jmp alltraps
80106071:	e9 14 f8 ff ff       	jmp    8010588a <alltraps>

80106076 <vector87>:
.globl vector87
vector87:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $87
80106078:	6a 57                	push   $0x57
  jmp alltraps
8010607a:	e9 0b f8 ff ff       	jmp    8010588a <alltraps>

8010607f <vector88>:
.globl vector88
vector88:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $88
80106081:	6a 58                	push   $0x58
  jmp alltraps
80106083:	e9 02 f8 ff ff       	jmp    8010588a <alltraps>

80106088 <vector89>:
.globl vector89
vector89:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $89
8010608a:	6a 59                	push   $0x59
  jmp alltraps
8010608c:	e9 f9 f7 ff ff       	jmp    8010588a <alltraps>

80106091 <vector90>:
.globl vector90
vector90:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $90
80106093:	6a 5a                	push   $0x5a
  jmp alltraps
80106095:	e9 f0 f7 ff ff       	jmp    8010588a <alltraps>

8010609a <vector91>:
.globl vector91
vector91:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $91
8010609c:	6a 5b                	push   $0x5b
  jmp alltraps
8010609e:	e9 e7 f7 ff ff       	jmp    8010588a <alltraps>

801060a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $92
801060a5:	6a 5c                	push   $0x5c
  jmp alltraps
801060a7:	e9 de f7 ff ff       	jmp    8010588a <alltraps>

801060ac <vector93>:
.globl vector93
vector93:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $93
801060ae:	6a 5d                	push   $0x5d
  jmp alltraps
801060b0:	e9 d5 f7 ff ff       	jmp    8010588a <alltraps>

801060b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $94
801060b7:	6a 5e                	push   $0x5e
  jmp alltraps
801060b9:	e9 cc f7 ff ff       	jmp    8010588a <alltraps>

801060be <vector95>:
.globl vector95
vector95:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $95
801060c0:	6a 5f                	push   $0x5f
  jmp alltraps
801060c2:	e9 c3 f7 ff ff       	jmp    8010588a <alltraps>

801060c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $96
801060c9:	6a 60                	push   $0x60
  jmp alltraps
801060cb:	e9 ba f7 ff ff       	jmp    8010588a <alltraps>

801060d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $97
801060d2:	6a 61                	push   $0x61
  jmp alltraps
801060d4:	e9 b1 f7 ff ff       	jmp    8010588a <alltraps>

801060d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $98
801060db:	6a 62                	push   $0x62
  jmp alltraps
801060dd:	e9 a8 f7 ff ff       	jmp    8010588a <alltraps>

801060e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $99
801060e4:	6a 63                	push   $0x63
  jmp alltraps
801060e6:	e9 9f f7 ff ff       	jmp    8010588a <alltraps>

801060eb <vector100>:
.globl vector100
vector100:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $100
801060ed:	6a 64                	push   $0x64
  jmp alltraps
801060ef:	e9 96 f7 ff ff       	jmp    8010588a <alltraps>

801060f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $101
801060f6:	6a 65                	push   $0x65
  jmp alltraps
801060f8:	e9 8d f7 ff ff       	jmp    8010588a <alltraps>

801060fd <vector102>:
.globl vector102
vector102:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $102
801060ff:	6a 66                	push   $0x66
  jmp alltraps
80106101:	e9 84 f7 ff ff       	jmp    8010588a <alltraps>

80106106 <vector103>:
.globl vector103
vector103:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $103
80106108:	6a 67                	push   $0x67
  jmp alltraps
8010610a:	e9 7b f7 ff ff       	jmp    8010588a <alltraps>

8010610f <vector104>:
.globl vector104
vector104:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $104
80106111:	6a 68                	push   $0x68
  jmp alltraps
80106113:	e9 72 f7 ff ff       	jmp    8010588a <alltraps>

80106118 <vector105>:
.globl vector105
vector105:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $105
8010611a:	6a 69                	push   $0x69
  jmp alltraps
8010611c:	e9 69 f7 ff ff       	jmp    8010588a <alltraps>

80106121 <vector106>:
.globl vector106
vector106:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $106
80106123:	6a 6a                	push   $0x6a
  jmp alltraps
80106125:	e9 60 f7 ff ff       	jmp    8010588a <alltraps>

8010612a <vector107>:
.globl vector107
vector107:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $107
8010612c:	6a 6b                	push   $0x6b
  jmp alltraps
8010612e:	e9 57 f7 ff ff       	jmp    8010588a <alltraps>

80106133 <vector108>:
.globl vector108
vector108:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $108
80106135:	6a 6c                	push   $0x6c
  jmp alltraps
80106137:	e9 4e f7 ff ff       	jmp    8010588a <alltraps>

8010613c <vector109>:
.globl vector109
vector109:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $109
8010613e:	6a 6d                	push   $0x6d
  jmp alltraps
80106140:	e9 45 f7 ff ff       	jmp    8010588a <alltraps>

80106145 <vector110>:
.globl vector110
vector110:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $110
80106147:	6a 6e                	push   $0x6e
  jmp alltraps
80106149:	e9 3c f7 ff ff       	jmp    8010588a <alltraps>

8010614e <vector111>:
.globl vector111
vector111:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $111
80106150:	6a 6f                	push   $0x6f
  jmp alltraps
80106152:	e9 33 f7 ff ff       	jmp    8010588a <alltraps>

80106157 <vector112>:
.globl vector112
vector112:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $112
80106159:	6a 70                	push   $0x70
  jmp alltraps
8010615b:	e9 2a f7 ff ff       	jmp    8010588a <alltraps>

80106160 <vector113>:
.globl vector113
vector113:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $113
80106162:	6a 71                	push   $0x71
  jmp alltraps
80106164:	e9 21 f7 ff ff       	jmp    8010588a <alltraps>

80106169 <vector114>:
.globl vector114
vector114:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $114
8010616b:	6a 72                	push   $0x72
  jmp alltraps
8010616d:	e9 18 f7 ff ff       	jmp    8010588a <alltraps>

80106172 <vector115>:
.globl vector115
vector115:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $115
80106174:	6a 73                	push   $0x73
  jmp alltraps
80106176:	e9 0f f7 ff ff       	jmp    8010588a <alltraps>

8010617b <vector116>:
.globl vector116
vector116:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $116
8010617d:	6a 74                	push   $0x74
  jmp alltraps
8010617f:	e9 06 f7 ff ff       	jmp    8010588a <alltraps>

80106184 <vector117>:
.globl vector117
vector117:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $117
80106186:	6a 75                	push   $0x75
  jmp alltraps
80106188:	e9 fd f6 ff ff       	jmp    8010588a <alltraps>

8010618d <vector118>:
.globl vector118
vector118:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $118
8010618f:	6a 76                	push   $0x76
  jmp alltraps
80106191:	e9 f4 f6 ff ff       	jmp    8010588a <alltraps>

80106196 <vector119>:
.globl vector119
vector119:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $119
80106198:	6a 77                	push   $0x77
  jmp alltraps
8010619a:	e9 eb f6 ff ff       	jmp    8010588a <alltraps>

8010619f <vector120>:
.globl vector120
vector120:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $120
801061a1:	6a 78                	push   $0x78
  jmp alltraps
801061a3:	e9 e2 f6 ff ff       	jmp    8010588a <alltraps>

801061a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $121
801061aa:	6a 79                	push   $0x79
  jmp alltraps
801061ac:	e9 d9 f6 ff ff       	jmp    8010588a <alltraps>

801061b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $122
801061b3:	6a 7a                	push   $0x7a
  jmp alltraps
801061b5:	e9 d0 f6 ff ff       	jmp    8010588a <alltraps>

801061ba <vector123>:
.globl vector123
vector123:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $123
801061bc:	6a 7b                	push   $0x7b
  jmp alltraps
801061be:	e9 c7 f6 ff ff       	jmp    8010588a <alltraps>

801061c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $124
801061c5:	6a 7c                	push   $0x7c
  jmp alltraps
801061c7:	e9 be f6 ff ff       	jmp    8010588a <alltraps>

801061cc <vector125>:
.globl vector125
vector125:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $125
801061ce:	6a 7d                	push   $0x7d
  jmp alltraps
801061d0:	e9 b5 f6 ff ff       	jmp    8010588a <alltraps>

801061d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $126
801061d7:	6a 7e                	push   $0x7e
  jmp alltraps
801061d9:	e9 ac f6 ff ff       	jmp    8010588a <alltraps>

801061de <vector127>:
.globl vector127
vector127:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $127
801061e0:	6a 7f                	push   $0x7f
  jmp alltraps
801061e2:	e9 a3 f6 ff ff       	jmp    8010588a <alltraps>

801061e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $128
801061e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801061ee:	e9 97 f6 ff ff       	jmp    8010588a <alltraps>

801061f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $129
801061f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801061fa:	e9 8b f6 ff ff       	jmp    8010588a <alltraps>

801061ff <vector130>:
.globl vector130
vector130:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $130
80106201:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106206:	e9 7f f6 ff ff       	jmp    8010588a <alltraps>

8010620b <vector131>:
.globl vector131
vector131:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $131
8010620d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106212:	e9 73 f6 ff ff       	jmp    8010588a <alltraps>

80106217 <vector132>:
.globl vector132
vector132:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $132
80106219:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010621e:	e9 67 f6 ff ff       	jmp    8010588a <alltraps>

80106223 <vector133>:
.globl vector133
vector133:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $133
80106225:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010622a:	e9 5b f6 ff ff       	jmp    8010588a <alltraps>

8010622f <vector134>:
.globl vector134
vector134:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $134
80106231:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106236:	e9 4f f6 ff ff       	jmp    8010588a <alltraps>

8010623b <vector135>:
.globl vector135
vector135:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $135
8010623d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106242:	e9 43 f6 ff ff       	jmp    8010588a <alltraps>

80106247 <vector136>:
.globl vector136
vector136:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $136
80106249:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010624e:	e9 37 f6 ff ff       	jmp    8010588a <alltraps>

80106253 <vector137>:
.globl vector137
vector137:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $137
80106255:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010625a:	e9 2b f6 ff ff       	jmp    8010588a <alltraps>

8010625f <vector138>:
.globl vector138
vector138:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $138
80106261:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106266:	e9 1f f6 ff ff       	jmp    8010588a <alltraps>

8010626b <vector139>:
.globl vector139
vector139:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $139
8010626d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106272:	e9 13 f6 ff ff       	jmp    8010588a <alltraps>

80106277 <vector140>:
.globl vector140
vector140:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $140
80106279:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010627e:	e9 07 f6 ff ff       	jmp    8010588a <alltraps>

80106283 <vector141>:
.globl vector141
vector141:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $141
80106285:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010628a:	e9 fb f5 ff ff       	jmp    8010588a <alltraps>

8010628f <vector142>:
.globl vector142
vector142:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $142
80106291:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106296:	e9 ef f5 ff ff       	jmp    8010588a <alltraps>

8010629b <vector143>:
.globl vector143
vector143:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $143
8010629d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062a2:	e9 e3 f5 ff ff       	jmp    8010588a <alltraps>

801062a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $144
801062a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062ae:	e9 d7 f5 ff ff       	jmp    8010588a <alltraps>

801062b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $145
801062b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062ba:	e9 cb f5 ff ff       	jmp    8010588a <alltraps>

801062bf <vector146>:
.globl vector146
vector146:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $146
801062c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062c6:	e9 bf f5 ff ff       	jmp    8010588a <alltraps>

801062cb <vector147>:
.globl vector147
vector147:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $147
801062cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801062d2:	e9 b3 f5 ff ff       	jmp    8010588a <alltraps>

801062d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $148
801062d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801062de:	e9 a7 f5 ff ff       	jmp    8010588a <alltraps>

801062e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $149
801062e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801062ea:	e9 9b f5 ff ff       	jmp    8010588a <alltraps>

801062ef <vector150>:
.globl vector150
vector150:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $150
801062f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801062f6:	e9 8f f5 ff ff       	jmp    8010588a <alltraps>

801062fb <vector151>:
.globl vector151
vector151:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $151
801062fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106302:	e9 83 f5 ff ff       	jmp    8010588a <alltraps>

80106307 <vector152>:
.globl vector152
vector152:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $152
80106309:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010630e:	e9 77 f5 ff ff       	jmp    8010588a <alltraps>

80106313 <vector153>:
.globl vector153
vector153:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $153
80106315:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010631a:	e9 6b f5 ff ff       	jmp    8010588a <alltraps>

8010631f <vector154>:
.globl vector154
vector154:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $154
80106321:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106326:	e9 5f f5 ff ff       	jmp    8010588a <alltraps>

8010632b <vector155>:
.globl vector155
vector155:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $155
8010632d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106332:	e9 53 f5 ff ff       	jmp    8010588a <alltraps>

80106337 <vector156>:
.globl vector156
vector156:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $156
80106339:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010633e:	e9 47 f5 ff ff       	jmp    8010588a <alltraps>

80106343 <vector157>:
.globl vector157
vector157:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $157
80106345:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010634a:	e9 3b f5 ff ff       	jmp    8010588a <alltraps>

8010634f <vector158>:
.globl vector158
vector158:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $158
80106351:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106356:	e9 2f f5 ff ff       	jmp    8010588a <alltraps>

8010635b <vector159>:
.globl vector159
vector159:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $159
8010635d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106362:	e9 23 f5 ff ff       	jmp    8010588a <alltraps>

80106367 <vector160>:
.globl vector160
vector160:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $160
80106369:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010636e:	e9 17 f5 ff ff       	jmp    8010588a <alltraps>

80106373 <vector161>:
.globl vector161
vector161:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $161
80106375:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010637a:	e9 0b f5 ff ff       	jmp    8010588a <alltraps>

8010637f <vector162>:
.globl vector162
vector162:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $162
80106381:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106386:	e9 ff f4 ff ff       	jmp    8010588a <alltraps>

8010638b <vector163>:
.globl vector163
vector163:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $163
8010638d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106392:	e9 f3 f4 ff ff       	jmp    8010588a <alltraps>

80106397 <vector164>:
.globl vector164
vector164:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $164
80106399:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010639e:	e9 e7 f4 ff ff       	jmp    8010588a <alltraps>

801063a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $165
801063a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063aa:	e9 db f4 ff ff       	jmp    8010588a <alltraps>

801063af <vector166>:
.globl vector166
vector166:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $166
801063b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063b6:	e9 cf f4 ff ff       	jmp    8010588a <alltraps>

801063bb <vector167>:
.globl vector167
vector167:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $167
801063bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063c2:	e9 c3 f4 ff ff       	jmp    8010588a <alltraps>

801063c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $168
801063c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063ce:	e9 b7 f4 ff ff       	jmp    8010588a <alltraps>

801063d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $169
801063d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801063da:	e9 ab f4 ff ff       	jmp    8010588a <alltraps>

801063df <vector170>:
.globl vector170
vector170:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $170
801063e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801063e6:	e9 9f f4 ff ff       	jmp    8010588a <alltraps>

801063eb <vector171>:
.globl vector171
vector171:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $171
801063ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801063f2:	e9 93 f4 ff ff       	jmp    8010588a <alltraps>

801063f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $172
801063f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801063fe:	e9 87 f4 ff ff       	jmp    8010588a <alltraps>

80106403 <vector173>:
.globl vector173
vector173:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $173
80106405:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010640a:	e9 7b f4 ff ff       	jmp    8010588a <alltraps>

8010640f <vector174>:
.globl vector174
vector174:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $174
80106411:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106416:	e9 6f f4 ff ff       	jmp    8010588a <alltraps>

8010641b <vector175>:
.globl vector175
vector175:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $175
8010641d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106422:	e9 63 f4 ff ff       	jmp    8010588a <alltraps>

80106427 <vector176>:
.globl vector176
vector176:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $176
80106429:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010642e:	e9 57 f4 ff ff       	jmp    8010588a <alltraps>

80106433 <vector177>:
.globl vector177
vector177:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $177
80106435:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010643a:	e9 4b f4 ff ff       	jmp    8010588a <alltraps>

8010643f <vector178>:
.globl vector178
vector178:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $178
80106441:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106446:	e9 3f f4 ff ff       	jmp    8010588a <alltraps>

8010644b <vector179>:
.globl vector179
vector179:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $179
8010644d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106452:	e9 33 f4 ff ff       	jmp    8010588a <alltraps>

80106457 <vector180>:
.globl vector180
vector180:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $180
80106459:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010645e:	e9 27 f4 ff ff       	jmp    8010588a <alltraps>

80106463 <vector181>:
.globl vector181
vector181:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $181
80106465:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010646a:	e9 1b f4 ff ff       	jmp    8010588a <alltraps>

8010646f <vector182>:
.globl vector182
vector182:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $182
80106471:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106476:	e9 0f f4 ff ff       	jmp    8010588a <alltraps>

8010647b <vector183>:
.globl vector183
vector183:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $183
8010647d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106482:	e9 03 f4 ff ff       	jmp    8010588a <alltraps>

80106487 <vector184>:
.globl vector184
vector184:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $184
80106489:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010648e:	e9 f7 f3 ff ff       	jmp    8010588a <alltraps>

80106493 <vector185>:
.globl vector185
vector185:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $185
80106495:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010649a:	e9 eb f3 ff ff       	jmp    8010588a <alltraps>

8010649f <vector186>:
.globl vector186
vector186:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $186
801064a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064a6:	e9 df f3 ff ff       	jmp    8010588a <alltraps>

801064ab <vector187>:
.globl vector187
vector187:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $187
801064ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064b2:	e9 d3 f3 ff ff       	jmp    8010588a <alltraps>

801064b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $188
801064b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064be:	e9 c7 f3 ff ff       	jmp    8010588a <alltraps>

801064c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $189
801064c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064ca:	e9 bb f3 ff ff       	jmp    8010588a <alltraps>

801064cf <vector190>:
.globl vector190
vector190:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $190
801064d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801064d6:	e9 af f3 ff ff       	jmp    8010588a <alltraps>

801064db <vector191>:
.globl vector191
vector191:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $191
801064dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801064e2:	e9 a3 f3 ff ff       	jmp    8010588a <alltraps>

801064e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $192
801064e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801064ee:	e9 97 f3 ff ff       	jmp    8010588a <alltraps>

801064f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $193
801064f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801064fa:	e9 8b f3 ff ff       	jmp    8010588a <alltraps>

801064ff <vector194>:
.globl vector194
vector194:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $194
80106501:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106506:	e9 7f f3 ff ff       	jmp    8010588a <alltraps>

8010650b <vector195>:
.globl vector195
vector195:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $195
8010650d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106512:	e9 73 f3 ff ff       	jmp    8010588a <alltraps>

80106517 <vector196>:
.globl vector196
vector196:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $196
80106519:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010651e:	e9 67 f3 ff ff       	jmp    8010588a <alltraps>

80106523 <vector197>:
.globl vector197
vector197:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $197
80106525:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010652a:	e9 5b f3 ff ff       	jmp    8010588a <alltraps>

8010652f <vector198>:
.globl vector198
vector198:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $198
80106531:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106536:	e9 4f f3 ff ff       	jmp    8010588a <alltraps>

8010653b <vector199>:
.globl vector199
vector199:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $199
8010653d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106542:	e9 43 f3 ff ff       	jmp    8010588a <alltraps>

80106547 <vector200>:
.globl vector200
vector200:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $200
80106549:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010654e:	e9 37 f3 ff ff       	jmp    8010588a <alltraps>

80106553 <vector201>:
.globl vector201
vector201:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $201
80106555:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010655a:	e9 2b f3 ff ff       	jmp    8010588a <alltraps>

8010655f <vector202>:
.globl vector202
vector202:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $202
80106561:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106566:	e9 1f f3 ff ff       	jmp    8010588a <alltraps>

8010656b <vector203>:
.globl vector203
vector203:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $203
8010656d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106572:	e9 13 f3 ff ff       	jmp    8010588a <alltraps>

80106577 <vector204>:
.globl vector204
vector204:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $204
80106579:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010657e:	e9 07 f3 ff ff       	jmp    8010588a <alltraps>

80106583 <vector205>:
.globl vector205
vector205:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $205
80106585:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010658a:	e9 fb f2 ff ff       	jmp    8010588a <alltraps>

8010658f <vector206>:
.globl vector206
vector206:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $206
80106591:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106596:	e9 ef f2 ff ff       	jmp    8010588a <alltraps>

8010659b <vector207>:
.globl vector207
vector207:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $207
8010659d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065a2:	e9 e3 f2 ff ff       	jmp    8010588a <alltraps>

801065a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $208
801065a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065ae:	e9 d7 f2 ff ff       	jmp    8010588a <alltraps>

801065b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $209
801065b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065ba:	e9 cb f2 ff ff       	jmp    8010588a <alltraps>

801065bf <vector210>:
.globl vector210
vector210:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $210
801065c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065c6:	e9 bf f2 ff ff       	jmp    8010588a <alltraps>

801065cb <vector211>:
.globl vector211
vector211:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $211
801065cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801065d2:	e9 b3 f2 ff ff       	jmp    8010588a <alltraps>

801065d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $212
801065d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801065de:	e9 a7 f2 ff ff       	jmp    8010588a <alltraps>

801065e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $213
801065e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801065ea:	e9 9b f2 ff ff       	jmp    8010588a <alltraps>

801065ef <vector214>:
.globl vector214
vector214:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $214
801065f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801065f6:	e9 8f f2 ff ff       	jmp    8010588a <alltraps>

801065fb <vector215>:
.globl vector215
vector215:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $215
801065fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106602:	e9 83 f2 ff ff       	jmp    8010588a <alltraps>

80106607 <vector216>:
.globl vector216
vector216:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $216
80106609:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010660e:	e9 77 f2 ff ff       	jmp    8010588a <alltraps>

80106613 <vector217>:
.globl vector217
vector217:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $217
80106615:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010661a:	e9 6b f2 ff ff       	jmp    8010588a <alltraps>

8010661f <vector218>:
.globl vector218
vector218:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $218
80106621:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106626:	e9 5f f2 ff ff       	jmp    8010588a <alltraps>

8010662b <vector219>:
.globl vector219
vector219:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $219
8010662d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106632:	e9 53 f2 ff ff       	jmp    8010588a <alltraps>

80106637 <vector220>:
.globl vector220
vector220:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $220
80106639:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010663e:	e9 47 f2 ff ff       	jmp    8010588a <alltraps>

80106643 <vector221>:
.globl vector221
vector221:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $221
80106645:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010664a:	e9 3b f2 ff ff       	jmp    8010588a <alltraps>

8010664f <vector222>:
.globl vector222
vector222:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $222
80106651:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106656:	e9 2f f2 ff ff       	jmp    8010588a <alltraps>

8010665b <vector223>:
.globl vector223
vector223:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $223
8010665d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106662:	e9 23 f2 ff ff       	jmp    8010588a <alltraps>

80106667 <vector224>:
.globl vector224
vector224:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $224
80106669:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010666e:	e9 17 f2 ff ff       	jmp    8010588a <alltraps>

80106673 <vector225>:
.globl vector225
vector225:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $225
80106675:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010667a:	e9 0b f2 ff ff       	jmp    8010588a <alltraps>

8010667f <vector226>:
.globl vector226
vector226:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $226
80106681:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106686:	e9 ff f1 ff ff       	jmp    8010588a <alltraps>

8010668b <vector227>:
.globl vector227
vector227:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $227
8010668d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106692:	e9 f3 f1 ff ff       	jmp    8010588a <alltraps>

80106697 <vector228>:
.globl vector228
vector228:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $228
80106699:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010669e:	e9 e7 f1 ff ff       	jmp    8010588a <alltraps>

801066a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $229
801066a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066aa:	e9 db f1 ff ff       	jmp    8010588a <alltraps>

801066af <vector230>:
.globl vector230
vector230:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $230
801066b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066b6:	e9 cf f1 ff ff       	jmp    8010588a <alltraps>

801066bb <vector231>:
.globl vector231
vector231:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $231
801066bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066c2:	e9 c3 f1 ff ff       	jmp    8010588a <alltraps>

801066c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $232
801066c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066ce:	e9 b7 f1 ff ff       	jmp    8010588a <alltraps>

801066d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $233
801066d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801066da:	e9 ab f1 ff ff       	jmp    8010588a <alltraps>

801066df <vector234>:
.globl vector234
vector234:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $234
801066e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801066e6:	e9 9f f1 ff ff       	jmp    8010588a <alltraps>

801066eb <vector235>:
.globl vector235
vector235:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $235
801066ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801066f2:	e9 93 f1 ff ff       	jmp    8010588a <alltraps>

801066f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $236
801066f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801066fe:	e9 87 f1 ff ff       	jmp    8010588a <alltraps>

80106703 <vector237>:
.globl vector237
vector237:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $237
80106705:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010670a:	e9 7b f1 ff ff       	jmp    8010588a <alltraps>

8010670f <vector238>:
.globl vector238
vector238:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $238
80106711:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106716:	e9 6f f1 ff ff       	jmp    8010588a <alltraps>

8010671b <vector239>:
.globl vector239
vector239:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $239
8010671d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106722:	e9 63 f1 ff ff       	jmp    8010588a <alltraps>

80106727 <vector240>:
.globl vector240
vector240:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $240
80106729:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010672e:	e9 57 f1 ff ff       	jmp    8010588a <alltraps>

80106733 <vector241>:
.globl vector241
vector241:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $241
80106735:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010673a:	e9 4b f1 ff ff       	jmp    8010588a <alltraps>

8010673f <vector242>:
.globl vector242
vector242:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $242
80106741:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106746:	e9 3f f1 ff ff       	jmp    8010588a <alltraps>

8010674b <vector243>:
.globl vector243
vector243:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $243
8010674d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106752:	e9 33 f1 ff ff       	jmp    8010588a <alltraps>

80106757 <vector244>:
.globl vector244
vector244:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $244
80106759:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010675e:	e9 27 f1 ff ff       	jmp    8010588a <alltraps>

80106763 <vector245>:
.globl vector245
vector245:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $245
80106765:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010676a:	e9 1b f1 ff ff       	jmp    8010588a <alltraps>

8010676f <vector246>:
.globl vector246
vector246:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $246
80106771:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106776:	e9 0f f1 ff ff       	jmp    8010588a <alltraps>

8010677b <vector247>:
.globl vector247
vector247:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $247
8010677d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106782:	e9 03 f1 ff ff       	jmp    8010588a <alltraps>

80106787 <vector248>:
.globl vector248
vector248:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $248
80106789:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010678e:	e9 f7 f0 ff ff       	jmp    8010588a <alltraps>

80106793 <vector249>:
.globl vector249
vector249:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $249
80106795:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010679a:	e9 eb f0 ff ff       	jmp    8010588a <alltraps>

8010679f <vector250>:
.globl vector250
vector250:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $250
801067a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067a6:	e9 df f0 ff ff       	jmp    8010588a <alltraps>

801067ab <vector251>:
.globl vector251
vector251:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $251
801067ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067b2:	e9 d3 f0 ff ff       	jmp    8010588a <alltraps>

801067b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $252
801067b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067be:	e9 c7 f0 ff ff       	jmp    8010588a <alltraps>

801067c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $253
801067c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067ca:	e9 bb f0 ff ff       	jmp    8010588a <alltraps>

801067cf <vector254>:
.globl vector254
vector254:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $254
801067d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801067d6:	e9 af f0 ff ff       	jmp    8010588a <alltraps>

801067db <vector255>:
.globl vector255
vector255:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $255
801067dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801067e2:	e9 a3 f0 ff ff       	jmp    8010588a <alltraps>
801067e7:	66 90                	xchg   %ax,%ax
801067e9:	66 90                	xchg   %ax,%ax
801067eb:	66 90                	xchg   %ax,%ax
801067ed:	66 90                	xchg   %ax,%ax
801067ef:	90                   	nop

801067f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	56                   	push   %esi
801067f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801067fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106802:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106805:	39 d3                	cmp    %edx,%ebx
80106807:	73 56                	jae    8010685f <deallocuvm.part.0+0x6f>
80106809:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010680c:	89 c6                	mov    %eax,%esi
8010680e:	89 d7                	mov    %edx,%edi
80106810:	eb 12                	jmp    80106824 <deallocuvm.part.0+0x34>
80106812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106818:	83 c2 01             	add    $0x1,%edx
8010681b:	89 d3                	mov    %edx,%ebx
8010681d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106820:	39 fb                	cmp    %edi,%ebx
80106822:	73 38                	jae    8010685c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106824:	89 da                	mov    %ebx,%edx
80106826:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106829:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010682c:	a8 01                	test   $0x1,%al
8010682e:	74 e8                	je     80106818 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106830:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106832:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106837:	c1 e9 0a             	shr    $0xa,%ecx
8010683a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106840:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106847:	85 c0                	test   %eax,%eax
80106849:	74 cd                	je     80106818 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
8010684b:	8b 10                	mov    (%eax),%edx
8010684d:	f6 c2 01             	test   $0x1,%dl
80106850:	75 1e                	jne    80106870 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106852:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106858:	39 fb                	cmp    %edi,%ebx
8010685a:	72 c8                	jb     80106824 <deallocuvm.part.0+0x34>
8010685c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010685f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106862:	89 c8                	mov    %ecx,%eax
80106864:	5b                   	pop    %ebx
80106865:	5e                   	pop    %esi
80106866:	5f                   	pop    %edi
80106867:	5d                   	pop    %ebp
80106868:	c3                   	ret
80106869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106870:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106876:	74 26                	je     8010689e <deallocuvm.part.0+0xae>
      kfree(v);
80106878:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010687b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106881:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106884:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010688a:	52                   	push   %edx
8010688b:	e8 60 bc ff ff       	call   801024f0 <kfree>
      *pte = 0;
80106890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106893:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106896:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010689c:	eb 82                	jmp    80106820 <deallocuvm.part.0+0x30>
        panic("kfree");
8010689e:	83 ec 0c             	sub    $0xc,%esp
801068a1:	68 a5 73 10 80       	push   $0x801073a5
801068a6:	e8 d5 9a ff ff       	call   80100380 <panic>
801068ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801068b0 <mappages>:
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801068b6:	89 d3                	mov    %edx,%ebx
801068b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801068be:	83 ec 1c             	sub    $0x1c,%esp
801068c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801068c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068d0:	8b 45 08             	mov    0x8(%ebp),%eax
801068d3:	29 d8                	sub    %ebx,%eax
801068d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068d8:	eb 3f                	jmp    80106919 <mappages+0x69>
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801068e0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801068e7:	c1 ea 0a             	shr    $0xa,%edx
801068ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801068f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068f7:	85 c0                	test   %eax,%eax
801068f9:	74 75                	je     80106970 <mappages+0xc0>
    if(*pte & PTE_P)
801068fb:	f6 00 01             	testb  $0x1,(%eax)
801068fe:	0f 85 86 00 00 00    	jne    8010698a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106904:	0b 75 0c             	or     0xc(%ebp),%esi
80106907:	83 ce 01             	or     $0x1,%esi
8010690a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010690c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010690f:	39 c3                	cmp    %eax,%ebx
80106911:	74 6d                	je     80106980 <mappages+0xd0>
    a += PGSIZE;
80106913:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106919:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010691c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010691f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106922:	89 d8                	mov    %ebx,%eax
80106924:	c1 e8 16             	shr    $0x16,%eax
80106927:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
8010692a:	8b 07                	mov    (%edi),%eax
8010692c:	a8 01                	test   $0x1,%al
8010692e:	75 b0                	jne    801068e0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106930:	e8 7b bd ff ff       	call   801026b0 <kalloc>
80106935:	85 c0                	test   %eax,%eax
80106937:	74 37                	je     80106970 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106939:	83 ec 04             	sub    $0x4,%esp
8010693c:	68 00 10 00 00       	push   $0x1000
80106941:	6a 00                	push   $0x0
80106943:	50                   	push   %eax
80106944:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106947:	e8 a4 dd ff ff       	call   801046f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010694c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010694f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106952:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106958:	83 c8 07             	or     $0x7,%eax
8010695b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010695d:	89 d8                	mov    %ebx,%eax
8010695f:	c1 e8 0a             	shr    $0xa,%eax
80106962:	25 fc 0f 00 00       	and    $0xffc,%eax
80106967:	01 d0                	add    %edx,%eax
80106969:	eb 90                	jmp    801068fb <mappages+0x4b>
8010696b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106970:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106978:	5b                   	pop    %ebx
80106979:	5e                   	pop    %esi
8010697a:	5f                   	pop    %edi
8010697b:	5d                   	pop    %ebp
8010697c:	c3                   	ret
8010697d:	8d 76 00             	lea    0x0(%esi),%esi
80106980:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106983:	31 c0                	xor    %eax,%eax
}
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5f                   	pop    %edi
80106988:	5d                   	pop    %ebp
80106989:	c3                   	ret
      panic("remap");
8010698a:	83 ec 0c             	sub    $0xc,%esp
8010698d:	68 d9 75 10 80       	push   $0x801075d9
80106992:	e8 e9 99 ff ff       	call   80100380 <panic>
80106997:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010699e:	00 
8010699f:	90                   	nop

801069a0 <seginit>:
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069a6:	e8 e5 cf ff ff       	call   80103990 <cpuid>
  pd[0] = size-1;
801069ab:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069b0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
801069ba:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
801069c1:	ff 00 00 
801069c4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
801069cb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069ce:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
801069d5:	ff 00 00 
801069d8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
801069df:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069e2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
801069e9:	ff 00 00 
801069ec:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
801069f3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069f6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
801069fd:	ff 00 00 
80106a00:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106a07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a0a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106a0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a13:	c1 e8 10             	shr    $0x10,%eax
80106a16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a1d:	0f 01 10             	lgdtl  (%eax)
}
80106a20:	c9                   	leave
80106a21:	c3                   	ret
80106a22:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a29:	00 
80106a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a30:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106a35:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a3a:	0f 22 d8             	mov    %eax,%cr3
}
80106a3d:	c3                   	ret
80106a3e:	66 90                	xchg   %ax,%ax

80106a40 <switchuvm>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
80106a46:	83 ec 1c             	sub    $0x1c,%esp
80106a49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a4c:	85 f6                	test   %esi,%esi
80106a4e:	0f 84 cb 00 00 00    	je     80106b1f <switchuvm+0xdf>
  if(p->kstack == 0)
80106a54:	8b 46 08             	mov    0x8(%esi),%eax
80106a57:	85 c0                	test   %eax,%eax
80106a59:	0f 84 da 00 00 00    	je     80106b39 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106a5f:	8b 46 04             	mov    0x4(%esi),%eax
80106a62:	85 c0                	test   %eax,%eax
80106a64:	0f 84 c2 00 00 00    	je     80106b2c <switchuvm+0xec>
  pushcli();
80106a6a:	e8 31 da ff ff       	call   801044a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a6f:	e8 bc ce ff ff       	call   80103930 <mycpu>
80106a74:	89 c3                	mov    %eax,%ebx
80106a76:	e8 b5 ce ff ff       	call   80103930 <mycpu>
80106a7b:	89 c7                	mov    %eax,%edi
80106a7d:	e8 ae ce ff ff       	call   80103930 <mycpu>
80106a82:	83 c7 08             	add    $0x8,%edi
80106a85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a88:	e8 a3 ce ff ff       	call   80103930 <mycpu>
80106a8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a90:	ba 67 00 00 00       	mov    $0x67,%edx
80106a95:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a9c:	83 c0 08             	add    $0x8,%eax
80106a9f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106aa6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106aab:	83 c1 08             	add    $0x8,%ecx
80106aae:	c1 e8 18             	shr    $0x18,%eax
80106ab1:	c1 e9 10             	shr    $0x10,%ecx
80106ab4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106aba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ac0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ac5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106acc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ad1:	e8 5a ce ff ff       	call   80103930 <mycpu>
80106ad6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106add:	e8 4e ce ff ff       	call   80103930 <mycpu>
80106ae2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ae6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106ae9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106aef:	e8 3c ce ff ff       	call   80103930 <mycpu>
80106af4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106af7:	e8 34 ce ff ff       	call   80103930 <mycpu>
80106afc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b00:	b8 28 00 00 00       	mov    $0x28,%eax
80106b05:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b08:	8b 46 04             	mov    0x4(%esi),%eax
80106b0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b10:	0f 22 d8             	mov    %eax,%cr3
}
80106b13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b16:	5b                   	pop    %ebx
80106b17:	5e                   	pop    %esi
80106b18:	5f                   	pop    %edi
80106b19:	5d                   	pop    %ebp
  popcli();
80106b1a:	e9 d1 d9 ff ff       	jmp    801044f0 <popcli>
    panic("switchuvm: no process");
80106b1f:	83 ec 0c             	sub    $0xc,%esp
80106b22:	68 df 75 10 80       	push   $0x801075df
80106b27:	e8 54 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106b2c:	83 ec 0c             	sub    $0xc,%esp
80106b2f:	68 0a 76 10 80       	push   $0x8010760a
80106b34:	e8 47 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106b39:	83 ec 0c             	sub    $0xc,%esp
80106b3c:	68 f5 75 10 80       	push   $0x801075f5
80106b41:	e8 3a 98 ff ff       	call   80100380 <panic>
80106b46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b4d:	00 
80106b4e:	66 90                	xchg   %ax,%ax

80106b50 <inituvm>:
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
80106b56:	83 ec 1c             	sub    $0x1c,%esp
80106b59:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5c:	8b 75 10             	mov    0x10(%ebp),%esi
80106b5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106b65:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b6b:	77 49                	ja     80106bb6 <inituvm+0x66>
  mem = kalloc();
80106b6d:	e8 3e bb ff ff       	call   801026b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106b72:	83 ec 04             	sub    $0x4,%esp
80106b75:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106b7a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b7c:	6a 00                	push   $0x0
80106b7e:	50                   	push   %eax
80106b7f:	e8 6c db ff ff       	call   801046f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b84:	58                   	pop    %eax
80106b85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b8b:	5a                   	pop    %edx
80106b8c:	6a 06                	push   $0x6
80106b8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b93:	31 d2                	xor    %edx,%edx
80106b95:	50                   	push   %eax
80106b96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b99:	e8 12 fd ff ff       	call   801068b0 <mappages>
  memmove(mem, init, sz);
80106b9e:	89 75 10             	mov    %esi,0x10(%ebp)
80106ba1:	83 c4 10             	add    $0x10,%esp
80106ba4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106ba7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bad:	5b                   	pop    %ebx
80106bae:	5e                   	pop    %esi
80106baf:	5f                   	pop    %edi
80106bb0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106bb1:	e9 ca db ff ff       	jmp    80104780 <memmove>
    panic("inituvm: more than a page");
80106bb6:	83 ec 0c             	sub    $0xc,%esp
80106bb9:	68 1e 76 10 80       	push   $0x8010761e
80106bbe:	e8 bd 97 ff ff       	call   80100380 <panic>
80106bc3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bca:	00 
80106bcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106bd0 <loaduvm>:
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
80106bd6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106bd9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106bdc:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106bdf:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106be5:	0f 85 a2 00 00 00    	jne    80106c8d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106beb:	85 ff                	test   %edi,%edi
80106bed:	74 7d                	je     80106c6c <loaduvm+0x9c>
80106bef:	90                   	nop
  pde = &pgdir[PDX(va)];
80106bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106bf3:	8b 55 08             	mov    0x8(%ebp),%edx
80106bf6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106bf8:	89 c1                	mov    %eax,%ecx
80106bfa:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106bfd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106c00:	f6 c1 01             	test   $0x1,%cl
80106c03:	75 13                	jne    80106c18 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106c05:	83 ec 0c             	sub    $0xc,%esp
80106c08:	68 38 76 10 80       	push   $0x80107638
80106c0d:	e8 6e 97 ff ff       	call   80100380 <panic>
80106c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c18:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c1b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106c21:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c26:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c2d:	85 c9                	test   %ecx,%ecx
80106c2f:	74 d4                	je     80106c05 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106c31:	89 fb                	mov    %edi,%ebx
80106c33:	b8 00 10 00 00       	mov    $0x1000,%eax
80106c38:	29 f3                	sub    %esi,%ebx
80106c3a:	39 c3                	cmp    %eax,%ebx
80106c3c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c3f:	53                   	push   %ebx
80106c40:	8b 45 14             	mov    0x14(%ebp),%eax
80106c43:	01 f0                	add    %esi,%eax
80106c45:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106c46:	8b 01                	mov    (%ecx),%eax
80106c48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c4d:	05 00 00 00 80       	add    $0x80000000,%eax
80106c52:	50                   	push   %eax
80106c53:	ff 75 10             	push   0x10(%ebp)
80106c56:	e8 a5 ae ff ff       	call   80101b00 <readi>
80106c5b:	83 c4 10             	add    $0x10,%esp
80106c5e:	39 d8                	cmp    %ebx,%eax
80106c60:	75 1e                	jne    80106c80 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106c62:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c68:	39 fe                	cmp    %edi,%esi
80106c6a:	72 84                	jb     80106bf0 <loaduvm+0x20>
}
80106c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c6f:	31 c0                	xor    %eax,%eax
}
80106c71:	5b                   	pop    %ebx
80106c72:	5e                   	pop    %esi
80106c73:	5f                   	pop    %edi
80106c74:	5d                   	pop    %ebp
80106c75:	c3                   	ret
80106c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c7d:	00 
80106c7e:	66 90                	xchg   %ax,%ax
80106c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c88:	5b                   	pop    %ebx
80106c89:	5e                   	pop    %esi
80106c8a:	5f                   	pop    %edi
80106c8b:	5d                   	pop    %ebp
80106c8c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106c8d:	83 ec 0c             	sub    $0xc,%esp
80106c90:	68 5c 78 10 80       	push   $0x8010785c
80106c95:	e8 e6 96 ff ff       	call   80100380 <panic>
80106c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ca0 <allocuvm>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 1c             	sub    $0x1c,%esp
80106ca9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106cac:	85 f6                	test   %esi,%esi
80106cae:	0f 88 98 00 00 00    	js     80106d4c <allocuvm+0xac>
80106cb4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106cb6:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106cb9:	0f 82 a1 00 00 00    	jb     80106d60 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cc2:	05 ff 0f 00 00       	add    $0xfff,%eax
80106cc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ccc:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106cce:	39 f0                	cmp    %esi,%eax
80106cd0:	0f 83 8d 00 00 00    	jae    80106d63 <allocuvm+0xc3>
80106cd6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106cd9:	eb 44                	jmp    80106d1f <allocuvm+0x7f>
80106cdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106ce0:	83 ec 04             	sub    $0x4,%esp
80106ce3:	68 00 10 00 00       	push   $0x1000
80106ce8:	6a 00                	push   $0x0
80106cea:	50                   	push   %eax
80106ceb:	e8 00 da ff ff       	call   801046f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106cf0:	58                   	pop    %eax
80106cf1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cf7:	5a                   	pop    %edx
80106cf8:	6a 06                	push   $0x6
80106cfa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cff:	89 fa                	mov    %edi,%edx
80106d01:	50                   	push   %eax
80106d02:	8b 45 08             	mov    0x8(%ebp),%eax
80106d05:	e8 a6 fb ff ff       	call   801068b0 <mappages>
80106d0a:	83 c4 10             	add    $0x10,%esp
80106d0d:	85 c0                	test   %eax,%eax
80106d0f:	78 5f                	js     80106d70 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106d11:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106d17:	39 f7                	cmp    %esi,%edi
80106d19:	0f 83 89 00 00 00    	jae    80106da8 <allocuvm+0x108>
    mem = kalloc();
80106d1f:	e8 8c b9 ff ff       	call   801026b0 <kalloc>
80106d24:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d26:	85 c0                	test   %eax,%eax
80106d28:	75 b6                	jne    80106ce0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d2a:	83 ec 0c             	sub    $0xc,%esp
80106d2d:	68 56 76 10 80       	push   $0x80107656
80106d32:	e8 79 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106d37:	83 c4 10             	add    $0x10,%esp
80106d3a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106d3d:	74 0d                	je     80106d4c <allocuvm+0xac>
80106d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d42:	8b 45 08             	mov    0x8(%ebp),%eax
80106d45:	89 f2                	mov    %esi,%edx
80106d47:	e8 a4 fa ff ff       	call   801067f0 <deallocuvm.part.0>
    return 0;
80106d4c:	31 d2                	xor    %edx,%edx
}
80106d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d51:	89 d0                	mov    %edx,%eax
80106d53:	5b                   	pop    %ebx
80106d54:	5e                   	pop    %esi
80106d55:	5f                   	pop    %edi
80106d56:	5d                   	pop    %ebp
80106d57:	c3                   	ret
80106d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d5f:	00 
    return oldsz;
80106d60:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d66:	89 d0                	mov    %edx,%eax
80106d68:	5b                   	pop    %ebx
80106d69:	5e                   	pop    %esi
80106d6a:	5f                   	pop    %edi
80106d6b:	5d                   	pop    %ebp
80106d6c:	c3                   	ret
80106d6d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106d70:	83 ec 0c             	sub    $0xc,%esp
80106d73:	68 6e 76 10 80       	push   $0x8010766e
80106d78:	e8 33 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106d7d:	83 c4 10             	add    $0x10,%esp
80106d80:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106d83:	74 0d                	je     80106d92 <allocuvm+0xf2>
80106d85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d88:	8b 45 08             	mov    0x8(%ebp),%eax
80106d8b:	89 f2                	mov    %esi,%edx
80106d8d:	e8 5e fa ff ff       	call   801067f0 <deallocuvm.part.0>
      kfree(mem);
80106d92:	83 ec 0c             	sub    $0xc,%esp
80106d95:	53                   	push   %ebx
80106d96:	e8 55 b7 ff ff       	call   801024f0 <kfree>
      return 0;
80106d9b:	83 c4 10             	add    $0x10,%esp
    return 0;
80106d9e:	31 d2                	xor    %edx,%edx
80106da0:	eb ac                	jmp    80106d4e <allocuvm+0xae>
80106da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106da8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dae:	5b                   	pop    %ebx
80106daf:	5e                   	pop    %esi
80106db0:	89 d0                	mov    %edx,%eax
80106db2:	5f                   	pop    %edi
80106db3:	5d                   	pop    %ebp
80106db4:	c3                   	ret
80106db5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dbc:	00 
80106dbd:	8d 76 00             	lea    0x0(%esi),%esi

80106dc0 <deallocuvm>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106dcc:	39 d1                	cmp    %edx,%ecx
80106dce:	73 10                	jae    80106de0 <deallocuvm+0x20>
}
80106dd0:	5d                   	pop    %ebp
80106dd1:	e9 1a fa ff ff       	jmp    801067f0 <deallocuvm.part.0>
80106dd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ddd:	00 
80106dde:	66 90                	xchg   %ax,%ax
80106de0:	89 d0                	mov    %edx,%eax
80106de2:	5d                   	pop    %ebp
80106de3:	c3                   	ret
80106de4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106deb:	00 
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106df0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 0c             	sub    $0xc,%esp
80106df9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106dfc:	85 f6                	test   %esi,%esi
80106dfe:	74 59                	je     80106e59 <freevm+0x69>
  if(newsz >= oldsz)
80106e00:	31 c9                	xor    %ecx,%ecx
80106e02:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e07:	89 f0                	mov    %esi,%eax
80106e09:	89 f3                	mov    %esi,%ebx
80106e0b:	e8 e0 f9 ff ff       	call   801067f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e10:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e16:	eb 0f                	jmp    80106e27 <freevm+0x37>
80106e18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e1f:	00 
80106e20:	83 c3 04             	add    $0x4,%ebx
80106e23:	39 fb                	cmp    %edi,%ebx
80106e25:	74 23                	je     80106e4a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e27:	8b 03                	mov    (%ebx),%eax
80106e29:	a8 01                	test   $0x1,%al
80106e2b:	74 f3                	je     80106e20 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e32:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e35:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e38:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e3d:	50                   	push   %eax
80106e3e:	e8 ad b6 ff ff       	call   801024f0 <kfree>
80106e43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e46:	39 fb                	cmp    %edi,%ebx
80106e48:	75 dd                	jne    80106e27 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e50:	5b                   	pop    %ebx
80106e51:	5e                   	pop    %esi
80106e52:	5f                   	pop    %edi
80106e53:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106e54:	e9 97 b6 ff ff       	jmp    801024f0 <kfree>
    panic("freevm: no pgdir");
80106e59:	83 ec 0c             	sub    $0xc,%esp
80106e5c:	68 8a 76 10 80       	push   $0x8010768a
80106e61:	e8 1a 95 ff ff       	call   80100380 <panic>
80106e66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e6d:	00 
80106e6e:	66 90                	xchg   %ax,%ax

80106e70 <setupkvm>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	56                   	push   %esi
80106e74:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106e75:	e8 36 b8 ff ff       	call   801026b0 <kalloc>
80106e7a:	85 c0                	test   %eax,%eax
80106e7c:	74 5e                	je     80106edc <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106e7e:	83 ec 04             	sub    $0x4,%esp
80106e81:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e83:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106e88:	68 00 10 00 00       	push   $0x1000
80106e8d:	6a 00                	push   $0x0
80106e8f:	50                   	push   %eax
80106e90:	e8 5b d8 ff ff       	call   801046f0 <memset>
80106e95:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106e98:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e9b:	83 ec 08             	sub    $0x8,%esp
80106e9e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ea1:	8b 13                	mov    (%ebx),%edx
80106ea3:	ff 73 0c             	push   0xc(%ebx)
80106ea6:	50                   	push   %eax
80106ea7:	29 c1                	sub    %eax,%ecx
80106ea9:	89 f0                	mov    %esi,%eax
80106eab:	e8 00 fa ff ff       	call   801068b0 <mappages>
80106eb0:	83 c4 10             	add    $0x10,%esp
80106eb3:	85 c0                	test   %eax,%eax
80106eb5:	78 19                	js     80106ed0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106eb7:	83 c3 10             	add    $0x10,%ebx
80106eba:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ec0:	75 d6                	jne    80106e98 <setupkvm+0x28>
}
80106ec2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ec5:	89 f0                	mov    %esi,%eax
80106ec7:	5b                   	pop    %ebx
80106ec8:	5e                   	pop    %esi
80106ec9:	5d                   	pop    %ebp
80106eca:	c3                   	ret
80106ecb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106ed0:	83 ec 0c             	sub    $0xc,%esp
80106ed3:	56                   	push   %esi
80106ed4:	e8 17 ff ff ff       	call   80106df0 <freevm>
      return 0;
80106ed9:	83 c4 10             	add    $0x10,%esp
}
80106edc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106edf:	31 f6                	xor    %esi,%esi
}
80106ee1:	89 f0                	mov    %esi,%eax
80106ee3:	5b                   	pop    %ebx
80106ee4:	5e                   	pop    %esi
80106ee5:	5d                   	pop    %ebp
80106ee6:	c3                   	ret
80106ee7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106eee:	00 
80106eef:	90                   	nop

80106ef0 <kvmalloc>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ef6:	e8 75 ff ff ff       	call   80106e70 <setupkvm>
80106efb:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f00:	05 00 00 00 80       	add    $0x80000000,%eax
80106f05:	0f 22 d8             	mov    %eax,%cr3
}
80106f08:	c9                   	leave
80106f09:	c3                   	ret
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f10 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	83 ec 08             	sub    $0x8,%esp
80106f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106f19:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106f1c:	89 c1                	mov    %eax,%ecx
80106f1e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106f21:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106f24:	f6 c2 01             	test   $0x1,%dl
80106f27:	75 17                	jne    80106f40 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f29:	83 ec 0c             	sub    $0xc,%esp
80106f2c:	68 9b 76 10 80       	push   $0x8010769b
80106f31:	e8 4a 94 ff ff       	call   80100380 <panic>
80106f36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f3d:	00 
80106f3e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80106f40:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f43:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f49:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f4e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106f55:	85 c0                	test   %eax,%eax
80106f57:	74 d0                	je     80106f29 <clearpteu+0x19>
  *pte &= ~PTE_U;
80106f59:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f5c:	c9                   	leave
80106f5d:	c3                   	ret
80106f5e:	66 90                	xchg   %ax,%ax

80106f60 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f69:	e8 02 ff ff ff       	call   80106e70 <setupkvm>
80106f6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f71:	85 c0                	test   %eax,%eax
80106f73:	0f 84 e9 00 00 00    	je     80107062 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f7c:	85 c9                	test   %ecx,%ecx
80106f7e:	0f 84 b2 00 00 00    	je     80107036 <copyuvm+0xd6>
80106f84:	31 f6                	xor    %esi,%esi
80106f86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f8d:	00 
80106f8e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80106f90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80106f93:	89 f0                	mov    %esi,%eax
80106f95:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106f98:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106f9b:	a8 01                	test   $0x1,%al
80106f9d:	75 11                	jne    80106fb0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106f9f:	83 ec 0c             	sub    $0xc,%esp
80106fa2:	68 a5 76 10 80       	push   $0x801076a5
80106fa7:	e8 d4 93 ff ff       	call   80100380 <panic>
80106fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80106fb0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106fb7:	c1 ea 0a             	shr    $0xa,%edx
80106fba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106fc0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106fc7:	85 c0                	test   %eax,%eax
80106fc9:	74 d4                	je     80106f9f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80106fcb:	8b 00                	mov    (%eax),%eax
80106fcd:	a8 01                	test   $0x1,%al
80106fcf:	0f 84 9f 00 00 00    	je     80107074 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106fd5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80106fd7:	25 ff 0f 00 00       	and    $0xfff,%eax
80106fdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106fdf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106fe5:	e8 c6 b6 ff ff       	call   801026b0 <kalloc>
80106fea:	89 c3                	mov    %eax,%ebx
80106fec:	85 c0                	test   %eax,%eax
80106fee:	74 64                	je     80107054 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ff0:	83 ec 04             	sub    $0x4,%esp
80106ff3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ff9:	68 00 10 00 00       	push   $0x1000
80106ffe:	57                   	push   %edi
80106fff:	50                   	push   %eax
80107000:	e8 7b d7 ff ff       	call   80104780 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107005:	58                   	pop    %eax
80107006:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010700c:	5a                   	pop    %edx
8010700d:	ff 75 e4             	push   -0x1c(%ebp)
80107010:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107015:	89 f2                	mov    %esi,%edx
80107017:	50                   	push   %eax
80107018:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010701b:	e8 90 f8 ff ff       	call   801068b0 <mappages>
80107020:	83 c4 10             	add    $0x10,%esp
80107023:	85 c0                	test   %eax,%eax
80107025:	78 21                	js     80107048 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107027:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010702d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107030:	0f 82 5a ff ff ff    	jb     80106f90 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107036:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107039:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703c:	5b                   	pop    %ebx
8010703d:	5e                   	pop    %esi
8010703e:	5f                   	pop    %edi
8010703f:	5d                   	pop    %ebp
80107040:	c3                   	ret
80107041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107048:	83 ec 0c             	sub    $0xc,%esp
8010704b:	53                   	push   %ebx
8010704c:	e8 9f b4 ff ff       	call   801024f0 <kfree>
      goto bad;
80107051:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107054:	83 ec 0c             	sub    $0xc,%esp
80107057:	ff 75 e0             	push   -0x20(%ebp)
8010705a:	e8 91 fd ff ff       	call   80106df0 <freevm>
  return 0;
8010705f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107062:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107069:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010706c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010706f:	5b                   	pop    %ebx
80107070:	5e                   	pop    %esi
80107071:	5f                   	pop    %edi
80107072:	5d                   	pop    %ebp
80107073:	c3                   	ret
      panic("copyuvm: page not present");
80107074:	83 ec 0c             	sub    $0xc,%esp
80107077:	68 bf 76 10 80       	push   $0x801076bf
8010707c:	e8 ff 92 ff ff       	call   80100380 <panic>
80107081:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107088:	00 
80107089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107090 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107096:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107099:	89 c1                	mov    %eax,%ecx
8010709b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010709e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801070a1:	f6 c2 01             	test   $0x1,%dl
801070a4:	0f 84 f8 00 00 00    	je     801071a2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801070aa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070ad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801070b3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801070b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801070b9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801070c0:	89 d0                	mov    %edx,%eax
801070c2:	f7 d2                	not    %edx
801070c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070c9:	05 00 00 00 80       	add    $0x80000000,%eax
801070ce:	83 e2 05             	and    $0x5,%edx
801070d1:	ba 00 00 00 00       	mov    $0x0,%edx
801070d6:	0f 45 c2             	cmovne %edx,%eax
}
801070d9:	c3                   	ret
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	8b 75 14             	mov    0x14(%ebp),%esi
801070ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801070ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070f2:	85 f6                	test   %esi,%esi
801070f4:	75 51                	jne    80107147 <copyout+0x67>
801070f6:	e9 9d 00 00 00       	jmp    80107198 <copyout+0xb8>
801070fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107100:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107106:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010710c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107112:	74 74                	je     80107188 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107114:	89 fb                	mov    %edi,%ebx
80107116:	29 c3                	sub    %eax,%ebx
80107118:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010711e:	39 f3                	cmp    %esi,%ebx
80107120:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107123:	29 f8                	sub    %edi,%eax
80107125:	83 ec 04             	sub    $0x4,%esp
80107128:	01 c1                	add    %eax,%ecx
8010712a:	53                   	push   %ebx
8010712b:	52                   	push   %edx
8010712c:	89 55 10             	mov    %edx,0x10(%ebp)
8010712f:	51                   	push   %ecx
80107130:	e8 4b d6 ff ff       	call   80104780 <memmove>
    len -= n;
    buf += n;
80107135:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107138:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010713e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107141:	01 da                	add    %ebx,%edx
  while(len > 0){
80107143:	29 de                	sub    %ebx,%esi
80107145:	74 51                	je     80107198 <copyout+0xb8>
  if(*pde & PTE_P){
80107147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010714a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010714c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010714e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107151:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107157:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010715a:	f6 c1 01             	test   $0x1,%cl
8010715d:	0f 84 46 00 00 00    	je     801071a9 <copyout.cold>
  return &pgtab[PTX(va)];
80107163:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107165:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010716b:	c1 eb 0c             	shr    $0xc,%ebx
8010716e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107174:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010717b:	89 d9                	mov    %ebx,%ecx
8010717d:	f7 d1                	not    %ecx
8010717f:	83 e1 05             	and    $0x5,%ecx
80107182:	0f 84 78 ff ff ff    	je     80107100 <copyout+0x20>
  }
  return 0;
}
80107188:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010718b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107190:	5b                   	pop    %ebx
80107191:	5e                   	pop    %esi
80107192:	5f                   	pop    %edi
80107193:	5d                   	pop    %ebp
80107194:	c3                   	ret
80107195:	8d 76 00             	lea    0x0(%esi),%esi
80107198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010719b:	31 c0                	xor    %eax,%eax
}
8010719d:	5b                   	pop    %ebx
8010719e:	5e                   	pop    %esi
8010719f:	5f                   	pop    %edi
801071a0:	5d                   	pop    %ebp
801071a1:	c3                   	ret

801071a2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801071a2:	a1 00 00 00 00       	mov    0x0,%eax
801071a7:	0f 0b                	ud2

801071a9 <copyout.cold>:
801071a9:	a1 00 00 00 00       	mov    0x0,%eax
801071ae:	0f 0b                	ud2
