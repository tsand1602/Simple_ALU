# Simple ALU (Arithmetic and Logic Unit)

This project implements a simple 6-bit Arithmetic and Logic Unit (ALU) in Verilog, demonstrating a variety of combinational digital circuits commonly used in computer hardware. The ALU and its submodules are written in synthesizable Verilog and are suitable for learning, simulation, or use as building blocks in more complex digital designs.

## Features

- **6-bit Addition**: Ripple Carry Adder (`add.v`)
- **6-bit Subtraction**: Ripple Borrow Subtractor (`Sub-6bit.v`)
- **6-bit Multiplication**: Wallace Tree Multiplier (`wallace_tree_6.v`)
- **6-bit Bitwise AND**

The ALU supports selectable operations via a 2-bit function selector.

## File Overview

| File Name              | Description                                 |
|------------------------|---------------------------------------------|
| `ALU.v`                | Top-level ALU module                        |
| `Adder-6bit.v`         | 6-bit Ripple Carry Adder and helpers        |
| `Sub-6bit.v`           | 6-bit Ripple Borrow Subtractor and helpers  |
| `wallace_tree_6.v`     | 6-bit Wallace Tree Multiplier               |
| `ALU_tb.v`             | Testbench for the ALU                       |

## ALU Operation Selector

| `alu_sel` | Operation            |
|-----------|----------------------|
|  00       | 6-bit Addition       |
|  01       | 6-bit Subtraction    |
|  10       | 6-bit Multiplication |
|  11       | 6-bit Bitwise AND    |

## How to Use

1. **Clone the Repository**
    ```sh
    git clone https://github.com/tsand1602/Simple_ALU.git
    cd Simple_ALU
    ```

2. **Compile and Simulate**
    - Using [Icarus Verilog](http://iverilog.icarus.com/):
      ```sh
      iverilog -o alu_testbench ALU.v Adder-6bit.v Sub-6bit.v wallace_tree_6.v ALU_tb.v
      vvp alu_testbench
      ```
    - Adjust file names as needed if you add/remove modules.

3. **View Simulation Output**
    - The testbench (`ALU_tb.v`) demonstrates and verifies all ALU operations.

## Customization

- The ALU modules are easy to modify for different bit-widths or additional logic operations.
- You can integrate them into larger processor, controller, or datapath designs.
