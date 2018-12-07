//-----------------------------------------------------------------------------
// D Flip-Flops
//-----------------------------------------------------------------------------

// D flip-flop with parameterized bit width (default: 1-bit)
// Parameters in Verilog: http://www.asic-world.com/verilog/para_modules1.html
module dff #( parameter W = 32 )
(
    input clk,
    input enable,
    input [W-1:0] d,
    output reg [W-1:0] q
);

    initial q = {W{1'b0}};

    always @(posedge clk) begin
        if(enable) begin
            q <= d;
        end
    end

endmodule

// Auxiliary Registers
module auxreg #( parameter W = 16 )
(
    input clk,
    input ARP,
    input [W-1:0] in,
    output [W/2-1:0] out
);

    wire [W-1:0] interm, interm0, interm1;

    dff #(W) AR0(.clk(clk),
                    .enable(!ARP),
                    .d(in),
                    .q(interm0));

    dff #(W) AR1(.clk(clk),
                    .enable(ARP),
                    .d(in),
                    .q(interm1));

    assign interm = (ARP) ? interm1 : interm0;
    assign out = interm[7:0];

endmodule
