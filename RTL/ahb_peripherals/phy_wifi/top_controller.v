module top_controller(
    input clk,
    input reset,
    input valid_in,
    input TB_enable,
    input [3:0] ACS_counter,
    input TB_stop,
    input valid_out_fifo,
    input valid_out,
    input [14:0] write_address,
    input enable,
    output reg reset_viterbi,
    output reg active,
    output reg [12:0] max_read_address,
    output reg re_buffer,
    output reg re
    );
//-----------------------------------------------------------------------------------//
    reg valid_in_end,flag,re_enable,flag_TB,reset_enable;
    reg [7:0] TB_count;
    wire [7:0] TB_length;
    wire [7:0] TB_length_num;
    wire [14:0] num_bits;
    wire complete;
//-----------------------------------------------------------------------------------//
assign TB_length=8'd128;
assign TB_length_num=write_address/TB_length;
assign num_bits=TB_length*TB_length_num;
assign complete =(num_bits==write_address)? 0:1;
always @(posedge clk or negedge reset)
begin
    if(!reset) 
    begin
        valid_in_end<=0;
        flag<=0;
        active<=0;
        re_enable<=0;
        re<=0;
        flag_TB<=0;
        reset_enable<=1;
        reset_viterbi<=0;   
        TB_count<=8'b00000000;
        max_read_address<=0;
        re_buffer<=0; 
    end
    else
    begin
        if(valid_in==1) flag<=1;
        if(valid_in==0 && flag==1) valid_in_end<=1;
        if((valid_in_end==1 && ACS_counter==4'b1111 && !TB_enable &&re_enable)||(valid_in_end==1 && ACS_counter==4'b1101 && !TB_stop && !TB_enable && !re_enable)) 
        begin
        re<=1;
        re_enable<=0;
        end
        else 
        begin
        re<=0;
        end
        if (TB_enable)
        begin
            active<=0; 
        end
        else
        begin
            if(re==1) 
            begin
                if(TB_count!=(write_address[14:7]+(write_address[0]|write_address[1]| write_address[2]| write_address[3]| write_address[4]| write_address[5]| write_address[6]))) active<=1;
                else
                begin
                    if(enable) re_buffer<=1;
                    max_read_address<=(write_address/2)-1;
                end
            end
        end
        if(valid_out==1) flag_TB<=1;
        if(valid_out==0 && flag_TB==1)
        begin
            flag_TB<=0;
            reset_viterbi<=0;
            reset_enable<=1;
            TB_count<= TB_count+1;
        end
        if(reset_viterbi==0 && reset_enable==1) 
        begin
            reset_viterbi<=1;
            reset_enable<=0;
            re_enable<=1;
        end
        
    end   
end
//---------------------------------------------------------------------------------------------//
endmodule
