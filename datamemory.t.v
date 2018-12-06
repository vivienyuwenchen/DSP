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

        en = 1'b1; addr = 8'h15; in = 16'h1234; #1000
        if (out != 16'h1234)
            $display("DATA MEMORY ERROR Expected: 1234, Got: %h", out);

        en = 1'b0; addr = 8'h15; in = 16'habcd; #1000
        if (out != 16'h1234)
            $display("DATA MEMORY ERROR Expected: 1234, Got: %h", out);

        $display("Data memory tests done!");
        $display("--------------------------------------------------");
        $finish;
    end

endmodule
