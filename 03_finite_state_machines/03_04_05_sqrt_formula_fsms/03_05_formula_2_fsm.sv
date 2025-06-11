//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_fsm
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

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);
    // Task:
    // Implement a module that calculates the formula from the `formula_2_fn.svh` file
    // using only one instance of the isqrt module.
    //
    // Design the FSM to calculate answer step-by-step and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm

   typedef enum logic [2:0] {
        ST_IDLE            = 'd0,  // Ready to accept new computation
        ST_FIRST_INPUT     = 'd1,  // Computing C
        ST_SECOND_INPUT    = 'd2,  // Computing b + √c
        ST_THIRD_INPUT     = 'd3,  // Computing √(a+√(b+√c))
        ST_RESULT_READY    = 'd4   // Result ready, outputting for one cycle
    } state_t;
    
    state_t state, next_state;
// driven by output formula. Then on the next state, formula input is driven by sum of wire and b. 

    //------------------------------------------------------------------------
    // Internal storage for intermediate results
    //------------------------------------------------------------------------
    
    // We need to store the results from the parallel phase
    // until we can add the final result
    //logic [31:0] accumulated_sum;  // Stores √a + √b

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
                    next_state = ST_FIRST_INPUT;
                end
            end
            
            ST_FIRST_INPUT: begin
                // Both isqrt modules should complete simultaneously due to fixed latency
                // We only transition when BOTH results are valid
                if (isqrt_y_vld) begin
                    next_state = ST_SECOND_INPUT;
                end
                // Note: With fixed latency, this condition should always be true together
                // But defensive programming suggests checking both
            end

            ST_SECOND_INPUT: begin
                // Both isqrt modules should complete simultaneously due to fixed latency
                // We only transition when BOTH results are valid
                if (isqrt_y_vld) begin
                    next_state = ST_THIRD_INPUT;
                end
                // Note: With fixed latency, this condition should always be true together
                // But defensive programming suggests checking both
            end

            ST_THIRD_INPUT: begin
                // Both isqrt modules should complete simultaneously due to fixed latency
                // We only transition when BOTH results are valid
                if (isqrt_y_vld) begin
                    next_state = ST_RESULT_READY;
                end
                // Note: With fixed latency, this condition should always be true together
                // But defensive programming suggests checking both
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
        isqrt_x_vld = 1'b0;
        isqrt_x     = 32'hX;  // Don't care default
        
        case (state)
            ST_IDLE: begin
                if (arg_vld) begin
                    // Start first parallel computation (√a)
                    isqrt_x_vld = 1'b1;
                    isqrt_x = c;
                end
            end
            
            ST_FIRST_INPUT: begin
                if (isqrt_y_vld) begin
                    // Both parallel computations done, start final computation (√c)
                    isqrt_x_vld = 1'b1;
                    isqrt_x = b + 32'(isqrt_y);
                end
            end

            ST_SECOND_INPUT: begin
                if (isqrt_y_vld) begin
                    // Both parallel computations done, start final computation (√c)
                    isqrt_x_vld = 1'b1;
                    isqrt_x = a + 32'(isqrt_y);
                end
            end

        endcase
    end
   
    // Generate final result value
    always_ff @(posedge clk) begin
        if (rst) begin
            res <= 32'h0;
        end else if (state == ST_THIRD_INPUT && isqrt_y_vld) begin
            // Final computation complete: (√a + √b) + √c
            res <= isqrt_y;
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
endmodule
