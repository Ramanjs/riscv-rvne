module control_unit (
    input      [6:0] opcode,
    input      [2:0] funct3,
    input            stall,
    output reg       branch,
    output reg       memtoreg,
    output reg       memwrite,
    output reg       aluSrc,
    output reg       regwrite,
    output reg       WVRwrite,
    output reg       SVRwrite,
    output reg       NSRwrite,
    output reg       NSRwrite1,
    output reg       NACC_VL,
    output reg       SorNACC,
    output reg [1:0] VL,
    output reg [1:0] aluop
);
  always @(*) begin
    if (opcode == 7'b0000011) begin
      aluSrc    = 1'b1;
      memtoreg  = 1'b1;
      regwrite  = 1'b1;
      memwrite  = 1'b0;
      branch    = 1'b0;
      WVRwrite  = 1'b0;
      SVRwrite  = 1'b0;
      VL        = 2'b00;
      aluop     = 2'b00;
      NSRwrite  = 1'b0;
      NSRwrite1 = 1'b0;
      NACC_VL   = 1'b0;
      SorNACC   = 1'b0;
    end else if (opcode == 7'b0100011) begin
      aluSrc    = 1'b1;
      memtoreg  = 1'bx;
      regwrite  = 1'b0;
      memwrite  = 1'b1;
      branch    = 1'b0;
      WVRwrite  = 1'b0;
      SVRwrite  = 1'b0;
      VL        = 2'b00;
      aluop     = 2'b00;
      NSRwrite  = 1'b0;
      NSRwrite1 = 1'b0;
      NACC_VL   = 1'b0;
      SorNACC   = 1'b0;
    end else if (opcode == 7'b0110011) begin
      aluSrc    = 1'b0;
      memtoreg  = 1'b0;
      regwrite  = 1'b1;
      memwrite  = 1'b0;
      branch    = 1'b0;
      WVRwrite  = 1'b0;
      SVRwrite  = 1'b0;
      VL        = 2'b00;
      aluop     = 2'b10;
      NSRwrite  = 1'b0;
      NSRwrite1 = 1'b0;
      NACC_VL   = 1'b0;
      SorNACC   = 1'b0;
      if (funct3 == 3'b111) begin
        regwrite  = 1'b0;
        NSRwrite1 = 1'b1;
        aluop     = 2'b00;
        memtoreg  = 1'b1;
      end
    end else if (opcode == 7'b1100011) begin
      aluSrc    = 1'b0;
      memtoreg  = 1'bx;
      regwrite  = 1'b0;
      memwrite  = 1'b0;
      branch    = 1'b1;
      WVRwrite  = 1'b0;
      SVRwrite  = 1'b0;
      VL        = 2'b00;
      aluop     = 2'b01;
      NSRwrite  = 1'b0;
      NSRwrite1 = 1'b0;
      NACC_VL   = 1'b0;
      SorNACC   = 1'b0;
    end else if (opcode == 7'b0010011) begin
      aluSrc    = 1'b1;
      memtoreg  = 1'b0;
      regwrite  = 1'b1;
      memwrite  = 1'b0;
      branch    = 1'b0;
      WVRwrite  = 1'b0;
      SVRwrite  = 1'b0;
      VL        = 2'b00;
      aluop     = 2'b00;
      NSRwrite  = 1'b0;
      NSRwrite1 = 1'b0;
      NACC_VL   = 1'b0;
      SorNACC   = 1'b0;
    end else if (opcode == 7'b0000010) begin
      aluSrc    = 1'b1;
      memtoreg  = 1'b1;
      regwrite  = 1'b0;
      memwrite  = 1'b0;
      branch    = 1'b0;
      aluop     = 2'b00;
      NSRwrite  = 1'b0;
      NSRwrite1 = 1'b0;
      NACC_VL   = 1'b0;
      SorNACC   = 1'b0;
      WVRwrite  = 1'b0;
      SVRwrite  = 1'b0;
      VL        = 2'b00;
      if (funct3 < 3'd3) WVRwrite = 1'b1;
      else if (3'd2 < funct3) SVRwrite = 1'b1;

      if (funct3 == 3'b001 || funct3 == 3'b100) VL = 2'b01;
      if (funct3 == 3'b010 || funct3 == 3'b101) VL = 2'b10;
    end else if (opcode == 7'b0110010) begin
      aluSrc    = 1'b0;
      memtoreg  = 1'b0;
      regwrite  = 1'b0;
      memwrite  = 1'b0;
      branch    = 1'b0;
      aluop     = 2'b00;
      WVRwrite  = 1'b0;
      SVRwrite  = 1'b0;
      VL        = 2'b00;
      NSRwrite  = 1'b1;
      NSRwrite1 = 1'b0;
      NACC_VL   = 1'b0;
      SorNACC   = 1'b0;

      if (funct3 == 3'b001) NACC_VL = 1'b1;
      if (funct3 < 3'b100) SorNACC = 1'b1;
    end else begin
      aluSrc    = 1'b0;
      memtoreg  = 1'b0;
      regwrite  = 1'b0;
      memwrite  = 1'b0;
      branch    = 1'b0;
      WVRwrite  = 1'b0;
      SVRwrite  = 1'b0;
      VL        = 2'b00;
      aluop     = 2'b00;
      NSRwrite  = 1'b0;
      NSRwrite1 = 1'b0;
      NACC_VL   = 1'b0;
      SorNACC   = 1'b0;
    end
  end
endmodule
