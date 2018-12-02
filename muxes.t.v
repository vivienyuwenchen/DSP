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
        $display("--------------------------------------------------");
        $display("MUX2 tests starting...");

        in0=32'hAAAAAAAA; in1=32'hBBBBBBBB; sel=1'b0; #1000
        if(out != 32'hAAAAAAAA)
            $display("ERROR Expected: AAAAAAAA, Got: %h", out);

        in0=32'hAAAAAAAA; in1=32'hBBBBBBBB; sel=1'b1; #1000
        if(out != 32'hBBBBBBBB)
            $display("ERROR Expected: BBBBBBBB, Got: %h", out);

        $display("MUX2 tests done!");
        $display("--------------------------------------------------");
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
        #3000
        $display("--------------------------------------------------");
        $display("MUX4 tests starting...");

        in0=32'h0; in1=32'h1; in2=32'h2; in3=32'h3;
        sel=2'b00; #1000
        if(out != 32'h0)
            $display("ERROR Expected: 0, Got: %h", out);

        sel=2'b01; #1000
        if(out != 32'h1)
            $display("ERROR Expected: 1, Got: %h", out);

        sel=2'b10; #1000
        if(out != 32'h2)
            $display("ERROR Expected: 2, Got: %h", out);

        sel=2'b11; #1000
        if(out != 32'h3)
            $display("ERROR Expected: 3, Got: %h", out);

        $display("MUX4 tests done!");
        $display("--------------------------------------------------");
    end

endmodule

// MUX8
module testMUX8();

    reg [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
    reg [2:0] sel;
    wire [31:0] out;

    mux8 #(32) dut(.in0(in0),
                    .in1(in1),
                    .in2(in2),
                    .in3(in3),
                    .in4(in4),
                    .in5(in5),
                    .in6(in6),
                    .in7(in7),
                    .sel(sel),
                    .out(out));

    initial begin
        #8000
        $display("--------------------------------------------------");
        $display("MUX8 tests starting...");

        in0=32'h0; in1=32'h1; in2=32'h2; in3=32'h3; in4=32'h4; in5=32'h5; in6=32'h6; in7=32'h7;
        sel=3'b000; #1000
        if(out != 32'h0)
            $display("ERROR Expected: 0, Got: %h", out);

        sel=3'b001; #1000
        if(out != 32'h1)
            $display("ERROR Expected: 1, Got: %h", out);

        sel=3'b010; #1000
        if(out != 32'h2)
            $display("ERROR Expected: 2, Got: %h", out);

        sel=3'b011; #1000
        if(out != 32'h3)
            $display("ERROR Expected: 3, Got: %h", out);

        sel=3'b100; #1000
        if(out != 32'h4)
            $display("ERROR Expected: 4, Got: %h", out);

        sel=3'b101; #1000
        if(out != 32'h5)
            $display("ERROR Expected: 5, Got: %h", out);

        sel=3'b110; #1000
        if(out != 32'h6)
            $display("ERROR Expected: 6, Got: %h", out);

        sel=3'b111; #1000
        if(out != 32'h7)
            $display("ERROR Expected: 7, Got: %h", out);

        $display("MUX8 tests done!");
        $display("--------------------------------------------------");
    end

endmodule
