/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Block Code Concatenation
				Created By : Eslam Elnader
======================================================================================
*/
module CBC_ble
(
    clk,
    reset,
    valid_in,
    data_in,
    n_blocks,
    valid_out,
    data_out
);
//-----------------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
input [9:0] n_blocks; 
output valid_out;
output data_out;
//-----------------------------------------------------------------
reg re;
reg valid_in_happened;
reg [9:0] n_blocks_saved;
reg [9:0] block_index;
reg valid_out_happened;
//-----------------------------------------------------------------
mapper_ram_bt_ble #(14, 1, 16384) encoder_input_buffer 
(
	.clk(clk),
	.reset(reset),
	.re(re),
	.we(valid_in),
	.data_in(data_in),
	.data_out(data_out),
	.valid_out(valid_out)
);
//-----------------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        re                  <= 1'b0;
        valid_in_happened   <= 1'b0;
        n_blocks_saved      <= 10'b0;
        block_index         <= 10'b0;
        valid_out_happened  <= 1'b0;
    end
    else
    begin
        if(valid_out==1'b1)
            valid_out_happened <= 1'b1;
        else
        begin
            if(valid_out_happened==1'b1)
            begin
                re                  <= 1'b0;
                valid_in_happened   <= 1'b0;
                n_blocks_saved      <= 10'b0;
                block_index         <= 10'b0;
                valid_out_happened  <= 1'b0;            
            end
        end
        if(valid_in==1)
        begin
            n_blocks_saved <= n_blocks;
            valid_in_happened <= 1'b1;
            if(valid_in_happened==1'b0)
                block_index <= block_index + 10'd1;
        end
        else
            valid_in_happened <= 1'b0;
        if((block_index<n_blocks_saved)&(valid_in_happened==1'b0))
            re <= 1'b0;
        else
        begin
            if((block_index>=n_blocks_saved)&(valid_in_happened==1'b0))
                re          <= 1'b1;
            else
                re          <= 1'b0;
        end
    end
end
//-----------------------------------------------------------------
endmodule
