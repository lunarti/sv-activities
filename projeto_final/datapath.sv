module datapath(    input logic clk, reset,
                    input logic [1:0] RegSrc,
                    input logic RegWrite,
                    input logic [1:0] ImmSrc,
                    input logic ALUSrc,
                    input logic [2:0] ALUControl,
                    input logic MemtoReg,
                    input logic PCSrc,
                    output logic [3:0] ALUFlags,
                    output logic [31:0] PC,
                    input logic [31:0] Instr,
                    output logic [31:0] newALUResult, ALUResult, Result, WriteData,
                    input logic [31:0] ReadData,
                    output logic [31:0] SrcA, SrcB,
                    input logic Shift);


logic [31:0] PCNext, PCPlus4, PCPlus8;
logic [31:0] ExtImm;
logic [3:0] RA1, RA2;
logic [31:0] shiftRD2;

// next PC logic
mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
flopr #(32) pcreg(clk, reset, PCNext, PC);
adder #(32) pcadd1(PC, 32'b100, PCPlus4);
adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

// register file logic
mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
regfile rf(clk, RegWrite, RA1, RA2, Instr[15:12], Result, PCPlus8, SrcA, WriteData);
mux2 #(32) resmux(newALUResult, ReadData, MemtoReg, Result);
extend ext(Instr[23:0], ImmSrc, ExtImm);

// ALU logic
shift #(32) shift_rd2(WriteData, Instr[11:5], shiftRD2);
mux2 #(32) srcbmux(shiftRD2, ExtImm, ALUSrc, SrcB);
alu alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
mux2 #(32) shift_alu(ALUResult, SrcB, Shift, newALUResult);
endmodule