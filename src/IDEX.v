module IDEX (
    input              clk,
    reset,
    input      [  2:0] funct3_in,          //funct3 of instruction from instruction memory
    input              funct7_5_in,
    input      [ 31:0] instr_address_in,   //adder input, ouput of IFID carried forward
    input      [ 31:0] rd1_in,             //from regfile
    input      [ 31:0] rd2_in,             //from regfile
    input      [ 31:0] imm_data_in,        //from data extractor
    input      [511:0] wvr_readdata_in,
    input      [511:0] cur_in,
    input      [511:0] vol_in,
    input      [ 31:0] vt_in,
    input      [127:0] svr_readdata_in,
    input      [ 31:0] nsr_readdata_in,
    input      [  4:0] rs1_in,             //from instruction parser
    input      [  4:0] rs2_in,             //from instruction parser
    input      [  4:0] rd_in,              //from instruction parser
    input              branch_in,
    memtoreg_in,
    memwrite_in,
    aluSrc_in,
    regwrite_in,
    WVRwrite_in,
    SVRwrite_in,  //from control unit
    NSRwrite_in,
    NSRwrite1_in,
    NACC_VL_in,
    SorNACC_in,
    input      [  1:0] aluop_in,
    input      [  1:0] VL_in,
    input      [  1:0] ns_vl_in,
    input              flush,
    output reg [ 31:0] instr_address_out,
    output reg [  4:0] rs1_out,
    output reg [  4:0] rs2_out,
    output reg [  4:0] rd_out,
    output reg [ 31:0] imm_data_out,
    output reg [ 31:0] rd1_out,            //2bit mux
    output reg [ 31:0] rd2_out,            //2bit mux
    output reg [511:0] wvr_readdata_out,
    output reg [511:0] cur_out,
    output reg [511:0] vol_out,
    output reg [ 31:0] vt_out,
    output reg [127:0] svr_readdata_out,
    output reg [ 31:0] nsr_readdata_out,
    output reg [  2:0] funct3_out,
    output reg         funct7_5_out,
    output reg         branch_out,
    memtoreg_out,
    memwrite_out,
    regwrite_out,
    aluSrc_out,
    WVRwrite_out,
    SVRwrite_out,
    NSRwrite_out,
    NSRwrite1_out,
    NACC_VL_out,
    SorNACC_out,
    output reg [  1:0] aluop_out,
    output reg [  1:0] VL_out,
    output reg [  1:0] ns_vl_out
);

  always @(posedge clk or posedge reset) begin
    if (reset == 1'b1 || flush == 1'b1) begin
      instr_address_out <= 32'b0;
      rs1_out           <= 5'b0;
      rs2_out           <= 5'b0;
      rd_out            <= 5'b0;
      imm_data_out      <= 32'b0;
      rd1_out           <= 32'b0;
      rd2_out           <= 32'b0;
      funct3_out        <= 3'b0;
      funct7_5_out      <= 1'b0;
      branch_out        <= 1'b0;
      memtoreg_out      <= 1'b0;
      memwrite_out      <= 1'b0;
      regwrite_out      <= 1'b0;
      aluSrc_out        <= 1'b0;
      aluop_out         <= 2'b0;
      WVRwrite_out      <= 1'b0;
      SVRwrite_out      <= 1'b0;
      VL_out            <= 2'b00;
      wvr_readdata_out  <= 512'b0;
      svr_readdata_out  <= 128'b0;
      nsr_readdata_out  <= 32'b0;
      NSRwrite_out      <= 1'b0;
      NSRwrite1_out     <= 1'b0;
      NACC_VL_out       <= 1'b0;
      SorNACC_out       <= 1'b0;
      cur_out           <= 512'd0;
      vol_out           <= 512'd0;
      vt_out            <= 32'd0;
      ns_vl_out         <= 2'b00;
    end else begin
      instr_address_out <= instr_address_in;
      rs1_out           <= rs1_in;
      rs2_out           <= rs2_in;
      rd_out            <= rd_in;
      imm_data_out      <= imm_data_in;
      rd1_out           <= rd1_in;
      rd2_out           <= rd2_in;
      funct3_out        <= funct3_in;
      funct7_5_out      <= funct7_5_in;
      branch_out        <= branch_in;
      memtoreg_out      <= memtoreg_in;
      memwrite_out      <= memwrite_in;
      regwrite_out      <= regwrite_in;
      aluSrc_out        <= aluSrc_in;
      aluop_out         <= aluop_in;
      WVRwrite_out      <= WVRwrite_in;
      SVRwrite_out      <= SVRwrite_in;
      VL_out            <= VL_in;
      wvr_readdata_out  <= wvr_readdata_in;
      svr_readdata_out  <= svr_readdata_in;
      nsr_readdata_out  <= nsr_readdata_in;
      NSRwrite_out      <= NSRwrite_in;
      NSRwrite1_out     <= NSRwrite1_in;
      NACC_VL_out       <= NACC_VL_in;
      SorNACC_out       <= SorNACC_in;
      cur_out           <= cur_in;
      vol_out           <= vol_in;
      vt_out            <= vt_in;
      ns_vl_out         <= ns_vl_in;
    end
  end
endmodule
