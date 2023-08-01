
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d45c>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x22e6>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd62b>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	66850513          	addi	a0,a0,1640 # 16c8 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7119                	addi	sp,sp,-128
      7a:	fc86                	sd	ra,120(sp)
      7c:	f8a2                	sd	s0,112(sp)
      7e:	f4a6                	sd	s1,104(sp)
      80:	f0ca                	sd	s2,96(sp)
      82:	ecce                	sd	s3,88(sp)
      84:	e8d2                	sd	s4,80(sp)
      86:	e4d6                	sd	s5,72(sp)
      88:	e0da                	sd	s6,64(sp)
      8a:	fc5e                	sd	s7,56(sp)
      8c:	0100                	addi	s0,sp,128
      8e:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      90:	4501                	li	a0,0
      92:	00001097          	auipc	ra,0x1
      96:	dde080e7          	jalr	-546(ra) # e70 <sbrk>
      9a:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9c:	00001517          	auipc	a0,0x1
      a0:	27450513          	addi	a0,a0,628 # 1310 <malloc+0xe6>
      a4:	00001097          	auipc	ra,0x1
      a8:	dac080e7          	jalr	-596(ra) # e50 <mkdir>
  if(chdir("grindir") != 0){
      ac:	00001517          	auipc	a0,0x1
      b0:	26450513          	addi	a0,a0,612 # 1310 <malloc+0xe6>
      b4:	00001097          	auipc	ra,0x1
      b8:	da4080e7          	jalr	-604(ra) # e58 <chdir>
      bc:	cd11                	beqz	a0,d8 <go+0x60>
    printf("grind: chdir grindir failed\n");
      be:	00001517          	auipc	a0,0x1
      c2:	25a50513          	addi	a0,a0,602 # 1318 <malloc+0xee>
      c6:	00001097          	auipc	ra,0x1
      ca:	0ac080e7          	jalr	172(ra) # 1172 <printf>
    exit(1);
      ce:	4505                	li	a0,1
      d0:	00001097          	auipc	ra,0x1
      d4:	d18080e7          	jalr	-744(ra) # de8 <exit>
  }
  chdir("/");
      d8:	00001517          	auipc	a0,0x1
      dc:	26050513          	addi	a0,a0,608 # 1338 <malloc+0x10e>
      e0:	00001097          	auipc	ra,0x1
      e4:	d78080e7          	jalr	-648(ra) # e58 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e8:	00001997          	auipc	s3,0x1
      ec:	26098993          	addi	s3,s3,608 # 1348 <malloc+0x11e>
      f0:	c489                	beqz	s1,fa <go+0x82>
      f2:	00001997          	auipc	s3,0x1
      f6:	24e98993          	addi	s3,s3,590 # 1340 <malloc+0x116>
    iters++;
      fa:	4485                	li	s1,1
  int fd = -1;
      fc:	5a7d                	li	s4,-1
      fe:	00001917          	auipc	s2,0x1
     102:	4f290913          	addi	s2,s2,1266 # 15f0 <malloc+0x3c6>
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     106:	00001b17          	auipc	s6,0x1
     10a:	5d2b0b13          	addi	s6,s6,1490 # 16d8 <buf.0>
     10e:	a825                	j	146 <go+0xce>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     110:	20200593          	li	a1,514
     114:	00001517          	auipc	a0,0x1
     118:	23c50513          	addi	a0,a0,572 # 1350 <malloc+0x126>
     11c:	00001097          	auipc	ra,0x1
     120:	d0c080e7          	jalr	-756(ra) # e28 <open>
     124:	00001097          	auipc	ra,0x1
     128:	cec080e7          	jalr	-788(ra) # e10 <close>
    iters++;
     12c:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     12e:	1f400793          	li	a5,500
     132:	02f4f7b3          	remu	a5,s1,a5
     136:	eb81                	bnez	a5,146 <go+0xce>
      write(1, which_child?"B":"A", 1);
     138:	4605                	li	a2,1
     13a:	85ce                	mv	a1,s3
     13c:	4505                	li	a0,1
     13e:	00001097          	auipc	ra,0x1
     142:	cca080e7          	jalr	-822(ra) # e08 <write>
    int what = rand() % 23;
     146:	00000097          	auipc	ra,0x0
     14a:	f12080e7          	jalr	-238(ra) # 58 <rand>
     14e:	47dd                	li	a5,23
     150:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     154:	4785                	li	a5,1
     156:	faf50de3          	beq	a0,a5,110 <go+0x98>
    } else if(what == 2){
     15a:	47d9                	li	a5,22
     15c:	fca7e8e3          	bltu	a5,a0,12c <go+0xb4>
     160:	050a                	slli	a0,a0,0x2
     162:	954a                	add	a0,a0,s2
     164:	411c                	lw	a5,0(a0)
     166:	97ca                	add	a5,a5,s2
     168:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     16a:	20200593          	li	a1,514
     16e:	00001517          	auipc	a0,0x1
     172:	1f250513          	addi	a0,a0,498 # 1360 <malloc+0x136>
     176:	00001097          	auipc	ra,0x1
     17a:	cb2080e7          	jalr	-846(ra) # e28 <open>
     17e:	00001097          	auipc	ra,0x1
     182:	c92080e7          	jalr	-878(ra) # e10 <close>
     186:	b75d                	j	12c <go+0xb4>
      unlink("grindir/../a");
     188:	00001517          	auipc	a0,0x1
     18c:	1c850513          	addi	a0,a0,456 # 1350 <malloc+0x126>
     190:	00001097          	auipc	ra,0x1
     194:	ca8080e7          	jalr	-856(ra) # e38 <unlink>
     198:	bf51                	j	12c <go+0xb4>
      if(chdir("grindir") != 0){
     19a:	00001517          	auipc	a0,0x1
     19e:	17650513          	addi	a0,a0,374 # 1310 <malloc+0xe6>
     1a2:	00001097          	auipc	ra,0x1
     1a6:	cb6080e7          	jalr	-842(ra) # e58 <chdir>
     1aa:	e115                	bnez	a0,1ce <go+0x156>
      unlink("../b");
     1ac:	00001517          	auipc	a0,0x1
     1b0:	1cc50513          	addi	a0,a0,460 # 1378 <malloc+0x14e>
     1b4:	00001097          	auipc	ra,0x1
     1b8:	c84080e7          	jalr	-892(ra) # e38 <unlink>
      chdir("/");
     1bc:	00001517          	auipc	a0,0x1
     1c0:	17c50513          	addi	a0,a0,380 # 1338 <malloc+0x10e>
     1c4:	00001097          	auipc	ra,0x1
     1c8:	c94080e7          	jalr	-876(ra) # e58 <chdir>
     1cc:	b785                	j	12c <go+0xb4>
        printf("grind: chdir grindir failed\n");
     1ce:	00001517          	auipc	a0,0x1
     1d2:	14a50513          	addi	a0,a0,330 # 1318 <malloc+0xee>
     1d6:	00001097          	auipc	ra,0x1
     1da:	f9c080e7          	jalr	-100(ra) # 1172 <printf>
        exit(1);
     1de:	4505                	li	a0,1
     1e0:	00001097          	auipc	ra,0x1
     1e4:	c08080e7          	jalr	-1016(ra) # de8 <exit>
      close(fd);
     1e8:	8552                	mv	a0,s4
     1ea:	00001097          	auipc	ra,0x1
     1ee:	c26080e7          	jalr	-986(ra) # e10 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1f2:	20200593          	li	a1,514
     1f6:	00001517          	auipc	a0,0x1
     1fa:	18a50513          	addi	a0,a0,394 # 1380 <malloc+0x156>
     1fe:	00001097          	auipc	ra,0x1
     202:	c2a080e7          	jalr	-982(ra) # e28 <open>
     206:	8a2a                	mv	s4,a0
     208:	b715                	j	12c <go+0xb4>
      close(fd);
     20a:	8552                	mv	a0,s4
     20c:	00001097          	auipc	ra,0x1
     210:	c04080e7          	jalr	-1020(ra) # e10 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     214:	20200593          	li	a1,514
     218:	00001517          	auipc	a0,0x1
     21c:	17850513          	addi	a0,a0,376 # 1390 <malloc+0x166>
     220:	00001097          	auipc	ra,0x1
     224:	c08080e7          	jalr	-1016(ra) # e28 <open>
     228:	8a2a                	mv	s4,a0
     22a:	b709                	j	12c <go+0xb4>
      write(fd, buf, sizeof(buf));
     22c:	3e700613          	li	a2,999
     230:	85da                	mv	a1,s6
     232:	8552                	mv	a0,s4
     234:	00001097          	auipc	ra,0x1
     238:	bd4080e7          	jalr	-1068(ra) # e08 <write>
     23c:	bdc5                	j	12c <go+0xb4>
      read(fd, buf, sizeof(buf));
     23e:	3e700613          	li	a2,999
     242:	85da                	mv	a1,s6
     244:	8552                	mv	a0,s4
     246:	00001097          	auipc	ra,0x1
     24a:	bba080e7          	jalr	-1094(ra) # e00 <read>
     24e:	bdf9                	j	12c <go+0xb4>
    } else if(what == 9){
      mkdir("grindir/../a");
     250:	00001517          	auipc	a0,0x1
     254:	10050513          	addi	a0,a0,256 # 1350 <malloc+0x126>
     258:	00001097          	auipc	ra,0x1
     25c:	bf8080e7          	jalr	-1032(ra) # e50 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     260:	20200593          	li	a1,514
     264:	00001517          	auipc	a0,0x1
     268:	14450513          	addi	a0,a0,324 # 13a8 <malloc+0x17e>
     26c:	00001097          	auipc	ra,0x1
     270:	bbc080e7          	jalr	-1092(ra) # e28 <open>
     274:	00001097          	auipc	ra,0x1
     278:	b9c080e7          	jalr	-1124(ra) # e10 <close>
      unlink("a/a");
     27c:	00001517          	auipc	a0,0x1
     280:	13c50513          	addi	a0,a0,316 # 13b8 <malloc+0x18e>
     284:	00001097          	auipc	ra,0x1
     288:	bb4080e7          	jalr	-1100(ra) # e38 <unlink>
     28c:	b545                	j	12c <go+0xb4>
    } else if(what == 10){
      mkdir("/../b");
     28e:	00001517          	auipc	a0,0x1
     292:	13250513          	addi	a0,a0,306 # 13c0 <malloc+0x196>
     296:	00001097          	auipc	ra,0x1
     29a:	bba080e7          	jalr	-1094(ra) # e50 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     29e:	20200593          	li	a1,514
     2a2:	00001517          	auipc	a0,0x1
     2a6:	12650513          	addi	a0,a0,294 # 13c8 <malloc+0x19e>
     2aa:	00001097          	auipc	ra,0x1
     2ae:	b7e080e7          	jalr	-1154(ra) # e28 <open>
     2b2:	00001097          	auipc	ra,0x1
     2b6:	b5e080e7          	jalr	-1186(ra) # e10 <close>
      unlink("b/b");
     2ba:	00001517          	auipc	a0,0x1
     2be:	11e50513          	addi	a0,a0,286 # 13d8 <malloc+0x1ae>
     2c2:	00001097          	auipc	ra,0x1
     2c6:	b76080e7          	jalr	-1162(ra) # e38 <unlink>
     2ca:	b58d                	j	12c <go+0xb4>
    } else if(what == 11){
      unlink("b");
     2cc:	00001517          	auipc	a0,0x1
     2d0:	0d450513          	addi	a0,a0,212 # 13a0 <malloc+0x176>
     2d4:	00001097          	auipc	ra,0x1
     2d8:	b64080e7          	jalr	-1180(ra) # e38 <unlink>
      link("../grindir/./../a", "../b");
     2dc:	00001597          	auipc	a1,0x1
     2e0:	09c58593          	addi	a1,a1,156 # 1378 <malloc+0x14e>
     2e4:	00001517          	auipc	a0,0x1
     2e8:	0fc50513          	addi	a0,a0,252 # 13e0 <malloc+0x1b6>
     2ec:	00001097          	auipc	ra,0x1
     2f0:	b5c080e7          	jalr	-1188(ra) # e48 <link>
     2f4:	bd25                	j	12c <go+0xb4>
    } else if(what == 12){
      unlink("../grindir/../a");
     2f6:	00001517          	auipc	a0,0x1
     2fa:	10250513          	addi	a0,a0,258 # 13f8 <malloc+0x1ce>
     2fe:	00001097          	auipc	ra,0x1
     302:	b3a080e7          	jalr	-1222(ra) # e38 <unlink>
      link(".././b", "/grindir/../a");
     306:	00001597          	auipc	a1,0x1
     30a:	07a58593          	addi	a1,a1,122 # 1380 <malloc+0x156>
     30e:	00001517          	auipc	a0,0x1
     312:	0fa50513          	addi	a0,a0,250 # 1408 <malloc+0x1de>
     316:	00001097          	auipc	ra,0x1
     31a:	b32080e7          	jalr	-1230(ra) # e48 <link>
     31e:	b539                	j	12c <go+0xb4>
    } else if(what == 13){
      int pid = fork();
     320:	00001097          	auipc	ra,0x1
     324:	ac0080e7          	jalr	-1344(ra) # de0 <fork>
      if(pid == 0){
     328:	c909                	beqz	a0,33a <go+0x2c2>
        exit(0);
      } else if(pid < 0){
     32a:	00054c63          	bltz	a0,342 <go+0x2ca>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     32e:	4501                	li	a0,0
     330:	00001097          	auipc	ra,0x1
     334:	ac0080e7          	jalr	-1344(ra) # df0 <wait>
     338:	bbd5                	j	12c <go+0xb4>
        exit(0);
     33a:	00001097          	auipc	ra,0x1
     33e:	aae080e7          	jalr	-1362(ra) # de8 <exit>
        printf("grind: fork failed\n");
     342:	00001517          	auipc	a0,0x1
     346:	0ce50513          	addi	a0,a0,206 # 1410 <malloc+0x1e6>
     34a:	00001097          	auipc	ra,0x1
     34e:	e28080e7          	jalr	-472(ra) # 1172 <printf>
        exit(1);
     352:	4505                	li	a0,1
     354:	00001097          	auipc	ra,0x1
     358:	a94080e7          	jalr	-1388(ra) # de8 <exit>
    } else if(what == 14){
      int pid = fork();
     35c:	00001097          	auipc	ra,0x1
     360:	a84080e7          	jalr	-1404(ra) # de0 <fork>
      if(pid == 0){
     364:	c909                	beqz	a0,376 <go+0x2fe>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     366:	02054563          	bltz	a0,390 <go+0x318>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36a:	4501                	li	a0,0
     36c:	00001097          	auipc	ra,0x1
     370:	a84080e7          	jalr	-1404(ra) # df0 <wait>
     374:	bb65                	j	12c <go+0xb4>
        fork();
     376:	00001097          	auipc	ra,0x1
     37a:	a6a080e7          	jalr	-1430(ra) # de0 <fork>
        fork();
     37e:	00001097          	auipc	ra,0x1
     382:	a62080e7          	jalr	-1438(ra) # de0 <fork>
        exit(0);
     386:	4501                	li	a0,0
     388:	00001097          	auipc	ra,0x1
     38c:	a60080e7          	jalr	-1440(ra) # de8 <exit>
        printf("grind: fork failed\n");
     390:	00001517          	auipc	a0,0x1
     394:	08050513          	addi	a0,a0,128 # 1410 <malloc+0x1e6>
     398:	00001097          	auipc	ra,0x1
     39c:	dda080e7          	jalr	-550(ra) # 1172 <printf>
        exit(1);
     3a0:	4505                	li	a0,1
     3a2:	00001097          	auipc	ra,0x1
     3a6:	a46080e7          	jalr	-1466(ra) # de8 <exit>
    } else if(what == 15){
      sbrk(6011);
     3aa:	6505                	lui	a0,0x1
     3ac:	77b50513          	addi	a0,a0,1915 # 177b <buf.0+0xa3>
     3b0:	00001097          	auipc	ra,0x1
     3b4:	ac0080e7          	jalr	-1344(ra) # e70 <sbrk>
     3b8:	bb95                	j	12c <go+0xb4>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3ba:	4501                	li	a0,0
     3bc:	00001097          	auipc	ra,0x1
     3c0:	ab4080e7          	jalr	-1356(ra) # e70 <sbrk>
     3c4:	d6aaf4e3          	bgeu	s5,a0,12c <go+0xb4>
        sbrk(-(sbrk(0) - break0));
     3c8:	4501                	li	a0,0
     3ca:	00001097          	auipc	ra,0x1
     3ce:	aa6080e7          	jalr	-1370(ra) # e70 <sbrk>
     3d2:	40aa853b          	subw	a0,s5,a0
     3d6:	00001097          	auipc	ra,0x1
     3da:	a9a080e7          	jalr	-1382(ra) # e70 <sbrk>
     3de:	b3b9                	j	12c <go+0xb4>
    } else if(what == 17){
      int pid = fork();
     3e0:	00001097          	auipc	ra,0x1
     3e4:	a00080e7          	jalr	-1536(ra) # de0 <fork>
     3e8:	8baa                	mv	s7,a0
      if(pid == 0){
     3ea:	c51d                	beqz	a0,418 <go+0x3a0>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3ec:	04054963          	bltz	a0,43e <go+0x3c6>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f0:	00001517          	auipc	a0,0x1
     3f4:	03850513          	addi	a0,a0,56 # 1428 <malloc+0x1fe>
     3f8:	00001097          	auipc	ra,0x1
     3fc:	a60080e7          	jalr	-1440(ra) # e58 <chdir>
     400:	ed21                	bnez	a0,458 <go+0x3e0>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     402:	855e                	mv	a0,s7
     404:	00001097          	auipc	ra,0x1
     408:	a14080e7          	jalr	-1516(ra) # e18 <kill>
      wait(0);
     40c:	4501                	li	a0,0
     40e:	00001097          	auipc	ra,0x1
     412:	9e2080e7          	jalr	-1566(ra) # df0 <wait>
     416:	bb19                	j	12c <go+0xb4>
        close(open("a", O_CREATE|O_RDWR));
     418:	20200593          	li	a1,514
     41c:	00001517          	auipc	a0,0x1
     420:	fd450513          	addi	a0,a0,-44 # 13f0 <malloc+0x1c6>
     424:	00001097          	auipc	ra,0x1
     428:	a04080e7          	jalr	-1532(ra) # e28 <open>
     42c:	00001097          	auipc	ra,0x1
     430:	9e4080e7          	jalr	-1564(ra) # e10 <close>
        exit(0);
     434:	4501                	li	a0,0
     436:	00001097          	auipc	ra,0x1
     43a:	9b2080e7          	jalr	-1614(ra) # de8 <exit>
        printf("grind: fork failed\n");
     43e:	00001517          	auipc	a0,0x1
     442:	fd250513          	addi	a0,a0,-46 # 1410 <malloc+0x1e6>
     446:	00001097          	auipc	ra,0x1
     44a:	d2c080e7          	jalr	-724(ra) # 1172 <printf>
        exit(1);
     44e:	4505                	li	a0,1
     450:	00001097          	auipc	ra,0x1
     454:	998080e7          	jalr	-1640(ra) # de8 <exit>
        printf("grind: chdir failed\n");
     458:	00001517          	auipc	a0,0x1
     45c:	fe050513          	addi	a0,a0,-32 # 1438 <malloc+0x20e>
     460:	00001097          	auipc	ra,0x1
     464:	d12080e7          	jalr	-750(ra) # 1172 <printf>
        exit(1);
     468:	4505                	li	a0,1
     46a:	00001097          	auipc	ra,0x1
     46e:	97e080e7          	jalr	-1666(ra) # de8 <exit>
    } else if(what == 18){
      int pid = fork();
     472:	00001097          	auipc	ra,0x1
     476:	96e080e7          	jalr	-1682(ra) # de0 <fork>
      if(pid == 0){
     47a:	c909                	beqz	a0,48c <go+0x414>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     47c:	02054563          	bltz	a0,4a6 <go+0x42e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     480:	4501                	li	a0,0
     482:	00001097          	auipc	ra,0x1
     486:	96e080e7          	jalr	-1682(ra) # df0 <wait>
     48a:	b14d                	j	12c <go+0xb4>
        kill(getpid());
     48c:	00001097          	auipc	ra,0x1
     490:	9dc080e7          	jalr	-1572(ra) # e68 <getpid>
     494:	00001097          	auipc	ra,0x1
     498:	984080e7          	jalr	-1660(ra) # e18 <kill>
        exit(0);
     49c:	4501                	li	a0,0
     49e:	00001097          	auipc	ra,0x1
     4a2:	94a080e7          	jalr	-1718(ra) # de8 <exit>
        printf("grind: fork failed\n");
     4a6:	00001517          	auipc	a0,0x1
     4aa:	f6a50513          	addi	a0,a0,-150 # 1410 <malloc+0x1e6>
     4ae:	00001097          	auipc	ra,0x1
     4b2:	cc4080e7          	jalr	-828(ra) # 1172 <printf>
        exit(1);
     4b6:	4505                	li	a0,1
     4b8:	00001097          	auipc	ra,0x1
     4bc:	930080e7          	jalr	-1744(ra) # de8 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c0:	f9840513          	addi	a0,s0,-104
     4c4:	00001097          	auipc	ra,0x1
     4c8:	934080e7          	jalr	-1740(ra) # df8 <pipe>
     4cc:	02054b63          	bltz	a0,502 <go+0x48a>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d0:	00001097          	auipc	ra,0x1
     4d4:	910080e7          	jalr	-1776(ra) # de0 <fork>
      if(pid == 0){
     4d8:	c131                	beqz	a0,51c <go+0x4a4>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4da:	0a054a63          	bltz	a0,58e <go+0x516>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4de:	f9842503          	lw	a0,-104(s0)
     4e2:	00001097          	auipc	ra,0x1
     4e6:	92e080e7          	jalr	-1746(ra) # e10 <close>
      close(fds[1]);
     4ea:	f9c42503          	lw	a0,-100(s0)
     4ee:	00001097          	auipc	ra,0x1
     4f2:	922080e7          	jalr	-1758(ra) # e10 <close>
      wait(0);
     4f6:	4501                	li	a0,0
     4f8:	00001097          	auipc	ra,0x1
     4fc:	8f8080e7          	jalr	-1800(ra) # df0 <wait>
     500:	b135                	j	12c <go+0xb4>
        printf("grind: pipe failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	f4e50513          	addi	a0,a0,-178 # 1450 <malloc+0x226>
     50a:	00001097          	auipc	ra,0x1
     50e:	c68080e7          	jalr	-920(ra) # 1172 <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	8d4080e7          	jalr	-1836(ra) # de8 <exit>
        fork();
     51c:	00001097          	auipc	ra,0x1
     520:	8c4080e7          	jalr	-1852(ra) # de0 <fork>
        fork();
     524:	00001097          	auipc	ra,0x1
     528:	8bc080e7          	jalr	-1860(ra) # de0 <fork>
        if(write(fds[1], "x", 1) != 1)
     52c:	4605                	li	a2,1
     52e:	00001597          	auipc	a1,0x1
     532:	f3a58593          	addi	a1,a1,-198 # 1468 <malloc+0x23e>
     536:	f9c42503          	lw	a0,-100(s0)
     53a:	00001097          	auipc	ra,0x1
     53e:	8ce080e7          	jalr	-1842(ra) # e08 <write>
     542:	4785                	li	a5,1
     544:	02f51363          	bne	a0,a5,56a <go+0x4f2>
        if(read(fds[0], &c, 1) != 1)
     548:	4605                	li	a2,1
     54a:	f9040593          	addi	a1,s0,-112
     54e:	f9842503          	lw	a0,-104(s0)
     552:	00001097          	auipc	ra,0x1
     556:	8ae080e7          	jalr	-1874(ra) # e00 <read>
     55a:	4785                	li	a5,1
     55c:	02f51063          	bne	a0,a5,57c <go+0x504>
        exit(0);
     560:	4501                	li	a0,0
     562:	00001097          	auipc	ra,0x1
     566:	886080e7          	jalr	-1914(ra) # de8 <exit>
          printf("grind: pipe write failed\n");
     56a:	00001517          	auipc	a0,0x1
     56e:	f0650513          	addi	a0,a0,-250 # 1470 <malloc+0x246>
     572:	00001097          	auipc	ra,0x1
     576:	c00080e7          	jalr	-1024(ra) # 1172 <printf>
     57a:	b7f9                	j	548 <go+0x4d0>
          printf("grind: pipe read failed\n");
     57c:	00001517          	auipc	a0,0x1
     580:	f1450513          	addi	a0,a0,-236 # 1490 <malloc+0x266>
     584:	00001097          	auipc	ra,0x1
     588:	bee080e7          	jalr	-1042(ra) # 1172 <printf>
     58c:	bfd1                	j	560 <go+0x4e8>
        printf("grind: fork failed\n");
     58e:	00001517          	auipc	a0,0x1
     592:	e8250513          	addi	a0,a0,-382 # 1410 <malloc+0x1e6>
     596:	00001097          	auipc	ra,0x1
     59a:	bdc080e7          	jalr	-1060(ra) # 1172 <printf>
        exit(1);
     59e:	4505                	li	a0,1
     5a0:	00001097          	auipc	ra,0x1
     5a4:	848080e7          	jalr	-1976(ra) # de8 <exit>
    } else if(what == 20){
      int pid = fork();
     5a8:	00001097          	auipc	ra,0x1
     5ac:	838080e7          	jalr	-1992(ra) # de0 <fork>
      if(pid == 0){
     5b0:	c909                	beqz	a0,5c2 <go+0x54a>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b2:	06054f63          	bltz	a0,630 <go+0x5b8>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5b6:	4501                	li	a0,0
     5b8:	00001097          	auipc	ra,0x1
     5bc:	838080e7          	jalr	-1992(ra) # df0 <wait>
     5c0:	b6b5                	j	12c <go+0xb4>
        unlink("a");
     5c2:	00001517          	auipc	a0,0x1
     5c6:	e2e50513          	addi	a0,a0,-466 # 13f0 <malloc+0x1c6>
     5ca:	00001097          	auipc	ra,0x1
     5ce:	86e080e7          	jalr	-1938(ra) # e38 <unlink>
        mkdir("a");
     5d2:	00001517          	auipc	a0,0x1
     5d6:	e1e50513          	addi	a0,a0,-482 # 13f0 <malloc+0x1c6>
     5da:	00001097          	auipc	ra,0x1
     5de:	876080e7          	jalr	-1930(ra) # e50 <mkdir>
        chdir("a");
     5e2:	00001517          	auipc	a0,0x1
     5e6:	e0e50513          	addi	a0,a0,-498 # 13f0 <malloc+0x1c6>
     5ea:	00001097          	auipc	ra,0x1
     5ee:	86e080e7          	jalr	-1938(ra) # e58 <chdir>
        unlink("../a");
     5f2:	00001517          	auipc	a0,0x1
     5f6:	d6650513          	addi	a0,a0,-666 # 1358 <malloc+0x12e>
     5fa:	00001097          	auipc	ra,0x1
     5fe:	83e080e7          	jalr	-1986(ra) # e38 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     602:	20200593          	li	a1,514
     606:	00001517          	auipc	a0,0x1
     60a:	e6250513          	addi	a0,a0,-414 # 1468 <malloc+0x23e>
     60e:	00001097          	auipc	ra,0x1
     612:	81a080e7          	jalr	-2022(ra) # e28 <open>
        unlink("x");
     616:	00001517          	auipc	a0,0x1
     61a:	e5250513          	addi	a0,a0,-430 # 1468 <malloc+0x23e>
     61e:	00001097          	auipc	ra,0x1
     622:	81a080e7          	jalr	-2022(ra) # e38 <unlink>
        exit(0);
     626:	4501                	li	a0,0
     628:	00000097          	auipc	ra,0x0
     62c:	7c0080e7          	jalr	1984(ra) # de8 <exit>
        printf("grind: fork failed\n");
     630:	00001517          	auipc	a0,0x1
     634:	de050513          	addi	a0,a0,-544 # 1410 <malloc+0x1e6>
     638:	00001097          	auipc	ra,0x1
     63c:	b3a080e7          	jalr	-1222(ra) # 1172 <printf>
        exit(1);
     640:	4505                	li	a0,1
     642:	00000097          	auipc	ra,0x0
     646:	7a6080e7          	jalr	1958(ra) # de8 <exit>
    } else if(what == 21){
      unlink("c");
     64a:	00001517          	auipc	a0,0x1
     64e:	e6650513          	addi	a0,a0,-410 # 14b0 <malloc+0x286>
     652:	00000097          	auipc	ra,0x0
     656:	7e6080e7          	jalr	2022(ra) # e38 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     65a:	20200593          	li	a1,514
     65e:	00001517          	auipc	a0,0x1
     662:	e5250513          	addi	a0,a0,-430 # 14b0 <malloc+0x286>
     666:	00000097          	auipc	ra,0x0
     66a:	7c2080e7          	jalr	1986(ra) # e28 <open>
     66e:	8baa                	mv	s7,a0
      if(fd1 < 0){
     670:	04054f63          	bltz	a0,6ce <go+0x656>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     674:	4605                	li	a2,1
     676:	00001597          	auipc	a1,0x1
     67a:	df258593          	addi	a1,a1,-526 # 1468 <malloc+0x23e>
     67e:	00000097          	auipc	ra,0x0
     682:	78a080e7          	jalr	1930(ra) # e08 <write>
     686:	4785                	li	a5,1
     688:	06f51063          	bne	a0,a5,6e8 <go+0x670>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     68c:	f9840593          	addi	a1,s0,-104
     690:	855e                	mv	a0,s7
     692:	00000097          	auipc	ra,0x0
     696:	7ae080e7          	jalr	1966(ra) # e40 <fstat>
     69a:	e525                	bnez	a0,702 <go+0x68a>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     69c:	fa843583          	ld	a1,-88(s0)
     6a0:	4785                	li	a5,1
     6a2:	06f59d63          	bne	a1,a5,71c <go+0x6a4>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6a6:	f9c42583          	lw	a1,-100(s0)
     6aa:	0c800793          	li	a5,200
     6ae:	08b7e563          	bltu	a5,a1,738 <go+0x6c0>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b2:	855e                	mv	a0,s7
     6b4:	00000097          	auipc	ra,0x0
     6b8:	75c080e7          	jalr	1884(ra) # e10 <close>
      unlink("c");
     6bc:	00001517          	auipc	a0,0x1
     6c0:	df450513          	addi	a0,a0,-524 # 14b0 <malloc+0x286>
     6c4:	00000097          	auipc	ra,0x0
     6c8:	774080e7          	jalr	1908(ra) # e38 <unlink>
     6cc:	b485                	j	12c <go+0xb4>
        printf("grind: create c failed\n");
     6ce:	00001517          	auipc	a0,0x1
     6d2:	dea50513          	addi	a0,a0,-534 # 14b8 <malloc+0x28e>
     6d6:	00001097          	auipc	ra,0x1
     6da:	a9c080e7          	jalr	-1380(ra) # 1172 <printf>
        exit(1);
     6de:	4505                	li	a0,1
     6e0:	00000097          	auipc	ra,0x0
     6e4:	708080e7          	jalr	1800(ra) # de8 <exit>
        printf("grind: write c failed\n");
     6e8:	00001517          	auipc	a0,0x1
     6ec:	de850513          	addi	a0,a0,-536 # 14d0 <malloc+0x2a6>
     6f0:	00001097          	auipc	ra,0x1
     6f4:	a82080e7          	jalr	-1406(ra) # 1172 <printf>
        exit(1);
     6f8:	4505                	li	a0,1
     6fa:	00000097          	auipc	ra,0x0
     6fe:	6ee080e7          	jalr	1774(ra) # de8 <exit>
        printf("grind: fstat failed\n");
     702:	00001517          	auipc	a0,0x1
     706:	de650513          	addi	a0,a0,-538 # 14e8 <malloc+0x2be>
     70a:	00001097          	auipc	ra,0x1
     70e:	a68080e7          	jalr	-1432(ra) # 1172 <printf>
        exit(1);
     712:	4505                	li	a0,1
     714:	00000097          	auipc	ra,0x0
     718:	6d4080e7          	jalr	1748(ra) # de8 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     71c:	2581                	sext.w	a1,a1
     71e:	00001517          	auipc	a0,0x1
     722:	de250513          	addi	a0,a0,-542 # 1500 <malloc+0x2d6>
     726:	00001097          	auipc	ra,0x1
     72a:	a4c080e7          	jalr	-1460(ra) # 1172 <printf>
        exit(1);
     72e:	4505                	li	a0,1
     730:	00000097          	auipc	ra,0x0
     734:	6b8080e7          	jalr	1720(ra) # de8 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     738:	00001517          	auipc	a0,0x1
     73c:	df050513          	addi	a0,a0,-528 # 1528 <malloc+0x2fe>
     740:	00001097          	auipc	ra,0x1
     744:	a32080e7          	jalr	-1486(ra) # 1172 <printf>
        exit(1);
     748:	4505                	li	a0,1
     74a:	00000097          	auipc	ra,0x0
     74e:	69e080e7          	jalr	1694(ra) # de8 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     752:	f8840513          	addi	a0,s0,-120
     756:	00000097          	auipc	ra,0x0
     75a:	6a2080e7          	jalr	1698(ra) # df8 <pipe>
     75e:	0e054963          	bltz	a0,850 <go+0x7d8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     762:	f9040513          	addi	a0,s0,-112
     766:	00000097          	auipc	ra,0x0
     76a:	692080e7          	jalr	1682(ra) # df8 <pipe>
     76e:	0e054f63          	bltz	a0,86c <go+0x7f4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     772:	00000097          	auipc	ra,0x0
     776:	66e080e7          	jalr	1646(ra) # de0 <fork>
      if(pid1 == 0){
     77a:	10050763          	beqz	a0,888 <go+0x810>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     77e:	1a054f63          	bltz	a0,93c <go+0x8c4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     782:	00000097          	auipc	ra,0x0
     786:	65e080e7          	jalr	1630(ra) # de0 <fork>
      if(pid2 == 0){
     78a:	1c050763          	beqz	a0,958 <go+0x8e0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     78e:	2a054363          	bltz	a0,a34 <go+0x9bc>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     792:	f8842503          	lw	a0,-120(s0)
     796:	00000097          	auipc	ra,0x0
     79a:	67a080e7          	jalr	1658(ra) # e10 <close>
      close(aa[1]);
     79e:	f8c42503          	lw	a0,-116(s0)
     7a2:	00000097          	auipc	ra,0x0
     7a6:	66e080e7          	jalr	1646(ra) # e10 <close>
      close(bb[1]);
     7aa:	f9442503          	lw	a0,-108(s0)
     7ae:	00000097          	auipc	ra,0x0
     7b2:	662080e7          	jalr	1634(ra) # e10 <close>
      char buf[3] = { 0, 0, 0 };
     7b6:	f8041023          	sh	zero,-128(s0)
     7ba:	f8040123          	sb	zero,-126(s0)
      read(bb[0], buf+0, 1);
     7be:	4605                	li	a2,1
     7c0:	f8040593          	addi	a1,s0,-128
     7c4:	f9042503          	lw	a0,-112(s0)
     7c8:	00000097          	auipc	ra,0x0
     7cc:	638080e7          	jalr	1592(ra) # e00 <read>
      read(bb[0], buf+1, 1);
     7d0:	4605                	li	a2,1
     7d2:	f8140593          	addi	a1,s0,-127
     7d6:	f9042503          	lw	a0,-112(s0)
     7da:	00000097          	auipc	ra,0x0
     7de:	626080e7          	jalr	1574(ra) # e00 <read>
      close(bb[0]);
     7e2:	f9042503          	lw	a0,-112(s0)
     7e6:	00000097          	auipc	ra,0x0
     7ea:	62a080e7          	jalr	1578(ra) # e10 <close>
      int st1, st2;
      wait(&st1);
     7ee:	f8440513          	addi	a0,s0,-124
     7f2:	00000097          	auipc	ra,0x0
     7f6:	5fe080e7          	jalr	1534(ra) # df0 <wait>
      wait(&st2);
     7fa:	f9840513          	addi	a0,s0,-104
     7fe:	00000097          	auipc	ra,0x0
     802:	5f2080e7          	jalr	1522(ra) # df0 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi") != 0){
     806:	f8442783          	lw	a5,-124(s0)
     80a:	f9842703          	lw	a4,-104(s0)
     80e:	8fd9                	or	a5,a5,a4
     810:	ef89                	bnez	a5,82a <go+0x7b2>
     812:	00001597          	auipc	a1,0x1
     816:	d5e58593          	addi	a1,a1,-674 # 1570 <malloc+0x346>
     81a:	f8040513          	addi	a0,s0,-128
     81e:	00000097          	auipc	ra,0x0
     822:	37a080e7          	jalr	890(ra) # b98 <strcmp>
     826:	900503e3          	beqz	a0,12c <go+0xb4>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     82a:	f8040693          	addi	a3,s0,-128
     82e:	f9842603          	lw	a2,-104(s0)
     832:	f8442583          	lw	a1,-124(s0)
     836:	00001517          	auipc	a0,0x1
     83a:	d9250513          	addi	a0,a0,-622 # 15c8 <malloc+0x39e>
     83e:	00001097          	auipc	ra,0x1
     842:	934080e7          	jalr	-1740(ra) # 1172 <printf>
        exit(1);
     846:	4505                	li	a0,1
     848:	00000097          	auipc	ra,0x0
     84c:	5a0080e7          	jalr	1440(ra) # de8 <exit>
        fprintf(2, "grind: pipe failed\n");
     850:	00001597          	auipc	a1,0x1
     854:	c0058593          	addi	a1,a1,-1024 # 1450 <malloc+0x226>
     858:	4509                	li	a0,2
     85a:	00001097          	auipc	ra,0x1
     85e:	8ea080e7          	jalr	-1814(ra) # 1144 <fprintf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	584080e7          	jalr	1412(ra) # de8 <exit>
        fprintf(2, "grind: pipe failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	be458593          	addi	a1,a1,-1052 # 1450 <malloc+0x226>
     874:	4509                	li	a0,2
     876:	00001097          	auipc	ra,0x1
     87a:	8ce080e7          	jalr	-1842(ra) # 1144 <fprintf>
        exit(1);
     87e:	4505                	li	a0,1
     880:	00000097          	auipc	ra,0x0
     884:	568080e7          	jalr	1384(ra) # de8 <exit>
        close(bb[0]);
     888:	f9042503          	lw	a0,-112(s0)
     88c:	00000097          	auipc	ra,0x0
     890:	584080e7          	jalr	1412(ra) # e10 <close>
        close(bb[1]);
     894:	f9442503          	lw	a0,-108(s0)
     898:	00000097          	auipc	ra,0x0
     89c:	578080e7          	jalr	1400(ra) # e10 <close>
        close(aa[0]);
     8a0:	f8842503          	lw	a0,-120(s0)
     8a4:	00000097          	auipc	ra,0x0
     8a8:	56c080e7          	jalr	1388(ra) # e10 <close>
        close(1);
     8ac:	4505                	li	a0,1
     8ae:	00000097          	auipc	ra,0x0
     8b2:	562080e7          	jalr	1378(ra) # e10 <close>
        if(dup(aa[1]) != 1){
     8b6:	f8c42503          	lw	a0,-116(s0)
     8ba:	00000097          	auipc	ra,0x0
     8be:	5a6080e7          	jalr	1446(ra) # e60 <dup>
     8c2:	4785                	li	a5,1
     8c4:	02f50063          	beq	a0,a5,8e4 <go+0x86c>
          fprintf(2, "grind: dup failed\n");
     8c8:	00001597          	auipc	a1,0x1
     8cc:	c8858593          	addi	a1,a1,-888 # 1550 <malloc+0x326>
     8d0:	4509                	li	a0,2
     8d2:	00001097          	auipc	ra,0x1
     8d6:	872080e7          	jalr	-1934(ra) # 1144 <fprintf>
          exit(1);
     8da:	4505                	li	a0,1
     8dc:	00000097          	auipc	ra,0x0
     8e0:	50c080e7          	jalr	1292(ra) # de8 <exit>
        close(aa[1]);
     8e4:	f8c42503          	lw	a0,-116(s0)
     8e8:	00000097          	auipc	ra,0x0
     8ec:	528080e7          	jalr	1320(ra) # e10 <close>
        char *args[3] = { "echo", "hi", 0 };
     8f0:	00001797          	auipc	a5,0x1
     8f4:	c7878793          	addi	a5,a5,-904 # 1568 <malloc+0x33e>
     8f8:	f8f43c23          	sd	a5,-104(s0)
     8fc:	00001797          	auipc	a5,0x1
     900:	c7478793          	addi	a5,a5,-908 # 1570 <malloc+0x346>
     904:	faf43023          	sd	a5,-96(s0)
     908:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     90c:	f9840593          	addi	a1,s0,-104
     910:	00001517          	auipc	a0,0x1
     914:	c6850513          	addi	a0,a0,-920 # 1578 <malloc+0x34e>
     918:	00000097          	auipc	ra,0x0
     91c:	508080e7          	jalr	1288(ra) # e20 <exec>
        fprintf(2, "grind: echo: not found\n");
     920:	00001597          	auipc	a1,0x1
     924:	c6858593          	addi	a1,a1,-920 # 1588 <malloc+0x35e>
     928:	4509                	li	a0,2
     92a:	00001097          	auipc	ra,0x1
     92e:	81a080e7          	jalr	-2022(ra) # 1144 <fprintf>
        exit(2);
     932:	4509                	li	a0,2
     934:	00000097          	auipc	ra,0x0
     938:	4b4080e7          	jalr	1204(ra) # de8 <exit>
        fprintf(2, "grind: fork failed\n");
     93c:	00001597          	auipc	a1,0x1
     940:	ad458593          	addi	a1,a1,-1324 # 1410 <malloc+0x1e6>
     944:	4509                	li	a0,2
     946:	00000097          	auipc	ra,0x0
     94a:	7fe080e7          	jalr	2046(ra) # 1144 <fprintf>
        exit(3);
     94e:	450d                	li	a0,3
     950:	00000097          	auipc	ra,0x0
     954:	498080e7          	jalr	1176(ra) # de8 <exit>
        close(aa[1]);
     958:	f8c42503          	lw	a0,-116(s0)
     95c:	00000097          	auipc	ra,0x0
     960:	4b4080e7          	jalr	1204(ra) # e10 <close>
        close(bb[0]);
     964:	f9042503          	lw	a0,-112(s0)
     968:	00000097          	auipc	ra,0x0
     96c:	4a8080e7          	jalr	1192(ra) # e10 <close>
        close(0);
     970:	4501                	li	a0,0
     972:	00000097          	auipc	ra,0x0
     976:	49e080e7          	jalr	1182(ra) # e10 <close>
        if(dup(aa[0]) != 0){
     97a:	f8842503          	lw	a0,-120(s0)
     97e:	00000097          	auipc	ra,0x0
     982:	4e2080e7          	jalr	1250(ra) # e60 <dup>
     986:	cd19                	beqz	a0,9a4 <go+0x92c>
          fprintf(2, "grind: dup failed\n");
     988:	00001597          	auipc	a1,0x1
     98c:	bc858593          	addi	a1,a1,-1080 # 1550 <malloc+0x326>
     990:	4509                	li	a0,2
     992:	00000097          	auipc	ra,0x0
     996:	7b2080e7          	jalr	1970(ra) # 1144 <fprintf>
          exit(4);
     99a:	4511                	li	a0,4
     99c:	00000097          	auipc	ra,0x0
     9a0:	44c080e7          	jalr	1100(ra) # de8 <exit>
        close(aa[0]);
     9a4:	f8842503          	lw	a0,-120(s0)
     9a8:	00000097          	auipc	ra,0x0
     9ac:	468080e7          	jalr	1128(ra) # e10 <close>
        close(1);
     9b0:	4505                	li	a0,1
     9b2:	00000097          	auipc	ra,0x0
     9b6:	45e080e7          	jalr	1118(ra) # e10 <close>
        if(dup(bb[1]) != 1){
     9ba:	f9442503          	lw	a0,-108(s0)
     9be:	00000097          	auipc	ra,0x0
     9c2:	4a2080e7          	jalr	1186(ra) # e60 <dup>
     9c6:	4785                	li	a5,1
     9c8:	02f50063          	beq	a0,a5,9e8 <go+0x970>
          fprintf(2, "grind: dup failed\n");
     9cc:	00001597          	auipc	a1,0x1
     9d0:	b8458593          	addi	a1,a1,-1148 # 1550 <malloc+0x326>
     9d4:	4509                	li	a0,2
     9d6:	00000097          	auipc	ra,0x0
     9da:	76e080e7          	jalr	1902(ra) # 1144 <fprintf>
          exit(5);
     9de:	4515                	li	a0,5
     9e0:	00000097          	auipc	ra,0x0
     9e4:	408080e7          	jalr	1032(ra) # de8 <exit>
        close(bb[1]);
     9e8:	f9442503          	lw	a0,-108(s0)
     9ec:	00000097          	auipc	ra,0x0
     9f0:	424080e7          	jalr	1060(ra) # e10 <close>
        char *args[2] = { "cat", 0 };
     9f4:	00001797          	auipc	a5,0x1
     9f8:	bac78793          	addi	a5,a5,-1108 # 15a0 <malloc+0x376>
     9fc:	f8f43c23          	sd	a5,-104(s0)
     a00:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     a04:	f9840593          	addi	a1,s0,-104
     a08:	00001517          	auipc	a0,0x1
     a0c:	ba050513          	addi	a0,a0,-1120 # 15a8 <malloc+0x37e>
     a10:	00000097          	auipc	ra,0x0
     a14:	410080e7          	jalr	1040(ra) # e20 <exec>
        fprintf(2, "grind: cat: not found\n");
     a18:	00001597          	auipc	a1,0x1
     a1c:	b9858593          	addi	a1,a1,-1128 # 15b0 <malloc+0x386>
     a20:	4509                	li	a0,2
     a22:	00000097          	auipc	ra,0x0
     a26:	722080e7          	jalr	1826(ra) # 1144 <fprintf>
        exit(6);
     a2a:	4519                	li	a0,6
     a2c:	00000097          	auipc	ra,0x0
     a30:	3bc080e7          	jalr	956(ra) # de8 <exit>
        fprintf(2, "grind: fork failed\n");
     a34:	00001597          	auipc	a1,0x1
     a38:	9dc58593          	addi	a1,a1,-1572 # 1410 <malloc+0x1e6>
     a3c:	4509                	li	a0,2
     a3e:	00000097          	auipc	ra,0x0
     a42:	706080e7          	jalr	1798(ra) # 1144 <fprintf>
        exit(7);
     a46:	451d                	li	a0,7
     a48:	00000097          	auipc	ra,0x0
     a4c:	3a0080e7          	jalr	928(ra) # de8 <exit>

0000000000000a50 <iter>:
  }
}

void
iter()
{
     a50:	7179                	addi	sp,sp,-48
     a52:	f406                	sd	ra,40(sp)
     a54:	f022                	sd	s0,32(sp)
     a56:	ec26                	sd	s1,24(sp)
     a58:	e84a                	sd	s2,16(sp)
     a5a:	1800                	addi	s0,sp,48
  unlink("a");
     a5c:	00001517          	auipc	a0,0x1
     a60:	99450513          	addi	a0,a0,-1644 # 13f0 <malloc+0x1c6>
     a64:	00000097          	auipc	ra,0x0
     a68:	3d4080e7          	jalr	980(ra) # e38 <unlink>
  unlink("b");
     a6c:	00001517          	auipc	a0,0x1
     a70:	93450513          	addi	a0,a0,-1740 # 13a0 <malloc+0x176>
     a74:	00000097          	auipc	ra,0x0
     a78:	3c4080e7          	jalr	964(ra) # e38 <unlink>
  
  int pid1 = fork();
     a7c:	00000097          	auipc	ra,0x0
     a80:	364080e7          	jalr	868(ra) # de0 <fork>
  if(pid1 < 0){
     a84:	00054e63          	bltz	a0,aa0 <iter+0x50>
     a88:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a8a:	e905                	bnez	a0,aba <iter+0x6a>
    rand_next = 31;
     a8c:	47fd                	li	a5,31
     a8e:	00001717          	auipc	a4,0x1
     a92:	c2f73d23          	sd	a5,-966(a4) # 16c8 <rand_next>
    go(0);
     a96:	4501                	li	a0,0
     a98:	fffff097          	auipc	ra,0xfffff
     a9c:	5e0080e7          	jalr	1504(ra) # 78 <go>
    printf("grind: fork failed\n");
     aa0:	00001517          	auipc	a0,0x1
     aa4:	97050513          	addi	a0,a0,-1680 # 1410 <malloc+0x1e6>
     aa8:	00000097          	auipc	ra,0x0
     aac:	6ca080e7          	jalr	1738(ra) # 1172 <printf>
    exit(1);
     ab0:	4505                	li	a0,1
     ab2:	00000097          	auipc	ra,0x0
     ab6:	336080e7          	jalr	822(ra) # de8 <exit>
    exit(0);
  }

  int pid2 = fork();
     aba:	00000097          	auipc	ra,0x0
     abe:	326080e7          	jalr	806(ra) # de0 <fork>
     ac2:	892a                	mv	s2,a0
  if(pid2 < 0){
     ac4:	00054f63          	bltz	a0,ae2 <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ac8:	e915                	bnez	a0,afc <iter+0xac>
    rand_next = 7177;
     aca:	6789                	lui	a5,0x2
     acc:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x139>
     ad0:	00001717          	auipc	a4,0x1
     ad4:	bef73c23          	sd	a5,-1032(a4) # 16c8 <rand_next>
    go(1);
     ad8:	4505                	li	a0,1
     ada:	fffff097          	auipc	ra,0xfffff
     ade:	59e080e7          	jalr	1438(ra) # 78 <go>
    printf("grind: fork failed\n");
     ae2:	00001517          	auipc	a0,0x1
     ae6:	92e50513          	addi	a0,a0,-1746 # 1410 <malloc+0x1e6>
     aea:	00000097          	auipc	ra,0x0
     aee:	688080e7          	jalr	1672(ra) # 1172 <printf>
    exit(1);
     af2:	4505                	li	a0,1
     af4:	00000097          	auipc	ra,0x0
     af8:	2f4080e7          	jalr	756(ra) # de8 <exit>
    exit(0);
  }

  int st1 = -1;
     afc:	57fd                	li	a5,-1
     afe:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b02:	fdc40513          	addi	a0,s0,-36
     b06:	00000097          	auipc	ra,0x0
     b0a:	2ea080e7          	jalr	746(ra) # df0 <wait>
  if(st1 != 0){
     b0e:	fdc42783          	lw	a5,-36(s0)
     b12:	ef99                	bnez	a5,b30 <iter+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b14:	57fd                	li	a5,-1
     b16:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b1a:	fd840513          	addi	a0,s0,-40
     b1e:	00000097          	auipc	ra,0x0
     b22:	2d2080e7          	jalr	722(ra) # df0 <wait>

  exit(0);
     b26:	4501                	li	a0,0
     b28:	00000097          	auipc	ra,0x0
     b2c:	2c0080e7          	jalr	704(ra) # de8 <exit>
    kill(pid1);
     b30:	8526                	mv	a0,s1
     b32:	00000097          	auipc	ra,0x0
     b36:	2e6080e7          	jalr	742(ra) # e18 <kill>
    kill(pid2);
     b3a:	854a                	mv	a0,s2
     b3c:	00000097          	auipc	ra,0x0
     b40:	2dc080e7          	jalr	732(ra) # e18 <kill>
     b44:	bfc1                	j	b14 <iter+0xc4>

0000000000000b46 <main>:
}

int
main()
{
     b46:	1141                	addi	sp,sp,-16
     b48:	e406                	sd	ra,8(sp)
     b4a:	e022                	sd	s0,0(sp)
     b4c:	0800                	addi	s0,sp,16
     b4e:	a811                	j	b62 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     b50:	00000097          	auipc	ra,0x0
     b54:	f00080e7          	jalr	-256(ra) # a50 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     b58:	4551                	li	a0,20
     b5a:	00000097          	auipc	ra,0x0
     b5e:	31e080e7          	jalr	798(ra) # e78 <sleep>
    int pid = fork();
     b62:	00000097          	auipc	ra,0x0
     b66:	27e080e7          	jalr	638(ra) # de0 <fork>
    if(pid == 0){
     b6a:	d17d                	beqz	a0,b50 <main+0xa>
    if(pid > 0){
     b6c:	fea056e3          	blez	a0,b58 <main+0x12>
      wait(0);
     b70:	4501                	li	a0,0
     b72:	00000097          	auipc	ra,0x0
     b76:	27e080e7          	jalr	638(ra) # df0 <wait>
     b7a:	bff9                	j	b58 <main+0x12>

0000000000000b7c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b7c:	1141                	addi	sp,sp,-16
     b7e:	e422                	sd	s0,8(sp)
     b80:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b82:	87aa                	mv	a5,a0
     b84:	0585                	addi	a1,a1,1
     b86:	0785                	addi	a5,a5,1
     b88:	fff5c703          	lbu	a4,-1(a1)
     b8c:	fee78fa3          	sb	a4,-1(a5)
     b90:	fb75                	bnez	a4,b84 <strcpy+0x8>
    ;
  return os;
}
     b92:	6422                	ld	s0,8(sp)
     b94:	0141                	addi	sp,sp,16
     b96:	8082                	ret

0000000000000b98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b98:	1141                	addi	sp,sp,-16
     b9a:	e422                	sd	s0,8(sp)
     b9c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b9e:	00054783          	lbu	a5,0(a0)
     ba2:	cb91                	beqz	a5,bb6 <strcmp+0x1e>
     ba4:	0005c703          	lbu	a4,0(a1)
     ba8:	00f71763          	bne	a4,a5,bb6 <strcmp+0x1e>
    p++, q++;
     bac:	0505                	addi	a0,a0,1
     bae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bb0:	00054783          	lbu	a5,0(a0)
     bb4:	fbe5                	bnez	a5,ba4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bb6:	0005c503          	lbu	a0,0(a1)
}
     bba:	40a7853b          	subw	a0,a5,a0
     bbe:	6422                	ld	s0,8(sp)
     bc0:	0141                	addi	sp,sp,16
     bc2:	8082                	ret

0000000000000bc4 <strlen>:

uint
strlen(const char *s)
{
     bc4:	1141                	addi	sp,sp,-16
     bc6:	e422                	sd	s0,8(sp)
     bc8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bca:	00054783          	lbu	a5,0(a0)
     bce:	cf91                	beqz	a5,bea <strlen+0x26>
     bd0:	0505                	addi	a0,a0,1
     bd2:	87aa                	mv	a5,a0
     bd4:	4685                	li	a3,1
     bd6:	9e89                	subw	a3,a3,a0
     bd8:	00f6853b          	addw	a0,a3,a5
     bdc:	0785                	addi	a5,a5,1
     bde:	fff7c703          	lbu	a4,-1(a5)
     be2:	fb7d                	bnez	a4,bd8 <strlen+0x14>
    ;
  return n;
}
     be4:	6422                	ld	s0,8(sp)
     be6:	0141                	addi	sp,sp,16
     be8:	8082                	ret
  for(n = 0; s[n]; n++)
     bea:	4501                	li	a0,0
     bec:	bfe5                	j	be4 <strlen+0x20>

0000000000000bee <memset>:

void*
memset(void *dst, int c, uint n)
{
     bee:	1141                	addi	sp,sp,-16
     bf0:	e422                	sd	s0,8(sp)
     bf2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bf4:	ca19                	beqz	a2,c0a <memset+0x1c>
     bf6:	87aa                	mv	a5,a0
     bf8:	1602                	slli	a2,a2,0x20
     bfa:	9201                	srli	a2,a2,0x20
     bfc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c00:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c04:	0785                	addi	a5,a5,1
     c06:	fee79de3          	bne	a5,a4,c00 <memset+0x12>
  }
  return dst;
}
     c0a:	6422                	ld	s0,8(sp)
     c0c:	0141                	addi	sp,sp,16
     c0e:	8082                	ret

0000000000000c10 <strchr>:

char*
strchr(const char *s, char c)
{
     c10:	1141                	addi	sp,sp,-16
     c12:	e422                	sd	s0,8(sp)
     c14:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c16:	00054783          	lbu	a5,0(a0)
     c1a:	cb99                	beqz	a5,c30 <strchr+0x20>
    if(*s == c)
     c1c:	00f58763          	beq	a1,a5,c2a <strchr+0x1a>
  for(; *s; s++)
     c20:	0505                	addi	a0,a0,1
     c22:	00054783          	lbu	a5,0(a0)
     c26:	fbfd                	bnez	a5,c1c <strchr+0xc>
      return (char*)s;
  return 0;
     c28:	4501                	li	a0,0
}
     c2a:	6422                	ld	s0,8(sp)
     c2c:	0141                	addi	sp,sp,16
     c2e:	8082                	ret
  return 0;
     c30:	4501                	li	a0,0
     c32:	bfe5                	j	c2a <strchr+0x1a>

0000000000000c34 <gets>:

char*
gets(char *buf, int max)
{
     c34:	711d                	addi	sp,sp,-96
     c36:	ec86                	sd	ra,88(sp)
     c38:	e8a2                	sd	s0,80(sp)
     c3a:	e4a6                	sd	s1,72(sp)
     c3c:	e0ca                	sd	s2,64(sp)
     c3e:	fc4e                	sd	s3,56(sp)
     c40:	f852                	sd	s4,48(sp)
     c42:	f456                	sd	s5,40(sp)
     c44:	f05a                	sd	s6,32(sp)
     c46:	ec5e                	sd	s7,24(sp)
     c48:	1080                	addi	s0,sp,96
     c4a:	8baa                	mv	s7,a0
     c4c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c4e:	892a                	mv	s2,a0
     c50:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c52:	4aa9                	li	s5,10
     c54:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c56:	89a6                	mv	s3,s1
     c58:	2485                	addiw	s1,s1,1
     c5a:	0344d863          	bge	s1,s4,c8a <gets+0x56>
    cc = read(0, &c, 1);
     c5e:	4605                	li	a2,1
     c60:	faf40593          	addi	a1,s0,-81
     c64:	4501                	li	a0,0
     c66:	00000097          	auipc	ra,0x0
     c6a:	19a080e7          	jalr	410(ra) # e00 <read>
    if(cc < 1)
     c6e:	00a05e63          	blez	a0,c8a <gets+0x56>
    buf[i++] = c;
     c72:	faf44783          	lbu	a5,-81(s0)
     c76:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c7a:	01578763          	beq	a5,s5,c88 <gets+0x54>
     c7e:	0905                	addi	s2,s2,1
     c80:	fd679be3          	bne	a5,s6,c56 <gets+0x22>
  for(i=0; i+1 < max; ){
     c84:	89a6                	mv	s3,s1
     c86:	a011                	j	c8a <gets+0x56>
     c88:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c8a:	99de                	add	s3,s3,s7
     c8c:	00098023          	sb	zero,0(s3)
  return buf;
}
     c90:	855e                	mv	a0,s7
     c92:	60e6                	ld	ra,88(sp)
     c94:	6446                	ld	s0,80(sp)
     c96:	64a6                	ld	s1,72(sp)
     c98:	6906                	ld	s2,64(sp)
     c9a:	79e2                	ld	s3,56(sp)
     c9c:	7a42                	ld	s4,48(sp)
     c9e:	7aa2                	ld	s5,40(sp)
     ca0:	7b02                	ld	s6,32(sp)
     ca2:	6be2                	ld	s7,24(sp)
     ca4:	6125                	addi	sp,sp,96
     ca6:	8082                	ret

0000000000000ca8 <stat>:

int
stat(const char *n, struct stat *st)
{
     ca8:	1101                	addi	sp,sp,-32
     caa:	ec06                	sd	ra,24(sp)
     cac:	e822                	sd	s0,16(sp)
     cae:	e426                	sd	s1,8(sp)
     cb0:	e04a                	sd	s2,0(sp)
     cb2:	1000                	addi	s0,sp,32
     cb4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cb6:	4581                	li	a1,0
     cb8:	00000097          	auipc	ra,0x0
     cbc:	170080e7          	jalr	368(ra) # e28 <open>
  if(fd < 0)
     cc0:	02054563          	bltz	a0,cea <stat+0x42>
     cc4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cc6:	85ca                	mv	a1,s2
     cc8:	00000097          	auipc	ra,0x0
     ccc:	178080e7          	jalr	376(ra) # e40 <fstat>
     cd0:	892a                	mv	s2,a0
  close(fd);
     cd2:	8526                	mv	a0,s1
     cd4:	00000097          	auipc	ra,0x0
     cd8:	13c080e7          	jalr	316(ra) # e10 <close>
  return r;
}
     cdc:	854a                	mv	a0,s2
     cde:	60e2                	ld	ra,24(sp)
     ce0:	6442                	ld	s0,16(sp)
     ce2:	64a2                	ld	s1,8(sp)
     ce4:	6902                	ld	s2,0(sp)
     ce6:	6105                	addi	sp,sp,32
     ce8:	8082                	ret
    return -1;
     cea:	597d                	li	s2,-1
     cec:	bfc5                	j	cdc <stat+0x34>

0000000000000cee <atoi>:

int
atoi(const char *s)
{
     cee:	1141                	addi	sp,sp,-16
     cf0:	e422                	sd	s0,8(sp)
     cf2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cf4:	00054683          	lbu	a3,0(a0)
     cf8:	fd06879b          	addiw	a5,a3,-48
     cfc:	0ff7f793          	zext.b	a5,a5
     d00:	4625                	li	a2,9
     d02:	02f66863          	bltu	a2,a5,d32 <atoi+0x44>
     d06:	872a                	mv	a4,a0
  n = 0;
     d08:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d0a:	0705                	addi	a4,a4,1
     d0c:	0025179b          	slliw	a5,a0,0x2
     d10:	9fa9                	addw	a5,a5,a0
     d12:	0017979b          	slliw	a5,a5,0x1
     d16:	9fb5                	addw	a5,a5,a3
     d18:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d1c:	00074683          	lbu	a3,0(a4)
     d20:	fd06879b          	addiw	a5,a3,-48
     d24:	0ff7f793          	zext.b	a5,a5
     d28:	fef671e3          	bgeu	a2,a5,d0a <atoi+0x1c>
  return n;
}
     d2c:	6422                	ld	s0,8(sp)
     d2e:	0141                	addi	sp,sp,16
     d30:	8082                	ret
  n = 0;
     d32:	4501                	li	a0,0
     d34:	bfe5                	j	d2c <atoi+0x3e>

0000000000000d36 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d36:	1141                	addi	sp,sp,-16
     d38:	e422                	sd	s0,8(sp)
     d3a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d3c:	02b57463          	bgeu	a0,a1,d64 <memmove+0x2e>
    while(n-- > 0)
     d40:	00c05f63          	blez	a2,d5e <memmove+0x28>
     d44:	1602                	slli	a2,a2,0x20
     d46:	9201                	srli	a2,a2,0x20
     d48:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d4c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d4e:	0585                	addi	a1,a1,1
     d50:	0705                	addi	a4,a4,1
     d52:	fff5c683          	lbu	a3,-1(a1)
     d56:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d5a:	fee79ae3          	bne	a5,a4,d4e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d5e:	6422                	ld	s0,8(sp)
     d60:	0141                	addi	sp,sp,16
     d62:	8082                	ret
    dst += n;
     d64:	00c50733          	add	a4,a0,a2
    src += n;
     d68:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d6a:	fec05ae3          	blez	a2,d5e <memmove+0x28>
     d6e:	fff6079b          	addiw	a5,a2,-1
     d72:	1782                	slli	a5,a5,0x20
     d74:	9381                	srli	a5,a5,0x20
     d76:	fff7c793          	not	a5,a5
     d7a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d7c:	15fd                	addi	a1,a1,-1
     d7e:	177d                	addi	a4,a4,-1
     d80:	0005c683          	lbu	a3,0(a1)
     d84:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d88:	fee79ae3          	bne	a5,a4,d7c <memmove+0x46>
     d8c:	bfc9                	j	d5e <memmove+0x28>

0000000000000d8e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d8e:	1141                	addi	sp,sp,-16
     d90:	e422                	sd	s0,8(sp)
     d92:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d94:	ca05                	beqz	a2,dc4 <memcmp+0x36>
     d96:	fff6069b          	addiw	a3,a2,-1
     d9a:	1682                	slli	a3,a3,0x20
     d9c:	9281                	srli	a3,a3,0x20
     d9e:	0685                	addi	a3,a3,1
     da0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     da2:	00054783          	lbu	a5,0(a0)
     da6:	0005c703          	lbu	a4,0(a1)
     daa:	00e79863          	bne	a5,a4,dba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dae:	0505                	addi	a0,a0,1
    p2++;
     db0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     db2:	fed518e3          	bne	a0,a3,da2 <memcmp+0x14>
  }
  return 0;
     db6:	4501                	li	a0,0
     db8:	a019                	j	dbe <memcmp+0x30>
      return *p1 - *p2;
     dba:	40e7853b          	subw	a0,a5,a4
}
     dbe:	6422                	ld	s0,8(sp)
     dc0:	0141                	addi	sp,sp,16
     dc2:	8082                	ret
  return 0;
     dc4:	4501                	li	a0,0
     dc6:	bfe5                	j	dbe <memcmp+0x30>

0000000000000dc8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dc8:	1141                	addi	sp,sp,-16
     dca:	e406                	sd	ra,8(sp)
     dcc:	e022                	sd	s0,0(sp)
     dce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     dd0:	00000097          	auipc	ra,0x0
     dd4:	f66080e7          	jalr	-154(ra) # d36 <memmove>
}
     dd8:	60a2                	ld	ra,8(sp)
     dda:	6402                	ld	s0,0(sp)
     ddc:	0141                	addi	sp,sp,16
     dde:	8082                	ret

0000000000000de0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     de0:	4885                	li	a7,1
 ecall
     de2:	00000073          	ecall
 ret
     de6:	8082                	ret

0000000000000de8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     de8:	4889                	li	a7,2
 ecall
     dea:	00000073          	ecall
 ret
     dee:	8082                	ret

0000000000000df0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     df0:	488d                	li	a7,3
 ecall
     df2:	00000073          	ecall
 ret
     df6:	8082                	ret

0000000000000df8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     df8:	4891                	li	a7,4
 ecall
     dfa:	00000073          	ecall
 ret
     dfe:	8082                	ret

0000000000000e00 <read>:
.global read
read:
 li a7, SYS_read
     e00:	4895                	li	a7,5
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <write>:
.global write
write:
 li a7, SYS_write
     e08:	48c1                	li	a7,16
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <close>:
.global close
close:
 li a7, SYS_close
     e10:	48d5                	li	a7,21
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e18:	4899                	li	a7,6
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e20:	489d                	li	a7,7
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <open>:
.global open
open:
 li a7, SYS_open
     e28:	48bd                	li	a7,15
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e30:	48c5                	li	a7,17
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e38:	48c9                	li	a7,18
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e40:	48a1                	li	a7,8
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <link>:
.global link
link:
 li a7, SYS_link
     e48:	48cd                	li	a7,19
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e50:	48d1                	li	a7,20
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e58:	48a5                	li	a7,9
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e60:	48a9                	li	a7,10
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e68:	48ad                	li	a7,11
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e70:	48b1                	li	a7,12
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e78:	48b5                	li	a7,13
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e80:	48b9                	li	a7,14
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     e88:	48d9                	li	a7,22
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     e90:	48dd                	li	a7,23
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e98:	1101                	addi	sp,sp,-32
     e9a:	ec06                	sd	ra,24(sp)
     e9c:	e822                	sd	s0,16(sp)
     e9e:	1000                	addi	s0,sp,32
     ea0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ea4:	4605                	li	a2,1
     ea6:	fef40593          	addi	a1,s0,-17
     eaa:	00000097          	auipc	ra,0x0
     eae:	f5e080e7          	jalr	-162(ra) # e08 <write>
}
     eb2:	60e2                	ld	ra,24(sp)
     eb4:	6442                	ld	s0,16(sp)
     eb6:	6105                	addi	sp,sp,32
     eb8:	8082                	ret

0000000000000eba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eba:	7139                	addi	sp,sp,-64
     ebc:	fc06                	sd	ra,56(sp)
     ebe:	f822                	sd	s0,48(sp)
     ec0:	f426                	sd	s1,40(sp)
     ec2:	f04a                	sd	s2,32(sp)
     ec4:	ec4e                	sd	s3,24(sp)
     ec6:	0080                	addi	s0,sp,64
     ec8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     eca:	c299                	beqz	a3,ed0 <printint+0x16>
     ecc:	0805c963          	bltz	a1,f5e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ed0:	2581                	sext.w	a1,a1
  neg = 0;
     ed2:	4881                	li	a7,0
     ed4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ed8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     eda:	2601                	sext.w	a2,a2
     edc:	00000517          	auipc	a0,0x0
     ee0:	7d450513          	addi	a0,a0,2004 # 16b0 <digits>
     ee4:	883a                	mv	a6,a4
     ee6:	2705                	addiw	a4,a4,1
     ee8:	02c5f7bb          	remuw	a5,a1,a2
     eec:	1782                	slli	a5,a5,0x20
     eee:	9381                	srli	a5,a5,0x20
     ef0:	97aa                	add	a5,a5,a0
     ef2:	0007c783          	lbu	a5,0(a5)
     ef6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     efa:	0005879b          	sext.w	a5,a1
     efe:	02c5d5bb          	divuw	a1,a1,a2
     f02:	0685                	addi	a3,a3,1
     f04:	fec7f0e3          	bgeu	a5,a2,ee4 <printint+0x2a>
  if(neg)
     f08:	00088c63          	beqz	a7,f20 <printint+0x66>
    buf[i++] = '-';
     f0c:	fd070793          	addi	a5,a4,-48
     f10:	00878733          	add	a4,a5,s0
     f14:	02d00793          	li	a5,45
     f18:	fef70823          	sb	a5,-16(a4)
     f1c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f20:	02e05863          	blez	a4,f50 <printint+0x96>
     f24:	fc040793          	addi	a5,s0,-64
     f28:	00e78933          	add	s2,a5,a4
     f2c:	fff78993          	addi	s3,a5,-1
     f30:	99ba                	add	s3,s3,a4
     f32:	377d                	addiw	a4,a4,-1
     f34:	1702                	slli	a4,a4,0x20
     f36:	9301                	srli	a4,a4,0x20
     f38:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f3c:	fff94583          	lbu	a1,-1(s2)
     f40:	8526                	mv	a0,s1
     f42:	00000097          	auipc	ra,0x0
     f46:	f56080e7          	jalr	-170(ra) # e98 <putc>
  while(--i >= 0)
     f4a:	197d                	addi	s2,s2,-1
     f4c:	ff3918e3          	bne	s2,s3,f3c <printint+0x82>
}
     f50:	70e2                	ld	ra,56(sp)
     f52:	7442                	ld	s0,48(sp)
     f54:	74a2                	ld	s1,40(sp)
     f56:	7902                	ld	s2,32(sp)
     f58:	69e2                	ld	s3,24(sp)
     f5a:	6121                	addi	sp,sp,64
     f5c:	8082                	ret
    x = -xx;
     f5e:	40b005bb          	negw	a1,a1
    neg = 1;
     f62:	4885                	li	a7,1
    x = -xx;
     f64:	bf85                	j	ed4 <printint+0x1a>

0000000000000f66 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f66:	7119                	addi	sp,sp,-128
     f68:	fc86                	sd	ra,120(sp)
     f6a:	f8a2                	sd	s0,112(sp)
     f6c:	f4a6                	sd	s1,104(sp)
     f6e:	f0ca                	sd	s2,96(sp)
     f70:	ecce                	sd	s3,88(sp)
     f72:	e8d2                	sd	s4,80(sp)
     f74:	e4d6                	sd	s5,72(sp)
     f76:	e0da                	sd	s6,64(sp)
     f78:	fc5e                	sd	s7,56(sp)
     f7a:	f862                	sd	s8,48(sp)
     f7c:	f466                	sd	s9,40(sp)
     f7e:	f06a                	sd	s10,32(sp)
     f80:	ec6e                	sd	s11,24(sp)
     f82:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f84:	0005c903          	lbu	s2,0(a1)
     f88:	18090f63          	beqz	s2,1126 <vprintf+0x1c0>
     f8c:	8aaa                	mv	s5,a0
     f8e:	8b32                	mv	s6,a2
     f90:	00158493          	addi	s1,a1,1
  state = 0;
     f94:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f96:	02500a13          	li	s4,37
     f9a:	4c55                	li	s8,21
     f9c:	00000c97          	auipc	s9,0x0
     fa0:	6bcc8c93          	addi	s9,s9,1724 # 1658 <malloc+0x42e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     fa4:	02800d93          	li	s11,40
  putc(fd, 'x');
     fa8:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     faa:	00000b97          	auipc	s7,0x0
     fae:	706b8b93          	addi	s7,s7,1798 # 16b0 <digits>
     fb2:	a839                	j	fd0 <vprintf+0x6a>
        putc(fd, c);
     fb4:	85ca                	mv	a1,s2
     fb6:	8556                	mv	a0,s5
     fb8:	00000097          	auipc	ra,0x0
     fbc:	ee0080e7          	jalr	-288(ra) # e98 <putc>
     fc0:	a019                	j	fc6 <vprintf+0x60>
    } else if(state == '%'){
     fc2:	01498d63          	beq	s3,s4,fdc <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     fc6:	0485                	addi	s1,s1,1
     fc8:	fff4c903          	lbu	s2,-1(s1)
     fcc:	14090d63          	beqz	s2,1126 <vprintf+0x1c0>
    if(state == 0){
     fd0:	fe0999e3          	bnez	s3,fc2 <vprintf+0x5c>
      if(c == '%'){
     fd4:	ff4910e3          	bne	s2,s4,fb4 <vprintf+0x4e>
        state = '%';
     fd8:	89d2                	mv	s3,s4
     fda:	b7f5                	j	fc6 <vprintf+0x60>
      if(c == 'd'){
     fdc:	11490c63          	beq	s2,s4,10f4 <vprintf+0x18e>
     fe0:	f9d9079b          	addiw	a5,s2,-99
     fe4:	0ff7f793          	zext.b	a5,a5
     fe8:	10fc6e63          	bltu	s8,a5,1104 <vprintf+0x19e>
     fec:	f9d9079b          	addiw	a5,s2,-99
     ff0:	0ff7f713          	zext.b	a4,a5
     ff4:	10ec6863          	bltu	s8,a4,1104 <vprintf+0x19e>
     ff8:	00271793          	slli	a5,a4,0x2
     ffc:	97e6                	add	a5,a5,s9
     ffe:	439c                	lw	a5,0(a5)
    1000:	97e6                	add	a5,a5,s9
    1002:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1004:	008b0913          	addi	s2,s6,8
    1008:	4685                	li	a3,1
    100a:	4629                	li	a2,10
    100c:	000b2583          	lw	a1,0(s6)
    1010:	8556                	mv	a0,s5
    1012:	00000097          	auipc	ra,0x0
    1016:	ea8080e7          	jalr	-344(ra) # eba <printint>
    101a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    101c:	4981                	li	s3,0
    101e:	b765                	j	fc6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1020:	008b0913          	addi	s2,s6,8
    1024:	4681                	li	a3,0
    1026:	4629                	li	a2,10
    1028:	000b2583          	lw	a1,0(s6)
    102c:	8556                	mv	a0,s5
    102e:	00000097          	auipc	ra,0x0
    1032:	e8c080e7          	jalr	-372(ra) # eba <printint>
    1036:	8b4a                	mv	s6,s2
      state = 0;
    1038:	4981                	li	s3,0
    103a:	b771                	j	fc6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    103c:	008b0913          	addi	s2,s6,8
    1040:	4681                	li	a3,0
    1042:	866a                	mv	a2,s10
    1044:	000b2583          	lw	a1,0(s6)
    1048:	8556                	mv	a0,s5
    104a:	00000097          	auipc	ra,0x0
    104e:	e70080e7          	jalr	-400(ra) # eba <printint>
    1052:	8b4a                	mv	s6,s2
      state = 0;
    1054:	4981                	li	s3,0
    1056:	bf85                	j	fc6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1058:	008b0793          	addi	a5,s6,8
    105c:	f8f43423          	sd	a5,-120(s0)
    1060:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1064:	03000593          	li	a1,48
    1068:	8556                	mv	a0,s5
    106a:	00000097          	auipc	ra,0x0
    106e:	e2e080e7          	jalr	-466(ra) # e98 <putc>
  putc(fd, 'x');
    1072:	07800593          	li	a1,120
    1076:	8556                	mv	a0,s5
    1078:	00000097          	auipc	ra,0x0
    107c:	e20080e7          	jalr	-480(ra) # e98 <putc>
    1080:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1082:	03c9d793          	srli	a5,s3,0x3c
    1086:	97de                	add	a5,a5,s7
    1088:	0007c583          	lbu	a1,0(a5)
    108c:	8556                	mv	a0,s5
    108e:	00000097          	auipc	ra,0x0
    1092:	e0a080e7          	jalr	-502(ra) # e98 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1096:	0992                	slli	s3,s3,0x4
    1098:	397d                	addiw	s2,s2,-1
    109a:	fe0914e3          	bnez	s2,1082 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    109e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    10a2:	4981                	li	s3,0
    10a4:	b70d                	j	fc6 <vprintf+0x60>
        s = va_arg(ap, char*);
    10a6:	008b0913          	addi	s2,s6,8
    10aa:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    10ae:	02098163          	beqz	s3,10d0 <vprintf+0x16a>
        while(*s != 0){
    10b2:	0009c583          	lbu	a1,0(s3)
    10b6:	c5ad                	beqz	a1,1120 <vprintf+0x1ba>
          putc(fd, *s);
    10b8:	8556                	mv	a0,s5
    10ba:	00000097          	auipc	ra,0x0
    10be:	dde080e7          	jalr	-546(ra) # e98 <putc>
          s++;
    10c2:	0985                	addi	s3,s3,1
        while(*s != 0){
    10c4:	0009c583          	lbu	a1,0(s3)
    10c8:	f9e5                	bnez	a1,10b8 <vprintf+0x152>
        s = va_arg(ap, char*);
    10ca:	8b4a                	mv	s6,s2
      state = 0;
    10cc:	4981                	li	s3,0
    10ce:	bde5                	j	fc6 <vprintf+0x60>
          s = "(null)";
    10d0:	00000997          	auipc	s3,0x0
    10d4:	58098993          	addi	s3,s3,1408 # 1650 <malloc+0x426>
        while(*s != 0){
    10d8:	85ee                	mv	a1,s11
    10da:	bff9                	j	10b8 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    10dc:	008b0913          	addi	s2,s6,8
    10e0:	000b4583          	lbu	a1,0(s6)
    10e4:	8556                	mv	a0,s5
    10e6:	00000097          	auipc	ra,0x0
    10ea:	db2080e7          	jalr	-590(ra) # e98 <putc>
    10ee:	8b4a                	mv	s6,s2
      state = 0;
    10f0:	4981                	li	s3,0
    10f2:	bdd1                	j	fc6 <vprintf+0x60>
        putc(fd, c);
    10f4:	85d2                	mv	a1,s4
    10f6:	8556                	mv	a0,s5
    10f8:	00000097          	auipc	ra,0x0
    10fc:	da0080e7          	jalr	-608(ra) # e98 <putc>
      state = 0;
    1100:	4981                	li	s3,0
    1102:	b5d1                	j	fc6 <vprintf+0x60>
        putc(fd, '%');
    1104:	85d2                	mv	a1,s4
    1106:	8556                	mv	a0,s5
    1108:	00000097          	auipc	ra,0x0
    110c:	d90080e7          	jalr	-624(ra) # e98 <putc>
        putc(fd, c);
    1110:	85ca                	mv	a1,s2
    1112:	8556                	mv	a0,s5
    1114:	00000097          	auipc	ra,0x0
    1118:	d84080e7          	jalr	-636(ra) # e98 <putc>
      state = 0;
    111c:	4981                	li	s3,0
    111e:	b565                	j	fc6 <vprintf+0x60>
        s = va_arg(ap, char*);
    1120:	8b4a                	mv	s6,s2
      state = 0;
    1122:	4981                	li	s3,0
    1124:	b54d                	j	fc6 <vprintf+0x60>
    }
  }
}
    1126:	70e6                	ld	ra,120(sp)
    1128:	7446                	ld	s0,112(sp)
    112a:	74a6                	ld	s1,104(sp)
    112c:	7906                	ld	s2,96(sp)
    112e:	69e6                	ld	s3,88(sp)
    1130:	6a46                	ld	s4,80(sp)
    1132:	6aa6                	ld	s5,72(sp)
    1134:	6b06                	ld	s6,64(sp)
    1136:	7be2                	ld	s7,56(sp)
    1138:	7c42                	ld	s8,48(sp)
    113a:	7ca2                	ld	s9,40(sp)
    113c:	7d02                	ld	s10,32(sp)
    113e:	6de2                	ld	s11,24(sp)
    1140:	6109                	addi	sp,sp,128
    1142:	8082                	ret

0000000000001144 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1144:	715d                	addi	sp,sp,-80
    1146:	ec06                	sd	ra,24(sp)
    1148:	e822                	sd	s0,16(sp)
    114a:	1000                	addi	s0,sp,32
    114c:	e010                	sd	a2,0(s0)
    114e:	e414                	sd	a3,8(s0)
    1150:	e818                	sd	a4,16(s0)
    1152:	ec1c                	sd	a5,24(s0)
    1154:	03043023          	sd	a6,32(s0)
    1158:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    115c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1160:	8622                	mv	a2,s0
    1162:	00000097          	auipc	ra,0x0
    1166:	e04080e7          	jalr	-508(ra) # f66 <vprintf>
}
    116a:	60e2                	ld	ra,24(sp)
    116c:	6442                	ld	s0,16(sp)
    116e:	6161                	addi	sp,sp,80
    1170:	8082                	ret

0000000000001172 <printf>:

void
printf(const char *fmt, ...)
{
    1172:	711d                	addi	sp,sp,-96
    1174:	ec06                	sd	ra,24(sp)
    1176:	e822                	sd	s0,16(sp)
    1178:	1000                	addi	s0,sp,32
    117a:	e40c                	sd	a1,8(s0)
    117c:	e810                	sd	a2,16(s0)
    117e:	ec14                	sd	a3,24(s0)
    1180:	f018                	sd	a4,32(s0)
    1182:	f41c                	sd	a5,40(s0)
    1184:	03043823          	sd	a6,48(s0)
    1188:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    118c:	00840613          	addi	a2,s0,8
    1190:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1194:	85aa                	mv	a1,a0
    1196:	4505                	li	a0,1
    1198:	00000097          	auipc	ra,0x0
    119c:	dce080e7          	jalr	-562(ra) # f66 <vprintf>
}
    11a0:	60e2                	ld	ra,24(sp)
    11a2:	6442                	ld	s0,16(sp)
    11a4:	6125                	addi	sp,sp,96
    11a6:	8082                	ret

00000000000011a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11a8:	1141                	addi	sp,sp,-16
    11aa:	e422                	sd	s0,8(sp)
    11ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11b2:	00000797          	auipc	a5,0x0
    11b6:	51e7b783          	ld	a5,1310(a5) # 16d0 <freep>
    11ba:	a02d                	j	11e4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11bc:	4618                	lw	a4,8(a2)
    11be:	9f2d                	addw	a4,a4,a1
    11c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11c4:	6398                	ld	a4,0(a5)
    11c6:	6310                	ld	a2,0(a4)
    11c8:	a83d                	j	1206 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11ca:	ff852703          	lw	a4,-8(a0)
    11ce:	9f31                	addw	a4,a4,a2
    11d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11d2:	ff053683          	ld	a3,-16(a0)
    11d6:	a091                	j	121a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11d8:	6398                	ld	a4,0(a5)
    11da:	00e7e463          	bltu	a5,a4,11e2 <free+0x3a>
    11de:	00e6ea63          	bltu	a3,a4,11f2 <free+0x4a>
{
    11e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e4:	fed7fae3          	bgeu	a5,a3,11d8 <free+0x30>
    11e8:	6398                	ld	a4,0(a5)
    11ea:	00e6e463          	bltu	a3,a4,11f2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ee:	fee7eae3          	bltu	a5,a4,11e2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11f2:	ff852583          	lw	a1,-8(a0)
    11f6:	6390                	ld	a2,0(a5)
    11f8:	02059813          	slli	a6,a1,0x20
    11fc:	01c85713          	srli	a4,a6,0x1c
    1200:	9736                	add	a4,a4,a3
    1202:	fae60de3          	beq	a2,a4,11bc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1206:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    120a:	4790                	lw	a2,8(a5)
    120c:	02061593          	slli	a1,a2,0x20
    1210:	01c5d713          	srli	a4,a1,0x1c
    1214:	973e                	add	a4,a4,a5
    1216:	fae68ae3          	beq	a3,a4,11ca <free+0x22>
    p->s.ptr = bp->s.ptr;
    121a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    121c:	00000717          	auipc	a4,0x0
    1220:	4af73a23          	sd	a5,1204(a4) # 16d0 <freep>
}
    1224:	6422                	ld	s0,8(sp)
    1226:	0141                	addi	sp,sp,16
    1228:	8082                	ret

000000000000122a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    122a:	7139                	addi	sp,sp,-64
    122c:	fc06                	sd	ra,56(sp)
    122e:	f822                	sd	s0,48(sp)
    1230:	f426                	sd	s1,40(sp)
    1232:	f04a                	sd	s2,32(sp)
    1234:	ec4e                	sd	s3,24(sp)
    1236:	e852                	sd	s4,16(sp)
    1238:	e456                	sd	s5,8(sp)
    123a:	e05a                	sd	s6,0(sp)
    123c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    123e:	02051493          	slli	s1,a0,0x20
    1242:	9081                	srli	s1,s1,0x20
    1244:	04bd                	addi	s1,s1,15
    1246:	8091                	srli	s1,s1,0x4
    1248:	0014899b          	addiw	s3,s1,1
    124c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    124e:	00000517          	auipc	a0,0x0
    1252:	48253503          	ld	a0,1154(a0) # 16d0 <freep>
    1256:	c515                	beqz	a0,1282 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1258:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    125a:	4798                	lw	a4,8(a5)
    125c:	02977f63          	bgeu	a4,s1,129a <malloc+0x70>
    1260:	8a4e                	mv	s4,s3
    1262:	0009871b          	sext.w	a4,s3
    1266:	6685                	lui	a3,0x1
    1268:	00d77363          	bgeu	a4,a3,126e <malloc+0x44>
    126c:	6a05                	lui	s4,0x1
    126e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1272:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1276:	00000917          	auipc	s2,0x0
    127a:	45a90913          	addi	s2,s2,1114 # 16d0 <freep>
  if(p == (char*)-1)
    127e:	5afd                	li	s5,-1
    1280:	a895                	j	12f4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1282:	00001797          	auipc	a5,0x1
    1286:	83e78793          	addi	a5,a5,-1986 # 1ac0 <base>
    128a:	00000717          	auipc	a4,0x0
    128e:	44f73323          	sd	a5,1094(a4) # 16d0 <freep>
    1292:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1294:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1298:	b7e1                	j	1260 <malloc+0x36>
      if(p->s.size == nunits)
    129a:	02e48c63          	beq	s1,a4,12d2 <malloc+0xa8>
        p->s.size -= nunits;
    129e:	4137073b          	subw	a4,a4,s3
    12a2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12a4:	02071693          	slli	a3,a4,0x20
    12a8:	01c6d713          	srli	a4,a3,0x1c
    12ac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12ae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12b2:	00000717          	auipc	a4,0x0
    12b6:	40a73f23          	sd	a0,1054(a4) # 16d0 <freep>
      return (void*)(p + 1);
    12ba:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12be:	70e2                	ld	ra,56(sp)
    12c0:	7442                	ld	s0,48(sp)
    12c2:	74a2                	ld	s1,40(sp)
    12c4:	7902                	ld	s2,32(sp)
    12c6:	69e2                	ld	s3,24(sp)
    12c8:	6a42                	ld	s4,16(sp)
    12ca:	6aa2                	ld	s5,8(sp)
    12cc:	6b02                	ld	s6,0(sp)
    12ce:	6121                	addi	sp,sp,64
    12d0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12d2:	6398                	ld	a4,0(a5)
    12d4:	e118                	sd	a4,0(a0)
    12d6:	bff1                	j	12b2 <malloc+0x88>
  hp->s.size = nu;
    12d8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12dc:	0541                	addi	a0,a0,16
    12de:	00000097          	auipc	ra,0x0
    12e2:	eca080e7          	jalr	-310(ra) # 11a8 <free>
  return freep;
    12e6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12ea:	d971                	beqz	a0,12be <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12ee:	4798                	lw	a4,8(a5)
    12f0:	fa9775e3          	bgeu	a4,s1,129a <malloc+0x70>
    if(p == freep)
    12f4:	00093703          	ld	a4,0(s2)
    12f8:	853e                	mv	a0,a5
    12fa:	fef719e3          	bne	a4,a5,12ec <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    12fe:	8552                	mv	a0,s4
    1300:	00000097          	auipc	ra,0x0
    1304:	b70080e7          	jalr	-1168(ra) # e70 <sbrk>
  if(p == (char*)-1)
    1308:	fd5518e3          	bne	a0,s5,12d8 <malloc+0xae>
        return 0;
    130c:	4501                	li	a0,0
    130e:	bf45                	j	12be <malloc+0x94>
