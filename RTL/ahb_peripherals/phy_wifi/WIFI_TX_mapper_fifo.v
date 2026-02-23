/*
======================================================================================
				Standard   : WIFI
				Block name : Generic FIFO
======================================================================================
*/
//====================================================================================
module WIFI_TX_mapper_fifo #(parameter AD=14, DATA=1, MEM=16384)
(
	clk,
	reset,
	re,
	we,
	data_in,
	data_out,
	valid_out,
	finished,
	last_sym,
	re_out	
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	input data_in;
	output data_out;
	output valid_out;
	output finished;
	output last_sym;
	output re_out;
	//============================================================================
	wire clk;
	wire reset;
	wire re;
	wire we;
	wire data_in;
	wire data_out;
	wire valid_out;
	wire finished;
	wire last_sym;
	wire re_out;
	wire [AD-1:0] read_address;
	wire [AD-1:0] write_address;
	//============================================================================
	mapper_finish finish
	(
		.clk(clk),
		.reset(reset),
		.re(re),
		.we(we),
		.valid_out(valid_out),
		.read_address(read_address),
		.write_address(write_address),
		.finished(finished),
		.last_sym(last_sym),
		.re_out(re_out)
	);
	//============================================================================
	mapper_input_counter #(AD) input_counter	
	(
		.clk(clk),
		.reset(reset),
		.re(re_out),
		.we(we),
		.valid_out(valid_out),
		.read_address(read_address),
		.write_address(write_address)
	);	
	//============================================================================
	mapper_input_ram #(AD,DATA,MEM) input_ram	
	(
		.clk(clk),
		.reset(reset),
		.re(re_out),
		.we(we),
		.read_address(read_address),
		.write_address(write_address),
		.data_in(data_in),
		.data_out(data_out)
	);
	//============================================================================
endmodule
//====================================================================================
module mapper_finish #(parameter AD=14)
(
	clk,
	reset,
	re,
	we,
	valid_out,
	read_address,
	write_address,
	finished,
	last_sym,
	re_out
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	input valid_out;
	input [AD-1:0] read_address;
	input [AD-1:0] write_address;
	output finished;
	output last_sym;
	output re_out;
	//============================================================================
	reg finished;
	reg last_sym;
	reg re_out;
	reg flag;
	reg [2:0] last_sym_counter;
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if (!reset)
		begin
			finished		<= 1;
			re_out			<= 0;
			flag			<= 0;
			last_sym		<= 0;
			last_sym_counter	<= 0;
		end
		//====================================================================
		else
		begin
			//============================================================
			if (we)
				flag		<= 1;
			else if(!we && flag)
			begin
				finished	<= 0;
				flag		<= 0;
			end	
			if((re) && (write_address!=read_address) && ((write_address-1)!=read_address))
				re_out		<= 1;
			else
				re_out		<= 0;
			//============================================================
			if (((write_address-1)==read_address) && (we==0)) 
				last_sym 	<= 1;
			if( valid_out==0 && last_sym==1 && last_sym_counter==7)
			begin 
				last_sym 	<= 0;
				finished 	<= 1; 
				last_sym_counter<= 0;
			end
			else if (valid_out==0 && last_sym==1 && last_sym_counter<7)
				last_sym_counter<= last_sym_counter + 1;
			//============================================================
		end
		//====================================================================
	end
	//============================================================================
endmodule
//====================================================================================
module mapper_input_counter #(parameter AD=14)
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
				valid_out    	<= 1;
				read_address  	<= read_address  +1;
			end
			else	valid_out     	<= 0;
		end	
		//====================================================================
	end
endmodule
//====================================================================================
module mapper_input_ram #(parameter AD=14, DATA=1, MEM=16384) 
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
	always @(posedge clk) if (we) ram[write_address] <= data_in;
	always @(posedge clk or negedge reset)
	begin 
		if (!reset)	data_out 	<= 0;
		else if (re)	data_out  	<= ram[read_address];
	end
	//============================================================================
endmodule
