module mux4(output o,input [3:0] i,input [1:0] s);
    wire t1,t2,w1,w2,w3,w4;

    not (t1,s[0]);
    not (t2,s[1]);

    and (w1,t1,t2,i[0]);
    and (w2,s[0],t2,i[1]);
    and (w3,t1,s[1],i[2]);
    and (w4,s[0],s[1],i[3]);

    or (o,w1,w2,w3,w4);
endmodule