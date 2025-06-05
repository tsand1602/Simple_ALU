`timescale 1ns/1ps

module ALU_tb;

    reg [3:0] A_4, B_4;
    reg [5:0] A_6, B_6;
    reg [7:0] A_8, B_8;
    reg [1:0] alu_sel;
    reg carry_in;

    wire [11:0] result;
    wire carry_out;

    ALU uut (
        .A_4(A_4), .B_4(B_4),
        .A_6(A_6), .B_6(B_6),
        .A_8(A_8), .B_8(B_8),
        .alu_sel(alu_sel),
        .carry_in(carry_in),
        .result(result),
        .carry_out(carry_out)
    );

    initial begin
        $display("Starting ALU testbench...");

        // Initialize all inputs
        A_4 = 0; B_4 = 0; A_6 = 0; B_6 = 0; A_8 = 0; B_8 = 0; carry_in = 0; alu_sel = 0;
        #5;

        // ADD: 4-bit addition, no carry in
        alu_sel = 2'b00;
        A_4 = 4'b0101; B_4 = 4'b0011; carry_in = 1'b0;
        #10;
        $display("ADD: %d + %d = %d, carry_out=%b, result=0x%h", A_4, B_4, result[3:0], carry_out, result);

        // ADD: 4-bit addition, with carry in
        alu_sel = 2'b00;
        A_4 = 4'b1111; B_4 = 4'b0001; carry_in = 1'b1;
        #10;
        $display("ADD (with carry): %d + %d + %b = %d, carry_out=%b, result=0x%h", A_4, B_4, carry_in, result[3:0], carry_out, result);

        // SUB: 8-bit subtraction, no borrow
        alu_sel = 2'b01;
        A_8 = 8'd100; B_8 = 8'd25; carry_in = 1'b0;
        #10;
        $display("SUB: %d - %d = %d, borrow_out=%b, result=0x%h", A_8, B_8, result[7:0], carry_out, result);

        // SUB: 8-bit subtraction, with borrow (result negative)
        alu_sel = 2'b01;
        A_8 = 8'd50; B_8 = 8'd100; carry_in = 1'b0;
        #10;
        $display("SUB (with borrow): %d - %d = %d, borrow_out=%b, result=0x%h", A_8, B_8, result[7:0], carry_out, result);

        // MUL: 6-bit multiplication, normal case
        alu_sel = 2'b10;
        A_6 = 6'd15; B_6 = 6'd3;
        #10;
        $display("MUL: %d * %d = %d, result=0x%h", A_6, B_6, result, result);

        // MUL: 6-bit multiplication, large values (max * max)
        alu_sel = 2'b10;
        A_6 = 6'd63; B_6 = 6'd63;
        #10;
        $display("MUL (max): %d * %d = %d, result=0x%h", A_6, B_6, result, result);

        // AND: 4-bit AND
        alu_sel = 2'b11;
        A_4 = 4'b1101; B_4 = 4'b1010;
        #10;
        $display("AND: %b & %b = %b, result=0x%h", A_4, B_4, result[3:0], result);

        // AND: 4-bit AND, all ones
        alu_sel = 2'b11;
        A_4 = 4'b1111; B_4 = 4'b1111;
        #10;
        $display("AND (all ones): %b & %b = %b, result=0x%h", A_4, B_4, result[3:0], result);

        // Invalid alu_sel
        alu_sel = 2'bxx;
        #10;
        $display("Default/Invalid alu_sel, result=0x%h, carry_out=%b", result, carry_out);

        $display("ALU testbench completed.");
        $stop;
    end

endmodule
