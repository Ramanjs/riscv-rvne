module NACC (
    input      [127:0] S,
    input      [511:0] W,
    input      [ 31:0] Cur_in,
    input              VL,
    output reg [ 31:0] Cur_out
);
  reg     [6:0] num;
  integer       i;
  always @(*) begin
    Cur_out = Cur_in;
    if (VL == 1'b0) num = 31;
    else num = 127;

    for (i = 0; i <= num; i = i + 1) begin
      Cur_out += S[i] * W[4*i+:4];
    end
  end

endmodule
