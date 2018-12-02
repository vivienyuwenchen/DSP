//-----------------------------------------------------------------------------
// Test Bench for Barrel and Parallel Shifters
//-----------------------------------------------------------------------------

`include "shifters.v"

module testBarrel();

    reg [15:0] in;
    reg [3:0] sh;
    wire [31:0] out;

    barrel #(16) dut(.in(in),
                    .sh(sh),
			        .out(out));

    initial begin
        $display("--------------------------------------------------");
        $display("Barrel shifter tests starting...");
        in=16'hABCD; sh=4'h4; #1000
        if(out != 32'hFFFABCD0)
            $display("ERROR Expected: FFFABCD0, Got: %h", out);
        in=16'h1234; sh=4'hC; #1000
        if(out != 32'h01234000)
            $display("ERROR Expected: 01234000, Got: %h", out);
        $display("Barrel shifter tests done!");
        $display("--------------------------------------------------");
    end

endmodule

module testParallel();

    reg [31:0] in;
    reg [3:0] sh;
    wire [15:0] out;

    parallel #(32) dut(.in(in),
                    .sh(sh),
			        .out(out));

    initial begin
        $display("--------------------------------------------------");
        $display("Parallel shifter tests starting...");
        in=32'hABCDEF09; sh=4'h4; #1000
        if(out != 16'hBCDE)
            $display("ERROR Expected: BCDE, Got: %h", out);
        in=32'h12345678; sh=4'h1; #1000
        if(out != 16'h2468)
            $display("ERROR Expected: 2468, Got: %h", out);
        $display("Parallel shifter tests done!");
        $display("--------------------------------------------------");
    end

endmodule
