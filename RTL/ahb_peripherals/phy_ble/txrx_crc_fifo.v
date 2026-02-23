/*
======================================================================================
				Standard   : Bluetooth
				Block name : Generic FIFO
				Modified By: Ahmed Nagy & Sherif Hosny
======================================================================================
*/
//====================================================================================
module dummy_fifo_ble #(parameter AD=8, DATA=1, MEM=256)
(
	clk,
	reset,
	re,
	we,
	data_in,
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
	output data_out;
	output valid_out;
	output finished;
	//============================================================================
	wire clk;
	wire reset;
	wire re;
	wire we;
	wire data_in;
	wire data_out;
	wire valid_out;
	wire finished;
	wire [AD-1:0] read_address;
	wire [AD-1:0] write_address;
	reg enable;
	//============================================================================
	dummy_finish_ble finish
	(
		.clk(clk),
		.reset(reset),
		.we(we),
		.valid_out(valid_out),
		.finished(finished)
	);
	//============================================================================
	dummy_input_counter_ble #(AD) input_counter	
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
	dummy_input_ram_ble #(AD,DATA,MEM) input_ram	
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
module dummy_finish_ble 
(
	clk,
	reset,
	we,
	valid_out,
	finished
);
	//============================================================================
	input clk;
	input reset;
	input we;
	input valid_out;
	output finished;
	//============================================================================
	reg finished;
	reg flag1;
	reg flag2;
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
			finished		<= 1;
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
			end
		end
	end
	//============================================================================
endmodule
//====================================================================================
module dummy_input_counter_ble #(parameter AD=14)
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
//====================================================================================
module dummy_input_ram_ble #(parameter AD=14, DATA=1, MEM=16384) 
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
	always @(posedge clk)
	begin
		if (we)	ram[write_address] <= data_in;
	end
	always @(posedge clk or negedge reset)
	begin
		if (!reset)	data_out 	<= 0;
		else if (re)	data_out  	<= ram[read_address];
	end
	//============================================================================
endmodule
