module half_adder(input a, input b, output s, output c);
    xor (s, a, b);
    and (c, a, b);
endmodule

module full_adder(input a, input b, input c0, output s, output c1);
    wire s0, c2, c3;
    half_adder h1(a, b, s0, c2);
    half_adder h2(s0, c0, s, c3);
    or(c1, c2, c3);
endmodule

module RCA6(
    input [5:0] A,
    input [5:0] B,
    input in,
    output out,
    output [5:0] sum
);
    wire [4:0] c;

    full_adder add0(A[0], B[0], in, sum[0], c[0]);
    full_adder add1(A[1], B[1], c[0], sum[1], c[1]);
    full_adder add2(A[2], B[2], c[1], sum[2], c[2]);
    full_adder add3(A[3], B[3], c[2], sum[3], c[3]);
    full_adder add4(A[4], B[4], c[3], sum[4], c[4]);
    full_adder add5(A[5], B[5], c[4], sum[5], out);
endmodule
