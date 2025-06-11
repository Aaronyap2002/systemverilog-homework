//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module posedge_detector (input clk, rst, a, output detected);

  logic a_r;

  // Note:
  // The a_r flip-flop input value d propogates to the output q
  // only on the next clock cycle.

  always_ff @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r & a; //previous input cycle's value inversed && with current input cycle's value. Detects rising edge. a is continuously assigned

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module one_cycle_pulse_detector (input clk, rst, a, output detected);
  wire k1;
  reg k2=0;
  // Task:
  // Create an one cycle pulse (010) detector.
  //
  // Note:
  // See the testbench for the output format ($display task).
  posedge_detector pd1 (.clk,.rst,.a,.detected(k1));
  always_ff@(posedge clk)
    begin
      if (rst)
        k2 <= 0;
      else
        k2 <= k1;
    end
 

 assign detected = ~a & k2;



endmodule
