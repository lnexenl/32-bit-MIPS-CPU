import re
Registers = ['zero', 'at', 'v0', 'v1', 'a0', 'a1', 'a2', 'a3', 't0', 't1', 't2', 't3', 't4', 't5', 't6', 't7', 's0', 's1', 's2', 's3', 's4', 's5', 's6', 's7', 't8', 't9', 'k0', 'k1', 'gp', 'sp', 'fp', 'ra']
OpCode = { 'nop':0, 'lw':35, 'sw':43, 'lui':15, 'add':0, 'addu':0, 'sub':0, 'subu':0, 'addi':8, 'addiu':9, 'and':0, 'or':0, 'xor':0, 'nor':0, 'andi':12, 'sll':0, 'srl':0, 'sra':0, 'slt':0, 'slti':10, 'sltiu':11, 'beq':4, 'bne':5, 'blez':6, 'bgtz':7, 'bltz':1, 'j':2, 'jal':3, 'jr':0, 'jalr':0}
funct = { 'nop':0, 'add':32, 'addu':33, 'sub':34, 'subu':35, 'and':36, 'or':37, 'xor':38, 'nor':39, 'sll':0, 'srl':2, 'sra':3, 'slt':42, 'jr':8, 'jalr':9}
MIPSFile = open('./gcd.asm', encoding='gb18030', errors='ignore')
def MIPS_code2machine_code(line, label, i):
    try:
        x = re.match(r'.*:?[ ]*(add|addu|sub|subu|and|or|xor|nor|slt)[ ]+\$(.+)[ ]*,[ ]*\$(.+)[ ]*,[ ]*\$(.+)', line) #有三个寄存器的指令
        if x:
            return hex((Registers.index(x.group(3)) << 21) + (Registers.index(x.group(4)) << 16) + (Registers.index(x.group(2)) << 11) + funct[x.group(1)])
        x = re.match(r'.*:?[ ]*(lw|sw)[ ]+\$(.+)[ ]*,[ ]*(.+)\(\$(.+)\)', line) #lw, sw
        if x:
            return hex((OpCode[x.group(1)] << 26) + (Registers.index(x.group(4)) << 21) + (Registers.index(x.group(2)) << 16) + (lambda x:int(x.group(3), 16) if x.group(3).startswith('0x') else int(x.group(3)))(x))
        x = re.match(r'.*:?[ ]*(beq|bne)[ ]+\$(.+)[ ]*,[ ]*\$(.+)[ ]*,[ ]*(.+)', line)
        if x:
            return hex((OpCode[x.group(1)] << 26) + (Registers.index(x.group(2)) << 21) + (Registers.index(x.group(3)) << 16) + i - label[x.group(4)])
        x = re.match(r'.*:?[ ]*(addi|addiu|andi|slti|sltiu)[ ]+\$(.+)[ ]*,[ ]*\$(.+)[ ]*,[ ]*(.+)', line) #含有offset和imm的指令（lw, sw除外）
        if x:
            return hex((OpCode[x.group(1)] << 26) + (Registers.index(x.group(2)) << 21) + (Registers.index(x.group(3)) << 16) + (lambda x:int(x.group(4), 16) if x.group(4).startswith('0x') else int(x.group(4)))(x))
        x = re.match(r'.*:?[ ]*(j|jal)[ ]+(.+)', line)
        if x:
            return hex((OpCode[x.group(1)] << 26) + (lambda x:int(x.group(2)) if x.group(2).isdigit() else label[x.group(2)])(x))
        x = re.match(r'.*:?[ ]*nop[ ]*', line)
        if x:
            return hex(0)
        x = re.match(r'.*:?[ ]*(blez|bgtz|blez)[ ]+\$(.+)[ ]*,[ ]*(.+)', line)
        if x:
            return hex((OpCode[x.group(1)] << 26) + (Registers.index(x.group(2)) << 21) + int(x.group(3)))
        x = re.match(r'.*:?[ ]*jr[ ]+\$(.+)', line)
        if x:
            return hex((Registers.index(x.group(1)) << 21) + 8)
        x = re.match(r'.*:?[ ]*jalr[ ]+\$(.+)[ ]*,[ ]*\$(.+)', line)
        if x:
            return hex((Registers.index(x.group(1)) << 21) + (Registers.index(x.group(2)) << 11) + 9)
        x = re.match(r'.*:?[ ]*lui[ ]+\$(.+)[ ]*,[ ]*(.+)', line)
        if x:
            return hex((15 << 26) + (Registers.index(x.group(1)) << 16) + (lambda x:int(x.group(2), 16) if x.group(2).startswith('0x') else int(x.group(2)))(x) + 9)
        x = re.match(r'.*:?[ ]*(sll|srl|sra)[ ]+\$(.+)[ ]*,[ ]*\$(.+)[ ]*,[ ]*(.+)', line)
        if x:
            return hex((Registers.index(x.group(2)) << 16) + (Registers.index(x.group(3)) << 11) + (int(x.group(4)) << 6) + funct[x.group(1)])
        return 'none'
    except: print('Error in verilog file')
label = {}
index = 0
MachineCodeFile = open('./MachineCode.v', 'w')
for line in MIPSFile:
    if line.startswith('#') or len(line.strip()) == 0: continue
    l = re.match(r'(.+):(.*)', line)
    if l:
        label[l.group(1)] = index
        if(not l.groups(2)): index = index + 1
    else:index = index + 1
MIPSFile.seek(0)
index = 0
for line in MIPSFile:
    res = MIPS_code2machine_code(line, label, index)
    if res != 'none':
        MachineCodeFile.write('ROMDATA['+ str(index) + '] <= 32\'h')
        MachineCodeFile.write(res[2:])
        MachineCodeFile.write(';\n')
        index = index + 1