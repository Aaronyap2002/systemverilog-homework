# Practical Assignment №4

Practical assignment №4 consists of 13 exercises:

- First in folder `04_01_signed_add_with_overflow`
- Second in folder `04_02_signed_add_with_saturation`
- Third in folder `04_03_signed_or_unsigned_mul`
- Fourth in folder `04_04_four_ways_of_doing_shift`
- Fifth in folder `04_05_circular_shifts`
- Sixth in folder `04_06_arithmetic_shift_or_signed_divide_by_power_of_2`
- Seventh through tenth in folder `04_07_10_sqrt_formula_pipe`
- Eleventh in folder `04_11_sqrt_formula_distributor`
- Twelfth in folder `04_12_float_discriminant_distributor`
- Thirteenth in folder `04_13_put_in_order`

Most exercises have an `Example` section with an example module, and a `Task` section with assignment description and place where you need to describe your solution.

## Preface

During work with exercises 1-6, it's possible to run verification of a single assignment solution using the command `iverilog -g2005-sv *.sv && vvp a.out` in the assignment folder.

In the file containing the Testbench of any assignment, you can uncomment the `$dumpfile;` and `$dumpvars;` lines to generate a `dump.vcd` file. The file will contain textual descriptions of the timing diagram describing changes on all wires and registers during simulation.

You can use the command `gtkwave dump.vcd` to view the file, or add the `--wave` or `-w` option to the `run_` script. You can also use the more modern [Surfer](https://surfer-project.org/) program to view timing diagrams. Surfer is available on Linux, Windows and macOS systems, as well as a [VS Code editor extension](https://marketplace.visualstudio.com/items?itemName=surfer-project.surfer).

## Exercise 1. Signed addition with overflow

Assignment:

Implement a module that adds two signed numbers and detects overflow. By "signed number" we mean numbers represented in "two's complement" ([two's complement](https://en.wikipedia.org/wiki/Two%27s_complement)).

The output "overflow" bit should be equal to 1 if the sum value (positive or negative) of two input arguments doesn't fit in 4 bits. Otherwise, the "overflow" value should be 0.

## Exercise 2. Signed addition with saturation

Assignment:

Implement a module that adds two signed numbers with saturation. "Addition with saturation" means:
- If the result doesn't fit in 4 bits and the arguments are positive, the resulting sum should become the maximum positive number.
- If the result doesn't fit in 4 bits and the arguments are negative, the resulting sum should become the minimum negative number.

## Exercise 3. Signed and unsigned multiplication

Assignment:

Implement a parameterized module that outputs the multiplication result with or without considering signs depending on the input bit 'signed_mul'.

## Exercise 4. Four ways of bitwise shifting

Assignment:

Implement a parameterized module that shifts an unsigned input number by `S` bits to the right using four different methods: logical right shift, concatenation, `for` loop inside `always_comb`, and `for` loop inside `generate`.

## Exercise 5. Circular bitwise shift

Assignment:

Implement a module that shifts the incoming `S` bits to the right circularly, in a circle, using only the bitwise concatenation operator (curly braces `{` and `}`) and slices (slice, square brackets operator `[` and `]`).

"Circularly" means `ABCDEFGH` -> `FGHABCDE`, when `N = 8` and `S = 3`.

In the second subtask, use only the following operations: logical right shift (`>>`), logical left shift (`<<`), "or" (`|`) and constants.

## Exercise 6. Arithmetic shift or signed division by power of two

Assignment:

Implement arithmetic right shift in three different ways. Arithmetic right shift (`>>>`) differs from logical shift (`>>`) by filling the initial bits with the correct value, depending on the sign.

For example:
`-4` equals `8'b11111100` in two's complement, so `-4 >>> 2` will equal `-1` = `8'b11111111`.

## Exercises 7-10. Pipelined calculation of formulas with square root

### Introduction

The `04_07_10_sqrt_formula_pipe` directory contains a set of exercises dedicated to calculating Formula 1 and Formula 2 with square roots in pipelined form. This is the best performance version of assignment `03_04_05_sqrt_formula_fsms`.

It's recommended to read the discussion of this assignment in Yuri Panchul's article published in FPGA-Systems Journal :: FSM :: Issue ALFA (state_0). The issue is available at https://fpga-systems.ru/fsm#state_0.

### Exercise 7

Assignment:

Implement a pipelined module `formula_1_pipe` that calculates the result according to the formula defined in file `formula_1_fn.svh`.

Requirements:
1. The formula_1_pipe module must be pipelined
    - It must be able to accept a new set of arguments `a`, `b` and `c` arriving every clock cycle
    - It must also be able to output a new result every clock cycle with fixed latency
2. Your solution must create exactly 3 instances of the pipelined `isqrt` module, each of which will calculate the integer square root for its argument.
3. Your solution must save dynamic power consumption through proper connection of valid signals.

Architectural diagram
![](../doc/isqrt/02_fa_fb_fc_3.png)

### Exercise 8

Assignment:

Implement a `formula_1_pipe_aware_fsm` module using a finite state machine (FSM) that controls input data and uses output data from one pipelined `isqrt` module.

It's assumed that the `formula_1_pipe_aware_fsm` module should be created inside the `formula_1_pipe_aware_fsm_top` module together with a single `isqrt` instance.

The resulting structure should calculate the formula defined in file `formula_1_fn.svh`. The `formula_1_pipe_aware_fsm` module should not create any instances of the `isqrt` module, it should only use input and output ports connected to the `isqrt` instance at a higher level of the instance hierarchy.

All datapath calculations, except square root calculation, should be implemented inside the `formula_1_pipe_aware_fsm` module. Thus, this module is not only a finite state machine, but also a combination of FSM with a datapath for additions and intermediate data registers.

Note that the `formula_1_pipe_aware_fsm` module itself is not pipelined. It must be able to accept new arguments `a`, `b` and `c` arriving every `N+3` clock cycles. To achieve this delay, it's assumed that the FSM uses the fact that `isqrt` is pipelined.

Architectural diagram
![](../doc/isqrt/03_fsm_1.png)

### Exercise 9. Shift register with valid signal

Assignment:

Implement a variant of the shift register module that moves data transmission only if this transmission is valid (the `valid` signal is active).

Architectural diagram
![](../doc/isqrt/06_shift_reg.png)

### Exercise 10

Assignment:

Implement a pipelined module `formula_2_pipe` that calculates the result according to the formula defined in file `formula_2_fn.svh`.

Requirements:
1. The `formula_2_pipe` module must be pipelined.
    - It must be able to accept a new set of arguments `a`, `b` and `c` arriving every clock cycle.
    - It must also be able to output a new result every clock cycle with fixed delay after accepting arguments.
2. Your solution must create exactly 3 instances of the pipelined `isqrt` module.
3. Your solution must save dynamic power consumption through proper connection of validity signals.

For proper pipelined processing, clock cycle data alignment, use the `shift_register_with_valid` module to create delays of `N` and `2N+1` clock cycles.

Architectural diagram
![](../doc/isqrt/07_f_a_f_b_fc_pipe.png)

## Exercise 11. Computation distributor. Formulas with roots

Assignment:

Implement a module that will calculate Formula 1 or Formula 2 based on parameter values. The module _must_ be pipelined. It must accept a new triple of arguments `a`, `b`, `c` arriving every clock cycle.

The idea of the assignment is to implement a hardware task distributor that will accept a triple of arguments and assign the task of calculating formula 1 or formula 2 with these arguments to a free internal module from previous assignments. The first step to solving the exercise is filling the files `03_04` and `03_05`.

Note 1:  \
You need to determine the delay in clock cycles for the `formula_1_isqrt` module from the timing diagram yourself. In case of difficulties with the timing diagram, you can assume it equals 50 clock cycles.

Note 2:  \
The exercise assumes an idealized distributor (with 50 internal computational blocks), however in practice engineers rarely use more than 10 modules simultaneously. Usually they use 3-5 blocks and global stall in case of high load.

Recommendation:  \
Create a sufficient number of "formula_1_impl_1_top", "formula_1_impl_2_top" or "formula_2_top" modules to achieve desired performance.

Architectural diagram
![](../doc/homework4/04_11_fix_latency.png)

Example operation on timing diagram
![](../doc/homework4/04_11_fix_latency_wave.png)

## Exercise 12. Computation distributor. Floating-point discriminant

Assignment:

Implement a module that will calculate the discriminant based on a triple of input floating-point numbers `a`, `b`, `c`.

The module _must_ be pipelined. It must be able to accept a new triple of arguments every clock cycle, and also output a result every clock cycle after some time.

The idea of the exercise is similar to exercise `04_11`. The main difference is in the base module `03_08_float_discriminant` instead of formula modules.

Note 1:  \
Reuse your file "03_08_float_discriminant.sv" from Homework 3.

Note 2:  \
The delay of the "float_discriminant" module should be determined from the timing diagram.

## Exercise 13. Result ordering

Assignment:

Implement a module that accepts multiple outputs from an array of computational blocks and outputs them one after another in order. Input signals `up_vlds` and `up_data` come from non-pipelined computational blocks. These external calculators have variable delay.

The order of incoming `up_vlds` is not fixed, while the task is to output `down_vld` and data in order, one after another.

Comment:  \
The idea of the block is somewhat similar to the `parallel_to_serial` block from Homework 2, but in this exercise the block must maintain the correct output order.

Architectural diagram
![](../doc/homework4/4_13_home_work_diagram.png)

Example operation on timing diagram
![](../doc/homework4/4_13_wave.png)