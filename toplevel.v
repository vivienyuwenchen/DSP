//------------------------------------------------------------------------
// DSP Recreated from TMS32010 User Guide
//------------------------------------------------------------------------

`include "multiplier.v"
`include "accumulator.v"
`include "shifters.v"
`include "alu.v"
`include "muxes.v"
`include "dff.v"
`include "instructionmemory.v"
`include "datamemory.v"
`include "decoder.v"

module dsp
(
    input clk
);

    wire [2:0] alu_ctrl, accumInMux_ctrl;
    wire [1:0] pcInMux_ctrl, aluInMux_ctrl, databus_ctrl;
    wire multInMux_ctrl, tReg_ctrl, pReg_ctrl, accumReset_ctrl, arInMux_ctrl, dataRamIn_ctrl, dataWrEn_ctrl;
    wire load_acc, abs_acc, enable_acc;
    wire [2:0] accumShifter_ctrl;                       // unused
    wire [7:0] OP_dk, K;
    wire [6:0] D;
    wire [3:0] OP_s, S;
    wire ARP, DP;
    wire [11:0] pcCount, pcPlus2, pcInMuxOut;
    wire [11:0] instructionPC, dataPC, stackOut;        // unused
    wire [15:0] instrMPYK_SE, accumOutLow;              // unused
    wire [15:0] instruction, dataBus, dataIn;
    wire [15:0] multInMuxOut, tOut, arIn, accumShiftOut, dataOut;
    wire [31:0] product, pOut, aluShiftOut, aluInMuxOut, aluOut, accumOut, accumInMuxOut;
    wire [7:0] arOut, dpOut, dataAddr;
    wire [31:0] data0Padded, dk0Padded, stack0Padded;   // unused
    wire carryout, zero, overflow;                      // unused
    wire [31:0] in3, in6, in7;

    assign instructionPC = instruction[11:0];   // unused
    assign dataPC = dataBus[11:0];              // unused

    mux4 #(12) PCInMux(.in0(instructionPC), // unused
                    .in1(stackOut),         // unused
                    .in2(dataPC),           // unused
                    .in3(pcPlus2),
                    .sel(pcInMux_ctrl),
                    .out(pcInMuxOut));

    dff #(12) PC(.clk(clk),
                    .enable(1'b1),
                    .d(pcInMuxOut),
                    .q(pcCount));

    assign pcPlus2 = pcCount + 12'h002;

    instrmem InstrMem(.clk(clk),
                    .addr(pcCount),
                    .instr(instruction));

    instructiondecoder InstrDec(.OP_dk(OP_dk),
                    .OP_s(OP_s),
                    .S(S),
                    .D(D),
                    .K(K),
                    .ARP(ARP),
                    .instruction(instruction));

    mux2 #(16) MultInMUX(.in0(dataBus),
                    .in1(instrMPYK_SE),       // unused, instrMPYK_SE = {3{1'b0}, instrMPYK}
                    .sel(multInMux_ctrl),
                    .out(multInMuxOut));

    dff #(16) T(.clk(clk),
                    .enable(tReg_ctrl),
                    .d(dataBus),
                    .q(tOut));

    multiplier #(16) Multiplier(.a(tOut),
                    .b(multInMuxOut),
                    .out(product));

    dff #(32) P(.clk(clk),
                    .enable(pReg_ctrl),
                    .d(product),
                    .q(pOut));

    barrel #(16) ALUShifter(.in(dataBus),
                    .sh(S),
			        .out(aluShiftOut));

    assign data0Padded = {{16{1'b0}}, dataBus};

    mux4 #(32) ALUInMUX(.in0(aluShiftOut),
                    .in1(pOut),
                    .in2(data0Padded),
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

    assign dk0Padded = {{24{1'b0}}, OP_dk};
    assign stack0Padded = {{20{1'b0}}, stackOut};

    mux8 #(32) AccumInMUX(.in0(aluOut),
                    .in1(aluShiftOut),
                    .in2(pOut),
                    .in3(data0Padded),
                    .in4(dk0Padded),
                    .in5(stack0Padded),     // unused
                    .in6(in6),              // unused
                    .in7(in7),              // unused
                    .sel(accumInMux_ctrl),
                    .out(accumInMuxOut));

    accumulator #(32) Accumulator(.clk(clk),
                    .reset(accumReset_ctrl),
                    .load(load_acc),
                    .abs(abs_acc),
                    .en(enable_acc),
                    .in(accumInMuxOut),
                    .out(accumOut));

    parallel #(32) AccumShifter(.in(accumOut),
                    .sh(accumShifter_ctrl),         // unused
			        .out(accumShiftOut));

    mux2 #(16) ARInMux(.in0(dataBus),
                    .in1(instruction),
                    .sel(arInMux_ctrl),
                    .out(arIn));

    auxreg #(16) AR(.clk(clk),
                    .ARP(ARP),
                    .in(arIn),
                    .out(arOut));

    assign DP = D[0];
    assign dpOut = {DP, D};             // check order

    mux2 #(8) DataRamInMux(.in0(arOut),
                    .in1(dpOut),
                    .sel(dataRamIn_ctrl),
                    .out(dataAddr));

    datamem DataMem(.clk(clk),
                    .en(dataWrEn_ctrl),
                    .addr(dataAddr),
                    .in(dataBus),
                    .out(dataOut));

    assign accumOutLow = accumOut[15:0];    // unused

    mux4 #(16) DataBusMux(.in0(instruction),
                    .in1(dataOut),
                    .in2(accumShiftOut),
                    .in3(accumOutLow),      // unused
                    .sel(databus_ctrl),
                    .out(dataBus));

endmodule
