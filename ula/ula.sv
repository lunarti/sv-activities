module ula #(
    parameter width = 4
) (
    input logic [width-1:0] a,b,
    input logic [1:0] ALUControl,
    output logic [width-1:0] result,
    output logic overflow,
    output logic carry,
    output logic negative,
    output logic zero
);

logic [width-1:0] condinvb;
logic [width:0] sum;

assign condinvb = ALUControl[0] ? -b : b;
assign sum = a + condinvb;

always_comb begin
    case (ALUControl[1:0])
        2'b00: begin
            result = sum;
            carry = (sum[width] == 1'b1);
            overflow = (a[width-1] == b[width-1] && a[width-1] != sum[width-1]);
            negative = sum[width-1];
            zero = (sum == 0);
        end
        2'b01: begin
            result = sum;
            carry = (sum[width] == 1'b0);
            overflow = (a[width-1] != b[width-1] && a[width-1] != sum[width-1]);
            negative = sum[width-1];
            zero = (sum == 0);
        end
        2'b10: begin 
            result = a & b;
            negative = result[width-1];
            zero = (result == zero);
            carry = 1'b0;
            overflow = 1'b0;
        end
        2'b11: begin 
            result = a | b;
            negative = result[width-1];
            zero = (result == zero);
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end
endmodule
