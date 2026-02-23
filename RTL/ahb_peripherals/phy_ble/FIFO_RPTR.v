module FIFO_R_Pointer_ble #(

	parameter ADDR_WIDTH = 4

)(

//////////////////
// 	  INPUTs 	//
//////////////////
	input  wire 		         R_CLK,
	input  wire 		         R_rst_n,
	input  wire 		         R_inc,
	input  wire [ADDR_WIDTH:0]   Rq2_wptr,		// Synchronized Write Pointer (synchronized to Read CLK) 
    input  wire                  tx_irq,
    input  wire [16:0]           data_size,
//////////////////
// 	 OUTPUTs	//
//////////////////
	output reg 			 R_empty,
	output wire  [ADDR_WIDTH     : 0] R_ptr,
	output wire [ADDR_WIDTH - 1 : 0] R_Addr,
	output wire                      Empty_Value
	
);

//------------------------------
// Internal Registers and Wires
//------------------------------

	reg  [ADDR_WIDTH : 0] Binary_R_ptr;
		
	wire [ADDR_WIDTH+5:0]           Binary_R_ptr_bits;
	
	assign Binary_R_ptr_bits = Binary_R_ptr[ADDR_WIDTH-1:0]<<5;
//---------------------------------------------------------------------------
// FIFO is Empty when the next rptr == synchronized write pointer or on reset
//---------------------------------------------------------------------------
	//Rq2_wptr is synchronized write pointer to the R_CLK which id much delayed when operating on read clk freq with much difference from write clk freq
	assign Empty_Value = (R_ptr == Rq2_wptr);



//---------------------------------------------------------------
// Behavioral Modelling of Read Pointer
//---------------------------------------------------------------	
	always @(posedge R_CLK or negedge R_rst_n)
	begin 
	
		if (!R_rst_n )
		begin
			Binary_R_ptr <= 0;
		end
		
		else if ( R_inc && ~Empty_Value ) begin
			if(Binary_R_ptr_bits >= data_size )
			begin
				Binary_R_ptr[ADDR_WIDTH - 1 : 0] <= 0;
				Binary_R_ptr[ADDR_WIDTH] <= ~ Binary_R_ptr[ADDR_WIDTH];
			end
			else
			begin
				Binary_R_ptr <= Binary_R_ptr + 1'b1;
			end
		end
	end

	always @(posedge R_CLK or negedge R_rst_n)
	begin
		if (!R_rst_n)
		begin
			R_empty <= 1'b1;
		end
		else
		begin
			R_empty <= Empty_Value;
		end
	end
	

assign R_Addr            = Binary_R_ptr[ADDR_WIDTH - 1 : 0];							// Binary Memory read address
assign R_ptr 		 = (Binary_R_ptr >> 1) ^ Binary_R_ptr;								// Converting the Read Pointer from Binary to Gray

endmodule
