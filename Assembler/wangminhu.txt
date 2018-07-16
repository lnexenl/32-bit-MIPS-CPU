j Main
j InterruptProcess #中断处理
j ExceptionProcess #异常处理
Main:
add $s0, $0, $0
lui $s0, 0x4000
addi $s0, $s0, 0x0018 # s0 = 0x40000018

add $s1, $0, $0
lui $s1, 0x0000
addi $s1, $s1, 0x0002 # s1 = 0x40000002

add $a0, $0, $0
add $a1, $0, $0

#==================Open Timer===================#
addi $s0, $s0, -16 # s0 = 0x40000008
sw $0, 0($s0)

addi $s0, $s0, -8  # s0 = 0x40000000
addi $t0, $0, -1000
sw $t0, 0($s0)

addi $t0, $0, -1
addi $s0, $s0, 4   # s0 = 0x40000004
sw $t0, 0($s0)

addi $t0, $0, 3
addi $s0, $s0, 4   # s0 = 0x40000008
sw $t0, 0($s0)
#================================================#


addi $s0, $s0, 24   # s0 = 0x40000020
add $v0, $0, $0

#==================Get First Number===================#
getNumber1:
lw $t0, 0($s0)
and $t1, $t0, $s1
beq $t1, $0, getNumber1
addi $s0, $s0, -4
lw $a0, 0($s0)
addi $a2, $a0, 0
addi $s0, $s0, 4

#==================Get Second Number===================#
getNumber2:
lw $t0, 0($s0)
and $t1, $t0, $s1
beq $t1, $0, getNumber2
addi $s0, $s0, -4
lw $a1, 0($s0)
addi $a3, $a1, 0
addi $s0, $s0, 4
j Euclidean

#============Euclidean Algorithm to get gcd=============#
Div:
add $t2, $a0, $0
sub $t4, $t2, $a1
blez $t4, Swap
sub $t2, $t2, $a1
Swap:
add $a0, $a1, $0
add $a1, $t2, $0
Euclidean:
bne $a0, $a1, Div
add $v0, $a0, $0

#============display result=================#
lui $s0, 0x4000
addi $s0, $s0, 0x000C

sw $v0, 0($s0)

lui $s0, 0x4000
addi $s0, $s0, 0x0018
sw $v0, 0($s0)
#===========================================#

ForeverLoop:
add $v1, $0, $0
add $v1, $0, $0
j ForeverLoop

ExceptionProcess:
jr $k1

InterruptProcess:
addi $t5, $0, -7

add $s7, $0, $0
lui $s7, 0x4000
addi $s7, $s7, 0x0008
lw $t6, 0($s7)

and $t5, $t5, $t6
sw $t5, 0($s7)

addi $s7, $s7, 12

lw $t5, 0($s7)
andi $s6, $t5, 0x0F00

addi $t6, $0, 0x0100
beq $s6, $0, LabelA
beq $t6, $s6, LabelB
sll $t6, $t6, 1
beq $t6, $s6, LabelC
sll $t6, $t6, 1
beq $t6, $s6, LabelD
sll $t6, $t6, 1
beq $t6, $s6, LabelA

LabelA:
add $t7, $0, $0
andi $t7, $a3, 0x00F0
srl $t7, $t7, 4
jal Decoder
addi $t8, $0, 0x0100
or $t7, $t7, $t8
sw $t7, 0($s7)
j Exit
LabelB:
add $t7, $0, $0
andi $t7, $a3, 0x000F
jal Decoder
addi $t8, $0, 0x0200
or $t7, $t7, $t8
sw $t7, 0($s7)
j Exit
LabelC:
add $t7, $0, $0
andi $t7, $a2, 0x00F0
srl $t7, $t7, 4
jal Decoder
addi $t8, $0, 0x0400
or $t7, $t7, $t8
sw $t7, 0($s7)
j Exit
LabelD:
add $t7, $0, $0
andi $t7, $a2, 0x000F
jal Decoder
addi $t8, $0, 0x0800
or $t7, $t7, $t8
sw $t7, 0($s7)
j Exit
Decoder:
addi $t5, $0, 0
bne $t7, $t5, L1
addi $t7, $0, 0x0040
jr $ra
L1:
addi $t5, $t5, 1
bne $t7, $t5, L2
addi $t7, $0, 0x0079
jr $ra
L2:
addi $t5, $t5, 1
bne $t7, $t5, L3
addi $t7, $0, 0x0024
jr $ra
L3:
addi $t5, $t5, 1
bne $t7, $t5, L4
addi $t7, $0, 0x0030
jr $ra
L4:
addi $t5, $t5, 1
bne $t7, $t5, L5
addi $t7, $0, 0x0019
jr $ra
L5:
addi $t5, $t5, 1
bne $t7, $t5, L6
addi $t7, $0, 0x0012
jr $ra
L6:
addi $t5, $t5, 1
bne $t7, $t5, L7
addi $t7, $0, 0x0002
jr $ra
L7:
addi $t5, $t5, 1
bne $t7, $t5, L8
addi $t7, $0, 0x0078
jr $ra
L8:
addi $t5, $t5, 1
bne $t7, $t5, L9
addi $t7, $0, 0x0000
jr $ra
L9:
addi $t5, $t5, 1
bne $t7, $t5, L10
addi $t7, $0, 0x0010
jr $ra
L10:
addi $t5, $t5, 1
bne $t7, $t5, L11
addi $t7, $0, 0x0008
jr $ra
L11:
addi $t5, $t5, 1
bne $t7, $t5, L12
addi $t7, $0, 0x0003
jr $ra
L12:
addi $t5, $t5, 1
bne $t7, $t5, L13
addi $t7, $0, 0x0046
jr $ra
L13:
addi $t5, $t5, 1
bne $t7, $t5, L14
addi $t7, $0, 0x0021
jr $ra
L14:
addi $t5, $t5, 1
bne $t7, $t5, L15
addi $t7, $0, 0x0006
jr $ra
L15:
addi $t5, $t5, 1
addi $t7, $0, 0x000E
jr $ra
Exit:
add $s7, $0, $0
lui $s7, 0x4000
addi $s7, $s7, 0x0008
lw $t6, 0($s7)
lui $t7, 0x0000
addi $t7, $t7, 0x0002
or $t6, $t7, $t6
sw $t6, 0($s7)
jr $k0