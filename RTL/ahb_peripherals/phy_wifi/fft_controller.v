/*
======================================================================================
				Standard   : WIFI
				Block name : FFT Controller
				Abdelrhman
======================================================================================
*/
//====================================================================================
module fft_controller #(parameter SAMPLE_WIDTH=12, SCALING_INDEX_WIDTH=6)
(
	clk,
	reset,
	data_in_real,
	data_in_imag,
	valid_in,
	last_symbol,
	data_out_real,
	data_out_imag,
	special_index,
	valid_out
);
	//============================================================================
	input				clk;
	input 				reset;
	input [11:0] 		data_in_real;
	input [11:0] 		data_in_imag;
	input 				valid_in;
	input				last_symbol;
	(* dont_touch = "yes" *) output wire [11:0] 	data_out_real;
	(* dont_touch = "yes" *) output wire [11:0] 	data_out_imag;
	output wire [5:0]	special_index;
	output wire 		valid_out;
	//============================================================================
	//					FFT Signals
	//============================================================================
	 reg   							start; 
	 reg  							cp_len_we;    
	 reg 							fwd_inv_we;	 	
	 wire   							rfd;	
	 reg   							ce;	
	 wire   							busy; 	
	 wire   							edone; 	
	 wire   		                    done; 	
	 wire   							dv; 	
	 wire   							cpv; 	
	 wire  							rfs; 	
	 reg  [SAMPLE_WIDTH-1:0]   		xn_re; 
	 reg  [SAMPLE_WIDTH-1:0]   		xn_im; 
	 wire [SCALING_INDEX_WIDTH-1:0]  xn_index; 
	 wire [SCALING_INDEX_WIDTH-1:0]  xk_index; 
	 wire [SAMPLE_WIDTH-1:0]  		xk_re;	
	 wire [SAMPLE_WIDTH-1:0]  		xk_im;	
	 wire [SCALING_INDEX_WIDTH-1:0]	cp_len = 6'b000000;
	 wire [SCALING_INDEX_WIDTH-1:0]	scale_sch = 6'b000000;
	 wire fwd_inv =1'b1;
	 wire scale_sch_we = 1'b0;
	//============================================================================
	//					Ram Signals
	//============================================================================
	reg								read_A;
	reg 							read_B;
	reg 							write_A;
	reg 							write_B;
	reg  [SAMPLE_WIDTH-1:0]			data_in_A_real;
	reg  [SAMPLE_WIDTH-1:0]			data_in_A_imag;
	reg  [SAMPLE_WIDTH-1:0]			data_in_B_real;
	reg  [SAMPLE_WIDTH-1:0]			data_in_B_imag;
	wire [SAMPLE_WIDTH-1:0]			data_out_A_real;
	wire [SAMPLE_WIDTH-1:0]			data_out_A_imag;
	wire [SAMPLE_WIDTH-1:0]			data_out_B_real;
	wire [SAMPLE_WIDTH-1:0]			data_out_B_imag;
	wire							valid_out_A;
	wire							valid_out_B;
	reg 							memory_switch;	// 0 writing in ram A and reading from ram B
	reg [SCALING_INDEX_WIDTH:0]     counter_64;		// counting the 64 samples input the ram without CP
	reg [SCALING_INDEX_WIDTH:0]     counter_80;		// for the first read from the ram
	reg [4:0]						counter_16;		// counting the cyclic prefix
	reg 							read_A_flag;	// flags to begin reading when i write in the second ram
	reg								read_B_flag;
	reg                             lock_start;
	reg                             wait_clk;
	reg                             wait_clk_flag;	
	//============================================================================
	//				Modules definitions
	//============================================================================
	(* keep_hierarchy = "yes" *)
	(* DONT_TOUCH = "yes" *)
	FFT FFT
	(
		.clk(clk), 			
		.ce(ce), 				
		.start(start), 			
		.cp_len_we(cp_len_we), 		
		.fwd_inv(fwd_inv), 		
		.fwd_inv_we(fwd_inv_we), 		
		.scale_sch_we(scale_sch_we), 	
		.rfd(rfd), 			
		.busy(busy), 			
		.edone(edone), 			
		.done(done), 			
		.dv(dv), 				
		.cpv(cpv), 			
		.rfs(rfs),			
		.cp_len(cp_len), 			
		.xn_re(xn_re), 			
		.xn_im(xn_im), 			
		.scale_sch(scale_sch), 		
		.xn_index(xn_index), 		
		.xk_index(xk_index), 		
		.xk_re(xk_re), 			
		.xk_im(xk_im) 			
	);
	//============================================================================
	(* keep_hierarchy = "yes" *)
	fifo_fft #(16, 12, 64)	ramA_real
	(
		.clk(clk),
		.reset(reset),
		.re(read_A),
		.we(write_A),
		.data_in(data_in_A_real),
		.data_out(data_out_A_real),
		.valid_out(valid_out_A)
	);
	//============================================================================
	(* keep_hierarchy = "yes" *)
	fifo_fft #(16, 12, 64)	ramA_imag
	(
		.clk(clk),
		.reset(reset),
		.re(read_A),
		.we(write_A),
		.data_in(data_in_A_imag),
		.data_out(data_out_A_imag),
		.valid_out(valid_out_A)
	);
	//============================================================================
	(* keep_hierarchy = "yes" *)
	fifo_fft #(16, 12, 64)	ramB_real
	(
		.clk(clk),
		.reset(reset),
		.re(read_B),
		.we(write_B),
		.data_in(data_in_B_real),
		.data_out(data_out_B_real),
		.valid_out(valid_out_B)
	);
	//============================================================================
	(* keep_hierarchy = "yes" *)
	fifo_fft #(16, 12, 64)	ramB_imag
	(
		.clk(clk),
		.reset(reset),
		.re(read_B),
		.we(write_B),
		.data_in(data_in_B_imag),
		.data_out(data_out_B_imag),
		.valid_out(valid_out_B)
	);
	//============================================================================
	assign valid_out = dv;
	assign special_index = xk_index;
	assign data_out_real = xk_re;
	assign data_out_imag = xk_im;
	//============================================================================
	//		RAM INPUT PROCESS
	//============================================================================
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			memory_switch 	<= 0;
			counter_16 		<= 5'b00000;
			counter_64 		<= 7'b000000;
			write_A			<= 0;
			write_B			<= 0;
			read_B_flag		<= 0;
			read_A_flag		<= 0;
		end
		else if(valid_in == 1 || last_symbol == 1)
		begin
			if(counter_16 == 12 && memory_switch ==1)
			begin
				read_A_flag <= 1;
				read_B_flag <= 0;
			end
			else if(counter_16 == 12 && memory_switch ==0)
			begin
				read_B_flag <= 1;
				read_A_flag <= 0;
			end	
			if (counter_16 == 16)	// begin writting
			begin 
				if(memory_switch == 0)
				begin
					write_A 		<= 1;
					data_in_A_real 	<= data_in_real;
					data_in_A_imag 	<= data_in_imag;
					data_in_B_real	<= 12'b000000000000;
					data_in_B_imag	<= 12'b000000000000;
					if (counter_64 == 64)	// switching the ram
					begin
						memory_switch 	<= 1;
						write_A 		<= 0;
						counter_16 		<= 5'b00001;
						counter_64 		<= 7'b0000000;
					end
					else
						counter_64 <= counter_64 + 1'b1;
				end
				else if(memory_switch == 1)
				begin
					write_B 		<= 1;
					data_in_B_real 	<= data_in_real;
					data_in_B_imag 	<= data_in_imag;
					data_in_A_real	<= 12'b000000000000;
					data_in_A_imag	<= 12'b000000000000;
					if (counter_64 == 64)
					begin
						memory_switch 	<= 0;
						write_B 		<= 0;
						counter_16 		<= 5'b00001;
						counter_64 		<= 7'b0000000;
					end
					else 
						counter_64 <= counter_64 + 1'b1;
				end
			end
			else if (counter_64 ==0)
			begin
				counter_16 <= counter_16 + 1'b1;
			end
		end
		else	// else of valid_in 
		begin
			write_A 		<= 0;
			write_B 		<= 0;
			data_in_A_real	<= 12'b000000000000;
			data_in_A_imag	<= 12'b000000000000;
			data_in_B_real	<= 12'b000000000000;
			data_in_B_imag	<= 12'b000000000000;
		end
	end
	//============================================================================
	//		RAM OUTPUT PROCESS
	//============================================================================
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			counter_80		<= 7'b000000;
			read_A			<= 0;
			read_B			<= 0;
			xn_re 			<= 12'b000000000000;
			xn_im 			<= 12'b000000000000;
			wait_clk 	    <= 0;
			wait_clk_flag   <= 0;
		end
		else if(valid_in == 1 || last_symbol == 1)
		begin
			if(counter_80==93)
			begin
				if(memory_switch == 0 && read_B_flag == 1)
				begin
					read_B 	<= 1;
					read_A 	<= 0;
					xn_re 	<= data_out_B_real;
					xn_im 	<= data_out_B_imag;
				end
				else if(memory_switch==1 && read_A_flag == 1)
				begin
					read_B 	<= 0;
					read_A 	<= 1;
		          	xn_re 	<= data_out_A_real;
					xn_im 	<= data_out_A_imag;
				end
				if(wait_clk_flag == 0)
				begin
    				counter_80 	<= counter_80 + 1'b1;
			        wait_clk_flag   <= 1;
				end
			end
            else if(counter_80==94)
			begin
    			wait_clk 	    <= 1;
				counter_80 	<= counter_80 - 1'b1;
			end
			else
				counter_80 	<= counter_80 + 1'b1;
		end
		else		// else of valid_in
        begin
            read_A            <= 0;
            read_B            <= 0;
        end
	end
	//============================================================================
	//		FFT INPUT SIGNALS PROCESS
	//============================================================================
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			start 			<= 0;
			fwd_inv_we 		<= 1;
			cp_len_we 		<= 1;
			ce				<= 1;
			lock_start      <= 0;
		end
		else
		begin
		if(start==0 && rfd==0 && counter_16 ==14)
		  lock_start 	<= 0;
		else if(xn_index == 62)
		begin
			start 		<= 0;
			lock_start 	<= 1;
		end
		else if ((read_A || read_B)&& lock_start==0 && wait_clk==1)
		begin
			start <= 1;
			fwd_inv_we 	<= 0;
			cp_len_we 	<= 0;
		end
	   end
	end
	
endmodule