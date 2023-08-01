
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	636080e7          	jalr	1590(ra) # 5646 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	624080e7          	jalr	1572(ra) # 5646 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	af250513          	addi	a0,a0,-1294 # 5b30 <malloc+0xe8>
      46:	00006097          	auipc	ra,0x6
      4a:	94a080e7          	jalr	-1718(ra) # 5990 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	5b6080e7          	jalr	1462(ra) # 5606 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	39078793          	addi	a5,a5,912 # 93e8 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	a9868693          	addi	a3,a3,-1384 # baf8 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	ad050513          	addi	a0,a0,-1328 # 5b50 <malloc+0x108>
      88:	00006097          	auipc	ra,0x6
      8c:	908080e7          	jalr	-1784(ra) # 5990 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	574080e7          	jalr	1396(ra) # 5606 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	ac050513          	addi	a0,a0,-1344 # 5b68 <malloc+0x120>
      b0:	00005097          	auipc	ra,0x5
      b4:	596080e7          	jalr	1430(ra) # 5646 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	572080e7          	jalr	1394(ra) # 562e <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	ac250513          	addi	a0,a0,-1342 # 5b88 <malloc+0x140>
      ce:	00005097          	auipc	ra,0x5
      d2:	578080e7          	jalr	1400(ra) # 5646 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	a8a50513          	addi	a0,a0,-1398 # 5b70 <malloc+0x128>
      ee:	00006097          	auipc	ra,0x6
      f2:	8a2080e7          	jalr	-1886(ra) # 5990 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	50e080e7          	jalr	1294(ra) # 5606 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	a9650513          	addi	a0,a0,-1386 # 5b98 <malloc+0x150>
     10a:	00006097          	auipc	ra,0x6
     10e:	886080e7          	jalr	-1914(ra) # 5990 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	4f2080e7          	jalr	1266(ra) # 5606 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	a9450513          	addi	a0,a0,-1388 # 5bc0 <malloc+0x178>
     134:	00005097          	auipc	ra,0x5
     138:	522080e7          	jalr	1314(ra) # 5656 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	a8050513          	addi	a0,a0,-1408 # 5bc0 <malloc+0x178>
     148:	00005097          	auipc	ra,0x5
     14c:	4fe080e7          	jalr	1278(ra) # 5646 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	a7c58593          	addi	a1,a1,-1412 # 5bd0 <malloc+0x188>
     15c:	00005097          	auipc	ra,0x5
     160:	4ca080e7          	jalr	1226(ra) # 5626 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	a5850513          	addi	a0,a0,-1448 # 5bc0 <malloc+0x178>
     170:	00005097          	auipc	ra,0x5
     174:	4d6080e7          	jalr	1238(ra) # 5646 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	a5c58593          	addi	a1,a1,-1444 # 5bd8 <malloc+0x190>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	4a0080e7          	jalr	1184(ra) # 5626 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	a2c50513          	addi	a0,a0,-1492 # 5bc0 <malloc+0x178>
     19c:	00005097          	auipc	ra,0x5
     1a0:	4ba080e7          	jalr	1210(ra) # 5656 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	488080e7          	jalr	1160(ra) # 562e <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	47e080e7          	jalr	1150(ra) # 562e <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	a1650513          	addi	a0,a0,-1514 # 5be0 <malloc+0x198>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	7be080e7          	jalr	1982(ra) # 5990 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	42a080e7          	jalr	1066(ra) # 5606 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	436080e7          	jalr	1078(ra) # 5646 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	416080e7          	jalr	1046(ra) # 562e <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	410080e7          	jalr	1040(ra) # 5656 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	98c50513          	addi	a0,a0,-1652 # 5c08 <malloc+0x1c0>
     284:	00005097          	auipc	ra,0x5
     288:	3d2080e7          	jalr	978(ra) # 5656 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	978a8a93          	addi	s5,s5,-1672 # 5c08 <malloc+0x1c0>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	860a0a13          	addi	s4,s4,-1952 # baf8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x179>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	39a080e7          	jalr	922(ra) # 5646 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	368080e7          	jalr	872(ra) # 5626 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	354080e7          	jalr	852(ra) # 5626 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	34e080e7          	jalr	846(ra) # 562e <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	36c080e7          	jalr	876(ra) # 5656 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	90650513          	addi	a0,a0,-1786 # 5c18 <malloc+0x1d0>
     31a:	00005097          	auipc	ra,0x5
     31e:	676080e7          	jalr	1654(ra) # 5990 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	2e2080e7          	jalr	738(ra) # 5606 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	90450513          	addi	a0,a0,-1788 # 5c38 <malloc+0x1f0>
     33c:	00005097          	auipc	ra,0x5
     340:	654080e7          	jalr	1620(ra) # 5990 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00005097          	auipc	ra,0x5
     34a:	2c0080e7          	jalr	704(ra) # 5606 <exit>

000000000000034e <copyin>:
{
     34e:	715d                	addi	sp,sp,-80
     350:	e486                	sd	ra,72(sp)
     352:	e0a2                	sd	s0,64(sp)
     354:	fc26                	sd	s1,56(sp)
     356:	f84a                	sd	s2,48(sp)
     358:	f44e                	sd	s3,40(sp)
     35a:	f052                	sd	s4,32(sp)
     35c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     35e:	4785                	li	a5,1
     360:	07fe                	slli	a5,a5,0x1f
     362:	fcf43023          	sd	a5,-64(s0)
     366:	57fd                	li	a5,-1
     368:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     370:	00006a17          	auipc	s4,0x6
     374:	8e0a0a13          	addi	s4,s4,-1824 # 5c50 <malloc+0x208>
    uint64 addr = addrs[ai];
     378:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37c:	20100593          	li	a1,513
     380:	8552                	mv	a0,s4
     382:	00005097          	auipc	ra,0x5
     386:	2c4080e7          	jalr	708(ra) # 5646 <open>
     38a:	84aa                	mv	s1,a0
    if(fd < 0){
     38c:	08054863          	bltz	a0,41c <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     390:	6609                	lui	a2,0x2
     392:	85ce                	mv	a1,s3
     394:	00005097          	auipc	ra,0x5
     398:	292080e7          	jalr	658(ra) # 5626 <write>
    if(n >= 0){
     39c:	08055d63          	bgez	a0,436 <copyin+0xe8>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00005097          	auipc	ra,0x5
     3a6:	28c080e7          	jalr	652(ra) # 562e <close>
    unlink("copyin1");
     3aa:	8552                	mv	a0,s4
     3ac:	00005097          	auipc	ra,0x5
     3b0:	2aa080e7          	jalr	682(ra) # 5656 <unlink>
    n = write(1, (char*)addr, 8192);
     3b4:	6609                	lui	a2,0x2
     3b6:	85ce                	mv	a1,s3
     3b8:	4505                	li	a0,1
     3ba:	00005097          	auipc	ra,0x5
     3be:	26c080e7          	jalr	620(ra) # 5626 <write>
    if(n > 0){
     3c2:	08a04963          	bgtz	a0,454 <copyin+0x106>
    if(pipe(fds) < 0){
     3c6:	fb840513          	addi	a0,s0,-72
     3ca:	00005097          	auipc	ra,0x5
     3ce:	24c080e7          	jalr	588(ra) # 5616 <pipe>
     3d2:	0a054063          	bltz	a0,472 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d6:	6609                	lui	a2,0x2
     3d8:	85ce                	mv	a1,s3
     3da:	fbc42503          	lw	a0,-68(s0)
     3de:	00005097          	auipc	ra,0x5
     3e2:	248080e7          	jalr	584(ra) # 5626 <write>
    if(n > 0){
     3e6:	0aa04363          	bgtz	a0,48c <copyin+0x13e>
    close(fds[0]);
     3ea:	fb842503          	lw	a0,-72(s0)
     3ee:	00005097          	auipc	ra,0x5
     3f2:	240080e7          	jalr	576(ra) # 562e <close>
    close(fds[1]);
     3f6:	fbc42503          	lw	a0,-68(s0)
     3fa:	00005097          	auipc	ra,0x5
     3fe:	234080e7          	jalr	564(ra) # 562e <close>
  for(int ai = 0; ai < 2; ai++){
     402:	0921                	addi	s2,s2,8
     404:	fd040793          	addi	a5,s0,-48
     408:	f6f918e3          	bne	s2,a5,378 <copyin+0x2a>
}
     40c:	60a6                	ld	ra,72(sp)
     40e:	6406                	ld	s0,64(sp)
     410:	74e2                	ld	s1,56(sp)
     412:	7942                	ld	s2,48(sp)
     414:	79a2                	ld	s3,40(sp)
     416:	7a02                	ld	s4,32(sp)
     418:	6161                	addi	sp,sp,80
     41a:	8082                	ret
      printf("open(copyin1) failed\n");
     41c:	00006517          	auipc	a0,0x6
     420:	83c50513          	addi	a0,a0,-1988 # 5c58 <malloc+0x210>
     424:	00005097          	auipc	ra,0x5
     428:	56c080e7          	jalr	1388(ra) # 5990 <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	1d8080e7          	jalr	472(ra) # 5606 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     436:	862a                	mv	a2,a0
     438:	85ce                	mv	a1,s3
     43a:	00006517          	auipc	a0,0x6
     43e:	83650513          	addi	a0,a0,-1994 # 5c70 <malloc+0x228>
     442:	00005097          	auipc	ra,0x5
     446:	54e080e7          	jalr	1358(ra) # 5990 <printf>
      exit(1);
     44a:	4505                	li	a0,1
     44c:	00005097          	auipc	ra,0x5
     450:	1ba080e7          	jalr	442(ra) # 5606 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     454:	862a                	mv	a2,a0
     456:	85ce                	mv	a1,s3
     458:	00006517          	auipc	a0,0x6
     45c:	84850513          	addi	a0,a0,-1976 # 5ca0 <malloc+0x258>
     460:	00005097          	auipc	ra,0x5
     464:	530080e7          	jalr	1328(ra) # 5990 <printf>
      exit(1);
     468:	4505                	li	a0,1
     46a:	00005097          	auipc	ra,0x5
     46e:	19c080e7          	jalr	412(ra) # 5606 <exit>
      printf("pipe() failed\n");
     472:	00006517          	auipc	a0,0x6
     476:	85e50513          	addi	a0,a0,-1954 # 5cd0 <malloc+0x288>
     47a:	00005097          	auipc	ra,0x5
     47e:	516080e7          	jalr	1302(ra) # 5990 <printf>
      exit(1);
     482:	4505                	li	a0,1
     484:	00005097          	auipc	ra,0x5
     488:	182080e7          	jalr	386(ra) # 5606 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48c:	862a                	mv	a2,a0
     48e:	85ce                	mv	a1,s3
     490:	00006517          	auipc	a0,0x6
     494:	85050513          	addi	a0,a0,-1968 # 5ce0 <malloc+0x298>
     498:	00005097          	auipc	ra,0x5
     49c:	4f8080e7          	jalr	1272(ra) # 5990 <printf>
      exit(1);
     4a0:	4505                	li	a0,1
     4a2:	00005097          	auipc	ra,0x5
     4a6:	164080e7          	jalr	356(ra) # 5606 <exit>

00000000000004aa <copyout>:
{
     4aa:	711d                	addi	sp,sp,-96
     4ac:	ec86                	sd	ra,88(sp)
     4ae:	e8a2                	sd	s0,80(sp)
     4b0:	e4a6                	sd	s1,72(sp)
     4b2:	e0ca                	sd	s2,64(sp)
     4b4:	fc4e                	sd	s3,56(sp)
     4b6:	f852                	sd	s4,48(sp)
     4b8:	f456                	sd	s5,40(sp)
     4ba:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4bc:	4785                	li	a5,1
     4be:	07fe                	slli	a5,a5,0x1f
     4c0:	faf43823          	sd	a5,-80(s0)
     4c4:	57fd                	li	a5,-1
     4c6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4ca:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4ce:	00006a17          	auipc	s4,0x6
     4d2:	842a0a13          	addi	s4,s4,-1982 # 5d10 <malloc+0x2c8>
    n = write(fds[1], "x", 1);
     4d6:	00005a97          	auipc	s5,0x5
     4da:	702a8a93          	addi	s5,s5,1794 # 5bd8 <malloc+0x190>
    uint64 addr = addrs[ai];
     4de:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e2:	4581                	li	a1,0
     4e4:	8552                	mv	a0,s4
     4e6:	00005097          	auipc	ra,0x5
     4ea:	160080e7          	jalr	352(ra) # 5646 <open>
     4ee:	84aa                	mv	s1,a0
    if(fd < 0){
     4f0:	08054663          	bltz	a0,57c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f4:	6609                	lui	a2,0x2
     4f6:	85ce                	mv	a1,s3
     4f8:	00005097          	auipc	ra,0x5
     4fc:	126080e7          	jalr	294(ra) # 561e <read>
    if(n > 0){
     500:	08a04b63          	bgtz	a0,596 <copyout+0xec>
    close(fd);
     504:	8526                	mv	a0,s1
     506:	00005097          	auipc	ra,0x5
     50a:	128080e7          	jalr	296(ra) # 562e <close>
    if(pipe(fds) < 0){
     50e:	fa840513          	addi	a0,s0,-88
     512:	00005097          	auipc	ra,0x5
     516:	104080e7          	jalr	260(ra) # 5616 <pipe>
     51a:	08054d63          	bltz	a0,5b4 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     51e:	4605                	li	a2,1
     520:	85d6                	mv	a1,s5
     522:	fac42503          	lw	a0,-84(s0)
     526:	00005097          	auipc	ra,0x5
     52a:	100080e7          	jalr	256(ra) # 5626 <write>
    if(n != 1){
     52e:	4785                	li	a5,1
     530:	08f51f63          	bne	a0,a5,5ce <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     534:	6609                	lui	a2,0x2
     536:	85ce                	mv	a1,s3
     538:	fa842503          	lw	a0,-88(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	0e2080e7          	jalr	226(ra) # 561e <read>
    if(n > 0){
     544:	0aa04263          	bgtz	a0,5e8 <copyout+0x13e>
    close(fds[0]);
     548:	fa842503          	lw	a0,-88(s0)
     54c:	00005097          	auipc	ra,0x5
     550:	0e2080e7          	jalr	226(ra) # 562e <close>
    close(fds[1]);
     554:	fac42503          	lw	a0,-84(s0)
     558:	00005097          	auipc	ra,0x5
     55c:	0d6080e7          	jalr	214(ra) # 562e <close>
  for(int ai = 0; ai < 2; ai++){
     560:	0921                	addi	s2,s2,8
     562:	fc040793          	addi	a5,s0,-64
     566:	f6f91ce3          	bne	s2,a5,4de <copyout+0x34>
}
     56a:	60e6                	ld	ra,88(sp)
     56c:	6446                	ld	s0,80(sp)
     56e:	64a6                	ld	s1,72(sp)
     570:	6906                	ld	s2,64(sp)
     572:	79e2                	ld	s3,56(sp)
     574:	7a42                	ld	s4,48(sp)
     576:	7aa2                	ld	s5,40(sp)
     578:	6125                	addi	sp,sp,96
     57a:	8082                	ret
      printf("open(README) failed\n");
     57c:	00005517          	auipc	a0,0x5
     580:	79c50513          	addi	a0,a0,1948 # 5d18 <malloc+0x2d0>
     584:	00005097          	auipc	ra,0x5
     588:	40c080e7          	jalr	1036(ra) # 5990 <printf>
      exit(1);
     58c:	4505                	li	a0,1
     58e:	00005097          	auipc	ra,0x5
     592:	078080e7          	jalr	120(ra) # 5606 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     596:	862a                	mv	a2,a0
     598:	85ce                	mv	a1,s3
     59a:	00005517          	auipc	a0,0x5
     59e:	79650513          	addi	a0,a0,1942 # 5d30 <malloc+0x2e8>
     5a2:	00005097          	auipc	ra,0x5
     5a6:	3ee080e7          	jalr	1006(ra) # 5990 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	00005097          	auipc	ra,0x5
     5b0:	05a080e7          	jalr	90(ra) # 5606 <exit>
      printf("pipe() failed\n");
     5b4:	00005517          	auipc	a0,0x5
     5b8:	71c50513          	addi	a0,a0,1820 # 5cd0 <malloc+0x288>
     5bc:	00005097          	auipc	ra,0x5
     5c0:	3d4080e7          	jalr	980(ra) # 5990 <printf>
      exit(1);
     5c4:	4505                	li	a0,1
     5c6:	00005097          	auipc	ra,0x5
     5ca:	040080e7          	jalr	64(ra) # 5606 <exit>
      printf("pipe write failed\n");
     5ce:	00005517          	auipc	a0,0x5
     5d2:	79250513          	addi	a0,a0,1938 # 5d60 <malloc+0x318>
     5d6:	00005097          	auipc	ra,0x5
     5da:	3ba080e7          	jalr	954(ra) # 5990 <printf>
      exit(1);
     5de:	4505                	li	a0,1
     5e0:	00005097          	auipc	ra,0x5
     5e4:	026080e7          	jalr	38(ra) # 5606 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5e8:	862a                	mv	a2,a0
     5ea:	85ce                	mv	a1,s3
     5ec:	00005517          	auipc	a0,0x5
     5f0:	78c50513          	addi	a0,a0,1932 # 5d78 <malloc+0x330>
     5f4:	00005097          	auipc	ra,0x5
     5f8:	39c080e7          	jalr	924(ra) # 5990 <printf>
      exit(1);
     5fc:	4505                	li	a0,1
     5fe:	00005097          	auipc	ra,0x5
     602:	008080e7          	jalr	8(ra) # 5606 <exit>

0000000000000606 <truncate1>:
{
     606:	711d                	addi	sp,sp,-96
     608:	ec86                	sd	ra,88(sp)
     60a:	e8a2                	sd	s0,80(sp)
     60c:	e4a6                	sd	s1,72(sp)
     60e:	e0ca                	sd	s2,64(sp)
     610:	fc4e                	sd	s3,56(sp)
     612:	f852                	sd	s4,48(sp)
     614:	f456                	sd	s5,40(sp)
     616:	1080                	addi	s0,sp,96
     618:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61a:	00005517          	auipc	a0,0x5
     61e:	5a650513          	addi	a0,a0,1446 # 5bc0 <malloc+0x178>
     622:	00005097          	auipc	ra,0x5
     626:	034080e7          	jalr	52(ra) # 5656 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62a:	60100593          	li	a1,1537
     62e:	00005517          	auipc	a0,0x5
     632:	59250513          	addi	a0,a0,1426 # 5bc0 <malloc+0x178>
     636:	00005097          	auipc	ra,0x5
     63a:	010080e7          	jalr	16(ra) # 5646 <open>
     63e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     640:	4611                	li	a2,4
     642:	00005597          	auipc	a1,0x5
     646:	58e58593          	addi	a1,a1,1422 # 5bd0 <malloc+0x188>
     64a:	00005097          	auipc	ra,0x5
     64e:	fdc080e7          	jalr	-36(ra) # 5626 <write>
  close(fd1);
     652:	8526                	mv	a0,s1
     654:	00005097          	auipc	ra,0x5
     658:	fda080e7          	jalr	-38(ra) # 562e <close>
  int fd2 = open("truncfile", O_RDONLY);
     65c:	4581                	li	a1,0
     65e:	00005517          	auipc	a0,0x5
     662:	56250513          	addi	a0,a0,1378 # 5bc0 <malloc+0x178>
     666:	00005097          	auipc	ra,0x5
     66a:	fe0080e7          	jalr	-32(ra) # 5646 <open>
     66e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     670:	02000613          	li	a2,32
     674:	fa040593          	addi	a1,s0,-96
     678:	00005097          	auipc	ra,0x5
     67c:	fa6080e7          	jalr	-90(ra) # 561e <read>
  if(n != 4){
     680:	4791                	li	a5,4
     682:	0cf51e63          	bne	a0,a5,75e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     686:	40100593          	li	a1,1025
     68a:	00005517          	auipc	a0,0x5
     68e:	53650513          	addi	a0,a0,1334 # 5bc0 <malloc+0x178>
     692:	00005097          	auipc	ra,0x5
     696:	fb4080e7          	jalr	-76(ra) # 5646 <open>
     69a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69c:	4581                	li	a1,0
     69e:	00005517          	auipc	a0,0x5
     6a2:	52250513          	addi	a0,a0,1314 # 5bc0 <malloc+0x178>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	fa0080e7          	jalr	-96(ra) # 5646 <open>
     6ae:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b0:	02000613          	li	a2,32
     6b4:	fa040593          	addi	a1,s0,-96
     6b8:	00005097          	auipc	ra,0x5
     6bc:	f66080e7          	jalr	-154(ra) # 561e <read>
     6c0:	8a2a                	mv	s4,a0
  if(n != 0){
     6c2:	ed4d                	bnez	a0,77c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	8526                	mv	a0,s1
     6ce:	00005097          	auipc	ra,0x5
     6d2:	f50080e7          	jalr	-176(ra) # 561e <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	e971                	bnez	a0,7ac <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6da:	4619                	li	a2,6
     6dc:	00005597          	auipc	a1,0x5
     6e0:	72c58593          	addi	a1,a1,1836 # 5e08 <malloc+0x3c0>
     6e4:	854e                	mv	a0,s3
     6e6:	00005097          	auipc	ra,0x5
     6ea:	f40080e7          	jalr	-192(ra) # 5626 <write>
  n = read(fd3, buf, sizeof(buf));
     6ee:	02000613          	li	a2,32
     6f2:	fa040593          	addi	a1,s0,-96
     6f6:	854a                	mv	a0,s2
     6f8:	00005097          	auipc	ra,0x5
     6fc:	f26080e7          	jalr	-218(ra) # 561e <read>
  if(n != 6){
     700:	4799                	li	a5,6
     702:	0cf51d63          	bne	a0,a5,7dc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     706:	02000613          	li	a2,32
     70a:	fa040593          	addi	a1,s0,-96
     70e:	8526                	mv	a0,s1
     710:	00005097          	auipc	ra,0x5
     714:	f0e080e7          	jalr	-242(ra) # 561e <read>
  if(n != 2){
     718:	4789                	li	a5,2
     71a:	0ef51063          	bne	a0,a5,7fa <truncate1+0x1f4>
  unlink("truncfile");
     71e:	00005517          	auipc	a0,0x5
     722:	4a250513          	addi	a0,a0,1186 # 5bc0 <malloc+0x178>
     726:	00005097          	auipc	ra,0x5
     72a:	f30080e7          	jalr	-208(ra) # 5656 <unlink>
  close(fd1);
     72e:	854e                	mv	a0,s3
     730:	00005097          	auipc	ra,0x5
     734:	efe080e7          	jalr	-258(ra) # 562e <close>
  close(fd2);
     738:	8526                	mv	a0,s1
     73a:	00005097          	auipc	ra,0x5
     73e:	ef4080e7          	jalr	-268(ra) # 562e <close>
  close(fd3);
     742:	854a                	mv	a0,s2
     744:	00005097          	auipc	ra,0x5
     748:	eea080e7          	jalr	-278(ra) # 562e <close>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     75e:	862a                	mv	a2,a0
     760:	85d6                	mv	a1,s5
     762:	00005517          	auipc	a0,0x5
     766:	64650513          	addi	a0,a0,1606 # 5da8 <malloc+0x360>
     76a:	00005097          	auipc	ra,0x5
     76e:	226080e7          	jalr	550(ra) # 5990 <printf>
    exit(1);
     772:	4505                	li	a0,1
     774:	00005097          	auipc	ra,0x5
     778:	e92080e7          	jalr	-366(ra) # 5606 <exit>
    printf("aaa fd3=%d\n", fd3);
     77c:	85ca                	mv	a1,s2
     77e:	00005517          	auipc	a0,0x5
     782:	64a50513          	addi	a0,a0,1610 # 5dc8 <malloc+0x380>
     786:	00005097          	auipc	ra,0x5
     78a:	20a080e7          	jalr	522(ra) # 5990 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     78e:	8652                	mv	a2,s4
     790:	85d6                	mv	a1,s5
     792:	00005517          	auipc	a0,0x5
     796:	64650513          	addi	a0,a0,1606 # 5dd8 <malloc+0x390>
     79a:	00005097          	auipc	ra,0x5
     79e:	1f6080e7          	jalr	502(ra) # 5990 <printf>
    exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00005097          	auipc	ra,0x5
     7a8:	e62080e7          	jalr	-414(ra) # 5606 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ac:	85a6                	mv	a1,s1
     7ae:	00005517          	auipc	a0,0x5
     7b2:	64a50513          	addi	a0,a0,1610 # 5df8 <malloc+0x3b0>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	1da080e7          	jalr	474(ra) # 5990 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7be:	8652                	mv	a2,s4
     7c0:	85d6                	mv	a1,s5
     7c2:	00005517          	auipc	a0,0x5
     7c6:	61650513          	addi	a0,a0,1558 # 5dd8 <malloc+0x390>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	1c6080e7          	jalr	454(ra) # 5990 <printf>
    exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	e32080e7          	jalr	-462(ra) # 5606 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7dc:	862a                	mv	a2,a0
     7de:	85d6                	mv	a1,s5
     7e0:	00005517          	auipc	a0,0x5
     7e4:	63050513          	addi	a0,a0,1584 # 5e10 <malloc+0x3c8>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	1a8080e7          	jalr	424(ra) # 5990 <printf>
    exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	e14080e7          	jalr	-492(ra) # 5606 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fa:	862a                	mv	a2,a0
     7fc:	85d6                	mv	a1,s5
     7fe:	00005517          	auipc	a0,0x5
     802:	63250513          	addi	a0,a0,1586 # 5e30 <malloc+0x3e8>
     806:	00005097          	auipc	ra,0x5
     80a:	18a080e7          	jalr	394(ra) # 5990 <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	df6080e7          	jalr	-522(ra) # 5606 <exit>

0000000000000818 <writetest>:
{
     818:	7139                	addi	sp,sp,-64
     81a:	fc06                	sd	ra,56(sp)
     81c:	f822                	sd	s0,48(sp)
     81e:	f426                	sd	s1,40(sp)
     820:	f04a                	sd	s2,32(sp)
     822:	ec4e                	sd	s3,24(sp)
     824:	e852                	sd	s4,16(sp)
     826:	e456                	sd	s5,8(sp)
     828:	e05a                	sd	s6,0(sp)
     82a:	0080                	addi	s0,sp,64
     82c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     82e:	20200593          	li	a1,514
     832:	00005517          	auipc	a0,0x5
     836:	61e50513          	addi	a0,a0,1566 # 5e50 <malloc+0x408>
     83a:	00005097          	auipc	ra,0x5
     83e:	e0c080e7          	jalr	-500(ra) # 5646 <open>
  if(fd < 0){
     842:	0a054d63          	bltz	a0,8fc <writetest+0xe4>
     846:	892a                	mv	s2,a0
     848:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84a:	00005997          	auipc	s3,0x5
     84e:	62e98993          	addi	s3,s3,1582 # 5e78 <malloc+0x430>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     852:	00005a97          	auipc	s5,0x5
     856:	65ea8a93          	addi	s5,s5,1630 # 5eb0 <malloc+0x468>
  for(i = 0; i < N; i++){
     85a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	4629                	li	a2,10
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00005097          	auipc	ra,0x5
     868:	dc2080e7          	jalr	-574(ra) # 5626 <write>
     86c:	47a9                	li	a5,10
     86e:	0af51563          	bne	a0,a5,918 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85d6                	mv	a1,s5
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	dae080e7          	jalr	-594(ra) # 5626 <write>
     880:	47a9                	li	a5,10
     882:	0af51a63          	bne	a0,a5,936 <writetest+0x11e>
  for(i = 0; i < N; i++){
     886:	2485                	addiw	s1,s1,1
     888:	fd449be3          	bne	s1,s4,85e <writetest+0x46>
  close(fd);
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	da0080e7          	jalr	-608(ra) # 562e <close>
  fd = open("small", O_RDONLY);
     896:	4581                	li	a1,0
     898:	00005517          	auipc	a0,0x5
     89c:	5b850513          	addi	a0,a0,1464 # 5e50 <malloc+0x408>
     8a0:	00005097          	auipc	ra,0x5
     8a4:	da6080e7          	jalr	-602(ra) # 5646 <open>
     8a8:	84aa                	mv	s1,a0
  if(fd < 0){
     8aa:	0a054563          	bltz	a0,954 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8ae:	7d000613          	li	a2,2000
     8b2:	0000b597          	auipc	a1,0xb
     8b6:	24658593          	addi	a1,a1,582 # baf8 <buf>
     8ba:	00005097          	auipc	ra,0x5
     8be:	d64080e7          	jalr	-668(ra) # 561e <read>
  if(i != N*SZ*2){
     8c2:	7d000793          	li	a5,2000
     8c6:	0af51563          	bne	a0,a5,970 <writetest+0x158>
  close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00005097          	auipc	ra,0x5
     8d0:	d62080e7          	jalr	-670(ra) # 562e <close>
  if(unlink("small") < 0){
     8d4:	00005517          	auipc	a0,0x5
     8d8:	57c50513          	addi	a0,a0,1404 # 5e50 <malloc+0x408>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	d7a080e7          	jalr	-646(ra) # 5656 <unlink>
     8e4:	0a054463          	bltz	a0,98c <writetest+0x174>
}
     8e8:	70e2                	ld	ra,56(sp)
     8ea:	7442                	ld	s0,48(sp)
     8ec:	74a2                	ld	s1,40(sp)
     8ee:	7902                	ld	s2,32(sp)
     8f0:	69e2                	ld	s3,24(sp)
     8f2:	6a42                	ld	s4,16(sp)
     8f4:	6aa2                	ld	s5,8(sp)
     8f6:	6b02                	ld	s6,0(sp)
     8f8:	6121                	addi	sp,sp,64
     8fa:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fc:	85da                	mv	a1,s6
     8fe:	00005517          	auipc	a0,0x5
     902:	55a50513          	addi	a0,a0,1370 # 5e58 <malloc+0x410>
     906:	00005097          	auipc	ra,0x5
     90a:	08a080e7          	jalr	138(ra) # 5990 <printf>
    exit(1);
     90e:	4505                	li	a0,1
     910:	00005097          	auipc	ra,0x5
     914:	cf6080e7          	jalr	-778(ra) # 5606 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     918:	8626                	mv	a2,s1
     91a:	85da                	mv	a1,s6
     91c:	00005517          	auipc	a0,0x5
     920:	56c50513          	addi	a0,a0,1388 # 5e88 <malloc+0x440>
     924:	00005097          	auipc	ra,0x5
     928:	06c080e7          	jalr	108(ra) # 5990 <printf>
      exit(1);
     92c:	4505                	li	a0,1
     92e:	00005097          	auipc	ra,0x5
     932:	cd8080e7          	jalr	-808(ra) # 5606 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     936:	8626                	mv	a2,s1
     938:	85da                	mv	a1,s6
     93a:	00005517          	auipc	a0,0x5
     93e:	58650513          	addi	a0,a0,1414 # 5ec0 <malloc+0x478>
     942:	00005097          	auipc	ra,0x5
     946:	04e080e7          	jalr	78(ra) # 5990 <printf>
      exit(1);
     94a:	4505                	li	a0,1
     94c:	00005097          	auipc	ra,0x5
     950:	cba080e7          	jalr	-838(ra) # 5606 <exit>
    printf("%s: error: open small failed!\n", s);
     954:	85da                	mv	a1,s6
     956:	00005517          	auipc	a0,0x5
     95a:	59250513          	addi	a0,a0,1426 # 5ee8 <malloc+0x4a0>
     95e:	00005097          	auipc	ra,0x5
     962:	032080e7          	jalr	50(ra) # 5990 <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	c9e080e7          	jalr	-866(ra) # 5606 <exit>
    printf("%s: read failed\n", s);
     970:	85da                	mv	a1,s6
     972:	00005517          	auipc	a0,0x5
     976:	59650513          	addi	a0,a0,1430 # 5f08 <malloc+0x4c0>
     97a:	00005097          	auipc	ra,0x5
     97e:	016080e7          	jalr	22(ra) # 5990 <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	c82080e7          	jalr	-894(ra) # 5606 <exit>
    printf("%s: unlink small failed\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00005517          	auipc	a0,0x5
     992:	59250513          	addi	a0,a0,1426 # 5f20 <malloc+0x4d8>
     996:	00005097          	auipc	ra,0x5
     99a:	ffa080e7          	jalr	-6(ra) # 5990 <printf>
    exit(1);
     99e:	4505                	li	a0,1
     9a0:	00005097          	auipc	ra,0x5
     9a4:	c66080e7          	jalr	-922(ra) # 5606 <exit>

00000000000009a8 <writebig>:
{
     9a8:	7139                	addi	sp,sp,-64
     9aa:	fc06                	sd	ra,56(sp)
     9ac:	f822                	sd	s0,48(sp)
     9ae:	f426                	sd	s1,40(sp)
     9b0:	f04a                	sd	s2,32(sp)
     9b2:	ec4e                	sd	s3,24(sp)
     9b4:	e852                	sd	s4,16(sp)
     9b6:	e456                	sd	s5,8(sp)
     9b8:	0080                	addi	s0,sp,64
     9ba:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9bc:	20200593          	li	a1,514
     9c0:	00005517          	auipc	a0,0x5
     9c4:	58050513          	addi	a0,a0,1408 # 5f40 <malloc+0x4f8>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	c7e080e7          	jalr	-898(ra) # 5646 <open>
     9d0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d4:	0000b917          	auipc	s2,0xb
     9d8:	12490913          	addi	s2,s2,292 # baf8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9dc:	10c00a13          	li	s4,268
  if(fd < 0){
     9e0:	06054c63          	bltz	a0,a58 <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9e8:	40000613          	li	a2,1024
     9ec:	85ca                	mv	a1,s2
     9ee:	854e                	mv	a0,s3
     9f0:	00005097          	auipc	ra,0x5
     9f4:	c36080e7          	jalr	-970(ra) # 5626 <write>
     9f8:	40000793          	li	a5,1024
     9fc:	06f51c63          	bne	a0,a5,a74 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a00:	2485                	addiw	s1,s1,1
     a02:	ff4491e3          	bne	s1,s4,9e4 <writebig+0x3c>
  close(fd);
     a06:	854e                	mv	a0,s3
     a08:	00005097          	auipc	ra,0x5
     a0c:	c26080e7          	jalr	-986(ra) # 562e <close>
  fd = open("big", O_RDONLY);
     a10:	4581                	li	a1,0
     a12:	00005517          	auipc	a0,0x5
     a16:	52e50513          	addi	a0,a0,1326 # 5f40 <malloc+0x4f8>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	c2c080e7          	jalr	-980(ra) # 5646 <open>
     a22:	89aa                	mv	s3,a0
  n = 0;
     a24:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a26:	0000b917          	auipc	s2,0xb
     a2a:	0d290913          	addi	s2,s2,210 # baf8 <buf>
  if(fd < 0){
     a2e:	06054263          	bltz	a0,a92 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a32:	40000613          	li	a2,1024
     a36:	85ca                	mv	a1,s2
     a38:	854e                	mv	a0,s3
     a3a:	00005097          	auipc	ra,0x5
     a3e:	be4080e7          	jalr	-1052(ra) # 561e <read>
    if(i == 0){
     a42:	c535                	beqz	a0,aae <writebig+0x106>
    } else if(i != BSIZE){
     a44:	40000793          	li	a5,1024
     a48:	0af51f63          	bne	a0,a5,b06 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4c:	00092683          	lw	a3,0(s2)
     a50:	0c969a63          	bne	a3,s1,b24 <writebig+0x17c>
    n++;
     a54:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a56:	bff1                	j	a32 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a58:	85d6                	mv	a1,s5
     a5a:	00005517          	auipc	a0,0x5
     a5e:	4ee50513          	addi	a0,a0,1262 # 5f48 <malloc+0x500>
     a62:	00005097          	auipc	ra,0x5
     a66:	f2e080e7          	jalr	-210(ra) # 5990 <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	00005097          	auipc	ra,0x5
     a70:	b9a080e7          	jalr	-1126(ra) # 5606 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a74:	8626                	mv	a2,s1
     a76:	85d6                	mv	a1,s5
     a78:	00005517          	auipc	a0,0x5
     a7c:	4f050513          	addi	a0,a0,1264 # 5f68 <malloc+0x520>
     a80:	00005097          	auipc	ra,0x5
     a84:	f10080e7          	jalr	-240(ra) # 5990 <printf>
      exit(1);
     a88:	4505                	li	a0,1
     a8a:	00005097          	auipc	ra,0x5
     a8e:	b7c080e7          	jalr	-1156(ra) # 5606 <exit>
    printf("%s: error: open big failed!\n", s);
     a92:	85d6                	mv	a1,s5
     a94:	00005517          	auipc	a0,0x5
     a98:	4fc50513          	addi	a0,a0,1276 # 5f90 <malloc+0x548>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	ef4080e7          	jalr	-268(ra) # 5990 <printf>
    exit(1);
     aa4:	4505                	li	a0,1
     aa6:	00005097          	auipc	ra,0x5
     aaa:	b60080e7          	jalr	-1184(ra) # 5606 <exit>
      if(n == MAXFILE - 1){
     aae:	10b00793          	li	a5,267
     ab2:	02f48a63          	beq	s1,a5,ae6 <writebig+0x13e>
  close(fd);
     ab6:	854e                	mv	a0,s3
     ab8:	00005097          	auipc	ra,0x5
     abc:	b76080e7          	jalr	-1162(ra) # 562e <close>
  if(unlink("big") < 0){
     ac0:	00005517          	auipc	a0,0x5
     ac4:	48050513          	addi	a0,a0,1152 # 5f40 <malloc+0x4f8>
     ac8:	00005097          	auipc	ra,0x5
     acc:	b8e080e7          	jalr	-1138(ra) # 5656 <unlink>
     ad0:	06054963          	bltz	a0,b42 <writebig+0x19a>
}
     ad4:	70e2                	ld	ra,56(sp)
     ad6:	7442                	ld	s0,48(sp)
     ad8:	74a2                	ld	s1,40(sp)
     ada:	7902                	ld	s2,32(sp)
     adc:	69e2                	ld	s3,24(sp)
     ade:	6a42                	ld	s4,16(sp)
     ae0:	6aa2                	ld	s5,8(sp)
     ae2:	6121                	addi	sp,sp,64
     ae4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae6:	10b00613          	li	a2,267
     aea:	85d6                	mv	a1,s5
     aec:	00005517          	auipc	a0,0x5
     af0:	4c450513          	addi	a0,a0,1220 # 5fb0 <malloc+0x568>
     af4:	00005097          	auipc	ra,0x5
     af8:	e9c080e7          	jalr	-356(ra) # 5990 <printf>
        exit(1);
     afc:	4505                	li	a0,1
     afe:	00005097          	auipc	ra,0x5
     b02:	b08080e7          	jalr	-1272(ra) # 5606 <exit>
      printf("%s: read failed %d\n", s, i);
     b06:	862a                	mv	a2,a0
     b08:	85d6                	mv	a1,s5
     b0a:	00005517          	auipc	a0,0x5
     b0e:	4ce50513          	addi	a0,a0,1230 # 5fd8 <malloc+0x590>
     b12:	00005097          	auipc	ra,0x5
     b16:	e7e080e7          	jalr	-386(ra) # 5990 <printf>
      exit(1);
     b1a:	4505                	li	a0,1
     b1c:	00005097          	auipc	ra,0x5
     b20:	aea080e7          	jalr	-1302(ra) # 5606 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b24:	8626                	mv	a2,s1
     b26:	85d6                	mv	a1,s5
     b28:	00005517          	auipc	a0,0x5
     b2c:	4c850513          	addi	a0,a0,1224 # 5ff0 <malloc+0x5a8>
     b30:	00005097          	auipc	ra,0x5
     b34:	e60080e7          	jalr	-416(ra) # 5990 <printf>
      exit(1);
     b38:	4505                	li	a0,1
     b3a:	00005097          	auipc	ra,0x5
     b3e:	acc080e7          	jalr	-1332(ra) # 5606 <exit>
    printf("%s: unlink big failed\n", s);
     b42:	85d6                	mv	a1,s5
     b44:	00005517          	auipc	a0,0x5
     b48:	4d450513          	addi	a0,a0,1236 # 6018 <malloc+0x5d0>
     b4c:	00005097          	auipc	ra,0x5
     b50:	e44080e7          	jalr	-444(ra) # 5990 <printf>
    exit(1);
     b54:	4505                	li	a0,1
     b56:	00005097          	auipc	ra,0x5
     b5a:	ab0080e7          	jalr	-1360(ra) # 5606 <exit>

0000000000000b5e <unlinkread>:
{
     b5e:	7179                	addi	sp,sp,-48
     b60:	f406                	sd	ra,40(sp)
     b62:	f022                	sd	s0,32(sp)
     b64:	ec26                	sd	s1,24(sp)
     b66:	e84a                	sd	s2,16(sp)
     b68:	e44e                	sd	s3,8(sp)
     b6a:	1800                	addi	s0,sp,48
     b6c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b6e:	20200593          	li	a1,514
     b72:	00005517          	auipc	a0,0x5
     b76:	4be50513          	addi	a0,a0,1214 # 6030 <malloc+0x5e8>
     b7a:	00005097          	auipc	ra,0x5
     b7e:	acc080e7          	jalr	-1332(ra) # 5646 <open>
  if(fd < 0){
     b82:	0e054563          	bltz	a0,c6c <unlinkread+0x10e>
     b86:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b88:	4615                	li	a2,5
     b8a:	00005597          	auipc	a1,0x5
     b8e:	4d658593          	addi	a1,a1,1238 # 6060 <malloc+0x618>
     b92:	00005097          	auipc	ra,0x5
     b96:	a94080e7          	jalr	-1388(ra) # 5626 <write>
  close(fd);
     b9a:	8526                	mv	a0,s1
     b9c:	00005097          	auipc	ra,0x5
     ba0:	a92080e7          	jalr	-1390(ra) # 562e <close>
  fd = open("unlinkread", O_RDWR);
     ba4:	4589                	li	a1,2
     ba6:	00005517          	auipc	a0,0x5
     baa:	48a50513          	addi	a0,a0,1162 # 6030 <malloc+0x5e8>
     bae:	00005097          	auipc	ra,0x5
     bb2:	a98080e7          	jalr	-1384(ra) # 5646 <open>
     bb6:	84aa                	mv	s1,a0
  if(fd < 0){
     bb8:	0c054863          	bltz	a0,c88 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbc:	00005517          	auipc	a0,0x5
     bc0:	47450513          	addi	a0,a0,1140 # 6030 <malloc+0x5e8>
     bc4:	00005097          	auipc	ra,0x5
     bc8:	a92080e7          	jalr	-1390(ra) # 5656 <unlink>
     bcc:	ed61                	bnez	a0,ca4 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bce:	20200593          	li	a1,514
     bd2:	00005517          	auipc	a0,0x5
     bd6:	45e50513          	addi	a0,a0,1118 # 6030 <malloc+0x5e8>
     bda:	00005097          	auipc	ra,0x5
     bde:	a6c080e7          	jalr	-1428(ra) # 5646 <open>
     be2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be4:	460d                	li	a2,3
     be6:	00005597          	auipc	a1,0x5
     bea:	4c258593          	addi	a1,a1,1218 # 60a8 <malloc+0x660>
     bee:	00005097          	auipc	ra,0x5
     bf2:	a38080e7          	jalr	-1480(ra) # 5626 <write>
  close(fd1);
     bf6:	854a                	mv	a0,s2
     bf8:	00005097          	auipc	ra,0x5
     bfc:	a36080e7          	jalr	-1482(ra) # 562e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c00:	660d                	lui	a2,0x3
     c02:	0000b597          	auipc	a1,0xb
     c06:	ef658593          	addi	a1,a1,-266 # baf8 <buf>
     c0a:	8526                	mv	a0,s1
     c0c:	00005097          	auipc	ra,0x5
     c10:	a12080e7          	jalr	-1518(ra) # 561e <read>
     c14:	4795                	li	a5,5
     c16:	0af51563          	bne	a0,a5,cc0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1a:	0000b717          	auipc	a4,0xb
     c1e:	ede74703          	lbu	a4,-290(a4) # baf8 <buf>
     c22:	06800793          	li	a5,104
     c26:	0af71b63          	bne	a4,a5,cdc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2a:	4629                	li	a2,10
     c2c:	0000b597          	auipc	a1,0xb
     c30:	ecc58593          	addi	a1,a1,-308 # baf8 <buf>
     c34:	8526                	mv	a0,s1
     c36:	00005097          	auipc	ra,0x5
     c3a:	9f0080e7          	jalr	-1552(ra) # 5626 <write>
     c3e:	47a9                	li	a5,10
     c40:	0af51c63          	bne	a0,a5,cf8 <unlinkread+0x19a>
  close(fd);
     c44:	8526                	mv	a0,s1
     c46:	00005097          	auipc	ra,0x5
     c4a:	9e8080e7          	jalr	-1560(ra) # 562e <close>
  unlink("unlinkread");
     c4e:	00005517          	auipc	a0,0x5
     c52:	3e250513          	addi	a0,a0,994 # 6030 <malloc+0x5e8>
     c56:	00005097          	auipc	ra,0x5
     c5a:	a00080e7          	jalr	-1536(ra) # 5656 <unlink>
}
     c5e:	70a2                	ld	ra,40(sp)
     c60:	7402                	ld	s0,32(sp)
     c62:	64e2                	ld	s1,24(sp)
     c64:	6942                	ld	s2,16(sp)
     c66:	69a2                	ld	s3,8(sp)
     c68:	6145                	addi	sp,sp,48
     c6a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6c:	85ce                	mv	a1,s3
     c6e:	00005517          	auipc	a0,0x5
     c72:	3d250513          	addi	a0,a0,978 # 6040 <malloc+0x5f8>
     c76:	00005097          	auipc	ra,0x5
     c7a:	d1a080e7          	jalr	-742(ra) # 5990 <printf>
    exit(1);
     c7e:	4505                	li	a0,1
     c80:	00005097          	auipc	ra,0x5
     c84:	986080e7          	jalr	-1658(ra) # 5606 <exit>
    printf("%s: open unlinkread failed\n", s);
     c88:	85ce                	mv	a1,s3
     c8a:	00005517          	auipc	a0,0x5
     c8e:	3de50513          	addi	a0,a0,990 # 6068 <malloc+0x620>
     c92:	00005097          	auipc	ra,0x5
     c96:	cfe080e7          	jalr	-770(ra) # 5990 <printf>
    exit(1);
     c9a:	4505                	li	a0,1
     c9c:	00005097          	auipc	ra,0x5
     ca0:	96a080e7          	jalr	-1686(ra) # 5606 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	3e250513          	addi	a0,a0,994 # 6088 <malloc+0x640>
     cae:	00005097          	auipc	ra,0x5
     cb2:	ce2080e7          	jalr	-798(ra) # 5990 <printf>
    exit(1);
     cb6:	4505                	li	a0,1
     cb8:	00005097          	auipc	ra,0x5
     cbc:	94e080e7          	jalr	-1714(ra) # 5606 <exit>
    printf("%s: unlinkread read failed", s);
     cc0:	85ce                	mv	a1,s3
     cc2:	00005517          	auipc	a0,0x5
     cc6:	3ee50513          	addi	a0,a0,1006 # 60b0 <malloc+0x668>
     cca:	00005097          	auipc	ra,0x5
     cce:	cc6080e7          	jalr	-826(ra) # 5990 <printf>
    exit(1);
     cd2:	4505                	li	a0,1
     cd4:	00005097          	auipc	ra,0x5
     cd8:	932080e7          	jalr	-1742(ra) # 5606 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cdc:	85ce                	mv	a1,s3
     cde:	00005517          	auipc	a0,0x5
     ce2:	3f250513          	addi	a0,a0,1010 # 60d0 <malloc+0x688>
     ce6:	00005097          	auipc	ra,0x5
     cea:	caa080e7          	jalr	-854(ra) # 5990 <printf>
    exit(1);
     cee:	4505                	li	a0,1
     cf0:	00005097          	auipc	ra,0x5
     cf4:	916080e7          	jalr	-1770(ra) # 5606 <exit>
    printf("%s: unlinkread write failed\n", s);
     cf8:	85ce                	mv	a1,s3
     cfa:	00005517          	auipc	a0,0x5
     cfe:	3f650513          	addi	a0,a0,1014 # 60f0 <malloc+0x6a8>
     d02:	00005097          	auipc	ra,0x5
     d06:	c8e080e7          	jalr	-882(ra) # 5990 <printf>
    exit(1);
     d0a:	4505                	li	a0,1
     d0c:	00005097          	auipc	ra,0x5
     d10:	8fa080e7          	jalr	-1798(ra) # 5606 <exit>

0000000000000d14 <linktest>:
{
     d14:	1101                	addi	sp,sp,-32
     d16:	ec06                	sd	ra,24(sp)
     d18:	e822                	sd	s0,16(sp)
     d1a:	e426                	sd	s1,8(sp)
     d1c:	e04a                	sd	s2,0(sp)
     d1e:	1000                	addi	s0,sp,32
     d20:	892a                	mv	s2,a0
  unlink("lf1");
     d22:	00005517          	auipc	a0,0x5
     d26:	3ee50513          	addi	a0,a0,1006 # 6110 <malloc+0x6c8>
     d2a:	00005097          	auipc	ra,0x5
     d2e:	92c080e7          	jalr	-1748(ra) # 5656 <unlink>
  unlink("lf2");
     d32:	00005517          	auipc	a0,0x5
     d36:	3e650513          	addi	a0,a0,998 # 6118 <malloc+0x6d0>
     d3a:	00005097          	auipc	ra,0x5
     d3e:	91c080e7          	jalr	-1764(ra) # 5656 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d42:	20200593          	li	a1,514
     d46:	00005517          	auipc	a0,0x5
     d4a:	3ca50513          	addi	a0,a0,970 # 6110 <malloc+0x6c8>
     d4e:	00005097          	auipc	ra,0x5
     d52:	8f8080e7          	jalr	-1800(ra) # 5646 <open>
  if(fd < 0){
     d56:	10054763          	bltz	a0,e64 <linktest+0x150>
     d5a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5c:	4615                	li	a2,5
     d5e:	00005597          	auipc	a1,0x5
     d62:	30258593          	addi	a1,a1,770 # 6060 <malloc+0x618>
     d66:	00005097          	auipc	ra,0x5
     d6a:	8c0080e7          	jalr	-1856(ra) # 5626 <write>
     d6e:	4795                	li	a5,5
     d70:	10f51863          	bne	a0,a5,e80 <linktest+0x16c>
  close(fd);
     d74:	8526                	mv	a0,s1
     d76:	00005097          	auipc	ra,0x5
     d7a:	8b8080e7          	jalr	-1864(ra) # 562e <close>
  if(link("lf1", "lf2") < 0){
     d7e:	00005597          	auipc	a1,0x5
     d82:	39a58593          	addi	a1,a1,922 # 6118 <malloc+0x6d0>
     d86:	00005517          	auipc	a0,0x5
     d8a:	38a50513          	addi	a0,a0,906 # 6110 <malloc+0x6c8>
     d8e:	00005097          	auipc	ra,0x5
     d92:	8d8080e7          	jalr	-1832(ra) # 5666 <link>
     d96:	10054363          	bltz	a0,e9c <linktest+0x188>
  unlink("lf1");
     d9a:	00005517          	auipc	a0,0x5
     d9e:	37650513          	addi	a0,a0,886 # 6110 <malloc+0x6c8>
     da2:	00005097          	auipc	ra,0x5
     da6:	8b4080e7          	jalr	-1868(ra) # 5656 <unlink>
  if(open("lf1", 0) >= 0){
     daa:	4581                	li	a1,0
     dac:	00005517          	auipc	a0,0x5
     db0:	36450513          	addi	a0,a0,868 # 6110 <malloc+0x6c8>
     db4:	00005097          	auipc	ra,0x5
     db8:	892080e7          	jalr	-1902(ra) # 5646 <open>
     dbc:	0e055e63          	bgez	a0,eb8 <linktest+0x1a4>
  fd = open("lf2", 0);
     dc0:	4581                	li	a1,0
     dc2:	00005517          	auipc	a0,0x5
     dc6:	35650513          	addi	a0,a0,854 # 6118 <malloc+0x6d0>
     dca:	00005097          	auipc	ra,0x5
     dce:	87c080e7          	jalr	-1924(ra) # 5646 <open>
     dd2:	84aa                	mv	s1,a0
  if(fd < 0){
     dd4:	10054063          	bltz	a0,ed4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dd8:	660d                	lui	a2,0x3
     dda:	0000b597          	auipc	a1,0xb
     dde:	d1e58593          	addi	a1,a1,-738 # baf8 <buf>
     de2:	00005097          	auipc	ra,0x5
     de6:	83c080e7          	jalr	-1988(ra) # 561e <read>
     dea:	4795                	li	a5,5
     dec:	10f51263          	bne	a0,a5,ef0 <linktest+0x1dc>
  close(fd);
     df0:	8526                	mv	a0,s1
     df2:	00005097          	auipc	ra,0x5
     df6:	83c080e7          	jalr	-1988(ra) # 562e <close>
  if(link("lf2", "lf2") >= 0){
     dfa:	00005597          	auipc	a1,0x5
     dfe:	31e58593          	addi	a1,a1,798 # 6118 <malloc+0x6d0>
     e02:	852e                	mv	a0,a1
     e04:	00005097          	auipc	ra,0x5
     e08:	862080e7          	jalr	-1950(ra) # 5666 <link>
     e0c:	10055063          	bgez	a0,f0c <linktest+0x1f8>
  unlink("lf2");
     e10:	00005517          	auipc	a0,0x5
     e14:	30850513          	addi	a0,a0,776 # 6118 <malloc+0x6d0>
     e18:	00005097          	auipc	ra,0x5
     e1c:	83e080e7          	jalr	-1986(ra) # 5656 <unlink>
  if(link("lf2", "lf1") >= 0){
     e20:	00005597          	auipc	a1,0x5
     e24:	2f058593          	addi	a1,a1,752 # 6110 <malloc+0x6c8>
     e28:	00005517          	auipc	a0,0x5
     e2c:	2f050513          	addi	a0,a0,752 # 6118 <malloc+0x6d0>
     e30:	00005097          	auipc	ra,0x5
     e34:	836080e7          	jalr	-1994(ra) # 5666 <link>
     e38:	0e055863          	bgez	a0,f28 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3c:	00005597          	auipc	a1,0x5
     e40:	2d458593          	addi	a1,a1,724 # 6110 <malloc+0x6c8>
     e44:	00005517          	auipc	a0,0x5
     e48:	3dc50513          	addi	a0,a0,988 # 6220 <malloc+0x7d8>
     e4c:	00005097          	auipc	ra,0x5
     e50:	81a080e7          	jalr	-2022(ra) # 5666 <link>
     e54:	0e055863          	bgez	a0,f44 <linktest+0x230>
}
     e58:	60e2                	ld	ra,24(sp)
     e5a:	6442                	ld	s0,16(sp)
     e5c:	64a2                	ld	s1,8(sp)
     e5e:	6902                	ld	s2,0(sp)
     e60:	6105                	addi	sp,sp,32
     e62:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e64:	85ca                	mv	a1,s2
     e66:	00005517          	auipc	a0,0x5
     e6a:	2ba50513          	addi	a0,a0,698 # 6120 <malloc+0x6d8>
     e6e:	00005097          	auipc	ra,0x5
     e72:	b22080e7          	jalr	-1246(ra) # 5990 <printf>
    exit(1);
     e76:	4505                	li	a0,1
     e78:	00004097          	auipc	ra,0x4
     e7c:	78e080e7          	jalr	1934(ra) # 5606 <exit>
    printf("%s: write lf1 failed\n", s);
     e80:	85ca                	mv	a1,s2
     e82:	00005517          	auipc	a0,0x5
     e86:	2b650513          	addi	a0,a0,694 # 6138 <malloc+0x6f0>
     e8a:	00005097          	auipc	ra,0x5
     e8e:	b06080e7          	jalr	-1274(ra) # 5990 <printf>
    exit(1);
     e92:	4505                	li	a0,1
     e94:	00004097          	auipc	ra,0x4
     e98:	772080e7          	jalr	1906(ra) # 5606 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9c:	85ca                	mv	a1,s2
     e9e:	00005517          	auipc	a0,0x5
     ea2:	2b250513          	addi	a0,a0,690 # 6150 <malloc+0x708>
     ea6:	00005097          	auipc	ra,0x5
     eaa:	aea080e7          	jalr	-1302(ra) # 5990 <printf>
    exit(1);
     eae:	4505                	li	a0,1
     eb0:	00004097          	auipc	ra,0x4
     eb4:	756080e7          	jalr	1878(ra) # 5606 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eb8:	85ca                	mv	a1,s2
     eba:	00005517          	auipc	a0,0x5
     ebe:	2b650513          	addi	a0,a0,694 # 6170 <malloc+0x728>
     ec2:	00005097          	auipc	ra,0x5
     ec6:	ace080e7          	jalr	-1330(ra) # 5990 <printf>
    exit(1);
     eca:	4505                	li	a0,1
     ecc:	00004097          	auipc	ra,0x4
     ed0:	73a080e7          	jalr	1850(ra) # 5606 <exit>
    printf("%s: open lf2 failed\n", s);
     ed4:	85ca                	mv	a1,s2
     ed6:	00005517          	auipc	a0,0x5
     eda:	2ca50513          	addi	a0,a0,714 # 61a0 <malloc+0x758>
     ede:	00005097          	auipc	ra,0x5
     ee2:	ab2080e7          	jalr	-1358(ra) # 5990 <printf>
    exit(1);
     ee6:	4505                	li	a0,1
     ee8:	00004097          	auipc	ra,0x4
     eec:	71e080e7          	jalr	1822(ra) # 5606 <exit>
    printf("%s: read lf2 failed\n", s);
     ef0:	85ca                	mv	a1,s2
     ef2:	00005517          	auipc	a0,0x5
     ef6:	2c650513          	addi	a0,a0,710 # 61b8 <malloc+0x770>
     efa:	00005097          	auipc	ra,0x5
     efe:	a96080e7          	jalr	-1386(ra) # 5990 <printf>
    exit(1);
     f02:	4505                	li	a0,1
     f04:	00004097          	auipc	ra,0x4
     f08:	702080e7          	jalr	1794(ra) # 5606 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0c:	85ca                	mv	a1,s2
     f0e:	00005517          	auipc	a0,0x5
     f12:	2c250513          	addi	a0,a0,706 # 61d0 <malloc+0x788>
     f16:	00005097          	auipc	ra,0x5
     f1a:	a7a080e7          	jalr	-1414(ra) # 5990 <printf>
    exit(1);
     f1e:	4505                	li	a0,1
     f20:	00004097          	auipc	ra,0x4
     f24:	6e6080e7          	jalr	1766(ra) # 5606 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f28:	85ca                	mv	a1,s2
     f2a:	00005517          	auipc	a0,0x5
     f2e:	2ce50513          	addi	a0,a0,718 # 61f8 <malloc+0x7b0>
     f32:	00005097          	auipc	ra,0x5
     f36:	a5e080e7          	jalr	-1442(ra) # 5990 <printf>
    exit(1);
     f3a:	4505                	li	a0,1
     f3c:	00004097          	auipc	ra,0x4
     f40:	6ca080e7          	jalr	1738(ra) # 5606 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f44:	85ca                	mv	a1,s2
     f46:	00005517          	auipc	a0,0x5
     f4a:	2e250513          	addi	a0,a0,738 # 6228 <malloc+0x7e0>
     f4e:	00005097          	auipc	ra,0x5
     f52:	a42080e7          	jalr	-1470(ra) # 5990 <printf>
    exit(1);
     f56:	4505                	li	a0,1
     f58:	00004097          	auipc	ra,0x4
     f5c:	6ae080e7          	jalr	1710(ra) # 5606 <exit>

0000000000000f60 <bigdir>:
{
     f60:	715d                	addi	sp,sp,-80
     f62:	e486                	sd	ra,72(sp)
     f64:	e0a2                	sd	s0,64(sp)
     f66:	fc26                	sd	s1,56(sp)
     f68:	f84a                	sd	s2,48(sp)
     f6a:	f44e                	sd	s3,40(sp)
     f6c:	f052                	sd	s4,32(sp)
     f6e:	ec56                	sd	s5,24(sp)
     f70:	e85a                	sd	s6,16(sp)
     f72:	0880                	addi	s0,sp,80
     f74:	89aa                	mv	s3,a0
  unlink("bd");
     f76:	00005517          	auipc	a0,0x5
     f7a:	2d250513          	addi	a0,a0,722 # 6248 <malloc+0x800>
     f7e:	00004097          	auipc	ra,0x4
     f82:	6d8080e7          	jalr	1752(ra) # 5656 <unlink>
  fd = open("bd", O_CREATE);
     f86:	20000593          	li	a1,512
     f8a:	00005517          	auipc	a0,0x5
     f8e:	2be50513          	addi	a0,a0,702 # 6248 <malloc+0x800>
     f92:	00004097          	auipc	ra,0x4
     f96:	6b4080e7          	jalr	1716(ra) # 5646 <open>
  if(fd < 0){
     f9a:	0c054963          	bltz	a0,106c <bigdir+0x10c>
  close(fd);
     f9e:	00004097          	auipc	ra,0x4
     fa2:	690080e7          	jalr	1680(ra) # 562e <close>
  for(i = 0; i < N; i++){
     fa6:	4901                	li	s2,0
    name[0] = 'x';
     fa8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fac:	00005a17          	auipc	s4,0x5
     fb0:	29ca0a13          	addi	s4,s4,668 # 6248 <malloc+0x800>
  for(i = 0; i < N; i++){
     fb4:	1f400b13          	li	s6,500
    name[0] = 'x';
     fb8:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbc:	41f9571b          	sraiw	a4,s2,0x1f
     fc0:	01a7571b          	srliw	a4,a4,0x1a
     fc4:	012707bb          	addw	a5,a4,s2
     fc8:	4067d69b          	sraiw	a3,a5,0x6
     fcc:	0306869b          	addiw	a3,a3,48
     fd0:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd4:	03f7f793          	andi	a5,a5,63
     fd8:	9f99                	subw	a5,a5,a4
     fda:	0307879b          	addiw	a5,a5,48
     fde:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe2:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe6:	fb040593          	addi	a1,s0,-80
     fea:	8552                	mv	a0,s4
     fec:	00004097          	auipc	ra,0x4
     ff0:	67a080e7          	jalr	1658(ra) # 5666 <link>
     ff4:	84aa                	mv	s1,a0
     ff6:	e949                	bnez	a0,1088 <bigdir+0x128>
  for(i = 0; i < N; i++){
     ff8:	2905                	addiw	s2,s2,1
     ffa:	fb691fe3          	bne	s2,s6,fb8 <bigdir+0x58>
  unlink("bd");
     ffe:	00005517          	auipc	a0,0x5
    1002:	24a50513          	addi	a0,a0,586 # 6248 <malloc+0x800>
    1006:	00004097          	auipc	ra,0x4
    100a:	650080e7          	jalr	1616(ra) # 5656 <unlink>
    name[0] = 'x';
    100e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1012:	1f400a13          	li	s4,500
    name[0] = 'x';
    1016:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101a:	41f4d71b          	sraiw	a4,s1,0x1f
    101e:	01a7571b          	srliw	a4,a4,0x1a
    1022:	009707bb          	addw	a5,a4,s1
    1026:	4067d69b          	sraiw	a3,a5,0x6
    102a:	0306869b          	addiw	a3,a3,48
    102e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1032:	03f7f793          	andi	a5,a5,63
    1036:	9f99                	subw	a5,a5,a4
    1038:	0307879b          	addiw	a5,a5,48
    103c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1040:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1044:	fb040513          	addi	a0,s0,-80
    1048:	00004097          	auipc	ra,0x4
    104c:	60e080e7          	jalr	1550(ra) # 5656 <unlink>
    1050:	ed21                	bnez	a0,10a8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    1052:	2485                	addiw	s1,s1,1
    1054:	fd4491e3          	bne	s1,s4,1016 <bigdir+0xb6>
}
    1058:	60a6                	ld	ra,72(sp)
    105a:	6406                	ld	s0,64(sp)
    105c:	74e2                	ld	s1,56(sp)
    105e:	7942                	ld	s2,48(sp)
    1060:	79a2                	ld	s3,40(sp)
    1062:	7a02                	ld	s4,32(sp)
    1064:	6ae2                	ld	s5,24(sp)
    1066:	6b42                	ld	s6,16(sp)
    1068:	6161                	addi	sp,sp,80
    106a:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106c:	85ce                	mv	a1,s3
    106e:	00005517          	auipc	a0,0x5
    1072:	1e250513          	addi	a0,a0,482 # 6250 <malloc+0x808>
    1076:	00005097          	auipc	ra,0x5
    107a:	91a080e7          	jalr	-1766(ra) # 5990 <printf>
    exit(1);
    107e:	4505                	li	a0,1
    1080:	00004097          	auipc	ra,0x4
    1084:	586080e7          	jalr	1414(ra) # 5606 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1088:	fb040613          	addi	a2,s0,-80
    108c:	85ce                	mv	a1,s3
    108e:	00005517          	auipc	a0,0x5
    1092:	1e250513          	addi	a0,a0,482 # 6270 <malloc+0x828>
    1096:	00005097          	auipc	ra,0x5
    109a:	8fa080e7          	jalr	-1798(ra) # 5990 <printf>
      exit(1);
    109e:	4505                	li	a0,1
    10a0:	00004097          	auipc	ra,0x4
    10a4:	566080e7          	jalr	1382(ra) # 5606 <exit>
      printf("%s: bigdir unlink failed", s);
    10a8:	85ce                	mv	a1,s3
    10aa:	00005517          	auipc	a0,0x5
    10ae:	1e650513          	addi	a0,a0,486 # 6290 <malloc+0x848>
    10b2:	00005097          	auipc	ra,0x5
    10b6:	8de080e7          	jalr	-1826(ra) # 5990 <printf>
      exit(1);
    10ba:	4505                	li	a0,1
    10bc:	00004097          	auipc	ra,0x4
    10c0:	54a080e7          	jalr	1354(ra) # 5606 <exit>

00000000000010c4 <validatetest>:
{
    10c4:	7139                	addi	sp,sp,-64
    10c6:	fc06                	sd	ra,56(sp)
    10c8:	f822                	sd	s0,48(sp)
    10ca:	f426                	sd	s1,40(sp)
    10cc:	f04a                	sd	s2,32(sp)
    10ce:	ec4e                	sd	s3,24(sp)
    10d0:	e852                	sd	s4,16(sp)
    10d2:	e456                	sd	s5,8(sp)
    10d4:	e05a                	sd	s6,0(sp)
    10d6:	0080                	addi	s0,sp,64
    10d8:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10da:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10dc:	00005997          	auipc	s3,0x5
    10e0:	1d498993          	addi	s3,s3,468 # 62b0 <malloc+0x868>
    10e4:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e6:	6a85                	lui	s5,0x1
    10e8:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ec:	85a6                	mv	a1,s1
    10ee:	854e                	mv	a0,s3
    10f0:	00004097          	auipc	ra,0x4
    10f4:	576080e7          	jalr	1398(ra) # 5666 <link>
    10f8:	01251f63          	bne	a0,s2,1116 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fc:	94d6                	add	s1,s1,s5
    10fe:	ff4497e3          	bne	s1,s4,10ec <validatetest+0x28>
}
    1102:	70e2                	ld	ra,56(sp)
    1104:	7442                	ld	s0,48(sp)
    1106:	74a2                	ld	s1,40(sp)
    1108:	7902                	ld	s2,32(sp)
    110a:	69e2                	ld	s3,24(sp)
    110c:	6a42                	ld	s4,16(sp)
    110e:	6aa2                	ld	s5,8(sp)
    1110:	6b02                	ld	s6,0(sp)
    1112:	6121                	addi	sp,sp,64
    1114:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1116:	85da                	mv	a1,s6
    1118:	00005517          	auipc	a0,0x5
    111c:	1a850513          	addi	a0,a0,424 # 62c0 <malloc+0x878>
    1120:	00005097          	auipc	ra,0x5
    1124:	870080e7          	jalr	-1936(ra) # 5990 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	00004097          	auipc	ra,0x4
    112e:	4dc080e7          	jalr	1244(ra) # 5606 <exit>

0000000000001132 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1132:	7179                	addi	sp,sp,-48
    1134:	f406                	sd	ra,40(sp)
    1136:	f022                	sd	s0,32(sp)
    1138:	ec26                	sd	s1,24(sp)
    113a:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113c:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1140:	00007497          	auipc	s1,0x7
    1144:	1884b483          	ld	s1,392(s1) # 82c8 <__SDATA_BEGIN__>
    1148:	fd840593          	addi	a1,s0,-40
    114c:	8526                	mv	a0,s1
    114e:	00004097          	auipc	ra,0x4
    1152:	4f0080e7          	jalr	1264(ra) # 563e <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	4be080e7          	jalr	1214(ra) # 5616 <pipe>

  exit(0);
    1160:	4501                	li	a0,0
    1162:	00004097          	auipc	ra,0x4
    1166:	4a4080e7          	jalr	1188(ra) # 5606 <exit>

000000000000116a <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116a:	7139                	addi	sp,sp,-64
    116c:	fc06                	sd	ra,56(sp)
    116e:	f822                	sd	s0,48(sp)
    1170:	f426                	sd	s1,40(sp)
    1172:	f04a                	sd	s2,32(sp)
    1174:	ec4e                	sd	s3,24(sp)
    1176:	0080                	addi	s0,sp,64
    1178:	64b1                	lui	s1,0xc
    117a:	35048493          	addi	s1,s1,848 # c350 <buf+0x858>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    117e:	597d                	li	s2,-1
    1180:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1184:	00005997          	auipc	s3,0x5
    1188:	9e498993          	addi	s3,s3,-1564 # 5b68 <malloc+0x120>
    argv[0] = (char*)0xffffffff;
    118c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1190:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1194:	fc040593          	addi	a1,s0,-64
    1198:	854e                	mv	a0,s3
    119a:	00004097          	auipc	ra,0x4
    119e:	4a4080e7          	jalr	1188(ra) # 563e <exec>
  for(int i = 0; i < 50000; i++){
    11a2:	34fd                	addiw	s1,s1,-1
    11a4:	f4e5                	bnez	s1,118c <badarg+0x22>
  }
  
  exit(0);
    11a6:	4501                	li	a0,0
    11a8:	00004097          	auipc	ra,0x4
    11ac:	45e080e7          	jalr	1118(ra) # 5606 <exit>

00000000000011b0 <copyinstr2>:
{
    11b0:	7155                	addi	sp,sp,-208
    11b2:	e586                	sd	ra,200(sp)
    11b4:	e1a2                	sd	s0,192(sp)
    11b6:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11b8:	f6840793          	addi	a5,s0,-152
    11bc:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c0:	07800713          	li	a4,120
    11c4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11c8:	0785                	addi	a5,a5,1
    11ca:	fed79de3          	bne	a5,a3,11c4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11ce:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d2:	f6840513          	addi	a0,s0,-152
    11d6:	00004097          	auipc	ra,0x4
    11da:	480080e7          	jalr	1152(ra) # 5656 <unlink>
  if(ret != -1){
    11de:	57fd                	li	a5,-1
    11e0:	0ef51063          	bne	a0,a5,12c0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e4:	20100593          	li	a1,513
    11e8:	f6840513          	addi	a0,s0,-152
    11ec:	00004097          	auipc	ra,0x4
    11f0:	45a080e7          	jalr	1114(ra) # 5646 <open>
  if(fd != -1){
    11f4:	57fd                	li	a5,-1
    11f6:	0ef51563          	bne	a0,a5,12e0 <copyinstr2+0x130>
  ret = link(b, b);
    11fa:	f6840593          	addi	a1,s0,-152
    11fe:	852e                	mv	a0,a1
    1200:	00004097          	auipc	ra,0x4
    1204:	466080e7          	jalr	1126(ra) # 5666 <link>
  if(ret != -1){
    1208:	57fd                	li	a5,-1
    120a:	0ef51b63          	bne	a0,a5,1300 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    120e:	00006797          	auipc	a5,0x6
    1212:	29278793          	addi	a5,a5,658 # 74a0 <malloc+0x1a58>
    1216:	f4f43c23          	sd	a5,-168(s0)
    121a:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    121e:	f5840593          	addi	a1,s0,-168
    1222:	f6840513          	addi	a0,s0,-152
    1226:	00004097          	auipc	ra,0x4
    122a:	418080e7          	jalr	1048(ra) # 563e <exec>
  if(ret != -1){
    122e:	57fd                	li	a5,-1
    1230:	0ef51963          	bne	a0,a5,1322 <copyinstr2+0x172>
  int pid = fork();
    1234:	00004097          	auipc	ra,0x4
    1238:	3ca080e7          	jalr	970(ra) # 55fe <fork>
  if(pid < 0){
    123c:	10054363          	bltz	a0,1342 <copyinstr2+0x192>
  if(pid == 0){
    1240:	12051463          	bnez	a0,1368 <copyinstr2+0x1b8>
    1244:	00007797          	auipc	a5,0x7
    1248:	19c78793          	addi	a5,a5,412 # 83e0 <big.0>
    124c:	00008697          	auipc	a3,0x8
    1250:	19468693          	addi	a3,a3,404 # 93e0 <__global_pointer$+0x918>
      big[i] = 'x';
    1254:	07800713          	li	a4,120
    1258:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125c:	0785                	addi	a5,a5,1
    125e:	fed79de3          	bne	a5,a3,1258 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1262:	00008797          	auipc	a5,0x8
    1266:	16078f23          	sb	zero,382(a5) # 93e0 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126a:	00007797          	auipc	a5,0x7
    126e:	c1678793          	addi	a5,a5,-1002 # 7e80 <malloc+0x2438>
    1272:	6390                	ld	a2,0(a5)
    1274:	6794                	ld	a3,8(a5)
    1276:	6b98                	ld	a4,16(a5)
    1278:	6f9c                	ld	a5,24(a5)
    127a:	f2c43823          	sd	a2,-208(s0)
    127e:	f2d43c23          	sd	a3,-200(s0)
    1282:	f4e43023          	sd	a4,-192(s0)
    1286:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128a:	f3040593          	addi	a1,s0,-208
    128e:	00005517          	auipc	a0,0x5
    1292:	8da50513          	addi	a0,a0,-1830 # 5b68 <malloc+0x120>
    1296:	00004097          	auipc	ra,0x4
    129a:	3a8080e7          	jalr	936(ra) # 563e <exec>
    if(ret != -1){
    129e:	57fd                	li	a5,-1
    12a0:	0af50e63          	beq	a0,a5,135c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a4:	55fd                	li	a1,-1
    12a6:	00005517          	auipc	a0,0x5
    12aa:	0c250513          	addi	a0,a0,194 # 6368 <malloc+0x920>
    12ae:	00004097          	auipc	ra,0x4
    12b2:	6e2080e7          	jalr	1762(ra) # 5990 <printf>
      exit(1);
    12b6:	4505                	li	a0,1
    12b8:	00004097          	auipc	ra,0x4
    12bc:	34e080e7          	jalr	846(ra) # 5606 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c0:	862a                	mv	a2,a0
    12c2:	f6840593          	addi	a1,s0,-152
    12c6:	00005517          	auipc	a0,0x5
    12ca:	01a50513          	addi	a0,a0,26 # 62e0 <malloc+0x898>
    12ce:	00004097          	auipc	ra,0x4
    12d2:	6c2080e7          	jalr	1730(ra) # 5990 <printf>
    exit(1);
    12d6:	4505                	li	a0,1
    12d8:	00004097          	auipc	ra,0x4
    12dc:	32e080e7          	jalr	814(ra) # 5606 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e0:	862a                	mv	a2,a0
    12e2:	f6840593          	addi	a1,s0,-152
    12e6:	00005517          	auipc	a0,0x5
    12ea:	01a50513          	addi	a0,a0,26 # 6300 <malloc+0x8b8>
    12ee:	00004097          	auipc	ra,0x4
    12f2:	6a2080e7          	jalr	1698(ra) # 5990 <printf>
    exit(1);
    12f6:	4505                	li	a0,1
    12f8:	00004097          	auipc	ra,0x4
    12fc:	30e080e7          	jalr	782(ra) # 5606 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1300:	86aa                	mv	a3,a0
    1302:	f6840613          	addi	a2,s0,-152
    1306:	85b2                	mv	a1,a2
    1308:	00005517          	auipc	a0,0x5
    130c:	01850513          	addi	a0,a0,24 # 6320 <malloc+0x8d8>
    1310:	00004097          	auipc	ra,0x4
    1314:	680080e7          	jalr	1664(ra) # 5990 <printf>
    exit(1);
    1318:	4505                	li	a0,1
    131a:	00004097          	auipc	ra,0x4
    131e:	2ec080e7          	jalr	748(ra) # 5606 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1322:	567d                	li	a2,-1
    1324:	f6840593          	addi	a1,s0,-152
    1328:	00005517          	auipc	a0,0x5
    132c:	02050513          	addi	a0,a0,32 # 6348 <malloc+0x900>
    1330:	00004097          	auipc	ra,0x4
    1334:	660080e7          	jalr	1632(ra) # 5990 <printf>
    exit(1);
    1338:	4505                	li	a0,1
    133a:	00004097          	auipc	ra,0x4
    133e:	2cc080e7          	jalr	716(ra) # 5606 <exit>
    printf("fork failed\n");
    1342:	00005517          	auipc	a0,0x5
    1346:	48650513          	addi	a0,a0,1158 # 67c8 <malloc+0xd80>
    134a:	00004097          	auipc	ra,0x4
    134e:	646080e7          	jalr	1606(ra) # 5990 <printf>
    exit(1);
    1352:	4505                	li	a0,1
    1354:	00004097          	auipc	ra,0x4
    1358:	2b2080e7          	jalr	690(ra) # 5606 <exit>
    exit(747); // OK
    135c:	2eb00513          	li	a0,747
    1360:	00004097          	auipc	ra,0x4
    1364:	2a6080e7          	jalr	678(ra) # 5606 <exit>
  int st = 0;
    1368:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136c:	f5440513          	addi	a0,s0,-172
    1370:	00004097          	auipc	ra,0x4
    1374:	29e080e7          	jalr	670(ra) # 560e <wait>
  if(st != 747){
    1378:	f5442703          	lw	a4,-172(s0)
    137c:	2eb00793          	li	a5,747
    1380:	00f71663          	bne	a4,a5,138c <copyinstr2+0x1dc>
}
    1384:	60ae                	ld	ra,200(sp)
    1386:	640e                	ld	s0,192(sp)
    1388:	6169                	addi	sp,sp,208
    138a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138c:	00005517          	auipc	a0,0x5
    1390:	00450513          	addi	a0,a0,4 # 6390 <malloc+0x948>
    1394:	00004097          	auipc	ra,0x4
    1398:	5fc080e7          	jalr	1532(ra) # 5990 <printf>
    exit(1);
    139c:	4505                	li	a0,1
    139e:	00004097          	auipc	ra,0x4
    13a2:	268080e7          	jalr	616(ra) # 5606 <exit>

00000000000013a6 <truncate3>:
{
    13a6:	7159                	addi	sp,sp,-112
    13a8:	f486                	sd	ra,104(sp)
    13aa:	f0a2                	sd	s0,96(sp)
    13ac:	eca6                	sd	s1,88(sp)
    13ae:	e8ca                	sd	s2,80(sp)
    13b0:	e4ce                	sd	s3,72(sp)
    13b2:	e0d2                	sd	s4,64(sp)
    13b4:	fc56                	sd	s5,56(sp)
    13b6:	1880                	addi	s0,sp,112
    13b8:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13ba:	60100593          	li	a1,1537
    13be:	00005517          	auipc	a0,0x5
    13c2:	80250513          	addi	a0,a0,-2046 # 5bc0 <malloc+0x178>
    13c6:	00004097          	auipc	ra,0x4
    13ca:	280080e7          	jalr	640(ra) # 5646 <open>
    13ce:	00004097          	auipc	ra,0x4
    13d2:	260080e7          	jalr	608(ra) # 562e <close>
  pid = fork();
    13d6:	00004097          	auipc	ra,0x4
    13da:	228080e7          	jalr	552(ra) # 55fe <fork>
  if(pid < 0){
    13de:	08054063          	bltz	a0,145e <truncate3+0xb8>
  if(pid == 0){
    13e2:	e969                	bnez	a0,14b4 <truncate3+0x10e>
    13e4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13e8:	00004a17          	auipc	s4,0x4
    13ec:	7d8a0a13          	addi	s4,s4,2008 # 5bc0 <malloc+0x178>
      int n = write(fd, "1234567890", 10);
    13f0:	00005a97          	auipc	s5,0x5
    13f4:	000a8a93          	mv	s5,s5
      int fd = open("truncfile", O_WRONLY);
    13f8:	4585                	li	a1,1
    13fa:	8552                	mv	a0,s4
    13fc:	00004097          	auipc	ra,0x4
    1400:	24a080e7          	jalr	586(ra) # 5646 <open>
    1404:	84aa                	mv	s1,a0
      if(fd < 0){
    1406:	06054a63          	bltz	a0,147a <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140a:	4629                	li	a2,10
    140c:	85d6                	mv	a1,s5
    140e:	00004097          	auipc	ra,0x4
    1412:	218080e7          	jalr	536(ra) # 5626 <write>
      if(n != 10){
    1416:	47a9                	li	a5,10
    1418:	06f51f63          	bne	a0,a5,1496 <truncate3+0xf0>
      close(fd);
    141c:	8526                	mv	a0,s1
    141e:	00004097          	auipc	ra,0x4
    1422:	210080e7          	jalr	528(ra) # 562e <close>
      fd = open("truncfile", O_RDONLY);
    1426:	4581                	li	a1,0
    1428:	8552                	mv	a0,s4
    142a:	00004097          	auipc	ra,0x4
    142e:	21c080e7          	jalr	540(ra) # 5646 <open>
    1432:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1434:	02000613          	li	a2,32
    1438:	f9840593          	addi	a1,s0,-104
    143c:	00004097          	auipc	ra,0x4
    1440:	1e2080e7          	jalr	482(ra) # 561e <read>
      close(fd);
    1444:	8526                	mv	a0,s1
    1446:	00004097          	auipc	ra,0x4
    144a:	1e8080e7          	jalr	488(ra) # 562e <close>
    for(int i = 0; i < 100; i++){
    144e:	39fd                	addiw	s3,s3,-1
    1450:	fa0994e3          	bnez	s3,13f8 <truncate3+0x52>
    exit(0);
    1454:	4501                	li	a0,0
    1456:	00004097          	auipc	ra,0x4
    145a:	1b0080e7          	jalr	432(ra) # 5606 <exit>
    printf("%s: fork failed\n", s);
    145e:	85ca                	mv	a1,s2
    1460:	00005517          	auipc	a0,0x5
    1464:	f6050513          	addi	a0,a0,-160 # 63c0 <malloc+0x978>
    1468:	00004097          	auipc	ra,0x4
    146c:	528080e7          	jalr	1320(ra) # 5990 <printf>
    exit(1);
    1470:	4505                	li	a0,1
    1472:	00004097          	auipc	ra,0x4
    1476:	194080e7          	jalr	404(ra) # 5606 <exit>
        printf("%s: open failed\n", s);
    147a:	85ca                	mv	a1,s2
    147c:	00005517          	auipc	a0,0x5
    1480:	f5c50513          	addi	a0,a0,-164 # 63d8 <malloc+0x990>
    1484:	00004097          	auipc	ra,0x4
    1488:	50c080e7          	jalr	1292(ra) # 5990 <printf>
        exit(1);
    148c:	4505                	li	a0,1
    148e:	00004097          	auipc	ra,0x4
    1492:	178080e7          	jalr	376(ra) # 5606 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1496:	862a                	mv	a2,a0
    1498:	85ca                	mv	a1,s2
    149a:	00005517          	auipc	a0,0x5
    149e:	f6650513          	addi	a0,a0,-154 # 6400 <malloc+0x9b8>
    14a2:	00004097          	auipc	ra,0x4
    14a6:	4ee080e7          	jalr	1262(ra) # 5990 <printf>
        exit(1);
    14aa:	4505                	li	a0,1
    14ac:	00004097          	auipc	ra,0x4
    14b0:	15a080e7          	jalr	346(ra) # 5606 <exit>
    14b4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14b8:	00004a17          	auipc	s4,0x4
    14bc:	708a0a13          	addi	s4,s4,1800 # 5bc0 <malloc+0x178>
    int n = write(fd, "xxx", 3);
    14c0:	00005a97          	auipc	s5,0x5
    14c4:	f60a8a93          	addi	s5,s5,-160 # 6420 <malloc+0x9d8>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c8:	60100593          	li	a1,1537
    14cc:	8552                	mv	a0,s4
    14ce:	00004097          	auipc	ra,0x4
    14d2:	178080e7          	jalr	376(ra) # 5646 <open>
    14d6:	84aa                	mv	s1,a0
    if(fd < 0){
    14d8:	04054763          	bltz	a0,1526 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14dc:	460d                	li	a2,3
    14de:	85d6                	mv	a1,s5
    14e0:	00004097          	auipc	ra,0x4
    14e4:	146080e7          	jalr	326(ra) # 5626 <write>
    if(n != 3){
    14e8:	478d                	li	a5,3
    14ea:	04f51c63          	bne	a0,a5,1542 <truncate3+0x19c>
    close(fd);
    14ee:	8526                	mv	a0,s1
    14f0:	00004097          	auipc	ra,0x4
    14f4:	13e080e7          	jalr	318(ra) # 562e <close>
  for(int i = 0; i < 150; i++){
    14f8:	39fd                	addiw	s3,s3,-1
    14fa:	fc0997e3          	bnez	s3,14c8 <truncate3+0x122>
  wait(&xstatus);
    14fe:	fbc40513          	addi	a0,s0,-68
    1502:	00004097          	auipc	ra,0x4
    1506:	10c080e7          	jalr	268(ra) # 560e <wait>
  unlink("truncfile");
    150a:	00004517          	auipc	a0,0x4
    150e:	6b650513          	addi	a0,a0,1718 # 5bc0 <malloc+0x178>
    1512:	00004097          	auipc	ra,0x4
    1516:	144080e7          	jalr	324(ra) # 5656 <unlink>
  exit(xstatus);
    151a:	fbc42503          	lw	a0,-68(s0)
    151e:	00004097          	auipc	ra,0x4
    1522:	0e8080e7          	jalr	232(ra) # 5606 <exit>
      printf("%s: open failed\n", s);
    1526:	85ca                	mv	a1,s2
    1528:	00005517          	auipc	a0,0x5
    152c:	eb050513          	addi	a0,a0,-336 # 63d8 <malloc+0x990>
    1530:	00004097          	auipc	ra,0x4
    1534:	460080e7          	jalr	1120(ra) # 5990 <printf>
      exit(1);
    1538:	4505                	li	a0,1
    153a:	00004097          	auipc	ra,0x4
    153e:	0cc080e7          	jalr	204(ra) # 5606 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1542:	862a                	mv	a2,a0
    1544:	85ca                	mv	a1,s2
    1546:	00005517          	auipc	a0,0x5
    154a:	ee250513          	addi	a0,a0,-286 # 6428 <malloc+0x9e0>
    154e:	00004097          	auipc	ra,0x4
    1552:	442080e7          	jalr	1090(ra) # 5990 <printf>
      exit(1);
    1556:	4505                	li	a0,1
    1558:	00004097          	auipc	ra,0x4
    155c:	0ae080e7          	jalr	174(ra) # 5606 <exit>

0000000000001560 <exectest>:
{
    1560:	715d                	addi	sp,sp,-80
    1562:	e486                	sd	ra,72(sp)
    1564:	e0a2                	sd	s0,64(sp)
    1566:	fc26                	sd	s1,56(sp)
    1568:	f84a                	sd	s2,48(sp)
    156a:	0880                	addi	s0,sp,80
    156c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    156e:	00004797          	auipc	a5,0x4
    1572:	5fa78793          	addi	a5,a5,1530 # 5b68 <malloc+0x120>
    1576:	fcf43023          	sd	a5,-64(s0)
    157a:	00005797          	auipc	a5,0x5
    157e:	ece78793          	addi	a5,a5,-306 # 6448 <malloc+0xa00>
    1582:	fcf43423          	sd	a5,-56(s0)
    1586:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158a:	00005517          	auipc	a0,0x5
    158e:	ec650513          	addi	a0,a0,-314 # 6450 <malloc+0xa08>
    1592:	00004097          	auipc	ra,0x4
    1596:	0c4080e7          	jalr	196(ra) # 5656 <unlink>
  pid = fork();
    159a:	00004097          	auipc	ra,0x4
    159e:	064080e7          	jalr	100(ra) # 55fe <fork>
  if(pid < 0) {
    15a2:	04054663          	bltz	a0,15ee <exectest+0x8e>
    15a6:	84aa                	mv	s1,a0
  if(pid == 0) {
    15a8:	e959                	bnez	a0,163e <exectest+0xde>
    close(1);
    15aa:	4505                	li	a0,1
    15ac:	00004097          	auipc	ra,0x4
    15b0:	082080e7          	jalr	130(ra) # 562e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b4:	20100593          	li	a1,513
    15b8:	00005517          	auipc	a0,0x5
    15bc:	e9850513          	addi	a0,a0,-360 # 6450 <malloc+0xa08>
    15c0:	00004097          	auipc	ra,0x4
    15c4:	086080e7          	jalr	134(ra) # 5646 <open>
    if(fd < 0) {
    15c8:	04054163          	bltz	a0,160a <exectest+0xaa>
    if(fd != 1) {
    15cc:	4785                	li	a5,1
    15ce:	04f50c63          	beq	a0,a5,1626 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d2:	85ca                	mv	a1,s2
    15d4:	00005517          	auipc	a0,0x5
    15d8:	e9c50513          	addi	a0,a0,-356 # 6470 <malloc+0xa28>
    15dc:	00004097          	auipc	ra,0x4
    15e0:	3b4080e7          	jalr	948(ra) # 5990 <printf>
      exit(1);
    15e4:	4505                	li	a0,1
    15e6:	00004097          	auipc	ra,0x4
    15ea:	020080e7          	jalr	32(ra) # 5606 <exit>
     printf("%s: fork failed\n", s);
    15ee:	85ca                	mv	a1,s2
    15f0:	00005517          	auipc	a0,0x5
    15f4:	dd050513          	addi	a0,a0,-560 # 63c0 <malloc+0x978>
    15f8:	00004097          	auipc	ra,0x4
    15fc:	398080e7          	jalr	920(ra) # 5990 <printf>
     exit(1);
    1600:	4505                	li	a0,1
    1602:	00004097          	auipc	ra,0x4
    1606:	004080e7          	jalr	4(ra) # 5606 <exit>
      printf("%s: create failed\n", s);
    160a:	85ca                	mv	a1,s2
    160c:	00005517          	auipc	a0,0x5
    1610:	e4c50513          	addi	a0,a0,-436 # 6458 <malloc+0xa10>
    1614:	00004097          	auipc	ra,0x4
    1618:	37c080e7          	jalr	892(ra) # 5990 <printf>
      exit(1);
    161c:	4505                	li	a0,1
    161e:	00004097          	auipc	ra,0x4
    1622:	fe8080e7          	jalr	-24(ra) # 5606 <exit>
    if(exec("echo", echoargv) < 0){
    1626:	fc040593          	addi	a1,s0,-64
    162a:	00004517          	auipc	a0,0x4
    162e:	53e50513          	addi	a0,a0,1342 # 5b68 <malloc+0x120>
    1632:	00004097          	auipc	ra,0x4
    1636:	00c080e7          	jalr	12(ra) # 563e <exec>
    163a:	02054163          	bltz	a0,165c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    163e:	fdc40513          	addi	a0,s0,-36
    1642:	00004097          	auipc	ra,0x4
    1646:	fcc080e7          	jalr	-52(ra) # 560e <wait>
    164a:	02951763          	bne	a0,s1,1678 <exectest+0x118>
  if(xstatus != 0)
    164e:	fdc42503          	lw	a0,-36(s0)
    1652:	cd0d                	beqz	a0,168c <exectest+0x12c>
    exit(xstatus);
    1654:	00004097          	auipc	ra,0x4
    1658:	fb2080e7          	jalr	-78(ra) # 5606 <exit>
      printf("%s: exec echo failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	e2250513          	addi	a0,a0,-478 # 6480 <malloc+0xa38>
    1666:	00004097          	auipc	ra,0x4
    166a:	32a080e7          	jalr	810(ra) # 5990 <printf>
      exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	f96080e7          	jalr	-106(ra) # 5606 <exit>
    printf("%s: wait failed!\n", s);
    1678:	85ca                	mv	a1,s2
    167a:	00005517          	auipc	a0,0x5
    167e:	e1e50513          	addi	a0,a0,-482 # 6498 <malloc+0xa50>
    1682:	00004097          	auipc	ra,0x4
    1686:	30e080e7          	jalr	782(ra) # 5990 <printf>
    168a:	b7d1                	j	164e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168c:	4581                	li	a1,0
    168e:	00005517          	auipc	a0,0x5
    1692:	dc250513          	addi	a0,a0,-574 # 6450 <malloc+0xa08>
    1696:	00004097          	auipc	ra,0x4
    169a:	fb0080e7          	jalr	-80(ra) # 5646 <open>
  if(fd < 0) {
    169e:	02054a63          	bltz	a0,16d2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a2:	4609                	li	a2,2
    16a4:	fb840593          	addi	a1,s0,-72
    16a8:	00004097          	auipc	ra,0x4
    16ac:	f76080e7          	jalr	-138(ra) # 561e <read>
    16b0:	4789                	li	a5,2
    16b2:	02f50e63          	beq	a0,a5,16ee <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b6:	85ca                	mv	a1,s2
    16b8:	00005517          	auipc	a0,0x5
    16bc:	85050513          	addi	a0,a0,-1968 # 5f08 <malloc+0x4c0>
    16c0:	00004097          	auipc	ra,0x4
    16c4:	2d0080e7          	jalr	720(ra) # 5990 <printf>
    exit(1);
    16c8:	4505                	li	a0,1
    16ca:	00004097          	auipc	ra,0x4
    16ce:	f3c080e7          	jalr	-196(ra) # 5606 <exit>
    printf("%s: open failed\n", s);
    16d2:	85ca                	mv	a1,s2
    16d4:	00005517          	auipc	a0,0x5
    16d8:	d0450513          	addi	a0,a0,-764 # 63d8 <malloc+0x990>
    16dc:	00004097          	auipc	ra,0x4
    16e0:	2b4080e7          	jalr	692(ra) # 5990 <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00004097          	auipc	ra,0x4
    16ea:	f20080e7          	jalr	-224(ra) # 5606 <exit>
  unlink("echo-ok");
    16ee:	00005517          	auipc	a0,0x5
    16f2:	d6250513          	addi	a0,a0,-670 # 6450 <malloc+0xa08>
    16f6:	00004097          	auipc	ra,0x4
    16fa:	f60080e7          	jalr	-160(ra) # 5656 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    16fe:	fb844703          	lbu	a4,-72(s0)
    1702:	04f00793          	li	a5,79
    1706:	00f71863          	bne	a4,a5,1716 <exectest+0x1b6>
    170a:	fb944703          	lbu	a4,-71(s0)
    170e:	04b00793          	li	a5,75
    1712:	02f70063          	beq	a4,a5,1732 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1716:	85ca                	mv	a1,s2
    1718:	00005517          	auipc	a0,0x5
    171c:	d9850513          	addi	a0,a0,-616 # 64b0 <malloc+0xa68>
    1720:	00004097          	auipc	ra,0x4
    1724:	270080e7          	jalr	624(ra) # 5990 <printf>
    exit(1);
    1728:	4505                	li	a0,1
    172a:	00004097          	auipc	ra,0x4
    172e:	edc080e7          	jalr	-292(ra) # 5606 <exit>
    exit(0);
    1732:	4501                	li	a0,0
    1734:	00004097          	auipc	ra,0x4
    1738:	ed2080e7          	jalr	-302(ra) # 5606 <exit>

000000000000173c <pipe1>:
{
    173c:	711d                	addi	sp,sp,-96
    173e:	ec86                	sd	ra,88(sp)
    1740:	e8a2                	sd	s0,80(sp)
    1742:	e4a6                	sd	s1,72(sp)
    1744:	e0ca                	sd	s2,64(sp)
    1746:	fc4e                	sd	s3,56(sp)
    1748:	f852                	sd	s4,48(sp)
    174a:	f456                	sd	s5,40(sp)
    174c:	f05a                	sd	s6,32(sp)
    174e:	ec5e                	sd	s7,24(sp)
    1750:	1080                	addi	s0,sp,96
    1752:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1754:	fa840513          	addi	a0,s0,-88
    1758:	00004097          	auipc	ra,0x4
    175c:	ebe080e7          	jalr	-322(ra) # 5616 <pipe>
    1760:	e93d                	bnez	a0,17d6 <pipe1+0x9a>
    1762:	84aa                	mv	s1,a0
  pid = fork();
    1764:	00004097          	auipc	ra,0x4
    1768:	e9a080e7          	jalr	-358(ra) # 55fe <fork>
    176c:	8a2a                	mv	s4,a0
  if(pid == 0){
    176e:	c151                	beqz	a0,17f2 <pipe1+0xb6>
  } else if(pid > 0){
    1770:	16a05d63          	blez	a0,18ea <pipe1+0x1ae>
    close(fds[1]);
    1774:	fac42503          	lw	a0,-84(s0)
    1778:	00004097          	auipc	ra,0x4
    177c:	eb6080e7          	jalr	-330(ra) # 562e <close>
    total = 0;
    1780:	8a26                	mv	s4,s1
    cc = 1;
    1782:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1784:	0000aa97          	auipc	s5,0xa
    1788:	374a8a93          	addi	s5,s5,884 # baf8 <buf>
      if(cc > sizeof(buf))
    178c:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    178e:	864e                	mv	a2,s3
    1790:	85d6                	mv	a1,s5
    1792:	fa842503          	lw	a0,-88(s0)
    1796:	00004097          	auipc	ra,0x4
    179a:	e88080e7          	jalr	-376(ra) # 561e <read>
    179e:	10a05163          	blez	a0,18a0 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17a2:	0000a717          	auipc	a4,0xa
    17a6:	35670713          	addi	a4,a4,854 # baf8 <buf>
    17aa:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ae:	00074683          	lbu	a3,0(a4)
    17b2:	0ff4f793          	zext.b	a5,s1
    17b6:	2485                	addiw	s1,s1,1
    17b8:	0cf69063          	bne	a3,a5,1878 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    17bc:	0705                	addi	a4,a4,1
    17be:	fec498e3          	bne	s1,a2,17ae <pipe1+0x72>
      total += n;
    17c2:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c6:	0019979b          	slliw	a5,s3,0x1
    17ca:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17ce:	fd3b70e3          	bgeu	s6,s3,178e <pipe1+0x52>
        cc = sizeof(buf);
    17d2:	89da                	mv	s3,s6
    17d4:	bf6d                	j	178e <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17d6:	85ca                	mv	a1,s2
    17d8:	00005517          	auipc	a0,0x5
    17dc:	cf050513          	addi	a0,a0,-784 # 64c8 <malloc+0xa80>
    17e0:	00004097          	auipc	ra,0x4
    17e4:	1b0080e7          	jalr	432(ra) # 5990 <printf>
    exit(1);
    17e8:	4505                	li	a0,1
    17ea:	00004097          	auipc	ra,0x4
    17ee:	e1c080e7          	jalr	-484(ra) # 5606 <exit>
    close(fds[0]);
    17f2:	fa842503          	lw	a0,-88(s0)
    17f6:	00004097          	auipc	ra,0x4
    17fa:	e38080e7          	jalr	-456(ra) # 562e <close>
    for(n = 0; n < N; n++){
    17fe:	0000ab17          	auipc	s6,0xa
    1802:	2fab0b13          	addi	s6,s6,762 # baf8 <buf>
    1806:	416004bb          	negw	s1,s6
    180a:	0ff4f493          	zext.b	s1,s1
    180e:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1812:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1814:	6a85                	lui	s5,0x1
    1816:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x87>
{
    181a:	87da                	mv	a5,s6
        buf[i] = seq++;
    181c:	0097873b          	addw	a4,a5,s1
    1820:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1824:	0785                	addi	a5,a5,1
    1826:	fef99be3          	bne	s3,a5,181c <pipe1+0xe0>
        buf[i] = seq++;
    182a:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    182e:	40900613          	li	a2,1033
    1832:	85de                	mv	a1,s7
    1834:	fac42503          	lw	a0,-84(s0)
    1838:	00004097          	auipc	ra,0x4
    183c:	dee080e7          	jalr	-530(ra) # 5626 <write>
    1840:	40900793          	li	a5,1033
    1844:	00f51c63          	bne	a0,a5,185c <pipe1+0x120>
    for(n = 0; n < N; n++){
    1848:	24a5                	addiw	s1,s1,9
    184a:	0ff4f493          	zext.b	s1,s1
    184e:	fd5a16e3          	bne	s4,s5,181a <pipe1+0xde>
    exit(0);
    1852:	4501                	li	a0,0
    1854:	00004097          	auipc	ra,0x4
    1858:	db2080e7          	jalr	-590(ra) # 5606 <exit>
        printf("%s: pipe1 oops 1\n", s);
    185c:	85ca                	mv	a1,s2
    185e:	00005517          	auipc	a0,0x5
    1862:	c8250513          	addi	a0,a0,-894 # 64e0 <malloc+0xa98>
    1866:	00004097          	auipc	ra,0x4
    186a:	12a080e7          	jalr	298(ra) # 5990 <printf>
        exit(1);
    186e:	4505                	li	a0,1
    1870:	00004097          	auipc	ra,0x4
    1874:	d96080e7          	jalr	-618(ra) # 5606 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1878:	85ca                	mv	a1,s2
    187a:	00005517          	auipc	a0,0x5
    187e:	c7e50513          	addi	a0,a0,-898 # 64f8 <malloc+0xab0>
    1882:	00004097          	auipc	ra,0x4
    1886:	10e080e7          	jalr	270(ra) # 5990 <printf>
}
    188a:	60e6                	ld	ra,88(sp)
    188c:	6446                	ld	s0,80(sp)
    188e:	64a6                	ld	s1,72(sp)
    1890:	6906                	ld	s2,64(sp)
    1892:	79e2                	ld	s3,56(sp)
    1894:	7a42                	ld	s4,48(sp)
    1896:	7aa2                	ld	s5,40(sp)
    1898:	7b02                	ld	s6,32(sp)
    189a:	6be2                	ld	s7,24(sp)
    189c:	6125                	addi	sp,sp,96
    189e:	8082                	ret
    if(total != N * SZ){
    18a0:	6785                	lui	a5,0x1
    18a2:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x87>
    18a6:	02fa0063          	beq	s4,a5,18c6 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18aa:	85d2                	mv	a1,s4
    18ac:	00005517          	auipc	a0,0x5
    18b0:	c6450513          	addi	a0,a0,-924 # 6510 <malloc+0xac8>
    18b4:	00004097          	auipc	ra,0x4
    18b8:	0dc080e7          	jalr	220(ra) # 5990 <printf>
      exit(1);
    18bc:	4505                	li	a0,1
    18be:	00004097          	auipc	ra,0x4
    18c2:	d48080e7          	jalr	-696(ra) # 5606 <exit>
    close(fds[0]);
    18c6:	fa842503          	lw	a0,-88(s0)
    18ca:	00004097          	auipc	ra,0x4
    18ce:	d64080e7          	jalr	-668(ra) # 562e <close>
    wait(&xstatus);
    18d2:	fa440513          	addi	a0,s0,-92
    18d6:	00004097          	auipc	ra,0x4
    18da:	d38080e7          	jalr	-712(ra) # 560e <wait>
    exit(xstatus);
    18de:	fa442503          	lw	a0,-92(s0)
    18e2:	00004097          	auipc	ra,0x4
    18e6:	d24080e7          	jalr	-732(ra) # 5606 <exit>
    printf("%s: fork() failed\n", s);
    18ea:	85ca                	mv	a1,s2
    18ec:	00005517          	auipc	a0,0x5
    18f0:	c4450513          	addi	a0,a0,-956 # 6530 <malloc+0xae8>
    18f4:	00004097          	auipc	ra,0x4
    18f8:	09c080e7          	jalr	156(ra) # 5990 <printf>
    exit(1);
    18fc:	4505                	li	a0,1
    18fe:	00004097          	auipc	ra,0x4
    1902:	d08080e7          	jalr	-760(ra) # 5606 <exit>

0000000000001906 <exitwait>:
{
    1906:	7139                	addi	sp,sp,-64
    1908:	fc06                	sd	ra,56(sp)
    190a:	f822                	sd	s0,48(sp)
    190c:	f426                	sd	s1,40(sp)
    190e:	f04a                	sd	s2,32(sp)
    1910:	ec4e                	sd	s3,24(sp)
    1912:	e852                	sd	s4,16(sp)
    1914:	0080                	addi	s0,sp,64
    1916:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1918:	4901                	li	s2,0
    191a:	06400993          	li	s3,100
    pid = fork();
    191e:	00004097          	auipc	ra,0x4
    1922:	ce0080e7          	jalr	-800(ra) # 55fe <fork>
    1926:	84aa                	mv	s1,a0
    if(pid < 0){
    1928:	02054a63          	bltz	a0,195c <exitwait+0x56>
    if(pid){
    192c:	c151                	beqz	a0,19b0 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    192e:	fcc40513          	addi	a0,s0,-52
    1932:	00004097          	auipc	ra,0x4
    1936:	cdc080e7          	jalr	-804(ra) # 560e <wait>
    193a:	02951f63          	bne	a0,s1,1978 <exitwait+0x72>
      if(i != xstate) {
    193e:	fcc42783          	lw	a5,-52(s0)
    1942:	05279963          	bne	a5,s2,1994 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1946:	2905                	addiw	s2,s2,1
    1948:	fd391be3          	bne	s2,s3,191e <exitwait+0x18>
}
    194c:	70e2                	ld	ra,56(sp)
    194e:	7442                	ld	s0,48(sp)
    1950:	74a2                	ld	s1,40(sp)
    1952:	7902                	ld	s2,32(sp)
    1954:	69e2                	ld	s3,24(sp)
    1956:	6a42                	ld	s4,16(sp)
    1958:	6121                	addi	sp,sp,64
    195a:	8082                	ret
      printf("%s: fork failed\n", s);
    195c:	85d2                	mv	a1,s4
    195e:	00005517          	auipc	a0,0x5
    1962:	a6250513          	addi	a0,a0,-1438 # 63c0 <malloc+0x978>
    1966:	00004097          	auipc	ra,0x4
    196a:	02a080e7          	jalr	42(ra) # 5990 <printf>
      exit(1);
    196e:	4505                	li	a0,1
    1970:	00004097          	auipc	ra,0x4
    1974:	c96080e7          	jalr	-874(ra) # 5606 <exit>
        printf("%s: wait wrong pid\n", s);
    1978:	85d2                	mv	a1,s4
    197a:	00005517          	auipc	a0,0x5
    197e:	bce50513          	addi	a0,a0,-1074 # 6548 <malloc+0xb00>
    1982:	00004097          	auipc	ra,0x4
    1986:	00e080e7          	jalr	14(ra) # 5990 <printf>
        exit(1);
    198a:	4505                	li	a0,1
    198c:	00004097          	auipc	ra,0x4
    1990:	c7a080e7          	jalr	-902(ra) # 5606 <exit>
        printf("%s: wait wrong exit status\n", s);
    1994:	85d2                	mv	a1,s4
    1996:	00005517          	auipc	a0,0x5
    199a:	bca50513          	addi	a0,a0,-1078 # 6560 <malloc+0xb18>
    199e:	00004097          	auipc	ra,0x4
    19a2:	ff2080e7          	jalr	-14(ra) # 5990 <printf>
        exit(1);
    19a6:	4505                	li	a0,1
    19a8:	00004097          	auipc	ra,0x4
    19ac:	c5e080e7          	jalr	-930(ra) # 5606 <exit>
      exit(i);
    19b0:	854a                	mv	a0,s2
    19b2:	00004097          	auipc	ra,0x4
    19b6:	c54080e7          	jalr	-940(ra) # 5606 <exit>

00000000000019ba <twochildren>:
{
    19ba:	1101                	addi	sp,sp,-32
    19bc:	ec06                	sd	ra,24(sp)
    19be:	e822                	sd	s0,16(sp)
    19c0:	e426                	sd	s1,8(sp)
    19c2:	e04a                	sd	s2,0(sp)
    19c4:	1000                	addi	s0,sp,32
    19c6:	892a                	mv	s2,a0
    19c8:	3e800493          	li	s1,1000
    int pid1 = fork();
    19cc:	00004097          	auipc	ra,0x4
    19d0:	c32080e7          	jalr	-974(ra) # 55fe <fork>
    if(pid1 < 0){
    19d4:	02054c63          	bltz	a0,1a0c <twochildren+0x52>
    if(pid1 == 0){
    19d8:	c921                	beqz	a0,1a28 <twochildren+0x6e>
      int pid2 = fork();
    19da:	00004097          	auipc	ra,0x4
    19de:	c24080e7          	jalr	-988(ra) # 55fe <fork>
      if(pid2 < 0){
    19e2:	04054763          	bltz	a0,1a30 <twochildren+0x76>
      if(pid2 == 0){
    19e6:	c13d                	beqz	a0,1a4c <twochildren+0x92>
        wait(0);
    19e8:	4501                	li	a0,0
    19ea:	00004097          	auipc	ra,0x4
    19ee:	c24080e7          	jalr	-988(ra) # 560e <wait>
        wait(0);
    19f2:	4501                	li	a0,0
    19f4:	00004097          	auipc	ra,0x4
    19f8:	c1a080e7          	jalr	-998(ra) # 560e <wait>
  for(int i = 0; i < 1000; i++){
    19fc:	34fd                	addiw	s1,s1,-1
    19fe:	f4f9                	bnez	s1,19cc <twochildren+0x12>
}
    1a00:	60e2                	ld	ra,24(sp)
    1a02:	6442                	ld	s0,16(sp)
    1a04:	64a2                	ld	s1,8(sp)
    1a06:	6902                	ld	s2,0(sp)
    1a08:	6105                	addi	sp,sp,32
    1a0a:	8082                	ret
      printf("%s: fork failed\n", s);
    1a0c:	85ca                	mv	a1,s2
    1a0e:	00005517          	auipc	a0,0x5
    1a12:	9b250513          	addi	a0,a0,-1614 # 63c0 <malloc+0x978>
    1a16:	00004097          	auipc	ra,0x4
    1a1a:	f7a080e7          	jalr	-134(ra) # 5990 <printf>
      exit(1);
    1a1e:	4505                	li	a0,1
    1a20:	00004097          	auipc	ra,0x4
    1a24:	be6080e7          	jalr	-1050(ra) # 5606 <exit>
      exit(0);
    1a28:	00004097          	auipc	ra,0x4
    1a2c:	bde080e7          	jalr	-1058(ra) # 5606 <exit>
        printf("%s: fork failed\n", s);
    1a30:	85ca                	mv	a1,s2
    1a32:	00005517          	auipc	a0,0x5
    1a36:	98e50513          	addi	a0,a0,-1650 # 63c0 <malloc+0x978>
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	f56080e7          	jalr	-170(ra) # 5990 <printf>
        exit(1);
    1a42:	4505                	li	a0,1
    1a44:	00004097          	auipc	ra,0x4
    1a48:	bc2080e7          	jalr	-1086(ra) # 5606 <exit>
        exit(0);
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	bba080e7          	jalr	-1094(ra) # 5606 <exit>

0000000000001a54 <forkfork>:
{
    1a54:	7179                	addi	sp,sp,-48
    1a56:	f406                	sd	ra,40(sp)
    1a58:	f022                	sd	s0,32(sp)
    1a5a:	ec26                	sd	s1,24(sp)
    1a5c:	1800                	addi	s0,sp,48
    1a5e:	84aa                	mv	s1,a0
    int pid = fork();
    1a60:	00004097          	auipc	ra,0x4
    1a64:	b9e080e7          	jalr	-1122(ra) # 55fe <fork>
    if(pid < 0){
    1a68:	04054163          	bltz	a0,1aaa <forkfork+0x56>
    if(pid == 0){
    1a6c:	cd29                	beqz	a0,1ac6 <forkfork+0x72>
    int pid = fork();
    1a6e:	00004097          	auipc	ra,0x4
    1a72:	b90080e7          	jalr	-1136(ra) # 55fe <fork>
    if(pid < 0){
    1a76:	02054a63          	bltz	a0,1aaa <forkfork+0x56>
    if(pid == 0){
    1a7a:	c531                	beqz	a0,1ac6 <forkfork+0x72>
    wait(&xstatus);
    1a7c:	fdc40513          	addi	a0,s0,-36
    1a80:	00004097          	auipc	ra,0x4
    1a84:	b8e080e7          	jalr	-1138(ra) # 560e <wait>
    if(xstatus != 0) {
    1a88:	fdc42783          	lw	a5,-36(s0)
    1a8c:	ebbd                	bnez	a5,1b02 <forkfork+0xae>
    wait(&xstatus);
    1a8e:	fdc40513          	addi	a0,s0,-36
    1a92:	00004097          	auipc	ra,0x4
    1a96:	b7c080e7          	jalr	-1156(ra) # 560e <wait>
    if(xstatus != 0) {
    1a9a:	fdc42783          	lw	a5,-36(s0)
    1a9e:	e3b5                	bnez	a5,1b02 <forkfork+0xae>
}
    1aa0:	70a2                	ld	ra,40(sp)
    1aa2:	7402                	ld	s0,32(sp)
    1aa4:	64e2                	ld	s1,24(sp)
    1aa6:	6145                	addi	sp,sp,48
    1aa8:	8082                	ret
      printf("%s: fork failed", s);
    1aaa:	85a6                	mv	a1,s1
    1aac:	00005517          	auipc	a0,0x5
    1ab0:	ad450513          	addi	a0,a0,-1324 # 6580 <malloc+0xb38>
    1ab4:	00004097          	auipc	ra,0x4
    1ab8:	edc080e7          	jalr	-292(ra) # 5990 <printf>
      exit(1);
    1abc:	4505                	li	a0,1
    1abe:	00004097          	auipc	ra,0x4
    1ac2:	b48080e7          	jalr	-1208(ra) # 5606 <exit>
{
    1ac6:	0c800493          	li	s1,200
        int pid1 = fork();
    1aca:	00004097          	auipc	ra,0x4
    1ace:	b34080e7          	jalr	-1228(ra) # 55fe <fork>
        if(pid1 < 0){
    1ad2:	00054f63          	bltz	a0,1af0 <forkfork+0x9c>
        if(pid1 == 0){
    1ad6:	c115                	beqz	a0,1afa <forkfork+0xa6>
        wait(0);
    1ad8:	4501                	li	a0,0
    1ada:	00004097          	auipc	ra,0x4
    1ade:	b34080e7          	jalr	-1228(ra) # 560e <wait>
      for(int j = 0; j < 200; j++){
    1ae2:	34fd                	addiw	s1,s1,-1
    1ae4:	f0fd                	bnez	s1,1aca <forkfork+0x76>
      exit(0);
    1ae6:	4501                	li	a0,0
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	b1e080e7          	jalr	-1250(ra) # 5606 <exit>
          exit(1);
    1af0:	4505                	li	a0,1
    1af2:	00004097          	auipc	ra,0x4
    1af6:	b14080e7          	jalr	-1260(ra) # 5606 <exit>
          exit(0);
    1afa:	00004097          	auipc	ra,0x4
    1afe:	b0c080e7          	jalr	-1268(ra) # 5606 <exit>
      printf("%s: fork in child failed", s);
    1b02:	85a6                	mv	a1,s1
    1b04:	00005517          	auipc	a0,0x5
    1b08:	a8c50513          	addi	a0,a0,-1396 # 6590 <malloc+0xb48>
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	e84080e7          	jalr	-380(ra) # 5990 <printf>
      exit(1);
    1b14:	4505                	li	a0,1
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	af0080e7          	jalr	-1296(ra) # 5606 <exit>

0000000000001b1e <reparent2>:
{
    1b1e:	1101                	addi	sp,sp,-32
    1b20:	ec06                	sd	ra,24(sp)
    1b22:	e822                	sd	s0,16(sp)
    1b24:	e426                	sd	s1,8(sp)
    1b26:	1000                	addi	s0,sp,32
    1b28:	32000493          	li	s1,800
    int pid1 = fork();
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	ad2080e7          	jalr	-1326(ra) # 55fe <fork>
    if(pid1 < 0){
    1b34:	00054f63          	bltz	a0,1b52 <reparent2+0x34>
    if(pid1 == 0){
    1b38:	c915                	beqz	a0,1b6c <reparent2+0x4e>
    wait(0);
    1b3a:	4501                	li	a0,0
    1b3c:	00004097          	auipc	ra,0x4
    1b40:	ad2080e7          	jalr	-1326(ra) # 560e <wait>
  for(int i = 0; i < 800; i++){
    1b44:	34fd                	addiw	s1,s1,-1
    1b46:	f0fd                	bnez	s1,1b2c <reparent2+0xe>
  exit(0);
    1b48:	4501                	li	a0,0
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	abc080e7          	jalr	-1348(ra) # 5606 <exit>
      printf("fork failed\n");
    1b52:	00005517          	auipc	a0,0x5
    1b56:	c7650513          	addi	a0,a0,-906 # 67c8 <malloc+0xd80>
    1b5a:	00004097          	auipc	ra,0x4
    1b5e:	e36080e7          	jalr	-458(ra) # 5990 <printf>
      exit(1);
    1b62:	4505                	li	a0,1
    1b64:	00004097          	auipc	ra,0x4
    1b68:	aa2080e7          	jalr	-1374(ra) # 5606 <exit>
      fork();
    1b6c:	00004097          	auipc	ra,0x4
    1b70:	a92080e7          	jalr	-1390(ra) # 55fe <fork>
      fork();
    1b74:	00004097          	auipc	ra,0x4
    1b78:	a8a080e7          	jalr	-1398(ra) # 55fe <fork>
      exit(0);
    1b7c:	4501                	li	a0,0
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	a88080e7          	jalr	-1400(ra) # 5606 <exit>

0000000000001b86 <createdelete>:
{
    1b86:	7175                	addi	sp,sp,-144
    1b88:	e506                	sd	ra,136(sp)
    1b8a:	e122                	sd	s0,128(sp)
    1b8c:	fca6                	sd	s1,120(sp)
    1b8e:	f8ca                	sd	s2,112(sp)
    1b90:	f4ce                	sd	s3,104(sp)
    1b92:	f0d2                	sd	s4,96(sp)
    1b94:	ecd6                	sd	s5,88(sp)
    1b96:	e8da                	sd	s6,80(sp)
    1b98:	e4de                	sd	s7,72(sp)
    1b9a:	e0e2                	sd	s8,64(sp)
    1b9c:	fc66                	sd	s9,56(sp)
    1b9e:	0900                	addi	s0,sp,144
    1ba0:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba2:	4901                	li	s2,0
    1ba4:	4991                	li	s3,4
    pid = fork();
    1ba6:	00004097          	auipc	ra,0x4
    1baa:	a58080e7          	jalr	-1448(ra) # 55fe <fork>
    1bae:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb0:	02054f63          	bltz	a0,1bee <createdelete+0x68>
    if(pid == 0){
    1bb4:	c939                	beqz	a0,1c0a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bb6:	2905                	addiw	s2,s2,1
    1bb8:	ff3917e3          	bne	s2,s3,1ba6 <createdelete+0x20>
    1bbc:	4491                	li	s1,4
    wait(&xstatus);
    1bbe:	f7c40513          	addi	a0,s0,-132
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	a4c080e7          	jalr	-1460(ra) # 560e <wait>
    if(xstatus != 0)
    1bca:	f7c42903          	lw	s2,-132(s0)
    1bce:	0e091263          	bnez	s2,1cb2 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd2:	34fd                	addiw	s1,s1,-1
    1bd4:	f4ed                	bnez	s1,1bbe <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bd6:	f8040123          	sb	zero,-126(s0)
    1bda:	03000993          	li	s3,48
    1bde:	5a7d                	li	s4,-1
    1be0:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be4:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1be6:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1be8:	07400a93          	li	s5,116
    1bec:	a29d                	j	1d52 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bee:	85e6                	mv	a1,s9
    1bf0:	00005517          	auipc	a0,0x5
    1bf4:	bd850513          	addi	a0,a0,-1064 # 67c8 <malloc+0xd80>
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	d98080e7          	jalr	-616(ra) # 5990 <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	00004097          	auipc	ra,0x4
    1c06:	a04080e7          	jalr	-1532(ra) # 5606 <exit>
      name[0] = 'p' + pi;
    1c0a:	0709091b          	addiw	s2,s2,112
    1c0e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c12:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c16:	4951                	li	s2,20
    1c18:	a015                	j	1c3c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1a:	85e6                	mv	a1,s9
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	83c50513          	addi	a0,a0,-1988 # 6458 <malloc+0xa10>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	d6c080e7          	jalr	-660(ra) # 5990 <printf>
          exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	9d8080e7          	jalr	-1576(ra) # 5606 <exit>
      for(i = 0; i < N; i++){
    1c36:	2485                	addiw	s1,s1,1
    1c38:	07248863          	beq	s1,s2,1ca8 <createdelete+0x122>
        name[1] = '0' + i;
    1c3c:	0304879b          	addiw	a5,s1,48
    1c40:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c44:	20200593          	li	a1,514
    1c48:	f8040513          	addi	a0,s0,-128
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	9fa080e7          	jalr	-1542(ra) # 5646 <open>
        if(fd < 0){
    1c54:	fc0543e3          	bltz	a0,1c1a <createdelete+0x94>
        close(fd);
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	9d6080e7          	jalr	-1578(ra) # 562e <close>
        if(i > 0 && (i % 2 ) == 0){
    1c60:	fc905be3          	blez	s1,1c36 <createdelete+0xb0>
    1c64:	0014f793          	andi	a5,s1,1
    1c68:	f7f9                	bnez	a5,1c36 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6a:	01f4d79b          	srliw	a5,s1,0x1f
    1c6e:	9fa5                	addw	a5,a5,s1
    1c70:	4017d79b          	sraiw	a5,a5,0x1
    1c74:	0307879b          	addiw	a5,a5,48
    1c78:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c7c:	f8040513          	addi	a0,s0,-128
    1c80:	00004097          	auipc	ra,0x4
    1c84:	9d6080e7          	jalr	-1578(ra) # 5656 <unlink>
    1c88:	fa0557e3          	bgez	a0,1c36 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c8c:	85e6                	mv	a1,s9
    1c8e:	00005517          	auipc	a0,0x5
    1c92:	92250513          	addi	a0,a0,-1758 # 65b0 <malloc+0xb68>
    1c96:	00004097          	auipc	ra,0x4
    1c9a:	cfa080e7          	jalr	-774(ra) # 5990 <printf>
            exit(1);
    1c9e:	4505                	li	a0,1
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	966080e7          	jalr	-1690(ra) # 5606 <exit>
      exit(0);
    1ca8:	4501                	li	a0,0
    1caa:	00004097          	auipc	ra,0x4
    1cae:	95c080e7          	jalr	-1700(ra) # 5606 <exit>
      exit(1);
    1cb2:	4505                	li	a0,1
    1cb4:	00004097          	auipc	ra,0x4
    1cb8:	952080e7          	jalr	-1710(ra) # 5606 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cbc:	f8040613          	addi	a2,s0,-128
    1cc0:	85e6                	mv	a1,s9
    1cc2:	00005517          	auipc	a0,0x5
    1cc6:	90650513          	addi	a0,a0,-1786 # 65c8 <malloc+0xb80>
    1cca:	00004097          	auipc	ra,0x4
    1cce:	cc6080e7          	jalr	-826(ra) # 5990 <printf>
        exit(1);
    1cd2:	4505                	li	a0,1
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	932080e7          	jalr	-1742(ra) # 5606 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cdc:	054b7163          	bgeu	s6,s4,1d1e <createdelete+0x198>
      if(fd >= 0)
    1ce0:	02055a63          	bgez	a0,1d14 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce4:	2485                	addiw	s1,s1,1
    1ce6:	0ff4f493          	zext.b	s1,s1
    1cea:	05548c63          	beq	s1,s5,1d42 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cee:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf2:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cf6:	4581                	li	a1,0
    1cf8:	f8040513          	addi	a0,s0,-128
    1cfc:	00004097          	auipc	ra,0x4
    1d00:	94a080e7          	jalr	-1718(ra) # 5646 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d04:	00090463          	beqz	s2,1d0c <createdelete+0x186>
    1d08:	fd2bdae3          	bge	s7,s2,1cdc <createdelete+0x156>
    1d0c:	fa0548e3          	bltz	a0,1cbc <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d10:	014b7963          	bgeu	s6,s4,1d22 <createdelete+0x19c>
        close(fd);
    1d14:	00004097          	auipc	ra,0x4
    1d18:	91a080e7          	jalr	-1766(ra) # 562e <close>
    1d1c:	b7e1                	j	1ce4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1e:	fc0543e3          	bltz	a0,1ce4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d22:	f8040613          	addi	a2,s0,-128
    1d26:	85e6                	mv	a1,s9
    1d28:	00005517          	auipc	a0,0x5
    1d2c:	8c850513          	addi	a0,a0,-1848 # 65f0 <malloc+0xba8>
    1d30:	00004097          	auipc	ra,0x4
    1d34:	c60080e7          	jalr	-928(ra) # 5990 <printf>
        exit(1);
    1d38:	4505                	li	a0,1
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	8cc080e7          	jalr	-1844(ra) # 5606 <exit>
  for(i = 0; i < N; i++){
    1d42:	2905                	addiw	s2,s2,1
    1d44:	2a05                	addiw	s4,s4,1
    1d46:	2985                	addiw	s3,s3,1
    1d48:	0ff9f993          	zext.b	s3,s3
    1d4c:	47d1                	li	a5,20
    1d4e:	02f90a63          	beq	s2,a5,1d82 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d52:	84e2                	mv	s1,s8
    1d54:	bf69                	j	1cee <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d56:	2905                	addiw	s2,s2,1
    1d58:	0ff97913          	zext.b	s2,s2
    1d5c:	2985                	addiw	s3,s3,1
    1d5e:	0ff9f993          	zext.b	s3,s3
    1d62:	03490863          	beq	s2,s4,1d92 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d66:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d68:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d6c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d70:	f8040513          	addi	a0,s0,-128
    1d74:	00004097          	auipc	ra,0x4
    1d78:	8e2080e7          	jalr	-1822(ra) # 5656 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d7c:	34fd                	addiw	s1,s1,-1
    1d7e:	f4ed                	bnez	s1,1d68 <createdelete+0x1e2>
    1d80:	bfd9                	j	1d56 <createdelete+0x1d0>
    1d82:	03000993          	li	s3,48
    1d86:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8a:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d8c:	08400a13          	li	s4,132
    1d90:	bfd9                	j	1d66 <createdelete+0x1e0>
}
    1d92:	60aa                	ld	ra,136(sp)
    1d94:	640a                	ld	s0,128(sp)
    1d96:	74e6                	ld	s1,120(sp)
    1d98:	7946                	ld	s2,112(sp)
    1d9a:	79a6                	ld	s3,104(sp)
    1d9c:	7a06                	ld	s4,96(sp)
    1d9e:	6ae6                	ld	s5,88(sp)
    1da0:	6b46                	ld	s6,80(sp)
    1da2:	6ba6                	ld	s7,72(sp)
    1da4:	6c06                	ld	s8,64(sp)
    1da6:	7ce2                	ld	s9,56(sp)
    1da8:	6149                	addi	sp,sp,144
    1daa:	8082                	ret

0000000000001dac <linkunlink>:
{
    1dac:	711d                	addi	sp,sp,-96
    1dae:	ec86                	sd	ra,88(sp)
    1db0:	e8a2                	sd	s0,80(sp)
    1db2:	e4a6                	sd	s1,72(sp)
    1db4:	e0ca                	sd	s2,64(sp)
    1db6:	fc4e                	sd	s3,56(sp)
    1db8:	f852                	sd	s4,48(sp)
    1dba:	f456                	sd	s5,40(sp)
    1dbc:	f05a                	sd	s6,32(sp)
    1dbe:	ec5e                	sd	s7,24(sp)
    1dc0:	e862                	sd	s8,16(sp)
    1dc2:	e466                	sd	s9,8(sp)
    1dc4:	1080                	addi	s0,sp,96
    1dc6:	84aa                	mv	s1,a0
  unlink("x");
    1dc8:	00004517          	auipc	a0,0x4
    1dcc:	e1050513          	addi	a0,a0,-496 # 5bd8 <malloc+0x190>
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	886080e7          	jalr	-1914(ra) # 5656 <unlink>
  pid = fork();
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	826080e7          	jalr	-2010(ra) # 55fe <fork>
  if(pid < 0){
    1de0:	02054b63          	bltz	a0,1e16 <linkunlink+0x6a>
    1de4:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1de6:	4c85                	li	s9,1
    1de8:	e119                	bnez	a0,1dee <linkunlink+0x42>
    1dea:	06100c93          	li	s9,97
    1dee:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df2:	41c659b7          	lui	s3,0x41c65
    1df6:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c56365>
    1dfa:	690d                	lui	s2,0x3
    1dfc:	0399091b          	addiw	s2,s2,57 # 3039 <dirtest+0xbf>
    if((x % 3) == 0){
    1e00:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e02:	4b05                	li	s6,1
      unlink("x");
    1e04:	00004a97          	auipc	s5,0x4
    1e08:	dd4a8a93          	addi	s5,s5,-556 # 5bd8 <malloc+0x190>
      link("cat", "x");
    1e0c:	00005b97          	auipc	s7,0x5
    1e10:	80cb8b93          	addi	s7,s7,-2036 # 6618 <malloc+0xbd0>
    1e14:	a825                	j	1e4c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e16:	85a6                	mv	a1,s1
    1e18:	00004517          	auipc	a0,0x4
    1e1c:	5a850513          	addi	a0,a0,1448 # 63c0 <malloc+0x978>
    1e20:	00004097          	auipc	ra,0x4
    1e24:	b70080e7          	jalr	-1168(ra) # 5990 <printf>
    exit(1);
    1e28:	4505                	li	a0,1
    1e2a:	00003097          	auipc	ra,0x3
    1e2e:	7dc080e7          	jalr	2012(ra) # 5606 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e32:	20200593          	li	a1,514
    1e36:	8556                	mv	a0,s5
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	80e080e7          	jalr	-2034(ra) # 5646 <open>
    1e40:	00003097          	auipc	ra,0x3
    1e44:	7ee080e7          	jalr	2030(ra) # 562e <close>
  for(i = 0; i < 100; i++){
    1e48:	34fd                	addiw	s1,s1,-1
    1e4a:	c88d                	beqz	s1,1e7c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e4c:	033c87bb          	mulw	a5,s9,s3
    1e50:	012787bb          	addw	a5,a5,s2
    1e54:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e58:	0347f7bb          	remuw	a5,a5,s4
    1e5c:	dbf9                	beqz	a5,1e32 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e5e:	01678863          	beq	a5,s6,1e6e <linkunlink+0xc2>
      unlink("x");
    1e62:	8556                	mv	a0,s5
    1e64:	00003097          	auipc	ra,0x3
    1e68:	7f2080e7          	jalr	2034(ra) # 5656 <unlink>
    1e6c:	bff1                	j	1e48 <linkunlink+0x9c>
      link("cat", "x");
    1e6e:	85d6                	mv	a1,s5
    1e70:	855e                	mv	a0,s7
    1e72:	00003097          	auipc	ra,0x3
    1e76:	7f4080e7          	jalr	2036(ra) # 5666 <link>
    1e7a:	b7f9                	j	1e48 <linkunlink+0x9c>
  if(pid)
    1e7c:	020c0463          	beqz	s8,1ea4 <linkunlink+0xf8>
    wait(0);
    1e80:	4501                	li	a0,0
    1e82:	00003097          	auipc	ra,0x3
    1e86:	78c080e7          	jalr	1932(ra) # 560e <wait>
}
    1e8a:	60e6                	ld	ra,88(sp)
    1e8c:	6446                	ld	s0,80(sp)
    1e8e:	64a6                	ld	s1,72(sp)
    1e90:	6906                	ld	s2,64(sp)
    1e92:	79e2                	ld	s3,56(sp)
    1e94:	7a42                	ld	s4,48(sp)
    1e96:	7aa2                	ld	s5,40(sp)
    1e98:	7b02                	ld	s6,32(sp)
    1e9a:	6be2                	ld	s7,24(sp)
    1e9c:	6c42                	ld	s8,16(sp)
    1e9e:	6ca2                	ld	s9,8(sp)
    1ea0:	6125                	addi	sp,sp,96
    1ea2:	8082                	ret
    exit(0);
    1ea4:	4501                	li	a0,0
    1ea6:	00003097          	auipc	ra,0x3
    1eaa:	760080e7          	jalr	1888(ra) # 5606 <exit>

0000000000001eae <manywrites>:
{
    1eae:	711d                	addi	sp,sp,-96
    1eb0:	ec86                	sd	ra,88(sp)
    1eb2:	e8a2                	sd	s0,80(sp)
    1eb4:	e4a6                	sd	s1,72(sp)
    1eb6:	e0ca                	sd	s2,64(sp)
    1eb8:	fc4e                	sd	s3,56(sp)
    1eba:	f852                	sd	s4,48(sp)
    1ebc:	f456                	sd	s5,40(sp)
    1ebe:	f05a                	sd	s6,32(sp)
    1ec0:	ec5e                	sd	s7,24(sp)
    1ec2:	1080                	addi	s0,sp,96
    1ec4:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ec6:	4981                	li	s3,0
    1ec8:	4911                	li	s2,4
    int pid = fork();
    1eca:	00003097          	auipc	ra,0x3
    1ece:	734080e7          	jalr	1844(ra) # 55fe <fork>
    1ed2:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed4:	02054963          	bltz	a0,1f06 <manywrites+0x58>
    if(pid == 0){
    1ed8:	c521                	beqz	a0,1f20 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1eda:	2985                	addiw	s3,s3,1
    1edc:	ff2997e3          	bne	s3,s2,1eca <manywrites+0x1c>
    1ee0:	4491                	li	s1,4
    int st = 0;
    1ee2:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1ee6:	fa840513          	addi	a0,s0,-88
    1eea:	00003097          	auipc	ra,0x3
    1eee:	724080e7          	jalr	1828(ra) # 560e <wait>
    if(st != 0)
    1ef2:	fa842503          	lw	a0,-88(s0)
    1ef6:	ed6d                	bnez	a0,1ff0 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1ef8:	34fd                	addiw	s1,s1,-1
    1efa:	f4e5                	bnez	s1,1ee2 <manywrites+0x34>
  exit(0);
    1efc:	4501                	li	a0,0
    1efe:	00003097          	auipc	ra,0x3
    1f02:	708080e7          	jalr	1800(ra) # 5606 <exit>
      printf("fork failed\n");
    1f06:	00005517          	auipc	a0,0x5
    1f0a:	8c250513          	addi	a0,a0,-1854 # 67c8 <malloc+0xd80>
    1f0e:	00004097          	auipc	ra,0x4
    1f12:	a82080e7          	jalr	-1406(ra) # 5990 <printf>
      exit(1);
    1f16:	4505                	li	a0,1
    1f18:	00003097          	auipc	ra,0x3
    1f1c:	6ee080e7          	jalr	1774(ra) # 5606 <exit>
      name[0] = 'b';
    1f20:	06200793          	li	a5,98
    1f24:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f28:	0619879b          	addiw	a5,s3,97
    1f2c:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f30:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f34:	fa840513          	addi	a0,s0,-88
    1f38:	00003097          	auipc	ra,0x3
    1f3c:	71e080e7          	jalr	1822(ra) # 5656 <unlink>
    1f40:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f42:	0000ab17          	auipc	s6,0xa
    1f46:	bb6b0b13          	addi	s6,s6,-1098 # baf8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4a:	8a26                	mv	s4,s1
    1f4c:	0209ce63          	bltz	s3,1f88 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f50:	20200593          	li	a1,514
    1f54:	fa840513          	addi	a0,s0,-88
    1f58:	00003097          	auipc	ra,0x3
    1f5c:	6ee080e7          	jalr	1774(ra) # 5646 <open>
    1f60:	892a                	mv	s2,a0
          if(fd < 0){
    1f62:	04054763          	bltz	a0,1fb0 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f66:	660d                	lui	a2,0x3
    1f68:	85da                	mv	a1,s6
    1f6a:	00003097          	auipc	ra,0x3
    1f6e:	6bc080e7          	jalr	1724(ra) # 5626 <write>
          if(cc != sz){
    1f72:	678d                	lui	a5,0x3
    1f74:	04f51e63          	bne	a0,a5,1fd0 <manywrites+0x122>
          close(fd);
    1f78:	854a                	mv	a0,s2
    1f7a:	00003097          	auipc	ra,0x3
    1f7e:	6b4080e7          	jalr	1716(ra) # 562e <close>
        for(int i = 0; i < ci+1; i++){
    1f82:	2a05                	addiw	s4,s4,1
    1f84:	fd49d6e3          	bge	s3,s4,1f50 <manywrites+0xa2>
        unlink(name);
    1f88:	fa840513          	addi	a0,s0,-88
    1f8c:	00003097          	auipc	ra,0x3
    1f90:	6ca080e7          	jalr	1738(ra) # 5656 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f94:	3bfd                	addiw	s7,s7,-1
    1f96:	fa0b9ae3          	bnez	s7,1f4a <manywrites+0x9c>
      unlink(name);
    1f9a:	fa840513          	addi	a0,s0,-88
    1f9e:	00003097          	auipc	ra,0x3
    1fa2:	6b8080e7          	jalr	1720(ra) # 5656 <unlink>
      exit(0);
    1fa6:	4501                	li	a0,0
    1fa8:	00003097          	auipc	ra,0x3
    1fac:	65e080e7          	jalr	1630(ra) # 5606 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb0:	fa840613          	addi	a2,s0,-88
    1fb4:	85d6                	mv	a1,s5
    1fb6:	00004517          	auipc	a0,0x4
    1fba:	66a50513          	addi	a0,a0,1642 # 6620 <malloc+0xbd8>
    1fbe:	00004097          	auipc	ra,0x4
    1fc2:	9d2080e7          	jalr	-1582(ra) # 5990 <printf>
            exit(1);
    1fc6:	4505                	li	a0,1
    1fc8:	00003097          	auipc	ra,0x3
    1fcc:	63e080e7          	jalr	1598(ra) # 5606 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd0:	86aa                	mv	a3,a0
    1fd2:	660d                	lui	a2,0x3
    1fd4:	85d6                	mv	a1,s5
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	c6250513          	addi	a0,a0,-926 # 5c38 <malloc+0x1f0>
    1fde:	00004097          	auipc	ra,0x4
    1fe2:	9b2080e7          	jalr	-1614(ra) # 5990 <printf>
            exit(1);
    1fe6:	4505                	li	a0,1
    1fe8:	00003097          	auipc	ra,0x3
    1fec:	61e080e7          	jalr	1566(ra) # 5606 <exit>
      exit(st);
    1ff0:	00003097          	auipc	ra,0x3
    1ff4:	616080e7          	jalr	1558(ra) # 5606 <exit>

0000000000001ff8 <forktest>:
{
    1ff8:	7179                	addi	sp,sp,-48
    1ffa:	f406                	sd	ra,40(sp)
    1ffc:	f022                	sd	s0,32(sp)
    1ffe:	ec26                	sd	s1,24(sp)
    2000:	e84a                	sd	s2,16(sp)
    2002:	e44e                	sd	s3,8(sp)
    2004:	1800                	addi	s0,sp,48
    2006:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2008:	4481                	li	s1,0
    200a:	3e800913          	li	s2,1000
    pid = fork();
    200e:	00003097          	auipc	ra,0x3
    2012:	5f0080e7          	jalr	1520(ra) # 55fe <fork>
    if(pid < 0)
    2016:	02054863          	bltz	a0,2046 <forktest+0x4e>
    if(pid == 0)
    201a:	c115                	beqz	a0,203e <forktest+0x46>
  for(n=0; n<N; n++){
    201c:	2485                	addiw	s1,s1,1
    201e:	ff2498e3          	bne	s1,s2,200e <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2022:	85ce                	mv	a1,s3
    2024:	00004517          	auipc	a0,0x4
    2028:	62c50513          	addi	a0,a0,1580 # 6650 <malloc+0xc08>
    202c:	00004097          	auipc	ra,0x4
    2030:	964080e7          	jalr	-1692(ra) # 5990 <printf>
    exit(1);
    2034:	4505                	li	a0,1
    2036:	00003097          	auipc	ra,0x3
    203a:	5d0080e7          	jalr	1488(ra) # 5606 <exit>
      exit(0);
    203e:	00003097          	auipc	ra,0x3
    2042:	5c8080e7          	jalr	1480(ra) # 5606 <exit>
  if (n == 0) {
    2046:	cc9d                	beqz	s1,2084 <forktest+0x8c>
  if(n == N){
    2048:	3e800793          	li	a5,1000
    204c:	fcf48be3          	beq	s1,a5,2022 <forktest+0x2a>
  for(; n > 0; n--){
    2050:	00905b63          	blez	s1,2066 <forktest+0x6e>
    if(wait(0) < 0){
    2054:	4501                	li	a0,0
    2056:	00003097          	auipc	ra,0x3
    205a:	5b8080e7          	jalr	1464(ra) # 560e <wait>
    205e:	04054163          	bltz	a0,20a0 <forktest+0xa8>
  for(; n > 0; n--){
    2062:	34fd                	addiw	s1,s1,-1
    2064:	f8e5                	bnez	s1,2054 <forktest+0x5c>
  if(wait(0) != -1){
    2066:	4501                	li	a0,0
    2068:	00003097          	auipc	ra,0x3
    206c:	5a6080e7          	jalr	1446(ra) # 560e <wait>
    2070:	57fd                	li	a5,-1
    2072:	04f51563          	bne	a0,a5,20bc <forktest+0xc4>
}
    2076:	70a2                	ld	ra,40(sp)
    2078:	7402                	ld	s0,32(sp)
    207a:	64e2                	ld	s1,24(sp)
    207c:	6942                	ld	s2,16(sp)
    207e:	69a2                	ld	s3,8(sp)
    2080:	6145                	addi	sp,sp,48
    2082:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2084:	85ce                	mv	a1,s3
    2086:	00004517          	auipc	a0,0x4
    208a:	5b250513          	addi	a0,a0,1458 # 6638 <malloc+0xbf0>
    208e:	00004097          	auipc	ra,0x4
    2092:	902080e7          	jalr	-1790(ra) # 5990 <printf>
    exit(1);
    2096:	4505                	li	a0,1
    2098:	00003097          	auipc	ra,0x3
    209c:	56e080e7          	jalr	1390(ra) # 5606 <exit>
      printf("%s: wait stopped early\n", s);
    20a0:	85ce                	mv	a1,s3
    20a2:	00004517          	auipc	a0,0x4
    20a6:	5d650513          	addi	a0,a0,1494 # 6678 <malloc+0xc30>
    20aa:	00004097          	auipc	ra,0x4
    20ae:	8e6080e7          	jalr	-1818(ra) # 5990 <printf>
      exit(1);
    20b2:	4505                	li	a0,1
    20b4:	00003097          	auipc	ra,0x3
    20b8:	552080e7          	jalr	1362(ra) # 5606 <exit>
    printf("%s: wait got too many\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00004517          	auipc	a0,0x4
    20c2:	5d250513          	addi	a0,a0,1490 # 6690 <malloc+0xc48>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	8ca080e7          	jalr	-1846(ra) # 5990 <printf>
    exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00003097          	auipc	ra,0x3
    20d4:	536080e7          	jalr	1334(ra) # 5606 <exit>

00000000000020d8 <kernmem>:
{
    20d8:	715d                	addi	sp,sp,-80
    20da:	e486                	sd	ra,72(sp)
    20dc:	e0a2                	sd	s0,64(sp)
    20de:	fc26                	sd	s1,56(sp)
    20e0:	f84a                	sd	s2,48(sp)
    20e2:	f44e                	sd	s3,40(sp)
    20e4:	f052                	sd	s4,32(sp)
    20e6:	ec56                	sd	s5,24(sp)
    20e8:	0880                	addi	s0,sp,80
    20ea:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20ec:	4485                	li	s1,1
    20ee:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f0:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f2:	69b1                	lui	s3,0xc
    20f4:	35098993          	addi	s3,s3,848 # c350 <buf+0x858>
    20f8:	1003d937          	lui	s2,0x1003d
    20fc:	090e                	slli	s2,s2,0x3
    20fe:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e978>
    pid = fork();
    2102:	00003097          	auipc	ra,0x3
    2106:	4fc080e7          	jalr	1276(ra) # 55fe <fork>
    if(pid < 0){
    210a:	02054963          	bltz	a0,213c <kernmem+0x64>
    if(pid == 0){
    210e:	c529                	beqz	a0,2158 <kernmem+0x80>
    wait(&xstatus);
    2110:	fbc40513          	addi	a0,s0,-68
    2114:	00003097          	auipc	ra,0x3
    2118:	4fa080e7          	jalr	1274(ra) # 560e <wait>
    if(xstatus != -1)  // did kernel kill child?
    211c:	fbc42783          	lw	a5,-68(s0)
    2120:	05579d63          	bne	a5,s5,217a <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2124:	94ce                	add	s1,s1,s3
    2126:	fd249ee3          	bne	s1,s2,2102 <kernmem+0x2a>
}
    212a:	60a6                	ld	ra,72(sp)
    212c:	6406                	ld	s0,64(sp)
    212e:	74e2                	ld	s1,56(sp)
    2130:	7942                	ld	s2,48(sp)
    2132:	79a2                	ld	s3,40(sp)
    2134:	7a02                	ld	s4,32(sp)
    2136:	6ae2                	ld	s5,24(sp)
    2138:	6161                	addi	sp,sp,80
    213a:	8082                	ret
      printf("%s: fork failed\n", s);
    213c:	85d2                	mv	a1,s4
    213e:	00004517          	auipc	a0,0x4
    2142:	28250513          	addi	a0,a0,642 # 63c0 <malloc+0x978>
    2146:	00004097          	auipc	ra,0x4
    214a:	84a080e7          	jalr	-1974(ra) # 5990 <printf>
      exit(1);
    214e:	4505                	li	a0,1
    2150:	00003097          	auipc	ra,0x3
    2154:	4b6080e7          	jalr	1206(ra) # 5606 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2158:	0004c683          	lbu	a3,0(s1)
    215c:	8626                	mv	a2,s1
    215e:	85d2                	mv	a1,s4
    2160:	00004517          	auipc	a0,0x4
    2164:	54850513          	addi	a0,a0,1352 # 66a8 <malloc+0xc60>
    2168:	00004097          	auipc	ra,0x4
    216c:	828080e7          	jalr	-2008(ra) # 5990 <printf>
      exit(1);
    2170:	4505                	li	a0,1
    2172:	00003097          	auipc	ra,0x3
    2176:	494080e7          	jalr	1172(ra) # 5606 <exit>
      exit(1);
    217a:	4505                	li	a0,1
    217c:	00003097          	auipc	ra,0x3
    2180:	48a080e7          	jalr	1162(ra) # 5606 <exit>

0000000000002184 <bigargtest>:
{
    2184:	7179                	addi	sp,sp,-48
    2186:	f406                	sd	ra,40(sp)
    2188:	f022                	sd	s0,32(sp)
    218a:	ec26                	sd	s1,24(sp)
    218c:	1800                	addi	s0,sp,48
    218e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2190:	00004517          	auipc	a0,0x4
    2194:	53850513          	addi	a0,a0,1336 # 66c8 <malloc+0xc80>
    2198:	00003097          	auipc	ra,0x3
    219c:	4be080e7          	jalr	1214(ra) # 5656 <unlink>
  pid = fork();
    21a0:	00003097          	auipc	ra,0x3
    21a4:	45e080e7          	jalr	1118(ra) # 55fe <fork>
  if(pid == 0){
    21a8:	c121                	beqz	a0,21e8 <bigargtest+0x64>
  } else if(pid < 0){
    21aa:	0a054063          	bltz	a0,224a <bigargtest+0xc6>
  wait(&xstatus);
    21ae:	fdc40513          	addi	a0,s0,-36
    21b2:	00003097          	auipc	ra,0x3
    21b6:	45c080e7          	jalr	1116(ra) # 560e <wait>
  if(xstatus != 0)
    21ba:	fdc42503          	lw	a0,-36(s0)
    21be:	e545                	bnez	a0,2266 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c0:	4581                	li	a1,0
    21c2:	00004517          	auipc	a0,0x4
    21c6:	50650513          	addi	a0,a0,1286 # 66c8 <malloc+0xc80>
    21ca:	00003097          	auipc	ra,0x3
    21ce:	47c080e7          	jalr	1148(ra) # 5646 <open>
  if(fd < 0){
    21d2:	08054e63          	bltz	a0,226e <bigargtest+0xea>
  close(fd);
    21d6:	00003097          	auipc	ra,0x3
    21da:	458080e7          	jalr	1112(ra) # 562e <close>
}
    21de:	70a2                	ld	ra,40(sp)
    21e0:	7402                	ld	s0,32(sp)
    21e2:	64e2                	ld	s1,24(sp)
    21e4:	6145                	addi	sp,sp,48
    21e6:	8082                	ret
    21e8:	00006797          	auipc	a5,0x6
    21ec:	0f878793          	addi	a5,a5,248 # 82e0 <args.1>
    21f0:	00006697          	auipc	a3,0x6
    21f4:	1e868693          	addi	a3,a3,488 # 83d8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21f8:	00004717          	auipc	a4,0x4
    21fc:	4e070713          	addi	a4,a4,1248 # 66d8 <malloc+0xc90>
    2200:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2202:	07a1                	addi	a5,a5,8
    2204:	fed79ee3          	bne	a5,a3,2200 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2208:	00006597          	auipc	a1,0x6
    220c:	0d858593          	addi	a1,a1,216 # 82e0 <args.1>
    2210:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2214:	00004517          	auipc	a0,0x4
    2218:	95450513          	addi	a0,a0,-1708 # 5b68 <malloc+0x120>
    221c:	00003097          	auipc	ra,0x3
    2220:	422080e7          	jalr	1058(ra) # 563e <exec>
    fd = open("bigarg-ok", O_CREATE);
    2224:	20000593          	li	a1,512
    2228:	00004517          	auipc	a0,0x4
    222c:	4a050513          	addi	a0,a0,1184 # 66c8 <malloc+0xc80>
    2230:	00003097          	auipc	ra,0x3
    2234:	416080e7          	jalr	1046(ra) # 5646 <open>
    close(fd);
    2238:	00003097          	auipc	ra,0x3
    223c:	3f6080e7          	jalr	1014(ra) # 562e <close>
    exit(0);
    2240:	4501                	li	a0,0
    2242:	00003097          	auipc	ra,0x3
    2246:	3c4080e7          	jalr	964(ra) # 5606 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    224a:	85a6                	mv	a1,s1
    224c:	00004517          	auipc	a0,0x4
    2250:	56c50513          	addi	a0,a0,1388 # 67b8 <malloc+0xd70>
    2254:	00003097          	auipc	ra,0x3
    2258:	73c080e7          	jalr	1852(ra) # 5990 <printf>
    exit(1);
    225c:	4505                	li	a0,1
    225e:	00003097          	auipc	ra,0x3
    2262:	3a8080e7          	jalr	936(ra) # 5606 <exit>
    exit(xstatus);
    2266:	00003097          	auipc	ra,0x3
    226a:	3a0080e7          	jalr	928(ra) # 5606 <exit>
    printf("%s: bigarg test failed!\n", s);
    226e:	85a6                	mv	a1,s1
    2270:	00004517          	auipc	a0,0x4
    2274:	56850513          	addi	a0,a0,1384 # 67d8 <malloc+0xd90>
    2278:	00003097          	auipc	ra,0x3
    227c:	718080e7          	jalr	1816(ra) # 5990 <printf>
    exit(1);
    2280:	4505                	li	a0,1
    2282:	00003097          	auipc	ra,0x3
    2286:	384080e7          	jalr	900(ra) # 5606 <exit>

000000000000228a <stacktest>:
{
    228a:	7179                	addi	sp,sp,-48
    228c:	f406                	sd	ra,40(sp)
    228e:	f022                	sd	s0,32(sp)
    2290:	ec26                	sd	s1,24(sp)
    2292:	1800                	addi	s0,sp,48
    2294:	84aa                	mv	s1,a0
  pid = fork();
    2296:	00003097          	auipc	ra,0x3
    229a:	368080e7          	jalr	872(ra) # 55fe <fork>
  if(pid == 0) {
    229e:	c115                	beqz	a0,22c2 <stacktest+0x38>
  } else if(pid < 0){
    22a0:	04054463          	bltz	a0,22e8 <stacktest+0x5e>
  wait(&xstatus);
    22a4:	fdc40513          	addi	a0,s0,-36
    22a8:	00003097          	auipc	ra,0x3
    22ac:	366080e7          	jalr	870(ra) # 560e <wait>
  if(xstatus == -1)  // kernel killed child?
    22b0:	fdc42503          	lw	a0,-36(s0)
    22b4:	57fd                	li	a5,-1
    22b6:	04f50763          	beq	a0,a5,2304 <stacktest+0x7a>
    exit(xstatus);
    22ba:	00003097          	auipc	ra,0x3
    22be:	34c080e7          	jalr	844(ra) # 5606 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c2:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22c4:	77fd                	lui	a5,0xfffff
    22c6:	97ba                	add	a5,a5,a4
    22c8:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff04f8>
    22cc:	85a6                	mv	a1,s1
    22ce:	00004517          	auipc	a0,0x4
    22d2:	52a50513          	addi	a0,a0,1322 # 67f8 <malloc+0xdb0>
    22d6:	00003097          	auipc	ra,0x3
    22da:	6ba080e7          	jalr	1722(ra) # 5990 <printf>
    exit(1);
    22de:	4505                	li	a0,1
    22e0:	00003097          	auipc	ra,0x3
    22e4:	326080e7          	jalr	806(ra) # 5606 <exit>
    printf("%s: fork failed\n", s);
    22e8:	85a6                	mv	a1,s1
    22ea:	00004517          	auipc	a0,0x4
    22ee:	0d650513          	addi	a0,a0,214 # 63c0 <malloc+0x978>
    22f2:	00003097          	auipc	ra,0x3
    22f6:	69e080e7          	jalr	1694(ra) # 5990 <printf>
    exit(1);
    22fa:	4505                	li	a0,1
    22fc:	00003097          	auipc	ra,0x3
    2300:	30a080e7          	jalr	778(ra) # 5606 <exit>
    exit(0);
    2304:	4501                	li	a0,0
    2306:	00003097          	auipc	ra,0x3
    230a:	300080e7          	jalr	768(ra) # 5606 <exit>

000000000000230e <copyinstr3>:
{
    230e:	7179                	addi	sp,sp,-48
    2310:	f406                	sd	ra,40(sp)
    2312:	f022                	sd	s0,32(sp)
    2314:	ec26                	sd	s1,24(sp)
    2316:	1800                	addi	s0,sp,48
  sbrk(8192);
    2318:	6509                	lui	a0,0x2
    231a:	00003097          	auipc	ra,0x3
    231e:	374080e7          	jalr	884(ra) # 568e <sbrk>
  uint64 top = (uint64) sbrk(0);
    2322:	4501                	li	a0,0
    2324:	00003097          	auipc	ra,0x3
    2328:	36a080e7          	jalr	874(ra) # 568e <sbrk>
  if((top % PGSIZE) != 0){
    232c:	03451793          	slli	a5,a0,0x34
    2330:	e3c9                	bnez	a5,23b2 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2332:	4501                	li	a0,0
    2334:	00003097          	auipc	ra,0x3
    2338:	35a080e7          	jalr	858(ra) # 568e <sbrk>
  if(top % PGSIZE){
    233c:	03451793          	slli	a5,a0,0x34
    2340:	e3d9                	bnez	a5,23c6 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2342:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x7>
  *b = 'x';
    2346:	07800793          	li	a5,120
    234a:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    234e:	8526                	mv	a0,s1
    2350:	00003097          	auipc	ra,0x3
    2354:	306080e7          	jalr	774(ra) # 5656 <unlink>
  if(ret != -1){
    2358:	57fd                	li	a5,-1
    235a:	08f51363          	bne	a0,a5,23e0 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    235e:	20100593          	li	a1,513
    2362:	8526                	mv	a0,s1
    2364:	00003097          	auipc	ra,0x3
    2368:	2e2080e7          	jalr	738(ra) # 5646 <open>
  if(fd != -1){
    236c:	57fd                	li	a5,-1
    236e:	08f51863          	bne	a0,a5,23fe <copyinstr3+0xf0>
  ret = link(b, b);
    2372:	85a6                	mv	a1,s1
    2374:	8526                	mv	a0,s1
    2376:	00003097          	auipc	ra,0x3
    237a:	2f0080e7          	jalr	752(ra) # 5666 <link>
  if(ret != -1){
    237e:	57fd                	li	a5,-1
    2380:	08f51e63          	bne	a0,a5,241c <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2384:	00005797          	auipc	a5,0x5
    2388:	11c78793          	addi	a5,a5,284 # 74a0 <malloc+0x1a58>
    238c:	fcf43823          	sd	a5,-48(s0)
    2390:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2394:	fd040593          	addi	a1,s0,-48
    2398:	8526                	mv	a0,s1
    239a:	00003097          	auipc	ra,0x3
    239e:	2a4080e7          	jalr	676(ra) # 563e <exec>
  if(ret != -1){
    23a2:	57fd                	li	a5,-1
    23a4:	08f51c63          	bne	a0,a5,243c <copyinstr3+0x12e>
}
    23a8:	70a2                	ld	ra,40(sp)
    23aa:	7402                	ld	s0,32(sp)
    23ac:	64e2                	ld	s1,24(sp)
    23ae:	6145                	addi	sp,sp,48
    23b0:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b2:	0347d513          	srli	a0,a5,0x34
    23b6:	6785                	lui	a5,0x1
    23b8:	40a7853b          	subw	a0,a5,a0
    23bc:	00003097          	auipc	ra,0x3
    23c0:	2d2080e7          	jalr	722(ra) # 568e <sbrk>
    23c4:	b7bd                	j	2332 <copyinstr3+0x24>
    printf("oops\n");
    23c6:	00004517          	auipc	a0,0x4
    23ca:	45a50513          	addi	a0,a0,1114 # 6820 <malloc+0xdd8>
    23ce:	00003097          	auipc	ra,0x3
    23d2:	5c2080e7          	jalr	1474(ra) # 5990 <printf>
    exit(1);
    23d6:	4505                	li	a0,1
    23d8:	00003097          	auipc	ra,0x3
    23dc:	22e080e7          	jalr	558(ra) # 5606 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e0:	862a                	mv	a2,a0
    23e2:	85a6                	mv	a1,s1
    23e4:	00004517          	auipc	a0,0x4
    23e8:	efc50513          	addi	a0,a0,-260 # 62e0 <malloc+0x898>
    23ec:	00003097          	auipc	ra,0x3
    23f0:	5a4080e7          	jalr	1444(ra) # 5990 <printf>
    exit(1);
    23f4:	4505                	li	a0,1
    23f6:	00003097          	auipc	ra,0x3
    23fa:	210080e7          	jalr	528(ra) # 5606 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    23fe:	862a                	mv	a2,a0
    2400:	85a6                	mv	a1,s1
    2402:	00004517          	auipc	a0,0x4
    2406:	efe50513          	addi	a0,a0,-258 # 6300 <malloc+0x8b8>
    240a:	00003097          	auipc	ra,0x3
    240e:	586080e7          	jalr	1414(ra) # 5990 <printf>
    exit(1);
    2412:	4505                	li	a0,1
    2414:	00003097          	auipc	ra,0x3
    2418:	1f2080e7          	jalr	498(ra) # 5606 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    241c:	86aa                	mv	a3,a0
    241e:	8626                	mv	a2,s1
    2420:	85a6                	mv	a1,s1
    2422:	00004517          	auipc	a0,0x4
    2426:	efe50513          	addi	a0,a0,-258 # 6320 <malloc+0x8d8>
    242a:	00003097          	auipc	ra,0x3
    242e:	566080e7          	jalr	1382(ra) # 5990 <printf>
    exit(1);
    2432:	4505                	li	a0,1
    2434:	00003097          	auipc	ra,0x3
    2438:	1d2080e7          	jalr	466(ra) # 5606 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    243c:	567d                	li	a2,-1
    243e:	85a6                	mv	a1,s1
    2440:	00004517          	auipc	a0,0x4
    2444:	f0850513          	addi	a0,a0,-248 # 6348 <malloc+0x900>
    2448:	00003097          	auipc	ra,0x3
    244c:	548080e7          	jalr	1352(ra) # 5990 <printf>
    exit(1);
    2450:	4505                	li	a0,1
    2452:	00003097          	auipc	ra,0x3
    2456:	1b4080e7          	jalr	436(ra) # 5606 <exit>

000000000000245a <rwsbrk>:
{
    245a:	1101                	addi	sp,sp,-32
    245c:	ec06                	sd	ra,24(sp)
    245e:	e822                	sd	s0,16(sp)
    2460:	e426                	sd	s1,8(sp)
    2462:	e04a                	sd	s2,0(sp)
    2464:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2466:	6509                	lui	a0,0x2
    2468:	00003097          	auipc	ra,0x3
    246c:	226080e7          	jalr	550(ra) # 568e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2470:	57fd                	li	a5,-1
    2472:	06f50263          	beq	a0,a5,24d6 <rwsbrk+0x7c>
    2476:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2478:	7579                	lui	a0,0xffffe
    247a:	00003097          	auipc	ra,0x3
    247e:	214080e7          	jalr	532(ra) # 568e <sbrk>
    2482:	57fd                	li	a5,-1
    2484:	06f50663          	beq	a0,a5,24f0 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2488:	20100593          	li	a1,513
    248c:	00004517          	auipc	a0,0x4
    2490:	3d450513          	addi	a0,a0,980 # 6860 <malloc+0xe18>
    2494:	00003097          	auipc	ra,0x3
    2498:	1b2080e7          	jalr	434(ra) # 5646 <open>
    249c:	892a                	mv	s2,a0
  if(fd < 0){
    249e:	06054663          	bltz	a0,250a <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    24a2:	6785                	lui	a5,0x1
    24a4:	94be                	add	s1,s1,a5
    24a6:	40000613          	li	a2,1024
    24aa:	85a6                	mv	a1,s1
    24ac:	00003097          	auipc	ra,0x3
    24b0:	17a080e7          	jalr	378(ra) # 5626 <write>
    24b4:	862a                	mv	a2,a0
  if(n >= 0){
    24b6:	06054763          	bltz	a0,2524 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24ba:	85a6                	mv	a1,s1
    24bc:	00004517          	auipc	a0,0x4
    24c0:	3c450513          	addi	a0,a0,964 # 6880 <malloc+0xe38>
    24c4:	00003097          	auipc	ra,0x3
    24c8:	4cc080e7          	jalr	1228(ra) # 5990 <printf>
    exit(1);
    24cc:	4505                	li	a0,1
    24ce:	00003097          	auipc	ra,0x3
    24d2:	138080e7          	jalr	312(ra) # 5606 <exit>
    printf("sbrk(rwsbrk) failed\n");
    24d6:	00004517          	auipc	a0,0x4
    24da:	35250513          	addi	a0,a0,850 # 6828 <malloc+0xde0>
    24de:	00003097          	auipc	ra,0x3
    24e2:	4b2080e7          	jalr	1202(ra) # 5990 <printf>
    exit(1);
    24e6:	4505                	li	a0,1
    24e8:	00003097          	auipc	ra,0x3
    24ec:	11e080e7          	jalr	286(ra) # 5606 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f0:	00004517          	auipc	a0,0x4
    24f4:	35050513          	addi	a0,a0,848 # 6840 <malloc+0xdf8>
    24f8:	00003097          	auipc	ra,0x3
    24fc:	498080e7          	jalr	1176(ra) # 5990 <printf>
    exit(1);
    2500:	4505                	li	a0,1
    2502:	00003097          	auipc	ra,0x3
    2506:	104080e7          	jalr	260(ra) # 5606 <exit>
    printf("open(rwsbrk) failed\n");
    250a:	00004517          	auipc	a0,0x4
    250e:	35e50513          	addi	a0,a0,862 # 6868 <malloc+0xe20>
    2512:	00003097          	auipc	ra,0x3
    2516:	47e080e7          	jalr	1150(ra) # 5990 <printf>
    exit(1);
    251a:	4505                	li	a0,1
    251c:	00003097          	auipc	ra,0x3
    2520:	0ea080e7          	jalr	234(ra) # 5606 <exit>
  close(fd);
    2524:	854a                	mv	a0,s2
    2526:	00003097          	auipc	ra,0x3
    252a:	108080e7          	jalr	264(ra) # 562e <close>
  unlink("rwsbrk");
    252e:	00004517          	auipc	a0,0x4
    2532:	33250513          	addi	a0,a0,818 # 6860 <malloc+0xe18>
    2536:	00003097          	auipc	ra,0x3
    253a:	120080e7          	jalr	288(ra) # 5656 <unlink>
  fd = open("README", O_RDONLY);
    253e:	4581                	li	a1,0
    2540:	00003517          	auipc	a0,0x3
    2544:	7d050513          	addi	a0,a0,2000 # 5d10 <malloc+0x2c8>
    2548:	00003097          	auipc	ra,0x3
    254c:	0fe080e7          	jalr	254(ra) # 5646 <open>
    2550:	892a                	mv	s2,a0
  if(fd < 0){
    2552:	02054963          	bltz	a0,2584 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2556:	4629                	li	a2,10
    2558:	85a6                	mv	a1,s1
    255a:	00003097          	auipc	ra,0x3
    255e:	0c4080e7          	jalr	196(ra) # 561e <read>
    2562:	862a                	mv	a2,a0
  if(n >= 0){
    2564:	02054d63          	bltz	a0,259e <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2568:	85a6                	mv	a1,s1
    256a:	00004517          	auipc	a0,0x4
    256e:	34650513          	addi	a0,a0,838 # 68b0 <malloc+0xe68>
    2572:	00003097          	auipc	ra,0x3
    2576:	41e080e7          	jalr	1054(ra) # 5990 <printf>
    exit(1);
    257a:	4505                	li	a0,1
    257c:	00003097          	auipc	ra,0x3
    2580:	08a080e7          	jalr	138(ra) # 5606 <exit>
    printf("open(rwsbrk) failed\n");
    2584:	00004517          	auipc	a0,0x4
    2588:	2e450513          	addi	a0,a0,740 # 6868 <malloc+0xe20>
    258c:	00003097          	auipc	ra,0x3
    2590:	404080e7          	jalr	1028(ra) # 5990 <printf>
    exit(1);
    2594:	4505                	li	a0,1
    2596:	00003097          	auipc	ra,0x3
    259a:	070080e7          	jalr	112(ra) # 5606 <exit>
  close(fd);
    259e:	854a                	mv	a0,s2
    25a0:	00003097          	auipc	ra,0x3
    25a4:	08e080e7          	jalr	142(ra) # 562e <close>
  exit(0);
    25a8:	4501                	li	a0,0
    25aa:	00003097          	auipc	ra,0x3
    25ae:	05c080e7          	jalr	92(ra) # 5606 <exit>

00000000000025b2 <sbrkbasic>:
{
    25b2:	7139                	addi	sp,sp,-64
    25b4:	fc06                	sd	ra,56(sp)
    25b6:	f822                	sd	s0,48(sp)
    25b8:	f426                	sd	s1,40(sp)
    25ba:	f04a                	sd	s2,32(sp)
    25bc:	ec4e                	sd	s3,24(sp)
    25be:	e852                	sd	s4,16(sp)
    25c0:	0080                	addi	s0,sp,64
    25c2:	8a2a                	mv	s4,a0
  pid = fork();
    25c4:	00003097          	auipc	ra,0x3
    25c8:	03a080e7          	jalr	58(ra) # 55fe <fork>
  if(pid < 0){
    25cc:	02054c63          	bltz	a0,2604 <sbrkbasic+0x52>
  if(pid == 0){
    25d0:	ed21                	bnez	a0,2628 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    25d2:	40000537          	lui	a0,0x40000
    25d6:	00003097          	auipc	ra,0x3
    25da:	0b8080e7          	jalr	184(ra) # 568e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25de:	57fd                	li	a5,-1
    25e0:	02f50f63          	beq	a0,a5,261e <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25e4:	400007b7          	lui	a5,0x40000
    25e8:	97aa                	add	a5,a5,a0
      *b = 99;
    25ea:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ee:	6705                	lui	a4,0x1
      *b = 99;
    25f0:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff14f8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f4:	953a                	add	a0,a0,a4
    25f6:	fef51de3          	bne	a0,a5,25f0 <sbrkbasic+0x3e>
    exit(1);
    25fa:	4505                	li	a0,1
    25fc:	00003097          	auipc	ra,0x3
    2600:	00a080e7          	jalr	10(ra) # 5606 <exit>
    printf("fork failed in sbrkbasic\n");
    2604:	00004517          	auipc	a0,0x4
    2608:	2d450513          	addi	a0,a0,724 # 68d8 <malloc+0xe90>
    260c:	00003097          	auipc	ra,0x3
    2610:	384080e7          	jalr	900(ra) # 5990 <printf>
    exit(1);
    2614:	4505                	li	a0,1
    2616:	00003097          	auipc	ra,0x3
    261a:	ff0080e7          	jalr	-16(ra) # 5606 <exit>
      exit(0);
    261e:	4501                	li	a0,0
    2620:	00003097          	auipc	ra,0x3
    2624:	fe6080e7          	jalr	-26(ra) # 5606 <exit>
  wait(&xstatus);
    2628:	fcc40513          	addi	a0,s0,-52
    262c:	00003097          	auipc	ra,0x3
    2630:	fe2080e7          	jalr	-30(ra) # 560e <wait>
  if(xstatus == 1){
    2634:	fcc42703          	lw	a4,-52(s0)
    2638:	4785                	li	a5,1
    263a:	00f70d63          	beq	a4,a5,2654 <sbrkbasic+0xa2>
  a = sbrk(0);
    263e:	4501                	li	a0,0
    2640:	00003097          	auipc	ra,0x3
    2644:	04e080e7          	jalr	78(ra) # 568e <sbrk>
    2648:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    264a:	4901                	li	s2,0
    264c:	6985                	lui	s3,0x1
    264e:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d8>
    2652:	a005                	j	2672 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2654:	85d2                	mv	a1,s4
    2656:	00004517          	auipc	a0,0x4
    265a:	2a250513          	addi	a0,a0,674 # 68f8 <malloc+0xeb0>
    265e:	00003097          	auipc	ra,0x3
    2662:	332080e7          	jalr	818(ra) # 5990 <printf>
    exit(1);
    2666:	4505                	li	a0,1
    2668:	00003097          	auipc	ra,0x3
    266c:	f9e080e7          	jalr	-98(ra) # 5606 <exit>
    a = b + 1;
    2670:	84be                	mv	s1,a5
    b = sbrk(1);
    2672:	4505                	li	a0,1
    2674:	00003097          	auipc	ra,0x3
    2678:	01a080e7          	jalr	26(ra) # 568e <sbrk>
    if(b != a){
    267c:	04951c63          	bne	a0,s1,26d4 <sbrkbasic+0x122>
    *b = 1;
    2680:	4785                	li	a5,1
    2682:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2686:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    268a:	2905                	addiw	s2,s2,1
    268c:	ff3912e3          	bne	s2,s3,2670 <sbrkbasic+0xbe>
  pid = fork();
    2690:	00003097          	auipc	ra,0x3
    2694:	f6e080e7          	jalr	-146(ra) # 55fe <fork>
    2698:	892a                	mv	s2,a0
  if(pid < 0){
    269a:	04054d63          	bltz	a0,26f4 <sbrkbasic+0x142>
  c = sbrk(1);
    269e:	4505                	li	a0,1
    26a0:	00003097          	auipc	ra,0x3
    26a4:	fee080e7          	jalr	-18(ra) # 568e <sbrk>
  c = sbrk(1);
    26a8:	4505                	li	a0,1
    26aa:	00003097          	auipc	ra,0x3
    26ae:	fe4080e7          	jalr	-28(ra) # 568e <sbrk>
  if(c != a + 1){
    26b2:	0489                	addi	s1,s1,2
    26b4:	04a48e63          	beq	s1,a0,2710 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    26b8:	85d2                	mv	a1,s4
    26ba:	00004517          	auipc	a0,0x4
    26be:	29e50513          	addi	a0,a0,670 # 6958 <malloc+0xf10>
    26c2:	00003097          	auipc	ra,0x3
    26c6:	2ce080e7          	jalr	718(ra) # 5990 <printf>
    exit(1);
    26ca:	4505                	li	a0,1
    26cc:	00003097          	auipc	ra,0x3
    26d0:	f3a080e7          	jalr	-198(ra) # 5606 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26d4:	86aa                	mv	a3,a0
    26d6:	8626                	mv	a2,s1
    26d8:	85ca                	mv	a1,s2
    26da:	00004517          	auipc	a0,0x4
    26de:	23e50513          	addi	a0,a0,574 # 6918 <malloc+0xed0>
    26e2:	00003097          	auipc	ra,0x3
    26e6:	2ae080e7          	jalr	686(ra) # 5990 <printf>
      exit(1);
    26ea:	4505                	li	a0,1
    26ec:	00003097          	auipc	ra,0x3
    26f0:	f1a080e7          	jalr	-230(ra) # 5606 <exit>
    printf("%s: sbrk test fork failed\n", s);
    26f4:	85d2                	mv	a1,s4
    26f6:	00004517          	auipc	a0,0x4
    26fa:	24250513          	addi	a0,a0,578 # 6938 <malloc+0xef0>
    26fe:	00003097          	auipc	ra,0x3
    2702:	292080e7          	jalr	658(ra) # 5990 <printf>
    exit(1);
    2706:	4505                	li	a0,1
    2708:	00003097          	auipc	ra,0x3
    270c:	efe080e7          	jalr	-258(ra) # 5606 <exit>
  if(pid == 0)
    2710:	00091763          	bnez	s2,271e <sbrkbasic+0x16c>
    exit(0);
    2714:	4501                	li	a0,0
    2716:	00003097          	auipc	ra,0x3
    271a:	ef0080e7          	jalr	-272(ra) # 5606 <exit>
  wait(&xstatus);
    271e:	fcc40513          	addi	a0,s0,-52
    2722:	00003097          	auipc	ra,0x3
    2726:	eec080e7          	jalr	-276(ra) # 560e <wait>
  exit(xstatus);
    272a:	fcc42503          	lw	a0,-52(s0)
    272e:	00003097          	auipc	ra,0x3
    2732:	ed8080e7          	jalr	-296(ra) # 5606 <exit>

0000000000002736 <sbrkmuch>:
{
    2736:	7179                	addi	sp,sp,-48
    2738:	f406                	sd	ra,40(sp)
    273a:	f022                	sd	s0,32(sp)
    273c:	ec26                	sd	s1,24(sp)
    273e:	e84a                	sd	s2,16(sp)
    2740:	e44e                	sd	s3,8(sp)
    2742:	e052                	sd	s4,0(sp)
    2744:	1800                	addi	s0,sp,48
    2746:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2748:	4501                	li	a0,0
    274a:	00003097          	auipc	ra,0x3
    274e:	f44080e7          	jalr	-188(ra) # 568e <sbrk>
    2752:	892a                	mv	s2,a0
  a = sbrk(0);
    2754:	4501                	li	a0,0
    2756:	00003097          	auipc	ra,0x3
    275a:	f38080e7          	jalr	-200(ra) # 568e <sbrk>
    275e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2760:	06400537          	lui	a0,0x6400
    2764:	9d05                	subw	a0,a0,s1
    2766:	00003097          	auipc	ra,0x3
    276a:	f28080e7          	jalr	-216(ra) # 568e <sbrk>
  if (p != a) {
    276e:	0ca49863          	bne	s1,a0,283e <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2772:	4501                	li	a0,0
    2774:	00003097          	auipc	ra,0x3
    2778:	f1a080e7          	jalr	-230(ra) # 568e <sbrk>
    277c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    277e:	00a4f963          	bgeu	s1,a0,2790 <sbrkmuch+0x5a>
    *pp = 1;
    2782:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2784:	6705                	lui	a4,0x1
    *pp = 1;
    2786:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    278a:	94ba                	add	s1,s1,a4
    278c:	fef4ede3          	bltu	s1,a5,2786 <sbrkmuch+0x50>
  *lastaddr = 99;
    2790:	064007b7          	lui	a5,0x6400
    2794:	06300713          	li	a4,99
    2798:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f14f7>
  a = sbrk(0);
    279c:	4501                	li	a0,0
    279e:	00003097          	auipc	ra,0x3
    27a2:	ef0080e7          	jalr	-272(ra) # 568e <sbrk>
    27a6:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27a8:	757d                	lui	a0,0xfffff
    27aa:	00003097          	auipc	ra,0x3
    27ae:	ee4080e7          	jalr	-284(ra) # 568e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27b2:	57fd                	li	a5,-1
    27b4:	0af50363          	beq	a0,a5,285a <sbrkmuch+0x124>
  c = sbrk(0);
    27b8:	4501                	li	a0,0
    27ba:	00003097          	auipc	ra,0x3
    27be:	ed4080e7          	jalr	-300(ra) # 568e <sbrk>
  if(c != a - PGSIZE){
    27c2:	77fd                	lui	a5,0xfffff
    27c4:	97a6                	add	a5,a5,s1
    27c6:	0af51863          	bne	a0,a5,2876 <sbrkmuch+0x140>
  a = sbrk(0);
    27ca:	4501                	li	a0,0
    27cc:	00003097          	auipc	ra,0x3
    27d0:	ec2080e7          	jalr	-318(ra) # 568e <sbrk>
    27d4:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27d6:	6505                	lui	a0,0x1
    27d8:	00003097          	auipc	ra,0x3
    27dc:	eb6080e7          	jalr	-330(ra) # 568e <sbrk>
    27e0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27e2:	0aa49a63          	bne	s1,a0,2896 <sbrkmuch+0x160>
    27e6:	4501                	li	a0,0
    27e8:	00003097          	auipc	ra,0x3
    27ec:	ea6080e7          	jalr	-346(ra) # 568e <sbrk>
    27f0:	6785                	lui	a5,0x1
    27f2:	97a6                	add	a5,a5,s1
    27f4:	0af51163          	bne	a0,a5,2896 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    27f8:	064007b7          	lui	a5,0x6400
    27fc:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f14f7>
    2800:	06300793          	li	a5,99
    2804:	0af70963          	beq	a4,a5,28b6 <sbrkmuch+0x180>
  a = sbrk(0);
    2808:	4501                	li	a0,0
    280a:	00003097          	auipc	ra,0x3
    280e:	e84080e7          	jalr	-380(ra) # 568e <sbrk>
    2812:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2814:	4501                	li	a0,0
    2816:	00003097          	auipc	ra,0x3
    281a:	e78080e7          	jalr	-392(ra) # 568e <sbrk>
    281e:	40a9053b          	subw	a0,s2,a0
    2822:	00003097          	auipc	ra,0x3
    2826:	e6c080e7          	jalr	-404(ra) # 568e <sbrk>
  if(c != a){
    282a:	0aa49463          	bne	s1,a0,28d2 <sbrkmuch+0x19c>
}
    282e:	70a2                	ld	ra,40(sp)
    2830:	7402                	ld	s0,32(sp)
    2832:	64e2                	ld	s1,24(sp)
    2834:	6942                	ld	s2,16(sp)
    2836:	69a2                	ld	s3,8(sp)
    2838:	6a02                	ld	s4,0(sp)
    283a:	6145                	addi	sp,sp,48
    283c:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    283e:	85ce                	mv	a1,s3
    2840:	00004517          	auipc	a0,0x4
    2844:	13850513          	addi	a0,a0,312 # 6978 <malloc+0xf30>
    2848:	00003097          	auipc	ra,0x3
    284c:	148080e7          	jalr	328(ra) # 5990 <printf>
    exit(1);
    2850:	4505                	li	a0,1
    2852:	00003097          	auipc	ra,0x3
    2856:	db4080e7          	jalr	-588(ra) # 5606 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    285a:	85ce                	mv	a1,s3
    285c:	00004517          	auipc	a0,0x4
    2860:	16450513          	addi	a0,a0,356 # 69c0 <malloc+0xf78>
    2864:	00003097          	auipc	ra,0x3
    2868:	12c080e7          	jalr	300(ra) # 5990 <printf>
    exit(1);
    286c:	4505                	li	a0,1
    286e:	00003097          	auipc	ra,0x3
    2872:	d98080e7          	jalr	-616(ra) # 5606 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2876:	86aa                	mv	a3,a0
    2878:	8626                	mv	a2,s1
    287a:	85ce                	mv	a1,s3
    287c:	00004517          	auipc	a0,0x4
    2880:	16450513          	addi	a0,a0,356 # 69e0 <malloc+0xf98>
    2884:	00003097          	auipc	ra,0x3
    2888:	10c080e7          	jalr	268(ra) # 5990 <printf>
    exit(1);
    288c:	4505                	li	a0,1
    288e:	00003097          	auipc	ra,0x3
    2892:	d78080e7          	jalr	-648(ra) # 5606 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2896:	86d2                	mv	a3,s4
    2898:	8626                	mv	a2,s1
    289a:	85ce                	mv	a1,s3
    289c:	00004517          	auipc	a0,0x4
    28a0:	18450513          	addi	a0,a0,388 # 6a20 <malloc+0xfd8>
    28a4:	00003097          	auipc	ra,0x3
    28a8:	0ec080e7          	jalr	236(ra) # 5990 <printf>
    exit(1);
    28ac:	4505                	li	a0,1
    28ae:	00003097          	auipc	ra,0x3
    28b2:	d58080e7          	jalr	-680(ra) # 5606 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28b6:	85ce                	mv	a1,s3
    28b8:	00004517          	auipc	a0,0x4
    28bc:	19850513          	addi	a0,a0,408 # 6a50 <malloc+0x1008>
    28c0:	00003097          	auipc	ra,0x3
    28c4:	0d0080e7          	jalr	208(ra) # 5990 <printf>
    exit(1);
    28c8:	4505                	li	a0,1
    28ca:	00003097          	auipc	ra,0x3
    28ce:	d3c080e7          	jalr	-708(ra) # 5606 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28d2:	86aa                	mv	a3,a0
    28d4:	8626                	mv	a2,s1
    28d6:	85ce                	mv	a1,s3
    28d8:	00004517          	auipc	a0,0x4
    28dc:	1b050513          	addi	a0,a0,432 # 6a88 <malloc+0x1040>
    28e0:	00003097          	auipc	ra,0x3
    28e4:	0b0080e7          	jalr	176(ra) # 5990 <printf>
    exit(1);
    28e8:	4505                	li	a0,1
    28ea:	00003097          	auipc	ra,0x3
    28ee:	d1c080e7          	jalr	-740(ra) # 5606 <exit>

00000000000028f2 <sbrkarg>:
{
    28f2:	7179                	addi	sp,sp,-48
    28f4:	f406                	sd	ra,40(sp)
    28f6:	f022                	sd	s0,32(sp)
    28f8:	ec26                	sd	s1,24(sp)
    28fa:	e84a                	sd	s2,16(sp)
    28fc:	e44e                	sd	s3,8(sp)
    28fe:	1800                	addi	s0,sp,48
    2900:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2902:	6505                	lui	a0,0x1
    2904:	00003097          	auipc	ra,0x3
    2908:	d8a080e7          	jalr	-630(ra) # 568e <sbrk>
    290c:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    290e:	20100593          	li	a1,513
    2912:	00004517          	auipc	a0,0x4
    2916:	19e50513          	addi	a0,a0,414 # 6ab0 <malloc+0x1068>
    291a:	00003097          	auipc	ra,0x3
    291e:	d2c080e7          	jalr	-724(ra) # 5646 <open>
    2922:	84aa                	mv	s1,a0
  unlink("sbrk");
    2924:	00004517          	auipc	a0,0x4
    2928:	18c50513          	addi	a0,a0,396 # 6ab0 <malloc+0x1068>
    292c:	00003097          	auipc	ra,0x3
    2930:	d2a080e7          	jalr	-726(ra) # 5656 <unlink>
  if(fd < 0)  {
    2934:	0404c163          	bltz	s1,2976 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2938:	6605                	lui	a2,0x1
    293a:	85ca                	mv	a1,s2
    293c:	8526                	mv	a0,s1
    293e:	00003097          	auipc	ra,0x3
    2942:	ce8080e7          	jalr	-792(ra) # 5626 <write>
    2946:	04054663          	bltz	a0,2992 <sbrkarg+0xa0>
  close(fd);
    294a:	8526                	mv	a0,s1
    294c:	00003097          	auipc	ra,0x3
    2950:	ce2080e7          	jalr	-798(ra) # 562e <close>
  a = sbrk(PGSIZE);
    2954:	6505                	lui	a0,0x1
    2956:	00003097          	auipc	ra,0x3
    295a:	d38080e7          	jalr	-712(ra) # 568e <sbrk>
  if(pipe((int *) a) != 0){
    295e:	00003097          	auipc	ra,0x3
    2962:	cb8080e7          	jalr	-840(ra) # 5616 <pipe>
    2966:	e521                	bnez	a0,29ae <sbrkarg+0xbc>
}
    2968:	70a2                	ld	ra,40(sp)
    296a:	7402                	ld	s0,32(sp)
    296c:	64e2                	ld	s1,24(sp)
    296e:	6942                	ld	s2,16(sp)
    2970:	69a2                	ld	s3,8(sp)
    2972:	6145                	addi	sp,sp,48
    2974:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2976:	85ce                	mv	a1,s3
    2978:	00004517          	auipc	a0,0x4
    297c:	14050513          	addi	a0,a0,320 # 6ab8 <malloc+0x1070>
    2980:	00003097          	auipc	ra,0x3
    2984:	010080e7          	jalr	16(ra) # 5990 <printf>
    exit(1);
    2988:	4505                	li	a0,1
    298a:	00003097          	auipc	ra,0x3
    298e:	c7c080e7          	jalr	-900(ra) # 5606 <exit>
    printf("%s: write sbrk failed\n", s);
    2992:	85ce                	mv	a1,s3
    2994:	00004517          	auipc	a0,0x4
    2998:	13c50513          	addi	a0,a0,316 # 6ad0 <malloc+0x1088>
    299c:	00003097          	auipc	ra,0x3
    29a0:	ff4080e7          	jalr	-12(ra) # 5990 <printf>
    exit(1);
    29a4:	4505                	li	a0,1
    29a6:	00003097          	auipc	ra,0x3
    29aa:	c60080e7          	jalr	-928(ra) # 5606 <exit>
    printf("%s: pipe() failed\n", s);
    29ae:	85ce                	mv	a1,s3
    29b0:	00004517          	auipc	a0,0x4
    29b4:	b1850513          	addi	a0,a0,-1256 # 64c8 <malloc+0xa80>
    29b8:	00003097          	auipc	ra,0x3
    29bc:	fd8080e7          	jalr	-40(ra) # 5990 <printf>
    exit(1);
    29c0:	4505                	li	a0,1
    29c2:	00003097          	auipc	ra,0x3
    29c6:	c44080e7          	jalr	-956(ra) # 5606 <exit>

00000000000029ca <argptest>:
{
    29ca:	1101                	addi	sp,sp,-32
    29cc:	ec06                	sd	ra,24(sp)
    29ce:	e822                	sd	s0,16(sp)
    29d0:	e426                	sd	s1,8(sp)
    29d2:	e04a                	sd	s2,0(sp)
    29d4:	1000                	addi	s0,sp,32
    29d6:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29d8:	4581                	li	a1,0
    29da:	00004517          	auipc	a0,0x4
    29de:	10e50513          	addi	a0,a0,270 # 6ae8 <malloc+0x10a0>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	c64080e7          	jalr	-924(ra) # 5646 <open>
  if (fd < 0) {
    29ea:	02054b63          	bltz	a0,2a20 <argptest+0x56>
    29ee:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f0:	4501                	li	a0,0
    29f2:	00003097          	auipc	ra,0x3
    29f6:	c9c080e7          	jalr	-868(ra) # 568e <sbrk>
    29fa:	567d                	li	a2,-1
    29fc:	fff50593          	addi	a1,a0,-1
    2a00:	8526                	mv	a0,s1
    2a02:	00003097          	auipc	ra,0x3
    2a06:	c1c080e7          	jalr	-996(ra) # 561e <read>
  close(fd);
    2a0a:	8526                	mv	a0,s1
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	c22080e7          	jalr	-990(ra) # 562e <close>
}
    2a14:	60e2                	ld	ra,24(sp)
    2a16:	6442                	ld	s0,16(sp)
    2a18:	64a2                	ld	s1,8(sp)
    2a1a:	6902                	ld	s2,0(sp)
    2a1c:	6105                	addi	sp,sp,32
    2a1e:	8082                	ret
    printf("%s: open failed\n", s);
    2a20:	85ca                	mv	a1,s2
    2a22:	00004517          	auipc	a0,0x4
    2a26:	9b650513          	addi	a0,a0,-1610 # 63d8 <malloc+0x990>
    2a2a:	00003097          	auipc	ra,0x3
    2a2e:	f66080e7          	jalr	-154(ra) # 5990 <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	00003097          	auipc	ra,0x3
    2a38:	bd2080e7          	jalr	-1070(ra) # 5606 <exit>

0000000000002a3c <sbrkbugs>:
{
    2a3c:	1141                	addi	sp,sp,-16
    2a3e:	e406                	sd	ra,8(sp)
    2a40:	e022                	sd	s0,0(sp)
    2a42:	0800                	addi	s0,sp,16
  int pid = fork();
    2a44:	00003097          	auipc	ra,0x3
    2a48:	bba080e7          	jalr	-1094(ra) # 55fe <fork>
  if(pid < 0){
    2a4c:	02054263          	bltz	a0,2a70 <sbrkbugs+0x34>
  if(pid == 0){
    2a50:	ed0d                	bnez	a0,2a8a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a52:	00003097          	auipc	ra,0x3
    2a56:	c3c080e7          	jalr	-964(ra) # 568e <sbrk>
    sbrk(-sz);
    2a5a:	40a0053b          	negw	a0,a0
    2a5e:	00003097          	auipc	ra,0x3
    2a62:	c30080e7          	jalr	-976(ra) # 568e <sbrk>
    exit(0);
    2a66:	4501                	li	a0,0
    2a68:	00003097          	auipc	ra,0x3
    2a6c:	b9e080e7          	jalr	-1122(ra) # 5606 <exit>
    printf("fork failed\n");
    2a70:	00004517          	auipc	a0,0x4
    2a74:	d5850513          	addi	a0,a0,-680 # 67c8 <malloc+0xd80>
    2a78:	00003097          	auipc	ra,0x3
    2a7c:	f18080e7          	jalr	-232(ra) # 5990 <printf>
    exit(1);
    2a80:	4505                	li	a0,1
    2a82:	00003097          	auipc	ra,0x3
    2a86:	b84080e7          	jalr	-1148(ra) # 5606 <exit>
  wait(0);
    2a8a:	4501                	li	a0,0
    2a8c:	00003097          	auipc	ra,0x3
    2a90:	b82080e7          	jalr	-1150(ra) # 560e <wait>
  pid = fork();
    2a94:	00003097          	auipc	ra,0x3
    2a98:	b6a080e7          	jalr	-1174(ra) # 55fe <fork>
  if(pid < 0){
    2a9c:	02054563          	bltz	a0,2ac6 <sbrkbugs+0x8a>
  if(pid == 0){
    2aa0:	e121                	bnez	a0,2ae0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	bec080e7          	jalr	-1044(ra) # 568e <sbrk>
    sbrk(-(sz - 3500));
    2aaa:	6785                	lui	a5,0x1
    2aac:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x98>
    2ab0:	40a7853b          	subw	a0,a5,a0
    2ab4:	00003097          	auipc	ra,0x3
    2ab8:	bda080e7          	jalr	-1062(ra) # 568e <sbrk>
    exit(0);
    2abc:	4501                	li	a0,0
    2abe:	00003097          	auipc	ra,0x3
    2ac2:	b48080e7          	jalr	-1208(ra) # 5606 <exit>
    printf("fork failed\n");
    2ac6:	00004517          	auipc	a0,0x4
    2aca:	d0250513          	addi	a0,a0,-766 # 67c8 <malloc+0xd80>
    2ace:	00003097          	auipc	ra,0x3
    2ad2:	ec2080e7          	jalr	-318(ra) # 5990 <printf>
    exit(1);
    2ad6:	4505                	li	a0,1
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	b2e080e7          	jalr	-1234(ra) # 5606 <exit>
  wait(0);
    2ae0:	4501                	li	a0,0
    2ae2:	00003097          	auipc	ra,0x3
    2ae6:	b2c080e7          	jalr	-1236(ra) # 560e <wait>
  pid = fork();
    2aea:	00003097          	auipc	ra,0x3
    2aee:	b14080e7          	jalr	-1260(ra) # 55fe <fork>
  if(pid < 0){
    2af2:	02054a63          	bltz	a0,2b26 <sbrkbugs+0xea>
  if(pid == 0){
    2af6:	e529                	bnez	a0,2b40 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2af8:	00003097          	auipc	ra,0x3
    2afc:	b96080e7          	jalr	-1130(ra) # 568e <sbrk>
    2b00:	67ad                	lui	a5,0xb
    2b02:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1418>
    2b06:	40a7853b          	subw	a0,a5,a0
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	b84080e7          	jalr	-1148(ra) # 568e <sbrk>
    sbrk(-10);
    2b12:	5559                	li	a0,-10
    2b14:	00003097          	auipc	ra,0x3
    2b18:	b7a080e7          	jalr	-1158(ra) # 568e <sbrk>
    exit(0);
    2b1c:	4501                	li	a0,0
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	ae8080e7          	jalr	-1304(ra) # 5606 <exit>
    printf("fork failed\n");
    2b26:	00004517          	auipc	a0,0x4
    2b2a:	ca250513          	addi	a0,a0,-862 # 67c8 <malloc+0xd80>
    2b2e:	00003097          	auipc	ra,0x3
    2b32:	e62080e7          	jalr	-414(ra) # 5990 <printf>
    exit(1);
    2b36:	4505                	li	a0,1
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	ace080e7          	jalr	-1330(ra) # 5606 <exit>
  wait(0);
    2b40:	4501                	li	a0,0
    2b42:	00003097          	auipc	ra,0x3
    2b46:	acc080e7          	jalr	-1332(ra) # 560e <wait>
  exit(0);
    2b4a:	4501                	li	a0,0
    2b4c:	00003097          	auipc	ra,0x3
    2b50:	aba080e7          	jalr	-1350(ra) # 5606 <exit>

0000000000002b54 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b54:	715d                	addi	sp,sp,-80
    2b56:	e486                	sd	ra,72(sp)
    2b58:	e0a2                	sd	s0,64(sp)
    2b5a:	fc26                	sd	s1,56(sp)
    2b5c:	f84a                	sd	s2,48(sp)
    2b5e:	f44e                	sd	s3,40(sp)
    2b60:	f052                	sd	s4,32(sp)
    2b62:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b64:	4901                	li	s2,0
    2b66:	49bd                	li	s3,15
    int pid = fork();
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	a96080e7          	jalr	-1386(ra) # 55fe <fork>
    2b70:	84aa                	mv	s1,a0
    if(pid < 0){
    2b72:	02054063          	bltz	a0,2b92 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b76:	c91d                	beqz	a0,2bac <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b78:	4501                	li	a0,0
    2b7a:	00003097          	auipc	ra,0x3
    2b7e:	a94080e7          	jalr	-1388(ra) # 560e <wait>
  for(int avail = 0; avail < 15; avail++){
    2b82:	2905                	addiw	s2,s2,1
    2b84:	ff3912e3          	bne	s2,s3,2b68 <execout+0x14>
    }
  }

  exit(0);
    2b88:	4501                	li	a0,0
    2b8a:	00003097          	auipc	ra,0x3
    2b8e:	a7c080e7          	jalr	-1412(ra) # 5606 <exit>
      printf("fork failed\n");
    2b92:	00004517          	auipc	a0,0x4
    2b96:	c3650513          	addi	a0,a0,-970 # 67c8 <malloc+0xd80>
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	df6080e7          	jalr	-522(ra) # 5990 <printf>
      exit(1);
    2ba2:	4505                	li	a0,1
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	a62080e7          	jalr	-1438(ra) # 5606 <exit>
        if(a == 0xffffffffffffffffLL)
    2bac:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bae:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb0:	6505                	lui	a0,0x1
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	adc080e7          	jalr	-1316(ra) # 568e <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bba:	01350763          	beq	a0,s3,2bc8 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bbe:	6785                	lui	a5,0x1
    2bc0:	97aa                	add	a5,a5,a0
    2bc2:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x9f>
      while(1){
    2bc6:	b7ed                	j	2bb0 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bc8:	01205a63          	blez	s2,2bdc <execout+0x88>
        sbrk(-4096);
    2bcc:	757d                	lui	a0,0xfffff
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	ac0080e7          	jalr	-1344(ra) # 568e <sbrk>
      for(int i = 0; i < avail; i++)
    2bd6:	2485                	addiw	s1,s1,1
    2bd8:	ff249ae3          	bne	s1,s2,2bcc <execout+0x78>
      close(1);
    2bdc:	4505                	li	a0,1
    2bde:	00003097          	auipc	ra,0x3
    2be2:	a50080e7          	jalr	-1456(ra) # 562e <close>
      char *args[] = { "echo", "x", 0 };
    2be6:	00003517          	auipc	a0,0x3
    2bea:	f8250513          	addi	a0,a0,-126 # 5b68 <malloc+0x120>
    2bee:	faa43c23          	sd	a0,-72(s0)
    2bf2:	00003797          	auipc	a5,0x3
    2bf6:	fe678793          	addi	a5,a5,-26 # 5bd8 <malloc+0x190>
    2bfa:	fcf43023          	sd	a5,-64(s0)
    2bfe:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c02:	fb840593          	addi	a1,s0,-72
    2c06:	00003097          	auipc	ra,0x3
    2c0a:	a38080e7          	jalr	-1480(ra) # 563e <exec>
      exit(0);
    2c0e:	4501                	li	a0,0
    2c10:	00003097          	auipc	ra,0x3
    2c14:	9f6080e7          	jalr	-1546(ra) # 5606 <exit>

0000000000002c18 <fourteen>:
{
    2c18:	1101                	addi	sp,sp,-32
    2c1a:	ec06                	sd	ra,24(sp)
    2c1c:	e822                	sd	s0,16(sp)
    2c1e:	e426                	sd	s1,8(sp)
    2c20:	1000                	addi	s0,sp,32
    2c22:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c24:	00004517          	auipc	a0,0x4
    2c28:	09c50513          	addi	a0,a0,156 # 6cc0 <malloc+0x1278>
    2c2c:	00003097          	auipc	ra,0x3
    2c30:	a42080e7          	jalr	-1470(ra) # 566e <mkdir>
    2c34:	e165                	bnez	a0,2d14 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c36:	00004517          	auipc	a0,0x4
    2c3a:	ee250513          	addi	a0,a0,-286 # 6b18 <malloc+0x10d0>
    2c3e:	00003097          	auipc	ra,0x3
    2c42:	a30080e7          	jalr	-1488(ra) # 566e <mkdir>
    2c46:	e56d                	bnez	a0,2d30 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c48:	20000593          	li	a1,512
    2c4c:	00004517          	auipc	a0,0x4
    2c50:	f2450513          	addi	a0,a0,-220 # 6b70 <malloc+0x1128>
    2c54:	00003097          	auipc	ra,0x3
    2c58:	9f2080e7          	jalr	-1550(ra) # 5646 <open>
  if(fd < 0){
    2c5c:	0e054863          	bltz	a0,2d4c <fourteen+0x134>
  close(fd);
    2c60:	00003097          	auipc	ra,0x3
    2c64:	9ce080e7          	jalr	-1586(ra) # 562e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c68:	4581                	li	a1,0
    2c6a:	00004517          	auipc	a0,0x4
    2c6e:	f7e50513          	addi	a0,a0,-130 # 6be8 <malloc+0x11a0>
    2c72:	00003097          	auipc	ra,0x3
    2c76:	9d4080e7          	jalr	-1580(ra) # 5646 <open>
  if(fd < 0){
    2c7a:	0e054763          	bltz	a0,2d68 <fourteen+0x150>
  close(fd);
    2c7e:	00003097          	auipc	ra,0x3
    2c82:	9b0080e7          	jalr	-1616(ra) # 562e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	fd250513          	addi	a0,a0,-46 # 6c58 <malloc+0x1210>
    2c8e:	00003097          	auipc	ra,0x3
    2c92:	9e0080e7          	jalr	-1568(ra) # 566e <mkdir>
    2c96:	c57d                	beqz	a0,2d84 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2c98:	00004517          	auipc	a0,0x4
    2c9c:	01850513          	addi	a0,a0,24 # 6cb0 <malloc+0x1268>
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	9ce080e7          	jalr	-1586(ra) # 566e <mkdir>
    2ca8:	cd65                	beqz	a0,2da0 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2caa:	00004517          	auipc	a0,0x4
    2cae:	00650513          	addi	a0,a0,6 # 6cb0 <malloc+0x1268>
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	9a4080e7          	jalr	-1628(ra) # 5656 <unlink>
  unlink("12345678901234/12345678901234");
    2cba:	00004517          	auipc	a0,0x4
    2cbe:	f9e50513          	addi	a0,a0,-98 # 6c58 <malloc+0x1210>
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	994080e7          	jalr	-1644(ra) # 5656 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cca:	00004517          	auipc	a0,0x4
    2cce:	f1e50513          	addi	a0,a0,-226 # 6be8 <malloc+0x11a0>
    2cd2:	00003097          	auipc	ra,0x3
    2cd6:	984080e7          	jalr	-1660(ra) # 5656 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2cda:	00004517          	auipc	a0,0x4
    2cde:	e9650513          	addi	a0,a0,-362 # 6b70 <malloc+0x1128>
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	974080e7          	jalr	-1676(ra) # 5656 <unlink>
  unlink("12345678901234/123456789012345");
    2cea:	00004517          	auipc	a0,0x4
    2cee:	e2e50513          	addi	a0,a0,-466 # 6b18 <malloc+0x10d0>
    2cf2:	00003097          	auipc	ra,0x3
    2cf6:	964080e7          	jalr	-1692(ra) # 5656 <unlink>
  unlink("12345678901234");
    2cfa:	00004517          	auipc	a0,0x4
    2cfe:	fc650513          	addi	a0,a0,-58 # 6cc0 <malloc+0x1278>
    2d02:	00003097          	auipc	ra,0x3
    2d06:	954080e7          	jalr	-1708(ra) # 5656 <unlink>
}
    2d0a:	60e2                	ld	ra,24(sp)
    2d0c:	6442                	ld	s0,16(sp)
    2d0e:	64a2                	ld	s1,8(sp)
    2d10:	6105                	addi	sp,sp,32
    2d12:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d14:	85a6                	mv	a1,s1
    2d16:	00004517          	auipc	a0,0x4
    2d1a:	dda50513          	addi	a0,a0,-550 # 6af0 <malloc+0x10a8>
    2d1e:	00003097          	auipc	ra,0x3
    2d22:	c72080e7          	jalr	-910(ra) # 5990 <printf>
    exit(1);
    2d26:	4505                	li	a0,1
    2d28:	00003097          	auipc	ra,0x3
    2d2c:	8de080e7          	jalr	-1826(ra) # 5606 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d30:	85a6                	mv	a1,s1
    2d32:	00004517          	auipc	a0,0x4
    2d36:	e0650513          	addi	a0,a0,-506 # 6b38 <malloc+0x10f0>
    2d3a:	00003097          	auipc	ra,0x3
    2d3e:	c56080e7          	jalr	-938(ra) # 5990 <printf>
    exit(1);
    2d42:	4505                	li	a0,1
    2d44:	00003097          	auipc	ra,0x3
    2d48:	8c2080e7          	jalr	-1854(ra) # 5606 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d4c:	85a6                	mv	a1,s1
    2d4e:	00004517          	auipc	a0,0x4
    2d52:	e5250513          	addi	a0,a0,-430 # 6ba0 <malloc+0x1158>
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	c3a080e7          	jalr	-966(ra) # 5990 <printf>
    exit(1);
    2d5e:	4505                	li	a0,1
    2d60:	00003097          	auipc	ra,0x3
    2d64:	8a6080e7          	jalr	-1882(ra) # 5606 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d68:	85a6                	mv	a1,s1
    2d6a:	00004517          	auipc	a0,0x4
    2d6e:	eae50513          	addi	a0,a0,-338 # 6c18 <malloc+0x11d0>
    2d72:	00003097          	auipc	ra,0x3
    2d76:	c1e080e7          	jalr	-994(ra) # 5990 <printf>
    exit(1);
    2d7a:	4505                	li	a0,1
    2d7c:	00003097          	auipc	ra,0x3
    2d80:	88a080e7          	jalr	-1910(ra) # 5606 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d84:	85a6                	mv	a1,s1
    2d86:	00004517          	auipc	a0,0x4
    2d8a:	ef250513          	addi	a0,a0,-270 # 6c78 <malloc+0x1230>
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	c02080e7          	jalr	-1022(ra) # 5990 <printf>
    exit(1);
    2d96:	4505                	li	a0,1
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	86e080e7          	jalr	-1938(ra) # 5606 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da0:	85a6                	mv	a1,s1
    2da2:	00004517          	auipc	a0,0x4
    2da6:	f2e50513          	addi	a0,a0,-210 # 6cd0 <malloc+0x1288>
    2daa:	00003097          	auipc	ra,0x3
    2dae:	be6080e7          	jalr	-1050(ra) # 5990 <printf>
    exit(1);
    2db2:	4505                	li	a0,1
    2db4:	00003097          	auipc	ra,0x3
    2db8:	852080e7          	jalr	-1966(ra) # 5606 <exit>

0000000000002dbc <iputtest>:
{
    2dbc:	1101                	addi	sp,sp,-32
    2dbe:	ec06                	sd	ra,24(sp)
    2dc0:	e822                	sd	s0,16(sp)
    2dc2:	e426                	sd	s1,8(sp)
    2dc4:	1000                	addi	s0,sp,32
    2dc6:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dc8:	00004517          	auipc	a0,0x4
    2dcc:	f4050513          	addi	a0,a0,-192 # 6d08 <malloc+0x12c0>
    2dd0:	00003097          	auipc	ra,0x3
    2dd4:	89e080e7          	jalr	-1890(ra) # 566e <mkdir>
    2dd8:	04054563          	bltz	a0,2e22 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	f2c50513          	addi	a0,a0,-212 # 6d08 <malloc+0x12c0>
    2de4:	00003097          	auipc	ra,0x3
    2de8:	892080e7          	jalr	-1902(ra) # 5676 <chdir>
    2dec:	04054963          	bltz	a0,2e3e <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df0:	00004517          	auipc	a0,0x4
    2df4:	f5850513          	addi	a0,a0,-168 # 6d48 <malloc+0x1300>
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	85e080e7          	jalr	-1954(ra) # 5656 <unlink>
    2e00:	04054d63          	bltz	a0,2e5a <iputtest+0x9e>
  if(chdir("/") < 0){
    2e04:	00004517          	auipc	a0,0x4
    2e08:	f7450513          	addi	a0,a0,-140 # 6d78 <malloc+0x1330>
    2e0c:	00003097          	auipc	ra,0x3
    2e10:	86a080e7          	jalr	-1942(ra) # 5676 <chdir>
    2e14:	06054163          	bltz	a0,2e76 <iputtest+0xba>
}
    2e18:	60e2                	ld	ra,24(sp)
    2e1a:	6442                	ld	s0,16(sp)
    2e1c:	64a2                	ld	s1,8(sp)
    2e1e:	6105                	addi	sp,sp,32
    2e20:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e22:	85a6                	mv	a1,s1
    2e24:	00004517          	auipc	a0,0x4
    2e28:	eec50513          	addi	a0,a0,-276 # 6d10 <malloc+0x12c8>
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	b64080e7          	jalr	-1180(ra) # 5990 <printf>
    exit(1);
    2e34:	4505                	li	a0,1
    2e36:	00002097          	auipc	ra,0x2
    2e3a:	7d0080e7          	jalr	2000(ra) # 5606 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e3e:	85a6                	mv	a1,s1
    2e40:	00004517          	auipc	a0,0x4
    2e44:	ee850513          	addi	a0,a0,-280 # 6d28 <malloc+0x12e0>
    2e48:	00003097          	auipc	ra,0x3
    2e4c:	b48080e7          	jalr	-1208(ra) # 5990 <printf>
    exit(1);
    2e50:	4505                	li	a0,1
    2e52:	00002097          	auipc	ra,0x2
    2e56:	7b4080e7          	jalr	1972(ra) # 5606 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e5a:	85a6                	mv	a1,s1
    2e5c:	00004517          	auipc	a0,0x4
    2e60:	efc50513          	addi	a0,a0,-260 # 6d58 <malloc+0x1310>
    2e64:	00003097          	auipc	ra,0x3
    2e68:	b2c080e7          	jalr	-1236(ra) # 5990 <printf>
    exit(1);
    2e6c:	4505                	li	a0,1
    2e6e:	00002097          	auipc	ra,0x2
    2e72:	798080e7          	jalr	1944(ra) # 5606 <exit>
    printf("%s: chdir / failed\n", s);
    2e76:	85a6                	mv	a1,s1
    2e78:	00004517          	auipc	a0,0x4
    2e7c:	f0850513          	addi	a0,a0,-248 # 6d80 <malloc+0x1338>
    2e80:	00003097          	auipc	ra,0x3
    2e84:	b10080e7          	jalr	-1264(ra) # 5990 <printf>
    exit(1);
    2e88:	4505                	li	a0,1
    2e8a:	00002097          	auipc	ra,0x2
    2e8e:	77c080e7          	jalr	1916(ra) # 5606 <exit>

0000000000002e92 <exitiputtest>:
{
    2e92:	7179                	addi	sp,sp,-48
    2e94:	f406                	sd	ra,40(sp)
    2e96:	f022                	sd	s0,32(sp)
    2e98:	ec26                	sd	s1,24(sp)
    2e9a:	1800                	addi	s0,sp,48
    2e9c:	84aa                	mv	s1,a0
  pid = fork();
    2e9e:	00002097          	auipc	ra,0x2
    2ea2:	760080e7          	jalr	1888(ra) # 55fe <fork>
  if(pid < 0){
    2ea6:	04054663          	bltz	a0,2ef2 <exitiputtest+0x60>
  if(pid == 0){
    2eaa:	ed45                	bnez	a0,2f62 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eac:	00004517          	auipc	a0,0x4
    2eb0:	e5c50513          	addi	a0,a0,-420 # 6d08 <malloc+0x12c0>
    2eb4:	00002097          	auipc	ra,0x2
    2eb8:	7ba080e7          	jalr	1978(ra) # 566e <mkdir>
    2ebc:	04054963          	bltz	a0,2f0e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec0:	00004517          	auipc	a0,0x4
    2ec4:	e4850513          	addi	a0,a0,-440 # 6d08 <malloc+0x12c0>
    2ec8:	00002097          	auipc	ra,0x2
    2ecc:	7ae080e7          	jalr	1966(ra) # 5676 <chdir>
    2ed0:	04054d63          	bltz	a0,2f2a <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	e7450513          	addi	a0,a0,-396 # 6d48 <malloc+0x1300>
    2edc:	00002097          	auipc	ra,0x2
    2ee0:	77a080e7          	jalr	1914(ra) # 5656 <unlink>
    2ee4:	06054163          	bltz	a0,2f46 <exitiputtest+0xb4>
    exit(0);
    2ee8:	4501                	li	a0,0
    2eea:	00002097          	auipc	ra,0x2
    2eee:	71c080e7          	jalr	1820(ra) # 5606 <exit>
    printf("%s: fork failed\n", s);
    2ef2:	85a6                	mv	a1,s1
    2ef4:	00003517          	auipc	a0,0x3
    2ef8:	4cc50513          	addi	a0,a0,1228 # 63c0 <malloc+0x978>
    2efc:	00003097          	auipc	ra,0x3
    2f00:	a94080e7          	jalr	-1388(ra) # 5990 <printf>
    exit(1);
    2f04:	4505                	li	a0,1
    2f06:	00002097          	auipc	ra,0x2
    2f0a:	700080e7          	jalr	1792(ra) # 5606 <exit>
      printf("%s: mkdir failed\n", s);
    2f0e:	85a6                	mv	a1,s1
    2f10:	00004517          	auipc	a0,0x4
    2f14:	e0050513          	addi	a0,a0,-512 # 6d10 <malloc+0x12c8>
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	a78080e7          	jalr	-1416(ra) # 5990 <printf>
      exit(1);
    2f20:	4505                	li	a0,1
    2f22:	00002097          	auipc	ra,0x2
    2f26:	6e4080e7          	jalr	1764(ra) # 5606 <exit>
      printf("%s: child chdir failed\n", s);
    2f2a:	85a6                	mv	a1,s1
    2f2c:	00004517          	auipc	a0,0x4
    2f30:	e6c50513          	addi	a0,a0,-404 # 6d98 <malloc+0x1350>
    2f34:	00003097          	auipc	ra,0x3
    2f38:	a5c080e7          	jalr	-1444(ra) # 5990 <printf>
      exit(1);
    2f3c:	4505                	li	a0,1
    2f3e:	00002097          	auipc	ra,0x2
    2f42:	6c8080e7          	jalr	1736(ra) # 5606 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f46:	85a6                	mv	a1,s1
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	e1050513          	addi	a0,a0,-496 # 6d58 <malloc+0x1310>
    2f50:	00003097          	auipc	ra,0x3
    2f54:	a40080e7          	jalr	-1472(ra) # 5990 <printf>
      exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	00002097          	auipc	ra,0x2
    2f5e:	6ac080e7          	jalr	1708(ra) # 5606 <exit>
  wait(&xstatus);
    2f62:	fdc40513          	addi	a0,s0,-36
    2f66:	00002097          	auipc	ra,0x2
    2f6a:	6a8080e7          	jalr	1704(ra) # 560e <wait>
  exit(xstatus);
    2f6e:	fdc42503          	lw	a0,-36(s0)
    2f72:	00002097          	auipc	ra,0x2
    2f76:	694080e7          	jalr	1684(ra) # 5606 <exit>

0000000000002f7a <dirtest>:
{
    2f7a:	1101                	addi	sp,sp,-32
    2f7c:	ec06                	sd	ra,24(sp)
    2f7e:	e822                	sd	s0,16(sp)
    2f80:	e426                	sd	s1,8(sp)
    2f82:	1000                	addi	s0,sp,32
    2f84:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f86:	00004517          	auipc	a0,0x4
    2f8a:	e2a50513          	addi	a0,a0,-470 # 6db0 <malloc+0x1368>
    2f8e:	00002097          	auipc	ra,0x2
    2f92:	6e0080e7          	jalr	1760(ra) # 566e <mkdir>
    2f96:	04054563          	bltz	a0,2fe0 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2f9a:	00004517          	auipc	a0,0x4
    2f9e:	e1650513          	addi	a0,a0,-490 # 6db0 <malloc+0x1368>
    2fa2:	00002097          	auipc	ra,0x2
    2fa6:	6d4080e7          	jalr	1748(ra) # 5676 <chdir>
    2faa:	04054963          	bltz	a0,2ffc <dirtest+0x82>
  if(chdir("..") < 0){
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	e2250513          	addi	a0,a0,-478 # 6dd0 <malloc+0x1388>
    2fb6:	00002097          	auipc	ra,0x2
    2fba:	6c0080e7          	jalr	1728(ra) # 5676 <chdir>
    2fbe:	04054d63          	bltz	a0,3018 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fc2:	00004517          	auipc	a0,0x4
    2fc6:	dee50513          	addi	a0,a0,-530 # 6db0 <malloc+0x1368>
    2fca:	00002097          	auipc	ra,0x2
    2fce:	68c080e7          	jalr	1676(ra) # 5656 <unlink>
    2fd2:	06054163          	bltz	a0,3034 <dirtest+0xba>
}
    2fd6:	60e2                	ld	ra,24(sp)
    2fd8:	6442                	ld	s0,16(sp)
    2fda:	64a2                	ld	s1,8(sp)
    2fdc:	6105                	addi	sp,sp,32
    2fde:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe0:	85a6                	mv	a1,s1
    2fe2:	00004517          	auipc	a0,0x4
    2fe6:	d2e50513          	addi	a0,a0,-722 # 6d10 <malloc+0x12c8>
    2fea:	00003097          	auipc	ra,0x3
    2fee:	9a6080e7          	jalr	-1626(ra) # 5990 <printf>
    exit(1);
    2ff2:	4505                	li	a0,1
    2ff4:	00002097          	auipc	ra,0x2
    2ff8:	612080e7          	jalr	1554(ra) # 5606 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2ffc:	85a6                	mv	a1,s1
    2ffe:	00004517          	auipc	a0,0x4
    3002:	dba50513          	addi	a0,a0,-582 # 6db8 <malloc+0x1370>
    3006:	00003097          	auipc	ra,0x3
    300a:	98a080e7          	jalr	-1654(ra) # 5990 <printf>
    exit(1);
    300e:	4505                	li	a0,1
    3010:	00002097          	auipc	ra,0x2
    3014:	5f6080e7          	jalr	1526(ra) # 5606 <exit>
    printf("%s: chdir .. failed\n", s);
    3018:	85a6                	mv	a1,s1
    301a:	00004517          	auipc	a0,0x4
    301e:	dbe50513          	addi	a0,a0,-578 # 6dd8 <malloc+0x1390>
    3022:	00003097          	auipc	ra,0x3
    3026:	96e080e7          	jalr	-1682(ra) # 5990 <printf>
    exit(1);
    302a:	4505                	li	a0,1
    302c:	00002097          	auipc	ra,0x2
    3030:	5da080e7          	jalr	1498(ra) # 5606 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3034:	85a6                	mv	a1,s1
    3036:	00004517          	auipc	a0,0x4
    303a:	dba50513          	addi	a0,a0,-582 # 6df0 <malloc+0x13a8>
    303e:	00003097          	auipc	ra,0x3
    3042:	952080e7          	jalr	-1710(ra) # 5990 <printf>
    exit(1);
    3046:	4505                	li	a0,1
    3048:	00002097          	auipc	ra,0x2
    304c:	5be080e7          	jalr	1470(ra) # 5606 <exit>

0000000000003050 <subdir>:
{
    3050:	1101                	addi	sp,sp,-32
    3052:	ec06                	sd	ra,24(sp)
    3054:	e822                	sd	s0,16(sp)
    3056:	e426                	sd	s1,8(sp)
    3058:	e04a                	sd	s2,0(sp)
    305a:	1000                	addi	s0,sp,32
    305c:	892a                	mv	s2,a0
  unlink("ff");
    305e:	00004517          	auipc	a0,0x4
    3062:	eda50513          	addi	a0,a0,-294 # 6f38 <malloc+0x14f0>
    3066:	00002097          	auipc	ra,0x2
    306a:	5f0080e7          	jalr	1520(ra) # 5656 <unlink>
  if(mkdir("dd") != 0){
    306e:	00004517          	auipc	a0,0x4
    3072:	d9a50513          	addi	a0,a0,-614 # 6e08 <malloc+0x13c0>
    3076:	00002097          	auipc	ra,0x2
    307a:	5f8080e7          	jalr	1528(ra) # 566e <mkdir>
    307e:	38051663          	bnez	a0,340a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3082:	20200593          	li	a1,514
    3086:	00004517          	auipc	a0,0x4
    308a:	da250513          	addi	a0,a0,-606 # 6e28 <malloc+0x13e0>
    308e:	00002097          	auipc	ra,0x2
    3092:	5b8080e7          	jalr	1464(ra) # 5646 <open>
    3096:	84aa                	mv	s1,a0
  if(fd < 0){
    3098:	38054763          	bltz	a0,3426 <subdir+0x3d6>
  write(fd, "ff", 2);
    309c:	4609                	li	a2,2
    309e:	00004597          	auipc	a1,0x4
    30a2:	e9a58593          	addi	a1,a1,-358 # 6f38 <malloc+0x14f0>
    30a6:	00002097          	auipc	ra,0x2
    30aa:	580080e7          	jalr	1408(ra) # 5626 <write>
  close(fd);
    30ae:	8526                	mv	a0,s1
    30b0:	00002097          	auipc	ra,0x2
    30b4:	57e080e7          	jalr	1406(ra) # 562e <close>
  if(unlink("dd") >= 0){
    30b8:	00004517          	auipc	a0,0x4
    30bc:	d5050513          	addi	a0,a0,-688 # 6e08 <malloc+0x13c0>
    30c0:	00002097          	auipc	ra,0x2
    30c4:	596080e7          	jalr	1430(ra) # 5656 <unlink>
    30c8:	36055d63          	bgez	a0,3442 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30cc:	00004517          	auipc	a0,0x4
    30d0:	db450513          	addi	a0,a0,-588 # 6e80 <malloc+0x1438>
    30d4:	00002097          	auipc	ra,0x2
    30d8:	59a080e7          	jalr	1434(ra) # 566e <mkdir>
    30dc:	38051163          	bnez	a0,345e <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e0:	20200593          	li	a1,514
    30e4:	00004517          	auipc	a0,0x4
    30e8:	dc450513          	addi	a0,a0,-572 # 6ea8 <malloc+0x1460>
    30ec:	00002097          	auipc	ra,0x2
    30f0:	55a080e7          	jalr	1370(ra) # 5646 <open>
    30f4:	84aa                	mv	s1,a0
  if(fd < 0){
    30f6:	38054263          	bltz	a0,347a <subdir+0x42a>
  write(fd, "FF", 2);
    30fa:	4609                	li	a2,2
    30fc:	00004597          	auipc	a1,0x4
    3100:	ddc58593          	addi	a1,a1,-548 # 6ed8 <malloc+0x1490>
    3104:	00002097          	auipc	ra,0x2
    3108:	522080e7          	jalr	1314(ra) # 5626 <write>
  close(fd);
    310c:	8526                	mv	a0,s1
    310e:	00002097          	auipc	ra,0x2
    3112:	520080e7          	jalr	1312(ra) # 562e <close>
  fd = open("dd/dd/../ff", 0);
    3116:	4581                	li	a1,0
    3118:	00004517          	auipc	a0,0x4
    311c:	dc850513          	addi	a0,a0,-568 # 6ee0 <malloc+0x1498>
    3120:	00002097          	auipc	ra,0x2
    3124:	526080e7          	jalr	1318(ra) # 5646 <open>
    3128:	84aa                	mv	s1,a0
  if(fd < 0){
    312a:	36054663          	bltz	a0,3496 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    312e:	660d                	lui	a2,0x3
    3130:	00009597          	auipc	a1,0x9
    3134:	9c858593          	addi	a1,a1,-1592 # baf8 <buf>
    3138:	00002097          	auipc	ra,0x2
    313c:	4e6080e7          	jalr	1254(ra) # 561e <read>
  if(cc != 2 || buf[0] != 'f'){
    3140:	4789                	li	a5,2
    3142:	36f51863          	bne	a0,a5,34b2 <subdir+0x462>
    3146:	00009717          	auipc	a4,0x9
    314a:	9b274703          	lbu	a4,-1614(a4) # baf8 <buf>
    314e:	06600793          	li	a5,102
    3152:	36f71063          	bne	a4,a5,34b2 <subdir+0x462>
  close(fd);
    3156:	8526                	mv	a0,s1
    3158:	00002097          	auipc	ra,0x2
    315c:	4d6080e7          	jalr	1238(ra) # 562e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3160:	00004597          	auipc	a1,0x4
    3164:	dd058593          	addi	a1,a1,-560 # 6f30 <malloc+0x14e8>
    3168:	00004517          	auipc	a0,0x4
    316c:	d4050513          	addi	a0,a0,-704 # 6ea8 <malloc+0x1460>
    3170:	00002097          	auipc	ra,0x2
    3174:	4f6080e7          	jalr	1270(ra) # 5666 <link>
    3178:	34051b63          	bnez	a0,34ce <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    317c:	00004517          	auipc	a0,0x4
    3180:	d2c50513          	addi	a0,a0,-724 # 6ea8 <malloc+0x1460>
    3184:	00002097          	auipc	ra,0x2
    3188:	4d2080e7          	jalr	1234(ra) # 5656 <unlink>
    318c:	34051f63          	bnez	a0,34ea <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3190:	4581                	li	a1,0
    3192:	00004517          	auipc	a0,0x4
    3196:	d1650513          	addi	a0,a0,-746 # 6ea8 <malloc+0x1460>
    319a:	00002097          	auipc	ra,0x2
    319e:	4ac080e7          	jalr	1196(ra) # 5646 <open>
    31a2:	36055263          	bgez	a0,3506 <subdir+0x4b6>
  if(chdir("dd") != 0){
    31a6:	00004517          	auipc	a0,0x4
    31aa:	c6250513          	addi	a0,a0,-926 # 6e08 <malloc+0x13c0>
    31ae:	00002097          	auipc	ra,0x2
    31b2:	4c8080e7          	jalr	1224(ra) # 5676 <chdir>
    31b6:	36051663          	bnez	a0,3522 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31ba:	00004517          	auipc	a0,0x4
    31be:	e0e50513          	addi	a0,a0,-498 # 6fc8 <malloc+0x1580>
    31c2:	00002097          	auipc	ra,0x2
    31c6:	4b4080e7          	jalr	1204(ra) # 5676 <chdir>
    31ca:	36051a63          	bnez	a0,353e <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31ce:	00004517          	auipc	a0,0x4
    31d2:	e2a50513          	addi	a0,a0,-470 # 6ff8 <malloc+0x15b0>
    31d6:	00002097          	auipc	ra,0x2
    31da:	4a0080e7          	jalr	1184(ra) # 5676 <chdir>
    31de:	36051e63          	bnez	a0,355a <subdir+0x50a>
  if(chdir("./..") != 0){
    31e2:	00004517          	auipc	a0,0x4
    31e6:	e4650513          	addi	a0,a0,-442 # 7028 <malloc+0x15e0>
    31ea:	00002097          	auipc	ra,0x2
    31ee:	48c080e7          	jalr	1164(ra) # 5676 <chdir>
    31f2:	38051263          	bnez	a0,3576 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31f6:	4581                	li	a1,0
    31f8:	00004517          	auipc	a0,0x4
    31fc:	d3850513          	addi	a0,a0,-712 # 6f30 <malloc+0x14e8>
    3200:	00002097          	auipc	ra,0x2
    3204:	446080e7          	jalr	1094(ra) # 5646 <open>
    3208:	84aa                	mv	s1,a0
  if(fd < 0){
    320a:	38054463          	bltz	a0,3592 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    320e:	660d                	lui	a2,0x3
    3210:	00009597          	auipc	a1,0x9
    3214:	8e858593          	addi	a1,a1,-1816 # baf8 <buf>
    3218:	00002097          	auipc	ra,0x2
    321c:	406080e7          	jalr	1030(ra) # 561e <read>
    3220:	4789                	li	a5,2
    3222:	38f51663          	bne	a0,a5,35ae <subdir+0x55e>
  close(fd);
    3226:	8526                	mv	a0,s1
    3228:	00002097          	auipc	ra,0x2
    322c:	406080e7          	jalr	1030(ra) # 562e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3230:	4581                	li	a1,0
    3232:	00004517          	auipc	a0,0x4
    3236:	c7650513          	addi	a0,a0,-906 # 6ea8 <malloc+0x1460>
    323a:	00002097          	auipc	ra,0x2
    323e:	40c080e7          	jalr	1036(ra) # 5646 <open>
    3242:	38055463          	bgez	a0,35ca <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3246:	20200593          	li	a1,514
    324a:	00004517          	auipc	a0,0x4
    324e:	e6e50513          	addi	a0,a0,-402 # 70b8 <malloc+0x1670>
    3252:	00002097          	auipc	ra,0x2
    3256:	3f4080e7          	jalr	1012(ra) # 5646 <open>
    325a:	38055663          	bgez	a0,35e6 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    325e:	20200593          	li	a1,514
    3262:	00004517          	auipc	a0,0x4
    3266:	e8650513          	addi	a0,a0,-378 # 70e8 <malloc+0x16a0>
    326a:	00002097          	auipc	ra,0x2
    326e:	3dc080e7          	jalr	988(ra) # 5646 <open>
    3272:	38055863          	bgez	a0,3602 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3276:	20000593          	li	a1,512
    327a:	00004517          	auipc	a0,0x4
    327e:	b8e50513          	addi	a0,a0,-1138 # 6e08 <malloc+0x13c0>
    3282:	00002097          	auipc	ra,0x2
    3286:	3c4080e7          	jalr	964(ra) # 5646 <open>
    328a:	38055a63          	bgez	a0,361e <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    328e:	4589                	li	a1,2
    3290:	00004517          	auipc	a0,0x4
    3294:	b7850513          	addi	a0,a0,-1160 # 6e08 <malloc+0x13c0>
    3298:	00002097          	auipc	ra,0x2
    329c:	3ae080e7          	jalr	942(ra) # 5646 <open>
    32a0:	38055d63          	bgez	a0,363a <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32a4:	4585                	li	a1,1
    32a6:	00004517          	auipc	a0,0x4
    32aa:	b6250513          	addi	a0,a0,-1182 # 6e08 <malloc+0x13c0>
    32ae:	00002097          	auipc	ra,0x2
    32b2:	398080e7          	jalr	920(ra) # 5646 <open>
    32b6:	3a055063          	bgez	a0,3656 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32ba:	00004597          	auipc	a1,0x4
    32be:	ebe58593          	addi	a1,a1,-322 # 7178 <malloc+0x1730>
    32c2:	00004517          	auipc	a0,0x4
    32c6:	df650513          	addi	a0,a0,-522 # 70b8 <malloc+0x1670>
    32ca:	00002097          	auipc	ra,0x2
    32ce:	39c080e7          	jalr	924(ra) # 5666 <link>
    32d2:	3a050063          	beqz	a0,3672 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32d6:	00004597          	auipc	a1,0x4
    32da:	ea258593          	addi	a1,a1,-350 # 7178 <malloc+0x1730>
    32de:	00004517          	auipc	a0,0x4
    32e2:	e0a50513          	addi	a0,a0,-502 # 70e8 <malloc+0x16a0>
    32e6:	00002097          	auipc	ra,0x2
    32ea:	380080e7          	jalr	896(ra) # 5666 <link>
    32ee:	3a050063          	beqz	a0,368e <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32f2:	00004597          	auipc	a1,0x4
    32f6:	c3e58593          	addi	a1,a1,-962 # 6f30 <malloc+0x14e8>
    32fa:	00004517          	auipc	a0,0x4
    32fe:	b2e50513          	addi	a0,a0,-1234 # 6e28 <malloc+0x13e0>
    3302:	00002097          	auipc	ra,0x2
    3306:	364080e7          	jalr	868(ra) # 5666 <link>
    330a:	3a050063          	beqz	a0,36aa <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    330e:	00004517          	auipc	a0,0x4
    3312:	daa50513          	addi	a0,a0,-598 # 70b8 <malloc+0x1670>
    3316:	00002097          	auipc	ra,0x2
    331a:	358080e7          	jalr	856(ra) # 566e <mkdir>
    331e:	3a050463          	beqz	a0,36c6 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3322:	00004517          	auipc	a0,0x4
    3326:	dc650513          	addi	a0,a0,-570 # 70e8 <malloc+0x16a0>
    332a:	00002097          	auipc	ra,0x2
    332e:	344080e7          	jalr	836(ra) # 566e <mkdir>
    3332:	3a050863          	beqz	a0,36e2 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3336:	00004517          	auipc	a0,0x4
    333a:	bfa50513          	addi	a0,a0,-1030 # 6f30 <malloc+0x14e8>
    333e:	00002097          	auipc	ra,0x2
    3342:	330080e7          	jalr	816(ra) # 566e <mkdir>
    3346:	3a050c63          	beqz	a0,36fe <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    334a:	00004517          	auipc	a0,0x4
    334e:	d9e50513          	addi	a0,a0,-610 # 70e8 <malloc+0x16a0>
    3352:	00002097          	auipc	ra,0x2
    3356:	304080e7          	jalr	772(ra) # 5656 <unlink>
    335a:	3c050063          	beqz	a0,371a <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    335e:	00004517          	auipc	a0,0x4
    3362:	d5a50513          	addi	a0,a0,-678 # 70b8 <malloc+0x1670>
    3366:	00002097          	auipc	ra,0x2
    336a:	2f0080e7          	jalr	752(ra) # 5656 <unlink>
    336e:	3c050463          	beqz	a0,3736 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3372:	00004517          	auipc	a0,0x4
    3376:	ab650513          	addi	a0,a0,-1354 # 6e28 <malloc+0x13e0>
    337a:	00002097          	auipc	ra,0x2
    337e:	2fc080e7          	jalr	764(ra) # 5676 <chdir>
    3382:	3c050863          	beqz	a0,3752 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3386:	00004517          	auipc	a0,0x4
    338a:	f4250513          	addi	a0,a0,-190 # 72c8 <malloc+0x1880>
    338e:	00002097          	auipc	ra,0x2
    3392:	2e8080e7          	jalr	744(ra) # 5676 <chdir>
    3396:	3c050c63          	beqz	a0,376e <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    339a:	00004517          	auipc	a0,0x4
    339e:	b9650513          	addi	a0,a0,-1130 # 6f30 <malloc+0x14e8>
    33a2:	00002097          	auipc	ra,0x2
    33a6:	2b4080e7          	jalr	692(ra) # 5656 <unlink>
    33aa:	3e051063          	bnez	a0,378a <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33ae:	00004517          	auipc	a0,0x4
    33b2:	a7a50513          	addi	a0,a0,-1414 # 6e28 <malloc+0x13e0>
    33b6:	00002097          	auipc	ra,0x2
    33ba:	2a0080e7          	jalr	672(ra) # 5656 <unlink>
    33be:	3e051463          	bnez	a0,37a6 <subdir+0x756>
  if(unlink("dd") == 0){
    33c2:	00004517          	auipc	a0,0x4
    33c6:	a4650513          	addi	a0,a0,-1466 # 6e08 <malloc+0x13c0>
    33ca:	00002097          	auipc	ra,0x2
    33ce:	28c080e7          	jalr	652(ra) # 5656 <unlink>
    33d2:	3e050863          	beqz	a0,37c2 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33d6:	00004517          	auipc	a0,0x4
    33da:	f6250513          	addi	a0,a0,-158 # 7338 <malloc+0x18f0>
    33de:	00002097          	auipc	ra,0x2
    33e2:	278080e7          	jalr	632(ra) # 5656 <unlink>
    33e6:	3e054c63          	bltz	a0,37de <subdir+0x78e>
  if(unlink("dd") < 0){
    33ea:	00004517          	auipc	a0,0x4
    33ee:	a1e50513          	addi	a0,a0,-1506 # 6e08 <malloc+0x13c0>
    33f2:	00002097          	auipc	ra,0x2
    33f6:	264080e7          	jalr	612(ra) # 5656 <unlink>
    33fa:	40054063          	bltz	a0,37fa <subdir+0x7aa>
}
    33fe:	60e2                	ld	ra,24(sp)
    3400:	6442                	ld	s0,16(sp)
    3402:	64a2                	ld	s1,8(sp)
    3404:	6902                	ld	s2,0(sp)
    3406:	6105                	addi	sp,sp,32
    3408:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    340a:	85ca                	mv	a1,s2
    340c:	00004517          	auipc	a0,0x4
    3410:	a0450513          	addi	a0,a0,-1532 # 6e10 <malloc+0x13c8>
    3414:	00002097          	auipc	ra,0x2
    3418:	57c080e7          	jalr	1404(ra) # 5990 <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	00002097          	auipc	ra,0x2
    3422:	1e8080e7          	jalr	488(ra) # 5606 <exit>
    printf("%s: create dd/ff failed\n", s);
    3426:	85ca                	mv	a1,s2
    3428:	00004517          	auipc	a0,0x4
    342c:	a0850513          	addi	a0,a0,-1528 # 6e30 <malloc+0x13e8>
    3430:	00002097          	auipc	ra,0x2
    3434:	560080e7          	jalr	1376(ra) # 5990 <printf>
    exit(1);
    3438:	4505                	li	a0,1
    343a:	00002097          	auipc	ra,0x2
    343e:	1cc080e7          	jalr	460(ra) # 5606 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3442:	85ca                	mv	a1,s2
    3444:	00004517          	auipc	a0,0x4
    3448:	a0c50513          	addi	a0,a0,-1524 # 6e50 <malloc+0x1408>
    344c:	00002097          	auipc	ra,0x2
    3450:	544080e7          	jalr	1348(ra) # 5990 <printf>
    exit(1);
    3454:	4505                	li	a0,1
    3456:	00002097          	auipc	ra,0x2
    345a:	1b0080e7          	jalr	432(ra) # 5606 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    345e:	85ca                	mv	a1,s2
    3460:	00004517          	auipc	a0,0x4
    3464:	a2850513          	addi	a0,a0,-1496 # 6e88 <malloc+0x1440>
    3468:	00002097          	auipc	ra,0x2
    346c:	528080e7          	jalr	1320(ra) # 5990 <printf>
    exit(1);
    3470:	4505                	li	a0,1
    3472:	00002097          	auipc	ra,0x2
    3476:	194080e7          	jalr	404(ra) # 5606 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    347a:	85ca                	mv	a1,s2
    347c:	00004517          	auipc	a0,0x4
    3480:	a3c50513          	addi	a0,a0,-1476 # 6eb8 <malloc+0x1470>
    3484:	00002097          	auipc	ra,0x2
    3488:	50c080e7          	jalr	1292(ra) # 5990 <printf>
    exit(1);
    348c:	4505                	li	a0,1
    348e:	00002097          	auipc	ra,0x2
    3492:	178080e7          	jalr	376(ra) # 5606 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3496:	85ca                	mv	a1,s2
    3498:	00004517          	auipc	a0,0x4
    349c:	a5850513          	addi	a0,a0,-1448 # 6ef0 <malloc+0x14a8>
    34a0:	00002097          	auipc	ra,0x2
    34a4:	4f0080e7          	jalr	1264(ra) # 5990 <printf>
    exit(1);
    34a8:	4505                	li	a0,1
    34aa:	00002097          	auipc	ra,0x2
    34ae:	15c080e7          	jalr	348(ra) # 5606 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34b2:	85ca                	mv	a1,s2
    34b4:	00004517          	auipc	a0,0x4
    34b8:	a5c50513          	addi	a0,a0,-1444 # 6f10 <malloc+0x14c8>
    34bc:	00002097          	auipc	ra,0x2
    34c0:	4d4080e7          	jalr	1236(ra) # 5990 <printf>
    exit(1);
    34c4:	4505                	li	a0,1
    34c6:	00002097          	auipc	ra,0x2
    34ca:	140080e7          	jalr	320(ra) # 5606 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34ce:	85ca                	mv	a1,s2
    34d0:	00004517          	auipc	a0,0x4
    34d4:	a7050513          	addi	a0,a0,-1424 # 6f40 <malloc+0x14f8>
    34d8:	00002097          	auipc	ra,0x2
    34dc:	4b8080e7          	jalr	1208(ra) # 5990 <printf>
    exit(1);
    34e0:	4505                	li	a0,1
    34e2:	00002097          	auipc	ra,0x2
    34e6:	124080e7          	jalr	292(ra) # 5606 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34ea:	85ca                	mv	a1,s2
    34ec:	00004517          	auipc	a0,0x4
    34f0:	a7c50513          	addi	a0,a0,-1412 # 6f68 <malloc+0x1520>
    34f4:	00002097          	auipc	ra,0x2
    34f8:	49c080e7          	jalr	1180(ra) # 5990 <printf>
    exit(1);
    34fc:	4505                	li	a0,1
    34fe:	00002097          	auipc	ra,0x2
    3502:	108080e7          	jalr	264(ra) # 5606 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3506:	85ca                	mv	a1,s2
    3508:	00004517          	auipc	a0,0x4
    350c:	a8050513          	addi	a0,a0,-1408 # 6f88 <malloc+0x1540>
    3510:	00002097          	auipc	ra,0x2
    3514:	480080e7          	jalr	1152(ra) # 5990 <printf>
    exit(1);
    3518:	4505                	li	a0,1
    351a:	00002097          	auipc	ra,0x2
    351e:	0ec080e7          	jalr	236(ra) # 5606 <exit>
    printf("%s: chdir dd failed\n", s);
    3522:	85ca                	mv	a1,s2
    3524:	00004517          	auipc	a0,0x4
    3528:	a8c50513          	addi	a0,a0,-1396 # 6fb0 <malloc+0x1568>
    352c:	00002097          	auipc	ra,0x2
    3530:	464080e7          	jalr	1124(ra) # 5990 <printf>
    exit(1);
    3534:	4505                	li	a0,1
    3536:	00002097          	auipc	ra,0x2
    353a:	0d0080e7          	jalr	208(ra) # 5606 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    353e:	85ca                	mv	a1,s2
    3540:	00004517          	auipc	a0,0x4
    3544:	a9850513          	addi	a0,a0,-1384 # 6fd8 <malloc+0x1590>
    3548:	00002097          	auipc	ra,0x2
    354c:	448080e7          	jalr	1096(ra) # 5990 <printf>
    exit(1);
    3550:	4505                	li	a0,1
    3552:	00002097          	auipc	ra,0x2
    3556:	0b4080e7          	jalr	180(ra) # 5606 <exit>
    printf("chdir dd/../../dd failed\n", s);
    355a:	85ca                	mv	a1,s2
    355c:	00004517          	auipc	a0,0x4
    3560:	aac50513          	addi	a0,a0,-1364 # 7008 <malloc+0x15c0>
    3564:	00002097          	auipc	ra,0x2
    3568:	42c080e7          	jalr	1068(ra) # 5990 <printf>
    exit(1);
    356c:	4505                	li	a0,1
    356e:	00002097          	auipc	ra,0x2
    3572:	098080e7          	jalr	152(ra) # 5606 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3576:	85ca                	mv	a1,s2
    3578:	00004517          	auipc	a0,0x4
    357c:	ab850513          	addi	a0,a0,-1352 # 7030 <malloc+0x15e8>
    3580:	00002097          	auipc	ra,0x2
    3584:	410080e7          	jalr	1040(ra) # 5990 <printf>
    exit(1);
    3588:	4505                	li	a0,1
    358a:	00002097          	auipc	ra,0x2
    358e:	07c080e7          	jalr	124(ra) # 5606 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3592:	85ca                	mv	a1,s2
    3594:	00004517          	auipc	a0,0x4
    3598:	ab450513          	addi	a0,a0,-1356 # 7048 <malloc+0x1600>
    359c:	00002097          	auipc	ra,0x2
    35a0:	3f4080e7          	jalr	1012(ra) # 5990 <printf>
    exit(1);
    35a4:	4505                	li	a0,1
    35a6:	00002097          	auipc	ra,0x2
    35aa:	060080e7          	jalr	96(ra) # 5606 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35ae:	85ca                	mv	a1,s2
    35b0:	00004517          	auipc	a0,0x4
    35b4:	ab850513          	addi	a0,a0,-1352 # 7068 <malloc+0x1620>
    35b8:	00002097          	auipc	ra,0x2
    35bc:	3d8080e7          	jalr	984(ra) # 5990 <printf>
    exit(1);
    35c0:	4505                	li	a0,1
    35c2:	00002097          	auipc	ra,0x2
    35c6:	044080e7          	jalr	68(ra) # 5606 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35ca:	85ca                	mv	a1,s2
    35cc:	00004517          	auipc	a0,0x4
    35d0:	abc50513          	addi	a0,a0,-1348 # 7088 <malloc+0x1640>
    35d4:	00002097          	auipc	ra,0x2
    35d8:	3bc080e7          	jalr	956(ra) # 5990 <printf>
    exit(1);
    35dc:	4505                	li	a0,1
    35de:	00002097          	auipc	ra,0x2
    35e2:	028080e7          	jalr	40(ra) # 5606 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35e6:	85ca                	mv	a1,s2
    35e8:	00004517          	auipc	a0,0x4
    35ec:	ae050513          	addi	a0,a0,-1312 # 70c8 <malloc+0x1680>
    35f0:	00002097          	auipc	ra,0x2
    35f4:	3a0080e7          	jalr	928(ra) # 5990 <printf>
    exit(1);
    35f8:	4505                	li	a0,1
    35fa:	00002097          	auipc	ra,0x2
    35fe:	00c080e7          	jalr	12(ra) # 5606 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3602:	85ca                	mv	a1,s2
    3604:	00004517          	auipc	a0,0x4
    3608:	af450513          	addi	a0,a0,-1292 # 70f8 <malloc+0x16b0>
    360c:	00002097          	auipc	ra,0x2
    3610:	384080e7          	jalr	900(ra) # 5990 <printf>
    exit(1);
    3614:	4505                	li	a0,1
    3616:	00002097          	auipc	ra,0x2
    361a:	ff0080e7          	jalr	-16(ra) # 5606 <exit>
    printf("%s: create dd succeeded!\n", s);
    361e:	85ca                	mv	a1,s2
    3620:	00004517          	auipc	a0,0x4
    3624:	af850513          	addi	a0,a0,-1288 # 7118 <malloc+0x16d0>
    3628:	00002097          	auipc	ra,0x2
    362c:	368080e7          	jalr	872(ra) # 5990 <printf>
    exit(1);
    3630:	4505                	li	a0,1
    3632:	00002097          	auipc	ra,0x2
    3636:	fd4080e7          	jalr	-44(ra) # 5606 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    363a:	85ca                	mv	a1,s2
    363c:	00004517          	auipc	a0,0x4
    3640:	afc50513          	addi	a0,a0,-1284 # 7138 <malloc+0x16f0>
    3644:	00002097          	auipc	ra,0x2
    3648:	34c080e7          	jalr	844(ra) # 5990 <printf>
    exit(1);
    364c:	4505                	li	a0,1
    364e:	00002097          	auipc	ra,0x2
    3652:	fb8080e7          	jalr	-72(ra) # 5606 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3656:	85ca                	mv	a1,s2
    3658:	00004517          	auipc	a0,0x4
    365c:	b0050513          	addi	a0,a0,-1280 # 7158 <malloc+0x1710>
    3660:	00002097          	auipc	ra,0x2
    3664:	330080e7          	jalr	816(ra) # 5990 <printf>
    exit(1);
    3668:	4505                	li	a0,1
    366a:	00002097          	auipc	ra,0x2
    366e:	f9c080e7          	jalr	-100(ra) # 5606 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3672:	85ca                	mv	a1,s2
    3674:	00004517          	auipc	a0,0x4
    3678:	b1450513          	addi	a0,a0,-1260 # 7188 <malloc+0x1740>
    367c:	00002097          	auipc	ra,0x2
    3680:	314080e7          	jalr	788(ra) # 5990 <printf>
    exit(1);
    3684:	4505                	li	a0,1
    3686:	00002097          	auipc	ra,0x2
    368a:	f80080e7          	jalr	-128(ra) # 5606 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    368e:	85ca                	mv	a1,s2
    3690:	00004517          	auipc	a0,0x4
    3694:	b2050513          	addi	a0,a0,-1248 # 71b0 <malloc+0x1768>
    3698:	00002097          	auipc	ra,0x2
    369c:	2f8080e7          	jalr	760(ra) # 5990 <printf>
    exit(1);
    36a0:	4505                	li	a0,1
    36a2:	00002097          	auipc	ra,0x2
    36a6:	f64080e7          	jalr	-156(ra) # 5606 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36aa:	85ca                	mv	a1,s2
    36ac:	00004517          	auipc	a0,0x4
    36b0:	b2c50513          	addi	a0,a0,-1236 # 71d8 <malloc+0x1790>
    36b4:	00002097          	auipc	ra,0x2
    36b8:	2dc080e7          	jalr	732(ra) # 5990 <printf>
    exit(1);
    36bc:	4505                	li	a0,1
    36be:	00002097          	auipc	ra,0x2
    36c2:	f48080e7          	jalr	-184(ra) # 5606 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36c6:	85ca                	mv	a1,s2
    36c8:	00004517          	auipc	a0,0x4
    36cc:	b3850513          	addi	a0,a0,-1224 # 7200 <malloc+0x17b8>
    36d0:	00002097          	auipc	ra,0x2
    36d4:	2c0080e7          	jalr	704(ra) # 5990 <printf>
    exit(1);
    36d8:	4505                	li	a0,1
    36da:	00002097          	auipc	ra,0x2
    36de:	f2c080e7          	jalr	-212(ra) # 5606 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36e2:	85ca                	mv	a1,s2
    36e4:	00004517          	auipc	a0,0x4
    36e8:	b3c50513          	addi	a0,a0,-1220 # 7220 <malloc+0x17d8>
    36ec:	00002097          	auipc	ra,0x2
    36f0:	2a4080e7          	jalr	676(ra) # 5990 <printf>
    exit(1);
    36f4:	4505                	li	a0,1
    36f6:	00002097          	auipc	ra,0x2
    36fa:	f10080e7          	jalr	-240(ra) # 5606 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    36fe:	85ca                	mv	a1,s2
    3700:	00004517          	auipc	a0,0x4
    3704:	b4050513          	addi	a0,a0,-1216 # 7240 <malloc+0x17f8>
    3708:	00002097          	auipc	ra,0x2
    370c:	288080e7          	jalr	648(ra) # 5990 <printf>
    exit(1);
    3710:	4505                	li	a0,1
    3712:	00002097          	auipc	ra,0x2
    3716:	ef4080e7          	jalr	-268(ra) # 5606 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    371a:	85ca                	mv	a1,s2
    371c:	00004517          	auipc	a0,0x4
    3720:	b4c50513          	addi	a0,a0,-1204 # 7268 <malloc+0x1820>
    3724:	00002097          	auipc	ra,0x2
    3728:	26c080e7          	jalr	620(ra) # 5990 <printf>
    exit(1);
    372c:	4505                	li	a0,1
    372e:	00002097          	auipc	ra,0x2
    3732:	ed8080e7          	jalr	-296(ra) # 5606 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3736:	85ca                	mv	a1,s2
    3738:	00004517          	auipc	a0,0x4
    373c:	b5050513          	addi	a0,a0,-1200 # 7288 <malloc+0x1840>
    3740:	00002097          	auipc	ra,0x2
    3744:	250080e7          	jalr	592(ra) # 5990 <printf>
    exit(1);
    3748:	4505                	li	a0,1
    374a:	00002097          	auipc	ra,0x2
    374e:	ebc080e7          	jalr	-324(ra) # 5606 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3752:	85ca                	mv	a1,s2
    3754:	00004517          	auipc	a0,0x4
    3758:	b5450513          	addi	a0,a0,-1196 # 72a8 <malloc+0x1860>
    375c:	00002097          	auipc	ra,0x2
    3760:	234080e7          	jalr	564(ra) # 5990 <printf>
    exit(1);
    3764:	4505                	li	a0,1
    3766:	00002097          	auipc	ra,0x2
    376a:	ea0080e7          	jalr	-352(ra) # 5606 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    376e:	85ca                	mv	a1,s2
    3770:	00004517          	auipc	a0,0x4
    3774:	b6050513          	addi	a0,a0,-1184 # 72d0 <malloc+0x1888>
    3778:	00002097          	auipc	ra,0x2
    377c:	218080e7          	jalr	536(ra) # 5990 <printf>
    exit(1);
    3780:	4505                	li	a0,1
    3782:	00002097          	auipc	ra,0x2
    3786:	e84080e7          	jalr	-380(ra) # 5606 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    378a:	85ca                	mv	a1,s2
    378c:	00003517          	auipc	a0,0x3
    3790:	7dc50513          	addi	a0,a0,2012 # 6f68 <malloc+0x1520>
    3794:	00002097          	auipc	ra,0x2
    3798:	1fc080e7          	jalr	508(ra) # 5990 <printf>
    exit(1);
    379c:	4505                	li	a0,1
    379e:	00002097          	auipc	ra,0x2
    37a2:	e68080e7          	jalr	-408(ra) # 5606 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37a6:	85ca                	mv	a1,s2
    37a8:	00004517          	auipc	a0,0x4
    37ac:	b4850513          	addi	a0,a0,-1208 # 72f0 <malloc+0x18a8>
    37b0:	00002097          	auipc	ra,0x2
    37b4:	1e0080e7          	jalr	480(ra) # 5990 <printf>
    exit(1);
    37b8:	4505                	li	a0,1
    37ba:	00002097          	auipc	ra,0x2
    37be:	e4c080e7          	jalr	-436(ra) # 5606 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37c2:	85ca                	mv	a1,s2
    37c4:	00004517          	auipc	a0,0x4
    37c8:	b4c50513          	addi	a0,a0,-1204 # 7310 <malloc+0x18c8>
    37cc:	00002097          	auipc	ra,0x2
    37d0:	1c4080e7          	jalr	452(ra) # 5990 <printf>
    exit(1);
    37d4:	4505                	li	a0,1
    37d6:	00002097          	auipc	ra,0x2
    37da:	e30080e7          	jalr	-464(ra) # 5606 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37de:	85ca                	mv	a1,s2
    37e0:	00004517          	auipc	a0,0x4
    37e4:	b6050513          	addi	a0,a0,-1184 # 7340 <malloc+0x18f8>
    37e8:	00002097          	auipc	ra,0x2
    37ec:	1a8080e7          	jalr	424(ra) # 5990 <printf>
    exit(1);
    37f0:	4505                	li	a0,1
    37f2:	00002097          	auipc	ra,0x2
    37f6:	e14080e7          	jalr	-492(ra) # 5606 <exit>
    printf("%s: unlink dd failed\n", s);
    37fa:	85ca                	mv	a1,s2
    37fc:	00004517          	auipc	a0,0x4
    3800:	b6450513          	addi	a0,a0,-1180 # 7360 <malloc+0x1918>
    3804:	00002097          	auipc	ra,0x2
    3808:	18c080e7          	jalr	396(ra) # 5990 <printf>
    exit(1);
    380c:	4505                	li	a0,1
    380e:	00002097          	auipc	ra,0x2
    3812:	df8080e7          	jalr	-520(ra) # 5606 <exit>

0000000000003816 <rmdot>:
{
    3816:	1101                	addi	sp,sp,-32
    3818:	ec06                	sd	ra,24(sp)
    381a:	e822                	sd	s0,16(sp)
    381c:	e426                	sd	s1,8(sp)
    381e:	1000                	addi	s0,sp,32
    3820:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3822:	00004517          	auipc	a0,0x4
    3826:	b5650513          	addi	a0,a0,-1194 # 7378 <malloc+0x1930>
    382a:	00002097          	auipc	ra,0x2
    382e:	e44080e7          	jalr	-444(ra) # 566e <mkdir>
    3832:	e549                	bnez	a0,38bc <rmdot+0xa6>
  if(chdir("dots") != 0){
    3834:	00004517          	auipc	a0,0x4
    3838:	b4450513          	addi	a0,a0,-1212 # 7378 <malloc+0x1930>
    383c:	00002097          	auipc	ra,0x2
    3840:	e3a080e7          	jalr	-454(ra) # 5676 <chdir>
    3844:	e951                	bnez	a0,38d8 <rmdot+0xc2>
  if(unlink(".") == 0){
    3846:	00003517          	auipc	a0,0x3
    384a:	9da50513          	addi	a0,a0,-1574 # 6220 <malloc+0x7d8>
    384e:	00002097          	auipc	ra,0x2
    3852:	e08080e7          	jalr	-504(ra) # 5656 <unlink>
    3856:	cd59                	beqz	a0,38f4 <rmdot+0xde>
  if(unlink("..") == 0){
    3858:	00003517          	auipc	a0,0x3
    385c:	57850513          	addi	a0,a0,1400 # 6dd0 <malloc+0x1388>
    3860:	00002097          	auipc	ra,0x2
    3864:	df6080e7          	jalr	-522(ra) # 5656 <unlink>
    3868:	c545                	beqz	a0,3910 <rmdot+0xfa>
  if(chdir("/") != 0){
    386a:	00003517          	auipc	a0,0x3
    386e:	50e50513          	addi	a0,a0,1294 # 6d78 <malloc+0x1330>
    3872:	00002097          	auipc	ra,0x2
    3876:	e04080e7          	jalr	-508(ra) # 5676 <chdir>
    387a:	e94d                	bnez	a0,392c <rmdot+0x116>
  if(unlink("dots/.") == 0){
    387c:	00004517          	auipc	a0,0x4
    3880:	b6450513          	addi	a0,a0,-1180 # 73e0 <malloc+0x1998>
    3884:	00002097          	auipc	ra,0x2
    3888:	dd2080e7          	jalr	-558(ra) # 5656 <unlink>
    388c:	cd55                	beqz	a0,3948 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    388e:	00004517          	auipc	a0,0x4
    3892:	b7a50513          	addi	a0,a0,-1158 # 7408 <malloc+0x19c0>
    3896:	00002097          	auipc	ra,0x2
    389a:	dc0080e7          	jalr	-576(ra) # 5656 <unlink>
    389e:	c179                	beqz	a0,3964 <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a0:	00004517          	auipc	a0,0x4
    38a4:	ad850513          	addi	a0,a0,-1320 # 7378 <malloc+0x1930>
    38a8:	00002097          	auipc	ra,0x2
    38ac:	dae080e7          	jalr	-594(ra) # 5656 <unlink>
    38b0:	e961                	bnez	a0,3980 <rmdot+0x16a>
}
    38b2:	60e2                	ld	ra,24(sp)
    38b4:	6442                	ld	s0,16(sp)
    38b6:	64a2                	ld	s1,8(sp)
    38b8:	6105                	addi	sp,sp,32
    38ba:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38bc:	85a6                	mv	a1,s1
    38be:	00004517          	auipc	a0,0x4
    38c2:	ac250513          	addi	a0,a0,-1342 # 7380 <malloc+0x1938>
    38c6:	00002097          	auipc	ra,0x2
    38ca:	0ca080e7          	jalr	202(ra) # 5990 <printf>
    exit(1);
    38ce:	4505                	li	a0,1
    38d0:	00002097          	auipc	ra,0x2
    38d4:	d36080e7          	jalr	-714(ra) # 5606 <exit>
    printf("%s: chdir dots failed\n", s);
    38d8:	85a6                	mv	a1,s1
    38da:	00004517          	auipc	a0,0x4
    38de:	abe50513          	addi	a0,a0,-1346 # 7398 <malloc+0x1950>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	0ae080e7          	jalr	174(ra) # 5990 <printf>
    exit(1);
    38ea:	4505                	li	a0,1
    38ec:	00002097          	auipc	ra,0x2
    38f0:	d1a080e7          	jalr	-742(ra) # 5606 <exit>
    printf("%s: rm . worked!\n", s);
    38f4:	85a6                	mv	a1,s1
    38f6:	00004517          	auipc	a0,0x4
    38fa:	aba50513          	addi	a0,a0,-1350 # 73b0 <malloc+0x1968>
    38fe:	00002097          	auipc	ra,0x2
    3902:	092080e7          	jalr	146(ra) # 5990 <printf>
    exit(1);
    3906:	4505                	li	a0,1
    3908:	00002097          	auipc	ra,0x2
    390c:	cfe080e7          	jalr	-770(ra) # 5606 <exit>
    printf("%s: rm .. worked!\n", s);
    3910:	85a6                	mv	a1,s1
    3912:	00004517          	auipc	a0,0x4
    3916:	ab650513          	addi	a0,a0,-1354 # 73c8 <malloc+0x1980>
    391a:	00002097          	auipc	ra,0x2
    391e:	076080e7          	jalr	118(ra) # 5990 <printf>
    exit(1);
    3922:	4505                	li	a0,1
    3924:	00002097          	auipc	ra,0x2
    3928:	ce2080e7          	jalr	-798(ra) # 5606 <exit>
    printf("%s: chdir / failed\n", s);
    392c:	85a6                	mv	a1,s1
    392e:	00003517          	auipc	a0,0x3
    3932:	45250513          	addi	a0,a0,1106 # 6d80 <malloc+0x1338>
    3936:	00002097          	auipc	ra,0x2
    393a:	05a080e7          	jalr	90(ra) # 5990 <printf>
    exit(1);
    393e:	4505                	li	a0,1
    3940:	00002097          	auipc	ra,0x2
    3944:	cc6080e7          	jalr	-826(ra) # 5606 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3948:	85a6                	mv	a1,s1
    394a:	00004517          	auipc	a0,0x4
    394e:	a9e50513          	addi	a0,a0,-1378 # 73e8 <malloc+0x19a0>
    3952:	00002097          	auipc	ra,0x2
    3956:	03e080e7          	jalr	62(ra) # 5990 <printf>
    exit(1);
    395a:	4505                	li	a0,1
    395c:	00002097          	auipc	ra,0x2
    3960:	caa080e7          	jalr	-854(ra) # 5606 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3964:	85a6                	mv	a1,s1
    3966:	00004517          	auipc	a0,0x4
    396a:	aaa50513          	addi	a0,a0,-1366 # 7410 <malloc+0x19c8>
    396e:	00002097          	auipc	ra,0x2
    3972:	022080e7          	jalr	34(ra) # 5990 <printf>
    exit(1);
    3976:	4505                	li	a0,1
    3978:	00002097          	auipc	ra,0x2
    397c:	c8e080e7          	jalr	-882(ra) # 5606 <exit>
    printf("%s: unlink dots failed!\n", s);
    3980:	85a6                	mv	a1,s1
    3982:	00004517          	auipc	a0,0x4
    3986:	aae50513          	addi	a0,a0,-1362 # 7430 <malloc+0x19e8>
    398a:	00002097          	auipc	ra,0x2
    398e:	006080e7          	jalr	6(ra) # 5990 <printf>
    exit(1);
    3992:	4505                	li	a0,1
    3994:	00002097          	auipc	ra,0x2
    3998:	c72080e7          	jalr	-910(ra) # 5606 <exit>

000000000000399c <dirfile>:
{
    399c:	1101                	addi	sp,sp,-32
    399e:	ec06                	sd	ra,24(sp)
    39a0:	e822                	sd	s0,16(sp)
    39a2:	e426                	sd	s1,8(sp)
    39a4:	e04a                	sd	s2,0(sp)
    39a6:	1000                	addi	s0,sp,32
    39a8:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39aa:	20000593          	li	a1,512
    39ae:	00004517          	auipc	a0,0x4
    39b2:	aa250513          	addi	a0,a0,-1374 # 7450 <malloc+0x1a08>
    39b6:	00002097          	auipc	ra,0x2
    39ba:	c90080e7          	jalr	-880(ra) # 5646 <open>
  if(fd < 0){
    39be:	0e054d63          	bltz	a0,3ab8 <dirfile+0x11c>
  close(fd);
    39c2:	00002097          	auipc	ra,0x2
    39c6:	c6c080e7          	jalr	-916(ra) # 562e <close>
  if(chdir("dirfile") == 0){
    39ca:	00004517          	auipc	a0,0x4
    39ce:	a8650513          	addi	a0,a0,-1402 # 7450 <malloc+0x1a08>
    39d2:	00002097          	auipc	ra,0x2
    39d6:	ca4080e7          	jalr	-860(ra) # 5676 <chdir>
    39da:	cd6d                	beqz	a0,3ad4 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39dc:	4581                	li	a1,0
    39de:	00004517          	auipc	a0,0x4
    39e2:	aba50513          	addi	a0,a0,-1350 # 7498 <malloc+0x1a50>
    39e6:	00002097          	auipc	ra,0x2
    39ea:	c60080e7          	jalr	-928(ra) # 5646 <open>
  if(fd >= 0){
    39ee:	10055163          	bgez	a0,3af0 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39f2:	20000593          	li	a1,512
    39f6:	00004517          	auipc	a0,0x4
    39fa:	aa250513          	addi	a0,a0,-1374 # 7498 <malloc+0x1a50>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	c48080e7          	jalr	-952(ra) # 5646 <open>
  if(fd >= 0){
    3a06:	10055363          	bgez	a0,3b0c <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a0a:	00004517          	auipc	a0,0x4
    3a0e:	a8e50513          	addi	a0,a0,-1394 # 7498 <malloc+0x1a50>
    3a12:	00002097          	auipc	ra,0x2
    3a16:	c5c080e7          	jalr	-932(ra) # 566e <mkdir>
    3a1a:	10050763          	beqz	a0,3b28 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a1e:	00004517          	auipc	a0,0x4
    3a22:	a7a50513          	addi	a0,a0,-1414 # 7498 <malloc+0x1a50>
    3a26:	00002097          	auipc	ra,0x2
    3a2a:	c30080e7          	jalr	-976(ra) # 5656 <unlink>
    3a2e:	10050b63          	beqz	a0,3b44 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a32:	00004597          	auipc	a1,0x4
    3a36:	a6658593          	addi	a1,a1,-1434 # 7498 <malloc+0x1a50>
    3a3a:	00002517          	auipc	a0,0x2
    3a3e:	2d650513          	addi	a0,a0,726 # 5d10 <malloc+0x2c8>
    3a42:	00002097          	auipc	ra,0x2
    3a46:	c24080e7          	jalr	-988(ra) # 5666 <link>
    3a4a:	10050b63          	beqz	a0,3b60 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a4e:	00004517          	auipc	a0,0x4
    3a52:	a0250513          	addi	a0,a0,-1534 # 7450 <malloc+0x1a08>
    3a56:	00002097          	auipc	ra,0x2
    3a5a:	c00080e7          	jalr	-1024(ra) # 5656 <unlink>
    3a5e:	10051f63          	bnez	a0,3b7c <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a62:	4589                	li	a1,2
    3a64:	00002517          	auipc	a0,0x2
    3a68:	7bc50513          	addi	a0,a0,1980 # 6220 <malloc+0x7d8>
    3a6c:	00002097          	auipc	ra,0x2
    3a70:	bda080e7          	jalr	-1062(ra) # 5646 <open>
  if(fd >= 0){
    3a74:	12055263          	bgez	a0,3b98 <dirfile+0x1fc>
  fd = open(".", 0);
    3a78:	4581                	li	a1,0
    3a7a:	00002517          	auipc	a0,0x2
    3a7e:	7a650513          	addi	a0,a0,1958 # 6220 <malloc+0x7d8>
    3a82:	00002097          	auipc	ra,0x2
    3a86:	bc4080e7          	jalr	-1084(ra) # 5646 <open>
    3a8a:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a8c:	4605                	li	a2,1
    3a8e:	00002597          	auipc	a1,0x2
    3a92:	14a58593          	addi	a1,a1,330 # 5bd8 <malloc+0x190>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	b90080e7          	jalr	-1136(ra) # 5626 <write>
    3a9e:	10a04b63          	bgtz	a0,3bb4 <dirfile+0x218>
  close(fd);
    3aa2:	8526                	mv	a0,s1
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	b8a080e7          	jalr	-1142(ra) # 562e <close>
}
    3aac:	60e2                	ld	ra,24(sp)
    3aae:	6442                	ld	s0,16(sp)
    3ab0:	64a2                	ld	s1,8(sp)
    3ab2:	6902                	ld	s2,0(sp)
    3ab4:	6105                	addi	sp,sp,32
    3ab6:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3ab8:	85ca                	mv	a1,s2
    3aba:	00004517          	auipc	a0,0x4
    3abe:	99e50513          	addi	a0,a0,-1634 # 7458 <malloc+0x1a10>
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	ece080e7          	jalr	-306(ra) # 5990 <printf>
    exit(1);
    3aca:	4505                	li	a0,1
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	b3a080e7          	jalr	-1222(ra) # 5606 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3ad4:	85ca                	mv	a1,s2
    3ad6:	00004517          	auipc	a0,0x4
    3ada:	9a250513          	addi	a0,a0,-1630 # 7478 <malloc+0x1a30>
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	eb2080e7          	jalr	-334(ra) # 5990 <printf>
    exit(1);
    3ae6:	4505                	li	a0,1
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	b1e080e7          	jalr	-1250(ra) # 5606 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af0:	85ca                	mv	a1,s2
    3af2:	00004517          	auipc	a0,0x4
    3af6:	9b650513          	addi	a0,a0,-1610 # 74a8 <malloc+0x1a60>
    3afa:	00002097          	auipc	ra,0x2
    3afe:	e96080e7          	jalr	-362(ra) # 5990 <printf>
    exit(1);
    3b02:	4505                	li	a0,1
    3b04:	00002097          	auipc	ra,0x2
    3b08:	b02080e7          	jalr	-1278(ra) # 5606 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b0c:	85ca                	mv	a1,s2
    3b0e:	00004517          	auipc	a0,0x4
    3b12:	99a50513          	addi	a0,a0,-1638 # 74a8 <malloc+0x1a60>
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	e7a080e7          	jalr	-390(ra) # 5990 <printf>
    exit(1);
    3b1e:	4505                	li	a0,1
    3b20:	00002097          	auipc	ra,0x2
    3b24:	ae6080e7          	jalr	-1306(ra) # 5606 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b28:	85ca                	mv	a1,s2
    3b2a:	00004517          	auipc	a0,0x4
    3b2e:	9a650513          	addi	a0,a0,-1626 # 74d0 <malloc+0x1a88>
    3b32:	00002097          	auipc	ra,0x2
    3b36:	e5e080e7          	jalr	-418(ra) # 5990 <printf>
    exit(1);
    3b3a:	4505                	li	a0,1
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	aca080e7          	jalr	-1334(ra) # 5606 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b44:	85ca                	mv	a1,s2
    3b46:	00004517          	auipc	a0,0x4
    3b4a:	9b250513          	addi	a0,a0,-1614 # 74f8 <malloc+0x1ab0>
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	e42080e7          	jalr	-446(ra) # 5990 <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	aae080e7          	jalr	-1362(ra) # 5606 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b60:	85ca                	mv	a1,s2
    3b62:	00004517          	auipc	a0,0x4
    3b66:	9be50513          	addi	a0,a0,-1602 # 7520 <malloc+0x1ad8>
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	e26080e7          	jalr	-474(ra) # 5990 <printf>
    exit(1);
    3b72:	4505                	li	a0,1
    3b74:	00002097          	auipc	ra,0x2
    3b78:	a92080e7          	jalr	-1390(ra) # 5606 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b7c:	85ca                	mv	a1,s2
    3b7e:	00004517          	auipc	a0,0x4
    3b82:	9ca50513          	addi	a0,a0,-1590 # 7548 <malloc+0x1b00>
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	e0a080e7          	jalr	-502(ra) # 5990 <printf>
    exit(1);
    3b8e:	4505                	li	a0,1
    3b90:	00002097          	auipc	ra,0x2
    3b94:	a76080e7          	jalr	-1418(ra) # 5606 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3b98:	85ca                	mv	a1,s2
    3b9a:	00004517          	auipc	a0,0x4
    3b9e:	9ce50513          	addi	a0,a0,-1586 # 7568 <malloc+0x1b20>
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	dee080e7          	jalr	-530(ra) # 5990 <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	a5a080e7          	jalr	-1446(ra) # 5606 <exit>
    printf("%s: write . succeeded!\n", s);
    3bb4:	85ca                	mv	a1,s2
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	9da50513          	addi	a0,a0,-1574 # 7590 <malloc+0x1b48>
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	dd2080e7          	jalr	-558(ra) # 5990 <printf>
    exit(1);
    3bc6:	4505                	li	a0,1
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	a3e080e7          	jalr	-1474(ra) # 5606 <exit>

0000000000003bd0 <iref>:
{
    3bd0:	7139                	addi	sp,sp,-64
    3bd2:	fc06                	sd	ra,56(sp)
    3bd4:	f822                	sd	s0,48(sp)
    3bd6:	f426                	sd	s1,40(sp)
    3bd8:	f04a                	sd	s2,32(sp)
    3bda:	ec4e                	sd	s3,24(sp)
    3bdc:	e852                	sd	s4,16(sp)
    3bde:	e456                	sd	s5,8(sp)
    3be0:	e05a                	sd	s6,0(sp)
    3be2:	0080                	addi	s0,sp,64
    3be4:	8b2a                	mv	s6,a0
    3be6:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bea:	00004a17          	auipc	s4,0x4
    3bee:	9bea0a13          	addi	s4,s4,-1602 # 75a8 <malloc+0x1b60>
    mkdir("");
    3bf2:	00003497          	auipc	s1,0x3
    3bf6:	4be48493          	addi	s1,s1,1214 # 70b0 <malloc+0x1668>
    link("README", "");
    3bfa:	00002a97          	auipc	s5,0x2
    3bfe:	116a8a93          	addi	s5,s5,278 # 5d10 <malloc+0x2c8>
    fd = open("xx", O_CREATE);
    3c02:	00004997          	auipc	s3,0x4
    3c06:	89e98993          	addi	s3,s3,-1890 # 74a0 <malloc+0x1a58>
    3c0a:	a891                	j	3c5e <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c0c:	85da                	mv	a1,s6
    3c0e:	00004517          	auipc	a0,0x4
    3c12:	9a250513          	addi	a0,a0,-1630 # 75b0 <malloc+0x1b68>
    3c16:	00002097          	auipc	ra,0x2
    3c1a:	d7a080e7          	jalr	-646(ra) # 5990 <printf>
      exit(1);
    3c1e:	4505                	li	a0,1
    3c20:	00002097          	auipc	ra,0x2
    3c24:	9e6080e7          	jalr	-1562(ra) # 5606 <exit>
      printf("%s: chdir irefd failed\n", s);
    3c28:	85da                	mv	a1,s6
    3c2a:	00004517          	auipc	a0,0x4
    3c2e:	99e50513          	addi	a0,a0,-1634 # 75c8 <malloc+0x1b80>
    3c32:	00002097          	auipc	ra,0x2
    3c36:	d5e080e7          	jalr	-674(ra) # 5990 <printf>
      exit(1);
    3c3a:	4505                	li	a0,1
    3c3c:	00002097          	auipc	ra,0x2
    3c40:	9ca080e7          	jalr	-1590(ra) # 5606 <exit>
      close(fd);
    3c44:	00002097          	auipc	ra,0x2
    3c48:	9ea080e7          	jalr	-1558(ra) # 562e <close>
    3c4c:	a889                	j	3c9e <iref+0xce>
    unlink("xx");
    3c4e:	854e                	mv	a0,s3
    3c50:	00002097          	auipc	ra,0x2
    3c54:	a06080e7          	jalr	-1530(ra) # 5656 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c58:	397d                	addiw	s2,s2,-1
    3c5a:	06090063          	beqz	s2,3cba <iref+0xea>
    if(mkdir("irefd") != 0){
    3c5e:	8552                	mv	a0,s4
    3c60:	00002097          	auipc	ra,0x2
    3c64:	a0e080e7          	jalr	-1522(ra) # 566e <mkdir>
    3c68:	f155                	bnez	a0,3c0c <iref+0x3c>
    if(chdir("irefd") != 0){
    3c6a:	8552                	mv	a0,s4
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	a0a080e7          	jalr	-1526(ra) # 5676 <chdir>
    3c74:	f955                	bnez	a0,3c28 <iref+0x58>
    mkdir("");
    3c76:	8526                	mv	a0,s1
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	9f6080e7          	jalr	-1546(ra) # 566e <mkdir>
    link("README", "");
    3c80:	85a6                	mv	a1,s1
    3c82:	8556                	mv	a0,s5
    3c84:	00002097          	auipc	ra,0x2
    3c88:	9e2080e7          	jalr	-1566(ra) # 5666 <link>
    fd = open("", O_CREATE);
    3c8c:	20000593          	li	a1,512
    3c90:	8526                	mv	a0,s1
    3c92:	00002097          	auipc	ra,0x2
    3c96:	9b4080e7          	jalr	-1612(ra) # 5646 <open>
    if(fd >= 0)
    3c9a:	fa0555e3          	bgez	a0,3c44 <iref+0x74>
    fd = open("xx", O_CREATE);
    3c9e:	20000593          	li	a1,512
    3ca2:	854e                	mv	a0,s3
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	9a2080e7          	jalr	-1630(ra) # 5646 <open>
    if(fd >= 0)
    3cac:	fa0541e3          	bltz	a0,3c4e <iref+0x7e>
      close(fd);
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	97e080e7          	jalr	-1666(ra) # 562e <close>
    3cb8:	bf59                	j	3c4e <iref+0x7e>
    3cba:	03300493          	li	s1,51
    chdir("..");
    3cbe:	00003997          	auipc	s3,0x3
    3cc2:	11298993          	addi	s3,s3,274 # 6dd0 <malloc+0x1388>
    unlink("irefd");
    3cc6:	00004917          	auipc	s2,0x4
    3cca:	8e290913          	addi	s2,s2,-1822 # 75a8 <malloc+0x1b60>
    chdir("..");
    3cce:	854e                	mv	a0,s3
    3cd0:	00002097          	auipc	ra,0x2
    3cd4:	9a6080e7          	jalr	-1626(ra) # 5676 <chdir>
    unlink("irefd");
    3cd8:	854a                	mv	a0,s2
    3cda:	00002097          	auipc	ra,0x2
    3cde:	97c080e7          	jalr	-1668(ra) # 5656 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ce2:	34fd                	addiw	s1,s1,-1
    3ce4:	f4ed                	bnez	s1,3cce <iref+0xfe>
  chdir("/");
    3ce6:	00003517          	auipc	a0,0x3
    3cea:	09250513          	addi	a0,a0,146 # 6d78 <malloc+0x1330>
    3cee:	00002097          	auipc	ra,0x2
    3cf2:	988080e7          	jalr	-1656(ra) # 5676 <chdir>
}
    3cf6:	70e2                	ld	ra,56(sp)
    3cf8:	7442                	ld	s0,48(sp)
    3cfa:	74a2                	ld	s1,40(sp)
    3cfc:	7902                	ld	s2,32(sp)
    3cfe:	69e2                	ld	s3,24(sp)
    3d00:	6a42                	ld	s4,16(sp)
    3d02:	6aa2                	ld	s5,8(sp)
    3d04:	6b02                	ld	s6,0(sp)
    3d06:	6121                	addi	sp,sp,64
    3d08:	8082                	ret

0000000000003d0a <openiputtest>:
{
    3d0a:	7179                	addi	sp,sp,-48
    3d0c:	f406                	sd	ra,40(sp)
    3d0e:	f022                	sd	s0,32(sp)
    3d10:	ec26                	sd	s1,24(sp)
    3d12:	1800                	addi	s0,sp,48
    3d14:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d16:	00004517          	auipc	a0,0x4
    3d1a:	8ca50513          	addi	a0,a0,-1846 # 75e0 <malloc+0x1b98>
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	950080e7          	jalr	-1712(ra) # 566e <mkdir>
    3d26:	04054263          	bltz	a0,3d6a <openiputtest+0x60>
  pid = fork();
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	8d4080e7          	jalr	-1836(ra) # 55fe <fork>
  if(pid < 0){
    3d32:	04054a63          	bltz	a0,3d86 <openiputtest+0x7c>
  if(pid == 0){
    3d36:	e93d                	bnez	a0,3dac <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d38:	4589                	li	a1,2
    3d3a:	00004517          	auipc	a0,0x4
    3d3e:	8a650513          	addi	a0,a0,-1882 # 75e0 <malloc+0x1b98>
    3d42:	00002097          	auipc	ra,0x2
    3d46:	904080e7          	jalr	-1788(ra) # 5646 <open>
    if(fd >= 0){
    3d4a:	04054c63          	bltz	a0,3da2 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d4e:	85a6                	mv	a1,s1
    3d50:	00004517          	auipc	a0,0x4
    3d54:	8b050513          	addi	a0,a0,-1872 # 7600 <malloc+0x1bb8>
    3d58:	00002097          	auipc	ra,0x2
    3d5c:	c38080e7          	jalr	-968(ra) # 5990 <printf>
      exit(1);
    3d60:	4505                	li	a0,1
    3d62:	00002097          	auipc	ra,0x2
    3d66:	8a4080e7          	jalr	-1884(ra) # 5606 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d6a:	85a6                	mv	a1,s1
    3d6c:	00004517          	auipc	a0,0x4
    3d70:	87c50513          	addi	a0,a0,-1924 # 75e8 <malloc+0x1ba0>
    3d74:	00002097          	auipc	ra,0x2
    3d78:	c1c080e7          	jalr	-996(ra) # 5990 <printf>
    exit(1);
    3d7c:	4505                	li	a0,1
    3d7e:	00002097          	auipc	ra,0x2
    3d82:	888080e7          	jalr	-1912(ra) # 5606 <exit>
    printf("%s: fork failed\n", s);
    3d86:	85a6                	mv	a1,s1
    3d88:	00002517          	auipc	a0,0x2
    3d8c:	63850513          	addi	a0,a0,1592 # 63c0 <malloc+0x978>
    3d90:	00002097          	auipc	ra,0x2
    3d94:	c00080e7          	jalr	-1024(ra) # 5990 <printf>
    exit(1);
    3d98:	4505                	li	a0,1
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	86c080e7          	jalr	-1940(ra) # 5606 <exit>
    exit(0);
    3da2:	4501                	li	a0,0
    3da4:	00002097          	auipc	ra,0x2
    3da8:	862080e7          	jalr	-1950(ra) # 5606 <exit>
  sleep(1);
    3dac:	4505                	li	a0,1
    3dae:	00002097          	auipc	ra,0x2
    3db2:	8e8080e7          	jalr	-1816(ra) # 5696 <sleep>
  if(unlink("oidir") != 0){
    3db6:	00004517          	auipc	a0,0x4
    3dba:	82a50513          	addi	a0,a0,-2006 # 75e0 <malloc+0x1b98>
    3dbe:	00002097          	auipc	ra,0x2
    3dc2:	898080e7          	jalr	-1896(ra) # 5656 <unlink>
    3dc6:	cd19                	beqz	a0,3de4 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dc8:	85a6                	mv	a1,s1
    3dca:	00002517          	auipc	a0,0x2
    3dce:	7e650513          	addi	a0,a0,2022 # 65b0 <malloc+0xb68>
    3dd2:	00002097          	auipc	ra,0x2
    3dd6:	bbe080e7          	jalr	-1090(ra) # 5990 <printf>
    exit(1);
    3dda:	4505                	li	a0,1
    3ddc:	00002097          	auipc	ra,0x2
    3de0:	82a080e7          	jalr	-2006(ra) # 5606 <exit>
  wait(&xstatus);
    3de4:	fdc40513          	addi	a0,s0,-36
    3de8:	00002097          	auipc	ra,0x2
    3dec:	826080e7          	jalr	-2010(ra) # 560e <wait>
  exit(xstatus);
    3df0:	fdc42503          	lw	a0,-36(s0)
    3df4:	00002097          	auipc	ra,0x2
    3df8:	812080e7          	jalr	-2030(ra) # 5606 <exit>

0000000000003dfc <forkforkfork>:
{
    3dfc:	1101                	addi	sp,sp,-32
    3dfe:	ec06                	sd	ra,24(sp)
    3e00:	e822                	sd	s0,16(sp)
    3e02:	e426                	sd	s1,8(sp)
    3e04:	1000                	addi	s0,sp,32
    3e06:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e08:	00004517          	auipc	a0,0x4
    3e0c:	82050513          	addi	a0,a0,-2016 # 7628 <malloc+0x1be0>
    3e10:	00002097          	auipc	ra,0x2
    3e14:	846080e7          	jalr	-1978(ra) # 5656 <unlink>
  int pid = fork();
    3e18:	00001097          	auipc	ra,0x1
    3e1c:	7e6080e7          	jalr	2022(ra) # 55fe <fork>
  if(pid < 0){
    3e20:	04054563          	bltz	a0,3e6a <forkforkfork+0x6e>
  if(pid == 0){
    3e24:	c12d                	beqz	a0,3e86 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e26:	4551                	li	a0,20
    3e28:	00002097          	auipc	ra,0x2
    3e2c:	86e080e7          	jalr	-1938(ra) # 5696 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e30:	20200593          	li	a1,514
    3e34:	00003517          	auipc	a0,0x3
    3e38:	7f450513          	addi	a0,a0,2036 # 7628 <malloc+0x1be0>
    3e3c:	00002097          	auipc	ra,0x2
    3e40:	80a080e7          	jalr	-2038(ra) # 5646 <open>
    3e44:	00001097          	auipc	ra,0x1
    3e48:	7ea080e7          	jalr	2026(ra) # 562e <close>
  wait(0);
    3e4c:	4501                	li	a0,0
    3e4e:	00001097          	auipc	ra,0x1
    3e52:	7c0080e7          	jalr	1984(ra) # 560e <wait>
  sleep(10); // one second
    3e56:	4529                	li	a0,10
    3e58:	00002097          	auipc	ra,0x2
    3e5c:	83e080e7          	jalr	-1986(ra) # 5696 <sleep>
}
    3e60:	60e2                	ld	ra,24(sp)
    3e62:	6442                	ld	s0,16(sp)
    3e64:	64a2                	ld	s1,8(sp)
    3e66:	6105                	addi	sp,sp,32
    3e68:	8082                	ret
    printf("%s: fork failed", s);
    3e6a:	85a6                	mv	a1,s1
    3e6c:	00002517          	auipc	a0,0x2
    3e70:	71450513          	addi	a0,a0,1812 # 6580 <malloc+0xb38>
    3e74:	00002097          	auipc	ra,0x2
    3e78:	b1c080e7          	jalr	-1252(ra) # 5990 <printf>
    exit(1);
    3e7c:	4505                	li	a0,1
    3e7e:	00001097          	auipc	ra,0x1
    3e82:	788080e7          	jalr	1928(ra) # 5606 <exit>
      int fd = open("stopforking", 0);
    3e86:	00003497          	auipc	s1,0x3
    3e8a:	7a248493          	addi	s1,s1,1954 # 7628 <malloc+0x1be0>
    3e8e:	4581                	li	a1,0
    3e90:	8526                	mv	a0,s1
    3e92:	00001097          	auipc	ra,0x1
    3e96:	7b4080e7          	jalr	1972(ra) # 5646 <open>
      if(fd >= 0){
    3e9a:	02055463          	bgez	a0,3ec2 <forkforkfork+0xc6>
      if(fork() < 0){
    3e9e:	00001097          	auipc	ra,0x1
    3ea2:	760080e7          	jalr	1888(ra) # 55fe <fork>
    3ea6:	fe0554e3          	bgez	a0,3e8e <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eaa:	20200593          	li	a1,514
    3eae:	8526                	mv	a0,s1
    3eb0:	00001097          	auipc	ra,0x1
    3eb4:	796080e7          	jalr	1942(ra) # 5646 <open>
    3eb8:	00001097          	auipc	ra,0x1
    3ebc:	776080e7          	jalr	1910(ra) # 562e <close>
    3ec0:	b7f9                	j	3e8e <forkforkfork+0x92>
        exit(0);
    3ec2:	4501                	li	a0,0
    3ec4:	00001097          	auipc	ra,0x1
    3ec8:	742080e7          	jalr	1858(ra) # 5606 <exit>

0000000000003ecc <preempt>:
{
    3ecc:	7139                	addi	sp,sp,-64
    3ece:	fc06                	sd	ra,56(sp)
    3ed0:	f822                	sd	s0,48(sp)
    3ed2:	f426                	sd	s1,40(sp)
    3ed4:	f04a                	sd	s2,32(sp)
    3ed6:	ec4e                	sd	s3,24(sp)
    3ed8:	e852                	sd	s4,16(sp)
    3eda:	0080                	addi	s0,sp,64
    3edc:	892a                	mv	s2,a0
  pid1 = fork();
    3ede:	00001097          	auipc	ra,0x1
    3ee2:	720080e7          	jalr	1824(ra) # 55fe <fork>
  if(pid1 < 0) {
    3ee6:	00054563          	bltz	a0,3ef0 <preempt+0x24>
    3eea:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3eec:	e105                	bnez	a0,3f0c <preempt+0x40>
    for(;;)
    3eee:	a001                	j	3eee <preempt+0x22>
    printf("%s: fork failed", s);
    3ef0:	85ca                	mv	a1,s2
    3ef2:	00002517          	auipc	a0,0x2
    3ef6:	68e50513          	addi	a0,a0,1678 # 6580 <malloc+0xb38>
    3efa:	00002097          	auipc	ra,0x2
    3efe:	a96080e7          	jalr	-1386(ra) # 5990 <printf>
    exit(1);
    3f02:	4505                	li	a0,1
    3f04:	00001097          	auipc	ra,0x1
    3f08:	702080e7          	jalr	1794(ra) # 5606 <exit>
  pid2 = fork();
    3f0c:	00001097          	auipc	ra,0x1
    3f10:	6f2080e7          	jalr	1778(ra) # 55fe <fork>
    3f14:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3f16:	00054463          	bltz	a0,3f1e <preempt+0x52>
  if(pid2 == 0)
    3f1a:	e105                	bnez	a0,3f3a <preempt+0x6e>
    for(;;)
    3f1c:	a001                	j	3f1c <preempt+0x50>
    printf("%s: fork failed\n", s);
    3f1e:	85ca                	mv	a1,s2
    3f20:	00002517          	auipc	a0,0x2
    3f24:	4a050513          	addi	a0,a0,1184 # 63c0 <malloc+0x978>
    3f28:	00002097          	auipc	ra,0x2
    3f2c:	a68080e7          	jalr	-1432(ra) # 5990 <printf>
    exit(1);
    3f30:	4505                	li	a0,1
    3f32:	00001097          	auipc	ra,0x1
    3f36:	6d4080e7          	jalr	1748(ra) # 5606 <exit>
  pipe(pfds);
    3f3a:	fc840513          	addi	a0,s0,-56
    3f3e:	00001097          	auipc	ra,0x1
    3f42:	6d8080e7          	jalr	1752(ra) # 5616 <pipe>
  pid3 = fork();
    3f46:	00001097          	auipc	ra,0x1
    3f4a:	6b8080e7          	jalr	1720(ra) # 55fe <fork>
    3f4e:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3f50:	02054e63          	bltz	a0,3f8c <preempt+0xc0>
  if(pid3 == 0){
    3f54:	e525                	bnez	a0,3fbc <preempt+0xf0>
    close(pfds[0]);
    3f56:	fc842503          	lw	a0,-56(s0)
    3f5a:	00001097          	auipc	ra,0x1
    3f5e:	6d4080e7          	jalr	1748(ra) # 562e <close>
    if(write(pfds[1], "x", 1) != 1)
    3f62:	4605                	li	a2,1
    3f64:	00002597          	auipc	a1,0x2
    3f68:	c7458593          	addi	a1,a1,-908 # 5bd8 <malloc+0x190>
    3f6c:	fcc42503          	lw	a0,-52(s0)
    3f70:	00001097          	auipc	ra,0x1
    3f74:	6b6080e7          	jalr	1718(ra) # 5626 <write>
    3f78:	4785                	li	a5,1
    3f7a:	02f51763          	bne	a0,a5,3fa8 <preempt+0xdc>
    close(pfds[1]);
    3f7e:	fcc42503          	lw	a0,-52(s0)
    3f82:	00001097          	auipc	ra,0x1
    3f86:	6ac080e7          	jalr	1708(ra) # 562e <close>
    for(;;)
    3f8a:	a001                	j	3f8a <preempt+0xbe>
     printf("%s: fork failed\n", s);
    3f8c:	85ca                	mv	a1,s2
    3f8e:	00002517          	auipc	a0,0x2
    3f92:	43250513          	addi	a0,a0,1074 # 63c0 <malloc+0x978>
    3f96:	00002097          	auipc	ra,0x2
    3f9a:	9fa080e7          	jalr	-1542(ra) # 5990 <printf>
     exit(1);
    3f9e:	4505                	li	a0,1
    3fa0:	00001097          	auipc	ra,0x1
    3fa4:	666080e7          	jalr	1638(ra) # 5606 <exit>
      printf("%s: preempt write error", s);
    3fa8:	85ca                	mv	a1,s2
    3faa:	00003517          	auipc	a0,0x3
    3fae:	68e50513          	addi	a0,a0,1678 # 7638 <malloc+0x1bf0>
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	9de080e7          	jalr	-1570(ra) # 5990 <printf>
    3fba:	b7d1                	j	3f7e <preempt+0xb2>
  close(pfds[1]);
    3fbc:	fcc42503          	lw	a0,-52(s0)
    3fc0:	00001097          	auipc	ra,0x1
    3fc4:	66e080e7          	jalr	1646(ra) # 562e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3fc8:	660d                	lui	a2,0x3
    3fca:	00008597          	auipc	a1,0x8
    3fce:	b2e58593          	addi	a1,a1,-1234 # baf8 <buf>
    3fd2:	fc842503          	lw	a0,-56(s0)
    3fd6:	00001097          	auipc	ra,0x1
    3fda:	648080e7          	jalr	1608(ra) # 561e <read>
    3fde:	4785                	li	a5,1
    3fe0:	02f50363          	beq	a0,a5,4006 <preempt+0x13a>
    printf("%s: preempt read error", s);
    3fe4:	85ca                	mv	a1,s2
    3fe6:	00003517          	auipc	a0,0x3
    3fea:	66a50513          	addi	a0,a0,1642 # 7650 <malloc+0x1c08>
    3fee:	00002097          	auipc	ra,0x2
    3ff2:	9a2080e7          	jalr	-1630(ra) # 5990 <printf>
}
    3ff6:	70e2                	ld	ra,56(sp)
    3ff8:	7442                	ld	s0,48(sp)
    3ffa:	74a2                	ld	s1,40(sp)
    3ffc:	7902                	ld	s2,32(sp)
    3ffe:	69e2                	ld	s3,24(sp)
    4000:	6a42                	ld	s4,16(sp)
    4002:	6121                	addi	sp,sp,64
    4004:	8082                	ret
  close(pfds[0]);
    4006:	fc842503          	lw	a0,-56(s0)
    400a:	00001097          	auipc	ra,0x1
    400e:	624080e7          	jalr	1572(ra) # 562e <close>
  printf("kill... ");
    4012:	00003517          	auipc	a0,0x3
    4016:	65650513          	addi	a0,a0,1622 # 7668 <malloc+0x1c20>
    401a:	00002097          	auipc	ra,0x2
    401e:	976080e7          	jalr	-1674(ra) # 5990 <printf>
  kill(pid1);
    4022:	8526                	mv	a0,s1
    4024:	00001097          	auipc	ra,0x1
    4028:	612080e7          	jalr	1554(ra) # 5636 <kill>
  kill(pid2);
    402c:	854e                	mv	a0,s3
    402e:	00001097          	auipc	ra,0x1
    4032:	608080e7          	jalr	1544(ra) # 5636 <kill>
  kill(pid3);
    4036:	8552                	mv	a0,s4
    4038:	00001097          	auipc	ra,0x1
    403c:	5fe080e7          	jalr	1534(ra) # 5636 <kill>
  printf("wait... ");
    4040:	00003517          	auipc	a0,0x3
    4044:	63850513          	addi	a0,a0,1592 # 7678 <malloc+0x1c30>
    4048:	00002097          	auipc	ra,0x2
    404c:	948080e7          	jalr	-1720(ra) # 5990 <printf>
  wait(0);
    4050:	4501                	li	a0,0
    4052:	00001097          	auipc	ra,0x1
    4056:	5bc080e7          	jalr	1468(ra) # 560e <wait>
  wait(0);
    405a:	4501                	li	a0,0
    405c:	00001097          	auipc	ra,0x1
    4060:	5b2080e7          	jalr	1458(ra) # 560e <wait>
  wait(0);
    4064:	4501                	li	a0,0
    4066:	00001097          	auipc	ra,0x1
    406a:	5a8080e7          	jalr	1448(ra) # 560e <wait>
    406e:	b761                	j	3ff6 <preempt+0x12a>

0000000000004070 <sbrkfail>:
{
    4070:	7119                	addi	sp,sp,-128
    4072:	fc86                	sd	ra,120(sp)
    4074:	f8a2                	sd	s0,112(sp)
    4076:	f4a6                	sd	s1,104(sp)
    4078:	f0ca                	sd	s2,96(sp)
    407a:	ecce                	sd	s3,88(sp)
    407c:	e8d2                	sd	s4,80(sp)
    407e:	e4d6                	sd	s5,72(sp)
    4080:	0100                	addi	s0,sp,128
    4082:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4084:	fb040513          	addi	a0,s0,-80
    4088:	00001097          	auipc	ra,0x1
    408c:	58e080e7          	jalr	1422(ra) # 5616 <pipe>
    4090:	e901                	bnez	a0,40a0 <sbrkfail+0x30>
    4092:	f8040493          	addi	s1,s0,-128
    4096:	fa840993          	addi	s3,s0,-88
    409a:	8926                	mv	s2,s1
    if(pids[i] != -1)
    409c:	5a7d                	li	s4,-1
    409e:	a085                	j	40fe <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    40a0:	85d6                	mv	a1,s5
    40a2:	00002517          	auipc	a0,0x2
    40a6:	42650513          	addi	a0,a0,1062 # 64c8 <malloc+0xa80>
    40aa:	00002097          	auipc	ra,0x2
    40ae:	8e6080e7          	jalr	-1818(ra) # 5990 <printf>
    exit(1);
    40b2:	4505                	li	a0,1
    40b4:	00001097          	auipc	ra,0x1
    40b8:	552080e7          	jalr	1362(ra) # 5606 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    40bc:	00001097          	auipc	ra,0x1
    40c0:	5d2080e7          	jalr	1490(ra) # 568e <sbrk>
    40c4:	064007b7          	lui	a5,0x6400
    40c8:	40a7853b          	subw	a0,a5,a0
    40cc:	00001097          	auipc	ra,0x1
    40d0:	5c2080e7          	jalr	1474(ra) # 568e <sbrk>
      write(fds[1], "x", 1);
    40d4:	4605                	li	a2,1
    40d6:	00002597          	auipc	a1,0x2
    40da:	b0258593          	addi	a1,a1,-1278 # 5bd8 <malloc+0x190>
    40de:	fb442503          	lw	a0,-76(s0)
    40e2:	00001097          	auipc	ra,0x1
    40e6:	544080e7          	jalr	1348(ra) # 5626 <write>
      for(;;) sleep(1000);
    40ea:	3e800513          	li	a0,1000
    40ee:	00001097          	auipc	ra,0x1
    40f2:	5a8080e7          	jalr	1448(ra) # 5696 <sleep>
    40f6:	bfd5                	j	40ea <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    40f8:	0911                	addi	s2,s2,4
    40fa:	03390563          	beq	s2,s3,4124 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    40fe:	00001097          	auipc	ra,0x1
    4102:	500080e7          	jalr	1280(ra) # 55fe <fork>
    4106:	00a92023          	sw	a0,0(s2)
    410a:	d94d                	beqz	a0,40bc <sbrkfail+0x4c>
    if(pids[i] != -1)
    410c:	ff4506e3          	beq	a0,s4,40f8 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4110:	4605                	li	a2,1
    4112:	faf40593          	addi	a1,s0,-81
    4116:	fb042503          	lw	a0,-80(s0)
    411a:	00001097          	auipc	ra,0x1
    411e:	504080e7          	jalr	1284(ra) # 561e <read>
    4122:	bfd9                	j	40f8 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4124:	6505                	lui	a0,0x1
    4126:	00001097          	auipc	ra,0x1
    412a:	568080e7          	jalr	1384(ra) # 568e <sbrk>
    412e:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4130:	597d                	li	s2,-1
    4132:	a021                	j	413a <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4134:	0491                	addi	s1,s1,4
    4136:	01348f63          	beq	s1,s3,4154 <sbrkfail+0xe4>
    if(pids[i] == -1)
    413a:	4088                	lw	a0,0(s1)
    413c:	ff250ce3          	beq	a0,s2,4134 <sbrkfail+0xc4>
    kill(pids[i]);
    4140:	00001097          	auipc	ra,0x1
    4144:	4f6080e7          	jalr	1270(ra) # 5636 <kill>
    wait(0);
    4148:	4501                	li	a0,0
    414a:	00001097          	auipc	ra,0x1
    414e:	4c4080e7          	jalr	1220(ra) # 560e <wait>
    4152:	b7cd                	j	4134 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4154:	57fd                	li	a5,-1
    4156:	04fa0163          	beq	s4,a5,4198 <sbrkfail+0x128>
  pid = fork();
    415a:	00001097          	auipc	ra,0x1
    415e:	4a4080e7          	jalr	1188(ra) # 55fe <fork>
    4162:	84aa                	mv	s1,a0
  if(pid < 0){
    4164:	04054863          	bltz	a0,41b4 <sbrkfail+0x144>
  if(pid == 0){
    4168:	c525                	beqz	a0,41d0 <sbrkfail+0x160>
  wait(&xstatus);
    416a:	fbc40513          	addi	a0,s0,-68
    416e:	00001097          	auipc	ra,0x1
    4172:	4a0080e7          	jalr	1184(ra) # 560e <wait>
  if(xstatus != -1 && xstatus != 2)
    4176:	fbc42783          	lw	a5,-68(s0)
    417a:	577d                	li	a4,-1
    417c:	00e78563          	beq	a5,a4,4186 <sbrkfail+0x116>
    4180:	4709                	li	a4,2
    4182:	08e79d63          	bne	a5,a4,421c <sbrkfail+0x1ac>
}
    4186:	70e6                	ld	ra,120(sp)
    4188:	7446                	ld	s0,112(sp)
    418a:	74a6                	ld	s1,104(sp)
    418c:	7906                	ld	s2,96(sp)
    418e:	69e6                	ld	s3,88(sp)
    4190:	6a46                	ld	s4,80(sp)
    4192:	6aa6                	ld	s5,72(sp)
    4194:	6109                	addi	sp,sp,128
    4196:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4198:	85d6                	mv	a1,s5
    419a:	00003517          	auipc	a0,0x3
    419e:	4ee50513          	addi	a0,a0,1262 # 7688 <malloc+0x1c40>
    41a2:	00001097          	auipc	ra,0x1
    41a6:	7ee080e7          	jalr	2030(ra) # 5990 <printf>
    exit(1);
    41aa:	4505                	li	a0,1
    41ac:	00001097          	auipc	ra,0x1
    41b0:	45a080e7          	jalr	1114(ra) # 5606 <exit>
    printf("%s: fork failed\n", s);
    41b4:	85d6                	mv	a1,s5
    41b6:	00002517          	auipc	a0,0x2
    41ba:	20a50513          	addi	a0,a0,522 # 63c0 <malloc+0x978>
    41be:	00001097          	auipc	ra,0x1
    41c2:	7d2080e7          	jalr	2002(ra) # 5990 <printf>
    exit(1);
    41c6:	4505                	li	a0,1
    41c8:	00001097          	auipc	ra,0x1
    41cc:	43e080e7          	jalr	1086(ra) # 5606 <exit>
    a = sbrk(0);
    41d0:	4501                	li	a0,0
    41d2:	00001097          	auipc	ra,0x1
    41d6:	4bc080e7          	jalr	1212(ra) # 568e <sbrk>
    41da:	892a                	mv	s2,a0
    sbrk(10*BIG);
    41dc:	3e800537          	lui	a0,0x3e800
    41e0:	00001097          	auipc	ra,0x1
    41e4:	4ae080e7          	jalr	1198(ra) # 568e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    41e8:	87ca                	mv	a5,s2
    41ea:	3e800737          	lui	a4,0x3e800
    41ee:	993a                	add	s2,s2,a4
    41f0:	6705                	lui	a4,0x1
      n += *(a+i);
    41f2:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f14f8>
    41f6:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    41f8:	97ba                	add	a5,a5,a4
    41fa:	ff279ce3          	bne	a5,s2,41f2 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    41fe:	8626                	mv	a2,s1
    4200:	85d6                	mv	a1,s5
    4202:	00003517          	auipc	a0,0x3
    4206:	4a650513          	addi	a0,a0,1190 # 76a8 <malloc+0x1c60>
    420a:	00001097          	auipc	ra,0x1
    420e:	786080e7          	jalr	1926(ra) # 5990 <printf>
    exit(1);
    4212:	4505                	li	a0,1
    4214:	00001097          	auipc	ra,0x1
    4218:	3f2080e7          	jalr	1010(ra) # 5606 <exit>
    exit(1);
    421c:	4505                	li	a0,1
    421e:	00001097          	auipc	ra,0x1
    4222:	3e8080e7          	jalr	1000(ra) # 5606 <exit>

0000000000004226 <reparent>:
{
    4226:	7179                	addi	sp,sp,-48
    4228:	f406                	sd	ra,40(sp)
    422a:	f022                	sd	s0,32(sp)
    422c:	ec26                	sd	s1,24(sp)
    422e:	e84a                	sd	s2,16(sp)
    4230:	e44e                	sd	s3,8(sp)
    4232:	e052                	sd	s4,0(sp)
    4234:	1800                	addi	s0,sp,48
    4236:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4238:	00001097          	auipc	ra,0x1
    423c:	44e080e7          	jalr	1102(ra) # 5686 <getpid>
    4240:	8a2a                	mv	s4,a0
    4242:	0c800913          	li	s2,200
    int pid = fork();
    4246:	00001097          	auipc	ra,0x1
    424a:	3b8080e7          	jalr	952(ra) # 55fe <fork>
    424e:	84aa                	mv	s1,a0
    if(pid < 0){
    4250:	02054263          	bltz	a0,4274 <reparent+0x4e>
    if(pid){
    4254:	cd21                	beqz	a0,42ac <reparent+0x86>
      if(wait(0) != pid){
    4256:	4501                	li	a0,0
    4258:	00001097          	auipc	ra,0x1
    425c:	3b6080e7          	jalr	950(ra) # 560e <wait>
    4260:	02951863          	bne	a0,s1,4290 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4264:	397d                	addiw	s2,s2,-1
    4266:	fe0910e3          	bnez	s2,4246 <reparent+0x20>
  exit(0);
    426a:	4501                	li	a0,0
    426c:	00001097          	auipc	ra,0x1
    4270:	39a080e7          	jalr	922(ra) # 5606 <exit>
      printf("%s: fork failed\n", s);
    4274:	85ce                	mv	a1,s3
    4276:	00002517          	auipc	a0,0x2
    427a:	14a50513          	addi	a0,a0,330 # 63c0 <malloc+0x978>
    427e:	00001097          	auipc	ra,0x1
    4282:	712080e7          	jalr	1810(ra) # 5990 <printf>
      exit(1);
    4286:	4505                	li	a0,1
    4288:	00001097          	auipc	ra,0x1
    428c:	37e080e7          	jalr	894(ra) # 5606 <exit>
        printf("%s: wait wrong pid\n", s);
    4290:	85ce                	mv	a1,s3
    4292:	00002517          	auipc	a0,0x2
    4296:	2b650513          	addi	a0,a0,694 # 6548 <malloc+0xb00>
    429a:	00001097          	auipc	ra,0x1
    429e:	6f6080e7          	jalr	1782(ra) # 5990 <printf>
        exit(1);
    42a2:	4505                	li	a0,1
    42a4:	00001097          	auipc	ra,0x1
    42a8:	362080e7          	jalr	866(ra) # 5606 <exit>
      int pid2 = fork();
    42ac:	00001097          	auipc	ra,0x1
    42b0:	352080e7          	jalr	850(ra) # 55fe <fork>
      if(pid2 < 0){
    42b4:	00054763          	bltz	a0,42c2 <reparent+0x9c>
      exit(0);
    42b8:	4501                	li	a0,0
    42ba:	00001097          	auipc	ra,0x1
    42be:	34c080e7          	jalr	844(ra) # 5606 <exit>
        kill(master_pid);
    42c2:	8552                	mv	a0,s4
    42c4:	00001097          	auipc	ra,0x1
    42c8:	372080e7          	jalr	882(ra) # 5636 <kill>
        exit(1);
    42cc:	4505                	li	a0,1
    42ce:	00001097          	auipc	ra,0x1
    42d2:	338080e7          	jalr	824(ra) # 5606 <exit>

00000000000042d6 <mem>:
{
    42d6:	7139                	addi	sp,sp,-64
    42d8:	fc06                	sd	ra,56(sp)
    42da:	f822                	sd	s0,48(sp)
    42dc:	f426                	sd	s1,40(sp)
    42de:	f04a                	sd	s2,32(sp)
    42e0:	ec4e                	sd	s3,24(sp)
    42e2:	0080                	addi	s0,sp,64
    42e4:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    42e6:	00001097          	auipc	ra,0x1
    42ea:	318080e7          	jalr	792(ra) # 55fe <fork>
    m1 = 0;
    42ee:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    42f0:	6909                	lui	s2,0x2
    42f2:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x15f>
  if((pid = fork()) == 0){
    42f6:	c115                	beqz	a0,431a <mem+0x44>
    wait(&xstatus);
    42f8:	fcc40513          	addi	a0,s0,-52
    42fc:	00001097          	auipc	ra,0x1
    4300:	312080e7          	jalr	786(ra) # 560e <wait>
    if(xstatus == -1){
    4304:	fcc42503          	lw	a0,-52(s0)
    4308:	57fd                	li	a5,-1
    430a:	06f50363          	beq	a0,a5,4370 <mem+0x9a>
    exit(xstatus);
    430e:	00001097          	auipc	ra,0x1
    4312:	2f8080e7          	jalr	760(ra) # 5606 <exit>
      *(char**)m2 = m1;
    4316:	e104                	sd	s1,0(a0)
      m1 = m2;
    4318:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    431a:	854a                	mv	a0,s2
    431c:	00001097          	auipc	ra,0x1
    4320:	72c080e7          	jalr	1836(ra) # 5a48 <malloc>
    4324:	f96d                	bnez	a0,4316 <mem+0x40>
    while(m1){
    4326:	c881                	beqz	s1,4336 <mem+0x60>
      m2 = *(char**)m1;
    4328:	8526                	mv	a0,s1
    432a:	6084                	ld	s1,0(s1)
      free(m1);
    432c:	00001097          	auipc	ra,0x1
    4330:	69a080e7          	jalr	1690(ra) # 59c6 <free>
    while(m1){
    4334:	f8f5                	bnez	s1,4328 <mem+0x52>
    m1 = malloc(1024*20);
    4336:	6515                	lui	a0,0x5
    4338:	00001097          	auipc	ra,0x1
    433c:	710080e7          	jalr	1808(ra) # 5a48 <malloc>
    if(m1 == 0){
    4340:	c911                	beqz	a0,4354 <mem+0x7e>
    free(m1);
    4342:	00001097          	auipc	ra,0x1
    4346:	684080e7          	jalr	1668(ra) # 59c6 <free>
    exit(0);
    434a:	4501                	li	a0,0
    434c:	00001097          	auipc	ra,0x1
    4350:	2ba080e7          	jalr	698(ra) # 5606 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4354:	85ce                	mv	a1,s3
    4356:	00003517          	auipc	a0,0x3
    435a:	38250513          	addi	a0,a0,898 # 76d8 <malloc+0x1c90>
    435e:	00001097          	auipc	ra,0x1
    4362:	632080e7          	jalr	1586(ra) # 5990 <printf>
      exit(1);
    4366:	4505                	li	a0,1
    4368:	00001097          	auipc	ra,0x1
    436c:	29e080e7          	jalr	670(ra) # 5606 <exit>
      exit(0);
    4370:	4501                	li	a0,0
    4372:	00001097          	auipc	ra,0x1
    4376:	294080e7          	jalr	660(ra) # 5606 <exit>

000000000000437a <sharedfd>:
{
    437a:	7159                	addi	sp,sp,-112
    437c:	f486                	sd	ra,104(sp)
    437e:	f0a2                	sd	s0,96(sp)
    4380:	eca6                	sd	s1,88(sp)
    4382:	e8ca                	sd	s2,80(sp)
    4384:	e4ce                	sd	s3,72(sp)
    4386:	e0d2                	sd	s4,64(sp)
    4388:	fc56                	sd	s5,56(sp)
    438a:	f85a                	sd	s6,48(sp)
    438c:	f45e                	sd	s7,40(sp)
    438e:	1880                	addi	s0,sp,112
    4390:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4392:	00003517          	auipc	a0,0x3
    4396:	36650513          	addi	a0,a0,870 # 76f8 <malloc+0x1cb0>
    439a:	00001097          	auipc	ra,0x1
    439e:	2bc080e7          	jalr	700(ra) # 5656 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    43a2:	20200593          	li	a1,514
    43a6:	00003517          	auipc	a0,0x3
    43aa:	35250513          	addi	a0,a0,850 # 76f8 <malloc+0x1cb0>
    43ae:	00001097          	auipc	ra,0x1
    43b2:	298080e7          	jalr	664(ra) # 5646 <open>
  if(fd < 0){
    43b6:	04054a63          	bltz	a0,440a <sharedfd+0x90>
    43ba:	892a                	mv	s2,a0
  pid = fork();
    43bc:	00001097          	auipc	ra,0x1
    43c0:	242080e7          	jalr	578(ra) # 55fe <fork>
    43c4:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    43c6:	06300593          	li	a1,99
    43ca:	c119                	beqz	a0,43d0 <sharedfd+0x56>
    43cc:	07000593          	li	a1,112
    43d0:	4629                	li	a2,10
    43d2:	fa040513          	addi	a0,s0,-96
    43d6:	00001097          	auipc	ra,0x1
    43da:	036080e7          	jalr	54(ra) # 540c <memset>
    43de:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    43e2:	4629                	li	a2,10
    43e4:	fa040593          	addi	a1,s0,-96
    43e8:	854a                	mv	a0,s2
    43ea:	00001097          	auipc	ra,0x1
    43ee:	23c080e7          	jalr	572(ra) # 5626 <write>
    43f2:	47a9                	li	a5,10
    43f4:	02f51963          	bne	a0,a5,4426 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    43f8:	34fd                	addiw	s1,s1,-1
    43fa:	f4e5                	bnez	s1,43e2 <sharedfd+0x68>
  if(pid == 0) {
    43fc:	04099363          	bnez	s3,4442 <sharedfd+0xc8>
    exit(0);
    4400:	4501                	li	a0,0
    4402:	00001097          	auipc	ra,0x1
    4406:	204080e7          	jalr	516(ra) # 5606 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    440a:	85d2                	mv	a1,s4
    440c:	00003517          	auipc	a0,0x3
    4410:	2fc50513          	addi	a0,a0,764 # 7708 <malloc+0x1cc0>
    4414:	00001097          	auipc	ra,0x1
    4418:	57c080e7          	jalr	1404(ra) # 5990 <printf>
    exit(1);
    441c:	4505                	li	a0,1
    441e:	00001097          	auipc	ra,0x1
    4422:	1e8080e7          	jalr	488(ra) # 5606 <exit>
      printf("%s: write sharedfd failed\n", s);
    4426:	85d2                	mv	a1,s4
    4428:	00003517          	auipc	a0,0x3
    442c:	30850513          	addi	a0,a0,776 # 7730 <malloc+0x1ce8>
    4430:	00001097          	auipc	ra,0x1
    4434:	560080e7          	jalr	1376(ra) # 5990 <printf>
      exit(1);
    4438:	4505                	li	a0,1
    443a:	00001097          	auipc	ra,0x1
    443e:	1cc080e7          	jalr	460(ra) # 5606 <exit>
    wait(&xstatus);
    4442:	f9c40513          	addi	a0,s0,-100
    4446:	00001097          	auipc	ra,0x1
    444a:	1c8080e7          	jalr	456(ra) # 560e <wait>
    if(xstatus != 0)
    444e:	f9c42983          	lw	s3,-100(s0)
    4452:	00098763          	beqz	s3,4460 <sharedfd+0xe6>
      exit(xstatus);
    4456:	854e                	mv	a0,s3
    4458:	00001097          	auipc	ra,0x1
    445c:	1ae080e7          	jalr	430(ra) # 5606 <exit>
  close(fd);
    4460:	854a                	mv	a0,s2
    4462:	00001097          	auipc	ra,0x1
    4466:	1cc080e7          	jalr	460(ra) # 562e <close>
  fd = open("sharedfd", 0);
    446a:	4581                	li	a1,0
    446c:	00003517          	auipc	a0,0x3
    4470:	28c50513          	addi	a0,a0,652 # 76f8 <malloc+0x1cb0>
    4474:	00001097          	auipc	ra,0x1
    4478:	1d2080e7          	jalr	466(ra) # 5646 <open>
    447c:	8baa                	mv	s7,a0
  nc = np = 0;
    447e:	8ace                	mv	s5,s3
  if(fd < 0){
    4480:	02054563          	bltz	a0,44aa <sharedfd+0x130>
    4484:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4488:	06300493          	li	s1,99
      if(buf[i] == 'p')
    448c:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4490:	4629                	li	a2,10
    4492:	fa040593          	addi	a1,s0,-96
    4496:	855e                	mv	a0,s7
    4498:	00001097          	auipc	ra,0x1
    449c:	186080e7          	jalr	390(ra) # 561e <read>
    44a0:	02a05f63          	blez	a0,44de <sharedfd+0x164>
    44a4:	fa040793          	addi	a5,s0,-96
    44a8:	a01d                	j	44ce <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    44aa:	85d2                	mv	a1,s4
    44ac:	00003517          	auipc	a0,0x3
    44b0:	2a450513          	addi	a0,a0,676 # 7750 <malloc+0x1d08>
    44b4:	00001097          	auipc	ra,0x1
    44b8:	4dc080e7          	jalr	1244(ra) # 5990 <printf>
    exit(1);
    44bc:	4505                	li	a0,1
    44be:	00001097          	auipc	ra,0x1
    44c2:	148080e7          	jalr	328(ra) # 5606 <exit>
        nc++;
    44c6:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    44c8:	0785                	addi	a5,a5,1
    44ca:	fd2783e3          	beq	a5,s2,4490 <sharedfd+0x116>
      if(buf[i] == 'c')
    44ce:	0007c703          	lbu	a4,0(a5)
    44d2:	fe970ae3          	beq	a4,s1,44c6 <sharedfd+0x14c>
      if(buf[i] == 'p')
    44d6:	ff6719e3          	bne	a4,s6,44c8 <sharedfd+0x14e>
        np++;
    44da:	2a85                	addiw	s5,s5,1
    44dc:	b7f5                	j	44c8 <sharedfd+0x14e>
  close(fd);
    44de:	855e                	mv	a0,s7
    44e0:	00001097          	auipc	ra,0x1
    44e4:	14e080e7          	jalr	334(ra) # 562e <close>
  unlink("sharedfd");
    44e8:	00003517          	auipc	a0,0x3
    44ec:	21050513          	addi	a0,a0,528 # 76f8 <malloc+0x1cb0>
    44f0:	00001097          	auipc	ra,0x1
    44f4:	166080e7          	jalr	358(ra) # 5656 <unlink>
  if(nc == N*SZ && np == N*SZ){
    44f8:	6789                	lui	a5,0x2
    44fa:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x15e>
    44fe:	00f99763          	bne	s3,a5,450c <sharedfd+0x192>
    4502:	6789                	lui	a5,0x2
    4504:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x15e>
    4508:	02fa8063          	beq	s5,a5,4528 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    450c:	85d2                	mv	a1,s4
    450e:	00003517          	auipc	a0,0x3
    4512:	26a50513          	addi	a0,a0,618 # 7778 <malloc+0x1d30>
    4516:	00001097          	auipc	ra,0x1
    451a:	47a080e7          	jalr	1146(ra) # 5990 <printf>
    exit(1);
    451e:	4505                	li	a0,1
    4520:	00001097          	auipc	ra,0x1
    4524:	0e6080e7          	jalr	230(ra) # 5606 <exit>
    exit(0);
    4528:	4501                	li	a0,0
    452a:	00001097          	auipc	ra,0x1
    452e:	0dc080e7          	jalr	220(ra) # 5606 <exit>

0000000000004532 <fourfiles>:
{
    4532:	7171                	addi	sp,sp,-176
    4534:	f506                	sd	ra,168(sp)
    4536:	f122                	sd	s0,160(sp)
    4538:	ed26                	sd	s1,152(sp)
    453a:	e94a                	sd	s2,144(sp)
    453c:	e54e                	sd	s3,136(sp)
    453e:	e152                	sd	s4,128(sp)
    4540:	fcd6                	sd	s5,120(sp)
    4542:	f8da                	sd	s6,112(sp)
    4544:	f4de                	sd	s7,104(sp)
    4546:	f0e2                	sd	s8,96(sp)
    4548:	ece6                	sd	s9,88(sp)
    454a:	e8ea                	sd	s10,80(sp)
    454c:	e4ee                	sd	s11,72(sp)
    454e:	1900                	addi	s0,sp,176
    4550:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    4554:	00003797          	auipc	a5,0x3
    4558:	23c78793          	addi	a5,a5,572 # 7790 <malloc+0x1d48>
    455c:	f6f43823          	sd	a5,-144(s0)
    4560:	00003797          	auipc	a5,0x3
    4564:	23878793          	addi	a5,a5,568 # 7798 <malloc+0x1d50>
    4568:	f6f43c23          	sd	a5,-136(s0)
    456c:	00003797          	auipc	a5,0x3
    4570:	23478793          	addi	a5,a5,564 # 77a0 <malloc+0x1d58>
    4574:	f8f43023          	sd	a5,-128(s0)
    4578:	00003797          	auipc	a5,0x3
    457c:	23078793          	addi	a5,a5,560 # 77a8 <malloc+0x1d60>
    4580:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4584:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4588:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    458a:	4481                	li	s1,0
    458c:	4a11                	li	s4,4
    fname = names[pi];
    458e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4592:	854e                	mv	a0,s3
    4594:	00001097          	auipc	ra,0x1
    4598:	0c2080e7          	jalr	194(ra) # 5656 <unlink>
    pid = fork();
    459c:	00001097          	auipc	ra,0x1
    45a0:	062080e7          	jalr	98(ra) # 55fe <fork>
    if(pid < 0){
    45a4:	04054463          	bltz	a0,45ec <fourfiles+0xba>
    if(pid == 0){
    45a8:	c12d                	beqz	a0,460a <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    45aa:	2485                	addiw	s1,s1,1
    45ac:	0921                	addi	s2,s2,8
    45ae:	ff4490e3          	bne	s1,s4,458e <fourfiles+0x5c>
    45b2:	4491                	li	s1,4
    wait(&xstatus);
    45b4:	f6c40513          	addi	a0,s0,-148
    45b8:	00001097          	auipc	ra,0x1
    45bc:	056080e7          	jalr	86(ra) # 560e <wait>
    if(xstatus != 0)
    45c0:	f6c42b03          	lw	s6,-148(s0)
    45c4:	0c0b1e63          	bnez	s6,46a0 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    45c8:	34fd                	addiw	s1,s1,-1
    45ca:	f4ed                	bnez	s1,45b4 <fourfiles+0x82>
    45cc:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    45d0:	00007a17          	auipc	s4,0x7
    45d4:	528a0a13          	addi	s4,s4,1320 # baf8 <buf>
    45d8:	00007a97          	auipc	s5,0x7
    45dc:	521a8a93          	addi	s5,s5,1313 # baf9 <buf+0x1>
    if(total != N*SZ){
    45e0:	6d85                	lui	s11,0x1
    45e2:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x34>
  for(i = 0; i < NCHILD; i++){
    45e6:	03400d13          	li	s10,52
    45ea:	aa1d                	j	4720 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    45ec:	f5843583          	ld	a1,-168(s0)
    45f0:	00002517          	auipc	a0,0x2
    45f4:	1d850513          	addi	a0,a0,472 # 67c8 <malloc+0xd80>
    45f8:	00001097          	auipc	ra,0x1
    45fc:	398080e7          	jalr	920(ra) # 5990 <printf>
      exit(1);
    4600:	4505                	li	a0,1
    4602:	00001097          	auipc	ra,0x1
    4606:	004080e7          	jalr	4(ra) # 5606 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    460a:	20200593          	li	a1,514
    460e:	854e                	mv	a0,s3
    4610:	00001097          	auipc	ra,0x1
    4614:	036080e7          	jalr	54(ra) # 5646 <open>
    4618:	892a                	mv	s2,a0
      if(fd < 0){
    461a:	04054763          	bltz	a0,4668 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    461e:	1f400613          	li	a2,500
    4622:	0304859b          	addiw	a1,s1,48
    4626:	00007517          	auipc	a0,0x7
    462a:	4d250513          	addi	a0,a0,1234 # baf8 <buf>
    462e:	00001097          	auipc	ra,0x1
    4632:	dde080e7          	jalr	-546(ra) # 540c <memset>
    4636:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4638:	00007997          	auipc	s3,0x7
    463c:	4c098993          	addi	s3,s3,1216 # baf8 <buf>
    4640:	1f400613          	li	a2,500
    4644:	85ce                	mv	a1,s3
    4646:	854a                	mv	a0,s2
    4648:	00001097          	auipc	ra,0x1
    464c:	fde080e7          	jalr	-34(ra) # 5626 <write>
    4650:	85aa                	mv	a1,a0
    4652:	1f400793          	li	a5,500
    4656:	02f51863          	bne	a0,a5,4686 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    465a:	34fd                	addiw	s1,s1,-1
    465c:	f0f5                	bnez	s1,4640 <fourfiles+0x10e>
      exit(0);
    465e:	4501                	li	a0,0
    4660:	00001097          	auipc	ra,0x1
    4664:	fa6080e7          	jalr	-90(ra) # 5606 <exit>
        printf("create failed\n", s);
    4668:	f5843583          	ld	a1,-168(s0)
    466c:	00003517          	auipc	a0,0x3
    4670:	14450513          	addi	a0,a0,324 # 77b0 <malloc+0x1d68>
    4674:	00001097          	auipc	ra,0x1
    4678:	31c080e7          	jalr	796(ra) # 5990 <printf>
        exit(1);
    467c:	4505                	li	a0,1
    467e:	00001097          	auipc	ra,0x1
    4682:	f88080e7          	jalr	-120(ra) # 5606 <exit>
          printf("write failed %d\n", n);
    4686:	00003517          	auipc	a0,0x3
    468a:	13a50513          	addi	a0,a0,314 # 77c0 <malloc+0x1d78>
    468e:	00001097          	auipc	ra,0x1
    4692:	302080e7          	jalr	770(ra) # 5990 <printf>
          exit(1);
    4696:	4505                	li	a0,1
    4698:	00001097          	auipc	ra,0x1
    469c:	f6e080e7          	jalr	-146(ra) # 5606 <exit>
      exit(xstatus);
    46a0:	855a                	mv	a0,s6
    46a2:	00001097          	auipc	ra,0x1
    46a6:	f64080e7          	jalr	-156(ra) # 5606 <exit>
          printf("wrong char\n", s);
    46aa:	f5843583          	ld	a1,-168(s0)
    46ae:	00003517          	auipc	a0,0x3
    46b2:	12a50513          	addi	a0,a0,298 # 77d8 <malloc+0x1d90>
    46b6:	00001097          	auipc	ra,0x1
    46ba:	2da080e7          	jalr	730(ra) # 5990 <printf>
          exit(1);
    46be:	4505                	li	a0,1
    46c0:	00001097          	auipc	ra,0x1
    46c4:	f46080e7          	jalr	-186(ra) # 5606 <exit>
      total += n;
    46c8:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    46cc:	660d                	lui	a2,0x3
    46ce:	85d2                	mv	a1,s4
    46d0:	854e                	mv	a0,s3
    46d2:	00001097          	auipc	ra,0x1
    46d6:	f4c080e7          	jalr	-180(ra) # 561e <read>
    46da:	02a05363          	blez	a0,4700 <fourfiles+0x1ce>
    46de:	00007797          	auipc	a5,0x7
    46e2:	41a78793          	addi	a5,a5,1050 # baf8 <buf>
    46e6:	fff5069b          	addiw	a3,a0,-1
    46ea:	1682                	slli	a3,a3,0x20
    46ec:	9281                	srli	a3,a3,0x20
    46ee:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    46f0:	0007c703          	lbu	a4,0(a5)
    46f4:	fa971be3          	bne	a4,s1,46aa <fourfiles+0x178>
      for(j = 0; j < n; j++){
    46f8:	0785                	addi	a5,a5,1
    46fa:	fed79be3          	bne	a5,a3,46f0 <fourfiles+0x1be>
    46fe:	b7e9                	j	46c8 <fourfiles+0x196>
    close(fd);
    4700:	854e                	mv	a0,s3
    4702:	00001097          	auipc	ra,0x1
    4706:	f2c080e7          	jalr	-212(ra) # 562e <close>
    if(total != N*SZ){
    470a:	03b91863          	bne	s2,s11,473a <fourfiles+0x208>
    unlink(fname);
    470e:	8566                	mv	a0,s9
    4710:	00001097          	auipc	ra,0x1
    4714:	f46080e7          	jalr	-186(ra) # 5656 <unlink>
  for(i = 0; i < NCHILD; i++){
    4718:	0c21                	addi	s8,s8,8
    471a:	2b85                	addiw	s7,s7,1
    471c:	03ab8d63          	beq	s7,s10,4756 <fourfiles+0x224>
    fname = names[i];
    4720:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4724:	4581                	li	a1,0
    4726:	8566                	mv	a0,s9
    4728:	00001097          	auipc	ra,0x1
    472c:	f1e080e7          	jalr	-226(ra) # 5646 <open>
    4730:	89aa                	mv	s3,a0
    total = 0;
    4732:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    4734:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4738:	bf51                	j	46cc <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    473a:	85ca                	mv	a1,s2
    473c:	00003517          	auipc	a0,0x3
    4740:	0ac50513          	addi	a0,a0,172 # 77e8 <malloc+0x1da0>
    4744:	00001097          	auipc	ra,0x1
    4748:	24c080e7          	jalr	588(ra) # 5990 <printf>
      exit(1);
    474c:	4505                	li	a0,1
    474e:	00001097          	auipc	ra,0x1
    4752:	eb8080e7          	jalr	-328(ra) # 5606 <exit>
}
    4756:	70aa                	ld	ra,168(sp)
    4758:	740a                	ld	s0,160(sp)
    475a:	64ea                	ld	s1,152(sp)
    475c:	694a                	ld	s2,144(sp)
    475e:	69aa                	ld	s3,136(sp)
    4760:	6a0a                	ld	s4,128(sp)
    4762:	7ae6                	ld	s5,120(sp)
    4764:	7b46                	ld	s6,112(sp)
    4766:	7ba6                	ld	s7,104(sp)
    4768:	7c06                	ld	s8,96(sp)
    476a:	6ce6                	ld	s9,88(sp)
    476c:	6d46                	ld	s10,80(sp)
    476e:	6da6                	ld	s11,72(sp)
    4770:	614d                	addi	sp,sp,176
    4772:	8082                	ret

0000000000004774 <concreate>:
{
    4774:	7135                	addi	sp,sp,-160
    4776:	ed06                	sd	ra,152(sp)
    4778:	e922                	sd	s0,144(sp)
    477a:	e526                	sd	s1,136(sp)
    477c:	e14a                	sd	s2,128(sp)
    477e:	fcce                	sd	s3,120(sp)
    4780:	f8d2                	sd	s4,112(sp)
    4782:	f4d6                	sd	s5,104(sp)
    4784:	f0da                	sd	s6,96(sp)
    4786:	ecde                	sd	s7,88(sp)
    4788:	1100                	addi	s0,sp,160
    478a:	89aa                	mv	s3,a0
  file[0] = 'C';
    478c:	04300793          	li	a5,67
    4790:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4794:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4798:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    479a:	4b0d                	li	s6,3
    479c:	4a85                	li	s5,1
      link("C0", file);
    479e:	00003b97          	auipc	s7,0x3
    47a2:	062b8b93          	addi	s7,s7,98 # 7800 <malloc+0x1db8>
  for(i = 0; i < N; i++){
    47a6:	02800a13          	li	s4,40
    47aa:	acc9                	j	4a7c <concreate+0x308>
      link("C0", file);
    47ac:	fa840593          	addi	a1,s0,-88
    47b0:	855e                	mv	a0,s7
    47b2:	00001097          	auipc	ra,0x1
    47b6:	eb4080e7          	jalr	-332(ra) # 5666 <link>
    if(pid == 0) {
    47ba:	a465                	j	4a62 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    47bc:	4795                	li	a5,5
    47be:	02f9693b          	remw	s2,s2,a5
    47c2:	4785                	li	a5,1
    47c4:	02f90b63          	beq	s2,a5,47fa <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    47c8:	20200593          	li	a1,514
    47cc:	fa840513          	addi	a0,s0,-88
    47d0:	00001097          	auipc	ra,0x1
    47d4:	e76080e7          	jalr	-394(ra) # 5646 <open>
      if(fd < 0){
    47d8:	26055c63          	bgez	a0,4a50 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    47dc:	fa840593          	addi	a1,s0,-88
    47e0:	00003517          	auipc	a0,0x3
    47e4:	02850513          	addi	a0,a0,40 # 7808 <malloc+0x1dc0>
    47e8:	00001097          	auipc	ra,0x1
    47ec:	1a8080e7          	jalr	424(ra) # 5990 <printf>
        exit(1);
    47f0:	4505                	li	a0,1
    47f2:	00001097          	auipc	ra,0x1
    47f6:	e14080e7          	jalr	-492(ra) # 5606 <exit>
      link("C0", file);
    47fa:	fa840593          	addi	a1,s0,-88
    47fe:	00003517          	auipc	a0,0x3
    4802:	00250513          	addi	a0,a0,2 # 7800 <malloc+0x1db8>
    4806:	00001097          	auipc	ra,0x1
    480a:	e60080e7          	jalr	-416(ra) # 5666 <link>
      exit(0);
    480e:	4501                	li	a0,0
    4810:	00001097          	auipc	ra,0x1
    4814:	df6080e7          	jalr	-522(ra) # 5606 <exit>
        exit(1);
    4818:	4505                	li	a0,1
    481a:	00001097          	auipc	ra,0x1
    481e:	dec080e7          	jalr	-532(ra) # 5606 <exit>
  memset(fa, 0, sizeof(fa));
    4822:	02800613          	li	a2,40
    4826:	4581                	li	a1,0
    4828:	f8040513          	addi	a0,s0,-128
    482c:	00001097          	auipc	ra,0x1
    4830:	be0080e7          	jalr	-1056(ra) # 540c <memset>
  fd = open(".", 0);
    4834:	4581                	li	a1,0
    4836:	00002517          	auipc	a0,0x2
    483a:	9ea50513          	addi	a0,a0,-1558 # 6220 <malloc+0x7d8>
    483e:	00001097          	auipc	ra,0x1
    4842:	e08080e7          	jalr	-504(ra) # 5646 <open>
    4846:	892a                	mv	s2,a0
  n = 0;
    4848:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    484a:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    484e:	02700b13          	li	s6,39
      fa[i] = 1;
    4852:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4854:	4641                	li	a2,16
    4856:	f7040593          	addi	a1,s0,-144
    485a:	854a                	mv	a0,s2
    485c:	00001097          	auipc	ra,0x1
    4860:	dc2080e7          	jalr	-574(ra) # 561e <read>
    4864:	08a05263          	blez	a0,48e8 <concreate+0x174>
    if(de.inum == 0)
    4868:	f7045783          	lhu	a5,-144(s0)
    486c:	d7e5                	beqz	a5,4854 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    486e:	f7244783          	lbu	a5,-142(s0)
    4872:	ff4791e3          	bne	a5,s4,4854 <concreate+0xe0>
    4876:	f7444783          	lbu	a5,-140(s0)
    487a:	ffe9                	bnez	a5,4854 <concreate+0xe0>
      i = de.name[1] - '0';
    487c:	f7344783          	lbu	a5,-141(s0)
    4880:	fd07879b          	addiw	a5,a5,-48
    4884:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4888:	02eb6063          	bltu	s6,a4,48a8 <concreate+0x134>
      if(fa[i]){
    488c:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x50>
    4890:	97a2                	add	a5,a5,s0
    4892:	fd07c783          	lbu	a5,-48(a5)
    4896:	eb8d                	bnez	a5,48c8 <concreate+0x154>
      fa[i] = 1;
    4898:	fb070793          	addi	a5,a4,-80
    489c:	00878733          	add	a4,a5,s0
    48a0:	fd770823          	sb	s7,-48(a4)
      n++;
    48a4:	2a85                	addiw	s5,s5,1
    48a6:	b77d                	j	4854 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    48a8:	f7240613          	addi	a2,s0,-142
    48ac:	85ce                	mv	a1,s3
    48ae:	00003517          	auipc	a0,0x3
    48b2:	f7a50513          	addi	a0,a0,-134 # 7828 <malloc+0x1de0>
    48b6:	00001097          	auipc	ra,0x1
    48ba:	0da080e7          	jalr	218(ra) # 5990 <printf>
        exit(1);
    48be:	4505                	li	a0,1
    48c0:	00001097          	auipc	ra,0x1
    48c4:	d46080e7          	jalr	-698(ra) # 5606 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    48c8:	f7240613          	addi	a2,s0,-142
    48cc:	85ce                	mv	a1,s3
    48ce:	00003517          	auipc	a0,0x3
    48d2:	f7a50513          	addi	a0,a0,-134 # 7848 <malloc+0x1e00>
    48d6:	00001097          	auipc	ra,0x1
    48da:	0ba080e7          	jalr	186(ra) # 5990 <printf>
        exit(1);
    48de:	4505                	li	a0,1
    48e0:	00001097          	auipc	ra,0x1
    48e4:	d26080e7          	jalr	-730(ra) # 5606 <exit>
  close(fd);
    48e8:	854a                	mv	a0,s2
    48ea:	00001097          	auipc	ra,0x1
    48ee:	d44080e7          	jalr	-700(ra) # 562e <close>
  if(n != N){
    48f2:	02800793          	li	a5,40
    48f6:	00fa9763          	bne	s5,a5,4904 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    48fa:	4a8d                	li	s5,3
    48fc:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    48fe:	02800a13          	li	s4,40
    4902:	a8c9                	j	49d4 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4904:	85ce                	mv	a1,s3
    4906:	00003517          	auipc	a0,0x3
    490a:	f6a50513          	addi	a0,a0,-150 # 7870 <malloc+0x1e28>
    490e:	00001097          	auipc	ra,0x1
    4912:	082080e7          	jalr	130(ra) # 5990 <printf>
    exit(1);
    4916:	4505                	li	a0,1
    4918:	00001097          	auipc	ra,0x1
    491c:	cee080e7          	jalr	-786(ra) # 5606 <exit>
      printf("%s: fork failed\n", s);
    4920:	85ce                	mv	a1,s3
    4922:	00002517          	auipc	a0,0x2
    4926:	a9e50513          	addi	a0,a0,-1378 # 63c0 <malloc+0x978>
    492a:	00001097          	auipc	ra,0x1
    492e:	066080e7          	jalr	102(ra) # 5990 <printf>
      exit(1);
    4932:	4505                	li	a0,1
    4934:	00001097          	auipc	ra,0x1
    4938:	cd2080e7          	jalr	-814(ra) # 5606 <exit>
      close(open(file, 0));
    493c:	4581                	li	a1,0
    493e:	fa840513          	addi	a0,s0,-88
    4942:	00001097          	auipc	ra,0x1
    4946:	d04080e7          	jalr	-764(ra) # 5646 <open>
    494a:	00001097          	auipc	ra,0x1
    494e:	ce4080e7          	jalr	-796(ra) # 562e <close>
      close(open(file, 0));
    4952:	4581                	li	a1,0
    4954:	fa840513          	addi	a0,s0,-88
    4958:	00001097          	auipc	ra,0x1
    495c:	cee080e7          	jalr	-786(ra) # 5646 <open>
    4960:	00001097          	auipc	ra,0x1
    4964:	cce080e7          	jalr	-818(ra) # 562e <close>
      close(open(file, 0));
    4968:	4581                	li	a1,0
    496a:	fa840513          	addi	a0,s0,-88
    496e:	00001097          	auipc	ra,0x1
    4972:	cd8080e7          	jalr	-808(ra) # 5646 <open>
    4976:	00001097          	auipc	ra,0x1
    497a:	cb8080e7          	jalr	-840(ra) # 562e <close>
      close(open(file, 0));
    497e:	4581                	li	a1,0
    4980:	fa840513          	addi	a0,s0,-88
    4984:	00001097          	auipc	ra,0x1
    4988:	cc2080e7          	jalr	-830(ra) # 5646 <open>
    498c:	00001097          	auipc	ra,0x1
    4990:	ca2080e7          	jalr	-862(ra) # 562e <close>
      close(open(file, 0));
    4994:	4581                	li	a1,0
    4996:	fa840513          	addi	a0,s0,-88
    499a:	00001097          	auipc	ra,0x1
    499e:	cac080e7          	jalr	-852(ra) # 5646 <open>
    49a2:	00001097          	auipc	ra,0x1
    49a6:	c8c080e7          	jalr	-884(ra) # 562e <close>
      close(open(file, 0));
    49aa:	4581                	li	a1,0
    49ac:	fa840513          	addi	a0,s0,-88
    49b0:	00001097          	auipc	ra,0x1
    49b4:	c96080e7          	jalr	-874(ra) # 5646 <open>
    49b8:	00001097          	auipc	ra,0x1
    49bc:	c76080e7          	jalr	-906(ra) # 562e <close>
    if(pid == 0)
    49c0:	08090363          	beqz	s2,4a46 <concreate+0x2d2>
      wait(0);
    49c4:	4501                	li	a0,0
    49c6:	00001097          	auipc	ra,0x1
    49ca:	c48080e7          	jalr	-952(ra) # 560e <wait>
  for(i = 0; i < N; i++){
    49ce:	2485                	addiw	s1,s1,1
    49d0:	0f448563          	beq	s1,s4,4aba <concreate+0x346>
    file[1] = '0' + i;
    49d4:	0304879b          	addiw	a5,s1,48
    49d8:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    49dc:	00001097          	auipc	ra,0x1
    49e0:	c22080e7          	jalr	-990(ra) # 55fe <fork>
    49e4:	892a                	mv	s2,a0
    if(pid < 0){
    49e6:	f2054de3          	bltz	a0,4920 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    49ea:	0354e73b          	remw	a4,s1,s5
    49ee:	00a767b3          	or	a5,a4,a0
    49f2:	2781                	sext.w	a5,a5
    49f4:	d7a1                	beqz	a5,493c <concreate+0x1c8>
    49f6:	01671363          	bne	a4,s6,49fc <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    49fa:	f129                	bnez	a0,493c <concreate+0x1c8>
      unlink(file);
    49fc:	fa840513          	addi	a0,s0,-88
    4a00:	00001097          	auipc	ra,0x1
    4a04:	c56080e7          	jalr	-938(ra) # 5656 <unlink>
      unlink(file);
    4a08:	fa840513          	addi	a0,s0,-88
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	c4a080e7          	jalr	-950(ra) # 5656 <unlink>
      unlink(file);
    4a14:	fa840513          	addi	a0,s0,-88
    4a18:	00001097          	auipc	ra,0x1
    4a1c:	c3e080e7          	jalr	-962(ra) # 5656 <unlink>
      unlink(file);
    4a20:	fa840513          	addi	a0,s0,-88
    4a24:	00001097          	auipc	ra,0x1
    4a28:	c32080e7          	jalr	-974(ra) # 5656 <unlink>
      unlink(file);
    4a2c:	fa840513          	addi	a0,s0,-88
    4a30:	00001097          	auipc	ra,0x1
    4a34:	c26080e7          	jalr	-986(ra) # 5656 <unlink>
      unlink(file);
    4a38:	fa840513          	addi	a0,s0,-88
    4a3c:	00001097          	auipc	ra,0x1
    4a40:	c1a080e7          	jalr	-998(ra) # 5656 <unlink>
    4a44:	bfb5                	j	49c0 <concreate+0x24c>
      exit(0);
    4a46:	4501                	li	a0,0
    4a48:	00001097          	auipc	ra,0x1
    4a4c:	bbe080e7          	jalr	-1090(ra) # 5606 <exit>
      close(fd);
    4a50:	00001097          	auipc	ra,0x1
    4a54:	bde080e7          	jalr	-1058(ra) # 562e <close>
    if(pid == 0) {
    4a58:	bb5d                	j	480e <concreate+0x9a>
      close(fd);
    4a5a:	00001097          	auipc	ra,0x1
    4a5e:	bd4080e7          	jalr	-1068(ra) # 562e <close>
      wait(&xstatus);
    4a62:	f6c40513          	addi	a0,s0,-148
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	ba8080e7          	jalr	-1112(ra) # 560e <wait>
      if(xstatus != 0)
    4a6e:	f6c42483          	lw	s1,-148(s0)
    4a72:	da0493e3          	bnez	s1,4818 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4a76:	2905                	addiw	s2,s2,1
    4a78:	db4905e3          	beq	s2,s4,4822 <concreate+0xae>
    file[1] = '0' + i;
    4a7c:	0309079b          	addiw	a5,s2,48
    4a80:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4a84:	fa840513          	addi	a0,s0,-88
    4a88:	00001097          	auipc	ra,0x1
    4a8c:	bce080e7          	jalr	-1074(ra) # 5656 <unlink>
    pid = fork();
    4a90:	00001097          	auipc	ra,0x1
    4a94:	b6e080e7          	jalr	-1170(ra) # 55fe <fork>
    if(pid && (i % 3) == 1){
    4a98:	d20502e3          	beqz	a0,47bc <concreate+0x48>
    4a9c:	036967bb          	remw	a5,s2,s6
    4aa0:	d15786e3          	beq	a5,s5,47ac <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4aa4:	20200593          	li	a1,514
    4aa8:	fa840513          	addi	a0,s0,-88
    4aac:	00001097          	auipc	ra,0x1
    4ab0:	b9a080e7          	jalr	-1126(ra) # 5646 <open>
      if(fd < 0){
    4ab4:	fa0553e3          	bgez	a0,4a5a <concreate+0x2e6>
    4ab8:	b315                	j	47dc <concreate+0x68>
}
    4aba:	60ea                	ld	ra,152(sp)
    4abc:	644a                	ld	s0,144(sp)
    4abe:	64aa                	ld	s1,136(sp)
    4ac0:	690a                	ld	s2,128(sp)
    4ac2:	79e6                	ld	s3,120(sp)
    4ac4:	7a46                	ld	s4,112(sp)
    4ac6:	7aa6                	ld	s5,104(sp)
    4ac8:	7b06                	ld	s6,96(sp)
    4aca:	6be6                	ld	s7,88(sp)
    4acc:	610d                	addi	sp,sp,160
    4ace:	8082                	ret

0000000000004ad0 <bigfile>:
{
    4ad0:	7139                	addi	sp,sp,-64
    4ad2:	fc06                	sd	ra,56(sp)
    4ad4:	f822                	sd	s0,48(sp)
    4ad6:	f426                	sd	s1,40(sp)
    4ad8:	f04a                	sd	s2,32(sp)
    4ada:	ec4e                	sd	s3,24(sp)
    4adc:	e852                	sd	s4,16(sp)
    4ade:	e456                	sd	s5,8(sp)
    4ae0:	0080                	addi	s0,sp,64
    4ae2:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4ae4:	00003517          	auipc	a0,0x3
    4ae8:	dc450513          	addi	a0,a0,-572 # 78a8 <malloc+0x1e60>
    4aec:	00001097          	auipc	ra,0x1
    4af0:	b6a080e7          	jalr	-1174(ra) # 5656 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4af4:	20200593          	li	a1,514
    4af8:	00003517          	auipc	a0,0x3
    4afc:	db050513          	addi	a0,a0,-592 # 78a8 <malloc+0x1e60>
    4b00:	00001097          	auipc	ra,0x1
    4b04:	b46080e7          	jalr	-1210(ra) # 5646 <open>
    4b08:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4b0a:	4481                	li	s1,0
    memset(buf, i, SZ);
    4b0c:	00007917          	auipc	s2,0x7
    4b10:	fec90913          	addi	s2,s2,-20 # baf8 <buf>
  for(i = 0; i < N; i++){
    4b14:	4a51                	li	s4,20
  if(fd < 0){
    4b16:	0a054063          	bltz	a0,4bb6 <bigfile+0xe6>
    memset(buf, i, SZ);
    4b1a:	25800613          	li	a2,600
    4b1e:	85a6                	mv	a1,s1
    4b20:	854a                	mv	a0,s2
    4b22:	00001097          	auipc	ra,0x1
    4b26:	8ea080e7          	jalr	-1814(ra) # 540c <memset>
    if(write(fd, buf, SZ) != SZ){
    4b2a:	25800613          	li	a2,600
    4b2e:	85ca                	mv	a1,s2
    4b30:	854e                	mv	a0,s3
    4b32:	00001097          	auipc	ra,0x1
    4b36:	af4080e7          	jalr	-1292(ra) # 5626 <write>
    4b3a:	25800793          	li	a5,600
    4b3e:	08f51a63          	bne	a0,a5,4bd2 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4b42:	2485                	addiw	s1,s1,1
    4b44:	fd449be3          	bne	s1,s4,4b1a <bigfile+0x4a>
  close(fd);
    4b48:	854e                	mv	a0,s3
    4b4a:	00001097          	auipc	ra,0x1
    4b4e:	ae4080e7          	jalr	-1308(ra) # 562e <close>
  fd = open("bigfile.dat", 0);
    4b52:	4581                	li	a1,0
    4b54:	00003517          	auipc	a0,0x3
    4b58:	d5450513          	addi	a0,a0,-684 # 78a8 <malloc+0x1e60>
    4b5c:	00001097          	auipc	ra,0x1
    4b60:	aea080e7          	jalr	-1302(ra) # 5646 <open>
    4b64:	8a2a                	mv	s4,a0
  total = 0;
    4b66:	4981                	li	s3,0
  for(i = 0; ; i++){
    4b68:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4b6a:	00007917          	auipc	s2,0x7
    4b6e:	f8e90913          	addi	s2,s2,-114 # baf8 <buf>
  if(fd < 0){
    4b72:	06054e63          	bltz	a0,4bee <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4b76:	12c00613          	li	a2,300
    4b7a:	85ca                	mv	a1,s2
    4b7c:	8552                	mv	a0,s4
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	aa0080e7          	jalr	-1376(ra) # 561e <read>
    if(cc < 0){
    4b86:	08054263          	bltz	a0,4c0a <bigfile+0x13a>
    if(cc == 0)
    4b8a:	c971                	beqz	a0,4c5e <bigfile+0x18e>
    if(cc != SZ/2){
    4b8c:	12c00793          	li	a5,300
    4b90:	08f51b63          	bne	a0,a5,4c26 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4b94:	01f4d79b          	srliw	a5,s1,0x1f
    4b98:	9fa5                	addw	a5,a5,s1
    4b9a:	4017d79b          	sraiw	a5,a5,0x1
    4b9e:	00094703          	lbu	a4,0(s2)
    4ba2:	0af71063          	bne	a4,a5,4c42 <bigfile+0x172>
    4ba6:	12b94703          	lbu	a4,299(s2)
    4baa:	08f71c63          	bne	a4,a5,4c42 <bigfile+0x172>
    total += cc;
    4bae:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4bb2:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4bb4:	b7c9                	j	4b76 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4bb6:	85d6                	mv	a1,s5
    4bb8:	00003517          	auipc	a0,0x3
    4bbc:	d0050513          	addi	a0,a0,-768 # 78b8 <malloc+0x1e70>
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	dd0080e7          	jalr	-560(ra) # 5990 <printf>
    exit(1);
    4bc8:	4505                	li	a0,1
    4bca:	00001097          	auipc	ra,0x1
    4bce:	a3c080e7          	jalr	-1476(ra) # 5606 <exit>
      printf("%s: write bigfile failed\n", s);
    4bd2:	85d6                	mv	a1,s5
    4bd4:	00003517          	auipc	a0,0x3
    4bd8:	d0450513          	addi	a0,a0,-764 # 78d8 <malloc+0x1e90>
    4bdc:	00001097          	auipc	ra,0x1
    4be0:	db4080e7          	jalr	-588(ra) # 5990 <printf>
      exit(1);
    4be4:	4505                	li	a0,1
    4be6:	00001097          	auipc	ra,0x1
    4bea:	a20080e7          	jalr	-1504(ra) # 5606 <exit>
    printf("%s: cannot open bigfile\n", s);
    4bee:	85d6                	mv	a1,s5
    4bf0:	00003517          	auipc	a0,0x3
    4bf4:	d0850513          	addi	a0,a0,-760 # 78f8 <malloc+0x1eb0>
    4bf8:	00001097          	auipc	ra,0x1
    4bfc:	d98080e7          	jalr	-616(ra) # 5990 <printf>
    exit(1);
    4c00:	4505                	li	a0,1
    4c02:	00001097          	auipc	ra,0x1
    4c06:	a04080e7          	jalr	-1532(ra) # 5606 <exit>
      printf("%s: read bigfile failed\n", s);
    4c0a:	85d6                	mv	a1,s5
    4c0c:	00003517          	auipc	a0,0x3
    4c10:	d0c50513          	addi	a0,a0,-756 # 7918 <malloc+0x1ed0>
    4c14:	00001097          	auipc	ra,0x1
    4c18:	d7c080e7          	jalr	-644(ra) # 5990 <printf>
      exit(1);
    4c1c:	4505                	li	a0,1
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	9e8080e7          	jalr	-1560(ra) # 5606 <exit>
      printf("%s: short read bigfile\n", s);
    4c26:	85d6                	mv	a1,s5
    4c28:	00003517          	auipc	a0,0x3
    4c2c:	d1050513          	addi	a0,a0,-752 # 7938 <malloc+0x1ef0>
    4c30:	00001097          	auipc	ra,0x1
    4c34:	d60080e7          	jalr	-672(ra) # 5990 <printf>
      exit(1);
    4c38:	4505                	li	a0,1
    4c3a:	00001097          	auipc	ra,0x1
    4c3e:	9cc080e7          	jalr	-1588(ra) # 5606 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4c42:	85d6                	mv	a1,s5
    4c44:	00003517          	auipc	a0,0x3
    4c48:	d0c50513          	addi	a0,a0,-756 # 7950 <malloc+0x1f08>
    4c4c:	00001097          	auipc	ra,0x1
    4c50:	d44080e7          	jalr	-700(ra) # 5990 <printf>
      exit(1);
    4c54:	4505                	li	a0,1
    4c56:	00001097          	auipc	ra,0x1
    4c5a:	9b0080e7          	jalr	-1616(ra) # 5606 <exit>
  close(fd);
    4c5e:	8552                	mv	a0,s4
    4c60:	00001097          	auipc	ra,0x1
    4c64:	9ce080e7          	jalr	-1586(ra) # 562e <close>
  if(total != N*SZ){
    4c68:	678d                	lui	a5,0x3
    4c6a:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x4e>
    4c6e:	02f99363          	bne	s3,a5,4c94 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4c72:	00003517          	auipc	a0,0x3
    4c76:	c3650513          	addi	a0,a0,-970 # 78a8 <malloc+0x1e60>
    4c7a:	00001097          	auipc	ra,0x1
    4c7e:	9dc080e7          	jalr	-1572(ra) # 5656 <unlink>
}
    4c82:	70e2                	ld	ra,56(sp)
    4c84:	7442                	ld	s0,48(sp)
    4c86:	74a2                	ld	s1,40(sp)
    4c88:	7902                	ld	s2,32(sp)
    4c8a:	69e2                	ld	s3,24(sp)
    4c8c:	6a42                	ld	s4,16(sp)
    4c8e:	6aa2                	ld	s5,8(sp)
    4c90:	6121                	addi	sp,sp,64
    4c92:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4c94:	85d6                	mv	a1,s5
    4c96:	00003517          	auipc	a0,0x3
    4c9a:	cda50513          	addi	a0,a0,-806 # 7970 <malloc+0x1f28>
    4c9e:	00001097          	auipc	ra,0x1
    4ca2:	cf2080e7          	jalr	-782(ra) # 5990 <printf>
    exit(1);
    4ca6:	4505                	li	a0,1
    4ca8:	00001097          	auipc	ra,0x1
    4cac:	95e080e7          	jalr	-1698(ra) # 5606 <exit>

0000000000004cb0 <fsfull>:
{
    4cb0:	7171                	addi	sp,sp,-176
    4cb2:	f506                	sd	ra,168(sp)
    4cb4:	f122                	sd	s0,160(sp)
    4cb6:	ed26                	sd	s1,152(sp)
    4cb8:	e94a                	sd	s2,144(sp)
    4cba:	e54e                	sd	s3,136(sp)
    4cbc:	e152                	sd	s4,128(sp)
    4cbe:	fcd6                	sd	s5,120(sp)
    4cc0:	f8da                	sd	s6,112(sp)
    4cc2:	f4de                	sd	s7,104(sp)
    4cc4:	f0e2                	sd	s8,96(sp)
    4cc6:	ece6                	sd	s9,88(sp)
    4cc8:	e8ea                	sd	s10,80(sp)
    4cca:	e4ee                	sd	s11,72(sp)
    4ccc:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4cce:	00003517          	auipc	a0,0x3
    4cd2:	cc250513          	addi	a0,a0,-830 # 7990 <malloc+0x1f48>
    4cd6:	00001097          	auipc	ra,0x1
    4cda:	cba080e7          	jalr	-838(ra) # 5990 <printf>
  for(nfiles = 0; ; nfiles++){
    4cde:	4481                	li	s1,0
    name[0] = 'f';
    4ce0:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4ce4:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4ce8:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4cec:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4cee:	00003c97          	auipc	s9,0x3
    4cf2:	cb2c8c93          	addi	s9,s9,-846 # 79a0 <malloc+0x1f58>
    int total = 0;
    4cf6:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4cf8:	00007a17          	auipc	s4,0x7
    4cfc:	e00a0a13          	addi	s4,s4,-512 # baf8 <buf>
    name[0] = 'f';
    4d00:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d04:	0384c7bb          	divw	a5,s1,s8
    4d08:	0307879b          	addiw	a5,a5,48
    4d0c:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d10:	0384e7bb          	remw	a5,s1,s8
    4d14:	0377c7bb          	divw	a5,a5,s7
    4d18:	0307879b          	addiw	a5,a5,48
    4d1c:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d20:	0374e7bb          	remw	a5,s1,s7
    4d24:	0367c7bb          	divw	a5,a5,s6
    4d28:	0307879b          	addiw	a5,a5,48
    4d2c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d30:	0364e7bb          	remw	a5,s1,s6
    4d34:	0307879b          	addiw	a5,a5,48
    4d38:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4d3c:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4d40:	f5040593          	addi	a1,s0,-176
    4d44:	8566                	mv	a0,s9
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	c4a080e7          	jalr	-950(ra) # 5990 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4d4e:	20200593          	li	a1,514
    4d52:	f5040513          	addi	a0,s0,-176
    4d56:	00001097          	auipc	ra,0x1
    4d5a:	8f0080e7          	jalr	-1808(ra) # 5646 <open>
    4d5e:	892a                	mv	s2,a0
    if(fd < 0){
    4d60:	0a055663          	bgez	a0,4e0c <fsfull+0x15c>
      printf("open %s failed\n", name);
    4d64:	f5040593          	addi	a1,s0,-176
    4d68:	00003517          	auipc	a0,0x3
    4d6c:	c4850513          	addi	a0,a0,-952 # 79b0 <malloc+0x1f68>
    4d70:	00001097          	auipc	ra,0x1
    4d74:	c20080e7          	jalr	-992(ra) # 5990 <printf>
  while(nfiles >= 0){
    4d78:	0604c363          	bltz	s1,4dde <fsfull+0x12e>
    name[0] = 'f';
    4d7c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4d80:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d84:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d88:	4929                	li	s2,10
  while(nfiles >= 0){
    4d8a:	5afd                	li	s5,-1
    name[0] = 'f';
    4d8c:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d90:	0344c7bb          	divw	a5,s1,s4
    4d94:	0307879b          	addiw	a5,a5,48
    4d98:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d9c:	0344e7bb          	remw	a5,s1,s4
    4da0:	0337c7bb          	divw	a5,a5,s3
    4da4:	0307879b          	addiw	a5,a5,48
    4da8:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4dac:	0334e7bb          	remw	a5,s1,s3
    4db0:	0327c7bb          	divw	a5,a5,s2
    4db4:	0307879b          	addiw	a5,a5,48
    4db8:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4dbc:	0324e7bb          	remw	a5,s1,s2
    4dc0:	0307879b          	addiw	a5,a5,48
    4dc4:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4dc8:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4dcc:	f5040513          	addi	a0,s0,-176
    4dd0:	00001097          	auipc	ra,0x1
    4dd4:	886080e7          	jalr	-1914(ra) # 5656 <unlink>
    nfiles--;
    4dd8:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4dda:	fb5499e3          	bne	s1,s5,4d8c <fsfull+0xdc>
  printf("fsfull test finished\n");
    4dde:	00003517          	auipc	a0,0x3
    4de2:	bf250513          	addi	a0,a0,-1038 # 79d0 <malloc+0x1f88>
    4de6:	00001097          	auipc	ra,0x1
    4dea:	baa080e7          	jalr	-1110(ra) # 5990 <printf>
}
    4dee:	70aa                	ld	ra,168(sp)
    4df0:	740a                	ld	s0,160(sp)
    4df2:	64ea                	ld	s1,152(sp)
    4df4:	694a                	ld	s2,144(sp)
    4df6:	69aa                	ld	s3,136(sp)
    4df8:	6a0a                	ld	s4,128(sp)
    4dfa:	7ae6                	ld	s5,120(sp)
    4dfc:	7b46                	ld	s6,112(sp)
    4dfe:	7ba6                	ld	s7,104(sp)
    4e00:	7c06                	ld	s8,96(sp)
    4e02:	6ce6                	ld	s9,88(sp)
    4e04:	6d46                	ld	s10,80(sp)
    4e06:	6da6                	ld	s11,72(sp)
    4e08:	614d                	addi	sp,sp,176
    4e0a:	8082                	ret
    int total = 0;
    4e0c:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4e0e:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4e12:	40000613          	li	a2,1024
    4e16:	85d2                	mv	a1,s4
    4e18:	854a                	mv	a0,s2
    4e1a:	00001097          	auipc	ra,0x1
    4e1e:	80c080e7          	jalr	-2036(ra) # 5626 <write>
      if(cc < BSIZE)
    4e22:	00aad563          	bge	s5,a0,4e2c <fsfull+0x17c>
      total += cc;
    4e26:	00a989bb          	addw	s3,s3,a0
    while(1){
    4e2a:	b7e5                	j	4e12 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4e2c:	85ce                	mv	a1,s3
    4e2e:	00003517          	auipc	a0,0x3
    4e32:	b9250513          	addi	a0,a0,-1134 # 79c0 <malloc+0x1f78>
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	b5a080e7          	jalr	-1190(ra) # 5990 <printf>
    close(fd);
    4e3e:	854a                	mv	a0,s2
    4e40:	00000097          	auipc	ra,0x0
    4e44:	7ee080e7          	jalr	2030(ra) # 562e <close>
    if(total == 0)
    4e48:	f20988e3          	beqz	s3,4d78 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4e4c:	2485                	addiw	s1,s1,1
    4e4e:	bd4d                	j	4d00 <fsfull+0x50>

0000000000004e50 <rand>:
{
    4e50:	1141                	addi	sp,sp,-16
    4e52:	e422                	sd	s0,8(sp)
    4e54:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4e56:	00003717          	auipc	a4,0x3
    4e5a:	47a70713          	addi	a4,a4,1146 # 82d0 <randstate>
    4e5e:	6308                	ld	a0,0(a4)
    4e60:	001967b7          	lui	a5,0x196
    4e64:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187b05>
    4e68:	02f50533          	mul	a0,a0,a5
    4e6c:	3c6ef7b7          	lui	a5,0x3c6ef
    4e70:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0857>
    4e74:	953e                	add	a0,a0,a5
    4e76:	e308                	sd	a0,0(a4)
}
    4e78:	2501                	sext.w	a0,a0
    4e7a:	6422                	ld	s0,8(sp)
    4e7c:	0141                	addi	sp,sp,16
    4e7e:	8082                	ret

0000000000004e80 <badwrite>:
{
    4e80:	7179                	addi	sp,sp,-48
    4e82:	f406                	sd	ra,40(sp)
    4e84:	f022                	sd	s0,32(sp)
    4e86:	ec26                	sd	s1,24(sp)
    4e88:	e84a                	sd	s2,16(sp)
    4e8a:	e44e                	sd	s3,8(sp)
    4e8c:	e052                	sd	s4,0(sp)
    4e8e:	1800                	addi	s0,sp,48
  unlink("junk");
    4e90:	00003517          	auipc	a0,0x3
    4e94:	b5850513          	addi	a0,a0,-1192 # 79e8 <malloc+0x1fa0>
    4e98:	00000097          	auipc	ra,0x0
    4e9c:	7be080e7          	jalr	1982(ra) # 5656 <unlink>
    4ea0:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4ea4:	00003997          	auipc	s3,0x3
    4ea8:	b4498993          	addi	s3,s3,-1212 # 79e8 <malloc+0x1fa0>
    write(fd, (char*)0xffffffffffL, 1);
    4eac:	5a7d                	li	s4,-1
    4eae:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4eb2:	20100593          	li	a1,513
    4eb6:	854e                	mv	a0,s3
    4eb8:	00000097          	auipc	ra,0x0
    4ebc:	78e080e7          	jalr	1934(ra) # 5646 <open>
    4ec0:	84aa                	mv	s1,a0
    if(fd < 0){
    4ec2:	06054b63          	bltz	a0,4f38 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4ec6:	4605                	li	a2,1
    4ec8:	85d2                	mv	a1,s4
    4eca:	00000097          	auipc	ra,0x0
    4ece:	75c080e7          	jalr	1884(ra) # 5626 <write>
    close(fd);
    4ed2:	8526                	mv	a0,s1
    4ed4:	00000097          	auipc	ra,0x0
    4ed8:	75a080e7          	jalr	1882(ra) # 562e <close>
    unlink("junk");
    4edc:	854e                	mv	a0,s3
    4ede:	00000097          	auipc	ra,0x0
    4ee2:	778080e7          	jalr	1912(ra) # 5656 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4ee6:	397d                	addiw	s2,s2,-1
    4ee8:	fc0915e3          	bnez	s2,4eb2 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4eec:	20100593          	li	a1,513
    4ef0:	00003517          	auipc	a0,0x3
    4ef4:	af850513          	addi	a0,a0,-1288 # 79e8 <malloc+0x1fa0>
    4ef8:	00000097          	auipc	ra,0x0
    4efc:	74e080e7          	jalr	1870(ra) # 5646 <open>
    4f00:	84aa                	mv	s1,a0
  if(fd < 0){
    4f02:	04054863          	bltz	a0,4f52 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4f06:	4605                	li	a2,1
    4f08:	00001597          	auipc	a1,0x1
    4f0c:	cd058593          	addi	a1,a1,-816 # 5bd8 <malloc+0x190>
    4f10:	00000097          	auipc	ra,0x0
    4f14:	716080e7          	jalr	1814(ra) # 5626 <write>
    4f18:	4785                	li	a5,1
    4f1a:	04f50963          	beq	a0,a5,4f6c <badwrite+0xec>
    printf("write failed\n");
    4f1e:	00003517          	auipc	a0,0x3
    4f22:	aea50513          	addi	a0,a0,-1302 # 7a08 <malloc+0x1fc0>
    4f26:	00001097          	auipc	ra,0x1
    4f2a:	a6a080e7          	jalr	-1430(ra) # 5990 <printf>
    exit(1);
    4f2e:	4505                	li	a0,1
    4f30:	00000097          	auipc	ra,0x0
    4f34:	6d6080e7          	jalr	1750(ra) # 5606 <exit>
      printf("open junk failed\n");
    4f38:	00003517          	auipc	a0,0x3
    4f3c:	ab850513          	addi	a0,a0,-1352 # 79f0 <malloc+0x1fa8>
    4f40:	00001097          	auipc	ra,0x1
    4f44:	a50080e7          	jalr	-1456(ra) # 5990 <printf>
      exit(1);
    4f48:	4505                	li	a0,1
    4f4a:	00000097          	auipc	ra,0x0
    4f4e:	6bc080e7          	jalr	1724(ra) # 5606 <exit>
    printf("open junk failed\n");
    4f52:	00003517          	auipc	a0,0x3
    4f56:	a9e50513          	addi	a0,a0,-1378 # 79f0 <malloc+0x1fa8>
    4f5a:	00001097          	auipc	ra,0x1
    4f5e:	a36080e7          	jalr	-1482(ra) # 5990 <printf>
    exit(1);
    4f62:	4505                	li	a0,1
    4f64:	00000097          	auipc	ra,0x0
    4f68:	6a2080e7          	jalr	1698(ra) # 5606 <exit>
  close(fd);
    4f6c:	8526                	mv	a0,s1
    4f6e:	00000097          	auipc	ra,0x0
    4f72:	6c0080e7          	jalr	1728(ra) # 562e <close>
  unlink("junk");
    4f76:	00003517          	auipc	a0,0x3
    4f7a:	a7250513          	addi	a0,a0,-1422 # 79e8 <malloc+0x1fa0>
    4f7e:	00000097          	auipc	ra,0x0
    4f82:	6d8080e7          	jalr	1752(ra) # 5656 <unlink>
  exit(0);
    4f86:	4501                	li	a0,0
    4f88:	00000097          	auipc	ra,0x0
    4f8c:	67e080e7          	jalr	1662(ra) # 5606 <exit>

0000000000004f90 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4f90:	7139                	addi	sp,sp,-64
    4f92:	fc06                	sd	ra,56(sp)
    4f94:	f822                	sd	s0,48(sp)
    4f96:	f426                	sd	s1,40(sp)
    4f98:	f04a                	sd	s2,32(sp)
    4f9a:	ec4e                	sd	s3,24(sp)
    4f9c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4f9e:	fc840513          	addi	a0,s0,-56
    4fa2:	00000097          	auipc	ra,0x0
    4fa6:	674080e7          	jalr	1652(ra) # 5616 <pipe>
    4faa:	06054763          	bltz	a0,5018 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4fae:	00000097          	auipc	ra,0x0
    4fb2:	650080e7          	jalr	1616(ra) # 55fe <fork>

  if(pid < 0){
    4fb6:	06054e63          	bltz	a0,5032 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4fba:	ed51                	bnez	a0,5056 <countfree+0xc6>
    close(fds[0]);
    4fbc:	fc842503          	lw	a0,-56(s0)
    4fc0:	00000097          	auipc	ra,0x0
    4fc4:	66e080e7          	jalr	1646(ra) # 562e <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4fc8:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4fca:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4fcc:	00001997          	auipc	s3,0x1
    4fd0:	c0c98993          	addi	s3,s3,-1012 # 5bd8 <malloc+0x190>
      uint64 a = (uint64) sbrk(4096);
    4fd4:	6505                	lui	a0,0x1
    4fd6:	00000097          	auipc	ra,0x0
    4fda:	6b8080e7          	jalr	1720(ra) # 568e <sbrk>
      if(a == 0xffffffffffffffff){
    4fde:	07250763          	beq	a0,s2,504c <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4fe2:	6785                	lui	a5,0x1
    4fe4:	97aa                	add	a5,a5,a0
    4fe6:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x9f>
      if(write(fds[1], "x", 1) != 1){
    4fea:	8626                	mv	a2,s1
    4fec:	85ce                	mv	a1,s3
    4fee:	fcc42503          	lw	a0,-52(s0)
    4ff2:	00000097          	auipc	ra,0x0
    4ff6:	634080e7          	jalr	1588(ra) # 5626 <write>
    4ffa:	fc950de3          	beq	a0,s1,4fd4 <countfree+0x44>
        printf("write() failed in countfree()\n");
    4ffe:	00003517          	auipc	a0,0x3
    5002:	a5a50513          	addi	a0,a0,-1446 # 7a58 <malloc+0x2010>
    5006:	00001097          	auipc	ra,0x1
    500a:	98a080e7          	jalr	-1654(ra) # 5990 <printf>
        exit(1);
    500e:	4505                	li	a0,1
    5010:	00000097          	auipc	ra,0x0
    5014:	5f6080e7          	jalr	1526(ra) # 5606 <exit>
    printf("pipe() failed in countfree()\n");
    5018:	00003517          	auipc	a0,0x3
    501c:	a0050513          	addi	a0,a0,-1536 # 7a18 <malloc+0x1fd0>
    5020:	00001097          	auipc	ra,0x1
    5024:	970080e7          	jalr	-1680(ra) # 5990 <printf>
    exit(1);
    5028:	4505                	li	a0,1
    502a:	00000097          	auipc	ra,0x0
    502e:	5dc080e7          	jalr	1500(ra) # 5606 <exit>
    printf("fork failed in countfree()\n");
    5032:	00003517          	auipc	a0,0x3
    5036:	a0650513          	addi	a0,a0,-1530 # 7a38 <malloc+0x1ff0>
    503a:	00001097          	auipc	ra,0x1
    503e:	956080e7          	jalr	-1706(ra) # 5990 <printf>
    exit(1);
    5042:	4505                	li	a0,1
    5044:	00000097          	auipc	ra,0x0
    5048:	5c2080e7          	jalr	1474(ra) # 5606 <exit>
      }
    }

    exit(0);
    504c:	4501                	li	a0,0
    504e:	00000097          	auipc	ra,0x0
    5052:	5b8080e7          	jalr	1464(ra) # 5606 <exit>
  }

  close(fds[1]);
    5056:	fcc42503          	lw	a0,-52(s0)
    505a:	00000097          	auipc	ra,0x0
    505e:	5d4080e7          	jalr	1492(ra) # 562e <close>

  int n = 0;
    5062:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5064:	4605                	li	a2,1
    5066:	fc740593          	addi	a1,s0,-57
    506a:	fc842503          	lw	a0,-56(s0)
    506e:	00000097          	auipc	ra,0x0
    5072:	5b0080e7          	jalr	1456(ra) # 561e <read>
    if(cc < 0){
    5076:	00054563          	bltz	a0,5080 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    507a:	c105                	beqz	a0,509a <countfree+0x10a>
      break;
    n += 1;
    507c:	2485                	addiw	s1,s1,1
  while(1){
    507e:	b7dd                	j	5064 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5080:	00003517          	auipc	a0,0x3
    5084:	9f850513          	addi	a0,a0,-1544 # 7a78 <malloc+0x2030>
    5088:	00001097          	auipc	ra,0x1
    508c:	908080e7          	jalr	-1784(ra) # 5990 <printf>
      exit(1);
    5090:	4505                	li	a0,1
    5092:	00000097          	auipc	ra,0x0
    5096:	574080e7          	jalr	1396(ra) # 5606 <exit>
  }

  close(fds[0]);
    509a:	fc842503          	lw	a0,-56(s0)
    509e:	00000097          	auipc	ra,0x0
    50a2:	590080e7          	jalr	1424(ra) # 562e <close>
  wait((int*)0);
    50a6:	4501                	li	a0,0
    50a8:	00000097          	auipc	ra,0x0
    50ac:	566080e7          	jalr	1382(ra) # 560e <wait>
  
  return n;
}
    50b0:	8526                	mv	a0,s1
    50b2:	70e2                	ld	ra,56(sp)
    50b4:	7442                	ld	s0,48(sp)
    50b6:	74a2                	ld	s1,40(sp)
    50b8:	7902                	ld	s2,32(sp)
    50ba:	69e2                	ld	s3,24(sp)
    50bc:	6121                	addi	sp,sp,64
    50be:	8082                	ret

00000000000050c0 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    50c0:	7179                	addi	sp,sp,-48
    50c2:	f406                	sd	ra,40(sp)
    50c4:	f022                	sd	s0,32(sp)
    50c6:	ec26                	sd	s1,24(sp)
    50c8:	e84a                	sd	s2,16(sp)
    50ca:	1800                	addi	s0,sp,48
    50cc:	84aa                	mv	s1,a0
    50ce:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    50d0:	00003517          	auipc	a0,0x3
    50d4:	9c850513          	addi	a0,a0,-1592 # 7a98 <malloc+0x2050>
    50d8:	00001097          	auipc	ra,0x1
    50dc:	8b8080e7          	jalr	-1864(ra) # 5990 <printf>
  if((pid = fork()) < 0) {
    50e0:	00000097          	auipc	ra,0x0
    50e4:	51e080e7          	jalr	1310(ra) # 55fe <fork>
    50e8:	02054e63          	bltz	a0,5124 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    50ec:	c929                	beqz	a0,513e <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    50ee:	fdc40513          	addi	a0,s0,-36
    50f2:	00000097          	auipc	ra,0x0
    50f6:	51c080e7          	jalr	1308(ra) # 560e <wait>
    if(xstatus != 0) 
    50fa:	fdc42783          	lw	a5,-36(s0)
    50fe:	c7b9                	beqz	a5,514c <run+0x8c>
      printf("FAILED\n");
    5100:	00003517          	auipc	a0,0x3
    5104:	9c050513          	addi	a0,a0,-1600 # 7ac0 <malloc+0x2078>
    5108:	00001097          	auipc	ra,0x1
    510c:	888080e7          	jalr	-1912(ra) # 5990 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5110:	fdc42503          	lw	a0,-36(s0)
  }
}
    5114:	00153513          	seqz	a0,a0
    5118:	70a2                	ld	ra,40(sp)
    511a:	7402                	ld	s0,32(sp)
    511c:	64e2                	ld	s1,24(sp)
    511e:	6942                	ld	s2,16(sp)
    5120:	6145                	addi	sp,sp,48
    5122:	8082                	ret
    printf("runtest: fork error\n");
    5124:	00003517          	auipc	a0,0x3
    5128:	98450513          	addi	a0,a0,-1660 # 7aa8 <malloc+0x2060>
    512c:	00001097          	auipc	ra,0x1
    5130:	864080e7          	jalr	-1948(ra) # 5990 <printf>
    exit(1);
    5134:	4505                	li	a0,1
    5136:	00000097          	auipc	ra,0x0
    513a:	4d0080e7          	jalr	1232(ra) # 5606 <exit>
    f(s);
    513e:	854a                	mv	a0,s2
    5140:	9482                	jalr	s1
    exit(0);
    5142:	4501                	li	a0,0
    5144:	00000097          	auipc	ra,0x0
    5148:	4c2080e7          	jalr	1218(ra) # 5606 <exit>
      printf("OK\n");
    514c:	00003517          	auipc	a0,0x3
    5150:	97c50513          	addi	a0,a0,-1668 # 7ac8 <malloc+0x2080>
    5154:	00001097          	auipc	ra,0x1
    5158:	83c080e7          	jalr	-1988(ra) # 5990 <printf>
    515c:	bf55                	j	5110 <run+0x50>

000000000000515e <main>:

int
main(int argc, char *argv[])
{
    515e:	c1010113          	addi	sp,sp,-1008
    5162:	3e113423          	sd	ra,1000(sp)
    5166:	3e813023          	sd	s0,992(sp)
    516a:	3c913c23          	sd	s1,984(sp)
    516e:	3d213823          	sd	s2,976(sp)
    5172:	3d313423          	sd	s3,968(sp)
    5176:	3d413023          	sd	s4,960(sp)
    517a:	3b513c23          	sd	s5,952(sp)
    517e:	3b613823          	sd	s6,944(sp)
    5182:	1f80                	addi	s0,sp,1008
    5184:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5186:	4789                	li	a5,2
    5188:	08f50b63          	beq	a0,a5,521e <main+0xc0>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    518c:	4785                	li	a5,1
  char *justone = 0;
    518e:	4901                	li	s2,0
  } else if(argc > 1){
    5190:	0ca7c563          	blt	a5,a0,525a <main+0xfc>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5194:	00003797          	auipc	a5,0x3
    5198:	d0c78793          	addi	a5,a5,-756 # 7ea0 <malloc+0x2458>
    519c:	c1040713          	addi	a4,s0,-1008
    51a0:	00003817          	auipc	a6,0x3
    51a4:	0a080813          	addi	a6,a6,160 # 8240 <malloc+0x27f8>
    51a8:	6388                	ld	a0,0(a5)
    51aa:	678c                	ld	a1,8(a5)
    51ac:	6b90                	ld	a2,16(a5)
    51ae:	6f94                	ld	a3,24(a5)
    51b0:	e308                	sd	a0,0(a4)
    51b2:	e70c                	sd	a1,8(a4)
    51b4:	eb10                	sd	a2,16(a4)
    51b6:	ef14                	sd	a3,24(a4)
    51b8:	02078793          	addi	a5,a5,32
    51bc:	02070713          	addi	a4,a4,32
    51c0:	ff0794e3          	bne	a5,a6,51a8 <main+0x4a>
    51c4:	6394                	ld	a3,0(a5)
    51c6:	679c                	ld	a5,8(a5)
    51c8:	e314                	sd	a3,0(a4)
    51ca:	e71c                	sd	a5,8(a4)
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    51cc:	00003517          	auipc	a0,0x3
    51d0:	9b450513          	addi	a0,a0,-1612 # 7b80 <malloc+0x2138>
    51d4:	00000097          	auipc	ra,0x0
    51d8:	7bc080e7          	jalr	1980(ra) # 5990 <printf>
  int free0 = countfree();
    51dc:	00000097          	auipc	ra,0x0
    51e0:	db4080e7          	jalr	-588(ra) # 4f90 <countfree>
    51e4:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    51e6:	c1843503          	ld	a0,-1000(s0)
    51ea:	c1040493          	addi	s1,s0,-1008
  int fail = 0;
    51ee:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    51f0:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    51f2:	e55d                	bnez	a0,52a0 <main+0x142>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    51f4:	00000097          	auipc	ra,0x0
    51f8:	d9c080e7          	jalr	-612(ra) # 4f90 <countfree>
    51fc:	85aa                	mv	a1,a0
    51fe:	0f455163          	bge	a0,s4,52e0 <main+0x182>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5202:	8652                	mv	a2,s4
    5204:	00003517          	auipc	a0,0x3
    5208:	93450513          	addi	a0,a0,-1740 # 7b38 <malloc+0x20f0>
    520c:	00000097          	auipc	ra,0x0
    5210:	784080e7          	jalr	1924(ra) # 5990 <printf>
    exit(1);
    5214:	4505                	li	a0,1
    5216:	00000097          	auipc	ra,0x0
    521a:	3f0080e7          	jalr	1008(ra) # 5606 <exit>
    521e:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5220:	00003597          	auipc	a1,0x3
    5224:	8b058593          	addi	a1,a1,-1872 # 7ad0 <malloc+0x2088>
    5228:	6488                	ld	a0,8(s1)
    522a:	00000097          	auipc	ra,0x0
    522e:	18c080e7          	jalr	396(ra) # 53b6 <strcmp>
    5232:	10050563          	beqz	a0,533c <main+0x1de>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5236:	00003597          	auipc	a1,0x3
    523a:	98258593          	addi	a1,a1,-1662 # 7bb8 <malloc+0x2170>
    523e:	6488                	ld	a0,8(s1)
    5240:	00000097          	auipc	ra,0x0
    5244:	176080e7          	jalr	374(ra) # 53b6 <strcmp>
    5248:	c97d                	beqz	a0,533e <main+0x1e0>
  } else if(argc == 2 && argv[1][0] != '-'){
    524a:	0084b903          	ld	s2,8(s1)
    524e:	00094703          	lbu	a4,0(s2)
    5252:	02d00793          	li	a5,45
    5256:	f2f71fe3          	bne	a4,a5,5194 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    525a:	00003517          	auipc	a0,0x3
    525e:	87e50513          	addi	a0,a0,-1922 # 7ad8 <malloc+0x2090>
    5262:	00000097          	auipc	ra,0x0
    5266:	72e080e7          	jalr	1838(ra) # 5990 <printf>
    exit(1);
    526a:	4505                	li	a0,1
    526c:	00000097          	auipc	ra,0x0
    5270:	39a080e7          	jalr	922(ra) # 5606 <exit>
          exit(1);
    5274:	4505                	li	a0,1
    5276:	00000097          	auipc	ra,0x0
    527a:	390080e7          	jalr	912(ra) # 5606 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    527e:	40a905bb          	subw	a1,s2,a0
    5282:	855a                	mv	a0,s6
    5284:	00000097          	auipc	ra,0x0
    5288:	70c080e7          	jalr	1804(ra) # 5990 <printf>
        if(continuous != 2)
    528c:	09498463          	beq	s3,s4,5314 <main+0x1b6>
          exit(1);
    5290:	4505                	li	a0,1
    5292:	00000097          	auipc	ra,0x0
    5296:	374080e7          	jalr	884(ra) # 5606 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    529a:	04c1                	addi	s1,s1,16
    529c:	6488                	ld	a0,8(s1)
    529e:	c115                	beqz	a0,52c2 <main+0x164>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    52a0:	00090863          	beqz	s2,52b0 <main+0x152>
    52a4:	85ca                	mv	a1,s2
    52a6:	00000097          	auipc	ra,0x0
    52aa:	110080e7          	jalr	272(ra) # 53b6 <strcmp>
    52ae:	f575                	bnez	a0,529a <main+0x13c>
      if(!run(t->f, t->s))
    52b0:	648c                	ld	a1,8(s1)
    52b2:	6088                	ld	a0,0(s1)
    52b4:	00000097          	auipc	ra,0x0
    52b8:	e0c080e7          	jalr	-500(ra) # 50c0 <run>
    52bc:	fd79                	bnez	a0,529a <main+0x13c>
        fail = 1;
    52be:	89d6                	mv	s3,s5
    52c0:	bfe9                	j	529a <main+0x13c>
  if(fail){
    52c2:	f20989e3          	beqz	s3,51f4 <main+0x96>
    printf("SOME TESTS FAILED\n");
    52c6:	00003517          	auipc	a0,0x3
    52ca:	85a50513          	addi	a0,a0,-1958 # 7b20 <malloc+0x20d8>
    52ce:	00000097          	auipc	ra,0x0
    52d2:	6c2080e7          	jalr	1730(ra) # 5990 <printf>
    exit(1);
    52d6:	4505                	li	a0,1
    52d8:	00000097          	auipc	ra,0x0
    52dc:	32e080e7          	jalr	814(ra) # 5606 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    52e0:	00003517          	auipc	a0,0x3
    52e4:	88850513          	addi	a0,a0,-1912 # 7b68 <malloc+0x2120>
    52e8:	00000097          	auipc	ra,0x0
    52ec:	6a8080e7          	jalr	1704(ra) # 5990 <printf>
    exit(0);
    52f0:	4501                	li	a0,0
    52f2:	00000097          	auipc	ra,0x0
    52f6:	314080e7          	jalr	788(ra) # 5606 <exit>
        printf("SOME TESTS FAILED\n");
    52fa:	8556                	mv	a0,s5
    52fc:	00000097          	auipc	ra,0x0
    5300:	694080e7          	jalr	1684(ra) # 5990 <printf>
        if(continuous != 2)
    5304:	f74998e3          	bne	s3,s4,5274 <main+0x116>
      int free1 = countfree();
    5308:	00000097          	auipc	ra,0x0
    530c:	c88080e7          	jalr	-888(ra) # 4f90 <countfree>
      if(free1 < free0){
    5310:	f72547e3          	blt	a0,s2,527e <main+0x120>
      int free0 = countfree();
    5314:	00000097          	auipc	ra,0x0
    5318:	c7c080e7          	jalr	-900(ra) # 4f90 <countfree>
    531c:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    531e:	c1843583          	ld	a1,-1000(s0)
    5322:	d1fd                	beqz	a1,5308 <main+0x1aa>
    5324:	c1040493          	addi	s1,s0,-1008
        if(!run(t->f, t->s)){
    5328:	6088                	ld	a0,0(s1)
    532a:	00000097          	auipc	ra,0x0
    532e:	d96080e7          	jalr	-618(ra) # 50c0 <run>
    5332:	d561                	beqz	a0,52fa <main+0x19c>
      for (struct test *t = tests; t->s != 0; t++) {
    5334:	04c1                	addi	s1,s1,16
    5336:	648c                	ld	a1,8(s1)
    5338:	f9e5                	bnez	a1,5328 <main+0x1ca>
    533a:	b7f9                	j	5308 <main+0x1aa>
    continuous = 1;
    533c:	4985                	li	s3,1
  } tests[] = {
    533e:	00003797          	auipc	a5,0x3
    5342:	b6278793          	addi	a5,a5,-1182 # 7ea0 <malloc+0x2458>
    5346:	c1040713          	addi	a4,s0,-1008
    534a:	00003817          	auipc	a6,0x3
    534e:	ef680813          	addi	a6,a6,-266 # 8240 <malloc+0x27f8>
    5352:	6388                	ld	a0,0(a5)
    5354:	678c                	ld	a1,8(a5)
    5356:	6b90                	ld	a2,16(a5)
    5358:	6f94                	ld	a3,24(a5)
    535a:	e308                	sd	a0,0(a4)
    535c:	e70c                	sd	a1,8(a4)
    535e:	eb10                	sd	a2,16(a4)
    5360:	ef14                	sd	a3,24(a4)
    5362:	02078793          	addi	a5,a5,32
    5366:	02070713          	addi	a4,a4,32
    536a:	ff0794e3          	bne	a5,a6,5352 <main+0x1f4>
    536e:	6394                	ld	a3,0(a5)
    5370:	679c                	ld	a5,8(a5)
    5372:	e314                	sd	a3,0(a4)
    5374:	e71c                	sd	a5,8(a4)
    printf("continuous usertests starting\n");
    5376:	00003517          	auipc	a0,0x3
    537a:	82250513          	addi	a0,a0,-2014 # 7b98 <malloc+0x2150>
    537e:	00000097          	auipc	ra,0x0
    5382:	612080e7          	jalr	1554(ra) # 5990 <printf>
        printf("SOME TESTS FAILED\n");
    5386:	00002a97          	auipc	s5,0x2
    538a:	79aa8a93          	addi	s5,s5,1946 # 7b20 <malloc+0x20d8>
        if(continuous != 2)
    538e:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5390:	00002b17          	auipc	s6,0x2
    5394:	770b0b13          	addi	s6,s6,1904 # 7b00 <malloc+0x20b8>
    5398:	bfb5                	j	5314 <main+0x1b6>

000000000000539a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    539a:	1141                	addi	sp,sp,-16
    539c:	e422                	sd	s0,8(sp)
    539e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    53a0:	87aa                	mv	a5,a0
    53a2:	0585                	addi	a1,a1,1
    53a4:	0785                	addi	a5,a5,1
    53a6:	fff5c703          	lbu	a4,-1(a1)
    53aa:	fee78fa3          	sb	a4,-1(a5)
    53ae:	fb75                	bnez	a4,53a2 <strcpy+0x8>
    ;
  return os;
}
    53b0:	6422                	ld	s0,8(sp)
    53b2:	0141                	addi	sp,sp,16
    53b4:	8082                	ret

00000000000053b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    53b6:	1141                	addi	sp,sp,-16
    53b8:	e422                	sd	s0,8(sp)
    53ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    53bc:	00054783          	lbu	a5,0(a0)
    53c0:	cb91                	beqz	a5,53d4 <strcmp+0x1e>
    53c2:	0005c703          	lbu	a4,0(a1)
    53c6:	00f71763          	bne	a4,a5,53d4 <strcmp+0x1e>
    p++, q++;
    53ca:	0505                	addi	a0,a0,1
    53cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    53ce:	00054783          	lbu	a5,0(a0)
    53d2:	fbe5                	bnez	a5,53c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    53d4:	0005c503          	lbu	a0,0(a1)
}
    53d8:	40a7853b          	subw	a0,a5,a0
    53dc:	6422                	ld	s0,8(sp)
    53de:	0141                	addi	sp,sp,16
    53e0:	8082                	ret

00000000000053e2 <strlen>:

uint
strlen(const char *s)
{
    53e2:	1141                	addi	sp,sp,-16
    53e4:	e422                	sd	s0,8(sp)
    53e6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    53e8:	00054783          	lbu	a5,0(a0)
    53ec:	cf91                	beqz	a5,5408 <strlen+0x26>
    53ee:	0505                	addi	a0,a0,1
    53f0:	87aa                	mv	a5,a0
    53f2:	4685                	li	a3,1
    53f4:	9e89                	subw	a3,a3,a0
    53f6:	00f6853b          	addw	a0,a3,a5
    53fa:	0785                	addi	a5,a5,1
    53fc:	fff7c703          	lbu	a4,-1(a5)
    5400:	fb7d                	bnez	a4,53f6 <strlen+0x14>
    ;
  return n;
}
    5402:	6422                	ld	s0,8(sp)
    5404:	0141                	addi	sp,sp,16
    5406:	8082                	ret
  for(n = 0; s[n]; n++)
    5408:	4501                	li	a0,0
    540a:	bfe5                	j	5402 <strlen+0x20>

000000000000540c <memset>:

void*
memset(void *dst, int c, uint n)
{
    540c:	1141                	addi	sp,sp,-16
    540e:	e422                	sd	s0,8(sp)
    5410:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5412:	ca19                	beqz	a2,5428 <memset+0x1c>
    5414:	87aa                	mv	a5,a0
    5416:	1602                	slli	a2,a2,0x20
    5418:	9201                	srli	a2,a2,0x20
    541a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    541e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5422:	0785                	addi	a5,a5,1
    5424:	fee79de3          	bne	a5,a4,541e <memset+0x12>
  }
  return dst;
}
    5428:	6422                	ld	s0,8(sp)
    542a:	0141                	addi	sp,sp,16
    542c:	8082                	ret

000000000000542e <strchr>:

char*
strchr(const char *s, char c)
{
    542e:	1141                	addi	sp,sp,-16
    5430:	e422                	sd	s0,8(sp)
    5432:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5434:	00054783          	lbu	a5,0(a0)
    5438:	cb99                	beqz	a5,544e <strchr+0x20>
    if(*s == c)
    543a:	00f58763          	beq	a1,a5,5448 <strchr+0x1a>
  for(; *s; s++)
    543e:	0505                	addi	a0,a0,1
    5440:	00054783          	lbu	a5,0(a0)
    5444:	fbfd                	bnez	a5,543a <strchr+0xc>
      return (char*)s;
  return 0;
    5446:	4501                	li	a0,0
}
    5448:	6422                	ld	s0,8(sp)
    544a:	0141                	addi	sp,sp,16
    544c:	8082                	ret
  return 0;
    544e:	4501                	li	a0,0
    5450:	bfe5                	j	5448 <strchr+0x1a>

0000000000005452 <gets>:

char*
gets(char *buf, int max)
{
    5452:	711d                	addi	sp,sp,-96
    5454:	ec86                	sd	ra,88(sp)
    5456:	e8a2                	sd	s0,80(sp)
    5458:	e4a6                	sd	s1,72(sp)
    545a:	e0ca                	sd	s2,64(sp)
    545c:	fc4e                	sd	s3,56(sp)
    545e:	f852                	sd	s4,48(sp)
    5460:	f456                	sd	s5,40(sp)
    5462:	f05a                	sd	s6,32(sp)
    5464:	ec5e                	sd	s7,24(sp)
    5466:	1080                	addi	s0,sp,96
    5468:	8baa                	mv	s7,a0
    546a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    546c:	892a                	mv	s2,a0
    546e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5470:	4aa9                	li	s5,10
    5472:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5474:	89a6                	mv	s3,s1
    5476:	2485                	addiw	s1,s1,1
    5478:	0344d863          	bge	s1,s4,54a8 <gets+0x56>
    cc = read(0, &c, 1);
    547c:	4605                	li	a2,1
    547e:	faf40593          	addi	a1,s0,-81
    5482:	4501                	li	a0,0
    5484:	00000097          	auipc	ra,0x0
    5488:	19a080e7          	jalr	410(ra) # 561e <read>
    if(cc < 1)
    548c:	00a05e63          	blez	a0,54a8 <gets+0x56>
    buf[i++] = c;
    5490:	faf44783          	lbu	a5,-81(s0)
    5494:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5498:	01578763          	beq	a5,s5,54a6 <gets+0x54>
    549c:	0905                	addi	s2,s2,1
    549e:	fd679be3          	bne	a5,s6,5474 <gets+0x22>
  for(i=0; i+1 < max; ){
    54a2:	89a6                	mv	s3,s1
    54a4:	a011                	j	54a8 <gets+0x56>
    54a6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    54a8:	99de                	add	s3,s3,s7
    54aa:	00098023          	sb	zero,0(s3)
  return buf;
}
    54ae:	855e                	mv	a0,s7
    54b0:	60e6                	ld	ra,88(sp)
    54b2:	6446                	ld	s0,80(sp)
    54b4:	64a6                	ld	s1,72(sp)
    54b6:	6906                	ld	s2,64(sp)
    54b8:	79e2                	ld	s3,56(sp)
    54ba:	7a42                	ld	s4,48(sp)
    54bc:	7aa2                	ld	s5,40(sp)
    54be:	7b02                	ld	s6,32(sp)
    54c0:	6be2                	ld	s7,24(sp)
    54c2:	6125                	addi	sp,sp,96
    54c4:	8082                	ret

00000000000054c6 <stat>:

int
stat(const char *n, struct stat *st)
{
    54c6:	1101                	addi	sp,sp,-32
    54c8:	ec06                	sd	ra,24(sp)
    54ca:	e822                	sd	s0,16(sp)
    54cc:	e426                	sd	s1,8(sp)
    54ce:	e04a                	sd	s2,0(sp)
    54d0:	1000                	addi	s0,sp,32
    54d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    54d4:	4581                	li	a1,0
    54d6:	00000097          	auipc	ra,0x0
    54da:	170080e7          	jalr	368(ra) # 5646 <open>
  if(fd < 0)
    54de:	02054563          	bltz	a0,5508 <stat+0x42>
    54e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    54e4:	85ca                	mv	a1,s2
    54e6:	00000097          	auipc	ra,0x0
    54ea:	178080e7          	jalr	376(ra) # 565e <fstat>
    54ee:	892a                	mv	s2,a0
  close(fd);
    54f0:	8526                	mv	a0,s1
    54f2:	00000097          	auipc	ra,0x0
    54f6:	13c080e7          	jalr	316(ra) # 562e <close>
  return r;
}
    54fa:	854a                	mv	a0,s2
    54fc:	60e2                	ld	ra,24(sp)
    54fe:	6442                	ld	s0,16(sp)
    5500:	64a2                	ld	s1,8(sp)
    5502:	6902                	ld	s2,0(sp)
    5504:	6105                	addi	sp,sp,32
    5506:	8082                	ret
    return -1;
    5508:	597d                	li	s2,-1
    550a:	bfc5                	j	54fa <stat+0x34>

000000000000550c <atoi>:

int
atoi(const char *s)
{
    550c:	1141                	addi	sp,sp,-16
    550e:	e422                	sd	s0,8(sp)
    5510:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5512:	00054683          	lbu	a3,0(a0)
    5516:	fd06879b          	addiw	a5,a3,-48
    551a:	0ff7f793          	zext.b	a5,a5
    551e:	4625                	li	a2,9
    5520:	02f66863          	bltu	a2,a5,5550 <atoi+0x44>
    5524:	872a                	mv	a4,a0
  n = 0;
    5526:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5528:	0705                	addi	a4,a4,1
    552a:	0025179b          	slliw	a5,a0,0x2
    552e:	9fa9                	addw	a5,a5,a0
    5530:	0017979b          	slliw	a5,a5,0x1
    5534:	9fb5                	addw	a5,a5,a3
    5536:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    553a:	00074683          	lbu	a3,0(a4)
    553e:	fd06879b          	addiw	a5,a3,-48
    5542:	0ff7f793          	zext.b	a5,a5
    5546:	fef671e3          	bgeu	a2,a5,5528 <atoi+0x1c>
  return n;
}
    554a:	6422                	ld	s0,8(sp)
    554c:	0141                	addi	sp,sp,16
    554e:	8082                	ret
  n = 0;
    5550:	4501                	li	a0,0
    5552:	bfe5                	j	554a <atoi+0x3e>

0000000000005554 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5554:	1141                	addi	sp,sp,-16
    5556:	e422                	sd	s0,8(sp)
    5558:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    555a:	02b57463          	bgeu	a0,a1,5582 <memmove+0x2e>
    while(n-- > 0)
    555e:	00c05f63          	blez	a2,557c <memmove+0x28>
    5562:	1602                	slli	a2,a2,0x20
    5564:	9201                	srli	a2,a2,0x20
    5566:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    556a:	872a                	mv	a4,a0
      *dst++ = *src++;
    556c:	0585                	addi	a1,a1,1
    556e:	0705                	addi	a4,a4,1
    5570:	fff5c683          	lbu	a3,-1(a1)
    5574:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5578:	fee79ae3          	bne	a5,a4,556c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    557c:	6422                	ld	s0,8(sp)
    557e:	0141                	addi	sp,sp,16
    5580:	8082                	ret
    dst += n;
    5582:	00c50733          	add	a4,a0,a2
    src += n;
    5586:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5588:	fec05ae3          	blez	a2,557c <memmove+0x28>
    558c:	fff6079b          	addiw	a5,a2,-1 # 2fff <dirtest+0x85>
    5590:	1782                	slli	a5,a5,0x20
    5592:	9381                	srli	a5,a5,0x20
    5594:	fff7c793          	not	a5,a5
    5598:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    559a:	15fd                	addi	a1,a1,-1
    559c:	177d                	addi	a4,a4,-1
    559e:	0005c683          	lbu	a3,0(a1)
    55a2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    55a6:	fee79ae3          	bne	a5,a4,559a <memmove+0x46>
    55aa:	bfc9                	j	557c <memmove+0x28>

00000000000055ac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    55ac:	1141                	addi	sp,sp,-16
    55ae:	e422                	sd	s0,8(sp)
    55b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    55b2:	ca05                	beqz	a2,55e2 <memcmp+0x36>
    55b4:	fff6069b          	addiw	a3,a2,-1
    55b8:	1682                	slli	a3,a3,0x20
    55ba:	9281                	srli	a3,a3,0x20
    55bc:	0685                	addi	a3,a3,1
    55be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    55c0:	00054783          	lbu	a5,0(a0)
    55c4:	0005c703          	lbu	a4,0(a1)
    55c8:	00e79863          	bne	a5,a4,55d8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    55cc:	0505                	addi	a0,a0,1
    p2++;
    55ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    55d0:	fed518e3          	bne	a0,a3,55c0 <memcmp+0x14>
  }
  return 0;
    55d4:	4501                	li	a0,0
    55d6:	a019                	j	55dc <memcmp+0x30>
      return *p1 - *p2;
    55d8:	40e7853b          	subw	a0,a5,a4
}
    55dc:	6422                	ld	s0,8(sp)
    55de:	0141                	addi	sp,sp,16
    55e0:	8082                	ret
  return 0;
    55e2:	4501                	li	a0,0
    55e4:	bfe5                	j	55dc <memcmp+0x30>

00000000000055e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    55e6:	1141                	addi	sp,sp,-16
    55e8:	e406                	sd	ra,8(sp)
    55ea:	e022                	sd	s0,0(sp)
    55ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    55ee:	00000097          	auipc	ra,0x0
    55f2:	f66080e7          	jalr	-154(ra) # 5554 <memmove>
}
    55f6:	60a2                	ld	ra,8(sp)
    55f8:	6402                	ld	s0,0(sp)
    55fa:	0141                	addi	sp,sp,16
    55fc:	8082                	ret

00000000000055fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    55fe:	4885                	li	a7,1
 ecall
    5600:	00000073          	ecall
 ret
    5604:	8082                	ret

0000000000005606 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5606:	4889                	li	a7,2
 ecall
    5608:	00000073          	ecall
 ret
    560c:	8082                	ret

000000000000560e <wait>:
.global wait
wait:
 li a7, SYS_wait
    560e:	488d                	li	a7,3
 ecall
    5610:	00000073          	ecall
 ret
    5614:	8082                	ret

0000000000005616 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5616:	4891                	li	a7,4
 ecall
    5618:	00000073          	ecall
 ret
    561c:	8082                	ret

000000000000561e <read>:
.global read
read:
 li a7, SYS_read
    561e:	4895                	li	a7,5
 ecall
    5620:	00000073          	ecall
 ret
    5624:	8082                	ret

0000000000005626 <write>:
.global write
write:
 li a7, SYS_write
    5626:	48c1                	li	a7,16
 ecall
    5628:	00000073          	ecall
 ret
    562c:	8082                	ret

000000000000562e <close>:
.global close
close:
 li a7, SYS_close
    562e:	48d5                	li	a7,21
 ecall
    5630:	00000073          	ecall
 ret
    5634:	8082                	ret

0000000000005636 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5636:	4899                	li	a7,6
 ecall
    5638:	00000073          	ecall
 ret
    563c:	8082                	ret

000000000000563e <exec>:
.global exec
exec:
 li a7, SYS_exec
    563e:	489d                	li	a7,7
 ecall
    5640:	00000073          	ecall
 ret
    5644:	8082                	ret

0000000000005646 <open>:
.global open
open:
 li a7, SYS_open
    5646:	48bd                	li	a7,15
 ecall
    5648:	00000073          	ecall
 ret
    564c:	8082                	ret

000000000000564e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    564e:	48c5                	li	a7,17
 ecall
    5650:	00000073          	ecall
 ret
    5654:	8082                	ret

0000000000005656 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5656:	48c9                	li	a7,18
 ecall
    5658:	00000073          	ecall
 ret
    565c:	8082                	ret

000000000000565e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    565e:	48a1                	li	a7,8
 ecall
    5660:	00000073          	ecall
 ret
    5664:	8082                	ret

0000000000005666 <link>:
.global link
link:
 li a7, SYS_link
    5666:	48cd                	li	a7,19
 ecall
    5668:	00000073          	ecall
 ret
    566c:	8082                	ret

000000000000566e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    566e:	48d1                	li	a7,20
 ecall
    5670:	00000073          	ecall
 ret
    5674:	8082                	ret

0000000000005676 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5676:	48a5                	li	a7,9
 ecall
    5678:	00000073          	ecall
 ret
    567c:	8082                	ret

000000000000567e <dup>:
.global dup
dup:
 li a7, SYS_dup
    567e:	48a9                	li	a7,10
 ecall
    5680:	00000073          	ecall
 ret
    5684:	8082                	ret

0000000000005686 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5686:	48ad                	li	a7,11
 ecall
    5688:	00000073          	ecall
 ret
    568c:	8082                	ret

000000000000568e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    568e:	48b1                	li	a7,12
 ecall
    5690:	00000073          	ecall
 ret
    5694:	8082                	ret

0000000000005696 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5696:	48b5                	li	a7,13
 ecall
    5698:	00000073          	ecall
 ret
    569c:	8082                	ret

000000000000569e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    569e:	48b9                	li	a7,14
 ecall
    56a0:	00000073          	ecall
 ret
    56a4:	8082                	ret

00000000000056a6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
    56a6:	48d9                	li	a7,22
 ecall
    56a8:	00000073          	ecall
 ret
    56ac:	8082                	ret

00000000000056ae <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    56ae:	48dd                	li	a7,23
 ecall
    56b0:	00000073          	ecall
 ret
    56b4:	8082                	ret

00000000000056b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    56b6:	1101                	addi	sp,sp,-32
    56b8:	ec06                	sd	ra,24(sp)
    56ba:	e822                	sd	s0,16(sp)
    56bc:	1000                	addi	s0,sp,32
    56be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    56c2:	4605                	li	a2,1
    56c4:	fef40593          	addi	a1,s0,-17
    56c8:	00000097          	auipc	ra,0x0
    56cc:	f5e080e7          	jalr	-162(ra) # 5626 <write>
}
    56d0:	60e2                	ld	ra,24(sp)
    56d2:	6442                	ld	s0,16(sp)
    56d4:	6105                	addi	sp,sp,32
    56d6:	8082                	ret

00000000000056d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    56d8:	7139                	addi	sp,sp,-64
    56da:	fc06                	sd	ra,56(sp)
    56dc:	f822                	sd	s0,48(sp)
    56de:	f426                	sd	s1,40(sp)
    56e0:	f04a                	sd	s2,32(sp)
    56e2:	ec4e                	sd	s3,24(sp)
    56e4:	0080                	addi	s0,sp,64
    56e6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    56e8:	c299                	beqz	a3,56ee <printint+0x16>
    56ea:	0805c963          	bltz	a1,577c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    56ee:	2581                	sext.w	a1,a1
  neg = 0;
    56f0:	4881                	li	a7,0
    56f2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    56f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    56f8:	2601                	sext.w	a2,a2
    56fa:	00003517          	auipc	a0,0x3
    56fe:	bb650513          	addi	a0,a0,-1098 # 82b0 <digits>
    5702:	883a                	mv	a6,a4
    5704:	2705                	addiw	a4,a4,1
    5706:	02c5f7bb          	remuw	a5,a1,a2
    570a:	1782                	slli	a5,a5,0x20
    570c:	9381                	srli	a5,a5,0x20
    570e:	97aa                	add	a5,a5,a0
    5710:	0007c783          	lbu	a5,0(a5)
    5714:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5718:	0005879b          	sext.w	a5,a1
    571c:	02c5d5bb          	divuw	a1,a1,a2
    5720:	0685                	addi	a3,a3,1
    5722:	fec7f0e3          	bgeu	a5,a2,5702 <printint+0x2a>
  if(neg)
    5726:	00088c63          	beqz	a7,573e <printint+0x66>
    buf[i++] = '-';
    572a:	fd070793          	addi	a5,a4,-48
    572e:	00878733          	add	a4,a5,s0
    5732:	02d00793          	li	a5,45
    5736:	fef70823          	sb	a5,-16(a4)
    573a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    573e:	02e05863          	blez	a4,576e <printint+0x96>
    5742:	fc040793          	addi	a5,s0,-64
    5746:	00e78933          	add	s2,a5,a4
    574a:	fff78993          	addi	s3,a5,-1
    574e:	99ba                	add	s3,s3,a4
    5750:	377d                	addiw	a4,a4,-1
    5752:	1702                	slli	a4,a4,0x20
    5754:	9301                	srli	a4,a4,0x20
    5756:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    575a:	fff94583          	lbu	a1,-1(s2)
    575e:	8526                	mv	a0,s1
    5760:	00000097          	auipc	ra,0x0
    5764:	f56080e7          	jalr	-170(ra) # 56b6 <putc>
  while(--i >= 0)
    5768:	197d                	addi	s2,s2,-1
    576a:	ff3918e3          	bne	s2,s3,575a <printint+0x82>
}
    576e:	70e2                	ld	ra,56(sp)
    5770:	7442                	ld	s0,48(sp)
    5772:	74a2                	ld	s1,40(sp)
    5774:	7902                	ld	s2,32(sp)
    5776:	69e2                	ld	s3,24(sp)
    5778:	6121                	addi	sp,sp,64
    577a:	8082                	ret
    x = -xx;
    577c:	40b005bb          	negw	a1,a1
    neg = 1;
    5780:	4885                	li	a7,1
    x = -xx;
    5782:	bf85                	j	56f2 <printint+0x1a>

0000000000005784 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5784:	7119                	addi	sp,sp,-128
    5786:	fc86                	sd	ra,120(sp)
    5788:	f8a2                	sd	s0,112(sp)
    578a:	f4a6                	sd	s1,104(sp)
    578c:	f0ca                	sd	s2,96(sp)
    578e:	ecce                	sd	s3,88(sp)
    5790:	e8d2                	sd	s4,80(sp)
    5792:	e4d6                	sd	s5,72(sp)
    5794:	e0da                	sd	s6,64(sp)
    5796:	fc5e                	sd	s7,56(sp)
    5798:	f862                	sd	s8,48(sp)
    579a:	f466                	sd	s9,40(sp)
    579c:	f06a                	sd	s10,32(sp)
    579e:	ec6e                	sd	s11,24(sp)
    57a0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    57a2:	0005c903          	lbu	s2,0(a1)
    57a6:	18090f63          	beqz	s2,5944 <vprintf+0x1c0>
    57aa:	8aaa                	mv	s5,a0
    57ac:	8b32                	mv	s6,a2
    57ae:	00158493          	addi	s1,a1,1
  state = 0;
    57b2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    57b4:	02500a13          	li	s4,37
    57b8:	4c55                	li	s8,21
    57ba:	00003c97          	auipc	s9,0x3
    57be:	a9ec8c93          	addi	s9,s9,-1378 # 8258 <malloc+0x2810>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    57c2:	02800d93          	li	s11,40
  putc(fd, 'x');
    57c6:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    57c8:	00003b97          	auipc	s7,0x3
    57cc:	ae8b8b93          	addi	s7,s7,-1304 # 82b0 <digits>
    57d0:	a839                	j	57ee <vprintf+0x6a>
        putc(fd, c);
    57d2:	85ca                	mv	a1,s2
    57d4:	8556                	mv	a0,s5
    57d6:	00000097          	auipc	ra,0x0
    57da:	ee0080e7          	jalr	-288(ra) # 56b6 <putc>
    57de:	a019                	j	57e4 <vprintf+0x60>
    } else if(state == '%'){
    57e0:	01498d63          	beq	s3,s4,57fa <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    57e4:	0485                	addi	s1,s1,1
    57e6:	fff4c903          	lbu	s2,-1(s1)
    57ea:	14090d63          	beqz	s2,5944 <vprintf+0x1c0>
    if(state == 0){
    57ee:	fe0999e3          	bnez	s3,57e0 <vprintf+0x5c>
      if(c == '%'){
    57f2:	ff4910e3          	bne	s2,s4,57d2 <vprintf+0x4e>
        state = '%';
    57f6:	89d2                	mv	s3,s4
    57f8:	b7f5                	j	57e4 <vprintf+0x60>
      if(c == 'd'){
    57fa:	11490c63          	beq	s2,s4,5912 <vprintf+0x18e>
    57fe:	f9d9079b          	addiw	a5,s2,-99
    5802:	0ff7f793          	zext.b	a5,a5
    5806:	10fc6e63          	bltu	s8,a5,5922 <vprintf+0x19e>
    580a:	f9d9079b          	addiw	a5,s2,-99
    580e:	0ff7f713          	zext.b	a4,a5
    5812:	10ec6863          	bltu	s8,a4,5922 <vprintf+0x19e>
    5816:	00271793          	slli	a5,a4,0x2
    581a:	97e6                	add	a5,a5,s9
    581c:	439c                	lw	a5,0(a5)
    581e:	97e6                	add	a5,a5,s9
    5820:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5822:	008b0913          	addi	s2,s6,8
    5826:	4685                	li	a3,1
    5828:	4629                	li	a2,10
    582a:	000b2583          	lw	a1,0(s6)
    582e:	8556                	mv	a0,s5
    5830:	00000097          	auipc	ra,0x0
    5834:	ea8080e7          	jalr	-344(ra) # 56d8 <printint>
    5838:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    583a:	4981                	li	s3,0
    583c:	b765                	j	57e4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    583e:	008b0913          	addi	s2,s6,8
    5842:	4681                	li	a3,0
    5844:	4629                	li	a2,10
    5846:	000b2583          	lw	a1,0(s6)
    584a:	8556                	mv	a0,s5
    584c:	00000097          	auipc	ra,0x0
    5850:	e8c080e7          	jalr	-372(ra) # 56d8 <printint>
    5854:	8b4a                	mv	s6,s2
      state = 0;
    5856:	4981                	li	s3,0
    5858:	b771                	j	57e4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    585a:	008b0913          	addi	s2,s6,8
    585e:	4681                	li	a3,0
    5860:	866a                	mv	a2,s10
    5862:	000b2583          	lw	a1,0(s6)
    5866:	8556                	mv	a0,s5
    5868:	00000097          	auipc	ra,0x0
    586c:	e70080e7          	jalr	-400(ra) # 56d8 <printint>
    5870:	8b4a                	mv	s6,s2
      state = 0;
    5872:	4981                	li	s3,0
    5874:	bf85                	j	57e4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5876:	008b0793          	addi	a5,s6,8
    587a:	f8f43423          	sd	a5,-120(s0)
    587e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5882:	03000593          	li	a1,48
    5886:	8556                	mv	a0,s5
    5888:	00000097          	auipc	ra,0x0
    588c:	e2e080e7          	jalr	-466(ra) # 56b6 <putc>
  putc(fd, 'x');
    5890:	07800593          	li	a1,120
    5894:	8556                	mv	a0,s5
    5896:	00000097          	auipc	ra,0x0
    589a:	e20080e7          	jalr	-480(ra) # 56b6 <putc>
    589e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    58a0:	03c9d793          	srli	a5,s3,0x3c
    58a4:	97de                	add	a5,a5,s7
    58a6:	0007c583          	lbu	a1,0(a5)
    58aa:	8556                	mv	a0,s5
    58ac:	00000097          	auipc	ra,0x0
    58b0:	e0a080e7          	jalr	-502(ra) # 56b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    58b4:	0992                	slli	s3,s3,0x4
    58b6:	397d                	addiw	s2,s2,-1
    58b8:	fe0914e3          	bnez	s2,58a0 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    58bc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    58c0:	4981                	li	s3,0
    58c2:	b70d                	j	57e4 <vprintf+0x60>
        s = va_arg(ap, char*);
    58c4:	008b0913          	addi	s2,s6,8
    58c8:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    58cc:	02098163          	beqz	s3,58ee <vprintf+0x16a>
        while(*s != 0){
    58d0:	0009c583          	lbu	a1,0(s3)
    58d4:	c5ad                	beqz	a1,593e <vprintf+0x1ba>
          putc(fd, *s);
    58d6:	8556                	mv	a0,s5
    58d8:	00000097          	auipc	ra,0x0
    58dc:	dde080e7          	jalr	-546(ra) # 56b6 <putc>
          s++;
    58e0:	0985                	addi	s3,s3,1
        while(*s != 0){
    58e2:	0009c583          	lbu	a1,0(s3)
    58e6:	f9e5                	bnez	a1,58d6 <vprintf+0x152>
        s = va_arg(ap, char*);
    58e8:	8b4a                	mv	s6,s2
      state = 0;
    58ea:	4981                	li	s3,0
    58ec:	bde5                	j	57e4 <vprintf+0x60>
          s = "(null)";
    58ee:	00003997          	auipc	s3,0x3
    58f2:	96298993          	addi	s3,s3,-1694 # 8250 <malloc+0x2808>
        while(*s != 0){
    58f6:	85ee                	mv	a1,s11
    58f8:	bff9                	j	58d6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    58fa:	008b0913          	addi	s2,s6,8
    58fe:	000b4583          	lbu	a1,0(s6)
    5902:	8556                	mv	a0,s5
    5904:	00000097          	auipc	ra,0x0
    5908:	db2080e7          	jalr	-590(ra) # 56b6 <putc>
    590c:	8b4a                	mv	s6,s2
      state = 0;
    590e:	4981                	li	s3,0
    5910:	bdd1                	j	57e4 <vprintf+0x60>
        putc(fd, c);
    5912:	85d2                	mv	a1,s4
    5914:	8556                	mv	a0,s5
    5916:	00000097          	auipc	ra,0x0
    591a:	da0080e7          	jalr	-608(ra) # 56b6 <putc>
      state = 0;
    591e:	4981                	li	s3,0
    5920:	b5d1                	j	57e4 <vprintf+0x60>
        putc(fd, '%');
    5922:	85d2                	mv	a1,s4
    5924:	8556                	mv	a0,s5
    5926:	00000097          	auipc	ra,0x0
    592a:	d90080e7          	jalr	-624(ra) # 56b6 <putc>
        putc(fd, c);
    592e:	85ca                	mv	a1,s2
    5930:	8556                	mv	a0,s5
    5932:	00000097          	auipc	ra,0x0
    5936:	d84080e7          	jalr	-636(ra) # 56b6 <putc>
      state = 0;
    593a:	4981                	li	s3,0
    593c:	b565                	j	57e4 <vprintf+0x60>
        s = va_arg(ap, char*);
    593e:	8b4a                	mv	s6,s2
      state = 0;
    5940:	4981                	li	s3,0
    5942:	b54d                	j	57e4 <vprintf+0x60>
    }
  }
}
    5944:	70e6                	ld	ra,120(sp)
    5946:	7446                	ld	s0,112(sp)
    5948:	74a6                	ld	s1,104(sp)
    594a:	7906                	ld	s2,96(sp)
    594c:	69e6                	ld	s3,88(sp)
    594e:	6a46                	ld	s4,80(sp)
    5950:	6aa6                	ld	s5,72(sp)
    5952:	6b06                	ld	s6,64(sp)
    5954:	7be2                	ld	s7,56(sp)
    5956:	7c42                	ld	s8,48(sp)
    5958:	7ca2                	ld	s9,40(sp)
    595a:	7d02                	ld	s10,32(sp)
    595c:	6de2                	ld	s11,24(sp)
    595e:	6109                	addi	sp,sp,128
    5960:	8082                	ret

0000000000005962 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5962:	715d                	addi	sp,sp,-80
    5964:	ec06                	sd	ra,24(sp)
    5966:	e822                	sd	s0,16(sp)
    5968:	1000                	addi	s0,sp,32
    596a:	e010                	sd	a2,0(s0)
    596c:	e414                	sd	a3,8(s0)
    596e:	e818                	sd	a4,16(s0)
    5970:	ec1c                	sd	a5,24(s0)
    5972:	03043023          	sd	a6,32(s0)
    5976:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    597a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    597e:	8622                	mv	a2,s0
    5980:	00000097          	auipc	ra,0x0
    5984:	e04080e7          	jalr	-508(ra) # 5784 <vprintf>
}
    5988:	60e2                	ld	ra,24(sp)
    598a:	6442                	ld	s0,16(sp)
    598c:	6161                	addi	sp,sp,80
    598e:	8082                	ret

0000000000005990 <printf>:

void
printf(const char *fmt, ...)
{
    5990:	711d                	addi	sp,sp,-96
    5992:	ec06                	sd	ra,24(sp)
    5994:	e822                	sd	s0,16(sp)
    5996:	1000                	addi	s0,sp,32
    5998:	e40c                	sd	a1,8(s0)
    599a:	e810                	sd	a2,16(s0)
    599c:	ec14                	sd	a3,24(s0)
    599e:	f018                	sd	a4,32(s0)
    59a0:	f41c                	sd	a5,40(s0)
    59a2:	03043823          	sd	a6,48(s0)
    59a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    59aa:	00840613          	addi	a2,s0,8
    59ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    59b2:	85aa                	mv	a1,a0
    59b4:	4505                	li	a0,1
    59b6:	00000097          	auipc	ra,0x0
    59ba:	dce080e7          	jalr	-562(ra) # 5784 <vprintf>
}
    59be:	60e2                	ld	ra,24(sp)
    59c0:	6442                	ld	s0,16(sp)
    59c2:	6125                	addi	sp,sp,96
    59c4:	8082                	ret

00000000000059c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    59c6:	1141                	addi	sp,sp,-16
    59c8:	e422                	sd	s0,8(sp)
    59ca:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    59cc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    59d0:	00003797          	auipc	a5,0x3
    59d4:	9087b783          	ld	a5,-1784(a5) # 82d8 <freep>
    59d8:	a02d                	j	5a02 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    59da:	4618                	lw	a4,8(a2)
    59dc:	9f2d                	addw	a4,a4,a1
    59de:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    59e2:	6398                	ld	a4,0(a5)
    59e4:	6310                	ld	a2,0(a4)
    59e6:	a83d                	j	5a24 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    59e8:	ff852703          	lw	a4,-8(a0)
    59ec:	9f31                	addw	a4,a4,a2
    59ee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    59f0:	ff053683          	ld	a3,-16(a0)
    59f4:	a091                	j	5a38 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    59f6:	6398                	ld	a4,0(a5)
    59f8:	00e7e463          	bltu	a5,a4,5a00 <free+0x3a>
    59fc:	00e6ea63          	bltu	a3,a4,5a10 <free+0x4a>
{
    5a00:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a02:	fed7fae3          	bgeu	a5,a3,59f6 <free+0x30>
    5a06:	6398                	ld	a4,0(a5)
    5a08:	00e6e463          	bltu	a3,a4,5a10 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5a0c:	fee7eae3          	bltu	a5,a4,5a00 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5a10:	ff852583          	lw	a1,-8(a0)
    5a14:	6390                	ld	a2,0(a5)
    5a16:	02059813          	slli	a6,a1,0x20
    5a1a:	01c85713          	srli	a4,a6,0x1c
    5a1e:	9736                	add	a4,a4,a3
    5a20:	fae60de3          	beq	a2,a4,59da <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5a24:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5a28:	4790                	lw	a2,8(a5)
    5a2a:	02061593          	slli	a1,a2,0x20
    5a2e:	01c5d713          	srli	a4,a1,0x1c
    5a32:	973e                	add	a4,a4,a5
    5a34:	fae68ae3          	beq	a3,a4,59e8 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5a38:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5a3a:	00003717          	auipc	a4,0x3
    5a3e:	88f73f23          	sd	a5,-1890(a4) # 82d8 <freep>
}
    5a42:	6422                	ld	s0,8(sp)
    5a44:	0141                	addi	sp,sp,16
    5a46:	8082                	ret

0000000000005a48 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5a48:	7139                	addi	sp,sp,-64
    5a4a:	fc06                	sd	ra,56(sp)
    5a4c:	f822                	sd	s0,48(sp)
    5a4e:	f426                	sd	s1,40(sp)
    5a50:	f04a                	sd	s2,32(sp)
    5a52:	ec4e                	sd	s3,24(sp)
    5a54:	e852                	sd	s4,16(sp)
    5a56:	e456                	sd	s5,8(sp)
    5a58:	e05a                	sd	s6,0(sp)
    5a5a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5a5c:	02051493          	slli	s1,a0,0x20
    5a60:	9081                	srli	s1,s1,0x20
    5a62:	04bd                	addi	s1,s1,15
    5a64:	8091                	srli	s1,s1,0x4
    5a66:	0014899b          	addiw	s3,s1,1
    5a6a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5a6c:	00003517          	auipc	a0,0x3
    5a70:	86c53503          	ld	a0,-1940(a0) # 82d8 <freep>
    5a74:	c515                	beqz	a0,5aa0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5a76:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5a78:	4798                	lw	a4,8(a5)
    5a7a:	02977f63          	bgeu	a4,s1,5ab8 <malloc+0x70>
    5a7e:	8a4e                	mv	s4,s3
    5a80:	0009871b          	sext.w	a4,s3
    5a84:	6685                	lui	a3,0x1
    5a86:	00d77363          	bgeu	a4,a3,5a8c <malloc+0x44>
    5a8a:	6a05                	lui	s4,0x1
    5a8c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5a90:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5a94:	00003917          	auipc	s2,0x3
    5a98:	84490913          	addi	s2,s2,-1980 # 82d8 <freep>
  if(p == (char*)-1)
    5a9c:	5afd                	li	s5,-1
    5a9e:	a895                	j	5b12 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5aa0:	00009797          	auipc	a5,0x9
    5aa4:	05878793          	addi	a5,a5,88 # eaf8 <base>
    5aa8:	00003717          	auipc	a4,0x3
    5aac:	82f73823          	sd	a5,-2000(a4) # 82d8 <freep>
    5ab0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5ab2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5ab6:	b7e1                	j	5a7e <malloc+0x36>
      if(p->s.size == nunits)
    5ab8:	02e48c63          	beq	s1,a4,5af0 <malloc+0xa8>
        p->s.size -= nunits;
    5abc:	4137073b          	subw	a4,a4,s3
    5ac0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5ac2:	02071693          	slli	a3,a4,0x20
    5ac6:	01c6d713          	srli	a4,a3,0x1c
    5aca:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5acc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5ad0:	00003717          	auipc	a4,0x3
    5ad4:	80a73423          	sd	a0,-2040(a4) # 82d8 <freep>
      return (void*)(p + 1);
    5ad8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5adc:	70e2                	ld	ra,56(sp)
    5ade:	7442                	ld	s0,48(sp)
    5ae0:	74a2                	ld	s1,40(sp)
    5ae2:	7902                	ld	s2,32(sp)
    5ae4:	69e2                	ld	s3,24(sp)
    5ae6:	6a42                	ld	s4,16(sp)
    5ae8:	6aa2                	ld	s5,8(sp)
    5aea:	6b02                	ld	s6,0(sp)
    5aec:	6121                	addi	sp,sp,64
    5aee:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5af0:	6398                	ld	a4,0(a5)
    5af2:	e118                	sd	a4,0(a0)
    5af4:	bff1                	j	5ad0 <malloc+0x88>
  hp->s.size = nu;
    5af6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5afa:	0541                	addi	a0,a0,16
    5afc:	00000097          	auipc	ra,0x0
    5b00:	eca080e7          	jalr	-310(ra) # 59c6 <free>
  return freep;
    5b04:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5b08:	d971                	beqz	a0,5adc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5b0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5b0c:	4798                	lw	a4,8(a5)
    5b0e:	fa9775e3          	bgeu	a4,s1,5ab8 <malloc+0x70>
    if(p == freep)
    5b12:	00093703          	ld	a4,0(s2)
    5b16:	853e                	mv	a0,a5
    5b18:	fef719e3          	bne	a4,a5,5b0a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5b1c:	8552                	mv	a0,s4
    5b1e:	00000097          	auipc	ra,0x0
    5b22:	b70080e7          	jalr	-1168(ra) # 568e <sbrk>
  if(p == (char*)-1)
    5b26:	fd5518e3          	bne	a0,s5,5af6 <malloc+0xae>
        return 0;
    5b2a:	4501                	li	a0,0
    5b2c:	bf45                	j	5adc <malloc+0x94>
