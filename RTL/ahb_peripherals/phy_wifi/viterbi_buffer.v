/*
======================================================================================
				Standard   : WIFI
				Block name : Generic FIFO
======================================================================================
*/
//====================================================================================
module viterbi_buffer #(parameter AD=13, DATA=1, MEM=8192)
(
	clk,
	reset,
	re,
	we,
	data_in,
	max_read_address,
	reset_all,
	data_out,
	valid_out,
	finished
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	input data_in;
	input [AD-1:0] max_read_address;
	output reset_all;
	output data_out;
	output valid_out;
	output finished;
	//============================================================================
	wire clk;
	wire reset;
	wire re;
	wire we;
	wire data_in;
	wire [AD-1:0] max_read_address;
	wire reset_all;
	wire data_out;
	wire valid_out;
	wire finished;
	wire [AD-1:0] read_address;
	wire [AD-1:0] write_address;
	reg enable;
	//============================================================================
	buffer_finish finish
	(
		.clk(clk),
		.reset(reset),
		.we(we),
		.valid_out(valid_out),
		.reset_all(reset_all),
		.finished(finished)
	);
	//============================================================================
	buffer_input_counter #(AD) input_counter	
	(
		.clk(clk),
		.reset(reset),
		.re(enable),
		.we(we),
		.max_read_address(max_read_address),
		.valid_out(valid_out),
		.read_address(read_address),
		.write_address(write_address)
	);	
	//============================================================================
	buffer_input_ram #(AD,DATA,MEM) input_ram	
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
			if((re==1) && (write_address!=read_address) && ((write_address-1)!=read_address))
				enable	<= 1;
			else
				enable	<= 0;
		end
	end
	//============================================================================
endmodule
//====================================================================================
module buffer_finish 
(
	clk,
	reset,
	we,
	valid_out,
	reset_all,
	finished
);
	//============================================================================
	input clk;
	input reset;
	input we;
	input valid_out;
	output reset_all;
	output finished;
	//============================================================================
	reg finished;
	reg reset_all;
	reg flag1;
	reg flag2;
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
		begin
			finished		<= 1;
			reset_all       <= 1;
		end
		else
		begin
			if (we)
				flag1		<= 1;
			else if(!we && flag1)
			begin
				finished	<= 0;
				flag1		<= 0;
			end	
			if(valid_out) 
				flag2		<= 1;
			else if(!valid_out && flag2)
			begin	
				finished	<= 1;
				flag2		<= 0;
				reset_all   <= 0;
			end
		end
	end
	//============================================================================
endmodule
//====================================================================================
module buffer_input_counter #(parameter AD=14)
(
	clk,
	reset,
	re,
	we,
	max_read_address,
	valid_out,
	read_address,
	write_address
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	input [AD-1:0] max_read_address;
	output valid_out;
	output [AD-1:0] read_address;
	output [AD-1:0] write_address;
	//============================================================================
	reg valid_out;
	reg finished;
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
			finished	<= 1;
		end
		//====================================================================
		else
		begin
			if (we)	write_address 	<= write_address +1;
			if (re && (read_address <= max_read_address) )
			begin
				read_address  	<= read_address  +1;
				valid_out     	<= 1;
			end
			else	valid_out     	<= 0;
		end	
		//====================================================================
	end
endmodule
//====================================================================================
module buffer_input_ram #(parameter AD=14, DATA=1, MEM=16384) 
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
	reg [DATA-1:0] ram [MEM-1:0];
	reg data_out;
	//============================================================================
	always @(posedge clk) if (we)	ram[write_address] <= data_in;
	always @(posedge clk or negedge reset)
	begin 
		if (!reset)	data_out 	<= 0;
		else if (re)	data_out  	<= ram[read_address];
	end
	//============================================================================
endmodule
