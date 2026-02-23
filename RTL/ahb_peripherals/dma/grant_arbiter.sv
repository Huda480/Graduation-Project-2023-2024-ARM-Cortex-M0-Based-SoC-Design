/////////////////////////////////////////////////////////////////////
////  AHB DMA grant arbiter                                      ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
module grant_arb #(
//==========================================================================
// Parameters
//==========================================================================   
parameter [5:0]              channel_number = 31 ,
parameter                    ch_add_bits = $clog2(channel_number),
parameter [ch_add_bits-1:0]  grant_param [31] = {5'd0,5'd1,5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd8,5'd9,5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16,5'd17,5'd18,5'd19,5'd20,5'd21,5'd22,5'd23,5'd24,5'd25,5'd26,5'd27,5'd28,5'd29,5'd30},
parameter [ch_add_bits-1:0]  channel_ID = 5)
(
//==========================================================================
// Inputs & Outputs
//==========================================================================   
input                               advance ,
input	    [channel_number-1:0]	   req,
output    [ch_add_bits-1:0]         state
);
//==========================================================================
// Internal signls
//==========================================================================
   reg   [ch_add_bits-1:0]       grant_next [0:channel_number-1];
   wire  [channel_number-1:0]    req_rotate;
   wire  [channel_number-1:0]    new_req_rotate;
   wire  [channel_number-1:0]    req1;
   wire  [channel_number-1:0]    req2;
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
   wire  [ch_add_bits-1:0]       grantat [0:channel_number] ;
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
//==========================================================================
// Main code
//==========================================================================
   always_comb 
   begin
      if(channel_ID == 0)
      grant_next = grant_param[channel_ID:channel_number-1];
      else
      grant_next = {grant_param[channel_ID:channel_number-1],grant_param[0:channel_ID-1]};
   end
   /////////////////////////////////////////////////////////////////////
   assign   selector_0 = ~(advance | !(req_rotate[0]));
   /////////////////////////////////////////////////////////////////////
   assign   req1 = (req >> channel_ID);
   assign   req2 = (req << (channel_number - channel_ID));
   assign   req_rotate = req1 | req2 ;
   /////////////////////////////////////////////////////////////////////
   assign   new_req_rotate = {req_rotate[channel_number-1:1],selector_0};
   /////////////////////////////////////////////////////////////////////
   assign grantat [channel_number] = channel_ID ;
   /////////////////////////////////////////////////////////////////////
   /////////////////////////////////////
   assign   state = grantat[0];
   /////////////////////////////////////
   /////////////////////////////////////////////////////////////////////
   genvar k ;
   generate
   for(k=0;k<channel_number;k=k+1)
      begin
      if (k==0)
      mux #(ch_add_bits) mux_grant(grant_next[k],grantat[k+1],new_req_rotate[k],grantat[k]);
      else
      not_mux #(ch_add_bits) not_mux_grant(grant_next[k],grantat[k+1],new_req_rotate[k],grantat[k]);
      end
   endgenerate
endmodule