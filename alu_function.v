//------------------------------------------------------------------------
// Supporting Files for ALU Module
//------------------------------------------------------------------------

`define AND and
`define AND4 and
`define OR or
`define XOR xor
`define NOT not
`define NAND nand
`define NOR nor
`define OR5 or

// Mux for 5 inputs for bit slices
// AND gates set to 0 anything not called with 5 bit input
module structuralMultiplexer5
(
    output out,
    input[2:0] command,
    input in0, in1, in2, in3, in4
);
    wire[2:0] ncommand;
    wire m0,m1,m2,m3,m4;

    `NOT invA(ncommand[0], command[0]);
    `NOT invB(ncommand[1], command[1]);
    `NOT invC(ncommand[2], command[2]);

    `AND4 andgateA(m0,in0,ncommand[0],ncommand[1], ncommand[2]);
    `AND4 andgateB(m1,in1,command[0],ncommand[1], ncommand[2]);
    `AND4 andgateC(m2,in2,ncommand[0],command[1], ncommand[2]);
    `AND4 andgateD(m3,in3,command[0],command[1], ncommand[2]);
    `AND4 andgateE(m4,in4,ncommand[0],ncommand[1], command[2]);

    `OR5 orgate(out,m0,m1,m2,m3,m4);
endmodule

// Implementation of full adder for bitslices. Called by AddSubN
module structuralFullAdder
(
    output sum, carryout,
    input a, b,
    input carryin
);
    wire axorb, ab, caxorb;

    xor AXORB(axorb, a, b);
    `AND AANDB(ab, a, b);
    xor SUM(sum, carryin, axorb);
    `AND CAXORB(caxorb, carryin, axorb);
    `OR  CARRYOUT(carryout, caxorb, ab);
endmodule

//Add/Sub for bitslices.
module AddSubN
(
    output sum,  // 2's complement sum of a and b
    output carryout,  // Carry out of the summation of a and b
    output overflow,  // True if the calculation resulted in an overflow
    input a,     // First operand in 2's complement format
    input b,      // Second operand in 2's complement format
    input carryin,
    input subtract
);
    wire atest, btest;
    wire bsub;
    // allows for subtraction
    `XOR subtest(bsub, b, subtract);

    structuralFullAdder adder (sum, carryout, a, bsub, carryin);
endmodule


// SLT for bitslices. Uses AddSubN as a subtractor to determine relative magnitude of a and b
module SLTmod #( parameter n = 31 )
(
    output[n:0] slt,
    output carryout,
    output overflow,
    input[n:0] a, b
);
    wire[n:0] sub;
    wire carryout0, over;
    wire subtract;

    wire[32:0] carryin0;

    assign subtract = 1'b1;
    assign carryin0[0] = subtract;

   	genvar i;
   	generate for (i = 0; i < 32; i = i + 1) begin
   			AddSubN adder(.sum(sub[i]), .carryout(carryin0[i+1]), .a(a[i]), .b(b[i]), .carryin(carryin0[i]), .subtract(subtract));
     end
   	endgenerate

    //calculate overflow for adder; overflow if final carryout is not equal to carryin of most significant bit
    //used only to calculate SLT, not actual overflow output
  	`XOR OVERFLOW(over, carryin0[32], carryin0[31]);
    // a larger than b if final bit of subraction if overflow != msb of subtraction
    // in case where both are 0, both inputs were equal so SLT = 0 anyway
    `XOR SLTXOR(slt[0], sub[n], over);

    assign slt[31:1] = 0;
    assign carryout = 0;
    assign overflow = 0;
endmodule


// XOR for bitslices. Carryout and overflow do not apply
module XORmod
(
    output out,
    output carryout,
    output overflow,
    input a, b
);
    `XOR xorgate(out, a, b);
    assign carryout = 0;
    assign overflow = 0;
endmodule


// NAND for bislices.
module NANDmod
(
    output out,
    output carryout,
    output overflow,
    input a, b,
    input invert    // if invert = 1 functions as an AND module
);
    wire interim_out;
    `NAND nandgate(interim_out, a, b);
    `XOR xorgate(out, interim_out, invert);     // Will invert NAND output if meant to function as AND module
    assign carryout = 0;
    assign overflow = 0;
endmodule


// NOR for bitslices.
module NORmod
(
    output out,
    output carryout,
    output overflow,
    input a, b,
    input invert    // if invert = 1 functions as an OR module
);
    wire interim_out;
    `NOR norgate(interim_out, a, b);
    `XOR xorgate(out, interim_out, invert); // Will invert NAND output if meant to function as OR module
    assign carryout = 0;
    assign overflow = 0;
endmodule
