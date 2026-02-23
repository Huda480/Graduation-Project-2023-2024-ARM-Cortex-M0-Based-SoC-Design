module control_depuncture34_wifi
(
	clk,
	reset,
	valid_in,
	data_in,
	data_write,
	re,
	we,
	valid_out,
	data_out
);
	input clk;
	input reset;
	input valid_in;
	input data_in;
	output reg we;
	output reg data_write;
	output reg re;
	output reg data_out;
	output reg valid_out;

	reg [15:0] counter_clkin;
	reg [15:0] counter_clkout;
	reg [2:0] pattern_counter;
	reg [5:0] counter;
	reg flag;
	reg valid_in_is_set;

	always @(posedge clk or negedge reset)
	begin
		if (!reset)
		begin
			re							<= 0;
			we							<= 0;
			flag 							<= 0;
			valid_in_is_set						<= 0;
			pattern_counter						<= 0;
			counter							<= 0;
			data_write						<= 0;
			counter_clkin						<= 0;
			counter_clkout						<= 0;
			valid_out						<= 0;
			data_out						<= 0;
		end
		else 
		begin
			if (valid_in)
			begin
				we						<= 1; 
				data_write					<= data_in; 
				counter_clkin					<= counter_clkin+1;
				valid_in_is_set					<= 1;
			end
			else if(valid_in_is_set)
			begin
				we						<= 0;
				if(counter_clkout==0 & flag ==0)
				begin
					counter_clkout				<= counter_clkin;
					flag					<= 1;
				end
				else if(counter_clkout==0 & flag ==1)
				begin
					counter_clkout                          <= 0;
					re					<= 0;
					valid_out				<= 0;
				end
				else
				begin
					counter_clkin				<= 0;
					counter_clkout				<= counter_clkout-1;

					if(counter<48)
					begin
						counter				<= counter+1;
						re				<= 1;
					end
					else
					begin
						if(pattern_counter==5)
						begin
							pattern_counter		<= 0;
							re			<= 1;
							valid_out		<= 0;
						end
						else
						begin
								$display("KK",pattern_counter);
							pattern_counter		<= pattern_counter+1;
							data_out		<= 0;

							if(pattern_counter==3 || pattern_counter==4)
							begin
								re		<= 0;
								valid_out	<= 1;
							end
							else
							begin
								$display("Hi");
								re		<= 1;
								valid_out	<= 0;
							end
						end
					end
				end
			end
			else
			begin
				re						<= 0;
				we						<= 0;
				flag 						<= 0;
				valid_in_is_set					<= 0;
				pattern_counter					<= 0;
				counter						<= 0;
				data_write					<= 0;
				counter_clkin					<= 0;
				counter_clkout					<= 0;
				valid_out					<= 0;
				data_out					<= 0;
			end
		end
	end 
endmodule
