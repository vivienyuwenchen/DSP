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
    output reg tReg_ctrl,
    output reg pReg_ctrl,
    output reg accumReset_ctrl,
    output reg multInMux_ctrl,
    output reg [1:0] aluInMux_ctrl,
    output reg [2:0] accumInMux_ctrl,
    output reg arInMux_ctrl,
    output reg dataMux_ctrl,
    output reg dataRamIn_ctrl,
    output reg [1:0] pcInMux_ctrl,
  //  output reg ioExternalMux_ctrl,
    output reg [2:0] alu_ctrl
);

    always @(*) begin
        case(instruction)
            `opABS: begin //this is def wrong
                tReg_ctrl = 0;
                pReg_ctrl = 0;
                accumReset_ctrl = 0;
                multInMux_ctrl = 0;
                aluInMux_ctrl = 2'b00; //0
                accumInMux_ctrl = 2'b00; //d
                arInMux_ctrl = 0;
                dataMux_ctrl = 0;
                dataRamIn_ctrl = 1;
                pcInMux_ctrl = 2'b11;
                alu_ctrl = 3'b000;

            end
            `opAPAC: begin
              tReg_ctrl = 0;
              pReg_ctrl = 0;
              accumReset_ctrl = 0;
              multInMux_ctrl = 0;
              aluInMux_ctrl = 2'b01; //b
              accumInMux_ctrl = 2'b00; //a
              arInMux_ctrl = 0;
              dataMux_ctrl = 0;
              dataRamIn_ctrl = 0;
              pcInMux_ctrl = 2'b11;
              alu_ctrl = 3'b000; //addition

            end
            `opPAC: begin
              tReg_ctrl = 0;
              pReg_ctrl = 0;
              accumReset_ctrl = 0;
              multInMux_ctrl = 0;
              aluInMux_ctrl = 2'b00;
              accumInMux_ctrl = 2'b10; //c
              arInMux_ctrl = 0;
              dataMux_ctrl = 0;
              dataRamIn_ctrl = 0;
              pcInMux_ctrl = 2'b11;
              alu_ctrl = 2'b00;

            end
            `opSPAC: begin
              tReg_ctrl = 0;
              pReg_ctrl = 0;
              accumReset_ctrl = 0;
              multInMux_ctrl = 0;
              aluInMux_ctrl = 2'b01; //b
              accumInMux_ctrl = 2'b00; //a
              arInMux_ctrl = 0;
              dataMux_ctrl = 0;
              dataRamIn_ctrl = 0;
              pcInMux_ctrl = 2'b11;
              alu_ctrl = 3'b001; //subtract
            end
            `opZAC: begin
              tReg_ctrl = 0;
              pReg_ctrl = 0;
              accumReset_ctrl = 1;
              multInMux_ctrl = 0;
              aluInMux_ctrl = 0;
              accumInMux_ctrl = 0;
              arInMux_ctrl = 0;
              dataMux_ctrl = 0;
              dataRamIn_ctrl = 0;
              pcInMux_ctrl = 2'b11;
              alu_ctrl = 3'b000;



            end
            default: begin
                case(OP_dk)
                    `opADDH: begin
                        tReg_ctrl = 0;
                        pReg_ctrl = 0;
                        accumReset_ctrl = 0;
                        multInMux_ctrl = 0;
                        aluInMux_ctrl = 2'b00; //0
                        accumInMux_ctrl = 2'b11; //d
                        arInMux_ctrl = 1;
                        dataMux_ctrl = 0;
                        dataRamIn_ctrl = 0;
                        pcInMux_ctrl = 2'b11;
                        alu_ctrl = 3'b000;

                    end
                    `opADDS: begin
                        tReg_ctrl = 0;
                        pReg_ctrl = 0;
                        accumReset_ctrl = 0;
                        multInMux_ctrl = 0;
                        aluInMux_ctrl = 2'b00; //0
                        accumInMux_ctrl = 2'b01; //b
                        arInMux_ctrl = 1;
                        dataMux_ctrl = 0;
                        dataRamIn_ctrl = 0;
                        pcInMux_ctrl = 2'b11;
                        alu_ctrl = 3'b000;

                    end
                    `opAND: begin
                        tReg_ctrl = 0;
                        pReg_ctrl = 0;
                        accumReset_ctrl = 0;
                        multInMux_ctrl = 0;
                        aluInMux_ctrl = 2'b10; //3
                        accumInMux_ctrl = 2'b00; //a
                        arInMux_ctrl = 1;
                        dataMux_ctrl = 0;
                        dataRamIn_ctrl = 1;
                        pcInMux_ctrl = 2'b11;
                        alu_ctrl = 3'd4;


                    end
                    `opLACK: begin
                        tReg_ctrl = 0;
                        pReg_ctrl = 0;
                        accumReset_ctrl = 0;
                        multInMux_ctrl = 0;
                        aluInMux_ctrl = 2'b00; //b
                        accumInMux_ctrl = 2'b11; //d
                        arInMux_ctrl = 1;
                        dataMux_ctrl = 0;
                        dataRamIn_ctrl = 1;
                        pcInMux_ctrl = 2'b11;
                        alu_ctrl = 3'b000;

                    end
                    `opOR: begin

                    end
                    `opLDP: begin
                        tReg_ctrl = 1;
                        pReg_ctrl = 0;
                        accumReset_ctrl = 0;
                        multInMux_ctrl = 0;
                        aluInMux_ctrl = 2'b00;
                        accumInMux_ctrl = 2'b00;
                        arInMux_ctrl = 1;
                        dataMux_ctrl = 0;
                        dataRamIn_ctrl = 1;
                        pcInMux_ctrl = 2'b11;
                        alu_ctrl = 3'b000;

                    end
                    `opLT: begin
                        tReg_ctrl = 1;
                        pReg_ctrl = 0;
                        accumReset_ctrl = 0;
                        multInMux_ctrl = 0;
                        aluInMux_ctrl = 2'b01; //b
                        accumInMux_ctrl = 2'b00; //a
                        arInMux_ctrl = 1;
                        dataMux_ctrl = 0;
                        dataRamIn_ctrl = 1;
                        pcInMux_ctrl = 2'b11;
                        alu_ctrl = 3'b000;

                    end
                    `opLTA: begin
                        tReg_ctrl = 1;
                        pReg_ctrl = 1;
                        accumReset_ctrl = 0;
                        multInMux_ctrl = 0;
                        aluInMux_ctrl = 2'b01; //b
                        accumInMux_ctrl = 2'b00; //a
                        arInMux_ctrl = 1;
                        dataMux_ctrl = 0;
                        dataRamIn_ctrl = 1;
                        pcInMux_ctrl = 2'b11;
                        alu_ctrl = 3'b000;

                    end
                    `opMPY: begin
                        tReg_ctrl = 1;
                        pReg_ctrl = 1;
                        accumReset_ctrl = 0;
                        multInMux_ctrl = 00; //0
                        aluInMux_ctrl = 2'b00; //a
                        accumInMux_ctrl = 2'b00; //a
                        arInMux_ctrl = 1;
                        dataMux_ctrl = 0;
                        dataRamIn_ctrl = 1;
                        pcInMux_ctrl = 2'b11;
                        alu_ctrl = 3'b000;

                    end
                    default: begin
                        case(OP_s)
                            `opADD: begin
                            tReg_ctrl = 0;
                            pReg_ctrl = 0;
                            accumReset_ctrl = 0;
                            multInMux_ctrl = 0;
                            aluInMux_ctrl = 2'd3; //3
                            accumInMux_ctrl = 2'b00; //a
                            arInMux_ctrl = 0;
                            dataMux_ctrl = 0;
                            dataRamIn_ctrl = 1;
                            pcInMux_ctrl = 2'b11;
                            alu_ctrl = 3'd0;

                            end
                            `opLAC: begin
                              tReg_ctrl = 0;
                              pReg_ctrl = 0;
                              accumReset_ctrl = 0;
                              multInMux_ctrl = 0;
                              aluInMux_ctrl = 2'b00; //b
                              accumInMux_ctrl = 2'b11; //d
                              arInMux_ctrl = 0;
                              dataMux_ctrl = 0;
                              dataRamIn_ctrl = 0;
                              pcInMux_ctrl = 2'b11;
                              alu_ctrl = 3'b000;

                            end
                            `opSUB: begin
                                tReg_ctrl = 0;
                                pReg_ctrl = 0;
                                accumReset_ctrl = 0;
                                multInMux_ctrl = 0;
                                aluInMux_ctrl = 2'd3; //3
                                accumInMux_ctrl = 2'b00; //a
                                arInMux_ctrl = 0;
                                dataMux_ctrl = 0;
                                dataRamIn_ctrl = 1;
                                pcInMux_ctrl = 2'b11;
                                alu_ctrl = 3'd1;

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
