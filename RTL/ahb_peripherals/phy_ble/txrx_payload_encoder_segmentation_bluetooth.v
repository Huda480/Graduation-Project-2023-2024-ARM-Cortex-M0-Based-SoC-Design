/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Block Code Segmentation
				Created By : Eslam Elnader
======================================================================================
*/
module Block_Segmentation_ble
(
    clk,
    reset,
    data_in,
    valid_in,
    required_block_size,
    enable,
    n_bits,
    n_blocks,
    data_out,
    valid_out
);
//------------------------------------------------------------------------
input clk;
input reset;
input data_in;
input valid_in;
input enable;
input [4:0] required_block_size;
input [15:0] n_bits;
output [9:0] n_blocks;
output data_out;
output valid_out;
//------------------------------------------------------------------------
reg re_input_ram;
reg [4:0] bit_counter;
reg [9:0] n_blocks;
reg valid_in_happened;
reg [9:0] block_index;
//------------------------------------------------------------------------
mapper_ram_bt_ble #(14, 1, 16384) encoder_input_ram 
(
	.clk(clk),
	.reset(reset),
	.re(re_input_ram),
	.we(valid_in),
	.data_in(data_in),
	.data_out(data_out),
	.valid_out(valid_out)
);
//------------------------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        bit_counter         <= 5'b00000;
        n_blocks            <= 10'b0;
        block_index         <= 10'b0;
        re_input_ram        <= 1'b0;
        valid_in_happened   <= 1'b0;
    end
    else
    begin
        if(valid_in== 1'b1)
        begin
            //n_blocks          <= n_bits/required_block_size;
            //Commented: 28/6/2024
            //in TX
            //if the payload size+16 is not divisable by 10
            ////there will be some bits that are not encoded
            //in RX
            //This line is the reason of the assertion of the error flag
            //if the payload size+16 is not divisable by 10
            ////there will be some bits that are not decoded
            ////we should check the difference between payload size and decoded
            ////if not equal, increment the n_blocks+1 to decode all the bits
            n_blocks          <= n_bits/5'd10;
            valid_in_happened <= 1'b1;
        end
        else
        begin
            if((enable == 1'b1) & (valid_in_happened==1'b1))
            begin
                if(bit_counter>(required_block_size-5'd1))
                begin
                    re_input_ram    <= 1'b0;
                    if(bit_counter==required_block_size+5'd3)
                    begin
                        bit_counter     <= 5'b00000;
                        block_index     <= block_index+10'd1;
                    end   
                    else 
                        bit_counter     <= bit_counter+5'd1;
                    if(block_index == n_blocks-10'd1) 
                    begin   
                        valid_in_happened   <= 1'b0;
                        n_blocks            <= 10'b0;
                        block_index         <= 10'b0;
                    end
                end
                else
                begin
                    re_input_ram    <= 1'b1;
                    bit_counter     <= bit_counter+5'd1;
                end
            end
            else
            begin
                re_input_ram    <= 1'b0;
                bit_counter     <= 5'b0000;
            end
        end
    end
end
//------------------------------------------------------------------------

endmodule
