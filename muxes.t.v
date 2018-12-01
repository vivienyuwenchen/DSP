//------------------------------------------------------------------------
// Test Bench for Multiplexers
//------------------------------------------------------------------------

`include "muxes.v"

// MUX2
module testMUX2();

    reg [31:0] in0;
    reg [31:0] in1;
    reg sel;
    wire [31:0] out;

    mux2 #(32) dut(.in0(in0),
                .in1(in1),
			    .sel(sel),
			    .out(out));

    initial begin
        $display("Testing MUX2...");
        in0=32'hAAAAAAAA; in1=32'hBBBBBBBB; sel=1'b0; #1000
        if(out != 32'hAAAAAAAA)
            $display("ERROR Expected: AAAAAAAA, Got: %h", out);
        in0=32'hAAAAAAAA; in1=32'hBBBBBBBB; sel=1'b1; #1000
        if(out != 32'hBBBBBBBB)
            $display("ERROR Expected: BBBBBBBB, Got: %h", out);
        $display("Done with MUX2!");
    end
endmodule

// MUX4
module testMUX4();

    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [1:0] sel;
    wire [31:0] out;

    mux4 #(32) dut(.in0(in0),
                .in1(in1),
                .in2(in2),
                .in3(in3),
			          .sel(sel),
			          .out(out));

    initial begin
        $display("Testing MUX4...");
        in0=32'h0; in1=32'h1; in2=32'h2; in3=32'h3;  sel=2'b00; #1000
        if(out != 32'h0)
        $display("ERROR Expected: 0, Got: %h", out);
        in0=32'h0; in1=32'h1; in2=32'h2; in3=32'h3;  sel=2'b01; #1000
        if(out != 32'h1)
        $display("ERROR Expected: 1, Got: %h", out);
        in0=32'h0; in1=32'h1; in2=32'h2; in3=32'h3;  sel=2'b10; #1000
        if(out != 32'h2)
        $display("ERROR Expected: 2, Got: %h", out);
        in0=32'h0; in1=32'h1; in2=32'h2; in3=32'h3;  sel=2'b11; #1000
        if(out != 32'h3)
            $display("ERROR Expected: 3, Got: %h", out);
        $display("Done with MUX4!");
    end
endmodule
