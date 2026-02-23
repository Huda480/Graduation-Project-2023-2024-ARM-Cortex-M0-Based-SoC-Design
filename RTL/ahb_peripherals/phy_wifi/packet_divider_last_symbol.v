module packet_divider
(
	clk,
	valid_in,
	reset,
	data_in_re,
	data_in_im,
	data_out_re,
	data_out_im,
	valid_out,
	last_symbol
);
	//============================================================================
	input		  		clk;
	input		  		valid_in;
	input		  		reset;
	input  [11:0] 		data_in_re;
	input  [11:0] 		data_in_im;
	output reg [11:0] 	data_out_re;
	output reg [11:0] 	data_out_im;
	output reg		  	valid_out;
	output reg		  	last_symbol;
	//============================================================================
	reg [8:0] counter=322;		//To get rid of the preamble in the begining of the frame 
	reg flag_last_symbol;      // To know the last symbol
	reg [8:0] counter_last;	   // To make sure that fft is working till last 64 symbols outgone from the RAM
	//============================================================================
	always @(posedge clk or  negedge reset) 
	begin
		if(reset == 0)
		begin
			valid_out		<=0;
			last_symbol		<=0;
			counter 		<=322;
			flag_last_symbol<=0;
			counter_last 	<=0;
		end
		//=======================================================================
		else
		begin
			if(valid_in == 1)
			begin
				if(counter == 0)
				begin
					valid_out 		<=1;
					data_out_re 	<=data_in_re;
					data_out_im 	<=data_in_im;
					flag_last_symbol<=1;
				end
				else
					counter <= counter-1;
			end 
			//=======================================================================
			else if(valid_in == 0)
			begin
				valid_out 			<=0;
				if(counter_last == 91)
                begin
                    flag_last_symbol<=0;
                    last_symbol 	<=0;
                end
				else if(last_symbol == 1)
				begin
					counter_last 	<=counter_last + 1'b1;
				end
			end
			//=======================================================================
			if(flag_last_symbol== 1 && valid_out== 0)
				last_symbol			<=1;
			end
end
endmodule