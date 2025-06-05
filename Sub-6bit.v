module full_subtractor (input A, B, Bin, output D, Bout);
    assign D = A ^ B ^ Bin;
    assign Bout = (~A & B) | (Bin & (~(A ^ B)));
endmodule

module ripple_borrow_subtractor_6bit (
    input [5:0] A, B,
    input Bin,
    output [5:0] D,
    output Bout
);
    wire B1, B2, B3, B4, B5;

    full_subtractor FS0 (A[0], B[0], Bin,  D[0], B1);
    full_subtractor FS1 (A[1], B[1], B1,   D[1], B2);
    full_subtractor FS2 (A[2], B[2], B2,   D[2], B3);
    full_subtractor FS3 (A[3], B[3], B3,   D[3], B4);
    full_subtractor FS4 (A[4], B[4], B4,   D[4], B5);
    full_subtractor FS5 (A[5], B[5], B5,   D[5], Bout);
endmodule
