//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    // Task:
    // Implement a module that converts serial data to the parallel multibit value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits, the module should assert the parallel_valid
    // output and set the data.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
localparam decimal_value = (1<<width);
logic [width-1:0] parallel_storage;
logic [width-1:0] counter;

  assign parallel_data = (parallel_valid == 1)? parallel_storage: 0;

  always_ff @(posedge clk or posedge rst) begin 
    if(rst) begin
      counter<= 0;
      parallel_valid <= 0;
      parallel_storage <= 0;
    end
    else if (serial_valid) begin
      parallel_storage <= {serial_data,parallel_storage[width-1:1]};
      if (counter == width-1) begin
        counter <= 0;
        parallel_valid <=1; 
      end
      else begin
        counter <= counter+1;
        parallel_valid <=0;
      end
    end
    else if (counter == 0)
      parallel_valid <=0;
  end
endmodule
