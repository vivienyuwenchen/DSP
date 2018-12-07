//-----------------------------------------------------------------------------
// Accumulator
//-----------------------------------------------------------------------------

module accumulator #( parameter W = 32 )
(
    input clk, reset, load, abs, en,
    input [W-1:0] in,
    output reg [W-1:0] out
);

    initial begin
        out <= {W{1'b1}};
    end

    always @ ( posedge clk ) begin
        if (en) begin
            if (reset)
                out <= {W{1'b0}};
            else if (load)
                out <= in;
            else if (abs) begin
                if (out[W-1] == 1)
                    out <= -out;
                else if (out[W-1] == 0)
                    out <= out;
            end
            else
                out <= out + in;
        end
        else out <= out;
    end

endmodule
