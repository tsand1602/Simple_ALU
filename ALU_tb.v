`timescale 1ns/1ps

module ALU_tb;
    reg [5:0] A, B;
    reg [1:0] alu_sel;
    reg carry_in;
    wire [11:0] result;
    wire carry_out;

    // Instantiate the ALU
    ALU uut (
        .A(A),
        .B(B),
        .alu_sel(alu_sel),
        .carry_in(carry_in),
        .result(result),
        .carry_out(carry_out)
    );

    initial begin
        $display("ALU Testbench - 6-bit Inputs\n");

        // Test ADD
        alu_sel = 2'b00; carry_in = 0;
        A = 6'b000101; B = 6'b000011; // 5 + 3 = 8
        #10;
        $display("ADD: %d + %d = %d (result = %b), carry_out=%b", A, B, result[5:0], result, carry_out);

        alu_sel = 2'b00; carry_in = 1;
        A = 6'b111111; B = 6'b000001; // 63 + 1 + carry_in = 65
        #10;
        $display("ADD: %d + %d + carry_in = %d (result = %b), carry_out=%b", A, B, result[5:0], result, carry_out);

        // Test SUB
        alu_sel = 2'b01; carry_in = 0;
        A = 6'b001010; B = 6'b000110; // 10 - 6 = 4
        #10;
        $display("SUB: %d - %d = %d (result = %b), borrow_out=%b", A, B, result[5:0], result, carry_out);

        alu_sel = 2'b01; carry_in = 1;
        A = 6'b000100; B = 6'b000011; // 4 - 3 - 1 = 0
        #10;
        $display("SUB: %d - %d - borrow_in = %d (result = %b), borrow_out=%b", A, B, result[5:0], result, carry_out);

        alu_sel = 2'b01; carry_in = 0;
        A = 6'b000010; B = 6'b000100; // 2 - 4 = negative value (underflow)
        #10;
        $display("SUB (underflow): %d - %d = %d (result = %b), borrow_out=%b", A, B, result[5:0], result, carry_out);

        // Test MUL
        alu_sel = 2'b10; carry_in = 0;
        A = 6'd10; B = 6'd15;
        #10;
        $display("MUL: %d * %d = %d (result = %b)", A, B, result, result);

        alu_sel = 2'b10; carry_in = 0;
        A = 6'd63; B = 6'd63;
        #10;
        $display("MUL (max): %d * %d = %d (result = %b)", A, B, result, result);

        // Test AND
        alu_sel = 2'b11; carry_in = 0;
        A = 6'b110011; B = 6'b101010;
        #10;
        $display("AND: %b & %b = %b (result = %b)", A, B, result[5:0], result);

        alu_sel = 2'b11; carry_in = 0;
        A = 6'b111111; B = 6'b000000;
        #10;
        $display("AND (all zeros): %b & %b = %b (result = %b)", A, B, result[5:0], result);

        alu_sel = 2'b11; carry_in = 0;
        A = 6'b111111; B = 6'b111111;
        #10;
        $display("AND (all ones): %b & %b = %b (result = %b)", A, B, result[5:0], result);

        $finish;
    end
endmodule
