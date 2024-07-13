module shift #(parameter WIDTH = 32)
    (input logic [WIDTH-1:0] inputData,
     input logic [11:5] Instr,
     output logic [WIDTH-1:0] outputData);

    logic [WIDTH-1:0] shift_reg;

    always_comb begin
        if (Instr[6:5] == 2'b00) begin
            shift_reg = inputData << Instr[11:7];
        end else if (Instr[6:5] == 2'b01) begin
            shift_reg = inputData >> Instr[11:7];
        end else begin
            shift_reg = inputData;
        end
    end

    assign outputData = shift_reg;
endmodule