//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module halve_tokens
(
    input  clk,
    input  rst,
    input  logic a,
    output logic b
);
    // Task:
    // Implement a serial module that reduces amount of incoming '1' tokens by half.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 110_011_101_000_1111
    // b -> 010_001_001_000_0101

//output 1 only when 2 ones have occured. need keep track of history of 1

logic storage,out;
/*  always_ff @ (posedge clk) begin
    if (rst)
      b <= 0;
    else
      if(storage)
	if (a) begin
	  b<=1;
	  storage <=0;
	end
	else 
	  b<=0;
      end
      else 
        if (a) begin
	  b<=0;
	  storage <=1;
	end
	else 
	  b<=0; */

  always_ff@(posedge clk) begin
   if (rst)
      b <= 0;
    else begin
      if (a) begin
        if(!storage) begin
	  storage <= 1;
	  b <= 0;
	end
	else begin
	  storage <=0;
	  b<=1;
	end
      end
      else begin
        b<=0;
      end
    end     
  end
endmodule
