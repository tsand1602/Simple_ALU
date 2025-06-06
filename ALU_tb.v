`timescale 1ns/1ps

module ALU_tb;

    reg [5:0] A, B;
    reg [1:0] alu_sel;
    wire [11:0] result;

    ALU uut (
        .A(A),
        .B(B),
        .alu_sel(alu_sel),
        .result(result)
    );

    initial begin
        $display("ALU Testbench Started");
        
        // Test Addition (alu_sel = 00)
        alu_sel = 2'b00;
        A = 6'd15; B = 6'd5; #10;
        $display("ADD: %d + %d = %d", A, B, result);

        // Test Subtraction (alu_sel = 01)
        alu_sel = 2'b01;
        A = 6'd30; B = 6'd10; #10;
        $display("SUB: %d - %d = %d", A, B, result);

        // Test Multiplication (alu_sel = 10)
        alu_sel = 2'b10;
        A = 6'd6; B = 6'd7; #10;
        $display("MUL: %d * %d = %d", A, B, result);

        // Test AND (alu_sel = 11)
        alu_sel = 2'b11;
        A = 6'b101010; B = 6'b110011; #10;
        $display("AND: %b & %b = %b", A, B, result[5:0]);

        // Test edge cases
        alu_sel = 2'b00;
        A = 6'd63; B = 6'd1; #10;
        $display("ADD (Overflow): %d + %d = %d", A, B, result);

        alu_sel = 2'b01;
        A = 6'd0; B = 6'd1; #10;
        $display("SUB (Negative): %d - %d = %d", A, B, result);

        alu_sel = 2'b10;
        A = 6'd63; B = 6'd63; #10;
        $display("MUL (Max): %d * %d = %d", A, B, result);

        $display("ALU Testbench Finished");
        $finish;
    end

endmodule
