/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Finish Signal Generator
				Modified By: Sherif Hosny
======================================================================================
*/
module finish_generator_ble 
(
	clk,
	reset,
	we,
	valid_out,
	finished
);
	//------------------------------------------------------------------------------
	input clk;
	input reset;
	input we;
	input valid_out;
	output reg finished;
	//------------------------------------------------------------------------------
	reg flag1;
	reg flag2;
	//------------------------------------------------------------------------------
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
	//------------------------------------------------------------------------------
endmodule