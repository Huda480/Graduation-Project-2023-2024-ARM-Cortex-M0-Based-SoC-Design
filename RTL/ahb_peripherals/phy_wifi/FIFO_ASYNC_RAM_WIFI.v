module FIFO_ASYNC_RAM_WIFI #(

	parameter ADDR_FIFO = 4,						// Address Width
	parameter DATA_WIDTH = 8,						// Data Width
	parameter DEPTH_FIFO = 200
	

)(

// INPUTs
	input  wire			             W_CLK,			// Write Side Clock
	input  wire			             R_CLK,			// Read Side Clock
	input  wire 			         W_CLK_en,		// Write Enable 
	input  wire 			         R_CLK_en,		// Read Enable
	input  wire [DATA_WIDTH - 1 : 0] W_Data,		// Data to be written into the Memory
	input  wire [ADDR_FIFO - 1 : 0]  W_Addr,		// Write Pointer Address
	input  wire [ADDR_FIFO - 1 : 0]  R_Addr,		// Read Pointer Address
// Outputs
	output reg  [DATA_WIDTH - 1 : 0] R_Data,	    // Data to be read form the Memory
	output wire  [DATA_WIDTH - 1 : 0] R_Data_ahb	
	


);


// Memory Packed Array  
	reg [DATA_WIDTH - 1 : 0] MEM [ 0 : DEPTH_FIFO - 1];			// 2-D Memory Width * Depth
	
	
// Writing Operation
	always @(posedge W_CLK )
	begin
	
		if(W_CLK_en)
			begin
				MEM[W_Addr] <= W_Data;
			end
		

	end


// Reading Operation	
	always @(posedge R_CLK )
	begin
	
	
		if(R_CLK_en)
			begin
				R_Data <= MEM[R_Addr]; 
			end

	end

assign R_Data_ahb = MEM[R_Addr];



endmodule 