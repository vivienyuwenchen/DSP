//------------------------------------------------------------------------
// ALU Module
//------------------------------------------------------------------------

`define ADD  3'd0
`define SUB  3'd1
`define Xor  3'd2
`define SLT  3'd3
`define And  3'd4
`define Nand 3'd5
`define Nor  3'd6
`define Or   3'd7
`include "alu_function.v"
`define NOR32 nor  //32 input NOR

module ALU
(
output[31:0]  result,
output        carryout,
output        zero,
output        overflow,
input[31:0]   operandA,
input[31:0]   operandB,
input[2:0]    command
);
  //declare wires
	wire[31:0] out0, out1, out2, out3, out4;
	wire 			 cout0, cout1, cout2, cout3, cout4;
	wire 			 over0, over1, over2, over3, over4;
	wire 			 invert;
	wire[2:0]  muxindex;
	wire[32:0] carryin0;

  //use LUT to get variable assignments for muxindex and invert depending on the input command
	ALUcontrolLUT lut(.muxindex(muxindex), .invert(invert), .ALUcommand(command));
  //first carryin of add-subtract module is identical to the invert signal
	assign carryin0[0] = invert;

  //bit slice approach, generate 32 of each module for full capability
	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin
			AddSubN adder(.sum(out0[i]), .carryout(carryin0[i+1]), .a(operandA[i]), .b(operandB[i]), .carryin(carryin0[i]), .subtract(invert));

			XORmod xorer(.out(out1[i]), .carryout(cout1), .overflow(over1), .a(operandA[i]), .b(operandB[i]));

			NANDmod nander(.out(out3[i]), .carryout(cout3), .overflow(over3), .a(operandA[i]), .b(operandB[i]), .invert(invert));

			NORmod norer(.out(out4[i]), .carryout(cout4), .overflow(over4), .a(operandA[i]), .b(operandB[i]), .invert(invert));
  end
	endgenerate

	SLTmod slter (.slt(out2), .carryout(cout2), .overflow(over2), .a(operandA), .b(operandB));

	//set carryout for adder, equivalent to the "carryin" of the 33rd bit
  assign cout0 = carryin0[32];
	//calculate overflow for adder; overflow if final carryout is not equal to carryin of most significant bit
	`XOR OVERFLOW(over0, cout0, carryin0[31]);

  //mux between generated outputs depending on muxindex given by ALUcommand
	genvar n;
	generate for (n = 0; n < 32; n = n + 1) begin
			structuralMultiplexer5 resultmux (.out(result[n]), .command(muxindex), .in0(out0[n]), .in1(out1[n]), .in2(out2[n]), .in3(out3[n]), .in4(out4[n]));
  end
	endgenerate

	//mux between carryouts
	structuralMultiplexer5 coutmux (.out(carryout), .command(muxindex), .in0(cout0), .in1(cout1), .in2(cout2), .in3(cout3), .in4(cout4));
	//mux between overflows
	structuralMultiplexer5 overmux (.out(overflow), .command(muxindex), .in0(over0), .in1(over1), .in2(over2), .in3(over3), .in4(over4));

  //if all bits of the result are zero, the output zero should return zero
	`NOR32 norgate(zero, result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10],
		result[11], result[12], result[13], result[14], result[15], result[16], result[17], result[18], result[19], result[20], result[21], result[22],
		result[23], result[24], result[25], result[26], result[27], result[28], result[29], result[30], result[31]);

endmodule


module ALUcontrolLUT
(
output reg[2:0] muxindex,
output reg	invert,
input[2:0]	ALUcommand
);
  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD:  begin muxindex = 0; invert=0; end
      `SUB:  begin muxindex = 0; invert=1; end
      `Xor:  begin muxindex = 1; invert=0; end
      `SLT:  begin muxindex = 2; invert=0; end
      `Nand: begin muxindex = 3; invert=0; end
      `And:  begin muxindex = 3; invert=1; end
      `Nor:  begin muxindex = 4; invert=0; end
      `Or:   begin muxindex = 4; invert=1; end
    endcase
  end
endmodule
