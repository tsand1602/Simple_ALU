module RCA4(input [3:0] A,input [3:0] B,input in, output out, output [3:0] sum);
    wire [2:0] c;

    full_adder add1(c[0],sum[0],A[0],B[0],in);
    full_adder add2(c[1],sum[1],A[1],B[1],c[0]);
    full_adder add3(c[2],sum[2],A[2],B[2],c[1]);
    full_adder add4(cout,sum[3],A[3],B[3],c[2]);
endmodule

module full_adder(output cout, output s, input x,input y,input cin);
    wire w1,w2,w3;

    half_adder a1(w2,w1,x,y);
    half_adder a2(w3,s,w1,cin);

    or (cout,w2,w3);
endmodule

module half_adder(output cout, output s, input x, input y);
    xor (s,x,y);
    and (cout,x,y);
endmodule