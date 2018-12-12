//------------------------------------------------------------------------
// Data Memory Module
//------------------------------------------------------------------------

module datamem
(
    input clk,
    input en,
    input [7:0] addr,
    input [15:0] in,
    output [15:0] out
);

    wire [7:0] index;
    reg [15:0] mem[143:0];

    assign index = {addr[7], addr[7:1]};

    always @(posedge clk) begin
        if (en) begin
            mem[addr] <= in;
        end
    end

    assign out = mem[addr];

endmodule
