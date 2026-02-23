/*
=========================================================================================
				Standard   :	WIFI
				Block name :	Deinterleaver 192
=========================================================================================
*/
//=======================================================================================
module top_deinterleaver192_wifi
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
	output reg finished;
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
	reg valid_out_reg3;
	reg re_reg,re_reg_1;
	reg flag;
	reg flag1;
	reg flag3;
	reg flag2;
	reg [15:0] j;
	reg [15:0] d;
	reg [15:0] e;
	reg [15:0] m;
	reg [15:0] blocknum;
	//===============================================================================
	parameter [15:0] NCBPS = 192;
	//===============================================================================
	interleaver_fifo interleaver_ram	
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
		if(!reset) 
		begin
			j 				<= 0;
			d 				<= 0;	
			e 				<= 0;	
			m 				<= 0;	
			blocknum 			<= 0;
			re 				<= 0;	
			re_reg				<= 0;		
			re_reg_1			<= 0;	
			we 				<= 0;	
			flag 				<= 0;	
			flag1 				<= 0;
			flag3 				<= 0; 
			flag2 				<= 0;
			valid_out 			<= 0;	
			valid_out_reg1 			<= 0;	
			valid_out_reg2 			<= 0;	
			valid_out_reg3 			<= 0;
			finished 			<= 1;
		end
		else 
		begin
			//===============================================================
			if(valid_in == 1 && enable == 1) 
			begin
				we 			<= 1;
				flag			<= 1;
				valid_out_reg1 		<= 0;
				reset_enable 		<= 0;
			end 
			//===============================================================
			else if (valid_in == 0 && flag == 1 && enable == 0) 
			begin
				finished 		<= 0;
				we 			<= 0;
			end 
			//===============================================================
			else if(valid_in == 0 && flag == 1) 
			begin
				//=======================================================
				finished 		<= 0;
				d 			<= 2*(j>>1)+(j+(j/12))%2;
				e 			<= 16*d -(NCBPS - 1)*(d/12);
				//=======================================================
				if(j != NCBPS - 1) 
				begin 
					j 		<= j + 1; 
				end
				//=======================================================
				m 			<= m + 1;
				we			<= 0;
				re_reg_1		<= 1;
				address_read 		<= e + 192*blocknum ; 
				valid_out_reg1 		<= 1;
				//=======================================================
				if(j == NCBPS - 1) 
				begin  
					j 		<= 0; 
					flag3 		<= 1; 
				end
				//=======================================================
				if(flag3 == 1) 
				begin   
					flag1 		<= 1; 
					flag3 		<= 0;
				end
				//=======================================================
				if (flag1 == 1) 
				begin 
					blocknum 	<= blocknum + 1;
				 	flag1 		<= 0; 
				end
				//=======================================================
				if(m == address_write + 1) 
				begin
					j 		<= 0;
					d 		<= 0;
					e 		<= 0;
					m 		<= 0;
					blocknum 	<= 0;
					re_reg_1 	<= 0;
					we 		<= 0;
					flag 		<= 0;
					flag1 		<= 0;
					flag3 		<= 0;
					flag2 		<= 0;
					valid_out_reg1 	<= 0; 
					reset_enable	<= 1;   
				end
				//=======================================================
			end
			//===============================================================
			data_in_reg 			<= data_in;
			//===============================================================
			if (valid_out_reg1 == 1) 
			begin
				valid_out_reg2 		<= valid_out_reg1;
				valid_out_reg3 		<= valid_out_reg2;
				valid_out 		<= valid_out_reg3;
			end 
			//===============================================================
			else 
			begin
				valid_out_reg2 		<= valid_out_reg1;
				valid_out_reg3 		<= valid_out_reg1;
				valid_out 		<= valid_out_reg3;
			end
			//===============================================================
			re_reg 				<= re_reg_1;
			re 				<= re_reg;
			//===============================================================
			if(valid_out_reg3 == 1) 
			begin 
				flag2			<= 1; 
			end
			//===============================================================
			else if(valid_out_reg3 == 0 && flag2 == 1) 
			begin 
				finished		<= 1; 
				flag2			<= 0; 
			end
			//===============================================================
		end 
		//=======================================================================
	end
	//===============================================================================
endmodule
