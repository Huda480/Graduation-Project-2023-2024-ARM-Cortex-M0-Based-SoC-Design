/*
======================================================================================
				Standard   : WIFI
				Block name : Interleaver_192
======================================================================================
*/
//====================================================================================
module WIFI_TX_top_interleaver192
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
	reg valid_out_reg3;
	reg re_reg;
	reg re_reg_1;
	//============================================================================
	parameter [15:0] NCBPS   = 192;
	parameter [15:0] NBPSC   = 4;
	parameter [15:0] NCBPS_S = 48;
	parameter [15:0] NBPSC_S = 1;
	//============================================================================
	reg flag,flag1,flag2,flag3,flag4,flag5,flag6;
	reg [15:0] k,i,j,m,blocknum;
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
			j 		<= 0;
			m 		<= 0;
			blocknum 	<= 0;
			re 		<= 0;	
			re_reg		<= 0;		
			re_reg_1	<= 0;
			we 		<= 0;	
			flag 		<= 0;
			flag1 		<= 0;
			flag3 		<= 0;
			flag2 		<= 0;
			flag4		<= 0;
			flag5		<= 0;
			flag6		<= 0;
			valid_out 	<= 0;
			valid_out_reg1 	<= 0;
			valid_out_reg2 	<= 0;
			valid_out_reg3 	<= 0;
			finished 	<= 1;
		end
		//====================================================================
		else
		begin
			//============================================================
			if(valid_in == 1 && enable == 1) 
			begin
				we <= 1;
				flag <= 1;
				valid_out_reg1 <= 0;
				reset_enable <= 0;
			end 
			//============================================================
			else if (valid_in == 0 && flag == 1 && enable == 0) 
			begin
				finished <= 0;
				we <= 0;
			end 
			//============================================================
			else if(valid_in == 0 && flag == 1) 
			begin
				//====================================================
				finished <= 0;
				//====================================================
				if(flag6 == 0) 
				begin
					if(flag5 == 0) 
					begin 
						i 		<= (NCBPS_S>>4)*(k%16) + (k>>4);
						j 		<= i;
						k 		<= k + 1;
						m 		<= m + 1; 
					end
					else 
					begin
						i 		<= (NCBPS>>4)*(k%16) + (k>>4);
						j 		<= 2*(i>>1) + ((i + NCBPS - (i/12))%2);
						m 		<= m + 1;
						address_read 	<= j + 48 +192*blocknum ; 

						if(k != NCBPS - 1) 
							k 	<= k + 1; 
					end

					we			<= 0;
					re_reg_1 		<= 1;
					address_read 		<= j; 
					valid_out_reg1 		<= 1;

					if(k == NCBPS_S - 1) 
					begin 
						k 		<= 0; 
						flag4		<= 1; 
					end
					if(flag4 == 1 ) 
						flag5 		<= 1;
					if(flag5 == 1 )
						flag6 		<= 1;
				end
				//====================================================
				if(flag6 == 1) 
				begin
					i 			<= (NCBPS>>4)*(k%16) + (k>>4);
					j 			<= 2*(i>>1) + ((i + NCBPS - (i/12))%2);
					m 			<= m + 1;
					address_read 		<= j + 48 +192*blocknum ; 
					valid_out_reg1 		<= 1;

					if(k != NCBPS - 1) 
						k 		<= k + 1;

					if(k == NCBPS - 1) 
					begin  
						k		<= 0; 
						flag3 		<= 1; 
					end
					if(flag3 == 1) 
					begin   
						flag1 		<= 1; 
						flag3 		<= 0;
					end
					if (flag1 == 1) 
					begin 
						blocknum 	<= blocknum + 1;
						flag1 		<= 0; 
					end
					if(m == address_write + 1) 
					begin
						k		<= 0;
						i 		<= 0;
						j 		<= 0;
						m 		<= 0;
						blocknum 	<= 0;
						re_reg_1 	<= 0;
						we 		<= 0;
						flag		<= 0;
						flag1 		<= 0;
						flag3 		<= 0;
						flag2 		<= 0;
						flag4		<= 0;
						flag5		<= 0;
						flag6		<= 0;
						valid_out_reg1 	<= 0;
						reset_enable 	<= 1;   
					end
				end
				//====================================================
			end
			//============================================================
			data_in_reg <= data_in;
			//============================================================
			if (valid_out_reg1 == 1) 
			begin
				valid_out_reg2 	<= valid_out_reg1;
				valid_out_reg3	<= valid_out_reg2;
				valid_out 	<= valid_out_reg3;
			end 
			//============================================================
			else 
			begin
				valid_out_reg2 	<= valid_out_reg1;
				valid_out_reg3 	<= valid_out_reg1;
				valid_out	<= valid_out_reg3;
			end
			//============================================================
			re_reg	<= re_reg_1;
			re 	<= re_reg;
			//============================================================
			if(valid_out_reg3 == 1) 
				flag2		<= 1; 
			else if(valid_out_reg3 == 0 && flag2 == 1) 
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
