/*
======================================================================================
				Standard   : Bluetooth 
				Block name : DQPSK Demodulator
				Created By : Eslam Elnader
======================================================================================
*/
module QPSK_demapper_ble
(
    clk,
    clk_fast,
    reset,
    valid_in,
    data_in_re,
    data_in_im,
    valid_out,
    data_out
);
//-------------------------------------------------------------
input clk;
input clk_fast;
input reset;
input valid_in;
input [11:0] data_in_re;
input [11:0] data_in_im;
output valid_out;
output data_out; 
//-------------------------------------------------------------
wire [1:0] data_out_differential_decoder;
wire valid_out_differential_decoder;
reg valid_out;
reg data_out;
//-------------------------------------------------------------
(*DONT_TOUCH="yes"*)
QPSK_differential_decoder_ble differential_decoder
(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .data_in({(data_in_re[11]),(data_in_im[11])}),
    .valid_out(valid_out_differential_decoder),
    .data_out(data_out_differential_decoder)
);

//Edited: 11/6/2024 : syncing data_out and valid_out
reg [1:0] data_sync_ff1;
reg [1:0] data_sync_ff2;
reg valid_sync_ff1;
reg valid_sync_ff2;
//counter memicing slow_clk
reg count;
//-------------------------------------------------------------
//pulse of valid_out_differential_decoder
//2 always blocks to one at posedge other at negedge
///at posedge asserts syn_clks_flag
///at negedge asserts delayed_clks_flag
//in this always blocks we check the flags
///syn_clks_flag == 1       -> invert the count reg
///delayed_clks_flag == 1   ->  dont invert count
always @(posedge clk_fast or negedge reset)
begin
    if(reset==1'b0)
    begin
        data_out        <= 1'b0;
        valid_out       <= 1'b0;
        
        data_sync_ff1   <= 2'b00;
        data_sync_ff2   <= 2'b00;
        valid_sync_ff1  <= 2'b00;
        valid_sync_ff2  <= 2'b00;
        //********************
        count           <= 1'b0;       
    end
    else
    begin
        //sync valid_out
        valid_sync_ff1  <= valid_out_differential_decoder;
        valid_sync_ff2  <= valid_sync_ff1;
        valid_out       <= valid_sync_ff2;
        //sync data_out
        data_sync_ff1 <= data_out_differential_decoder;
        data_sync_ff2 <= data_sync_ff1;
        //counter
        if (valid_sync_ff1 == 1'b1) begin
            count           <= ~count;
        end
        else begin
            count           <= 1'b0;
        end
        if(count == 1'b0)   data_out <= data_sync_ff2[0];
        else                data_out <= data_sync_ff2[1];
    end
end
//-------------------------------------------------------------
endmodule
//================================================================================
module QPSK_differential_decoder_ble
(
    clk,
    reset,
    valid_in,
    data_in,
    valid_out,
    data_out
);
//------------------------------------------------------------------
input clk;
input reset;
input valid_in;
input [1:0] data_in;
output valid_out;
output [1:0] data_out;
//------------------------------------------------------------------
reg [1:0] data_delayed;
reg [1:0] previous_input;
reg valid_out;
wire [1:0] data_out_temp_1;
wire [1:0] data_out_temp_2;
wire [1:0] data_out_temp_3;
wire [1:0] data_out_temp_4;
//------------------------------------------------------------------
assign data_out_temp_1=(previous_input==2'b00)? 2'b00:
                       (previous_input==2'b01)? 2'b01:
                       (previous_input==2'b11)? 2'b11:
                                                2'b10;
//______________________________________________________
assign data_out_temp_2=(previous_input==2'b00)? 2'b10:
                       (previous_input==2'b01)? 2'b00:
                       (previous_input==2'b11)? 2'b01:
                                                2'b11;
//______________________________________________________
assign data_out_temp_3=(previous_input==2'b00)? 2'b11:
                       (previous_input==2'b01)? 2'b10:
                       (previous_input==2'b11)? 2'b00:
                                                2'b01;
//______________________________________________________
assign data_out_temp_4=(previous_input==2'b00)? 2'b01:
                       (previous_input==2'b01)? 2'b11:
                       (previous_input==2'b11)? 2'b10:
                                                2'b00;
//______________________________________________________                                                                                                
assign data_out=(data_delayed==2'b00)? data_out_temp_1:
                (data_delayed==2'b01)? data_out_temp_2:
                (data_delayed==2'b11)? data_out_temp_3:
                                       data_out_temp_4;    
//------------------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        previous_input <= 2'b00;
        data_delayed   <= 2'b00;
        valid_out      <= 1'b0;
    end
    else
    begin
        if(valid_in==1'b1)
        begin
            data_delayed   <= data_in;
            previous_input <= data_delayed;
            valid_out      <= 1'b1;
        end
        else
        begin
            previous_input <= 2'b00;
            data_delayed   <= 2'b00;
            valid_out      <= 1'b0;
        end
    end
end
//------------------------------------------------------------------
endmodule