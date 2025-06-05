module half_adder (input x,y, output c,s);
    xor (s,x,y);
    and (c,x,y);
endmodule

module full_adder (input x,y,cin, output cout,s);
    wire [2:0] w;

    xor (s,x,y,cin);

    and (w[0],x,y);
    and (w[1],x,cin);
    and (w[2],y,cin);

    or (cout,w[0],w[1],w[2]);
endmodule

module CLA4 (input [3:0] A,input [3:0] B,input carry_in, output carry_out, output [3:0] sum);
    wire [3:0] c;

    wire [3:0] p;
    wire [3:0] g;
    wire t1,t2,t3,t4,w1,w2,w3,w4,w5,w6;

    or (p[0],A[0],B[0]);
    or (p[1],A[1],B[1]);
    or (p[2],A[2],B[2]);
    or (p[3],A[3],B[3]);

    and (g[0],A[0],B[0]);
    and (g[1],A[1],B[1]);
    and (g[2],A[2],B[2]);
    and (g[3],A[3],B[3]);

    and (c[0],carry_in,1'b1);

    and (t1,p[0],c[0]);
    or (c[1],g[0],t1);

    and (t2,p[1],g[0]);
    and (w1,p[0],p[1],c[0]);
    or (c[2],g[1],t2,w1);

    and (t3,p[2],g[1]);
    and (w2,p[2],p[1],g[0]);
    and (w3,p[2],p[1],p[0],c[0]);
    or (c[3],g[2],t3,w2,w3);

    and (t4,p[3],g[2]);
    and (w4,p[3],p[2],g[1]);
    and (w5,p[3],p[2],p[1],g[0]);
    and (w6,p[3],p[2],p[1],p[0],c[0]);
    or (carry_out,g[3],t4,w4,w5,w6);

    xor (sum[0],A[0],B[0],c[0]);
    xor (sum[1],A[1],B[1],c[1]);
    xor (sum[2],A[2],B[2],c[2]);
    xor (sum[3],A[3],B[3],c[3]);
endmodule

module wallace_tree_6(input [5:0] op1,op2, output [11:0] res);
    wire [35:0] p;
    wire [22:0] c;
    wire [22:0] s;

    wire f1_carry,f2_carry,f3_carry;

    and (p[0],op2[0],op1[0]);
    and (p[1],op2[0],op1[1]);
    and (p[2],op2[0],op1[2]);
    and (p[3],op2[0],op1[3]);
    and (p[4],op2[0],op1[4]);
    and (p[5],op2[0],op1[5]);

    and (p[6],op2[1],op1[0]);
    and (p[7],op2[1],op1[1]);
    and (p[8],op2[1],op1[2]);
    and (p[9],op2[1],op1[3]);
    and (p[10],op2[1],op1[4]);
    and (p[11],op2[1],op1[5]);

    and (p[12],op2[2],op1[0]);
    and (p[13],op2[2],op1[1]);
    and (p[14],op2[2],op1[2]);
    and (p[15],op2[2],op1[3]);
    and (p[16],op2[2],op1[4]);
    and (p[17],op2[2],op1[5]);

    and (p[18],op2[3],op1[0]);
    and (p[19],op2[3],op1[1]);
    and (p[20],op2[3],op1[2]);
    and (p[21],op2[3],op1[3]);
    and (p[22],op2[3],op1[4]);
    and (p[23],op2[3],op1[5]);

    and (p[24],op2[4],op1[0]);
    and (p[25],op2[4],op1[1]);
    and (p[26],op2[4],op1[2]);
    and (p[27],op2[4],op1[3]);
    and (p[28],op2[4],op1[4]);
    and (p[29],op2[4],op1[5]);

    and (p[30],op2[5],op1[0]);
    and (p[31],op2[5],op1[1]);
    and (p[32],op2[5],op1[2]);
    and (p[33],op2[5],op1[3]);
    and (p[34],op2[5],op1[4]);
    and (p[35],op2[5],op1[5]);

    and (res[0],p[0],1'b1);

    full_adder f1(p[23],p[28],p[33],c[0],s[0]);
    full_adder f2(p[17],p[22],p[27],c[1],s[1]);
    full_adder f3(p[11],p[16],p[21],c[2],s[2]);
    full_adder f4(p[5],p[10],p[15],c[3],s[3]);
    full_adder f5(p[4],p[9],p[14],c[4],s[4]);
    full_adder f6(p[3],p[8],p[13],c[5],s[5]);
    full_adder f7(p[20],p[25],p[30],c[8],s[8]);

    half_adder h1(p[2],p[7],c[6],s[6]);
    half_adder h2(p[26],p[31],c[7],s[7]);
    half_adder h3(p[19],p[24],c[9],s[9]);

    full_adder f8(p[29],p[34],c[0],c[10],s[10]);
    full_adder f9(s[1],p[32],c[2],c[11],s[11]);
    full_adder f10(s[2],c[8],s[7],c[12],s[12]);
    full_adder f11(s[3],s[8],c[4],c[13],s[13]);
    full_adder f12(s[4],c[5],s[9],c[14],s[14]);

    half_adder h4(s[0],c[1],c[15],s[15]);
    half_adder h5(s[5],p[18],c[16],s[16]);

    half_adder h6(p[35],c[10],c[17],s[17]);
    half_adder h7(s[10],c[15],c[18],s[18]);
    half_adder h8(s[15],c[11],c[19],s[19]);
    half_adder h9(s[13],c[14],c[20],s[20]);

    full_adder f13(s[11],c[7],c[12],c[21],s[21]);
    full_adder f14(s[12],c[3],c[13],c[22],s[22]);

    half_adder h10(p[1],p[6],f1_carry,res[1]);
    full_adder f15(s[6],p[12],f1_carry,f2_carry,res[2]);

    CLA4 add1({s[22],s[20],s[14],s[16]},{c[20],c[9],c[16],c[6]},f2_carry,f3_carry,res[6:3]);
    CLA4 add2({s[17],s[18],s[19],s[21]},{c[18],c[19],c[21],c[22]},f3_carry,res[11],res[10:7]);

endmodule
