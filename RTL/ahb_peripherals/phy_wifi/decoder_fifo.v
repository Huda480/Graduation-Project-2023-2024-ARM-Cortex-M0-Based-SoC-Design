/*
======================================================================================
				Standard   : WIFI
				Block name : Generic FIFO
======================================================================================
*/
//====================================================================================
module decoder_fifo #(parameter AD=14, DATA=1, MEM=16384)
(
	clk,
	reset,
	re,
	we,
	data_in,
	data_out,
	valid_out,
	write_address
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	input data_in;
	output [1:0] data_out;
	output valid_out;
	output [AD:0] write_address;
	//============================================================================
	wire clk;
	wire reset;
	wire re;
	wire we;
	wire data_in;
	wire [1:0]data_out;
	wire valid_out;
	wire [AD-1:0] read_address;
	wire [AD:0] write_address;
	reg enable;
	
	//============================================================================
	decoder_input_counter #(AD) input_counter	
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
	decoder_input_ram #(14,DATA,MEM) input_ram	
	(
		.clk1(clk),
		.clk2(clk),
		.reset(reset),
		.re(enable),
		.we(we),
		.read_address1(read_address),
		.read_address2(read_address+1),
		.write_address(write_address [AD-1:0]),
		.data_in(data_in),
		.data_out1(data_out[1]),
		.data_out2(data_out[0])
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
module decoder_input_counter #(parameter AD=14)
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
	output [AD:0] write_address;
	//============================================================================
	reg valid_out;
	reg finished;
	reg [AD-1:0] read_address;
	reg [AD:0] write_address;
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
				read_address  	<= read_address  +2;
				valid_out     	<= 1;
			end
			else	valid_out     	<= 0;
		end	
		//====================================================================
	end
endmodule
//====================================================================================
module decoder_input_ram #(parameter AD=15, DATA=1, MEM=16384) 
(
	clk1,
	clk2,
	reset,
	re,
	we,
	read_address1,
	read_address2,
	write_address,
	data_in,
	data_out1,
	data_out2
);
	//============================================================================
	input clk1;
	input clk2;
	input reset;
	input re;
	input we;
	input [AD-1:0] read_address1;
	input [AD-1:0] read_address2;
	input [AD-1:0] write_address;
	input data_in;
	output data_out1;
	output data_out2;
	//============================================================================
	reg [DATA-1:0] ram [MEM-1:0];
	reg data_out1,data_out2;
	//============================================================================
	always @(posedge clk1) 
	begin 
	   if (we)	ram[write_address] <= data_in;
	   if (re)  data_out1<=ram[read_address1];
	end
	always @(posedge clk2)
	begin 
         if (re) data_out2  	<= ram[read_address2];	
		//data_out  	<= {ram[read_address1],ram[read_address2]};
	end
	//============================================================================
endmodule
