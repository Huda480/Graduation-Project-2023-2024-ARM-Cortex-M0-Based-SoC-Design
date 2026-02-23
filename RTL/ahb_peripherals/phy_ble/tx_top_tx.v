module top_tx_ble #(parameter RE_IM_SIZE=12)
(
    clk,
    reset,
    valid_in,
    data_in,
    UAP,
    payload_size,
    FEC_enable,
    CRC_enable,
    tx_irq_en,
    valid_out,
    data_out_re,
    data_out_im,
    header_mapper_data_in_count,
    payload_mapper_data_in_count,
    tx_irq_pulse,
    tx_irq,
    tx_irq_clear,
    chain_clr_tx_irq
);
//------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
input [7:0] UAP;
input [15:0] payload_size;
input FEC_enable;
input CRC_enable;
input tx_irq_en;
input tx_irq_clear;
output valid_out;
output [RE_IM_SIZE-1:0] data_out_re;
output [RE_IM_SIZE-1:0] data_out_im;
output [11:0] header_mapper_data_in_count;
output [11:0] payload_mapper_data_in_count;
output tx_irq_pulse;
output tx_irq;
output reg chain_clr_tx_irq;
//------------------------------------------------------
wire valid_out_tx_header;
wire [RE_IM_SIZE-1:0] data_out_re_tx_header;
wire [RE_IM_SIZE-1:0] data_out_im_tx_header;
wire valid_out_tx_payload;
reg valid_out_tx_payload_delayed;
wire [RE_IM_SIZE-1:0] data_out_re_tx_payload;
wire [RE_IM_SIZE-1:0] data_out_im_tx_payload;
reg valid_in_happened;
reg valid_in_counter;
reg tx_irq_flag;
//------------------------------------------------------
(* keep_hierarchy = "yes" *) 
top_transmitter_bt_header_ble #(RE_IM_SIZE)tx_header
(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in & ~(valid_in_counter)),
    .data_in(data_in),
    .UAP(UAP),
    .valid_out(valid_out_tx_header),
    .data_out_real(data_out_re_tx_header),
    .data_out_imag(data_out_im_tx_header),
    .header_mapper_data_in_count(header_mapper_data_in_count)
);
//-----------------------------------------------------------
(* keep_hierarchy = "yes" *) 
top_transmitter_bt_payload_ble #(RE_IM_SIZE) tx_payload
(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in & valid_in_counter),
    .data_in(data_in),
    .UAP(UAP),
    .n_bits(payload_size),
    .FEC_enable(FEC_enable),
    .CRC_enable(CRC_enable),
    .valid_out(valid_out_tx_payload),
    .data_out_real(data_out_re_tx_payload),
    .data_out_imag(data_out_im_tx_payload),
    .payload_mapper_data_in_count(payload_mapper_data_in_count)
);
//------------------------------------------------------
assign valid_out = valid_out_tx_header|valid_out_tx_payload;
assign data_out_re=(valid_out_tx_header==1'b1)? data_out_re_tx_header:data_out_re_tx_payload;
assign data_out_im=(valid_out_tx_header==1'b1)? data_out_im_tx_header:data_out_im_tx_payload;
//------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        valid_in_counter        <= 1'b0;
        valid_in_happened       <= 1'b0;
    end
    else
    begin
        if(valid_in==1'b1)
            valid_in_happened <= 1'b1;
        else
        begin
            if(valid_in_happened==1'b1)
            begin
                valid_in_counter    <= ~(valid_in_counter);
                valid_in_happened   <= 1'b0;
            end
        end
    end
end
//------------------------------------------------------

//generating tx_irq_pulse, tx finish ppulse interupt
assign tx_irq_pulse = valid_out_tx_payload_delayed & (~valid_out_tx_payload);

//generating Tx interrupt signal (If master is enabling an interrupt)
always @(posedge clk or negedge reset) begin
    if (~reset) begin
        tx_irq_flag <= 1'b0;
        chain_clr_tx_irq <= 0;
    end   
    else begin
        if (tx_irq_clear) begin
           tx_irq_flag <= 1'b0;
           chain_clr_tx_irq <= 1'b1; 
        end
        else if (tx_irq_pulse) begin
            tx_irq_flag <= 1'b1; //saving the pulse assertion
        end
    end
end 
assign tx_irq = (tx_irq_flag && tx_irq_en)? 1'b1 : 1'b0;

always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        valid_out_tx_payload_delayed        <= 1'b0;
    end
    else
    begin
        valid_out_tx_payload_delayed        <= valid_out_tx_payload;
    end
end
//------------------------------------------------------

endmodule
