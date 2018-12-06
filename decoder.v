//------------------------------------------------------------------------
// Instruction Decoder
//------------------------------------------------------------------------

module instructiondecoder
(
    output [7:0]    OP_dk,     // 15:8 bits op of D type [operation]
    output [3:0]    OP_s,     // 15:12 bits of I-type & R-type
    output [3:0]    S,     // 25:21 bits of I-type & R-type
    output [6:0]    D,     // 15:11 bits of R-type
    output [6:0]   K,  // 15:0 bits of I-type [16-bit immediate]
    output    ARP,     // 25:0 bit of J-type [target address]
    output [15:0]   ALL,  // 32 bits of instruction from instruction memor
    input  [15:0]   instruction  // 32 bits of instruction from instruction memory
);

    assign OP_dk = instruction[15:8];
    assign OP_s = instruction[15:12];
    assign S = instruction[11:8];
    assign D = instruction[6:0];
    assign K = instruction[6:0];
    assign ARP = instruction[7];
    assign ALL = instruction[15:0];

endmodule
