module testbench ();
  reg clk, reset;

  riscv dut (
      .clk  (clk),
      .reset(reset)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
  end

  initial begin
    clk   = 0;
    reset = 1;
    #5 reset = 0;
    #75 $stop;
  end

  always #5 clk = ~clk;

endmodule
