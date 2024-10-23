module MEMWB (
    input              clk,
    input              reset,
    input      [ 31:0] readdata_in,
    input      [511:0] readdata512_in,
    input      [ 31:0] alu_result_in,    //2 bit 2by1 mux input b
    input      [  4:0] rd_in,            //EX MEM output
    input              memtoreg_in,
    regwrite_in,
    WVRwrite_in,
    SVRwrite_in,  //ex mem output as mem wb inputs
    input      [  1:0] VL_in,
    output reg [ 31:0] readdata_out,     //1bit
    output reg [511:0] readdata512_out,
    output reg [ 31:0] alu_result_out,   //1bit
    output reg [  4:0] rd_out,
    output reg         memtoreg_out,
    regwrite_out,
    WVRwrite_out,
    SVRwrite_out,
    output reg [  1:0] VL_out
);

  always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
      readdata_out    <= 32'b0;
      readdata512_out <= 512'b0;
      alu_result_out  <= 32'b0;
      rd_out          <= 5'b0;
      memtoreg_out    <= 1'b0;
      regwrite_out    <= 1'b0;
      WVRwrite_out    <= 1'b0;
      SVRwrite_out    <= 1'b0;
      VL_out          <= 2'b00;
    end else begin
      readdata_out    <= readdata_in;
      readdata512_out <= readdata512_in;
      alu_result_out  <= alu_result_in;
      rd_out          <= rd_in;
      memtoreg_out    <= memtoreg_in;
      regwrite_out    <= regwrite_in;
      WVRwrite_out    <= WVRwrite_in;
      SVRwrite_out    <= SVRwrite_in;
      VL_out          <= VL_in;
    end
  end
endmodule
