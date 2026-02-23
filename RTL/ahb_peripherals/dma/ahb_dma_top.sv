/////////////////////////////////////////////////////////////////////
////  AHB DMA Top                                                ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
module ahb_dma_top(clk_i, rst_i,
sHSEL,
sHADDR,
sHWDATA,
sHRDATA,
sHWRITE,
sHSIZE,
sHBURST,
sHPROT,
sHTRANS,
sHREADYOUT,
sHREADY,
sHRESP,
m0HADDR,
m0HWDATA,
m0HRDATA,
m0HWRITE,
m0HSIZE,
m0HBURST,
m0HPROT,
m0HTRANS,
m0HREADY,
m0HRESP,
dma_req_i,
dma_ack_o,
dma_rest_i,
ch_done_all_transfer,
ack_for_req,
irqa_o);
//==========================================================================
// Parameters
//==========================================================================
parameter	[1:0]	pri_sel  = 2'd2;
parameter           channel_number = 15;
parameter           channel_number_bits = $clog2(channel_number);
parameter   [1:0]   ch_conf [31] = {2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0};
parameter           req_number = 31;
//==========================================================================
// Inputs & Outputs
//==========================================================================
input						clk_i;
input       				rst_i;
input                 		sHSEL     ;
input  [31:0]         		sHADDR    ;
input  [31:0]         		sHWDATA   ;
output [31:0]         		sHRDATA   ;
input                 		sHWRITE   ;
input  [ 2:0]         		sHSIZE    ;
input  [ 2:0]         		sHBURST   ;
input  [ 3:0]         		sHPROT    ;
input  [ 1:0]         		sHTRANS   ;
output                		sHREADYOUT;
input                 		sHREADY   ;
output                		sHRESP    ;
output [31:0]         		m0HADDR ;
output [31:0]         		m0HWDATA;
input  [31:0]         		m0HRDATA;
output                		m0HWRITE;
output [ 2:0]         		m0HSIZE ;
output [ 2:0]         		m0HBURST;
output [ 3:0]         		m0HPROT ;
output [ 1:0]         		m0HTRANS;
input                 		m0HREADY;
input                 		m0HRESP ;
input  [req_number-1:0]    	dma_req_i;
output [req_number-1:0]	    dma_ack_o;
input  [channel_number-1:0]	dma_rest_i;
output						irqa_o;
output [req_number-1:0]     ch_done_all_transfer;
output [req_number-1:0]     ack_for_req;
//==========================================================================
// Internal signls
//==========================================================================
	wire  [31:0]  					pointer_DESC    [0:channel_number-1] ;
	wire  [31:0]  					pointer_S       [0:channel_number-1] ;
	wire  [31:0]  					ch_csr          [0:channel_number-1] ;
	wire  [31:0]  					ch_txsz         [0:channel_number-1] ;
	wire  [31:0]  					ch_adr0         [0:channel_number-1] ;
	wire  [31:0]  					ch_adr1         [0:channel_number-1] ;
	wire  [31:0]  					ch_am0          [0:channel_number-1] ;
	wire  [31:0]  					ch_am1          [0:channel_number-1] ;
	wire  [31:0]  					ch_csr_REQ      [0:channel_number-1] ;
	wire  [channel_number_bits-1:0]	ch_sel;
	wire  [channel_number_bits-1:0] saved_channel_burst;
	wire  [channel_number_bits-1:0] saved_channel_no_burst;
	wire		    				gedak_5ofo;	
	wire  [31:0]					csr;		
	wire  [31:0]					pointer;
	wire  [31:0]					pointer_s;
	wire  [31:0]					txsz;		
	wire  [31:0]					adr0, adr1;
	wire  [31:0]					am0, am1;
	wire		    				next_ch;
	wire		    				irqa_o;
	wire		    				dma_abort;
	wire		    				dma_busy;
	wire		    				dma_err;
	wire		    				dma_done;
	wire		    				dma_done_all;
	wire  [31:0]					de_csr;
	wire  [11:0]					de_txsz;
	wire  [31:0]					de_adr0;
	wire  [31:0]					de_adr1;
	wire		    				de_csr_we;
	wire		    				de_txsz_we;
	wire		    				de_adr0_we;
	wire		    				de_adr1_we; 
	wire		    				de_fetch_descr;
	wire		    				ptr_set;
	wire		    				de_ack;
	wire		    				pause_req;
	wire		    				paused;		
	wire		    				mast0_we;	
	wire  [31:0]					mast0_adr;	
	wire  [31:0]					mast0_din;	
	wire  [31:0]					mast0_dout;	
	wire		    				mast0_err;	
	wire		    				mast0_drdy;
	wire		    				mast0_wait;	
	wire  [31:0]					slv0_adr_write;
	wire  [31:0]    				slv0_adr_read;
	wire  [31:0]					slv0_din;	
	wire  [31:0]					slv0_dout;	
	wire		    				slv0_re;	
	wire		    				slv0_we;		
	wire		    				mast1_we;	
	wire  [31:0]					mast1_adr;	
	wire  [31:0]					mast1_din;	
	wire  [31:0]					mast1_dout;	
	wire		    				mast1_err;	
	wire		    				mast1_drdy;	
	wire		    				mast1_wait;	
	wire            				slave_wait0;
	wire            				slave_wait1;
	wire  [channel_number-1:0]		dma_req;
	wire  [channel_number-1:0]      dma_dst_req;
	wire  [channel_number-1:0]		dma_ack;
	wire  [channel_number-1:0]		dma_rest;
	wire  [channel_number-1:0]    	dma_req_arb;
	wire  [channel_number-1:0]    	dma_ack_arb;
	wire  [channel_number-1:0]    	dma_done_arb;
	wire           					seq_transfer;
	wire           					no_trnasfer;
	wire                            seq_transfer_desc;
	wire                            burst_desc;
	wire           		            destination_request;	
	wire           		            resume;
	wire           		            no_more_peripheral_to_peripheral_burst_reg;
	wire 							no_more_peripheral_to_peripheral_no_burst_reg;
	wire                            source_req_done;
	wire                            wait_for_dst_req;
	wire [channel_number-1:0]       real_pref_to_pref;
	wire    						selected_real_pref_to_pref;
	wire                            save_this_channel_no_burst;
	wire                            save_this_channel_burst;
	wire                            no_trnasfer_linked_list_dascreptor;
	wire [channel_number-1:0]       source_req_done_for_channel;
//==========================================================================
// Main code
//==========================================================================
	assign dma_rest = dma_rest_i;
	/////////////////////////////////////////////////////////////////////
	req_arb #(.channel_number(channel_number),.system_req_number(req_number)) request_arbiter (
		.req(dma_req_i),
		.ch_ack(dma_ack_arb),
		.ch_done_all(dma_ack),
		.ch_csr_req(ch_csr_REQ),
		.ch_csr(ch_csr),
		.ch_req(dma_req),
		.dst_ch_req(dma_dst_req),
		.ack(ack_for_req),
		.source_req_done_for_channel(source_req_done_for_channel),
		.no_more_peripheral_to_peripheral_burst_reg(no_more_peripheral_to_peripheral_burst_reg),
		.no_more_peripheral_to_peripheral_no_burst_reg(no_more_peripheral_to_peripheral_no_burst_reg),
		.real_pref_to_pref(real_pref_to_pref),
		.saved_channel_burst(saved_channel_burst),
		.saved_channel_no_burst(saved_channel_no_burst),
		.done_all(dma_ack_o));
	/////////////////////////////////////////////////////////////////////
	ahb_dma_rf   #(.ch_conf(ch_conf),.channel_number(channel_number))
			REG_FILE(
			.clk				 (clk_i),
			.rst				 (rst_i),
			.ahb_address		 (slv0_adr_write[9:2]),
			.ahb_read_address	 (slv0_adr_read[9:2]),
			.ahb_write_data		 (slv0_din),
			.ahb_read_data		 (slv0_dout),
			.ahb_write_enable	 (slv0_we),
			.ahb_read_enable     (slv0_re),
			.irqa_o              (irqa_o),
			.ch_done_all_transfer(dma_done_arb),
			.ch_csr_REQ			 (ch_csr_REQ),
			.pointer_DESC   	 (pointer_DESC),
			.pointer_S			 (pointer_S),   
			.ch_csr_CTRL		 (ch_csr),         
			.ch_txsz_update		 (ch_txsz),        
			.ch_adr0_update		 (ch_adr0),        
			.ch_adr1_update		 (ch_adr1),
			.ch_am0				 (ch_am0),         
			.ch_am1				 (ch_am1),                 
			.ch_sel				 (ch_sel),
			.pause_req			 (pause_req),
			.paused				 (paused),
			.dma_busy			 (dma_busy),
			.dma_err			 (dma_err),
			.dma_done			 (dma_done),
			.dma_done_all		 (dma_done_all),
			.de_csr				 (de_csr),
			.de_txsz			 (de_txsz),
			.de_adr0			 (de_adr0),
			.de_adr1			 (de_adr1),
			.de_csr_we			 (de_csr_we),
			.de_txsz_we			 (de_txsz_we),
			.de_adr0_we			 (de_adr0_we),
			.de_adr1_we			 (de_adr1_we),
			.de_fetch_descr		 (de_fetch_descr),
			.dma_rest			 (dma_rest),
			.ptr_set			 (ptr_set));
	/////////////////////////////////////////////////////////////////////
	ahb_dma_ch_sel #(.pri_sel(pri_sel),.channel_number(channel_number))
			CHANNEL_SELECT(
			.clk		 (clk_i),
			.rst		 (rst_i),
			.req_i		 (dma_req),
			.ack_o		 (dma_ack),
			.pointer_DESC(pointer_DESC),
			.pointer_S   (pointer_S),   
			.ch_csr 	 (ch_csr),         
			.ch_txsz	 (ch_txsz),        
			.ch_adr0	 (ch_adr0),        
			.ch_adr1	 (ch_adr1),        
			.ch_am0		 (ch_am0),         
			.ch_am1		 (ch_am1),
			.ch_sel      (ch_sel),
			.gedak_5ofo	 (gedak_5ofo),
			.csr		 (csr),
			.pointer	 (pointer),
			.txsz		 (txsz),
			.adr0		 (adr0),
			.adr1		 (adr1),
			.am0		 (am0),
			.am1		 (am1),
			.pointer_s   (pointer_s),
			.next_ch	 (next_ch),
			.de_ack		 (de_ack),
			.ack_for_req (dma_ack_arb),
			.source_req_done_for_channel(source_req_done_for_channel),
			.destination_request(destination_request),
			.dma_dst_req(dma_dst_req),
			.source_req_done(source_req_done),
			.need_dst_req_for_this_channel(need_dst_req_for_this_channel),
			.real_pref_to_pref(real_pref_to_pref),
			.selected_real_pref_to_pref(selected_real_pref_to_pref),
			.save_this_channel_burst(save_this_channel_burst),
			.save_this_channel_no_burst(save_this_channel_no_burst),
			.saved_channel_burst(saved_channel_burst),
			.saved_channel_no_burst(saved_channel_no_burst),
			.dma_busy	 (dma_busy));
	/////////////////////////////////////////////////////////////////////
	ahb_dma_engine	DMA_ENGINE(
			.clk			(clk_i),
			.rst			(rst_i),
			.mast0_we		(mast0_we),
			.mast0_adr		(mast0_adr),
			.mast0_din		(mast0_din),
			.mast0_dout		(mast0_dout),
			.mast0_err		(mast0_err),
			.no_trnasfer	(no_trnasfer),
			.gedak_5ofo		(gedak_5ofo),
			.csr			(csr),
			.pointer		(pointer),
			.pointer_s		(pointer_s),
			.txsz			(txsz),
			.adr0			(adr0),
			.adr1			(adr1),
			.am0			(am0),
			.am1			(am1),
			.de_csr_we		(de_csr_we),
			.de_txsz_we	    (de_txsz_we),
			.de_adr0_we	    (de_adr0_we),
			.de_adr1_we	    (de_adr1_we),
			.de_fetch_descr (de_fetch_descr),
			.ptr_set	    (ptr_set),
			.de_csr 	    (de_csr),
			.de_txsz	    (de_txsz),
			.de_adr0	    (de_adr0),
			.de_adr1	    (de_adr1),
			.next_ch	    (next_ch),
			.de_ack		    (de_ack),
			.pause_req	    (pause_req),
			.paused		    (paused),
			.dma_busy	    (dma_busy),
			.dma_err	    (dma_err),
			.dma_done	    (dma_done),
			.slave_wait0    (slave_wait0),
			.seq_transfer   (seq_transfer),
			.seq_transfer_desc(seq_transfer_desc),
			.burst_desc(burst_desc),
			.destination_request(destination_request),
			.no_more_peripheral_to_peripheral_burst_reg(no_more_peripheral_to_peripheral_burst_reg),
			.source_req_done_for_this_channel(source_req_done),
			.need_dst_req_for_this_channel(need_dst_req_for_this_channel),
			.selected_real_pref_to_pref(selected_real_pref_to_pref),
			.save_this_channel_burst(save_this_channel_burst),
			.save_this_channel_no_burst(save_this_channel_no_burst),
			.no_more_peripheral_to_peripheral_no_burst_reg(no_more_peripheral_to_peripheral_no_burst_reg),
			.no_trnasfer_linked_list_dascreptor(no_trnasfer_linked_list_dascreptor),
			.dma_done_all   (dma_done_all));
	/////////////////////////////////////////////////////////////////////
	ahb_dma_master   master_if (
		.clk_i				(clk_i),
		.rst_n_i			(rst_i),
		.transfer_size		(csr[19:17]),
		.address			(mast0_adr),
		.write_enable		(mast0_we),
		.write_data			(mast0_dout),
		.error				(mast0_err),
		.read_data			(mast0_din),
		.mHSIZE				(m0HSIZE),
		.mHRDATA			(m0HRDATA),
		.mHRESP				(m0HRESP),
		.mHREADY			(m0HREADY),
		.mHWRITE			(m0HWRITE),
		.mHBURST			(m0HBURST),
		.mHADDR				(m0HADDR),
		.mHTRANS			(m0HTRANS),
		.mHWDATA			(m0HWDATA),
		.slave_wait			(slave_wait0),
		.burst_seq_transfer (seq_transfer),
		.burst				(csr[23:21]),
		.no_trnasfer		(no_trnasfer),
		.seq_transfer_desc(seq_transfer_desc),
		.burst_desc(burst_desc),
		.no_trnasfer_linked_list_dascreptor(no_trnasfer_linked_list_dascreptor),
		.mHPROT				(m0HPROT));
	/////////////////////////////////////////////////////////////////////
	ahb_dma_slave slave_if(
		.clk_i 					(clk_i), 
		.rst_n_i 				(rst_i),
		.sHADDR  				(sHADDR),  
		.sHWDATA 				(sHWDATA),  
		.sHWRITE 				(sHWRITE),  
		.sHREADYOUT 			(sHREADYOUT),
		.sHSIZE    				(sHSIZE),
		.sHBURST   				(sHBURST),
		.sHSEL     				(sHSEL),
		.sHTRANS   				(sHTRANS),
		.sHRDATA   				(sHRDATA),
		.sHRESP    				(sHRESP),
		.sHREADY   				(sHREADY),
		.sHPROT    				(sHPROT),
		.slave_write_data  		(slv0_din),
		.slave_write_address    (slv0_adr_write),
		.slave_read_address		(slv0_adr_read),  
		.slave_write_enable		(slv0_we),
		.slave_read_enable 		(slv0_re),      
		.slave_read_data   		(slv0_dout),    
		.slave_error     		(1'b0));

endmodule