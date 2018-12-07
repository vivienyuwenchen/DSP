//-----------------------------------------------------------------------------
// Barrel and Parallel Shifters
//-----------------------------------------------------------------------------

// Arithmetic left shift
// Zero-fills lower-order bits and sign-extends 16-bit data memory word to 32 bits
module barrel #( parameter W = 32 )
(
    input[15:0]    in,
    input[3:0]  sh,
    output[31:0] out
);

    wire[31:0] interm;

    assign interm = {{16{in[15]}}, in};
    assign out = interm <<< sh;

endmodule

// Left-shifts 32-bit accumulator by 0, 1, or 4 and places 16 bits into data RAM
module parallel #( parameter W = 32 )
(
    input[31:0]  in,
    input[2:0]   sh,
    output[15:0] out
);

    wire[31:0] interm;

    assign interm = in <<< sh;
    assign out = interm[31:16];

endmodule
