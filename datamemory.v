//------------------------------------------------------------------------
// Data Memory Module
//------------------------------------------------------------------------

module datamem
(
    input clk,
    input en,                 // Data memory write enable
    input [31:0] addr,       // Data memory address
    input [31:0] in,         // Data memory input
    output [31:0] out        // Data memory output
);

    wire [11:0] index;      // Data memory index
    reg [31:0] mem[4095:0];     // 16kb Memory

    assign index = {addr[13:2]};

    always @(posedge clk) begin
        if (en) begin
            mem[index] <= in;
        end
    end

    assign out = mem[index];

endmodule
