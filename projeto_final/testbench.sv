// `timescale 10ns/1ns

module testbench();
    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr;
    logic MemWrite;
    logic [31:0] PC;         
    logic [31:0] Instr;
    logic [31:0] ALUResult;
    logic [31:0] Result;
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [31:0] ReadData;
    logic [3:0] ALUFlags;

// instantiate device to be tested
top dut(clk, reset, WriteData, DataAdr, MemWrite, PC, Instr, ALUResult, Result, SrcA, SrcB, ReadData, ALUFlags);

// initialize test
initial
    begin
    reset <= 1; # 5; reset <= 0;
    end

// generate clock to sequence tests
always
    begin
    clk <= 1; # 5; clk <= 0; # 5;
    end


always @(posedge clk) begin
    $display("PC: %h | Instr: %h | WriteData: %h | MemWrite: %b | DataAdr: %h | ReadData: %h | ALUResult: %h |  Result: %h | SrcA: %h | SrcB: %h | ALUFlags: %b", PC, Instr, WriteData, MemWrite, DataAdr,ALUResult, Result,SrcA, SrcB, ReadData, ALUFlags);
end

endmodule