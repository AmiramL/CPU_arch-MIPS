#This program implements the following C code
#if (i<j)
#	f=g+h;
#else
#	f=g-h;
#end
.data 
s: .word 0x80000000 
h1: .word 0x00001234
h2: .word 0x00005678
h3: .word 0x00009abc
h4: .word 0x0000DEF0
ssg: .word 0x00000400
led: .word 0x00000404
but: .word 0x00000408
one: .word 0x0000000E
two: .word 0x0000000D
for: .word 0x0000000C
hun: .word 0x0000001F
ffff: .word 0xffffffff

fp1: .word 0x40100000#2.25
fp2: .word 0x42fb0000#125.5
fp3: .word 0xc3160148#-150.005

.text
# Before running this code make sure that
# Settings -> Memory Configuration -> Compact, Data at Address 0
	add $t0, $zero,$zero
	lw  $v0,ssg
	lw $v1,but
	lw $a0,led
	lw $t1,h1
	lw $t2,h2
	lw $t3,h3
	lw $t4,h4
	nop
	lw $s1,one
	lw $s2,two
	lw $s3,for
	lw $s4,hun
	nop
	nop
	nop
	nop
	sw $s4, 0x00000000($v0)
	sw $s4, 0x00000000($a0)
	nop
	nop
	nop
HERE:	nop
	nop
	beq $zero,$zero,HERE
	xor $s5,$a1,$a2
	nor $s6,$a2,$a1
	nor $s1,$a3,$a2
	nop
	nop
	sw $s4, 0x00000000($v0)
	sw $s4, 0x00000000($a0)
	nop
	nop
	nop
LOOP:	lw $t5,0x00000000($v1)
	nop
	nop
	nop
	nop
	nop
	beq $t5,$s1,HEX1
	beq $t5,$s2,HEX2
	beq $t5,$s3,HEX3
	beq $t5,$s4,HEX4
	#sw $zero, 0x00000000($v0)
	beq $zero,$zero,LOOP
	
HEX1:	#sw $t1, 0x00000000($v0)
	beq $zero,$zero,LOOP

HEX2:	#sw $t2, 0x00000000($v0)
	beq $zero,$zero,LOOP

HEX3:	#sw $t3, 0x00000000($v0)
	beq $zero,$zero,LOOP

HEX4:	#sw $t4, 0x00000000($v0)
	beq $zero,$zero,LOOP
	
