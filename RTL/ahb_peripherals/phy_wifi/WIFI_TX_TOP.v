/*
=========================================================================================
				Standard   :	WIFI
				Block name :	Tx top level
=========================================================================================
*/
//=======================================================================================
module WIFI_TX_TOP #(parameter PUNCTURER=0, INTERLEAVER=96, MAPPER=4,DATA_WIDTH =32)
(
	clk_input,
	clk_encoder,
	clk_ifft, 
	reset, 
	data_in, 
	valid_in,
	data_size,
	en_Tx_irq, 
	clear_Tx_irq,  
	valid_out,
	data_out_re,
	data_out_im,
	done_PISO,
	start_rd_pulse,
    done,
    Tx_irq,
	clear_tx
);
	//===============================================================================	
	input clk_input;
	input clk_encoder;
	input clk_ifft;
	input reset;
	input [DATA_WIDTH - 1 :0] data_in;
	input valid_in;
	input [DATA_WIDTH - 1 :0] data_size;
    input clear_Tx_irq;
    input en_Tx_irq;
	output valid_out;
	output [11:0] data_out_re;
	output [11:0] data_out_im;
	output done_PISO;
	output start_rd_pulse;
	output done;
	output reg Tx_irq;
	output clear_tx;
	//===============================================================================	
	wire scrambler_data_out;
	wire scrambler_valid_out;
	wire encoder_data_out;
	wire encoder_valid_out;
	wire encoder_finish;
	wire puncturer_data_out;
	wire puncturer_valid_out;
	wire puncturer_finish;
	wire interleaver_data_out;
	wire interleaver_valid_out;
	wire interleaver_finish;
	wire [11:0] mapper_data_out_real;
	wire [11:0] mapper_data_out_imag;
	wire mapper_valid_out;
	wire mapper_finish;
	wire preamble_finish;
	wire last_symbol;
	wire mapper_ready;
	//===============================================================================
	wire data_out_serializer;
	wire valid_out_serializer;
	wire Tx_irq_reg;
	//===============================================================================
	always@(posedge clk_ifft or negedge reset) begin
	if(~reset) begin
		Tx_irq <= 0;
	end
	else begin
		Tx_irq <= Tx_irq_reg;
	end
	end
	//===============================================================================
	(* keep_hierarchy = "yes" *)
    WIFI_TX_scrambler_serializer #(DATA_WIDTH ) scrambler_serializer_inist
    (
        .clk(clk_input),
		.reset(reset),
		.enable(encoder_finish),
		.valid_in(valid_in),
		.data_in(data_in),
		.data_size(data_size),
		.data_out(data_out_serializer),
		.valid_out(valid_out_serializer),
		.done_PISO(done_PISO),
    	.start_rd_pulse(start_rd_pulse),
		.done(done)
    );
	//===============================================================================
	(* keep_hierarchy = "yes" *) 
	WIFI_TX_top_Scrambler scrambler
	(
		.clk(clk_input),
		.reset(reset),
		.data_in(data_out_serializer),
		.valid_in(valid_out_serializer),
		.valid_out(scrambler_valid_out),
		.data_out(scrambler_data_out) 
	);
	

	//===============================================================================	
	(* keep_hierarchy = "yes" *) 
	WIFI_TX_top_convo encoder
	(
		.clk(clk_input), 
		.clk_out(clk_encoder), 
		.reset(reset), 
		.enable(puncturer_finish), 
		.valid_in(scrambler_valid_out), 
		.data_in(scrambler_data_out), 
		.data_out(encoder_data_out), 
		.valid_out(encoder_valid_out),
		.finished(encoder_finish)
	);
	//===============================================================================	
	(* keep_hierarchy = "yes" *) 
	WIFI_TX_top_puncturer #(PUNCTURER) puncturer
	(
		.clk(clk_encoder), 
		.reset(reset), 
		.enable(interleaver_finish), 
		.valid_in(encoder_valid_out), 
		.data_in(encoder_data_out), 
		.data_out(puncturer_data_out), 
		.valid_out(puncturer_valid_out),
		.finished(puncturer_finish)
	);
	//===============================================================================	
	(* keep_hierarchy = "yes" *) 
	WIFI_TX_top_interleaver #(INTERLEAVER) interleaver 
	(
		.clk(clk_encoder), 
		.reset(reset), 
		.enable(mapper_finish),  
		.valid_in(puncturer_valid_out), 
		.data_in(puncturer_data_out), 
		.data_out(interleaver_data_out), 
		.valid_out(interleaver_valid_out),
		.finished(interleaver_finish)
	);
	//===============================================================================	
	(* keep_hierarchy = "yes" *) 
	WIFI_TX_topControlled_bpskMapper #(MAPPER) mapper 
	(
		.clk(clk_encoder), 
		.reset(reset), 
		.enable(preamble_finish), 
		.valid_in(interleaver_valid_out), 
		.data_in(interleaver_data_out), 
		.mod_out_im(mapper_data_out_imag), 
		.mod_out_re(mapper_data_out_real),                                         
		.re_out(mapper_ready),
		.valid_out(mapper_valid_out),
		.last_sym(last_symbol),
		.finished(mapper_finish) 
	);
	//===============================================================================	
	(* keep_hierarchy = "yes" *) 
	WIFI_TX_top_ofdm #(MAPPER) top_ofdm 
	(
		.clk_ifft(clk_ifft), 
		.clk_encoder(clk_encoder), 
		.reset(reset), 
		.mapper_ready(mapper_ready),
		.valid_in(mapper_valid_out),
		.clear_Tx_irq(clear_Tx_irq),
		.data_in_im(mapper_data_out_imag), 
		.data_in_re(mapper_data_out_real), 
		.data_out_im(data_out_im), 
		.data_out_re(data_out_re), 
		.last_sym(last_symbol),
		.valid_out(valid_out),
		.Tx_irq(Tx_irq_reg),
		.en_Tx_irq(en_Tx_irq),
		.finished(preamble_finish),
		.clear_tx(clear_tx) 
	);
	
endmodule
