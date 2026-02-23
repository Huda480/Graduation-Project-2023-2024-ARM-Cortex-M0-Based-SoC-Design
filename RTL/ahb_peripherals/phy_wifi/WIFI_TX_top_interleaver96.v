/*
======================================================================================
				Standard   : WIFI
				Block name : Interleaver_96
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_interleaver96
(
	clk,
	reset,
	enable,
	valid_in,
	data_in,
	valid_out,
	data_out,
	finished
);
	//============================================================================
	input clk;
	input reset;
	input enable;
	input data_in;
	input valid_in;
	output finished;
	output valid_out;
	output data_out; 
	//============================================================================
	reg valid_out;
	reg finished;
	reg re;
	reg we;
	reg reset_enable;
	reg [15:0] address_read;
	wire [15:0] address_write;
	reg data_in_reg;
	reg valid_out_reg1;
	reg valid_out_reg2;
	reg re_reg;
	//============================================================================
	parameter [15:0] NCBPS   = 96;
	parameter [15:0] NBPSC   = 2;
	parameter [15:0] NCBPS_S = 48;
	parameter [15:0] NBPSC_S = 1;
	//============================================================================
	reg flag,flag1,flag2,flag3,flag4;
	reg [15:0] k,i,m,blocknum;
	//============================================================================
	WIFI_TXRX_interleaver_fifo ram
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
	//============================================================================
	always@(posedge clk or negedge reset)
	begin
		//====================================================================
		if(!reset) 
		begin
			k 		<= 0;			
			i 		<= 0;		
			m 		<= 0; 			
			blocknum 	<= 0;
			re 		<= 0;		
			re_reg		<= 0;
			we 		<= 0;			
			flag 		<= 0;
			flag1 		<= 0;
			flag2 		<= 0;
			flag3		<= 0;
			flag4		<= 0;
			valid_out 	<= 0;	
			valid_out_reg1 	<= 0;	
			valid_out_reg2 	<= 0;
			finished 	<= 1;
		end
		//====================================================================
		else 
		begin
			//============================================================
			if(valid_in == 1 && enable == 1) 
			begin
				we 		<= 1;
				flag 		<= 1;
				valid_out_reg1 	<= 0;
				reset_enable	<= 0;
			end 
			//============================================================
			else if (valid_in == 0 && flag == 1 && enable == 0) 
			begin
				finished 	<= 0;
				we 		<= 0;
			end 
			//============================================================
			else if(valid_in == 0 && flag == 1) 
			begin
				//====================================================
				finished 	<= 0;
				//====================================================
				if(flag4 == 0) 
				begin
					i 			<= (NCBPS_S>>4)*(k%16) + (k>>4);
					k 			<= k + 1;
					m 			<= m + 1;
					we			<= 0;
					re_reg			<= 1;
					address_read 		<= i;
					valid_out_reg1 		<= 1;

					if(k == NCBPS_S - 1) 
					begin 
						k 		<= 0; 
						flag3 		<= 1; 
					end
					if(flag3 == 1 ) 
						flag4 		<= 1; 
				end
				//====================================================
				if(flag4 == 1) 
				begin
					i 			<= (NCBPS>>4)*(k%16) + (k>>4);
					k 			<= k + 1;
					m 			<= m + 1;
					address_read 		<= i + 48 + 96*blocknum; 

					if(k == NCBPS - 1) 
					begin 
						k 		<= 0; 
						flag1 		<= 1; 
					end
					if (flag1 == 1) 
					begin 
						blocknum 	<= blocknum + 1; 	
						flag1 		<= 0; 
					end
					if(m == address_write) 
					begin
						k 		<= 0;				
						i 		<= 0;	
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
						reset_enable 	<= 1;   
					end
				end
				//====================================================
			end
			//============================================================
			data_in_reg	 	<= data_in;
			valid_out_reg2 		<= valid_out_reg1;
			valid_out 		<= valid_out_reg2;
			re 			<= re_reg;
			//============================================================
			if(valid_out_reg2 == 1) 
				flag2		<= 1;
			else if(valid_out_reg2 == 0 && flag2 == 1) 
			begin 
				finished	<= 1; 
				flag2		<= 0; 
			end
			//============================================================
		end
		//====================================================================
	end
	//============================================================================
endmodule
