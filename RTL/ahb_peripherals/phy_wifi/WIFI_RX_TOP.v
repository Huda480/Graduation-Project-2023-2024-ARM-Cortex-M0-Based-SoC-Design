/*
=========================================================================================
				Standard   :	WIFI
				Block name :	Rx top level
=========================================================================================
*/

module WIFI_RX_TOP #(parameter PUNCTURER=0, INTERLEAVER=96 , MAPPER=4,  DATA_WIDTH = 32)
(
	clk_output,
	clk_decoder,
	clk_fft,
	reset,
	valid_in,
	data_in_re,
    data_in_im,

	en_Rx_irq, 
	clear_Rx_irq, 
	rx_irq,
	data_out,
	valid_out,
	clear_rx
);
//===============================================================================	
input clk_output;
input clk_decoder;
input clk_fft;
input reset;
input valid_in;
input [11:0] data_in_re;
input [11:0] data_in_im;
input      en_Rx_irq; 
input      clear_Rx_irq; 
output                   rx_irq;
output   [DATA_WIDTH - 1:0]   data_out;
output                  valid_out;
output clear_rx;
//===============================================================================

wire [11:0] data_out_real, data_out_imag;
wire enable, valid_out_re, valid_out_im;
wire  data_in_deserializer;
wire valid_out_rx;
//===============================================================================
RX_in_mem input_memory_real (
	.clk(clk_fft),
	.reset(reset),
	.re(1),
	.we(valid_in),
	.data_in(data_in_re),
	.data_out(data_out_real),
	.valid_out(valid_out_re)
);
//===============================================================================
RX_in_mem input_memory_imag (
	.clk(clk_fft),
	.reset(reset),
	.re(valid_in),
	.we(valid_in),
	.data_in(data_in_im),
	.data_out(data_out_imag),
	.valid_out(valid_out_im)
);
//===============================================================================
top_rx_wifi  #( PUNCTURER, INTERLEAVER , MAPPER) top_rx
(
	.clk_output(clk_output),
	.clk_decoder(clk_decoder),
	.clk_fft(clk_fft),
	.reset(reset),
	.valid_in(enable),
	.data_in_real(data_out_real),
	.data_in_imag(data_out_imag),
	.valid_out(valid_out_rx),
	.data_out(data_in_deserializer)
);
//===============================================================================
RX_deserializer #(DATA_WIDTH) RX_deserializer_inist (
    .clk(clk_output),
    .reset(reset),
    .we(valid_out_rx),
    .data_in(data_in_deserializer),
    .data_out(data_out),
    .rx_irq(rx_irq),
    .en_Rx_irq(en_Rx_irq), 
    .clear_Rx_irq(clear_Rx_irq),
    .clear_rx(clear_rx),
    .valid_out(valid_out)
);
assign enable = valid_out_im && valid_out_re;
endmodule