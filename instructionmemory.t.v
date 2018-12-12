//------------------------------------------------------------------------
// Test Bench for Instruction Memory Module
//------------------------------------------------------------------------

`timescale 1 ns / 1 ps
`include "instructionmemory.v"

module testInstrMem();

    reg clk;
    reg [11:0] addr;
    wire [15:0] instr;

    instrmem dut(.clk(clk),
                    .addr(addr),
                    .instr(instr));

    initial clk=0;
    always #10 clk = !clk;

    initial begin
        $display("--------------------------------------------------");
        $display("Instruction memory tests starting...");

        $readmemb("./assemble/machine_code.dat", dut.mem, 0);
        $dumpfile("dspTopLevel.vcd");
        $dumpvars();
        addr = 12'h0; #1000
        if (instr != 16'h7F89)
            $display("INSTRUCTION MEMORY ERROR Expected: 7F89, Got: %h", instr);

        addr = 12'h2; #1000
        if (instr != 16'h7E0A)
            $display("INSTRUCTION MEMORY ERROR Expected: 7E0A, Got: %h", instr);

        $display("Instruction memory tests done!");
        $display("--------------------------------------------------");
        $finish;
    end

endmodule
