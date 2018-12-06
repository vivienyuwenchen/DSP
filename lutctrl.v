//------------------------------------------------------------------------
// Look Up Table for Control Wires
//------------------------------------------------------------------------

`define opABS   16'b0111111110001000
`define opADD   4'b0000
`define opADDH  8'b01100000
`define opADDS  8'b01100001
`define opAND   8'b01111001
`define opLAC   4'b0010
`define opLACK  8'b01111110
`define opOR    8'b01111010
`define opSUB   4'b0001
`define opLDP   8'b01101111
`define opLT    8'b01101010
`define opLTA   8'b01101100
`define opAPAC  16'b0111111110001111
`define opPAC   16'b0111111110001110
`define opSPAC  16'b0111111110010000
`define opMPY   8'b01101101

module instructionLUT
(
    input [15:0] instruction,
    input [7:0] OP_dk,
    input [3:0] OP_s,
    output reg multInMux_ctrl,
    output reg [1:0] aluInMux_ctrl,
    output reg [2:0] accumInMux_ctrl,
    output reg arInMux_ctrl,
    output reg dataMux_ctrl,
    output reg dataRamIn_ctrl,
    output reg [1:0] pcInMux_ctrl,
    output reg ioExternalMux_ctrl,
    output reg [2:0] alu_ctrl
);

    always @(*) begin
        case(instruction)
            `opABS: begin

            end
            `opAPAC: begin

            end
            `opPAC: begin

            end
            `opSPAC: begin

            end
            default: begin
                case(OP_dk)
                    `opADDH: begin

                    end
                    `opADDS: begin

                    end
                    `opAND: begin

                    end
                    `opLACK: begin

                    end
                    `opOR: begin

                    end
                    `opLDP: begin

                    end
                    `opLT: begin

                    end
                    `opLTA: begin

                    end
                    `opMPY: begin

                    end
                    default: begin
                        case(OP_s)
                            `opADD: begin
                                accumInMux_ctrl = 011;
                                alu_ctrl = 000;

                            end
                            `opLAC: begin

                            end
                            `opSUB: begin

                            end
                            default: begin

                            end // default
                        endcase // case(OP_s: 4bit)
                    end // default
                endcase // case(OP_dk: 8bit)
            end // default
        endcase // case(instruction: 16bit)
    end // always
endmodule
