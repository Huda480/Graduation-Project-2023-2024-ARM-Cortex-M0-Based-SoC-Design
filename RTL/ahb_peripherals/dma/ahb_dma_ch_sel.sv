/////////////////////////////////////////////////////////////////////
////  AHB DMA Channel Select                                     ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
module ahb_dma_ch_sel(
clk,
rst,
req_i, ack_o,
pointer_DESC,
pointer_S,
ch_csr,
ch_txsz,
ch_adr0,
ch_adr1,
ch_am0,
ch_am1,
ch_sel,
gedak_5ofo,
csr,
pointer,
txsz,
adr0,
adr1,
am0,
am1,
ack_for_req,
dma_dst_req,
source_req_done,
need_dst_req_for_this_channel,
real_pref_to_pref,
selected_real_pref_to_pref,
pointer_s,
next_ch,
de_ack,
dma_busy,
destination_request,
saved_channel_burst,
saved_channel_no_burst,
save_this_channel_burst,
source_req_done_for_channel,
save_this_channel_no_burst);
//==========================================================================
// Parameters
//==========================================================================
parameter	[1:0]   pri_sel   = 2'd2;
parameter   [5:0]   channel_number = 15;
parameter           channel_number_bits = $clog2(channel_number);
localparam      	power =pri_sel+1'b1;
localparam  [3:0]   pri_sel_instance = 2**power;
//==========================================================================
// Inputs & Outputs
//==========================================================================
input								clk  ;
input       						rst  ;
input  [channel_number-1:0]			req_i;
output [channel_number-1:0]			ack_o;
input  [31:0]  						pointer_DESC [0:channel_number-1] ;
input  [31:0]  						pointer_S    [0:channel_number-1] ;
input  [31:0]  						ch_csr       [0:channel_number-1] ;
input  [31:0]  						ch_txsz      [0:channel_number-1] ;
input  [31:0]  						ch_adr0      [0:channel_number-1] ;
input  [31:0]  						ch_adr1      [0:channel_number-1] ;
input  [31:0]  						ch_am0       [0:channel_number-1] ;
input  [31:0]  						ch_am1       [0:channel_number-1] ;
output [channel_number_bits-1:0]	ch_sel;
output [channel_number_bits-1:0]    saved_channel_burst;
output [channel_number_bits-1:0]    saved_channel_no_burst;
output		    					gedak_5ofo;	
output	[31:0]						csr;		
output	[31:0]						pointer;	
output	[31:0]						pointer_s;	
output	[31:0]						txsz;		
output	[31:0]						adr0, adr1;	
output	[31:0]						am0, am1;	
input		    					next_ch;	
input								de_ack;		
input								dma_busy;
output  [channel_number-1:0]    	ack_for_req;
output                              destination_request;
input   [channel_number-1:0]    	dma_dst_req;
output  [channel_number-1:0]        source_req_done_for_channel;
input                               source_req_done;
input                               need_dst_req_for_this_channel;
input   [channel_number-1:0]    	real_pref_to_pref;
output                              selected_real_pref_to_pref;
input                               save_this_channel_burst;
input                               save_this_channel_no_burst;
//==========================================================================
// Macro
//==========================================================================
`include "ahb_dma_defines.svh"
//==========================================================================
// Internal signls
//==========================================================================
	reg	 [channel_number-1:0]		ack_o;
	reg  [channel_number-1:0]    	ack_for_req;
	reg  [channel_number-1:0]		valid;		
	reg	 [channel_number-1:0]		req_r;		
	reg		    					valid_sel;
	reg                             destination_request;
	wire [2:0]						pri_out;
	reg  [2:0]						pri_ch [0:channel_number-1] ;
	reg	 [channel_number_bits-1:0]	ch_sel_d;
	reg	 [channel_number_bits-1:0]	ch_sel_r;
	reg  [channel_number_bits-1:0]  saved_channel_burst;
	reg  [channel_number_bits-1:0]  saved_channel_no_burst;
	reg		    					next_start;
	reg		    					de_start_r;
	reg	 [31:0]						csr;		
	reg	 [31:0]						pointer;
	reg	 [31:0]						pointer_s;
	reg	 [31:0]						txsz;		
	reg	 [31:0]						adr0, adr1;	
	reg	 [31:0]						am0, am1;	
	reg  [channel_number-1:0]       req_p     [0:pri_sel_instance-1] ;
	wire [channel_number_bits-1:0]  gnt_p_d   [0:pri_sel_instance-1] ;
	reg  [channel_number_bits-1:0]  gnt_p     [0:pri_sel_instance-1] ;
	reg  [channel_number-1:0]       need_dst_req;
	reg  [channel_number-1:0]       source_req_done_for_channel;
	reg								selected_real_pref_to_pref;
//==========================================================================
// Main code
//==========================================================================
	integer nn;
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		req_r <= 'b0;
		else
		begin
			for(nn = 0 ;nn < channel_number;nn = nn + 1)
			begin
				if(need_dst_req[nn])
				req_r[nn] <=  dma_dst_req[nn] & ~ack_o[nn];
				else
				req_r[nn] <=  req_i[nn] & ~ack_o[nn];
			end
		end
	end
			
		
	/////////////////////////////////////////////////////////////////////
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		ack_for_req <= 'b0;
		else if (source_req_done_for_channel[ch_sel])
		ack_for_req [ch_sel] <= dma_dst_req [ch_sel];
		else
		ack_for_req [ch_sel] <= req_i [ch_sel];
	end
	/////////////////////////////////////////////////////////////////////
	assign gedak_5ofo = (valid_sel & !de_start_r ) | next_start;
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk)
		de_start_r <=  valid_sel;
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk)
		next_start <=  next_ch & valid_sel;
	/////////////////////////////////////////////////////////////////////
	integer i,j;
	generate
	always_comb 
	begin
		for(i=0;i<channel_number;i=i+1)
		begin
			pri_ch[i][0] = ch_csr[i][13];
			pri_ch[i][1] = (pri_sel != 2'd0) ? ch_csr[i][14] : 1'b0;
			pri_ch[i][2] = (pri_sel == 2'd2) ? ch_csr[i][15] : 1'b0;
			valid[i] = (ch_csr[i][`WDMA_MODE]) ? (req_r[i] & !ack_o[i]) : (ch_csr[i][`WDMA_CH_EN]);
		end
	end
	/////////////////////////////////////////////////////////////////////
	always@(posedge clk)
	begin
		for(j=0;j<channel_number;j=j+1)
		begin
			ack_o[j] <= (ch_sel == j) & ch_csr[j][`WDMA_MODE] & de_ack;
		end
	end
	endgenerate
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk or negedge rst)
	begin	
		if(!rst)
		begin
			ch_sel_r <=  0;
		end
		else if(gedak_5ofo)
		begin	
			ch_sel_r <=  ch_sel_d;
		end
	end
	/////////////////////////////////////////////////////////////////////
	assign ch_sel = !dma_busy ? ch_sel_d : ch_sel_r;
	/////////////////////////////////////////////////////////////////////
	always_comb
	begin
			pointer   					= pointer_DESC [ch_sel];
			pointer_s 					= pointer_S    [ch_sel];
			csr       					= ch_csr       [ch_sel];
			txsz      					= ch_txsz      [ch_sel];
			adr0      					= ch_adr0      [ch_sel];
			adr1      					= ch_adr1      [ch_sel];
			am0       					= ch_am0       [ch_sel];
			am1       					= ch_am1       [ch_sel];
			destination_request 		= dma_dst_req  [ch_sel] & need_dst_req [ch_sel];
			selected_real_pref_to_pref  = real_pref_to_pref[ch_sel];
			valid_sel 					= valid[ch_sel];
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		saved_channel_burst <= 'b0;
		else if (save_this_channel_burst)
		saved_channel_burst <= ch_sel;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		saved_channel_no_burst <= 'b0;
		else if (save_this_channel_no_burst)
		saved_channel_no_burst <= ch_sel;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		source_req_done_for_channel <= 'b0;
		else if(source_req_done)
			source_req_done_for_channel [ch_sel] <= !source_req_done_for_channel [ch_sel] ;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		need_dst_req <= 'b0;
		else if(need_dst_req_for_this_channel)
		need_dst_req [ch_sel] <= !need_dst_req [ch_sel] ;
	end
	/////////////////////////////////////////////////////////////////////
	always_comb 
	begin
		ch_sel_d = gnt_p[pri_out];
	end
	/////////////////////////////////////////////////////////////////////
	ahb_dma_ch_pri_enc #(pri_sel,channel_number) channel_priority_encoder(
	.clk(clk),
	.valid(valid),
	.pri_ch(pri_ch),
	.pri_out(pri_out));
	/////////////////////////////////////////////////////////////////////
	genvar d;
	genvar w;
	generate
		for(d=0;d<pri_sel_instance;d=d+1)
		begin
			ahb_dma_ch_arb #(channel_number,channel_number_bits) priorityd(
			.clk    (clk	   ),
			.rst    (rst	   ),
			.req    (req_p[d]  ),
			.gnt    (gnt_p_d[d]),
			.advance(next_ch   ));
			always_comb
			begin
				gnt_p[d] = gnt_p_d[d] ;
			end
			for(w=0;w<channel_number;w=w+1)
			begin
				always_comb 
				begin
					req_p[d][w] = valid[w] & (pri_ch[w] == d) ;
				end
			end
		end
	endgenerate

endmodule