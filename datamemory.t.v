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


        // en = 1'b1; addr = 8'h15; in = 16'h1234; #1000
        // if (out != 16'h1234)
        //     $display("DATA MEMORY ERROR Expected: 1234, Got: %h", out);

        en = 1'b0; addr = 8'b0; in = 16'habcd; #1000
        if (out != 16'h0001)
            $display("DATA MEMORY ERROR Expected: 0001, Got: %h", out);
        en = 1'b0; addr = 8'b0; in = 16'habcd; #2000
        en = 1'b0; addr = 8'b01; in = 16'habcd; #2000
        en = 1'b0; addr = 8'b10; in = 16'habcd; #2000
        en = 1'b0; addr = 8'b11; in = 16'habcd; #2000
        en = 1'b0; addr = 8'b100; in = 16'habcd; #2000

        $display("Data memory tests done!");
        $display("--------------------------------------------------");
        $finish;
    end

endmodule
