/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Repetition code encoder
				Modified By: Eslam Elnader
======================================================================================
*/
module repetition_encoder_ble #(parameter AD=7, DATA=1, MEM=128)
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
	wire [AD-1:0] read_address;
	wire [AD-1:0] write_address;
	wire [1:0] read_counter;
	reg enable;
	//============================================================================
	headerEnc_input_counter_ble #(AD) input_counter	
	(
		.clk(clk),
		.reset(reset),
		.re(enable),
		.we(we),
		.valid_out(valid_out),
		.read_address(read_address),
		.reading_counter(read_counter),
		.write_address(write_address)
	);	
	//============================================================================
	headerEnc_input_ram_ble #(AD,DATA,MEM) input_ram	
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
				if (read_counter==2'b10) enable	<= 0;
		end
	end
	//============================================================================
endmodule

//====================================================================================
module headerEnc_input_counter_ble #(parameter AD=14)
(
	clk,
	reset,
	re,
	we,
	valid_out,
	read_address,
	reading_counter,
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
	output [1:0] reading_counter;
	//============================================================================
	reg valid_out;
	reg [AD-1:0] read_address;
	reg [AD-1:0] write_address;
	reg [1:0] reading_counter;
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if (!reset)
		begin
            read_address  	<= 0;
			write_address	<= 0;
            valid_out    	<= 0;
			reading_counter <= 2'b0;
		end
		//====================================================================
		else
		begin
			if (we)	write_address 	<= write_address +1;
			if (re)
			begin
				reading_counter <= reading_counter +1;
				valid_out     	<= 1;
				if(reading_counter == 2'b10)
				begin
					read_address  	<= read_address  +1;
					reading_counter <= 2'b0;
				end
			end
			else
			begin
				reading_counter <= 2'b0;
				valid_out     	<= 0;
			end
		end	
		//====================================================================
	end
endmodule
//====================================================================================
module headerEnc_input_ram_ble #(parameter AD=14, DATA=1, MEM=16384) 
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
