/////////////////////////////////////////////////////////////////////
////  AHB DMA engine                                             ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
`include "ahb_dma_defines.svh"
/////////////////////////////////////////////////////////////////////
module ahb_dma_engine(clk, rst,
mast0_we,
mast0_adr,
mast0_din,
mast0_dout,
mast0_err,
no_trnasfer,
no_trnasfer_linked_list_dascreptor,
gedak_5ofo,
csr,
pointer,
pointer_s,
txsz,
seq_transfer_desc,
burst_desc,
adr0,
adr1,
am0,
am1,
de_csr_we,
de_txsz_we,
de_adr0_we,
de_adr1_we,
ptr_set,
de_csr,
de_txsz,
de_adr0,
de_adr1,
de_fetch_descr,
slave_wait0,
save_this_channel_burst,
save_this_channel_no_burst,
next_ch,
de_ack,
pause_req,
paused,
destination_request,
no_more_peripheral_to_peripheral_burst_reg,
no_more_peripheral_to_peripheral_no_burst_reg,
source_req_done_for_this_channel,
need_dst_req_for_this_channel,
selected_real_pref_to_pref,
dma_busy,
dma_err,
dma_done,
dma_done_all,
seq_transfer);
//==========================================================================
// Parameters
//==========================================================================
parameter     max_burst = 512;
parameter     max_p2p_burst = 2560;	
//==========================================================================
// Inputs & Outputs
//==========================================================================
input			clk;
input       	rst;	
output			mast0_we;	
output	[31:0]	mast0_adr;	
input	[31:0]	mast0_din;	
output	[31:0]	mast0_dout;	
input			mast0_err;	
output          no_trnasfer;
output          no_trnasfer_linked_list_dascreptor;			
input           slave_wait0;
///////////////////////////////////////////////////////
input			gedak_5ofo;
///////////////////////////////////////////////////////
output          seq_transfer_desc;
input           destination_request;	
output          no_more_peripheral_to_peripheral_burst_reg;
output          no_more_peripheral_to_peripheral_no_burst_reg;
output          source_req_done_for_this_channel;
input	[31:0]	csr;		
input	[31:0]	pointer;	
input	[31:0]	pointer_s;	
input	[31:0]	txsz;		
input	[31:0]	adr0, adr1;	
input	[31:0]	am0, am1;	
output			de_csr_we;	
output			de_txsz_we;	
output			de_adr0_we;	
output			de_adr1_we;	
output			ptr_set;	
output	[31:0]	de_csr;		
output	[11:0]	de_txsz;	
output	[31:0]	de_adr0;	
output	[31:0]	de_adr1;	
output			de_fetch_descr;
output			next_ch;
output			de_ack;
input			pause_req;
output			paused;
output			dma_busy;
output			dma_err;
output			dma_done;
output			dma_done_all;
output          seq_transfer;
output          burst_desc;
output			need_dst_req_for_this_channel;
input           selected_real_pref_to_pref;
output          save_this_channel_burst;
output          save_this_channel_no_burst;
//==========================================================================
// Internal signls
//==========================================================================
	typedef enum bit 	[25:0] {
			IDLE		    	    = 26'b00_0000_0000_0000_0000_0000_0001,
			READ		    	    = 26'b00_0000_0000_0000_0000_0000_0010,
			WRITE		    	    = 26'b00_0000_0000_0000_0000_0000_0100,
			UPDATE		    	    = 26'b00_0000_0000_0000_0000_0000_1000,
			LD_DESC1	    	    = 26'b00_0000_0000_0000_0000_0001_0000,
			LD_DESC2	    	    = 26'b00_0000_0000_0000_0000_0010_0000,
			LD_DESC3	    	    = 26'b00_0000_0000_0000_0000_0100_0000,
			LD_DESC4	    	    = 26'b00_0000_0000_0000_0000_1000_0000,
			PAUSE                   = 26'b00_0000_0000_0000_0001_0000_0000,
			READ_BURST              = 26'b00_0000_0000_0000_0010_0000_0000,
			WRITE_BURST             = 26'b00_0000_0000_0000_0100_0000_0000,
			READ_PREF               = 26'b00_0000_0000_0000_1000_0000_0000,
			WAIT_WRITE_PREF         = 26'b00_0000_0000_0001_0000_0000_0000,
			WRITE_PREF              = 26'b00_0000_0000_0010_0000_0000_0000,
			READ_BURST_PREF         = 26'b00_0000_0000_0100_0000_0000_0000,
			WAIT_WRITE_BURST_PREF   = 26'b00_0000_0000_1000_0000_0000_0000,
			WRITE_BURST_PREF        = 26'b00_0000_0001_0000_0000_0000_0000,
			READ_FIRST_PREF         = 26'b00_0000_0010_0000_0000_0000_0000 } states_t ;
/////////////////////////////////////////////////////////////////////
	states_t		state; 
	states_t		next_state;
	reg             dma_busy;
	reg		[31:0]	mast0_adr;
	wire  			slave_wait; 
	reg		[31:0]	adr0_cnt;
	reg 	[31:0]  adr1_cnt;
	reg	    [31:0]	adr0_cnt_next;
	reg 	[31:0]	adr1_cnt_next;
	wire	[31:0]	adr0_cnt_next1;
	wire	[31:0]  adr1_cnt_next1;
	reg				adr0_inc;
	reg				adr1_inc;
	reg				adr0_inc_burst;
	reg				adr1_inc_burst;
	reg		[10:0]	chunk_cnt;
	reg		[11:0]	tsz_cnt;
	reg				de_txsz_we;
	reg				de_csr_we;
	reg				de_adr0_we;
	reg				de_adr1_we;
	reg				ld_desc_sel;
	wire			chunk_cnt_is_0_d;
	reg				chunk_cnt_is_0_r;
	wire			tsz_cnt_is_0_d;
	reg				tsz_cnt_is_0_r;
	reg				read, write;
	reg             read_burst;
	reg				write_burst;
	reg				chunk_0;
	wire			done;
	reg				dma_done_d;
	reg				dma_abort_r;
	reg				next_ch;
	reg		[1:0]	ptr_adr_low;
	reg				m0_go;
	reg				ptr_set;
	reg             ptr_set_reg;
	wire			a0_inc_en = csr[4];
	wire			a1_inc_en = csr[3];
	wire			ptr_valid = pointer[0];
	wire			use_ed = csr[`WDMA_USE_ED];
	reg				paused;
	reg				de_fetch_descr;		
	reg     [31:0]  data_reg0;
	reg     [31:0]  adr0_reg;
	wire    [31:0]  burst_mem_data;
	wire    [31:0]  burst_pref_data;
	reg     [11:0]  burst_counter;
	reg     [11:0]  burst ;
	wire            no_use_burst; 
	reg             seq_transfer;
	reg     [31:0]  adr0_cnt_burst; 
	reg     [31:0]  adr1_cnt_burst; 
	wire    [2:0]   size_of_transfer;
	reg   			no_trnasfer ;
	reg   			dec_burst ;
	reg   			dec_no_burst;
	reg 			true_data;
	reg             seq_transfer_desc ;
	reg             burst_desc;
	reg             hwrite;
	reg             zero_counter;
	reg             start;
	reg             start_reg;
	wire    [31:0]  data_reg;
	reg             stop_this_burst;
	reg             seq_transfer_reg;
	reg     [29:0]  nw_ponter;
	wire            peripheral_to_peripheral;
	reg             no_more_peripheral_to_peripheral_burst;
	reg             no_more_peripheral_to_peripheral_burst_reg;
	reg             no_more_peripheral_to_peripheral_no_burst;
	reg             no_more_peripheral_to_peripheral_no_burst_reg;
	reg             save_data;
	reg             roo7_l_channel_tania;
	reg     [31:0]  saved_data;
	reg             take_saved_data;
	reg             take_saved_data_reg;
	reg             source_req_done;
	reg             source_req_done_reg;
	reg             source_req_done_for_this_channel;
	reg             wait_for_dst_req;
	reg             wait_for_dst_req_reg;
	reg             read_burst_pref;
	reg             write_burst_pref;
	reg             save_this_channel_burst;
	reg             save_this_channel_no_burst;
	reg             start_write_from_idle;
	reg             start_write_from_idle_reg;
	reg             need_dst_req_for_this_channel;
	reg             no_trnasfer_linked_list_dascreptor;
	reg				response_p2p;
	reg				response_msh_p2p;
//==========================================================================
// Main code
//==========================================================================
	always_comb
		if(gedak_5ofo | ptr_set_reg)		adr0_cnt_burst =  adr0;
		else
		if((adr0_inc | adr0_inc_burst) & a0_inc_en)	adr0_cnt_burst =  adr0_cnt_next;
		else
		adr0_cnt_burst = adr0_cnt ;
	/////////////////////////////////////////////////////////////////////
		always@(posedge clk or negedge rst)
		if(!rst)
		adr0_cnt <= 32'b0;
		else
		adr0_cnt <= adr0_cnt_burst ;
	/////////////////////////////////////////////////////////////////////

	ahb_dma_inc30r source_mask(	.clk(	clk		),
			.in(	adr0_cnt	),
			.size_of_incr (size_of_transfer),
			.out(	adr0_cnt_next1 	)	);
	/////////////////////////////////////////////////////////////////////
		always_comb
		if(gedak_5ofo | ptr_set)		adr1_cnt_burst =  adr1;
		else
		if((adr1_inc | adr1_inc_burst) & a1_inc_en)	adr1_cnt_burst =  adr1_cnt_next;
		else
		adr1_cnt_burst = adr1_cnt;
	/////////////////////////////////////////////////////////////////////
		always@(posedge clk or negedge rst)
		if(!rst)
		adr1_cnt <= 32'b0;
		else
		adr1_cnt <= adr1_cnt_burst ;
	/////////////////////////////////////////////////////////////////////
	ahb_dma_inc30r destination_mask(	.clk(	clk		),
				.in(	adr1_cnt	),
				.size_of_incr (size_of_transfer),
				.out(	adr1_cnt_next1 	)	);
	/////////////////////////////////////////////////////////////////////
	genvar k ;
	generate
		for(k=0;k<32;k=k+1)
		begin
			always_comb
			begin
				adr0_cnt_next[k] = am0[k] ? adr0_cnt_next1[k] : adr0_cnt[k];
				adr1_cnt_next[k] = am1[k] ? adr1_cnt_next1[k] : adr1_cnt[k];
			end
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////
	assign no_use_burst = (csr[23:21] == 3'b0);

	assign peripheral_to_peripheral = csr[24] & selected_real_pref_to_pref;

	assign size_of_transfer = csr[19:17];
	/////////////////////////////////////////////////////////////////////
	always_comb
	begin
		case(csr[23:21])
		0:burst = 12'd0  	 ;
		1:burst = (txsz[26:16] == 11'b0) ? txsz[11:0] : txsz[26:16];
		2:burst = 12'd4 	     ;
		3:burst = 12'd4 	     ;
		4:burst = 12'd8 	     ;
		5:burst = 12'd8 	     ;
		6:burst = 12'd16	     ;
		7:burst = 12'd16	     ;
		endcase
	end
	/////////////////////////////////////////////////////////////////////
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			burst_counter <= 12'b0;
		else if (zero_counter)
			burst_counter <= 12'b0;
		else if(read_burst | read_burst_pref)
			burst_counter <= burst_counter + 1'b1 ;
		else if(write_burst | write_burst_pref)
			burst_counter <= burst_counter + 1'b1 ;
	end
	/////////////////////////////////////////////////////////////////////
	mem_dma #(.depth(max_burst)) burst_memory (
	.clk(clk),
	.reset(rst),
	.response(response_msh_p2p),
	.transfer_size(size_of_transfer),
	.write_data(mast0_din),
	.read_enable(write_burst),
	.write_enable(read_burst),
	.read_data(burst_mem_data)
	);
	/////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////
	mem_dma #(.depth(max_p2p_burst)) pref_to_pref_memory (
	.clk(clk),
	.reset(rst),
	.response(response_p2p),
	.transfer_size(size_of_transfer),
	.write_data(mast0_din),
	.read_enable(write_burst_pref),
	.write_enable(read_burst_pref),
	.read_data(burst_pref_data)
	);
	/////////////////////////////////////////////////////////////////////
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		data_reg0 <= 32'b0;
		else 
		data_reg0 <= data_reg;
	end

	assign data_reg = true_data ? (take_saved_data_reg ? saved_data: mast0_din) : data_reg0 ;
	/////////////////////////////////////////////////////////////////////
	always_comb 
	begin
		stop_this_burst = (read & (adr0_cnt_burst [10] ^ adr0_cnt [10])) | (write & (adr1_cnt_burst [10] ^ adr1_cnt [10]));
	end
	/////////////////////////////////////////////////////////////////////
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		seq_transfer_reg <= 1'b0 ;
		else
		seq_transfer_reg <= seq_transfer;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		take_saved_data_reg <= 1'b0 ;
		else
		take_saved_data_reg <= take_saved_data;
	end

	/////////////////////////////////////////////////////////////////////
	always @(posedge clk)
	begin
		if(gedak_5ofo)
		begin
			if((dec_no_burst |dec_burst) & (|txsz[26:16]))
				chunk_cnt <=  txsz[26:16] - 1'b1;
			else
			chunk_cnt <=  txsz[26:16] ;
		end
		else
		if((dec_no_burst |dec_burst) & !chunk_cnt_is_0_d)	chunk_cnt <=  chunk_cnt - 11'h1;
	end

	assign chunk_cnt_is_0_d = (chunk_cnt ==11'h0);

	always @(posedge clk)
		chunk_cnt_is_0_r <=  chunk_cnt_is_0_d;


		always @(posedge clk)
	begin
		if(gedak_5ofo | ptr_set_reg)
		begin
			tsz_cnt <=  txsz[11:0] ;
		end
		else
		if((dec_no_burst |dec_burst)  & !tsz_cnt_is_0_d)	tsz_cnt <=  tsz_cnt - 12'h1;
		

	end

	assign tsz_cnt_is_0_d = (tsz_cnt == 12'h0);

	always @(posedge clk)
		tsz_cnt_is_0_r <=  tsz_cnt_is_0_d;
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk)
		chunk_0 <=  (txsz[26:16] == 11'h0);
	/////////////////////////////////////////////////////////////////////
	assign done = chunk_0 ? tsz_cnt_is_0_d : (tsz_cnt_is_0_d | chunk_cnt_is_0_d);
	assign dma_done = dma_done_d & done;
	assign dma_done_all = no_use_burst ? (dma_done_d & ( tsz_cnt_is_0_r)) : dma_done_d & tsz_cnt_is_0_d;//ntl3 de bra a7sn
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk)
		next_ch <=  dma_done | roo7_l_channel_tania;
	/////////////////////////////////////////////////////////////////////
	assign de_txsz = ld_desc_sel ? mast0_din[11:0] : tsz_cnt;
	assign de_adr0 = ld_desc_sel ? mast0_din : adr0_cnt;
	assign de_adr1 = ld_desc_sel ? mast0_din : adr1_cnt;
	assign de_csr  = mast0_din;
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk)
		dma_abort_r <= mast0_err ;

	assign	dma_err = dma_abort_r;

	/////////////////////////////////////////////////////////////////////
	always_comb
	begin
		nw_ponter = ptr_adr_low + pointer[31:2] ;
	end
	/////////////////////////////////////////////////////////////////////
	assign mast0_dout = no_use_burst ? data_reg : (peripheral_to_peripheral ? burst_pref_data: burst_mem_data); 
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk or negedge rst)
	begin
		if (!rst)
		adr0_reg <= 32'b0 ;
		else if (!no_trnasfer || !no_trnasfer_linked_list_dascreptor) 
		begin
		if(m0_go)
		begin
			adr0_reg <= {nw_ponter, 2'b00};
		end
		else if (read)
		begin
			adr0_reg <= adr0_cnt_burst;
		end
		else if(write)
		begin
			adr0_reg <= adr1_cnt_burst;
		end
		end
		else
		adr0_reg <= 32'b0 ; 
	end
	/////////////////////////////////////////////////////////////////////
	always_comb
	begin
		mast0_adr = adr0_reg;
	end
	/////////////////////////////////////////////////////////////////////
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		start_reg <= 1'b0 ;
		else
		start_reg <= start ;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		start_write_from_idle_reg <= 1'b0;
		else
		start_write_from_idle_reg <= start_write_from_idle;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		save_this_channel_burst <= 1'b0;
		else if(no_more_peripheral_to_peripheral_burst & !no_more_peripheral_to_peripheral_burst_reg)
		save_this_channel_burst <= 1'b1;
		else
		save_this_channel_burst <= 1'b0;
	end


	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		save_this_channel_no_burst <= 1'b0;
		else if(no_more_peripheral_to_peripheral_no_burst & !no_more_peripheral_to_peripheral_no_burst_reg)
			save_this_channel_no_burst <= 1'b1;
		else
			save_this_channel_no_burst <= 1'b0;
	end


	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		ptr_set <= 1'b0 ;
		else if(!slave_wait)
		ptr_set <= ptr_set_reg ;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		wait_for_dst_req_reg <= 1'b0;
		else
		wait_for_dst_req_reg <= wait_for_dst_req;
	end

	always_comb
	begin
		need_dst_req_for_this_channel = wait_for_dst_req ^ wait_for_dst_req_reg;
	end


	always_comb
	begin
		source_req_done_for_this_channel = source_req_done ^ source_req_done_reg;
	end



	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		no_more_peripheral_to_peripheral_burst_reg <= 1'b0 ;
		else
		no_more_peripheral_to_peripheral_burst_reg <= no_more_peripheral_to_peripheral_burst ;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		no_more_peripheral_to_peripheral_no_burst_reg <= 1'b0 ;
		else
			no_more_peripheral_to_peripheral_no_burst_reg <= no_more_peripheral_to_peripheral_no_burst ;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		source_req_done_reg <= 1'b0 ;
		else
		source_req_done_reg <= source_req_done ;
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		saved_data <= 32'b0;
		else if (save_data)
		saved_data <= mast0_din;
	end


	/////////////////////////////////////////////////////////////////////	
	assign mast0_we = hwrite;

	assign	de_ack = dma_done;

	assign slave_wait  = slave_wait0;
	/////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk or negedge rst)
		if(!rst)	state <=  IDLE;
		else		state <=  next_state;
	/////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////
	always_comb
	begin
		next_state = state;	// Default keep state
		read = 1'b0;
		write = 1'b0;
		dma_done_d = 1'b0;
		de_csr_we = 1'b0;
		de_txsz_we = 1'b0;
		de_adr0_we = 1'b0;
		de_adr1_we = 1'b0;
		de_fetch_descr = 1'b0;
		write_burst = 1'b0;
		read_burst = 1'b0;
		seq_transfer = 1'b0;
		adr0_inc = 1'b0 ;
		adr1_inc = 1'b0;
		no_trnasfer = 1'b0;
		seq_transfer_desc = 1'b0;
		hwrite = 1'b0 ;
		dec_burst = 1'b0 ;
		dec_no_burst = 1'b0 ;
		m0_go = 1'b0;
		ptr_adr_low = 2'h0;
		ptr_set_reg = 1'b0;
		ld_desc_sel = 1'b0;
		paused = 1'b0;
		true_data = 1'b0;
		burst_desc = 1'b0;
		adr0_inc_burst = 1'b0 ;
		adr1_inc_burst = 1'b0 ;
		dma_busy = 1'b1 ;
		zero_counter = 1'b0 ;
		start = 1'b0 ;
		save_data = 1'b0 ;
		no_more_peripheral_to_peripheral_burst = no_more_peripheral_to_peripheral_burst_reg ;
		no_more_peripheral_to_peripheral_no_burst = no_more_peripheral_to_peripheral_no_burst_reg ;
		read_burst_pref = 1'b0 ;
		write_burst_pref = 1'b0 ;
		take_saved_data = 1'b0;
		source_req_done = source_req_done_reg ;
		wait_for_dst_req = wait_for_dst_req_reg;
		roo7_l_channel_tania = 1'b0;
		start_write_from_idle = 1'b0;
		no_trnasfer_linked_list_dascreptor = 1'b1;
		response_p2p = 1'b0;
		response_msh_p2p = 1'b0;

		case(state)		// synopsys parallel_case full_case
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		IDLE:
			begin
				no_trnasfer = 1'b1;
				dma_busy = 1'b0 ;
			if(pause_req)			next_state = PAUSE;
			else
			if(gedak_5ofo & !csr[`WDMA_ERR])
			begin
				if(destination_request)
				begin
					wait_for_dst_req = 1'b0;
					if(no_use_burst)
					begin
						dec_no_burst = 1'b1;
						next_state = WRITE_PREF;
						take_saved_data = 1'b1;
						source_req_done = 1'b1;
						no_trnasfer = 1'b0 ;
						write = 1'b1;
						hwrite = 1'b1 ;
						no_more_peripheral_to_peripheral_no_burst = 1'b0;
					end
					else
					begin
						dec_burst = 1'b1;
						next_state = WRITE_BURST_PREF;
						source_req_done = 1'b1;
						seq_transfer = 1'b0;
						no_trnasfer = 1'b0 ;
						write = 1'b1;
						hwrite = 1'b1 ;
						dec_burst = 1'b1;
						start = 1'b0;
						start_write_from_idle = 1'b1;
						no_more_peripheral_to_peripheral_burst = 1'b0;
					end
				end
				else if(use_ed & !ptr_valid)
				begin
					next_state = LD_DESC1;
					if(!slave_wait)
					begin
						m0_go = 1'b1;
						//no_trnasfer = 1'b0;
						no_trnasfer_linked_list_dascreptor = 1'b0;
						burst_desc = 1'b1;
						if(peripheral_to_peripheral)
						begin
						wait_for_dst_req = 1'b1;
						end

					end
				end
				else if(no_use_burst)
				begin
					no_trnasfer = 1'b0;
					if(!slave_wait)
					begin
						read = 1'b1;
					end
					if(peripheral_to_peripheral)
					begin
						next_state = READ_FIRST_PREF ;
						wait_for_dst_req = 1'b1;
					end
					else
					begin
						next_state = READ;
					end
				
			end
			
			else
			begin
					no_trnasfer = 1'b0;
					if(!slave_wait)
					begin
						read = 1'b1;
					end
					if(peripheral_to_peripheral)
					begin
						next_state = READ_BURST_PREF;
						wait_for_dst_req = 1'b1;
					end
					else
					begin
					next_state = READ_BURST ;
					end
					
			end
			end
			end
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		PAUSE:
			begin
			paused = 1'b1;
			if(!pause_req)		next_state = IDLE;
			end
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		READ:	// Read From Source
			begin
			if(dma_abort_r)	next_state = UPDATE;
			else if (!slave_wait)	
			begin
			next_state = WRITE;
			no_trnasfer = 1'b0 ;
			adr0_inc = 1'b1 ;
			write = 1'b1;
			hwrite = 1'b1 ;
			dec_no_burst = 1'b1 ;
			end
			else
			begin
				no_trnasfer = 1'b0;
			end
			end
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		WRITE:	// Write To Destination
			begin
				true_data = 1'b1;
				adr1_inc = 1'b1;
			if(dma_abort_r)	next_state = UPDATE;
	
			else if (!slave_wait) 
			begin
				if(done)
				begin
					next_state = UPDATE;
					no_trnasfer = 1'b1 ;
				end
				else
				begin
					next_state = READ;
					no_trnasfer = 1'b0;
					read = 1'b1;
				end
			end   
			else
			begin
				no_trnasfer = 1'b0;
				hwrite = 1'b1 ;
			end
			end

			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		UPDATE:	// Update Registers
			begin
			dma_done_d = 1'b1;
			de_txsz_we = 1'b1;
			de_adr0_we = 1'b1;
			de_adr1_we = 1'b1;
			no_trnasfer = 1'b1;
			zero_counter = 1'b1 ;
			next_state = IDLE;
			end
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		LD_DESC1:	// Load Descriptor from memory to registers
			begin
			seq_transfer_desc = 1'b1;
			no_trnasfer = 1'b1;
			burst_desc = 1'b1;
			ptr_adr_low = 2'h0;
			no_trnasfer_linked_list_dascreptor = 1'b0;
			if(!slave_wait)
			begin
				next_state = LD_DESC2;
				burst_desc = 1'b1;
				ptr_adr_low = 2'h1;
				m0_go = 1'b1;
				de_fetch_descr = 1'b1;			
			end
			end

			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		LD_DESC2:
			begin
			burst_desc = 1'b1;
			no_trnasfer = 1'b1;
			ptr_adr_low = 2'h1;	
			seq_transfer_desc = 1'b1;
			no_trnasfer_linked_list_dascreptor = 1'b0;
			if(!slave_wait)
			begin
				next_state = LD_DESC3;
				de_csr_we = 1'b1;
				de_txsz_we = 1'b1;
				ptr_adr_low = 2'h2;
				ld_desc_sel = 1'b1;
				m0_go = 1'b1;
				de_fetch_descr = 1'b1;
			end
			end
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		LD_DESC3:
			begin
			burst_desc = 1'b1;
			no_trnasfer = 1'b1;
			m0_go = 1'b1;
			ptr_adr_low = 2'h2;
			seq_transfer_desc = 1'b1;
			de_adr0_we = 1'b1;
			no_trnasfer_linked_list_dascreptor = 1'b0;
			if(!slave_wait)
			begin
				next_state = LD_DESC4;
				ld_desc_sel = 1'b1;
				ptr_adr_low = 2'h3;
				de_fetch_descr = 1'b1;
			end
			end
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		LD_DESC4:
			begin
			de_fetch_descr = 1'b1;
			no_trnasfer = 1'b1;
			burst_desc = 1'b1;
			m0_go = 1'b1 ;
			ptr_adr_low = 2'h3;
			seq_transfer_desc = 1'b1;
			de_adr1_we = 1'b1;
			no_trnasfer_linked_list_dascreptor = 1'b0;
			if(!slave_wait)
			begin
				ptr_set_reg = 1'b1;
				burst_desc = 1'b0;
				ld_desc_sel = 1'b1;
				read = 1'b1 ;
				m0_go = 1'b0 ;
				no_trnasfer_linked_list_dascreptor = 1'b1;
				seq_transfer_desc = 1'b0;
				no_trnasfer = 1'b0;
				if(no_use_burst)
				begin
					if(peripheral_to_peripheral)
					begin
					next_state = READ_FIRST_PREF;
					end
					else
					next_state = READ;
				end
				else
				begin
					if(peripheral_to_peripheral)
					begin
					next_state = READ_BURST_PREF;
					end
					else
					next_state = READ_BURST ;
				end	
			end
			end
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			READ_BURST :
			begin
				start = 1'b1 ;
				if(dma_abort_r)	
				begin
					next_state = UPDATE;
					response_msh_p2p = 1'b1;
				end
				else if (!slave_wait)
				begin
					read = 1'b1;
					read_burst = start_reg;
					adr0_inc_burst = 1'b1 ;
					if(burst_counter == (burst - 2'b10))
					begin
						adr0_inc_burst = 1'b1 ;
						next_state = WRITE_BURST;
						seq_transfer = 1'b0;
						write = 1'b1;
						hwrite = 1'b1 ;
						dec_burst = 1'b1;
						start = 1'b0;
						read = 1'b0;
					end
					else if(stop_this_burst)
					begin
						seq_transfer = 1'b0;
					end
					else 
					begin
						seq_transfer = 1'b1;
					end
				end
				else
				begin
					seq_transfer = seq_transfer_reg;
					adr0_inc_burst = 1'b0 ;
				end
			end
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			WRITE_BURST: 
			begin
				adr1_inc_burst = 1'b1 ;
				hwrite = 1'b1 ;
				start = 1'b1 ;
			if(dma_abort_r)
			begin
				next_state = UPDATE;
				response_msh_p2p = 1'b1;
			end
			else if (!slave_wait)
			begin
				
				write = 1'b1;
				write_burst = 1'b1;
				if(start & !start_reg)
				begin
					read_burst = 1'b1;
					zero_counter = 1'b1;
					dec_burst = 1'b1 ;
					seq_transfer = 1'b1;
				end

				else if(burst_counter == (burst - 2'b10))
				begin
					next_state = UPDATE;
					no_trnasfer = 1'b1;
					adr1_inc_burst = 1'b1 ;
					write_burst = 1'b1;
					hwrite = 1'b0 ;
				end
				else if(stop_this_burst)
				begin
				seq_transfer = 1'b0;
				dec_burst = 1'b1 ;
				end
				else 
				begin
					seq_transfer = 1'b1;
					dec_burst = 1'b1 ;
				end
			end

			else
			begin
			seq_transfer = seq_transfer_reg;
			adr1_inc_burst = 1'b0 ;
			end
			end

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			READ_FIRST_PREF : 
			begin
				wait_for_dst_req = 1'b1;
				if(dma_abort_r)
				begin	
					next_state = UPDATE;
					wait_for_dst_req = 1'b0;
					source_req_done = 1'b0;
				end
				else if (!slave_wait)	
				begin
					//save_data = 1'b1 ;
					if(destination_request)
					begin
						wait_for_dst_req = 1'b0;
						next_state = WRITE_PREF;
						no_trnasfer = 1'b0 ;
						adr0_inc = 1'b1 ;
						write = 1'b1;
						hwrite = 1'b1 ;
						dec_no_burst = 1'b1 ;
						source_req_done = 1'b1 ;
						no_more_peripheral_to_peripheral_no_burst = 1'b0;
					end
					else
					begin
						next_state = WAIT_WRITE_PREF;
						no_trnasfer = 1'b1 ;
						adr0_inc = 1'b0 ;
						write = 1'b0;
						hwrite = 1'b0 ;
						dec_no_burst = 1'b0 ;
						no_more_peripheral_to_peripheral_no_burst = 1'b1;
					end

				end
				else
				begin
					no_trnasfer = 1'b0;
				end
			end
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			WRITE_PREF : 
			begin
				true_data = 1'b1;
				adr1_inc = 1'b1;
				
				if(dma_abort_r)	next_state = UPDATE;
				
				else if (!slave_wait) 
				begin
				if(done)
				begin
					next_state = UPDATE;
					no_trnasfer = 1'b1 ;
					source_req_done = 1'b0;
				end
				else
				begin
					next_state = READ_PREF;
					no_trnasfer = 1'b0;
					read = 1'b1;
				end
				end   
				else
				begin
					no_trnasfer = 1'b0;
					hwrite = 1'b1 ;
				end
			end
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			READ_PREF:	// Read From Source
			begin
				if(dma_abort_r)	next_state = UPDATE;
				else if (!slave_wait)	
				begin
					next_state = WRITE_PREF;
					no_trnasfer = 1'b0 ;
					adr0_inc = 1'b1 ;
					write = 1'b1;
					hwrite = 1'b1 ;
					dec_no_burst = 1'b1 ;
				end
				else
				begin
					no_trnasfer = 1'b0;
				end
			end
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			WAIT_WRITE_PREF : 
			begin
				wait_for_dst_req = 1'b1;
				true_data = 1'b1;
				no_trnasfer = 1'b1;
				no_more_peripheral_to_peripheral_no_burst = 1'b1;
				if(dma_abort_r)
				begin
					next_state = UPDATE;
					wait_for_dst_req = 1'b0;
					source_req_done = 1'b0;
				end
				else if (!slave_wait) 
				begin
					save_data = 1'b1 ;
					
					if(destination_request)
					begin
						wait_for_dst_req = 1'b0;
						next_state = WRITE_PREF ;
						dec_no_burst = 1'b1 ;
						no_more_peripheral_to_peripheral_no_burst = 1'b0;	
						no_trnasfer = 1'b1;
					end
					else
					begin
						next_state =IDLE ;
						roo7_l_channel_tania = 1'b1;
						wait_for_dst_req = 1'b1;
					end

				end   
			end
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			READ_BURST_PREF :
			begin
			wait_for_dst_req = 1'b1;
			start = 1'b1 ;
			if(dma_abort_r)	
			begin
				next_state = UPDATE;
				response_p2p = 1'b1;
				wait_for_dst_req = 1'b0;
				source_req_done = 1'b0;
			end
			else if (!slave_wait)
				begin
					read = 1'b1;
					read_burst_pref = start_reg; 
					adr0_inc_burst = 1'b1 ;
					if(burst_counter == (burst - 2'b10))
					begin
						if(destination_request)
						begin
							wait_for_dst_req = 1'b0;
							adr0_inc_burst = 1'b1 ;
							next_state = WRITE_BURST_PREF;
							seq_transfer = 1'b0;
							write = 1'b1;
							hwrite = 1'b1 ;
							dec_burst = 1'b1;
							start = 1'b0;
							read = 1'b0;
							source_req_done = 1'b1;
							no_more_peripheral_to_peripheral_burst = 1'b0;
						end
						else
						begin
							adr0_inc_burst = 1'b1 ;
							next_state = WAIT_WRITE_BURST_PREF;
							seq_transfer = 1'b0;
							write = 1'b0;
							hwrite = 1'b0;
							dec_burst = 1'b0;
							start = 1'b0;
							read = 1'b0;
							no_trnasfer = 1'b1;
							no_more_peripheral_to_peripheral_burst = 1'b1;
						end
					end
					else if(stop_this_burst)
					begin
						seq_transfer = 1'b0;
					end
					else begin
						seq_transfer = 1'b1;
					end
				end
				else
				begin
					seq_transfer = seq_transfer_reg;
					adr0_inc_burst = 1'b0 ;
				end
	
			end
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			WRITE_BURST_PREF: 
			begin
				adr1_inc_burst = 1'b1 ;
				hwrite = 1'b1 ;
				start = 1'b1 ;	
				if(dma_abort_r)
				begin
					next_state = UPDATE;
					response_p2p = 1'b1;
				end
				else if (!slave_wait)
				begin

					write = 1'b1;
					write_burst_pref = 1'b1;
					if(start & !start_reg & ((burst_counter != 'b0) | start_write_from_idle_reg))
					begin
						if(burst_counter != 'b0)
						begin
						read_burst_pref = 1'b1;
						zero_counter = 1'b1;
						dec_burst = 1'b1 ;
						seq_transfer = 1'b1;
						end
						else if(start_write_from_idle_reg)
						begin
							zero_counter = 1'b1;
							dec_burst = 1'b1 ;
							seq_transfer = 1'b1;
						end
					end

					else if(burst_counter == (burst - 2'b10))
					begin
						next_state = UPDATE;
						no_trnasfer = 1'b1;
						adr1_inc_burst = 1'b1 ;
						write_burst_pref = 1'b1;
						hwrite = 1'b0 ;
						source_req_done = 1'b0;
					end
					else if(stop_this_burst)
					begin
					seq_transfer = 1'b0;
					dec_burst = 1'b1 ;
					end
					else 
					begin
						seq_transfer = 1'b1;
						dec_burst = 1'b1 ;
					end
				end

				else
				begin
					seq_transfer = seq_transfer_reg;
					adr1_inc_burst = 1'b0 ;
					start_write_from_idle = start_write_from_idle_reg;
				end
			end

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			WAIT_WRITE_BURST_PREF :
			begin
				wait_for_dst_req = 1'b1;
				no_trnasfer = 1'b1;
				no_more_peripheral_to_peripheral_burst = 1'b1;
				if(dma_abort_r)
				begin
					next_state = UPDATE;
					response_p2p = 1'b1;
					wait_for_dst_req = 1'b0;
					source_req_done = 1'b0;
				end
				else if (!slave_wait) 
				begin
					
					read_burst_pref = 1'b1;
					zero_counter = 1'b1;

					if(destination_request)
					begin
						wait_for_dst_req = 1'b0;
						next_state = WRITE_BURST_PREF;
						dec_burst = 1'b1;
						no_more_peripheral_to_peripheral_burst = 1'b0;
					end
					else
					begin
						next_state = IDLE;
						roo7_l_channel_tania = 1'b1;
						wait_for_dst_req = 1'b1;
					end
				end   
			end
		endcase

	end

endmodule