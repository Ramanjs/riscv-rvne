module register_file (
    input         clk,
    input         we,
    input  [ 4:0] ra1,
    input  [ 4:0] ra2,
    input  [ 4:0] wa3,
    input  [31:0] wd,
    output [31:0] rd1,
    output [31:0] rd2
);

  reg [31:0] rf[31:0];
  always @(posedge clk) if (we) rf[wa3] <= wd;

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;

endmodule
