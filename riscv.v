module riscv (
    input clk,
    input reset
);

  wire [31:0] PC_in, PC_out, nextPC_in, PC_D, PC_M;
  wire [31:0] instruction, instruction_D;
  wire [6:0] opcode, funct7;
  wire stall, takeBranch, flush;

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

endmodule
