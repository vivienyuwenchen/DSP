`include "toplevel.v"
`timescale 1 ns / 1 ps

//------------------------------------------------------------------------
// Test bench load instructions and data memory.
// instructions were generated from test_dsp.asm
// This test bench test the funcitonality of all the  instructions this is capable of including ZAC, LACK, ADDS,LT , MPY, ADDH, AND, LAC, OR
// SUB, LDP, MPY, LTA, APAC, PAC, SPAC
//------------------------------------------------------------------------

module cpu_test ();

    reg clk;
    reg reset;

    // Clock generation
    initial clk=0;
    always #10 clk = !clk;

    // Instantiate CPU
    dsp dsp(.clk(clk));

    initial begin

    $readmemb("./assemble/machine_code_short.dat", dsp.InstrMem.mem, 0);
    $readmemb("./assemble/data_mem.dat", dsp.DataMem.mem, 0);

    $display("$mem %b",dsp.InstrMem.mem[0]);

  	$dumpfile("dspTopLevel.vcd");
  	$dumpvars();

  	// Assert reset pulse
  	reset = 0; #10;
  	reset = 1; #10;
  	reset = 0; #10;

    #82450;
         $display("----------------------------------------");
         $display("TEST Complete");
         $display("----------------------------------------");

  	#2000 $finish();
      end

  endmodule
