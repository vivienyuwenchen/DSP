//------------------------------------------------------------------------
// Instruction Memory Module
//------------------------------------------------------------------------

module instrmem
(
    input clk,
    input [11:0] addr,
    output [15:0] instr
);

    wire [11:0] index;
    reg [15:0] mem[4095:0];

    assign index = {addr[11], addr[11:1]};
    assign instr = mem[index];

endmodule
