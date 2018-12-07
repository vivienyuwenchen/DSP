//------------------------------------------------------------------------
// Test Bench for Instruction Decoder
//------------------------------------------------------------------------

`include "decoder.v"

module testInstrDecoder();
    wire [7:0]  OP_dk, K;
    wire [6:0]  D;
    wire [3:0]  OP_s, S;
    wire  ARP;
    reg  [15:0] instruction;

    instructiondecoder dut(.OP_dk(OP_dk),
                    .OP_s(OP_s),
                    .S(S),
                    .D(D),
                    .K(K),
                    .ARP(ARP),
                    .instruction(instruction));

    initial begin
        $display("--------------------------------------------------");
        $display("Instruction decoder tests starting...");

        instruction = 16'h2BAD; #1000

        if (OP_dk == 8'h2B && OP_s == 4'h2 && S == 4'hB &&
            D == 7'h2D && K == 8'hAD && ARP == 1'b1) begin
            $display("Test 1 Passed!");
        end
        else begin
            $display("Test 1 Failed :(");
            $display("OP_dk: %h, Expected: 2B", OP_dk);
            $display("OP_s: %h, Expected: 2", OP_s);
            $display("S: %h, Expected: B", S);
            $display("D: %h, Expected: 2D", D);
            $display("K: %h, Expected: AD", K);
            $display("ARP: %h, Expected: 1", ARP);
        end

        $display("Instruction decoder tests done!");
        $display("--------------------------------------------------");
    end
endmodule
