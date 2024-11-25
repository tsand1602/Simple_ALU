module floating_point_mult (
    input [31:0] a, 
    input [31:0] b, 
    output [31:0] product,
    output exception, 
    output overflow, 
    output underflow
);

wire sign_bit, product_rounded, is_normalized, is_zero;
wire [8:0] exp_final, exp_sum;
wire [22:0] mantissa_product;
wire [23:0] sig_a, sig_b;
wire [47:0] mult_result, normalized_product, exception_flags;

assign sign_bit = a[31] ^ b[31];

assign exception_flags = (&a[30:23]) | (&b[30:23]) | (&(!a[30:23])) | (&(!b[30:23]));

assign sig_a = (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
assign sig_b = (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

assign mult_result = sig_a * sig_b;

assign product_rounded = |normalized_product[22:0];

assign is_normalized = mult_result[47] ? 1'b1 : 1'b0;

assign normalized_product = is_normalized ? mult_result : mult_result << 1;

assign mantissa_product = normalized_product[46:24] + (normalized_product[23] & product_rounded);

assign is_zero = exception ? 1'b0 : (mantissa_product == 23'd0) ? 1'b1 : 1'b0;

assign exp_sum = a[30:23] + b[30:23];

assign exp_final = exp_sum - 8'd127 + is_normalized;

assign overflow = ((exp_final[8] & !exp_final[7]) & !is_zero) && !(&a[30:23]) & !(&b[30:23]);

assign underflow = ((exp_final[8] & exp_final[7]) & !is_zero) ? 1'b1 : 1'b0;

assign exception = exception_flags | overflow | underflow;

assign product = exception_flags ? (&a[30:23]?{a[31]^b[31],a[30:0]}:(&b[30:23]?{a[31]^b[31],b[30:0]}:(&(!a[30:23])?{a[31]^b[31],a[30:0]}:(&(!b[30:23])?{a[31]^b[31],b[30:0]}:32'b01111111100000000000000000000000)))) : 
                 is_zero ? {sign_bit, 31'd0} : 
                 overflow ? {sign_bit, 8'hFF, 23'b0} : 
                 underflow ? {sign_bit, 31'b0} : 
                 {sign_bit, exp_final[7:0], mantissa_product};

endmodule
