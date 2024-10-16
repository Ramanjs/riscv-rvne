module riscv (
    input clk,
    input reset
);

  // Instruction Fetch wires
  wire [31:0] PC_in, PC_out, nextPC_in, PC_M;
  wire [31:0] instruction;


  // Decode wires
  wire [31:0] instruction_D, PC_D, rd1, rd2, imm_data;
  wire [6:0] opcode, funct7;
  wire [4:0] rd, rs1, rs2;
  wire [2:0] funct3;
  wire [1:0] aluop;
  wire branch, memwrite, memtoreg, aluSrc, regwrite;


  // Execute wires
  wire [31:0] PC_E, imm_data_E, rd1_E, rd2_E;
  wire [4:0] rs1_E, rs2_E, rd_E;
  wire [2:0] funct3_E;
  wire [1:0] aluop_E;
  wire funct7_5_E, branch_E, memtoreg_E, memwrite_E, regwrite_E, aluSrc_E;

  wire stall, takeBranch, flush;


  // Writeback wires
  wire [ 4:0] rd_W;
  wire        regwrite_W;
  wire [31:0] writeData;

  // Instruction Fetch Stage
  program_counter pc (
      .clk   (clk),
      .reset (reset),
      .stall (stall),
      .PC_in (PC_in),
      .PC_out(PC_out)
  );
  adder pc_adder (
      .a  (PC_out),
      .b  (32'd4),
      .out(nextPC_in)
  );
  instruction_memory imem (
      .inst_address(PC_out[8:2]),
      .instruction (instruction)
  );
  mux2 newPCmux (
      .d0(nextPC_in),
      .d1(PC_M),
      .s (takeBranch),
      .y (PC_in)
  );

  IFID ifid_reg (
      .clk              (clk),
      .reset            (reset),
      .instruction      (instruction),
      .instr_address    (PC_out),
      .flush            (flush),
      .instruction_out  (instruction_D),
      .instr_address_out(PC_D)
  );

  // Decode Stage
  instruction_parser parser (
      .instruction(instruction_D),
      .opcode     (opcode),
      .rd         (rd),
      .funct3     (funct3),
      .rs1        (rs1),
      .rs2        (rs2),
      .funct7     (funct7)
  );
  control_unit cu (
      .opcode  (opcode),
      .stall   (stall),
      .branch  (branch),
      .memtoreg(memtoreg),
      .memwrite(memwrite),
      .aluSrc  (aluSrc),
      .regwrite(regwrite),
      .aluop   (aluop)
  );
  imm_extractor extractor (
      .instruction(instruction_D),
      .imm_data   (imm_data)
  );
  register_file regfile (
      .clk(clk),
      .we (regwrite_W),
      .ra1(rs1),
      .ra2(rs2),
      .wa3(rd_W),
      .wd (writeData),
      .rd1(rd1),
      .rd2(rd2)
  );

  IDEX idex_reg (
      .clk              (clk),
      .reset            (reset),
      .funct3_in        (funct3),
      .funct7_5_in      (funct7[5]),
      .instr_address_in (PC_D),
      .rd1_in           (rd1),
      .rd2_in           (rd2),
      .imm_data_in      (imm_data),
      .rs1_in           (rs1),
      .rs2_in           (rs2),
      .rd_in            (rd),
      .branch_in        (branch),
      .memtoreg_in      (memtoreg),
      .memwrite_in      (memwrite),
      .aluSrc_in        (aluSrc),
      .regwrite_in      (regwrite),
      .aluop_in         (aluop),
      .flush            (flush),
      .instr_address_out(PC_E),
      .rs1_out          (rs1_E),
      .rs2_out          (rs2_E),
      .rd_out           (rd_E),
      .imm_data_out     (imm_data_E),
      .rd1_out          (rd1_E),
      .rd2_out          (rd2_E),
      .funct3_out       (funct3_E),
      .funct7_5_out     (funct7_5_E),
      .branch_out       (branch_E),
      .memtoreg_out     (memtoreg_E),
      .memwrite_out     (memwrite_E),
      .regwrite_out     (regwrite_E),
      .aluSrc_out       (aluSrc_E),
      .aluop_out        (aluop_E)
  );

endmodule
