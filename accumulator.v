//-----------------------------------------------------------------------------
// Accumulator
//-----------------------------------------------------------------------------

module accumulator #( parameter W = 32 )
(
    input clk, reset,
    input [W-1:0] in,
    output reg [W-1:0] out
);

    initial begin
        out <= {W{1'b1}};
    end

    always @ ( posedge clk ) begin
        if (reset)
            out <= {W{1'b0}};
        else
            out <= out + in;
    end

endmodule
