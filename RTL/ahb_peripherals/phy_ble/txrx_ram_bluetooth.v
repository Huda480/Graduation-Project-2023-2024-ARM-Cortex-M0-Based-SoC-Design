/*
======================================================================================
				Standard   : Bluetooth 
				Block name : RAM
				Modified By: Sherif Hosny
======================================================================================
*/
module mapper_ram_bt_ble #(parameter AD_PL_MAP=14, DATA_PL_MAP=1, MEM_PL_MAP=16384)
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
	input data_in;
	output data_out;
	output valid_out;
	//============================================================================
	wire clk;
	wire reset;
	wire re;
	wire we;
	wire data_in;
	wire data_out;
	wire valid_out;
	wire [AD_PL_MAP-1:0] read_address;
	wire [AD_PL_MAP-1:0] write_address;
	reg enable;
	//============================================================================
	mapper_input_counter_bt_ble #(AD_PL_MAP) input_counter	
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
	mapper_input_ram_bt_ble #(AD_PL_MAP,DATA_PL_MAP,MEM_PL_MAP) input_ram	
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
module mapper_input_counter_bt_ble #(parameter AD_PL_MAP=14)
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
	output [AD_PL_MAP-1:0] read_address;
	output [AD_PL_MAP-1:0] write_address;
	//============================================================================
	reg valid_out;
	reg [AD_PL_MAP-1:0] read_address;
	reg [AD_PL_MAP-1:0] write_address;
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
				valid_out     	<= 1;
				read_address  	<= read_address  +1;
			end
			else
			begin
				valid_out     	<= 0;
			end
		end	
		//====================================================================
	end
endmodule
//====================================================================================
module mapper_input_ram_bt_ble #(parameter AD_PL_MAP=14, DATA_PL_MAP=1, MEM_PL_MAP=16384) 
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
	input [AD_PL_MAP-1:0] read_address;
	input [AD_PL_MAP-1:0] write_address;
	input data_in;
	output data_out;
	//============================================================================
	reg [DATA_PL_MAP-1:0] ram [MEM_PL_MAP-1:0];
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
