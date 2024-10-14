module IDEX (
    input             clk,
    reset,
    input      [ 3:0] funct3_in,          //funct3 of instruction from instruction memory
    input             funct7_5_in,
    input      [31:0] instr_address_in,   //adder input, ouput of IFID carried forward
    input      [31:0] rd1_in,             //from regfile
    input      [31:0] rd2_in,             //from regfile
    input      [31:0] imm_data_in,        //from data extractor
    input      [ 4:0] rs1_in,             //from instruction parser
    input      [ 4:0] rs2_in,             //from instruction parser
    input      [ 4:0] rd_in,              //from instruction parser
    input             branch_in,
    memtoreg_in,
    memwrite_in,
    aluSrc_in,
    regwrite_in,  //from control unit
    input      [ 1:0] aluop_in,
    input             flush,
    output reg [31:0] instr_address_out,
    output reg [ 4:0] rs1_out,
    output reg [ 4:0] rs2_out,
    output reg [ 4:0] rd_out,
    output reg [31:0] imm_data_out,
    output reg [31:0] rd1_out,            //2bit mux
    output reg [31:0] rd2_out,            //2bit mux
    output reg [ 3:0] funct3_out,
    output reg        funct7_5_out,
    output reg        branch_out,
    memtoreg_out,
    memwrite_out,
    regwrite_out,
    aluSrc_out,
    output reg [ 1:0] aluop_out
);

  always @(posedge clk) begin
    if (reset == 1'b1 || flush == 1'b1) begin
      instr_address_out <= 32'b0;
      rs1_out           <= 5'b0;
      rs2_out           <= 5'b0;
      rd_out            <= 5'b0;
      imm_data_out      <= 32'b0;
      rd1_out           <= 32'b0;
      rd2_out           <= 32'b0;
      funct3_out        <= 4'b0;
      funct7_5_out      <= 1'b0;
      branch_out        <= 1'b0;
      memtoreg_out      <= 1'b0;
      memwrite_out      <= 1'b0;
      regwrite_out      <= 1'b0;
      aluSrc_out        <= 1'b0;
      aluop_out         <= 2'b0;
    end else begin
      instr_address_out <= instr_address_in;
      rs1_out <= rs1_in;
      rs2_out <= rs2_in;
      rd_out <= rd_in;
      imm_data_out <= imm_data_in;
      rd1_out <= rd1_in;
      rd2_out <= rd2_in;
      funct3_out <= funct3_in; //when connecting in top module Funct4 is wire containing this section of 31 bit instruction {instruction[30],instruction[14:12]}
      funct7_5_out <= funct7_5_in;
      branch_out <= branch_in;
      memtoreg_out <= memtoreg_in;
      memwrite_out <= memwrite_in;
      regwrite_out <= regwrite_in;
      aluSrc_out <= aluSrc_in;
      aluop_out <= aluop_in;
    end
  end
endmodule
