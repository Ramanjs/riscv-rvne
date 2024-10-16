module instruction_memory (
    input      [ 6:0] inst_address,
    output reg [31:0] instruction
);

  reg [31:0] RAM[127:0];
  initial begin
    $readmemh("memfile.dat", RAM);
  end
  assign instruction = RAM[inst_address];
endmodule
