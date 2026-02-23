/////////////////////////////////////////////////////////////////////
////  AHB DMA Register File                                      ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
`include "ahb_dma_defines.svh"
/////////////////////////////////////////////////////////////////////
module ahb_dma_rf(
clk,
rst,
ahb_address,
ahb_write_data,
ahb_read_data,
ahb_write_enable,
ahb_read_enable,
irqa_o,
pointer_DESC,
pointer_S,
ch_csr_CTRL,
ch_csr_REQ,
ch_am0,
ch_am1,
ch_adr1_update,
ch_adr0_update,
ch_txsz_update,
ch_sel,
ch_done_all_transfer,
ahb_read_address,
pause_req,
paused,
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
parameter   [5:0]   channel_number = 0;
parameter   [1:0]   ch_conf [31] = {2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0};
parameter           channel_number_bits = $clog2(channel_number);
localparam          valid_address = (channel_number+1) ;
localparam	[4:0]   requestat [31] = {5'd0,5'd1,5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd8,5'd9,5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16,5'd17,5'd18,5'd19,5'd20,5'd21,5'd22,5'd23,5'd24,5'd25,5'd26,5'd27,5'd28,5'd29,5'd30};
//==========================================================================
// Inputs & Outputs
//==========================================================================
input		              				  clk;
input                     				  rst;
input		  [7:0]	      				  ahb_address;
input   	  [7:0]       				  ahb_read_address;
input		  [31:0]	  				  ahb_write_data;
output		  [31:0]	  				  ahb_read_data;
input					  				  ahb_write_enable;
input                                     ahb_read_enable;
output					  				  irqa_o;
output  	  [31:0]  	  				  pointer_DESC    [0:channel_number-1] ;
output  	  [31:0]  	  				  pointer_S       [0:channel_number-1] ;
output  	  [31:0]  	  				  ch_csr_CTRL     [0:channel_number-1] ;
output  	  [31:0]  	  				  ch_am0          [0:channel_number-1] ;
output  	  [31:0]  	  				  ch_am1          [0:channel_number-1] ;
output  	  [31:0]  	  				  ch_csr_REQ      [0:channel_number-1] ;
output  wire  [31:0]      				  ch_adr1_update  [0:channel_number-1] ;
output  wire  [31:0]      				  ch_adr0_update  [0:channel_number-1] ;
output  wire  [31:0]      				  ch_txsz_update  [0:channel_number-1] ;
input	      [channel_number_bits-1:0]	  ch_sel;
output  reg   [channel_number-1:0]        ch_done_all_transfer;
output									  pause_req;
input									  paused;
input									  dma_busy;
input									  dma_err;
input									  dma_done;
input									  dma_done_all;
input		  [31:0]					  de_csr;
input		  [11:0]					  de_txsz;
input		  [31:0]					  de_adr0;
input		  [31:0]					  de_adr1;
input									  de_csr_we;
input									  de_txsz_we;
input									  de_adr0_we;
input									  de_adr1_we;
input									  ptr_set;
input									  de_fetch_descr;
input	      [channel_number-1:0]	      dma_rest;
//==========================================================================
// Internal signls
//==========================================================================
	reg	          [31:0]				ahb_read_data;
	reg		                			irqa_o;
	reg	    	  [30:0]				irq_maska_r;
	wire		  [31:0]				irq_maska;
	wire		  [31:0]				irq_srca;
	wire		            			irq_maska_we;
	wire	      [channel_number-1:0]	ch_irq;
	wire		                        csr_we;
	wire	      [31:0]	            csr;
	reg	          [7:0]	                csr_r;
	wire	      [channel_number-1:0]	ch_dis;
	wire  		  [31:0]  				ch_csr_CTRL     [0:channel_number-1] ;
	wire  		  [31:0]  				ch_csr_REQ      [0:channel_number-1] ;
	wire  		  [31:0]  				ch_csr_INTCLEAR [0:channel_number-1] ;
	wire  		  [31:0]  				ch_txsz         [0:channel_number-1] ;
	wire  		  [31:0]  				ch_adr0         [0:channel_number-1] ;
	wire  		  [31:0]  				ch_adr1         [0:channel_number-1] ;
	wire  		  [31:0]  				ch_am0          [0:channel_number-1] ;
	wire  		  [31:0]  				ch_am1          [0:channel_number-1] ;
	wire  		  [31:0]  				ch_INTEN        [0:channel_number-1] ;
	wire 								channel_address;
//==========================================================================
// Main code
//==========================================================================
	assign irq_maska = {1'h0, irq_maska_r};
	assign csr = {31'h0, paused};
	/////////////////////////////////////////////////////////////////////
	assign pause_req = csr_r[0];
	/////////////////////////////////////////////////////////////////////


	assign  channel_address = |(ahb_read_address[7:3]);
	integer i;

	generate
	always@(posedge clk or negedge rst)
		begin		

			if(!rst)
				ahb_read_data <= 32'b0;
			else if (ahb_read_enable)
			begin
				if(!channel_address)
				begin
					case(ahb_read_address[2:0])
						0:ahb_read_data <= csr;
						1:ahb_read_data <= irq_maska;
						2:ahb_read_data <= irq_srca;
						3:ahb_read_data <= 32'b0;
						4:ahb_read_data <= 32'b0;
						5:ahb_read_data <= 32'b0;
						6:ahb_read_data <= 32'b0;
						7:ahb_read_data <= 32'b0;
					endcase
				end
				else
				begin
					for(i=1;i<valid_address;i=i+1)
					begin
		
						if((ahb_read_address[7:3] == i))
						begin
							case(ahb_read_address[2:0])
								0:ahb_read_data <= ch_csr_CTRL[i-1]    ;
								1:ahb_read_data <= ch_csr_REQ [i-1]    ;
								2:ahb_read_data <= ch_INTEN[i-1]       ;
								3:ahb_read_data <= ch_csr_INTCLEAR[i-1];
								4:ahb_read_data <= ch_txsz[i-1]        ;
								5:ahb_read_data <= ch_adr0[i-1]        ;
								6:ahb_read_data <= ch_adr1[i-1]        ;
								7:ahb_read_data <= pointer_DESC[i-1]   ;
							endcase
						end
					end
				end
			end
			else
			ahb_read_data <= 32'b0;
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////
	assign csr_we		= ahb_write_enable & (ahb_address == 8'h0);
	assign irq_maska_we	= ahb_write_enable & (ahb_address == 8'h1);
	/////////////////////////////////////////////////////////////////////
	always @(posedge clk or negedge rst)
		if(!rst)		csr_r <=  8'h0;
		else
		if(csr_we)		csr_r <=  ahb_write_data[7:0];

	always @(posedge clk or negedge rst)
		if(!rst)		irq_maska_r <=  31'h0;
		else
		if(irq_maska_we)	irq_maska_r <=  ahb_write_data[30:0];

	assign irq_srca = {1'b0, (irq_maska_r & ch_irq) };

	always @(posedge clk)
		irqa_o <=  |irq_srca;
	/////////////////////////////////////////////////////////////////////
		always@(posedge clk or negedge rst)
		begin
			if(!rst)
			ch_done_all_transfer <= 'b0;
			else
			ch_done_all_transfer[ch_sel] <= dma_done_all;
		end
	/////////////////////////////////////////////////////////////////////
	genvar k ;          
	generate
	for(k=0;k<channel_number;k=k+1)
	begin
		ahb_dma_ch_rf #(.CH_NO(k),.ch_cofig(ch_conf[k]),.channel_number(channel_number),.request_wa7ed(requestat[k])) channel_rf(
			.clk    			(clk),
			.rst    			(rst),
			.pointer			(pointer_DESC[k]),
			.pointer_s			(pointer_S[k]),
			.ch_csr_CTRL		(ch_csr_CTRL[k]),
			.ch_csr_REQ			(ch_csr_REQ[k]),
			.ch_csr_INTCLEAR    (ch_csr_INTCLEAR[k]),
			.ch_txsz			(ch_txsz[k]),
			.ch_adr0			(ch_adr0[k]),
			.ch_adr1			(ch_adr1[k]),
			.ch_am0				(ch_am0[k]),
			.ch_am1				(ch_am1[k]),
			.ch_INTEN			(ch_INTEN[k]),
			.ch_dis				(ch_dis[k]),
			.irq				(ch_irq[k]),
			.ahb_write_data		(ahb_write_data),
			.ahb_address		(ahb_address),
			.ahb_write_enable	(ahb_write_enable),
			.ch_sel				(ch_sel),
			.dma_busy			(dma_busy),
			.dma_err			(dma_err),
			.dma_done			(dma_done),
			.dma_done_all		(dma_done_all),
			.de_csr				(de_csr),
			.de_txsz			(de_txsz),
			.de_adr0			(de_adr0),
			.de_adr1			(de_adr1),
			.de_csr_we			(de_csr_we),
			.de_txsz_we			(de_txsz_we),
			.de_adr0_we			(de_adr0_we),
			.de_adr1_we			(de_adr1_we),
			.de_fetch_descr     (de_fetch_descr),
			.dma_rest			(dma_rest[k]),
			.ch_txsz_update		(ch_txsz_update[k]),
			.ch_adr0_update		(ch_adr0_update[k]),
			.ch_adr1_update		(ch_adr1_update[k]),
			.ptr_set			(ptr_set));
	end
	endgenerate

endmodule
