`include "toplevel.v"

//------------------------------------------------------------------------
// Test bench for XOR SUB SLT sequence.
// instructions were generated from xor_sub_slt.asm
// This test bench test the ADDI, XORI, SUB, SLT, BNE, J functionality
// outputs are found at verious registers including
//------------------------------------------------------------------------

module cpu_test ();

    reg clk;
    reg reset;

    // Clock generation
    initial clk=0;
    always #10 clk = !clk;

    // Instantiate CPU
    dap dsp(.clk(clk));

    initial begin

    $readmemh("../asm/dat/alu_test.dat", cpu.mem.mem,0);

  	$dumpfile("dspTopLevel.vcd");
  	$dumpvars();

  	// Assert reset pulse
  	reset = 0; #10;
  	reset = 1; #10;
  	reset = 0; #10;

    #82450
    if(dsp.accumulator.AccumulatorOutput[8] != 32'h1 || dsp.accumulator.AccumulatorOutput[9] != 32'h3 || dsp.accumulator.AccumulatorOutput[10] != 32'h2 || dsp.accumulator.AccumulatorOutput[11] != 32'h3 || dsp.accumulator.AccumulatorOutput[12] != 32'h2 || dsp.accumulator.AccumulatorOutput[13] != 32'h5|| dsp.accumulator.AccumulatorOutput[14] != 32'h6 ) begin// || dsp.accumulator.AccumulatorOutput[4] != 32'hb || cpu.register.RegisterOutput[8] != 32'hb || cpu.register.RegisterOutput[9] != 32'h37)
          $display("----------------------------------------");
          $display("FAILED PIPELINE ALU TEST");
          $display("$t0$: Expected: %h, ACTUAL: %h", 32'h1, dsp.accumulator.AccumulatorOutput[8]);
          $display("$t1$: Expected: %h, ACTUAL: %h", 32'h3, dsp.accumulator.AccumulatorOutput[9]);
          $display("$t2$: Expected: %h, ACTUAL: %h", 32'h2, dsp.accumulator.AccumulatorOutput[10]);
          $display("$t3$: Expected: %h, ACTUAL: %h", 32'h3, dsp.accumulator.AccumsulatorOutput[11]);
          $display("$t4$: Expected: %h, ACTUAL: %h", 32'h2, dsp.accumulator.AccumulatorOutput[12]);
          $display("$t5$: Expected: %h, ACTUAL: %h", 32'h5, dsp.accumulator.AccumulatorOutput[13]);
          $display("$t6$: Expected: %h, ACTUAL: %h", 32'h6, dsp.accumulator.AccumulatorOutput[14]);
          $display("----------------------------------------");

          end
   else begin
         $display("----------------------------------------");
         $display("PASSED TEST");
         $display("----------------------------------------");
         end
  	#2000 $finish();
      end

  endmodule