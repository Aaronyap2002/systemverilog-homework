//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module fibonacci
(
  input               clk,
  input               rst,
  output logic [15:0] num
);

  logic [15:0] num2;

  always_ff @ (posedge clk)
    if (rst)
      { num, num2 } <= { 16'd1, 16'd1 };
    else
      { num, num2 } <= { num2, num + num2 };

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module fibonacci_2
(
  input               clk,
  input               rst,
  output logic [15:0] num,
  output logic [15:0] num2
);

  // Task:
  // Implement a module that generates two fibonacci numbers per cycle
  
  always_ff @ (posedge clk)
    if (rst) begin
      num  <= 16'd1;
      num2 <= 16'd1;
      end
    else begin
    //double data rate means output of numbers is calculating 2 numbers ahead.
    //which means for the next num number, num needs 1 previous number and itself.
    //and num2 needs the new num value, and the number before new num value (which is num2). 
      num  <= num + num2; 
      num2 <= num + num2 + num2;
    end
endmodule
