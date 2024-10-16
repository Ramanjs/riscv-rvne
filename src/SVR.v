module SVR (
    input         clk,
    input         we,
    input  [ 4:0] ra,
    input  [ 4:0] wa,
    input  [31:0] wd,
    output [31:0] rd
);

  reg [31:0] rf[31:0];
  always @(posedge clk) if (we) rf[wa] <= wd;

  assign rd = rf[ra];

endmodule
