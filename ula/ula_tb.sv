`timescale 10ns/1ns

module ula_tb;

    parameter ULA_BITS = 4;
    parameter VECTOR_LINES = 16;

    logic [ULA_BITS*3+2:0] vector[VECTOR_LINES:0];
    logic [ULA_BITS-1:0] a, b, result, result_esp;
    logic [2:0] ALUControl;
    logic z,c,v,n,hs,ls,hi,lo;
    int i;
    int failed_i[$];

    ula #(ULA_BITS) DUT1(
        .a(a),
        .b(b),
        .ALUControl(ALUControl),
        .result(result),
        .zero(z),
        .carry(c),
        .overflow(v),
        .negative(n)
    );

    comparator #(ULA_BITS) DUT2(
        .zero(z),
        .carry(c),
        .hs(hs),
        .ls(ls),
        .hi(hi),
        .lo(lo)
    );

    initial begin
        string vectorfile;
        vectorfile = $sformatf("vector%0dbits", ULA_BITS);
        $display("vector file: %s", vectorfile);
        $readmemb(vectorfile, vector);
        i = 0;
    end

    always begin
        {a, b, ALUControl, result_esp} = vector[i]; #1

        $display("a %b, b %b, ALUControl %b, y_esp %b, z %b, c %b, v %b, n %b", a,b,ALUControl,result_esp,z,c,v,n);
        if (result!=result_esp) begin
            failed_i.push_back(i);
        end
        i = i + 1;
        if (i >= VECTOR_LINES) begin
            if (failed_i.size() != 0) begin
                $display("Failed vector:");
                foreach (failed_i[j]) begin
                    $display("Index %0d", failed_i[j]);
                end
            end else begin
                $display("Tests are successful");
            end
            $stop;
        end
    end

endmodule
