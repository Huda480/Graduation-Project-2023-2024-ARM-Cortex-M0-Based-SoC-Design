module stack_controller
(
	clk,
	reset,
	valid_in,
	special_index,
	last_symbol,
	data_in_real,
	data_in_imag,
	valid_out,
	data_out_real,
	stop_flag,
	data_out_imag
);
	//============================================================================
	input 		clk;
	input 		reset;
	input 		valid_in;
	input [5:0]	special_index;
	input 		last_symbol;
	input [11:0] data_in_real;
	input [11:0] data_in_imag;
	output 		valid_out;
	(* dont_touch = "yes" *) output [11:0] data_out_real;
	output reg         stop_flag;
	(* dont_touch = "yes" *) output [11:0] data_out_imag;
	//============================================================================
	reg 		read_A;
	reg 		read_B;
	reg 		write_A;
	reg 		write_B;
	wire [11:0] data_real_in_A;
	wire [11:0] data_imag_in_A;
	wire [11:0] data_real_out_A;
	wire [11:0] data_imag_out_A;
	wire [11:0] data_real_in_B;
	wire [11:0] data_imag_in_B;
	wire [11:0] data_real_out_B;
	wire [11:0] data_imag_out_B;
	wire 		valid_out_A;
	wire 		valid_out_B;
	wire 		valid_out_A_i;
    wire        valid_out_B_i;
	reg			memory_switch;
	reg			memory_switch_out;	// 1 read form b
	reg			flag_valid;	// for the logic of valid_out
	reg			delay_clk;
	reg	[6:0]	counter_first_read;	// for first read from the stack
	reg [5:0]	counter_write;		// to switch writing
	reg [5:0]	counter_write_out;	// for the valid_out of the stacks
	reg			last_flag;
	reg 		flag_stop;		//	to catch the last symbol when it turned to 1
	reg	[8:0]	counter_read;	// for the last read
	//============================================================================
	wire [5:0]		pilot_add_1 = 6'b000111;	//7
	wire [5:0]		pilot_add_2 = 6'b010101;	//21
	wire [5:0]		pilot_add_3 = 6'b111001;	//57
	wire [5:0]		pilot_add_4 = 6'b101011;	//43
	wire [5:0]		zero_add    = 6'b000000;	//0
	wire [5:0]		nulls_start = 6'b011011;	//27
	wire [5:0]		nulls_end   = 6'b100101;	//37
	//============================================================================
	(* keep_hierarchy = "yes" *)
	stack_mapper #(16, 12, 48) Stack_A_real
	(
		.clk(clk),
		.reset(reset),
		.re(read_A),
		.we(write_A),
		.data_in(data_real_in_A),
		.data_out(data_real_out_A),
		.valid_out(valid_out_A)
	);	
	(* keep_hierarchy = "yes" *)
	stack_mapper #(16, 12, 48) Stack_A_imag
	(
		.clk(clk),
		.reset(reset),
		.re(read_A),
		.we(write_A),
		.data_in(data_imag_in_A),
		.data_out(data_imag_out_A),
		.valid_out(valid_out_A_i)
	);
	(* keep_hierarchy = "yes" *)
	stack_mapper #(16, 12, 48) Stack_B_real
	(
		.clk(clk),
		.reset(reset),
		.re(read_B),
		.we(write_B),
		.data_in(data_real_in_B),
		.data_out(data_real_out_B),
		.valid_out(valid_out_B)
	);
	(* keep_hierarchy = "yes" *)
	stack_mapper #(16, 12, 48) Stack_B_imag
	(
		.clk(clk),
		.reset(reset),
		.re(read_B),
		.we(write_B),
		.data_in(data_imag_in_B),
		.data_out(data_imag_out_B),
		.valid_out(valid_out_B_i)
	);
	assign valid_out = (memory_switch_out==1 && flag_valid==0)? valid_out_A : (memory_switch_out==0 && flag_valid==0)? valid_out_B : 1'b0;
	
	assign data_out_real = (memory_switch_out==1)? data_real_out_A : (memory_switch_out==0)? data_real_out_B :12'b000000000000;
	assign data_out_imag = (memory_switch_out==1)? data_imag_out_A : (memory_switch_out==0)? data_imag_out_B :12'b000000000000;
	
	assign data_real_in_A = (memory_switch == 0)? data_in_real : 12'b000000000000;
	assign data_imag_in_A = (memory_switch == 0)? data_in_imag : 12'b000000000000;
	assign data_real_in_B = (memory_switch == 1)? data_in_real : 12'b000000000000;
	assign data_imag_in_B = (memory_switch == 1)? data_in_imag : 12'b000000000000;
	//============================================================================
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			read_A 				<= 0;
			read_B 				<= 0;
			write_A 			<= 0;
			write_B				<= 0;
			last_flag			<= 0;
			memory_switch		<= 0;		// 0 to write in A, 1 to write in B
			memory_switch_out	<= 0;		// 0 to write in A, 1 to write in B
			flag_valid			<= 0;
			delay_clk			<= 0;
			counter_first_read	<= 7'b000000000;
			counter_write		<= 6'b000000;
			counter_read		<= 9'b000000000;
			counter_write_out	<= 6'b000000;
			stop_flag			<= 0;
			flag_stop 			<= 0;
		end
		//============================================================================
		else
		begin
			//============================================================================
		    if (counter_read == 219)	// counts when last symbol turned to 1 then 0 
			begin
				stop_flag 			<= 1;			// waiting for the last 64 block from fft to read from the big ram
				flag_stop 			<= 0;
				read_A				<= 0;
				read_B				<= 0;
				write_A				<= 0;
				write_B				<= 0;
				last_flag			<= 0;
			end
			else if(flag_stop == 1 && last_symbol == 0)
				counter_read<= counter_read + 1'b1;
			else if(last_symbol == 1)	// store the value of last symbol
				flag_stop 			<= 1;
				
			if (counter_read == 195)		// enable read process for the last read from the other stack
				last_flag			<= 1;
			//============================================================================
			//============================================================================
			//								Read Process
			//============================================================================
			if(valid_in==1 || last_flag == 1)
			begin
				//============================================================================
				if(counter_first_read == 64)
				begin
					if(memory_switch==0)
					begin
						read_B			<= 1;
						read_A			<= 0;
					end
					//============================================================================
					else
					begin
						read_B			<= 0;
						read_A			<= 1;
					end
				end
				//============================================================================
				else	// else of counter_first_read
				begin
					read_B				<= 0;
					read_A				<= 0;
					counter_first_read	<= counter_first_read + 7'b000000001;
				end
			end	
			//============================================================================	
			//============================================================================
			// 								Write Process
			//============================================================================	
			if(valid_in==1 || last_flag == 1)
			begin	
				//============================================================================
				if (special_index == pilot_add_1-1 || special_index == pilot_add_2-1 || special_index == pilot_add_3-1 || special_index == pilot_add_4-1 || special_index == 63 || /*special_index == zero_add ||*/ (special_index >= nulls_start-1 && special_index <= nulls_end-1))
				begin
					read_A		<= 0;
					read_B		<= 0;
					write_A		<= 0;
					write_B		<= 0;
				end
				//============================================================================
				else
				begin
					counter_write		<= counter_write + 6'b000001;
					counter_write_out	<= counter_write_out + 6'b000001;
					if (memory_switch == 0)
					begin
						write_A <= 1;
						write_B	<= 0;
					end
					//============================================================================
					else
					begin
						write_A <= 0;
						write_B	<= 1;
					end
				end
				//============================================================================
				if (counter_write == 48)
				begin
					memory_switch 	<= ~memory_switch;
					counter_write	<= 6'b000000;
					counter_write_out	<= counter_write_out + 6'b000001;
					delay_clk		<= 1;
				end
				//============================================================================
				if (counter_write_out == 48 && counter_write == 0)
				begin
					counter_write_out	<= 6'b000000;
					delay_clk			<= 0;
					flag_valid			<= 0;
					memory_switch_out 	<= ~memory_switch_out;
				end
				//============================================================================
				if (counter_write_out == 49)
				begin
					memory_switch_out 	<= ~memory_switch_out;
					counter_write_out	<= 6'b000000;
					delay_clk			<= 0;
					flag_valid			<= 0;
				end
			end
			//============================================================================
			//		valid_in == 0
			//============================================================================
			else if(valid_in == 0 && last_flag == 0)	// of read and write conditions
			begin
				if(delay_clk == 1)
					flag_valid	<= 1; // nothing 					
			end
		end
	end
endmodule