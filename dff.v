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

// // Stack for PC
// module stack #( parameter W = 32 )
// (
//     input
// );
//
//
//
// endmodule
