module NSR (
    input         clk,
    input         we,
    input         we1,
    input  [ 1:0] VL,
    input  [ 4:0] ra,
    input  [ 4:0] wa,
    input  [31:0] wd,
    input  [31:0] wd1,
    output [31:0] rd
);

  reg [31:0] CUR[32];
  reg [31:0] VT;
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

  assign rd = CUR[ra];
endmodule
