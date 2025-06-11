# Homework Assignment 02 Problems

## 01_edge_and_pulse_detection

Write a single-pulse signal detector (010).

For output format, see `$display` in the `testbench.sv` file.

## 02_single_and_double_rate_fibonacci

Create a module that generates 2 Fibonacci numbers per clock cycle.

## 03_serial_adder_using_logic_operations_only

Write a serial adder using only the operators `^` (XOR), `|` (OR), `&` (AND) and `~` (NOT).

Information about a one-bit full adder can be found in Harris and Harris book or on [Wikipedia](https://en.wikipedia.org/wiki/Adder_(electronics)#Full_adder).

For output format, see `$display` in the `testbench.sv` file.

## 04_serial_adder_with_vld

Write a module that implements serial addition of two numbers (adding one pair of bits per clock cycle). The module has inputs `a` and `b`, output `sum`. Also, the module has control signals `vld` and `last`.

The `vld` signal means that the input signals are valid. The `last` signal means that the last bits of the numbers have been received.

When `vld` is 1, the module should add `a` and `b` and output the sum `sum`. When `last` is 1, the module should output the sum and reset its state to initial, but only if the `vld` signal is also 1, otherwise `last` should be ignored.

When `rst` is 1, the module should reset its state to initial.

## 05_serial_comparator_most_significant_first

Write a module that serially compares 2 numbers.

The module inputs `a` and `b` are bits from two numbers, with the most significant bits coming first. The module outputs `a_less_b`, `a_eq_b` and `a_greater_b` should show the relationship between `a` and `b`. The module should also use inputs `clk` and `rst`.

For output format, see `$display` in the `testbench.sv` file.

## 06_serial_comparator_most_significant_first_using_fsm

Write a serial comparator similar to the previous exercise, but using a finite state machine to determine the outputs. The most significant bits come first.

## 07_halve_tokens

Assignment:
Implement a sequential module that halves the number of incoming "1" tokens (logical ones).

Timing diagram:

![](../doc/homework2/02_07_01_halve_tokens.png)

## 08_double_tokens

Assignment:
Implement a sequential module that doubles each incoming "1" token (logical one). The module should handle doubling for at least 200 consecutive "1" tokens.

If the module detects more than 200 consecutive "1" tokens, it should set an overflow error flag. The overflow error should be sticky. Once the error appears, the only way to clear it is to use the reset signal "rst".

Timing diagram:

![](../doc/homework2/02_08_01_double_tokens.png)

## 09_round_robin_arbiter_with_2_requests

Assignment:
Implement an "arbiter" module that accepts up to two requests and grants permission to work to one of them.

The module should maintain an internal register that tracks which requester is next in line to receive a grant.

Timing diagram:

![](../doc/homework2/02_09_01_rr_arbiter_2_req.png)

## 10_serial_to_parallel

Assignment:
Implement a module that converts serial data into a parallel multi-bit value.

The module should accept single-bit values with a "valid" interface serially. After accumulating bits of the specified width, the module should assert the "parallel_valid" signal and output the data.

Timing diagram:

![](../doc/homework2/02_10_01_serial_to_parallel.png)