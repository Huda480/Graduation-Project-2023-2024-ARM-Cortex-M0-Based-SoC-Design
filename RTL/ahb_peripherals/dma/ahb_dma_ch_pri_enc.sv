/////////////////////////////////////////////////////////////////////
////  AHB DMA Priority Encoder                                   ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
module ahb_dma_ch_pri_enc(clk, valid,pri_ch,pri_out);
//==========================================================================
// Parameters
//==========================================================================
parameter	[1:0]	pri_sel   = 2'd2;
parameter   [5:0]   channel_number = 12;
//==========================================================================
// Inputs & Outputs
//==========================================================================
input		    clk;
input	[channel_number-1:0]	valid;
input   [2:0]	pri_ch [0:channel_number - 1] ;
output	[2:0]	pri_out;			
//==========================================================================
// Internal signals
//==========================================================================
wire  [7:0] ch_pri_out [0:channel_number-1] ;
wire  [7:0]	pri_out_tmp ;
reg	  [2:0]	pri_out;
//==========================================================================
// Main code
//==========================================================================
//integer i;
genvar k ;
generate 
	for(k=0;k<channel_number;k=k+1)
	begin
	  ahb_dma_pri_enc_sub  priority_select (.valid(valid[k]),.pri_in(pri_ch[k]),.pri_out(ch_pri_out[k]));
	end
endgenerate


or_opt #(.channel_number(channel_number),.width(8)) OR (.signals(ch_pri_out),.ored_signal(pri_out_tmp));

generate
	if(pri_sel == 2'b10)
	begin
		always @(posedge clk)
			if(pri_out_tmp[7])	pri_out <=  3'h7;
			else
			if(pri_out_tmp[6])	pri_out <=  3'h6;
			else
			if(pri_out_tmp[5])	pri_out <=  3'h5;
			else
			if(pri_out_tmp[4])	pri_out <=  3'h4;
			else
			if(pri_out_tmp[3])	pri_out <=  3'h3;
			else
			if(pri_out_tmp[2])	pri_out <=  3'h2;
			else
			if(pri_out_tmp[1])	pri_out <=  3'h1;
			else			pri_out <=  3'h0;
	end
	else if (pri_sel == 2'b01) begin
		always @(posedge clk)
			if(pri_out_tmp[3])	pri_out <=  3'h3;
			else
			if(pri_out_tmp[2])	pri_out <=  3'h2;
			else
			if(pri_out_tmp[1])	pri_out <=  3'h1;
			else			pri_out <=  3'h0;
	end
	else if (pri_sel == 2'b00) begin
		always @(posedge clk)
			if(pri_out_tmp[1])	pri_out <=  3'h1;
			else			pri_out <=  3'h0;
	end

endgenerate

endmodule
