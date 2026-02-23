module WIFI_TX_convolutionHalf
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
	output [1:0] data_out;	

	reg [5:0] state;
	reg valid_out;
	reg [1:0] data_out;

	always @(posedge clk or negedge reset)
	begin
		if (!reset)
		begin
			state		<= 0;
			data_out 	<= 0;
			valid_out	<= 0;
		end
		else
		begin 
			valid_out 	<= valid_in;

			if(valid_in)
			begin
				state[5] 	<= data_in;
				state[4] 	<= state[5];
				state[3] 	<= state[4];
				state[2]	<= state[3];
				state[1] 	<= state[2];
				state[0] 	<= state[1];
			
				data_out[0]	<= data_in ^ state[5] ^ state[4] ^ state[3] ^ state[0];	//171 octal
				data_out[1]	<= data_in ^ state[4] ^ state[3] ^ state[1] ^ state[0];	//133 octal
			end
		end
	end
endmodule
