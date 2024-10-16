module IFID (
    input             clk,
    input             reset,
    input      [31:0] instruction,
    input      [31:0] instr_address,
    input             flush,
    output reg [31:0] instruction_out,
    output reg [31:0] instr_address_out
);

  always @(posedge clk or posedge reset) begin
    if (reset == 1'b1 || flush == 1'b1) begin
      instruction_out   <= 32'd0;
      instr_address_out <= 32'd0;
    end else begin
      instruction_out   <= instruction;
      instr_address_out <= instr_address;
    end
  end

endmodule
