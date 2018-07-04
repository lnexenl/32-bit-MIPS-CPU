# 32-bit-MIPS-CPU

##### Instructions:

| Instruction | OpCode[5:0] | rs[4:0] | rt[4:0] | rd[4:0] | shamt[4:0] | funct[4:0] |
| ----------- | ----------- | ------- | ------- | ------- | ---------- | ---------- |
| nop         | 0           | 0       | 0       | 0       | 0          | 0          |
| lw          | 0x23        | rs      | rt      | offset  |            |            |
| sw          | 0x2b        | rs      | rt      | offset  |            |            |
| lui         | 0x0f        | 0       | rt      | imm     |            |            |
| add         | 0           | rs      | rt      | rd      | 0          | 0x20       |
| addu        | 0           | rs      | rt      | rd      | 0          | 0x21       |
| sub         | 0           | rs      | rt      | rd      | 0          | 0x22       |
| subu        | 0           | rs      | rt      | rd      | 0          | 0x23       |
| addi        | 0x08        | rs      | rt      | imm     |            |            |
| addiu       | 0x09        | rs      | rt      | imm     |            |            |
| and         | 0           | rs      | rt      | rd      | 0          | 0x24       |
| or          | 0           | rs      | rt      | rd      | 0          | 0x25       |
| xor         | 0           | rs      | rt      | rd      | 0          | 0x26       |
| nor         | 0           | rs      | rt      | rd      | 0          | 0x27       |
| andi        | 0x0c        | rs      | rt      | imm     |            |            |
| sll         | 0           | 0       | rt      | rd      | shamt      | 0          |
| srl         | 0           | 0       | rt      | rd      | shamt      | 0x02       |
| sra         | 0           | 0       | rt      | rd      | shamt      | 0x03       |
| slt         | 0           | rs      | rt      | rd      | 0          | 0x2a       |
| slti        | 0x0a        | rs      | rt      | imm     |            |            |
| sltiu       | 0x0b        | rs      | rt      | imm     |            |            |
| beq         | 0x04        | rs      | rt      | offset  |            |            |
| bne         | 0x05        | rs      | rt      | offset  |            |            |
| blez        | 0x06        | rs      | 0       | offset  |            |            |
| bgtz        | 7           | rs      | 0       | offset  |            |            |
| bltz        | 1           | rs      | 0       | offset  |            |            |
| j           | 0x02        | target  |         |         |            |            |
| jal         | 0x03        | target  |         |         |            |            |
| jr          | 0           | rs      | 0       | 0x08    |            |            |
| jalr        | 0           | rs      | 0       | rd      | 0          | 0x09       |