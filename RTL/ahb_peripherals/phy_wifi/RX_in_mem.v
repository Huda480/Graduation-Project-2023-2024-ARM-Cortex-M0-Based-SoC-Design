module RX_in_mem #(parameter AD=14, DATA=12, MEM=8000) (
    clk,
	reset,
    re,
	we,
	data_in,
	data_out,
	valid_out
);

//============================================================================
	input                   clk;
	input                   reset;
	input                   re;
	input                   we;
	input      [DATA-1:0]   data_in;
	output     [DATA-1:0]   data_out;
	output                  valid_out;
//============================================================================
wire clk;
wire reset;
wire re;
wire we;
wire [DATA-1:0] data_in;
wire [DATA-1:0] data_out;
wire valid_out;
wire [AD-1:0] read_address;
wire [AD-1:0] write_address;
reg enable;
//============================================================================

//============================================================================
input_counter #(AD) input_counter	
(
	.clk(clk),
	.reset(reset),
	.re(enable),
	.we(we),
	.valid_out(valid_out),
	.read_address(read_address),
	.write_address(write_address)
);	
//============================================================================


input_ram input_ram 
(
	.clk(clk),
	.reset(reset),
	.re(enable),
	.we(we),
	.read_address(read_address),
	.write_address(write_address),
	.data_in(data_in),
	.data_out(data_out)
);


//============================================================================
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
			enable	<= 0;
		else
		begin
			if ((write_address > read_address) && ( read_address != (write_address-1)))
				enable	<= 1;
			else
				enable	<= 0;
		end
	end
//============================================================================



    
endmodule

module input_counter #(parameter AD=14)
(
	clk,
	reset,
	re,
	we,
	valid_out,
	read_address,
	write_address
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	output valid_out;
	output [AD-1:0] read_address;
	output [AD-1:0] write_address;
	//============================================================================
	reg valid_out;
	
	reg [AD-1:0] read_address;
	reg [AD-1:0] write_address;
	//============================================================================
    
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if (!reset)
		begin
                        read_address  	<= 0;
			            write_address	<= 0;
                        valid_out    	<= 0;
			
		end
		//====================================================================
		else
		begin
			if (we)	write_address 	<= write_address +1;
			if (re)
			begin
				read_address  	<= read_address  +1;
				valid_out     	<= 1;
			end
			else	valid_out     	<= 0;
		end	
		//====================================================================
	end
endmodule

module input_ram #(parameter AD=14, DATA=12, MEM=8000) 
(
	clk,
	reset,
	re,
	we,
	read_address,
	write_address,
	data_in,
	data_out
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	input [AD-1:0] read_address;
	input [AD-1:0] write_address;
	input [DATA-1:0] data_in;
	output [DATA-1:0] data_out;
	//============================================================================
	reg [DATA-1:0] ram [MEM-1:0];
	reg [DATA-1:0]data_out;
	//============================================================================
	always @(posedge clk) if (we)	ram[write_address] <= data_in;
	always @(posedge clk or negedge reset)
	begin 
		if (!reset)	data_out 	<= 0;
		else if (re)   data_out  	<= ram[read_address];
	end
	//============================================================================
endmodule