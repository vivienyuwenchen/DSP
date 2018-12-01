//-----------------------------------------------------------------------------
// Barrel and Parallel Shifters
//-----------------------------------------------------------------------------

module barrel #( parameter W = 16 )
(
    input[W-1:0]    in,
    input[W/4-1:0]  sh,
    output[W*2-1:0] out
);

    wire[W*2-1:0] interm;

    assign interm = {{W{in[W-1]}}, in};
    assign out = interm <<< sh;

endmodule
