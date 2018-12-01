//-----------------------------------------------------------------------------
// Basic building block modules
//-----------------------------------------------------------------------------

module multiplier #( parameter W = 8 )
(
    input  [W-1:0]   a,
    input  [W-1:0]   b,
    output [W*2-1:0] out
);

	assign out = a * b;

endmodule


module accumulator #( parameter W = 16 )
(
    input              clk, load, clear,
    input      [W-1:0] mult_out,
    output reg [W-1:0] accum_out
);

    reg         load_reg;
    reg [W-1:0] old_result;

    always @ ( accum_out, load_reg ) begin
        if (load_reg)
            old_result <= 0;
        else
            old_result <= accum_out;
    end

    always @ ( posedge clk or posedge clear ) begin
        if (clear) begin
            load_reg <= 0;
            accum_out <= 0;
        end
        else begin
            load_reg <= load;
            accum_out <= old_result + mult_out;
        end
    end

endmodule
