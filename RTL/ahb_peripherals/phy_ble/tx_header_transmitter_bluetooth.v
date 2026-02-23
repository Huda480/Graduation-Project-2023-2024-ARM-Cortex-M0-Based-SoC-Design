/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Header Transmitter Chain
				Created By : Eslam Elnader
======================================================================================
*/
module top_transmitter_bt_header_ble #(parameter RE_IM_SIZE=12)
(
    clk,
    reset,
    valid_in,
    data_in,
    UAP,
    valid_out,
    data_out_real,
    data_out_imag,
    header_mapper_data_in_count
);
//--------------------------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
input [7:0] UAP;
output [RE_IM_SIZE-1:0] data_out_real;
output [RE_IM_SIZE-1:0] data_out_imag;
output valid_out;
output [11:0] header_mapper_data_in_count;
//--------------------------------------------------------------------------
// CRC
wire data_out_hec;
wire valid_out_hec;
// Whitening
wire valid_out_whitening;
wire data_out_whitening;
wire finished_whitening;
// Encoder
wire valid_out_encoder;
wire data_out_encoder;
// Mapper
wire finished_mapper;
// mapper data in counter
reg [11:0] header_mapper_data_in_count;
//--------------------------------------------------------------------------
// HEC
(* keep_hierarchy = "yes" *) 
top_controlled_hec_bluetooth_ble header_hec
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.valid_in(valid_in),
	.data_in(data_in),
	.uap_dci(UAP),
	.finished(),
	.valid_out(valid_out_hec),
	.data_out(data_out_hec),
	.flag(),
	.num_after_hec()
);
//--------------------------------------------------------------------------
// Whitening

(* keep_hierarchy = "yes" *) 
whitening_ble header_Whitening
(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_out_hec),
    .data_in(data_out_hec),
    .enable(1'b1),
    //Edited: 5/6/2024
    .int_D(6'd0),
    .valid_out(valid_out_whitening),
    .data_out(data_out_whitening),
    .finished(finished_whitening)
);
//--------------------------------------------------------------------------
// Encoder
(* keep_hierarchy = "yes" *) 
repetition_encoder_ble #(14,1,16384) header_encoder
(
	.clk(clk),
	.reset(reset),
	.re(finished_mapper),
	.we(valid_out_whitening),
	.data_in(data_out_whitening),
	.data_out(data_out_encoder),
	.valid_out(valid_out_encoder)
);
//--------------------------------------------------------------------------
// Mapper
//(* keep_hierarchy = "yes" *)
(*DONT_TOUCH="yes"*) 
QPSK_ble #(RE_IM_SIZE) header_mapper
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
            header_mapper_data_in_count    <=0;
        end
        else begin
            if(valid_out) begin
                header_mapper_data_in_count <= header_mapper_data_in_count +1;
            end
        end
    end
//--------------------------------------------------------------------------
endmodule
