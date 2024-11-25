module decoder(input [1:0] i, output [3:0] o);
    wire a,b;

    // getting the complement of each bit in input
    not (a,i[1]);
    not (b,i[0]);

    //writing product terms using AND gates
    and (o[0],a,b);
    and (o[1],a,i[0]);
    and (o[2],i[1],b);
    and (o[3],i[1],i[0]);
endmodule

