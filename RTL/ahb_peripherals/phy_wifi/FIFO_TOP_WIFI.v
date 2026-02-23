
module FIFO_TOP_WIFI #(

	parameter ADDR_FIFO = 8,				// Address Width
	parameter DATA_WIDTH = 32,				// Data Width
	parameter DEPTH_FIFO = 200				// mem depth
)(

/////////////////
// Input Ports //
/////////////////
	input  wire 			 		 W_CLK,
	input  wire 			 		 R_CLK,
	input  wire 			 		 W_rst_n,
	input  wire 			 		 R_rst_n,
	input  wire 			 		 W_inc,
	input  wire 			 		 R_inc,
	input  wire              		 mode,
	input  wire              		 tx_irq,
	input  wire [ADDR_FIFO - 1 : 0] fifo_address,
	input  wire [DATA_WIDTH - 1 : 0] W_Data,
	input  wire [DATA_WIDTH - 1 : 0] data_size,


//////////////////
// Output Ports //
//////////////////
	output wire                      Full,
	output wire                      Empty,
	output wire [DATA_WIDTH - 1 : 0] R_Data,
	output wire [DATA_WIDTH - 1 : 0] R_Data_ahb


);




//-----------------
// Internal Wires
//-----------------
	wire [ADDR_FIFO - 1 : 0] W_Addr, R_Addr;
	wire [ADDR_FIFO - 1 : 0] w_addr_fifo,r_addr_fifo;
	wire [ADDR_FIFO     : 0] W_ptr, R_ptr, Wq2_rptr, Rq2_wptr;




//---------------------------------------------------------------
// 		Internal Modules Connections
//---------------------------------------------------------------

///////////////////////////////
//     1. Write Pointer	     //
///////////////////////////////

FIFO_Write_Pointer #(.ADDR_FIFO(ADDR_FIFO),.DATA_WIDTH(DATA_WIDTH)) FIFO_Write_Pointer_F1(

	.W_CLK(W_CLK), 
	.W_rst_n(W_rst_n),
	.W_inc(W_inc),
	.Wq2_rptr(Wq2_rptr),						 
	.tx_irq(tx_irq),
	.W_Full(Full),
	.W_ptr(W_ptr),								
	.W_Addr(W_Addr),
	.data_size(data_size)
	
);

assign w_addr_fifo = mode ? fifo_address : W_Addr;

///////////////////////////////
//	2. Read Pointer      //
///////////////////////////////

FIFO_R_Pointer #(.ADDR_FIFO(ADDR_FIFO), .DATA_WIDTH(DATA_WIDTH)) FIFO_R_Pointer_F2(

	.R_CLK(R_CLK),
	.R_rst_n(R_rst_n),
	.R_inc(R_inc),
	.Rq2_wptr(W_ptr),
	.tx_irq(tx_irq),
	.R_empty(Empty),
	.R_ptr(R_ptr),
	.R_Addr(R_Addr),
	.data_size(data_size)
	
);



assign r_addr_fifo = mode ? R_Addr : fifo_address ;

///////////////////////////////
// 	3. FIFO Memory       //
///////////////////////////////
(* dont_touch = "true" *)
FIFO_ASYNC_RAM_WIFI #(.ADDR_FIFO(ADDR_FIFO), .DATA_WIDTH(DATA_WIDTH), .DEPTH_FIFO(DEPTH_FIFO))  ASYNC_FIFO_RAM_F3(

	.W_CLK(W_CLK),
	.R_CLK(R_CLK),					
	.W_CLK_en(W_inc & ~Full),
	.R_CLK_en(R_inc),				
	.W_Data(W_Data),				
	.W_Addr(w_addr_fifo),				
	.R_Addr(r_addr_fifo),
	.R_Data(R_Data),
	.R_Data_ahb(R_Data_ahb)	

);

//////////////////////////////////////////////////////////////
//        4. Read Pointer Synchronizer to Write Clk         //
//////////////////////////////////////////////////////////////
FIFO_Sync_R2W #(.ADDR_FIFO(ADDR_FIFO)) Sync_R2W_F4(

	.W_CLK(W_CLK),					
	.W_rst_n(W_rst_n),				
	.R_ptr(R_ptr),					
	.Wq2_rptr(Wq2_rptr)				

);


//////////////////////////////////////////////////////////////
//        5. Write Pointer Synchronizer to Read Clk         //
//////////////////////////////////////////////////////////////

FIFO_Sync_W2R #(.ADDR_FIFO(ADDR_FIFO)) Sync_W2R_F5(
 
	.R_CLK(R_CLK),					
	.R_rst_n(W_rst_n),				
	.W_ptr(W_ptr),					
	.Rq2_wptr(Rq2_wptr)				
	
);

endmodule
