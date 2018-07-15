j main
j interrupt
j exception

#定时器设置
addi $t1, $zero, -1000
lui $t0, 0x4000
sw $t1, 0($t0)
addi $t0, $t0, 0x0004
sw $t1, 0($t0)
addi $t0, $t0, 0x0004
sw $zero, 0($t0)


main:
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
	# li $v0, 1
	# move $a0, $s0
	# syscall