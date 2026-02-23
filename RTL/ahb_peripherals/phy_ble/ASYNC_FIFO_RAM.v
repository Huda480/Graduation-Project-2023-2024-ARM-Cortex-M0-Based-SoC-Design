module ASYNC_FIFO_RAM_ble #(

	parameter ADDR_WIDTH = 4,						// Address Width
	parameter DATA_WIDTH = 8						// Data Width

)(

// INPUTs
	input  wire			     W_CLK,					// Write Side Clock
	input  wire              R_CLK,
	input  wire 			 W_CLK_en,				// Write Enable 
	input  wire              R_CLK_en,
	input  wire [DATA_WIDTH - 1 : 0] W_Data,				// Data to be written into the Memory
	input  wire [ADDR_WIDTH - 1 : 0] W_Addr,				// Write Pointer Address
	input  wire [ADDR_WIDTH - 1 : 0] R_Addr,				// Read Pointer Address
	
// Outputs
	output reg [DATA_WIDTH - 1 : 0] R_Data					// Data to be read form the Memory

);


// FIFO_DEPTH is multiple of power 2
	localparam FIFO_DEPTH = 1 << ADDR_WIDTH;
 
// Memory Packed Array  
	reg [DATA_WIDTH - 1 : 0] MEM [ 0 : FIFO_DEPTH - 1];			// 2-D Memory Width * Depth
	
	
// Writing Operation
	always @(posedge W_CLK)
	begin
	
		if(W_CLK_en)
			begin
				MEM[W_Addr] <= W_Data;
			end
	end
	
// Reading Operation
	always @(posedge R_CLK)
	begin
	
		if(R_CLK_en)
			begin
				R_Data <= MEM[R_Addr];
			end
	end	

endmodule 
