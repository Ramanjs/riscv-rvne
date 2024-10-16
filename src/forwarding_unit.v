module forwarding_unit (
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd_M,
    input [4:0] rd_WB,

    input            regWrite_WB,
    input            regWrite_M,
    output reg [1:0] forward_A,
    output reg [1:0] forward_B
);

  always @(*) begin
    if ((rd_M == rs1) & (regWrite_M != 0 & rd_M != 0)) forward_A = 2'b10;
    else if ((rd_WB == rs1) & (regWrite_WB != 0 & rd_WB != 0)) forward_A = 2'b01;
    else forward_A = 2'b00;

    if ((rd_M == rs2) & (regWrite_M != 0 & rd_M != 0)) forward_B = 2'b10;
    else if ((rd_WB == rs2) & (regWrite_WB != 0 & rd_WB != 0)) forward_B = 2'b01;
    else forward_B = 2'b00;
  end
endmodule
