//Last Edited: 26/6/2024
module top_rx_ble #(parameter DATA=32)
(
    clk,
    clk_fast,
    reset,
    valid_in,
    data_in_re,
    data_in_im,
    UAP,
    payload_size,
    header_size,
    FEC_enable,
    CRC_enable,
    rx_irq_en,
    rx_irq_clear,
    dma_ack,
    dma_mode,
    valid_out,
    error_flag,
    data_out,
    //Edited 26/6/2024
    //data_out_from_output_ram,
    //valid_out_from_output_ram
    data_out_parallel,
    done_sipo,
    finish_write_output_ram,
    rx_irq,
    chain_clr_rx_irq,
    rx_dma_req,
    rx_dma_done
);
//------------------------------------------------------
input clk;
input clk_fast;
input reset;
input valid_in;
input [11:0] data_in_re;
input [11:0] data_in_im;
input [7:0] UAP;
input [15:0] payload_size;
input [15:0] header_size;
input FEC_enable;
input CRC_enable;
input rx_irq_en;
input rx_irq_clear;
input dma_ack;
input dma_mode; 
output valid_out;
output data_out;
output error_flag;
//Edited: 26/6/2024
//output [31:0] data_out_from_output_ram;
//output valid_out_from_output_ram;
//Edited 2/7/2024
output [DATA-1:0] data_out_parallel;
output done_sipo;
output finish_write_output_ram;
output rx_irq;
output reg chain_clr_rx_irq;
output rx_dma_req;

input rx_dma_done;
//------------------------------------------------------
wire data_out_header;
wire valid_out_header;
wire error_flag_header;
wire data_out_payload;
wire valid_out_payload;
wire error_flag_payload;
//Edited: 26/6/2024
wire finished_decrc;
//wire [31:0] data_out_from_output_ram;
//wire valid_out_from_output_ram;
reg finished_decrc_delayed;
//------------------------------------------------------
reg valid_in_happened;
reg valid_in_counter;
//reg valid_in_header;
reg rx_irq_flag;
//------------------------------------------------------
reg rx_dma_req_flag;
wire finish_rx_pulse;

reg rx_dma_ack_reg;
//------------------------------------------------------
(* keep_hierarchy = "yes" *) 
top_receiver_bt_header_ble rx_header
(
    .clk(clk),
    .clk_fast(clk_fast),
    .reset(reset),
    .data_in_re(data_in_re),
    .data_in_im(data_in_im),
    .valid_in(valid_in & ~valid_in_counter),
    .UAP(UAP),
    .n_bits(header_size),
    .header_error_flag(error_flag_header),
    .data_out(data_out_header),
    .valid_out(valid_out_header)
);
//-----------------------------------------------------------
(* keep_hierarchy = "yes" *) 
top_receiver_bt_payload_ble rx_payload
(
    .clk(clk),
    .clk_fast(clk_fast),
    .reset(reset),
    .UAP(UAP),
    .data_in_re(data_in_re),
    .data_in_im(data_in_im),
    .valid_in(valid_in & valid_in_counter),
    .n_bits(payload_size),
    .FEC_enable(FEC_enable),
    .CRC_enable(CRC_enable),
    .data_out(data_out_payload),
    .payload_error_flag(error_flag_payload),
    .valid_out(valid_out_payload),
    //Edited: 26/6/2024
    //added this to test the reading from the output ram after finishing the decrc
    .finished_decrc(finished_decrc)
);
    //============================================================================
    //parallel in serial out
	//============================================================================
   serial_in_parallel_out_ble #(DATA) sipo 
        (
            .clk(clk_fast),
            .reset(reset), 
            .data_in(data_out), 
            .data_out(data_out_parallel),
            .done(done_sipo),
            .we(valid_out)
        );
    //============================================================================
//--------------------------------------------------------------------
assign valid_out = valid_out_payload | valid_out_header;
assign data_out  = (valid_out_header==1'b1)? data_out_header : data_out_payload;
assign error_flag= error_flag_payload | error_flag_header;
//------------------------------------------------------
//finish_write_output_ram is a pulse that tells that this is the last valid data to enter
//we need to know when to finish writing to assert the done signal at the end 
////and capture the last bits correctly
//finish_write_output_ram pulse asserts when finished_decrc turns high
//without it the last 32 bits are not written
assign finish_write_output_ram = finished_decrc & (~finished_decrc_delayed);
	//finished_decrc_delayed signal to genrate pulse of finished_decrc
always@(posedge clk_fast or negedge reset)
	begin
		if(!reset) begin
			 finished_decrc_delayed	  <= 0;
		end
		else
		begin
		    finished_decrc_delayed <= finished_decrc;  
	    end	
	end 
	
assign finish_rx_pulse = finish_write_output_ram;
	
//Rx Interrupt Signal Assertion
always @(posedge clk or negedge reset) begin
    if (~reset) begin
        rx_irq_flag<= 0;
        chain_clr_rx_irq <= 1'b0;
    end
    else begin
        if (rx_irq_clear) begin
            rx_irq_flag <= 1'b0;
            chain_clr_rx_irq <= 1'b1;
        end
        else if(finish_rx_pulse) begin
            rx_irq_flag <= 1'b1;
        end
    end  
end
assign rx_irq = (rx_irq_flag & rx_irq_en)? 1'b1: 1'b0;


//generating RX DMA REQ flag signal (If RX finished writting in the FIFO)
always @(posedge clk or negedge reset) begin
    if (~reset) begin
        rx_dma_ack_reg <= 1'b0;
    end   
    else if (dma_ack) begin
         rx_dma_ack_reg <= 1'b1;
    end
    else if (rx_dma_done) begin
        rx_dma_ack_reg <= 1'b0; //saving the pulse assertion
    end
end

always @(posedge clk or negedge reset) begin
    if (~reset) begin
        rx_dma_req_flag <= 1'b0;
    end   
    else begin
        if (rx_dma_ack_reg) begin
           rx_dma_req_flag <= 1'b0;
        end
        else if (finish_rx_pulse) begin
            rx_dma_req_flag <= 1'b1; //saving the pulse assertion
        end
    end
end 
//Rx DMA REQ Signal Assertion
assign rx_dma_req = (dma_mode & rx_dma_req_flag) ? 1'b1:1'b0; 

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
endmodule
