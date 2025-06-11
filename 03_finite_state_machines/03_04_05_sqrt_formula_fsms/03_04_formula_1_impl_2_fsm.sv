//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_impl_2_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_1_x_vld,
    output logic [31:0] isqrt_1_x,

    input               isqrt_1_y_vld,
    input        [15:0] isqrt_1_y,

    output logic        isqrt_2_x_vld,
    output logic [31:0] isqrt_2_x,

    input               isqrt_2_y_vld,
    input        [15:0] isqrt_2_y
);

    // Task:
    // Implement a module that calculates the formula from the `formula_1_fn.svh` file
    // using two instances of the isqrt module in parallel.
    //
    // Design the FSM to calculate an answer and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm

    //----------------------------------------------------------------------------
// Exercise 4: Parallel implementation of Formula 1 using two isqrt modules
//----------------------------------------------------------------------------


    //------------------------------------------------------------------------
    // State Definition: Describing computation phases rather than waiting states
    //------------------------------------------------------------------------
    
    typedef enum logic [1:0] {
        ST_IDLE            = 2'd0,  // Ready to accept new computation
        ST_PARALLEL_PHASE  = 2'd1,  // Computing √a and √b in parallel
        ST_FINAL_PHASE     = 2'd2,  // Computing √c (final computation)
        ST_RESULT_READY    = 2'd3   // Result ready, outputting for one cycle
    } state_t;
    
    state_t state, next_state;

    //------------------------------------------------------------------------
    // Internal storage for intermediate results
    //------------------------------------------------------------------------
    
    // We need to store the results from the parallel phase
    // until we can add the final result
    logic [31:0] accumulated_sum;  // Stores √a + √b

    //------------------------------------------------------------------------
    // State Transition Logic: The Heart of Our Parallel Coordination
    //------------------------------------------------------------------------
    
    always_comb begin
        // Default: stay in current state
        next_state = state;
        
        case (state)
            ST_IDLE: begin
                // Start computation when valid inputs arrive
                if (arg_vld) begin
                    next_state = ST_PARALLEL_PHASE;
                end
            end
            
            ST_PARALLEL_PHASE: begin
                // Both isqrt modules should complete simultaneously due to fixed latency
                // We only transition when BOTH results are valid
                if (isqrt_1_y_vld && isqrt_2_y_vld) begin
                    next_state = ST_FINAL_PHASE;
                end
                // Note: With fixed latency, this condition should always be true together
                // But defensive programming suggests checking both
            end
            
            ST_FINAL_PHASE: begin
                // Wait for the final √c computation to complete
                if (isqrt_1_y_vld) begin  // Using isqrt_1 for final computation
                    next_state = ST_RESULT_READY;
                end
            end
            
            ST_RESULT_READY: begin
                // Stay here for exactly one cycle to output the result
                // Then return to idle for next computation
                next_state = ST_IDLE;
            end
        endcase
    end

    //------------------------------------------------------------------------
    // Sequential State Update
    //------------------------------------------------------------------------
    
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= ST_IDLE;
        end else begin
            state <= next_state;
        end
    end

    //------------------------------------------------------------------------
    // ISQRT Interface Control: Coordinating Two Modules
    //------------------------------------------------------------------------
    
    // First isqrt module control
    always_comb begin
        isqrt_1_x_vld = 1'b0;
        isqrt_1_x = 32'hX;  // Don't care default
        
        case (state)
            ST_IDLE: begin
                if (arg_vld) begin
                    // Start first parallel computation (√a)
                    isqrt_1_x_vld = 1'b1;
                    isqrt_1_x = a;
                end
            end
            
            ST_PARALLEL_PHASE: begin
                if (isqrt_1_y_vld && isqrt_2_y_vld) begin
                    // Both parallel computations done, start final computation (√c)
                    isqrt_1_x_vld = 1'b1;
                    isqrt_1_x = c;
                end
            end
            
            // In other states, isqrt_1 is either busy or not needed
        endcase
    end
    
    // Second isqrt module control (only used during parallel phase)
    always_comb begin
        isqrt_2_x_vld = 1'b0;
        isqrt_2_x = 32'hX;  // Don't care default
        
        case (state)
            ST_IDLE: begin
                if (arg_vld) begin
                    // Start second parallel computation (√b)
                    isqrt_2_x_vld = 1'b1;
                    isqrt_2_x = b;
                end
            end
            
            // isqrt_2 is only used for the parallel phase
            // After that, it remains idle
        endcase
    end

    //------------------------------------------------------------------------
    // Result Accumulation: Building the Final Answer
    //------------------------------------------------------------------------
    
    // Accumulate partial results as they become available
    always_ff @(posedge clk) begin
        if (rst) begin
            accumulated_sum <= 32'h0;
        end else begin
            case (state)
                ST_IDLE: begin
                    // Clear accumulator when starting new computation
                    accumulated_sum <= 32'h0;
                end
                
                ST_PARALLEL_PHASE: begin
                    if (isqrt_1_y_vld && isqrt_2_y_vld) begin
                        // Both parallel results ready: √a + √b
                        accumulated_sum <= 32'(isqrt_1_y) + 32'(isqrt_2_y);
                    end
                end
                
                // accumulated_sum holds its value during ST_FINAL_PHASE
            endcase
        end
    end
   
    // Generate final result value
    always_ff @(posedge clk) begin
        if (rst) begin
            res <= 32'h0;
        end else if (state == ST_FINAL_PHASE && isqrt_1_y_vld) begin
            // Final computation complete: (√a + √b) + √c
            res <= accumulated_sum + 32'(isqrt_1_y);
        end
    end

    //------------------------------------------------------------------------
    // Final Result Output: When Everything is Complete
    //------------------------------------------------------------------------
    
    // Generate result valid signal
    always_ff @(posedge clk) begin
        if (rst) begin
            res_vld <= 1'b0;
        end else begin
            // Result is valid for exactly one cycle when we reach ST_RESULT_READY
            res_vld <= (state == ST_RESULT_READY);
        end
    end
   /* 
    // Generate final result value
    always_ff @(posedge clk) begin
        if (rst) begin
            res <= 32'h0;
        end else if (state == ST_FINAL_PHASE && isqrt_1_y_vld) begin
            // Final computation complete: (√a + √b) + √c
            res <= accumulated_sum + 32'(isqrt_1_y);
        end
    end*/
endmodule