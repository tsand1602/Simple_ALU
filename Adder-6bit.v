module RCA6(
    input  [5:0] A,
    input  [5:0] B,
    input        in,        
    output       out,       
    output [5:0] sum
);
    wire c1, c2, c3, c4, c5;

    full_adder fa0(A[0], B[0], in,   c1, sum[0]);
    full_adder fa1(A[1], B[1], c1,   c2, sum[1]);
    full_adder fa2(A[2], B[2], c2,   c3, sum[2]);
    full_adder fa3(A[3], B[3], c3,   c4, sum[3]);
    full_adder fa4(A[4], B[4], c4,   c5, sum[4]);
    full_adder fa5(A[5], B[5], c5,   out, sum[5]);
endmodule
