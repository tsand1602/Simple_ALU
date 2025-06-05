module ALU(
    input [5:0] A,    // Operand A (6 bits)
    input [5:0] B,    // Operand B (6 bits)
    input [1:0] alu_sel, // Operation select: 00=ADD, 01=SUB, 10=MUL, 11=AND
    input carry_in,      // Carry-in for add/sub
    output reg [11:0] result, // ALU result (12 bits for multiplication)
    output reg carry_out      // Carry or borrow out
);

    wire [5:0] add_result;
    wire add_carry_out;
    wire [5:0] sub_result;
    wire sub_borrow_out;
    wire [11:0] mul_result;
    wire [5:0] and_result;

    RCA6 adder_inst (
        .A(A),
        .B(B),
        .in(carry_in),
        .out(add_carry_out),
        .sum(add_result)
    );

    ripple_borrow_subtractor_6bit subtractor_inst (
        .A(A),
        .B(B),
        .Bin(carry_in),
        .D(sub_result),
        .Bout(sub_borrow_out)
    );

    wallace_tree_6 multiplier_inst (
        .A(A),
        .B(B),
        .P(mul_result)
    );

    assign and_result = A & B;

    always @(*) begin
        case (alu_sel)
            2'b00: begin // ADD
                result = {6'b0, add_result};
                carry_out = add_carry_out;
            end
            2'b01: begin // SUB
                result = {6'b0, sub_result};
                carry_out = sub_borrow_out;
            end
            2'b10: begin // MUL
                result = mul_result;
                carry_out = 1'b0;
            end
            2'b11: begin // AND 
                result = {6'b0, and_result};
                carry_out = 1'b0;
            end
            default: begin
                result = 12'b0;
                carry_out = 1'b0;
            end
        endcase
    end

endmodule
