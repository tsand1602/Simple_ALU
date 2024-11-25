module demux_4(output [3:0] o,input i,input [1:0]s);
    wire n1,n2;

    not (n1,s[0]);
    not (n2,s[1]);

    and (o[0],i,n1,n2);
    and (o[1],i,s[0],n2);
    and (o[2],i,n1,s[1]);
    and (o[3],i,s[0],s[1]);
endmodule