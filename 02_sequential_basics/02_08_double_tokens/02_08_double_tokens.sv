//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input logic       a,
    output logic       b,
    output logic overflow
);
    // Task:
    // Implement a serial module that doubles each incoming token '1' two times.
    // The module should handle doubling for at least 200 tokens '1' arriving in a row.
    //
    // In case module detects more than 200 sequential tokens '1', it should assert
    // an overflow error. The overflow error should be sticky. Once the error is on,
    // the only way to clear it is by using the "rst" reset signal.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 10010011000110100001100100
    // b -> 11011011110111111001111110
logic [10:0] storage, of_counter;

assign b = a|(storage > 0);
always_ff@(posedge clk) begin
   if (rst) begin
      storage <= 0;
      of_counter <= 0;
      overflow <= 0;
    end
    else begin
      if (a) begin
        if(of_counter <= 200)
          of_counter <= of_counter+1;
	else if (!overflow)
	  overflow <= 1;
	storage <= storage +1;
      end
      else if (storage >0)
        storage <= storage-1;
      else
        storage <=0;
    end
end
endmodule
