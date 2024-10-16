## RISC-V

Verilog source for a subset of the RV32I ISA.

### RVNE ISA

#### Synaptic weight loading instructions

__lw.wv/lh.wv/la.wv__

lw.wv:

| imm[11:0] | rs1[4:0] | funct3[2:0] | rd[4:0] | opcode[6:0] |
| --- | --- | --- | --- | --- |
| offset | base | 000 | WVR_dst | 0000010 |

lh.wv:

| imm[11:0] | rs1[4:0] | funct3[2:0] | hint[0] | rd[3:0] | opcode[6:0] |
| --- | --- | --- | --- | --- | --- |
| offset | base | 001 | hint | WVR_dst | 0000010 |

la.wv:

| imm[11:0] | rs1[4:0] | funct3[2:0] | hint[0] | rd[3:0] | opcode[6:0] |
| --- | --- | --- | --- | --- | --- |
| offset | base | 010 | hint | WVR_dst | 0000010 |

#### Spike vector loading instructions

__lw.sv/lh.sv/la.sv__

lw.sv:

| imm[11:0] | rs1[4:0] | funct3[2:0] | rd[4:0] | opcode[6:0] |
| --- | --- | --- | --- | --- |
| offset | base | 011 | SVR_dst | 0000010 |

lh.sv:

| imm[11:0] | rs1[4:0] | funct3[2:0] | hint[0] | rd[3:0] | opcode[6:0] |
| --- | --- | --- | --- | --- | --- |
| offset | base | 100 | hint | SVR_dst | 0000010 |

la.sv:

| imm[11:0] | rs1[4:0] | funct3[2:0] | hint[0] | rd[3:0] | opcode[6:0] |
| --- | --- | --- | --- | --- | --- |
| offset | base | 101 | hint | SVR_dst | 0000010 |
