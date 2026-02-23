module FIFO_R_Pointer #(

	parameter ADDR_FIFO = 4,
	parameter DATA_WIDTH = 32

)(

//////////////////
// 	  INPUTs 	//
//////////////////
	input  wire 		      R_CLK,
	input  wire 		      R_rst_n,
	input  wire 		      R_inc,
	input  wire               tx_irq,
	input  wire [ADDR_FIFO  : 0] Rq2_wptr,						// Synchronized Write Pointer (synchronized to Read CLK) 
	input wire [DATA_WIDTH-1:0] data_size,


//////////////////
// 	 OUTPUTs	//
//////////////////
	output wire 			 R_empty,
	output wire  [ADDR_FIFO     : 0] R_ptr,
	output wire [ADDR_FIFO - 1 : 0] R_Addr
	
);

//------------------------------
// Internal Registers and Wires
//------------------------------

	reg  [ADDR_FIFO : 0] Binary_R_ptr;
	wire [ADDR_FIFO + 5 : 0] shifted_pointer ;

	assign shifted_pointer = Binary_R_ptr[ADDR_FIFO-1:0] << 5;
	
	
//---------------------------------------------------------------------------
// FIFO is Empty when the next rptr == synchronized write pointer or on reset
//---------------------------------------------------------------------------
	
	assign R_empty = (R_ptr == Rq2_wptr);



//---------------------------------------------------------------
// Behavioral Modelling of Read Pointer
//---------------------------------------------------------------	
	always @(posedge R_CLK or negedge R_rst_n)
	begin 
	
		if (!R_rst_n )
		begin
		
			Binary_R_ptr <= 'b0;
			
		end
		
		else if(R_inc && !R_empty)
		begin
			if(shifted_pointer >= (data_size-32'd32))
			begin
				Binary_R_ptr[ADDR_FIFO-1:0] <= 0;
				Binary_R_ptr[ADDR_FIFO] <= ~Binary_R_ptr[ADDR_FIFO]; 
			end
			else
			begin
				Binary_R_ptr <= Binary_R_ptr + 1'b1;
			end
		end
	end
	

assign R_Addr            = Binary_R_ptr[ADDR_FIFO - 1 : 0];							// Binary Memory read address
assign R_ptr 		 = (Binary_R_ptr >> 1) ^ Binary_R_ptr;				// Converting the Read Pointer from Binary to Gray

endmodule