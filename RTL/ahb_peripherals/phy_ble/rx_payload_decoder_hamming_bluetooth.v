/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Hamming Block Code decoder
				Created By : Eslam Elnader
======================================================================================
*/
module HammingDec_ble
(
    clk,
    reset,
    valid_in,
    data_in,
    valid_out,
    data_out,
    decoded,
    finished
);
//-----------------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
output valid_out;
output data_out;
output decoded;
output finished;
//-----------------------------------------------------------------
reg D0;
reg D1;
reg D2;
reg D3;
reg D4;
reg D5;
reg D6;
reg D7;
reg D8;
reg D9;
reg D10;
reg D11;
reg D12;
reg D13;
reg D14;
reg [4:0] S; // Syndrome
reg valid_out;
reg data_out;
reg flag_valid_in;
reg correct_input;
reg decoded;
reg output_data;
reg [3:0] counter_out;
wire [15:0] e; // error retreival matrix
//-----------------------------------------------------------------
finish_generator_ble finished_signal
(
	.clk(clk),
	.reset(reset),
	.we(valid_in),
	.valid_out(valid_out),
	.finished(finished)
);
//-----------------------------------------------------------------
assign e = (S==5'b00000)? 16'b0000000000000000:
           (S==5'b00001)? 16'b0000000000000001:
           (S==5'b00010)? 16'b0000000000000010:
           (S==5'b00100)? 16'b0000000000000100:
           (S==5'b01000)? 16'b0000000000001000:
           (S==5'b10000)? 16'b0000000000010000:
           (S==5'b10101)? 16'b0000000000100000:
           (S==5'b11111)? 16'b0000000001000000:
           (S==5'b01011)? 16'b0000000010000000:
           (S==5'b10110)? 16'b0000000100000000:
           (S==5'b11001)? 16'b0000001000000000:
           (S==5'b00111)? 16'b0000010000000000:
           (S==5'b01110)? 16'b0000100000000000:
           (S==5'b11100)? 16'b0001000000000000:
           (S==5'b01101)? 16'b0010000000000000:
           (S==5'b11010)? 16'b0100000000000000:
                          16'b1000000000000000;
//-----------------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        D0              <= 1'b0;
        D1              <= 1'b0;
        D2              <= 1'b0;
        D3              <= 1'b0;
        D4              <= 1'b0;
        D5              <= 1'b0;
        D6              <= 1'b0;
        D7              <= 1'b0;
        D8              <= 1'b0;
        D9              <= 1'b0;
        D10             <= 1'b0;
        D11             <= 1'b0;
        D12             <= 1'b0;
        D13             <= 1'b0;
        D14             <= 1'b0;
        valid_out       <= 1'b0;
        flag_valid_in   <= 1'b0;
        data_out        <= 1'b0;
        correct_input   <= 1'b0;
        output_data     <= 1'b0;
        decoded         <= 1'b0;
        counter_out     <= 4'b0;
    end
    else
    begin
        if(valid_in == 1'b1)
        begin
            valid_out       <= 1'b0;
            D0              <= data_in;      
            D1              <= D0;      
            D2              <= D1;      
            D3              <= D2;      
            D4              <= D3;      
            D5              <= D4;      
            D6              <= D5;      
            D7              <= D6;      
            D8              <= D7;      
            D9              <= D8;      
            D10             <= D9;      
            D11             <= D10;      
            D12             <= D11;      
            D13             <= D12;      
            D14             <= D13;      
            flag_valid_in   <= 1'b1;
            correct_input   <= 1'b0;
            output_data     <= 1'b0;
            counter_out     <= 4'b0;
        end
        else
        begin
            if(flag_valid_in==1'b1)
            begin
                valid_out       <= 1'b0;
                S[0]            <= D13 ^ D10 ^ D9 ^ D7 ^ D6 ^ D5 ^ D0;
                S[1]            <= D14 ^ D11 ^ D10 ^ D8 ^ D7 ^ D6 ^ D1;
                S[2]            <= D13 ^ D12 ^ D11 ^ D10 ^ D8 ^ D6 ^ D5 ^ D2;
                S[3]            <= D14 ^ D13 ^ D12 ^ D11 ^ D9 ^ D7 ^ D6 ^ D3;
                S[4]            <= D14 ^ D12 ^ D9 ^ D8 ^ D6 ^ D5 ^ D4;
                flag_valid_in   <= 1'b0;
                correct_input   <= 1'b1;
                output_data     <= 1'b0;
                counter_out     <= 4'b0;
            end
            else
            begin
                if(correct_input==1'b1)
                begin
                    D0              <= D0 ^ e[0];
                    D1              <= D1 ^ e[1];
                    D2              <= D2 ^ e[2];
                    D3              <= D3 ^ e[3];
                    D4              <= D4 ^ e[4];
                    D5              <= D5 ^ e[5];
                    D6              <= D6 ^ e[6];
                    D7              <= D7 ^ e[7];
                    D8              <= D8 ^ e[8];
                    D9              <= D9 ^ e[9];
                    D10             <= D10 ^ e[10];
                    D11             <= D11 ^ e[11];
                    D12             <= D12 ^ e[12];
                    D13             <= D13 ^ e[13];
                    D14             <= D14 ^ e[14];
                    decoded         <= e[15];
                    flag_valid_in   <= 1'b0;
                    valid_out       <= 1'b0;
                    correct_input   <= 1'b0;
                    output_data     <= 1'b1;
                    counter_out     <= 4'b0;
                end
                else
                begin
                    if(output_data)
                    begin
                        counter_out     <= counter_out+4'd1;
                        D0              <= 1'b0;
                        D1              <= D0;      
                        D2              <= D1;      
                        D3              <= D2;      
                        D4              <= D3;      
                        D5              <= D4;      
                        D6              <= D5;      
                        D7              <= D6;      
                        D8              <= D7;      
                        D9              <= D8;      
                        D10             <= D9;      
                        D11             <= D10;      
                        D12             <= D11;      
                        D13             <= D12;      
                        D14             <= D13;      
                        data_out        <= D14;           
                        if(counter_out==4'b1111)
                        begin
                            output_data <= 1'b0;
                            counter_out <= 4'b0;
                        end
                        else
                        begin
                            if(counter_out < 4'b1010)
                                valid_out <= 1'b1;
                            else
                                valid_out <= 1'b0;
                        end
                    end
                    else
                    begin
                        D0              <= 1'b0;
                        D1              <= 1'b0;
                        D2              <= 1'b0;
                        D3              <= 1'b0;
                        D4              <= 1'b0;
                        D5              <= 1'b0;
                        D6              <= 1'b0;
                        D7              <= 1'b0;
                        D8              <= 1'b0;
                        D9              <= 1'b0;
                        D10             <= 1'b0;
                        D11             <= 1'b0;
                        D12             <= 1'b0;
                        D13             <= 1'b0;
                        D14             <= 1'b0;
                        valid_out       <= 1'b0;
                        flag_valid_in   <= 1'b0;
                        data_out        <= 1'b0;
                        correct_input   <= 1'b0;
                        output_data     <= 1'b0;
                        decoded         <= 1'b0;
                        counter_out     <= 4'b0;                    
                    end
                end
            end
        end
    end
end
//-----------------------------------------------------------------
endmodule
