/////////////////////////////////////////////////////////////////////
////  AHB DMA request & acknowledge & transfer complete arbiter  ////
////                                                             ////
////  Author: Ibrahim Hossam                                     ////
/////////////////////////////////////////////////////////////////////
module req_arb #(
//==========================================================================
// Parameters
//==========================================================================
parameter channel_number = 31 ,system_req_number = 15 ,channel_number_bits = $clog2(channel_number))(
//==========================================================================
// Inputs & Outputs
//==========================================================================
input       [system_req_number-1:0]   req,
input       [channel_number-1:0]      ch_ack,
input       [channel_number-1:0]      ch_done_all,
input       [31:0]                    ch_csr_req [0:channel_number-1],
input       [31:0]                    ch_csr     [0:channel_number-1],
input                                 no_more_peripheral_to_peripheral_burst_reg,
input                                 no_more_peripheral_to_peripheral_no_burst_reg,
input       [channel_number_bits-1:0] saved_channel_burst,
input       [channel_number_bits-1:0] saved_channel_no_burst,
input       [channel_number-1:0]      source_req_done_for_channel,
output reg  [channel_number-1:0]      ch_req,
output reg  [channel_number-1:0]      dst_ch_req,
output reg  [channel_number-1:0]      real_pref_to_pref,
output reg  [system_req_number-1:0]   ack,
output reg  [system_req_number-1:0]   done_all
);
//==========================================================================
// Main code
//==========================================================================
    integer k ;
    generate 
    always_comb
        begin
            ack = 'b0;
            done_all = 'b0 ;
            ch_req = 'b0;
            dst_ch_req = 'b0 ;
            real_pref_to_pref = 'b0;
            for(k=0;k<channel_number;k=k+1)
            begin
                if (ch_csr[k][0]) 
                begin
                    ch_req[k] = req[ch_csr_req[k][4:0]] ;
                    ack[ch_csr_req[k][4:0]] = ch_ack[k] ;

                    if(ch_csr[k][24])
                    begin
                        if(|ch_csr[k][23:21])
                        begin
                            if(!no_more_peripheral_to_peripheral_burst_reg | (saved_channel_burst == k)) 
                            begin
                                dst_ch_req[k] = req[ch_csr_req[k][9:5]] ;
                                real_pref_to_pref[k] = 1'b1;
                                if(source_req_done_for_channel[k])
                                begin
                                    ack[ch_csr_req[k][9:5]] = ch_ack[k] ;
                                    ack[ch_csr_req[k][4:0]] = 1'b0 ;
                                end
                            end
                            else
                            begin
                                ch_req [k] = req[ch_csr_req[k][4:0]] && req[ch_csr_req[k][9:5]];
                                real_pref_to_pref[k] = 1'b0;
                                ack[ch_csr_req[k][9:5]] = ch_ack[k] ;
                                ack[ch_csr_req[k][4:0]] = ch_ack[k] ;
                            end  
                        end
                        
                        else
                        begin
                            if(!no_more_peripheral_to_peripheral_no_burst_reg | (saved_channel_no_burst == k)) 
                            begin
                                dst_ch_req[k] = req[ch_csr_req[k][9:5]] ;
                                real_pref_to_pref[k] = 1'b1;
                                if(source_req_done_for_channel[k])
                                begin
                                    ack[ch_csr_req[k][9:5]] = ch_ack[k] ;
                                    ack[ch_csr_req[k][4:0]] = 1'b0 ;
                                end
                            end
                            else
                            begin
                                ch_req [k] = req[ch_csr_req[k][4:0]] && req[ch_csr_req[k][9:5]];
                                real_pref_to_pref[k] = 1'b0;
                                ack[ch_csr_req[k][9:5]] = ch_ack[k] ;
                                ack[ch_csr_req[k][4:0]] = ch_ack[k] ;
                            end  
                        end
                    end    
                end
                if(ch_csr[k][11])
                begin
                    done_all[ch_csr_req[k][4:0]] = ch_done_all[k];
                    if(ch_csr[k][24])
                    done_all[ch_csr_req[k][9:5]] = ch_done_all[k];
                end

            end
        end
    endgenerate


    `ifdef SIM_DMA
        always_comb 
        begin
            foreach(ch_req[i])
            begin
                if(ch_csr[i][0])
                begin
                    if((no_more_peripheral_to_peripheral_burst_reg && (|ch_csr[i][23:21]) && ch_csr[i][24] && (saved_channel_burst != i)) ||
                       (no_more_peripheral_to_peripheral_no_burst_reg && !(|ch_csr[i][23:21]) && ch_csr[i][24] && (saved_channel_no_burst != i)))
                    begin   
                        ch_req_func_assert : assert final (ch_req[i] == (req[ch_csr_req[i][4:0]] && req[ch_csr_req[i][9:5]]));
                        ch_req_func_cover  : cover  final (ch_req[i] == (req[ch_csr_req[i][4:0]] && req[ch_csr_req[i][9:5]]));
                    end
                    else
                    begin
                        ch_req_func_assert_no_p2p : assert final (ch_req[i] == req[ch_csr_req[i][4:0]]);
                        ch_req_func_cover_no_p2p  : cover  final (ch_req[i] == req[ch_csr_req[i][4:0]]); 
                    end
                end

                else 
                begin
                    ch_req_func_assert_no_enable : assert final (ch_req[i] == 1'b0);
                    ch_req_func_cover_no_enable  : cover  final (ch_req[i] == 1'b0);
                end

            end

            foreach(dst_ch_req[i])
            begin
                if(ch_csr[i][0] && ch_csr[i][24])
                begin
                    if((no_more_peripheral_to_peripheral_burst_reg && (|ch_csr[i][23:21]) && !(saved_channel_burst == i)) ||
                    (no_more_peripheral_to_peripheral_no_burst_reg && !(|ch_csr[i][23:21]) && !(saved_channel_no_burst == i)))
                    begin   
                        dst_ch_req_func_assert_not_real : assert final (dst_ch_req[i] == 1'b0);
                        dst_ch_req_func_cover_not_real  : cover  final (dst_ch_req[i] == 1'b0);
                        no_real_p2p_assert              : assert final (real_pref_to_pref[i] == 1'b0); 
                        no_real_p2p_cover               : cover  final (real_pref_to_pref[i] == 1'b0); 
                    end
                    else
                    begin
                        dst_ch_req_func_assert : assert final (dst_ch_req[i] == req[ch_csr_req[i][9:5]]);
                        dst_ch_req_func_cover  : cover  final (dst_ch_req[i] == req[ch_csr_req[i][9:5]]);
                        real_p2p_assert        : assert final (real_pref_to_pref[i] == 1'b1); 
                        real_p2p_cover         : cover  final (real_pref_to_pref[i] == 1'b1); 
                    end
                end

                else 
                begin
                    dst_ch_req_func_assert_no_enable : assert final (dst_ch_req[i] == 1'b0);
                    dst_ch_req_func_cover_no_enable  : cover  final (dst_ch_req[i] == 1'b0);
                    real_p2p_assert_no_enable        : assert final (real_pref_to_pref[i] == 1'b0); 
                    real_p2p_cover_no_enable         : cover  final (real_pref_to_pref[i] == 1'b0); 
                end

            end

            foreach (ch_ack[i]) begin
                if(ch_ack[i] == 1'b1 && ch_csr[i][0])
                begin
                    if((no_more_peripheral_to_peripheral_burst_reg && (|ch_csr[i][23:21]) && ch_csr[i][24] && !(saved_channel_burst == i)) ||
                       (no_more_peripheral_to_peripheral_no_burst_reg && !(|ch_csr[i][23:21]) && ch_csr[i][24] && !(saved_channel_no_burst == i)))
                    begin
                        src_dst_ack_assert : assert final (ack[ch_csr_req[i][9:5]] == ch_ack[i] && ack[ch_csr_req[i][4:0]] == ch_ack[i]);
                        src_dst_ack_cover  : cover  final (ack[ch_csr_req[i][9:5]] == ch_ack[i] && ack[ch_csr_req[i][4:0]] == ch_ack[i]);
                    end

                    else if(source_req_done_for_channel[i] && ch_csr[i][24])
                    begin
                        dst_ack_only_assert : assert final (ack[ch_csr_req[i][9:5]] == ch_ack[i]);
                        dst_ack_only_cover  : cover  final (ack[ch_csr_req[i][9:5]] == ch_ack[i]);
                        no_src_ack_assert   : assert final (ack[ch_csr_req[i][4:0]] == 1'b0);
                        no_src_ack_cover    : cover final (ack[ch_csr_req[i][4:0]] == 1'b0);
                    end

                    else
                    begin
                        src_ack_only_assert : assert final (ack[ch_csr_req[i][4:0]] == ch_ack[i]);
                        src_ack_only_cover  : cover  final (ack[ch_csr_req[i][4:0]] == ch_ack[i]);
                        no_dst_ack_assert   : assert final (ack[ch_csr_req[i][9:5]] == 1'b0);
                        no_dst_ack_cover    : cover final  (ack[ch_csr_req[i][9:5]] == 1'b0);
                    end
                end
                else
                begin
                    no_enable_src_ack_assert   : assert final (ack[ch_csr_req[i][4:0]] == 1'b0);
                    no_enable_src_ack_cover    : cover  final (ack[ch_csr_req[i][4:0]] == 1'b0);
                    no_enable_dst_ack_assert   : assert final (ack[ch_csr_req[i][9:5]] == 1'b0);
                    no_enable_dst_ack_cover    : cover final  (ack[ch_csr_req[i][9:5]] == 1'b0);
                end
            end

            foreach (ch_done_all[i]) begin
                if(ch_csr[i][11] && ch_done_all[i] == 1'b1 && !ch_csr[i][0])
                begin
                    src_done_all_assert : assert final (done_all[ch_csr_req[i][4:0]] == ch_done_all[i]);
                    src_done_all_cover  : cover  final (done_all[ch_csr_req[i][4:0]] == ch_done_all[i]);
                    if(ch_csr[i][24])
                    begin
                        dst_done_all_assert : assert final (done_all[ch_csr_req[i][9:5]] == ch_done_all[i]);
                        dst_done_all_cover  : cover  final (done_all[ch_csr_req[i][9:5]] == ch_done_all[i]);
                    end
                    else
                    begin
                        no_p2p_dst_done_all_assert : assert final (done_all[ch_csr_req[i][9:5]] == 1'b0);
                        no_p2p_dst_done_all_cover  : cover  final (done_all[ch_csr_req[i][9:5]] == 1'b0); 
                    end
                end
                else
                begin
                    no_enable_dst_done_all_assert : assert final (done_all[ch_csr_req[i][9:5]] == 1'b0);
                    no_enable_dst_done_all_cover  : cover  final (done_all[ch_csr_req[i][9:5]] == 1'b0);
                    no_enable_src_done_all_assert : assert final (done_all[ch_csr_req[i][4:0]] == 1'b0);
                    no_enable_src_done_all_cover  : cover  final (done_all[ch_csr_req[i][4:0]] == 1'b0);
                end
            end
        end



    `endif 

endmodule