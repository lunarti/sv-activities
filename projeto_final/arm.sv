module arm( input logic clk, reset,
            output logic [31:0] PC,
            input logic [31:0] Instr,
            output logic MemWrite,
            output logic [31:0] newALUResult, ALUResult, Result, WriteData, SrcA, SrcB,
            input logic [31:0] ReadData,
            output logic [3:0] ALUFlags);

logic RegWrite, ALUSrc, MemtoReg, PCSrc, NoWrite, Shift;
logic [1:0] RegSrc, ImmSrc;
logic [2:0] ALUControl;

controller c(clk, reset, Instr[31:12], ALUFlags,
            RegSrc, RegWrite, ImmSrc,
            ALUSrc, ALUControl,
            MemWrite, MemtoReg, PCSrc,
            NoWrite, Shift);

datapath dp(clk, reset, RegSrc, RegWrite, ImmSrc,
            ALUSrc, ALUControl,
            MemtoReg, PCSrc,
            ALUFlags, PC, Instr,
            newALUResult, ALUResult, Result, WriteData, ReadData,
            SrcA, SrcB, Shift);
endmodule