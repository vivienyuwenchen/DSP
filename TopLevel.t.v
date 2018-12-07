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
    if(dsp.Accumulator.out != 32'h1 || dsp.P.q != 32'h1 || dsp.T.q != 16'h1) begin
          $display("----------------------------------------");
          $display("FAILED PIPELINE ALU TEST");
          $display("$AccumOut$: Expected: %h, ACTUAL: %h", 32'h1, dsp.Accumulator.out);
          $display("$Pout$: Expected: %h, ACTUAL: %h", 32'h1, dsp.P.q);
          $display("$Tout$: Expected: %h, ACTUAL: %h", 16'h1, dsp.T.q);
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