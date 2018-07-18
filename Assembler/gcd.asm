j main
j interrupt
j exception

main:
	lui $t0, 0x4000
receive1:
	lw $t1, 32($t0)
	andi $t1, $t1, 0x0002
#t1 = uart_conr
	beq $t1, $zero, receive1
	lw $s0, 28($t0)
#读入s0
receive2:
	lw $t1, 32($t0)
	andi $t1, $t1, 0x0002
	beq $t1, $zero, receive2
	lw $s1, 28($t0)
#读入s1
#timer setting
	sw $zero, 8($t0)
#t0 = 40000000
	addi $t1, $zero, -1000
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	addi $t1, $zero, 3
	sw $t1, 8($t0)
	
#backup
	add $s6, $zero, $s0
	add $s7, $zero, $s1
# addi $s0, $zero, 12331
# addi $s1, $zero, 23177
	addi $t7, $zero, 1
	j judge

shift:
	beq $t0, $zero, a_shift
	beq $t1, $zero, b_shift
a_shift:
	srl $s0, $s0, 1
	j judge
b_shift:
	srl $s1, $s1, 1
	j judge
judge:
	andi $t0, $s0, 1
	andi $t1, $s1, 1
	add $t2, $t0, $t1
	beq $t2, $t7, shift
gcd:
	beq $s0, $s1, end
	slt $t0, $s0, $s1
	beq $t0, $zero, b_s
a_s:
	sub $s1, $s1, $s0
	beq $s0, $s1, end
	j judge
b_s:
	sub $s0, $s0, $s1
	beq $s0, $s1, end
	j judge
end:
	lui $s2, 0x4000
	sw $s0, 24($s2)
# uart_txd = s0
wait:	
	j wait
#$t0, $t1, $t2, $t7, $s0, $s1, $a0, $v0
exception:
	jr $k1
#interrupt
interrupt:
	sw $s0, 12($s2) 
# led = s0
	lw $s3, 8($s2)
#s3 = tcon
	addi $s4, $zero, -7
	and $s3, $s3, $s4
	sw $s3, 8($s2)
	addi $s2, $s2, 20 
#s2 = 0x40000014 #start updating
	lw $s3,0($s2)
	andi $s3, $s3, 0x0f00 
#s3 = digi high
	addi $s4, $zero, 0x0100
	beq $s3, $zero, num11
	beq $s3, $s4, num12
	sll $s4, $s4, 1
	beq $s3, $s4, num21
	sll $s4, $s4, 1
	beq $s3, $s4, num22
	sll $s4, $s4, 1
	beq $s3, $s4, num11
num11:
	addi $s4, $zero, 0x0100 
#s4 = new digi high
	andi $t4, $s6, 0x000f 
#t4 = s0 low
	jal bcd
#t4 = new digi low
	j restore
num12:
	sll $s4, $s4, 1
	andi $t4, $s6, 0x00f0
	srl $t4, $t4, 4
#t4 = s0 high
	jal bcd
	j restore
num21:
	sll $s4, $s4, 1
	andi $t4, $s7, 0x000f
#t4 = s1 low
	jal bcd
	j restore
num22:
	sll $s4, $s4, 1
	andi $t4, $s7, 0x00f0
	srl $t4, $t4, 4
#t4 = s1 high
	jal bcd
	j restore
bcd:
	add $s3, $zero, $zero
#s3 counting
	beq $t4, $s3, d0
	addi $s3, $s3, 1
	beq $t4, $s3, d1
	addi $s3, $s3, 1
	beq $t4, $s3, d2
	addi $s3, $s3, 1
	beq $t4, $s3, d3
	addi $s3, $s3, 1
	beq $t4, $s3, d4
	addi $s3, $s3, 1
	beq $t4, $s3, d5
	addi $s3, $s3, 1
	beq $t4, $s3, d6
	addi $s3, $s3, 1
	beq $t4, $s3, d7
	addi $s3, $s3, 1
	beq $t4, $s3, d8
	addi $s3, $s3, 1
	beq $t4, $s3, d9
	addi $s3, $s3, 1
	beq $t4, $s3, d10
	addi $s3, $s3, 1
	beq $t4, $s3, d11
	addi $s3, $s3, 1
	beq $t4, $s3, d12
	addi $s3, $s3, 1
	beq $t4, $s3, d13
	addi $s3, $s3, 1
	beq $t4, $s3, d14
	addi $t4, $zero, 0x0071
	jr $ra
d0:
	addi $t4, $zero, 0x003f
	jr $ra
d1:
	addi $t4, $zero, 0x0006
	jr $ra
d2:
	addi $t4, $zero, 0x005b
	jr $ra
d3:
	addi $t4, $zero, 0x004f
	jr $ra
d4:
	addi $t4, $zero, 0x0066
	jr $ra
d5:
	addi $t4, $zero, 0x006d
	jr $ra
d6:
	addi $t4, $zero, 0x007d
	jr $ra
d7:
	addi $t4, $zero, 0x0007
	jr $ra
d8:
	addi $t4, $zero, 0x007f
	jr $ra
d9:
	addi $t4, $zero, 0x006f
	jr $ra
d10:
	addi $t4, $zero, 0x0077
	jr $ra
d11:
	addi $t4, $zero, 0x007c
	jr $ra
d12:
	addi $t4, $zero, 0x0039
	jr $ra
d13:
	addi $t4, $zero, 0x005e
	jr $ra
d14:
	addi $t4, $zero, 0x0079
	jr $ra
restore:
	add $t4, $t4, $s4
#t4 = new digi
	sw $t4, 0($s2)
	addi $s2, $s2, -12
#s2 = 0x40000008
	lw $s3, 0($s2)
#s3 = tcon
	addi $s4, $zero, 2
	or $s3, $s3, $s4
	sw $s3, 0($s2)
	jr $k0