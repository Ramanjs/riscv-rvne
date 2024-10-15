module alu_control (
    input      [1:0] aluop,
    input      [2:0] funct3,
    input            funct7_5,
    output reg [3:0] operation
);
  wire [3:0] funct;
  assign funct = {funct7_5, funct3};
  always @(*) begin
    operation = 4'b0000;
    if (aluop == 2'b01) operation = 4'b0110;
    if (aluop == 2'b00) operation = 4'b0010;
    if (aluop == 2'b10) begin
      if (funct == 4'b0000) operation = 4'b0010;
      if (funct == 4'b0111) operation = 4'b0000;
      if (funct == 4'b1000) operation = 4'b0110;
      if (funct == 4'b0110) operation = 4'b0001;
    end
  end
endmodule
