module mux3 (
    input  wire [31:0] in1,
           wire [31:0] in2,
           wire [31:0] in3,
           wire [ 1:0] sel,
    output wire [31:0] out
);
  wire [31:0] temp;
  mux2 m1 (
      .d0(in1),
      .d1(in2),
      .s (sel[0]),
      .y (temp)
  );
  mux2 m2 (
      .d0(temp),
      .d1(in3),
      .s (sel[1]),
      .y (out)
  );
endmodule
