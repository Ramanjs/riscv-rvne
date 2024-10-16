module riscv (
    input clk,
    input reset
);

  // Instruction Fetch wires
  wire [31:0] PC_in, PC_out, nextPC_in;
  wire [31:0] instruction;


  // Decode wires
  wire [31:0] instruction_D, PC_D, rd1, rd2, imm_data;
  wire [6:0] opcode, funct7;
  wire [4:0] rd, rs1, rs2;
  wire [2:0] funct3;
  wire [1:0] aluop;
  wire branch, memwrite, memtoreg, aluSrc, regwrite, WVRwrite, SVRwrite;


  // Execute wires
  wire [31:0] PC_E, imm_data_E, rd1_E, rd2_E, branchPC, aluA, aluB, aluFinalB, aluResult;
  wire [4:0] rs1_E, rs2_E, rd_E;
  wire [3:0] operation;
  wire [2:0] funct3_E;
  wire [1:0] aluop_E, forwardA, forwardB;
  wire funct7_5_E, branch_E, memtoreg_E, memwrite_E, regwrite_E, aluSrc_E, zero;
  wire WVRwrite_E, SVRwrite_E;


  wire stall, takeBranch, flush;


  // Memory wires
  wire [31:0] aluResult_M, PC_M, writeData_M, readdata_M;
  wire [4:0] rd_M;
  wire zero_M, branch_M, memtoreg_M, memwrite_M, regwrite_M;
  wire WVRwrite_M, SVRwrite_M;


  // Writeback wires
  wire [31:0] writeData_W, readdata_W, aluResult_W;
  wire [4:0] rd_W;
  wire memtoreg_W, regwrite_W, WVRwrite_W, SVRwrite_W;


  // WVR wires
  wire [31:0] wvr_readdata;
  wire [ 4:0] wvr_readaddr;


  // SVR wires
  wire [31:0] svr_readdata;
  wire [ 4:0] svr_readaddr;

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
      .funct3  (funct3),
      .stall   (stall),
      .branch  (branch),
      .memtoreg(memtoreg),
      .memwrite(memwrite),
      .aluSrc  (aluSrc),
      .regwrite(regwrite),
      .WVRwrite(WVRwrite),
      .SVRwrite(SVRwrite),
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
      .wd (writeData_W),
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
      .WVRwrite_in      (WVRwrite),
      .SVRwrite_in      (SVRwrite),
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
      .WVRwrite_out     (WVRwrite_E),
      .SVRwrite_out     (SVRwrite_E),
      .aluSrc_out       (aluSrc_E),
      .aluop_out        (aluop_E)
  );

  // Execute Stage
  alu_control aluct (
      .aluop    (aluop_E),
      .funct3   (funct3_E),
      .funct7_5 (funct7_5_E),
      .operation(operation)
  );
  adder branch_adder (
      .a  (PC_E),
      .b  (imm_data_E << 1),
      .out(branchPC)
  );
  mux3 forwardingmux1 (
      .in1(rd1_E),
      .in2(writeData_W),
      .in3(aluResult_M),
      .sel(forwardA),
      .out(aluA)
  );
  mux3 forwardingmux2 (
      .in1(rd2_E),
      .in2(writeData_W),
      .in3(aluResult_M),
      .sel(forwardB),
      .out(aluB)
  );
  forwarding_unit fu (
      .rs1        (rs1_E),
      .rs2        (rs2_E),
      .rd_M       (rd_M),
      .rd_WB      (rd_W),
      .regWrite_WB(regwrite_W),
      .regWrite_M (regwrite_M),
      .forward_A  (forwardA),
      .forward_B  (forwardB)
  );
  mux2 aluSrcMux (
      .d0(aluB),
      .d1(imm_data_E),
      .s (aluSrc_E),
      .y (aluFinalB)
  );
  alu aluex (
      .a     (aluA),
      .b     (aluFinalB),
      .aluop (operation),
      .result(aluResult),
      .zero  (zero)
  );

  EXMEM exmem_reg (
      .clk           (clk),
      .reset         (reset),
      .adder_in      (branchPC),
      .alu_result_in (aluResult),
      .zero_in       (zero),
      .writedata_in  (aluB),
      .rd_in         (rd_E),
      .branch_in     (branch_E),
      .memtoreg_in   (memtoreg_E),
      .memwrite_in   (memwrite_E),
      .regwrite_in   (regwrite_E),
      .WVRwrite_in   (WVRwrite_E),
      .SVRwrite_in   (SVRwrite_E),
      .flush         (flush),
      .adder_out     (PC_M),
      .zero_out      (zero_M),
      .alu_result_out(aluResult_M),
      .writedata_out (writeData_M),
      .rd_out        (rd_M),
      .branch_out    (branch_M),
      .memtoreg_out  (memtoreg_M),
      .memwrite_out  (memwrite_M),
      .regwrite_out  (regwrite_M),
      .WVRwrite_out  (WVRwrite_M),
      .SVRwrite_out  (SVRwrite_M)
  );

  // Memory Stage
  assign takeBranch = branch_M & zero_M;

  data_memory dmem (
      .clk(clk),
      .a  (aluResult_M),
      .wd (writeData_M),
      .we (memwrite_M),
      .rd (readdata_M)
  );

  MEMWB memwb_reg (
      .clk           (clk),
      .reset         (reset),
      .readdata_in   (readdata_M),
      .alu_result_in (aluResult_M),
      .rd_in         (rd_M),
      .memtoreg_in   (memtoreg_M),
      .regwrite_in   (regwrite_M),
      .WVRwrite_in   (WVRwrite_M),
      .SVRwrite_in   (SVRwrite_M),
      .readdata_out  (readdata_W),
      .alu_result_out(aluResult_W),
      .rd_out        (rd_W),
      .memtoreg_out  (memtoreg_W),
      .regwrite_out  (regwrite_W),
      .WVRwrite_out  (WVRwrite_W),
      .SVRwrite_out  (SVRwrite_W)
  );

  // Writeback Stage
  mux2 memregMux (
      .d0(aluResult_W),
      .d1(readdata_W),
      .s (memtoreg_W),
      .y (writeData_W)
  );


  /********** Neuromorphic Core **********/
  WVR wvr_reg (
      .clk(clk),
      .we (WVRwrite_W),
      .ra (wvr_readaddr),
      .wa (rd_W),
      .wd (writeData_W),
      .rd (wvr_readdata)
  );

  SVR svr_reg (
      .clk(clk),
      .we (SVRwrite_W),
      .ra (svr_readaddr),
      .wa (rd_W),
      .wd (writeData_W),
      .rd (svr_readdata)
  );
  /********** Neuromorphic Core **********/
endmodule
