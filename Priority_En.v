module priority_encoder(input [3:0] i, output [1:0] o, output v);
    wire a,b,c,t1,t2;

    //getting the complement of last 3 bits in input
    not (a,i[0]);
    not (b,i[1]);
    not (c,i[2]);

    // getting product terms using AND gate
    and (t1,a,c);
    and (t2,a,i[1]);

    // writing logical expressions using sum of products using AND and OR gates
    and (o[1],a,b);
    or (o[0],t1,t2);
    or (v,i[0],i[1],i[2],i[3]);
endmodule