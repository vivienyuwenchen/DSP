//-----------------------------------------------------------------------------
// Test Bench for Accumulator
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ps
`include "accumulator.v"

module testAccumulator();

    reg clk, reset, load, abs, en;
    reg [31:0] in;
    wire [31:0] out;

    accumulator #(32) dut(.clk(clk),
                    .reset(reset),
                    .load(load),
                    .abs(abs),
                    .en(en),
                    .in(in),
                    .out(out));

    initial begin
        $display("--------------------------------------------------");
        $display("Accumulator tests starting...");

        reset=1'b0; load=1'b0; abs=1'b0; en=1'b1; in=32'h1; clk=0; #100 clk=1; #100
        clk=0; #100 clk=1; #100
        if(out != 32'h00000001)
            $display("ACCUMULATOR ERROR Expected: 00000001, Got: %h", out);

        clk=0; #100 clk=1; #100
        if(out != 32'h00000002)
            $display("ACCUMULATOR ERROR Expected: 00000002, Got: %h", out);

        in=32'hF0; clk=0; #100 clk=1; #100
        if(out != 32'h000000F2)
            $display("ACCUMULATOR ERROR Expected: 000000F2, Got: %h", out);

        reset=1'b1; in=32'h5400; clk=0; #100 clk=1; #100
        if(out != 32'h00000000)
            $display("ACCUMULATOR ERROR Expected: 00000000, Got: %h", out);

        reset=1'b0; in=32'hABCD0000; clk=0; #100 clk=1; #100
        if(out != 32'hABCD0000)
            $display("ACCUMULATOR ERROR Expected: ABCD0000, Got: %h", out);

        load=1'b1; in=32'h00001234; clk=0; #100 clk=1; #100
        if(out != 32'h00001234)
            $display("ACCUMULATOR ERROR Expected: 00001234, Got: %h", out);

        load=1'b0; in=32'hFFFFEDCB; clk=0; #100 clk=1; #100
        if(out != 32'hFFFFFFFF)
            $display("ACCUMULATOR ERROR Expected: FFFFFFFF, Got: %h", out);

        abs=1'b1; clk=0; #100 clk=1; #100
        if(out != 32'h00000001)
            $display("ACCUMULATOR ERROR Expected: 00000001, Got: %h", out);

        $display("Accumulator tests done!");
        $display("--------------------------------------------------");
        $finish;
    end

endmodule
