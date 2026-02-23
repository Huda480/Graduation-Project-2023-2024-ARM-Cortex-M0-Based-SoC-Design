/////////////////////////////////////////////////////////////////////
////  AHB DMA Channel Arbiter                                    ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
module ahb_dma_ch_arb(clk, rst, req, gnt, advance);
//==========================================================================
// Parameters
//==========================================================================
parameter   [5:0]   channel_number = 19;
parameter           channel_number_bits = $clog2(channel_number);
parameter	[channel_number_bits-1:0]  grant [31] = {5'd0,5'd1,5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd8,5'd9,5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16,5'd17,5'd18,5'd19,5'd20,5'd21,5'd22,5'd23,5'd24,5'd25,5'd26,5'd27,5'd28,5'd29,5'd30};
//==========================================================================
// Inputs & Outputs
//==========================================================================
input								clk;
input								rst;
input	[channel_number-1:0]		req;
output	[channel_number_bits-1:0]	gnt;
input								advance;
//==========================================================================
// Internal signls
//==========================================================================
	reg [channel_number_bits-1:0]	state, next_state;
	reg [channel_number_bits-1:0]   granti [0:channel_number-1] ;
//==========================================================================
// Main code
//==========================================================================
	genvar k;
	generate
	for(k=0;k<channel_number;k=k+1)
	begin:grant_arbiter_inst
			grant_arb #(channel_number,channel_number_bits,grant,grant[k]) grant_arbiter(advance,req,granti[k]);
	end:grant_arbiter_inst
	endgenerate


	always_comb
	begin
		next_state = granti[state];
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			state <=  grant[0];
		end
		else
		begin
			state <=  next_state;
		end
	end

	assign	gnt = state;

endmodule