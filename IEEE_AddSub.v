module full_subtractor (input A, B, Bin,output D, Bout);
   assign D=A^B^Bin;
   assign Bout= (~A&B)+(Bin&(~(A^B)));

endmodule

module ripple_borrow_subtractor_8bit (input [7:0] A, B,input Bin, output [7:0] D,output Bout);
    wire B1,B2,B3,B4,B5,B6,B7;

    full_subtractor FS0 (A[0],B[0],Bin,D[0],B1);
    full_subtractor FS1 (A[1],B[1],B1,D[1],B2);
    full_subtractor FS2 (A[2],B[2],B2,D[2],B3);
    full_subtractor FS3 (A[3],B[3],B3,D[3],B4);
    full_subtractor FS4 (A[4],B[4],B4,D[4],B5);
    full_subtractor FS5 (A[5],B[5],B5,D[5],B6);
    full_subtractor FS6 (A[6],B[6],B6,D[6],B7);
    full_subtractor FS7 (A[7],B[7],B7,D[7],Bout);

endmodule

module FloatingPointAddition (
    input [31:0] a_operand,
    input [31:0] b_operand,
    output reg Exception,
    output reg [31:0] result
);
    reg sign_a, sign_b, sign_result;
    reg [7:0] exp_a, exp_b, exp_result;
    reg [23:0] mantissa_a, mantissa_b, mantissa_result;
    reg [24:0] aligned_mantissa_a, aligned_mantissa_b, mantissa_sum;
    wire [7:0] exp_diff;
    wire borrow_out;

    ripple_borrow_subtractor_8bit exp_subtractor (
        .A(exp_a),
        .B(exp_b),
        .Bin(1'b0),
        .D(exp_diff),
        .Bout(borrow_out)
    );

    function [23:0] shift_right;
        input [23:0] value;
        input [7:0] shift_amount;
        integer i;
        begin
            shift_right = value;
            for (i = 0; i < shift_amount; i = i + 1) begin
                shift_right = {1'b0, shift_right[23:1]};
            end
        end
    endfunction

    always @(*) begin
        sign_a = a_operand[31];
        sign_b = b_operand[31];
        exp_a = a_operand[30:23];
        exp_b = b_operand[30:23];
        mantissa_a = {1'b1, a_operand[22:0]};
        mantissa_b = {1'b1, b_operand[22:0]};
        Exception = 1'b0;
        result = 32'h0;

        if ((exp_a == 8'hFF && mantissa_a[22:0] == 0) || (exp_b == 8'hFF && mantissa_b[22:0] == 0)) begin
            result = (exp_a == 8'hFF) ? a_operand : b_operand;
            Exception = 1'b1;
        end 
        else if ((exp_a == 8'hFF) || (exp_b == 8'hFF) || 
                 (mantissa_a[22:0] != 0 && exp_a == 8'hFF) || 
                 (mantissa_b[22:0] != 0 && exp_b == 8'hFF)) begin
            Exception = 1'b1; 
            result = 32'h7FC00000;
        end 
        else begin
            if (exp_a > exp_b) begin
                aligned_mantissa_b = shift_right(mantissa_b, exp_diff);
                aligned_mantissa_a = mantissa_a;
                exp_result = exp_a;
            end 
            else begin
                aligned_mantissa_a = shift_right(mantissa_a, exp_diff);
                aligned_mantissa_b = mantissa_b;
                exp_result = exp_b;
            end

            if (sign_a == sign_b) begin
                mantissa_sum = aligned_mantissa_a + aligned_mantissa_b;
                sign_result = sign_a;
                if (mantissa_sum[24]) begin
                    mantissa_result = shift_right(mantissa_sum, 1);
                    exp_result = exp_result + 1;
                end 
                else begin
                    mantissa_result = mantissa_sum;
                end
            end 
            else begin
                if (aligned_mantissa_a >= aligned_mantissa_b) begin
                    mantissa_sum = aligned_mantissa_a - aligned_mantissa_b;
                    sign_result = sign_a;
                end 
                else begin
                    mantissa_sum = aligned_mantissa_b - aligned_mantissa_a;
                    sign_result = sign_b;
                end
                if (mantissa_sum[24]) begin
                    mantissa_result = shift_right(mantissa_sum, 1);
                    exp_result = exp_result + 1;
                end 
                else begin
                    mantissa_result = mantissa_sum;
                end
            end

            result = {sign_result, exp_result, mantissa_result[22:0]};
        end
    end
endmodule
