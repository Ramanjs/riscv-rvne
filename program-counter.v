module program_counter (
    input      [31:0] PC_in,
    input             clk,
    input             reset,
    input             stall,
    output reg [31:0] PC_out
);

  always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) PC_out <= '0;
    else if (stall == 1'b0) PC_out <= PC_in;
  end

endmodule
