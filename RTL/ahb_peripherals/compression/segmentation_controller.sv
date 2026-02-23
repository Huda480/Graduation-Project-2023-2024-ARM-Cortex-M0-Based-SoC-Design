//===========================================================
// Purpose: Image segmentation
// Used in: 
//===========================================================
(* dont_touch = "true" *)module segmentation_controller import segmentation_pkg::*;
#(
  parameter int DEPTH = 8192         ,
  parameter int ADDR  = $clog2(DEPTH),
  parameter int DIM   = 8
) (
  //=======================================================
  // Controls
  //=======================================================
  input  logic            clk      ,
  input  logic            rst_n    ,
  //=======================================================
  // Inputs
  //=======================================================
  input  logic            enable   ,
  //=======================================================
  // Outputs
  //=======================================================
  output logic            valid_out,
  output logic            finished ,
  output logic [ADDR-1:0] addr_out
  //=======================================================
);
  //=======================================================
  // Internals
  //=======================================================
  logic [ADDR-1:0]  addr_reg     ;
  logic [   3:0]    counter      ;
  states_t          state;
  states_t          next_state   ;
  //=======================================================
  // Current State Register
  //=======================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      state <= IDLE;
    else
      state <= next_state;
  end
  //=======================================================
  // Next State Combinational block
  //=======================================================
  always_comb
    begin
      //===================================================
      // Current state selection
      //===================================================
      case(state)
        //===============================================
        // IDLE state
        //===============================================
        IDLE :
          begin
            //valid_out = 1'b0;
            //finished  = 1'b0;
            if(enable)
              next_state = TRANSMIT;
            else
              next_state = IDLE;
          end
        //===============================================
        // TRANSMIT state
        //===============================================
        TRANSMIT :
          begin
           // valid_out = 1'b1;
            if(counter == (DIM)) begin
            //  finished = 1'b1;
              next_state = IDLE;
            end
            else begin
            //  finished = 1'b0;
              next_state = TRANSMIT;
            end
          end
        //===============================================
      endcase
      //===================================================
    end
  //=======================================================
  // Outputs Combinational block
  //=======================================================
  always_comb
    begin
      //===================================================
      // Current state selection
      //===================================================
      case(state)
        //===============================================
        // IDLE state
        //===============================================
        IDLE :
          begin
            valid_out = 1'b0;
            finished  = 1'b0;
          end
        //===============================================
        // TRANSMIT state
        //===============================================
        TRANSMIT :
          begin
            valid_out = 1'b1;
            if(counter == (DIM))
              finished = 1'b1;
            else
              finished = 1'b0;
          end
        //===============================================
      endcase
      //===================================================
    end
  //=======================================================
  // Internal Counter
  //=======================================================
  always_ff @(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      counter <= 'b0;
    else if (enable)
    //begin
		  counter <= counter + 1'b1;
	  else
		counter <= 'b0;
	end
  //end
  //=======================================================
  // Memory Address
  //=======================================================
  always_ff @(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      addr_out <= 'b0;
    else if (enable)
      addr_out <= addr_out + 1'b1;
  end

  //assign valid_out = ((counter != 9) && (counter != 0));
  //assign addr_out = addr_reg;   // Actual Memory address
  //=======================================================
endmodule