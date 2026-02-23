module FIFO_Write_Pointer_ble #(

	parameter ADDR_WIDTH = 4
	
)(

	input  wire 					 W_CLK, 
	input  wire 					 W_rst_n,
	input  wire 					 W_inc,
	input  wire [ADDR_WIDTH     : 0] Wq2_rptr,						// Synchronized Read pointer  
	input  wire                      tx_irq, 
	input  wire [16:0]               data_size,
	input  wire [16:0]               W_Addr_bits,  
	output wire 				     FULL_VALUE,
	output wire  [ADDR_WIDTH     : 0] W_ptr,							// Binary write pointer that needs to be converted to Gray one		
	output      [ADDR_WIDTH - 1 : 0] W_Addr	
);

	reg  [ADDR_WIDTH: 0] Binary_W_ptr;								// Binary Value of the Write Pointer 
	wire [ADDR_WIDTH: 0] Gray_W_ptr , Binary_W_ptr_next;			// Gray Value of the Write Pointer
	
	
	
	always @(posedge W_CLK or negedge W_rst_n)
	begin
	    //this condition checks if the needed data are written in the fifo or not to reset the pointers
		if (!W_rst_n)
		begin
			Binary_W_ptr <= 0;
		end
		
		else if (~FULL_VALUE && W_inc ) begin
			if(W_Addr_bits >= data_size )
			begin
				Binary_W_ptr[ADDR_WIDTH - 1 : 0] <= 0;
				Binary_W_ptr[ADDR_WIDTH]         <= ~ Binary_W_ptr[ADDR_WIDTH];
			end
			else
			begin
				Binary_W_ptr <= Binary_W_ptr + 1'b1;
			end
		end
	end
	
	assign FULL_VALUE        = (W_ptr[ADDR_WIDTH]!= Wq2_rptr[ADDR_WIDTH])&&                           // MSB of Write Pointer differs from MSB of the Read Pointer
							   (W_ptr[ADDR_WIDTH-1]!= Wq2_rptr[ADDR_WIDTH - 1]) &&                    
							   (W_ptr[ADDR_WIDTH-2 : 0] == Wq2_rptr[ADDR_WIDTH - 2 : 0]);
							   
	assign W_Addr 			 = Binary_W_ptr[ADDR_WIDTH - 1 : 0];					// Binary Memory Address				
	assign W_ptr 	     = (Binary_W_ptr >> 1) ^ Binary_W_ptr;		// Binary to Gray Conversion
	
	
	

endmodule