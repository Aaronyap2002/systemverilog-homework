# Practical Assignment №5

Practical assignment №5 consists of 10 exercises: 6 are mandatory and 4 are optional for extra points.

These exercises are divided into 3 subjects — FIFO, pipelined computational units, and schoolRISCV processor core.

The assignment has the following directory structure:
- `05_01_fifo_with_counter_baseline` - baseline example FIFO for examination
- `05_02_fifo_pow2_depth` - first exercise on FIFO
- `05_03_fifo_empty_full_optimized` - second exercise on FIFO
- `05_04_fifo_with_reg_empty_full` - third exercise on FIFO
- `05_05_a_plus_b_using_fifos_and_double_buffer` - exercise with `a + b` formula
- `05_06_sqrt_formula_pipe` - exercise with formula 2 from assignment №4 and `isqrt` module
- `05_07_cpu_baseline` - baseline schoolRISCV processor example for examination
- `05_08_cpu_with_comb_mul_instr` - exercise on adding multiplication instruction
- `05_09_cpu_mul_with_latency` - optional exercise
- `05_10_cpu_with_b_instr` - optional exercise
- `05_11_cpu_fetch_with_latency` - optional exercise
- `05_12_three_cpus_sharing_instr_memory` - optional exercise

Every exercise has an example section starting with `// Example` comment, and you should write your solution below the `// Task` comment.

Every exercise also has `tb.sv` file, which does a minimal check of your solution.

## Preface

While working on solutions, it is possible to check each separate exercise with the corresponding `run_using_iverilog` script in each directory. It is also possible to run the script in the root directory of assignment 5 to check all exercises.

In `tb.sv` file of any exercise, you can uncomment `$dumpvars;` line for generation of `dump.vcd` file. You can use `gtkwave dump.vcd` command to view the file, or uncomment the corresponding line in `run_all_using_iverilog` script.



## Exercise 1. FIFO with a depth of power of 2

> Exercise: Mandatory
>
> Directory: `05_02_fifo_pow2_depth`

Assignment: Implement missing code for extended read pointer update and `empty` signal for full FIFO functionality.

## Exercise 2. Optimized FIFO

> Exercise: Mandatory
>
> Directory: `05_03_fifo_empty_full_optimized`

FIFO optimization consists of absence of depth-dependent counter, but having only 2 bits to determine the mutual position of read and write pointers.

Assignment: Implement code for read pointer update and circle parity bit, as well as form `full` signal considering `equal_ptrs` and/or `same_circle` constants.

## Exercise 3. FIFO with empty and full registers

> Exercise: Mandatory
>
> Directory: `05_04_fifo_with_reg_empty_full`

In this exercise, empty and full signals are registers, while internal signals are formed combinationally and then written to corresponding registers.

Assignment: Implement code for forming combinational signal `rd_ptr_d`, as well as describe logic for forming signals `empty_d` and `full_d` when `pop` signal is asserted.

## Exercise 4. Formula a + b with FIFO

> Exercise: Mandatory
>
> Directory: `05_05_a_plus_b_using_fifos_and_double_buffer`

This exercise implements a scheme roughly described in the article "[FIFO for the little ones](https://habr.com/ru/articles/646685/)" in Example 3. Two FIFOs at the inputs of the addition operation align results in time and the result is added to a double buffer at the formula output.

Assignment: Connect all internal modules of the exercise using external valid/ready signals as well. Templates for all connections (assign) are provided in `Task` comments, you need to implement the logic for signal formation after `=`.

## Exercise 5. Formula 2 with FIFO

> Exercise: Mandatory
>
> Directory: `05_06_sqrt_formula_pipe`

The exercise folder structure is identical to the formula exercise in Practical Assignment 4. It's recommended to read Yuri Panchul's article "What American students can and cannot write in SystemVerilog for ASIC and FPGA?" in [FPGA-Systems Magazine](https://fpga-systems.ru/fsm/).

Assignment: Implement one of the last cases described in the article — calculation of Formula 2 using pipelined `isqrt` modules and ready-made module from file `flip_flop_fifo_with_counter`.

![](../doc/isqrt/08_f_a_f_b_fc_pipe_with_fifo.png)

## Exercise 6. New multiplication instruction in processor

> Exercise: Mandatory
>
> Directory: `05_08_cpu_with_comb_mul_instr`

In this exercise, first you need to familiarize yourself with the schoolRISCV processor structure in folder `05_07_cpu_baseline`. In this and subsequent exercises, the basic processor structure is similar, but is extended depending on exercise conditions. It's also advisable to familiarize yourself with laboratory work `30_schoolriscv` in the `basics-graphics-music` repository and watch session 21 of the Digital Circuit Synthesis School, where it's explained in detail how to work with the schoolRISCV project.

It's also useful to familiarize yourself [with the RISC-V standard](https://riscv.org/technical/specifications/) (RV32I User-Level ISA and RV32M extension) and extend the processor according to the standard.

Assignment: You need to add the multiplication instruction `mul` to the processor for correct operation of the `program.s` program for calculating Fibonacci numbers. To do this, you need to update the file `sr_cpu.svh` by adding correct constants, as well as the ALU module `sr_alu.sv`, or create a module `sr_mdu.sv`.

## Exercise 7. Multiplication instruction with latency

> Exercise: **Additional**
>
> Directory: `05_09_cpu_mul_with_latency`

Assignment: Based on the previous exercise, implement the `mul` multiplication instruction using a pipelined multiplication module with constant latency 2 (or parameterizable `N`).

Note: Several solution variants of different performance levels are allowed - from very simple, where the entire processor operation is delayed until the result appears from the multiplication block (stall), to building a simple pipeline with bypasses (forwarding). Bypasses can be made both between multiplications and additions (and other combinational ALU instructions), and between two multiplications, which provides maximum throughput. Two multiplication operations can also follow each other and should be processed inside the pipelined multiplier simultaneously. From experience, a student who implemented such a variant as homework, after an interview - received an offer from a large electronics company.


## Exercise 8. New unconditional branch instruction `b`

> Exercise: **Additional**
>
> Directory: `05_10_cpu_with_b_instr`

Assignment: Add an unconditional branch instruction `b`. To do this, you need to extend the interface of modules `sr_control.sv` and `sr_decode.sv`, as well as add correct logic for updating the program counter `pcNext` and writing the instruction result to register `wd3`.

## Exercise 9. Instruction memory module with latency

> Exercise: **Additional**
>
> Directory: `05_11_cpu_fetch_with_latency`

Assignment: Modify the processor for correct operation with instruction memory that has a 1 clock cycle latency for getting instructions.

You can assume either non-pipelined or pipelined memory. In the first case you just need to track whether instruction memory data is valid for the current clock cycle. In the second case you can try to implement a pipelined CPU construction with rudimentary branch prediction ("predict no branch").

## Exercise 10. Three processors and arbiter

> Exercise: **Additional**
>
> Directory: `05_12_three_cpus_sharing_instr_memory`

Familiarize yourself with the arbiter operation in file `round_robin_arbiter_8.sv`.

Assignment: Implement a processor cluster in file `cpu_cluster.sv` consisting of 3 instances of schoolRISCV core sharing one instruction memory.

Advanced variant: Make instruction memory from several so-called banks, which would provide simultaneous access to different parts of the address space in most cases (when there's no "bank conflict").