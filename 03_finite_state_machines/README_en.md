# Practical Assignment №3

Practical assignment №3 consists of 8 exercises:

- First in folder `03_01_detect_sequence_using_fsm`
- Second in folder `03_02_detect_sequence_using_shift_reg`
- Third in folder `03_03_serial_divisibility_using_fsm`
- Fourth and fifth in folder `03_04_05_sqrt_formula_fsms`
- Sixth in folder `03_06_sort_floats`
- Seventh in folder `03_07_sort_floats_using_fsm`
- Eighth in folder `03_08_float_discriminant`

Most exercises have an `Example` section with an example module, a `Task` section with assignment description and place where you need to describe your solution, as well as a `Testbench` file that performs minimal verification of your solution's functionality.

## Preface

During work with exercises 1-3, it's possible to run verification of your solution separately using the command `iverilog -g2005-sv *.sv && vvp a.out` in the assignment folder.

In the `Testbench` file of any assignment, you can uncomment the `$dumpfile;` and `$dumpvars;` lines to generate a `dump.vcd` file when running. The file will contain a textual description of the timing diagram describing changes on all wires and registers during module operation simulation.

You can use the command `gtkwave dump.vcd` to view the file, or add the `--wave` or `-w` option to the `run_` script. You can also use the more modern [Surfer](https://surfer-project.org/) program to view timing diagrams. Surfer is available on Linux, Windows and macOS systems, as well as a [VS Code editor extension](https://marketplace.visualstudio.com/items?itemName=surfer-project.surfer).

## Exercise 1. Binary sequence recognition using FSM

Study the example of 4-bit sequence detection.

Assignment: Implement a module for detecting the 6-bit sequence `110011` using a finite state machine.

## Exercise 2. Binary sequence recognition using Shift Register

Study the example of 4-bit sequence detection.

Assignment: Implement a module for detecting the 6-bit sequence `110011` using a shift register.

## Exercise 3. Serial divisibility check

Study the example of detecting divisibility by 3.

Below is an example of module operation, output and internal state during the process. Only the rightmost bit is fed to the module input:
```
binary number   Div by 3    State
          0       yes       mod_0
         01        no       mod_1
        011       yes       mod_0
       0110       yes       mod_0
      01101        no       mod_1
     011010        no       mod_2
    0110100        no       mod_1
   01101001       yes       mod_0
```

Assignment: Implement a module for serial detection of divisibility by 5 using a finite state machine.

## Exercises 4 and 5. Formula calculation using FSM

### Introduction
The `03_04_05_sqrt_formula_fsms` directory contains examples, testbenches, solution templates and auxiliary code for exercises 4 and 5.

To complete the exercises, you need to use the ready-made `isqrt.sv` module as a black box and write FSM for calculating two formulas. The `isqrt.sv` module calculates integer square root with fixed latency (time in clock cycles between argument input and result output). The module starts calculation when the `x_vld` signal is asserted, and reports result readiness (validity) by asserting the `y_vld` signal.

The `isqrt` module is located in the `common/isqrt/` directory:

```c
common/black_boxes // Ready-made isqrt module
├── isqrt.sv
├── isqrt_slice_comb.sv
└── isqrt_slice_reg.sv
```

Exercise directory structure:

```c
├── testbenches
│   ├── formula_tb.sv // Main testbench code
│   ├── isqrt_fn.svh  // Mathematical isqrt formula for verification
│   └── tb.sv         // Running three testbenches for different formulas
├── formula_1_fn.svh  // Reference formula 1 (used for verification)
├── formula_1_impl_1_fsm.sv         // Example implementation of formula 1
├── formula_1_impl_1_fsm_style_2.sv // Alternative implementation of formula 1
├── formula_1_impl_1_top.sv
├── 03_04_formula_1_impl_2_fsm.sv // File with Exercise 4
├── formula_1_impl_2_top.sv
├── formula_2_fn.svh  // Reference formula 2 (used for verification)
├── 03_05_formula_2_fsm.sv // File with Exercise 5
├── formula_2_top.sv
├── run_all_using_iverilog_under_linux_or_macos_brew.sh
└── run_all_using_iverilog_under_windows.bat
```

> **Note**: Creating instances of the `isqrt` module independently is prohibited. You must work with the module through the `isqrt_x` and `isqrt_y` inputs and outputs of the exercise module.

### Exercise 4

Study the formula in file `formula_1_fn.svh` and the finite state machine example for sequential calculation of this formula in file `formula_1_impl_1_fsm.sv` or `formula_1_impl_1_fsm_style_2.sv`.

Assignment:
In file `formula_1_impl_2_fsm.sv`, implement calculation of Formula 1 using two `isqrt` modules simultaneously. Calculate two of the three values in parallel. Then, calculate the remaining value and provide the sum result.

### Exercise 5

Study the formula in file `formula_2_fn.svh`.

Assignment:
In file `formula_2_fsm.sv`, implement sequential calculation of Formula 2 using one `isqrt` module.

## Exercises 6, 7 and 8. Floating-point numbers

### Introduction

To successfully complete the exercises, you need to become familiar at a basic level with floating-point number representation in computers and in binary format. The exercises are based on the IEEE 754 standard.

In this group of exercises, for working with floating-point numbers, a block (FPU) from the open-source processor [CORE-V Wally](https://github.com/openhwgroup/cvw) is used. This processor is based on the RISC-V standard and is being developed by a group of researchers led by David Harris.

To simplify working with floating-point numbers, the FPU block from the processor is wrapped in simpler wrapper modules. Each wrapper module is specialized for performing one specific operation. For example, the `f_less_or_equal` module calculates whether the first number is less than or equal to the second, and the `f_add` and `f_sub` modules perform addition and subtraction of two floating-point numbers respectively.

All wrapper modules are located in the `common/wally_fpu` folder. The processor source codes are located in the `import/preprocessed/cvw` folder and, if absent, should be imported by running the `run_linux_mac.sh` script.

The `FLEN` constant is declared in the `import/preprocessed/cvw/config-shared.sv` file and denotes the length of the floating-point number in bits. In all exercises of this practical assignment, the length of floating-point numbers implies 64 bits, however for compatibility it is strongly recommended to use the `FLEN` constant instead of numerical length specification.

The `NE` (<u>N</u>umber of <u>E</u>xponent bits) constant and the `NF` (<u>N</u>umber of <u>F</u>raction bits) constant denote the number of bits used to store the exponent and fractional part respectively. Also, the first bit of the floating-point number denotes the sign (Sign).

### Exercise 6. Combinational sorting of floating-point numbers

Study the examples of sorting two numbers `a` and `b` separately, as well as sorting an `unsorted` array of two elements.

Assignment:
In file `03_06_sort_floats.sv`, implement a module for sorting three floating-point numbers using several `f_less_or_equal` modules. The solution should be combinational. When processing incoming numbers, the module should set the `err` flag to logical one if any of the internal `f_less_or_equal` modules detects `NaN`, `+Inf` or `-Inf` numbers and sets the `err` flag.

## Exercise 7. Sorting floating-point numbers using FSM

Assignment:
In file `03_07_sort_floats_using_fsm.sv`, implement a module for sorting three floating-point numbers using FSM and an external module for comparing two floating-point numbers.

In this assignment, creation of any module instances is **prohibited**. You must use the signals `f_le_a`, `f_le_b`, `f_le_res`, `f_le_err` to communicate with the external combinational module. The total latency of the module (from the moment `valid_in` is asserted to the moment `valid_out` is asserted) should not exceed 10 clock cycles.

When a comparison error is detected, i.e., `f_le_err` equals logical one, you must stop the FSM operation and in the current or next clock cycle assert the `valid_out` signal together with the error signal `err`. In this case, the `sorted` output values can be arbitrary and will be ignored by the testing environment.

## Exercise 8. Floating-point discriminant calculation

Study the wrapper modules for multiplication (`f_mult`), addition (`f_add`) and subtraction (`f_sub`) of floating-point numbers.

Assignment:
In file `03_08_float_discriminant.sv`, implement a module for calculating the discriminant of a quadratic equation. The calculation should use the commonly accepted formula `D = b*b - 4ac`.

When processing incoming numbers, the module should set the `err` flag to logical one if any of the internal module instances detects `NaN`, `+Inf` or `-Inf` numbers and sets the `err` flag. In this case, the `res` output values can be arbitrary and will be ignored by the testing environment.

As a constant floating-point number 4, you can use the following declaration:

```systemverilog
localparam [FLEN - 1:0] four = 64'h4010_0000_0000_0000;
```