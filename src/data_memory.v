module data_memory (
    input              clk,
    input      [ 31:0] wd,
    input      [ 31:0] a,
    input              we,
    output reg [ 31:0] rd1,
    output reg [511:0] rd2
);
  genvar i;
  reg [31:0] RAM[128];
  assign rd1 = RAM[a[31:2]];
  for (i = 0; i < 16; i = i + 1) begin
    assign rd2[32*i+:32] = RAM[a[31:2]+i];
  end

  always @(posedge clk) if (we) RAM[a[31:2]] <= wd;
  integer j;
  initial begin
    for (j = 0; j < 16; j = j + 1) begin
      RAM[j] = j;
    end
    $writememh("memh.txt", RAM);
  end
endmodule
