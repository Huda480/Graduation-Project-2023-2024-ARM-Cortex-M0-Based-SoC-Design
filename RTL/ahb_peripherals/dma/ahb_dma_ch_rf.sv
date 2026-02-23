/////////////////////////////////////////////////////////////////////
////  AHB DMA One Channel Register File                          ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////

module ahb_dma_ch_rf(clk, rst,
pointer,
pointer_s,
ch_csr_CTRL,
ch_csr_INTCLEAR,
ch_csr_REQ,
ch_txsz,
ch_adr0,
ch_adr1,
ch_am0,
ch_am1,
ch_dis,
irq,
ch_txsz_update,
ch_adr0_update,
ch_adr1_update,
ch_INTEN,
ahb_write_data,
ahb_address,
ahb_write_enable,
ch_sel,
dma_busy,
dma_err,
dma_done,
dma_done_all,
de_csr,
de_txsz,
de_adr0,
de_adr1,
de_csr_we,
de_txsz_we,
de_adr0_we,
de_adr1_we,
de_fetch_descr,
dma_rest,
ptr_set);
//==========================================================================
// Parameters
//==========================================================================
parameter	[4:0]	CH_NO    = 5'h0;
parameter  			ch_cofig = 2'h0;
parameter   [5:0]   channel_number = 15;
parameter           channel_number_bits = $clog2(channel_number);
parameter	[4:0]	CH_ADR = CH_NO + 5'h1;
parameter   [4:0]   request_wa7ed = 5'b0;
localparam	[0:0]	HAVE_ARS = ch_cofig[0]; 
localparam	[0:0]	HAVE_CBUF= ch_cofig[1];
//==========================================================================
// Inputs & Outputs
//==========================================================================
input		    					clk;
input           					rst;
output	[31:0]						pointer;
output	[31:0]						pointer_s;
output	[31:0]						ch_txsz;
output	[31:0]						ch_adr0;
output	[31:0]						ch_adr1;
output	[31:0]						ch_am0; 
output	[31:0]						ch_am1; 
output  [31:0]  					ch_INTEN;
output		    					ch_dis;
output		    					irq;
output 	[31:0]  					ch_csr_CTRL;
output  [31:0]  					ch_csr_REQ;
output  [31:0]  					ch_csr_INTCLEAR;
output  [31:0]  					ch_txsz_update;
output  [31:0]  					ch_adr0_update;
output  [31:0]  					ch_adr1_update;
input	[7:0]						ahb_address;
input   [31:0]                      ahb_write_data;
input		    					ahb_write_enable;
input	[channel_number_bits-1:0]	ch_sel;
input								dma_busy;
input       						dma_err;
input       						dma_done;
input       						dma_done_all;
input	[31:0]						de_csr;
input	[11:0]						de_txsz;
input	[31:0]						de_adr0;
input	[31:0]						de_adr1;
input		    					de_csr_we;
input           					de_txsz_we;
input           					de_adr0_we;
input           					de_adr1_we;
input           					ptr_set;
input		    					de_fetch_descr;
input		    					dma_rest;
//==========================================================================
// Macro
//==========================================================================
`include "ahb_dma_defines.svh"
//==========================================================================
// Internal signals
//==========================================================================
	wire	[31:0]	pointer;
	reg	    [29:0]	pointer_r;
	reg	    [29:0]	pointer_sr;
	reg		        ptr_valid;
	reg		        ch_eol;
	wire	[31:0]	ch_csr_CTRL;
	wire    [31:0]  ch_csr_REQ;
	wire    [31:0]  ch_csr_INTCLEAR;
	wire    [31:0]  ch_INTEN;
	wire    [31:0]  ch_txsz;
	reg     [2:0]   transfer_size;
	reg     [2:0]   burst;
	reg             peripheral_to_peripheral;
	reg	    [7:0]	ch_csr_r;
	reg	    [2:0]	channel_priority;
	reg	    [1:0]	ch_int_en;
	reg	    [1:0]	irq_src_r;
	reg		        ch_err_r;
	reg		        ch_busy;
	reg		        ch_done;
	reg		        ch_err;
	reg		        rest_en;
	reg	    [10:0]	ch_chk_sz_r;
	reg	    [11:0]	ch_tot_sz_r,total_size_update;
	reg	    [22:0]	ch_txsz_s;
	wire	[31:0]	ch_adr0;
	wire	[31:0]  ch_adr1;
	reg	    [31:0]	ch_adr0_r,ch_adr0_r_update;
	reg	    [31:0]  ch_adr1_r,ch_adr1_r_update;
	wire	[31:0]	ch_am0;
	wire	[31:0]	ch_am1;
	reg	    [31:0]	ch_am0_r;
	reg	    [31:0]	ch_am1_r;
	reg	    [31:0]	ch_adr0_s;
	reg	    [31:0]	ch_adr1_s;
	reg		        ch_dis;
	wire		    ch_enable;
	wire		    pointer_we;
	wire		    ch_csr_ctrl_we;
	wire            ch_csr_request;
	wire            ch_csr_int_clear_we;
	wire		    ch_txsz_we;
	wire		    ch_adr0_we;
	wire		    ch_adr1_we;
	wire		    ch_am0_we;
	wire            ch_am1_we;
	reg		        ch_rl;
	wire		    ch_done_we;
	wire		    ch_err_we;
	wire		    chunk_done_we;
	wire		    ch_csr_dewe;
	wire            ch_txsz_dewe;
	wire            ch_adr0_dewe;
	wire            ch_adr1_dewe;
	wire		    this_ptr_set;
	wire		    ptr_inv;
	wire    [31:0]  ch_txsz_update,ch_adr0_update,ch_adr1_update;
	reg    			keep_regs;
	reg     [4:0]   channel_request_1;
	reg     [4:0]   channel_request_2; 
	reg     [31:0]  sw_pointer_dst,sw_pointer_src;
	reg     [1:0]   int_en;
//==========================================================================
// Main code
//==========================================================================
	assign ch_am0		= ch_am0_r;
	assign ch_am1		= ch_am1_r;

	// AM0 : mask for incrementing source address
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		ch_am0_r <=  32'h0;
		else
		begin
			if(transfer_size == 3'b000)
			begin
				case (burst)
				3'b10:
				begin
					ch_am0_r <= 32'h3;
				end
				3'b100:
				begin
					ch_am0_r <= 32'h7;
				end
				3'b110:
				begin
					ch_am0_r <= 32'hf;
				end
				default : 
				begin
					ch_am0_r <=  32'hffff;
				end
				endcase
			end
			else if (transfer_size == 3'b001)
			begin
				case (burst)
				3'b10:
				begin
					ch_am0_r <= 32'h6;
				end
				3'b100:
				begin
					ch_am0_r <= 32'he;
				end
				3'b110:
				begin
					ch_am0_r <= 32'h1e;
				end
				default : 
				begin
					ch_am0_r <= 32'hfffe;
				end
				endcase
			end
			else
			begin
				case (burst)
				3'b10:
				begin
					ch_am0_r <= 32'hc;
				end
				3'b100:
				begin
					ch_am0_r <= 32'h1c;
				end
				3'b110:
				begin
					ch_am0_r <= 32'h3c;
				end
				default : 
				begin
					ch_am0_r <= 32'hfffc;
				end
				endcase
			end
		end
	end

	// AM1 : mask for incrementing destination address
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		ch_am1_r <=  32'h0;
		else
		begin
			if(transfer_size == 3'b000)
			begin
				case (burst)
				3'b10:
				begin
					ch_am1_r <= 32'h3;
				end
				3'b100:
				begin
					ch_am1_r <= 32'h7;
				end
				3'b110:
				begin
					ch_am1_r <= 32'hf;
				end
				default : 
				begin
					ch_am1_r <=  32'hffff;
				end
				endcase
			end
			else if (transfer_size == 3'b001)
			begin
				case (burst)
				3'b10:
				begin
					ch_am1_r <= 32'h6;
				end
				3'b100:
				begin
					ch_am1_r <= 32'he;
				end
				3'b110:
				begin
					ch_am1_r <= 32'h1e;
				end
				default : 
				begin
					ch_am1_r <= 32'hfffe;
				end
				endcase
			end
			else
			begin
				case (burst)
				3'b10:
				begin
					ch_am1_r <= 32'hc;
				end
				3'b100:
				begin
					ch_am1_r <= 32'h1c;
				end
				3'b110:
				begin
					ch_am1_r <= 32'h3c;
				end
				default : 
				begin
					ch_am1_r <= 32'hfffc;
				end
				endcase
			end
		end
	end

	////////////////////////////////////////////////////////////sw_pointer////////////////////////////////////////////////////////
	generate
		if(HAVE_CBUF)
		begin
			always@(posedge clk or negedge rst)
			begin
				if(!rst)
				sw_pointer_src <= 32'b0 ;
				else
				begin
					case(ch_adr0[31:28])
						4'h2 : sw_pointer_src <= 32'h200f0000;
						4'h4 : sw_pointer_src <= {ch_adr0[31:12],12'h414} ;
						default : sw_pointer_src <= 32'h00000000;
					endcase
				end
			end

			always@(posedge clk or negedge rst)
			begin
				if(!rst)
				sw_pointer_dst <= 32'b0 ;
				else
				begin
					case(ch_adr1[31:28])
						4'h2 : sw_pointer_dst <= 32'h200f0000;
						4'h4 : sw_pointer_dst <= {ch_adr1[31:12],12'h414} ;
						default : sw_pointer_dst <= 32'h00000000;
					endcase
				end
			end

			always @(posedge clk or negedge rst)
			begin
			if(!rst)
				ch_dis <= 1'b0;
			else
				ch_dis <= ((sw_pointer_dst == ch_adr1_update) | (sw_pointer_src == ch_adr0_update));
			end

			/////channel enable bit
			assign ch_enable	= (ch_csr_r[`WDMA_CH_EN] & (HAVE_CBUF ? !ch_dis : 1'b1) );
		end
		else
		/////channel enable bit
		assign ch_enable	= ch_csr_r[`WDMA_CH_EN] ;

	endgenerate
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////restart//////////////////////////////////////////////////////////////////////////

	generate
		if(HAVE_ARS)
		begin
			always @(posedge clk)
			begin
				ch_rl <= 	(rest_en & dma_rest) |((ch_sel==CH_NO) & dma_done_all & ch_csr_CTRL[`WDMA_ARS] & !ch_csr_CTRL[`WDMA_USE_ED]);
			end

			always @(posedge clk or negedge rst)
			begin
				if(!rst)
				begin
					ch_txsz_s <= 23'b0 ;
				end
				else
					begin
						if(ch_txsz_we)
						begin
							ch_txsz_s <=  {ahb_write_data[24:16], ahb_write_data[11:0]};
						end
						else
							if(rest_en & ch_txsz_dewe & de_fetch_descr)
							begin
								ch_txsz_s[11:0] <=  de_txsz[11:0];
							end
					end
			end


			always @(posedge clk or negedge rst)
			begin
				if(!rst)
					ch_adr0_s <= 32'b0;
				else
					begin
						if(ch_adr0_we)
							ch_adr0_s <=  ahb_write_data;
						else
							if(rest_en & ch_adr0_dewe & de_fetch_descr)
								ch_adr0_s <=  de_adr0;
					end
			end


			always @(posedge clk or negedge rst)
			begin
				if(!rst)
					ch_adr1_s <= 32'b0;
				else	
					begin
						if(ch_adr1_we)
							ch_adr1_s <=  ahb_write_data;
						else
							if(rest_en & ch_adr1_dewe & de_fetch_descr)
								ch_adr1_s <=  de_adr1;
					end
			end

			always @(posedge clk or negedge rst)
			begin
				if(!rst)
					rest_en <=  1'b0;
				else
					if(ch_csr_ctrl_we)
						rest_en <=  ahb_write_data[16];
			end

			always @(posedge clk or negedge rst)
			begin
				if(!rst)
				ch_csr_r[6] <=  1'b0;
				else if(ch_csr_ctrl_we)
				ch_csr_r[6] <=  ahb_write_data[6];
			end
		end
		else 
		begin
			always_comb
			begin
				ch_rl       = 1'b0 ;
				ch_txsz_s   = 23'b0;
				ch_adr0_s   = 32'b0;
				ch_adr1_s   = 32'b0;
				rest_en     = 1'b0 ;
				ch_csr_r[6] = 1'b0 ;
			end
		end	
	endgenerate

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	assign ch_done_we	    = (((ch_sel==CH_NO) & dma_done_all)) & (ch_csr_CTRL[`WDMA_USE_ED] ? ch_eol : !ch_csr_CTRL[`WDMA_ARS]);
	assign ch_err_we	    = (ch_sel==CH_NO) & dma_err;
	assign ch_csr_dewe	    = de_csr_we  & (ch_sel==CH_NO);
	assign ch_txsz_dewe	    = de_txsz_we & (ch_sel==CH_NO);
	assign ch_adr0_dewe	    = de_adr0_we & (ch_sel==CH_NO);
	assign ch_adr1_dewe	    = de_adr1_we & (ch_sel==CH_NO);

	assign ptr_inv		= ((ch_sel==CH_NO) & dma_done_all);

	assign this_ptr_set	= ptr_set & (ch_sel==CH_NO);



	// -----------------------------------------------------------------------------------------------------------------------------------------
	////////////////////////////////////////////
	//ch_csr_ctrl
	////////////////////////////////////////////
	assign ch_csr_ctrl_we	    = ahb_write_enable & (ahb_address[7:3] == CH_ADR) & (ahb_address[2:0] == 3'h0);
	////////////////////////////////////////
	//ch_csr_r[0]  --> channel enable
	//ch_csr_r[1]  --> destination interface (in our system is 0)
	//ch_csr_r[2]  --> source interface (in our system is 0)
	//ch_csr_r[3]  --> destination address increment 
	//ch_csr_r[4]  --> source address increment
	//ch_csr_r[5]  --> channel mode (0 :software , 1 :hardware)
	//ch_csr_r[6]  --> automatic restart bit
	//ch_csr_r[7]  --> use external descriptor
	///////////////////////////////////////////
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			ch_csr_r[5:0] <=  8'b0;
			ch_csr_r[7] <=  8'b0;
		end
		else
			begin
				if(ch_csr_ctrl_we)
				begin
					ch_csr_r[5:0] <=  ahb_write_data[5:0];
					ch_csr_r[7]   <=  ahb_write_data[7];
				end
				else
				begin
					if(ch_done_we)
						ch_csr_r[`WDMA_CH_EN] <=  1'b0;

					if(ch_csr_dewe)
						ch_csr_r[4:1] <=  de_csr[19:16];
				end
		end
	end


	/////////busy bit 
	always @(posedge clk or negedge rst) 
	begin
		if(!rst)
		ch_busy <= 1'b0;
		else
		ch_busy <= (ch_sel==CH_NO) & dma_busy;
	end


	////////transfer complete
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			ch_done <=  1'b0;
		else
			begin
			if(ch_done_we)
				ch_done <=  1'b1;
			else if(ch_enable == 1'b1)
				ch_done <=  1'b0;
		end
	end


	///////error bit
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			ch_err <=  1'b0;
		else
			begin
				if(ch_err_we)
					ch_err <=  1'b1;
				else if(ch_csr_int_clear_we)
					ch_err <=  !ahb_write_data[0];
		end
	end


	////////priority bits
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			channel_priority <=  3'h0;
		else
			if(ch_csr_ctrl_we)
				channel_priority <=  ahb_write_data[15:13];
	end


	/////restart enable bit 



	////////////////////////
	//transfer size (0:byte , 1:halfword , 2:word)
	//keep regs --> update source & destination addresses and size registers
	//burst --> AHB burst transfer
	always @(posedge clk or negedge rst)
	begin
		if(!rst) begin
			transfer_size <=  3'h0;
			keep_regs <= 1'b0;
			burst <= 3'b0;
			peripheral_to_peripheral <= 1'b0;
		end
		else
			if(ch_csr_ctrl_we) begin
				keep_regs <= ahb_write_data[20];
				burst <= ahb_write_data[23:21];
				peripheral_to_peripheral <= ahb_write_data[24];
				case(ahb_write_data[19:17])
					3'b0 :    transfer_size <= 3'b0  ;
					3'b1 :    transfer_size <= 3'b1  ;
					default : transfer_size <= 3'b10 ;
				endcase
			end
	end

	//////////////////////////////////////////////////////////////////////////////
	assign ch_csr_CTRL	= {7'h0,peripheral_to_peripheral,burst,keep_regs,transfer_size,rest_en,channel_priority,ch_err, ch_done,ch_busy,2'b0, ch_csr_r[7:1], ch_enable};
	//////////////////////////////////////////////////////////////////////////////

	//-----------------------------------------------------------------------------------------------------------------------------------------
	///////////////////////////////////////////////////
	//ch_csr_REQ
	///////////////////////////////////////////////////

	////////////////////////////////////////////////
	assign ch_csr_request     = ahb_write_enable & (ahb_address[7:3] == CH_ADR) & (ahb_address[2:0] == 3'h1);


	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			channel_request_1 <=  request_wa7ed;
			channel_request_2 <=  request_wa7ed;
		end
		else if(ch_csr_request) 
		begin
			channel_request_1 <=  ahb_write_data[4:0];
			channel_request_2 <=  ahb_write_data[9:5];
		end
	end

	//////////////////////////////////////////////////
	assign ch_csr_REQ = {22'b0,channel_request_2,channel_request_1};
	//////////////////////////////////////////////////

	//-------------------------------------------------------------------------------------------------------------------------------------------
	//////////////////////////////////////////////
	//ch_INTEN
	//int_en[0]  --> enable interupt for error
	//int_en[1]  --> enable interupt for transfer complete
	//////////////////////////////////////////////
	assign int_enable	    = ahb_write_enable & (ahb_address[7:3] == CH_ADR) & (ahb_address[2:0] == 3'h2);


	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		int_en <=  2'b0;
		else
			if(int_enable)
			int_en <=  ahb_write_data[1:0];
	end

	assign ch_INTEN = {30'b0,int_en};
	//////////////////////////////////////////////////
	//ch_csr_int_status&int_clear
	//////////////////////////////////////////////////

	//ch_int_clear[0]  --> clear interupt for error
	//ch_int_clear[1]  --> clear interupt for transfer complete


	assign ch_csr_int_clear_we  = ahb_write_enable & (ahb_address[7:3] == CH_ADR) & (ahb_address[2:0] == 3'h3);

	always @(posedge clk or negedge rst)
	begin
		if(!rst)	
			irq_src_r[1] <=  1'b0;
		else
			begin
				if(ch_done_we)	
					irq_src_r[1] <=  1'b1;
			else
				if(ch_csr_int_clear_we)	
					irq_src_r[1] <=  !ahb_write_data[1];
			end
	end

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			irq_src_r[0] <=  1'b0;
		else
			begin
				if(ch_err_we)
					irq_src_r[0] <=  1'b1;
			else
				if(ch_csr_int_clear_we)	
					irq_src_r[0] <= !ahb_write_data[0];
			end
	end

	////////////////////////////////////////////////////////////
	assign irq = |(irq_src_r & int_en);
	assign ch_csr_INTCLEAR = {30'b0,irq_src_r};
	////////////////////////////////////////////////////////////

	//--------------------------------------------------------------------------------------------------------------------------------------------
	////////////////////////////////////////////////
	//ch_size & update size
	////////////////////////////////////////////////

	assign ch_txsz_we	    = ahb_write_enable & (ahb_address[7:3] == CH_ADR) & (ahb_address[2:0] == 3'h4);

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			total_size_update <= 12'b0;
			ch_chk_sz_r <= 11'b0;
			ch_tot_sz_r <= 12'b0;
		end

		else if(ch_txsz_we)
		begin
			ch_chk_sz_r <= ahb_write_data[26:16] ;
			total_size_update <= ahb_write_data[11:0];
			ch_tot_sz_r <= ahb_write_data[11:0];

		end

		else if(ch_txsz_dewe)
		begin
			total_size_update <=  de_txsz;
			if(!keep_regs)
			begin
				ch_tot_sz_r <= de_txsz;
			end
		end

		else if(ch_rl)
		begin
			{ch_chk_sz_r, ch_tot_sz_r} <=  ch_txsz_s;
			total_size_update <= ch_txsz_s[11:0] ;
		end
		
		else if (total_size_update == 12'b0) 
		begin
			total_size_update <= ch_tot_sz_r;
		end
	end





	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	assign ch_txsz		  = {4'h0,ch_chk_sz_r,4'h0, ch_tot_sz_r};
	assign ch_txsz_update = {4'h0,ch_chk_sz_r,4'h0, total_size_update};
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//--------------------------------------------------------------------------------------------------------------------------------------------
	/////////////////////////////////////////////
	//source address
	/////////////////////////////////////////////
	assign ch_adr0_we	    = ahb_write_enable & (ahb_address[7:3] == CH_ADR) & (ahb_address[2:0] == 3'h5);

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			ch_adr0_r <= 32'b0;
			ch_adr0_r_update <= 32'b0;
		end
		else
				begin
					if(ch_adr0_we)
					begin
						ch_adr0_r <=  ahb_write_data;
						ch_adr0_r_update <= ahb_write_data;
					end
					else
						if(ch_adr0_dewe)
						begin
							ch_adr0_r_update <= de_adr0;
							if(!keep_regs)
							begin
								ch_adr0_r <=  de_adr0;
							end
						end
					else
						if(ch_rl) 
						begin
							ch_adr0_r <=  ch_adr0_s;
							ch_adr0_r_update <= ch_adr0_s;
						end
					else 
						if (total_size_update == 12'b0) 
						begin
							ch_adr0_r_update <= ch_adr0_r;
						end
				end
	end
	// Adr0 shadow register


	///////////////////////////////////////////////////////////////////
	assign ch_adr0		  = ch_adr0_r;
	assign ch_adr0_update = ch_adr0_r_update;
	///////////////////////////////////////////////////////////////////

	//--------------------------------------------------------------------------------------------------------------------------------------------
	//////////////////////////////////////////////////
	//destination address
	//////////////////////////////////////////////////

	assign ch_adr1_we	    = ahb_write_enable & (ahb_address[7:3] == CH_ADR) & (ahb_address[2:0] == 3'h6);


	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			ch_adr1_r <= 32'b0;
			ch_adr1_r_update <= 32'b0;
		end
		else
			begin
				if(ch_adr1_we)
				begin
					ch_adr1_r <=  ahb_write_data;
					ch_adr1_r_update <= ahb_write_data;
				end
				else
					if(ch_adr1_dewe)
					begin
						ch_adr1_r_update <= de_adr1;
						if(!keep_regs)
						begin
							ch_adr1_r <=  de_adr1;
						end
					end
				else
					if(ch_rl)
					begin
						ch_adr1_r <=  ch_adr1_s;
						ch_adr1_r_update <= ch_adr1_s;
					end
				else 
					if (total_size_update == 12'b0) 
					begin
						ch_adr1_r_update <= ch_adr1_r;
					end
			end
	end


		

	///////////////////////////////////////////////////////////////////
	assign ch_adr1		= ch_adr1_r;
	assign ch_adr1_update = ch_adr1_r_update;
	///////////////////////////////////////////////////////////////////

	//--------------------------------------------------------------------------------------------------------------------------------------------

	////////////////////////////////////////////////////////////
	//linked list pointer
	////////////////////////////////////////////////////////////
	assign pointer_we	    = ahb_write_enable & (ahb_address[7:3] == CH_ADR) & (ahb_address[2:0] == 3'h7);

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			ptr_valid <=  1'b0;
		else
			begin
				if( this_ptr_set | (rest_en & dma_rest) )
					ptr_valid <=  1'b1;
				else
					if(ptr_inv)
						ptr_valid <=  1'b0;
			end
	end

	//////end of linked list
	always @(posedge clk or negedge rst)
	begin
		if(!rst)	
			ch_eol <=  1'b0;
		else
			begin
				if(ch_csr_dewe)	
					ch_eol <=  de_csr[`WDMA_ED_EOL];
				else
					if(ch_done_we)
						ch_eol <=  1'b0;
			end
	end

	////pointer
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			pointer_r <= 30'b0;
		else	
			begin
				if(pointer_we)
					pointer_r <=  ahb_write_data[31:2];
				else
					if(this_ptr_set)
						pointer_r <=  de_csr[31:2];
			end
	end		


	/////previous pointer
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			pointer_sr <= 30'b0;
		else	
			begin
				if(this_ptr_set)
					pointer_sr <=  pointer_r;
			end
	end
	///////////////////////////////////////////////////////////////////
	assign pointer		= {pointer_r, 1'h0, ptr_valid}; 
	assign pointer_s	= {pointer_sr, 2'h0};
	///////////////////////////////////////////////////////////////////

endmodule