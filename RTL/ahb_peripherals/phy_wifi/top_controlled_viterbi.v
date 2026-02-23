module top_controlled_viterbi_wifi(
    input clk, 
    input RESET,
    input valid_in,
    input data_in,
    input enable,
    output data_out,
    output valid_out,
    output finished
    );
//---------------------------------------------------------------------------------------------------------------------//
wire re,valid_out_fifo,active,TB_enable,reset_viterbi,valid_out_viterbi,re_buffer,decode_out,reset_all,reset;
wire [1:0] Code;
wire [3:0] ACS_counter;
wire [14:0] write_address;
wire [12:0] max_read_address;
wire TB_stop;
//---------------------------------------------------------------------------------------------------------------------//
decoder_fifo dec_fifo(
     .clk(clk),
     .reset(reset),
     .re(re),
     .we(valid_in),
     .data_in(data_in),
     .data_out(Code),
     .valid_out(valid_out_fifo),
     .write_address(write_address)
 );
//--------------------------------------------------------------------------------------------------------------------//
VITERBIDECODER viterbi_decoder (
    .Reset(reset_viterbi), 
    .CLOCK(clk), 
    .Active(active), 
    .Code(Code), 
    .DecodeOut(decode_out),
    .valid_out(valid_out_viterbi),
    .valid_in(active),
    .TB_enable(TB_enable),
    .ACS_counter(ACS_counter),
    .TB_stop(TB_stop)
    );
//------------------------------------------------------------------------------------------------------------------------------//
top_controller top_cntrl(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .TB_enable(TB_enable),
    .ACS_counter(ACS_counter),
    .TB_stop(TB_stop),
    .valid_out_fifo(valid_out_fifo),
    .valid_out(valid_out_viterbi),
    .write_address(write_address),
    .enable(enable),
    .reset_viterbi(reset_viterbi),
    .active(active),
    .max_read_address(max_read_address),
    .re_buffer(re_buffer),
    .re(re)
);
//------------------------------------------------------------------------------------------------------------------------------//
viterbi_buffer vit_buffer (
    .clk(clk),
	.reset(reset),
	.re(re_buffer),
	.we(valid_out_viterbi),
	.data_in(decode_out),
	.max_read_address(max_read_address),
	.reset_all(reset_all),
	.data_out(data_out),
	.valid_out(valid_out),
	.finished(finished)
);
//----------------------------------------------------------------------------------------------------------------------//
reset_control reset_cntrl(
    .clk(clk),
    .RESET(RESET),
    .reset_all(reset_all),
    .reset(reset)
);
	/*always@(posedge clk or negedge RESET)
	if(reset & valid_out_fifo) $display(Code);*/
endmodule
//========================================================================================================================//
module reset_control(
input clk,
input RESET,
input reset_all,
output reg reset
);
always @(posedge clk or negedge RESET)
begin
    if(!RESET) 
    begin
        reset<=0;
    end
    else
    begin
        if(!reset_all) reset<=0;
        else reset<=1;    
    end
end
endmodule
//--------------------------------------------------------------------------------------------------------------------//
