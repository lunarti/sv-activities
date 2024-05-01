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
logic [2*width-1:0] product;

assign condinvb = ALUControl[0] ? -b : b;
assign sum = a + condinvb;

always_comb begin
    case (ALUControl[2:0])
        3'b000: begin // Sum
            result = sum;
            carry = (sum[width] == 1'b1);
            // overflow = ((a > 0 && b > 0 && a + b < 0) || (a < 0 && b < 0 && a + b >= 0));
            overflow = (a[width-1] == b[width-1]) && (a[width-1] != sum[width-1]);
            negative = sum[width-1];
            zero = (sum == 0);
        end
        3'b001: begin // Subtract
            result = sum;
            carry = (sum[width] == 1'b0);
            // overflow = ((a > 0 && condinvb < 0 && a - condinvb < 0) || (a < 0 && condinvb > 0 && a + condinvb >= 0));
            overflow = (a[width-1] != b[width-1]) && (a[width-1] != sum[width-1]);
            negative = sum[width-1];
            zero = (sum == 0);
        end
        3'b010: begin // And
            result = a & b;
            negative = result[width-1];
            zero = (result == 0);
            carry = 1'b0;
            overflow = 1'b0;
        end
        3'b011: begin //Or
            result = a | b;
            negative = result[width-1];
            zero = (result == 0);
            carry = 1'b0;
            overflow = 1'b0;
        end
        3'b100: begin // Divide
            if (b != 0) begin
                result = a / b;
                negative = result[width-1];
                zero = (result == 0);
                carry = 1'b0;
                overflow = 1'b0;
            end else begin
                // Handle division by zero
                result = 'bx;
                negative = 1'b0;
                zero = 1'b0;
                carry = 1'b0;
                overflow = 1'b1;
            end
        end
        3'b101: begin // Multiply
            product = a * b;
            result = product[width-1:0];
            negative = result[width-1];
            zero = (result == 0);
            carry = (product[2*width-1:width] != 0);
            overflow = (product[2*width-1:width] != {{width{product[width-1]}}});
        end
        3'b110: begin // Shift Left
            result = a << b;
            carry = a[width-1-b];
            overflow = 1'b0;
            negative = result[width-1];
            zero = (result == 0);
        end
        3'b111: begin // Shift Right
            result = a >> b;
            carry = a[b-1];
            overflow = 1'b0;
            negative = result[width-1];
            zero = (result == 0);
        end
    endcase
end
endmodule
