//------------------------------------------------------------------------
// Test Bench for D Flip-Flops
//------------------------------------------------------------------------

`timescale 1 ns / 1 ps
`include "dff.v"

module testDFF();

    reg clk;
    reg enable;
    reg [31:0] d;
    wire [31:0] q;

    dff #(32) dut(.clk(clk),
                .enable(enable),
			    .d(d),
			    .q(q));

    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
        $display("--------------------------------------------------");
        $display("Testing DFF...");
        enable=1'b1; d=32'hAAAAAAAA; #1000
        if(q != 32'hAAAAAAAA)
            $display("ERROR Expected: AAAAAAAA, Got: %h", q);
        enable=1'b0; d=32'hBBBBBBBB; #1000
        if(q != 32'hAAAAAAAA)
            $display("ERROR Expected: AAAAAAAA, Got: %h", q);
        enable=1'b1; d=32'hCCCCCCCC; #1000
        if(q != 32'hCCCCCCCC)
            $display("ERROR Expected: CCCCCCCC, Got: %h", q);
        enable=1'b0; d=32'hDDDDDDDD; #1000
        if(q != 32'hCCCCCCCC)
            $display("ERROR Expected: CCCCCCCC, Got: %h", q);
        $display("Done with DFF!");
        $display("--------------------------------------------------");
        $finish();
    end
endmodule
