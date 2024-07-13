module top( input logic clk, reset,
            output logic [31:0] WriteData, DataAdr,
            output logic MemWrite,
            output logic [31:0] PC,
            output logic [31:0] Instr,
            output logic [31:0] ALUResult, Result, SrcA, SrcB, ReadData,
            output logic [3:0] ALUFlags);

// instantiate processor and memories
logic [31:0] shiftedALUResult;
arm arm(clk, reset, PC, Instr, MemWrite, shiftedALUResult, ALUResult, Result, WriteData, SrcA, SrcB, ReadData, ALUFlags);
imem imem(PC, Instr);
dmem dmem(clk, MemWrite, shiftedALUResult, WriteData, ReadData);
assign DataAdr = shiftedALUResult;
endmodule