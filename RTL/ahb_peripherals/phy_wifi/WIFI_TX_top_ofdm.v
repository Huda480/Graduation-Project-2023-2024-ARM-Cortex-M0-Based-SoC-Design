// Code your design here
/*
=========================================================================================
				Standard :	WIFI
				Block name :	OFDM
=========================================================================================
*/
//=======================================================================================
module WIFI_TX_top_ofdm #(parameter MAPPER =4)
(
	valid_in,
	data_in_re,
	data_in_im,
	reset,
	clk_ifft,
	clk_encoder,
	last_sym,
	data_out_re,
	data_out_im,
	valid_out,
	finished,
	Tx_irq,
	clear_Tx_irq,
	en_Tx_irq,
	clear_tx,
	mapper_ready
);
	//===============================================================================	
	input valid_in;
	input reset;
	input clk_ifft;
	input clk_encoder;
	input last_sym;
	input mapper_ready;
	input [11:0] data_in_re;
	input [11:0] data_in_im;
	input clear_Tx_irq;
	input en_Tx_irq;
	output valid_out;
	output finished;
	output  Tx_irq;
	output [11:0] data_out_re;
	output [11:0] data_out_im;
	output reg clear_tx;
	//===============================================================================	
	wire ifft_start;
	wire valid_out_ifft;
	wire valid_out_pre;
	wire preamble_start;
	wire done;
	wire [11:0] data_out_ifft_re;
	wire [11:0] data_out_ifft_im;
	wire [11:0] pre_re;
	wire [11:0] pre_im;
	reg flag_Tx_irq;
	wire ifft_pul;
	reg valid_out_ifft_reg ;
	//===============================================================================	
	(* keep_hierarchy = "yes" *) 
	WIFI_TX_top_ifft_controller #(MAPPER) ifft_module 
	(
		.clk(clk_encoder), 
		.clk_div(clk_ifft), 
		.reset(reset), 
		.sym_re(data_in_re),
		.sym_im(data_in_im), 
		.valid_in(valid_in), 
		.ifft_start(ifft_start),
		.last_symbol(last_sym), 
		.valid_out(valid_out_ifft), 
		.sample_real(data_out_ifft_re), 
		.sample_im(data_out_ifft_im), 
		.preample_st(preamble_start), 
		.enable(finished),
		.mapper_ready(mapper_ready)
	);
	//===============================================================================	
	(* keep_hierarchy = "yes" *) 
	WIFI_TX_top_preamble preamble (
		.valid_in(preamble_start), 
		.clk(clk_ifft), 
		.valid_out(valid_out_pre), 
		.pre_re(pre_re), 
		.pre_im(pre_im), 
		.done(done), 
		.reset(reset), 
		.enable_ifft(ifft_start)
	);


	always@(posedge clk_ifft or negedge reset) begin
		if (~reset)begin
			flag_Tx_irq <= 1'b0;
 			clear_tx <= 1'b0;
		end 
		else begin
			 if (clear_Tx_irq) begin
        	   flag_Tx_irq <= 1'b0;
        	   clear_tx <= 1'b1;
        	end
        	else if(ifft_pul) begin
        	   flag_Tx_irq <= 1'b1;
        	end
		end
	end	 

	always @(posedge clk_ifft or negedge reset) begin

		if(!reset)
		begin
			valid_out_ifft_reg <= 0;
		end
		else
		begin
			valid_out_ifft_reg <= valid_out_ifft;
		end
		
	end

	assign ifft_pul = valid_out_ifft_reg & ! valid_out_ifft ;


	//===============================================================================
	assign Tx_irq = (flag_Tx_irq  && en_Tx_irq)  ; 	
	assign valid_out= valid_out_pre || valid_out_ifft;	 
	assign  data_out_re=(valid_out_ifft) ? data_out_ifft_re:(valid_out_pre)? pre_re: 12'b0;
	assign  data_out_im=(valid_out_ifft) ? data_out_ifft_im:(valid_out_pre)? pre_im: 12'b0;
	//===============================================================================	
endmodule
