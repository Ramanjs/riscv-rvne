module SVR (
    input              clk,
    input              we,
    input      [  1:0] VL,
    input      [  4:0] ra,
    input      [  4:0] wa,
    input      [511:0] wd,
    output reg [127:0] rd
);

  reg     [31:0] rf[31];
  integer        i;
  always @(posedge clk) begin
    if (we) begin
      if (VL == 2'b00) rf[wa] <= wd[31:0];
      else if (VL == 2'b01) begin
        for (i = 0; i < 4; i = i + 1) begin
          rf[wa+i] <= wd[32*i+:32];
        end
      end else if (VL == 2'b10) begin
        for (i = 0; i < 16; i = i + 1) begin
          rf[wa+i] <= wd[32*i+:32];
        end
      end
    end
  end

  integer j;
  always @(*) begin
    for (j = 0; j < 4; j = j + 1) begin
      rd[32*j+:32] = rf[ra+j];
    end
  end
endmodule
