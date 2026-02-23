/*
======================================================================================
				Standard   : WIFI
				Block name : Generic FIFO
				Abdelrhman
======================================================================================
*/
//====================================================================================
module ram_demap #(parameter AD=14, DATA=1, MEM=16384)
(
	clk,
	reset,
	re,
	we,
	data_in,
	data_out,
	valid_out
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	input  [DATA-1:0] data_in;
	output [DATA-1:0] data_out;
	output valid_out;
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
	dummy_input_counter_demapper #(AD) input_counter	
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
	dummy_input_ram_demapper #(AD,DATA,MEM) input_ram	
	(
		.clk(clk),
		.reset(reset),
		.re(enable),
		.we(we),
		.read_address(read_address[AD-1:0]),
		.write_address(write_address[AD-1:0]),
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
			if((re==1) && (write_address!=read_address) && ((write_address-1)!=read_address))
				enable	<= 1;
			else
				enable	<= 0;
		end
	end
	//============================================================================
endmodule
//====================================================================================
module dummy_input_counter_demapper #(parameter AD=14)
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
			if (we)	
			begin
				write_address 	<= write_address +1;
				valid_out     	<= 0;
			end
			if (re)
			begin
				read_address  	<= read_address  +1;
				valid_out     	<= 1;
			end
			else
				valid_out     	<= 0;
		end	
		//====================================================================
	end
endmodule
//====================================================================================
module dummy_input_ram_demapper #(parameter AD=14, DATA=1, MEM=16384) 
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
	input  [AD-1:0] read_address;
	input  [AD-1:0] write_address;
	input  [DATA-1:0]  data_in;
	output [DATA-1:0] data_out;
	//============================================================================
	reg [DATA-1:0] ram [MEM-1:0];
	reg [DATA-1:0] data_out;
	//============================================================================
	always @(posedge clk)
	begin
		if (we)	ram[write_address] <= data_in;
	end
	always @(posedge clk or negedge reset)
	begin
		if (!reset)		data_out 	<= 0;
		else if (re)	data_out  	<= ram[read_address];
	end
	//============================================================================
endmodule
