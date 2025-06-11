//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_adder_with_vld
(
  input  clk,
  input  rst,
  input  logic vld,
  input  logic a,
  input  logic b,
  input  logic last,
  output logic sum
);

logic a_1,b_1,temp;
//assign a_1 = a;
//assign b_1 = b;

  always_comb begin
    if (vld) begin
      temp = a_1 + b_1;
    end
  end

  always_ff@(posedge clk) 
    begin
      if (rst)begin
	a_1<=0;
        b_1<=0;
      end
      else if (last)
        sum <=temp;
        a_1<=0;
        b_1<=0;
	temp<=0;
    end
  // Task:
  // Implement a module that performs serial addition of two numbers
  // (one pair of bits is summed per clock cycle).
  //
  // It should have input signals a and b, and output signal sum.
  // Additionally, the module have two control signals, vld and last.
  //
  // The vld signal indicates when the input values are valid.
  // The last signal indicates when the last digits of the input numbers has been received.
  //
  // When vld is high, the module should add the values of a and b and produce the sum.
  // When last is high, the module should output the sum and reset its internal state, but
  // only if vld is also high, otherwise last should be ignored.
  //
  // When rst is high, the module should reset its internal state.


endmodule
