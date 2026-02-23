/*
=========================================================================================
				Standard   :	WIFI
				Block name :	Deinterleaver 96
=========================================================================================
*/
//=======================================================================================
module top_deinterleaver96_wifi
(
	clk,
	reset,
	enable,
	data_in,
	valid_in,
	finished,
	data_out,
	valid_out
);
	//===============================================================================
	input clk;
	input reset;
	input enable;
	input data_in;
	input valid_in;
	(* dont_touch = "yes" *) output reg finished;
	output reg valid_out;
	output data_out; 
	//===============================================================================
	reg re;
	reg we;
	reg reset_enable;
	reg [15:0] address_read;
	wire [15:0] address_write;
	reg data_in_reg;
	reg valid_out_reg1;
	reg valid_out_reg2;
	reg re_reg;
	reg flag;
	reg flag1;
	reg flag2;
	reg flag3;
	reg flag4;
	reg [15:0] j;
	reg [15:0] e;
	reg [15:0] m;
	reg [15:0] blocknum;
	//===============================================================================
	parameter [15:0] NCBPS 		= 96;
	parameter [15:0] NCBPS_S 	= 48;
	//===============================================================================
	WIFI_TXRX_interleaver_fifo interleaver_ram	
	(
		.clk(clk),
		.reset(reset),
		.re(re),
		.we(we),
		.data_in(data_in_reg),
		.reset_enable(reset_enable),
		.read_address(address_read),	 
		.data_out(data_out),
		.write_address(address_write)
	);
	//===============================================================================
	always@(posedge clk or negedge reset)
	begin
		//=======================================================================
		if(!reset) 
		begin
			j 					<= 0;
			e 					<= 0;	
			m 					<= 0; 	
			blocknum 				<= 0;
			re 					<= 0;
			re_reg					<= 0;		
			we 					<= 0;	
			flag 					<= 0;
			flag1 					<= 0;		
			flag2 					<= 0; 
			flag3					<= 0;	
			flag4					<= 0;
			valid_out 				<= 0;	
			valid_out_reg1 				<= 0;
			valid_out_reg2 				<= 0;
			finished 				<= 1;
		end
		//=======================================================================
		else 
		begin
			//===============================================================
			if(valid_in == 1 && enable == 1) 
			begin
				we 				<= 1;
				flag 				<= 1;
				valid_out_reg1 			<= 0;
				reset_enable 			<= 0;
			end 
			//===============================================================
			else if (valid_in == 0 && flag == 1 && enable == 0) 
			begin
				finished			<= 0;
				we 				<= 0;
			end 
			//===============================================================
			else if(valid_in == 0 && flag == 1) 
			begin
				//=======================================================
				finished 			<= 0;
				//=======================================================
				if(flag4 == 0) 
				begin
					//===============================================
					e 			<= 16*j-(NCBPS_S-1)*(j/3);
					j 			<= j + 1;
					m 			<= m + 1;
					we			<= 0;
					re_reg			<= 1;
					address_read 		<= e; 
					valid_out_reg1		<= 1;
					//===============================================
					if(j == NCBPS_S - 1) 
					begin 
						j 		<= 0; 
						flag3 		<= 1; 
					end
					//===============================================
					if(flag3 == 1 ) 
						flag4 		<= 1; 
					//===============================================
				end
				//=======================================================
				if(flag4 == 1) 
				begin
					//===============================================
					e 			<= 16*j-(NCBPS-1)*(j/6);
					j 			<= j + 1;
					m 			<= m + 1;
					address_read 		<= e + 48 + 96*blocknum; 
					//===============================================
					if(j == NCBPS - 1) 
					begin 
						j 		<= 0; 
						flag1 		<= 1; 
					end
					//===============================================
					if (flag1 == 1) 
					begin 
						blocknum	<= blocknum + 1;
					 	flag1 		<= 0; 
					end
					//===============================================
					if(m == address_write) 
					begin
						j 		<= 0;
						e 		<= 0;
						m 		<= 0;
	 					blocknum 	<= 0;
						re_reg 		<= 0;
						we 		<= 0;
						flag 		<= 0;				
						flag1 		<= 0;
						flag2 		<= 0;
						flag3		<= 0;
						flag4		<= 0;
						valid_out_reg1 	<= 0;
						valid_out_reg2 	<= 0;
						valid_out 	<= 0;
						reset_enable	<= 1;   
					end
					//===============================================
				end
				//=======================================================
			end
			//===============================================================
			data_in_reg 				<= data_in;
			valid_out_reg2 				<= valid_out_reg1;
			valid_out 				<= valid_out_reg2;
			re 					<= re_reg;
			//===============================================================
			if(valid_out_reg2 == 1) 
			begin 
				flag2				<= 1; 
			end
			//===============================================================
			else if(valid_out_reg2 == 0 && flag2 == 1) 
			begin 
				finished			<= 1; 
				flag2				<= 0; 
			end
			//===============================================================
		end 
		//=======================================================================
	end 
	//===============================================================================
endmodule
