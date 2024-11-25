module NSR (
    input              clk,
    input              we,
    input              we1,
    input      [  4:0] ra,
    input      [  4:0] wa,
    input      [ 31:0] wd,
    input      [ 31:0] wd1,
    output reg [511:0] cur_out,
    output reg [511:0] vol_out,
    output reg [ 31:0] vt_out,
    output reg [ 31:0] rd
);

  reg     [31:0] CUR[32];
  reg     [31:0] VOL[32];
  reg     [31:0] VT;

  integer        j;
  initial begin
    for (j = 0; j < 32; j = j + 1) begin
      CUR[j] = j + 1;
      VOL[j] = j + 1;
    end
  end

  //integer        i;
  //always @(posedge clk) begin
  //if (we) begin
  //if (VL == 2'b00) rf[wa] <= wd[31:0];
  //else if (VL == 2'b01) begin
  //for (i = 0; i < 4; i = i + 1) begin
  //rf[wa+i] <= wd[32*i+:32];
  //end
  //end else if (VL == 2'b10) begin
  //for (i = 0; i < 16; i = i + 1) begin
  //rf[wa+i] <= wd[32*i+:32];
  //end
  //end
  //end
  //end
  always @(posedge clk) begin
    if (we) begin
      CUR[wa] <= wd;
    end
  end

  always @(posedge clk) begin
    if (we1) begin
      VT <= wd1;
    end
  end

  integer i;
  always @(*) begin
    for (i = 0; i < 16; i = i + 1) begin
      cur_out[32*i+:32] = CUR[ra+i];
      vol_out[32*i+:32] = VOL[ra+i];
    end
  end

  assign rd     = CUR[ra];
  assign vt_out = VT;
endmodule
