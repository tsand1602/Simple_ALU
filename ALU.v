module ALU(
    input  [5:0] A,
    input  [5:0] B,
    input  [1:0] alu_sel,
    output reg [11:0] result
);

    // Internal wires for each operation
    wire [5:0] add_result;
    wire add_carry_out;

    wire [5:0] sub_result;
    wire sub_borrow_out;

    wire [11:0] mul_result;
    wire [5:0] and_result;

    // 6-bit ripple-carry adder
    RCA6 adder_inst (
        .A(A),
        .B(B),
        .in(1'b0),
        .out(add_carry_out),
        .sum(add_result)
    );

    // 6-bit ripple-borrow subtractor
    ripple_borrow_subtractor_6bit subtractor_inst (
        .A(A),
        .B(B),
        .Bin(1'b0),
        .D(sub_result),
        .Bout(sub_borrow_out)
    );

    // 6-bit AND
    assign and_result = A & B;

    // 6-bit Wallace Tree Multiplier
    wallace_tree_6 multiplier_inst (
        .op1(A),
        .op2(B),
        .res(mul_result)
    );

    always @(*) begin
        case (alu_sel)
            2'b00: result = {6'b0, add_result}; // Zero-extend to 12 bits
            2'b01: result = {6'b0, sub_result}; // Zero-extend to 12 bits
            2'b10: result = mul_result;
            2'b11: result = {6'b0, and_result}; // Zero-extend to 12 bits
            default: result = 12'b0;
        endcase
    end

endmodule
