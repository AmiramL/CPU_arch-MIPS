.data 
	i: .word 1
	j: .word 2
	g: .word 3
	h: .word 4
	f: .word 5
.text
	la $s0,i
	lw $t1,0($s0)#$t1=i
	lw $t2,4($s0)#$t2=j
	lw $t3,8($s0)#$t3=g
	lw $t4,12($s0)#$t4=h
	slt $t0,$t1,$t2 #if i<j than $t0=1
	beq $t0,$zero,ELSE #if i>=j then go to else part
IF:	
 
ELSE:
END: