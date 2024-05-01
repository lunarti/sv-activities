module ula #(
    parameter width = 4
) (
    input logic [width-1:0] a,b,
    input logic [2:0] ALUControl,
    output logic [width-1:0] result,
    output logic overflow,
    output logic carry,
    output logic negative,
    output logic zero
);

logic [width-1:0] condinvb;
logic [width:0] sum;
logic [2*width:0] product;

assign condinvb = ALUControl[0] ? -b : b;
assign sum = a + condinvb;

always_comb begin
    case (ALUControl[2:0])
        3'b000: begin // Sum
            result = sum;
            carry = (sum[width] == 1'b1);
            overflow = ((a > 0 && b > 0 && a + b < 0) || (a < 0 && b < 0 && a + b >= 0));
            // overflow = (a[width-1] == b[width-1] && a[width-1] != sum[width-1]);
            negative = sum[width-1];
            zero = (sum == 0);
        end
        3'b001: begin // Subtract
            result = sum;
            carry = (sum[width] == 1'b0);
            overflow = ((a > 0 && condinvb < 0 && a - condinvb < 0) || (a < 0 && condinvb > 0 && a - condinvb >= 0));
            // overflow = (a[width-1] != condinvb[width-1] && a[width-1] != sum[width-1]);
            negative = sum[width-1];
            zero = (sum == 0);
        end
        3'b010: begin // And
            result = a & b;
            negative = result[width-1];
            zero = (result == zero);
            carry = 1'b0;
            overflow = 1'b0;
        end
        3'b011: begin //Or
            result = a | b;
            negative = result[width-1];
            zero = (result == zero);
            carry = 1'b0;
            overflow = 1'b0;
        end
        3'b100: begin // Divide
            result = a / b;
            negative = result[width-1];
            zero = (result == 0);
            carry = 1'b0;
            overflow = (b == 0);
        end
        3'b101: begin // Multiply
            product = a*b;
            result = product[width-1:0];
            negative = result[width-1];
            zero = (result == 0);
            carry = (product[2*width-1:width] != 0); // Check upper bits for carry
            overflow = (product[2*width-1:width] != {width{product[width-1]}}); // Check upper bits for overflow
        end
        3'b110: begin // Shift Left
            result = a << b; // Shift left by 'b' positions
            carry = a[width-1-b]; // Carry out is the 'b'th bit from the left
            overflow = 1'b0; // Shift left does not cause overflow
            negative = result[width-1]; // Sign of the result after shifting
            zero = (result == 0); // Check if the result is zero
        end
        3'b111: begin // Shift Right
            result = a >> b; // Shift right by 'b' positions
            carry = a[b-1]; // Carry out is the 'b'th bit from the right
            overflow = 1'b0; // Shift right does not cause overflow
            negative = result[width-1]; // Sign of the result after shifting
            zero = (result == 0); // Check if the result is zero
        end
    endcase
end
endmodule
