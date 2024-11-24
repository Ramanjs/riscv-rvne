import sys
import re

registers = {
    'x0': '00000', 'x1': '00001', 'x2': '00010', 'x3': '00011',
    'x4': '00100', 'x5': '00101', 'x6': '00110', 'x7': '00111',
    'x8': '01000', 'x9': '01001', 'x10': '01010', 'x11': '01011',
    'x12': '01100', 'x13': '01101', 'x14': '01110', 'x15': '01111',
    'x16': '10000', 'x17': '10001', 'x18': '10010', 'x19': '10011',
    'x20': '10100', 'x21': '10101', 'x22': '10110', 'x23': '10111',
    'x24': '11000', 'x25': '11001', 'x26': '11010', 'x27': '11011',
    'x28': '11100', 'x29': '11101', 'x30': '11110', 'x31': '11111'
}

opcodes = {
    'lw':  '0000011',  # Load word
    'lw.wv': '0000010',
    'lh.wv': '0000010',
    'la.wv': '0000010',
    'lw.sv': '0000010',
    'lh.sv': '0000010',
    'la.sv': '0000010',
    'lw.vt': '0110011',
    'sw':  '0100011',  # Store word
    'beq': '1100011',  # Branch equal
    'addi': '0010011',  # Add immediate
    'and':  '0110011',  # AND operation
    'sub':  '0110011'   # SUB operation
}

func3 = {
    'lw':   '010',
    'lw.wv': '000',
    'lh.wv': '001',
    'la.wv': '010',
    'lw.sv': '011',
    'lh.sv': '100',
    'la.sv': '101',
    'lw.vt': '111',
    'sw':   '010',
    'beq':  '000',
    'addi': '000',
    'and':  '111',
    'sub':  '000'
}

func7 = {
    'sub': '0100000',
    'lw.vt': '0000001',
    'and': '0000000'
}

def imm_to_bin(imm, bits):
    return format(int(imm) & ((1 << bits) - 1), f'0{bits}b')

def assemble_instruction(instruction):
    parts = instruction.split()
    inst = parts[0]
    
    if (inst[0:2] == 'lw' or inst[0:2] == 'lh' or inst[0:2] == 'la') and (inst != 'lw.vt'):
        rd = registers[parts[1]]
        offset, rs1 = re.match(r'(-?\d+)\((x\d+)\)', parts[2]).groups()
        imm = imm_to_bin(offset, 12)
        rs1_bin = registers[rs1]
        opcode = opcodes[inst]
        f3 = func3[inst]
        return f"{imm}{rs1_bin}{f3}{rd}{opcode}"

    elif inst == 'sw':
        rs2 = registers[parts[1]]
        offset, rs1 = re.match(r'(-?\d+)\((x\d+)\)', parts[2]).groups()
        imm = imm_to_bin(offset, 12)
        imm_11_5 = imm[:7]
        imm_4_0 = imm[7:]
        rs1_bin = registers[rs1]
        opcode = opcodes[inst]
        f3 = func3[inst]
        return f"{imm_11_5}{rs2}{rs1_bin}{f3}{imm_4_0}{opcode}"
    
    elif inst == 'beq':
        rs1 = registers[parts[1]]
        rs2 = registers[parts[2]]
        imm = imm_to_bin(parts[3], 13)
        imm_12 = imm[0]
        imm_10_5 = imm[1:7]
        imm_4_1 = imm[7:11]
        imm_11 = imm[11]
        opcode = opcodes[inst]
        f3 = func3[inst]
        return f"{imm_12}{imm_10_5}{rs2}{rs1}{f3}{imm_4_1}{imm_11}{opcode}"
    
    elif inst == 'addi':
        rd = registers[parts[1]]
        rs1 = registers[parts[2]]
        imm = imm_to_bin(parts[3], 12)
        opcode = opcodes[inst]
        f3 = func3[inst]
        return f"{imm}{rs1}{f3}{rd}{opcode}"
    
    elif inst == 'and' or inst == 'sub':
        rd = registers[parts[1]]
        rs1 = registers[parts[2]]
        rs2 = registers[parts[3]]
        opcode = opcodes[inst]
        f3 = func3[inst]
        f7 = func7[inst]
        return f"{f7}{rs2}{rs1}{f3}{rd}{opcode}"

    elif inst == 'lw.vt':
        rd = registers['x0']
        rs1 = registers[parts[1]]
        rs2 = registers[parts[2]]
        opcode = opcodes[inst]
        f3 = func3[inst]
        f7 = func7[inst]
        return f"{f7}{rs2}{rs1}{f3}{rd}{opcode}"
    
    return None

def assemble_riscv(input_path, output_path):
    with open(input_path, 'r') as f:
        lines = f.readlines()

    machine_code = []
    for line in lines:
        line = line.strip()
        if line == '' or line.startswith('#'):
            continue
        binary_instr = assemble_instruction(line)
        if binary_instr:
            hex_instr = format(int(binary_instr, 2), '08x').upper()
            machine_code.append(hex_instr)

    with open(output_path, 'w') as f:
        for code in machine_code:
            f.write(f"{code}\n")

source = sys.argv[1]

assemble_riscv(source, 'memfile.dat')
