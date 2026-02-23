/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Hamming Code Encoder
				Created By : Eslam Elnader
======================================================================================
*/
module hamming_encoder_ble
(
    clk,
    reset,
    data_in,
    valid_in,
    valid_out,
    data_out,
    finished
);
//------------------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
output valid_out;
output data_out;
output finished;
//------------------------------------------------------------------
reg D0;
reg D1;
reg D2;
reg D3;
reg D4;
reg data_out;
reg valid_out; 
reg [3:0] counter;
//------------------------------------------------------------------
finish_generator_ble finished_signal
(
	.clk(clk),
	.reset(reset),
	.we(valid_in),
	.valid_out(valid_out),
	.finished(finished)
);
//------------------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        D0          <= 1'b0;
        D1          <= 1'b0;
        D2          <= 1'b0;
        D3          <= 1'b0;
        D4          <= 1'b0;
        counter     <= 4'b0;
        data_out    <= 1'b0;
        valid_out   <= 1'b0;        
    end
    else
    begin
        if(valid_in == 1'b1)
        begin
            if(counter < 4'b1010)   
                D0      <= D4 ^ data_in;
            else
                D0      <= 1'b0;                
            D1          <= D0;
            if(counter > 4'b1010)
                D2      <= D1;
            else
                D2      <= D1 ^ D4 ^ data_in;
            D3          <= D2;
            if(counter > 4'b1010)
                D4      <= D3;
            else
                D4      <= D3 ^ D4 ^ data_in;
            valid_out   <= 1'b1;
            data_out    <= data_in;
            counter     <= counter + 1;
        end
        else
        begin
            if(counter > 4'b1001)
            begin
                D0          <= 1'b0;
                D1          <= D0;
                D2          <= D1;
                D3          <= D2;
                D4          <= D3;                
                data_out    <= D4;
                valid_out   <= 1'b1;
                counter     <= counter + 1;
                if (counter == 4'b1111)
                begin
                    D0          <= 1'b0;
                    D1          <= 1'b0;
                    D2          <= 1'b0;
                    D3          <= 1'b0;
                    D4          <= 1'b0;
                    counter     <= 4'b0;
                    data_out    <= 1'b0;
                    valid_out   <= 1'b0;        
                end   
            end
        end 
    end
end
//------------------------------------------------------------------
endmodule
