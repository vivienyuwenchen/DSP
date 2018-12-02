//-----------------------------------------------------------------------------
// Test Bench for Multiplier
//-----------------------------------------------------------------------------

`include "multiplier.v"

module testMultiplier();

    reg [15:0] a, b;
    wire [31:0] out;

    multiplier #(16) dut(.a(a),
                    .b(b),
                    .out(out));

    initial begin
        $display("--------------------------------------------------");
        $display("Multiplier tests starting...");
        a=16'hABCD; b=16'h1234; #1000
        if(out != 32'h0C374FA4)
            $display("MULTIPLIER ERROR Expected: 0C374FA4, Got: %h", out);
        $display("Multiplier tests done!");
        $display("--------------------------------------------------");
        $finish;
    end

endmodule
