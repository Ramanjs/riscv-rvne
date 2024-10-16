module data_memory (
    input             clk,
    input      [31:0] wd,
    input      [31:0] a,
    input             we,
    output reg [31:0] rd
);

  reg [31:0] RAM[127:0];
  assign rd = RAM[a[31:2]];

  always @(posedge clk) if (we) RAM[a[31:2]] <= wd;
endmodule
