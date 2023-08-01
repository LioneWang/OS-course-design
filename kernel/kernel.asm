
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8c013103          	ld	sp,-1856(sp) # 800088c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	ff070713          	addi	a4,a4,-16 # 80009040 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	06e78793          	addi	a5,a5,110 # 800060d0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcc7ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dce78793          	addi	a5,a5,-562 # 80000e7a <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  timerinit();
    800000d6:	00000097          	auipc	ra,0x0
    800000da:	f46080e7          	jalr	-186(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000de:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e4:	823e                	mv	tp,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000e6:	57fd                	li	a5,-1
    800000e8:	83a9                	srli	a5,a5,0xa
    800000ea:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000ee:	47fd                	li	a5,31
    800000f0:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	510080e7          	jalr	1296(ra) # 8000263a <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	77e080e7          	jalr	1918(ra) # 800008b8 <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	ff650513          	addi	a0,a0,-10 # 80011180 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a3e080e7          	jalr	-1474(ra) # 80000bd0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	fe648493          	addi	s1,s1,-26 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	07690913          	addi	s2,s2,118 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305863          	blez	s3,80000220 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71463          	bne	a4,a5,800001e4 <consoleread+0x80>
      if(myproc()->killed){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	91c080e7          	jalr	-1764(ra) # 80001adc <myproc>
    800001c8:	591c                	lw	a5,48(a0)
    800001ca:	e7b5                	bnez	a5,80000236 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001cc:	85a6                	mv	a1,s1
    800001ce:	854a                	mv	a0,s2
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	1ba080e7          	jalr	442(ra) # 8000238a <sleep>
    while(cons.r == cons.w){
    800001d8:	0984a783          	lw	a5,152(s1)
    800001dc:	09c4a703          	lw	a4,156(s1)
    800001e0:	fef700e3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001e4:	0017871b          	addiw	a4,a5,1
    800001e8:	08e4ac23          	sw	a4,152(s1)
    800001ec:	07f7f713          	andi	a4,a5,127
    800001f0:	9726                	add	a4,a4,s1
    800001f2:	01874703          	lbu	a4,24(a4)
    800001f6:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001fa:	077d0563          	beq	s10,s7,80000264 <consoleread+0x100>
    cbuf = c;
    800001fe:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000202:	4685                	li	a3,1
    80000204:	f9f40613          	addi	a2,s0,-97
    80000208:	85d2                	mv	a1,s4
    8000020a:	8556                	mv	a0,s5
    8000020c:	00002097          	auipc	ra,0x2
    80000210:	3d8080e7          	jalr	984(ra) # 800025e4 <either_copyout>
    80000214:	01850663          	beq	a0,s8,80000220 <consoleread+0xbc>
    dst++;
    80000218:	0a05                	addi	s4,s4,1
    --n;
    8000021a:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000021c:	f99d1ae3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000220:	00011517          	auipc	a0,0x11
    80000224:	f6050513          	addi	a0,a0,-160 # 80011180 <cons>
    80000228:	00001097          	auipc	ra,0x1
    8000022c:	a5c080e7          	jalr	-1444(ra) # 80000c84 <release>

  return target - n;
    80000230:	413b053b          	subw	a0,s6,s3
    80000234:	a811                	j	80000248 <consoleread+0xe4>
        release(&cons.lock);
    80000236:	00011517          	auipc	a0,0x11
    8000023a:	f4a50513          	addi	a0,a0,-182 # 80011180 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	a46080e7          	jalr	-1466(ra) # 80000c84 <release>
        return -1;
    80000246:	557d                	li	a0,-1
}
    80000248:	70a6                	ld	ra,104(sp)
    8000024a:	7406                	ld	s0,96(sp)
    8000024c:	64e6                	ld	s1,88(sp)
    8000024e:	6946                	ld	s2,80(sp)
    80000250:	69a6                	ld	s3,72(sp)
    80000252:	6a06                	ld	s4,64(sp)
    80000254:	7ae2                	ld	s5,56(sp)
    80000256:	7b42                	ld	s6,48(sp)
    80000258:	7ba2                	ld	s7,40(sp)
    8000025a:	7c02                	ld	s8,32(sp)
    8000025c:	6ce2                	ld	s9,24(sp)
    8000025e:	6d42                	ld	s10,16(sp)
    80000260:	6165                	addi	sp,sp,112
    80000262:	8082                	ret
      if(n < target){
    80000264:	0009871b          	sext.w	a4,s3
    80000268:	fb677ce3          	bgeu	a4,s6,80000220 <consoleread+0xbc>
        cons.r--;
    8000026c:	00011717          	auipc	a4,0x11
    80000270:	faf72623          	sw	a5,-84(a4) # 80011218 <cons+0x98>
    80000274:	b775                	j	80000220 <consoleread+0xbc>

0000000080000276 <consputc>:
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e406                	sd	ra,8(sp)
    8000027a:	e022                	sd	s0,0(sp)
    8000027c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000027e:	10000793          	li	a5,256
    80000282:	00f50a63          	beq	a0,a5,80000296 <consputc+0x20>
    uartputc_sync(c);
    80000286:	00000097          	auipc	ra,0x0
    8000028a:	560080e7          	jalr	1376(ra) # 800007e6 <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	00000097          	auipc	ra,0x0
    8000029c:	54e080e7          	jalr	1358(ra) # 800007e6 <uartputc_sync>
    800002a0:	02000513          	li	a0,32
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	542080e7          	jalr	1346(ra) # 800007e6 <uartputc_sync>
    800002ac:	4521                	li	a0,8
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	538080e7          	jalr	1336(ra) # 800007e6 <uartputc_sync>
    800002b6:	bfe1                	j	8000028e <consputc+0x18>

00000000800002b8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002b8:	1101                	addi	sp,sp,-32
    800002ba:	ec06                	sd	ra,24(sp)
    800002bc:	e822                	sd	s0,16(sp)
    800002be:	e426                	sd	s1,8(sp)
    800002c0:	e04a                	sd	s2,0(sp)
    800002c2:	1000                	addi	s0,sp,32
    800002c4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c6:	00011517          	auipc	a0,0x11
    800002ca:	eba50513          	addi	a0,a0,-326 # 80011180 <cons>
    800002ce:	00001097          	auipc	ra,0x1
    800002d2:	902080e7          	jalr	-1790(ra) # 80000bd0 <acquire>

  switch(c){
    800002d6:	47d5                	li	a5,21
    800002d8:	0af48663          	beq	s1,a5,80000384 <consoleintr+0xcc>
    800002dc:	0297ca63          	blt	a5,s1,80000310 <consoleintr+0x58>
    800002e0:	47a1                	li	a5,8
    800002e2:	0ef48763          	beq	s1,a5,800003d0 <consoleintr+0x118>
    800002e6:	47c1                	li	a5,16
    800002e8:	10f49a63          	bne	s1,a5,800003fc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002ec:	00002097          	auipc	ra,0x2
    800002f0:	3a4080e7          	jalr	932(ra) # 80002690 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f4:	00011517          	auipc	a0,0x11
    800002f8:	e8c50513          	addi	a0,a0,-372 # 80011180 <cons>
    800002fc:	00001097          	auipc	ra,0x1
    80000300:	988080e7          	jalr	-1656(ra) # 80000c84 <release>
}
    80000304:	60e2                	ld	ra,24(sp)
    80000306:	6442                	ld	s0,16(sp)
    80000308:	64a2                	ld	s1,8(sp)
    8000030a:	6902                	ld	s2,0(sp)
    8000030c:	6105                	addi	sp,sp,32
    8000030e:	8082                	ret
  switch(c){
    80000310:	07f00793          	li	a5,127
    80000314:	0af48e63          	beq	s1,a5,800003d0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000318:	00011717          	auipc	a4,0x11
    8000031c:	e6870713          	addi	a4,a4,-408 # 80011180 <cons>
    80000320:	0a072783          	lw	a5,160(a4)
    80000324:	09872703          	lw	a4,152(a4)
    80000328:	9f99                	subw	a5,a5,a4
    8000032a:	07f00713          	li	a4,127
    8000032e:	fcf763e3          	bltu	a4,a5,800002f4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000332:	47b5                	li	a5,13
    80000334:	0cf48763          	beq	s1,a5,80000402 <consoleintr+0x14a>
      consputc(c);
    80000338:	8526                	mv	a0,s1
    8000033a:	00000097          	auipc	ra,0x0
    8000033e:	f3c080e7          	jalr	-196(ra) # 80000276 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000342:	00011797          	auipc	a5,0x11
    80000346:	e3e78793          	addi	a5,a5,-450 # 80011180 <cons>
    8000034a:	0a07a703          	lw	a4,160(a5)
    8000034e:	0017069b          	addiw	a3,a4,1
    80000352:	0006861b          	sext.w	a2,a3
    80000356:	0ad7a023          	sw	a3,160(a5)
    8000035a:	07f77713          	andi	a4,a4,127
    8000035e:	97ba                	add	a5,a5,a4
    80000360:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000364:	47a9                	li	a5,10
    80000366:	0cf48563          	beq	s1,a5,80000430 <consoleintr+0x178>
    8000036a:	4791                	li	a5,4
    8000036c:	0cf48263          	beq	s1,a5,80000430 <consoleintr+0x178>
    80000370:	00011797          	auipc	a5,0x11
    80000374:	ea87a783          	lw	a5,-344(a5) # 80011218 <cons+0x98>
    80000378:	0807879b          	addiw	a5,a5,128
    8000037c:	f6f61ce3          	bne	a2,a5,800002f4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000380:	863e                	mv	a2,a5
    80000382:	a07d                	j	80000430 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000384:	00011717          	auipc	a4,0x11
    80000388:	dfc70713          	addi	a4,a4,-516 # 80011180 <cons>
    8000038c:	0a072783          	lw	a5,160(a4)
    80000390:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	00011497          	auipc	s1,0x11
    80000398:	dec48493          	addi	s1,s1,-532 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000039c:	4929                	li	s2,10
    8000039e:	f4f70be3          	beq	a4,a5,800002f4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a2:	37fd                	addiw	a5,a5,-1
    800003a4:	07f7f713          	andi	a4,a5,127
    800003a8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003aa:	01874703          	lbu	a4,24(a4)
    800003ae:	f52703e3          	beq	a4,s2,800002f4 <consoleintr+0x3c>
      cons.e--;
    800003b2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003b6:	10000513          	li	a0,256
    800003ba:	00000097          	auipc	ra,0x0
    800003be:	ebc080e7          	jalr	-324(ra) # 80000276 <consputc>
    while(cons.e != cons.w &&
    800003c2:	0a04a783          	lw	a5,160(s1)
    800003c6:	09c4a703          	lw	a4,156(s1)
    800003ca:	fcf71ce3          	bne	a4,a5,800003a2 <consoleintr+0xea>
    800003ce:	b71d                	j	800002f4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d0:	00011717          	auipc	a4,0x11
    800003d4:	db070713          	addi	a4,a4,-592 # 80011180 <cons>
    800003d8:	0a072783          	lw	a5,160(a4)
    800003dc:	09c72703          	lw	a4,156(a4)
    800003e0:	f0f70ae3          	beq	a4,a5,800002f4 <consoleintr+0x3c>
      cons.e--;
    800003e4:	37fd                	addiw	a5,a5,-1
    800003e6:	00011717          	auipc	a4,0x11
    800003ea:	e2f72d23          	sw	a5,-454(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003ee:	10000513          	li	a0,256
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	e84080e7          	jalr	-380(ra) # 80000276 <consputc>
    800003fa:	bded                	j	800002f4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003fc:	ee048ce3          	beqz	s1,800002f4 <consoleintr+0x3c>
    80000400:	bf21                	j	80000318 <consoleintr+0x60>
      consputc(c);
    80000402:	4529                	li	a0,10
    80000404:	00000097          	auipc	ra,0x0
    80000408:	e72080e7          	jalr	-398(ra) # 80000276 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000040c:	00011797          	auipc	a5,0x11
    80000410:	d7478793          	addi	a5,a5,-652 # 80011180 <cons>
    80000414:	0a07a703          	lw	a4,160(a5)
    80000418:	0017069b          	addiw	a3,a4,1
    8000041c:	0006861b          	sext.w	a2,a3
    80000420:	0ad7a023          	sw	a3,160(a5)
    80000424:	07f77713          	andi	a4,a4,127
    80000428:	97ba                	add	a5,a5,a4
    8000042a:	4729                	li	a4,10
    8000042c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000430:	00011797          	auipc	a5,0x11
    80000434:	dec7a623          	sw	a2,-532(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    80000438:	00011517          	auipc	a0,0x11
    8000043c:	de050513          	addi	a0,a0,-544 # 80011218 <cons+0x98>
    80000440:	00002097          	auipc	ra,0x2
    80000444:	0ca080e7          	jalr	202(ra) # 8000250a <wakeup>
    80000448:	b575                	j	800002f4 <consoleintr+0x3c>

000000008000044a <consoleinit>:

void
consoleinit(void)
{
    8000044a:	1141                	addi	sp,sp,-16
    8000044c:	e406                	sd	ra,8(sp)
    8000044e:	e022                	sd	s0,0(sp)
    80000450:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000452:	00008597          	auipc	a1,0x8
    80000456:	bbe58593          	addi	a1,a1,-1090 # 80008010 <etext+0x10>
    8000045a:	00011517          	auipc	a0,0x11
    8000045e:	d2650513          	addi	a0,a0,-730 # 80011180 <cons>
    80000462:	00000097          	auipc	ra,0x0
    80000466:	6de080e7          	jalr	1758(ra) # 80000b40 <initlock>

  uartinit();
    8000046a:	00000097          	auipc	ra,0x0
    8000046e:	32c080e7          	jalr	812(ra) # 80000796 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000472:	0002d797          	auipc	a5,0x2d
    80000476:	e8e78793          	addi	a5,a5,-370 # 8002d300 <devsw>
    8000047a:	00000717          	auipc	a4,0x0
    8000047e:	cea70713          	addi	a4,a4,-790 # 80000164 <consoleread>
    80000482:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000484:	00000717          	auipc	a4,0x0
    80000488:	c7c70713          	addi	a4,a4,-900 # 80000100 <consolewrite>
    8000048c:	ef98                	sd	a4,24(a5)
}
    8000048e:	60a2                	ld	ra,8(sp)
    80000490:	6402                	ld	s0,0(sp)
    80000492:	0141                	addi	sp,sp,16
    80000494:	8082                	ret

0000000080000496 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000496:	7179                	addi	sp,sp,-48
    80000498:	f406                	sd	ra,40(sp)
    8000049a:	f022                	sd	s0,32(sp)
    8000049c:	ec26                	sd	s1,24(sp)
    8000049e:	e84a                	sd	s2,16(sp)
    800004a0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a2:	c219                	beqz	a2,800004a8 <printint+0x12>
    800004a4:	08054763          	bltz	a0,80000532 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004a8:	2501                	sext.w	a0,a0
    800004aa:	4881                	li	a7,0
    800004ac:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b2:	2581                	sext.w	a1,a1
    800004b4:	00008617          	auipc	a2,0x8
    800004b8:	b8c60613          	addi	a2,a2,-1140 # 80008040 <digits>
    800004bc:	883a                	mv	a6,a4
    800004be:	2705                	addiw	a4,a4,1
    800004c0:	02b577bb          	remuw	a5,a0,a1
    800004c4:	1782                	slli	a5,a5,0x20
    800004c6:	9381                	srli	a5,a5,0x20
    800004c8:	97b2                	add	a5,a5,a2
    800004ca:	0007c783          	lbu	a5,0(a5)
    800004ce:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d2:	0005079b          	sext.w	a5,a0
    800004d6:	02b5553b          	divuw	a0,a0,a1
    800004da:	0685                	addi	a3,a3,1
    800004dc:	feb7f0e3          	bgeu	a5,a1,800004bc <printint+0x26>

  if(sign)
    800004e0:	00088c63          	beqz	a7,800004f8 <printint+0x62>
    buf[i++] = '-';
    800004e4:	fe070793          	addi	a5,a4,-32
    800004e8:	00878733          	add	a4,a5,s0
    800004ec:	02d00793          	li	a5,45
    800004f0:	fef70823          	sb	a5,-16(a4)
    800004f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004f8:	02e05763          	blez	a4,80000526 <printint+0x90>
    800004fc:	fd040793          	addi	a5,s0,-48
    80000500:	00e784b3          	add	s1,a5,a4
    80000504:	fff78913          	addi	s2,a5,-1
    80000508:	993a                	add	s2,s2,a4
    8000050a:	377d                	addiw	a4,a4,-1
    8000050c:	1702                	slli	a4,a4,0x20
    8000050e:	9301                	srli	a4,a4,0x20
    80000510:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000514:	fff4c503          	lbu	a0,-1(s1)
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	d5e080e7          	jalr	-674(ra) # 80000276 <consputc>
  while(--i >= 0)
    80000520:	14fd                	addi	s1,s1,-1
    80000522:	ff2499e3          	bne	s1,s2,80000514 <printint+0x7e>
}
    80000526:	70a2                	ld	ra,40(sp)
    80000528:	7402                	ld	s0,32(sp)
    8000052a:	64e2                	ld	s1,24(sp)
    8000052c:	6942                	ld	s2,16(sp)
    8000052e:	6145                	addi	sp,sp,48
    80000530:	8082                	ret
    x = -xx;
    80000532:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000536:	4885                	li	a7,1
    x = -xx;
    80000538:	bf95                	j	800004ac <printint+0x16>

000000008000053a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053a:	1101                	addi	sp,sp,-32
    8000053c:	ec06                	sd	ra,24(sp)
    8000053e:	e822                	sd	s0,16(sp)
    80000540:	e426                	sd	s1,8(sp)
    80000542:	1000                	addi	s0,sp,32
    80000544:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000546:	00011797          	auipc	a5,0x11
    8000054a:	ce07ad23          	sw	zero,-774(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000054e:	00008517          	auipc	a0,0x8
    80000552:	aca50513          	addi	a0,a0,-1334 # 80008018 <etext+0x18>
    80000556:	00000097          	auipc	ra,0x0
    8000055a:	02e080e7          	jalr	46(ra) # 80000584 <printf>
  printf(s);
    8000055e:	8526                	mv	a0,s1
    80000560:	00000097          	auipc	ra,0x0
    80000564:	024080e7          	jalr	36(ra) # 80000584 <printf>
  printf("\n");
    80000568:	00008517          	auipc	a0,0x8
    8000056c:	b6050513          	addi	a0,a0,-1184 # 800080c8 <digits+0x88>
    80000570:	00000097          	auipc	ra,0x0
    80000574:	014080e7          	jalr	20(ra) # 80000584 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000578:	4785                	li	a5,1
    8000057a:	00009717          	auipc	a4,0x9
    8000057e:	a8f72323          	sw	a5,-1402(a4) # 80009000 <panicked>
  for(;;)
    80000582:	a001                	j	80000582 <panic+0x48>

0000000080000584 <printf>:
{
    80000584:	7131                	addi	sp,sp,-192
    80000586:	fc86                	sd	ra,120(sp)
    80000588:	f8a2                	sd	s0,112(sp)
    8000058a:	f4a6                	sd	s1,104(sp)
    8000058c:	f0ca                	sd	s2,96(sp)
    8000058e:	ecce                	sd	s3,88(sp)
    80000590:	e8d2                	sd	s4,80(sp)
    80000592:	e4d6                	sd	s5,72(sp)
    80000594:	e0da                	sd	s6,64(sp)
    80000596:	fc5e                	sd	s7,56(sp)
    80000598:	f862                	sd	s8,48(sp)
    8000059a:	f466                	sd	s9,40(sp)
    8000059c:	f06a                	sd	s10,32(sp)
    8000059e:	ec6e                	sd	s11,24(sp)
    800005a0:	0100                	addi	s0,sp,128
    800005a2:	8a2a                	mv	s4,a0
    800005a4:	e40c                	sd	a1,8(s0)
    800005a6:	e810                	sd	a2,16(s0)
    800005a8:	ec14                	sd	a3,24(s0)
    800005aa:	f018                	sd	a4,32(s0)
    800005ac:	f41c                	sd	a5,40(s0)
    800005ae:	03043823          	sd	a6,48(s0)
    800005b2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005b6:	00011d97          	auipc	s11,0x11
    800005ba:	c8adad83          	lw	s11,-886(s11) # 80011240 <pr+0x18>
  if(locking)
    800005be:	020d9b63          	bnez	s11,800005f4 <printf+0x70>
  if (fmt == 0)
    800005c2:	040a0263          	beqz	s4,80000606 <printf+0x82>
  va_start(ap, fmt);
    800005c6:	00840793          	addi	a5,s0,8
    800005ca:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005ce:	000a4503          	lbu	a0,0(s4)
    800005d2:	14050f63          	beqz	a0,80000730 <printf+0x1ac>
    800005d6:	4981                	li	s3,0
    if(c != '%'){
    800005d8:	02500a93          	li	s5,37
    switch(c){
    800005dc:	07000b93          	li	s7,112
  consputc('x');
    800005e0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e2:	00008b17          	auipc	s6,0x8
    800005e6:	a5eb0b13          	addi	s6,s6,-1442 # 80008040 <digits>
    switch(c){
    800005ea:	07300c93          	li	s9,115
    800005ee:	06400c13          	li	s8,100
    800005f2:	a82d                	j	8000062c <printf+0xa8>
    acquire(&pr.lock);
    800005f4:	00011517          	auipc	a0,0x11
    800005f8:	c3450513          	addi	a0,a0,-972 # 80011228 <pr>
    800005fc:	00000097          	auipc	ra,0x0
    80000600:	5d4080e7          	jalr	1492(ra) # 80000bd0 <acquire>
    80000604:	bf7d                	j	800005c2 <printf+0x3e>
    panic("null fmt");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a2250513          	addi	a0,a0,-1502 # 80008028 <etext+0x28>
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	f2c080e7          	jalr	-212(ra) # 8000053a <panic>
      consputc(c);
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	c60080e7          	jalr	-928(ra) # 80000276 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000061e:	2985                	addiw	s3,s3,1
    80000620:	013a07b3          	add	a5,s4,s3
    80000624:	0007c503          	lbu	a0,0(a5)
    80000628:	10050463          	beqz	a0,80000730 <printf+0x1ac>
    if(c != '%'){
    8000062c:	ff5515e3          	bne	a0,s5,80000616 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000630:	2985                	addiw	s3,s3,1
    80000632:	013a07b3          	add	a5,s4,s3
    80000636:	0007c783          	lbu	a5,0(a5)
    8000063a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000063e:	cbed                	beqz	a5,80000730 <printf+0x1ac>
    switch(c){
    80000640:	05778a63          	beq	a5,s7,80000694 <printf+0x110>
    80000644:	02fbf663          	bgeu	s7,a5,80000670 <printf+0xec>
    80000648:	09978863          	beq	a5,s9,800006d8 <printf+0x154>
    8000064c:	07800713          	li	a4,120
    80000650:	0ce79563          	bne	a5,a4,8000071a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000654:	f8843783          	ld	a5,-120(s0)
    80000658:	00878713          	addi	a4,a5,8
    8000065c:	f8e43423          	sd	a4,-120(s0)
    80000660:	4605                	li	a2,1
    80000662:	85ea                	mv	a1,s10
    80000664:	4388                	lw	a0,0(a5)
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	e30080e7          	jalr	-464(ra) # 80000496 <printint>
      break;
    8000066e:	bf45                	j	8000061e <printf+0x9a>
    switch(c){
    80000670:	09578f63          	beq	a5,s5,8000070e <printf+0x18a>
    80000674:	0b879363          	bne	a5,s8,8000071a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4605                	li	a2,1
    80000686:	45a9                	li	a1,10
    80000688:	4388                	lw	a0,0(a5)
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	e0c080e7          	jalr	-500(ra) # 80000496 <printint>
      break;
    80000692:	b771                	j	8000061e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a4:	03000513          	li	a0,48
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	bce080e7          	jalr	-1074(ra) # 80000276 <consputc>
  consputc('x');
    800006b0:	07800513          	li	a0,120
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	bc2080e7          	jalr	-1086(ra) # 80000276 <consputc>
    800006bc:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006be:	03c95793          	srli	a5,s2,0x3c
    800006c2:	97da                	add	a5,a5,s6
    800006c4:	0007c503          	lbu	a0,0(a5)
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	bae080e7          	jalr	-1106(ra) # 80000276 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d0:	0912                	slli	s2,s2,0x4
    800006d2:	34fd                	addiw	s1,s1,-1
    800006d4:	f4ed                	bnez	s1,800006be <printf+0x13a>
    800006d6:	b7a1                	j	8000061e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006d8:	f8843783          	ld	a5,-120(s0)
    800006dc:	00878713          	addi	a4,a5,8
    800006e0:	f8e43423          	sd	a4,-120(s0)
    800006e4:	6384                	ld	s1,0(a5)
    800006e6:	cc89                	beqz	s1,80000700 <printf+0x17c>
      for(; *s; s++)
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	d90d                	beqz	a0,8000061e <printf+0x9a>
        consputc(*s);
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	b88080e7          	jalr	-1144(ra) # 80000276 <consputc>
      for(; *s; s++)
    800006f6:	0485                	addi	s1,s1,1
    800006f8:	0004c503          	lbu	a0,0(s1)
    800006fc:	f96d                	bnez	a0,800006ee <printf+0x16a>
    800006fe:	b705                	j	8000061e <printf+0x9a>
        s = "(null)";
    80000700:	00008497          	auipc	s1,0x8
    80000704:	92048493          	addi	s1,s1,-1760 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000708:	02800513          	li	a0,40
    8000070c:	b7cd                	j	800006ee <printf+0x16a>
      consputc('%');
    8000070e:	8556                	mv	a0,s5
    80000710:	00000097          	auipc	ra,0x0
    80000714:	b66080e7          	jalr	-1178(ra) # 80000276 <consputc>
      break;
    80000718:	b719                	j	8000061e <printf+0x9a>
      consputc('%');
    8000071a:	8556                	mv	a0,s5
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	b5a080e7          	jalr	-1190(ra) # 80000276 <consputc>
      consputc(c);
    80000724:	8526                	mv	a0,s1
    80000726:	00000097          	auipc	ra,0x0
    8000072a:	b50080e7          	jalr	-1200(ra) # 80000276 <consputc>
      break;
    8000072e:	bdc5                	j	8000061e <printf+0x9a>
  if(locking)
    80000730:	020d9163          	bnez	s11,80000752 <printf+0x1ce>
}
    80000734:	70e6                	ld	ra,120(sp)
    80000736:	7446                	ld	s0,112(sp)
    80000738:	74a6                	ld	s1,104(sp)
    8000073a:	7906                	ld	s2,96(sp)
    8000073c:	69e6                	ld	s3,88(sp)
    8000073e:	6a46                	ld	s4,80(sp)
    80000740:	6aa6                	ld	s5,72(sp)
    80000742:	6b06                	ld	s6,64(sp)
    80000744:	7be2                	ld	s7,56(sp)
    80000746:	7c42                	ld	s8,48(sp)
    80000748:	7ca2                	ld	s9,40(sp)
    8000074a:	7d02                	ld	s10,32(sp)
    8000074c:	6de2                	ld	s11,24(sp)
    8000074e:	6129                	addi	sp,sp,192
    80000750:	8082                	ret
    release(&pr.lock);
    80000752:	00011517          	auipc	a0,0x11
    80000756:	ad650513          	addi	a0,a0,-1322 # 80011228 <pr>
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	52a080e7          	jalr	1322(ra) # 80000c84 <release>
}
    80000762:	bfc9                	j	80000734 <printf+0x1b0>

0000000080000764 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000764:	1101                	addi	sp,sp,-32
    80000766:	ec06                	sd	ra,24(sp)
    80000768:	e822                	sd	s0,16(sp)
    8000076a:	e426                	sd	s1,8(sp)
    8000076c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000076e:	00011497          	auipc	s1,0x11
    80000772:	aba48493          	addi	s1,s1,-1350 # 80011228 <pr>
    80000776:	00008597          	auipc	a1,0x8
    8000077a:	8c258593          	addi	a1,a1,-1854 # 80008038 <etext+0x38>
    8000077e:	8526                	mv	a0,s1
    80000780:	00000097          	auipc	ra,0x0
    80000784:	3c0080e7          	jalr	960(ra) # 80000b40 <initlock>
  pr.locking = 1;
    80000788:	4785                	li	a5,1
    8000078a:	cc9c                	sw	a5,24(s1)
}
    8000078c:	60e2                	ld	ra,24(sp)
    8000078e:	6442                	ld	s0,16(sp)
    80000790:	64a2                	ld	s1,8(sp)
    80000792:	6105                	addi	sp,sp,32
    80000794:	8082                	ret

0000000080000796 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000796:	1141                	addi	sp,sp,-16
    80000798:	e406                	sd	ra,8(sp)
    8000079a:	e022                	sd	s0,0(sp)
    8000079c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000079e:	100007b7          	lui	a5,0x10000
    800007a2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007a6:	f8000713          	li	a4,-128
    800007aa:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ae:	470d                	li	a4,3
    800007b0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007b8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007bc:	469d                	li	a3,7
    800007be:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007c6:	00008597          	auipc	a1,0x8
    800007ca:	89258593          	addi	a1,a1,-1902 # 80008058 <digits+0x18>
    800007ce:	00011517          	auipc	a0,0x11
    800007d2:	a7a50513          	addi	a0,a0,-1414 # 80011248 <uart_tx_lock>
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	36a080e7          	jalr	874(ra) # 80000b40 <initlock>
}
    800007de:	60a2                	ld	ra,8(sp)
    800007e0:	6402                	ld	s0,0(sp)
    800007e2:	0141                	addi	sp,sp,16
    800007e4:	8082                	ret

00000000800007e6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007e6:	1101                	addi	sp,sp,-32
    800007e8:	ec06                	sd	ra,24(sp)
    800007ea:	e822                	sd	s0,16(sp)
    800007ec:	e426                	sd	s1,8(sp)
    800007ee:	1000                	addi	s0,sp,32
    800007f0:	84aa                	mv	s1,a0
  push_off();
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	392080e7          	jalr	914(ra) # 80000b84 <push_off>

  if(panicked){
    800007fa:	00009797          	auipc	a5,0x9
    800007fe:	8067a783          	lw	a5,-2042(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000802:	10000737          	lui	a4,0x10000
  if(panicked){
    80000806:	c391                	beqz	a5,8000080a <uartputc_sync+0x24>
    for(;;)
    80000808:	a001                	j	80000808 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000080e:	0207f793          	andi	a5,a5,32
    80000812:	dfe5                	beqz	a5,8000080a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000814:	0ff4f513          	zext.b	a0,s1
    80000818:	100007b7          	lui	a5,0x10000
    8000081c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	404080e7          	jalr	1028(ra) # 80000c24 <pop_off>
}
    80000828:	60e2                	ld	ra,24(sp)
    8000082a:	6442                	ld	s0,16(sp)
    8000082c:	64a2                	ld	s1,8(sp)
    8000082e:	6105                	addi	sp,sp,32
    80000830:	8082                	ret

0000000080000832 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000832:	00008797          	auipc	a5,0x8
    80000836:	7d67b783          	ld	a5,2006(a5) # 80009008 <uart_tx_r>
    8000083a:	00008717          	auipc	a4,0x8
    8000083e:	7d673703          	ld	a4,2006(a4) # 80009010 <uart_tx_w>
    80000842:	06f70a63          	beq	a4,a5,800008b6 <uartstart+0x84>
{
    80000846:	7139                	addi	sp,sp,-64
    80000848:	fc06                	sd	ra,56(sp)
    8000084a:	f822                	sd	s0,48(sp)
    8000084c:	f426                	sd	s1,40(sp)
    8000084e:	f04a                	sd	s2,32(sp)
    80000850:	ec4e                	sd	s3,24(sp)
    80000852:	e852                	sd	s4,16(sp)
    80000854:	e456                	sd	s5,8(sp)
    80000856:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000858:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000085c:	00011a17          	auipc	s4,0x11
    80000860:	9eca0a13          	addi	s4,s4,-1556 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000864:	00008497          	auipc	s1,0x8
    80000868:	7a448493          	addi	s1,s1,1956 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000086c:	00008997          	auipc	s3,0x8
    80000870:	7a498993          	addi	s3,s3,1956 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000874:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000878:	02077713          	andi	a4,a4,32
    8000087c:	c705                	beqz	a4,800008a4 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000087e:	01f7f713          	andi	a4,a5,31
    80000882:	9752                	add	a4,a4,s4
    80000884:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000888:	0785                	addi	a5,a5,1
    8000088a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000088c:	8526                	mv	a0,s1
    8000088e:	00002097          	auipc	ra,0x2
    80000892:	c7c080e7          	jalr	-900(ra) # 8000250a <wakeup>
    
    WriteReg(THR, c);
    80000896:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089a:	609c                	ld	a5,0(s1)
    8000089c:	0009b703          	ld	a4,0(s3)
    800008a0:	fcf71ae3          	bne	a4,a5,80000874 <uartstart+0x42>
  }
}
    800008a4:	70e2                	ld	ra,56(sp)
    800008a6:	7442                	ld	s0,48(sp)
    800008a8:	74a2                	ld	s1,40(sp)
    800008aa:	7902                	ld	s2,32(sp)
    800008ac:	69e2                	ld	s3,24(sp)
    800008ae:	6a42                	ld	s4,16(sp)
    800008b0:	6aa2                	ld	s5,8(sp)
    800008b2:	6121                	addi	sp,sp,64
    800008b4:	8082                	ret
    800008b6:	8082                	ret

00000000800008b8 <uartputc>:
{
    800008b8:	7179                	addi	sp,sp,-48
    800008ba:	f406                	sd	ra,40(sp)
    800008bc:	f022                	sd	s0,32(sp)
    800008be:	ec26                	sd	s1,24(sp)
    800008c0:	e84a                	sd	s2,16(sp)
    800008c2:	e44e                	sd	s3,8(sp)
    800008c4:	e052                	sd	s4,0(sp)
    800008c6:	1800                	addi	s0,sp,48
    800008c8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ca:	00011517          	auipc	a0,0x11
    800008ce:	97e50513          	addi	a0,a0,-1666 # 80011248 <uart_tx_lock>
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	2fe080e7          	jalr	766(ra) # 80000bd0 <acquire>
  if(panicked){
    800008da:	00008797          	auipc	a5,0x8
    800008de:	7267a783          	lw	a5,1830(a5) # 80009000 <panicked>
    800008e2:	c391                	beqz	a5,800008e6 <uartputc+0x2e>
    for(;;)
    800008e4:	a001                	j	800008e4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e6:	00008717          	auipc	a4,0x8
    800008ea:	72a73703          	ld	a4,1834(a4) # 80009010 <uart_tx_w>
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	71a7b783          	ld	a5,1818(a5) # 80009008 <uart_tx_r>
    800008f6:	02078793          	addi	a5,a5,32
    800008fa:	02e79b63          	bne	a5,a4,80000930 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00011997          	auipc	s3,0x11
    80000902:	94a98993          	addi	s3,s3,-1718 # 80011248 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	70248493          	addi	s1,s1,1794 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	70290913          	addi	s2,s2,1794 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000916:	85ce                	mv	a1,s3
    80000918:	8526                	mv	a0,s1
    8000091a:	00002097          	auipc	ra,0x2
    8000091e:	a70080e7          	jalr	-1424(ra) # 8000238a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000922:	00093703          	ld	a4,0(s2)
    80000926:	609c                	ld	a5,0(s1)
    80000928:	02078793          	addi	a5,a5,32
    8000092c:	fee785e3          	beq	a5,a4,80000916 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000930:	00011497          	auipc	s1,0x11
    80000934:	91848493          	addi	s1,s1,-1768 # 80011248 <uart_tx_lock>
    80000938:	01f77793          	andi	a5,a4,31
    8000093c:	97a6                	add	a5,a5,s1
    8000093e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000942:	0705                	addi	a4,a4,1
    80000944:	00008797          	auipc	a5,0x8
    80000948:	6ce7b623          	sd	a4,1740(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	ee6080e7          	jalr	-282(ra) # 80000832 <uartstart>
      release(&uart_tx_lock);
    80000954:	8526                	mv	a0,s1
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	32e080e7          	jalr	814(ra) # 80000c84 <release>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	addi	sp,sp,48
    8000096c:	8082                	ret

000000008000096e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000096e:	1141                	addi	sp,sp,-16
    80000970:	e422                	sd	s0,8(sp)
    80000972:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000974:	100007b7          	lui	a5,0x10000
    80000978:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000097c:	8b85                	andi	a5,a5,1
    8000097e:	cb81                	beqz	a5,8000098e <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000980:	100007b7          	lui	a5,0x10000
    80000984:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000988:	6422                	ld	s0,8(sp)
    8000098a:	0141                	addi	sp,sp,16
    8000098c:	8082                	ret
    return -1;
    8000098e:	557d                	li	a0,-1
    80000990:	bfe5                	j	80000988 <uartgetc+0x1a>

0000000080000992 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000992:	1101                	addi	sp,sp,-32
    80000994:	ec06                	sd	ra,24(sp)
    80000996:	e822                	sd	s0,16(sp)
    80000998:	e426                	sd	s1,8(sp)
    8000099a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000099c:	54fd                	li	s1,-1
    8000099e:	a029                	j	800009a8 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	918080e7          	jalr	-1768(ra) # 800002b8 <consoleintr>
    int c = uartgetc();
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	fc6080e7          	jalr	-58(ra) # 8000096e <uartgetc>
    if(c == -1)
    800009b0:	fe9518e3          	bne	a0,s1,800009a0 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009b4:	00011497          	auipc	s1,0x11
    800009b8:	89448493          	addi	s1,s1,-1900 # 80011248 <uart_tx_lock>
    800009bc:	8526                	mv	a0,s1
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	212080e7          	jalr	530(ra) # 80000bd0 <acquire>
  uartstart();
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	e6c080e7          	jalr	-404(ra) # 80000832 <uartstart>
  release(&uart_tx_lock);
    800009ce:	8526                	mv	a0,s1
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	2b4080e7          	jalr	692(ra) # 80000c84 <release>
}
    800009d8:	60e2                	ld	ra,24(sp)
    800009da:	6442                	ld	s0,16(sp)
    800009dc:	64a2                	ld	s1,8(sp)
    800009de:	6105                	addi	sp,sp,32
    800009e0:	8082                	ret

00000000800009e2 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e2:	1101                	addi	sp,sp,-32
    800009e4:	ec06                	sd	ra,24(sp)
    800009e6:	e822                	sd	s0,16(sp)
    800009e8:	e426                	sd	s1,8(sp)
    800009ea:	e04a                	sd	s2,0(sp)
    800009ec:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009ee:	03451793          	slli	a5,a0,0x34
    800009f2:	ebb9                	bnez	a5,80000a48 <kfree+0x66>
    800009f4:	84aa                	mv	s1,a0
    800009f6:	00031797          	auipc	a5,0x31
    800009fa:	60a78793          	addi	a5,a5,1546 # 80032000 <end>
    800009fe:	04f56563          	bltu	a0,a5,80000a48 <kfree+0x66>
    80000a02:	47c5                	li	a5,17
    80000a04:	07ee                	slli	a5,a5,0x1b
    80000a06:	04f57163          	bgeu	a0,a5,80000a48 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a0a:	6605                	lui	a2,0x1
    80000a0c:	4585                	li	a1,1
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	2be080e7          	jalr	702(ra) # 80000ccc <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a16:	00011917          	auipc	s2,0x11
    80000a1a:	86a90913          	addi	s2,s2,-1942 # 80011280 <kmem>
    80000a1e:	854a                	mv	a0,s2
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	1b0080e7          	jalr	432(ra) # 80000bd0 <acquire>
  r->next = kmem.freelist;
    80000a28:	01893783          	ld	a5,24(s2)
    80000a2c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a2e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a32:	854a                	mv	a0,s2
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	250080e7          	jalr	592(ra) # 80000c84 <release>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6902                	ld	s2,0(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret
    panic("kfree");
    80000a48:	00007517          	auipc	a0,0x7
    80000a4c:	61850513          	addi	a0,a0,1560 # 80008060 <digits+0x20>
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	aea080e7          	jalr	-1302(ra) # 8000053a <panic>

0000000080000a58 <freerange>:
{
    80000a58:	7179                	addi	sp,sp,-48
    80000a5a:	f406                	sd	ra,40(sp)
    80000a5c:	f022                	sd	s0,32(sp)
    80000a5e:	ec26                	sd	s1,24(sp)
    80000a60:	e84a                	sd	s2,16(sp)
    80000a62:	e44e                	sd	s3,8(sp)
    80000a64:	e052                	sd	s4,0(sp)
    80000a66:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a68:	6785                	lui	a5,0x1
    80000a6a:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a6e:	00e504b3          	add	s1,a0,a4
    80000a72:	777d                	lui	a4,0xfffff
    80000a74:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a76:	94be                	add	s1,s1,a5
    80000a78:	0095ee63          	bltu	a1,s1,80000a94 <freerange+0x3c>
    80000a7c:	892e                	mv	s2,a1
    kfree(p);
    80000a7e:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	6985                	lui	s3,0x1
    kfree(p);
    80000a82:	01448533          	add	a0,s1,s4
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	f5c080e7          	jalr	-164(ra) # 800009e2 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a8e:	94ce                	add	s1,s1,s3
    80000a90:	fe9979e3          	bgeu	s2,s1,80000a82 <freerange+0x2a>
}
    80000a94:	70a2                	ld	ra,40(sp)
    80000a96:	7402                	ld	s0,32(sp)
    80000a98:	64e2                	ld	s1,24(sp)
    80000a9a:	6942                	ld	s2,16(sp)
    80000a9c:	69a2                	ld	s3,8(sp)
    80000a9e:	6a02                	ld	s4,0(sp)
    80000aa0:	6145                	addi	sp,sp,48
    80000aa2:	8082                	ret

0000000080000aa4 <kinit>:
{
    80000aa4:	1141                	addi	sp,sp,-16
    80000aa6:	e406                	sd	ra,8(sp)
    80000aa8:	e022                	sd	s0,0(sp)
    80000aaa:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aac:	00007597          	auipc	a1,0x7
    80000ab0:	5bc58593          	addi	a1,a1,1468 # 80008068 <digits+0x28>
    80000ab4:	00010517          	auipc	a0,0x10
    80000ab8:	7cc50513          	addi	a0,a0,1996 # 80011280 <kmem>
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	084080e7          	jalr	132(ra) # 80000b40 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ac4:	45c5                	li	a1,17
    80000ac6:	05ee                	slli	a1,a1,0x1b
    80000ac8:	00031517          	auipc	a0,0x31
    80000acc:	53850513          	addi	a0,a0,1336 # 80032000 <end>
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	f88080e7          	jalr	-120(ra) # 80000a58 <freerange>
}
    80000ad8:	60a2                	ld	ra,8(sp)
    80000ada:	6402                	ld	s0,0(sp)
    80000adc:	0141                	addi	sp,sp,16
    80000ade:	8082                	ret

0000000080000ae0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae0:	1101                	addi	sp,sp,-32
    80000ae2:	ec06                	sd	ra,24(sp)
    80000ae4:	e822                	sd	s0,16(sp)
    80000ae6:	e426                	sd	s1,8(sp)
    80000ae8:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aea:	00010497          	auipc	s1,0x10
    80000aee:	79648493          	addi	s1,s1,1942 # 80011280 <kmem>
    80000af2:	8526                	mv	a0,s1
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	0dc080e7          	jalr	220(ra) # 80000bd0 <acquire>
  r = kmem.freelist;
    80000afc:	6c84                	ld	s1,24(s1)
  if(r)
    80000afe:	c885                	beqz	s1,80000b2e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b00:	609c                	ld	a5,0(s1)
    80000b02:	00010517          	auipc	a0,0x10
    80000b06:	77e50513          	addi	a0,a0,1918 # 80011280 <kmem>
    80000b0a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	178080e7          	jalr	376(ra) # 80000c84 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b14:	6605                	lui	a2,0x1
    80000b16:	4595                	li	a1,5
    80000b18:	8526                	mv	a0,s1
    80000b1a:	00000097          	auipc	ra,0x0
    80000b1e:	1b2080e7          	jalr	434(ra) # 80000ccc <memset>
  return (void*)r;
}
    80000b22:	8526                	mv	a0,s1
    80000b24:	60e2                	ld	ra,24(sp)
    80000b26:	6442                	ld	s0,16(sp)
    80000b28:	64a2                	ld	s1,8(sp)
    80000b2a:	6105                	addi	sp,sp,32
    80000b2c:	8082                	ret
  release(&kmem.lock);
    80000b2e:	00010517          	auipc	a0,0x10
    80000b32:	75250513          	addi	a0,a0,1874 # 80011280 <kmem>
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	14e080e7          	jalr	334(ra) # 80000c84 <release>
  if(r)
    80000b3e:	b7d5                	j	80000b22 <kalloc+0x42>

0000000080000b40 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b40:	1141                	addi	sp,sp,-16
    80000b42:	e422                	sd	s0,8(sp)
    80000b44:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b46:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b48:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b4c:	00053823          	sd	zero,16(a0)
}
    80000b50:	6422                	ld	s0,8(sp)
    80000b52:	0141                	addi	sp,sp,16
    80000b54:	8082                	ret

0000000080000b56 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b56:	411c                	lw	a5,0(a0)
    80000b58:	e399                	bnez	a5,80000b5e <holding+0x8>
    80000b5a:	4501                	li	a0,0
  return r;
}
    80000b5c:	8082                	ret
{
    80000b5e:	1101                	addi	sp,sp,-32
    80000b60:	ec06                	sd	ra,24(sp)
    80000b62:	e822                	sd	s0,16(sp)
    80000b64:	e426                	sd	s1,8(sp)
    80000b66:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b68:	6904                	ld	s1,16(a0)
    80000b6a:	00001097          	auipc	ra,0x1
    80000b6e:	f56080e7          	jalr	-170(ra) # 80001ac0 <mycpu>
    80000b72:	40a48533          	sub	a0,s1,a0
    80000b76:	00153513          	seqz	a0,a0
}
    80000b7a:	60e2                	ld	ra,24(sp)
    80000b7c:	6442                	ld	s0,16(sp)
    80000b7e:	64a2                	ld	s1,8(sp)
    80000b80:	6105                	addi	sp,sp,32
    80000b82:	8082                	ret

0000000080000b84 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b84:	1101                	addi	sp,sp,-32
    80000b86:	ec06                	sd	ra,24(sp)
    80000b88:	e822                	sd	s0,16(sp)
    80000b8a:	e426                	sd	s1,8(sp)
    80000b8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b8e:	100024f3          	csrr	s1,sstatus
    80000b92:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b96:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b98:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b9c:	00001097          	auipc	ra,0x1
    80000ba0:	f24080e7          	jalr	-220(ra) # 80001ac0 <mycpu>
    80000ba4:	5d3c                	lw	a5,120(a0)
    80000ba6:	cf89                	beqz	a5,80000bc0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ba8:	00001097          	auipc	ra,0x1
    80000bac:	f18080e7          	jalr	-232(ra) # 80001ac0 <mycpu>
    80000bb0:	5d3c                	lw	a5,120(a0)
    80000bb2:	2785                	addiw	a5,a5,1
    80000bb4:	dd3c                	sw	a5,120(a0)
}
    80000bb6:	60e2                	ld	ra,24(sp)
    80000bb8:	6442                	ld	s0,16(sp)
    80000bba:	64a2                	ld	s1,8(sp)
    80000bbc:	6105                	addi	sp,sp,32
    80000bbe:	8082                	ret
    mycpu()->intena = old;
    80000bc0:	00001097          	auipc	ra,0x1
    80000bc4:	f00080e7          	jalr	-256(ra) # 80001ac0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bc8:	8085                	srli	s1,s1,0x1
    80000bca:	8885                	andi	s1,s1,1
    80000bcc:	dd64                	sw	s1,124(a0)
    80000bce:	bfe9                	j	80000ba8 <push_off+0x24>

0000000080000bd0 <acquire>:
{
    80000bd0:	1101                	addi	sp,sp,-32
    80000bd2:	ec06                	sd	ra,24(sp)
    80000bd4:	e822                	sd	s0,16(sp)
    80000bd6:	e426                	sd	s1,8(sp)
    80000bd8:	1000                	addi	s0,sp,32
    80000bda:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bdc:	00000097          	auipc	ra,0x0
    80000be0:	fa8080e7          	jalr	-88(ra) # 80000b84 <push_off>
  if(holding(lk))
    80000be4:	8526                	mv	a0,s1
    80000be6:	00000097          	auipc	ra,0x0
    80000bea:	f70080e7          	jalr	-144(ra) # 80000b56 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bee:	4705                	li	a4,1
  if(holding(lk))
    80000bf0:	e115                	bnez	a0,80000c14 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf2:	87ba                	mv	a5,a4
    80000bf4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bf8:	2781                	sext.w	a5,a5
    80000bfa:	ffe5                	bnez	a5,80000bf2 <acquire+0x22>
  __sync_synchronize();
    80000bfc:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c00:	00001097          	auipc	ra,0x1
    80000c04:	ec0080e7          	jalr	-320(ra) # 80001ac0 <mycpu>
    80000c08:	e888                	sd	a0,16(s1)
}
    80000c0a:	60e2                	ld	ra,24(sp)
    80000c0c:	6442                	ld	s0,16(sp)
    80000c0e:	64a2                	ld	s1,8(sp)
    80000c10:	6105                	addi	sp,sp,32
    80000c12:	8082                	ret
    panic("acquire");
    80000c14:	00007517          	auipc	a0,0x7
    80000c18:	45c50513          	addi	a0,a0,1116 # 80008070 <digits+0x30>
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	91e080e7          	jalr	-1762(ra) # 8000053a <panic>

0000000080000c24 <pop_off>:

void
pop_off(void)
{
    80000c24:	1141                	addi	sp,sp,-16
    80000c26:	e406                	sd	ra,8(sp)
    80000c28:	e022                	sd	s0,0(sp)
    80000c2a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c2c:	00001097          	auipc	ra,0x1
    80000c30:	e94080e7          	jalr	-364(ra) # 80001ac0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c38:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c3a:	e78d                	bnez	a5,80000c64 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c3c:	5d3c                	lw	a5,120(a0)
    80000c3e:	02f05b63          	blez	a5,80000c74 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c42:	37fd                	addiw	a5,a5,-1
    80000c44:	0007871b          	sext.w	a4,a5
    80000c48:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c4a:	eb09                	bnez	a4,80000c5c <pop_off+0x38>
    80000c4c:	5d7c                	lw	a5,124(a0)
    80000c4e:	c799                	beqz	a5,80000c5c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c58:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c5c:	60a2                	ld	ra,8(sp)
    80000c5e:	6402                	ld	s0,0(sp)
    80000c60:	0141                	addi	sp,sp,16
    80000c62:	8082                	ret
    panic("pop_off - interruptible");
    80000c64:	00007517          	auipc	a0,0x7
    80000c68:	41450513          	addi	a0,a0,1044 # 80008078 <digits+0x38>
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	8ce080e7          	jalr	-1842(ra) # 8000053a <panic>
    panic("pop_off");
    80000c74:	00007517          	auipc	a0,0x7
    80000c78:	41c50513          	addi	a0,a0,1052 # 80008090 <digits+0x50>
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	8be080e7          	jalr	-1858(ra) # 8000053a <panic>

0000000080000c84 <release>:
{
    80000c84:	1101                	addi	sp,sp,-32
    80000c86:	ec06                	sd	ra,24(sp)
    80000c88:	e822                	sd	s0,16(sp)
    80000c8a:	e426                	sd	s1,8(sp)
    80000c8c:	1000                	addi	s0,sp,32
    80000c8e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	ec6080e7          	jalr	-314(ra) # 80000b56 <holding>
    80000c98:	c115                	beqz	a0,80000cbc <release+0x38>
  lk->cpu = 0;
    80000c9a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c9e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca2:	0f50000f          	fence	iorw,ow
    80000ca6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	f7a080e7          	jalr	-134(ra) # 80000c24 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00007517          	auipc	a0,0x7
    80000cc0:	3dc50513          	addi	a0,a0,988 # 80008098 <digits+0x58>
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	876080e7          	jalr	-1930(ra) # 8000053a <panic>

0000000080000ccc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ccc:	1141                	addi	sp,sp,-16
    80000cce:	e422                	sd	s0,8(sp)
    80000cd0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd2:	ca19                	beqz	a2,80000ce8 <memset+0x1c>
    80000cd4:	87aa                	mv	a5,a0
    80000cd6:	1602                	slli	a2,a2,0x20
    80000cd8:	9201                	srli	a2,a2,0x20
    80000cda:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cde:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce2:	0785                	addi	a5,a5,1
    80000ce4:	fee79de3          	bne	a5,a4,80000cde <memset+0x12>
  }
  return dst;
}
    80000ce8:	6422                	ld	s0,8(sp)
    80000cea:	0141                	addi	sp,sp,16
    80000cec:	8082                	ret

0000000080000cee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cee:	1141                	addi	sp,sp,-16
    80000cf0:	e422                	sd	s0,8(sp)
    80000cf2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf4:	ca05                	beqz	a2,80000d24 <memcmp+0x36>
    80000cf6:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	0685                	addi	a3,a3,1
    80000d00:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d02:	00054783          	lbu	a5,0(a0)
    80000d06:	0005c703          	lbu	a4,0(a1)
    80000d0a:	00e79863          	bne	a5,a4,80000d1a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0e:	0505                	addi	a0,a0,1
    80000d10:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d12:	fed518e3          	bne	a0,a3,80000d02 <memcmp+0x14>
  }

  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	a019                	j	80000d1e <memcmp+0x30>
      return *s1 - *s2;
    80000d1a:	40e7853b          	subw	a0,a5,a4
}
    80000d1e:	6422                	ld	s0,8(sp)
    80000d20:	0141                	addi	sp,sp,16
    80000d22:	8082                	ret
  return 0;
    80000d24:	4501                	li	a0,0
    80000d26:	bfe5                	j	80000d1e <memcmp+0x30>

0000000080000d28 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e422                	sd	s0,8(sp)
    80000d2c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2e:	02a5e563          	bltu	a1,a0,80000d58 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d32:	fff6069b          	addiw	a3,a2,-1
    80000d36:	ce11                	beqz	a2,80000d52 <memmove+0x2a>
    80000d38:	1682                	slli	a3,a3,0x20
    80000d3a:	9281                	srli	a3,a3,0x20
    80000d3c:	0685                	addi	a3,a3,1
    80000d3e:	96ae                	add	a3,a3,a1
    80000d40:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d42:	0585                	addi	a1,a1,1
    80000d44:	0785                	addi	a5,a5,1
    80000d46:	fff5c703          	lbu	a4,-1(a1)
    80000d4a:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d4e:	fed59ae3          	bne	a1,a3,80000d42 <memmove+0x1a>

  return dst;
}
    80000d52:	6422                	ld	s0,8(sp)
    80000d54:	0141                	addi	sp,sp,16
    80000d56:	8082                	ret
  if(s < d && s + n > d){
    80000d58:	02061713          	slli	a4,a2,0x20
    80000d5c:	9301                	srli	a4,a4,0x20
    80000d5e:	00e587b3          	add	a5,a1,a4
    80000d62:	fcf578e3          	bgeu	a0,a5,80000d32 <memmove+0xa>
    d += n;
    80000d66:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d68:	fff6069b          	addiw	a3,a2,-1
    80000d6c:	d27d                	beqz	a2,80000d52 <memmove+0x2a>
    80000d6e:	02069613          	slli	a2,a3,0x20
    80000d72:	9201                	srli	a2,a2,0x20
    80000d74:	fff64613          	not	a2,a2
    80000d78:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d7a:	17fd                	addi	a5,a5,-1
    80000d7c:	177d                	addi	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffccfff>
    80000d7e:	0007c683          	lbu	a3,0(a5)
    80000d82:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d86:	fef61ae3          	bne	a2,a5,80000d7a <memmove+0x52>
    80000d8a:	b7e1                	j	80000d52 <memmove+0x2a>

0000000080000d8c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e406                	sd	ra,8(sp)
    80000d90:	e022                	sd	s0,0(sp)
    80000d92:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d94:	00000097          	auipc	ra,0x0
    80000d98:	f94080e7          	jalr	-108(ra) # 80000d28 <memmove>
}
    80000d9c:	60a2                	ld	ra,8(sp)
    80000d9e:	6402                	ld	s0,0(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e422                	sd	s0,8(sp)
    80000da8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000daa:	ce11                	beqz	a2,80000dc6 <strncmp+0x22>
    80000dac:	00054783          	lbu	a5,0(a0)
    80000db0:	cf89                	beqz	a5,80000dca <strncmp+0x26>
    80000db2:	0005c703          	lbu	a4,0(a1)
    80000db6:	00f71a63          	bne	a4,a5,80000dca <strncmp+0x26>
    n--, p++, q++;
    80000dba:	367d                	addiw	a2,a2,-1
    80000dbc:	0505                	addi	a0,a0,1
    80000dbe:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dc0:	f675                	bnez	a2,80000dac <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc2:	4501                	li	a0,0
    80000dc4:	a809                	j	80000dd6 <strncmp+0x32>
    80000dc6:	4501                	li	a0,0
    80000dc8:	a039                	j	80000dd6 <strncmp+0x32>
  if(n == 0)
    80000dca:	ca09                	beqz	a2,80000ddc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dcc:	00054503          	lbu	a0,0(a0)
    80000dd0:	0005c783          	lbu	a5,0(a1)
    80000dd4:	9d1d                	subw	a0,a0,a5
}
    80000dd6:	6422                	ld	s0,8(sp)
    80000dd8:	0141                	addi	sp,sp,16
    80000dda:	8082                	ret
    return 0;
    80000ddc:	4501                	li	a0,0
    80000dde:	bfe5                	j	80000dd6 <strncmp+0x32>

0000000080000de0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000de0:	1141                	addi	sp,sp,-16
    80000de2:	e422                	sd	s0,8(sp)
    80000de4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de6:	872a                	mv	a4,a0
    80000de8:	8832                	mv	a6,a2
    80000dea:	367d                	addiw	a2,a2,-1
    80000dec:	01005963          	blez	a6,80000dfe <strncpy+0x1e>
    80000df0:	0705                	addi	a4,a4,1
    80000df2:	0005c783          	lbu	a5,0(a1)
    80000df6:	fef70fa3          	sb	a5,-1(a4)
    80000dfa:	0585                	addi	a1,a1,1
    80000dfc:	f7f5                	bnez	a5,80000de8 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dfe:	86ba                	mv	a3,a4
    80000e00:	00c05c63          	blez	a2,80000e18 <strncpy+0x38>
    *s++ = 0;
    80000e04:	0685                	addi	a3,a3,1
    80000e06:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e0a:	40d707bb          	subw	a5,a4,a3
    80000e0e:	37fd                	addiw	a5,a5,-1
    80000e10:	010787bb          	addw	a5,a5,a6
    80000e14:	fef048e3          	bgtz	a5,80000e04 <strncpy+0x24>
  return os;
}
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e422                	sd	s0,8(sp)
    80000e22:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e24:	02c05363          	blez	a2,80000e4a <safestrcpy+0x2c>
    80000e28:	fff6069b          	addiw	a3,a2,-1
    80000e2c:	1682                	slli	a3,a3,0x20
    80000e2e:	9281                	srli	a3,a3,0x20
    80000e30:	96ae                	add	a3,a3,a1
    80000e32:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e34:	00d58963          	beq	a1,a3,80000e46 <safestrcpy+0x28>
    80000e38:	0585                	addi	a1,a1,1
    80000e3a:	0785                	addi	a5,a5,1
    80000e3c:	fff5c703          	lbu	a4,-1(a1)
    80000e40:	fee78fa3          	sb	a4,-1(a5)
    80000e44:	fb65                	bnez	a4,80000e34 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e46:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e4a:	6422                	ld	s0,8(sp)
    80000e4c:	0141                	addi	sp,sp,16
    80000e4e:	8082                	ret

0000000080000e50 <strlen>:

int
strlen(const char *s)
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e56:	00054783          	lbu	a5,0(a0)
    80000e5a:	cf91                	beqz	a5,80000e76 <strlen+0x26>
    80000e5c:	0505                	addi	a0,a0,1
    80000e5e:	87aa                	mv	a5,a0
    80000e60:	4685                	li	a3,1
    80000e62:	9e89                	subw	a3,a3,a0
    80000e64:	00f6853b          	addw	a0,a3,a5
    80000e68:	0785                	addi	a5,a5,1
    80000e6a:	fff7c703          	lbu	a4,-1(a5)
    80000e6e:	fb7d                	bnez	a4,80000e64 <strlen+0x14>
    ;
  return n;
}
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e76:	4501                	li	a0,0
    80000e78:	bfe5                	j	80000e70 <strlen+0x20>

0000000080000e7a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e7a:	1141                	addi	sp,sp,-16
    80000e7c:	e406                	sd	ra,8(sp)
    80000e7e:	e022                	sd	s0,0(sp)
    80000e80:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e82:	00001097          	auipc	ra,0x1
    80000e86:	c2e080e7          	jalr	-978(ra) # 80001ab0 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e8a:	00008717          	auipc	a4,0x8
    80000e8e:	18e70713          	addi	a4,a4,398 # 80009018 <started>
  if(cpuid() == 0){
    80000e92:	c139                	beqz	a0,80000ed8 <main+0x5e>
    while(started == 0)
    80000e94:	431c                	lw	a5,0(a4)
    80000e96:	2781                	sext.w	a5,a5
    80000e98:	dff5                	beqz	a5,80000e94 <main+0x1a>
      ;
    __sync_synchronize();
    80000e9a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c12080e7          	jalr	-1006(ra) # 80001ab0 <cpuid>
    80000ea6:	85aa                	mv	a1,a0
    80000ea8:	00007517          	auipc	a0,0x7
    80000eac:	21050513          	addi	a0,a0,528 # 800080b8 <digits+0x78>
    80000eb0:	fffff097          	auipc	ra,0xfffff
    80000eb4:	6d4080e7          	jalr	1748(ra) # 80000584 <printf>
    kvminithart();    // turn on paging
    80000eb8:	00000097          	auipc	ra,0x0
    80000ebc:	0d8080e7          	jalr	216(ra) # 80000f90 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ec0:	00002097          	auipc	ra,0x2
    80000ec4:	912080e7          	jalr	-1774(ra) # 800027d2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec8:	00005097          	auipc	ra,0x5
    80000ecc:	264080e7          	jalr	612(ra) # 8000612c <plicinithart>
  }

  scheduler();        
    80000ed0:	00001097          	auipc	ra,0x1
    80000ed4:	1da080e7          	jalr	474(ra) # 800020aa <scheduler>
    consoleinit();
    80000ed8:	fffff097          	auipc	ra,0xfffff
    80000edc:	572080e7          	jalr	1394(ra) # 8000044a <consoleinit>
    printfinit();
    80000ee0:	00000097          	auipc	ra,0x0
    80000ee4:	884080e7          	jalr	-1916(ra) # 80000764 <printfinit>
    printf("\n");
    80000ee8:	00007517          	auipc	a0,0x7
    80000eec:	1e050513          	addi	a0,a0,480 # 800080c8 <digits+0x88>
    80000ef0:	fffff097          	auipc	ra,0xfffff
    80000ef4:	694080e7          	jalr	1684(ra) # 80000584 <printf>
    printf("xv6 kernel is booting\n");
    80000ef8:	00007517          	auipc	a0,0x7
    80000efc:	1a850513          	addi	a0,a0,424 # 800080a0 <digits+0x60>
    80000f00:	fffff097          	auipc	ra,0xfffff
    80000f04:	684080e7          	jalr	1668(ra) # 80000584 <printf>
    printf("\n");
    80000f08:	00007517          	auipc	a0,0x7
    80000f0c:	1c050513          	addi	a0,a0,448 # 800080c8 <digits+0x88>
    80000f10:	fffff097          	auipc	ra,0xfffff
    80000f14:	674080e7          	jalr	1652(ra) # 80000584 <printf>
    kinit();         // physical page allocator
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	b8c080e7          	jalr	-1140(ra) # 80000aa4 <kinit>
    kvminit();       // create kernel page table
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	310080e7          	jalr	784(ra) # 80001230 <kvminit>
    kvminithart();   // turn on paging
    80000f28:	00000097          	auipc	ra,0x0
    80000f2c:	068080e7          	jalr	104(ra) # 80000f90 <kvminithart>
    procinit();      // process table
    80000f30:	00001097          	auipc	ra,0x1
    80000f34:	ae8080e7          	jalr	-1304(ra) # 80001a18 <procinit>
    trapinit();      // trap vectors
    80000f38:	00002097          	auipc	ra,0x2
    80000f3c:	872080e7          	jalr	-1934(ra) # 800027aa <trapinit>
    trapinithart();  // install kernel trap vector
    80000f40:	00002097          	auipc	ra,0x2
    80000f44:	892080e7          	jalr	-1902(ra) # 800027d2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	1ce080e7          	jalr	462(ra) # 80006116 <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f50:	00005097          	auipc	ra,0x5
    80000f54:	1dc080e7          	jalr	476(ra) # 8000612c <plicinithart>
    binit();         // buffer cache
    80000f58:	00002097          	auipc	ra,0x2
    80000f5c:	fe0080e7          	jalr	-32(ra) # 80002f38 <binit>
    iinit();         // inode cache
    80000f60:	00002097          	auipc	ra,0x2
    80000f64:	66e080e7          	jalr	1646(ra) # 800035ce <iinit>
    fileinit();      // file table
    80000f68:	00003097          	auipc	ra,0x3
    80000f6c:	628080e7          	jalr	1576(ra) # 80004590 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f70:	00005097          	auipc	ra,0x5
    80000f74:	2dc080e7          	jalr	732(ra) # 8000624c <virtio_disk_init>
    userinit();      // first user process
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	e74080e7          	jalr	-396(ra) # 80001dec <userinit>
    __sync_synchronize();
    80000f80:	0ff0000f          	fence
    started = 1;
    80000f84:	4785                	li	a5,1
    80000f86:	00008717          	auipc	a4,0x8
    80000f8a:	08f72923          	sw	a5,146(a4) # 80009018 <started>
    80000f8e:	b789                	j	80000ed0 <main+0x56>

0000000080000f90 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e422                	sd	s0,8(sp)
    80000f94:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f96:	00008797          	auipc	a5,0x8
    80000f9a:	08a7b783          	ld	a5,138(a5) # 80009020 <kernel_pagetable>
    80000f9e:	83b1                	srli	a5,a5,0xc
    80000fa0:	577d                	li	a4,-1
    80000fa2:	177e                	slli	a4,a4,0x3f
    80000fa4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa6:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000faa:	12000073          	sfence.vma
  sfence_vma();
}
    80000fae:	6422                	ld	s0,8(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret

0000000080000fb4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb4:	7139                	addi	sp,sp,-64
    80000fb6:	fc06                	sd	ra,56(sp)
    80000fb8:	f822                	sd	s0,48(sp)
    80000fba:	f426                	sd	s1,40(sp)
    80000fbc:	f04a                	sd	s2,32(sp)
    80000fbe:	ec4e                	sd	s3,24(sp)
    80000fc0:	e852                	sd	s4,16(sp)
    80000fc2:	e456                	sd	s5,8(sp)
    80000fc4:	e05a                	sd	s6,0(sp)
    80000fc6:	0080                	addi	s0,sp,64
    80000fc8:	84aa                	mv	s1,a0
    80000fca:	89ae                	mv	s3,a1
    80000fcc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fce:	57fd                	li	a5,-1
    80000fd0:	83e9                	srli	a5,a5,0x1a
    80000fd2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd4:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd6:	04b7f263          	bgeu	a5,a1,8000101a <walk+0x66>
    panic("walk");
    80000fda:	00007517          	auipc	a0,0x7
    80000fde:	0f650513          	addi	a0,a0,246 # 800080d0 <digits+0x90>
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	558080e7          	jalr	1368(ra) # 8000053a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fea:	060a8663          	beqz	s5,80001056 <walk+0xa2>
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	af2080e7          	jalr	-1294(ra) # 80000ae0 <kalloc>
    80000ff6:	84aa                	mv	s1,a0
    80000ff8:	c529                	beqz	a0,80001042 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffa:	6605                	lui	a2,0x1
    80000ffc:	4581                	li	a1,0
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	cce080e7          	jalr	-818(ra) # 80000ccc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001006:	00c4d793          	srli	a5,s1,0xc
    8000100a:	07aa                	slli	a5,a5,0xa
    8000100c:	0017e793          	ori	a5,a5,1
    80001010:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001014:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffccff7>
    80001016:	036a0063          	beq	s4,s6,80001036 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101a:	0149d933          	srl	s2,s3,s4
    8000101e:	1ff97913          	andi	s2,s2,511
    80001022:	090e                	slli	s2,s2,0x3
    80001024:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001026:	00093483          	ld	s1,0(s2)
    8000102a:	0014f793          	andi	a5,s1,1
    8000102e:	dfd5                	beqz	a5,80000fea <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001030:	80a9                	srli	s1,s1,0xa
    80001032:	04b2                	slli	s1,s1,0xc
    80001034:	b7c5                	j	80001014 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001036:	00c9d513          	srli	a0,s3,0xc
    8000103a:	1ff57513          	andi	a0,a0,511
    8000103e:	050e                	slli	a0,a0,0x3
    80001040:	9526                	add	a0,a0,s1
}
    80001042:	70e2                	ld	ra,56(sp)
    80001044:	7442                	ld	s0,48(sp)
    80001046:	74a2                	ld	s1,40(sp)
    80001048:	7902                	ld	s2,32(sp)
    8000104a:	69e2                	ld	s3,24(sp)
    8000104c:	6a42                	ld	s4,16(sp)
    8000104e:	6aa2                	ld	s5,8(sp)
    80001050:	6b02                	ld	s6,0(sp)
    80001052:	6121                	addi	sp,sp,64
    80001054:	8082                	ret
        return 0;
    80001056:	4501                	li	a0,0
    80001058:	b7ed                	j	80001042 <walk+0x8e>

000000008000105a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105a:	57fd                	li	a5,-1
    8000105c:	83e9                	srli	a5,a5,0x1a
    8000105e:	00b7f463          	bgeu	a5,a1,80001066 <walkaddr+0xc>
    return 0;
    80001062:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001064:	8082                	ret
{
    80001066:	1141                	addi	sp,sp,-16
    80001068:	e406                	sd	ra,8(sp)
    8000106a:	e022                	sd	s0,0(sp)
    8000106c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000106e:	4601                	li	a2,0
    80001070:	00000097          	auipc	ra,0x0
    80001074:	f44080e7          	jalr	-188(ra) # 80000fb4 <walk>
  if(pte == 0)
    80001078:	c105                	beqz	a0,80001098 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107c:	0117f693          	andi	a3,a5,17
    80001080:	4745                	li	a4,17
    return 0;
    80001082:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001084:	00e68663          	beq	a3,a4,80001090 <walkaddr+0x36>
}
    80001088:	60a2                	ld	ra,8(sp)
    8000108a:	6402                	ld	s0,0(sp)
    8000108c:	0141                	addi	sp,sp,16
    8000108e:	8082                	ret
  pa = PTE2PA(*pte);
    80001090:	83a9                	srli	a5,a5,0xa
    80001092:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001096:	bfcd                	j	80001088 <walkaddr+0x2e>
    return 0;
    80001098:	4501                	li	a0,0
    8000109a:	b7fd                	j	80001088 <walkaddr+0x2e>

000000008000109c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109c:	715d                	addi	sp,sp,-80
    8000109e:	e486                	sd	ra,72(sp)
    800010a0:	e0a2                	sd	s0,64(sp)
    800010a2:	fc26                	sd	s1,56(sp)
    800010a4:	f84a                	sd	s2,48(sp)
    800010a6:	f44e                	sd	s3,40(sp)
    800010a8:	f052                	sd	s4,32(sp)
    800010aa:	ec56                	sd	s5,24(sp)
    800010ac:	e85a                	sd	s6,16(sp)
    800010ae:	e45e                	sd	s7,8(sp)
    800010b0:	0880                	addi	s0,sp,80
    800010b2:	8aaa                	mv	s5,a0
    800010b4:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010b6:	777d                	lui	a4,0xfffff
    800010b8:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010bc:	fff60993          	addi	s3,a2,-1 # fff <_entry-0x7ffff001>
    800010c0:	99ae                	add	s3,s3,a1
    800010c2:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010c6:	893e                	mv	s2,a5
    800010c8:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010cc:	6b85                	lui	s7,0x1
    800010ce:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d2:	4605                	li	a2,1
    800010d4:	85ca                	mv	a1,s2
    800010d6:	8556                	mv	a0,s5
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	edc080e7          	jalr	-292(ra) # 80000fb4 <walk>
    800010e0:	c51d                	beqz	a0,8000110e <mappages+0x72>
    if(*pte & PTE_V)
    800010e2:	611c                	ld	a5,0(a0)
    800010e4:	8b85                	andi	a5,a5,1
    800010e6:	ef81                	bnez	a5,800010fe <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010e8:	80b1                	srli	s1,s1,0xc
    800010ea:	04aa                	slli	s1,s1,0xa
    800010ec:	0164e4b3          	or	s1,s1,s6
    800010f0:	0014e493          	ori	s1,s1,1
    800010f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800010f6:	03390863          	beq	s2,s3,80001126 <mappages+0x8a>
    a += PGSIZE;
    800010fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010fc:	bfc9                	j	800010ce <mappages+0x32>
      panic("remap");
    800010fe:	00007517          	auipc	a0,0x7
    80001102:	fda50513          	addi	a0,a0,-38 # 800080d8 <digits+0x98>
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	434080e7          	jalr	1076(ra) # 8000053a <panic>
      return -1;
    8000110e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001110:	60a6                	ld	ra,72(sp)
    80001112:	6406                	ld	s0,64(sp)
    80001114:	74e2                	ld	s1,56(sp)
    80001116:	7942                	ld	s2,48(sp)
    80001118:	79a2                	ld	s3,40(sp)
    8000111a:	7a02                	ld	s4,32(sp)
    8000111c:	6ae2                	ld	s5,24(sp)
    8000111e:	6b42                	ld	s6,16(sp)
    80001120:	6ba2                	ld	s7,8(sp)
    80001122:	6161                	addi	sp,sp,80
    80001124:	8082                	ret
  return 0;
    80001126:	4501                	li	a0,0
    80001128:	b7e5                	j	80001110 <mappages+0x74>

000000008000112a <kvmmap>:
{
    8000112a:	1141                	addi	sp,sp,-16
    8000112c:	e406                	sd	ra,8(sp)
    8000112e:	e022                	sd	s0,0(sp)
    80001130:	0800                	addi	s0,sp,16
    80001132:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001134:	86b2                	mv	a3,a2
    80001136:	863e                	mv	a2,a5
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	f64080e7          	jalr	-156(ra) # 8000109c <mappages>
    80001140:	e509                	bnez	a0,8000114a <kvmmap+0x20>
}
    80001142:	60a2                	ld	ra,8(sp)
    80001144:	6402                	ld	s0,0(sp)
    80001146:	0141                	addi	sp,sp,16
    80001148:	8082                	ret
    panic("kvmmap");
    8000114a:	00007517          	auipc	a0,0x7
    8000114e:	f9650513          	addi	a0,a0,-106 # 800080e0 <digits+0xa0>
    80001152:	fffff097          	auipc	ra,0xfffff
    80001156:	3e8080e7          	jalr	1000(ra) # 8000053a <panic>

000000008000115a <kvmmake>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	e04a                	sd	s2,0(sp)
    80001164:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	97a080e7          	jalr	-1670(ra) # 80000ae0 <kalloc>
    8000116e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001170:	6605                	lui	a2,0x1
    80001172:	4581                	li	a1,0
    80001174:	00000097          	auipc	ra,0x0
    80001178:	b58080e7          	jalr	-1192(ra) # 80000ccc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000117c:	4719                	li	a4,6
    8000117e:	6685                	lui	a3,0x1
    80001180:	10000637          	lui	a2,0x10000
    80001184:	100005b7          	lui	a1,0x10000
    80001188:	8526                	mv	a0,s1
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	fa0080e7          	jalr	-96(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001192:	4719                	li	a4,6
    80001194:	6685                	lui	a3,0x1
    80001196:	10001637          	lui	a2,0x10001
    8000119a:	100015b7          	lui	a1,0x10001
    8000119e:	8526                	mv	a0,s1
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	f8a080e7          	jalr	-118(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011a8:	4719                	li	a4,6
    800011aa:	004006b7          	lui	a3,0x400
    800011ae:	0c000637          	lui	a2,0xc000
    800011b2:	0c0005b7          	lui	a1,0xc000
    800011b6:	8526                	mv	a0,s1
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	f72080e7          	jalr	-142(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011c0:	00007917          	auipc	s2,0x7
    800011c4:	e4090913          	addi	s2,s2,-448 # 80008000 <etext>
    800011c8:	4729                	li	a4,10
    800011ca:	80007697          	auipc	a3,0x80007
    800011ce:	e3668693          	addi	a3,a3,-458 # 8000 <_entry-0x7fff8000>
    800011d2:	4605                	li	a2,1
    800011d4:	067e                	slli	a2,a2,0x1f
    800011d6:	85b2                	mv	a1,a2
    800011d8:	8526                	mv	a0,s1
    800011da:	00000097          	auipc	ra,0x0
    800011de:	f50080e7          	jalr	-176(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011e2:	4719                	li	a4,6
    800011e4:	46c5                	li	a3,17
    800011e6:	06ee                	slli	a3,a3,0x1b
    800011e8:	412686b3          	sub	a3,a3,s2
    800011ec:	864a                	mv	a2,s2
    800011ee:	85ca                	mv	a1,s2
    800011f0:	8526                	mv	a0,s1
    800011f2:	00000097          	auipc	ra,0x0
    800011f6:	f38080e7          	jalr	-200(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011fa:	4729                	li	a4,10
    800011fc:	6685                	lui	a3,0x1
    800011fe:	00006617          	auipc	a2,0x6
    80001202:	e0260613          	addi	a2,a2,-510 # 80007000 <_trampoline>
    80001206:	040005b7          	lui	a1,0x4000
    8000120a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000120c:	05b2                	slli	a1,a1,0xc
    8000120e:	8526                	mv	a0,s1
    80001210:	00000097          	auipc	ra,0x0
    80001214:	f1a080e7          	jalr	-230(ra) # 8000112a <kvmmap>
  proc_mapstacks(kpgtbl);
    80001218:	8526                	mv	a0,s1
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	768080e7          	jalr	1896(ra) # 80001982 <proc_mapstacks>
}
    80001222:	8526                	mv	a0,s1
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6902                	ld	s2,0(sp)
    8000122c:	6105                	addi	sp,sp,32
    8000122e:	8082                	ret

0000000080001230 <kvminit>:
{
    80001230:	1141                	addi	sp,sp,-16
    80001232:	e406                	sd	ra,8(sp)
    80001234:	e022                	sd	s0,0(sp)
    80001236:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	f22080e7          	jalr	-222(ra) # 8000115a <kvmmake>
    80001240:	00008797          	auipc	a5,0x8
    80001244:	dea7b023          	sd	a0,-544(a5) # 80009020 <kernel_pagetable>
}
    80001248:	60a2                	ld	ra,8(sp)
    8000124a:	6402                	ld	s0,0(sp)
    8000124c:	0141                	addi	sp,sp,16
    8000124e:	8082                	ret

0000000080001250 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001250:	715d                	addi	sp,sp,-80
    80001252:	e486                	sd	ra,72(sp)
    80001254:	e0a2                	sd	s0,64(sp)
    80001256:	fc26                	sd	s1,56(sp)
    80001258:	f84a                	sd	s2,48(sp)
    8000125a:	f44e                	sd	s3,40(sp)
    8000125c:	f052                	sd	s4,32(sp)
    8000125e:	ec56                	sd	s5,24(sp)
    80001260:	e85a                	sd	s6,16(sp)
    80001262:	e45e                	sd	s7,8(sp)
    80001264:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001266:	03459793          	slli	a5,a1,0x34
    8000126a:	e795                	bnez	a5,80001296 <uvmunmap+0x46>
    8000126c:	8a2a                	mv	s4,a0
    8000126e:	892e                	mv	s2,a1
    80001270:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001272:	0632                	slli	a2,a2,0xc
    80001274:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001278:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000127a:	6b05                	lui	s6,0x1
    8000127c:	0735e263          	bltu	a1,s3,800012e0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001280:	60a6                	ld	ra,72(sp)
    80001282:	6406                	ld	s0,64(sp)
    80001284:	74e2                	ld	s1,56(sp)
    80001286:	7942                	ld	s2,48(sp)
    80001288:	79a2                	ld	s3,40(sp)
    8000128a:	7a02                	ld	s4,32(sp)
    8000128c:	6ae2                	ld	s5,24(sp)
    8000128e:	6b42                	ld	s6,16(sp)
    80001290:	6ba2                	ld	s7,8(sp)
    80001292:	6161                	addi	sp,sp,80
    80001294:	8082                	ret
    panic("uvmunmap: not aligned");
    80001296:	00007517          	auipc	a0,0x7
    8000129a:	e5250513          	addi	a0,a0,-430 # 800080e8 <digits+0xa8>
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	29c080e7          	jalr	668(ra) # 8000053a <panic>
      panic("uvmunmap: walk");
    800012a6:	00007517          	auipc	a0,0x7
    800012aa:	e5a50513          	addi	a0,a0,-422 # 80008100 <digits+0xc0>
    800012ae:	fffff097          	auipc	ra,0xfffff
    800012b2:	28c080e7          	jalr	652(ra) # 8000053a <panic>
      panic("uvmunmap: not mapped");
    800012b6:	00007517          	auipc	a0,0x7
    800012ba:	e5a50513          	addi	a0,a0,-422 # 80008110 <digits+0xd0>
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	27c080e7          	jalr	636(ra) # 8000053a <panic>
      panic("uvmunmap: not a leaf");
    800012c6:	00007517          	auipc	a0,0x7
    800012ca:	e6250513          	addi	a0,a0,-414 # 80008128 <digits+0xe8>
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	26c080e7          	jalr	620(ra) # 8000053a <panic>
    *pte = 0;
    800012d6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012da:	995a                	add	s2,s2,s6
    800012dc:	fb3972e3          	bgeu	s2,s3,80001280 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012e0:	4601                	li	a2,0
    800012e2:	85ca                	mv	a1,s2
    800012e4:	8552                	mv	a0,s4
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	cce080e7          	jalr	-818(ra) # 80000fb4 <walk>
    800012ee:	84aa                	mv	s1,a0
    800012f0:	d95d                	beqz	a0,800012a6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012f2:	6108                	ld	a0,0(a0)
    800012f4:	00157793          	andi	a5,a0,1
    800012f8:	dfdd                	beqz	a5,800012b6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012fa:	3ff57793          	andi	a5,a0,1023
    800012fe:	fd7784e3          	beq	a5,s7,800012c6 <uvmunmap+0x76>
    if(do_free){
    80001302:	fc0a8ae3          	beqz	s5,800012d6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001306:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001308:	0532                	slli	a0,a0,0xc
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	6d8080e7          	jalr	1752(ra) # 800009e2 <kfree>
    80001312:	b7d1                	j	800012d6 <uvmunmap+0x86>

0000000080001314 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001314:	1101                	addi	sp,sp,-32
    80001316:	ec06                	sd	ra,24(sp)
    80001318:	e822                	sd	s0,16(sp)
    8000131a:	e426                	sd	s1,8(sp)
    8000131c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	7c2080e7          	jalr	1986(ra) # 80000ae0 <kalloc>
    80001326:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001328:	c519                	beqz	a0,80001336 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000132a:	6605                	lui	a2,0x1
    8000132c:	4581                	li	a1,0
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	99e080e7          	jalr	-1634(ra) # 80000ccc <memset>
  return pagetable;
}
    80001336:	8526                	mv	a0,s1
    80001338:	60e2                	ld	ra,24(sp)
    8000133a:	6442                	ld	s0,16(sp)
    8000133c:	64a2                	ld	s1,8(sp)
    8000133e:	6105                	addi	sp,sp,32
    80001340:	8082                	ret

0000000080001342 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001342:	7179                	addi	sp,sp,-48
    80001344:	f406                	sd	ra,40(sp)
    80001346:	f022                	sd	s0,32(sp)
    80001348:	ec26                	sd	s1,24(sp)
    8000134a:	e84a                	sd	s2,16(sp)
    8000134c:	e44e                	sd	s3,8(sp)
    8000134e:	e052                	sd	s4,0(sp)
    80001350:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001352:	6785                	lui	a5,0x1
    80001354:	04f67863          	bgeu	a2,a5,800013a4 <uvminit+0x62>
    80001358:	8a2a                	mv	s4,a0
    8000135a:	89ae                	mv	s3,a1
    8000135c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000135e:	fffff097          	auipc	ra,0xfffff
    80001362:	782080e7          	jalr	1922(ra) # 80000ae0 <kalloc>
    80001366:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001368:	6605                	lui	a2,0x1
    8000136a:	4581                	li	a1,0
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	960080e7          	jalr	-1696(ra) # 80000ccc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001374:	4779                	li	a4,30
    80001376:	86ca                	mv	a3,s2
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	8552                	mv	a0,s4
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	d1e080e7          	jalr	-738(ra) # 8000109c <mappages>
  memmove(mem, src, sz);
    80001386:	8626                	mv	a2,s1
    80001388:	85ce                	mv	a1,s3
    8000138a:	854a                	mv	a0,s2
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	99c080e7          	jalr	-1636(ra) # 80000d28 <memmove>
}
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6a02                	ld	s4,0(sp)
    800013a0:	6145                	addi	sp,sp,48
    800013a2:	8082                	ret
    panic("inituvm: more than a page");
    800013a4:	00007517          	auipc	a0,0x7
    800013a8:	d9c50513          	addi	a0,a0,-612 # 80008140 <digits+0x100>
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	18e080e7          	jalr	398(ra) # 8000053a <panic>

00000000800013b4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013be:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013c0:	00b67d63          	bgeu	a2,a1,800013da <uvmdealloc+0x26>
    800013c4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013c6:	6785                	lui	a5,0x1
    800013c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013ca:	00f60733          	add	a4,a2,a5
    800013ce:	76fd                	lui	a3,0xfffff
    800013d0:	8f75                	and	a4,a4,a3
    800013d2:	97ae                	add	a5,a5,a1
    800013d4:	8ff5                	and	a5,a5,a3
    800013d6:	00f76863          	bltu	a4,a5,800013e6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013da:	8526                	mv	a0,s1
    800013dc:	60e2                	ld	ra,24(sp)
    800013de:	6442                	ld	s0,16(sp)
    800013e0:	64a2                	ld	s1,8(sp)
    800013e2:	6105                	addi	sp,sp,32
    800013e4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013e6:	8f99                	sub	a5,a5,a4
    800013e8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013ea:	4685                	li	a3,1
    800013ec:	0007861b          	sext.w	a2,a5
    800013f0:	85ba                	mv	a1,a4
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	e5e080e7          	jalr	-418(ra) # 80001250 <uvmunmap>
    800013fa:	b7c5                	j	800013da <uvmdealloc+0x26>

00000000800013fc <uvmalloc>:
  if(newsz < oldsz)
    800013fc:	0ab66163          	bltu	a2,a1,8000149e <uvmalloc+0xa2>
{
    80001400:	7139                	addi	sp,sp,-64
    80001402:	fc06                	sd	ra,56(sp)
    80001404:	f822                	sd	s0,48(sp)
    80001406:	f426                	sd	s1,40(sp)
    80001408:	f04a                	sd	s2,32(sp)
    8000140a:	ec4e                	sd	s3,24(sp)
    8000140c:	e852                	sd	s4,16(sp)
    8000140e:	e456                	sd	s5,8(sp)
    80001410:	0080                	addi	s0,sp,64
    80001412:	8aaa                	mv	s5,a0
    80001414:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001416:	6785                	lui	a5,0x1
    80001418:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000141a:	95be                	add	a1,a1,a5
    8000141c:	77fd                	lui	a5,0xfffff
    8000141e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001422:	08c9f063          	bgeu	s3,a2,800014a2 <uvmalloc+0xa6>
    80001426:	894e                	mv	s2,s3
    mem = kalloc();
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	6b8080e7          	jalr	1720(ra) # 80000ae0 <kalloc>
    80001430:	84aa                	mv	s1,a0
    if(mem == 0){
    80001432:	c51d                	beqz	a0,80001460 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001434:	6605                	lui	a2,0x1
    80001436:	4581                	li	a1,0
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	894080e7          	jalr	-1900(ra) # 80000ccc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001440:	4779                	li	a4,30
    80001442:	86a6                	mv	a3,s1
    80001444:	6605                	lui	a2,0x1
    80001446:	85ca                	mv	a1,s2
    80001448:	8556                	mv	a0,s5
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	c52080e7          	jalr	-942(ra) # 8000109c <mappages>
    80001452:	e905                	bnez	a0,80001482 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001454:	6785                	lui	a5,0x1
    80001456:	993e                	add	s2,s2,a5
    80001458:	fd4968e3          	bltu	s2,s4,80001428 <uvmalloc+0x2c>
  return newsz;
    8000145c:	8552                	mv	a0,s4
    8000145e:	a809                	j	80001470 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001460:	864e                	mv	a2,s3
    80001462:	85ca                	mv	a1,s2
    80001464:	8556                	mv	a0,s5
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	f4e080e7          	jalr	-178(ra) # 800013b4 <uvmdealloc>
      return 0;
    8000146e:	4501                	li	a0,0
}
    80001470:	70e2                	ld	ra,56(sp)
    80001472:	7442                	ld	s0,48(sp)
    80001474:	74a2                	ld	s1,40(sp)
    80001476:	7902                	ld	s2,32(sp)
    80001478:	69e2                	ld	s3,24(sp)
    8000147a:	6a42                	ld	s4,16(sp)
    8000147c:	6aa2                	ld	s5,8(sp)
    8000147e:	6121                	addi	sp,sp,64
    80001480:	8082                	ret
      kfree(mem);
    80001482:	8526                	mv	a0,s1
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	55e080e7          	jalr	1374(ra) # 800009e2 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000148c:	864e                	mv	a2,s3
    8000148e:	85ca                	mv	a1,s2
    80001490:	8556                	mv	a0,s5
    80001492:	00000097          	auipc	ra,0x0
    80001496:	f22080e7          	jalr	-222(ra) # 800013b4 <uvmdealloc>
      return 0;
    8000149a:	4501                	li	a0,0
    8000149c:	bfd1                	j	80001470 <uvmalloc+0x74>
    return oldsz;
    8000149e:	852e                	mv	a0,a1
}
    800014a0:	8082                	ret
  return newsz;
    800014a2:	8532                	mv	a0,a2
    800014a4:	b7f1                	j	80001470 <uvmalloc+0x74>

00000000800014a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014a6:	7179                	addi	sp,sp,-48
    800014a8:	f406                	sd	ra,40(sp)
    800014aa:	f022                	sd	s0,32(sp)
    800014ac:	ec26                	sd	s1,24(sp)
    800014ae:	e84a                	sd	s2,16(sp)
    800014b0:	e44e                	sd	s3,8(sp)
    800014b2:	e052                	sd	s4,0(sp)
    800014b4:	1800                	addi	s0,sp,48
    800014b6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014b8:	84aa                	mv	s1,a0
    800014ba:	6905                	lui	s2,0x1
    800014bc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014be:	4985                	li	s3,1
    800014c0:	a829                	j	800014da <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014c2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014c4:	00c79513          	slli	a0,a5,0xc
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	fde080e7          	jalr	-34(ra) # 800014a6 <freewalk>
      pagetable[i] = 0;
    800014d0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014d4:	04a1                	addi	s1,s1,8
    800014d6:	03248163          	beq	s1,s2,800014f8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014da:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014dc:	00f7f713          	andi	a4,a5,15
    800014e0:	ff3701e3          	beq	a4,s3,800014c2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014e4:	8b85                	andi	a5,a5,1
    800014e6:	d7fd                	beqz	a5,800014d4 <freewalk+0x2e>
      panic("freewalk: leaf");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	c7850513          	addi	a0,a0,-904 # 80008160 <digits+0x120>
    800014f0:	fffff097          	auipc	ra,0xfffff
    800014f4:	04a080e7          	jalr	74(ra) # 8000053a <panic>
    }
  }
  kfree((void*)pagetable);
    800014f8:	8552                	mv	a0,s4
    800014fa:	fffff097          	auipc	ra,0xfffff
    800014fe:	4e8080e7          	jalr	1256(ra) # 800009e2 <kfree>
}
    80001502:	70a2                	ld	ra,40(sp)
    80001504:	7402                	ld	s0,32(sp)
    80001506:	64e2                	ld	s1,24(sp)
    80001508:	6942                	ld	s2,16(sp)
    8000150a:	69a2                	ld	s3,8(sp)
    8000150c:	6a02                	ld	s4,0(sp)
    8000150e:	6145                	addi	sp,sp,48
    80001510:	8082                	ret

0000000080001512 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001512:	1101                	addi	sp,sp,-32
    80001514:	ec06                	sd	ra,24(sp)
    80001516:	e822                	sd	s0,16(sp)
    80001518:	e426                	sd	s1,8(sp)
    8000151a:	1000                	addi	s0,sp,32
    8000151c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000151e:	e999                	bnez	a1,80001534 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001520:	8526                	mv	a0,s1
    80001522:	00000097          	auipc	ra,0x0
    80001526:	f84080e7          	jalr	-124(ra) # 800014a6 <freewalk>
}
    8000152a:	60e2                	ld	ra,24(sp)
    8000152c:	6442                	ld	s0,16(sp)
    8000152e:	64a2                	ld	s1,8(sp)
    80001530:	6105                	addi	sp,sp,32
    80001532:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001534:	6785                	lui	a5,0x1
    80001536:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001538:	95be                	add	a1,a1,a5
    8000153a:	4685                	li	a3,1
    8000153c:	00c5d613          	srli	a2,a1,0xc
    80001540:	4581                	li	a1,0
    80001542:	00000097          	auipc	ra,0x0
    80001546:	d0e080e7          	jalr	-754(ra) # 80001250 <uvmunmap>
    8000154a:	bfd9                	j	80001520 <uvmfree+0xe>

000000008000154c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000154c:	c679                	beqz	a2,8000161a <uvmcopy+0xce>
{
    8000154e:	715d                	addi	sp,sp,-80
    80001550:	e486                	sd	ra,72(sp)
    80001552:	e0a2                	sd	s0,64(sp)
    80001554:	fc26                	sd	s1,56(sp)
    80001556:	f84a                	sd	s2,48(sp)
    80001558:	f44e                	sd	s3,40(sp)
    8000155a:	f052                	sd	s4,32(sp)
    8000155c:	ec56                	sd	s5,24(sp)
    8000155e:	e85a                	sd	s6,16(sp)
    80001560:	e45e                	sd	s7,8(sp)
    80001562:	0880                	addi	s0,sp,80
    80001564:	8b2a                	mv	s6,a0
    80001566:	8aae                	mv	s5,a1
    80001568:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000156a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000156c:	4601                	li	a2,0
    8000156e:	85ce                	mv	a1,s3
    80001570:	855a                	mv	a0,s6
    80001572:	00000097          	auipc	ra,0x0
    80001576:	a42080e7          	jalr	-1470(ra) # 80000fb4 <walk>
    8000157a:	c531                	beqz	a0,800015c6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000157c:	6118                	ld	a4,0(a0)
    8000157e:	00177793          	andi	a5,a4,1
    80001582:	cbb1                	beqz	a5,800015d6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001584:	00a75593          	srli	a1,a4,0xa
    80001588:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000158c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001590:	fffff097          	auipc	ra,0xfffff
    80001594:	550080e7          	jalr	1360(ra) # 80000ae0 <kalloc>
    80001598:	892a                	mv	s2,a0
    8000159a:	c939                	beqz	a0,800015f0 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000159c:	6605                	lui	a2,0x1
    8000159e:	85de                	mv	a1,s7
    800015a0:	fffff097          	auipc	ra,0xfffff
    800015a4:	788080e7          	jalr	1928(ra) # 80000d28 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015a8:	8726                	mv	a4,s1
    800015aa:	86ca                	mv	a3,s2
    800015ac:	6605                	lui	a2,0x1
    800015ae:	85ce                	mv	a1,s3
    800015b0:	8556                	mv	a0,s5
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	aea080e7          	jalr	-1302(ra) # 8000109c <mappages>
    800015ba:	e515                	bnez	a0,800015e6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015bc:	6785                	lui	a5,0x1
    800015be:	99be                	add	s3,s3,a5
    800015c0:	fb49e6e3          	bltu	s3,s4,8000156c <uvmcopy+0x20>
    800015c4:	a081                	j	80001604 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015c6:	00007517          	auipc	a0,0x7
    800015ca:	baa50513          	addi	a0,a0,-1110 # 80008170 <digits+0x130>
    800015ce:	fffff097          	auipc	ra,0xfffff
    800015d2:	f6c080e7          	jalr	-148(ra) # 8000053a <panic>
      panic("uvmcopy: page not present");
    800015d6:	00007517          	auipc	a0,0x7
    800015da:	bba50513          	addi	a0,a0,-1094 # 80008190 <digits+0x150>
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	f5c080e7          	jalr	-164(ra) # 8000053a <panic>
      kfree(mem);
    800015e6:	854a                	mv	a0,s2
    800015e8:	fffff097          	auipc	ra,0xfffff
    800015ec:	3fa080e7          	jalr	1018(ra) # 800009e2 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015f0:	4685                	li	a3,1
    800015f2:	00c9d613          	srli	a2,s3,0xc
    800015f6:	4581                	li	a1,0
    800015f8:	8556                	mv	a0,s5
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	c56080e7          	jalr	-938(ra) # 80001250 <uvmunmap>
  return -1;
    80001602:	557d                	li	a0,-1
}
    80001604:	60a6                	ld	ra,72(sp)
    80001606:	6406                	ld	s0,64(sp)
    80001608:	74e2                	ld	s1,56(sp)
    8000160a:	7942                	ld	s2,48(sp)
    8000160c:	79a2                	ld	s3,40(sp)
    8000160e:	7a02                	ld	s4,32(sp)
    80001610:	6ae2                	ld	s5,24(sp)
    80001612:	6b42                	ld	s6,16(sp)
    80001614:	6ba2                	ld	s7,8(sp)
    80001616:	6161                	addi	sp,sp,80
    80001618:	8082                	ret
  return 0;
    8000161a:	4501                	li	a0,0
}
    8000161c:	8082                	ret

000000008000161e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000161e:	1141                	addi	sp,sp,-16
    80001620:	e406                	sd	ra,8(sp)
    80001622:	e022                	sd	s0,0(sp)
    80001624:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001626:	4601                	li	a2,0
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	98c080e7          	jalr	-1652(ra) # 80000fb4 <walk>
  if(pte == 0)
    80001630:	c901                	beqz	a0,80001640 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001632:	611c                	ld	a5,0(a0)
    80001634:	9bbd                	andi	a5,a5,-17
    80001636:	e11c                	sd	a5,0(a0)
}
    80001638:	60a2                	ld	ra,8(sp)
    8000163a:	6402                	ld	s0,0(sp)
    8000163c:	0141                	addi	sp,sp,16
    8000163e:	8082                	ret
    panic("uvmclear");
    80001640:	00007517          	auipc	a0,0x7
    80001644:	b7050513          	addi	a0,a0,-1168 # 800081b0 <digits+0x170>
    80001648:	fffff097          	auipc	ra,0xfffff
    8000164c:	ef2080e7          	jalr	-270(ra) # 8000053a <panic>

0000000080001650 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001650:	c6bd                	beqz	a3,800016be <copyout+0x6e>
{
    80001652:	715d                	addi	sp,sp,-80
    80001654:	e486                	sd	ra,72(sp)
    80001656:	e0a2                	sd	s0,64(sp)
    80001658:	fc26                	sd	s1,56(sp)
    8000165a:	f84a                	sd	s2,48(sp)
    8000165c:	f44e                	sd	s3,40(sp)
    8000165e:	f052                	sd	s4,32(sp)
    80001660:	ec56                	sd	s5,24(sp)
    80001662:	e85a                	sd	s6,16(sp)
    80001664:	e45e                	sd	s7,8(sp)
    80001666:	e062                	sd	s8,0(sp)
    80001668:	0880                	addi	s0,sp,80
    8000166a:	8b2a                	mv	s6,a0
    8000166c:	8c2e                	mv	s8,a1
    8000166e:	8a32                	mv	s4,a2
    80001670:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001672:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001674:	6a85                	lui	s5,0x1
    80001676:	a015                	j	8000169a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001678:	9562                	add	a0,a0,s8
    8000167a:	0004861b          	sext.w	a2,s1
    8000167e:	85d2                	mv	a1,s4
    80001680:	41250533          	sub	a0,a0,s2
    80001684:	fffff097          	auipc	ra,0xfffff
    80001688:	6a4080e7          	jalr	1700(ra) # 80000d28 <memmove>

    len -= n;
    8000168c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001690:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001692:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001696:	02098263          	beqz	s3,800016ba <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000169a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000169e:	85ca                	mv	a1,s2
    800016a0:	855a                	mv	a0,s6
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	9b8080e7          	jalr	-1608(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800016aa:	cd01                	beqz	a0,800016c2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016ac:	418904b3          	sub	s1,s2,s8
    800016b0:	94d6                	add	s1,s1,s5
    800016b2:	fc99f3e3          	bgeu	s3,s1,80001678 <copyout+0x28>
    800016b6:	84ce                	mv	s1,s3
    800016b8:	b7c1                	j	80001678 <copyout+0x28>
  }
  return 0;
    800016ba:	4501                	li	a0,0
    800016bc:	a021                	j	800016c4 <copyout+0x74>
    800016be:	4501                	li	a0,0
}
    800016c0:	8082                	ret
      return -1;
    800016c2:	557d                	li	a0,-1
}
    800016c4:	60a6                	ld	ra,72(sp)
    800016c6:	6406                	ld	s0,64(sp)
    800016c8:	74e2                	ld	s1,56(sp)
    800016ca:	7942                	ld	s2,48(sp)
    800016cc:	79a2                	ld	s3,40(sp)
    800016ce:	7a02                	ld	s4,32(sp)
    800016d0:	6ae2                	ld	s5,24(sp)
    800016d2:	6b42                	ld	s6,16(sp)
    800016d4:	6ba2                	ld	s7,8(sp)
    800016d6:	6c02                	ld	s8,0(sp)
    800016d8:	6161                	addi	sp,sp,80
    800016da:	8082                	ret

00000000800016dc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016dc:	caa5                	beqz	a3,8000174c <copyin+0x70>
{
    800016de:	715d                	addi	sp,sp,-80
    800016e0:	e486                	sd	ra,72(sp)
    800016e2:	e0a2                	sd	s0,64(sp)
    800016e4:	fc26                	sd	s1,56(sp)
    800016e6:	f84a                	sd	s2,48(sp)
    800016e8:	f44e                	sd	s3,40(sp)
    800016ea:	f052                	sd	s4,32(sp)
    800016ec:	ec56                	sd	s5,24(sp)
    800016ee:	e85a                	sd	s6,16(sp)
    800016f0:	e45e                	sd	s7,8(sp)
    800016f2:	e062                	sd	s8,0(sp)
    800016f4:	0880                	addi	s0,sp,80
    800016f6:	8b2a                	mv	s6,a0
    800016f8:	8a2e                	mv	s4,a1
    800016fa:	8c32                	mv	s8,a2
    800016fc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016fe:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001700:	6a85                	lui	s5,0x1
    80001702:	a01d                	j	80001728 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001704:	018505b3          	add	a1,a0,s8
    80001708:	0004861b          	sext.w	a2,s1
    8000170c:	412585b3          	sub	a1,a1,s2
    80001710:	8552                	mv	a0,s4
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	616080e7          	jalr	1558(ra) # 80000d28 <memmove>

    len -= n;
    8000171a:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000171e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001720:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001724:	02098263          	beqz	s3,80001748 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001728:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000172c:	85ca                	mv	a1,s2
    8000172e:	855a                	mv	a0,s6
    80001730:	00000097          	auipc	ra,0x0
    80001734:	92a080e7          	jalr	-1750(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    80001738:	cd01                	beqz	a0,80001750 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000173a:	418904b3          	sub	s1,s2,s8
    8000173e:	94d6                	add	s1,s1,s5
    80001740:	fc99f2e3          	bgeu	s3,s1,80001704 <copyin+0x28>
    80001744:	84ce                	mv	s1,s3
    80001746:	bf7d                	j	80001704 <copyin+0x28>
  }
  return 0;
    80001748:	4501                	li	a0,0
    8000174a:	a021                	j	80001752 <copyin+0x76>
    8000174c:	4501                	li	a0,0
}
    8000174e:	8082                	ret
      return -1;
    80001750:	557d                	li	a0,-1
}
    80001752:	60a6                	ld	ra,72(sp)
    80001754:	6406                	ld	s0,64(sp)
    80001756:	74e2                	ld	s1,56(sp)
    80001758:	7942                	ld	s2,48(sp)
    8000175a:	79a2                	ld	s3,40(sp)
    8000175c:	7a02                	ld	s4,32(sp)
    8000175e:	6ae2                	ld	s5,24(sp)
    80001760:	6b42                	ld	s6,16(sp)
    80001762:	6ba2                	ld	s7,8(sp)
    80001764:	6c02                	ld	s8,0(sp)
    80001766:	6161                	addi	sp,sp,80
    80001768:	8082                	ret

000000008000176a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000176a:	c2dd                	beqz	a3,80001810 <copyinstr+0xa6>
{
    8000176c:	715d                	addi	sp,sp,-80
    8000176e:	e486                	sd	ra,72(sp)
    80001770:	e0a2                	sd	s0,64(sp)
    80001772:	fc26                	sd	s1,56(sp)
    80001774:	f84a                	sd	s2,48(sp)
    80001776:	f44e                	sd	s3,40(sp)
    80001778:	f052                	sd	s4,32(sp)
    8000177a:	ec56                	sd	s5,24(sp)
    8000177c:	e85a                	sd	s6,16(sp)
    8000177e:	e45e                	sd	s7,8(sp)
    80001780:	0880                	addi	s0,sp,80
    80001782:	8a2a                	mv	s4,a0
    80001784:	8b2e                	mv	s6,a1
    80001786:	8bb2                	mv	s7,a2
    80001788:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000178a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000178c:	6985                	lui	s3,0x1
    8000178e:	a02d                	j	800017b8 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001790:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001794:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001796:	37fd                	addiw	a5,a5,-1
    80001798:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000179c:	60a6                	ld	ra,72(sp)
    8000179e:	6406                	ld	s0,64(sp)
    800017a0:	74e2                	ld	s1,56(sp)
    800017a2:	7942                	ld	s2,48(sp)
    800017a4:	79a2                	ld	s3,40(sp)
    800017a6:	7a02                	ld	s4,32(sp)
    800017a8:	6ae2                	ld	s5,24(sp)
    800017aa:	6b42                	ld	s6,16(sp)
    800017ac:	6ba2                	ld	s7,8(sp)
    800017ae:	6161                	addi	sp,sp,80
    800017b0:	8082                	ret
    srcva = va0 + PGSIZE;
    800017b2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017b6:	c8a9                	beqz	s1,80001808 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017b8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017bc:	85ca                	mv	a1,s2
    800017be:	8552                	mv	a0,s4
    800017c0:	00000097          	auipc	ra,0x0
    800017c4:	89a080e7          	jalr	-1894(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800017c8:	c131                	beqz	a0,8000180c <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017ca:	417906b3          	sub	a3,s2,s7
    800017ce:	96ce                	add	a3,a3,s3
    800017d0:	00d4f363          	bgeu	s1,a3,800017d6 <copyinstr+0x6c>
    800017d4:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017d6:	955e                	add	a0,a0,s7
    800017d8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017dc:	daf9                	beqz	a3,800017b2 <copyinstr+0x48>
    800017de:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017e0:	41650633          	sub	a2,a0,s6
    800017e4:	fff48593          	addi	a1,s1,-1
    800017e8:	95da                	add	a1,a1,s6
    while(n > 0){
    800017ea:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    800017ec:	00f60733          	add	a4,a2,a5
    800017f0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffcd000>
    800017f4:	df51                	beqz	a4,80001790 <copyinstr+0x26>
        *dst = *p;
    800017f6:	00e78023          	sb	a4,0(a5)
      --max;
    800017fa:	40f584b3          	sub	s1,a1,a5
      dst++;
    800017fe:	0785                	addi	a5,a5,1
    while(n > 0){
    80001800:	fed796e3          	bne	a5,a3,800017ec <copyinstr+0x82>
      dst++;
    80001804:	8b3e                	mv	s6,a5
    80001806:	b775                	j	800017b2 <copyinstr+0x48>
    80001808:	4781                	li	a5,0
    8000180a:	b771                	j	80001796 <copyinstr+0x2c>
      return -1;
    8000180c:	557d                	li	a0,-1
    8000180e:	b779                	j	8000179c <copyinstr+0x32>
  int got_null = 0;
    80001810:	4781                	li	a5,0
  if(got_null){
    80001812:	37fd                	addiw	a5,a5,-1
    80001814:	0007851b          	sext.w	a0,a5
}
    80001818:	8082                	ret

000000008000181a <vmaunmap>:
// Remove n BYTES (not pages) of vma mappings starting from va. va must be
// page-aligned. The mappings NEED NOT exist.
// Also free the physical memory and write back vma data to disk if necessary.
void
vmaunmap(pagetable_t pagetable, uint64 va, uint64 nbytes, struct vma *v)
{
    8000181a:	715d                	addi	sp,sp,-80
    8000181c:	e486                	sd	ra,72(sp)
    8000181e:	e0a2                	sd	s0,64(sp)
    80001820:	fc26                	sd	s1,56(sp)
    80001822:	f84a                	sd	s2,48(sp)
    80001824:	f44e                	sd	s3,40(sp)
    80001826:	f052                	sd	s4,32(sp)
    80001828:	ec56                	sd	s5,24(sp)
    8000182a:	e85a                	sd	s6,16(sp)
    8000182c:	e45e                	sd	s7,8(sp)
    8000182e:	e062                	sd	s8,0(sp)
    80001830:	0880                	addi	s0,sp,80
  pte_t *pte;

  // printf("unmapping %d bytes from %p\n",nbytes, va);

  // borrowed from "uvmunmap"
  for(a = va; a < va + nbytes; a += PGSIZE){
    80001832:	00c58ab3          	add	s5,a1,a2
    80001836:	0f55f863          	bgeu	a1,s5,80001926 <vmaunmap+0x10c>
    8000183a:	8b2a                	mv	s6,a0
    8000183c:	892e                	mv	s2,a1
    8000183e:	8c36                	mv	s8,a3
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("sys_munmap: walk");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001840:	4b85                	li	s7,1
        begin_op();
        ilock(v->f->ip);
        uint64 aoff = a - v->vastart; // offset relative to the start of memory range
        if(aoff < 0) { // if the first page is not a full 4k page
          writei(v->f->ip, 0, pa + (-aoff), v->offset, PGSIZE + aoff);
        } else if(aoff + PGSIZE > v->sz){  // if the last page is not a full 4k page
    80001842:	6a05                	lui	s4,0x1
    80001844:	a09d                	j	800018aa <vmaunmap+0x90>
      panic("sys_munmap: walk");
    80001846:	00007517          	auipc	a0,0x7
    8000184a:	97a50513          	addi	a0,a0,-1670 # 800081c0 <digits+0x180>
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	cec080e7          	jalr	-788(ra) # 8000053a <panic>
      panic("sys_munmap: not a leaf");
    80001856:	00007517          	auipc	a0,0x7
    8000185a:	98250513          	addi	a0,a0,-1662 # 800081d8 <digits+0x198>
    8000185e:	fffff097          	auipc	ra,0xfffff
    80001862:	cdc080e7          	jalr	-804(ra) # 8000053a <panic>
          writei(v->f->ip, 0, pa, v->offset + aoff, v->sz - aoff);
        } else { // full 4k pages
          writei(v->f->ip, 0, pa, v->offset + aoff, PGSIZE);
    80001866:	028c3683          	ld	a3,40(s8)
    8000186a:	018c3503          	ld	a0,24(s8)
    8000186e:	8752                	mv	a4,s4
    80001870:	9ebd                	addw	a3,a3,a5
    80001872:	864e                	mv	a2,s3
    80001874:	4581                	li	a1,0
    80001876:	6d08                	ld	a0,24(a0)
    80001878:	00002097          	auipc	ra,0x2
    8000187c:	2fc080e7          	jalr	764(ra) # 80003b74 <writei>
        }
        iunlock(v->f->ip);
    80001880:	018c3783          	ld	a5,24(s8)
    80001884:	6f88                	ld	a0,24(a5)
    80001886:	00002097          	auipc	ra,0x2
    8000188a:	004080e7          	jalr	4(ra) # 8000388a <iunlock>
        end_op();
    8000188e:	00003097          	auipc	ra,0x3
    80001892:	994080e7          	jalr	-1644(ra) # 80004222 <end_op>
      }
      kfree((void*)pa);
    80001896:	854e                	mv	a0,s3
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	14a080e7          	jalr	330(ra) # 800009e2 <kfree>
      *pte = 0;
    800018a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + nbytes; a += PGSIZE){
    800018a4:	9952                	add	s2,s2,s4
    800018a6:	09597063          	bgeu	s2,s5,80001926 <vmaunmap+0x10c>
    if((pte = walk(pagetable, a, 0)) == 0)
    800018aa:	4601                	li	a2,0
    800018ac:	85ca                	mv	a1,s2
    800018ae:	855a                	mv	a0,s6
    800018b0:	fffff097          	auipc	ra,0xfffff
    800018b4:	704080e7          	jalr	1796(ra) # 80000fb4 <walk>
    800018b8:	84aa                	mv	s1,a0
    800018ba:	d551                	beqz	a0,80001846 <vmaunmap+0x2c>
    if(PTE_FLAGS(*pte) == PTE_V)
    800018bc:	611c                	ld	a5,0(a0)
    800018be:	3ff7f713          	andi	a4,a5,1023
    800018c2:	f9770ae3          	beq	a4,s7,80001856 <vmaunmap+0x3c>
    if(*pte & PTE_V){
    800018c6:	0017f713          	andi	a4,a5,1
    800018ca:	df69                	beqz	a4,800018a4 <vmaunmap+0x8a>
      uint64 pa = PTE2PA(*pte);
    800018cc:	00a7d993          	srli	s3,a5,0xa
    800018d0:	09b2                	slli	s3,s3,0xc
      if((*pte & PTE_D) && (v->flags & MAP_SHARED)) { // dirty, need to write back to disk
    800018d2:	0807f793          	andi	a5,a5,128
    800018d6:	d3e1                	beqz	a5,80001896 <vmaunmap+0x7c>
    800018d8:	024c2783          	lw	a5,36(s8)
    800018dc:	8b85                	andi	a5,a5,1
    800018de:	dfc5                	beqz	a5,80001896 <vmaunmap+0x7c>
        begin_op();
    800018e0:	00003097          	auipc	ra,0x3
    800018e4:	8c4080e7          	jalr	-1852(ra) # 800041a4 <begin_op>
        ilock(v->f->ip);
    800018e8:	018c3783          	ld	a5,24(s8)
    800018ec:	6f88                	ld	a0,24(a5)
    800018ee:	00002097          	auipc	ra,0x2
    800018f2:	eda080e7          	jalr	-294(ra) # 800037c8 <ilock>
        uint64 aoff = a - v->vastart; // offset relative to the start of memory range
    800018f6:	008c3783          	ld	a5,8(s8)
    800018fa:	40f907b3          	sub	a5,s2,a5
        } else if(aoff + PGSIZE > v->sz){  // if the last page is not a full 4k page
    800018fe:	010c3703          	ld	a4,16(s8)
    80001902:	014786b3          	add	a3,a5,s4
    80001906:	f6d770e3          	bgeu	a4,a3,80001866 <vmaunmap+0x4c>
          writei(v->f->ip, 0, pa, v->offset + aoff, v->sz - aoff);
    8000190a:	028c3683          	ld	a3,40(s8)
    8000190e:	018c3503          	ld	a0,24(s8)
    80001912:	9f1d                	subw	a4,a4,a5
    80001914:	9ebd                	addw	a3,a3,a5
    80001916:	864e                	mv	a2,s3
    80001918:	4581                	li	a1,0
    8000191a:	6d08                	ld	a0,24(a0)
    8000191c:	00002097          	auipc	ra,0x2
    80001920:	258080e7          	jalr	600(ra) # 80003b74 <writei>
    80001924:	bfb1                	j	80001880 <vmaunmap+0x66>
    }
  }
}
    80001926:	60a6                	ld	ra,72(sp)
    80001928:	6406                	ld	s0,64(sp)
    8000192a:	74e2                	ld	s1,56(sp)
    8000192c:	7942                	ld	s2,48(sp)
    8000192e:	79a2                	ld	s3,40(sp)
    80001930:	7a02                	ld	s4,32(sp)
    80001932:	6ae2                	ld	s5,24(sp)
    80001934:	6b42                	ld	s6,16(sp)
    80001936:	6ba2                	ld	s7,8(sp)
    80001938:	6c02                	ld	s8,0(sp)
    8000193a:	6161                	addi	sp,sp,80
    8000193c:	8082                	ret

000000008000193e <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    8000193e:	1101                	addi	sp,sp,-32
    80001940:	ec06                	sd	ra,24(sp)
    80001942:	e822                	sd	s0,16(sp)
    80001944:	e426                	sd	s1,8(sp)
    80001946:	1000                	addi	s0,sp,32
    80001948:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000194a:	fffff097          	auipc	ra,0xfffff
    8000194e:	20c080e7          	jalr	524(ra) # 80000b56 <holding>
    80001952:	c909                	beqz	a0,80001964 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001954:	749c                	ld	a5,40(s1)
    80001956:	00978f63          	beq	a5,s1,80001974 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    8000195a:	60e2                	ld	ra,24(sp)
    8000195c:	6442                	ld	s0,16(sp)
    8000195e:	64a2                	ld	s1,8(sp)
    80001960:	6105                	addi	sp,sp,32
    80001962:	8082                	ret
    panic("wakeup1");
    80001964:	00007517          	auipc	a0,0x7
    80001968:	88c50513          	addi	a0,a0,-1908 # 800081f0 <digits+0x1b0>
    8000196c:	fffff097          	auipc	ra,0xfffff
    80001970:	bce080e7          	jalr	-1074(ra) # 8000053a <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001974:	4c98                	lw	a4,24(s1)
    80001976:	4785                	li	a5,1
    80001978:	fef711e3          	bne	a4,a5,8000195a <wakeup1+0x1c>
    p->state = RUNNABLE;
    8000197c:	4789                	li	a5,2
    8000197e:	cc9c                	sw	a5,24(s1)
}
    80001980:	bfe9                	j	8000195a <wakeup1+0x1c>

0000000080001982 <proc_mapstacks>:
proc_mapstacks(pagetable_t kpgtbl) {
    80001982:	7139                	addi	sp,sp,-64
    80001984:	fc06                	sd	ra,56(sp)
    80001986:	f822                	sd	s0,48(sp)
    80001988:	f426                	sd	s1,40(sp)
    8000198a:	f04a                	sd	s2,32(sp)
    8000198c:	ec4e                	sd	s3,24(sp)
    8000198e:	e852                	sd	s4,16(sp)
    80001990:	e456                	sd	s5,8(sp)
    80001992:	e05a                	sd	s6,0(sp)
    80001994:	0080                	addi	s0,sp,64
    80001996:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001998:	00010497          	auipc	s1,0x10
    8000199c:	d2048493          	addi	s1,s1,-736 # 800116b8 <proc>
    uint64 va = KSTACK((int) (p - proc));
    800019a0:	8b26                	mv	s6,s1
    800019a2:	00006a97          	auipc	s5,0x6
    800019a6:	65ea8a93          	addi	s5,s5,1630 # 80008000 <etext>
    800019aa:	04000937          	lui	s2,0x4000
    800019ae:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800019b0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019b2:	00021a17          	auipc	s4,0x21
    800019b6:	706a0a13          	addi	s4,s4,1798 # 800230b8 <tickslock>
    char *pa = kalloc();
    800019ba:	fffff097          	auipc	ra,0xfffff
    800019be:	126080e7          	jalr	294(ra) # 80000ae0 <kalloc>
    800019c2:	862a                	mv	a2,a0
    if(pa == 0)
    800019c4:	c131                	beqz	a0,80001a08 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    800019c6:	416485b3          	sub	a1,s1,s6
    800019ca:	858d                	srai	a1,a1,0x3
    800019cc:	000ab783          	ld	a5,0(s5)
    800019d0:	02f585b3          	mul	a1,a1,a5
    800019d4:	2585                	addiw	a1,a1,1
    800019d6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019da:	4719                	li	a4,6
    800019dc:	6685                	lui	a3,0x1
    800019de:	40b905b3          	sub	a1,s2,a1
    800019e2:	854e                	mv	a0,s3
    800019e4:	fffff097          	auipc	ra,0xfffff
    800019e8:	746080e7          	jalr	1862(ra) # 8000112a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ec:	46848493          	addi	s1,s1,1128
    800019f0:	fd4495e3          	bne	s1,s4,800019ba <proc_mapstacks+0x38>
}
    800019f4:	70e2                	ld	ra,56(sp)
    800019f6:	7442                	ld	s0,48(sp)
    800019f8:	74a2                	ld	s1,40(sp)
    800019fa:	7902                	ld	s2,32(sp)
    800019fc:	69e2                	ld	s3,24(sp)
    800019fe:	6a42                	ld	s4,16(sp)
    80001a00:	6aa2                	ld	s5,8(sp)
    80001a02:	6b02                	ld	s6,0(sp)
    80001a04:	6121                	addi	sp,sp,64
    80001a06:	8082                	ret
      panic("kalloc");
    80001a08:	00006517          	auipc	a0,0x6
    80001a0c:	7f050513          	addi	a0,a0,2032 # 800081f8 <digits+0x1b8>
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	b2a080e7          	jalr	-1238(ra) # 8000053a <panic>

0000000080001a18 <procinit>:
{
    80001a18:	7139                	addi	sp,sp,-64
    80001a1a:	fc06                	sd	ra,56(sp)
    80001a1c:	f822                	sd	s0,48(sp)
    80001a1e:	f426                	sd	s1,40(sp)
    80001a20:	f04a                	sd	s2,32(sp)
    80001a22:	ec4e                	sd	s3,24(sp)
    80001a24:	e852                	sd	s4,16(sp)
    80001a26:	e456                	sd	s5,8(sp)
    80001a28:	e05a                	sd	s6,0(sp)
    80001a2a:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80001a2c:	00006597          	auipc	a1,0x6
    80001a30:	7d458593          	addi	a1,a1,2004 # 80008200 <digits+0x1c0>
    80001a34:	00010517          	auipc	a0,0x10
    80001a38:	86c50513          	addi	a0,a0,-1940 # 800112a0 <pid_lock>
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	104080e7          	jalr	260(ra) # 80000b40 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a44:	00010497          	auipc	s1,0x10
    80001a48:	c7448493          	addi	s1,s1,-908 # 800116b8 <proc>
      initlock(&p->lock, "proc");
    80001a4c:	00006b17          	auipc	s6,0x6
    80001a50:	7bcb0b13          	addi	s6,s6,1980 # 80008208 <digits+0x1c8>
      p->kstack = KSTACK((int) (p - proc));
    80001a54:	8aa6                	mv	s5,s1
    80001a56:	00006a17          	auipc	s4,0x6
    80001a5a:	5aaa0a13          	addi	s4,s4,1450 # 80008000 <etext>
    80001a5e:	04000937          	lui	s2,0x4000
    80001a62:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001a64:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a66:	00021997          	auipc	s3,0x21
    80001a6a:	65298993          	addi	s3,s3,1618 # 800230b8 <tickslock>
      initlock(&p->lock, "proc");
    80001a6e:	85da                	mv	a1,s6
    80001a70:	8526                	mv	a0,s1
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	0ce080e7          	jalr	206(ra) # 80000b40 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001a7a:	415487b3          	sub	a5,s1,s5
    80001a7e:	878d                	srai	a5,a5,0x3
    80001a80:	000a3703          	ld	a4,0(s4)
    80001a84:	02e787b3          	mul	a5,a5,a4
    80001a88:	2785                	addiw	a5,a5,1
    80001a8a:	00d7979b          	slliw	a5,a5,0xd
    80001a8e:	40f907b3          	sub	a5,s2,a5
    80001a92:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a94:	46848493          	addi	s1,s1,1128
    80001a98:	fd349be3          	bne	s1,s3,80001a6e <procinit+0x56>
}
    80001a9c:	70e2                	ld	ra,56(sp)
    80001a9e:	7442                	ld	s0,48(sp)
    80001aa0:	74a2                	ld	s1,40(sp)
    80001aa2:	7902                	ld	s2,32(sp)
    80001aa4:	69e2                	ld	s3,24(sp)
    80001aa6:	6a42                	ld	s4,16(sp)
    80001aa8:	6aa2                	ld	s5,8(sp)
    80001aaa:	6b02                	ld	s6,0(sp)
    80001aac:	6121                	addi	sp,sp,64
    80001aae:	8082                	ret

0000000080001ab0 <cpuid>:
{
    80001ab0:	1141                	addi	sp,sp,-16
    80001ab2:	e422                	sd	s0,8(sp)
    80001ab4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ab6:	8512                	mv	a0,tp
}
    80001ab8:	2501                	sext.w	a0,a0
    80001aba:	6422                	ld	s0,8(sp)
    80001abc:	0141                	addi	sp,sp,16
    80001abe:	8082                	ret

0000000080001ac0 <mycpu>:
mycpu(void) {
    80001ac0:	1141                	addi	sp,sp,-16
    80001ac2:	e422                	sd	s0,8(sp)
    80001ac4:	0800                	addi	s0,sp,16
    80001ac6:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001ac8:	2781                	sext.w	a5,a5
    80001aca:	079e                	slli	a5,a5,0x7
}
    80001acc:	0000f517          	auipc	a0,0xf
    80001ad0:	7ec50513          	addi	a0,a0,2028 # 800112b8 <cpus>
    80001ad4:	953e                	add	a0,a0,a5
    80001ad6:	6422                	ld	s0,8(sp)
    80001ad8:	0141                	addi	sp,sp,16
    80001ada:	8082                	ret

0000000080001adc <myproc>:
myproc(void) {
    80001adc:	1101                	addi	sp,sp,-32
    80001ade:	ec06                	sd	ra,24(sp)
    80001ae0:	e822                	sd	s0,16(sp)
    80001ae2:	e426                	sd	s1,8(sp)
    80001ae4:	1000                	addi	s0,sp,32
  push_off();
    80001ae6:	fffff097          	auipc	ra,0xfffff
    80001aea:	09e080e7          	jalr	158(ra) # 80000b84 <push_off>
    80001aee:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001af0:	2781                	sext.w	a5,a5
    80001af2:	079e                	slli	a5,a5,0x7
    80001af4:	0000f717          	auipc	a4,0xf
    80001af8:	7ac70713          	addi	a4,a4,1964 # 800112a0 <pid_lock>
    80001afc:	97ba                	add	a5,a5,a4
    80001afe:	6f84                	ld	s1,24(a5)
  pop_off();
    80001b00:	fffff097          	auipc	ra,0xfffff
    80001b04:	124080e7          	jalr	292(ra) # 80000c24 <pop_off>
}
    80001b08:	8526                	mv	a0,s1
    80001b0a:	60e2                	ld	ra,24(sp)
    80001b0c:	6442                	ld	s0,16(sp)
    80001b0e:	64a2                	ld	s1,8(sp)
    80001b10:	6105                	addi	sp,sp,32
    80001b12:	8082                	ret

0000000080001b14 <forkret>:
{
    80001b14:	1141                	addi	sp,sp,-16
    80001b16:	e406                	sd	ra,8(sp)
    80001b18:	e022                	sd	s0,0(sp)
    80001b1a:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001b1c:	00000097          	auipc	ra,0x0
    80001b20:	fc0080e7          	jalr	-64(ra) # 80001adc <myproc>
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	160080e7          	jalr	352(ra) # 80000c84 <release>
  if (first) {
    80001b2c:	00007797          	auipc	a5,0x7
    80001b30:	d447a783          	lw	a5,-700(a5) # 80008870 <first.1>
    80001b34:	eb89                	bnez	a5,80001b46 <forkret+0x32>
  usertrapret();
    80001b36:	00001097          	auipc	ra,0x1
    80001b3a:	cb4080e7          	jalr	-844(ra) # 800027ea <usertrapret>
}
    80001b3e:	60a2                	ld	ra,8(sp)
    80001b40:	6402                	ld	s0,0(sp)
    80001b42:	0141                	addi	sp,sp,16
    80001b44:	8082                	ret
    first = 0;
    80001b46:	00007797          	auipc	a5,0x7
    80001b4a:	d207a523          	sw	zero,-726(a5) # 80008870 <first.1>
    fsinit(ROOTDEV);
    80001b4e:	4505                	li	a0,1
    80001b50:	00002097          	auipc	ra,0x2
    80001b54:	9fe080e7          	jalr	-1538(ra) # 8000354e <fsinit>
    80001b58:	bff9                	j	80001b36 <forkret+0x22>

0000000080001b5a <allocpid>:
allocpid() {
    80001b5a:	1101                	addi	sp,sp,-32
    80001b5c:	ec06                	sd	ra,24(sp)
    80001b5e:	e822                	sd	s0,16(sp)
    80001b60:	e426                	sd	s1,8(sp)
    80001b62:	e04a                	sd	s2,0(sp)
    80001b64:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b66:	0000f917          	auipc	s2,0xf
    80001b6a:	73a90913          	addi	s2,s2,1850 # 800112a0 <pid_lock>
    80001b6e:	854a                	mv	a0,s2
    80001b70:	fffff097          	auipc	ra,0xfffff
    80001b74:	060080e7          	jalr	96(ra) # 80000bd0 <acquire>
  pid = nextpid;
    80001b78:	00007797          	auipc	a5,0x7
    80001b7c:	cfc78793          	addi	a5,a5,-772 # 80008874 <nextpid>
    80001b80:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b82:	0014871b          	addiw	a4,s1,1
    80001b86:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b88:	854a                	mv	a0,s2
    80001b8a:	fffff097          	auipc	ra,0xfffff
    80001b8e:	0fa080e7          	jalr	250(ra) # 80000c84 <release>
}
    80001b92:	8526                	mv	a0,s1
    80001b94:	60e2                	ld	ra,24(sp)
    80001b96:	6442                	ld	s0,16(sp)
    80001b98:	64a2                	ld	s1,8(sp)
    80001b9a:	6902                	ld	s2,0(sp)
    80001b9c:	6105                	addi	sp,sp,32
    80001b9e:	8082                	ret

0000000080001ba0 <proc_pagetable>:
{
    80001ba0:	1101                	addi	sp,sp,-32
    80001ba2:	ec06                	sd	ra,24(sp)
    80001ba4:	e822                	sd	s0,16(sp)
    80001ba6:	e426                	sd	s1,8(sp)
    80001ba8:	e04a                	sd	s2,0(sp)
    80001baa:	1000                	addi	s0,sp,32
    80001bac:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001bae:	fffff097          	auipc	ra,0xfffff
    80001bb2:	766080e7          	jalr	1894(ra) # 80001314 <uvmcreate>
    80001bb6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001bb8:	c121                	beqz	a0,80001bf8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001bba:	4729                	li	a4,10
    80001bbc:	00005697          	auipc	a3,0x5
    80001bc0:	44468693          	addi	a3,a3,1092 # 80007000 <_trampoline>
    80001bc4:	6605                	lui	a2,0x1
    80001bc6:	040005b7          	lui	a1,0x4000
    80001bca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bcc:	05b2                	slli	a1,a1,0xc
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	4ce080e7          	jalr	1230(ra) # 8000109c <mappages>
    80001bd6:	02054863          	bltz	a0,80001c06 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001bda:	4719                	li	a4,6
    80001bdc:	05893683          	ld	a3,88(s2)
    80001be0:	6605                	lui	a2,0x1
    80001be2:	020005b7          	lui	a1,0x2000
    80001be6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001be8:	05b6                	slli	a1,a1,0xd
    80001bea:	8526                	mv	a0,s1
    80001bec:	fffff097          	auipc	ra,0xfffff
    80001bf0:	4b0080e7          	jalr	1200(ra) # 8000109c <mappages>
    80001bf4:	02054163          	bltz	a0,80001c16 <proc_pagetable+0x76>
}
    80001bf8:	8526                	mv	a0,s1
    80001bfa:	60e2                	ld	ra,24(sp)
    80001bfc:	6442                	ld	s0,16(sp)
    80001bfe:	64a2                	ld	s1,8(sp)
    80001c00:	6902                	ld	s2,0(sp)
    80001c02:	6105                	addi	sp,sp,32
    80001c04:	8082                	ret
    uvmfree(pagetable, 0);
    80001c06:	4581                	li	a1,0
    80001c08:	8526                	mv	a0,s1
    80001c0a:	00000097          	auipc	ra,0x0
    80001c0e:	908080e7          	jalr	-1784(ra) # 80001512 <uvmfree>
    return 0;
    80001c12:	4481                	li	s1,0
    80001c14:	b7d5                	j	80001bf8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c16:	4681                	li	a3,0
    80001c18:	4605                	li	a2,1
    80001c1a:	040005b7          	lui	a1,0x4000
    80001c1e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c20:	05b2                	slli	a1,a1,0xc
    80001c22:	8526                	mv	a0,s1
    80001c24:	fffff097          	auipc	ra,0xfffff
    80001c28:	62c080e7          	jalr	1580(ra) # 80001250 <uvmunmap>
    uvmfree(pagetable, 0);
    80001c2c:	4581                	li	a1,0
    80001c2e:	8526                	mv	a0,s1
    80001c30:	00000097          	auipc	ra,0x0
    80001c34:	8e2080e7          	jalr	-1822(ra) # 80001512 <uvmfree>
    return 0;
    80001c38:	4481                	li	s1,0
    80001c3a:	bf7d                	j	80001bf8 <proc_pagetable+0x58>

0000000080001c3c <proc_freepagetable>:
{
    80001c3c:	1101                	addi	sp,sp,-32
    80001c3e:	ec06                	sd	ra,24(sp)
    80001c40:	e822                	sd	s0,16(sp)
    80001c42:	e426                	sd	s1,8(sp)
    80001c44:	e04a                	sd	s2,0(sp)
    80001c46:	1000                	addi	s0,sp,32
    80001c48:	84aa                	mv	s1,a0
    80001c4a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c4c:	4681                	li	a3,0
    80001c4e:	4605                	li	a2,1
    80001c50:	040005b7          	lui	a1,0x4000
    80001c54:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c56:	05b2                	slli	a1,a1,0xc
    80001c58:	fffff097          	auipc	ra,0xfffff
    80001c5c:	5f8080e7          	jalr	1528(ra) # 80001250 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c60:	4681                	li	a3,0
    80001c62:	4605                	li	a2,1
    80001c64:	020005b7          	lui	a1,0x2000
    80001c68:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c6a:	05b6                	slli	a1,a1,0xd
    80001c6c:	8526                	mv	a0,s1
    80001c6e:	fffff097          	auipc	ra,0xfffff
    80001c72:	5e2080e7          	jalr	1506(ra) # 80001250 <uvmunmap>
  uvmfree(pagetable, sz);
    80001c76:	85ca                	mv	a1,s2
    80001c78:	8526                	mv	a0,s1
    80001c7a:	00000097          	auipc	ra,0x0
    80001c7e:	898080e7          	jalr	-1896(ra) # 80001512 <uvmfree>
}
    80001c82:	60e2                	ld	ra,24(sp)
    80001c84:	6442                	ld	s0,16(sp)
    80001c86:	64a2                	ld	s1,8(sp)
    80001c88:	6902                	ld	s2,0(sp)
    80001c8a:	6105                	addi	sp,sp,32
    80001c8c:	8082                	ret

0000000080001c8e <freeproc>:
{
    80001c8e:	7179                	addi	sp,sp,-48
    80001c90:	f406                	sd	ra,40(sp)
    80001c92:	f022                	sd	s0,32(sp)
    80001c94:	ec26                	sd	s1,24(sp)
    80001c96:	e84a                	sd	s2,16(sp)
    80001c98:	e44e                	sd	s3,8(sp)
    80001c9a:	1800                	addi	s0,sp,48
    80001c9c:	892a                	mv	s2,a0
  if(p->trapframe)
    80001c9e:	6d28                	ld	a0,88(a0)
    80001ca0:	c509                	beqz	a0,80001caa <freeproc+0x1c>
    kfree((void*)p->trapframe);
    80001ca2:	fffff097          	auipc	ra,0xfffff
    80001ca6:	d40080e7          	jalr	-704(ra) # 800009e2 <kfree>
  p->trapframe = 0;
    80001caa:	04093c23          	sd	zero,88(s2)
  for(int i = 0; i < NVMA; i++) {
    80001cae:	16890493          	addi	s1,s2,360
    80001cb2:	46890993          	addi	s3,s2,1128
    vmaunmap(p->pagetable, v->vastart, v->sz, v);
    80001cb6:	86a6                	mv	a3,s1
    80001cb8:	6890                	ld	a2,16(s1)
    80001cba:	648c                	ld	a1,8(s1)
    80001cbc:	05093503          	ld	a0,80(s2)
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	b5a080e7          	jalr	-1190(ra) # 8000181a <vmaunmap>
  for(int i = 0; i < NVMA; i++) {
    80001cc8:	03048493          	addi	s1,s1,48
    80001ccc:	ff3495e3          	bne	s1,s3,80001cb6 <freeproc+0x28>
  if(p->pagetable)
    80001cd0:	05093503          	ld	a0,80(s2)
    80001cd4:	c519                	beqz	a0,80001ce2 <freeproc+0x54>
    proc_freepagetable(p->pagetable, p->sz);
    80001cd6:	04893583          	ld	a1,72(s2)
    80001cda:	00000097          	auipc	ra,0x0
    80001cde:	f62080e7          	jalr	-158(ra) # 80001c3c <proc_freepagetable>
  p->pagetable = 0;
    80001ce2:	04093823          	sd	zero,80(s2)
  p->sz = 0;
    80001ce6:	04093423          	sd	zero,72(s2)
  p->pid = 0;
    80001cea:	02092c23          	sw	zero,56(s2)
  p->parent = 0;
    80001cee:	02093023          	sd	zero,32(s2)
  p->name[0] = 0;
    80001cf2:	14090c23          	sb	zero,344(s2)
  p->chan = 0;
    80001cf6:	02093423          	sd	zero,40(s2)
  p->killed = 0;
    80001cfa:	02092823          	sw	zero,48(s2)
  p->xstate = 0;
    80001cfe:	02092a23          	sw	zero,52(s2)
  p->state = UNUSED;
    80001d02:	00092c23          	sw	zero,24(s2)
}
    80001d06:	70a2                	ld	ra,40(sp)
    80001d08:	7402                	ld	s0,32(sp)
    80001d0a:	64e2                	ld	s1,24(sp)
    80001d0c:	6942                	ld	s2,16(sp)
    80001d0e:	69a2                	ld	s3,8(sp)
    80001d10:	6145                	addi	sp,sp,48
    80001d12:	8082                	ret

0000000080001d14 <allocproc>:
{
    80001d14:	7179                	addi	sp,sp,-48
    80001d16:	f406                	sd	ra,40(sp)
    80001d18:	f022                	sd	s0,32(sp)
    80001d1a:	ec26                	sd	s1,24(sp)
    80001d1c:	e84a                	sd	s2,16(sp)
    80001d1e:	e44e                	sd	s3,8(sp)
    80001d20:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d22:	00010497          	auipc	s1,0x10
    80001d26:	99648493          	addi	s1,s1,-1642 # 800116b8 <proc>
    80001d2a:	00021997          	auipc	s3,0x21
    80001d2e:	38e98993          	addi	s3,s3,910 # 800230b8 <tickslock>
    acquire(&p->lock);
    80001d32:	8526                	mv	a0,s1
    80001d34:	fffff097          	auipc	ra,0xfffff
    80001d38:	e9c080e7          	jalr	-356(ra) # 80000bd0 <acquire>
    if(p->state == UNUSED) {
    80001d3c:	4c9c                	lw	a5,24(s1)
    80001d3e:	cf81                	beqz	a5,80001d56 <allocproc+0x42>
      release(&p->lock);
    80001d40:	8526                	mv	a0,s1
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	f42080e7          	jalr	-190(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d4a:	46848493          	addi	s1,s1,1128
    80001d4e:	ff3492e3          	bne	s1,s3,80001d32 <allocproc+0x1e>
  return 0;
    80001d52:	4481                	li	s1,0
    80001d54:	a08d                	j	80001db6 <allocproc+0xa2>
  p->pid = allocpid();
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	e04080e7          	jalr	-508(ra) # 80001b5a <allocpid>
    80001d5e:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	d80080e7          	jalr	-640(ra) # 80000ae0 <kalloc>
    80001d68:	89aa                	mv	s3,a0
    80001d6a:	eca8                	sd	a0,88(s1)
    80001d6c:	cd29                	beqz	a0,80001dc6 <allocproc+0xb2>
  p->pagetable = proc_pagetable(p);
    80001d6e:	8526                	mv	a0,s1
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	e30080e7          	jalr	-464(ra) # 80001ba0 <proc_pagetable>
    80001d78:	89aa                	mv	s3,a0
    80001d7a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001d7c:	cd21                	beqz	a0,80001dd4 <allocproc+0xc0>
  memset(&p->context, 0, sizeof(p->context));
    80001d7e:	07000613          	li	a2,112
    80001d82:	4581                	li	a1,0
    80001d84:	06048513          	addi	a0,s1,96
    80001d88:	fffff097          	auipc	ra,0xfffff
    80001d8c:	f44080e7          	jalr	-188(ra) # 80000ccc <memset>
  p->context.ra = (uint64)forkret;
    80001d90:	00000797          	auipc	a5,0x0
    80001d94:	d8478793          	addi	a5,a5,-636 # 80001b14 <forkret>
    80001d98:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d9a:	60bc                	ld	a5,64(s1)
    80001d9c:	6705                	lui	a4,0x1
    80001d9e:	97ba                	add	a5,a5,a4
    80001da0:	f4bc                	sd	a5,104(s1)
  for(int i=0;i<NVMA;i++) {
    80001da2:	16848793          	addi	a5,s1,360
    80001da6:	46848913          	addi	s2,s1,1128
    p->vmas[i].valid = 0;
    80001daa:	0007a023          	sw	zero,0(a5)
  for(int i=0;i<NVMA;i++) {
    80001dae:	03078793          	addi	a5,a5,48
    80001db2:	ff279ce3          	bne	a5,s2,80001daa <allocproc+0x96>
}
    80001db6:	8526                	mv	a0,s1
    80001db8:	70a2                	ld	ra,40(sp)
    80001dba:	7402                	ld	s0,32(sp)
    80001dbc:	64e2                	ld	s1,24(sp)
    80001dbe:	6942                	ld	s2,16(sp)
    80001dc0:	69a2                	ld	s3,8(sp)
    80001dc2:	6145                	addi	sp,sp,48
    80001dc4:	8082                	ret
    release(&p->lock);
    80001dc6:	8526                	mv	a0,s1
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	ebc080e7          	jalr	-324(ra) # 80000c84 <release>
    return 0;
    80001dd0:	84ce                	mv	s1,s3
    80001dd2:	b7d5                	j	80001db6 <allocproc+0xa2>
    freeproc(p);
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	eb8080e7          	jalr	-328(ra) # 80001c8e <freeproc>
    release(&p->lock);
    80001dde:	8526                	mv	a0,s1
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	ea4080e7          	jalr	-348(ra) # 80000c84 <release>
    return 0;
    80001de8:	84ce                	mv	s1,s3
    80001dea:	b7f1                	j	80001db6 <allocproc+0xa2>

0000000080001dec <userinit>:
{
    80001dec:	1101                	addi	sp,sp,-32
    80001dee:	ec06                	sd	ra,24(sp)
    80001df0:	e822                	sd	s0,16(sp)
    80001df2:	e426                	sd	s1,8(sp)
    80001df4:	1000                	addi	s0,sp,32
  p = allocproc();
    80001df6:	00000097          	auipc	ra,0x0
    80001dfa:	f1e080e7          	jalr	-226(ra) # 80001d14 <allocproc>
    80001dfe:	84aa                	mv	s1,a0
  initproc = p;
    80001e00:	00007797          	auipc	a5,0x7
    80001e04:	22a7b423          	sd	a0,552(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001e08:	03400613          	li	a2,52
    80001e0c:	00007597          	auipc	a1,0x7
    80001e10:	a7458593          	addi	a1,a1,-1420 # 80008880 <initcode>
    80001e14:	6928                	ld	a0,80(a0)
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	52c080e7          	jalr	1324(ra) # 80001342 <uvminit>
  p->sz = PGSIZE;
    80001e1e:	6785                	lui	a5,0x1
    80001e20:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001e22:	6cb8                	ld	a4,88(s1)
    80001e24:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001e28:	6cb8                	ld	a4,88(s1)
    80001e2a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e2c:	4641                	li	a2,16
    80001e2e:	00006597          	auipc	a1,0x6
    80001e32:	3e258593          	addi	a1,a1,994 # 80008210 <digits+0x1d0>
    80001e36:	15848513          	addi	a0,s1,344
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	fe4080e7          	jalr	-28(ra) # 80000e1e <safestrcpy>
  p->cwd = namei("/");
    80001e42:	00006517          	auipc	a0,0x6
    80001e46:	3de50513          	addi	a0,a0,990 # 80008220 <digits+0x1e0>
    80001e4a:	00002097          	auipc	ra,0x2
    80001e4e:	13a080e7          	jalr	314(ra) # 80003f84 <namei>
    80001e52:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001e56:	4789                	li	a5,2
    80001e58:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001e5a:	8526                	mv	a0,s1
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	e28080e7          	jalr	-472(ra) # 80000c84 <release>
}
    80001e64:	60e2                	ld	ra,24(sp)
    80001e66:	6442                	ld	s0,16(sp)
    80001e68:	64a2                	ld	s1,8(sp)
    80001e6a:	6105                	addi	sp,sp,32
    80001e6c:	8082                	ret

0000000080001e6e <growproc>:
{
    80001e6e:	1101                	addi	sp,sp,-32
    80001e70:	ec06                	sd	ra,24(sp)
    80001e72:	e822                	sd	s0,16(sp)
    80001e74:	e426                	sd	s1,8(sp)
    80001e76:	e04a                	sd	s2,0(sp)
    80001e78:	1000                	addi	s0,sp,32
    80001e7a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	c60080e7          	jalr	-928(ra) # 80001adc <myproc>
    80001e84:	892a                	mv	s2,a0
  sz = p->sz;
    80001e86:	652c                	ld	a1,72(a0)
    80001e88:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001e8c:	00904f63          	bgtz	s1,80001eaa <growproc+0x3c>
  } else if(n < 0){
    80001e90:	0204cd63          	bltz	s1,80001eca <growproc+0x5c>
  p->sz = sz;
    80001e94:	1782                	slli	a5,a5,0x20
    80001e96:	9381                	srli	a5,a5,0x20
    80001e98:	04f93423          	sd	a5,72(s2)
  return 0;
    80001e9c:	4501                	li	a0,0
}
    80001e9e:	60e2                	ld	ra,24(sp)
    80001ea0:	6442                	ld	s0,16(sp)
    80001ea2:	64a2                	ld	s1,8(sp)
    80001ea4:	6902                	ld	s2,0(sp)
    80001ea6:	6105                	addi	sp,sp,32
    80001ea8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001eaa:	00f4863b          	addw	a2,s1,a5
    80001eae:	1602                	slli	a2,a2,0x20
    80001eb0:	9201                	srli	a2,a2,0x20
    80001eb2:	1582                	slli	a1,a1,0x20
    80001eb4:	9181                	srli	a1,a1,0x20
    80001eb6:	6928                	ld	a0,80(a0)
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	544080e7          	jalr	1348(ra) # 800013fc <uvmalloc>
    80001ec0:	0005079b          	sext.w	a5,a0
    80001ec4:	fbe1                	bnez	a5,80001e94 <growproc+0x26>
      return -1;
    80001ec6:	557d                	li	a0,-1
    80001ec8:	bfd9                	j	80001e9e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001eca:	00f4863b          	addw	a2,s1,a5
    80001ece:	1602                	slli	a2,a2,0x20
    80001ed0:	9201                	srli	a2,a2,0x20
    80001ed2:	1582                	slli	a1,a1,0x20
    80001ed4:	9181                	srli	a1,a1,0x20
    80001ed6:	6928                	ld	a0,80(a0)
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	4dc080e7          	jalr	1244(ra) # 800013b4 <uvmdealloc>
    80001ee0:	0005079b          	sext.w	a5,a0
    80001ee4:	bf45                	j	80001e94 <growproc+0x26>

0000000080001ee6 <fork>:
{
    80001ee6:	7139                	addi	sp,sp,-64
    80001ee8:	fc06                	sd	ra,56(sp)
    80001eea:	f822                	sd	s0,48(sp)
    80001eec:	f426                	sd	s1,40(sp)
    80001eee:	f04a                	sd	s2,32(sp)
    80001ef0:	ec4e                	sd	s3,24(sp)
    80001ef2:	e852                	sd	s4,16(sp)
    80001ef4:	e456                	sd	s5,8(sp)
    80001ef6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001ef8:	00000097          	auipc	ra,0x0
    80001efc:	be4080e7          	jalr	-1052(ra) # 80001adc <myproc>
    80001f00:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80001f02:	00000097          	auipc	ra,0x0
    80001f06:	e12080e7          	jalr	-494(ra) # 80001d14 <allocproc>
    80001f0a:	12050b63          	beqz	a0,80002040 <fork+0x15a>
    80001f0e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001f10:	048a3603          	ld	a2,72(s4)
    80001f14:	692c                	ld	a1,80(a0)
    80001f16:	050a3503          	ld	a0,80(s4)
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	632080e7          	jalr	1586(ra) # 8000154c <uvmcopy>
    80001f22:	04054a63          	bltz	a0,80001f76 <fork+0x90>
  np->sz = p->sz;
    80001f26:	048a3783          	ld	a5,72(s4)
    80001f2a:	04f9b423          	sd	a5,72(s3)
  np->parent = p;
    80001f2e:	0349b023          	sd	s4,32(s3)
  *(np->trapframe) = *(p->trapframe);
    80001f32:	058a3683          	ld	a3,88(s4)
    80001f36:	87b6                	mv	a5,a3
    80001f38:	0589b703          	ld	a4,88(s3)
    80001f3c:	12068693          	addi	a3,a3,288
    80001f40:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001f44:	6788                	ld	a0,8(a5)
    80001f46:	6b8c                	ld	a1,16(a5)
    80001f48:	6f90                	ld	a2,24(a5)
    80001f4a:	01073023          	sd	a6,0(a4)
    80001f4e:	e708                	sd	a0,8(a4)
    80001f50:	eb0c                	sd	a1,16(a4)
    80001f52:	ef10                	sd	a2,24(a4)
    80001f54:	02078793          	addi	a5,a5,32
    80001f58:	02070713          	addi	a4,a4,32
    80001f5c:	fed792e3          	bne	a5,a3,80001f40 <fork+0x5a>
  np->trapframe->a0 = 0;
    80001f60:	0589b783          	ld	a5,88(s3)
    80001f64:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001f68:	0d0a0493          	addi	s1,s4,208
    80001f6c:	0d098913          	addi	s2,s3,208
    80001f70:	150a0a93          	addi	s5,s4,336
    80001f74:	a00d                	j	80001f96 <fork+0xb0>
    freeproc(np);
    80001f76:	854e                	mv	a0,s3
    80001f78:	00000097          	auipc	ra,0x0
    80001f7c:	d16080e7          	jalr	-746(ra) # 80001c8e <freeproc>
    release(&np->lock);
    80001f80:	854e                	mv	a0,s3
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	d02080e7          	jalr	-766(ra) # 80000c84 <release>
    return -1;
    80001f8a:	54fd                	li	s1,-1
    80001f8c:	a045                	j	8000202c <fork+0x146>
  for(i = 0; i < NOFILE; i++)
    80001f8e:	04a1                	addi	s1,s1,8
    80001f90:	0921                	addi	s2,s2,8
    80001f92:	01548b63          	beq	s1,s5,80001fa8 <fork+0xc2>
    if(p->ofile[i])
    80001f96:	6088                	ld	a0,0(s1)
    80001f98:	d97d                	beqz	a0,80001f8e <fork+0xa8>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f9a:	00002097          	auipc	ra,0x2
    80001f9e:	688080e7          	jalr	1672(ra) # 80004622 <filedup>
    80001fa2:	00a93023          	sd	a0,0(s2)
    80001fa6:	b7e5                	j	80001f8e <fork+0xa8>
  np->cwd = idup(p->cwd);
    80001fa8:	150a3503          	ld	a0,336(s4)
    80001fac:	00001097          	auipc	ra,0x1
    80001fb0:	7de080e7          	jalr	2014(ra) # 8000378a <idup>
    80001fb4:	14a9b823          	sd	a0,336(s3)
  for(i = 0; i < NVMA; i++) {
    80001fb8:	168a0493          	addi	s1,s4,360
    80001fbc:	16898913          	addi	s2,s3,360
    80001fc0:	468a0a93          	addi	s5,s4,1128
    80001fc4:	a039                	j	80001fd2 <fork+0xec>
    80001fc6:	03048493          	addi	s1,s1,48
    80001fca:	03090913          	addi	s2,s2,48
    80001fce:	03548c63          	beq	s1,s5,80002006 <fork+0x120>
    if(v->valid) {
    80001fd2:	409c                	lw	a5,0(s1)
    80001fd4:	dbed                	beqz	a5,80001fc6 <fork+0xe0>
      np->vmas[i] = *v;
    80001fd6:	6088                	ld	a0,0(s1)
    80001fd8:	648c                	ld	a1,8(s1)
    80001fda:	6890                	ld	a2,16(s1)
    80001fdc:	6c94                	ld	a3,24(s1)
    80001fde:	7098                	ld	a4,32(s1)
    80001fe0:	749c                	ld	a5,40(s1)
    80001fe2:	00a93023          	sd	a0,0(s2)
    80001fe6:	00b93423          	sd	a1,8(s2)
    80001fea:	00c93823          	sd	a2,16(s2)
    80001fee:	00d93c23          	sd	a3,24(s2)
    80001ff2:	02e93023          	sd	a4,32(s2)
    80001ff6:	02f93423          	sd	a5,40(s2)
      filedup(v->f);
    80001ffa:	6c88                	ld	a0,24(s1)
    80001ffc:	00002097          	auipc	ra,0x2
    80002000:	626080e7          	jalr	1574(ra) # 80004622 <filedup>
    80002004:	b7c9                	j	80001fc6 <fork+0xe0>
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002006:	4641                	li	a2,16
    80002008:	158a0593          	addi	a1,s4,344
    8000200c:	15898513          	addi	a0,s3,344
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	e0e080e7          	jalr	-498(ra) # 80000e1e <safestrcpy>
  pid = np->pid;
    80002018:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    8000201c:	4789                	li	a5,2
    8000201e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002022:	854e                	mv	a0,s3
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	c60080e7          	jalr	-928(ra) # 80000c84 <release>
}
    8000202c:	8526                	mv	a0,s1
    8000202e:	70e2                	ld	ra,56(sp)
    80002030:	7442                	ld	s0,48(sp)
    80002032:	74a2                	ld	s1,40(sp)
    80002034:	7902                	ld	s2,32(sp)
    80002036:	69e2                	ld	s3,24(sp)
    80002038:	6a42                	ld	s4,16(sp)
    8000203a:	6aa2                	ld	s5,8(sp)
    8000203c:	6121                	addi	sp,sp,64
    8000203e:	8082                	ret
    return -1;
    80002040:	54fd                	li	s1,-1
    80002042:	b7ed                	j	8000202c <fork+0x146>

0000000080002044 <reparent>:
{
    80002044:	7179                	addi	sp,sp,-48
    80002046:	f406                	sd	ra,40(sp)
    80002048:	f022                	sd	s0,32(sp)
    8000204a:	ec26                	sd	s1,24(sp)
    8000204c:	e84a                	sd	s2,16(sp)
    8000204e:	e44e                	sd	s3,8(sp)
    80002050:	e052                	sd	s4,0(sp)
    80002052:	1800                	addi	s0,sp,48
    80002054:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002056:	0000f497          	auipc	s1,0xf
    8000205a:	66248493          	addi	s1,s1,1634 # 800116b8 <proc>
      pp->parent = initproc;
    8000205e:	00007a17          	auipc	s4,0x7
    80002062:	fcaa0a13          	addi	s4,s4,-54 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002066:	00021997          	auipc	s3,0x21
    8000206a:	05298993          	addi	s3,s3,82 # 800230b8 <tickslock>
    8000206e:	a029                	j	80002078 <reparent+0x34>
    80002070:	46848493          	addi	s1,s1,1128
    80002074:	03348363          	beq	s1,s3,8000209a <reparent+0x56>
    if(pp->parent == p){
    80002078:	709c                	ld	a5,32(s1)
    8000207a:	ff279be3          	bne	a5,s2,80002070 <reparent+0x2c>
      acquire(&pp->lock);
    8000207e:	8526                	mv	a0,s1
    80002080:	fffff097          	auipc	ra,0xfffff
    80002084:	b50080e7          	jalr	-1200(ra) # 80000bd0 <acquire>
      pp->parent = initproc;
    80002088:	000a3783          	ld	a5,0(s4)
    8000208c:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    8000208e:	8526                	mv	a0,s1
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	bf4080e7          	jalr	-1036(ra) # 80000c84 <release>
    80002098:	bfe1                	j	80002070 <reparent+0x2c>
}
    8000209a:	70a2                	ld	ra,40(sp)
    8000209c:	7402                	ld	s0,32(sp)
    8000209e:	64e2                	ld	s1,24(sp)
    800020a0:	6942                	ld	s2,16(sp)
    800020a2:	69a2                	ld	s3,8(sp)
    800020a4:	6a02                	ld	s4,0(sp)
    800020a6:	6145                	addi	sp,sp,48
    800020a8:	8082                	ret

00000000800020aa <scheduler>:
{
    800020aa:	711d                	addi	sp,sp,-96
    800020ac:	ec86                	sd	ra,88(sp)
    800020ae:	e8a2                	sd	s0,80(sp)
    800020b0:	e4a6                	sd	s1,72(sp)
    800020b2:	e0ca                	sd	s2,64(sp)
    800020b4:	fc4e                	sd	s3,56(sp)
    800020b6:	f852                	sd	s4,48(sp)
    800020b8:	f456                	sd	s5,40(sp)
    800020ba:	f05a                	sd	s6,32(sp)
    800020bc:	ec5e                	sd	s7,24(sp)
    800020be:	e862                	sd	s8,16(sp)
    800020c0:	e466                	sd	s9,8(sp)
    800020c2:	1080                	addi	s0,sp,96
    800020c4:	8792                	mv	a5,tp
  int id = r_tp();
    800020c6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800020c8:	00779c13          	slli	s8,a5,0x7
    800020cc:	0000f717          	auipc	a4,0xf
    800020d0:	1d470713          	addi	a4,a4,468 # 800112a0 <pid_lock>
    800020d4:	9762                	add	a4,a4,s8
    800020d6:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    800020da:	0000f717          	auipc	a4,0xf
    800020de:	1e670713          	addi	a4,a4,486 # 800112c0 <cpus+0x8>
    800020e2:	9c3a                	add	s8,s8,a4
    int nproc = 0;
    800020e4:	4c81                	li	s9,0
      if(p->state == RUNNABLE) {
    800020e6:	4a89                	li	s5,2
        c->proc = p;
    800020e8:	079e                	slli	a5,a5,0x7
    800020ea:	0000fb17          	auipc	s6,0xf
    800020ee:	1b6b0b13          	addi	s6,s6,438 # 800112a0 <pid_lock>
    800020f2:	9b3e                	add	s6,s6,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800020f4:	00021a17          	auipc	s4,0x21
    800020f8:	fc4a0a13          	addi	s4,s4,-60 # 800230b8 <tickslock>
    800020fc:	a8a1                	j	80002154 <scheduler+0xaa>
      release(&p->lock);
    800020fe:	8526                	mv	a0,s1
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	b84080e7          	jalr	-1148(ra) # 80000c84 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002108:	46848493          	addi	s1,s1,1128
    8000210c:	03448a63          	beq	s1,s4,80002140 <scheduler+0x96>
      acquire(&p->lock);
    80002110:	8526                	mv	a0,s1
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	abe080e7          	jalr	-1346(ra) # 80000bd0 <acquire>
      if(p->state != UNUSED) {
    8000211a:	4c9c                	lw	a5,24(s1)
    8000211c:	d3ed                	beqz	a5,800020fe <scheduler+0x54>
        nproc++;
    8000211e:	2985                	addiw	s3,s3,1
      if(p->state == RUNNABLE) {
    80002120:	fd579fe3          	bne	a5,s5,800020fe <scheduler+0x54>
        p->state = RUNNING;
    80002124:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    80002128:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    8000212c:	06048593          	addi	a1,s1,96
    80002130:	8562                	mv	a0,s8
    80002132:	00000097          	auipc	ra,0x0
    80002136:	60e080e7          	jalr	1550(ra) # 80002740 <swtch>
        c->proc = 0;
    8000213a:	000b3c23          	sd	zero,24(s6)
    8000213e:	b7c1                	j	800020fe <scheduler+0x54>
    if(nproc <= 2) {   // only init and sh exist
    80002140:	013aca63          	blt	s5,s3,80002154 <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002144:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002148:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000214c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002150:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002154:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002158:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000215c:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80002160:	89e6                	mv	s3,s9
    for(p = proc; p < &proc[NPROC]; p++) {
    80002162:	0000f497          	auipc	s1,0xf
    80002166:	55648493          	addi	s1,s1,1366 # 800116b8 <proc>
        p->state = RUNNING;
    8000216a:	4b8d                	li	s7,3
    8000216c:	b755                	j	80002110 <scheduler+0x66>

000000008000216e <sched>:
{
    8000216e:	7179                	addi	sp,sp,-48
    80002170:	f406                	sd	ra,40(sp)
    80002172:	f022                	sd	s0,32(sp)
    80002174:	ec26                	sd	s1,24(sp)
    80002176:	e84a                	sd	s2,16(sp)
    80002178:	e44e                	sd	s3,8(sp)
    8000217a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000217c:	00000097          	auipc	ra,0x0
    80002180:	960080e7          	jalr	-1696(ra) # 80001adc <myproc>
    80002184:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	9d0080e7          	jalr	-1584(ra) # 80000b56 <holding>
    8000218e:	c93d                	beqz	a0,80002204 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002190:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002192:	2781                	sext.w	a5,a5
    80002194:	079e                	slli	a5,a5,0x7
    80002196:	0000f717          	auipc	a4,0xf
    8000219a:	10a70713          	addi	a4,a4,266 # 800112a0 <pid_lock>
    8000219e:	97ba                	add	a5,a5,a4
    800021a0:	0907a703          	lw	a4,144(a5)
    800021a4:	4785                	li	a5,1
    800021a6:	06f71763          	bne	a4,a5,80002214 <sched+0xa6>
  if(p->state == RUNNING)
    800021aa:	4c98                	lw	a4,24(s1)
    800021ac:	478d                	li	a5,3
    800021ae:	06f70b63          	beq	a4,a5,80002224 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021b2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800021b6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800021b8:	efb5                	bnez	a5,80002234 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800021ba:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800021bc:	0000f917          	auipc	s2,0xf
    800021c0:	0e490913          	addi	s2,s2,228 # 800112a0 <pid_lock>
    800021c4:	2781                	sext.w	a5,a5
    800021c6:	079e                	slli	a5,a5,0x7
    800021c8:	97ca                	add	a5,a5,s2
    800021ca:	0947a983          	lw	s3,148(a5)
    800021ce:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800021d0:	2781                	sext.w	a5,a5
    800021d2:	079e                	slli	a5,a5,0x7
    800021d4:	0000f597          	auipc	a1,0xf
    800021d8:	0ec58593          	addi	a1,a1,236 # 800112c0 <cpus+0x8>
    800021dc:	95be                	add	a1,a1,a5
    800021de:	06048513          	addi	a0,s1,96
    800021e2:	00000097          	auipc	ra,0x0
    800021e6:	55e080e7          	jalr	1374(ra) # 80002740 <swtch>
    800021ea:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800021ec:	2781                	sext.w	a5,a5
    800021ee:	079e                	slli	a5,a5,0x7
    800021f0:	993e                	add	s2,s2,a5
    800021f2:	09392a23          	sw	s3,148(s2)
}
    800021f6:	70a2                	ld	ra,40(sp)
    800021f8:	7402                	ld	s0,32(sp)
    800021fa:	64e2                	ld	s1,24(sp)
    800021fc:	6942                	ld	s2,16(sp)
    800021fe:	69a2                	ld	s3,8(sp)
    80002200:	6145                	addi	sp,sp,48
    80002202:	8082                	ret
    panic("sched p->lock");
    80002204:	00006517          	auipc	a0,0x6
    80002208:	02450513          	addi	a0,a0,36 # 80008228 <digits+0x1e8>
    8000220c:	ffffe097          	auipc	ra,0xffffe
    80002210:	32e080e7          	jalr	814(ra) # 8000053a <panic>
    panic("sched locks");
    80002214:	00006517          	auipc	a0,0x6
    80002218:	02450513          	addi	a0,a0,36 # 80008238 <digits+0x1f8>
    8000221c:	ffffe097          	auipc	ra,0xffffe
    80002220:	31e080e7          	jalr	798(ra) # 8000053a <panic>
    panic("sched running");
    80002224:	00006517          	auipc	a0,0x6
    80002228:	02450513          	addi	a0,a0,36 # 80008248 <digits+0x208>
    8000222c:	ffffe097          	auipc	ra,0xffffe
    80002230:	30e080e7          	jalr	782(ra) # 8000053a <panic>
    panic("sched interruptible");
    80002234:	00006517          	auipc	a0,0x6
    80002238:	02450513          	addi	a0,a0,36 # 80008258 <digits+0x218>
    8000223c:	ffffe097          	auipc	ra,0xffffe
    80002240:	2fe080e7          	jalr	766(ra) # 8000053a <panic>

0000000080002244 <exit>:
{
    80002244:	7179                	addi	sp,sp,-48
    80002246:	f406                	sd	ra,40(sp)
    80002248:	f022                	sd	s0,32(sp)
    8000224a:	ec26                	sd	s1,24(sp)
    8000224c:	e84a                	sd	s2,16(sp)
    8000224e:	e44e                	sd	s3,8(sp)
    80002250:	e052                	sd	s4,0(sp)
    80002252:	1800                	addi	s0,sp,48
    80002254:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	886080e7          	jalr	-1914(ra) # 80001adc <myproc>
    8000225e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002260:	00007797          	auipc	a5,0x7
    80002264:	dc87b783          	ld	a5,-568(a5) # 80009028 <initproc>
    80002268:	0d050493          	addi	s1,a0,208
    8000226c:	15050913          	addi	s2,a0,336
    80002270:	02a79363          	bne	a5,a0,80002296 <exit+0x52>
    panic("init exiting");
    80002274:	00006517          	auipc	a0,0x6
    80002278:	ffc50513          	addi	a0,a0,-4 # 80008270 <digits+0x230>
    8000227c:	ffffe097          	auipc	ra,0xffffe
    80002280:	2be080e7          	jalr	702(ra) # 8000053a <panic>
      fileclose(f);
    80002284:	00002097          	auipc	ra,0x2
    80002288:	3f0080e7          	jalr	1008(ra) # 80004674 <fileclose>
      p->ofile[fd] = 0;
    8000228c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002290:	04a1                	addi	s1,s1,8
    80002292:	01248563          	beq	s1,s2,8000229c <exit+0x58>
    if(p->ofile[fd]){
    80002296:	6088                	ld	a0,0(s1)
    80002298:	f575                	bnez	a0,80002284 <exit+0x40>
    8000229a:	bfdd                	j	80002290 <exit+0x4c>
  begin_op();
    8000229c:	00002097          	auipc	ra,0x2
    800022a0:	f08080e7          	jalr	-248(ra) # 800041a4 <begin_op>
  iput(p->cwd);
    800022a4:	1509b503          	ld	a0,336(s3)
    800022a8:	00001097          	auipc	ra,0x1
    800022ac:	6da080e7          	jalr	1754(ra) # 80003982 <iput>
  end_op();
    800022b0:	00002097          	auipc	ra,0x2
    800022b4:	f72080e7          	jalr	-142(ra) # 80004222 <end_op>
  p->cwd = 0;
    800022b8:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800022bc:	00007497          	auipc	s1,0x7
    800022c0:	d6c48493          	addi	s1,s1,-660 # 80009028 <initproc>
    800022c4:	6088                	ld	a0,0(s1)
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	90a080e7          	jalr	-1782(ra) # 80000bd0 <acquire>
  wakeup1(initproc);
    800022ce:	6088                	ld	a0,0(s1)
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	66e080e7          	jalr	1646(ra) # 8000193e <wakeup1>
  release(&initproc->lock);
    800022d8:	6088                	ld	a0,0(s1)
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	9aa080e7          	jalr	-1622(ra) # 80000c84 <release>
  acquire(&p->lock);
    800022e2:	854e                	mv	a0,s3
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	8ec080e7          	jalr	-1812(ra) # 80000bd0 <acquire>
  struct proc *original_parent = p->parent;
    800022ec:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800022f0:	854e                	mv	a0,s3
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	992080e7          	jalr	-1646(ra) # 80000c84 <release>
  acquire(&original_parent->lock);
    800022fa:	8526                	mv	a0,s1
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	8d4080e7          	jalr	-1836(ra) # 80000bd0 <acquire>
  acquire(&p->lock);
    80002304:	854e                	mv	a0,s3
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	8ca080e7          	jalr	-1846(ra) # 80000bd0 <acquire>
  reparent(p);
    8000230e:	854e                	mv	a0,s3
    80002310:	00000097          	auipc	ra,0x0
    80002314:	d34080e7          	jalr	-716(ra) # 80002044 <reparent>
  wakeup1(original_parent);
    80002318:	8526                	mv	a0,s1
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	624080e7          	jalr	1572(ra) # 8000193e <wakeup1>
  p->xstate = status;
    80002322:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002326:	4791                	li	a5,4
    80002328:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000232c:	8526                	mv	a0,s1
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	956080e7          	jalr	-1706(ra) # 80000c84 <release>
  sched();
    80002336:	00000097          	auipc	ra,0x0
    8000233a:	e38080e7          	jalr	-456(ra) # 8000216e <sched>
  panic("zombie exit");
    8000233e:	00006517          	auipc	a0,0x6
    80002342:	f4250513          	addi	a0,a0,-190 # 80008280 <digits+0x240>
    80002346:	ffffe097          	auipc	ra,0xffffe
    8000234a:	1f4080e7          	jalr	500(ra) # 8000053a <panic>

000000008000234e <yield>:
{
    8000234e:	1101                	addi	sp,sp,-32
    80002350:	ec06                	sd	ra,24(sp)
    80002352:	e822                	sd	s0,16(sp)
    80002354:	e426                	sd	s1,8(sp)
    80002356:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	784080e7          	jalr	1924(ra) # 80001adc <myproc>
    80002360:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	86e080e7          	jalr	-1938(ra) # 80000bd0 <acquire>
  p->state = RUNNABLE;
    8000236a:	4789                	li	a5,2
    8000236c:	cc9c                	sw	a5,24(s1)
  sched();
    8000236e:	00000097          	auipc	ra,0x0
    80002372:	e00080e7          	jalr	-512(ra) # 8000216e <sched>
  release(&p->lock);
    80002376:	8526                	mv	a0,s1
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	90c080e7          	jalr	-1780(ra) # 80000c84 <release>
}
    80002380:	60e2                	ld	ra,24(sp)
    80002382:	6442                	ld	s0,16(sp)
    80002384:	64a2                	ld	s1,8(sp)
    80002386:	6105                	addi	sp,sp,32
    80002388:	8082                	ret

000000008000238a <sleep>:
{
    8000238a:	7179                	addi	sp,sp,-48
    8000238c:	f406                	sd	ra,40(sp)
    8000238e:	f022                	sd	s0,32(sp)
    80002390:	ec26                	sd	s1,24(sp)
    80002392:	e84a                	sd	s2,16(sp)
    80002394:	e44e                	sd	s3,8(sp)
    80002396:	1800                	addi	s0,sp,48
    80002398:	89aa                	mv	s3,a0
    8000239a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	740080e7          	jalr	1856(ra) # 80001adc <myproc>
    800023a4:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800023a6:	05250663          	beq	a0,s2,800023f2 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	826080e7          	jalr	-2010(ra) # 80000bd0 <acquire>
    release(lk);
    800023b2:	854a                	mv	a0,s2
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	8d0080e7          	jalr	-1840(ra) # 80000c84 <release>
  p->chan = chan;
    800023bc:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800023c0:	4785                	li	a5,1
    800023c2:	cc9c                	sw	a5,24(s1)
  sched();
    800023c4:	00000097          	auipc	ra,0x0
    800023c8:	daa080e7          	jalr	-598(ra) # 8000216e <sched>
  p->chan = 0;
    800023cc:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800023d0:	8526                	mv	a0,s1
    800023d2:	fffff097          	auipc	ra,0xfffff
    800023d6:	8b2080e7          	jalr	-1870(ra) # 80000c84 <release>
    acquire(lk);
    800023da:	854a                	mv	a0,s2
    800023dc:	ffffe097          	auipc	ra,0xffffe
    800023e0:	7f4080e7          	jalr	2036(ra) # 80000bd0 <acquire>
}
    800023e4:	70a2                	ld	ra,40(sp)
    800023e6:	7402                	ld	s0,32(sp)
    800023e8:	64e2                	ld	s1,24(sp)
    800023ea:	6942                	ld	s2,16(sp)
    800023ec:	69a2                	ld	s3,8(sp)
    800023ee:	6145                	addi	sp,sp,48
    800023f0:	8082                	ret
  p->chan = chan;
    800023f2:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800023f6:	4785                	li	a5,1
    800023f8:	cd1c                	sw	a5,24(a0)
  sched();
    800023fa:	00000097          	auipc	ra,0x0
    800023fe:	d74080e7          	jalr	-652(ra) # 8000216e <sched>
  p->chan = 0;
    80002402:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002406:	bff9                	j	800023e4 <sleep+0x5a>

0000000080002408 <wait>:
{
    80002408:	715d                	addi	sp,sp,-80
    8000240a:	e486                	sd	ra,72(sp)
    8000240c:	e0a2                	sd	s0,64(sp)
    8000240e:	fc26                	sd	s1,56(sp)
    80002410:	f84a                	sd	s2,48(sp)
    80002412:	f44e                	sd	s3,40(sp)
    80002414:	f052                	sd	s4,32(sp)
    80002416:	ec56                	sd	s5,24(sp)
    80002418:	e85a                	sd	s6,16(sp)
    8000241a:	e45e                	sd	s7,8(sp)
    8000241c:	0880                	addi	s0,sp,80
    8000241e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002420:	fffff097          	auipc	ra,0xfffff
    80002424:	6bc080e7          	jalr	1724(ra) # 80001adc <myproc>
    80002428:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000242a:	ffffe097          	auipc	ra,0xffffe
    8000242e:	7a6080e7          	jalr	1958(ra) # 80000bd0 <acquire>
    havekids = 0;
    80002432:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002434:	4a11                	li	s4,4
        havekids = 1;
    80002436:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002438:	00021997          	auipc	s3,0x21
    8000243c:	c8098993          	addi	s3,s3,-896 # 800230b8 <tickslock>
    havekids = 0;
    80002440:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002442:	0000f497          	auipc	s1,0xf
    80002446:	27648493          	addi	s1,s1,630 # 800116b8 <proc>
    8000244a:	a08d                	j	800024ac <wait+0xa4>
          pid = np->pid;
    8000244c:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002450:	000b0e63          	beqz	s6,8000246c <wait+0x64>
    80002454:	4691                	li	a3,4
    80002456:	03448613          	addi	a2,s1,52
    8000245a:	85da                	mv	a1,s6
    8000245c:	05093503          	ld	a0,80(s2)
    80002460:	fffff097          	auipc	ra,0xfffff
    80002464:	1f0080e7          	jalr	496(ra) # 80001650 <copyout>
    80002468:	02054263          	bltz	a0,8000248c <wait+0x84>
          freeproc(np);
    8000246c:	8526                	mv	a0,s1
    8000246e:	00000097          	auipc	ra,0x0
    80002472:	820080e7          	jalr	-2016(ra) # 80001c8e <freeproc>
          release(&np->lock);
    80002476:	8526                	mv	a0,s1
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	80c080e7          	jalr	-2036(ra) # 80000c84 <release>
          release(&p->lock);
    80002480:	854a                	mv	a0,s2
    80002482:	fffff097          	auipc	ra,0xfffff
    80002486:	802080e7          	jalr	-2046(ra) # 80000c84 <release>
          return pid;
    8000248a:	a8a9                	j	800024e4 <wait+0xdc>
            release(&np->lock);
    8000248c:	8526                	mv	a0,s1
    8000248e:	ffffe097          	auipc	ra,0xffffe
    80002492:	7f6080e7          	jalr	2038(ra) # 80000c84 <release>
            release(&p->lock);
    80002496:	854a                	mv	a0,s2
    80002498:	ffffe097          	auipc	ra,0xffffe
    8000249c:	7ec080e7          	jalr	2028(ra) # 80000c84 <release>
            return -1;
    800024a0:	59fd                	li	s3,-1
    800024a2:	a089                	j	800024e4 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    800024a4:	46848493          	addi	s1,s1,1128
    800024a8:	03348463          	beq	s1,s3,800024d0 <wait+0xc8>
      if(np->parent == p){
    800024ac:	709c                	ld	a5,32(s1)
    800024ae:	ff279be3          	bne	a5,s2,800024a4 <wait+0x9c>
        acquire(&np->lock);
    800024b2:	8526                	mv	a0,s1
    800024b4:	ffffe097          	auipc	ra,0xffffe
    800024b8:	71c080e7          	jalr	1820(ra) # 80000bd0 <acquire>
        if(np->state == ZOMBIE){
    800024bc:	4c9c                	lw	a5,24(s1)
    800024be:	f94787e3          	beq	a5,s4,8000244c <wait+0x44>
        release(&np->lock);
    800024c2:	8526                	mv	a0,s1
    800024c4:	ffffe097          	auipc	ra,0xffffe
    800024c8:	7c0080e7          	jalr	1984(ra) # 80000c84 <release>
        havekids = 1;
    800024cc:	8756                	mv	a4,s5
    800024ce:	bfd9                	j	800024a4 <wait+0x9c>
    if(!havekids || p->killed){
    800024d0:	c701                	beqz	a4,800024d8 <wait+0xd0>
    800024d2:	03092783          	lw	a5,48(s2)
    800024d6:	c39d                	beqz	a5,800024fc <wait+0xf4>
      release(&p->lock);
    800024d8:	854a                	mv	a0,s2
    800024da:	ffffe097          	auipc	ra,0xffffe
    800024de:	7aa080e7          	jalr	1962(ra) # 80000c84 <release>
      return -1;
    800024e2:	59fd                	li	s3,-1
}
    800024e4:	854e                	mv	a0,s3
    800024e6:	60a6                	ld	ra,72(sp)
    800024e8:	6406                	ld	s0,64(sp)
    800024ea:	74e2                	ld	s1,56(sp)
    800024ec:	7942                	ld	s2,48(sp)
    800024ee:	79a2                	ld	s3,40(sp)
    800024f0:	7a02                	ld	s4,32(sp)
    800024f2:	6ae2                	ld	s5,24(sp)
    800024f4:	6b42                	ld	s6,16(sp)
    800024f6:	6ba2                	ld	s7,8(sp)
    800024f8:	6161                	addi	sp,sp,80
    800024fa:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800024fc:	85ca                	mv	a1,s2
    800024fe:	854a                	mv	a0,s2
    80002500:	00000097          	auipc	ra,0x0
    80002504:	e8a080e7          	jalr	-374(ra) # 8000238a <sleep>
    havekids = 0;
    80002508:	bf25                	j	80002440 <wait+0x38>

000000008000250a <wakeup>:
{
    8000250a:	7139                	addi	sp,sp,-64
    8000250c:	fc06                	sd	ra,56(sp)
    8000250e:	f822                	sd	s0,48(sp)
    80002510:	f426                	sd	s1,40(sp)
    80002512:	f04a                	sd	s2,32(sp)
    80002514:	ec4e                	sd	s3,24(sp)
    80002516:	e852                	sd	s4,16(sp)
    80002518:	e456                	sd	s5,8(sp)
    8000251a:	0080                	addi	s0,sp,64
    8000251c:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000251e:	0000f497          	auipc	s1,0xf
    80002522:	19a48493          	addi	s1,s1,410 # 800116b8 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002526:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002528:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000252a:	00021917          	auipc	s2,0x21
    8000252e:	b8e90913          	addi	s2,s2,-1138 # 800230b8 <tickslock>
    80002532:	a811                	j	80002546 <wakeup+0x3c>
    release(&p->lock);
    80002534:	8526                	mv	a0,s1
    80002536:	ffffe097          	auipc	ra,0xffffe
    8000253a:	74e080e7          	jalr	1870(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000253e:	46848493          	addi	s1,s1,1128
    80002542:	03248063          	beq	s1,s2,80002562 <wakeup+0x58>
    acquire(&p->lock);
    80002546:	8526                	mv	a0,s1
    80002548:	ffffe097          	auipc	ra,0xffffe
    8000254c:	688080e7          	jalr	1672(ra) # 80000bd0 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002550:	4c9c                	lw	a5,24(s1)
    80002552:	ff3791e3          	bne	a5,s3,80002534 <wakeup+0x2a>
    80002556:	749c                	ld	a5,40(s1)
    80002558:	fd479ee3          	bne	a5,s4,80002534 <wakeup+0x2a>
      p->state = RUNNABLE;
    8000255c:	0154ac23          	sw	s5,24(s1)
    80002560:	bfd1                	j	80002534 <wakeup+0x2a>
}
    80002562:	70e2                	ld	ra,56(sp)
    80002564:	7442                	ld	s0,48(sp)
    80002566:	74a2                	ld	s1,40(sp)
    80002568:	7902                	ld	s2,32(sp)
    8000256a:	69e2                	ld	s3,24(sp)
    8000256c:	6a42                	ld	s4,16(sp)
    8000256e:	6aa2                	ld	s5,8(sp)
    80002570:	6121                	addi	sp,sp,64
    80002572:	8082                	ret

0000000080002574 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002574:	7179                	addi	sp,sp,-48
    80002576:	f406                	sd	ra,40(sp)
    80002578:	f022                	sd	s0,32(sp)
    8000257a:	ec26                	sd	s1,24(sp)
    8000257c:	e84a                	sd	s2,16(sp)
    8000257e:	e44e                	sd	s3,8(sp)
    80002580:	1800                	addi	s0,sp,48
    80002582:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002584:	0000f497          	auipc	s1,0xf
    80002588:	13448493          	addi	s1,s1,308 # 800116b8 <proc>
    8000258c:	00021997          	auipc	s3,0x21
    80002590:	b2c98993          	addi	s3,s3,-1236 # 800230b8 <tickslock>
    acquire(&p->lock);
    80002594:	8526                	mv	a0,s1
    80002596:	ffffe097          	auipc	ra,0xffffe
    8000259a:	63a080e7          	jalr	1594(ra) # 80000bd0 <acquire>
    if(p->pid == pid){
    8000259e:	5c9c                	lw	a5,56(s1)
    800025a0:	01278d63          	beq	a5,s2,800025ba <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800025a4:	8526                	mv	a0,s1
    800025a6:	ffffe097          	auipc	ra,0xffffe
    800025aa:	6de080e7          	jalr	1758(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800025ae:	46848493          	addi	s1,s1,1128
    800025b2:	ff3491e3          	bne	s1,s3,80002594 <kill+0x20>
  }
  return -1;
    800025b6:	557d                	li	a0,-1
    800025b8:	a821                	j	800025d0 <kill+0x5c>
      p->killed = 1;
    800025ba:	4785                	li	a5,1
    800025bc:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800025be:	4c98                	lw	a4,24(s1)
    800025c0:	00f70f63          	beq	a4,a5,800025de <kill+0x6a>
      release(&p->lock);
    800025c4:	8526                	mv	a0,s1
    800025c6:	ffffe097          	auipc	ra,0xffffe
    800025ca:	6be080e7          	jalr	1726(ra) # 80000c84 <release>
      return 0;
    800025ce:	4501                	li	a0,0
}
    800025d0:	70a2                	ld	ra,40(sp)
    800025d2:	7402                	ld	s0,32(sp)
    800025d4:	64e2                	ld	s1,24(sp)
    800025d6:	6942                	ld	s2,16(sp)
    800025d8:	69a2                	ld	s3,8(sp)
    800025da:	6145                	addi	sp,sp,48
    800025dc:	8082                	ret
        p->state = RUNNABLE;
    800025de:	4789                	li	a5,2
    800025e0:	cc9c                	sw	a5,24(s1)
    800025e2:	b7cd                	j	800025c4 <kill+0x50>

00000000800025e4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800025e4:	7179                	addi	sp,sp,-48
    800025e6:	f406                	sd	ra,40(sp)
    800025e8:	f022                	sd	s0,32(sp)
    800025ea:	ec26                	sd	s1,24(sp)
    800025ec:	e84a                	sd	s2,16(sp)
    800025ee:	e44e                	sd	s3,8(sp)
    800025f0:	e052                	sd	s4,0(sp)
    800025f2:	1800                	addi	s0,sp,48
    800025f4:	84aa                	mv	s1,a0
    800025f6:	892e                	mv	s2,a1
    800025f8:	89b2                	mv	s3,a2
    800025fa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025fc:	fffff097          	auipc	ra,0xfffff
    80002600:	4e0080e7          	jalr	1248(ra) # 80001adc <myproc>
  if(user_dst){
    80002604:	c08d                	beqz	s1,80002626 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002606:	86d2                	mv	a3,s4
    80002608:	864e                	mv	a2,s3
    8000260a:	85ca                	mv	a1,s2
    8000260c:	6928                	ld	a0,80(a0)
    8000260e:	fffff097          	auipc	ra,0xfffff
    80002612:	042080e7          	jalr	66(ra) # 80001650 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002616:	70a2                	ld	ra,40(sp)
    80002618:	7402                	ld	s0,32(sp)
    8000261a:	64e2                	ld	s1,24(sp)
    8000261c:	6942                	ld	s2,16(sp)
    8000261e:	69a2                	ld	s3,8(sp)
    80002620:	6a02                	ld	s4,0(sp)
    80002622:	6145                	addi	sp,sp,48
    80002624:	8082                	ret
    memmove((char *)dst, src, len);
    80002626:	000a061b          	sext.w	a2,s4
    8000262a:	85ce                	mv	a1,s3
    8000262c:	854a                	mv	a0,s2
    8000262e:	ffffe097          	auipc	ra,0xffffe
    80002632:	6fa080e7          	jalr	1786(ra) # 80000d28 <memmove>
    return 0;
    80002636:	8526                	mv	a0,s1
    80002638:	bff9                	j	80002616 <either_copyout+0x32>

000000008000263a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000263a:	7179                	addi	sp,sp,-48
    8000263c:	f406                	sd	ra,40(sp)
    8000263e:	f022                	sd	s0,32(sp)
    80002640:	ec26                	sd	s1,24(sp)
    80002642:	e84a                	sd	s2,16(sp)
    80002644:	e44e                	sd	s3,8(sp)
    80002646:	e052                	sd	s4,0(sp)
    80002648:	1800                	addi	s0,sp,48
    8000264a:	892a                	mv	s2,a0
    8000264c:	84ae                	mv	s1,a1
    8000264e:	89b2                	mv	s3,a2
    80002650:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002652:	fffff097          	auipc	ra,0xfffff
    80002656:	48a080e7          	jalr	1162(ra) # 80001adc <myproc>
  if(user_src){
    8000265a:	c08d                	beqz	s1,8000267c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000265c:	86d2                	mv	a3,s4
    8000265e:	864e                	mv	a2,s3
    80002660:	85ca                	mv	a1,s2
    80002662:	6928                	ld	a0,80(a0)
    80002664:	fffff097          	auipc	ra,0xfffff
    80002668:	078080e7          	jalr	120(ra) # 800016dc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000266c:	70a2                	ld	ra,40(sp)
    8000266e:	7402                	ld	s0,32(sp)
    80002670:	64e2                	ld	s1,24(sp)
    80002672:	6942                	ld	s2,16(sp)
    80002674:	69a2                	ld	s3,8(sp)
    80002676:	6a02                	ld	s4,0(sp)
    80002678:	6145                	addi	sp,sp,48
    8000267a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000267c:	000a061b          	sext.w	a2,s4
    80002680:	85ce                	mv	a1,s3
    80002682:	854a                	mv	a0,s2
    80002684:	ffffe097          	auipc	ra,0xffffe
    80002688:	6a4080e7          	jalr	1700(ra) # 80000d28 <memmove>
    return 0;
    8000268c:	8526                	mv	a0,s1
    8000268e:	bff9                	j	8000266c <either_copyin+0x32>

0000000080002690 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002690:	715d                	addi	sp,sp,-80
    80002692:	e486                	sd	ra,72(sp)
    80002694:	e0a2                	sd	s0,64(sp)
    80002696:	fc26                	sd	s1,56(sp)
    80002698:	f84a                	sd	s2,48(sp)
    8000269a:	f44e                	sd	s3,40(sp)
    8000269c:	f052                	sd	s4,32(sp)
    8000269e:	ec56                	sd	s5,24(sp)
    800026a0:	e85a                	sd	s6,16(sp)
    800026a2:	e45e                	sd	s7,8(sp)
    800026a4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800026a6:	00006517          	auipc	a0,0x6
    800026aa:	a2250513          	addi	a0,a0,-1502 # 800080c8 <digits+0x88>
    800026ae:	ffffe097          	auipc	ra,0xffffe
    800026b2:	ed6080e7          	jalr	-298(ra) # 80000584 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026b6:	0000f497          	auipc	s1,0xf
    800026ba:	15a48493          	addi	s1,s1,346 # 80011810 <proc+0x158>
    800026be:	00021917          	auipc	s2,0x21
    800026c2:	b5290913          	addi	s2,s2,-1198 # 80023210 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026c6:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800026c8:	00006997          	auipc	s3,0x6
    800026cc:	bc898993          	addi	s3,s3,-1080 # 80008290 <digits+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    800026d0:	00006a97          	auipc	s5,0x6
    800026d4:	bc8a8a93          	addi	s5,s5,-1080 # 80008298 <digits+0x258>
    printf("\n");
    800026d8:	00006a17          	auipc	s4,0x6
    800026dc:	9f0a0a13          	addi	s4,s4,-1552 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026e0:	00006b97          	auipc	s7,0x6
    800026e4:	bf0b8b93          	addi	s7,s7,-1040 # 800082d0 <states.0>
    800026e8:	a00d                	j	8000270a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800026ea:	ee06a583          	lw	a1,-288(a3)
    800026ee:	8556                	mv	a0,s5
    800026f0:	ffffe097          	auipc	ra,0xffffe
    800026f4:	e94080e7          	jalr	-364(ra) # 80000584 <printf>
    printf("\n");
    800026f8:	8552                	mv	a0,s4
    800026fa:	ffffe097          	auipc	ra,0xffffe
    800026fe:	e8a080e7          	jalr	-374(ra) # 80000584 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002702:	46848493          	addi	s1,s1,1128
    80002706:	03248263          	beq	s1,s2,8000272a <procdump+0x9a>
    if(p->state == UNUSED)
    8000270a:	86a6                	mv	a3,s1
    8000270c:	ec04a783          	lw	a5,-320(s1)
    80002710:	dbed                	beqz	a5,80002702 <procdump+0x72>
      state = "???";
    80002712:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002714:	fcfb6be3          	bltu	s6,a5,800026ea <procdump+0x5a>
    80002718:	02079713          	slli	a4,a5,0x20
    8000271c:	01d75793          	srli	a5,a4,0x1d
    80002720:	97de                	add	a5,a5,s7
    80002722:	6390                	ld	a2,0(a5)
    80002724:	f279                	bnez	a2,800026ea <procdump+0x5a>
      state = "???";
    80002726:	864e                	mv	a2,s3
    80002728:	b7c9                	j	800026ea <procdump+0x5a>
  }
}
    8000272a:	60a6                	ld	ra,72(sp)
    8000272c:	6406                	ld	s0,64(sp)
    8000272e:	74e2                	ld	s1,56(sp)
    80002730:	7942                	ld	s2,48(sp)
    80002732:	79a2                	ld	s3,40(sp)
    80002734:	7a02                	ld	s4,32(sp)
    80002736:	6ae2                	ld	s5,24(sp)
    80002738:	6b42                	ld	s6,16(sp)
    8000273a:	6ba2                	ld	s7,8(sp)
    8000273c:	6161                	addi	sp,sp,80
    8000273e:	8082                	ret

0000000080002740 <swtch>:
    80002740:	00153023          	sd	ra,0(a0)
    80002744:	00253423          	sd	sp,8(a0)
    80002748:	e900                	sd	s0,16(a0)
    8000274a:	ed04                	sd	s1,24(a0)
    8000274c:	03253023          	sd	s2,32(a0)
    80002750:	03353423          	sd	s3,40(a0)
    80002754:	03453823          	sd	s4,48(a0)
    80002758:	03553c23          	sd	s5,56(a0)
    8000275c:	05653023          	sd	s6,64(a0)
    80002760:	05753423          	sd	s7,72(a0)
    80002764:	05853823          	sd	s8,80(a0)
    80002768:	05953c23          	sd	s9,88(a0)
    8000276c:	07a53023          	sd	s10,96(a0)
    80002770:	07b53423          	sd	s11,104(a0)
    80002774:	0005b083          	ld	ra,0(a1)
    80002778:	0085b103          	ld	sp,8(a1)
    8000277c:	6980                	ld	s0,16(a1)
    8000277e:	6d84                	ld	s1,24(a1)
    80002780:	0205b903          	ld	s2,32(a1)
    80002784:	0285b983          	ld	s3,40(a1)
    80002788:	0305ba03          	ld	s4,48(a1)
    8000278c:	0385ba83          	ld	s5,56(a1)
    80002790:	0405bb03          	ld	s6,64(a1)
    80002794:	0485bb83          	ld	s7,72(a1)
    80002798:	0505bc03          	ld	s8,80(a1)
    8000279c:	0585bc83          	ld	s9,88(a1)
    800027a0:	0605bd03          	ld	s10,96(a1)
    800027a4:	0685bd83          	ld	s11,104(a1)
    800027a8:	8082                	ret

00000000800027aa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800027aa:	1141                	addi	sp,sp,-16
    800027ac:	e406                	sd	ra,8(sp)
    800027ae:	e022                	sd	s0,0(sp)
    800027b0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800027b2:	00006597          	auipc	a1,0x6
    800027b6:	b4658593          	addi	a1,a1,-1210 # 800082f8 <states.0+0x28>
    800027ba:	00021517          	auipc	a0,0x21
    800027be:	8fe50513          	addi	a0,a0,-1794 # 800230b8 <tickslock>
    800027c2:	ffffe097          	auipc	ra,0xffffe
    800027c6:	37e080e7          	jalr	894(ra) # 80000b40 <initlock>
}
    800027ca:	60a2                	ld	ra,8(sp)
    800027cc:	6402                	ld	s0,0(sp)
    800027ce:	0141                	addi	sp,sp,16
    800027d0:	8082                	ret

00000000800027d2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800027d2:	1141                	addi	sp,sp,-16
    800027d4:	e422                	sd	s0,8(sp)
    800027d6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027d8:	00004797          	auipc	a5,0x4
    800027dc:	86878793          	addi	a5,a5,-1944 # 80006040 <kernelvec>
    800027e0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027e4:	6422                	ld	s0,8(sp)
    800027e6:	0141                	addi	sp,sp,16
    800027e8:	8082                	ret

00000000800027ea <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800027ea:	1141                	addi	sp,sp,-16
    800027ec:	e406                	sd	ra,8(sp)
    800027ee:	e022                	sd	s0,0(sp)
    800027f0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027f2:	fffff097          	auipc	ra,0xfffff
    800027f6:	2ea080e7          	jalr	746(ra) # 80001adc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027fe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002800:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002804:	00004697          	auipc	a3,0x4
    80002808:	7fc68693          	addi	a3,a3,2044 # 80007000 <_trampoline>
    8000280c:	00004717          	auipc	a4,0x4
    80002810:	7f470713          	addi	a4,a4,2036 # 80007000 <_trampoline>
    80002814:	8f15                	sub	a4,a4,a3
    80002816:	040007b7          	lui	a5,0x4000
    8000281a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000281c:	07b2                	slli	a5,a5,0xc
    8000281e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002820:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002824:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002826:	18002673          	csrr	a2,satp
    8000282a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000282c:	6d30                	ld	a2,88(a0)
    8000282e:	6138                	ld	a4,64(a0)
    80002830:	6585                	lui	a1,0x1
    80002832:	972e                	add	a4,a4,a1
    80002834:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002836:	6d38                	ld	a4,88(a0)
    80002838:	00000617          	auipc	a2,0x0
    8000283c:	13860613          	addi	a2,a2,312 # 80002970 <usertrap>
    80002840:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002842:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002844:	8612                	mv	a2,tp
    80002846:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002848:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000284c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002850:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002854:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002858:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000285a:	6f18                	ld	a4,24(a4)
    8000285c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002860:	692c                	ld	a1,80(a0)
    80002862:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002864:	00005717          	auipc	a4,0x5
    80002868:	82c70713          	addi	a4,a4,-2004 # 80007090 <userret>
    8000286c:	8f15                	sub	a4,a4,a3
    8000286e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002870:	577d                	li	a4,-1
    80002872:	177e                	slli	a4,a4,0x3f
    80002874:	8dd9                	or	a1,a1,a4
    80002876:	02000537          	lui	a0,0x2000
    8000287a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000287c:	0536                	slli	a0,a0,0xd
    8000287e:	9782                	jalr	a5
}
    80002880:	60a2                	ld	ra,8(sp)
    80002882:	6402                	ld	s0,0(sp)
    80002884:	0141                	addi	sp,sp,16
    80002886:	8082                	ret

0000000080002888 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002888:	1101                	addi	sp,sp,-32
    8000288a:	ec06                	sd	ra,24(sp)
    8000288c:	e822                	sd	s0,16(sp)
    8000288e:	e426                	sd	s1,8(sp)
    80002890:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002892:	00021497          	auipc	s1,0x21
    80002896:	82648493          	addi	s1,s1,-2010 # 800230b8 <tickslock>
    8000289a:	8526                	mv	a0,s1
    8000289c:	ffffe097          	auipc	ra,0xffffe
    800028a0:	334080e7          	jalr	820(ra) # 80000bd0 <acquire>
  ticks++;
    800028a4:	00006517          	auipc	a0,0x6
    800028a8:	78c50513          	addi	a0,a0,1932 # 80009030 <ticks>
    800028ac:	411c                	lw	a5,0(a0)
    800028ae:	2785                	addiw	a5,a5,1
    800028b0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	c58080e7          	jalr	-936(ra) # 8000250a <wakeup>
  release(&tickslock);
    800028ba:	8526                	mv	a0,s1
    800028bc:	ffffe097          	auipc	ra,0xffffe
    800028c0:	3c8080e7          	jalr	968(ra) # 80000c84 <release>
}
    800028c4:	60e2                	ld	ra,24(sp)
    800028c6:	6442                	ld	s0,16(sp)
    800028c8:	64a2                	ld	s1,8(sp)
    800028ca:	6105                	addi	sp,sp,32
    800028cc:	8082                	ret

00000000800028ce <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800028ce:	1101                	addi	sp,sp,-32
    800028d0:	ec06                	sd	ra,24(sp)
    800028d2:	e822                	sd	s0,16(sp)
    800028d4:	e426                	sd	s1,8(sp)
    800028d6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028d8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800028dc:	00074d63          	bltz	a4,800028f6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800028e0:	57fd                	li	a5,-1
    800028e2:	17fe                	slli	a5,a5,0x3f
    800028e4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800028e6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800028e8:	06f70363          	beq	a4,a5,8000294e <devintr+0x80>
  }
}
    800028ec:	60e2                	ld	ra,24(sp)
    800028ee:	6442                	ld	s0,16(sp)
    800028f0:	64a2                	ld	s1,8(sp)
    800028f2:	6105                	addi	sp,sp,32
    800028f4:	8082                	ret
     (scause & 0xff) == 9){
    800028f6:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    800028fa:	46a5                	li	a3,9
    800028fc:	fed792e3          	bne	a5,a3,800028e0 <devintr+0x12>
    int irq = plic_claim();
    80002900:	00004097          	auipc	ra,0x4
    80002904:	864080e7          	jalr	-1948(ra) # 80006164 <plic_claim>
    80002908:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000290a:	47a9                	li	a5,10
    8000290c:	02f50763          	beq	a0,a5,8000293a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002910:	4785                	li	a5,1
    80002912:	02f50963          	beq	a0,a5,80002944 <devintr+0x76>
    return 1;
    80002916:	4505                	li	a0,1
    } else if(irq){
    80002918:	d8f1                	beqz	s1,800028ec <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000291a:	85a6                	mv	a1,s1
    8000291c:	00006517          	auipc	a0,0x6
    80002920:	9e450513          	addi	a0,a0,-1564 # 80008300 <states.0+0x30>
    80002924:	ffffe097          	auipc	ra,0xffffe
    80002928:	c60080e7          	jalr	-928(ra) # 80000584 <printf>
      plic_complete(irq);
    8000292c:	8526                	mv	a0,s1
    8000292e:	00004097          	auipc	ra,0x4
    80002932:	85a080e7          	jalr	-1958(ra) # 80006188 <plic_complete>
    return 1;
    80002936:	4505                	li	a0,1
    80002938:	bf55                	j	800028ec <devintr+0x1e>
      uartintr();
    8000293a:	ffffe097          	auipc	ra,0xffffe
    8000293e:	058080e7          	jalr	88(ra) # 80000992 <uartintr>
    80002942:	b7ed                	j	8000292c <devintr+0x5e>
      virtio_disk_intr();
    80002944:	00004097          	auipc	ra,0x4
    80002948:	cd0080e7          	jalr	-816(ra) # 80006614 <virtio_disk_intr>
    8000294c:	b7c5                	j	8000292c <devintr+0x5e>
    if(cpuid() == 0){
    8000294e:	fffff097          	auipc	ra,0xfffff
    80002952:	162080e7          	jalr	354(ra) # 80001ab0 <cpuid>
    80002956:	c901                	beqz	a0,80002966 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002958:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000295c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000295e:	14479073          	csrw	sip,a5
    return 2;
    80002962:	4509                	li	a0,2
    80002964:	b761                	j	800028ec <devintr+0x1e>
      clockintr();
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	f22080e7          	jalr	-222(ra) # 80002888 <clockintr>
    8000296e:	b7ed                	j	80002958 <devintr+0x8a>

0000000080002970 <usertrap>:
{
    80002970:	1101                	addi	sp,sp,-32
    80002972:	ec06                	sd	ra,24(sp)
    80002974:	e822                	sd	s0,16(sp)
    80002976:	e426                	sd	s1,8(sp)
    80002978:	e04a                	sd	s2,0(sp)
    8000297a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000297c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002980:	1007f793          	andi	a5,a5,256
    80002984:	e3ad                	bnez	a5,800029e6 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002986:	00003797          	auipc	a5,0x3
    8000298a:	6ba78793          	addi	a5,a5,1722 # 80006040 <kernelvec>
    8000298e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002992:	fffff097          	auipc	ra,0xfffff
    80002996:	14a080e7          	jalr	330(ra) # 80001adc <myproc>
    8000299a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000299c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000299e:	14102773          	csrr	a4,sepc
    800029a2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029a4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800029a8:	47a1                	li	a5,8
    800029aa:	04f71c63          	bne	a4,a5,80002a02 <usertrap+0x92>
    if(p->killed)
    800029ae:	591c                	lw	a5,48(a0)
    800029b0:	e3b9                	bnez	a5,800029f6 <usertrap+0x86>
    p->trapframe->epc += 4;
    800029b2:	6cb8                	ld	a4,88(s1)
    800029b4:	6f1c                	ld	a5,24(a4)
    800029b6:	0791                	addi	a5,a5,4
    800029b8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029be:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029c2:	10079073          	csrw	sstatus,a5
    syscall();
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	304080e7          	jalr	772(ra) # 80002cca <syscall>
  if(p->killed)
    800029ce:	589c                	lw	a5,48(s1)
    800029d0:	ebd5                	bnez	a5,80002a84 <usertrap+0x114>
  usertrapret();
    800029d2:	00000097          	auipc	ra,0x0
    800029d6:	e18080e7          	jalr	-488(ra) # 800027ea <usertrapret>
}
    800029da:	60e2                	ld	ra,24(sp)
    800029dc:	6442                	ld	s0,16(sp)
    800029de:	64a2                	ld	s1,8(sp)
    800029e0:	6902                	ld	s2,0(sp)
    800029e2:	6105                	addi	sp,sp,32
    800029e4:	8082                	ret
    panic("usertrap: not from user mode");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	93a50513          	addi	a0,a0,-1734 # 80008320 <states.0+0x50>
    800029ee:	ffffe097          	auipc	ra,0xffffe
    800029f2:	b4c080e7          	jalr	-1204(ra) # 8000053a <panic>
      exit(-1);
    800029f6:	557d                	li	a0,-1
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	84c080e7          	jalr	-1972(ra) # 80002244 <exit>
    80002a00:	bf4d                	j	800029b2 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002a02:	00000097          	auipc	ra,0x0
    80002a06:	ecc080e7          	jalr	-308(ra) # 800028ce <devintr>
    80002a0a:	892a                	mv	s2,a0
    80002a0c:	e92d                	bnez	a0,80002a7e <usertrap+0x10e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a0e:	14302573          	csrr	a0,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a12:	14202773          	csrr	a4,scause
    if((r_scause() == 13 || r_scause() == 15)){ // vma lazy allocation
    80002a16:	47b5                	li	a5,13
    80002a18:	04f70d63          	beq	a4,a5,80002a72 <usertrap+0x102>
    80002a1c:	14202773          	csrr	a4,scause
    80002a20:	47bd                	li	a5,15
    80002a22:	04f70863          	beq	a4,a5,80002a72 <usertrap+0x102>
    80002a26:	142025f3          	csrr	a1,scause
      printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002a2a:	5c90                	lw	a2,56(s1)
    80002a2c:	00006517          	auipc	a0,0x6
    80002a30:	91450513          	addi	a0,a0,-1772 # 80008340 <states.0+0x70>
    80002a34:	ffffe097          	auipc	ra,0xffffe
    80002a38:	b50080e7          	jalr	-1200(ra) # 80000584 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a3c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a40:	14302673          	csrr	a2,stval
      printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a44:	00006517          	auipc	a0,0x6
    80002a48:	92c50513          	addi	a0,a0,-1748 # 80008370 <states.0+0xa0>
    80002a4c:	ffffe097          	auipc	ra,0xffffe
    80002a50:	b38080e7          	jalr	-1224(ra) # 80000584 <printf>
      p->killed = 1;
    80002a54:	4785                	li	a5,1
    80002a56:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002a58:	557d                	li	a0,-1
    80002a5a:	fffff097          	auipc	ra,0xfffff
    80002a5e:	7ea080e7          	jalr	2026(ra) # 80002244 <exit>
  if(which_dev == 2)
    80002a62:	4789                	li	a5,2
    80002a64:	f6f917e3          	bne	s2,a5,800029d2 <usertrap+0x62>
    yield();
    80002a68:	00000097          	auipc	ra,0x0
    80002a6c:	8e6080e7          	jalr	-1818(ra) # 8000234e <yield>
    80002a70:	b78d                	j	800029d2 <usertrap+0x62>
      if(!vmatrylazytouch(va)) {
    80002a72:	00003097          	auipc	ra,0x3
    80002a76:	4f0080e7          	jalr	1264(ra) # 80005f62 <vmatrylazytouch>
    80002a7a:	f931                	bnez	a0,800029ce <usertrap+0x5e>
    80002a7c:	b76d                	j	80002a26 <usertrap+0xb6>
  if(p->killed)
    80002a7e:	589c                	lw	a5,48(s1)
    80002a80:	d3ed                	beqz	a5,80002a62 <usertrap+0xf2>
    80002a82:	bfd9                	j	80002a58 <usertrap+0xe8>
    80002a84:	4901                	li	s2,0
    80002a86:	bfc9                	j	80002a58 <usertrap+0xe8>

0000000080002a88 <kerneltrap>:
{
    80002a88:	7179                	addi	sp,sp,-48
    80002a8a:	f406                	sd	ra,40(sp)
    80002a8c:	f022                	sd	s0,32(sp)
    80002a8e:	ec26                	sd	s1,24(sp)
    80002a90:	e84a                	sd	s2,16(sp)
    80002a92:	e44e                	sd	s3,8(sp)
    80002a94:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a96:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a9a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a9e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002aa2:	1004f793          	andi	a5,s1,256
    80002aa6:	cb85                	beqz	a5,80002ad6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002aa8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002aac:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002aae:	ef85                	bnez	a5,80002ae6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002ab0:	00000097          	auipc	ra,0x0
    80002ab4:	e1e080e7          	jalr	-482(ra) # 800028ce <devintr>
    80002ab8:	cd1d                	beqz	a0,80002af6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002aba:	4789                	li	a5,2
    80002abc:	06f50a63          	beq	a0,a5,80002b30 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ac0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ac4:	10049073          	csrw	sstatus,s1
}
    80002ac8:	70a2                	ld	ra,40(sp)
    80002aca:	7402                	ld	s0,32(sp)
    80002acc:	64e2                	ld	s1,24(sp)
    80002ace:	6942                	ld	s2,16(sp)
    80002ad0:	69a2                	ld	s3,8(sp)
    80002ad2:	6145                	addi	sp,sp,48
    80002ad4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002ad6:	00006517          	auipc	a0,0x6
    80002ada:	8ba50513          	addi	a0,a0,-1862 # 80008390 <states.0+0xc0>
    80002ade:	ffffe097          	auipc	ra,0xffffe
    80002ae2:	a5c080e7          	jalr	-1444(ra) # 8000053a <panic>
    panic("kerneltrap: interrupts enabled");
    80002ae6:	00006517          	auipc	a0,0x6
    80002aea:	8d250513          	addi	a0,a0,-1838 # 800083b8 <states.0+0xe8>
    80002aee:	ffffe097          	auipc	ra,0xffffe
    80002af2:	a4c080e7          	jalr	-1460(ra) # 8000053a <panic>
    printf("scause %p\n", scause);
    80002af6:	85ce                	mv	a1,s3
    80002af8:	00006517          	auipc	a0,0x6
    80002afc:	8e050513          	addi	a0,a0,-1824 # 800083d8 <states.0+0x108>
    80002b00:	ffffe097          	auipc	ra,0xffffe
    80002b04:	a84080e7          	jalr	-1404(ra) # 80000584 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b08:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b0c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002b10:	00006517          	auipc	a0,0x6
    80002b14:	8d850513          	addi	a0,a0,-1832 # 800083e8 <states.0+0x118>
    80002b18:	ffffe097          	auipc	ra,0xffffe
    80002b1c:	a6c080e7          	jalr	-1428(ra) # 80000584 <printf>
    panic("kerneltrap");
    80002b20:	00006517          	auipc	a0,0x6
    80002b24:	8e050513          	addi	a0,a0,-1824 # 80008400 <states.0+0x130>
    80002b28:	ffffe097          	auipc	ra,0xffffe
    80002b2c:	a12080e7          	jalr	-1518(ra) # 8000053a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002b30:	fffff097          	auipc	ra,0xfffff
    80002b34:	fac080e7          	jalr	-84(ra) # 80001adc <myproc>
    80002b38:	d541                	beqz	a0,80002ac0 <kerneltrap+0x38>
    80002b3a:	fffff097          	auipc	ra,0xfffff
    80002b3e:	fa2080e7          	jalr	-94(ra) # 80001adc <myproc>
    80002b42:	4d18                	lw	a4,24(a0)
    80002b44:	478d                	li	a5,3
    80002b46:	f6f71de3          	bne	a4,a5,80002ac0 <kerneltrap+0x38>
    yield();
    80002b4a:	00000097          	auipc	ra,0x0
    80002b4e:	804080e7          	jalr	-2044(ra) # 8000234e <yield>
    80002b52:	b7bd                	j	80002ac0 <kerneltrap+0x38>

0000000080002b54 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b54:	1101                	addi	sp,sp,-32
    80002b56:	ec06                	sd	ra,24(sp)
    80002b58:	e822                	sd	s0,16(sp)
    80002b5a:	e426                	sd	s1,8(sp)
    80002b5c:	1000                	addi	s0,sp,32
    80002b5e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b60:	fffff097          	auipc	ra,0xfffff
    80002b64:	f7c080e7          	jalr	-132(ra) # 80001adc <myproc>
  switch (n) {
    80002b68:	4795                	li	a5,5
    80002b6a:	0497e163          	bltu	a5,s1,80002bac <argraw+0x58>
    80002b6e:	048a                	slli	s1,s1,0x2
    80002b70:	00006717          	auipc	a4,0x6
    80002b74:	8c870713          	addi	a4,a4,-1848 # 80008438 <states.0+0x168>
    80002b78:	94ba                	add	s1,s1,a4
    80002b7a:	409c                	lw	a5,0(s1)
    80002b7c:	97ba                	add	a5,a5,a4
    80002b7e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b80:	6d3c                	ld	a5,88(a0)
    80002b82:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b84:	60e2                	ld	ra,24(sp)
    80002b86:	6442                	ld	s0,16(sp)
    80002b88:	64a2                	ld	s1,8(sp)
    80002b8a:	6105                	addi	sp,sp,32
    80002b8c:	8082                	ret
    return p->trapframe->a1;
    80002b8e:	6d3c                	ld	a5,88(a0)
    80002b90:	7fa8                	ld	a0,120(a5)
    80002b92:	bfcd                	j	80002b84 <argraw+0x30>
    return p->trapframe->a2;
    80002b94:	6d3c                	ld	a5,88(a0)
    80002b96:	63c8                	ld	a0,128(a5)
    80002b98:	b7f5                	j	80002b84 <argraw+0x30>
    return p->trapframe->a3;
    80002b9a:	6d3c                	ld	a5,88(a0)
    80002b9c:	67c8                	ld	a0,136(a5)
    80002b9e:	b7dd                	j	80002b84 <argraw+0x30>
    return p->trapframe->a4;
    80002ba0:	6d3c                	ld	a5,88(a0)
    80002ba2:	6bc8                	ld	a0,144(a5)
    80002ba4:	b7c5                	j	80002b84 <argraw+0x30>
    return p->trapframe->a5;
    80002ba6:	6d3c                	ld	a5,88(a0)
    80002ba8:	6fc8                	ld	a0,152(a5)
    80002baa:	bfe9                	j	80002b84 <argraw+0x30>
  panic("argraw");
    80002bac:	00006517          	auipc	a0,0x6
    80002bb0:	86450513          	addi	a0,a0,-1948 # 80008410 <states.0+0x140>
    80002bb4:	ffffe097          	auipc	ra,0xffffe
    80002bb8:	986080e7          	jalr	-1658(ra) # 8000053a <panic>

0000000080002bbc <fetchaddr>:
{
    80002bbc:	1101                	addi	sp,sp,-32
    80002bbe:	ec06                	sd	ra,24(sp)
    80002bc0:	e822                	sd	s0,16(sp)
    80002bc2:	e426                	sd	s1,8(sp)
    80002bc4:	e04a                	sd	s2,0(sp)
    80002bc6:	1000                	addi	s0,sp,32
    80002bc8:	84aa                	mv	s1,a0
    80002bca:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002bcc:	fffff097          	auipc	ra,0xfffff
    80002bd0:	f10080e7          	jalr	-240(ra) # 80001adc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002bd4:	653c                	ld	a5,72(a0)
    80002bd6:	02f4f863          	bgeu	s1,a5,80002c06 <fetchaddr+0x4a>
    80002bda:	00848713          	addi	a4,s1,8
    80002bde:	02e7e663          	bltu	a5,a4,80002c0a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002be2:	46a1                	li	a3,8
    80002be4:	8626                	mv	a2,s1
    80002be6:	85ca                	mv	a1,s2
    80002be8:	6928                	ld	a0,80(a0)
    80002bea:	fffff097          	auipc	ra,0xfffff
    80002bee:	af2080e7          	jalr	-1294(ra) # 800016dc <copyin>
    80002bf2:	00a03533          	snez	a0,a0
    80002bf6:	40a00533          	neg	a0,a0
}
    80002bfa:	60e2                	ld	ra,24(sp)
    80002bfc:	6442                	ld	s0,16(sp)
    80002bfe:	64a2                	ld	s1,8(sp)
    80002c00:	6902                	ld	s2,0(sp)
    80002c02:	6105                	addi	sp,sp,32
    80002c04:	8082                	ret
    return -1;
    80002c06:	557d                	li	a0,-1
    80002c08:	bfcd                	j	80002bfa <fetchaddr+0x3e>
    80002c0a:	557d                	li	a0,-1
    80002c0c:	b7fd                	j	80002bfa <fetchaddr+0x3e>

0000000080002c0e <fetchstr>:
{
    80002c0e:	7179                	addi	sp,sp,-48
    80002c10:	f406                	sd	ra,40(sp)
    80002c12:	f022                	sd	s0,32(sp)
    80002c14:	ec26                	sd	s1,24(sp)
    80002c16:	e84a                	sd	s2,16(sp)
    80002c18:	e44e                	sd	s3,8(sp)
    80002c1a:	1800                	addi	s0,sp,48
    80002c1c:	892a                	mv	s2,a0
    80002c1e:	84ae                	mv	s1,a1
    80002c20:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002c22:	fffff097          	auipc	ra,0xfffff
    80002c26:	eba080e7          	jalr	-326(ra) # 80001adc <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002c2a:	86ce                	mv	a3,s3
    80002c2c:	864a                	mv	a2,s2
    80002c2e:	85a6                	mv	a1,s1
    80002c30:	6928                	ld	a0,80(a0)
    80002c32:	fffff097          	auipc	ra,0xfffff
    80002c36:	b38080e7          	jalr	-1224(ra) # 8000176a <copyinstr>
  if(err < 0)
    80002c3a:	00054763          	bltz	a0,80002c48 <fetchstr+0x3a>
  return strlen(buf);
    80002c3e:	8526                	mv	a0,s1
    80002c40:	ffffe097          	auipc	ra,0xffffe
    80002c44:	210080e7          	jalr	528(ra) # 80000e50 <strlen>
}
    80002c48:	70a2                	ld	ra,40(sp)
    80002c4a:	7402                	ld	s0,32(sp)
    80002c4c:	64e2                	ld	s1,24(sp)
    80002c4e:	6942                	ld	s2,16(sp)
    80002c50:	69a2                	ld	s3,8(sp)
    80002c52:	6145                	addi	sp,sp,48
    80002c54:	8082                	ret

0000000080002c56 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002c56:	1101                	addi	sp,sp,-32
    80002c58:	ec06                	sd	ra,24(sp)
    80002c5a:	e822                	sd	s0,16(sp)
    80002c5c:	e426                	sd	s1,8(sp)
    80002c5e:	1000                	addi	s0,sp,32
    80002c60:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	ef2080e7          	jalr	-270(ra) # 80002b54 <argraw>
    80002c6a:	c088                	sw	a0,0(s1)
  return 0;
}
    80002c6c:	4501                	li	a0,0
    80002c6e:	60e2                	ld	ra,24(sp)
    80002c70:	6442                	ld	s0,16(sp)
    80002c72:	64a2                	ld	s1,8(sp)
    80002c74:	6105                	addi	sp,sp,32
    80002c76:	8082                	ret

0000000080002c78 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002c78:	1101                	addi	sp,sp,-32
    80002c7a:	ec06                	sd	ra,24(sp)
    80002c7c:	e822                	sd	s0,16(sp)
    80002c7e:	e426                	sd	s1,8(sp)
    80002c80:	1000                	addi	s0,sp,32
    80002c82:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	ed0080e7          	jalr	-304(ra) # 80002b54 <argraw>
    80002c8c:	e088                	sd	a0,0(s1)
  return 0;
}
    80002c8e:	4501                	li	a0,0
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6105                	addi	sp,sp,32
    80002c98:	8082                	ret

0000000080002c9a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c9a:	1101                	addi	sp,sp,-32
    80002c9c:	ec06                	sd	ra,24(sp)
    80002c9e:	e822                	sd	s0,16(sp)
    80002ca0:	e426                	sd	s1,8(sp)
    80002ca2:	e04a                	sd	s2,0(sp)
    80002ca4:	1000                	addi	s0,sp,32
    80002ca6:	84ae                	mv	s1,a1
    80002ca8:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002caa:	00000097          	auipc	ra,0x0
    80002cae:	eaa080e7          	jalr	-342(ra) # 80002b54 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002cb2:	864a                	mv	a2,s2
    80002cb4:	85a6                	mv	a1,s1
    80002cb6:	00000097          	auipc	ra,0x0
    80002cba:	f58080e7          	jalr	-168(ra) # 80002c0e <fetchstr>
}
    80002cbe:	60e2                	ld	ra,24(sp)
    80002cc0:	6442                	ld	s0,16(sp)
    80002cc2:	64a2                	ld	s1,8(sp)
    80002cc4:	6902                	ld	s2,0(sp)
    80002cc6:	6105                	addi	sp,sp,32
    80002cc8:	8082                	ret

0000000080002cca <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80002cca:	1101                	addi	sp,sp,-32
    80002ccc:	ec06                	sd	ra,24(sp)
    80002cce:	e822                	sd	s0,16(sp)
    80002cd0:	e426                	sd	s1,8(sp)
    80002cd2:	e04a                	sd	s2,0(sp)
    80002cd4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002cd6:	fffff097          	auipc	ra,0xfffff
    80002cda:	e06080e7          	jalr	-506(ra) # 80001adc <myproc>
    80002cde:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ce0:	05853903          	ld	s2,88(a0)
    80002ce4:	0a893783          	ld	a5,168(s2)
    80002ce8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cec:	37fd                	addiw	a5,a5,-1
    80002cee:	4759                	li	a4,22
    80002cf0:	00f76f63          	bltu	a4,a5,80002d0e <syscall+0x44>
    80002cf4:	00369713          	slli	a4,a3,0x3
    80002cf8:	00005797          	auipc	a5,0x5
    80002cfc:	75878793          	addi	a5,a5,1880 # 80008450 <syscalls>
    80002d00:	97ba                	add	a5,a5,a4
    80002d02:	639c                	ld	a5,0(a5)
    80002d04:	c789                	beqz	a5,80002d0e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002d06:	9782                	jalr	a5
    80002d08:	06a93823          	sd	a0,112(s2)
    80002d0c:	a839                	j	80002d2a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002d0e:	15848613          	addi	a2,s1,344
    80002d12:	5c8c                	lw	a1,56(s1)
    80002d14:	00005517          	auipc	a0,0x5
    80002d18:	70450513          	addi	a0,a0,1796 # 80008418 <states.0+0x148>
    80002d1c:	ffffe097          	auipc	ra,0xffffe
    80002d20:	868080e7          	jalr	-1944(ra) # 80000584 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d24:	6cbc                	ld	a5,88(s1)
    80002d26:	577d                	li	a4,-1
    80002d28:	fbb8                	sd	a4,112(a5)
  }
}
    80002d2a:	60e2                	ld	ra,24(sp)
    80002d2c:	6442                	ld	s0,16(sp)
    80002d2e:	64a2                	ld	s1,8(sp)
    80002d30:	6902                	ld	s2,0(sp)
    80002d32:	6105                	addi	sp,sp,32
    80002d34:	8082                	ret

0000000080002d36 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d36:	1101                	addi	sp,sp,-32
    80002d38:	ec06                	sd	ra,24(sp)
    80002d3a:	e822                	sd	s0,16(sp)
    80002d3c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002d3e:	fec40593          	addi	a1,s0,-20
    80002d42:	4501                	li	a0,0
    80002d44:	00000097          	auipc	ra,0x0
    80002d48:	f12080e7          	jalr	-238(ra) # 80002c56 <argint>
    return -1;
    80002d4c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d4e:	00054963          	bltz	a0,80002d60 <sys_exit+0x2a>
  exit(n);
    80002d52:	fec42503          	lw	a0,-20(s0)
    80002d56:	fffff097          	auipc	ra,0xfffff
    80002d5a:	4ee080e7          	jalr	1262(ra) # 80002244 <exit>
  return 0;  // not reached
    80002d5e:	4781                	li	a5,0
}
    80002d60:	853e                	mv	a0,a5
    80002d62:	60e2                	ld	ra,24(sp)
    80002d64:	6442                	ld	s0,16(sp)
    80002d66:	6105                	addi	sp,sp,32
    80002d68:	8082                	ret

0000000080002d6a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d6a:	1141                	addi	sp,sp,-16
    80002d6c:	e406                	sd	ra,8(sp)
    80002d6e:	e022                	sd	s0,0(sp)
    80002d70:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d72:	fffff097          	auipc	ra,0xfffff
    80002d76:	d6a080e7          	jalr	-662(ra) # 80001adc <myproc>
}
    80002d7a:	5d08                	lw	a0,56(a0)
    80002d7c:	60a2                	ld	ra,8(sp)
    80002d7e:	6402                	ld	s0,0(sp)
    80002d80:	0141                	addi	sp,sp,16
    80002d82:	8082                	ret

0000000080002d84 <sys_fork>:

uint64
sys_fork(void)
{
    80002d84:	1141                	addi	sp,sp,-16
    80002d86:	e406                	sd	ra,8(sp)
    80002d88:	e022                	sd	s0,0(sp)
    80002d8a:	0800                	addi	s0,sp,16
  return fork();
    80002d8c:	fffff097          	auipc	ra,0xfffff
    80002d90:	15a080e7          	jalr	346(ra) # 80001ee6 <fork>
}
    80002d94:	60a2                	ld	ra,8(sp)
    80002d96:	6402                	ld	s0,0(sp)
    80002d98:	0141                	addi	sp,sp,16
    80002d9a:	8082                	ret

0000000080002d9c <sys_wait>:

uint64
sys_wait(void)
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002da4:	fe840593          	addi	a1,s0,-24
    80002da8:	4501                	li	a0,0
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	ece080e7          	jalr	-306(ra) # 80002c78 <argaddr>
    80002db2:	87aa                	mv	a5,a0
    return -1;
    80002db4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002db6:	0007c863          	bltz	a5,80002dc6 <sys_wait+0x2a>
  return wait(p);
    80002dba:	fe843503          	ld	a0,-24(s0)
    80002dbe:	fffff097          	auipc	ra,0xfffff
    80002dc2:	64a080e7          	jalr	1610(ra) # 80002408 <wait>
}
    80002dc6:	60e2                	ld	ra,24(sp)
    80002dc8:	6442                	ld	s0,16(sp)
    80002dca:	6105                	addi	sp,sp,32
    80002dcc:	8082                	ret

0000000080002dce <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002dce:	7179                	addi	sp,sp,-48
    80002dd0:	f406                	sd	ra,40(sp)
    80002dd2:	f022                	sd	s0,32(sp)
    80002dd4:	ec26                	sd	s1,24(sp)
    80002dd6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002dd8:	fdc40593          	addi	a1,s0,-36
    80002ddc:	4501                	li	a0,0
    80002dde:	00000097          	auipc	ra,0x0
    80002de2:	e78080e7          	jalr	-392(ra) # 80002c56 <argint>
    80002de6:	87aa                	mv	a5,a0
    return -1;
    80002de8:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002dea:	0207c063          	bltz	a5,80002e0a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002dee:	fffff097          	auipc	ra,0xfffff
    80002df2:	cee080e7          	jalr	-786(ra) # 80001adc <myproc>
    80002df6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002df8:	fdc42503          	lw	a0,-36(s0)
    80002dfc:	fffff097          	auipc	ra,0xfffff
    80002e00:	072080e7          	jalr	114(ra) # 80001e6e <growproc>
    80002e04:	00054863          	bltz	a0,80002e14 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002e08:	8526                	mv	a0,s1
}
    80002e0a:	70a2                	ld	ra,40(sp)
    80002e0c:	7402                	ld	s0,32(sp)
    80002e0e:	64e2                	ld	s1,24(sp)
    80002e10:	6145                	addi	sp,sp,48
    80002e12:	8082                	ret
    return -1;
    80002e14:	557d                	li	a0,-1
    80002e16:	bfd5                	j	80002e0a <sys_sbrk+0x3c>

0000000080002e18 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002e18:	7139                	addi	sp,sp,-64
    80002e1a:	fc06                	sd	ra,56(sp)
    80002e1c:	f822                	sd	s0,48(sp)
    80002e1e:	f426                	sd	s1,40(sp)
    80002e20:	f04a                	sd	s2,32(sp)
    80002e22:	ec4e                	sd	s3,24(sp)
    80002e24:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002e26:	fcc40593          	addi	a1,s0,-52
    80002e2a:	4501                	li	a0,0
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	e2a080e7          	jalr	-470(ra) # 80002c56 <argint>
    return -1;
    80002e34:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002e36:	06054563          	bltz	a0,80002ea0 <sys_sleep+0x88>
  acquire(&tickslock);
    80002e3a:	00020517          	auipc	a0,0x20
    80002e3e:	27e50513          	addi	a0,a0,638 # 800230b8 <tickslock>
    80002e42:	ffffe097          	auipc	ra,0xffffe
    80002e46:	d8e080e7          	jalr	-626(ra) # 80000bd0 <acquire>
  ticks0 = ticks;
    80002e4a:	00006917          	auipc	s2,0x6
    80002e4e:	1e692903          	lw	s2,486(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    80002e52:	fcc42783          	lw	a5,-52(s0)
    80002e56:	cf85                	beqz	a5,80002e8e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e58:	00020997          	auipc	s3,0x20
    80002e5c:	26098993          	addi	s3,s3,608 # 800230b8 <tickslock>
    80002e60:	00006497          	auipc	s1,0x6
    80002e64:	1d048493          	addi	s1,s1,464 # 80009030 <ticks>
    if(myproc()->killed){
    80002e68:	fffff097          	auipc	ra,0xfffff
    80002e6c:	c74080e7          	jalr	-908(ra) # 80001adc <myproc>
    80002e70:	591c                	lw	a5,48(a0)
    80002e72:	ef9d                	bnez	a5,80002eb0 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002e74:	85ce                	mv	a1,s3
    80002e76:	8526                	mv	a0,s1
    80002e78:	fffff097          	auipc	ra,0xfffff
    80002e7c:	512080e7          	jalr	1298(ra) # 8000238a <sleep>
  while(ticks - ticks0 < n){
    80002e80:	409c                	lw	a5,0(s1)
    80002e82:	412787bb          	subw	a5,a5,s2
    80002e86:	fcc42703          	lw	a4,-52(s0)
    80002e8a:	fce7efe3          	bltu	a5,a4,80002e68 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002e8e:	00020517          	auipc	a0,0x20
    80002e92:	22a50513          	addi	a0,a0,554 # 800230b8 <tickslock>
    80002e96:	ffffe097          	auipc	ra,0xffffe
    80002e9a:	dee080e7          	jalr	-530(ra) # 80000c84 <release>
  return 0;
    80002e9e:	4781                	li	a5,0
}
    80002ea0:	853e                	mv	a0,a5
    80002ea2:	70e2                	ld	ra,56(sp)
    80002ea4:	7442                	ld	s0,48(sp)
    80002ea6:	74a2                	ld	s1,40(sp)
    80002ea8:	7902                	ld	s2,32(sp)
    80002eaa:	69e2                	ld	s3,24(sp)
    80002eac:	6121                	addi	sp,sp,64
    80002eae:	8082                	ret
      release(&tickslock);
    80002eb0:	00020517          	auipc	a0,0x20
    80002eb4:	20850513          	addi	a0,a0,520 # 800230b8 <tickslock>
    80002eb8:	ffffe097          	auipc	ra,0xffffe
    80002ebc:	dcc080e7          	jalr	-564(ra) # 80000c84 <release>
      return -1;
    80002ec0:	57fd                	li	a5,-1
    80002ec2:	bff9                	j	80002ea0 <sys_sleep+0x88>

0000000080002ec4 <sys_kill>:

uint64
sys_kill(void)
{
    80002ec4:	1101                	addi	sp,sp,-32
    80002ec6:	ec06                	sd	ra,24(sp)
    80002ec8:	e822                	sd	s0,16(sp)
    80002eca:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002ecc:	fec40593          	addi	a1,s0,-20
    80002ed0:	4501                	li	a0,0
    80002ed2:	00000097          	auipc	ra,0x0
    80002ed6:	d84080e7          	jalr	-636(ra) # 80002c56 <argint>
    80002eda:	87aa                	mv	a5,a0
    return -1;
    80002edc:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002ede:	0007c863          	bltz	a5,80002eee <sys_kill+0x2a>
  return kill(pid);
    80002ee2:	fec42503          	lw	a0,-20(s0)
    80002ee6:	fffff097          	auipc	ra,0xfffff
    80002eea:	68e080e7          	jalr	1678(ra) # 80002574 <kill>
}
    80002eee:	60e2                	ld	ra,24(sp)
    80002ef0:	6442                	ld	s0,16(sp)
    80002ef2:	6105                	addi	sp,sp,32
    80002ef4:	8082                	ret

0000000080002ef6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ef6:	1101                	addi	sp,sp,-32
    80002ef8:	ec06                	sd	ra,24(sp)
    80002efa:	e822                	sd	s0,16(sp)
    80002efc:	e426                	sd	s1,8(sp)
    80002efe:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002f00:	00020517          	auipc	a0,0x20
    80002f04:	1b850513          	addi	a0,a0,440 # 800230b8 <tickslock>
    80002f08:	ffffe097          	auipc	ra,0xffffe
    80002f0c:	cc8080e7          	jalr	-824(ra) # 80000bd0 <acquire>
  xticks = ticks;
    80002f10:	00006497          	auipc	s1,0x6
    80002f14:	1204a483          	lw	s1,288(s1) # 80009030 <ticks>
  release(&tickslock);
    80002f18:	00020517          	auipc	a0,0x20
    80002f1c:	1a050513          	addi	a0,a0,416 # 800230b8 <tickslock>
    80002f20:	ffffe097          	auipc	ra,0xffffe
    80002f24:	d64080e7          	jalr	-668(ra) # 80000c84 <release>
  return xticks;
}
    80002f28:	02049513          	slli	a0,s1,0x20
    80002f2c:	9101                	srli	a0,a0,0x20
    80002f2e:	60e2                	ld	ra,24(sp)
    80002f30:	6442                	ld	s0,16(sp)
    80002f32:	64a2                	ld	s1,8(sp)
    80002f34:	6105                	addi	sp,sp,32
    80002f36:	8082                	ret

0000000080002f38 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f38:	7179                	addi	sp,sp,-48
    80002f3a:	f406                	sd	ra,40(sp)
    80002f3c:	f022                	sd	s0,32(sp)
    80002f3e:	ec26                	sd	s1,24(sp)
    80002f40:	e84a                	sd	s2,16(sp)
    80002f42:	e44e                	sd	s3,8(sp)
    80002f44:	e052                	sd	s4,0(sp)
    80002f46:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f48:	00005597          	auipc	a1,0x5
    80002f4c:	5c858593          	addi	a1,a1,1480 # 80008510 <syscalls+0xc0>
    80002f50:	00020517          	auipc	a0,0x20
    80002f54:	18050513          	addi	a0,a0,384 # 800230d0 <bcache>
    80002f58:	ffffe097          	auipc	ra,0xffffe
    80002f5c:	be8080e7          	jalr	-1048(ra) # 80000b40 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002f60:	00028797          	auipc	a5,0x28
    80002f64:	17078793          	addi	a5,a5,368 # 8002b0d0 <bcache+0x8000>
    80002f68:	00028717          	auipc	a4,0x28
    80002f6c:	3d070713          	addi	a4,a4,976 # 8002b338 <bcache+0x8268>
    80002f70:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f74:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f78:	00020497          	auipc	s1,0x20
    80002f7c:	17048493          	addi	s1,s1,368 # 800230e8 <bcache+0x18>
    b->next = bcache.head.next;
    80002f80:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f82:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f84:	00005a17          	auipc	s4,0x5
    80002f88:	594a0a13          	addi	s4,s4,1428 # 80008518 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002f8c:	2b893783          	ld	a5,696(s2)
    80002f90:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f92:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f96:	85d2                	mv	a1,s4
    80002f98:	01048513          	addi	a0,s1,16
    80002f9c:	00001097          	auipc	ra,0x1
    80002fa0:	4ca080e7          	jalr	1226(ra) # 80004466 <initsleeplock>
    bcache.head.next->prev = b;
    80002fa4:	2b893783          	ld	a5,696(s2)
    80002fa8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002faa:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002fae:	45848493          	addi	s1,s1,1112
    80002fb2:	fd349de3          	bne	s1,s3,80002f8c <binit+0x54>
  }
}
    80002fb6:	70a2                	ld	ra,40(sp)
    80002fb8:	7402                	ld	s0,32(sp)
    80002fba:	64e2                	ld	s1,24(sp)
    80002fbc:	6942                	ld	s2,16(sp)
    80002fbe:	69a2                	ld	s3,8(sp)
    80002fc0:	6a02                	ld	s4,0(sp)
    80002fc2:	6145                	addi	sp,sp,48
    80002fc4:	8082                	ret

0000000080002fc6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002fc6:	7179                	addi	sp,sp,-48
    80002fc8:	f406                	sd	ra,40(sp)
    80002fca:	f022                	sd	s0,32(sp)
    80002fcc:	ec26                	sd	s1,24(sp)
    80002fce:	e84a                	sd	s2,16(sp)
    80002fd0:	e44e                	sd	s3,8(sp)
    80002fd2:	1800                	addi	s0,sp,48
    80002fd4:	892a                	mv	s2,a0
    80002fd6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002fd8:	00020517          	auipc	a0,0x20
    80002fdc:	0f850513          	addi	a0,a0,248 # 800230d0 <bcache>
    80002fe0:	ffffe097          	auipc	ra,0xffffe
    80002fe4:	bf0080e7          	jalr	-1040(ra) # 80000bd0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002fe8:	00028497          	auipc	s1,0x28
    80002fec:	3a04b483          	ld	s1,928(s1) # 8002b388 <bcache+0x82b8>
    80002ff0:	00028797          	auipc	a5,0x28
    80002ff4:	34878793          	addi	a5,a5,840 # 8002b338 <bcache+0x8268>
    80002ff8:	02f48f63          	beq	s1,a5,80003036 <bread+0x70>
    80002ffc:	873e                	mv	a4,a5
    80002ffe:	a021                	j	80003006 <bread+0x40>
    80003000:	68a4                	ld	s1,80(s1)
    80003002:	02e48a63          	beq	s1,a4,80003036 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003006:	449c                	lw	a5,8(s1)
    80003008:	ff279ce3          	bne	a5,s2,80003000 <bread+0x3a>
    8000300c:	44dc                	lw	a5,12(s1)
    8000300e:	ff3799e3          	bne	a5,s3,80003000 <bread+0x3a>
      b->refcnt++;
    80003012:	40bc                	lw	a5,64(s1)
    80003014:	2785                	addiw	a5,a5,1
    80003016:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003018:	00020517          	auipc	a0,0x20
    8000301c:	0b850513          	addi	a0,a0,184 # 800230d0 <bcache>
    80003020:	ffffe097          	auipc	ra,0xffffe
    80003024:	c64080e7          	jalr	-924(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003028:	01048513          	addi	a0,s1,16
    8000302c:	00001097          	auipc	ra,0x1
    80003030:	474080e7          	jalr	1140(ra) # 800044a0 <acquiresleep>
      return b;
    80003034:	a8b9                	j	80003092 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003036:	00028497          	auipc	s1,0x28
    8000303a:	34a4b483          	ld	s1,842(s1) # 8002b380 <bcache+0x82b0>
    8000303e:	00028797          	auipc	a5,0x28
    80003042:	2fa78793          	addi	a5,a5,762 # 8002b338 <bcache+0x8268>
    80003046:	00f48863          	beq	s1,a5,80003056 <bread+0x90>
    8000304a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000304c:	40bc                	lw	a5,64(s1)
    8000304e:	cf81                	beqz	a5,80003066 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003050:	64a4                	ld	s1,72(s1)
    80003052:	fee49de3          	bne	s1,a4,8000304c <bread+0x86>
  panic("bget: no buffers");
    80003056:	00005517          	auipc	a0,0x5
    8000305a:	4ca50513          	addi	a0,a0,1226 # 80008520 <syscalls+0xd0>
    8000305e:	ffffd097          	auipc	ra,0xffffd
    80003062:	4dc080e7          	jalr	1244(ra) # 8000053a <panic>
      b->dev = dev;
    80003066:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000306a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000306e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003072:	4785                	li	a5,1
    80003074:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003076:	00020517          	auipc	a0,0x20
    8000307a:	05a50513          	addi	a0,a0,90 # 800230d0 <bcache>
    8000307e:	ffffe097          	auipc	ra,0xffffe
    80003082:	c06080e7          	jalr	-1018(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003086:	01048513          	addi	a0,s1,16
    8000308a:	00001097          	auipc	ra,0x1
    8000308e:	416080e7          	jalr	1046(ra) # 800044a0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003092:	409c                	lw	a5,0(s1)
    80003094:	cb89                	beqz	a5,800030a6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003096:	8526                	mv	a0,s1
    80003098:	70a2                	ld	ra,40(sp)
    8000309a:	7402                	ld	s0,32(sp)
    8000309c:	64e2                	ld	s1,24(sp)
    8000309e:	6942                	ld	s2,16(sp)
    800030a0:	69a2                	ld	s3,8(sp)
    800030a2:	6145                	addi	sp,sp,48
    800030a4:	8082                	ret
    virtio_disk_rw(b, 0);
    800030a6:	4581                	li	a1,0
    800030a8:	8526                	mv	a0,s1
    800030aa:	00003097          	auipc	ra,0x3
    800030ae:	2e4080e7          	jalr	740(ra) # 8000638e <virtio_disk_rw>
    b->valid = 1;
    800030b2:	4785                	li	a5,1
    800030b4:	c09c                	sw	a5,0(s1)
  return b;
    800030b6:	b7c5                	j	80003096 <bread+0xd0>

00000000800030b8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800030b8:	1101                	addi	sp,sp,-32
    800030ba:	ec06                	sd	ra,24(sp)
    800030bc:	e822                	sd	s0,16(sp)
    800030be:	e426                	sd	s1,8(sp)
    800030c0:	1000                	addi	s0,sp,32
    800030c2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030c4:	0541                	addi	a0,a0,16
    800030c6:	00001097          	auipc	ra,0x1
    800030ca:	474080e7          	jalr	1140(ra) # 8000453a <holdingsleep>
    800030ce:	cd01                	beqz	a0,800030e6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800030d0:	4585                	li	a1,1
    800030d2:	8526                	mv	a0,s1
    800030d4:	00003097          	auipc	ra,0x3
    800030d8:	2ba080e7          	jalr	698(ra) # 8000638e <virtio_disk_rw>
}
    800030dc:	60e2                	ld	ra,24(sp)
    800030de:	6442                	ld	s0,16(sp)
    800030e0:	64a2                	ld	s1,8(sp)
    800030e2:	6105                	addi	sp,sp,32
    800030e4:	8082                	ret
    panic("bwrite");
    800030e6:	00005517          	auipc	a0,0x5
    800030ea:	45250513          	addi	a0,a0,1106 # 80008538 <syscalls+0xe8>
    800030ee:	ffffd097          	auipc	ra,0xffffd
    800030f2:	44c080e7          	jalr	1100(ra) # 8000053a <panic>

00000000800030f6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800030f6:	1101                	addi	sp,sp,-32
    800030f8:	ec06                	sd	ra,24(sp)
    800030fa:	e822                	sd	s0,16(sp)
    800030fc:	e426                	sd	s1,8(sp)
    800030fe:	e04a                	sd	s2,0(sp)
    80003100:	1000                	addi	s0,sp,32
    80003102:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003104:	01050913          	addi	s2,a0,16
    80003108:	854a                	mv	a0,s2
    8000310a:	00001097          	auipc	ra,0x1
    8000310e:	430080e7          	jalr	1072(ra) # 8000453a <holdingsleep>
    80003112:	c92d                	beqz	a0,80003184 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003114:	854a                	mv	a0,s2
    80003116:	00001097          	auipc	ra,0x1
    8000311a:	3e0080e7          	jalr	992(ra) # 800044f6 <releasesleep>

  acquire(&bcache.lock);
    8000311e:	00020517          	auipc	a0,0x20
    80003122:	fb250513          	addi	a0,a0,-78 # 800230d0 <bcache>
    80003126:	ffffe097          	auipc	ra,0xffffe
    8000312a:	aaa080e7          	jalr	-1366(ra) # 80000bd0 <acquire>
  b->refcnt--;
    8000312e:	40bc                	lw	a5,64(s1)
    80003130:	37fd                	addiw	a5,a5,-1
    80003132:	0007871b          	sext.w	a4,a5
    80003136:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003138:	eb05                	bnez	a4,80003168 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000313a:	68bc                	ld	a5,80(s1)
    8000313c:	64b8                	ld	a4,72(s1)
    8000313e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003140:	64bc                	ld	a5,72(s1)
    80003142:	68b8                	ld	a4,80(s1)
    80003144:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003146:	00028797          	auipc	a5,0x28
    8000314a:	f8a78793          	addi	a5,a5,-118 # 8002b0d0 <bcache+0x8000>
    8000314e:	2b87b703          	ld	a4,696(a5)
    80003152:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003154:	00028717          	auipc	a4,0x28
    80003158:	1e470713          	addi	a4,a4,484 # 8002b338 <bcache+0x8268>
    8000315c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000315e:	2b87b703          	ld	a4,696(a5)
    80003162:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003164:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003168:	00020517          	auipc	a0,0x20
    8000316c:	f6850513          	addi	a0,a0,-152 # 800230d0 <bcache>
    80003170:	ffffe097          	auipc	ra,0xffffe
    80003174:	b14080e7          	jalr	-1260(ra) # 80000c84 <release>
}
    80003178:	60e2                	ld	ra,24(sp)
    8000317a:	6442                	ld	s0,16(sp)
    8000317c:	64a2                	ld	s1,8(sp)
    8000317e:	6902                	ld	s2,0(sp)
    80003180:	6105                	addi	sp,sp,32
    80003182:	8082                	ret
    panic("brelse");
    80003184:	00005517          	auipc	a0,0x5
    80003188:	3bc50513          	addi	a0,a0,956 # 80008540 <syscalls+0xf0>
    8000318c:	ffffd097          	auipc	ra,0xffffd
    80003190:	3ae080e7          	jalr	942(ra) # 8000053a <panic>

0000000080003194 <bpin>:

void
bpin(struct buf *b) {
    80003194:	1101                	addi	sp,sp,-32
    80003196:	ec06                	sd	ra,24(sp)
    80003198:	e822                	sd	s0,16(sp)
    8000319a:	e426                	sd	s1,8(sp)
    8000319c:	1000                	addi	s0,sp,32
    8000319e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031a0:	00020517          	auipc	a0,0x20
    800031a4:	f3050513          	addi	a0,a0,-208 # 800230d0 <bcache>
    800031a8:	ffffe097          	auipc	ra,0xffffe
    800031ac:	a28080e7          	jalr	-1496(ra) # 80000bd0 <acquire>
  b->refcnt++;
    800031b0:	40bc                	lw	a5,64(s1)
    800031b2:	2785                	addiw	a5,a5,1
    800031b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031b6:	00020517          	auipc	a0,0x20
    800031ba:	f1a50513          	addi	a0,a0,-230 # 800230d0 <bcache>
    800031be:	ffffe097          	auipc	ra,0xffffe
    800031c2:	ac6080e7          	jalr	-1338(ra) # 80000c84 <release>
}
    800031c6:	60e2                	ld	ra,24(sp)
    800031c8:	6442                	ld	s0,16(sp)
    800031ca:	64a2                	ld	s1,8(sp)
    800031cc:	6105                	addi	sp,sp,32
    800031ce:	8082                	ret

00000000800031d0 <bunpin>:

void
bunpin(struct buf *b) {
    800031d0:	1101                	addi	sp,sp,-32
    800031d2:	ec06                	sd	ra,24(sp)
    800031d4:	e822                	sd	s0,16(sp)
    800031d6:	e426                	sd	s1,8(sp)
    800031d8:	1000                	addi	s0,sp,32
    800031da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031dc:	00020517          	auipc	a0,0x20
    800031e0:	ef450513          	addi	a0,a0,-268 # 800230d0 <bcache>
    800031e4:	ffffe097          	auipc	ra,0xffffe
    800031e8:	9ec080e7          	jalr	-1556(ra) # 80000bd0 <acquire>
  b->refcnt--;
    800031ec:	40bc                	lw	a5,64(s1)
    800031ee:	37fd                	addiw	a5,a5,-1
    800031f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031f2:	00020517          	auipc	a0,0x20
    800031f6:	ede50513          	addi	a0,a0,-290 # 800230d0 <bcache>
    800031fa:	ffffe097          	auipc	ra,0xffffe
    800031fe:	a8a080e7          	jalr	-1398(ra) # 80000c84 <release>
}
    80003202:	60e2                	ld	ra,24(sp)
    80003204:	6442                	ld	s0,16(sp)
    80003206:	64a2                	ld	s1,8(sp)
    80003208:	6105                	addi	sp,sp,32
    8000320a:	8082                	ret

000000008000320c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000320c:	1101                	addi	sp,sp,-32
    8000320e:	ec06                	sd	ra,24(sp)
    80003210:	e822                	sd	s0,16(sp)
    80003212:	e426                	sd	s1,8(sp)
    80003214:	e04a                	sd	s2,0(sp)
    80003216:	1000                	addi	s0,sp,32
    80003218:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000321a:	00d5d59b          	srliw	a1,a1,0xd
    8000321e:	00028797          	auipc	a5,0x28
    80003222:	58e7a783          	lw	a5,1422(a5) # 8002b7ac <sb+0x1c>
    80003226:	9dbd                	addw	a1,a1,a5
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	d9e080e7          	jalr	-610(ra) # 80002fc6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003230:	0074f713          	andi	a4,s1,7
    80003234:	4785                	li	a5,1
    80003236:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000323a:	14ce                	slli	s1,s1,0x33
    8000323c:	90d9                	srli	s1,s1,0x36
    8000323e:	00950733          	add	a4,a0,s1
    80003242:	05874703          	lbu	a4,88(a4)
    80003246:	00e7f6b3          	and	a3,a5,a4
    8000324a:	c69d                	beqz	a3,80003278 <bfree+0x6c>
    8000324c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000324e:	94aa                	add	s1,s1,a0
    80003250:	fff7c793          	not	a5,a5
    80003254:	8f7d                	and	a4,a4,a5
    80003256:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000325a:	00001097          	auipc	ra,0x1
    8000325e:	120080e7          	jalr	288(ra) # 8000437a <log_write>
  brelse(bp);
    80003262:	854a                	mv	a0,s2
    80003264:	00000097          	auipc	ra,0x0
    80003268:	e92080e7          	jalr	-366(ra) # 800030f6 <brelse>
}
    8000326c:	60e2                	ld	ra,24(sp)
    8000326e:	6442                	ld	s0,16(sp)
    80003270:	64a2                	ld	s1,8(sp)
    80003272:	6902                	ld	s2,0(sp)
    80003274:	6105                	addi	sp,sp,32
    80003276:	8082                	ret
    panic("freeing free block");
    80003278:	00005517          	auipc	a0,0x5
    8000327c:	2d050513          	addi	a0,a0,720 # 80008548 <syscalls+0xf8>
    80003280:	ffffd097          	auipc	ra,0xffffd
    80003284:	2ba080e7          	jalr	698(ra) # 8000053a <panic>

0000000080003288 <balloc>:
{
    80003288:	711d                	addi	sp,sp,-96
    8000328a:	ec86                	sd	ra,88(sp)
    8000328c:	e8a2                	sd	s0,80(sp)
    8000328e:	e4a6                	sd	s1,72(sp)
    80003290:	e0ca                	sd	s2,64(sp)
    80003292:	fc4e                	sd	s3,56(sp)
    80003294:	f852                	sd	s4,48(sp)
    80003296:	f456                	sd	s5,40(sp)
    80003298:	f05a                	sd	s6,32(sp)
    8000329a:	ec5e                	sd	s7,24(sp)
    8000329c:	e862                	sd	s8,16(sp)
    8000329e:	e466                	sd	s9,8(sp)
    800032a0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800032a2:	00028797          	auipc	a5,0x28
    800032a6:	4f27a783          	lw	a5,1266(a5) # 8002b794 <sb+0x4>
    800032aa:	cbc1                	beqz	a5,8000333a <balloc+0xb2>
    800032ac:	8baa                	mv	s7,a0
    800032ae:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800032b0:	00028b17          	auipc	s6,0x28
    800032b4:	4e0b0b13          	addi	s6,s6,1248 # 8002b790 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032b8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800032ba:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032bc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800032be:	6c89                	lui	s9,0x2
    800032c0:	a831                	j	800032dc <balloc+0x54>
    brelse(bp);
    800032c2:	854a                	mv	a0,s2
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	e32080e7          	jalr	-462(ra) # 800030f6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800032cc:	015c87bb          	addw	a5,s9,s5
    800032d0:	00078a9b          	sext.w	s5,a5
    800032d4:	004b2703          	lw	a4,4(s6)
    800032d8:	06eaf163          	bgeu	s5,a4,8000333a <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800032dc:	41fad79b          	sraiw	a5,s5,0x1f
    800032e0:	0137d79b          	srliw	a5,a5,0x13
    800032e4:	015787bb          	addw	a5,a5,s5
    800032e8:	40d7d79b          	sraiw	a5,a5,0xd
    800032ec:	01cb2583          	lw	a1,28(s6)
    800032f0:	9dbd                	addw	a1,a1,a5
    800032f2:	855e                	mv	a0,s7
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	cd2080e7          	jalr	-814(ra) # 80002fc6 <bread>
    800032fc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032fe:	004b2503          	lw	a0,4(s6)
    80003302:	000a849b          	sext.w	s1,s5
    80003306:	8762                	mv	a4,s8
    80003308:	faa4fde3          	bgeu	s1,a0,800032c2 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000330c:	00777693          	andi	a3,a4,7
    80003310:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003314:	41f7579b          	sraiw	a5,a4,0x1f
    80003318:	01d7d79b          	srliw	a5,a5,0x1d
    8000331c:	9fb9                	addw	a5,a5,a4
    8000331e:	4037d79b          	sraiw	a5,a5,0x3
    80003322:	00f90633          	add	a2,s2,a5
    80003326:	05864603          	lbu	a2,88(a2)
    8000332a:	00c6f5b3          	and	a1,a3,a2
    8000332e:	cd91                	beqz	a1,8000334a <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003330:	2705                	addiw	a4,a4,1
    80003332:	2485                	addiw	s1,s1,1
    80003334:	fd471ae3          	bne	a4,s4,80003308 <balloc+0x80>
    80003338:	b769                	j	800032c2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000333a:	00005517          	auipc	a0,0x5
    8000333e:	22650513          	addi	a0,a0,550 # 80008560 <syscalls+0x110>
    80003342:	ffffd097          	auipc	ra,0xffffd
    80003346:	1f8080e7          	jalr	504(ra) # 8000053a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000334a:	97ca                	add	a5,a5,s2
    8000334c:	8e55                	or	a2,a2,a3
    8000334e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003352:	854a                	mv	a0,s2
    80003354:	00001097          	auipc	ra,0x1
    80003358:	026080e7          	jalr	38(ra) # 8000437a <log_write>
        brelse(bp);
    8000335c:	854a                	mv	a0,s2
    8000335e:	00000097          	auipc	ra,0x0
    80003362:	d98080e7          	jalr	-616(ra) # 800030f6 <brelse>
  bp = bread(dev, bno);
    80003366:	85a6                	mv	a1,s1
    80003368:	855e                	mv	a0,s7
    8000336a:	00000097          	auipc	ra,0x0
    8000336e:	c5c080e7          	jalr	-932(ra) # 80002fc6 <bread>
    80003372:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003374:	40000613          	li	a2,1024
    80003378:	4581                	li	a1,0
    8000337a:	05850513          	addi	a0,a0,88
    8000337e:	ffffe097          	auipc	ra,0xffffe
    80003382:	94e080e7          	jalr	-1714(ra) # 80000ccc <memset>
  log_write(bp);
    80003386:	854a                	mv	a0,s2
    80003388:	00001097          	auipc	ra,0x1
    8000338c:	ff2080e7          	jalr	-14(ra) # 8000437a <log_write>
  brelse(bp);
    80003390:	854a                	mv	a0,s2
    80003392:	00000097          	auipc	ra,0x0
    80003396:	d64080e7          	jalr	-668(ra) # 800030f6 <brelse>
}
    8000339a:	8526                	mv	a0,s1
    8000339c:	60e6                	ld	ra,88(sp)
    8000339e:	6446                	ld	s0,80(sp)
    800033a0:	64a6                	ld	s1,72(sp)
    800033a2:	6906                	ld	s2,64(sp)
    800033a4:	79e2                	ld	s3,56(sp)
    800033a6:	7a42                	ld	s4,48(sp)
    800033a8:	7aa2                	ld	s5,40(sp)
    800033aa:	7b02                	ld	s6,32(sp)
    800033ac:	6be2                	ld	s7,24(sp)
    800033ae:	6c42                	ld	s8,16(sp)
    800033b0:	6ca2                	ld	s9,8(sp)
    800033b2:	6125                	addi	sp,sp,96
    800033b4:	8082                	ret

00000000800033b6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800033b6:	7179                	addi	sp,sp,-48
    800033b8:	f406                	sd	ra,40(sp)
    800033ba:	f022                	sd	s0,32(sp)
    800033bc:	ec26                	sd	s1,24(sp)
    800033be:	e84a                	sd	s2,16(sp)
    800033c0:	e44e                	sd	s3,8(sp)
    800033c2:	e052                	sd	s4,0(sp)
    800033c4:	1800                	addi	s0,sp,48
    800033c6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800033c8:	47ad                	li	a5,11
    800033ca:	04b7fe63          	bgeu	a5,a1,80003426 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800033ce:	ff45849b          	addiw	s1,a1,-12
    800033d2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800033d6:	0ff00793          	li	a5,255
    800033da:	0ae7e463          	bltu	a5,a4,80003482 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800033de:	08052583          	lw	a1,128(a0)
    800033e2:	c5b5                	beqz	a1,8000344e <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800033e4:	00092503          	lw	a0,0(s2)
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	bde080e7          	jalr	-1058(ra) # 80002fc6 <bread>
    800033f0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800033f2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800033f6:	02049713          	slli	a4,s1,0x20
    800033fa:	01e75593          	srli	a1,a4,0x1e
    800033fe:	00b784b3          	add	s1,a5,a1
    80003402:	0004a983          	lw	s3,0(s1)
    80003406:	04098e63          	beqz	s3,80003462 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000340a:	8552                	mv	a0,s4
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	cea080e7          	jalr	-790(ra) # 800030f6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003414:	854e                	mv	a0,s3
    80003416:	70a2                	ld	ra,40(sp)
    80003418:	7402                	ld	s0,32(sp)
    8000341a:	64e2                	ld	s1,24(sp)
    8000341c:	6942                	ld	s2,16(sp)
    8000341e:	69a2                	ld	s3,8(sp)
    80003420:	6a02                	ld	s4,0(sp)
    80003422:	6145                	addi	sp,sp,48
    80003424:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003426:	02059793          	slli	a5,a1,0x20
    8000342a:	01e7d593          	srli	a1,a5,0x1e
    8000342e:	00b504b3          	add	s1,a0,a1
    80003432:	0504a983          	lw	s3,80(s1)
    80003436:	fc099fe3          	bnez	s3,80003414 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000343a:	4108                	lw	a0,0(a0)
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	e4c080e7          	jalr	-436(ra) # 80003288 <balloc>
    80003444:	0005099b          	sext.w	s3,a0
    80003448:	0534a823          	sw	s3,80(s1)
    8000344c:	b7e1                	j	80003414 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000344e:	4108                	lw	a0,0(a0)
    80003450:	00000097          	auipc	ra,0x0
    80003454:	e38080e7          	jalr	-456(ra) # 80003288 <balloc>
    80003458:	0005059b          	sext.w	a1,a0
    8000345c:	08b92023          	sw	a1,128(s2)
    80003460:	b751                	j	800033e4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003462:	00092503          	lw	a0,0(s2)
    80003466:	00000097          	auipc	ra,0x0
    8000346a:	e22080e7          	jalr	-478(ra) # 80003288 <balloc>
    8000346e:	0005099b          	sext.w	s3,a0
    80003472:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003476:	8552                	mv	a0,s4
    80003478:	00001097          	auipc	ra,0x1
    8000347c:	f02080e7          	jalr	-254(ra) # 8000437a <log_write>
    80003480:	b769                	j	8000340a <bmap+0x54>
  panic("bmap: out of range");
    80003482:	00005517          	auipc	a0,0x5
    80003486:	0f650513          	addi	a0,a0,246 # 80008578 <syscalls+0x128>
    8000348a:	ffffd097          	auipc	ra,0xffffd
    8000348e:	0b0080e7          	jalr	176(ra) # 8000053a <panic>

0000000080003492 <iget>:
{
    80003492:	7179                	addi	sp,sp,-48
    80003494:	f406                	sd	ra,40(sp)
    80003496:	f022                	sd	s0,32(sp)
    80003498:	ec26                	sd	s1,24(sp)
    8000349a:	e84a                	sd	s2,16(sp)
    8000349c:	e44e                	sd	s3,8(sp)
    8000349e:	e052                	sd	s4,0(sp)
    800034a0:	1800                	addi	s0,sp,48
    800034a2:	89aa                	mv	s3,a0
    800034a4:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800034a6:	00028517          	auipc	a0,0x28
    800034aa:	30a50513          	addi	a0,a0,778 # 8002b7b0 <icache>
    800034ae:	ffffd097          	auipc	ra,0xffffd
    800034b2:	722080e7          	jalr	1826(ra) # 80000bd0 <acquire>
  empty = 0;
    800034b6:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800034b8:	00028497          	auipc	s1,0x28
    800034bc:	31048493          	addi	s1,s1,784 # 8002b7c8 <icache+0x18>
    800034c0:	0002a697          	auipc	a3,0x2a
    800034c4:	d9868693          	addi	a3,a3,-616 # 8002d258 <log>
    800034c8:	a039                	j	800034d6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034ca:	02090b63          	beqz	s2,80003500 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800034ce:	08848493          	addi	s1,s1,136
    800034d2:	02d48a63          	beq	s1,a3,80003506 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034d6:	449c                	lw	a5,8(s1)
    800034d8:	fef059e3          	blez	a5,800034ca <iget+0x38>
    800034dc:	4098                	lw	a4,0(s1)
    800034de:	ff3716e3          	bne	a4,s3,800034ca <iget+0x38>
    800034e2:	40d8                	lw	a4,4(s1)
    800034e4:	ff4713e3          	bne	a4,s4,800034ca <iget+0x38>
      ip->ref++;
    800034e8:	2785                	addiw	a5,a5,1
    800034ea:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800034ec:	00028517          	auipc	a0,0x28
    800034f0:	2c450513          	addi	a0,a0,708 # 8002b7b0 <icache>
    800034f4:	ffffd097          	auipc	ra,0xffffd
    800034f8:	790080e7          	jalr	1936(ra) # 80000c84 <release>
      return ip;
    800034fc:	8926                	mv	s2,s1
    800034fe:	a03d                	j	8000352c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003500:	f7f9                	bnez	a5,800034ce <iget+0x3c>
    80003502:	8926                	mv	s2,s1
    80003504:	b7e9                	j	800034ce <iget+0x3c>
  if(empty == 0)
    80003506:	02090c63          	beqz	s2,8000353e <iget+0xac>
  ip->dev = dev;
    8000350a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000350e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003512:	4785                	li	a5,1
    80003514:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003518:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000351c:	00028517          	auipc	a0,0x28
    80003520:	29450513          	addi	a0,a0,660 # 8002b7b0 <icache>
    80003524:	ffffd097          	auipc	ra,0xffffd
    80003528:	760080e7          	jalr	1888(ra) # 80000c84 <release>
}
    8000352c:	854a                	mv	a0,s2
    8000352e:	70a2                	ld	ra,40(sp)
    80003530:	7402                	ld	s0,32(sp)
    80003532:	64e2                	ld	s1,24(sp)
    80003534:	6942                	ld	s2,16(sp)
    80003536:	69a2                	ld	s3,8(sp)
    80003538:	6a02                	ld	s4,0(sp)
    8000353a:	6145                	addi	sp,sp,48
    8000353c:	8082                	ret
    panic("iget: no inodes");
    8000353e:	00005517          	auipc	a0,0x5
    80003542:	05250513          	addi	a0,a0,82 # 80008590 <syscalls+0x140>
    80003546:	ffffd097          	auipc	ra,0xffffd
    8000354a:	ff4080e7          	jalr	-12(ra) # 8000053a <panic>

000000008000354e <fsinit>:
fsinit(int dev) {
    8000354e:	7179                	addi	sp,sp,-48
    80003550:	f406                	sd	ra,40(sp)
    80003552:	f022                	sd	s0,32(sp)
    80003554:	ec26                	sd	s1,24(sp)
    80003556:	e84a                	sd	s2,16(sp)
    80003558:	e44e                	sd	s3,8(sp)
    8000355a:	1800                	addi	s0,sp,48
    8000355c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000355e:	4585                	li	a1,1
    80003560:	00000097          	auipc	ra,0x0
    80003564:	a66080e7          	jalr	-1434(ra) # 80002fc6 <bread>
    80003568:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000356a:	00028997          	auipc	s3,0x28
    8000356e:	22698993          	addi	s3,s3,550 # 8002b790 <sb>
    80003572:	02000613          	li	a2,32
    80003576:	05850593          	addi	a1,a0,88
    8000357a:	854e                	mv	a0,s3
    8000357c:	ffffd097          	auipc	ra,0xffffd
    80003580:	7ac080e7          	jalr	1964(ra) # 80000d28 <memmove>
  brelse(bp);
    80003584:	8526                	mv	a0,s1
    80003586:	00000097          	auipc	ra,0x0
    8000358a:	b70080e7          	jalr	-1168(ra) # 800030f6 <brelse>
  if(sb.magic != FSMAGIC)
    8000358e:	0009a703          	lw	a4,0(s3)
    80003592:	102037b7          	lui	a5,0x10203
    80003596:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000359a:	02f71263          	bne	a4,a5,800035be <fsinit+0x70>
  initlog(dev, &sb);
    8000359e:	00028597          	auipc	a1,0x28
    800035a2:	1f258593          	addi	a1,a1,498 # 8002b790 <sb>
    800035a6:	854a                	mv	a0,s2
    800035a8:	00001097          	auipc	ra,0x1
    800035ac:	b56080e7          	jalr	-1194(ra) # 800040fe <initlog>
}
    800035b0:	70a2                	ld	ra,40(sp)
    800035b2:	7402                	ld	s0,32(sp)
    800035b4:	64e2                	ld	s1,24(sp)
    800035b6:	6942                	ld	s2,16(sp)
    800035b8:	69a2                	ld	s3,8(sp)
    800035ba:	6145                	addi	sp,sp,48
    800035bc:	8082                	ret
    panic("invalid file system");
    800035be:	00005517          	auipc	a0,0x5
    800035c2:	fe250513          	addi	a0,a0,-30 # 800085a0 <syscalls+0x150>
    800035c6:	ffffd097          	auipc	ra,0xffffd
    800035ca:	f74080e7          	jalr	-140(ra) # 8000053a <panic>

00000000800035ce <iinit>:
{
    800035ce:	7179                	addi	sp,sp,-48
    800035d0:	f406                	sd	ra,40(sp)
    800035d2:	f022                	sd	s0,32(sp)
    800035d4:	ec26                	sd	s1,24(sp)
    800035d6:	e84a                	sd	s2,16(sp)
    800035d8:	e44e                	sd	s3,8(sp)
    800035da:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800035dc:	00005597          	auipc	a1,0x5
    800035e0:	fdc58593          	addi	a1,a1,-36 # 800085b8 <syscalls+0x168>
    800035e4:	00028517          	auipc	a0,0x28
    800035e8:	1cc50513          	addi	a0,a0,460 # 8002b7b0 <icache>
    800035ec:	ffffd097          	auipc	ra,0xffffd
    800035f0:	554080e7          	jalr	1364(ra) # 80000b40 <initlock>
  for(i = 0; i < NINODE; i++) {
    800035f4:	00028497          	auipc	s1,0x28
    800035f8:	1e448493          	addi	s1,s1,484 # 8002b7d8 <icache+0x28>
    800035fc:	0002a997          	auipc	s3,0x2a
    80003600:	c6c98993          	addi	s3,s3,-916 # 8002d268 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003604:	00005917          	auipc	s2,0x5
    80003608:	fbc90913          	addi	s2,s2,-68 # 800085c0 <syscalls+0x170>
    8000360c:	85ca                	mv	a1,s2
    8000360e:	8526                	mv	a0,s1
    80003610:	00001097          	auipc	ra,0x1
    80003614:	e56080e7          	jalr	-426(ra) # 80004466 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003618:	08848493          	addi	s1,s1,136
    8000361c:	ff3498e3          	bne	s1,s3,8000360c <iinit+0x3e>
}
    80003620:	70a2                	ld	ra,40(sp)
    80003622:	7402                	ld	s0,32(sp)
    80003624:	64e2                	ld	s1,24(sp)
    80003626:	6942                	ld	s2,16(sp)
    80003628:	69a2                	ld	s3,8(sp)
    8000362a:	6145                	addi	sp,sp,48
    8000362c:	8082                	ret

000000008000362e <ialloc>:
{
    8000362e:	715d                	addi	sp,sp,-80
    80003630:	e486                	sd	ra,72(sp)
    80003632:	e0a2                	sd	s0,64(sp)
    80003634:	fc26                	sd	s1,56(sp)
    80003636:	f84a                	sd	s2,48(sp)
    80003638:	f44e                	sd	s3,40(sp)
    8000363a:	f052                	sd	s4,32(sp)
    8000363c:	ec56                	sd	s5,24(sp)
    8000363e:	e85a                	sd	s6,16(sp)
    80003640:	e45e                	sd	s7,8(sp)
    80003642:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003644:	00028717          	auipc	a4,0x28
    80003648:	15872703          	lw	a4,344(a4) # 8002b79c <sb+0xc>
    8000364c:	4785                	li	a5,1
    8000364e:	04e7fa63          	bgeu	a5,a4,800036a2 <ialloc+0x74>
    80003652:	8aaa                	mv	s5,a0
    80003654:	8bae                	mv	s7,a1
    80003656:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003658:	00028a17          	auipc	s4,0x28
    8000365c:	138a0a13          	addi	s4,s4,312 # 8002b790 <sb>
    80003660:	00048b1b          	sext.w	s6,s1
    80003664:	0044d593          	srli	a1,s1,0x4
    80003668:	018a2783          	lw	a5,24(s4)
    8000366c:	9dbd                	addw	a1,a1,a5
    8000366e:	8556                	mv	a0,s5
    80003670:	00000097          	auipc	ra,0x0
    80003674:	956080e7          	jalr	-1706(ra) # 80002fc6 <bread>
    80003678:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000367a:	05850993          	addi	s3,a0,88
    8000367e:	00f4f793          	andi	a5,s1,15
    80003682:	079a                	slli	a5,a5,0x6
    80003684:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003686:	00099783          	lh	a5,0(s3)
    8000368a:	c785                	beqz	a5,800036b2 <ialloc+0x84>
    brelse(bp);
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	a6a080e7          	jalr	-1430(ra) # 800030f6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003694:	0485                	addi	s1,s1,1
    80003696:	00ca2703          	lw	a4,12(s4)
    8000369a:	0004879b          	sext.w	a5,s1
    8000369e:	fce7e1e3          	bltu	a5,a4,80003660 <ialloc+0x32>
  panic("ialloc: no inodes");
    800036a2:	00005517          	auipc	a0,0x5
    800036a6:	f2650513          	addi	a0,a0,-218 # 800085c8 <syscalls+0x178>
    800036aa:	ffffd097          	auipc	ra,0xffffd
    800036ae:	e90080e7          	jalr	-368(ra) # 8000053a <panic>
      memset(dip, 0, sizeof(*dip));
    800036b2:	04000613          	li	a2,64
    800036b6:	4581                	li	a1,0
    800036b8:	854e                	mv	a0,s3
    800036ba:	ffffd097          	auipc	ra,0xffffd
    800036be:	612080e7          	jalr	1554(ra) # 80000ccc <memset>
      dip->type = type;
    800036c2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800036c6:	854a                	mv	a0,s2
    800036c8:	00001097          	auipc	ra,0x1
    800036cc:	cb2080e7          	jalr	-846(ra) # 8000437a <log_write>
      brelse(bp);
    800036d0:	854a                	mv	a0,s2
    800036d2:	00000097          	auipc	ra,0x0
    800036d6:	a24080e7          	jalr	-1500(ra) # 800030f6 <brelse>
      return iget(dev, inum);
    800036da:	85da                	mv	a1,s6
    800036dc:	8556                	mv	a0,s5
    800036de:	00000097          	auipc	ra,0x0
    800036e2:	db4080e7          	jalr	-588(ra) # 80003492 <iget>
}
    800036e6:	60a6                	ld	ra,72(sp)
    800036e8:	6406                	ld	s0,64(sp)
    800036ea:	74e2                	ld	s1,56(sp)
    800036ec:	7942                	ld	s2,48(sp)
    800036ee:	79a2                	ld	s3,40(sp)
    800036f0:	7a02                	ld	s4,32(sp)
    800036f2:	6ae2                	ld	s5,24(sp)
    800036f4:	6b42                	ld	s6,16(sp)
    800036f6:	6ba2                	ld	s7,8(sp)
    800036f8:	6161                	addi	sp,sp,80
    800036fa:	8082                	ret

00000000800036fc <iupdate>:
{
    800036fc:	1101                	addi	sp,sp,-32
    800036fe:	ec06                	sd	ra,24(sp)
    80003700:	e822                	sd	s0,16(sp)
    80003702:	e426                	sd	s1,8(sp)
    80003704:	e04a                	sd	s2,0(sp)
    80003706:	1000                	addi	s0,sp,32
    80003708:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000370a:	415c                	lw	a5,4(a0)
    8000370c:	0047d79b          	srliw	a5,a5,0x4
    80003710:	00028597          	auipc	a1,0x28
    80003714:	0985a583          	lw	a1,152(a1) # 8002b7a8 <sb+0x18>
    80003718:	9dbd                	addw	a1,a1,a5
    8000371a:	4108                	lw	a0,0(a0)
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	8aa080e7          	jalr	-1878(ra) # 80002fc6 <bread>
    80003724:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003726:	05850793          	addi	a5,a0,88
    8000372a:	40d8                	lw	a4,4(s1)
    8000372c:	8b3d                	andi	a4,a4,15
    8000372e:	071a                	slli	a4,a4,0x6
    80003730:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003732:	04449703          	lh	a4,68(s1)
    80003736:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000373a:	04649703          	lh	a4,70(s1)
    8000373e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003742:	04849703          	lh	a4,72(s1)
    80003746:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000374a:	04a49703          	lh	a4,74(s1)
    8000374e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003752:	44f8                	lw	a4,76(s1)
    80003754:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003756:	03400613          	li	a2,52
    8000375a:	05048593          	addi	a1,s1,80
    8000375e:	00c78513          	addi	a0,a5,12
    80003762:	ffffd097          	auipc	ra,0xffffd
    80003766:	5c6080e7          	jalr	1478(ra) # 80000d28 <memmove>
  log_write(bp);
    8000376a:	854a                	mv	a0,s2
    8000376c:	00001097          	auipc	ra,0x1
    80003770:	c0e080e7          	jalr	-1010(ra) # 8000437a <log_write>
  brelse(bp);
    80003774:	854a                	mv	a0,s2
    80003776:	00000097          	auipc	ra,0x0
    8000377a:	980080e7          	jalr	-1664(ra) # 800030f6 <brelse>
}
    8000377e:	60e2                	ld	ra,24(sp)
    80003780:	6442                	ld	s0,16(sp)
    80003782:	64a2                	ld	s1,8(sp)
    80003784:	6902                	ld	s2,0(sp)
    80003786:	6105                	addi	sp,sp,32
    80003788:	8082                	ret

000000008000378a <idup>:
{
    8000378a:	1101                	addi	sp,sp,-32
    8000378c:	ec06                	sd	ra,24(sp)
    8000378e:	e822                	sd	s0,16(sp)
    80003790:	e426                	sd	s1,8(sp)
    80003792:	1000                	addi	s0,sp,32
    80003794:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003796:	00028517          	auipc	a0,0x28
    8000379a:	01a50513          	addi	a0,a0,26 # 8002b7b0 <icache>
    8000379e:	ffffd097          	auipc	ra,0xffffd
    800037a2:	432080e7          	jalr	1074(ra) # 80000bd0 <acquire>
  ip->ref++;
    800037a6:	449c                	lw	a5,8(s1)
    800037a8:	2785                	addiw	a5,a5,1
    800037aa:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037ac:	00028517          	auipc	a0,0x28
    800037b0:	00450513          	addi	a0,a0,4 # 8002b7b0 <icache>
    800037b4:	ffffd097          	auipc	ra,0xffffd
    800037b8:	4d0080e7          	jalr	1232(ra) # 80000c84 <release>
}
    800037bc:	8526                	mv	a0,s1
    800037be:	60e2                	ld	ra,24(sp)
    800037c0:	6442                	ld	s0,16(sp)
    800037c2:	64a2                	ld	s1,8(sp)
    800037c4:	6105                	addi	sp,sp,32
    800037c6:	8082                	ret

00000000800037c8 <ilock>:
{
    800037c8:	1101                	addi	sp,sp,-32
    800037ca:	ec06                	sd	ra,24(sp)
    800037cc:	e822                	sd	s0,16(sp)
    800037ce:	e426                	sd	s1,8(sp)
    800037d0:	e04a                	sd	s2,0(sp)
    800037d2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800037d4:	c115                	beqz	a0,800037f8 <ilock+0x30>
    800037d6:	84aa                	mv	s1,a0
    800037d8:	451c                	lw	a5,8(a0)
    800037da:	00f05f63          	blez	a5,800037f8 <ilock+0x30>
  acquiresleep(&ip->lock);
    800037de:	0541                	addi	a0,a0,16
    800037e0:	00001097          	auipc	ra,0x1
    800037e4:	cc0080e7          	jalr	-832(ra) # 800044a0 <acquiresleep>
  if(ip->valid == 0){
    800037e8:	40bc                	lw	a5,64(s1)
    800037ea:	cf99                	beqz	a5,80003808 <ilock+0x40>
}
    800037ec:	60e2                	ld	ra,24(sp)
    800037ee:	6442                	ld	s0,16(sp)
    800037f0:	64a2                	ld	s1,8(sp)
    800037f2:	6902                	ld	s2,0(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret
    panic("ilock");
    800037f8:	00005517          	auipc	a0,0x5
    800037fc:	de850513          	addi	a0,a0,-536 # 800085e0 <syscalls+0x190>
    80003800:	ffffd097          	auipc	ra,0xffffd
    80003804:	d3a080e7          	jalr	-710(ra) # 8000053a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003808:	40dc                	lw	a5,4(s1)
    8000380a:	0047d79b          	srliw	a5,a5,0x4
    8000380e:	00028597          	auipc	a1,0x28
    80003812:	f9a5a583          	lw	a1,-102(a1) # 8002b7a8 <sb+0x18>
    80003816:	9dbd                	addw	a1,a1,a5
    80003818:	4088                	lw	a0,0(s1)
    8000381a:	fffff097          	auipc	ra,0xfffff
    8000381e:	7ac080e7          	jalr	1964(ra) # 80002fc6 <bread>
    80003822:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003824:	05850593          	addi	a1,a0,88
    80003828:	40dc                	lw	a5,4(s1)
    8000382a:	8bbd                	andi	a5,a5,15
    8000382c:	079a                	slli	a5,a5,0x6
    8000382e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003830:	00059783          	lh	a5,0(a1)
    80003834:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003838:	00259783          	lh	a5,2(a1)
    8000383c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003840:	00459783          	lh	a5,4(a1)
    80003844:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003848:	00659783          	lh	a5,6(a1)
    8000384c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003850:	459c                	lw	a5,8(a1)
    80003852:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003854:	03400613          	li	a2,52
    80003858:	05b1                	addi	a1,a1,12
    8000385a:	05048513          	addi	a0,s1,80
    8000385e:	ffffd097          	auipc	ra,0xffffd
    80003862:	4ca080e7          	jalr	1226(ra) # 80000d28 <memmove>
    brelse(bp);
    80003866:	854a                	mv	a0,s2
    80003868:	00000097          	auipc	ra,0x0
    8000386c:	88e080e7          	jalr	-1906(ra) # 800030f6 <brelse>
    ip->valid = 1;
    80003870:	4785                	li	a5,1
    80003872:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003874:	04449783          	lh	a5,68(s1)
    80003878:	fbb5                	bnez	a5,800037ec <ilock+0x24>
      panic("ilock: no type");
    8000387a:	00005517          	auipc	a0,0x5
    8000387e:	d6e50513          	addi	a0,a0,-658 # 800085e8 <syscalls+0x198>
    80003882:	ffffd097          	auipc	ra,0xffffd
    80003886:	cb8080e7          	jalr	-840(ra) # 8000053a <panic>

000000008000388a <iunlock>:
{
    8000388a:	1101                	addi	sp,sp,-32
    8000388c:	ec06                	sd	ra,24(sp)
    8000388e:	e822                	sd	s0,16(sp)
    80003890:	e426                	sd	s1,8(sp)
    80003892:	e04a                	sd	s2,0(sp)
    80003894:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003896:	c905                	beqz	a0,800038c6 <iunlock+0x3c>
    80003898:	84aa                	mv	s1,a0
    8000389a:	01050913          	addi	s2,a0,16
    8000389e:	854a                	mv	a0,s2
    800038a0:	00001097          	auipc	ra,0x1
    800038a4:	c9a080e7          	jalr	-870(ra) # 8000453a <holdingsleep>
    800038a8:	cd19                	beqz	a0,800038c6 <iunlock+0x3c>
    800038aa:	449c                	lw	a5,8(s1)
    800038ac:	00f05d63          	blez	a5,800038c6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800038b0:	854a                	mv	a0,s2
    800038b2:	00001097          	auipc	ra,0x1
    800038b6:	c44080e7          	jalr	-956(ra) # 800044f6 <releasesleep>
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	64a2                	ld	s1,8(sp)
    800038c0:	6902                	ld	s2,0(sp)
    800038c2:	6105                	addi	sp,sp,32
    800038c4:	8082                	ret
    panic("iunlock");
    800038c6:	00005517          	auipc	a0,0x5
    800038ca:	d3250513          	addi	a0,a0,-718 # 800085f8 <syscalls+0x1a8>
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	c6c080e7          	jalr	-916(ra) # 8000053a <panic>

00000000800038d6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800038d6:	7179                	addi	sp,sp,-48
    800038d8:	f406                	sd	ra,40(sp)
    800038da:	f022                	sd	s0,32(sp)
    800038dc:	ec26                	sd	s1,24(sp)
    800038de:	e84a                	sd	s2,16(sp)
    800038e0:	e44e                	sd	s3,8(sp)
    800038e2:	e052                	sd	s4,0(sp)
    800038e4:	1800                	addi	s0,sp,48
    800038e6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038e8:	05050493          	addi	s1,a0,80
    800038ec:	08050913          	addi	s2,a0,128
    800038f0:	a021                	j	800038f8 <itrunc+0x22>
    800038f2:	0491                	addi	s1,s1,4
    800038f4:	01248d63          	beq	s1,s2,8000390e <itrunc+0x38>
    if(ip->addrs[i]){
    800038f8:	408c                	lw	a1,0(s1)
    800038fa:	dde5                	beqz	a1,800038f2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800038fc:	0009a503          	lw	a0,0(s3)
    80003900:	00000097          	auipc	ra,0x0
    80003904:	90c080e7          	jalr	-1780(ra) # 8000320c <bfree>
      ip->addrs[i] = 0;
    80003908:	0004a023          	sw	zero,0(s1)
    8000390c:	b7dd                	j	800038f2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000390e:	0809a583          	lw	a1,128(s3)
    80003912:	e185                	bnez	a1,80003932 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003914:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003918:	854e                	mv	a0,s3
    8000391a:	00000097          	auipc	ra,0x0
    8000391e:	de2080e7          	jalr	-542(ra) # 800036fc <iupdate>
}
    80003922:	70a2                	ld	ra,40(sp)
    80003924:	7402                	ld	s0,32(sp)
    80003926:	64e2                	ld	s1,24(sp)
    80003928:	6942                	ld	s2,16(sp)
    8000392a:	69a2                	ld	s3,8(sp)
    8000392c:	6a02                	ld	s4,0(sp)
    8000392e:	6145                	addi	sp,sp,48
    80003930:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003932:	0009a503          	lw	a0,0(s3)
    80003936:	fffff097          	auipc	ra,0xfffff
    8000393a:	690080e7          	jalr	1680(ra) # 80002fc6 <bread>
    8000393e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003940:	05850493          	addi	s1,a0,88
    80003944:	45850913          	addi	s2,a0,1112
    80003948:	a021                	j	80003950 <itrunc+0x7a>
    8000394a:	0491                	addi	s1,s1,4
    8000394c:	01248b63          	beq	s1,s2,80003962 <itrunc+0x8c>
      if(a[j])
    80003950:	408c                	lw	a1,0(s1)
    80003952:	dde5                	beqz	a1,8000394a <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003954:	0009a503          	lw	a0,0(s3)
    80003958:	00000097          	auipc	ra,0x0
    8000395c:	8b4080e7          	jalr	-1868(ra) # 8000320c <bfree>
    80003960:	b7ed                	j	8000394a <itrunc+0x74>
    brelse(bp);
    80003962:	8552                	mv	a0,s4
    80003964:	fffff097          	auipc	ra,0xfffff
    80003968:	792080e7          	jalr	1938(ra) # 800030f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000396c:	0809a583          	lw	a1,128(s3)
    80003970:	0009a503          	lw	a0,0(s3)
    80003974:	00000097          	auipc	ra,0x0
    80003978:	898080e7          	jalr	-1896(ra) # 8000320c <bfree>
    ip->addrs[NDIRECT] = 0;
    8000397c:	0809a023          	sw	zero,128(s3)
    80003980:	bf51                	j	80003914 <itrunc+0x3e>

0000000080003982 <iput>:
{
    80003982:	1101                	addi	sp,sp,-32
    80003984:	ec06                	sd	ra,24(sp)
    80003986:	e822                	sd	s0,16(sp)
    80003988:	e426                	sd	s1,8(sp)
    8000398a:	e04a                	sd	s2,0(sp)
    8000398c:	1000                	addi	s0,sp,32
    8000398e:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003990:	00028517          	auipc	a0,0x28
    80003994:	e2050513          	addi	a0,a0,-480 # 8002b7b0 <icache>
    80003998:	ffffd097          	auipc	ra,0xffffd
    8000399c:	238080e7          	jalr	568(ra) # 80000bd0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039a0:	4498                	lw	a4,8(s1)
    800039a2:	4785                	li	a5,1
    800039a4:	02f70363          	beq	a4,a5,800039ca <iput+0x48>
  ip->ref--;
    800039a8:	449c                	lw	a5,8(s1)
    800039aa:	37fd                	addiw	a5,a5,-1
    800039ac:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800039ae:	00028517          	auipc	a0,0x28
    800039b2:	e0250513          	addi	a0,a0,-510 # 8002b7b0 <icache>
    800039b6:	ffffd097          	auipc	ra,0xffffd
    800039ba:	2ce080e7          	jalr	718(ra) # 80000c84 <release>
}
    800039be:	60e2                	ld	ra,24(sp)
    800039c0:	6442                	ld	s0,16(sp)
    800039c2:	64a2                	ld	s1,8(sp)
    800039c4:	6902                	ld	s2,0(sp)
    800039c6:	6105                	addi	sp,sp,32
    800039c8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039ca:	40bc                	lw	a5,64(s1)
    800039cc:	dff1                	beqz	a5,800039a8 <iput+0x26>
    800039ce:	04a49783          	lh	a5,74(s1)
    800039d2:	fbf9                	bnez	a5,800039a8 <iput+0x26>
    acquiresleep(&ip->lock);
    800039d4:	01048913          	addi	s2,s1,16
    800039d8:	854a                	mv	a0,s2
    800039da:	00001097          	auipc	ra,0x1
    800039de:	ac6080e7          	jalr	-1338(ra) # 800044a0 <acquiresleep>
    release(&icache.lock);
    800039e2:	00028517          	auipc	a0,0x28
    800039e6:	dce50513          	addi	a0,a0,-562 # 8002b7b0 <icache>
    800039ea:	ffffd097          	auipc	ra,0xffffd
    800039ee:	29a080e7          	jalr	666(ra) # 80000c84 <release>
    itrunc(ip);
    800039f2:	8526                	mv	a0,s1
    800039f4:	00000097          	auipc	ra,0x0
    800039f8:	ee2080e7          	jalr	-286(ra) # 800038d6 <itrunc>
    ip->type = 0;
    800039fc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a00:	8526                	mv	a0,s1
    80003a02:	00000097          	auipc	ra,0x0
    80003a06:	cfa080e7          	jalr	-774(ra) # 800036fc <iupdate>
    ip->valid = 0;
    80003a0a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a0e:	854a                	mv	a0,s2
    80003a10:	00001097          	auipc	ra,0x1
    80003a14:	ae6080e7          	jalr	-1306(ra) # 800044f6 <releasesleep>
    acquire(&icache.lock);
    80003a18:	00028517          	auipc	a0,0x28
    80003a1c:	d9850513          	addi	a0,a0,-616 # 8002b7b0 <icache>
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	1b0080e7          	jalr	432(ra) # 80000bd0 <acquire>
    80003a28:	b741                	j	800039a8 <iput+0x26>

0000000080003a2a <iunlockput>:
{
    80003a2a:	1101                	addi	sp,sp,-32
    80003a2c:	ec06                	sd	ra,24(sp)
    80003a2e:	e822                	sd	s0,16(sp)
    80003a30:	e426                	sd	s1,8(sp)
    80003a32:	1000                	addi	s0,sp,32
    80003a34:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a36:	00000097          	auipc	ra,0x0
    80003a3a:	e54080e7          	jalr	-428(ra) # 8000388a <iunlock>
  iput(ip);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	f42080e7          	jalr	-190(ra) # 80003982 <iput>
}
    80003a48:	60e2                	ld	ra,24(sp)
    80003a4a:	6442                	ld	s0,16(sp)
    80003a4c:	64a2                	ld	s1,8(sp)
    80003a4e:	6105                	addi	sp,sp,32
    80003a50:	8082                	ret

0000000080003a52 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a52:	1141                	addi	sp,sp,-16
    80003a54:	e422                	sd	s0,8(sp)
    80003a56:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a58:	411c                	lw	a5,0(a0)
    80003a5a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a5c:	415c                	lw	a5,4(a0)
    80003a5e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a60:	04451783          	lh	a5,68(a0)
    80003a64:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a68:	04a51783          	lh	a5,74(a0)
    80003a6c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a70:	04c56783          	lwu	a5,76(a0)
    80003a74:	e99c                	sd	a5,16(a1)
}
    80003a76:	6422                	ld	s0,8(sp)
    80003a78:	0141                	addi	sp,sp,16
    80003a7a:	8082                	ret

0000000080003a7c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a7c:	457c                	lw	a5,76(a0)
    80003a7e:	0ed7e963          	bltu	a5,a3,80003b70 <readi+0xf4>
{
    80003a82:	7159                	addi	sp,sp,-112
    80003a84:	f486                	sd	ra,104(sp)
    80003a86:	f0a2                	sd	s0,96(sp)
    80003a88:	eca6                	sd	s1,88(sp)
    80003a8a:	e8ca                	sd	s2,80(sp)
    80003a8c:	e4ce                	sd	s3,72(sp)
    80003a8e:	e0d2                	sd	s4,64(sp)
    80003a90:	fc56                	sd	s5,56(sp)
    80003a92:	f85a                	sd	s6,48(sp)
    80003a94:	f45e                	sd	s7,40(sp)
    80003a96:	f062                	sd	s8,32(sp)
    80003a98:	ec66                	sd	s9,24(sp)
    80003a9a:	e86a                	sd	s10,16(sp)
    80003a9c:	e46e                	sd	s11,8(sp)
    80003a9e:	1880                	addi	s0,sp,112
    80003aa0:	8baa                	mv	s7,a0
    80003aa2:	8c2e                	mv	s8,a1
    80003aa4:	8ab2                	mv	s5,a2
    80003aa6:	84b6                	mv	s1,a3
    80003aa8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003aaa:	9f35                	addw	a4,a4,a3
    return 0;
    80003aac:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003aae:	0ad76063          	bltu	a4,a3,80003b4e <readi+0xd2>
  if(off + n > ip->size)
    80003ab2:	00e7f463          	bgeu	a5,a4,80003aba <readi+0x3e>
    n = ip->size - off;
    80003ab6:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aba:	0a0b0963          	beqz	s6,80003b6c <readi+0xf0>
    80003abe:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ac0:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ac4:	5cfd                	li	s9,-1
    80003ac6:	a82d                	j	80003b00 <readi+0x84>
    80003ac8:	020a1d93          	slli	s11,s4,0x20
    80003acc:	020ddd93          	srli	s11,s11,0x20
    80003ad0:	05890613          	addi	a2,s2,88
    80003ad4:	86ee                	mv	a3,s11
    80003ad6:	963a                	add	a2,a2,a4
    80003ad8:	85d6                	mv	a1,s5
    80003ada:	8562                	mv	a0,s8
    80003adc:	fffff097          	auipc	ra,0xfffff
    80003ae0:	b08080e7          	jalr	-1272(ra) # 800025e4 <either_copyout>
    80003ae4:	05950d63          	beq	a0,s9,80003b3e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ae8:	854a                	mv	a0,s2
    80003aea:	fffff097          	auipc	ra,0xfffff
    80003aee:	60c080e7          	jalr	1548(ra) # 800030f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003af2:	013a09bb          	addw	s3,s4,s3
    80003af6:	009a04bb          	addw	s1,s4,s1
    80003afa:	9aee                	add	s5,s5,s11
    80003afc:	0569f763          	bgeu	s3,s6,80003b4a <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b00:	000ba903          	lw	s2,0(s7)
    80003b04:	00a4d59b          	srliw	a1,s1,0xa
    80003b08:	855e                	mv	a0,s7
    80003b0a:	00000097          	auipc	ra,0x0
    80003b0e:	8ac080e7          	jalr	-1876(ra) # 800033b6 <bmap>
    80003b12:	0005059b          	sext.w	a1,a0
    80003b16:	854a                	mv	a0,s2
    80003b18:	fffff097          	auipc	ra,0xfffff
    80003b1c:	4ae080e7          	jalr	1198(ra) # 80002fc6 <bread>
    80003b20:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b22:	3ff4f713          	andi	a4,s1,1023
    80003b26:	40ed07bb          	subw	a5,s10,a4
    80003b2a:	413b06bb          	subw	a3,s6,s3
    80003b2e:	8a3e                	mv	s4,a5
    80003b30:	2781                	sext.w	a5,a5
    80003b32:	0006861b          	sext.w	a2,a3
    80003b36:	f8f679e3          	bgeu	a2,a5,80003ac8 <readi+0x4c>
    80003b3a:	8a36                	mv	s4,a3
    80003b3c:	b771                	j	80003ac8 <readi+0x4c>
      brelse(bp);
    80003b3e:	854a                	mv	a0,s2
    80003b40:	fffff097          	auipc	ra,0xfffff
    80003b44:	5b6080e7          	jalr	1462(ra) # 800030f6 <brelse>
      tot = -1;
    80003b48:	59fd                	li	s3,-1
  }
  return tot;
    80003b4a:	0009851b          	sext.w	a0,s3
}
    80003b4e:	70a6                	ld	ra,104(sp)
    80003b50:	7406                	ld	s0,96(sp)
    80003b52:	64e6                	ld	s1,88(sp)
    80003b54:	6946                	ld	s2,80(sp)
    80003b56:	69a6                	ld	s3,72(sp)
    80003b58:	6a06                	ld	s4,64(sp)
    80003b5a:	7ae2                	ld	s5,56(sp)
    80003b5c:	7b42                	ld	s6,48(sp)
    80003b5e:	7ba2                	ld	s7,40(sp)
    80003b60:	7c02                	ld	s8,32(sp)
    80003b62:	6ce2                	ld	s9,24(sp)
    80003b64:	6d42                	ld	s10,16(sp)
    80003b66:	6da2                	ld	s11,8(sp)
    80003b68:	6165                	addi	sp,sp,112
    80003b6a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b6c:	89da                	mv	s3,s6
    80003b6e:	bff1                	j	80003b4a <readi+0xce>
    return 0;
    80003b70:	4501                	li	a0,0
}
    80003b72:	8082                	ret

0000000080003b74 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b74:	457c                	lw	a5,76(a0)
    80003b76:	10d7e863          	bltu	a5,a3,80003c86 <writei+0x112>
{
    80003b7a:	7159                	addi	sp,sp,-112
    80003b7c:	f486                	sd	ra,104(sp)
    80003b7e:	f0a2                	sd	s0,96(sp)
    80003b80:	eca6                	sd	s1,88(sp)
    80003b82:	e8ca                	sd	s2,80(sp)
    80003b84:	e4ce                	sd	s3,72(sp)
    80003b86:	e0d2                	sd	s4,64(sp)
    80003b88:	fc56                	sd	s5,56(sp)
    80003b8a:	f85a                	sd	s6,48(sp)
    80003b8c:	f45e                	sd	s7,40(sp)
    80003b8e:	f062                	sd	s8,32(sp)
    80003b90:	ec66                	sd	s9,24(sp)
    80003b92:	e86a                	sd	s10,16(sp)
    80003b94:	e46e                	sd	s11,8(sp)
    80003b96:	1880                	addi	s0,sp,112
    80003b98:	8b2a                	mv	s6,a0
    80003b9a:	8c2e                	mv	s8,a1
    80003b9c:	8ab2                	mv	s5,a2
    80003b9e:	8936                	mv	s2,a3
    80003ba0:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003ba2:	00e687bb          	addw	a5,a3,a4
    80003ba6:	0ed7e263          	bltu	a5,a3,80003c8a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003baa:	00043737          	lui	a4,0x43
    80003bae:	0ef76063          	bltu	a4,a5,80003c8e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bb2:	0c0b8863          	beqz	s7,80003c82 <writei+0x10e>
    80003bb6:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bb8:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003bbc:	5cfd                	li	s9,-1
    80003bbe:	a091                	j	80003c02 <writei+0x8e>
    80003bc0:	02099d93          	slli	s11,s3,0x20
    80003bc4:	020ddd93          	srli	s11,s11,0x20
    80003bc8:	05848513          	addi	a0,s1,88
    80003bcc:	86ee                	mv	a3,s11
    80003bce:	8656                	mv	a2,s5
    80003bd0:	85e2                	mv	a1,s8
    80003bd2:	953a                	add	a0,a0,a4
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	a66080e7          	jalr	-1434(ra) # 8000263a <either_copyin>
    80003bdc:	07950263          	beq	a0,s9,80003c40 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003be0:	8526                	mv	a0,s1
    80003be2:	00000097          	auipc	ra,0x0
    80003be6:	798080e7          	jalr	1944(ra) # 8000437a <log_write>
    brelse(bp);
    80003bea:	8526                	mv	a0,s1
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	50a080e7          	jalr	1290(ra) # 800030f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bf4:	01498a3b          	addw	s4,s3,s4
    80003bf8:	0129893b          	addw	s2,s3,s2
    80003bfc:	9aee                	add	s5,s5,s11
    80003bfe:	057a7663          	bgeu	s4,s7,80003c4a <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003c02:	000b2483          	lw	s1,0(s6)
    80003c06:	00a9559b          	srliw	a1,s2,0xa
    80003c0a:	855a                	mv	a0,s6
    80003c0c:	fffff097          	auipc	ra,0xfffff
    80003c10:	7aa080e7          	jalr	1962(ra) # 800033b6 <bmap>
    80003c14:	0005059b          	sext.w	a1,a0
    80003c18:	8526                	mv	a0,s1
    80003c1a:	fffff097          	auipc	ra,0xfffff
    80003c1e:	3ac080e7          	jalr	940(ra) # 80002fc6 <bread>
    80003c22:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c24:	3ff97713          	andi	a4,s2,1023
    80003c28:	40ed07bb          	subw	a5,s10,a4
    80003c2c:	414b86bb          	subw	a3,s7,s4
    80003c30:	89be                	mv	s3,a5
    80003c32:	2781                	sext.w	a5,a5
    80003c34:	0006861b          	sext.w	a2,a3
    80003c38:	f8f674e3          	bgeu	a2,a5,80003bc0 <writei+0x4c>
    80003c3c:	89b6                	mv	s3,a3
    80003c3e:	b749                	j	80003bc0 <writei+0x4c>
      brelse(bp);
    80003c40:	8526                	mv	a0,s1
    80003c42:	fffff097          	auipc	ra,0xfffff
    80003c46:	4b4080e7          	jalr	1204(ra) # 800030f6 <brelse>
  }

  if(off > ip->size)
    80003c4a:	04cb2783          	lw	a5,76(s6)
    80003c4e:	0127f463          	bgeu	a5,s2,80003c56 <writei+0xe2>
    ip->size = off;
    80003c52:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c56:	855a                	mv	a0,s6
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	aa4080e7          	jalr	-1372(ra) # 800036fc <iupdate>

  return tot;
    80003c60:	000a051b          	sext.w	a0,s4
}
    80003c64:	70a6                	ld	ra,104(sp)
    80003c66:	7406                	ld	s0,96(sp)
    80003c68:	64e6                	ld	s1,88(sp)
    80003c6a:	6946                	ld	s2,80(sp)
    80003c6c:	69a6                	ld	s3,72(sp)
    80003c6e:	6a06                	ld	s4,64(sp)
    80003c70:	7ae2                	ld	s5,56(sp)
    80003c72:	7b42                	ld	s6,48(sp)
    80003c74:	7ba2                	ld	s7,40(sp)
    80003c76:	7c02                	ld	s8,32(sp)
    80003c78:	6ce2                	ld	s9,24(sp)
    80003c7a:	6d42                	ld	s10,16(sp)
    80003c7c:	6da2                	ld	s11,8(sp)
    80003c7e:	6165                	addi	sp,sp,112
    80003c80:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c82:	8a5e                	mv	s4,s7
    80003c84:	bfc9                	j	80003c56 <writei+0xe2>
    return -1;
    80003c86:	557d                	li	a0,-1
}
    80003c88:	8082                	ret
    return -1;
    80003c8a:	557d                	li	a0,-1
    80003c8c:	bfe1                	j	80003c64 <writei+0xf0>
    return -1;
    80003c8e:	557d                	li	a0,-1
    80003c90:	bfd1                	j	80003c64 <writei+0xf0>

0000000080003c92 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c92:	1141                	addi	sp,sp,-16
    80003c94:	e406                	sd	ra,8(sp)
    80003c96:	e022                	sd	s0,0(sp)
    80003c98:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c9a:	4639                	li	a2,14
    80003c9c:	ffffd097          	auipc	ra,0xffffd
    80003ca0:	108080e7          	jalr	264(ra) # 80000da4 <strncmp>
}
    80003ca4:	60a2                	ld	ra,8(sp)
    80003ca6:	6402                	ld	s0,0(sp)
    80003ca8:	0141                	addi	sp,sp,16
    80003caa:	8082                	ret

0000000080003cac <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003cac:	7139                	addi	sp,sp,-64
    80003cae:	fc06                	sd	ra,56(sp)
    80003cb0:	f822                	sd	s0,48(sp)
    80003cb2:	f426                	sd	s1,40(sp)
    80003cb4:	f04a                	sd	s2,32(sp)
    80003cb6:	ec4e                	sd	s3,24(sp)
    80003cb8:	e852                	sd	s4,16(sp)
    80003cba:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003cbc:	04451703          	lh	a4,68(a0)
    80003cc0:	4785                	li	a5,1
    80003cc2:	00f71a63          	bne	a4,a5,80003cd6 <dirlookup+0x2a>
    80003cc6:	892a                	mv	s2,a0
    80003cc8:	89ae                	mv	s3,a1
    80003cca:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ccc:	457c                	lw	a5,76(a0)
    80003cce:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cd0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cd2:	e79d                	bnez	a5,80003d00 <dirlookup+0x54>
    80003cd4:	a8a5                	j	80003d4c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003cd6:	00005517          	auipc	a0,0x5
    80003cda:	92a50513          	addi	a0,a0,-1750 # 80008600 <syscalls+0x1b0>
    80003cde:	ffffd097          	auipc	ra,0xffffd
    80003ce2:	85c080e7          	jalr	-1956(ra) # 8000053a <panic>
      panic("dirlookup read");
    80003ce6:	00005517          	auipc	a0,0x5
    80003cea:	93250513          	addi	a0,a0,-1742 # 80008618 <syscalls+0x1c8>
    80003cee:	ffffd097          	auipc	ra,0xffffd
    80003cf2:	84c080e7          	jalr	-1972(ra) # 8000053a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cf6:	24c1                	addiw	s1,s1,16
    80003cf8:	04c92783          	lw	a5,76(s2)
    80003cfc:	04f4f763          	bgeu	s1,a5,80003d4a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d00:	4741                	li	a4,16
    80003d02:	86a6                	mv	a3,s1
    80003d04:	fc040613          	addi	a2,s0,-64
    80003d08:	4581                	li	a1,0
    80003d0a:	854a                	mv	a0,s2
    80003d0c:	00000097          	auipc	ra,0x0
    80003d10:	d70080e7          	jalr	-656(ra) # 80003a7c <readi>
    80003d14:	47c1                	li	a5,16
    80003d16:	fcf518e3          	bne	a0,a5,80003ce6 <dirlookup+0x3a>
    if(de.inum == 0)
    80003d1a:	fc045783          	lhu	a5,-64(s0)
    80003d1e:	dfe1                	beqz	a5,80003cf6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003d20:	fc240593          	addi	a1,s0,-62
    80003d24:	854e                	mv	a0,s3
    80003d26:	00000097          	auipc	ra,0x0
    80003d2a:	f6c080e7          	jalr	-148(ra) # 80003c92 <namecmp>
    80003d2e:	f561                	bnez	a0,80003cf6 <dirlookup+0x4a>
      if(poff)
    80003d30:	000a0463          	beqz	s4,80003d38 <dirlookup+0x8c>
        *poff = off;
    80003d34:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d38:	fc045583          	lhu	a1,-64(s0)
    80003d3c:	00092503          	lw	a0,0(s2)
    80003d40:	fffff097          	auipc	ra,0xfffff
    80003d44:	752080e7          	jalr	1874(ra) # 80003492 <iget>
    80003d48:	a011                	j	80003d4c <dirlookup+0xa0>
  return 0;
    80003d4a:	4501                	li	a0,0
}
    80003d4c:	70e2                	ld	ra,56(sp)
    80003d4e:	7442                	ld	s0,48(sp)
    80003d50:	74a2                	ld	s1,40(sp)
    80003d52:	7902                	ld	s2,32(sp)
    80003d54:	69e2                	ld	s3,24(sp)
    80003d56:	6a42                	ld	s4,16(sp)
    80003d58:	6121                	addi	sp,sp,64
    80003d5a:	8082                	ret

0000000080003d5c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d5c:	711d                	addi	sp,sp,-96
    80003d5e:	ec86                	sd	ra,88(sp)
    80003d60:	e8a2                	sd	s0,80(sp)
    80003d62:	e4a6                	sd	s1,72(sp)
    80003d64:	e0ca                	sd	s2,64(sp)
    80003d66:	fc4e                	sd	s3,56(sp)
    80003d68:	f852                	sd	s4,48(sp)
    80003d6a:	f456                	sd	s5,40(sp)
    80003d6c:	f05a                	sd	s6,32(sp)
    80003d6e:	ec5e                	sd	s7,24(sp)
    80003d70:	e862                	sd	s8,16(sp)
    80003d72:	e466                	sd	s9,8(sp)
    80003d74:	e06a                	sd	s10,0(sp)
    80003d76:	1080                	addi	s0,sp,96
    80003d78:	84aa                	mv	s1,a0
    80003d7a:	8b2e                	mv	s6,a1
    80003d7c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d7e:	00054703          	lbu	a4,0(a0)
    80003d82:	02f00793          	li	a5,47
    80003d86:	02f70363          	beq	a4,a5,80003dac <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d8a:	ffffe097          	auipc	ra,0xffffe
    80003d8e:	d52080e7          	jalr	-686(ra) # 80001adc <myproc>
    80003d92:	15053503          	ld	a0,336(a0)
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	9f4080e7          	jalr	-1548(ra) # 8000378a <idup>
    80003d9e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003da0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003da4:	4cb5                	li	s9,13
  len = path - s;
    80003da6:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003da8:	4c05                	li	s8,1
    80003daa:	a87d                	j	80003e68 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003dac:	4585                	li	a1,1
    80003dae:	4505                	li	a0,1
    80003db0:	fffff097          	auipc	ra,0xfffff
    80003db4:	6e2080e7          	jalr	1762(ra) # 80003492 <iget>
    80003db8:	8a2a                	mv	s4,a0
    80003dba:	b7dd                	j	80003da0 <namex+0x44>
      iunlockput(ip);
    80003dbc:	8552                	mv	a0,s4
    80003dbe:	00000097          	auipc	ra,0x0
    80003dc2:	c6c080e7          	jalr	-916(ra) # 80003a2a <iunlockput>
      return 0;
    80003dc6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003dc8:	8552                	mv	a0,s4
    80003dca:	60e6                	ld	ra,88(sp)
    80003dcc:	6446                	ld	s0,80(sp)
    80003dce:	64a6                	ld	s1,72(sp)
    80003dd0:	6906                	ld	s2,64(sp)
    80003dd2:	79e2                	ld	s3,56(sp)
    80003dd4:	7a42                	ld	s4,48(sp)
    80003dd6:	7aa2                	ld	s5,40(sp)
    80003dd8:	7b02                	ld	s6,32(sp)
    80003dda:	6be2                	ld	s7,24(sp)
    80003ddc:	6c42                	ld	s8,16(sp)
    80003dde:	6ca2                	ld	s9,8(sp)
    80003de0:	6d02                	ld	s10,0(sp)
    80003de2:	6125                	addi	sp,sp,96
    80003de4:	8082                	ret
      iunlock(ip);
    80003de6:	8552                	mv	a0,s4
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	aa2080e7          	jalr	-1374(ra) # 8000388a <iunlock>
      return ip;
    80003df0:	bfe1                	j	80003dc8 <namex+0x6c>
      iunlockput(ip);
    80003df2:	8552                	mv	a0,s4
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	c36080e7          	jalr	-970(ra) # 80003a2a <iunlockput>
      return 0;
    80003dfc:	8a4e                	mv	s4,s3
    80003dfe:	b7e9                	j	80003dc8 <namex+0x6c>
  len = path - s;
    80003e00:	40998633          	sub	a2,s3,s1
    80003e04:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003e08:	09acd863          	bge	s9,s10,80003e98 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003e0c:	4639                	li	a2,14
    80003e0e:	85a6                	mv	a1,s1
    80003e10:	8556                	mv	a0,s5
    80003e12:	ffffd097          	auipc	ra,0xffffd
    80003e16:	f16080e7          	jalr	-234(ra) # 80000d28 <memmove>
    80003e1a:	84ce                	mv	s1,s3
  while(*path == '/')
    80003e1c:	0004c783          	lbu	a5,0(s1)
    80003e20:	01279763          	bne	a5,s2,80003e2e <namex+0xd2>
    path++;
    80003e24:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e26:	0004c783          	lbu	a5,0(s1)
    80003e2a:	ff278de3          	beq	a5,s2,80003e24 <namex+0xc8>
    ilock(ip);
    80003e2e:	8552                	mv	a0,s4
    80003e30:	00000097          	auipc	ra,0x0
    80003e34:	998080e7          	jalr	-1640(ra) # 800037c8 <ilock>
    if(ip->type != T_DIR){
    80003e38:	044a1783          	lh	a5,68(s4)
    80003e3c:	f98790e3          	bne	a5,s8,80003dbc <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003e40:	000b0563          	beqz	s6,80003e4a <namex+0xee>
    80003e44:	0004c783          	lbu	a5,0(s1)
    80003e48:	dfd9                	beqz	a5,80003de6 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e4a:	865e                	mv	a2,s7
    80003e4c:	85d6                	mv	a1,s5
    80003e4e:	8552                	mv	a0,s4
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	e5c080e7          	jalr	-420(ra) # 80003cac <dirlookup>
    80003e58:	89aa                	mv	s3,a0
    80003e5a:	dd41                	beqz	a0,80003df2 <namex+0x96>
    iunlockput(ip);
    80003e5c:	8552                	mv	a0,s4
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	bcc080e7          	jalr	-1076(ra) # 80003a2a <iunlockput>
    ip = next;
    80003e66:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e68:	0004c783          	lbu	a5,0(s1)
    80003e6c:	01279763          	bne	a5,s2,80003e7a <namex+0x11e>
    path++;
    80003e70:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e72:	0004c783          	lbu	a5,0(s1)
    80003e76:	ff278de3          	beq	a5,s2,80003e70 <namex+0x114>
  if(*path == 0)
    80003e7a:	cb9d                	beqz	a5,80003eb0 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003e7c:	0004c783          	lbu	a5,0(s1)
    80003e80:	89a6                	mv	s3,s1
  len = path - s;
    80003e82:	8d5e                	mv	s10,s7
    80003e84:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003e86:	01278963          	beq	a5,s2,80003e98 <namex+0x13c>
    80003e8a:	dbbd                	beqz	a5,80003e00 <namex+0xa4>
    path++;
    80003e8c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e8e:	0009c783          	lbu	a5,0(s3)
    80003e92:	ff279ce3          	bne	a5,s2,80003e8a <namex+0x12e>
    80003e96:	b7ad                	j	80003e00 <namex+0xa4>
    memmove(name, s, len);
    80003e98:	2601                	sext.w	a2,a2
    80003e9a:	85a6                	mv	a1,s1
    80003e9c:	8556                	mv	a0,s5
    80003e9e:	ffffd097          	auipc	ra,0xffffd
    80003ea2:	e8a080e7          	jalr	-374(ra) # 80000d28 <memmove>
    name[len] = 0;
    80003ea6:	9d56                	add	s10,s10,s5
    80003ea8:	000d0023          	sb	zero,0(s10)
    80003eac:	84ce                	mv	s1,s3
    80003eae:	b7bd                	j	80003e1c <namex+0xc0>
  if(nameiparent){
    80003eb0:	f00b0ce3          	beqz	s6,80003dc8 <namex+0x6c>
    iput(ip);
    80003eb4:	8552                	mv	a0,s4
    80003eb6:	00000097          	auipc	ra,0x0
    80003eba:	acc080e7          	jalr	-1332(ra) # 80003982 <iput>
    return 0;
    80003ebe:	4a01                	li	s4,0
    80003ec0:	b721                	j	80003dc8 <namex+0x6c>

0000000080003ec2 <dirlink>:
{
    80003ec2:	7139                	addi	sp,sp,-64
    80003ec4:	fc06                	sd	ra,56(sp)
    80003ec6:	f822                	sd	s0,48(sp)
    80003ec8:	f426                	sd	s1,40(sp)
    80003eca:	f04a                	sd	s2,32(sp)
    80003ecc:	ec4e                	sd	s3,24(sp)
    80003ece:	e852                	sd	s4,16(sp)
    80003ed0:	0080                	addi	s0,sp,64
    80003ed2:	892a                	mv	s2,a0
    80003ed4:	8a2e                	mv	s4,a1
    80003ed6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ed8:	4601                	li	a2,0
    80003eda:	00000097          	auipc	ra,0x0
    80003ede:	dd2080e7          	jalr	-558(ra) # 80003cac <dirlookup>
    80003ee2:	e93d                	bnez	a0,80003f58 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ee4:	04c92483          	lw	s1,76(s2)
    80003ee8:	c49d                	beqz	s1,80003f16 <dirlink+0x54>
    80003eea:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eec:	4741                	li	a4,16
    80003eee:	86a6                	mv	a3,s1
    80003ef0:	fc040613          	addi	a2,s0,-64
    80003ef4:	4581                	li	a1,0
    80003ef6:	854a                	mv	a0,s2
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	b84080e7          	jalr	-1148(ra) # 80003a7c <readi>
    80003f00:	47c1                	li	a5,16
    80003f02:	06f51163          	bne	a0,a5,80003f64 <dirlink+0xa2>
    if(de.inum == 0)
    80003f06:	fc045783          	lhu	a5,-64(s0)
    80003f0a:	c791                	beqz	a5,80003f16 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f0c:	24c1                	addiw	s1,s1,16
    80003f0e:	04c92783          	lw	a5,76(s2)
    80003f12:	fcf4ede3          	bltu	s1,a5,80003eec <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003f16:	4639                	li	a2,14
    80003f18:	85d2                	mv	a1,s4
    80003f1a:	fc240513          	addi	a0,s0,-62
    80003f1e:	ffffd097          	auipc	ra,0xffffd
    80003f22:	ec2080e7          	jalr	-318(ra) # 80000de0 <strncpy>
  de.inum = inum;
    80003f26:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f2a:	4741                	li	a4,16
    80003f2c:	86a6                	mv	a3,s1
    80003f2e:	fc040613          	addi	a2,s0,-64
    80003f32:	4581                	li	a1,0
    80003f34:	854a                	mv	a0,s2
    80003f36:	00000097          	auipc	ra,0x0
    80003f3a:	c3e080e7          	jalr	-962(ra) # 80003b74 <writei>
    80003f3e:	872a                	mv	a4,a0
    80003f40:	47c1                	li	a5,16
  return 0;
    80003f42:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f44:	02f71863          	bne	a4,a5,80003f74 <dirlink+0xb2>
}
    80003f48:	70e2                	ld	ra,56(sp)
    80003f4a:	7442                	ld	s0,48(sp)
    80003f4c:	74a2                	ld	s1,40(sp)
    80003f4e:	7902                	ld	s2,32(sp)
    80003f50:	69e2                	ld	s3,24(sp)
    80003f52:	6a42                	ld	s4,16(sp)
    80003f54:	6121                	addi	sp,sp,64
    80003f56:	8082                	ret
    iput(ip);
    80003f58:	00000097          	auipc	ra,0x0
    80003f5c:	a2a080e7          	jalr	-1494(ra) # 80003982 <iput>
    return -1;
    80003f60:	557d                	li	a0,-1
    80003f62:	b7dd                	j	80003f48 <dirlink+0x86>
      panic("dirlink read");
    80003f64:	00004517          	auipc	a0,0x4
    80003f68:	6c450513          	addi	a0,a0,1732 # 80008628 <syscalls+0x1d8>
    80003f6c:	ffffc097          	auipc	ra,0xffffc
    80003f70:	5ce080e7          	jalr	1486(ra) # 8000053a <panic>
    panic("dirlink");
    80003f74:	00004517          	auipc	a0,0x4
    80003f78:	7c450513          	addi	a0,a0,1988 # 80008738 <syscalls+0x2e8>
    80003f7c:	ffffc097          	auipc	ra,0xffffc
    80003f80:	5be080e7          	jalr	1470(ra) # 8000053a <panic>

0000000080003f84 <namei>:

struct inode*
namei(char *path)
{
    80003f84:	1101                	addi	sp,sp,-32
    80003f86:	ec06                	sd	ra,24(sp)
    80003f88:	e822                	sd	s0,16(sp)
    80003f8a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f8c:	fe040613          	addi	a2,s0,-32
    80003f90:	4581                	li	a1,0
    80003f92:	00000097          	auipc	ra,0x0
    80003f96:	dca080e7          	jalr	-566(ra) # 80003d5c <namex>
}
    80003f9a:	60e2                	ld	ra,24(sp)
    80003f9c:	6442                	ld	s0,16(sp)
    80003f9e:	6105                	addi	sp,sp,32
    80003fa0:	8082                	ret

0000000080003fa2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003fa2:	1141                	addi	sp,sp,-16
    80003fa4:	e406                	sd	ra,8(sp)
    80003fa6:	e022                	sd	s0,0(sp)
    80003fa8:	0800                	addi	s0,sp,16
    80003faa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003fac:	4585                	li	a1,1
    80003fae:	00000097          	auipc	ra,0x0
    80003fb2:	dae080e7          	jalr	-594(ra) # 80003d5c <namex>
}
    80003fb6:	60a2                	ld	ra,8(sp)
    80003fb8:	6402                	ld	s0,0(sp)
    80003fba:	0141                	addi	sp,sp,16
    80003fbc:	8082                	ret

0000000080003fbe <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003fbe:	1101                	addi	sp,sp,-32
    80003fc0:	ec06                	sd	ra,24(sp)
    80003fc2:	e822                	sd	s0,16(sp)
    80003fc4:	e426                	sd	s1,8(sp)
    80003fc6:	e04a                	sd	s2,0(sp)
    80003fc8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003fca:	00029917          	auipc	s2,0x29
    80003fce:	28e90913          	addi	s2,s2,654 # 8002d258 <log>
    80003fd2:	01892583          	lw	a1,24(s2)
    80003fd6:	02892503          	lw	a0,40(s2)
    80003fda:	fffff097          	auipc	ra,0xfffff
    80003fde:	fec080e7          	jalr	-20(ra) # 80002fc6 <bread>
    80003fe2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003fe4:	02c92683          	lw	a3,44(s2)
    80003fe8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003fea:	02d05863          	blez	a3,8000401a <write_head+0x5c>
    80003fee:	00029797          	auipc	a5,0x29
    80003ff2:	29a78793          	addi	a5,a5,666 # 8002d288 <log+0x30>
    80003ff6:	05c50713          	addi	a4,a0,92
    80003ffa:	36fd                	addiw	a3,a3,-1
    80003ffc:	02069613          	slli	a2,a3,0x20
    80004000:	01e65693          	srli	a3,a2,0x1e
    80004004:	00029617          	auipc	a2,0x29
    80004008:	28860613          	addi	a2,a2,648 # 8002d28c <log+0x34>
    8000400c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000400e:	4390                	lw	a2,0(a5)
    80004010:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004012:	0791                	addi	a5,a5,4
    80004014:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80004016:	fed79ce3          	bne	a5,a3,8000400e <write_head+0x50>
  }
  bwrite(buf);
    8000401a:	8526                	mv	a0,s1
    8000401c:	fffff097          	auipc	ra,0xfffff
    80004020:	09c080e7          	jalr	156(ra) # 800030b8 <bwrite>
  brelse(buf);
    80004024:	8526                	mv	a0,s1
    80004026:	fffff097          	auipc	ra,0xfffff
    8000402a:	0d0080e7          	jalr	208(ra) # 800030f6 <brelse>
}
    8000402e:	60e2                	ld	ra,24(sp)
    80004030:	6442                	ld	s0,16(sp)
    80004032:	64a2                	ld	s1,8(sp)
    80004034:	6902                	ld	s2,0(sp)
    80004036:	6105                	addi	sp,sp,32
    80004038:	8082                	ret

000000008000403a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000403a:	00029797          	auipc	a5,0x29
    8000403e:	24a7a783          	lw	a5,586(a5) # 8002d284 <log+0x2c>
    80004042:	0af05d63          	blez	a5,800040fc <install_trans+0xc2>
{
    80004046:	7139                	addi	sp,sp,-64
    80004048:	fc06                	sd	ra,56(sp)
    8000404a:	f822                	sd	s0,48(sp)
    8000404c:	f426                	sd	s1,40(sp)
    8000404e:	f04a                	sd	s2,32(sp)
    80004050:	ec4e                	sd	s3,24(sp)
    80004052:	e852                	sd	s4,16(sp)
    80004054:	e456                	sd	s5,8(sp)
    80004056:	e05a                	sd	s6,0(sp)
    80004058:	0080                	addi	s0,sp,64
    8000405a:	8b2a                	mv	s6,a0
    8000405c:	00029a97          	auipc	s5,0x29
    80004060:	22ca8a93          	addi	s5,s5,556 # 8002d288 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004064:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004066:	00029997          	auipc	s3,0x29
    8000406a:	1f298993          	addi	s3,s3,498 # 8002d258 <log>
    8000406e:	a00d                	j	80004090 <install_trans+0x56>
    brelse(lbuf);
    80004070:	854a                	mv	a0,s2
    80004072:	fffff097          	auipc	ra,0xfffff
    80004076:	084080e7          	jalr	132(ra) # 800030f6 <brelse>
    brelse(dbuf);
    8000407a:	8526                	mv	a0,s1
    8000407c:	fffff097          	auipc	ra,0xfffff
    80004080:	07a080e7          	jalr	122(ra) # 800030f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004084:	2a05                	addiw	s4,s4,1
    80004086:	0a91                	addi	s5,s5,4
    80004088:	02c9a783          	lw	a5,44(s3)
    8000408c:	04fa5e63          	bge	s4,a5,800040e8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004090:	0189a583          	lw	a1,24(s3)
    80004094:	014585bb          	addw	a1,a1,s4
    80004098:	2585                	addiw	a1,a1,1
    8000409a:	0289a503          	lw	a0,40(s3)
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	f28080e7          	jalr	-216(ra) # 80002fc6 <bread>
    800040a6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800040a8:	000aa583          	lw	a1,0(s5)
    800040ac:	0289a503          	lw	a0,40(s3)
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	f16080e7          	jalr	-234(ra) # 80002fc6 <bread>
    800040b8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800040ba:	40000613          	li	a2,1024
    800040be:	05890593          	addi	a1,s2,88
    800040c2:	05850513          	addi	a0,a0,88
    800040c6:	ffffd097          	auipc	ra,0xffffd
    800040ca:	c62080e7          	jalr	-926(ra) # 80000d28 <memmove>
    bwrite(dbuf);  // write dst to disk
    800040ce:	8526                	mv	a0,s1
    800040d0:	fffff097          	auipc	ra,0xfffff
    800040d4:	fe8080e7          	jalr	-24(ra) # 800030b8 <bwrite>
    if(recovering == 0)
    800040d8:	f80b1ce3          	bnez	s6,80004070 <install_trans+0x36>
      bunpin(dbuf);
    800040dc:	8526                	mv	a0,s1
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	0f2080e7          	jalr	242(ra) # 800031d0 <bunpin>
    800040e6:	b769                	j	80004070 <install_trans+0x36>
}
    800040e8:	70e2                	ld	ra,56(sp)
    800040ea:	7442                	ld	s0,48(sp)
    800040ec:	74a2                	ld	s1,40(sp)
    800040ee:	7902                	ld	s2,32(sp)
    800040f0:	69e2                	ld	s3,24(sp)
    800040f2:	6a42                	ld	s4,16(sp)
    800040f4:	6aa2                	ld	s5,8(sp)
    800040f6:	6b02                	ld	s6,0(sp)
    800040f8:	6121                	addi	sp,sp,64
    800040fa:	8082                	ret
    800040fc:	8082                	ret

00000000800040fe <initlog>:
{
    800040fe:	7179                	addi	sp,sp,-48
    80004100:	f406                	sd	ra,40(sp)
    80004102:	f022                	sd	s0,32(sp)
    80004104:	ec26                	sd	s1,24(sp)
    80004106:	e84a                	sd	s2,16(sp)
    80004108:	e44e                	sd	s3,8(sp)
    8000410a:	1800                	addi	s0,sp,48
    8000410c:	892a                	mv	s2,a0
    8000410e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004110:	00029497          	auipc	s1,0x29
    80004114:	14848493          	addi	s1,s1,328 # 8002d258 <log>
    80004118:	00004597          	auipc	a1,0x4
    8000411c:	52058593          	addi	a1,a1,1312 # 80008638 <syscalls+0x1e8>
    80004120:	8526                	mv	a0,s1
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	a1e080e7          	jalr	-1506(ra) # 80000b40 <initlock>
  log.start = sb->logstart;
    8000412a:	0149a583          	lw	a1,20(s3)
    8000412e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004130:	0109a783          	lw	a5,16(s3)
    80004134:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004136:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000413a:	854a                	mv	a0,s2
    8000413c:	fffff097          	auipc	ra,0xfffff
    80004140:	e8a080e7          	jalr	-374(ra) # 80002fc6 <bread>
  log.lh.n = lh->n;
    80004144:	4d34                	lw	a3,88(a0)
    80004146:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004148:	02d05663          	blez	a3,80004174 <initlog+0x76>
    8000414c:	05c50793          	addi	a5,a0,92
    80004150:	00029717          	auipc	a4,0x29
    80004154:	13870713          	addi	a4,a4,312 # 8002d288 <log+0x30>
    80004158:	36fd                	addiw	a3,a3,-1
    8000415a:	02069613          	slli	a2,a3,0x20
    8000415e:	01e65693          	srli	a3,a2,0x1e
    80004162:	06050613          	addi	a2,a0,96
    80004166:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004168:	4390                	lw	a2,0(a5)
    8000416a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000416c:	0791                	addi	a5,a5,4
    8000416e:	0711                	addi	a4,a4,4
    80004170:	fed79ce3          	bne	a5,a3,80004168 <initlog+0x6a>
  brelse(buf);
    80004174:	fffff097          	auipc	ra,0xfffff
    80004178:	f82080e7          	jalr	-126(ra) # 800030f6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000417c:	4505                	li	a0,1
    8000417e:	00000097          	auipc	ra,0x0
    80004182:	ebc080e7          	jalr	-324(ra) # 8000403a <install_trans>
  log.lh.n = 0;
    80004186:	00029797          	auipc	a5,0x29
    8000418a:	0e07af23          	sw	zero,254(a5) # 8002d284 <log+0x2c>
  write_head(); // clear the log
    8000418e:	00000097          	auipc	ra,0x0
    80004192:	e30080e7          	jalr	-464(ra) # 80003fbe <write_head>
}
    80004196:	70a2                	ld	ra,40(sp)
    80004198:	7402                	ld	s0,32(sp)
    8000419a:	64e2                	ld	s1,24(sp)
    8000419c:	6942                	ld	s2,16(sp)
    8000419e:	69a2                	ld	s3,8(sp)
    800041a0:	6145                	addi	sp,sp,48
    800041a2:	8082                	ret

00000000800041a4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800041a4:	1101                	addi	sp,sp,-32
    800041a6:	ec06                	sd	ra,24(sp)
    800041a8:	e822                	sd	s0,16(sp)
    800041aa:	e426                	sd	s1,8(sp)
    800041ac:	e04a                	sd	s2,0(sp)
    800041ae:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800041b0:	00029517          	auipc	a0,0x29
    800041b4:	0a850513          	addi	a0,a0,168 # 8002d258 <log>
    800041b8:	ffffd097          	auipc	ra,0xffffd
    800041bc:	a18080e7          	jalr	-1512(ra) # 80000bd0 <acquire>
  while(1){
    if(log.committing){
    800041c0:	00029497          	auipc	s1,0x29
    800041c4:	09848493          	addi	s1,s1,152 # 8002d258 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041c8:	4979                	li	s2,30
    800041ca:	a039                	j	800041d8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800041cc:	85a6                	mv	a1,s1
    800041ce:	8526                	mv	a0,s1
    800041d0:	ffffe097          	auipc	ra,0xffffe
    800041d4:	1ba080e7          	jalr	442(ra) # 8000238a <sleep>
    if(log.committing){
    800041d8:	50dc                	lw	a5,36(s1)
    800041da:	fbed                	bnez	a5,800041cc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041dc:	5098                	lw	a4,32(s1)
    800041de:	2705                	addiw	a4,a4,1
    800041e0:	0007069b          	sext.w	a3,a4
    800041e4:	0027179b          	slliw	a5,a4,0x2
    800041e8:	9fb9                	addw	a5,a5,a4
    800041ea:	0017979b          	slliw	a5,a5,0x1
    800041ee:	54d8                	lw	a4,44(s1)
    800041f0:	9fb9                	addw	a5,a5,a4
    800041f2:	00f95963          	bge	s2,a5,80004204 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800041f6:	85a6                	mv	a1,s1
    800041f8:	8526                	mv	a0,s1
    800041fa:	ffffe097          	auipc	ra,0xffffe
    800041fe:	190080e7          	jalr	400(ra) # 8000238a <sleep>
    80004202:	bfd9                	j	800041d8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004204:	00029517          	auipc	a0,0x29
    80004208:	05450513          	addi	a0,a0,84 # 8002d258 <log>
    8000420c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000420e:	ffffd097          	auipc	ra,0xffffd
    80004212:	a76080e7          	jalr	-1418(ra) # 80000c84 <release>
      break;
    }
  }
}
    80004216:	60e2                	ld	ra,24(sp)
    80004218:	6442                	ld	s0,16(sp)
    8000421a:	64a2                	ld	s1,8(sp)
    8000421c:	6902                	ld	s2,0(sp)
    8000421e:	6105                	addi	sp,sp,32
    80004220:	8082                	ret

0000000080004222 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004222:	7139                	addi	sp,sp,-64
    80004224:	fc06                	sd	ra,56(sp)
    80004226:	f822                	sd	s0,48(sp)
    80004228:	f426                	sd	s1,40(sp)
    8000422a:	f04a                	sd	s2,32(sp)
    8000422c:	ec4e                	sd	s3,24(sp)
    8000422e:	e852                	sd	s4,16(sp)
    80004230:	e456                	sd	s5,8(sp)
    80004232:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004234:	00029497          	auipc	s1,0x29
    80004238:	02448493          	addi	s1,s1,36 # 8002d258 <log>
    8000423c:	8526                	mv	a0,s1
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	992080e7          	jalr	-1646(ra) # 80000bd0 <acquire>
  log.outstanding -= 1;
    80004246:	509c                	lw	a5,32(s1)
    80004248:	37fd                	addiw	a5,a5,-1
    8000424a:	0007891b          	sext.w	s2,a5
    8000424e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004250:	50dc                	lw	a5,36(s1)
    80004252:	e7b9                	bnez	a5,800042a0 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004254:	04091e63          	bnez	s2,800042b0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004258:	00029497          	auipc	s1,0x29
    8000425c:	00048493          	mv	s1,s1
    80004260:	4785                	li	a5,1
    80004262:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004264:	8526                	mv	a0,s1
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	a1e080e7          	jalr	-1506(ra) # 80000c84 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000426e:	54dc                	lw	a5,44(s1)
    80004270:	06f04763          	bgtz	a5,800042de <end_op+0xbc>
    acquire(&log.lock);
    80004274:	00029497          	auipc	s1,0x29
    80004278:	fe448493          	addi	s1,s1,-28 # 8002d258 <log>
    8000427c:	8526                	mv	a0,s1
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	952080e7          	jalr	-1710(ra) # 80000bd0 <acquire>
    log.committing = 0;
    80004286:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000428a:	8526                	mv	a0,s1
    8000428c:	ffffe097          	auipc	ra,0xffffe
    80004290:	27e080e7          	jalr	638(ra) # 8000250a <wakeup>
    release(&log.lock);
    80004294:	8526                	mv	a0,s1
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	9ee080e7          	jalr	-1554(ra) # 80000c84 <release>
}
    8000429e:	a03d                	j	800042cc <end_op+0xaa>
    panic("log.committing");
    800042a0:	00004517          	auipc	a0,0x4
    800042a4:	3a050513          	addi	a0,a0,928 # 80008640 <syscalls+0x1f0>
    800042a8:	ffffc097          	auipc	ra,0xffffc
    800042ac:	292080e7          	jalr	658(ra) # 8000053a <panic>
    wakeup(&log);
    800042b0:	00029497          	auipc	s1,0x29
    800042b4:	fa848493          	addi	s1,s1,-88 # 8002d258 <log>
    800042b8:	8526                	mv	a0,s1
    800042ba:	ffffe097          	auipc	ra,0xffffe
    800042be:	250080e7          	jalr	592(ra) # 8000250a <wakeup>
  release(&log.lock);
    800042c2:	8526                	mv	a0,s1
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	9c0080e7          	jalr	-1600(ra) # 80000c84 <release>
}
    800042cc:	70e2                	ld	ra,56(sp)
    800042ce:	7442                	ld	s0,48(sp)
    800042d0:	74a2                	ld	s1,40(sp)
    800042d2:	7902                	ld	s2,32(sp)
    800042d4:	69e2                	ld	s3,24(sp)
    800042d6:	6a42                	ld	s4,16(sp)
    800042d8:	6aa2                	ld	s5,8(sp)
    800042da:	6121                	addi	sp,sp,64
    800042dc:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800042de:	00029a97          	auipc	s5,0x29
    800042e2:	faaa8a93          	addi	s5,s5,-86 # 8002d288 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800042e6:	00029a17          	auipc	s4,0x29
    800042ea:	f72a0a13          	addi	s4,s4,-142 # 8002d258 <log>
    800042ee:	018a2583          	lw	a1,24(s4)
    800042f2:	012585bb          	addw	a1,a1,s2
    800042f6:	2585                	addiw	a1,a1,1
    800042f8:	028a2503          	lw	a0,40(s4)
    800042fc:	fffff097          	auipc	ra,0xfffff
    80004300:	cca080e7          	jalr	-822(ra) # 80002fc6 <bread>
    80004304:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004306:	000aa583          	lw	a1,0(s5)
    8000430a:	028a2503          	lw	a0,40(s4)
    8000430e:	fffff097          	auipc	ra,0xfffff
    80004312:	cb8080e7          	jalr	-840(ra) # 80002fc6 <bread>
    80004316:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004318:	40000613          	li	a2,1024
    8000431c:	05850593          	addi	a1,a0,88
    80004320:	05848513          	addi	a0,s1,88
    80004324:	ffffd097          	auipc	ra,0xffffd
    80004328:	a04080e7          	jalr	-1532(ra) # 80000d28 <memmove>
    bwrite(to);  // write the log
    8000432c:	8526                	mv	a0,s1
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	d8a080e7          	jalr	-630(ra) # 800030b8 <bwrite>
    brelse(from);
    80004336:	854e                	mv	a0,s3
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	dbe080e7          	jalr	-578(ra) # 800030f6 <brelse>
    brelse(to);
    80004340:	8526                	mv	a0,s1
    80004342:	fffff097          	auipc	ra,0xfffff
    80004346:	db4080e7          	jalr	-588(ra) # 800030f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000434a:	2905                	addiw	s2,s2,1
    8000434c:	0a91                	addi	s5,s5,4
    8000434e:	02ca2783          	lw	a5,44(s4)
    80004352:	f8f94ee3          	blt	s2,a5,800042ee <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004356:	00000097          	auipc	ra,0x0
    8000435a:	c68080e7          	jalr	-920(ra) # 80003fbe <write_head>
    install_trans(0); // Now install writes to home locations
    8000435e:	4501                	li	a0,0
    80004360:	00000097          	auipc	ra,0x0
    80004364:	cda080e7          	jalr	-806(ra) # 8000403a <install_trans>
    log.lh.n = 0;
    80004368:	00029797          	auipc	a5,0x29
    8000436c:	f007ae23          	sw	zero,-228(a5) # 8002d284 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004370:	00000097          	auipc	ra,0x0
    80004374:	c4e080e7          	jalr	-946(ra) # 80003fbe <write_head>
    80004378:	bdf5                	j	80004274 <end_op+0x52>

000000008000437a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000437a:	1101                	addi	sp,sp,-32
    8000437c:	ec06                	sd	ra,24(sp)
    8000437e:	e822                	sd	s0,16(sp)
    80004380:	e426                	sd	s1,8(sp)
    80004382:	e04a                	sd	s2,0(sp)
    80004384:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004386:	00029717          	auipc	a4,0x29
    8000438a:	efe72703          	lw	a4,-258(a4) # 8002d284 <log+0x2c>
    8000438e:	47f5                	li	a5,29
    80004390:	08e7c063          	blt	a5,a4,80004410 <log_write+0x96>
    80004394:	84aa                	mv	s1,a0
    80004396:	00029797          	auipc	a5,0x29
    8000439a:	ede7a783          	lw	a5,-290(a5) # 8002d274 <log+0x1c>
    8000439e:	37fd                	addiw	a5,a5,-1
    800043a0:	06f75863          	bge	a4,a5,80004410 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800043a4:	00029797          	auipc	a5,0x29
    800043a8:	ed47a783          	lw	a5,-300(a5) # 8002d278 <log+0x20>
    800043ac:	06f05a63          	blez	a5,80004420 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800043b0:	00029917          	auipc	s2,0x29
    800043b4:	ea890913          	addi	s2,s2,-344 # 8002d258 <log>
    800043b8:	854a                	mv	a0,s2
    800043ba:	ffffd097          	auipc	ra,0xffffd
    800043be:	816080e7          	jalr	-2026(ra) # 80000bd0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800043c2:	02c92603          	lw	a2,44(s2)
    800043c6:	06c05563          	blez	a2,80004430 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800043ca:	44cc                	lw	a1,12(s1)
    800043cc:	00029717          	auipc	a4,0x29
    800043d0:	ebc70713          	addi	a4,a4,-324 # 8002d288 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800043d4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800043d6:	4314                	lw	a3,0(a4)
    800043d8:	04b68d63          	beq	a3,a1,80004432 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800043dc:	2785                	addiw	a5,a5,1
    800043de:	0711                	addi	a4,a4,4
    800043e0:	fec79be3          	bne	a5,a2,800043d6 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800043e4:	0621                	addi	a2,a2,8
    800043e6:	060a                	slli	a2,a2,0x2
    800043e8:	00029797          	auipc	a5,0x29
    800043ec:	e7078793          	addi	a5,a5,-400 # 8002d258 <log>
    800043f0:	97b2                	add	a5,a5,a2
    800043f2:	44d8                	lw	a4,12(s1)
    800043f4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800043f6:	8526                	mv	a0,s1
    800043f8:	fffff097          	auipc	ra,0xfffff
    800043fc:	d9c080e7          	jalr	-612(ra) # 80003194 <bpin>
    log.lh.n++;
    80004400:	00029717          	auipc	a4,0x29
    80004404:	e5870713          	addi	a4,a4,-424 # 8002d258 <log>
    80004408:	575c                	lw	a5,44(a4)
    8000440a:	2785                	addiw	a5,a5,1
    8000440c:	d75c                	sw	a5,44(a4)
    8000440e:	a835                	j	8000444a <log_write+0xd0>
    panic("too big a transaction");
    80004410:	00004517          	auipc	a0,0x4
    80004414:	24050513          	addi	a0,a0,576 # 80008650 <syscalls+0x200>
    80004418:	ffffc097          	auipc	ra,0xffffc
    8000441c:	122080e7          	jalr	290(ra) # 8000053a <panic>
    panic("log_write outside of trans");
    80004420:	00004517          	auipc	a0,0x4
    80004424:	24850513          	addi	a0,a0,584 # 80008668 <syscalls+0x218>
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	112080e7          	jalr	274(ra) # 8000053a <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004430:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004432:	00878693          	addi	a3,a5,8
    80004436:	068a                	slli	a3,a3,0x2
    80004438:	00029717          	auipc	a4,0x29
    8000443c:	e2070713          	addi	a4,a4,-480 # 8002d258 <log>
    80004440:	9736                	add	a4,a4,a3
    80004442:	44d4                	lw	a3,12(s1)
    80004444:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004446:	faf608e3          	beq	a2,a5,800043f6 <log_write+0x7c>
  }
  release(&log.lock);
    8000444a:	00029517          	auipc	a0,0x29
    8000444e:	e0e50513          	addi	a0,a0,-498 # 8002d258 <log>
    80004452:	ffffd097          	auipc	ra,0xffffd
    80004456:	832080e7          	jalr	-1998(ra) # 80000c84 <release>
}
    8000445a:	60e2                	ld	ra,24(sp)
    8000445c:	6442                	ld	s0,16(sp)
    8000445e:	64a2                	ld	s1,8(sp)
    80004460:	6902                	ld	s2,0(sp)
    80004462:	6105                	addi	sp,sp,32
    80004464:	8082                	ret

0000000080004466 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004466:	1101                	addi	sp,sp,-32
    80004468:	ec06                	sd	ra,24(sp)
    8000446a:	e822                	sd	s0,16(sp)
    8000446c:	e426                	sd	s1,8(sp)
    8000446e:	e04a                	sd	s2,0(sp)
    80004470:	1000                	addi	s0,sp,32
    80004472:	84aa                	mv	s1,a0
    80004474:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004476:	00004597          	auipc	a1,0x4
    8000447a:	21258593          	addi	a1,a1,530 # 80008688 <syscalls+0x238>
    8000447e:	0521                	addi	a0,a0,8
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	6c0080e7          	jalr	1728(ra) # 80000b40 <initlock>
  lk->name = name;
    80004488:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000448c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004490:	0204a423          	sw	zero,40(s1)
}
    80004494:	60e2                	ld	ra,24(sp)
    80004496:	6442                	ld	s0,16(sp)
    80004498:	64a2                	ld	s1,8(sp)
    8000449a:	6902                	ld	s2,0(sp)
    8000449c:	6105                	addi	sp,sp,32
    8000449e:	8082                	ret

00000000800044a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800044a0:	1101                	addi	sp,sp,-32
    800044a2:	ec06                	sd	ra,24(sp)
    800044a4:	e822                	sd	s0,16(sp)
    800044a6:	e426                	sd	s1,8(sp)
    800044a8:	e04a                	sd	s2,0(sp)
    800044aa:	1000                	addi	s0,sp,32
    800044ac:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044ae:	00850913          	addi	s2,a0,8
    800044b2:	854a                	mv	a0,s2
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	71c080e7          	jalr	1820(ra) # 80000bd0 <acquire>
  while (lk->locked) {
    800044bc:	409c                	lw	a5,0(s1)
    800044be:	cb89                	beqz	a5,800044d0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800044c0:	85ca                	mv	a1,s2
    800044c2:	8526                	mv	a0,s1
    800044c4:	ffffe097          	auipc	ra,0xffffe
    800044c8:	ec6080e7          	jalr	-314(ra) # 8000238a <sleep>
  while (lk->locked) {
    800044cc:	409c                	lw	a5,0(s1)
    800044ce:	fbed                	bnez	a5,800044c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800044d0:	4785                	li	a5,1
    800044d2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800044d4:	ffffd097          	auipc	ra,0xffffd
    800044d8:	608080e7          	jalr	1544(ra) # 80001adc <myproc>
    800044dc:	5d1c                	lw	a5,56(a0)
    800044de:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800044e0:	854a                	mv	a0,s2
    800044e2:	ffffc097          	auipc	ra,0xffffc
    800044e6:	7a2080e7          	jalr	1954(ra) # 80000c84 <release>
}
    800044ea:	60e2                	ld	ra,24(sp)
    800044ec:	6442                	ld	s0,16(sp)
    800044ee:	64a2                	ld	s1,8(sp)
    800044f0:	6902                	ld	s2,0(sp)
    800044f2:	6105                	addi	sp,sp,32
    800044f4:	8082                	ret

00000000800044f6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800044f6:	1101                	addi	sp,sp,-32
    800044f8:	ec06                	sd	ra,24(sp)
    800044fa:	e822                	sd	s0,16(sp)
    800044fc:	e426                	sd	s1,8(sp)
    800044fe:	e04a                	sd	s2,0(sp)
    80004500:	1000                	addi	s0,sp,32
    80004502:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004504:	00850913          	addi	s2,a0,8
    80004508:	854a                	mv	a0,s2
    8000450a:	ffffc097          	auipc	ra,0xffffc
    8000450e:	6c6080e7          	jalr	1734(ra) # 80000bd0 <acquire>
  lk->locked = 0;
    80004512:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004516:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000451a:	8526                	mv	a0,s1
    8000451c:	ffffe097          	auipc	ra,0xffffe
    80004520:	fee080e7          	jalr	-18(ra) # 8000250a <wakeup>
  release(&lk->lk);
    80004524:	854a                	mv	a0,s2
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	75e080e7          	jalr	1886(ra) # 80000c84 <release>
}
    8000452e:	60e2                	ld	ra,24(sp)
    80004530:	6442                	ld	s0,16(sp)
    80004532:	64a2                	ld	s1,8(sp)
    80004534:	6902                	ld	s2,0(sp)
    80004536:	6105                	addi	sp,sp,32
    80004538:	8082                	ret

000000008000453a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000453a:	7179                	addi	sp,sp,-48
    8000453c:	f406                	sd	ra,40(sp)
    8000453e:	f022                	sd	s0,32(sp)
    80004540:	ec26                	sd	s1,24(sp)
    80004542:	e84a                	sd	s2,16(sp)
    80004544:	e44e                	sd	s3,8(sp)
    80004546:	1800                	addi	s0,sp,48
    80004548:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000454a:	00850913          	addi	s2,a0,8
    8000454e:	854a                	mv	a0,s2
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	680080e7          	jalr	1664(ra) # 80000bd0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004558:	409c                	lw	a5,0(s1)
    8000455a:	ef99                	bnez	a5,80004578 <holdingsleep+0x3e>
    8000455c:	4481                	li	s1,0
  release(&lk->lk);
    8000455e:	854a                	mv	a0,s2
    80004560:	ffffc097          	auipc	ra,0xffffc
    80004564:	724080e7          	jalr	1828(ra) # 80000c84 <release>
  return r;
}
    80004568:	8526                	mv	a0,s1
    8000456a:	70a2                	ld	ra,40(sp)
    8000456c:	7402                	ld	s0,32(sp)
    8000456e:	64e2                	ld	s1,24(sp)
    80004570:	6942                	ld	s2,16(sp)
    80004572:	69a2                	ld	s3,8(sp)
    80004574:	6145                	addi	sp,sp,48
    80004576:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004578:	0284a983          	lw	s3,40(s1)
    8000457c:	ffffd097          	auipc	ra,0xffffd
    80004580:	560080e7          	jalr	1376(ra) # 80001adc <myproc>
    80004584:	5d04                	lw	s1,56(a0)
    80004586:	413484b3          	sub	s1,s1,s3
    8000458a:	0014b493          	seqz	s1,s1
    8000458e:	bfc1                	j	8000455e <holdingsleep+0x24>

0000000080004590 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004590:	1141                	addi	sp,sp,-16
    80004592:	e406                	sd	ra,8(sp)
    80004594:	e022                	sd	s0,0(sp)
    80004596:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004598:	00004597          	auipc	a1,0x4
    8000459c:	10058593          	addi	a1,a1,256 # 80008698 <syscalls+0x248>
    800045a0:	00029517          	auipc	a0,0x29
    800045a4:	e0050513          	addi	a0,a0,-512 # 8002d3a0 <ftable>
    800045a8:	ffffc097          	auipc	ra,0xffffc
    800045ac:	598080e7          	jalr	1432(ra) # 80000b40 <initlock>
}
    800045b0:	60a2                	ld	ra,8(sp)
    800045b2:	6402                	ld	s0,0(sp)
    800045b4:	0141                	addi	sp,sp,16
    800045b6:	8082                	ret

00000000800045b8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800045b8:	1101                	addi	sp,sp,-32
    800045ba:	ec06                	sd	ra,24(sp)
    800045bc:	e822                	sd	s0,16(sp)
    800045be:	e426                	sd	s1,8(sp)
    800045c0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045c2:	00029517          	auipc	a0,0x29
    800045c6:	dde50513          	addi	a0,a0,-546 # 8002d3a0 <ftable>
    800045ca:	ffffc097          	auipc	ra,0xffffc
    800045ce:	606080e7          	jalr	1542(ra) # 80000bd0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045d2:	00029497          	auipc	s1,0x29
    800045d6:	de648493          	addi	s1,s1,-538 # 8002d3b8 <ftable+0x18>
    800045da:	0002a717          	auipc	a4,0x2a
    800045de:	d7e70713          	addi	a4,a4,-642 # 8002e358 <ftable+0xfb8>
    if(f->ref == 0){
    800045e2:	40dc                	lw	a5,4(s1)
    800045e4:	cf99                	beqz	a5,80004602 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045e6:	02848493          	addi	s1,s1,40
    800045ea:	fee49ce3          	bne	s1,a4,800045e2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800045ee:	00029517          	auipc	a0,0x29
    800045f2:	db250513          	addi	a0,a0,-590 # 8002d3a0 <ftable>
    800045f6:	ffffc097          	auipc	ra,0xffffc
    800045fa:	68e080e7          	jalr	1678(ra) # 80000c84 <release>
  return 0;
    800045fe:	4481                	li	s1,0
    80004600:	a819                	j	80004616 <filealloc+0x5e>
      f->ref = 1;
    80004602:	4785                	li	a5,1
    80004604:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004606:	00029517          	auipc	a0,0x29
    8000460a:	d9a50513          	addi	a0,a0,-614 # 8002d3a0 <ftable>
    8000460e:	ffffc097          	auipc	ra,0xffffc
    80004612:	676080e7          	jalr	1654(ra) # 80000c84 <release>
}
    80004616:	8526                	mv	a0,s1
    80004618:	60e2                	ld	ra,24(sp)
    8000461a:	6442                	ld	s0,16(sp)
    8000461c:	64a2                	ld	s1,8(sp)
    8000461e:	6105                	addi	sp,sp,32
    80004620:	8082                	ret

0000000080004622 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004622:	1101                	addi	sp,sp,-32
    80004624:	ec06                	sd	ra,24(sp)
    80004626:	e822                	sd	s0,16(sp)
    80004628:	e426                	sd	s1,8(sp)
    8000462a:	1000                	addi	s0,sp,32
    8000462c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000462e:	00029517          	auipc	a0,0x29
    80004632:	d7250513          	addi	a0,a0,-654 # 8002d3a0 <ftable>
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	59a080e7          	jalr	1434(ra) # 80000bd0 <acquire>
  if(f->ref < 1)
    8000463e:	40dc                	lw	a5,4(s1)
    80004640:	02f05263          	blez	a5,80004664 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004644:	2785                	addiw	a5,a5,1
    80004646:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004648:	00029517          	auipc	a0,0x29
    8000464c:	d5850513          	addi	a0,a0,-680 # 8002d3a0 <ftable>
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	634080e7          	jalr	1588(ra) # 80000c84 <release>
  return f;
}
    80004658:	8526                	mv	a0,s1
    8000465a:	60e2                	ld	ra,24(sp)
    8000465c:	6442                	ld	s0,16(sp)
    8000465e:	64a2                	ld	s1,8(sp)
    80004660:	6105                	addi	sp,sp,32
    80004662:	8082                	ret
    panic("filedup");
    80004664:	00004517          	auipc	a0,0x4
    80004668:	03c50513          	addi	a0,a0,60 # 800086a0 <syscalls+0x250>
    8000466c:	ffffc097          	auipc	ra,0xffffc
    80004670:	ece080e7          	jalr	-306(ra) # 8000053a <panic>

0000000080004674 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004674:	7139                	addi	sp,sp,-64
    80004676:	fc06                	sd	ra,56(sp)
    80004678:	f822                	sd	s0,48(sp)
    8000467a:	f426                	sd	s1,40(sp)
    8000467c:	f04a                	sd	s2,32(sp)
    8000467e:	ec4e                	sd	s3,24(sp)
    80004680:	e852                	sd	s4,16(sp)
    80004682:	e456                	sd	s5,8(sp)
    80004684:	0080                	addi	s0,sp,64
    80004686:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004688:	00029517          	auipc	a0,0x29
    8000468c:	d1850513          	addi	a0,a0,-744 # 8002d3a0 <ftable>
    80004690:	ffffc097          	auipc	ra,0xffffc
    80004694:	540080e7          	jalr	1344(ra) # 80000bd0 <acquire>
  if(f->ref < 1)
    80004698:	40dc                	lw	a5,4(s1)
    8000469a:	06f05163          	blez	a5,800046fc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000469e:	37fd                	addiw	a5,a5,-1
    800046a0:	0007871b          	sext.w	a4,a5
    800046a4:	c0dc                	sw	a5,4(s1)
    800046a6:	06e04363          	bgtz	a4,8000470c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800046aa:	0004a903          	lw	s2,0(s1)
    800046ae:	0094ca83          	lbu	s5,9(s1)
    800046b2:	0104ba03          	ld	s4,16(s1)
    800046b6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046ba:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046be:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046c2:	00029517          	auipc	a0,0x29
    800046c6:	cde50513          	addi	a0,a0,-802 # 8002d3a0 <ftable>
    800046ca:	ffffc097          	auipc	ra,0xffffc
    800046ce:	5ba080e7          	jalr	1466(ra) # 80000c84 <release>

  if(ff.type == FD_PIPE){
    800046d2:	4785                	li	a5,1
    800046d4:	04f90d63          	beq	s2,a5,8000472e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046d8:	3979                	addiw	s2,s2,-2
    800046da:	4785                	li	a5,1
    800046dc:	0527e063          	bltu	a5,s2,8000471c <fileclose+0xa8>
    begin_op();
    800046e0:	00000097          	auipc	ra,0x0
    800046e4:	ac4080e7          	jalr	-1340(ra) # 800041a4 <begin_op>
    iput(ff.ip);
    800046e8:	854e                	mv	a0,s3
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	298080e7          	jalr	664(ra) # 80003982 <iput>
    end_op();
    800046f2:	00000097          	auipc	ra,0x0
    800046f6:	b30080e7          	jalr	-1232(ra) # 80004222 <end_op>
    800046fa:	a00d                	j	8000471c <fileclose+0xa8>
    panic("fileclose");
    800046fc:	00004517          	auipc	a0,0x4
    80004700:	fac50513          	addi	a0,a0,-84 # 800086a8 <syscalls+0x258>
    80004704:	ffffc097          	auipc	ra,0xffffc
    80004708:	e36080e7          	jalr	-458(ra) # 8000053a <panic>
    release(&ftable.lock);
    8000470c:	00029517          	auipc	a0,0x29
    80004710:	c9450513          	addi	a0,a0,-876 # 8002d3a0 <ftable>
    80004714:	ffffc097          	auipc	ra,0xffffc
    80004718:	570080e7          	jalr	1392(ra) # 80000c84 <release>
  }
}
    8000471c:	70e2                	ld	ra,56(sp)
    8000471e:	7442                	ld	s0,48(sp)
    80004720:	74a2                	ld	s1,40(sp)
    80004722:	7902                	ld	s2,32(sp)
    80004724:	69e2                	ld	s3,24(sp)
    80004726:	6a42                	ld	s4,16(sp)
    80004728:	6aa2                	ld	s5,8(sp)
    8000472a:	6121                	addi	sp,sp,64
    8000472c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000472e:	85d6                	mv	a1,s5
    80004730:	8552                	mv	a0,s4
    80004732:	00000097          	auipc	ra,0x0
    80004736:	34c080e7          	jalr	844(ra) # 80004a7e <pipeclose>
    8000473a:	b7cd                	j	8000471c <fileclose+0xa8>

000000008000473c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000473c:	715d                	addi	sp,sp,-80
    8000473e:	e486                	sd	ra,72(sp)
    80004740:	e0a2                	sd	s0,64(sp)
    80004742:	fc26                	sd	s1,56(sp)
    80004744:	f84a                	sd	s2,48(sp)
    80004746:	f44e                	sd	s3,40(sp)
    80004748:	0880                	addi	s0,sp,80
    8000474a:	84aa                	mv	s1,a0
    8000474c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000474e:	ffffd097          	auipc	ra,0xffffd
    80004752:	38e080e7          	jalr	910(ra) # 80001adc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004756:	409c                	lw	a5,0(s1)
    80004758:	37f9                	addiw	a5,a5,-2
    8000475a:	4705                	li	a4,1
    8000475c:	04f76763          	bltu	a4,a5,800047aa <filestat+0x6e>
    80004760:	892a                	mv	s2,a0
    ilock(f->ip);
    80004762:	6c88                	ld	a0,24(s1)
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	064080e7          	jalr	100(ra) # 800037c8 <ilock>
    stati(f->ip, &st);
    8000476c:	fb840593          	addi	a1,s0,-72
    80004770:	6c88                	ld	a0,24(s1)
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	2e0080e7          	jalr	736(ra) # 80003a52 <stati>
    iunlock(f->ip);
    8000477a:	6c88                	ld	a0,24(s1)
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	10e080e7          	jalr	270(ra) # 8000388a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004784:	46e1                	li	a3,24
    80004786:	fb840613          	addi	a2,s0,-72
    8000478a:	85ce                	mv	a1,s3
    8000478c:	05093503          	ld	a0,80(s2)
    80004790:	ffffd097          	auipc	ra,0xffffd
    80004794:	ec0080e7          	jalr	-320(ra) # 80001650 <copyout>
    80004798:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000479c:	60a6                	ld	ra,72(sp)
    8000479e:	6406                	ld	s0,64(sp)
    800047a0:	74e2                	ld	s1,56(sp)
    800047a2:	7942                	ld	s2,48(sp)
    800047a4:	79a2                	ld	s3,40(sp)
    800047a6:	6161                	addi	sp,sp,80
    800047a8:	8082                	ret
  return -1;
    800047aa:	557d                	li	a0,-1
    800047ac:	bfc5                	j	8000479c <filestat+0x60>

00000000800047ae <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800047ae:	7179                	addi	sp,sp,-48
    800047b0:	f406                	sd	ra,40(sp)
    800047b2:	f022                	sd	s0,32(sp)
    800047b4:	ec26                	sd	s1,24(sp)
    800047b6:	e84a                	sd	s2,16(sp)
    800047b8:	e44e                	sd	s3,8(sp)
    800047ba:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047bc:	00854783          	lbu	a5,8(a0)
    800047c0:	c3d5                	beqz	a5,80004864 <fileread+0xb6>
    800047c2:	84aa                	mv	s1,a0
    800047c4:	89ae                	mv	s3,a1
    800047c6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800047c8:	411c                	lw	a5,0(a0)
    800047ca:	4705                	li	a4,1
    800047cc:	04e78963          	beq	a5,a4,8000481e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047d0:	470d                	li	a4,3
    800047d2:	04e78d63          	beq	a5,a4,8000482c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800047d6:	4709                	li	a4,2
    800047d8:	06e79e63          	bne	a5,a4,80004854 <fileread+0xa6>
    ilock(f->ip);
    800047dc:	6d08                	ld	a0,24(a0)
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	fea080e7          	jalr	-22(ra) # 800037c8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047e6:	874a                	mv	a4,s2
    800047e8:	5094                	lw	a3,32(s1)
    800047ea:	864e                	mv	a2,s3
    800047ec:	4585                	li	a1,1
    800047ee:	6c88                	ld	a0,24(s1)
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	28c080e7          	jalr	652(ra) # 80003a7c <readi>
    800047f8:	892a                	mv	s2,a0
    800047fa:	00a05563          	blez	a0,80004804 <fileread+0x56>
      f->off += r;
    800047fe:	509c                	lw	a5,32(s1)
    80004800:	9fa9                	addw	a5,a5,a0
    80004802:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004804:	6c88                	ld	a0,24(s1)
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	084080e7          	jalr	132(ra) # 8000388a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000480e:	854a                	mv	a0,s2
    80004810:	70a2                	ld	ra,40(sp)
    80004812:	7402                	ld	s0,32(sp)
    80004814:	64e2                	ld	s1,24(sp)
    80004816:	6942                	ld	s2,16(sp)
    80004818:	69a2                	ld	s3,8(sp)
    8000481a:	6145                	addi	sp,sp,48
    8000481c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000481e:	6908                	ld	a0,16(a0)
    80004820:	00000097          	auipc	ra,0x0
    80004824:	3c0080e7          	jalr	960(ra) # 80004be0 <piperead>
    80004828:	892a                	mv	s2,a0
    8000482a:	b7d5                	j	8000480e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000482c:	02451783          	lh	a5,36(a0)
    80004830:	03079693          	slli	a3,a5,0x30
    80004834:	92c1                	srli	a3,a3,0x30
    80004836:	4725                	li	a4,9
    80004838:	02d76863          	bltu	a4,a3,80004868 <fileread+0xba>
    8000483c:	0792                	slli	a5,a5,0x4
    8000483e:	00029717          	auipc	a4,0x29
    80004842:	ac270713          	addi	a4,a4,-1342 # 8002d300 <devsw>
    80004846:	97ba                	add	a5,a5,a4
    80004848:	639c                	ld	a5,0(a5)
    8000484a:	c38d                	beqz	a5,8000486c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000484c:	4505                	li	a0,1
    8000484e:	9782                	jalr	a5
    80004850:	892a                	mv	s2,a0
    80004852:	bf75                	j	8000480e <fileread+0x60>
    panic("fileread");
    80004854:	00004517          	auipc	a0,0x4
    80004858:	e6450513          	addi	a0,a0,-412 # 800086b8 <syscalls+0x268>
    8000485c:	ffffc097          	auipc	ra,0xffffc
    80004860:	cde080e7          	jalr	-802(ra) # 8000053a <panic>
    return -1;
    80004864:	597d                	li	s2,-1
    80004866:	b765                	j	8000480e <fileread+0x60>
      return -1;
    80004868:	597d                	li	s2,-1
    8000486a:	b755                	j	8000480e <fileread+0x60>
    8000486c:	597d                	li	s2,-1
    8000486e:	b745                	j	8000480e <fileread+0x60>

0000000080004870 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004870:	715d                	addi	sp,sp,-80
    80004872:	e486                	sd	ra,72(sp)
    80004874:	e0a2                	sd	s0,64(sp)
    80004876:	fc26                	sd	s1,56(sp)
    80004878:	f84a                	sd	s2,48(sp)
    8000487a:	f44e                	sd	s3,40(sp)
    8000487c:	f052                	sd	s4,32(sp)
    8000487e:	ec56                	sd	s5,24(sp)
    80004880:	e85a                	sd	s6,16(sp)
    80004882:	e45e                	sd	s7,8(sp)
    80004884:	e062                	sd	s8,0(sp)
    80004886:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004888:	00954783          	lbu	a5,9(a0)
    8000488c:	10078663          	beqz	a5,80004998 <filewrite+0x128>
    80004890:	892a                	mv	s2,a0
    80004892:	8b2e                	mv	s6,a1
    80004894:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004896:	411c                	lw	a5,0(a0)
    80004898:	4705                	li	a4,1
    8000489a:	02e78263          	beq	a5,a4,800048be <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000489e:	470d                	li	a4,3
    800048a0:	02e78663          	beq	a5,a4,800048cc <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800048a4:	4709                	li	a4,2
    800048a6:	0ee79163          	bne	a5,a4,80004988 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048aa:	0ac05d63          	blez	a2,80004964 <filewrite+0xf4>
    int i = 0;
    800048ae:	4981                	li	s3,0
    800048b0:	6b85                	lui	s7,0x1
    800048b2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800048b6:	6c05                	lui	s8,0x1
    800048b8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800048bc:	a861                	j	80004954 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800048be:	6908                	ld	a0,16(a0)
    800048c0:	00000097          	auipc	ra,0x0
    800048c4:	22e080e7          	jalr	558(ra) # 80004aee <pipewrite>
    800048c8:	8a2a                	mv	s4,a0
    800048ca:	a045                	j	8000496a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048cc:	02451783          	lh	a5,36(a0)
    800048d0:	03079693          	slli	a3,a5,0x30
    800048d4:	92c1                	srli	a3,a3,0x30
    800048d6:	4725                	li	a4,9
    800048d8:	0cd76263          	bltu	a4,a3,8000499c <filewrite+0x12c>
    800048dc:	0792                	slli	a5,a5,0x4
    800048de:	00029717          	auipc	a4,0x29
    800048e2:	a2270713          	addi	a4,a4,-1502 # 8002d300 <devsw>
    800048e6:	97ba                	add	a5,a5,a4
    800048e8:	679c                	ld	a5,8(a5)
    800048ea:	cbdd                	beqz	a5,800049a0 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    800048ec:	4505                	li	a0,1
    800048ee:	9782                	jalr	a5
    800048f0:	8a2a                	mv	s4,a0
    800048f2:	a8a5                	j	8000496a <filewrite+0xfa>
    800048f4:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800048f8:	00000097          	auipc	ra,0x0
    800048fc:	8ac080e7          	jalr	-1876(ra) # 800041a4 <begin_op>
      ilock(f->ip);
    80004900:	01893503          	ld	a0,24(s2)
    80004904:	fffff097          	auipc	ra,0xfffff
    80004908:	ec4080e7          	jalr	-316(ra) # 800037c8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000490c:	8756                	mv	a4,s5
    8000490e:	02092683          	lw	a3,32(s2)
    80004912:	01698633          	add	a2,s3,s6
    80004916:	4585                	li	a1,1
    80004918:	01893503          	ld	a0,24(s2)
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	258080e7          	jalr	600(ra) # 80003b74 <writei>
    80004924:	84aa                	mv	s1,a0
    80004926:	00a05763          	blez	a0,80004934 <filewrite+0xc4>
        f->off += r;
    8000492a:	02092783          	lw	a5,32(s2)
    8000492e:	9fa9                	addw	a5,a5,a0
    80004930:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004934:	01893503          	ld	a0,24(s2)
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	f52080e7          	jalr	-174(ra) # 8000388a <iunlock>
      end_op();
    80004940:	00000097          	auipc	ra,0x0
    80004944:	8e2080e7          	jalr	-1822(ra) # 80004222 <end_op>

      if(r != n1){
    80004948:	009a9f63          	bne	s5,s1,80004966 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    8000494c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004950:	0149db63          	bge	s3,s4,80004966 <filewrite+0xf6>
      int n1 = n - i;
    80004954:	413a04bb          	subw	s1,s4,s3
    80004958:	0004879b          	sext.w	a5,s1
    8000495c:	f8fbdce3          	bge	s7,a5,800048f4 <filewrite+0x84>
    80004960:	84e2                	mv	s1,s8
    80004962:	bf49                	j	800048f4 <filewrite+0x84>
    int i = 0;
    80004964:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004966:	013a1f63          	bne	s4,s3,80004984 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000496a:	8552                	mv	a0,s4
    8000496c:	60a6                	ld	ra,72(sp)
    8000496e:	6406                	ld	s0,64(sp)
    80004970:	74e2                	ld	s1,56(sp)
    80004972:	7942                	ld	s2,48(sp)
    80004974:	79a2                	ld	s3,40(sp)
    80004976:	7a02                	ld	s4,32(sp)
    80004978:	6ae2                	ld	s5,24(sp)
    8000497a:	6b42                	ld	s6,16(sp)
    8000497c:	6ba2                	ld	s7,8(sp)
    8000497e:	6c02                	ld	s8,0(sp)
    80004980:	6161                	addi	sp,sp,80
    80004982:	8082                	ret
    ret = (i == n ? n : -1);
    80004984:	5a7d                	li	s4,-1
    80004986:	b7d5                	j	8000496a <filewrite+0xfa>
    panic("filewrite");
    80004988:	00004517          	auipc	a0,0x4
    8000498c:	d4050513          	addi	a0,a0,-704 # 800086c8 <syscalls+0x278>
    80004990:	ffffc097          	auipc	ra,0xffffc
    80004994:	baa080e7          	jalr	-1110(ra) # 8000053a <panic>
    return -1;
    80004998:	5a7d                	li	s4,-1
    8000499a:	bfc1                	j	8000496a <filewrite+0xfa>
      return -1;
    8000499c:	5a7d                	li	s4,-1
    8000499e:	b7f1                	j	8000496a <filewrite+0xfa>
    800049a0:	5a7d                	li	s4,-1
    800049a2:	b7e1                	j	8000496a <filewrite+0xfa>

00000000800049a4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800049a4:	7179                	addi	sp,sp,-48
    800049a6:	f406                	sd	ra,40(sp)
    800049a8:	f022                	sd	s0,32(sp)
    800049aa:	ec26                	sd	s1,24(sp)
    800049ac:	e84a                	sd	s2,16(sp)
    800049ae:	e44e                	sd	s3,8(sp)
    800049b0:	e052                	sd	s4,0(sp)
    800049b2:	1800                	addi	s0,sp,48
    800049b4:	84aa                	mv	s1,a0
    800049b6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049b8:	0005b023          	sd	zero,0(a1)
    800049bc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049c0:	00000097          	auipc	ra,0x0
    800049c4:	bf8080e7          	jalr	-1032(ra) # 800045b8 <filealloc>
    800049c8:	e088                	sd	a0,0(s1)
    800049ca:	c551                	beqz	a0,80004a56 <pipealloc+0xb2>
    800049cc:	00000097          	auipc	ra,0x0
    800049d0:	bec080e7          	jalr	-1044(ra) # 800045b8 <filealloc>
    800049d4:	00aa3023          	sd	a0,0(s4)
    800049d8:	c92d                	beqz	a0,80004a4a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800049da:	ffffc097          	auipc	ra,0xffffc
    800049de:	106080e7          	jalr	262(ra) # 80000ae0 <kalloc>
    800049e2:	892a                	mv	s2,a0
    800049e4:	c125                	beqz	a0,80004a44 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800049e6:	4985                	li	s3,1
    800049e8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800049ec:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800049f0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800049f4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800049f8:	00004597          	auipc	a1,0x4
    800049fc:	ce058593          	addi	a1,a1,-800 # 800086d8 <syscalls+0x288>
    80004a00:	ffffc097          	auipc	ra,0xffffc
    80004a04:	140080e7          	jalr	320(ra) # 80000b40 <initlock>
  (*f0)->type = FD_PIPE;
    80004a08:	609c                	ld	a5,0(s1)
    80004a0a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004a0e:	609c                	ld	a5,0(s1)
    80004a10:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a14:	609c                	ld	a5,0(s1)
    80004a16:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a1a:	609c                	ld	a5,0(s1)
    80004a1c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a20:	000a3783          	ld	a5,0(s4)
    80004a24:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a28:	000a3783          	ld	a5,0(s4)
    80004a2c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a30:	000a3783          	ld	a5,0(s4)
    80004a34:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a38:	000a3783          	ld	a5,0(s4)
    80004a3c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a40:	4501                	li	a0,0
    80004a42:	a025                	j	80004a6a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a44:	6088                	ld	a0,0(s1)
    80004a46:	e501                	bnez	a0,80004a4e <pipealloc+0xaa>
    80004a48:	a039                	j	80004a56 <pipealloc+0xb2>
    80004a4a:	6088                	ld	a0,0(s1)
    80004a4c:	c51d                	beqz	a0,80004a7a <pipealloc+0xd6>
    fileclose(*f0);
    80004a4e:	00000097          	auipc	ra,0x0
    80004a52:	c26080e7          	jalr	-986(ra) # 80004674 <fileclose>
  if(*f1)
    80004a56:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a5a:	557d                	li	a0,-1
  if(*f1)
    80004a5c:	c799                	beqz	a5,80004a6a <pipealloc+0xc6>
    fileclose(*f1);
    80004a5e:	853e                	mv	a0,a5
    80004a60:	00000097          	auipc	ra,0x0
    80004a64:	c14080e7          	jalr	-1004(ra) # 80004674 <fileclose>
  return -1;
    80004a68:	557d                	li	a0,-1
}
    80004a6a:	70a2                	ld	ra,40(sp)
    80004a6c:	7402                	ld	s0,32(sp)
    80004a6e:	64e2                	ld	s1,24(sp)
    80004a70:	6942                	ld	s2,16(sp)
    80004a72:	69a2                	ld	s3,8(sp)
    80004a74:	6a02                	ld	s4,0(sp)
    80004a76:	6145                	addi	sp,sp,48
    80004a78:	8082                	ret
  return -1;
    80004a7a:	557d                	li	a0,-1
    80004a7c:	b7fd                	j	80004a6a <pipealloc+0xc6>

0000000080004a7e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a7e:	1101                	addi	sp,sp,-32
    80004a80:	ec06                	sd	ra,24(sp)
    80004a82:	e822                	sd	s0,16(sp)
    80004a84:	e426                	sd	s1,8(sp)
    80004a86:	e04a                	sd	s2,0(sp)
    80004a88:	1000                	addi	s0,sp,32
    80004a8a:	84aa                	mv	s1,a0
    80004a8c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a8e:	ffffc097          	auipc	ra,0xffffc
    80004a92:	142080e7          	jalr	322(ra) # 80000bd0 <acquire>
  if(writable){
    80004a96:	02090d63          	beqz	s2,80004ad0 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a9a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a9e:	21848513          	addi	a0,s1,536
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	a68080e7          	jalr	-1432(ra) # 8000250a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004aaa:	2204b783          	ld	a5,544(s1)
    80004aae:	eb95                	bnez	a5,80004ae2 <pipeclose+0x64>
    release(&pi->lock);
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	ffffc097          	auipc	ra,0xffffc
    80004ab6:	1d2080e7          	jalr	466(ra) # 80000c84 <release>
    kfree((char*)pi);
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffc097          	auipc	ra,0xffffc
    80004ac0:	f26080e7          	jalr	-218(ra) # 800009e2 <kfree>
  } else
    release(&pi->lock);
}
    80004ac4:	60e2                	ld	ra,24(sp)
    80004ac6:	6442                	ld	s0,16(sp)
    80004ac8:	64a2                	ld	s1,8(sp)
    80004aca:	6902                	ld	s2,0(sp)
    80004acc:	6105                	addi	sp,sp,32
    80004ace:	8082                	ret
    pi->readopen = 0;
    80004ad0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ad4:	21c48513          	addi	a0,s1,540
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	a32080e7          	jalr	-1486(ra) # 8000250a <wakeup>
    80004ae0:	b7e9                	j	80004aaa <pipeclose+0x2c>
    release(&pi->lock);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	ffffc097          	auipc	ra,0xffffc
    80004ae8:	1a0080e7          	jalr	416(ra) # 80000c84 <release>
}
    80004aec:	bfe1                	j	80004ac4 <pipeclose+0x46>

0000000080004aee <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004aee:	711d                	addi	sp,sp,-96
    80004af0:	ec86                	sd	ra,88(sp)
    80004af2:	e8a2                	sd	s0,80(sp)
    80004af4:	e4a6                	sd	s1,72(sp)
    80004af6:	e0ca                	sd	s2,64(sp)
    80004af8:	fc4e                	sd	s3,56(sp)
    80004afa:	f852                	sd	s4,48(sp)
    80004afc:	f456                	sd	s5,40(sp)
    80004afe:	f05a                	sd	s6,32(sp)
    80004b00:	ec5e                	sd	s7,24(sp)
    80004b02:	e862                	sd	s8,16(sp)
    80004b04:	1080                	addi	s0,sp,96
    80004b06:	84aa                	mv	s1,a0
    80004b08:	8aae                	mv	s5,a1
    80004b0a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004b0c:	ffffd097          	auipc	ra,0xffffd
    80004b10:	fd0080e7          	jalr	-48(ra) # 80001adc <myproc>
    80004b14:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffc097          	auipc	ra,0xffffc
    80004b1c:	0b8080e7          	jalr	184(ra) # 80000bd0 <acquire>
  while(i < n){
    80004b20:	0b405363          	blez	s4,80004bc6 <pipewrite+0xd8>
  int i = 0;
    80004b24:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b26:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b28:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b2c:	21c48b93          	addi	s7,s1,540
    80004b30:	a089                	j	80004b72 <pipewrite+0x84>
      release(&pi->lock);
    80004b32:	8526                	mv	a0,s1
    80004b34:	ffffc097          	auipc	ra,0xffffc
    80004b38:	150080e7          	jalr	336(ra) # 80000c84 <release>
      return -1;
    80004b3c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004b3e:	854a                	mv	a0,s2
    80004b40:	60e6                	ld	ra,88(sp)
    80004b42:	6446                	ld	s0,80(sp)
    80004b44:	64a6                	ld	s1,72(sp)
    80004b46:	6906                	ld	s2,64(sp)
    80004b48:	79e2                	ld	s3,56(sp)
    80004b4a:	7a42                	ld	s4,48(sp)
    80004b4c:	7aa2                	ld	s5,40(sp)
    80004b4e:	7b02                	ld	s6,32(sp)
    80004b50:	6be2                	ld	s7,24(sp)
    80004b52:	6c42                	ld	s8,16(sp)
    80004b54:	6125                	addi	sp,sp,96
    80004b56:	8082                	ret
      wakeup(&pi->nread);
    80004b58:	8562                	mv	a0,s8
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	9b0080e7          	jalr	-1616(ra) # 8000250a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b62:	85a6                	mv	a1,s1
    80004b64:	855e                	mv	a0,s7
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	824080e7          	jalr	-2012(ra) # 8000238a <sleep>
  while(i < n){
    80004b6e:	05495d63          	bge	s2,s4,80004bc8 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004b72:	2204a783          	lw	a5,544(s1)
    80004b76:	dfd5                	beqz	a5,80004b32 <pipewrite+0x44>
    80004b78:	0309a783          	lw	a5,48(s3)
    80004b7c:	fbdd                	bnez	a5,80004b32 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004b7e:	2184a783          	lw	a5,536(s1)
    80004b82:	21c4a703          	lw	a4,540(s1)
    80004b86:	2007879b          	addiw	a5,a5,512
    80004b8a:	fcf707e3          	beq	a4,a5,80004b58 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b8e:	4685                	li	a3,1
    80004b90:	01590633          	add	a2,s2,s5
    80004b94:	faf40593          	addi	a1,s0,-81
    80004b98:	0509b503          	ld	a0,80(s3)
    80004b9c:	ffffd097          	auipc	ra,0xffffd
    80004ba0:	b40080e7          	jalr	-1216(ra) # 800016dc <copyin>
    80004ba4:	03650263          	beq	a0,s6,80004bc8 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ba8:	21c4a783          	lw	a5,540(s1)
    80004bac:	0017871b          	addiw	a4,a5,1
    80004bb0:	20e4ae23          	sw	a4,540(s1)
    80004bb4:	1ff7f793          	andi	a5,a5,511
    80004bb8:	97a6                	add	a5,a5,s1
    80004bba:	faf44703          	lbu	a4,-81(s0)
    80004bbe:	00e78c23          	sb	a4,24(a5)
      i++;
    80004bc2:	2905                	addiw	s2,s2,1
    80004bc4:	b76d                	j	80004b6e <pipewrite+0x80>
  int i = 0;
    80004bc6:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004bc8:	21848513          	addi	a0,s1,536
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	93e080e7          	jalr	-1730(ra) # 8000250a <wakeup>
  release(&pi->lock);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffc097          	auipc	ra,0xffffc
    80004bda:	0ae080e7          	jalr	174(ra) # 80000c84 <release>
  return i;
    80004bde:	b785                	j	80004b3e <pipewrite+0x50>

0000000080004be0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004be0:	715d                	addi	sp,sp,-80
    80004be2:	e486                	sd	ra,72(sp)
    80004be4:	e0a2                	sd	s0,64(sp)
    80004be6:	fc26                	sd	s1,56(sp)
    80004be8:	f84a                	sd	s2,48(sp)
    80004bea:	f44e                	sd	s3,40(sp)
    80004bec:	f052                	sd	s4,32(sp)
    80004bee:	ec56                	sd	s5,24(sp)
    80004bf0:	e85a                	sd	s6,16(sp)
    80004bf2:	0880                	addi	s0,sp,80
    80004bf4:	84aa                	mv	s1,a0
    80004bf6:	892e                	mv	s2,a1
    80004bf8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004bfa:	ffffd097          	auipc	ra,0xffffd
    80004bfe:	ee2080e7          	jalr	-286(ra) # 80001adc <myproc>
    80004c02:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffc097          	auipc	ra,0xffffc
    80004c0a:	fca080e7          	jalr	-54(ra) # 80000bd0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c0e:	2184a703          	lw	a4,536(s1)
    80004c12:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c16:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c1a:	02f71463          	bne	a4,a5,80004c42 <piperead+0x62>
    80004c1e:	2244a783          	lw	a5,548(s1)
    80004c22:	c385                	beqz	a5,80004c42 <piperead+0x62>
    if(pr->killed){
    80004c24:	030a2783          	lw	a5,48(s4)
    80004c28:	ebc9                	bnez	a5,80004cba <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c2a:	85a6                	mv	a1,s1
    80004c2c:	854e                	mv	a0,s3
    80004c2e:	ffffd097          	auipc	ra,0xffffd
    80004c32:	75c080e7          	jalr	1884(ra) # 8000238a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c36:	2184a703          	lw	a4,536(s1)
    80004c3a:	21c4a783          	lw	a5,540(s1)
    80004c3e:	fef700e3          	beq	a4,a5,80004c1e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c42:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c44:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c46:	05505463          	blez	s5,80004c8e <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004c4a:	2184a783          	lw	a5,536(s1)
    80004c4e:	21c4a703          	lw	a4,540(s1)
    80004c52:	02f70e63          	beq	a4,a5,80004c8e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c56:	0017871b          	addiw	a4,a5,1
    80004c5a:	20e4ac23          	sw	a4,536(s1)
    80004c5e:	1ff7f793          	andi	a5,a5,511
    80004c62:	97a6                	add	a5,a5,s1
    80004c64:	0187c783          	lbu	a5,24(a5)
    80004c68:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c6c:	4685                	li	a3,1
    80004c6e:	fbf40613          	addi	a2,s0,-65
    80004c72:	85ca                	mv	a1,s2
    80004c74:	050a3503          	ld	a0,80(s4)
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	9d8080e7          	jalr	-1576(ra) # 80001650 <copyout>
    80004c80:	01650763          	beq	a0,s6,80004c8e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c84:	2985                	addiw	s3,s3,1
    80004c86:	0905                	addi	s2,s2,1
    80004c88:	fd3a91e3          	bne	s5,s3,80004c4a <piperead+0x6a>
    80004c8c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c8e:	21c48513          	addi	a0,s1,540
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	878080e7          	jalr	-1928(ra) # 8000250a <wakeup>
  release(&pi->lock);
    80004c9a:	8526                	mv	a0,s1
    80004c9c:	ffffc097          	auipc	ra,0xffffc
    80004ca0:	fe8080e7          	jalr	-24(ra) # 80000c84 <release>
  return i;
}
    80004ca4:	854e                	mv	a0,s3
    80004ca6:	60a6                	ld	ra,72(sp)
    80004ca8:	6406                	ld	s0,64(sp)
    80004caa:	74e2                	ld	s1,56(sp)
    80004cac:	7942                	ld	s2,48(sp)
    80004cae:	79a2                	ld	s3,40(sp)
    80004cb0:	7a02                	ld	s4,32(sp)
    80004cb2:	6ae2                	ld	s5,24(sp)
    80004cb4:	6b42                	ld	s6,16(sp)
    80004cb6:	6161                	addi	sp,sp,80
    80004cb8:	8082                	ret
      release(&pi->lock);
    80004cba:	8526                	mv	a0,s1
    80004cbc:	ffffc097          	auipc	ra,0xffffc
    80004cc0:	fc8080e7          	jalr	-56(ra) # 80000c84 <release>
      return -1;
    80004cc4:	59fd                	li	s3,-1
    80004cc6:	bff9                	j	80004ca4 <piperead+0xc4>

0000000080004cc8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004cc8:	de010113          	addi	sp,sp,-544
    80004ccc:	20113c23          	sd	ra,536(sp)
    80004cd0:	20813823          	sd	s0,528(sp)
    80004cd4:	20913423          	sd	s1,520(sp)
    80004cd8:	21213023          	sd	s2,512(sp)
    80004cdc:	ffce                	sd	s3,504(sp)
    80004cde:	fbd2                	sd	s4,496(sp)
    80004ce0:	f7d6                	sd	s5,488(sp)
    80004ce2:	f3da                	sd	s6,480(sp)
    80004ce4:	efde                	sd	s7,472(sp)
    80004ce6:	ebe2                	sd	s8,464(sp)
    80004ce8:	e7e6                	sd	s9,456(sp)
    80004cea:	e3ea                	sd	s10,448(sp)
    80004cec:	ff6e                	sd	s11,440(sp)
    80004cee:	1400                	addi	s0,sp,544
    80004cf0:	892a                	mv	s2,a0
    80004cf2:	dea43423          	sd	a0,-536(s0)
    80004cf6:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004cfa:	ffffd097          	auipc	ra,0xffffd
    80004cfe:	de2080e7          	jalr	-542(ra) # 80001adc <myproc>
    80004d02:	84aa                	mv	s1,a0

  begin_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	4a0080e7          	jalr	1184(ra) # 800041a4 <begin_op>

  if((ip = namei(path)) == 0){
    80004d0c:	854a                	mv	a0,s2
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	276080e7          	jalr	630(ra) # 80003f84 <namei>
    80004d16:	c93d                	beqz	a0,80004d8c <exec+0xc4>
    80004d18:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	aae080e7          	jalr	-1362(ra) # 800037c8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d22:	04000713          	li	a4,64
    80004d26:	4681                	li	a3,0
    80004d28:	e4840613          	addi	a2,s0,-440
    80004d2c:	4581                	li	a1,0
    80004d2e:	8556                	mv	a0,s5
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	d4c080e7          	jalr	-692(ra) # 80003a7c <readi>
    80004d38:	04000793          	li	a5,64
    80004d3c:	00f51a63          	bne	a0,a5,80004d50 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004d40:	e4842703          	lw	a4,-440(s0)
    80004d44:	464c47b7          	lui	a5,0x464c4
    80004d48:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d4c:	04f70663          	beq	a4,a5,80004d98 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d50:	8556                	mv	a0,s5
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	cd8080e7          	jalr	-808(ra) # 80003a2a <iunlockput>
    end_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	4c8080e7          	jalr	1224(ra) # 80004222 <end_op>
  }
  return -1;
    80004d62:	557d                	li	a0,-1
}
    80004d64:	21813083          	ld	ra,536(sp)
    80004d68:	21013403          	ld	s0,528(sp)
    80004d6c:	20813483          	ld	s1,520(sp)
    80004d70:	20013903          	ld	s2,512(sp)
    80004d74:	79fe                	ld	s3,504(sp)
    80004d76:	7a5e                	ld	s4,496(sp)
    80004d78:	7abe                	ld	s5,488(sp)
    80004d7a:	7b1e                	ld	s6,480(sp)
    80004d7c:	6bfe                	ld	s7,472(sp)
    80004d7e:	6c5e                	ld	s8,464(sp)
    80004d80:	6cbe                	ld	s9,456(sp)
    80004d82:	6d1e                	ld	s10,448(sp)
    80004d84:	7dfa                	ld	s11,440(sp)
    80004d86:	22010113          	addi	sp,sp,544
    80004d8a:	8082                	ret
    end_op();
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	496080e7          	jalr	1174(ra) # 80004222 <end_op>
    return -1;
    80004d94:	557d                	li	a0,-1
    80004d96:	b7f9                	j	80004d64 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d98:	8526                	mv	a0,s1
    80004d9a:	ffffd097          	auipc	ra,0xffffd
    80004d9e:	e06080e7          	jalr	-506(ra) # 80001ba0 <proc_pagetable>
    80004da2:	8b2a                	mv	s6,a0
    80004da4:	d555                	beqz	a0,80004d50 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004da6:	e6842783          	lw	a5,-408(s0)
    80004daa:	e8045703          	lhu	a4,-384(s0)
    80004dae:	c735                	beqz	a4,80004e1a <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004db0:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004db2:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004db6:	6a05                	lui	s4,0x1
    80004db8:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004dbc:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004dc0:	6d85                	lui	s11,0x1
    80004dc2:	7d7d                	lui	s10,0xfffff
    80004dc4:	ac1d                	j	80004ffa <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004dc6:	00004517          	auipc	a0,0x4
    80004dca:	91a50513          	addi	a0,a0,-1766 # 800086e0 <syscalls+0x290>
    80004dce:	ffffb097          	auipc	ra,0xffffb
    80004dd2:	76c080e7          	jalr	1900(ra) # 8000053a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004dd6:	874a                	mv	a4,s2
    80004dd8:	009c86bb          	addw	a3,s9,s1
    80004ddc:	4581                	li	a1,0
    80004dde:	8556                	mv	a0,s5
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	c9c080e7          	jalr	-868(ra) # 80003a7c <readi>
    80004de8:	2501                	sext.w	a0,a0
    80004dea:	1aa91863          	bne	s2,a0,80004f9a <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004dee:	009d84bb          	addw	s1,s11,s1
    80004df2:	013d09bb          	addw	s3,s10,s3
    80004df6:	1f74f263          	bgeu	s1,s7,80004fda <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004dfa:	02049593          	slli	a1,s1,0x20
    80004dfe:	9181                	srli	a1,a1,0x20
    80004e00:	95e2                	add	a1,a1,s8
    80004e02:	855a                	mv	a0,s6
    80004e04:	ffffc097          	auipc	ra,0xffffc
    80004e08:	256080e7          	jalr	598(ra) # 8000105a <walkaddr>
    80004e0c:	862a                	mv	a2,a0
    if(pa == 0)
    80004e0e:	dd45                	beqz	a0,80004dc6 <exec+0xfe>
      n = PGSIZE;
    80004e10:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004e12:	fd49f2e3          	bgeu	s3,s4,80004dd6 <exec+0x10e>
      n = sz - i;
    80004e16:	894e                	mv	s2,s3
    80004e18:	bf7d                	j	80004dd6 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004e1a:	4481                	li	s1,0
  iunlockput(ip);
    80004e1c:	8556                	mv	a0,s5
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	c0c080e7          	jalr	-1012(ra) # 80003a2a <iunlockput>
  end_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	3fc080e7          	jalr	1020(ra) # 80004222 <end_op>
  p = myproc();
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	cae080e7          	jalr	-850(ra) # 80001adc <myproc>
    80004e36:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004e38:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004e3c:	6785                	lui	a5,0x1
    80004e3e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004e40:	97a6                	add	a5,a5,s1
    80004e42:	777d                	lui	a4,0xfffff
    80004e44:	8ff9                	and	a5,a5,a4
    80004e46:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e4a:	6609                	lui	a2,0x2
    80004e4c:	963e                	add	a2,a2,a5
    80004e4e:	85be                	mv	a1,a5
    80004e50:	855a                	mv	a0,s6
    80004e52:	ffffc097          	auipc	ra,0xffffc
    80004e56:	5aa080e7          	jalr	1450(ra) # 800013fc <uvmalloc>
    80004e5a:	8c2a                	mv	s8,a0
  ip = 0;
    80004e5c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e5e:	12050e63          	beqz	a0,80004f9a <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e62:	75f9                	lui	a1,0xffffe
    80004e64:	95aa                	add	a1,a1,a0
    80004e66:	855a                	mv	a0,s6
    80004e68:	ffffc097          	auipc	ra,0xffffc
    80004e6c:	7b6080e7          	jalr	1974(ra) # 8000161e <uvmclear>
  stackbase = sp - PGSIZE;
    80004e70:	7afd                	lui	s5,0xfffff
    80004e72:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e74:	df043783          	ld	a5,-528(s0)
    80004e78:	6388                	ld	a0,0(a5)
    80004e7a:	c925                	beqz	a0,80004eea <exec+0x222>
    80004e7c:	e8840993          	addi	s3,s0,-376
    80004e80:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004e84:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e86:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e88:	ffffc097          	auipc	ra,0xffffc
    80004e8c:	fc8080e7          	jalr	-56(ra) # 80000e50 <strlen>
    80004e90:	0015079b          	addiw	a5,a0,1
    80004e94:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e98:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004e9c:	13596363          	bltu	s2,s5,80004fc2 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ea0:	df043d83          	ld	s11,-528(s0)
    80004ea4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004ea8:	8552                	mv	a0,s4
    80004eaa:	ffffc097          	auipc	ra,0xffffc
    80004eae:	fa6080e7          	jalr	-90(ra) # 80000e50 <strlen>
    80004eb2:	0015069b          	addiw	a3,a0,1
    80004eb6:	8652                	mv	a2,s4
    80004eb8:	85ca                	mv	a1,s2
    80004eba:	855a                	mv	a0,s6
    80004ebc:	ffffc097          	auipc	ra,0xffffc
    80004ec0:	794080e7          	jalr	1940(ra) # 80001650 <copyout>
    80004ec4:	10054363          	bltz	a0,80004fca <exec+0x302>
    ustack[argc] = sp;
    80004ec8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004ecc:	0485                	addi	s1,s1,1
    80004ece:	008d8793          	addi	a5,s11,8
    80004ed2:	def43823          	sd	a5,-528(s0)
    80004ed6:	008db503          	ld	a0,8(s11)
    80004eda:	c911                	beqz	a0,80004eee <exec+0x226>
    if(argc >= MAXARG)
    80004edc:	09a1                	addi	s3,s3,8
    80004ede:	fb3c95e3          	bne	s9,s3,80004e88 <exec+0x1c0>
  sz = sz1;
    80004ee2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004ee6:	4a81                	li	s5,0
    80004ee8:	a84d                	j	80004f9a <exec+0x2d2>
  sp = sz;
    80004eea:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004eec:	4481                	li	s1,0
  ustack[argc] = 0;
    80004eee:	00349793          	slli	a5,s1,0x3
    80004ef2:	f9078793          	addi	a5,a5,-112
    80004ef6:	97a2                	add	a5,a5,s0
    80004ef8:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004efc:	00148693          	addi	a3,s1,1
    80004f00:	068e                	slli	a3,a3,0x3
    80004f02:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004f06:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004f0a:	01597663          	bgeu	s2,s5,80004f16 <exec+0x24e>
  sz = sz1;
    80004f0e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f12:	4a81                	li	s5,0
    80004f14:	a059                	j	80004f9a <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004f16:	e8840613          	addi	a2,s0,-376
    80004f1a:	85ca                	mv	a1,s2
    80004f1c:	855a                	mv	a0,s6
    80004f1e:	ffffc097          	auipc	ra,0xffffc
    80004f22:	732080e7          	jalr	1842(ra) # 80001650 <copyout>
    80004f26:	0a054663          	bltz	a0,80004fd2 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004f2a:	058bb783          	ld	a5,88(s7)
    80004f2e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004f32:	de843783          	ld	a5,-536(s0)
    80004f36:	0007c703          	lbu	a4,0(a5)
    80004f3a:	cf11                	beqz	a4,80004f56 <exec+0x28e>
    80004f3c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004f3e:	02f00693          	li	a3,47
    80004f42:	a039                	j	80004f50 <exec+0x288>
      last = s+1;
    80004f44:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004f48:	0785                	addi	a5,a5,1
    80004f4a:	fff7c703          	lbu	a4,-1(a5)
    80004f4e:	c701                	beqz	a4,80004f56 <exec+0x28e>
    if(*s == '/')
    80004f50:	fed71ce3          	bne	a4,a3,80004f48 <exec+0x280>
    80004f54:	bfc5                	j	80004f44 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f56:	4641                	li	a2,16
    80004f58:	de843583          	ld	a1,-536(s0)
    80004f5c:	158b8513          	addi	a0,s7,344
    80004f60:	ffffc097          	auipc	ra,0xffffc
    80004f64:	ebe080e7          	jalr	-322(ra) # 80000e1e <safestrcpy>
  oldpagetable = p->pagetable;
    80004f68:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004f6c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004f70:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f74:	058bb783          	ld	a5,88(s7)
    80004f78:	e6043703          	ld	a4,-416(s0)
    80004f7c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f7e:	058bb783          	ld	a5,88(s7)
    80004f82:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f86:	85ea                	mv	a1,s10
    80004f88:	ffffd097          	auipc	ra,0xffffd
    80004f8c:	cb4080e7          	jalr	-844(ra) # 80001c3c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f90:	0004851b          	sext.w	a0,s1
    80004f94:	bbc1                	j	80004d64 <exec+0x9c>
    80004f96:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004f9a:	df843583          	ld	a1,-520(s0)
    80004f9e:	855a                	mv	a0,s6
    80004fa0:	ffffd097          	auipc	ra,0xffffd
    80004fa4:	c9c080e7          	jalr	-868(ra) # 80001c3c <proc_freepagetable>
  if(ip){
    80004fa8:	da0a94e3          	bnez	s5,80004d50 <exec+0x88>
  return -1;
    80004fac:	557d                	li	a0,-1
    80004fae:	bb5d                	j	80004d64 <exec+0x9c>
    80004fb0:	de943c23          	sd	s1,-520(s0)
    80004fb4:	b7dd                	j	80004f9a <exec+0x2d2>
    80004fb6:	de943c23          	sd	s1,-520(s0)
    80004fba:	b7c5                	j	80004f9a <exec+0x2d2>
    80004fbc:	de943c23          	sd	s1,-520(s0)
    80004fc0:	bfe9                	j	80004f9a <exec+0x2d2>
  sz = sz1;
    80004fc2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004fc6:	4a81                	li	s5,0
    80004fc8:	bfc9                	j	80004f9a <exec+0x2d2>
  sz = sz1;
    80004fca:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004fce:	4a81                	li	s5,0
    80004fd0:	b7e9                	j	80004f9a <exec+0x2d2>
  sz = sz1;
    80004fd2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004fd6:	4a81                	li	s5,0
    80004fd8:	b7c9                	j	80004f9a <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004fda:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004fde:	e0843783          	ld	a5,-504(s0)
    80004fe2:	0017869b          	addiw	a3,a5,1
    80004fe6:	e0d43423          	sd	a3,-504(s0)
    80004fea:	e0043783          	ld	a5,-512(s0)
    80004fee:	0387879b          	addiw	a5,a5,56
    80004ff2:	e8045703          	lhu	a4,-384(s0)
    80004ff6:	e2e6d3e3          	bge	a3,a4,80004e1c <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004ffa:	2781                	sext.w	a5,a5
    80004ffc:	e0f43023          	sd	a5,-512(s0)
    80005000:	03800713          	li	a4,56
    80005004:	86be                	mv	a3,a5
    80005006:	e1040613          	addi	a2,s0,-496
    8000500a:	4581                	li	a1,0
    8000500c:	8556                	mv	a0,s5
    8000500e:	fffff097          	auipc	ra,0xfffff
    80005012:	a6e080e7          	jalr	-1426(ra) # 80003a7c <readi>
    80005016:	03800793          	li	a5,56
    8000501a:	f6f51ee3          	bne	a0,a5,80004f96 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000501e:	e1042783          	lw	a5,-496(s0)
    80005022:	4705                	li	a4,1
    80005024:	fae79de3          	bne	a5,a4,80004fde <exec+0x316>
    if(ph.memsz < ph.filesz)
    80005028:	e3843603          	ld	a2,-456(s0)
    8000502c:	e3043783          	ld	a5,-464(s0)
    80005030:	f8f660e3          	bltu	a2,a5,80004fb0 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005034:	e2043783          	ld	a5,-480(s0)
    80005038:	963e                	add	a2,a2,a5
    8000503a:	f6f66ee3          	bltu	a2,a5,80004fb6 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000503e:	85a6                	mv	a1,s1
    80005040:	855a                	mv	a0,s6
    80005042:	ffffc097          	auipc	ra,0xffffc
    80005046:	3ba080e7          	jalr	954(ra) # 800013fc <uvmalloc>
    8000504a:	dea43c23          	sd	a0,-520(s0)
    8000504e:	d53d                	beqz	a0,80004fbc <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    80005050:	e2043c03          	ld	s8,-480(s0)
    80005054:	de043783          	ld	a5,-544(s0)
    80005058:	00fc77b3          	and	a5,s8,a5
    8000505c:	ff9d                	bnez	a5,80004f9a <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000505e:	e1842c83          	lw	s9,-488(s0)
    80005062:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005066:	f60b8ae3          	beqz	s7,80004fda <exec+0x312>
    8000506a:	89de                	mv	s3,s7
    8000506c:	4481                	li	s1,0
    8000506e:	b371                	j	80004dfa <exec+0x132>

0000000080005070 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005070:	7179                	addi	sp,sp,-48
    80005072:	f406                	sd	ra,40(sp)
    80005074:	f022                	sd	s0,32(sp)
    80005076:	ec26                	sd	s1,24(sp)
    80005078:	e84a                	sd	s2,16(sp)
    8000507a:	1800                	addi	s0,sp,48
    8000507c:	892e                	mv	s2,a1
    8000507e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005080:	fdc40593          	addi	a1,s0,-36
    80005084:	ffffe097          	auipc	ra,0xffffe
    80005088:	bd2080e7          	jalr	-1070(ra) # 80002c56 <argint>
    8000508c:	04054063          	bltz	a0,800050cc <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005090:	fdc42703          	lw	a4,-36(s0)
    80005094:	47bd                	li	a5,15
    80005096:	02e7ed63          	bltu	a5,a4,800050d0 <argfd+0x60>
    8000509a:	ffffd097          	auipc	ra,0xffffd
    8000509e:	a42080e7          	jalr	-1470(ra) # 80001adc <myproc>
    800050a2:	fdc42703          	lw	a4,-36(s0)
    800050a6:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffcd01a>
    800050aa:	078e                	slli	a5,a5,0x3
    800050ac:	953e                	add	a0,a0,a5
    800050ae:	611c                	ld	a5,0(a0)
    800050b0:	c395                	beqz	a5,800050d4 <argfd+0x64>
    return -1;
  if(pfd)
    800050b2:	00090463          	beqz	s2,800050ba <argfd+0x4a>
    *pfd = fd;
    800050b6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800050ba:	4501                	li	a0,0
  if(pf)
    800050bc:	c091                	beqz	s1,800050c0 <argfd+0x50>
    *pf = f;
    800050be:	e09c                	sd	a5,0(s1)
}
    800050c0:	70a2                	ld	ra,40(sp)
    800050c2:	7402                	ld	s0,32(sp)
    800050c4:	64e2                	ld	s1,24(sp)
    800050c6:	6942                	ld	s2,16(sp)
    800050c8:	6145                	addi	sp,sp,48
    800050ca:	8082                	ret
    return -1;
    800050cc:	557d                	li	a0,-1
    800050ce:	bfcd                	j	800050c0 <argfd+0x50>
    return -1;
    800050d0:	557d                	li	a0,-1
    800050d2:	b7fd                	j	800050c0 <argfd+0x50>
    800050d4:	557d                	li	a0,-1
    800050d6:	b7ed                	j	800050c0 <argfd+0x50>

00000000800050d8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800050d8:	1101                	addi	sp,sp,-32
    800050da:	ec06                	sd	ra,24(sp)
    800050dc:	e822                	sd	s0,16(sp)
    800050de:	e426                	sd	s1,8(sp)
    800050e0:	1000                	addi	s0,sp,32
    800050e2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800050e4:	ffffd097          	auipc	ra,0xffffd
    800050e8:	9f8080e7          	jalr	-1544(ra) # 80001adc <myproc>
    800050ec:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800050ee:	0d050793          	addi	a5,a0,208
    800050f2:	4501                	li	a0,0
    800050f4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800050f6:	6398                	ld	a4,0(a5)
    800050f8:	cb19                	beqz	a4,8000510e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800050fa:	2505                	addiw	a0,a0,1
    800050fc:	07a1                	addi	a5,a5,8
    800050fe:	fed51ce3          	bne	a0,a3,800050f6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005102:	557d                	li	a0,-1
}
    80005104:	60e2                	ld	ra,24(sp)
    80005106:	6442                	ld	s0,16(sp)
    80005108:	64a2                	ld	s1,8(sp)
    8000510a:	6105                	addi	sp,sp,32
    8000510c:	8082                	ret
      p->ofile[fd] = f;
    8000510e:	01a50793          	addi	a5,a0,26
    80005112:	078e                	slli	a5,a5,0x3
    80005114:	963e                	add	a2,a2,a5
    80005116:	e204                	sd	s1,0(a2)
      return fd;
    80005118:	b7f5                	j	80005104 <fdalloc+0x2c>

000000008000511a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000511a:	715d                	addi	sp,sp,-80
    8000511c:	e486                	sd	ra,72(sp)
    8000511e:	e0a2                	sd	s0,64(sp)
    80005120:	fc26                	sd	s1,56(sp)
    80005122:	f84a                	sd	s2,48(sp)
    80005124:	f44e                	sd	s3,40(sp)
    80005126:	f052                	sd	s4,32(sp)
    80005128:	ec56                	sd	s5,24(sp)
    8000512a:	0880                	addi	s0,sp,80
    8000512c:	89ae                	mv	s3,a1
    8000512e:	8ab2                	mv	s5,a2
    80005130:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005132:	fb040593          	addi	a1,s0,-80
    80005136:	fffff097          	auipc	ra,0xfffff
    8000513a:	e6c080e7          	jalr	-404(ra) # 80003fa2 <nameiparent>
    8000513e:	892a                	mv	s2,a0
    80005140:	12050e63          	beqz	a0,8000527c <create+0x162>
    return 0;

  ilock(dp);
    80005144:	ffffe097          	auipc	ra,0xffffe
    80005148:	684080e7          	jalr	1668(ra) # 800037c8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000514c:	4601                	li	a2,0
    8000514e:	fb040593          	addi	a1,s0,-80
    80005152:	854a                	mv	a0,s2
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	b58080e7          	jalr	-1192(ra) # 80003cac <dirlookup>
    8000515c:	84aa                	mv	s1,a0
    8000515e:	c921                	beqz	a0,800051ae <create+0x94>
    iunlockput(dp);
    80005160:	854a                	mv	a0,s2
    80005162:	fffff097          	auipc	ra,0xfffff
    80005166:	8c8080e7          	jalr	-1848(ra) # 80003a2a <iunlockput>
    ilock(ip);
    8000516a:	8526                	mv	a0,s1
    8000516c:	ffffe097          	auipc	ra,0xffffe
    80005170:	65c080e7          	jalr	1628(ra) # 800037c8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005174:	2981                	sext.w	s3,s3
    80005176:	4789                	li	a5,2
    80005178:	02f99463          	bne	s3,a5,800051a0 <create+0x86>
    8000517c:	0444d783          	lhu	a5,68(s1)
    80005180:	37f9                	addiw	a5,a5,-2
    80005182:	17c2                	slli	a5,a5,0x30
    80005184:	93c1                	srli	a5,a5,0x30
    80005186:	4705                	li	a4,1
    80005188:	00f76c63          	bltu	a4,a5,800051a0 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000518c:	8526                	mv	a0,s1
    8000518e:	60a6                	ld	ra,72(sp)
    80005190:	6406                	ld	s0,64(sp)
    80005192:	74e2                	ld	s1,56(sp)
    80005194:	7942                	ld	s2,48(sp)
    80005196:	79a2                	ld	s3,40(sp)
    80005198:	7a02                	ld	s4,32(sp)
    8000519a:	6ae2                	ld	s5,24(sp)
    8000519c:	6161                	addi	sp,sp,80
    8000519e:	8082                	ret
    iunlockput(ip);
    800051a0:	8526                	mv	a0,s1
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	888080e7          	jalr	-1912(ra) # 80003a2a <iunlockput>
    return 0;
    800051aa:	4481                	li	s1,0
    800051ac:	b7c5                	j	8000518c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800051ae:	85ce                	mv	a1,s3
    800051b0:	00092503          	lw	a0,0(s2)
    800051b4:	ffffe097          	auipc	ra,0xffffe
    800051b8:	47a080e7          	jalr	1146(ra) # 8000362e <ialloc>
    800051bc:	84aa                	mv	s1,a0
    800051be:	c521                	beqz	a0,80005206 <create+0xec>
  ilock(ip);
    800051c0:	ffffe097          	auipc	ra,0xffffe
    800051c4:	608080e7          	jalr	1544(ra) # 800037c8 <ilock>
  ip->major = major;
    800051c8:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800051cc:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800051d0:	4a05                	li	s4,1
    800051d2:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800051d6:	8526                	mv	a0,s1
    800051d8:	ffffe097          	auipc	ra,0xffffe
    800051dc:	524080e7          	jalr	1316(ra) # 800036fc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800051e0:	2981                	sext.w	s3,s3
    800051e2:	03498a63          	beq	s3,s4,80005216 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800051e6:	40d0                	lw	a2,4(s1)
    800051e8:	fb040593          	addi	a1,s0,-80
    800051ec:	854a                	mv	a0,s2
    800051ee:	fffff097          	auipc	ra,0xfffff
    800051f2:	cd4080e7          	jalr	-812(ra) # 80003ec2 <dirlink>
    800051f6:	06054b63          	bltz	a0,8000526c <create+0x152>
  iunlockput(dp);
    800051fa:	854a                	mv	a0,s2
    800051fc:	fffff097          	auipc	ra,0xfffff
    80005200:	82e080e7          	jalr	-2002(ra) # 80003a2a <iunlockput>
  return ip;
    80005204:	b761                	j	8000518c <create+0x72>
    panic("create: ialloc");
    80005206:	00003517          	auipc	a0,0x3
    8000520a:	4fa50513          	addi	a0,a0,1274 # 80008700 <syscalls+0x2b0>
    8000520e:	ffffb097          	auipc	ra,0xffffb
    80005212:	32c080e7          	jalr	812(ra) # 8000053a <panic>
    dp->nlink++;  // for ".."
    80005216:	04a95783          	lhu	a5,74(s2)
    8000521a:	2785                	addiw	a5,a5,1
    8000521c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005220:	854a                	mv	a0,s2
    80005222:	ffffe097          	auipc	ra,0xffffe
    80005226:	4da080e7          	jalr	1242(ra) # 800036fc <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000522a:	40d0                	lw	a2,4(s1)
    8000522c:	00003597          	auipc	a1,0x3
    80005230:	4e458593          	addi	a1,a1,1252 # 80008710 <syscalls+0x2c0>
    80005234:	8526                	mv	a0,s1
    80005236:	fffff097          	auipc	ra,0xfffff
    8000523a:	c8c080e7          	jalr	-884(ra) # 80003ec2 <dirlink>
    8000523e:	00054f63          	bltz	a0,8000525c <create+0x142>
    80005242:	00492603          	lw	a2,4(s2)
    80005246:	00003597          	auipc	a1,0x3
    8000524a:	4d258593          	addi	a1,a1,1234 # 80008718 <syscalls+0x2c8>
    8000524e:	8526                	mv	a0,s1
    80005250:	fffff097          	auipc	ra,0xfffff
    80005254:	c72080e7          	jalr	-910(ra) # 80003ec2 <dirlink>
    80005258:	f80557e3          	bgez	a0,800051e6 <create+0xcc>
      panic("create dots");
    8000525c:	00003517          	auipc	a0,0x3
    80005260:	4c450513          	addi	a0,a0,1220 # 80008720 <syscalls+0x2d0>
    80005264:	ffffb097          	auipc	ra,0xffffb
    80005268:	2d6080e7          	jalr	726(ra) # 8000053a <panic>
    panic("create: dirlink");
    8000526c:	00003517          	auipc	a0,0x3
    80005270:	4c450513          	addi	a0,a0,1220 # 80008730 <syscalls+0x2e0>
    80005274:	ffffb097          	auipc	ra,0xffffb
    80005278:	2c6080e7          	jalr	710(ra) # 8000053a <panic>
    return 0;
    8000527c:	84aa                	mv	s1,a0
    8000527e:	b739                	j	8000518c <create+0x72>

0000000080005280 <sys_dup>:
{
    80005280:	7179                	addi	sp,sp,-48
    80005282:	f406                	sd	ra,40(sp)
    80005284:	f022                	sd	s0,32(sp)
    80005286:	ec26                	sd	s1,24(sp)
    80005288:	e84a                	sd	s2,16(sp)
    8000528a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000528c:	fd840613          	addi	a2,s0,-40
    80005290:	4581                	li	a1,0
    80005292:	4501                	li	a0,0
    80005294:	00000097          	auipc	ra,0x0
    80005298:	ddc080e7          	jalr	-548(ra) # 80005070 <argfd>
    return -1;
    8000529c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000529e:	02054363          	bltz	a0,800052c4 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800052a2:	fd843903          	ld	s2,-40(s0)
    800052a6:	854a                	mv	a0,s2
    800052a8:	00000097          	auipc	ra,0x0
    800052ac:	e30080e7          	jalr	-464(ra) # 800050d8 <fdalloc>
    800052b0:	84aa                	mv	s1,a0
    return -1;
    800052b2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052b4:	00054863          	bltz	a0,800052c4 <sys_dup+0x44>
  filedup(f);
    800052b8:	854a                	mv	a0,s2
    800052ba:	fffff097          	auipc	ra,0xfffff
    800052be:	368080e7          	jalr	872(ra) # 80004622 <filedup>
  return fd;
    800052c2:	87a6                	mv	a5,s1
}
    800052c4:	853e                	mv	a0,a5
    800052c6:	70a2                	ld	ra,40(sp)
    800052c8:	7402                	ld	s0,32(sp)
    800052ca:	64e2                	ld	s1,24(sp)
    800052cc:	6942                	ld	s2,16(sp)
    800052ce:	6145                	addi	sp,sp,48
    800052d0:	8082                	ret

00000000800052d2 <sys_read>:
{
    800052d2:	7179                	addi	sp,sp,-48
    800052d4:	f406                	sd	ra,40(sp)
    800052d6:	f022                	sd	s0,32(sp)
    800052d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052da:	fe840613          	addi	a2,s0,-24
    800052de:	4581                	li	a1,0
    800052e0:	4501                	li	a0,0
    800052e2:	00000097          	auipc	ra,0x0
    800052e6:	d8e080e7          	jalr	-626(ra) # 80005070 <argfd>
    return -1;
    800052ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052ec:	04054163          	bltz	a0,8000532e <sys_read+0x5c>
    800052f0:	fe440593          	addi	a1,s0,-28
    800052f4:	4509                	li	a0,2
    800052f6:	ffffe097          	auipc	ra,0xffffe
    800052fa:	960080e7          	jalr	-1696(ra) # 80002c56 <argint>
    return -1;
    800052fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005300:	02054763          	bltz	a0,8000532e <sys_read+0x5c>
    80005304:	fd840593          	addi	a1,s0,-40
    80005308:	4505                	li	a0,1
    8000530a:	ffffe097          	auipc	ra,0xffffe
    8000530e:	96e080e7          	jalr	-1682(ra) # 80002c78 <argaddr>
    return -1;
    80005312:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005314:	00054d63          	bltz	a0,8000532e <sys_read+0x5c>
  return fileread(f, p, n);
    80005318:	fe442603          	lw	a2,-28(s0)
    8000531c:	fd843583          	ld	a1,-40(s0)
    80005320:	fe843503          	ld	a0,-24(s0)
    80005324:	fffff097          	auipc	ra,0xfffff
    80005328:	48a080e7          	jalr	1162(ra) # 800047ae <fileread>
    8000532c:	87aa                	mv	a5,a0
}
    8000532e:	853e                	mv	a0,a5
    80005330:	70a2                	ld	ra,40(sp)
    80005332:	7402                	ld	s0,32(sp)
    80005334:	6145                	addi	sp,sp,48
    80005336:	8082                	ret

0000000080005338 <sys_write>:
{
    80005338:	7179                	addi	sp,sp,-48
    8000533a:	f406                	sd	ra,40(sp)
    8000533c:	f022                	sd	s0,32(sp)
    8000533e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005340:	fe840613          	addi	a2,s0,-24
    80005344:	4581                	li	a1,0
    80005346:	4501                	li	a0,0
    80005348:	00000097          	auipc	ra,0x0
    8000534c:	d28080e7          	jalr	-728(ra) # 80005070 <argfd>
    return -1;
    80005350:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005352:	04054163          	bltz	a0,80005394 <sys_write+0x5c>
    80005356:	fe440593          	addi	a1,s0,-28
    8000535a:	4509                	li	a0,2
    8000535c:	ffffe097          	auipc	ra,0xffffe
    80005360:	8fa080e7          	jalr	-1798(ra) # 80002c56 <argint>
    return -1;
    80005364:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005366:	02054763          	bltz	a0,80005394 <sys_write+0x5c>
    8000536a:	fd840593          	addi	a1,s0,-40
    8000536e:	4505                	li	a0,1
    80005370:	ffffe097          	auipc	ra,0xffffe
    80005374:	908080e7          	jalr	-1784(ra) # 80002c78 <argaddr>
    return -1;
    80005378:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000537a:	00054d63          	bltz	a0,80005394 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000537e:	fe442603          	lw	a2,-28(s0)
    80005382:	fd843583          	ld	a1,-40(s0)
    80005386:	fe843503          	ld	a0,-24(s0)
    8000538a:	fffff097          	auipc	ra,0xfffff
    8000538e:	4e6080e7          	jalr	1254(ra) # 80004870 <filewrite>
    80005392:	87aa                	mv	a5,a0
}
    80005394:	853e                	mv	a0,a5
    80005396:	70a2                	ld	ra,40(sp)
    80005398:	7402                	ld	s0,32(sp)
    8000539a:	6145                	addi	sp,sp,48
    8000539c:	8082                	ret

000000008000539e <sys_close>:
{
    8000539e:	1101                	addi	sp,sp,-32
    800053a0:	ec06                	sd	ra,24(sp)
    800053a2:	e822                	sd	s0,16(sp)
    800053a4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053a6:	fe040613          	addi	a2,s0,-32
    800053aa:	fec40593          	addi	a1,s0,-20
    800053ae:	4501                	li	a0,0
    800053b0:	00000097          	auipc	ra,0x0
    800053b4:	cc0080e7          	jalr	-832(ra) # 80005070 <argfd>
    return -1;
    800053b8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053ba:	02054463          	bltz	a0,800053e2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800053be:	ffffc097          	auipc	ra,0xffffc
    800053c2:	71e080e7          	jalr	1822(ra) # 80001adc <myproc>
    800053c6:	fec42783          	lw	a5,-20(s0)
    800053ca:	07e9                	addi	a5,a5,26
    800053cc:	078e                	slli	a5,a5,0x3
    800053ce:	953e                	add	a0,a0,a5
    800053d0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800053d4:	fe043503          	ld	a0,-32(s0)
    800053d8:	fffff097          	auipc	ra,0xfffff
    800053dc:	29c080e7          	jalr	668(ra) # 80004674 <fileclose>
  return 0;
    800053e0:	4781                	li	a5,0
}
    800053e2:	853e                	mv	a0,a5
    800053e4:	60e2                	ld	ra,24(sp)
    800053e6:	6442                	ld	s0,16(sp)
    800053e8:	6105                	addi	sp,sp,32
    800053ea:	8082                	ret

00000000800053ec <sys_fstat>:
{
    800053ec:	1101                	addi	sp,sp,-32
    800053ee:	ec06                	sd	ra,24(sp)
    800053f0:	e822                	sd	s0,16(sp)
    800053f2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800053f4:	fe840613          	addi	a2,s0,-24
    800053f8:	4581                	li	a1,0
    800053fa:	4501                	li	a0,0
    800053fc:	00000097          	auipc	ra,0x0
    80005400:	c74080e7          	jalr	-908(ra) # 80005070 <argfd>
    return -1;
    80005404:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005406:	02054563          	bltz	a0,80005430 <sys_fstat+0x44>
    8000540a:	fe040593          	addi	a1,s0,-32
    8000540e:	4505                	li	a0,1
    80005410:	ffffe097          	auipc	ra,0xffffe
    80005414:	868080e7          	jalr	-1944(ra) # 80002c78 <argaddr>
    return -1;
    80005418:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000541a:	00054b63          	bltz	a0,80005430 <sys_fstat+0x44>
  return filestat(f, st);
    8000541e:	fe043583          	ld	a1,-32(s0)
    80005422:	fe843503          	ld	a0,-24(s0)
    80005426:	fffff097          	auipc	ra,0xfffff
    8000542a:	316080e7          	jalr	790(ra) # 8000473c <filestat>
    8000542e:	87aa                	mv	a5,a0
}
    80005430:	853e                	mv	a0,a5
    80005432:	60e2                	ld	ra,24(sp)
    80005434:	6442                	ld	s0,16(sp)
    80005436:	6105                	addi	sp,sp,32
    80005438:	8082                	ret

000000008000543a <sys_link>:
{
    8000543a:	7169                	addi	sp,sp,-304
    8000543c:	f606                	sd	ra,296(sp)
    8000543e:	f222                	sd	s0,288(sp)
    80005440:	ee26                	sd	s1,280(sp)
    80005442:	ea4a                	sd	s2,272(sp)
    80005444:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005446:	08000613          	li	a2,128
    8000544a:	ed040593          	addi	a1,s0,-304
    8000544e:	4501                	li	a0,0
    80005450:	ffffe097          	auipc	ra,0xffffe
    80005454:	84a080e7          	jalr	-1974(ra) # 80002c9a <argstr>
    return -1;
    80005458:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000545a:	10054e63          	bltz	a0,80005576 <sys_link+0x13c>
    8000545e:	08000613          	li	a2,128
    80005462:	f5040593          	addi	a1,s0,-176
    80005466:	4505                	li	a0,1
    80005468:	ffffe097          	auipc	ra,0xffffe
    8000546c:	832080e7          	jalr	-1998(ra) # 80002c9a <argstr>
    return -1;
    80005470:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005472:	10054263          	bltz	a0,80005576 <sys_link+0x13c>
  begin_op();
    80005476:	fffff097          	auipc	ra,0xfffff
    8000547a:	d2e080e7          	jalr	-722(ra) # 800041a4 <begin_op>
  if((ip = namei(old)) == 0){
    8000547e:	ed040513          	addi	a0,s0,-304
    80005482:	fffff097          	auipc	ra,0xfffff
    80005486:	b02080e7          	jalr	-1278(ra) # 80003f84 <namei>
    8000548a:	84aa                	mv	s1,a0
    8000548c:	c551                	beqz	a0,80005518 <sys_link+0xde>
  ilock(ip);
    8000548e:	ffffe097          	auipc	ra,0xffffe
    80005492:	33a080e7          	jalr	826(ra) # 800037c8 <ilock>
  if(ip->type == T_DIR){
    80005496:	04449703          	lh	a4,68(s1)
    8000549a:	4785                	li	a5,1
    8000549c:	08f70463          	beq	a4,a5,80005524 <sys_link+0xea>
  ip->nlink++;
    800054a0:	04a4d783          	lhu	a5,74(s1)
    800054a4:	2785                	addiw	a5,a5,1
    800054a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054aa:	8526                	mv	a0,s1
    800054ac:	ffffe097          	auipc	ra,0xffffe
    800054b0:	250080e7          	jalr	592(ra) # 800036fc <iupdate>
  iunlock(ip);
    800054b4:	8526                	mv	a0,s1
    800054b6:	ffffe097          	auipc	ra,0xffffe
    800054ba:	3d4080e7          	jalr	980(ra) # 8000388a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054be:	fd040593          	addi	a1,s0,-48
    800054c2:	f5040513          	addi	a0,s0,-176
    800054c6:	fffff097          	auipc	ra,0xfffff
    800054ca:	adc080e7          	jalr	-1316(ra) # 80003fa2 <nameiparent>
    800054ce:	892a                	mv	s2,a0
    800054d0:	c935                	beqz	a0,80005544 <sys_link+0x10a>
  ilock(dp);
    800054d2:	ffffe097          	auipc	ra,0xffffe
    800054d6:	2f6080e7          	jalr	758(ra) # 800037c8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054da:	00092703          	lw	a4,0(s2)
    800054de:	409c                	lw	a5,0(s1)
    800054e0:	04f71d63          	bne	a4,a5,8000553a <sys_link+0x100>
    800054e4:	40d0                	lw	a2,4(s1)
    800054e6:	fd040593          	addi	a1,s0,-48
    800054ea:	854a                	mv	a0,s2
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	9d6080e7          	jalr	-1578(ra) # 80003ec2 <dirlink>
    800054f4:	04054363          	bltz	a0,8000553a <sys_link+0x100>
  iunlockput(dp);
    800054f8:	854a                	mv	a0,s2
    800054fa:	ffffe097          	auipc	ra,0xffffe
    800054fe:	530080e7          	jalr	1328(ra) # 80003a2a <iunlockput>
  iput(ip);
    80005502:	8526                	mv	a0,s1
    80005504:	ffffe097          	auipc	ra,0xffffe
    80005508:	47e080e7          	jalr	1150(ra) # 80003982 <iput>
  end_op();
    8000550c:	fffff097          	auipc	ra,0xfffff
    80005510:	d16080e7          	jalr	-746(ra) # 80004222 <end_op>
  return 0;
    80005514:	4781                	li	a5,0
    80005516:	a085                	j	80005576 <sys_link+0x13c>
    end_op();
    80005518:	fffff097          	auipc	ra,0xfffff
    8000551c:	d0a080e7          	jalr	-758(ra) # 80004222 <end_op>
    return -1;
    80005520:	57fd                	li	a5,-1
    80005522:	a891                	j	80005576 <sys_link+0x13c>
    iunlockput(ip);
    80005524:	8526                	mv	a0,s1
    80005526:	ffffe097          	auipc	ra,0xffffe
    8000552a:	504080e7          	jalr	1284(ra) # 80003a2a <iunlockput>
    end_op();
    8000552e:	fffff097          	auipc	ra,0xfffff
    80005532:	cf4080e7          	jalr	-780(ra) # 80004222 <end_op>
    return -1;
    80005536:	57fd                	li	a5,-1
    80005538:	a83d                	j	80005576 <sys_link+0x13c>
    iunlockput(dp);
    8000553a:	854a                	mv	a0,s2
    8000553c:	ffffe097          	auipc	ra,0xffffe
    80005540:	4ee080e7          	jalr	1262(ra) # 80003a2a <iunlockput>
  ilock(ip);
    80005544:	8526                	mv	a0,s1
    80005546:	ffffe097          	auipc	ra,0xffffe
    8000554a:	282080e7          	jalr	642(ra) # 800037c8 <ilock>
  ip->nlink--;
    8000554e:	04a4d783          	lhu	a5,74(s1)
    80005552:	37fd                	addiw	a5,a5,-1
    80005554:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005558:	8526                	mv	a0,s1
    8000555a:	ffffe097          	auipc	ra,0xffffe
    8000555e:	1a2080e7          	jalr	418(ra) # 800036fc <iupdate>
  iunlockput(ip);
    80005562:	8526                	mv	a0,s1
    80005564:	ffffe097          	auipc	ra,0xffffe
    80005568:	4c6080e7          	jalr	1222(ra) # 80003a2a <iunlockput>
  end_op();
    8000556c:	fffff097          	auipc	ra,0xfffff
    80005570:	cb6080e7          	jalr	-842(ra) # 80004222 <end_op>
  return -1;
    80005574:	57fd                	li	a5,-1
}
    80005576:	853e                	mv	a0,a5
    80005578:	70b2                	ld	ra,296(sp)
    8000557a:	7412                	ld	s0,288(sp)
    8000557c:	64f2                	ld	s1,280(sp)
    8000557e:	6952                	ld	s2,272(sp)
    80005580:	6155                	addi	sp,sp,304
    80005582:	8082                	ret

0000000080005584 <sys_unlink>:
{
    80005584:	7151                	addi	sp,sp,-240
    80005586:	f586                	sd	ra,232(sp)
    80005588:	f1a2                	sd	s0,224(sp)
    8000558a:	eda6                	sd	s1,216(sp)
    8000558c:	e9ca                	sd	s2,208(sp)
    8000558e:	e5ce                	sd	s3,200(sp)
    80005590:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005592:	08000613          	li	a2,128
    80005596:	f3040593          	addi	a1,s0,-208
    8000559a:	4501                	li	a0,0
    8000559c:	ffffd097          	auipc	ra,0xffffd
    800055a0:	6fe080e7          	jalr	1790(ra) # 80002c9a <argstr>
    800055a4:	18054163          	bltz	a0,80005726 <sys_unlink+0x1a2>
  begin_op();
    800055a8:	fffff097          	auipc	ra,0xfffff
    800055ac:	bfc080e7          	jalr	-1028(ra) # 800041a4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800055b0:	fb040593          	addi	a1,s0,-80
    800055b4:	f3040513          	addi	a0,s0,-208
    800055b8:	fffff097          	auipc	ra,0xfffff
    800055bc:	9ea080e7          	jalr	-1558(ra) # 80003fa2 <nameiparent>
    800055c0:	84aa                	mv	s1,a0
    800055c2:	c979                	beqz	a0,80005698 <sys_unlink+0x114>
  ilock(dp);
    800055c4:	ffffe097          	auipc	ra,0xffffe
    800055c8:	204080e7          	jalr	516(ra) # 800037c8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800055cc:	00003597          	auipc	a1,0x3
    800055d0:	14458593          	addi	a1,a1,324 # 80008710 <syscalls+0x2c0>
    800055d4:	fb040513          	addi	a0,s0,-80
    800055d8:	ffffe097          	auipc	ra,0xffffe
    800055dc:	6ba080e7          	jalr	1722(ra) # 80003c92 <namecmp>
    800055e0:	14050a63          	beqz	a0,80005734 <sys_unlink+0x1b0>
    800055e4:	00003597          	auipc	a1,0x3
    800055e8:	13458593          	addi	a1,a1,308 # 80008718 <syscalls+0x2c8>
    800055ec:	fb040513          	addi	a0,s0,-80
    800055f0:	ffffe097          	auipc	ra,0xffffe
    800055f4:	6a2080e7          	jalr	1698(ra) # 80003c92 <namecmp>
    800055f8:	12050e63          	beqz	a0,80005734 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800055fc:	f2c40613          	addi	a2,s0,-212
    80005600:	fb040593          	addi	a1,s0,-80
    80005604:	8526                	mv	a0,s1
    80005606:	ffffe097          	auipc	ra,0xffffe
    8000560a:	6a6080e7          	jalr	1702(ra) # 80003cac <dirlookup>
    8000560e:	892a                	mv	s2,a0
    80005610:	12050263          	beqz	a0,80005734 <sys_unlink+0x1b0>
  ilock(ip);
    80005614:	ffffe097          	auipc	ra,0xffffe
    80005618:	1b4080e7          	jalr	436(ra) # 800037c8 <ilock>
  if(ip->nlink < 1)
    8000561c:	04a91783          	lh	a5,74(s2)
    80005620:	08f05263          	blez	a5,800056a4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005624:	04491703          	lh	a4,68(s2)
    80005628:	4785                	li	a5,1
    8000562a:	08f70563          	beq	a4,a5,800056b4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000562e:	4641                	li	a2,16
    80005630:	4581                	li	a1,0
    80005632:	fc040513          	addi	a0,s0,-64
    80005636:	ffffb097          	auipc	ra,0xffffb
    8000563a:	696080e7          	jalr	1686(ra) # 80000ccc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000563e:	4741                	li	a4,16
    80005640:	f2c42683          	lw	a3,-212(s0)
    80005644:	fc040613          	addi	a2,s0,-64
    80005648:	4581                	li	a1,0
    8000564a:	8526                	mv	a0,s1
    8000564c:	ffffe097          	auipc	ra,0xffffe
    80005650:	528080e7          	jalr	1320(ra) # 80003b74 <writei>
    80005654:	47c1                	li	a5,16
    80005656:	0af51563          	bne	a0,a5,80005700 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000565a:	04491703          	lh	a4,68(s2)
    8000565e:	4785                	li	a5,1
    80005660:	0af70863          	beq	a4,a5,80005710 <sys_unlink+0x18c>
  iunlockput(dp);
    80005664:	8526                	mv	a0,s1
    80005666:	ffffe097          	auipc	ra,0xffffe
    8000566a:	3c4080e7          	jalr	964(ra) # 80003a2a <iunlockput>
  ip->nlink--;
    8000566e:	04a95783          	lhu	a5,74(s2)
    80005672:	37fd                	addiw	a5,a5,-1
    80005674:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005678:	854a                	mv	a0,s2
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	082080e7          	jalr	130(ra) # 800036fc <iupdate>
  iunlockput(ip);
    80005682:	854a                	mv	a0,s2
    80005684:	ffffe097          	auipc	ra,0xffffe
    80005688:	3a6080e7          	jalr	934(ra) # 80003a2a <iunlockput>
  end_op();
    8000568c:	fffff097          	auipc	ra,0xfffff
    80005690:	b96080e7          	jalr	-1130(ra) # 80004222 <end_op>
  return 0;
    80005694:	4501                	li	a0,0
    80005696:	a84d                	j	80005748 <sys_unlink+0x1c4>
    end_op();
    80005698:	fffff097          	auipc	ra,0xfffff
    8000569c:	b8a080e7          	jalr	-1142(ra) # 80004222 <end_op>
    return -1;
    800056a0:	557d                	li	a0,-1
    800056a2:	a05d                	j	80005748 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800056a4:	00003517          	auipc	a0,0x3
    800056a8:	09c50513          	addi	a0,a0,156 # 80008740 <syscalls+0x2f0>
    800056ac:	ffffb097          	auipc	ra,0xffffb
    800056b0:	e8e080e7          	jalr	-370(ra) # 8000053a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056b4:	04c92703          	lw	a4,76(s2)
    800056b8:	02000793          	li	a5,32
    800056bc:	f6e7f9e3          	bgeu	a5,a4,8000562e <sys_unlink+0xaa>
    800056c0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056c4:	4741                	li	a4,16
    800056c6:	86ce                	mv	a3,s3
    800056c8:	f1840613          	addi	a2,s0,-232
    800056cc:	4581                	li	a1,0
    800056ce:	854a                	mv	a0,s2
    800056d0:	ffffe097          	auipc	ra,0xffffe
    800056d4:	3ac080e7          	jalr	940(ra) # 80003a7c <readi>
    800056d8:	47c1                	li	a5,16
    800056da:	00f51b63          	bne	a0,a5,800056f0 <sys_unlink+0x16c>
    if(de.inum != 0)
    800056de:	f1845783          	lhu	a5,-232(s0)
    800056e2:	e7a1                	bnez	a5,8000572a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056e4:	29c1                	addiw	s3,s3,16
    800056e6:	04c92783          	lw	a5,76(s2)
    800056ea:	fcf9ede3          	bltu	s3,a5,800056c4 <sys_unlink+0x140>
    800056ee:	b781                	j	8000562e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800056f0:	00003517          	auipc	a0,0x3
    800056f4:	06850513          	addi	a0,a0,104 # 80008758 <syscalls+0x308>
    800056f8:	ffffb097          	auipc	ra,0xffffb
    800056fc:	e42080e7          	jalr	-446(ra) # 8000053a <panic>
    panic("unlink: writei");
    80005700:	00003517          	auipc	a0,0x3
    80005704:	07050513          	addi	a0,a0,112 # 80008770 <syscalls+0x320>
    80005708:	ffffb097          	auipc	ra,0xffffb
    8000570c:	e32080e7          	jalr	-462(ra) # 8000053a <panic>
    dp->nlink--;
    80005710:	04a4d783          	lhu	a5,74(s1)
    80005714:	37fd                	addiw	a5,a5,-1
    80005716:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000571a:	8526                	mv	a0,s1
    8000571c:	ffffe097          	auipc	ra,0xffffe
    80005720:	fe0080e7          	jalr	-32(ra) # 800036fc <iupdate>
    80005724:	b781                	j	80005664 <sys_unlink+0xe0>
    return -1;
    80005726:	557d                	li	a0,-1
    80005728:	a005                	j	80005748 <sys_unlink+0x1c4>
    iunlockput(ip);
    8000572a:	854a                	mv	a0,s2
    8000572c:	ffffe097          	auipc	ra,0xffffe
    80005730:	2fe080e7          	jalr	766(ra) # 80003a2a <iunlockput>
  iunlockput(dp);
    80005734:	8526                	mv	a0,s1
    80005736:	ffffe097          	auipc	ra,0xffffe
    8000573a:	2f4080e7          	jalr	756(ra) # 80003a2a <iunlockput>
  end_op();
    8000573e:	fffff097          	auipc	ra,0xfffff
    80005742:	ae4080e7          	jalr	-1308(ra) # 80004222 <end_op>
  return -1;
    80005746:	557d                	li	a0,-1
}
    80005748:	70ae                	ld	ra,232(sp)
    8000574a:	740e                	ld	s0,224(sp)
    8000574c:	64ee                	ld	s1,216(sp)
    8000574e:	694e                	ld	s2,208(sp)
    80005750:	69ae                	ld	s3,200(sp)
    80005752:	616d                	addi	sp,sp,240
    80005754:	8082                	ret

0000000080005756 <sys_open>:

uint64
sys_open(void)
{
    80005756:	7131                	addi	sp,sp,-192
    80005758:	fd06                	sd	ra,184(sp)
    8000575a:	f922                	sd	s0,176(sp)
    8000575c:	f526                	sd	s1,168(sp)
    8000575e:	f14a                	sd	s2,160(sp)
    80005760:	ed4e                	sd	s3,152(sp)
    80005762:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005764:	08000613          	li	a2,128
    80005768:	f5040593          	addi	a1,s0,-176
    8000576c:	4501                	li	a0,0
    8000576e:	ffffd097          	auipc	ra,0xffffd
    80005772:	52c080e7          	jalr	1324(ra) # 80002c9a <argstr>
    return -1;
    80005776:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005778:	0c054163          	bltz	a0,8000583a <sys_open+0xe4>
    8000577c:	f4c40593          	addi	a1,s0,-180
    80005780:	4505                	li	a0,1
    80005782:	ffffd097          	auipc	ra,0xffffd
    80005786:	4d4080e7          	jalr	1236(ra) # 80002c56 <argint>
    8000578a:	0a054863          	bltz	a0,8000583a <sys_open+0xe4>

  begin_op();
    8000578e:	fffff097          	auipc	ra,0xfffff
    80005792:	a16080e7          	jalr	-1514(ra) # 800041a4 <begin_op>

  if(omode & O_CREATE){
    80005796:	f4c42783          	lw	a5,-180(s0)
    8000579a:	2007f793          	andi	a5,a5,512
    8000579e:	cbdd                	beqz	a5,80005854 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800057a0:	4681                	li	a3,0
    800057a2:	4601                	li	a2,0
    800057a4:	4589                	li	a1,2
    800057a6:	f5040513          	addi	a0,s0,-176
    800057aa:	00000097          	auipc	ra,0x0
    800057ae:	970080e7          	jalr	-1680(ra) # 8000511a <create>
    800057b2:	892a                	mv	s2,a0
    if(ip == 0){
    800057b4:	c959                	beqz	a0,8000584a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057b6:	04491703          	lh	a4,68(s2)
    800057ba:	478d                	li	a5,3
    800057bc:	00f71763          	bne	a4,a5,800057ca <sys_open+0x74>
    800057c0:	04695703          	lhu	a4,70(s2)
    800057c4:	47a5                	li	a5,9
    800057c6:	0ce7ec63          	bltu	a5,a4,8000589e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800057ca:	fffff097          	auipc	ra,0xfffff
    800057ce:	dee080e7          	jalr	-530(ra) # 800045b8 <filealloc>
    800057d2:	89aa                	mv	s3,a0
    800057d4:	10050263          	beqz	a0,800058d8 <sys_open+0x182>
    800057d8:	00000097          	auipc	ra,0x0
    800057dc:	900080e7          	jalr	-1792(ra) # 800050d8 <fdalloc>
    800057e0:	84aa                	mv	s1,a0
    800057e2:	0e054663          	bltz	a0,800058ce <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800057e6:	04491703          	lh	a4,68(s2)
    800057ea:	478d                	li	a5,3
    800057ec:	0cf70463          	beq	a4,a5,800058b4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800057f0:	4789                	li	a5,2
    800057f2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800057f6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800057fa:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800057fe:	f4c42783          	lw	a5,-180(s0)
    80005802:	0017c713          	xori	a4,a5,1
    80005806:	8b05                	andi	a4,a4,1
    80005808:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000580c:	0037f713          	andi	a4,a5,3
    80005810:	00e03733          	snez	a4,a4
    80005814:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005818:	4007f793          	andi	a5,a5,1024
    8000581c:	c791                	beqz	a5,80005828 <sys_open+0xd2>
    8000581e:	04491703          	lh	a4,68(s2)
    80005822:	4789                	li	a5,2
    80005824:	08f70f63          	beq	a4,a5,800058c2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005828:	854a                	mv	a0,s2
    8000582a:	ffffe097          	auipc	ra,0xffffe
    8000582e:	060080e7          	jalr	96(ra) # 8000388a <iunlock>
  end_op();
    80005832:	fffff097          	auipc	ra,0xfffff
    80005836:	9f0080e7          	jalr	-1552(ra) # 80004222 <end_op>

  return fd;
}
    8000583a:	8526                	mv	a0,s1
    8000583c:	70ea                	ld	ra,184(sp)
    8000583e:	744a                	ld	s0,176(sp)
    80005840:	74aa                	ld	s1,168(sp)
    80005842:	790a                	ld	s2,160(sp)
    80005844:	69ea                	ld	s3,152(sp)
    80005846:	6129                	addi	sp,sp,192
    80005848:	8082                	ret
      end_op();
    8000584a:	fffff097          	auipc	ra,0xfffff
    8000584e:	9d8080e7          	jalr	-1576(ra) # 80004222 <end_op>
      return -1;
    80005852:	b7e5                	j	8000583a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005854:	f5040513          	addi	a0,s0,-176
    80005858:	ffffe097          	auipc	ra,0xffffe
    8000585c:	72c080e7          	jalr	1836(ra) # 80003f84 <namei>
    80005860:	892a                	mv	s2,a0
    80005862:	c905                	beqz	a0,80005892 <sys_open+0x13c>
    ilock(ip);
    80005864:	ffffe097          	auipc	ra,0xffffe
    80005868:	f64080e7          	jalr	-156(ra) # 800037c8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000586c:	04491703          	lh	a4,68(s2)
    80005870:	4785                	li	a5,1
    80005872:	f4f712e3          	bne	a4,a5,800057b6 <sys_open+0x60>
    80005876:	f4c42783          	lw	a5,-180(s0)
    8000587a:	dba1                	beqz	a5,800057ca <sys_open+0x74>
      iunlockput(ip);
    8000587c:	854a                	mv	a0,s2
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	1ac080e7          	jalr	428(ra) # 80003a2a <iunlockput>
      end_op();
    80005886:	fffff097          	auipc	ra,0xfffff
    8000588a:	99c080e7          	jalr	-1636(ra) # 80004222 <end_op>
      return -1;
    8000588e:	54fd                	li	s1,-1
    80005890:	b76d                	j	8000583a <sys_open+0xe4>
      end_op();
    80005892:	fffff097          	auipc	ra,0xfffff
    80005896:	990080e7          	jalr	-1648(ra) # 80004222 <end_op>
      return -1;
    8000589a:	54fd                	li	s1,-1
    8000589c:	bf79                	j	8000583a <sys_open+0xe4>
    iunlockput(ip);
    8000589e:	854a                	mv	a0,s2
    800058a0:	ffffe097          	auipc	ra,0xffffe
    800058a4:	18a080e7          	jalr	394(ra) # 80003a2a <iunlockput>
    end_op();
    800058a8:	fffff097          	auipc	ra,0xfffff
    800058ac:	97a080e7          	jalr	-1670(ra) # 80004222 <end_op>
    return -1;
    800058b0:	54fd                	li	s1,-1
    800058b2:	b761                	j	8000583a <sys_open+0xe4>
    f->type = FD_DEVICE;
    800058b4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800058b8:	04691783          	lh	a5,70(s2)
    800058bc:	02f99223          	sh	a5,36(s3)
    800058c0:	bf2d                	j	800057fa <sys_open+0xa4>
    itrunc(ip);
    800058c2:	854a                	mv	a0,s2
    800058c4:	ffffe097          	auipc	ra,0xffffe
    800058c8:	012080e7          	jalr	18(ra) # 800038d6 <itrunc>
    800058cc:	bfb1                	j	80005828 <sys_open+0xd2>
      fileclose(f);
    800058ce:	854e                	mv	a0,s3
    800058d0:	fffff097          	auipc	ra,0xfffff
    800058d4:	da4080e7          	jalr	-604(ra) # 80004674 <fileclose>
    iunlockput(ip);
    800058d8:	854a                	mv	a0,s2
    800058da:	ffffe097          	auipc	ra,0xffffe
    800058de:	150080e7          	jalr	336(ra) # 80003a2a <iunlockput>
    end_op();
    800058e2:	fffff097          	auipc	ra,0xfffff
    800058e6:	940080e7          	jalr	-1728(ra) # 80004222 <end_op>
    return -1;
    800058ea:	54fd                	li	s1,-1
    800058ec:	b7b9                	j	8000583a <sys_open+0xe4>

00000000800058ee <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800058ee:	7175                	addi	sp,sp,-144
    800058f0:	e506                	sd	ra,136(sp)
    800058f2:	e122                	sd	s0,128(sp)
    800058f4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	8ae080e7          	jalr	-1874(ra) # 800041a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800058fe:	08000613          	li	a2,128
    80005902:	f7040593          	addi	a1,s0,-144
    80005906:	4501                	li	a0,0
    80005908:	ffffd097          	auipc	ra,0xffffd
    8000590c:	392080e7          	jalr	914(ra) # 80002c9a <argstr>
    80005910:	02054963          	bltz	a0,80005942 <sys_mkdir+0x54>
    80005914:	4681                	li	a3,0
    80005916:	4601                	li	a2,0
    80005918:	4585                	li	a1,1
    8000591a:	f7040513          	addi	a0,s0,-144
    8000591e:	fffff097          	auipc	ra,0xfffff
    80005922:	7fc080e7          	jalr	2044(ra) # 8000511a <create>
    80005926:	cd11                	beqz	a0,80005942 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005928:	ffffe097          	auipc	ra,0xffffe
    8000592c:	102080e7          	jalr	258(ra) # 80003a2a <iunlockput>
  end_op();
    80005930:	fffff097          	auipc	ra,0xfffff
    80005934:	8f2080e7          	jalr	-1806(ra) # 80004222 <end_op>
  return 0;
    80005938:	4501                	li	a0,0
}
    8000593a:	60aa                	ld	ra,136(sp)
    8000593c:	640a                	ld	s0,128(sp)
    8000593e:	6149                	addi	sp,sp,144
    80005940:	8082                	ret
    end_op();
    80005942:	fffff097          	auipc	ra,0xfffff
    80005946:	8e0080e7          	jalr	-1824(ra) # 80004222 <end_op>
    return -1;
    8000594a:	557d                	li	a0,-1
    8000594c:	b7fd                	j	8000593a <sys_mkdir+0x4c>

000000008000594e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000594e:	7135                	addi	sp,sp,-160
    80005950:	ed06                	sd	ra,152(sp)
    80005952:	e922                	sd	s0,144(sp)
    80005954:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005956:	fffff097          	auipc	ra,0xfffff
    8000595a:	84e080e7          	jalr	-1970(ra) # 800041a4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000595e:	08000613          	li	a2,128
    80005962:	f7040593          	addi	a1,s0,-144
    80005966:	4501                	li	a0,0
    80005968:	ffffd097          	auipc	ra,0xffffd
    8000596c:	332080e7          	jalr	818(ra) # 80002c9a <argstr>
    80005970:	04054a63          	bltz	a0,800059c4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005974:	f6c40593          	addi	a1,s0,-148
    80005978:	4505                	li	a0,1
    8000597a:	ffffd097          	auipc	ra,0xffffd
    8000597e:	2dc080e7          	jalr	732(ra) # 80002c56 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005982:	04054163          	bltz	a0,800059c4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005986:	f6840593          	addi	a1,s0,-152
    8000598a:	4509                	li	a0,2
    8000598c:	ffffd097          	auipc	ra,0xffffd
    80005990:	2ca080e7          	jalr	714(ra) # 80002c56 <argint>
     argint(1, &major) < 0 ||
    80005994:	02054863          	bltz	a0,800059c4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005998:	f6841683          	lh	a3,-152(s0)
    8000599c:	f6c41603          	lh	a2,-148(s0)
    800059a0:	458d                	li	a1,3
    800059a2:	f7040513          	addi	a0,s0,-144
    800059a6:	fffff097          	auipc	ra,0xfffff
    800059aa:	774080e7          	jalr	1908(ra) # 8000511a <create>
     argint(2, &minor) < 0 ||
    800059ae:	c919                	beqz	a0,800059c4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059b0:	ffffe097          	auipc	ra,0xffffe
    800059b4:	07a080e7          	jalr	122(ra) # 80003a2a <iunlockput>
  end_op();
    800059b8:	fffff097          	auipc	ra,0xfffff
    800059bc:	86a080e7          	jalr	-1942(ra) # 80004222 <end_op>
  return 0;
    800059c0:	4501                	li	a0,0
    800059c2:	a031                	j	800059ce <sys_mknod+0x80>
    end_op();
    800059c4:	fffff097          	auipc	ra,0xfffff
    800059c8:	85e080e7          	jalr	-1954(ra) # 80004222 <end_op>
    return -1;
    800059cc:	557d                	li	a0,-1
}
    800059ce:	60ea                	ld	ra,152(sp)
    800059d0:	644a                	ld	s0,144(sp)
    800059d2:	610d                	addi	sp,sp,160
    800059d4:	8082                	ret

00000000800059d6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800059d6:	7135                	addi	sp,sp,-160
    800059d8:	ed06                	sd	ra,152(sp)
    800059da:	e922                	sd	s0,144(sp)
    800059dc:	e526                	sd	s1,136(sp)
    800059de:	e14a                	sd	s2,128(sp)
    800059e0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800059e2:	ffffc097          	auipc	ra,0xffffc
    800059e6:	0fa080e7          	jalr	250(ra) # 80001adc <myproc>
    800059ea:	892a                	mv	s2,a0
  
  begin_op();
    800059ec:	ffffe097          	auipc	ra,0xffffe
    800059f0:	7b8080e7          	jalr	1976(ra) # 800041a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800059f4:	08000613          	li	a2,128
    800059f8:	f6040593          	addi	a1,s0,-160
    800059fc:	4501                	li	a0,0
    800059fe:	ffffd097          	auipc	ra,0xffffd
    80005a02:	29c080e7          	jalr	668(ra) # 80002c9a <argstr>
    80005a06:	04054b63          	bltz	a0,80005a5c <sys_chdir+0x86>
    80005a0a:	f6040513          	addi	a0,s0,-160
    80005a0e:	ffffe097          	auipc	ra,0xffffe
    80005a12:	576080e7          	jalr	1398(ra) # 80003f84 <namei>
    80005a16:	84aa                	mv	s1,a0
    80005a18:	c131                	beqz	a0,80005a5c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a1a:	ffffe097          	auipc	ra,0xffffe
    80005a1e:	dae080e7          	jalr	-594(ra) # 800037c8 <ilock>
  if(ip->type != T_DIR){
    80005a22:	04449703          	lh	a4,68(s1)
    80005a26:	4785                	li	a5,1
    80005a28:	04f71063          	bne	a4,a5,80005a68 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005a2c:	8526                	mv	a0,s1
    80005a2e:	ffffe097          	auipc	ra,0xffffe
    80005a32:	e5c080e7          	jalr	-420(ra) # 8000388a <iunlock>
  iput(p->cwd);
    80005a36:	15093503          	ld	a0,336(s2)
    80005a3a:	ffffe097          	auipc	ra,0xffffe
    80005a3e:	f48080e7          	jalr	-184(ra) # 80003982 <iput>
  end_op();
    80005a42:	ffffe097          	auipc	ra,0xffffe
    80005a46:	7e0080e7          	jalr	2016(ra) # 80004222 <end_op>
  p->cwd = ip;
    80005a4a:	14993823          	sd	s1,336(s2)
  return 0;
    80005a4e:	4501                	li	a0,0
}
    80005a50:	60ea                	ld	ra,152(sp)
    80005a52:	644a                	ld	s0,144(sp)
    80005a54:	64aa                	ld	s1,136(sp)
    80005a56:	690a                	ld	s2,128(sp)
    80005a58:	610d                	addi	sp,sp,160
    80005a5a:	8082                	ret
    end_op();
    80005a5c:	ffffe097          	auipc	ra,0xffffe
    80005a60:	7c6080e7          	jalr	1990(ra) # 80004222 <end_op>
    return -1;
    80005a64:	557d                	li	a0,-1
    80005a66:	b7ed                	j	80005a50 <sys_chdir+0x7a>
    iunlockput(ip);
    80005a68:	8526                	mv	a0,s1
    80005a6a:	ffffe097          	auipc	ra,0xffffe
    80005a6e:	fc0080e7          	jalr	-64(ra) # 80003a2a <iunlockput>
    end_op();
    80005a72:	ffffe097          	auipc	ra,0xffffe
    80005a76:	7b0080e7          	jalr	1968(ra) # 80004222 <end_op>
    return -1;
    80005a7a:	557d                	li	a0,-1
    80005a7c:	bfd1                	j	80005a50 <sys_chdir+0x7a>

0000000080005a7e <sys_exec>:

uint64
sys_exec(void)
{
    80005a7e:	7145                	addi	sp,sp,-464
    80005a80:	e786                	sd	ra,456(sp)
    80005a82:	e3a2                	sd	s0,448(sp)
    80005a84:	ff26                	sd	s1,440(sp)
    80005a86:	fb4a                	sd	s2,432(sp)
    80005a88:	f74e                	sd	s3,424(sp)
    80005a8a:	f352                	sd	s4,416(sp)
    80005a8c:	ef56                	sd	s5,408(sp)
    80005a8e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a90:	08000613          	li	a2,128
    80005a94:	f4040593          	addi	a1,s0,-192
    80005a98:	4501                	li	a0,0
    80005a9a:	ffffd097          	auipc	ra,0xffffd
    80005a9e:	200080e7          	jalr	512(ra) # 80002c9a <argstr>
    return -1;
    80005aa2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005aa4:	0c054b63          	bltz	a0,80005b7a <sys_exec+0xfc>
    80005aa8:	e3840593          	addi	a1,s0,-456
    80005aac:	4505                	li	a0,1
    80005aae:	ffffd097          	auipc	ra,0xffffd
    80005ab2:	1ca080e7          	jalr	458(ra) # 80002c78 <argaddr>
    80005ab6:	0c054263          	bltz	a0,80005b7a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005aba:	10000613          	li	a2,256
    80005abe:	4581                	li	a1,0
    80005ac0:	e4040513          	addi	a0,s0,-448
    80005ac4:	ffffb097          	auipc	ra,0xffffb
    80005ac8:	208080e7          	jalr	520(ra) # 80000ccc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005acc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005ad0:	89a6                	mv	s3,s1
    80005ad2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005ad4:	02000a13          	li	s4,32
    80005ad8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005adc:	00391513          	slli	a0,s2,0x3
    80005ae0:	e3040593          	addi	a1,s0,-464
    80005ae4:	e3843783          	ld	a5,-456(s0)
    80005ae8:	953e                	add	a0,a0,a5
    80005aea:	ffffd097          	auipc	ra,0xffffd
    80005aee:	0d2080e7          	jalr	210(ra) # 80002bbc <fetchaddr>
    80005af2:	02054a63          	bltz	a0,80005b26 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005af6:	e3043783          	ld	a5,-464(s0)
    80005afa:	c3b9                	beqz	a5,80005b40 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005afc:	ffffb097          	auipc	ra,0xffffb
    80005b00:	fe4080e7          	jalr	-28(ra) # 80000ae0 <kalloc>
    80005b04:	85aa                	mv	a1,a0
    80005b06:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b0a:	cd11                	beqz	a0,80005b26 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005b0c:	6605                	lui	a2,0x1
    80005b0e:	e3043503          	ld	a0,-464(s0)
    80005b12:	ffffd097          	auipc	ra,0xffffd
    80005b16:	0fc080e7          	jalr	252(ra) # 80002c0e <fetchstr>
    80005b1a:	00054663          	bltz	a0,80005b26 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005b1e:	0905                	addi	s2,s2,1
    80005b20:	09a1                	addi	s3,s3,8
    80005b22:	fb491be3          	bne	s2,s4,80005ad8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b26:	f4040913          	addi	s2,s0,-192
    80005b2a:	6088                	ld	a0,0(s1)
    80005b2c:	c531                	beqz	a0,80005b78 <sys_exec+0xfa>
    kfree(argv[i]);
    80005b2e:	ffffb097          	auipc	ra,0xffffb
    80005b32:	eb4080e7          	jalr	-332(ra) # 800009e2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b36:	04a1                	addi	s1,s1,8
    80005b38:	ff2499e3          	bne	s1,s2,80005b2a <sys_exec+0xac>
  return -1;
    80005b3c:	597d                	li	s2,-1
    80005b3e:	a835                	j	80005b7a <sys_exec+0xfc>
      argv[i] = 0;
    80005b40:	0a8e                	slli	s5,s5,0x3
    80005b42:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffccfc0>
    80005b46:	00878ab3          	add	s5,a5,s0
    80005b4a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005b4e:	e4040593          	addi	a1,s0,-448
    80005b52:	f4040513          	addi	a0,s0,-192
    80005b56:	fffff097          	auipc	ra,0xfffff
    80005b5a:	172080e7          	jalr	370(ra) # 80004cc8 <exec>
    80005b5e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b60:	f4040993          	addi	s3,s0,-192
    80005b64:	6088                	ld	a0,0(s1)
    80005b66:	c911                	beqz	a0,80005b7a <sys_exec+0xfc>
    kfree(argv[i]);
    80005b68:	ffffb097          	auipc	ra,0xffffb
    80005b6c:	e7a080e7          	jalr	-390(ra) # 800009e2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b70:	04a1                	addi	s1,s1,8
    80005b72:	ff3499e3          	bne	s1,s3,80005b64 <sys_exec+0xe6>
    80005b76:	a011                	j	80005b7a <sys_exec+0xfc>
  return -1;
    80005b78:	597d                	li	s2,-1
}
    80005b7a:	854a                	mv	a0,s2
    80005b7c:	60be                	ld	ra,456(sp)
    80005b7e:	641e                	ld	s0,448(sp)
    80005b80:	74fa                	ld	s1,440(sp)
    80005b82:	795a                	ld	s2,432(sp)
    80005b84:	79ba                	ld	s3,424(sp)
    80005b86:	7a1a                	ld	s4,416(sp)
    80005b88:	6afa                	ld	s5,408(sp)
    80005b8a:	6179                	addi	sp,sp,464
    80005b8c:	8082                	ret

0000000080005b8e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b8e:	7139                	addi	sp,sp,-64
    80005b90:	fc06                	sd	ra,56(sp)
    80005b92:	f822                	sd	s0,48(sp)
    80005b94:	f426                	sd	s1,40(sp)
    80005b96:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b98:	ffffc097          	auipc	ra,0xffffc
    80005b9c:	f44080e7          	jalr	-188(ra) # 80001adc <myproc>
    80005ba0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005ba2:	fd840593          	addi	a1,s0,-40
    80005ba6:	4501                	li	a0,0
    80005ba8:	ffffd097          	auipc	ra,0xffffd
    80005bac:	0d0080e7          	jalr	208(ra) # 80002c78 <argaddr>
    return -1;
    80005bb0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005bb2:	0e054063          	bltz	a0,80005c92 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005bb6:	fc840593          	addi	a1,s0,-56
    80005bba:	fd040513          	addi	a0,s0,-48
    80005bbe:	fffff097          	auipc	ra,0xfffff
    80005bc2:	de6080e7          	jalr	-538(ra) # 800049a4 <pipealloc>
    return -1;
    80005bc6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005bc8:	0c054563          	bltz	a0,80005c92 <sys_pipe+0x104>
  fd0 = -1;
    80005bcc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005bd0:	fd043503          	ld	a0,-48(s0)
    80005bd4:	fffff097          	auipc	ra,0xfffff
    80005bd8:	504080e7          	jalr	1284(ra) # 800050d8 <fdalloc>
    80005bdc:	fca42223          	sw	a0,-60(s0)
    80005be0:	08054c63          	bltz	a0,80005c78 <sys_pipe+0xea>
    80005be4:	fc843503          	ld	a0,-56(s0)
    80005be8:	fffff097          	auipc	ra,0xfffff
    80005bec:	4f0080e7          	jalr	1264(ra) # 800050d8 <fdalloc>
    80005bf0:	fca42023          	sw	a0,-64(s0)
    80005bf4:	06054963          	bltz	a0,80005c66 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bf8:	4691                	li	a3,4
    80005bfa:	fc440613          	addi	a2,s0,-60
    80005bfe:	fd843583          	ld	a1,-40(s0)
    80005c02:	68a8                	ld	a0,80(s1)
    80005c04:	ffffc097          	auipc	ra,0xffffc
    80005c08:	a4c080e7          	jalr	-1460(ra) # 80001650 <copyout>
    80005c0c:	02054063          	bltz	a0,80005c2c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c10:	4691                	li	a3,4
    80005c12:	fc040613          	addi	a2,s0,-64
    80005c16:	fd843583          	ld	a1,-40(s0)
    80005c1a:	0591                	addi	a1,a1,4
    80005c1c:	68a8                	ld	a0,80(s1)
    80005c1e:	ffffc097          	auipc	ra,0xffffc
    80005c22:	a32080e7          	jalr	-1486(ra) # 80001650 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c26:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c28:	06055563          	bgez	a0,80005c92 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005c2c:	fc442783          	lw	a5,-60(s0)
    80005c30:	07e9                	addi	a5,a5,26
    80005c32:	078e                	slli	a5,a5,0x3
    80005c34:	97a6                	add	a5,a5,s1
    80005c36:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005c3a:	fc042783          	lw	a5,-64(s0)
    80005c3e:	07e9                	addi	a5,a5,26
    80005c40:	078e                	slli	a5,a5,0x3
    80005c42:	00f48533          	add	a0,s1,a5
    80005c46:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005c4a:	fd043503          	ld	a0,-48(s0)
    80005c4e:	fffff097          	auipc	ra,0xfffff
    80005c52:	a26080e7          	jalr	-1498(ra) # 80004674 <fileclose>
    fileclose(wf);
    80005c56:	fc843503          	ld	a0,-56(s0)
    80005c5a:	fffff097          	auipc	ra,0xfffff
    80005c5e:	a1a080e7          	jalr	-1510(ra) # 80004674 <fileclose>
    return -1;
    80005c62:	57fd                	li	a5,-1
    80005c64:	a03d                	j	80005c92 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005c66:	fc442783          	lw	a5,-60(s0)
    80005c6a:	0007c763          	bltz	a5,80005c78 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005c6e:	07e9                	addi	a5,a5,26
    80005c70:	078e                	slli	a5,a5,0x3
    80005c72:	97a6                	add	a5,a5,s1
    80005c74:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005c78:	fd043503          	ld	a0,-48(s0)
    80005c7c:	fffff097          	auipc	ra,0xfffff
    80005c80:	9f8080e7          	jalr	-1544(ra) # 80004674 <fileclose>
    fileclose(wf);
    80005c84:	fc843503          	ld	a0,-56(s0)
    80005c88:	fffff097          	auipc	ra,0xfffff
    80005c8c:	9ec080e7          	jalr	-1556(ra) # 80004674 <fileclose>
    return -1;
    80005c90:	57fd                	li	a5,-1
}
    80005c92:	853e                	mv	a0,a5
    80005c94:	70e2                	ld	ra,56(sp)
    80005c96:	7442                	ld	s0,48(sp)
    80005c98:	74a2                	ld	s1,40(sp)
    80005c9a:	6121                	addi	sp,sp,64
    80005c9c:	8082                	ret

0000000080005c9e <sys_mmap>:

uint64
sys_mmap(void)
{
    80005c9e:	715d                	addi	sp,sp,-80
    80005ca0:	e486                	sd	ra,72(sp)
    80005ca2:	e0a2                	sd	s0,64(sp)
    80005ca4:	fc26                	sd	s1,56(sp)
    80005ca6:	f84a                	sd	s2,48(sp)
    80005ca8:	0880                	addi	s0,sp,80
  uint64 addr, sz, offset;
  int prot, flags, fd; struct file *f;

  if(argaddr(0, &addr) < 0 || argaddr(1, &sz) < 0 || argint(2, &prot) < 0
    80005caa:	fd840593          	addi	a1,s0,-40
    80005cae:	4501                	li	a0,0
    80005cb0:	ffffd097          	auipc	ra,0xffffd
    80005cb4:	fc8080e7          	jalr	-56(ra) # 80002c78 <argaddr>
    80005cb8:	12054763          	bltz	a0,80005de6 <sys_mmap+0x148>
    80005cbc:	fd040593          	addi	a1,s0,-48
    80005cc0:	4505                	li	a0,1
    80005cc2:	ffffd097          	auipc	ra,0xffffd
    80005cc6:	fb6080e7          	jalr	-74(ra) # 80002c78 <argaddr>
    80005cca:	12054563          	bltz	a0,80005df4 <sys_mmap+0x156>
    80005cce:	fc440593          	addi	a1,s0,-60
    80005cd2:	4509                	li	a0,2
    80005cd4:	ffffd097          	auipc	ra,0xffffd
    80005cd8:	f82080e7          	jalr	-126(ra) # 80002c56 <argint>
    80005cdc:	10054e63          	bltz	a0,80005df8 <sys_mmap+0x15a>
    || argint(3, &flags) < 0 || argfd(4, &fd, &f) < 0 || argaddr(5, &offset) < 0 || sz == 0)
    80005ce0:	fc040593          	addi	a1,s0,-64
    80005ce4:	450d                	li	a0,3
    80005ce6:	ffffd097          	auipc	ra,0xffffd
    80005cea:	f70080e7          	jalr	-144(ra) # 80002c56 <argint>
    80005cee:	10054763          	bltz	a0,80005dfc <sys_mmap+0x15e>
    80005cf2:	fb040613          	addi	a2,s0,-80
    80005cf6:	fbc40593          	addi	a1,s0,-68
    80005cfa:	4511                	li	a0,4
    80005cfc:	fffff097          	auipc	ra,0xfffff
    80005d00:	374080e7          	jalr	884(ra) # 80005070 <argfd>
    80005d04:	0e054e63          	bltz	a0,80005e00 <sys_mmap+0x162>
    80005d08:	fc840593          	addi	a1,s0,-56
    80005d0c:	4515                	li	a0,5
    80005d0e:	ffffd097          	auipc	ra,0xffffd
    80005d12:	f6a080e7          	jalr	-150(ra) # 80002c78 <argaddr>
    80005d16:	0e054763          	bltz	a0,80005e04 <sys_mmap+0x166>
    80005d1a:	fd043783          	ld	a5,-48(s0)
    80005d1e:	c7ed                	beqz	a5,80005e08 <sys_mmap+0x16a>
    return -1;
  
  if((!f->readable && (prot & (PROT_READ)))
    80005d20:	fb043483          	ld	s1,-80(s0)
    80005d24:	0084c703          	lbu	a4,8(s1)
    80005d28:	e709                	bnez	a4,80005d32 <sys_mmap+0x94>
    80005d2a:	fc442703          	lw	a4,-60(s0)
    80005d2e:	8b05                	andi	a4,a4,1
    80005d30:	ef71                	bnez	a4,80005e0c <sys_mmap+0x16e>
     || (!f->writable && (prot & PROT_WRITE) && !(flags & MAP_PRIVATE)))
    80005d32:	0094c703          	lbu	a4,9(s1)
    80005d36:	eb09                	bnez	a4,80005d48 <sys_mmap+0xaa>
    80005d38:	fc442703          	lw	a4,-60(s0)
    80005d3c:	8b09                	andi	a4,a4,2
    80005d3e:	c709                	beqz	a4,80005d48 <sys_mmap+0xaa>
    80005d40:	fc042703          	lw	a4,-64(s0)
    80005d44:	8b09                	andi	a4,a4,2
    80005d46:	c769                	beqz	a4,80005e10 <sys_mmap+0x172>
    return -1;
  
  sz = PGROUNDUP(sz);
    80005d48:	6705                	lui	a4,0x1
    80005d4a:	177d                	addi	a4,a4,-1 # fff <_entry-0x7ffff001>
    80005d4c:	97ba                	add	a5,a5,a4
    80005d4e:	777d                	lui	a4,0xfffff
    80005d50:	8ff9                	and	a5,a5,a4
    80005d52:	fcf43823          	sd	a5,-48(s0)

  struct proc *p = myproc();
    80005d56:	ffffc097          	auipc	ra,0xffffc
    80005d5a:	d86080e7          	jalr	-634(ra) # 80001adc <myproc>
  // map the file
  // our implementation maps file right below where the trapframe is,
  // from high addresses to low addresses.

  // Find a free vma, and calculate where to map the file along the way.
  for(int i=0;i<NVMA;i++) {
    80005d5e:	16850793          	addi	a5,a0,360
    80005d62:	46850693          	addi	a3,a0,1128
  uint64 vaend = MMAPEND; // non-inclusive
    80005d66:	020005b7          	lui	a1,0x2000
    80005d6a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80005d6c:	05b6                	slli	a1,a1,0xd
  struct vma *v = 0;
    80005d6e:	4901                	li	s2,0
        v = &p->vmas[i];
        // found free vma;
        v->valid = 1;
      }
    } else if(vv->vastart < vaend) {
      vaend = PGROUNDDOWN(vv->vastart);
    80005d70:	757d                	lui	a0,0xfffff
        v->valid = 1;
    80005d72:	4805                	li	a6,1
    80005d74:	a811                	j	80005d88 <sys_mmap+0xea>
    } else if(vv->vastart < vaend) {
    80005d76:	6798                	ld	a4,8(a5)
    80005d78:	00b77463          	bgeu	a4,a1,80005d80 <sys_mmap+0xe2>
      vaend = PGROUNDDOWN(vv->vastart);
    80005d7c:	00a775b3          	and	a1,a4,a0
  for(int i=0;i<NVMA;i++) {
    80005d80:	03078793          	addi	a5,a5,48
    80005d84:	00d78a63          	beq	a5,a3,80005d98 <sys_mmap+0xfa>
    if(vv->valid == 0) {
    80005d88:	4398                	lw	a4,0(a5)
    80005d8a:	f775                	bnez	a4,80005d76 <sys_mmap+0xd8>
      if(v == 0) {
    80005d8c:	fe091ae3          	bnez	s2,80005d80 <sys_mmap+0xe2>
        v->valid = 1;
    80005d90:	0107a023          	sw	a6,0(a5)
        v = &p->vmas[i];
    80005d94:	893e                	mv	s2,a5
    80005d96:	b7ed                	j	80005d80 <sys_mmap+0xe2>
    }
  }

  if(v == 0){
    80005d98:	02090f63          	beqz	s2,80005dd6 <sys_mmap+0x138>
    panic("mmap: no free vma");
  }
  
  v->vastart = vaend - sz;
    80005d9c:	fd043783          	ld	a5,-48(s0)
    80005da0:	8d9d                	sub	a1,a1,a5
    80005da2:	00b93423          	sd	a1,8(s2)
  v->sz = sz;
    80005da6:	00f93823          	sd	a5,16(s2)
  v->prot = prot;
    80005daa:	fc442783          	lw	a5,-60(s0)
    80005dae:	02f92023          	sw	a5,32(s2)
  v->flags = flags;
    80005db2:	fc042783          	lw	a5,-64(s0)
    80005db6:	02f92223          	sw	a5,36(s2)
  v->f = f; // assume f->type == FD_INODE
    80005dba:	00993c23          	sd	s1,24(s2)
  v->offset = offset;
    80005dbe:	fc843783          	ld	a5,-56(s0)
    80005dc2:	02f93423          	sd	a5,40(s2)

  filedup(v->f);
    80005dc6:	8526                	mv	a0,s1
    80005dc8:	fffff097          	auipc	ra,0xfffff
    80005dcc:	85a080e7          	jalr	-1958(ra) # 80004622 <filedup>

  return v->vastart;
    80005dd0:	00893503          	ld	a0,8(s2)
    80005dd4:	a811                	j	80005de8 <sys_mmap+0x14a>
    panic("mmap: no free vma");
    80005dd6:	00003517          	auipc	a0,0x3
    80005dda:	9aa50513          	addi	a0,a0,-1622 # 80008780 <syscalls+0x330>
    80005dde:	ffffa097          	auipc	ra,0xffffa
    80005de2:	75c080e7          	jalr	1884(ra) # 8000053a <panic>
    return -1;
    80005de6:	557d                	li	a0,-1
}
    80005de8:	60a6                	ld	ra,72(sp)
    80005dea:	6406                	ld	s0,64(sp)
    80005dec:	74e2                	ld	s1,56(sp)
    80005dee:	7942                	ld	s2,48(sp)
    80005df0:	6161                	addi	sp,sp,80
    80005df2:	8082                	ret
    return -1;
    80005df4:	557d                	li	a0,-1
    80005df6:	bfcd                	j	80005de8 <sys_mmap+0x14a>
    80005df8:	557d                	li	a0,-1
    80005dfa:	b7fd                	j	80005de8 <sys_mmap+0x14a>
    80005dfc:	557d                	li	a0,-1
    80005dfe:	b7ed                	j	80005de8 <sys_mmap+0x14a>
    80005e00:	557d                	li	a0,-1
    80005e02:	b7dd                	j	80005de8 <sys_mmap+0x14a>
    80005e04:	557d                	li	a0,-1
    80005e06:	b7cd                	j	80005de8 <sys_mmap+0x14a>
    80005e08:	557d                	li	a0,-1
    80005e0a:	bff9                	j	80005de8 <sys_mmap+0x14a>
    return -1;
    80005e0c:	557d                	li	a0,-1
    80005e0e:	bfe9                	j	80005de8 <sys_mmap+0x14a>
    80005e10:	557d                	li	a0,-1
    80005e12:	bfd9                	j	80005de8 <sys_mmap+0x14a>

0000000080005e14 <findvma>:

// find a vma using a virtual address inside that vma.
struct vma *findvma(struct proc *p, uint64 va) {
    80005e14:	1141                	addi	sp,sp,-16
    80005e16:	e422                	sd	s0,8(sp)
    80005e18:	0800                	addi	s0,sp,16
  for(int i=0;i<NVMA;i++) {
    80005e1a:	16850793          	addi	a5,a0,360
    80005e1e:	4701                	li	a4,0
    struct vma *vv = &p->vmas[i];
    if(vv->valid == 1 && va >= vv->vastart && va < vv->vastart + vv->sz) {
    80005e20:	4805                	li	a6,1
  for(int i=0;i<NVMA;i++) {
    80005e22:	48c1                	li	a7,16
    80005e24:	a031                	j	80005e30 <findvma+0x1c>
    80005e26:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffcd001>
    80005e28:	03078793          	addi	a5,a5,48
    80005e2c:	03170463          	beq	a4,a7,80005e54 <findvma+0x40>
    if(vv->valid == 1 && va >= vv->vastart && va < vv->vastart + vv->sz) {
    80005e30:	4394                	lw	a3,0(a5)
    80005e32:	ff069ae3          	bne	a3,a6,80005e26 <findvma+0x12>
    80005e36:	6794                	ld	a3,8(a5)
    80005e38:	fed5e7e3          	bltu	a1,a3,80005e26 <findvma+0x12>
    80005e3c:	6b90                	ld	a2,16(a5)
    80005e3e:	96b2                	add	a3,a3,a2
    80005e40:	fed5f3e3          	bgeu	a1,a3,80005e26 <findvma+0x12>
    struct vma *vv = &p->vmas[i];
    80005e44:	00171793          	slli	a5,a4,0x1
    80005e48:	97ba                	add	a5,a5,a4
    80005e4a:	0792                	slli	a5,a5,0x4
    80005e4c:	16878793          	addi	a5,a5,360
    80005e50:	953e                	add	a0,a0,a5
    80005e52:	a011                	j	80005e56 <findvma+0x42>
      return vv;
    }
  }
  return 0;
    80005e54:	4501                	li	a0,0
}
    80005e56:	6422                	ld	s0,8(sp)
    80005e58:	0141                	addi	sp,sp,16
    80005e5a:	8082                	ret

0000000080005e5c <sys_munmap>:

uint64
sys_munmap(void)
{
    80005e5c:	7139                	addi	sp,sp,-64
    80005e5e:	fc06                	sd	ra,56(sp)
    80005e60:	f822                	sd	s0,48(sp)
    80005e62:	f426                	sd	s1,40(sp)
    80005e64:	f04a                	sd	s2,32(sp)
    80005e66:	ec4e                	sd	s3,24(sp)
    80005e68:	e852                	sd	s4,16(sp)
    80005e6a:	0080                	addi	s0,sp,64
  uint64 addr, sz;

  if(argaddr(0, &addr) < 0 || argaddr(1, &sz) < 0 || sz == 0)
    80005e6c:	fc840593          	addi	a1,s0,-56
    80005e70:	4501                	li	a0,0
    80005e72:	ffffd097          	auipc	ra,0xffffd
    80005e76:	e06080e7          	jalr	-506(ra) # 80002c78 <argaddr>
    return -1;
    80005e7a:	54fd                	li	s1,-1
  if(argaddr(0, &addr) < 0 || argaddr(1, &sz) < 0 || sz == 0)
    80005e7c:	0a054d63          	bltz	a0,80005f36 <sys_munmap+0xda>
    80005e80:	fc040593          	addi	a1,s0,-64
    80005e84:	4505                	li	a0,1
    80005e86:	ffffd097          	auipc	ra,0xffffd
    80005e8a:	df2080e7          	jalr	-526(ra) # 80002c78 <argaddr>
    80005e8e:	0c054663          	bltz	a0,80005f5a <sys_munmap+0xfe>
    80005e92:	fc043783          	ld	a5,-64(s0)
    80005e96:	c3c5                	beqz	a5,80005f36 <sys_munmap+0xda>

  struct proc *p = myproc();
    80005e98:	ffffc097          	auipc	ra,0xffffc
    80005e9c:	c44080e7          	jalr	-956(ra) # 80001adc <myproc>
    80005ea0:	8a2a                	mv	s4,a0

  struct vma *v = findvma(p, addr);
    80005ea2:	fc843983          	ld	s3,-56(s0)
    80005ea6:	85ce                	mv	a1,s3
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	f6c080e7          	jalr	-148(ra) # 80005e14 <findvma>
    80005eb0:	892a                	mv	s2,a0
  if(v == 0) {
    80005eb2:	c555                	beqz	a0,80005f5e <sys_munmap+0x102>
    return -1;
  }

  if(addr > v->vastart && addr + sz < v->vastart + v->sz) {
    80005eb4:	651c                	ld	a5,8(a0)
    80005eb6:	0137ff63          	bgeu	a5,s3,80005ed4 <sys_munmap+0x78>
    80005eba:	fc043703          	ld	a4,-64(s0)
    80005ebe:	974e                	add	a4,a4,s3
    80005ec0:	6914                	ld	a3,16(a0)
    80005ec2:	97b6                	add	a5,a5,a3
    80005ec4:	06f76963          	bltu	a4,a5,80005f36 <sys_munmap+0xda>
    return -1;
  }

  uint64 addr_aligned = addr;
  if(addr > v->vastart) {
    addr_aligned = PGROUNDUP(addr);
    80005ec8:	6585                	lui	a1,0x1
    80005eca:	15fd                	addi	a1,a1,-1 # fff <_entry-0x7ffff001>
    80005ecc:	95ce                	add	a1,a1,s3
    80005ece:	77fd                	lui	a5,0xfffff
    80005ed0:	8dfd                	and	a1,a1,a5
    80005ed2:	a011                	j	80005ed6 <sys_munmap+0x7a>
  uint64 addr_aligned = addr;
    80005ed4:	85ce                	mv	a1,s3
  }

  int nunmap = sz - (addr_aligned-addr); // nbytes to unmap
    80005ed6:	fc043603          	ld	a2,-64(s0)
    80005eda:	0136063b          	addw	a2,a2,s3
    80005ede:	9e0d                	subw	a2,a2,a1
  if(nunmap < 0)
    nunmap = 0;
  
  vmaunmap(p->pagetable, addr_aligned, nunmap, v);
    80005ee0:	0006079b          	sext.w	a5,a2
    80005ee4:	fff7c793          	not	a5,a5
    80005ee8:	97fd                	srai	a5,a5,0x3f
    80005eea:	8e7d                	and	a2,a2,a5
    80005eec:	86ca                	mv	a3,s2
    80005eee:	2601                	sext.w	a2,a2
    80005ef0:	050a3503          	ld	a0,80(s4)
    80005ef4:	ffffc097          	auipc	ra,0xffffc
    80005ef8:	926080e7          	jalr	-1754(ra) # 8000181a <vmaunmap>

  if(addr <= v->vastart && addr + sz > v->vastart) { // unmap at the beginning
    80005efc:	00893703          	ld	a4,8(s2)
    80005f00:	fc843783          	ld	a5,-56(s0)
    80005f04:	02f76063          	bltu	a4,a5,80005f24 <sys_munmap+0xc8>
    80005f08:	fc043683          	ld	a3,-64(s0)
    80005f0c:	97b6                	add	a5,a5,a3
    80005f0e:	00f77b63          	bgeu	a4,a5,80005f24 <sys_munmap+0xc8>
    v->offset += addr + sz - v->vastart;
    80005f12:	02893683          	ld	a3,40(s2)
    80005f16:	96be                	add	a3,a3,a5
    80005f18:	40e68733          	sub	a4,a3,a4
    80005f1c:	02e93423          	sd	a4,40(s2)
    v->vastart = addr + sz;
    80005f20:	00f93423          	sd	a5,8(s2)
  }
  v->sz -= sz;
    80005f24:	01093483          	ld	s1,16(s2)
    80005f28:	fc043783          	ld	a5,-64(s0)
    80005f2c:	8c9d                	sub	s1,s1,a5
    80005f2e:	00993823          	sd	s1,16(s2)

  if(v->sz <= 0) {
    80005f32:	c899                	beqz	s1,80005f48 <sys_munmap+0xec>
    fileclose(v->f);
    v->valid = 0;
  }

  return 0;  
    80005f34:	4481                	li	s1,0
}
    80005f36:	8526                	mv	a0,s1
    80005f38:	70e2                	ld	ra,56(sp)
    80005f3a:	7442                	ld	s0,48(sp)
    80005f3c:	74a2                	ld	s1,40(sp)
    80005f3e:	7902                	ld	s2,32(sp)
    80005f40:	69e2                	ld	s3,24(sp)
    80005f42:	6a42                	ld	s4,16(sp)
    80005f44:	6121                	addi	sp,sp,64
    80005f46:	8082                	ret
    fileclose(v->f);
    80005f48:	01893503          	ld	a0,24(s2)
    80005f4c:	ffffe097          	auipc	ra,0xffffe
    80005f50:	728080e7          	jalr	1832(ra) # 80004674 <fileclose>
    v->valid = 0;
    80005f54:	00092023          	sw	zero,0(s2)
    80005f58:	bff9                	j	80005f36 <sys_munmap+0xda>
    return -1;
    80005f5a:	54fd                	li	s1,-1
    80005f5c:	bfe9                	j	80005f36 <sys_munmap+0xda>
    return -1;
    80005f5e:	54fd                	li	s1,-1
    80005f60:	bfd9                	j	80005f36 <sys_munmap+0xda>

0000000080005f62 <vmatrylazytouch>:

// finds out whether a page is previously lazy-allocated for a vma
// and needed to be touched before use.
// if so, touch it so it's mapped to an actual physical page and contains
// content of the mapped file.
int vmatrylazytouch(uint64 va) {
    80005f62:	7179                	addi	sp,sp,-48
    80005f64:	f406                	sd	ra,40(sp)
    80005f66:	f022                	sd	s0,32(sp)
    80005f68:	ec26                	sd	s1,24(sp)
    80005f6a:	e84a                	sd	s2,16(sp)
    80005f6c:	e44e                	sd	s3,8(sp)
    80005f6e:	e052                	sd	s4,0(sp)
    80005f70:	1800                	addi	s0,sp,48
    80005f72:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80005f74:	ffffc097          	auipc	ra,0xffffc
    80005f78:	b68080e7          	jalr	-1176(ra) # 80001adc <myproc>
    80005f7c:	8a2a                	mv	s4,a0
  struct vma *v = findvma(p, va);
    80005f7e:	85ca                	mv	a1,s2
    80005f80:	00000097          	auipc	ra,0x0
    80005f84:	e94080e7          	jalr	-364(ra) # 80005e14 <findvma>
  if(v == 0) {
    80005f88:	c945                	beqz	a0,80006038 <vmatrylazytouch+0xd6>
    80005f8a:	84aa                	mv	s1,a0
  }

  // printf("vma mapping: %p => %d\n", va, v->offset + PGROUNDDOWN(va - v->vastart));

  // touch
  void *pa = kalloc();
    80005f8c:	ffffb097          	auipc	ra,0xffffb
    80005f90:	b54080e7          	jalr	-1196(ra) # 80000ae0 <kalloc>
    80005f94:	89aa                	mv	s3,a0
  if(pa == 0) {
    80005f96:	c149                	beqz	a0,80006018 <vmatrylazytouch+0xb6>
    panic("vmalazytouch: kalloc");
  }
  memset(pa, 0, PGSIZE);
    80005f98:	6605                	lui	a2,0x1
    80005f9a:	4581                	li	a1,0
    80005f9c:	ffffb097          	auipc	ra,0xffffb
    80005fa0:	d30080e7          	jalr	-720(ra) # 80000ccc <memset>
  
  begin_op();
    80005fa4:	ffffe097          	auipc	ra,0xffffe
    80005fa8:	200080e7          	jalr	512(ra) # 800041a4 <begin_op>
  ilock(v->f->ip);
    80005fac:	6c9c                	ld	a5,24(s1)
    80005fae:	6f88                	ld	a0,24(a5)
    80005fb0:	ffffe097          	auipc	ra,0xffffe
    80005fb4:	818080e7          	jalr	-2024(ra) # 800037c8 <ilock>
  readi(v->f->ip, 0, (uint64)pa, v->offset + PGROUNDDOWN(va - v->vastart), PGSIZE);
    80005fb8:	649c                	ld	a5,8(s1)
    80005fba:	40f907bb          	subw	a5,s2,a5
    80005fbe:	777d                	lui	a4,0xfffff
    80005fc0:	8ff9                	and	a5,a5,a4
    80005fc2:	7494                	ld	a3,40(s1)
    80005fc4:	6c88                	ld	a0,24(s1)
    80005fc6:	6705                	lui	a4,0x1
    80005fc8:	9ebd                	addw	a3,a3,a5
    80005fca:	864e                	mv	a2,s3
    80005fcc:	4581                	li	a1,0
    80005fce:	6d08                	ld	a0,24(a0)
    80005fd0:	ffffe097          	auipc	ra,0xffffe
    80005fd4:	aac080e7          	jalr	-1364(ra) # 80003a7c <readi>
  iunlock(v->f->ip);
    80005fd8:	6c9c                	ld	a5,24(s1)
    80005fda:	6f88                	ld	a0,24(a5)
    80005fdc:	ffffe097          	auipc	ra,0xffffe
    80005fe0:	8ae080e7          	jalr	-1874(ra) # 8000388a <iunlock>
  end_op();
    80005fe4:	ffffe097          	auipc	ra,0xffffe
    80005fe8:	23e080e7          	jalr	574(ra) # 80004222 <end_op>
  if(v->prot & PROT_WRITE)
    perm |= PTE_W;
  if(v->prot & PROT_EXEC)
    perm |= PTE_X;

  if(mappages(p->pagetable, va, PGSIZE, (uint64)pa, PTE_R | PTE_W | PTE_U) < 0) {
    80005fec:	4759                	li	a4,22
    80005fee:	86ce                	mv	a3,s3
    80005ff0:	6605                	lui	a2,0x1
    80005ff2:	85ca                	mv	a1,s2
    80005ff4:	050a3503          	ld	a0,80(s4)
    80005ff8:	ffffb097          	auipc	ra,0xffffb
    80005ffc:	0a4080e7          	jalr	164(ra) # 8000109c <mappages>
    80006000:	87aa                	mv	a5,a0
    panic("vmalazytouch: mappages");
  }

  return 1;
    80006002:	4505                	li	a0,1
  if(mappages(p->pagetable, va, PGSIZE, (uint64)pa, PTE_R | PTE_W | PTE_U) < 0) {
    80006004:	0207c263          	bltz	a5,80006028 <vmatrylazytouch+0xc6>
    80006008:	70a2                	ld	ra,40(sp)
    8000600a:	7402                	ld	s0,32(sp)
    8000600c:	64e2                	ld	s1,24(sp)
    8000600e:	6942                	ld	s2,16(sp)
    80006010:	69a2                	ld	s3,8(sp)
    80006012:	6a02                	ld	s4,0(sp)
    80006014:	6145                	addi	sp,sp,48
    80006016:	8082                	ret
    panic("vmalazytouch: kalloc");
    80006018:	00002517          	auipc	a0,0x2
    8000601c:	78050513          	addi	a0,a0,1920 # 80008798 <syscalls+0x348>
    80006020:	ffffa097          	auipc	ra,0xffffa
    80006024:	51a080e7          	jalr	1306(ra) # 8000053a <panic>
    panic("vmalazytouch: mappages");
    80006028:	00002517          	auipc	a0,0x2
    8000602c:	78850513          	addi	a0,a0,1928 # 800087b0 <syscalls+0x360>
    80006030:	ffffa097          	auipc	ra,0xffffa
    80006034:	50a080e7          	jalr	1290(ra) # 8000053a <panic>
    return 0;
    80006038:	4501                	li	a0,0
    8000603a:	b7f9                	j	80006008 <vmatrylazytouch+0xa6>
    8000603c:	0000                	unimp
	...

0000000080006040 <kernelvec>:
    80006040:	7111                	addi	sp,sp,-256
    80006042:	e006                	sd	ra,0(sp)
    80006044:	e40a                	sd	sp,8(sp)
    80006046:	e80e                	sd	gp,16(sp)
    80006048:	ec12                	sd	tp,24(sp)
    8000604a:	f016                	sd	t0,32(sp)
    8000604c:	f41a                	sd	t1,40(sp)
    8000604e:	f81e                	sd	t2,48(sp)
    80006050:	fc22                	sd	s0,56(sp)
    80006052:	e0a6                	sd	s1,64(sp)
    80006054:	e4aa                	sd	a0,72(sp)
    80006056:	e8ae                	sd	a1,80(sp)
    80006058:	ecb2                	sd	a2,88(sp)
    8000605a:	f0b6                	sd	a3,96(sp)
    8000605c:	f4ba                	sd	a4,104(sp)
    8000605e:	f8be                	sd	a5,112(sp)
    80006060:	fcc2                	sd	a6,120(sp)
    80006062:	e146                	sd	a7,128(sp)
    80006064:	e54a                	sd	s2,136(sp)
    80006066:	e94e                	sd	s3,144(sp)
    80006068:	ed52                	sd	s4,152(sp)
    8000606a:	f156                	sd	s5,160(sp)
    8000606c:	f55a                	sd	s6,168(sp)
    8000606e:	f95e                	sd	s7,176(sp)
    80006070:	fd62                	sd	s8,184(sp)
    80006072:	e1e6                	sd	s9,192(sp)
    80006074:	e5ea                	sd	s10,200(sp)
    80006076:	e9ee                	sd	s11,208(sp)
    80006078:	edf2                	sd	t3,216(sp)
    8000607a:	f1f6                	sd	t4,224(sp)
    8000607c:	f5fa                	sd	t5,232(sp)
    8000607e:	f9fe                	sd	t6,240(sp)
    80006080:	a09fc0ef          	jal	ra,80002a88 <kerneltrap>
    80006084:	6082                	ld	ra,0(sp)
    80006086:	6122                	ld	sp,8(sp)
    80006088:	61c2                	ld	gp,16(sp)
    8000608a:	7282                	ld	t0,32(sp)
    8000608c:	7322                	ld	t1,40(sp)
    8000608e:	73c2                	ld	t2,48(sp)
    80006090:	7462                	ld	s0,56(sp)
    80006092:	6486                	ld	s1,64(sp)
    80006094:	6526                	ld	a0,72(sp)
    80006096:	65c6                	ld	a1,80(sp)
    80006098:	6666                	ld	a2,88(sp)
    8000609a:	7686                	ld	a3,96(sp)
    8000609c:	7726                	ld	a4,104(sp)
    8000609e:	77c6                	ld	a5,112(sp)
    800060a0:	7866                	ld	a6,120(sp)
    800060a2:	688a                	ld	a7,128(sp)
    800060a4:	692a                	ld	s2,136(sp)
    800060a6:	69ca                	ld	s3,144(sp)
    800060a8:	6a6a                	ld	s4,152(sp)
    800060aa:	7a8a                	ld	s5,160(sp)
    800060ac:	7b2a                	ld	s6,168(sp)
    800060ae:	7bca                	ld	s7,176(sp)
    800060b0:	7c6a                	ld	s8,184(sp)
    800060b2:	6c8e                	ld	s9,192(sp)
    800060b4:	6d2e                	ld	s10,200(sp)
    800060b6:	6dce                	ld	s11,208(sp)
    800060b8:	6e6e                	ld	t3,216(sp)
    800060ba:	7e8e                	ld	t4,224(sp)
    800060bc:	7f2e                	ld	t5,232(sp)
    800060be:	7fce                	ld	t6,240(sp)
    800060c0:	6111                	addi	sp,sp,256
    800060c2:	10200073          	sret

00000000800060c6 <unexpected_exc>:
    800060c6:	a001                	j	800060c6 <unexpected_exc>

00000000800060c8 <unexpected_int>:
    800060c8:	a001                	j	800060c8 <unexpected_int>
    800060ca:	00000013          	nop
    800060ce:	0001                	nop

00000000800060d0 <timervec>:
    800060d0:	34051573          	csrrw	a0,mscratch,a0
    800060d4:	e10c                	sd	a1,0(a0)
    800060d6:	e510                	sd	a2,8(a0)
    800060d8:	e914                	sd	a3,16(a0)
    800060da:	342025f3          	csrr	a1,mcause
    800060de:	fe05d4e3          	bgez	a1,800060c6 <unexpected_exc>
    800060e2:	fff0061b          	addiw	a2,zero,-1
    800060e6:	167e                	slli	a2,a2,0x3f
    800060e8:	061d                	addi	a2,a2,7 # 1007 <_entry-0x7fffeff9>
    800060ea:	fcc59fe3          	bne	a1,a2,800060c8 <unexpected_int>
    800060ee:	6d0c                	ld	a1,24(a0)
    800060f0:	7110                	ld	a2,32(a0)
    800060f2:	6194                	ld	a3,0(a1)
    800060f4:	96b2                	add	a3,a3,a2
    800060f6:	e194                	sd	a3,0(a1)
    800060f8:	4589                	li	a1,2
    800060fa:	14459073          	csrw	sip,a1
    800060fe:	6914                	ld	a3,16(a0)
    80006100:	6510                	ld	a2,8(a0)
    80006102:	610c                	ld	a1,0(a0)
    80006104:	34051573          	csrrw	a0,mscratch,a0
    80006108:	30200073          	mret
	...

0000000080006116 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006116:	1141                	addi	sp,sp,-16
    80006118:	e422                	sd	s0,8(sp)
    8000611a:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    8000611c:	0c0007b7          	lui	a5,0xc000
    80006120:	4705                	li	a4,1
    80006122:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006124:	c3d8                	sw	a4,4(a5)
}
    80006126:	6422                	ld	s0,8(sp)
    80006128:	0141                	addi	sp,sp,16
    8000612a:	8082                	ret

000000008000612c <plicinithart>:

void
plicinithart(void)
{
    8000612c:	1141                	addi	sp,sp,-16
    8000612e:	e406                	sd	ra,8(sp)
    80006130:	e022                	sd	s0,0(sp)
    80006132:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006134:	ffffc097          	auipc	ra,0xffffc
    80006138:	97c080e7          	jalr	-1668(ra) # 80001ab0 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    8000613c:	0085171b          	slliw	a4,a0,0x8
    80006140:	0c0027b7          	lui	a5,0xc002
    80006144:	97ba                	add	a5,a5,a4
    80006146:	40200713          	li	a4,1026
    8000614a:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000614e:	00d5151b          	slliw	a0,a0,0xd
    80006152:	0c2017b7          	lui	a5,0xc201
    80006156:	97aa                	add	a5,a5,a0
    80006158:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    8000615c:	60a2                	ld	ra,8(sp)
    8000615e:	6402                	ld	s0,0(sp)
    80006160:	0141                	addi	sp,sp,16
    80006162:	8082                	ret

0000000080006164 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006164:	1141                	addi	sp,sp,-16
    80006166:	e406                	sd	ra,8(sp)
    80006168:	e022                	sd	s0,0(sp)
    8000616a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000616c:	ffffc097          	auipc	ra,0xffffc
    80006170:	944080e7          	jalr	-1724(ra) # 80001ab0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006174:	00d5151b          	slliw	a0,a0,0xd
    80006178:	0c2017b7          	lui	a5,0xc201
    8000617c:	97aa                	add	a5,a5,a0
  return irq;
}
    8000617e:	43c8                	lw	a0,4(a5)
    80006180:	60a2                	ld	ra,8(sp)
    80006182:	6402                	ld	s0,0(sp)
    80006184:	0141                	addi	sp,sp,16
    80006186:	8082                	ret

0000000080006188 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006188:	1101                	addi	sp,sp,-32
    8000618a:	ec06                	sd	ra,24(sp)
    8000618c:	e822                	sd	s0,16(sp)
    8000618e:	e426                	sd	s1,8(sp)
    80006190:	1000                	addi	s0,sp,32
    80006192:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006194:	ffffc097          	auipc	ra,0xffffc
    80006198:	91c080e7          	jalr	-1764(ra) # 80001ab0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000619c:	00d5151b          	slliw	a0,a0,0xd
    800061a0:	0c2017b7          	lui	a5,0xc201
    800061a4:	97aa                	add	a5,a5,a0
    800061a6:	c3c4                	sw	s1,4(a5)
}
    800061a8:	60e2                	ld	ra,24(sp)
    800061aa:	6442                	ld	s0,16(sp)
    800061ac:	64a2                	ld	s1,8(sp)
    800061ae:	6105                	addi	sp,sp,32
    800061b0:	8082                	ret

00000000800061b2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800061b2:	1141                	addi	sp,sp,-16
    800061b4:	e406                	sd	ra,8(sp)
    800061b6:	e022                	sd	s0,0(sp)
    800061b8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800061ba:	479d                	li	a5,7
    800061bc:	06a7c863          	blt	a5,a0,8000622c <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800061c0:	00029717          	auipc	a4,0x29
    800061c4:	e4070713          	addi	a4,a4,-448 # 8002f000 <disk>
    800061c8:	972a                	add	a4,a4,a0
    800061ca:	6789                	lui	a5,0x2
    800061cc:	97ba                	add	a5,a5,a4
    800061ce:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800061d2:	e7ad                	bnez	a5,8000623c <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800061d4:	00451793          	slli	a5,a0,0x4
    800061d8:	0002b717          	auipc	a4,0x2b
    800061dc:	e2870713          	addi	a4,a4,-472 # 80031000 <disk+0x2000>
    800061e0:	6314                	ld	a3,0(a4)
    800061e2:	96be                	add	a3,a3,a5
    800061e4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800061e8:	6314                	ld	a3,0(a4)
    800061ea:	96be                	add	a3,a3,a5
    800061ec:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800061f0:	6314                	ld	a3,0(a4)
    800061f2:	96be                	add	a3,a3,a5
    800061f4:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800061f8:	6318                	ld	a4,0(a4)
    800061fa:	97ba                	add	a5,a5,a4
    800061fc:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006200:	00029717          	auipc	a4,0x29
    80006204:	e0070713          	addi	a4,a4,-512 # 8002f000 <disk>
    80006208:	972a                	add	a4,a4,a0
    8000620a:	6789                	lui	a5,0x2
    8000620c:	97ba                	add	a5,a5,a4
    8000620e:	4705                	li	a4,1
    80006210:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006214:	0002b517          	auipc	a0,0x2b
    80006218:	e0450513          	addi	a0,a0,-508 # 80031018 <disk+0x2018>
    8000621c:	ffffc097          	auipc	ra,0xffffc
    80006220:	2ee080e7          	jalr	750(ra) # 8000250a <wakeup>
}
    80006224:	60a2                	ld	ra,8(sp)
    80006226:	6402                	ld	s0,0(sp)
    80006228:	0141                	addi	sp,sp,16
    8000622a:	8082                	ret
    panic("free_desc 1");
    8000622c:	00002517          	auipc	a0,0x2
    80006230:	59c50513          	addi	a0,a0,1436 # 800087c8 <syscalls+0x378>
    80006234:	ffffa097          	auipc	ra,0xffffa
    80006238:	306080e7          	jalr	774(ra) # 8000053a <panic>
    panic("free_desc 2");
    8000623c:	00002517          	auipc	a0,0x2
    80006240:	59c50513          	addi	a0,a0,1436 # 800087d8 <syscalls+0x388>
    80006244:	ffffa097          	auipc	ra,0xffffa
    80006248:	2f6080e7          	jalr	758(ra) # 8000053a <panic>

000000008000624c <virtio_disk_init>:
{
    8000624c:	1101                	addi	sp,sp,-32
    8000624e:	ec06                	sd	ra,24(sp)
    80006250:	e822                	sd	s0,16(sp)
    80006252:	e426                	sd	s1,8(sp)
    80006254:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006256:	00002597          	auipc	a1,0x2
    8000625a:	59258593          	addi	a1,a1,1426 # 800087e8 <syscalls+0x398>
    8000625e:	0002b517          	auipc	a0,0x2b
    80006262:	eca50513          	addi	a0,a0,-310 # 80031128 <disk+0x2128>
    80006266:	ffffb097          	auipc	ra,0xffffb
    8000626a:	8da080e7          	jalr	-1830(ra) # 80000b40 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000626e:	100017b7          	lui	a5,0x10001
    80006272:	4398                	lw	a4,0(a5)
    80006274:	2701                	sext.w	a4,a4
    80006276:	747277b7          	lui	a5,0x74727
    8000627a:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000627e:	0ef71063          	bne	a4,a5,8000635e <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006282:	100017b7          	lui	a5,0x10001
    80006286:	43dc                	lw	a5,4(a5)
    80006288:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000628a:	4705                	li	a4,1
    8000628c:	0ce79963          	bne	a5,a4,8000635e <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006290:	100017b7          	lui	a5,0x10001
    80006294:	479c                	lw	a5,8(a5)
    80006296:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006298:	4709                	li	a4,2
    8000629a:	0ce79263          	bne	a5,a4,8000635e <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000629e:	100017b7          	lui	a5,0x10001
    800062a2:	47d8                	lw	a4,12(a5)
    800062a4:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062a6:	554d47b7          	lui	a5,0x554d4
    800062aa:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800062ae:	0af71863          	bne	a4,a5,8000635e <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062b2:	100017b7          	lui	a5,0x10001
    800062b6:	4705                	li	a4,1
    800062b8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062ba:	470d                	li	a4,3
    800062bc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800062be:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800062c0:	c7ffe6b7          	lui	a3,0xc7ffe
    800062c4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fcc75f>
    800062c8:	8f75                	and	a4,a4,a3
    800062ca:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062cc:	472d                	li	a4,11
    800062ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062d0:	473d                	li	a4,15
    800062d2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800062d4:	6705                	lui	a4,0x1
    800062d6:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800062d8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800062dc:	5bdc                	lw	a5,52(a5)
    800062de:	2781                	sext.w	a5,a5
  if(max == 0)
    800062e0:	c7d9                	beqz	a5,8000636e <virtio_disk_init+0x122>
  if(max < NUM)
    800062e2:	471d                	li	a4,7
    800062e4:	08f77d63          	bgeu	a4,a5,8000637e <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800062e8:	100014b7          	lui	s1,0x10001
    800062ec:	47a1                	li	a5,8
    800062ee:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800062f0:	6609                	lui	a2,0x2
    800062f2:	4581                	li	a1,0
    800062f4:	00029517          	auipc	a0,0x29
    800062f8:	d0c50513          	addi	a0,a0,-756 # 8002f000 <disk>
    800062fc:	ffffb097          	auipc	ra,0xffffb
    80006300:	9d0080e7          	jalr	-1584(ra) # 80000ccc <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006304:	00029717          	auipc	a4,0x29
    80006308:	cfc70713          	addi	a4,a4,-772 # 8002f000 <disk>
    8000630c:	00c75793          	srli	a5,a4,0xc
    80006310:	2781                	sext.w	a5,a5
    80006312:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006314:	0002b797          	auipc	a5,0x2b
    80006318:	cec78793          	addi	a5,a5,-788 # 80031000 <disk+0x2000>
    8000631c:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    8000631e:	00029717          	auipc	a4,0x29
    80006322:	d6270713          	addi	a4,a4,-670 # 8002f080 <disk+0x80>
    80006326:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006328:	0002a717          	auipc	a4,0x2a
    8000632c:	cd870713          	addi	a4,a4,-808 # 80030000 <disk+0x1000>
    80006330:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006332:	4705                	li	a4,1
    80006334:	00e78c23          	sb	a4,24(a5)
    80006338:	00e78ca3          	sb	a4,25(a5)
    8000633c:	00e78d23          	sb	a4,26(a5)
    80006340:	00e78da3          	sb	a4,27(a5)
    80006344:	00e78e23          	sb	a4,28(a5)
    80006348:	00e78ea3          	sb	a4,29(a5)
    8000634c:	00e78f23          	sb	a4,30(a5)
    80006350:	00e78fa3          	sb	a4,31(a5)
}
    80006354:	60e2                	ld	ra,24(sp)
    80006356:	6442                	ld	s0,16(sp)
    80006358:	64a2                	ld	s1,8(sp)
    8000635a:	6105                	addi	sp,sp,32
    8000635c:	8082                	ret
    panic("could not find virtio disk");
    8000635e:	00002517          	auipc	a0,0x2
    80006362:	49a50513          	addi	a0,a0,1178 # 800087f8 <syscalls+0x3a8>
    80006366:	ffffa097          	auipc	ra,0xffffa
    8000636a:	1d4080e7          	jalr	468(ra) # 8000053a <panic>
    panic("virtio disk has no queue 0");
    8000636e:	00002517          	auipc	a0,0x2
    80006372:	4aa50513          	addi	a0,a0,1194 # 80008818 <syscalls+0x3c8>
    80006376:	ffffa097          	auipc	ra,0xffffa
    8000637a:	1c4080e7          	jalr	452(ra) # 8000053a <panic>
    panic("virtio disk max queue too short");
    8000637e:	00002517          	auipc	a0,0x2
    80006382:	4ba50513          	addi	a0,a0,1210 # 80008838 <syscalls+0x3e8>
    80006386:	ffffa097          	auipc	ra,0xffffa
    8000638a:	1b4080e7          	jalr	436(ra) # 8000053a <panic>

000000008000638e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000638e:	7119                	addi	sp,sp,-128
    80006390:	fc86                	sd	ra,120(sp)
    80006392:	f8a2                	sd	s0,112(sp)
    80006394:	f4a6                	sd	s1,104(sp)
    80006396:	f0ca                	sd	s2,96(sp)
    80006398:	ecce                	sd	s3,88(sp)
    8000639a:	e8d2                	sd	s4,80(sp)
    8000639c:	e4d6                	sd	s5,72(sp)
    8000639e:	e0da                	sd	s6,64(sp)
    800063a0:	fc5e                	sd	s7,56(sp)
    800063a2:	f862                	sd	s8,48(sp)
    800063a4:	f466                	sd	s9,40(sp)
    800063a6:	f06a                	sd	s10,32(sp)
    800063a8:	ec6e                	sd	s11,24(sp)
    800063aa:	0100                	addi	s0,sp,128
    800063ac:	8aaa                	mv	s5,a0
    800063ae:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800063b0:	00c52c83          	lw	s9,12(a0)
    800063b4:	001c9c9b          	slliw	s9,s9,0x1
    800063b8:	1c82                	slli	s9,s9,0x20
    800063ba:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800063be:	0002b517          	auipc	a0,0x2b
    800063c2:	d6a50513          	addi	a0,a0,-662 # 80031128 <disk+0x2128>
    800063c6:	ffffb097          	auipc	ra,0xffffb
    800063ca:	80a080e7          	jalr	-2038(ra) # 80000bd0 <acquire>
  for(int i = 0; i < 3; i++){
    800063ce:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800063d0:	44a1                	li	s1,8
      disk.free[i] = 0;
    800063d2:	00029c17          	auipc	s8,0x29
    800063d6:	c2ec0c13          	addi	s8,s8,-978 # 8002f000 <disk>
    800063da:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800063dc:	4b0d                	li	s6,3
    800063de:	a0ad                	j	80006448 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800063e0:	00fc0733          	add	a4,s8,a5
    800063e4:	975e                	add	a4,a4,s7
    800063e6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800063ea:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800063ec:	0207c563          	bltz	a5,80006416 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800063f0:	2905                	addiw	s2,s2,1
    800063f2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800063f4:	19690c63          	beq	s2,s6,8000658c <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800063f8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800063fa:	0002b717          	auipc	a4,0x2b
    800063fe:	c1e70713          	addi	a4,a4,-994 # 80031018 <disk+0x2018>
    80006402:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006404:	00074683          	lbu	a3,0(a4)
    80006408:	fee1                	bnez	a3,800063e0 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000640a:	2785                	addiw	a5,a5,1
    8000640c:	0705                	addi	a4,a4,1
    8000640e:	fe979be3          	bne	a5,s1,80006404 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006412:	57fd                	li	a5,-1
    80006414:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006416:	01205d63          	blez	s2,80006430 <virtio_disk_rw+0xa2>
    8000641a:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000641c:	000a2503          	lw	a0,0(s4)
    80006420:	00000097          	auipc	ra,0x0
    80006424:	d92080e7          	jalr	-622(ra) # 800061b2 <free_desc>
      for(int j = 0; j < i; j++)
    80006428:	2d85                	addiw	s11,s11,1
    8000642a:	0a11                	addi	s4,s4,4
    8000642c:	ff2d98e3          	bne	s11,s2,8000641c <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006430:	0002b597          	auipc	a1,0x2b
    80006434:	cf858593          	addi	a1,a1,-776 # 80031128 <disk+0x2128>
    80006438:	0002b517          	auipc	a0,0x2b
    8000643c:	be050513          	addi	a0,a0,-1056 # 80031018 <disk+0x2018>
    80006440:	ffffc097          	auipc	ra,0xffffc
    80006444:	f4a080e7          	jalr	-182(ra) # 8000238a <sleep>
  for(int i = 0; i < 3; i++){
    80006448:	f8040a13          	addi	s4,s0,-128
{
    8000644c:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000644e:	894e                	mv	s2,s3
    80006450:	b765                	j	800063f8 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006452:	0002b697          	auipc	a3,0x2b
    80006456:	bae6b683          	ld	a3,-1106(a3) # 80031000 <disk+0x2000>
    8000645a:	96ba                	add	a3,a3,a4
    8000645c:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006460:	00029817          	auipc	a6,0x29
    80006464:	ba080813          	addi	a6,a6,-1120 # 8002f000 <disk>
    80006468:	0002b697          	auipc	a3,0x2b
    8000646c:	b9868693          	addi	a3,a3,-1128 # 80031000 <disk+0x2000>
    80006470:	6290                	ld	a2,0(a3)
    80006472:	963a                	add	a2,a2,a4
    80006474:	00c65583          	lhu	a1,12(a2)
    80006478:	0015e593          	ori	a1,a1,1
    8000647c:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006480:	f8842603          	lw	a2,-120(s0)
    80006484:	628c                	ld	a1,0(a3)
    80006486:	972e                	add	a4,a4,a1
    80006488:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000648c:	20050593          	addi	a1,a0,512
    80006490:	0592                	slli	a1,a1,0x4
    80006492:	95c2                	add	a1,a1,a6
    80006494:	577d                	li	a4,-1
    80006496:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000649a:	00461713          	slli	a4,a2,0x4
    8000649e:	6290                	ld	a2,0(a3)
    800064a0:	963a                	add	a2,a2,a4
    800064a2:	03078793          	addi	a5,a5,48
    800064a6:	97c2                	add	a5,a5,a6
    800064a8:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800064aa:	629c                	ld	a5,0(a3)
    800064ac:	97ba                	add	a5,a5,a4
    800064ae:	4605                	li	a2,1
    800064b0:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800064b2:	629c                	ld	a5,0(a3)
    800064b4:	97ba                	add	a5,a5,a4
    800064b6:	4809                	li	a6,2
    800064b8:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800064bc:	629c                	ld	a5,0(a3)
    800064be:	97ba                	add	a5,a5,a4
    800064c0:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800064c4:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800064c8:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800064cc:	6698                	ld	a4,8(a3)
    800064ce:	00275783          	lhu	a5,2(a4)
    800064d2:	8b9d                	andi	a5,a5,7
    800064d4:	0786                	slli	a5,a5,0x1
    800064d6:	973e                	add	a4,a4,a5
    800064d8:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800064dc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800064e0:	6698                	ld	a4,8(a3)
    800064e2:	00275783          	lhu	a5,2(a4)
    800064e6:	2785                	addiw	a5,a5,1
    800064e8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800064ec:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800064f0:	100017b7          	lui	a5,0x10001
    800064f4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800064f8:	004aa783          	lw	a5,4(s5)
    800064fc:	02c79163          	bne	a5,a2,8000651e <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006500:	0002b917          	auipc	s2,0x2b
    80006504:	c2890913          	addi	s2,s2,-984 # 80031128 <disk+0x2128>
  while(b->disk == 1) {
    80006508:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000650a:	85ca                	mv	a1,s2
    8000650c:	8556                	mv	a0,s5
    8000650e:	ffffc097          	auipc	ra,0xffffc
    80006512:	e7c080e7          	jalr	-388(ra) # 8000238a <sleep>
  while(b->disk == 1) {
    80006516:	004aa783          	lw	a5,4(s5)
    8000651a:	fe9788e3          	beq	a5,s1,8000650a <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    8000651e:	f8042903          	lw	s2,-128(s0)
    80006522:	20090713          	addi	a4,s2,512
    80006526:	0712                	slli	a4,a4,0x4
    80006528:	00029797          	auipc	a5,0x29
    8000652c:	ad878793          	addi	a5,a5,-1320 # 8002f000 <disk>
    80006530:	97ba                	add	a5,a5,a4
    80006532:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006536:	0002b997          	auipc	s3,0x2b
    8000653a:	aca98993          	addi	s3,s3,-1334 # 80031000 <disk+0x2000>
    8000653e:	00491713          	slli	a4,s2,0x4
    80006542:	0009b783          	ld	a5,0(s3)
    80006546:	97ba                	add	a5,a5,a4
    80006548:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000654c:	854a                	mv	a0,s2
    8000654e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006552:	00000097          	auipc	ra,0x0
    80006556:	c60080e7          	jalr	-928(ra) # 800061b2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000655a:	8885                	andi	s1,s1,1
    8000655c:	f0ed                	bnez	s1,8000653e <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000655e:	0002b517          	auipc	a0,0x2b
    80006562:	bca50513          	addi	a0,a0,-1078 # 80031128 <disk+0x2128>
    80006566:	ffffa097          	auipc	ra,0xffffa
    8000656a:	71e080e7          	jalr	1822(ra) # 80000c84 <release>
}
    8000656e:	70e6                	ld	ra,120(sp)
    80006570:	7446                	ld	s0,112(sp)
    80006572:	74a6                	ld	s1,104(sp)
    80006574:	7906                	ld	s2,96(sp)
    80006576:	69e6                	ld	s3,88(sp)
    80006578:	6a46                	ld	s4,80(sp)
    8000657a:	6aa6                	ld	s5,72(sp)
    8000657c:	6b06                	ld	s6,64(sp)
    8000657e:	7be2                	ld	s7,56(sp)
    80006580:	7c42                	ld	s8,48(sp)
    80006582:	7ca2                	ld	s9,40(sp)
    80006584:	7d02                	ld	s10,32(sp)
    80006586:	6de2                	ld	s11,24(sp)
    80006588:	6109                	addi	sp,sp,128
    8000658a:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000658c:	f8042503          	lw	a0,-128(s0)
    80006590:	20050793          	addi	a5,a0,512
    80006594:	0792                	slli	a5,a5,0x4
  if(write)
    80006596:	00029817          	auipc	a6,0x29
    8000659a:	a6a80813          	addi	a6,a6,-1430 # 8002f000 <disk>
    8000659e:	00f80733          	add	a4,a6,a5
    800065a2:	01a036b3          	snez	a3,s10
    800065a6:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800065aa:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800065ae:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065b2:	7679                	lui	a2,0xffffe
    800065b4:	963e                	add	a2,a2,a5
    800065b6:	0002b697          	auipc	a3,0x2b
    800065ba:	a4a68693          	addi	a3,a3,-1462 # 80031000 <disk+0x2000>
    800065be:	6298                	ld	a4,0(a3)
    800065c0:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065c2:	0a878593          	addi	a1,a5,168
    800065c6:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065c8:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800065ca:	6298                	ld	a4,0(a3)
    800065cc:	9732                	add	a4,a4,a2
    800065ce:	45c1                	li	a1,16
    800065d0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800065d2:	6298                	ld	a4,0(a3)
    800065d4:	9732                	add	a4,a4,a2
    800065d6:	4585                	li	a1,1
    800065d8:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800065dc:	f8442703          	lw	a4,-124(s0)
    800065e0:	628c                	ld	a1,0(a3)
    800065e2:	962e                	add	a2,a2,a1
    800065e4:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcc00e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800065e8:	0712                	slli	a4,a4,0x4
    800065ea:	6290                	ld	a2,0(a3)
    800065ec:	963a                	add	a2,a2,a4
    800065ee:	058a8593          	addi	a1,s5,88
    800065f2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800065f4:	6294                	ld	a3,0(a3)
    800065f6:	96ba                	add	a3,a3,a4
    800065f8:	40000613          	li	a2,1024
    800065fc:	c690                	sw	a2,8(a3)
  if(write)
    800065fe:	e40d1ae3          	bnez	s10,80006452 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006602:	0002b697          	auipc	a3,0x2b
    80006606:	9fe6b683          	ld	a3,-1538(a3) # 80031000 <disk+0x2000>
    8000660a:	96ba                	add	a3,a3,a4
    8000660c:	4609                	li	a2,2
    8000660e:	00c69623          	sh	a2,12(a3)
    80006612:	b5b9                	j	80006460 <virtio_disk_rw+0xd2>

0000000080006614 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006614:	1101                	addi	sp,sp,-32
    80006616:	ec06                	sd	ra,24(sp)
    80006618:	e822                	sd	s0,16(sp)
    8000661a:	e426                	sd	s1,8(sp)
    8000661c:	e04a                	sd	s2,0(sp)
    8000661e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006620:	0002b517          	auipc	a0,0x2b
    80006624:	b0850513          	addi	a0,a0,-1272 # 80031128 <disk+0x2128>
    80006628:	ffffa097          	auipc	ra,0xffffa
    8000662c:	5a8080e7          	jalr	1448(ra) # 80000bd0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006630:	10001737          	lui	a4,0x10001
    80006634:	533c                	lw	a5,96(a4)
    80006636:	8b8d                	andi	a5,a5,3
    80006638:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000663a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000663e:	0002b797          	auipc	a5,0x2b
    80006642:	9c278793          	addi	a5,a5,-1598 # 80031000 <disk+0x2000>
    80006646:	6b94                	ld	a3,16(a5)
    80006648:	0207d703          	lhu	a4,32(a5)
    8000664c:	0026d783          	lhu	a5,2(a3)
    80006650:	06f70163          	beq	a4,a5,800066b2 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006654:	00029917          	auipc	s2,0x29
    80006658:	9ac90913          	addi	s2,s2,-1620 # 8002f000 <disk>
    8000665c:	0002b497          	auipc	s1,0x2b
    80006660:	9a448493          	addi	s1,s1,-1628 # 80031000 <disk+0x2000>
    __sync_synchronize();
    80006664:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006668:	6898                	ld	a4,16(s1)
    8000666a:	0204d783          	lhu	a5,32(s1)
    8000666e:	8b9d                	andi	a5,a5,7
    80006670:	078e                	slli	a5,a5,0x3
    80006672:	97ba                	add	a5,a5,a4
    80006674:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006676:	20078713          	addi	a4,a5,512
    8000667a:	0712                	slli	a4,a4,0x4
    8000667c:	974a                	add	a4,a4,s2
    8000667e:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80006682:	e731                	bnez	a4,800066ce <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006684:	20078793          	addi	a5,a5,512
    80006688:	0792                	slli	a5,a5,0x4
    8000668a:	97ca                	add	a5,a5,s2
    8000668c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000668e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006692:	ffffc097          	auipc	ra,0xffffc
    80006696:	e78080e7          	jalr	-392(ra) # 8000250a <wakeup>

    disk.used_idx += 1;
    8000669a:	0204d783          	lhu	a5,32(s1)
    8000669e:	2785                	addiw	a5,a5,1
    800066a0:	17c2                	slli	a5,a5,0x30
    800066a2:	93c1                	srli	a5,a5,0x30
    800066a4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800066a8:	6898                	ld	a4,16(s1)
    800066aa:	00275703          	lhu	a4,2(a4)
    800066ae:	faf71be3          	bne	a4,a5,80006664 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800066b2:	0002b517          	auipc	a0,0x2b
    800066b6:	a7650513          	addi	a0,a0,-1418 # 80031128 <disk+0x2128>
    800066ba:	ffffa097          	auipc	ra,0xffffa
    800066be:	5ca080e7          	jalr	1482(ra) # 80000c84 <release>
}
    800066c2:	60e2                	ld	ra,24(sp)
    800066c4:	6442                	ld	s0,16(sp)
    800066c6:	64a2                	ld	s1,8(sp)
    800066c8:	6902                	ld	s2,0(sp)
    800066ca:	6105                	addi	sp,sp,32
    800066cc:	8082                	ret
      panic("virtio_disk_intr status");
    800066ce:	00002517          	auipc	a0,0x2
    800066d2:	18a50513          	addi	a0,a0,394 # 80008858 <syscalls+0x408>
    800066d6:	ffffa097          	auipc	ra,0xffffa
    800066da:	e64080e7          	jalr	-412(ra) # 8000053a <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
