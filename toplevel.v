//------------------------------------------------------------------------
// DSP Recreated from TMS32010 User Guide
//------------------------------------------------------------------------

`include "multiplier.v"
`include "accumulator.v"
`include "shifters.v"
`include "alu.v"
`include "muxes.v"
`include "dff.v"

module dsp
(
    input clk
);

    dff #(16) T(.clk(clk),
                    .enable(1'b1),
                    .d(dataBus),
                    .q(tOut));

    multiplier #(16) Multiplier(.a(tOut),
                    .b(multInMuxOut),
                    .out(product));

    dff #(32) P(.clk(clk),
                    .enable(1'b1),
                    .d(product),
                    .q(pOut));

    barrel #(16) ALUShifter(.in(dataBus),
                    .sh(aluShifter_ctrl),
			        .out(aluShiftOut));

    mux4 #(32) ALUInMUX(.in0(aluShiftOut),
                    .in1(pOut),
                    .in2(dataBus_SE),
                    .in3(in3),              // unused
                    .sel(aluInMux_ctrl),
                    .out(aluInMuxOut));

    ALU ALU(.carryout(carryout),
                    .zero(zero),
                    .overflow(overflow),
                    .result(aluOut),
                    .operandA(aluInMuxOut),
                    .operandB(accumOut),
                    .command(alu_ctrl));

    mux8 #(32) AccumInMUX(.in0(aluOut),
                    .in1(aluShiftOut),
                    .in2(pOut),
                    .in3(dataBus_SE),       // come back later
                    .in4(romOut_SE),
                    .in5(stack_SE),
                    .in6(in6),              // unused
                    .in7(in7),              // unused
                    .sel(accumInMux_ctrl),
                    .out(accumInMuxOut));

    accumulator #(32) Accumulator(.clk(clk),
                    .reset(1'b0),
                    .in(accumInMuxOut),
                    .out(accumOut));

    parallel #(32) AccumShifter(.in(accumOut),
                    .sh(accumShifter_ctrl),
			        .out(accumShiftOut));

endmodule
