/*
======================================================================================
				Standard   : WIFI
				Block name : Interleaver FIFO
======================================================================================
*/
//====================================================================================
module WIFI_TXRX_interleaver_fifo #(parameter AD=16, DATA=1, MEM=65536)
(
	clk,
	reset,
	re,
	we,
	data_in,
	reset_enable,
	read_address,	 
	data_out,
	write_address
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	input data_in;
	input reset_enable;
	input [AD-1:0] read_address;
	output data_out;
	output [AD-1:0] write_address;
	//============================================================================
	wire clk;
	wire reset;
	wire re;
	wire we;
	wire data_in;
	wire data_out;
	wire [AD-1:0] w_address;
	//============================================================================
	input_counter_interleaver_wifi #(AD) input_counter	
	(
		.clk(clk),
		.reset(reset),
		.we(we),
		.reset_enable(reset_enable),
		.write_address(write_address),
		.w_address(w_address)
	);	
	//============================================================================
	input_ram_interleaver_wifi #(AD,DATA,MEM) input_ram
	(
		.clk(clk),
		.reset(reset),
		.re(re),
		.we(we),
		.read_address(read_address),
		.write_address(w_address),
		.data_in(data_in),
		.data_out(data_out)
	);
	//============================================================================
endmodule
//====================================================================================
module input_counter_interleaver_wifi #(parameter AD=16)
(
	clk,
	reset,
	we,
	reset_enable,
	write_address,
	w_address
);
	//============================================================================
	input clk;
	input reset;
	input we;
	input reset_enable;
	output [AD-1:0] write_address;
	output [AD-1:0] w_address;
	//============================================================================
	reg [AD-1:0] write_address;
	reg [AD-1:0] w_address;
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if (!reset)			w_address	<= 0;
		else
		begin
			if (we)			w_address 	<= w_address +1;
			if (reset_enable) 	w_address	<= 0;
		end	
		//====================================================================
		write_address	<= w_address;
	end
endmodule
//====================================================================================
module input_ram_interleaver_wifi #(parameter AD=16, DATA=1, MEM=65536) 
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
	input data_in;
	output data_out;
	//============================================================================
	reg [DATA-1:0] ram [0:MEM-1];
	reg data_out;
	//============================================================================
	always @(posedge clk) if (we) ram[write_address] <= data_in;
	always @(posedge clk or negedge reset)
	begin
		if (!reset)	data_out 	<= 0;
		else if (re)	data_out  	<= ram[read_address];
	end
	//============================================================================
endmodule
