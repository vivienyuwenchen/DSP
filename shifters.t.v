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
        $display("Testing barrel shifter...");
        in=16'hABCD; sh=4'h4; #1000
        if(out != 32'hFFFABCD0)
            $display("ERROR Expected: FFFABCD0, Got: %h", out);
        in=16'h1234; sh=4'hC; #1000
        if(out != 32'h01234000)
            $display("ERROR Expected: 01234000, Got: %h", out);
        $display("Done with barrel shifter!");
    end

endmodule
