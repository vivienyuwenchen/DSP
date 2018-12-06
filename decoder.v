//------------------------------------------------------------------------
// Instruction Decoder
//------------------------------------------------------------------------

module instructiondecoder
(
    output [7:0]    OP_dk,     // 15:8 bits op of D type and K type [operation] 8 bits
    output [3:0]    OP_s,     // 15:12 bits op for s type
    output [3:0]    S,     // 11:8 bits in s type instruction
    output [6:0]    D,     // 15:11 bits of R-type
    output [7:0]    K,  // 7:0 bits of k type [8-bit immediate]
    output    ARP,     // 1 bit Addres pointing mode
    output [15:0]   ALL,  // 32 bits of instruction from instruction memor
    input  [15:0]   instruction  // 32 bits of instruction from instruction memory
);

    assign OP_dk = instruction[15:8];
    assign OP_s = instruction[15:12];
    assign S = instruction[11:8];
    assign D = instruction[6:0];
    assign K = instruction[7:0];
    assign ARP = instruction[7];
    assign ALL = instruction[15:0];

endmodule
