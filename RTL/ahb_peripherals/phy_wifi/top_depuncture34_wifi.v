module top_depuncture34_wifi
(
	clk,
	reset,
	valid_in,
	data_in,
	valid_out,
	data_out
);
	input clk;
	input reset;
	input valid_in;
	input data_in;
	output valid_out;
	output data_out;

	wire re;
	wire we;
	wire data_write;
	wire controller_valid_out;
	wire controller_data_out;
	wire ram_valid_out;
	wire ram_data_out;

	control_depuncture34_wifi control_depuncture34_wifi
	(
		.clk(clk),
		.reset(reset),
		.valid_in(valid_in),
		.data_in(data_in),
		.data_write(data_write),
		.re(re),
		.we(we),
		.valid_out(controller_valid_out),
		.data_out(controller_data_out)
	);
	puncturer_fifo puncturer_fifo
	(
		.clk(clk),
		.reset(reset),
		.re(re),
		.we(we),
		.data_in(data_write),
		.data_out(ram_data_out),
		.valid_out(ram_valid_out)
		
	);

	assign valid_out 	= controller_valid_out || ram_valid_out;
	assign data_out		=(controller_valid_out) ? controller_data_out : (ram_valid_out) ? ram_data_out : 0;
	always@(posedge clk)
		if(reset & valid_out)	$display(controller_valid_out," ",controller_data_out," ",ram_data_out," ",data_out);
endmodule

