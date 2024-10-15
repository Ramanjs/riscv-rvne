module alu (
    input      [31:0] a,
    input      [31:0] b,
    input      [ 3:0] aluop,
    output reg [31:0] result,
    output reg        zero
);

  always @(*) begin
    case (aluop)
      4'b0000: result = a & b;
      4'b0001: result = a | b;
      4'b0010: result = a + b;
      4'b0110: result = a - b;
      4'b1100: result = ~(a | b);  //nor
      default: result = 32'b0;
    endcase
    if (result == 0) zero = 1;
    else zero = 0;
  end
endmodule
