/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Whitening/De-Whitening
				Created By : Eslam Elnader
======================================================================================
*/
module whitening_ble
(
    clk,
    reset,
    valid_in,
    data_in,
    enable,
    int_D,
    valid_out,
    data_out,
    finished
);
//-----------------------------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
input enable;
input [5:0] int_D;
output valid_out;
output data_out;
output finished;
//-----------------------------------------------------------------------------
reg D0,D1,D2,D3,D4,D5,D6;
reg valid_out;
reg data_out; 
reg finished;
//-----------------------------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        D0          <= 1'b0;
        D1          <= 1'b0;
        D2          <= 1'b0;
        D3          <= 1'b0;
        D4          <= 1'b0;
        D5          <= 1'b0;
        D6          <= 1'b1;
        data_out    <= 1'b0;
        valid_out   <= 1'b0;
        finished    <= 1'b1;
    end
    else
    begin
        if(enable == 1'b0)
        begin
            D0        <= int_D[0]; 
            D1        <= int_D[1]; 
            D2        <= int_D[2]; 
            D3        <= int_D[3]; 
            D4        <= int_D[4]; 
            D5        <= int_D[5]; 
            D6        <= 1'b1;
            data_out  <= 1'b0;
            valid_out <= 1'b0;
            finished  <= 1'b0; 
        end
        else
        begin
            if(valid_in == 1'b1)
            begin
                D0        <= D6;
                D1        <= D0;
                D2        <= D1;
                D3        <= D2;
                D4        <= D3 ^ D6;
                D5        <= D4;
                D6        <= D5;
                data_out  <= data_in ^ D6;
                valid_out <= 1'b1;
                finished  <= 1'b1; 
            end
            else
            begin
                D0        <= int_D[0]; 
                D1        <= int_D[1]; 
                D2        <= int_D[2]; 
                D3        <= int_D[3]; 
                D4        <= int_D[4]; 
                D5        <= int_D[5]; 
                D6        <= 1'b1;
                data_out  <= 1'b0;
                valid_out <= 1'b0;
                finished  <= 1'b1; 
            end
        end
    end
end
//-----------------------------------------------------------------------------
endmodule
