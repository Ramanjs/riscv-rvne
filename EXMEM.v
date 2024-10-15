module EXMEM (
    input             clk,
    input             reset,
    input      [31:0] adder_in,
    input      [31:0] alu_result_in,
    input             zero_in,
    input      [31:0] writedata_in,
    input      [ 4:0] rd_in,
    input             branch_in,
    memtoreg_in,
    memwrite_in,
    regwrite_in,
    input             flush,
    input             addermuxselect_in,
    output reg [31:0] adder_out,
    output reg        zero_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] writedata_out,
    output reg [ 4:0] rd_out,
    output reg        branch_out,
    memtoreg_out,
    memwrite_out,
    regwrite_out,
    output reg        addermuxselect_out
);

  always @(posedge clk) begin
    if (reset == 1'b1 || flush == 1'b1) begin
      adder_out          <= 32'b0;
      zero_out           <= 1'b0;
      alu_result_out     <= 32'b0;
      writedata_out      <= 64'b0;
      rd_out             <= 5'b0;
      branch_out         <= 1'b0;
      memtoreg_out       <= 1'b0;
      memwrite_out       <= 1'b0;
      regwrite_out       <= 1'b0;
      addermuxselect_out <= 1'b0;
    end else begin
      adder_out          <= adder_in;
      zero_out           <= zero_in;
      alu_result_out     <= alu_result_in;
      writedata_out      <= writedata_in;
      rd_out             <= rd_in;
      branch_out         <= branch_in;
      memtoreg_out       <= memtoreg_in;
      memwrite_out       <= memwrite_in;
      regwrite_out       <= regwrite_in;
      addermuxselect_out <= addermuxselect_in;
    end
  end
endmodule
