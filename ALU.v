module ALU(
    input [3:0] A_4, B_4,        // 4-bit inputs for adder and logic
    input [5:0] A_6, B_6,        // 6-bit inputs for multiplier
    input [7:0] A_8, B_8,        // 8-bit inputs for subtractor
    input [1:0] alu_sel,         // 2-bit operation select
    input carry_in,              // carry/borrow in for adder/subtractor
    output reg [11:0] result,    // Output (max needed for 6-bit mult)
    output reg carry_out         // carry/borrow out
);

wire [3:0] sum4;
wire adder_carry_out;

wire [11:0] mul6;

wire [7:0] sub8;
wire sub_borrow_out;

RCA4 adder4 (
    .A(A_4),
    .B(B_4),
    .in(carry_in),
    .out(adder_carry_out),
    .sum(sum4)
);

ripple_borrow_subtractor_8bit sub8_inst (
    .A(A_8),
    .B(B_8),
    .Bin(carry_in),
    .D(sub8),
    .Bout(sub_borrow_out)
);

wallace_tree_6 mult6 (
    .op1(A_6),
    .op2(B_6),
    .res(mul6)
);

always @(*) begin
    case (alu_sel)
        2'b00: begin 
            result    = {8'b0, sum4}; 
            carry_out = adder_carry_out;
        end
        2'b01: begin 
            result    = {4'b0, sub8}; 
            carry_out = sub_borrow_out;
        end
        2'b10: begin 
            result    = mul6;
            carry_out = 1'b0;
        end
        2'b11: begin 
            result    = {8'b0, (A_4 & B_4)};
            carry_out = 1'b0;
        end
        default: begin
            result    = 12'b0;
            carry_out = 1'b0;
        end
    endcase
end

endmodule
