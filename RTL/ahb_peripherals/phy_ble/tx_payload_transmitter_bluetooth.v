/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Payload Transmitter Chain
				Created By : Eslam Elnader
======================================================================================
*/
module top_transmitter_bt_payload_ble #(parameter RE_IM_SIZE=12)
(
    clk,
    reset,
    valid_in,
    data_in,
    UAP,
    n_bits,
    FEC_enable,
    CRC_enable,
    valid_out,
    data_out_real,
    data_out_imag,
    payload_mapper_data_in_count
);
//--------------------------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
input [7:0] UAP;
input [15:0] n_bits;
input FEC_enable;
input CRC_enable;
output [RE_IM_SIZE-1:0] data_out_real;
output [RE_IM_SIZE-1:0] data_out_imag;
output valid_out;
output [11:0] payload_mapper_data_in_count;
//--------------------------------------------------------------------------
// CRC
wire data_out_crc_block;
wire data_out_crc;
wire valid_out_crc_block;
wire valid_out_crc;
// Whitening
wire valid_out_whitening;
wire data_out_whitening;
wire finished_whitening;
// Encoder
wire [15:0] n_bits_encoder;
wire valid_out_encoder;
wire data_out_encoder;
wire finished_encoder;
wire valid_out_encoder_block;
wire data_out_encoder_block;
wire finished_encoder_block;
// Mapper
wire finished_mapper;

reg [11:0] payload_mapper_data_in_count;
//--------------------------------------------------------------------------
// CRC
(* keep_hierarchy = "yes" *) 
top_controlled_crc_bluetooth_ble payload_crc
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.valid_in(valid_in),
	.data_in(data_in),
	.uap_dci(UAP),
	.finished(),
	.valid_out(valid_out_crc_block),
	.data_out(data_out_crc_block),
	.flag(),
	.num_after_crc()
); 
assign data_out_crc   = (CRC_enable==1'b1)? data_out_crc_block:data_in; 
assign valid_out_crc  = (CRC_enable==1'b1)? valid_out_crc_block:valid_in;
assign n_bits_encoder = (CRC_enable==1'b1)? n_bits+16'd16 : n_bits;
//--------------------------------------------------------------------------
// Whitening

(* keep_hierarchy = "yes" *) 
whitening_ble payload_Whitening
(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_out_crc),
    .data_in(data_out_crc),
    .enable(finished_encoder),
    .int_D(6'd0),
    .valid_out(valid_out_whitening),
    .data_out(data_out_whitening),
    .finished(finished_whitening)
);
//--------------------------------------------------------------------------
// Encoder
(* keep_hierarchy = "yes" *) 
top_controlled_encoder_ble payload_encoder
(
    .clk(clk),
    .reset(reset),
    .data_in(data_out_whitening),
    .valid_in(valid_out_whitening),
    .n_bits(n_bits_encoder),
    .enable(finished_mapper),
    .valid_out(valid_out_encoder_block),
    .data_out(data_out_encoder_block),
    .finished(finished_encoder_block)
);
assign data_out_encoder  =(FEC_enable==1'b1)? data_out_encoder_block : data_out_whitening;
assign valid_out_encoder =(FEC_enable==1'b1)? valid_out_encoder_block : valid_out_whitening;
assign finished_encoder  =(FEC_enable==1'b1)? finished_encoder_block : 1'b1;
//--------------------------------------------------------------------------
// Mapper
//(* keep_hierarchy = "yes" *) 
(*DONT_TOUCH="yes"*)
QPSK_ble #(RE_IM_SIZE) payload_mapper
(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_out_encoder),
    .data_in(data_out_encoder),
    .enable(1'b1),
    .valid_out(valid_out),
    .data_out_re(data_out_real),
    .data_out_im(data_out_imag),
    .finished(finished_mapper)
);
//--------------------------------------------------------------------------
// Counter for encoder output bits                                          
    always@(posedge clk or negedge reset) begin                             
        if(!reset) begin                                                    
            payload_mapper_data_in_count    <=0;                                    
        end                                                                 
        else begin                                                          
            if(valid_out) begin                                     
                payload_mapper_data_in_count <= payload_mapper_data_in_count +1;            
            end                                                             
        end                                                                 
    end                                                                     
//--------------------------------------------------------------------------
endmodule