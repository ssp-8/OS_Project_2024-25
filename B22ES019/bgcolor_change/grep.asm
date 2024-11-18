
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 6f                	jle    90 <main+0x90>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  21:	8b 43 04             	mov    0x4(%ebx),%eax
  24:	83 c3 08             	add    $0x8,%ebx

  if(argc <= 2){
  27:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  2b:	be 02 00 00 00       	mov    $0x2,%esi
  pattern = argv[1];
  30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(argc <= 2){
  33:	75 2d                	jne    62 <main+0x62>
  35:	eb 6c                	jmp    a3 <main+0xa3>
  37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  3e:	00 
  3f:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  40:	83 ec 08             	sub    $0x8,%esp
  for(i = 2; i < argc; i++){
  43:	83 c6 01             	add    $0x1,%esi
  46:	83 c3 04             	add    $0x4,%ebx
    grep(pattern, fd);
  49:	50                   	push   %eax
  4a:	ff 75 e0             	push   -0x20(%ebp)
  4d:	e8 9e 01 00 00       	call   1f0 <grep>
    close(fd);
  52:	89 3c 24             	mov    %edi,(%esp)
  55:	e8 b1 05 00 00       	call   60b <close>
  for(i = 2; i < argc; i++){
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  60:	7e 29                	jle    8b <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
  62:	83 ec 08             	sub    $0x8,%esp
  65:	6a 00                	push   $0x0
  67:	ff 33                	push   (%ebx)
  69:	e8 b5 05 00 00       	call   623 <open>
  6e:	83 c4 10             	add    $0x10,%esp
  71:	89 c7                	mov    %eax,%edi
  73:	85 c0                	test   %eax,%eax
  75:	79 c9                	jns    40 <main+0x40>
      printf(1, "grep: cannot open %s\n", argv[i]);
  77:	50                   	push   %eax
  78:	ff 33                	push   (%ebx)
  7a:	68 58 0a 00 00       	push   $0xa58
  7f:	6a 01                	push   $0x1
  81:	e8 aa 06 00 00       	call   730 <printf>
      exit();
  86:	e8 58 05 00 00       	call   5e3 <exit>
  }
  exit();
  8b:	e8 53 05 00 00       	call   5e3 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  90:	51                   	push   %ecx
  91:	51                   	push   %ecx
  92:	68 38 0a 00 00       	push   $0xa38
  97:	6a 02                	push   $0x2
  99:	e8 92 06 00 00       	call   730 <printf>
    exit();
  9e:	e8 40 05 00 00       	call   5e3 <exit>
    grep(pattern, 0);
  a3:	52                   	push   %edx
  a4:	52                   	push   %edx
  a5:	6a 00                	push   $0x0
  a7:	50                   	push   %eax
  a8:	e8 43 01 00 00       	call   1f0 <grep>
    exit();
  ad:	e8 31 05 00 00       	call   5e3 <exit>
  b2:	66 90                	xchg   %ax,%ax
  b4:	66 90                	xchg   %ax,%ax
  b6:	66 90                	xchg   %ax,%ax
  b8:	66 90                	xchg   %ax,%ax
  ba:	66 90                	xchg   %ax,%ax
  bc:	66 90                	xchg   %ax,%ax
  be:	66 90                	xchg   %ax,%ax

000000c0 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	56                   	push   %esi
  c5:	53                   	push   %ebx
  c6:	83 ec 0c             	sub    $0xc,%esp
  c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '\0')
  cf:	0f b6 0f             	movzbl (%edi),%ecx
  d2:	84 c9                	test   %cl,%cl
  d4:	0f 84 96 00 00 00    	je     170 <matchhere+0xb0>
    return 1;
  if(re[1] == '*')
  da:	0f b6 47 01          	movzbl 0x1(%edi),%eax
  de:	3c 2a                	cmp    $0x2a,%al
  e0:	74 2d                	je     10f <matchhere+0x4f>
  e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  e8:	0f b6 33             	movzbl (%ebx),%esi
  if(re[0] == '$' && re[1] == '\0')
  eb:	80 f9 24             	cmp    $0x24,%cl
  ee:	74 50                	je     140 <matchhere+0x80>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  f0:	89 f2                	mov    %esi,%edx
  f2:	84 d2                	test   %dl,%dl
  f4:	74 6e                	je     164 <matchhere+0xa4>
  f6:	80 f9 2e             	cmp    $0x2e,%cl
  f9:	75 65                	jne    160 <matchhere+0xa0>
    return matchhere(re+1, text+1);
  fb:	83 c3 01             	add    $0x1,%ebx
  fe:	83 c7 01             	add    $0x1,%edi
  if(re[0] == '\0')
 101:	84 c0                	test   %al,%al
 103:	74 6b                	je     170 <matchhere+0xb0>
{
 105:	89 c1                	mov    %eax,%ecx
  if(re[1] == '*')
 107:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 10b:	3c 2a                	cmp    $0x2a,%al
 10d:	75 d9                	jne    e8 <matchhere+0x28>
    return matchstar(re[0], re+2, text);
 10f:	8d 77 02             	lea    0x2(%edi),%esi
 112:	0f be f9             	movsbl %cl,%edi
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
 115:	8d 76 00             	lea    0x0(%esi),%esi
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	53                   	push   %ebx
 11c:	56                   	push   %esi
 11d:	e8 9e ff ff ff       	call   c0 <matchhere>
 122:	83 c4 10             	add    $0x10,%esp
 125:	85 c0                	test   %eax,%eax
 127:	75 47                	jne    170 <matchhere+0xb0>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
 129:	0f be 13             	movsbl (%ebx),%edx
 12c:	84 d2                	test   %dl,%dl
 12e:	74 45                	je     175 <matchhere+0xb5>
 130:	83 c3 01             	add    $0x1,%ebx
 133:	39 fa                	cmp    %edi,%edx
 135:	74 e1                	je     118 <matchhere+0x58>
 137:	83 ff 2e             	cmp    $0x2e,%edi
 13a:	74 dc                	je     118 <matchhere+0x58>
 13c:	eb 37                	jmp    175 <matchhere+0xb5>
 13e:	66 90                	xchg   %ax,%ax
  if(re[0] == '$' && re[1] == '\0')
 140:	84 c0                	test   %al,%al
 142:	74 39                	je     17d <matchhere+0xbd>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 144:	89 f2                	mov    %esi,%edx
 146:	84 d2                	test   %dl,%dl
 148:	74 1a                	je     164 <matchhere+0xa4>
 14a:	80 fa 24             	cmp    $0x24,%dl
 14d:	75 15                	jne    164 <matchhere+0xa4>
    return matchhere(re+1, text+1);
 14f:	83 c3 01             	add    $0x1,%ebx
 152:	83 c7 01             	add    $0x1,%edi
{
 155:	89 c1                	mov    %eax,%ecx
 157:	eb ae                	jmp    107 <matchhere+0x47>
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 160:	38 ca                	cmp    %cl,%dl
 162:	74 97                	je     fb <matchhere+0x3b>
}
 164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
 167:	31 c0                	xor    %eax,%eax
}
 169:	5b                   	pop    %ebx
 16a:	5e                   	pop    %esi
 16b:	5f                   	pop    %edi
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret
 16e:	66 90                	xchg   %ax,%ax
    return 1;
 170:	b8 01 00 00 00       	mov    $0x1,%eax
}
 175:	8d 65 f4             	lea    -0xc(%ebp),%esp
 178:	5b                   	pop    %ebx
 179:	5e                   	pop    %esi
 17a:	5f                   	pop    %edi
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret
    return *text == '\0';
 17d:	89 f0                	mov    %esi,%eax
 17f:	84 c0                	test   %al,%al
 181:	0f 94 c0             	sete   %al
 184:	0f b6 c0             	movzbl %al,%eax
 187:	eb ec                	jmp    175 <matchhere+0xb5>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <match>:
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	8b 5d 08             	mov    0x8(%ebp),%ebx
 198:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
 19b:	80 3b 5e             	cmpb   $0x5e,(%ebx)
 19e:	75 11                	jne    1b1 <match+0x21>
 1a0:	eb 2e                	jmp    1d0 <match+0x40>
 1a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }while(*text++ != '\0');
 1a8:	83 c6 01             	add    $0x1,%esi
 1ab:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 1af:	74 16                	je     1c7 <match+0x37>
    if(matchhere(re, text))
 1b1:	83 ec 08             	sub    $0x8,%esp
 1b4:	56                   	push   %esi
 1b5:	53                   	push   %ebx
 1b6:	e8 05 ff ff ff       	call   c0 <matchhere>
 1bb:	83 c4 10             	add    $0x10,%esp
 1be:	85 c0                	test   %eax,%eax
 1c0:	74 e6                	je     1a8 <match+0x18>
      return 1;
 1c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ca:	5b                   	pop    %ebx
 1cb:	5e                   	pop    %esi
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret
 1ce:	66 90                	xchg   %ax,%ax
    return matchhere(re+1, text);
 1d0:	83 c3 01             	add    $0x1,%ebx
 1d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 1d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 1dc:	e9 df fe ff ff       	jmp    c0 <matchhere>
 1e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1e8:	00 
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001f0 <grep>:
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
  m = 0;
 1f4:	31 ff                	xor    %edi,%edi
{
 1f6:	56                   	push   %esi
 1f7:	53                   	push   %ebx
 1f8:	83 ec 1c             	sub    $0x1c,%esp
 1fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1fe:	89 7d e0             	mov    %edi,-0x20(%ebp)
    return matchhere(re+1, text);
 201:	8d 43 01             	lea    0x1(%ebx),%eax
 204:	89 45 dc             	mov    %eax,-0x24(%ebp)
 207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20e:	00 
 20f:	90                   	nop
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 210:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 213:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 218:	83 ec 04             	sub    $0x4,%esp
 21b:	29 c8                	sub    %ecx,%eax
 21d:	50                   	push   %eax
 21e:	8d 81 60 0e 00 00    	lea    0xe60(%ecx),%eax
 224:	50                   	push   %eax
 225:	ff 75 0c             	push   0xc(%ebp)
 228:	e8 ce 03 00 00       	call   5fb <read>
 22d:	83 c4 10             	add    $0x10,%esp
 230:	85 c0                	test   %eax,%eax
 232:	0f 8e fd 00 00 00    	jle    335 <grep+0x145>
    m += n;
 238:	01 45 e0             	add    %eax,-0x20(%ebp)
 23b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    buf[m] = '\0';
 23e:	bf 60 0e 00 00       	mov    $0xe60,%edi
 243:	89 de                	mov    %ebx,%esi
 245:	c6 81 60 0e 00 00 00 	movb   $0x0,0xe60(%ecx)
    while((q = strchr(p, '\n')) != 0){
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	83 ec 08             	sub    $0x8,%esp
 253:	6a 0a                	push   $0xa
 255:	57                   	push   %edi
 256:	e8 25 02 00 00       	call   480 <strchr>
 25b:	83 c4 10             	add    $0x10,%esp
 25e:	89 c2                	mov    %eax,%edx
 260:	85 c0                	test   %eax,%eax
 262:	0f 84 88 00 00 00    	je     2f0 <grep+0x100>
      *q = 0;
 268:	c6 02 00             	movb   $0x0,(%edx)
  if(re[0] == '^')
 26b:	80 3e 5e             	cmpb   $0x5e,(%esi)
 26e:	74 58                	je     2c8 <grep+0xd8>
 270:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 273:	89 d3                	mov    %edx,%ebx
 275:	eb 12                	jmp    289 <grep+0x99>
 277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27e:	00 
 27f:	90                   	nop
  }while(*text++ != '\0');
 280:	83 c7 01             	add    $0x1,%edi
 283:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
 287:	74 37                	je     2c0 <grep+0xd0>
    if(matchhere(re, text))
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	57                   	push   %edi
 28d:	56                   	push   %esi
 28e:	e8 2d fe ff ff       	call   c0 <matchhere>
 293:	83 c4 10             	add    $0x10,%esp
 296:	85 c0                	test   %eax,%eax
 298:	74 e6                	je     280 <grep+0x90>
        write(1, p, q+1 - p);
 29a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 29d:	89 da                	mov    %ebx,%edx
 29f:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2a2:	89 d8                	mov    %ebx,%eax
 2a4:	83 ec 04             	sub    $0x4,%esp
        *q = '\n';
 2a7:	c6 02 0a             	movb   $0xa,(%edx)
        write(1, p, q+1 - p);
 2aa:	29 f8                	sub    %edi,%eax
 2ac:	50                   	push   %eax
 2ad:	57                   	push   %edi
 2ae:	89 df                	mov    %ebx,%edi
 2b0:	6a 01                	push   $0x1
 2b2:	e8 4c 03 00 00       	call   603 <write>
 2b7:	83 c4 10             	add    $0x10,%esp
 2ba:	eb 94                	jmp    250 <grep+0x60>
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c0:	8d 7b 01             	lea    0x1(%ebx),%edi
      p = q+1;
 2c3:	eb 8b                	jmp    250 <grep+0x60>
 2c5:	8d 76 00             	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 2ce:	57                   	push   %edi
 2cf:	ff 75 dc             	push   -0x24(%ebp)
 2d2:	e8 e9 fd ff ff       	call   c0 <matchhere>
        write(1, p, q+1 - p);
 2d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return matchhere(re+1, text);
 2da:	83 c4 10             	add    $0x10,%esp
        write(1, p, q+1 - p);
 2dd:	8d 5a 01             	lea    0x1(%edx),%ebx
      if(match(pattern, p)){
 2e0:	85 c0                	test   %eax,%eax
 2e2:	75 be                	jne    2a2 <grep+0xb2>
        write(1, p, q+1 - p);
 2e4:	89 df                	mov    %ebx,%edi
 2e6:	e9 65 ff ff ff       	jmp    250 <grep+0x60>
 2eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p == buf)
 2f0:	89 f3                	mov    %esi,%ebx
 2f2:	81 ff 60 0e 00 00    	cmp    $0xe60,%edi
 2f8:	74 2f                	je     329 <grep+0x139>
    if(m > 0){
 2fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
 2fd:	85 c0                	test   %eax,%eax
 2ff:	0f 8e 0b ff ff ff    	jle    210 <grep+0x20>
      m -= p - buf;
 305:	89 f8                	mov    %edi,%eax
      memmove(buf, p, m);
 307:	83 ec 04             	sub    $0x4,%esp
      m -= p - buf;
 30a:	2d 60 0e 00 00       	sub    $0xe60,%eax
 30f:	29 45 e0             	sub    %eax,-0x20(%ebp)
 312:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      memmove(buf, p, m);
 315:	51                   	push   %ecx
 316:	57                   	push   %edi
 317:	68 60 0e 00 00       	push   $0xe60
 31c:	e8 8f 02 00 00       	call   5b0 <memmove>
 321:	83 c4 10             	add    $0x10,%esp
 324:	e9 e7 fe ff ff       	jmp    210 <grep+0x20>
      m = 0;
 329:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 330:	e9 db fe ff ff       	jmp    210 <grep+0x20>
}
 335:	8d 65 f4             	lea    -0xc(%ebp),%esp
 338:	5b                   	pop    %ebx
 339:	5e                   	pop    %esi
 33a:	5f                   	pop    %edi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret
 33d:	8d 76 00             	lea    0x0(%esi),%esi

00000340 <matchstar>:
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
 345:	53                   	push   %ebx
 346:	83 ec 0c             	sub    $0xc,%esp
 349:	8b 5d 08             	mov    0x8(%ebp),%ebx
 34c:	8b 75 0c             	mov    0xc(%ebp),%esi
 34f:	8b 7d 10             	mov    0x10(%ebp),%edi
 352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(matchhere(re, text))
 358:	83 ec 08             	sub    $0x8,%esp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	e8 5e fd ff ff       	call   c0 <matchhere>
 362:	83 c4 10             	add    $0x10,%esp
 365:	85 c0                	test   %eax,%eax
 367:	75 1f                	jne    388 <matchstar+0x48>
  }while(*text!='\0' && (*text++==c || c=='.'));
 369:	0f be 17             	movsbl (%edi),%edx
 36c:	84 d2                	test   %dl,%dl
 36e:	74 0c                	je     37c <matchstar+0x3c>
 370:	83 c7 01             	add    $0x1,%edi
 373:	83 fb 2e             	cmp    $0x2e,%ebx
 376:	74 e0                	je     358 <matchstar+0x18>
 378:	39 da                	cmp    %ebx,%edx
 37a:	74 dc                	je     358 <matchstar+0x18>
}
 37c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37f:	5b                   	pop    %ebx
 380:	5e                   	pop    %esi
 381:	5f                   	pop    %edi
 382:	5d                   	pop    %ebp
 383:	c3                   	ret
 384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 388:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 1;
 38b:	b8 01 00 00 00       	mov    $0x1,%eax
}
 390:	5b                   	pop    %ebx
 391:	5e                   	pop    %esi
 392:	5f                   	pop    %edi
 393:	5d                   	pop    %ebp
 394:	c3                   	ret
 395:	66 90                	xchg   %ax,%ax
 397:	66 90                	xchg   %ax,%ax
 399:	66 90                	xchg   %ax,%ax
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3a1:	31 c0                	xor    %eax,%eax
{
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	53                   	push   %ebx
 3a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 3b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 3b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 3b7:	83 c0 01             	add    $0x1,%eax
 3ba:	84 d2                	test   %dl,%dl
 3bc:	75 f2                	jne    3b0 <strcpy+0x10>
    ;
  return os;
}
 3be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3c1:	89 c8                	mov    %ecx,%eax
 3c3:	c9                   	leave
 3c4:	c3                   	ret
 3c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3cc:	00 
 3cd:	8d 76 00             	lea    0x0(%esi),%esi

000003d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	53                   	push   %ebx
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
 3d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3da:	0f b6 02             	movzbl (%edx),%eax
 3dd:	84 c0                	test   %al,%al
 3df:	75 17                	jne    3f8 <strcmp+0x28>
 3e1:	eb 3a                	jmp    41d <strcmp+0x4d>
 3e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 3e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 3ec:	83 c2 01             	add    $0x1,%edx
 3ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 3f2:	84 c0                	test   %al,%al
 3f4:	74 1a                	je     410 <strcmp+0x40>
 3f6:	89 d9                	mov    %ebx,%ecx
 3f8:	0f b6 19             	movzbl (%ecx),%ebx
 3fb:	38 c3                	cmp    %al,%bl
 3fd:	74 e9                	je     3e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 3ff:	29 d8                	sub    %ebx,%eax
}
 401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 404:	c9                   	leave
 405:	c3                   	ret
 406:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 40d:	00 
 40e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 410:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 414:	31 c0                	xor    %eax,%eax
 416:	29 d8                	sub    %ebx,%eax
}
 418:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 41b:	c9                   	leave
 41c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 41d:	0f b6 19             	movzbl (%ecx),%ebx
 420:	31 c0                	xor    %eax,%eax
 422:	eb db                	jmp    3ff <strcmp+0x2f>
 424:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42b:	00 
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <strlen>:

uint
strlen(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 436:	80 3a 00             	cmpb   $0x0,(%edx)
 439:	74 15                	je     450 <strlen+0x20>
 43b:	31 c0                	xor    %eax,%eax
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	83 c0 01             	add    $0x1,%eax
 443:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 447:	89 c1                	mov    %eax,%ecx
 449:	75 f5                	jne    440 <strlen+0x10>
    ;
  return n;
}
 44b:	89 c8                	mov    %ecx,%eax
 44d:	5d                   	pop    %ebp
 44e:	c3                   	ret
 44f:	90                   	nop
  for(n = 0; s[n]; n++)
 450:	31 c9                	xor    %ecx,%ecx
}
 452:	5d                   	pop    %ebp
 453:	89 c8                	mov    %ecx,%eax
 455:	c3                   	ret
 456:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 45d:	00 
 45e:	66 90                	xchg   %ax,%ax

00000460 <memset>:

void*
memset(void *dst, int c, uint n)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 467:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	89 d7                	mov    %edx,%edi
 46f:	fc                   	cld
 470:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 472:	8b 7d fc             	mov    -0x4(%ebp),%edi
 475:	89 d0                	mov    %edx,%eax
 477:	c9                   	leave
 478:	c3                   	ret
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000480 <strchr>:

char*
strchr(const char *s, char c)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 48a:	0f b6 10             	movzbl (%eax),%edx
 48d:	84 d2                	test   %dl,%dl
 48f:	75 12                	jne    4a3 <strchr+0x23>
 491:	eb 1d                	jmp    4b0 <strchr+0x30>
 493:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 498:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 49c:	83 c0 01             	add    $0x1,%eax
 49f:	84 d2                	test   %dl,%dl
 4a1:	74 0d                	je     4b0 <strchr+0x30>
    if(*s == c)
 4a3:	38 d1                	cmp    %dl,%cl
 4a5:	75 f1                	jne    498 <strchr+0x18>
      return (char*)s;
  return 0;
}
 4a7:	5d                   	pop    %ebp
 4a8:	c3                   	ret
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 4b0:	31 c0                	xor    %eax,%eax
}
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret
 4b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4bb:	00 
 4bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004c0 <gets>:

char*
gets(char *buf, int max)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 4c5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 4c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 4c9:	31 db                	xor    %ebx,%ebx
{
 4cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 4ce:	eb 27                	jmp    4f7 <gets+0x37>
    cc = read(0, &c, 1);
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	6a 01                	push   $0x1
 4d5:	56                   	push   %esi
 4d6:	6a 00                	push   $0x0
 4d8:	e8 1e 01 00 00       	call   5fb <read>
    if(cc < 1)
 4dd:	83 c4 10             	add    $0x10,%esp
 4e0:	85 c0                	test   %eax,%eax
 4e2:	7e 1d                	jle    501 <gets+0x41>
      break;
    buf[i++] = c;
 4e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4e8:	8b 55 08             	mov    0x8(%ebp),%edx
 4eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 4ef:	3c 0a                	cmp    $0xa,%al
 4f1:	74 10                	je     503 <gets+0x43>
 4f3:	3c 0d                	cmp    $0xd,%al
 4f5:	74 0c                	je     503 <gets+0x43>
  for(i=0; i+1 < max; ){
 4f7:	89 df                	mov    %ebx,%edi
 4f9:	83 c3 01             	add    $0x1,%ebx
 4fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4ff:	7c cf                	jl     4d0 <gets+0x10>
 501:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 50a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50d:	5b                   	pop    %ebx
 50e:	5e                   	pop    %esi
 50f:	5f                   	pop    %edi
 510:	5d                   	pop    %ebp
 511:	c3                   	ret
 512:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 519:	00 
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000520 <stat>:

int
stat(const char *n, struct stat *st)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	56                   	push   %esi
 524:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 525:	83 ec 08             	sub    $0x8,%esp
 528:	6a 00                	push   $0x0
 52a:	ff 75 08             	push   0x8(%ebp)
 52d:	e8 f1 00 00 00       	call   623 <open>
  if(fd < 0)
 532:	83 c4 10             	add    $0x10,%esp
 535:	85 c0                	test   %eax,%eax
 537:	78 27                	js     560 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	ff 75 0c             	push   0xc(%ebp)
 53f:	89 c3                	mov    %eax,%ebx
 541:	50                   	push   %eax
 542:	e8 f4 00 00 00       	call   63b <fstat>
  close(fd);
 547:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 54a:	89 c6                	mov    %eax,%esi
  close(fd);
 54c:	e8 ba 00 00 00       	call   60b <close>
  return r;
 551:	83 c4 10             	add    $0x10,%esp
}
 554:	8d 65 f8             	lea    -0x8(%ebp),%esp
 557:	89 f0                	mov    %esi,%eax
 559:	5b                   	pop    %ebx
 55a:	5e                   	pop    %esi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret
 55d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 560:	be ff ff ff ff       	mov    $0xffffffff,%esi
 565:	eb ed                	jmp    554 <stat+0x34>
 567:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 56e:	00 
 56f:	90                   	nop

00000570 <atoi>:

int
atoi(const char *s)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	53                   	push   %ebx
 574:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 577:	0f be 02             	movsbl (%edx),%eax
 57a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 57d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 580:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 585:	77 1e                	ja     5a5 <atoi+0x35>
 587:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 58e:	00 
 58f:	90                   	nop
    n = n*10 + *s++ - '0';
 590:	83 c2 01             	add    $0x1,%edx
 593:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 596:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 59a:	0f be 02             	movsbl (%edx),%eax
 59d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 5a0:	80 fb 09             	cmp    $0x9,%bl
 5a3:	76 eb                	jbe    590 <atoi+0x20>
  return n;
}
 5a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a8:	89 c8                	mov    %ecx,%eax
 5aa:	c9                   	leave
 5ab:	c3                   	ret
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	8b 45 10             	mov    0x10(%ebp),%eax
 5b7:	8b 55 08             	mov    0x8(%ebp),%edx
 5ba:	56                   	push   %esi
 5bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5be:	85 c0                	test   %eax,%eax
 5c0:	7e 13                	jle    5d5 <memmove+0x25>
 5c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 5c4:	89 d7                	mov    %edx,%edi
 5c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5cd:	00 
 5ce:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 5d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5d1:	39 f8                	cmp    %edi,%eax
 5d3:	75 fb                	jne    5d0 <memmove+0x20>
  return vdst;
}
 5d5:	5e                   	pop    %esi
 5d6:	89 d0                	mov    %edx,%eax
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret

000005db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5db:	b8 01 00 00 00       	mov    $0x1,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret

000005e3 <exit>:
SYSCALL(exit)
 5e3:	b8 02 00 00 00       	mov    $0x2,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret

000005eb <wait>:
SYSCALL(wait)
 5eb:	b8 03 00 00 00       	mov    $0x3,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret

000005f3 <pipe>:
SYSCALL(pipe)
 5f3:	b8 04 00 00 00       	mov    $0x4,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret

000005fb <read>:
SYSCALL(read)
 5fb:	b8 05 00 00 00       	mov    $0x5,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret

00000603 <write>:
SYSCALL(write)
 603:	b8 10 00 00 00       	mov    $0x10,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret

0000060b <close>:
SYSCALL(close)
 60b:	b8 15 00 00 00       	mov    $0x15,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret

00000613 <kill>:
SYSCALL(kill)
 613:	b8 06 00 00 00       	mov    $0x6,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret

0000061b <exec>:
SYSCALL(exec)
 61b:	b8 07 00 00 00       	mov    $0x7,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret

00000623 <open>:
SYSCALL(open)
 623:	b8 0f 00 00 00       	mov    $0xf,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret

0000062b <mknod>:
SYSCALL(mknod)
 62b:	b8 11 00 00 00       	mov    $0x11,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret

00000633 <unlink>:
SYSCALL(unlink)
 633:	b8 12 00 00 00       	mov    $0x12,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret

0000063b <fstat>:
SYSCALL(fstat)
 63b:	b8 08 00 00 00       	mov    $0x8,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret

00000643 <link>:
SYSCALL(link)
 643:	b8 13 00 00 00       	mov    $0x13,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret

0000064b <mkdir>:
SYSCALL(mkdir)
 64b:	b8 14 00 00 00       	mov    $0x14,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret

00000653 <chdir>:
SYSCALL(chdir)
 653:	b8 09 00 00 00       	mov    $0x9,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret

0000065b <dup>:
SYSCALL(dup)
 65b:	b8 0a 00 00 00       	mov    $0xa,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret

00000663 <getpid>:
SYSCALL(getpid)
 663:	b8 0b 00 00 00       	mov    $0xb,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret

0000066b <sbrk>:
SYSCALL(sbrk)
 66b:	b8 0c 00 00 00       	mov    $0xc,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret

00000673 <sleep>:
SYSCALL(sleep)
 673:	b8 0d 00 00 00       	mov    $0xd,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret

0000067b <uptime>:
SYSCALL(uptime)
 67b:	b8 0e 00 00 00       	mov    $0xe,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret
 683:	66 90                	xchg   %ax,%ax
 685:	66 90                	xchg   %ax,%ax
 687:	66 90                	xchg   %ax,%ax
 689:	66 90                	xchg   %ax,%ax
 68b:	66 90                	xchg   %ax,%ax
 68d:	66 90                	xchg   %ax,%ax
 68f:	90                   	nop

00000690 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 698:	89 d1                	mov    %edx,%ecx
{
 69a:	83 ec 3c             	sub    $0x3c,%esp
 69d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 6a0:	85 d2                	test   %edx,%edx
 6a2:	0f 89 80 00 00 00    	jns    728 <printint+0x98>
 6a8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6ac:	74 7a                	je     728 <printint+0x98>
    x = -xx;
 6ae:	f7 d9                	neg    %ecx
    neg = 1;
 6b0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 6b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 6b8:	31 f6                	xor    %esi,%esi
 6ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6c0:	89 c8                	mov    %ecx,%eax
 6c2:	31 d2                	xor    %edx,%edx
 6c4:	89 f7                	mov    %esi,%edi
 6c6:	f7 f3                	div    %ebx
 6c8:	8d 76 01             	lea    0x1(%esi),%esi
 6cb:	0f b6 92 d0 0a 00 00 	movzbl 0xad0(%edx),%edx
 6d2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 6d6:	89 ca                	mov    %ecx,%edx
 6d8:	89 c1                	mov    %eax,%ecx
 6da:	39 da                	cmp    %ebx,%edx
 6dc:	73 e2                	jae    6c0 <printint+0x30>
  if(neg)
 6de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6e1:	85 c0                	test   %eax,%eax
 6e3:	74 07                	je     6ec <printint+0x5c>
    buf[i++] = '-';
 6e5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 6ea:	89 f7                	mov    %esi,%edi
 6ec:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 6ef:	8b 75 c0             	mov    -0x40(%ebp),%esi
 6f2:	01 df                	add    %ebx,%edi
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 6f8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	88 45 d7             	mov    %al,-0x29(%ebp)
 701:	8d 45 d7             	lea    -0x29(%ebp),%eax
 704:	6a 01                	push   $0x1
 706:	50                   	push   %eax
 707:	56                   	push   %esi
 708:	e8 f6 fe ff ff       	call   603 <write>
  while(--i >= 0)
 70d:	89 f8                	mov    %edi,%eax
 70f:	83 c4 10             	add    $0x10,%esp
 712:	83 ef 01             	sub    $0x1,%edi
 715:	39 c3                	cmp    %eax,%ebx
 717:	75 df                	jne    6f8 <printint+0x68>
}
 719:	8d 65 f4             	lea    -0xc(%ebp),%esp
 71c:	5b                   	pop    %ebx
 71d:	5e                   	pop    %esi
 71e:	5f                   	pop    %edi
 71f:	5d                   	pop    %ebp
 720:	c3                   	ret
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 728:	31 c0                	xor    %eax,%eax
 72a:	eb 89                	jmp    6b5 <printint+0x25>
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 739:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 73c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 73f:	0f b6 1e             	movzbl (%esi),%ebx
 742:	83 c6 01             	add    $0x1,%esi
 745:	84 db                	test   %bl,%bl
 747:	74 67                	je     7b0 <printf+0x80>
 749:	8d 4d 10             	lea    0x10(%ebp),%ecx
 74c:	31 d2                	xor    %edx,%edx
 74e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 751:	eb 34                	jmp    787 <printf+0x57>
 753:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 758:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 75b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 760:	83 f8 25             	cmp    $0x25,%eax
 763:	74 18                	je     77d <printf+0x4d>
  write(fd, &c, 1);
 765:	83 ec 04             	sub    $0x4,%esp
 768:	8d 45 e7             	lea    -0x19(%ebp),%eax
 76b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 76e:	6a 01                	push   $0x1
 770:	50                   	push   %eax
 771:	57                   	push   %edi
 772:	e8 8c fe ff ff       	call   603 <write>
 777:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 77a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 77d:	0f b6 1e             	movzbl (%esi),%ebx
 780:	83 c6 01             	add    $0x1,%esi
 783:	84 db                	test   %bl,%bl
 785:	74 29                	je     7b0 <printf+0x80>
    c = fmt[i] & 0xff;
 787:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 78a:	85 d2                	test   %edx,%edx
 78c:	74 ca                	je     758 <printf+0x28>
      }
    } else if(state == '%'){
 78e:	83 fa 25             	cmp    $0x25,%edx
 791:	75 ea                	jne    77d <printf+0x4d>
      if(c == 'd'){
 793:	83 f8 25             	cmp    $0x25,%eax
 796:	0f 84 04 01 00 00    	je     8a0 <printf+0x170>
 79c:	83 e8 63             	sub    $0x63,%eax
 79f:	83 f8 15             	cmp    $0x15,%eax
 7a2:	77 1c                	ja     7c0 <printf+0x90>
 7a4:	ff 24 85 78 0a 00 00 	jmp    *0xa78(,%eax,4)
 7ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7b3:	5b                   	pop    %ebx
 7b4:	5e                   	pop    %esi
 7b5:	5f                   	pop    %edi
 7b6:	5d                   	pop    %ebp
 7b7:	c3                   	ret
 7b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7bf:	00 
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7c6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7ca:	6a 01                	push   $0x1
 7cc:	52                   	push   %edx
 7cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 7d0:	57                   	push   %edi
 7d1:	e8 2d fe ff ff       	call   603 <write>
 7d6:	83 c4 0c             	add    $0xc,%esp
 7d9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7dc:	6a 01                	push   $0x1
 7de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 7e1:	52                   	push   %edx
 7e2:	57                   	push   %edi
 7e3:	e8 1b fe ff ff       	call   603 <write>
        putc(fd, c);
 7e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7eb:	31 d2                	xor    %edx,%edx
 7ed:	eb 8e                	jmp    77d <printf+0x4d>
 7ef:	90                   	nop
        printint(fd, *ap, 16, 0);
 7f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7f3:	83 ec 0c             	sub    $0xc,%esp
 7f6:	b9 10 00 00 00       	mov    $0x10,%ecx
 7fb:	8b 13                	mov    (%ebx),%edx
 7fd:	6a 00                	push   $0x0
 7ff:	89 f8                	mov    %edi,%eax
        ap++;
 801:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 804:	e8 87 fe ff ff       	call   690 <printint>
        ap++;
 809:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 80c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 80f:	31 d2                	xor    %edx,%edx
 811:	e9 67 ff ff ff       	jmp    77d <printf+0x4d>
        s = (char*)*ap;
 816:	8b 45 d0             	mov    -0x30(%ebp),%eax
 819:	8b 18                	mov    (%eax),%ebx
        ap++;
 81b:	83 c0 04             	add    $0x4,%eax
 81e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 821:	85 db                	test   %ebx,%ebx
 823:	0f 84 87 00 00 00    	je     8b0 <printf+0x180>
        while(*s != 0){
 829:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 82c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 82e:	84 c0                	test   %al,%al
 830:	0f 84 47 ff ff ff    	je     77d <printf+0x4d>
 836:	8d 55 e7             	lea    -0x19(%ebp),%edx
 839:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 83c:	89 de                	mov    %ebx,%esi
 83e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 840:	83 ec 04             	sub    $0x4,%esp
 843:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 846:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 849:	6a 01                	push   $0x1
 84b:	53                   	push   %ebx
 84c:	57                   	push   %edi
 84d:	e8 b1 fd ff ff       	call   603 <write>
        while(*s != 0){
 852:	0f b6 06             	movzbl (%esi),%eax
 855:	83 c4 10             	add    $0x10,%esp
 858:	84 c0                	test   %al,%al
 85a:	75 e4                	jne    840 <printf+0x110>
      state = 0;
 85c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 85f:	31 d2                	xor    %edx,%edx
 861:	e9 17 ff ff ff       	jmp    77d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 866:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 869:	83 ec 0c             	sub    $0xc,%esp
 86c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 871:	8b 13                	mov    (%ebx),%edx
 873:	6a 01                	push   $0x1
 875:	eb 88                	jmp    7ff <printf+0xcf>
        putc(fd, *ap);
 877:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 87a:	83 ec 04             	sub    $0x4,%esp
 87d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 880:	8b 03                	mov    (%ebx),%eax
        ap++;
 882:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 885:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 888:	6a 01                	push   $0x1
 88a:	52                   	push   %edx
 88b:	57                   	push   %edi
 88c:	e8 72 fd ff ff       	call   603 <write>
        ap++;
 891:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 894:	83 c4 10             	add    $0x10,%esp
      state = 0;
 897:	31 d2                	xor    %edx,%edx
 899:	e9 df fe ff ff       	jmp    77d <printf+0x4d>
 89e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 8a0:	83 ec 04             	sub    $0x4,%esp
 8a3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 8a6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 8a9:	6a 01                	push   $0x1
 8ab:	e9 31 ff ff ff       	jmp    7e1 <printf+0xb1>
 8b0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 8b5:	bb 6e 0a 00 00       	mov    $0xa6e,%ebx
 8ba:	e9 77 ff ff ff       	jmp    836 <printf+0x106>
 8bf:	90                   	nop

000008c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	a1 60 12 00 00       	mov    0x1260,%eax
{
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	57                   	push   %edi
 8c9:	56                   	push   %esi
 8ca:	53                   	push   %ebx
 8cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	39 c8                	cmp    %ecx,%eax
 8dc:	73 32                	jae    910 <free+0x50>
 8de:	39 d1                	cmp    %edx,%ecx
 8e0:	72 04                	jb     8e6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e2:	39 d0                	cmp    %edx,%eax
 8e4:	72 32                	jb     918 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8e9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ec:	39 fa                	cmp    %edi,%edx
 8ee:	74 30                	je     920 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8f3:	8b 50 04             	mov    0x4(%eax),%edx
 8f6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8f9:	39 f1                	cmp    %esi,%ecx
 8fb:	74 3a                	je     937 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8fd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8ff:	5b                   	pop    %ebx
  freep = p;
 900:	a3 60 12 00 00       	mov    %eax,0x1260
}
 905:	5e                   	pop    %esi
 906:	5f                   	pop    %edi
 907:	5d                   	pop    %ebp
 908:	c3                   	ret
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	39 d0                	cmp    %edx,%eax
 912:	72 04                	jb     918 <free+0x58>
 914:	39 d1                	cmp    %edx,%ecx
 916:	72 ce                	jb     8e6 <free+0x26>
{
 918:	89 d0                	mov    %edx,%eax
 91a:	eb bc                	jmp    8d8 <free+0x18>
 91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 920:	03 72 04             	add    0x4(%edx),%esi
 923:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 926:	8b 10                	mov    (%eax),%edx
 928:	8b 12                	mov    (%edx),%edx
 92a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 92d:	8b 50 04             	mov    0x4(%eax),%edx
 930:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 933:	39 f1                	cmp    %esi,%ecx
 935:	75 c6                	jne    8fd <free+0x3d>
    p->s.size += bp->s.size;
 937:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 93a:	a3 60 12 00 00       	mov    %eax,0x1260
    p->s.size += bp->s.size;
 93f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 942:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 945:	89 08                	mov    %ecx,(%eax)
}
 947:	5b                   	pop    %ebx
 948:	5e                   	pop    %esi
 949:	5f                   	pop    %edi
 94a:	5d                   	pop    %ebp
 94b:	c3                   	ret
 94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000950 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	57                   	push   %edi
 954:	56                   	push   %esi
 955:	53                   	push   %ebx
 956:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 959:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 95c:	8b 15 60 12 00 00    	mov    0x1260,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 962:	8d 78 07             	lea    0x7(%eax),%edi
 965:	c1 ef 03             	shr    $0x3,%edi
 968:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 96b:	85 d2                	test   %edx,%edx
 96d:	0f 84 8d 00 00 00    	je     a00 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 973:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 975:	8b 48 04             	mov    0x4(%eax),%ecx
 978:	39 f9                	cmp    %edi,%ecx
 97a:	73 64                	jae    9e0 <malloc+0x90>
  if(nu < 4096)
 97c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 981:	39 df                	cmp    %ebx,%edi
 983:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 986:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 98d:	eb 0a                	jmp    999 <malloc+0x49>
 98f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 992:	8b 48 04             	mov    0x4(%eax),%ecx
 995:	39 f9                	cmp    %edi,%ecx
 997:	73 47                	jae    9e0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 999:	89 c2                	mov    %eax,%edx
 99b:	3b 05 60 12 00 00    	cmp    0x1260,%eax
 9a1:	75 ed                	jne    990 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 9a3:	83 ec 0c             	sub    $0xc,%esp
 9a6:	56                   	push   %esi
 9a7:	e8 bf fc ff ff       	call   66b <sbrk>
  if(p == (char*)-1)
 9ac:	83 c4 10             	add    $0x10,%esp
 9af:	83 f8 ff             	cmp    $0xffffffff,%eax
 9b2:	74 1c                	je     9d0 <malloc+0x80>
  hp->s.size = nu;
 9b4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9b7:	83 ec 0c             	sub    $0xc,%esp
 9ba:	83 c0 08             	add    $0x8,%eax
 9bd:	50                   	push   %eax
 9be:	e8 fd fe ff ff       	call   8c0 <free>
  return freep;
 9c3:	8b 15 60 12 00 00    	mov    0x1260,%edx
      if((p = morecore(nunits)) == 0)
 9c9:	83 c4 10             	add    $0x10,%esp
 9cc:	85 d2                	test   %edx,%edx
 9ce:	75 c0                	jne    990 <malloc+0x40>
        return 0;
  }
}
 9d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9d3:	31 c0                	xor    %eax,%eax
}
 9d5:	5b                   	pop    %ebx
 9d6:	5e                   	pop    %esi
 9d7:	5f                   	pop    %edi
 9d8:	5d                   	pop    %ebp
 9d9:	c3                   	ret
 9da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9e0:	39 cf                	cmp    %ecx,%edi
 9e2:	74 4c                	je     a30 <malloc+0xe0>
        p->s.size -= nunits;
 9e4:	29 f9                	sub    %edi,%ecx
 9e6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9ec:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 9ef:	89 15 60 12 00 00    	mov    %edx,0x1260
}
 9f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9f8:	83 c0 08             	add    $0x8,%eax
}
 9fb:	5b                   	pop    %ebx
 9fc:	5e                   	pop    %esi
 9fd:	5f                   	pop    %edi
 9fe:	5d                   	pop    %ebp
 9ff:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 a00:	c7 05 60 12 00 00 64 	movl   $0x1264,0x1260
 a07:	12 00 00 
    base.s.size = 0;
 a0a:	b8 64 12 00 00       	mov    $0x1264,%eax
    base.s.ptr = freep = prevp = &base;
 a0f:	c7 05 64 12 00 00 64 	movl   $0x1264,0x1264
 a16:	12 00 00 
    base.s.size = 0;
 a19:	c7 05 68 12 00 00 00 	movl   $0x0,0x1268
 a20:	00 00 00 
    if(p->s.size >= nunits){
 a23:	e9 54 ff ff ff       	jmp    97c <malloc+0x2c>
 a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 a2f:	00 
        prevp->s.ptr = p->s.ptr;
 a30:	8b 08                	mov    (%eax),%ecx
 a32:	89 0a                	mov    %ecx,(%edx)
 a34:	eb b9                	jmp    9ef <malloc+0x9f>
