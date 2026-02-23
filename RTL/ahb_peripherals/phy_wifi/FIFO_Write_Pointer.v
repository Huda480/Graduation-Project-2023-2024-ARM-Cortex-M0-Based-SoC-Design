
module FIFO_Write_Pointer #(

	parameter ADDR_FIFO = 4,
	parameter DATA_WIDTH = 32
	
)(

	input  wire 					 W_CLK, 
	input  wire 					 W_rst_n,
	input  wire 					 W_inc,
	input  wire                      tx_irq,
	input  wire [ADDR_FIFO     : 0] Wq2_rptr,						// Synchronized Read pointer  
	input wire [DATA_WIDTH-1:0] data_size,
	
	output wire 						 W_Full,
	output wire  [ADDR_FIFO     : 0] W_ptr,							// Binary write pointer that needs to be converted to Gray one		
	output      [ADDR_FIFO - 1 : 0] W_Addr
	
);

	reg  [ADDR_FIFO: 0] Binary_W_ptr;								// Binary Value of the Write Pointer 
	wire [ADDR_FIFO: 0] Binary_W_ptr_next;			// Gray Value of the Write Pointer


	wire [ADDR_FIFO + 5 : 0] shifted_pointer ;

	assign shifted_pointer = Binary_W_ptr[ADDR_FIFO-1:0] << 5;
	
	always @(posedge W_CLK or negedge W_rst_n)
	begin
	
		if (!W_rst_n )
		begin
			Binary_W_ptr <= 'b0;
			
			
		end
		else if(W_inc && !W_Full)
		begin
			if(shifted_pointer >= (data_size-32'd32) )
			begin
				Binary_W_ptr [ADDR_FIFO-1:0] <= 0;
				Binary_W_ptr[ADDR_FIFO] <= ~Binary_W_ptr[ADDR_FIFO];
			end
			else
			begin
				Binary_W_ptr <= Binary_W_ptr + 1'b1;
			end 
		end
	end
	
	//Full flag for fifo
	assign W_Full        = (W_ptr[ADDR_FIFO]!= Wq2_rptr[ADDR_FIFO])&&           
							   (W_ptr[ADDR_FIFO-1]!= Wq2_rptr[ADDR_FIFO - 1]) &&                    
							   (W_ptr[ADDR_FIFO-2 : 0] == Wq2_rptr[ADDR_FIFO - 2 : 0]);				   
	assign W_Addr 			 = Binary_W_ptr[ADDR_FIFO - 1 : 0];					// Binary Memory Address				
	assign W_ptr 	     = (Binary_W_ptr >> 1) ^ Binary_W_ptr;		// Binary to Gray Conversion
	
endmodule
