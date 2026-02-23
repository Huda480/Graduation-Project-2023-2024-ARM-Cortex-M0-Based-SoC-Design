module traceback_decoder_wifi(
    input clk,            
	input reset,        
    input valid_in, // TB_enable
    input WE_in,     
    input [6:0]least_PM, 
    input [7:0]least_SM,
    output reg read_enable, // read enable to survoir memory and write enable to trace back memory
    output reg [7:0] address_read,
    output reg [5:0] re_page,
    output  decoded_data,
    output reg valid_out          
);
//------------------------------------------------------------------------------------------------------------//
reg [5:0] counter,stall1;
reg [7:0] Least;
reg data_in_mem,RE,synch,synch2,flag,flag_synch2,counter_enable,WE,Least_enable,decrement;
//------------------------------------------------------------------------------------------------------------//
TB_Memory Mem (clk,reset,RE,read_enable,stall1,stall1,data_in_mem,decoded_data);
//-----------------------------------------------------------------------------------------------------------//
always @(posedge clk or negedge reset )
begin 
    if (!reset)
    begin 
        address_read<=8'hff;
        re_page<=0;   
        counter<=6'b111111;
        stall1<=6'b111111;
        Least<=8'b00000001;
        valid_out<=0;
        RE<=0;
        read_enable<=0;
        data_in_mem<=0;
        synch<=0;
        synch2<=0;
        flag<=0;
        flag_synch2<=0;
        counter_enable<=1;
        WE<=0;
        Least_enable<=0;
        decrement<=1;
    end 
    else 
    begin  
        if(valid_in==1)
        begin
            WE<=WE_in;
            synch <= !synch;
            if(synch) synch2<= !synch2;
            if(synch2==1) flag_synch2<=1;
            if(synch2==0 && flag_synch2==1)
            begin
                flag_synch2<=0;
                counter_enable<=1;
            end
            address_read<=Least;
            stall1<=counter;
            re_page<=stall1;   
            if((counter==63)&&(RE==0)&&(!flag)) 
            begin
                Least[7:1]<=least_PM;
                Least[0]<=0;
                data_in_mem=least_PM[0];
                read_enable<=1;
                flag<=1;
            end
            else
            begin
                if(least_SM[0]==0)
                begin
                Least<= least_SM;
                data_in_mem<=least_SM[1];
                Least_enable<=0;
                end
                read_enable<=0;
            end
            if((counter!=0)&&(read_enable==0)&& (counter_enable==1)&&(decrement==1))
            begin
                counter<=counter-1;
                counter_enable<=0;
                Least_enable<=1;
                read_enable<=1;
            end
            if((counter==0)&&(read_enable==0)&& (counter_enable==1)&&(decrement==1))
            begin
                counter_enable<=0;
                read_enable<=1;
                decrement<=0;
            end
            if((counter==0)&& (counter_enable==1)&&(decrement==0))
            begin
                RE<=1;
                read_enable<=0;
            end
            if((RE==1)&&(counter!=63)) counter=counter+1;
            if((RE==1)&&(counter==2)) valid_out<=1;
            if((RE==1)&&(stall1==63))
            begin
                RE<=0;
            end
            if((RE==0)&&(stall1==63)) valid_out<=0;
        end
    end
 end
 
endmodule
//=============================================================================================//

module TB_Memory #(parameter AD=6, DATA=1, MEM=64) 
(
	clk,
	reset,
	re,
	we,
	read_address,
	write_address,
	data_in,
	data_out
);
//---------------------------------------------------------------------------------------------//
	input clk;
	input reset;
	input re;
	input we;
	input [AD-1:0] read_address;
	input [AD-1:0] write_address;
	input data_in;
	output data_out;
//----------------------------------------------------------------------------------------------//
	reg [DATA-1:0] ram [MEM-1:0];
	reg data_out;
//----------------------------------------------------------------------------------------------//
	always @(posedge clk) if (we)	ram[write_address] <= data_in;
	always @(posedge clk or negedge reset)
	begin 
		if (!reset)	data_out 	<= 0;
		else if (re)	data_out  	<= ram[read_address];
	end

endmodule
