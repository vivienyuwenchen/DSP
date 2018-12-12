//------------------------------------------------------------------------
// Test Bench for Data Memory Module
//------------------------------------------------------------------------

`timescale 1 ns / 1 ps
`include "datamemory.v"

module testDataMem();

    reg clk;
    reg en;
    reg [7:0] addr;
    reg [15:0] in;
    wire [15:0] out;

    datamem dut(.clk(clk),
                    .en(en),
                    .addr(addr),
                    .in(in),
                    .out(out));

    initial clk=0;
    always #10 clk = !clk;

    initial begin
        $display("--------------------------------------------------");
        $display("Data memory tests starting...");
        $readmemb("./assemble/data_mem.dat", dut.mem, 0);
        $dumpfile("dut.vcd");
      	$dumpvars();
        $display("expected [0]: %b", dut.mem[0]);
        $display("expected [1]: %b", dut.mem[1]);
        $display("expected [2]: %b", dut.mem[2]);
        $display("expected [3]: %b", dut.mem[2]);
        $display("expected [4]: %b", dut.mem[2]);

        en = 1'b0; addr = 8'b0; in = 16'habcd; #1000
        if (out != 16'h1)
            $display("DATA MEMORY ERROR Expected: 1, Got: %h", out);
        else
            $display("Passed test 1");
        en = 1'b0; addr = 8'b01; in = 16'h2; #2000
        if (out != 16'h2)
            $display("DATA MEMORY ERROR Expected: 2, Got: %h", out);
        else
            $display("Passed test 2");
        en = 1'b0; addr = 8'b10; in = 16'h3; #2000
        if (out != 16'h3)
            $display("DATA MEMORY ERROR Expected: 3, Got: %h", out);
        else
            $display("Passed test 3");
        en = 1'b0; addr = 8'b11; in = 16'h4; #2000
        if (out != 16'h4)
            $display("DATA MEMORY ERROR Expected: 4, Got: %h", out);
        else
            $display("Passed test 4");
        en = 1'b0; addr = 8'b100; in = 16'h5; #2000
        if (out != 16'h5)
            $display("DATA MEMORY ERROR Expected: 5, Got: %h", out);
        else
            $display("Passed test 5");

        $display("Data memory tests done!");
        $display("--------------------------------------------------");
        $finish;
    end

endmodule
