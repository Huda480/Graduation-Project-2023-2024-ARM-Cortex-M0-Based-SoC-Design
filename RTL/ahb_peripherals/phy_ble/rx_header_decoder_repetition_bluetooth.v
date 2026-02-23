/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Repetition Code decoder
				Created By : Eslam Elnader
======================================================================================
*/
module repetition_code_decoder_ble
(
    clk,
    reset,
    valid_in,
    data_in,
    enable,
    valid_out,
    data_out,
    finished
);
//-----------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
input enable;
output valid_out;
output data_out;
output finished;
//-----------------------------------------------------------
reg we_1;
reg we_2;
reg we_3;
reg re;
reg data_in_delayed;
reg [2:0] counter;
reg flag_valid_in;
reg flag_valid_out;
reg finished;
//-----------------------------------------------------------
wire [2:0] data_out_ram;
//-----------------------------------------------------------
mapper_ram_bt_ble ram1
(
	.clk(clk),
	.reset(reset),
	.re(re),
	.we(we_1),
	.data_in(data_in_delayed),
	.data_out(data_out_ram[2]),
	.valid_out(valid_out)
);
//-----------------------------------------------------------
mapper_ram_bt_ble ram2
(
	.clk(clk),
	.reset(reset),
	.re(re),
	.we(we_2),
	.data_in(data_in_delayed),
	.data_out(data_out_ram[1]),
	.valid_out()
);
//-----------------------------------------------------------
mapper_ram_bt_ble ram3
(
	.clk(clk),
	.reset(reset),
	.re(re),
	.we(we_3),
	.data_in(data_in_delayed),
	.data_out(data_out_ram[0]),
	.valid_out()
);
//-----------------------------------------------------------
assign data_out=((data_out_ram[0]&data_out_ram[1])|(data_out_ram[0]&data_out_ram[2])|(data_out_ram[1]&data_out_ram[2]));
//-----------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset == 1'b0)
    begin
        data_in_delayed <= 1'b0;
        counter         <= 2'b00;
        we_1            <= 1'b0;
        we_2            <= 1'b0;
        we_3            <= 1'b0;
        re              <= 1'b0;
        flag_valid_in   <= 1'b0;
        flag_valid_out  <= 1'b0;
        finished        <= 1'b1;
    end
    else
    begin
        if(valid_in == 1'b1)
        begin
            flag_valid_in   <=1'b1;
            data_in_delayed <= data_in;
            if(counter == 2'b10)    counter <= 2'b00;
            else    counter <= counter + 2'b01;
            if(counter == 2'b00)
            begin
                we_1 <= 1'b1;
                we_2 <= 1'b0;
                we_3 <= 1'b0;
            end
            else
            begin
                if(counter==2'b01)
                begin
                    we_1 <= 1'b0;
                    we_2 <= 1'b1;
                    we_3 <= 1'b0;
                end
                else
                begin
                    we_1 <= 1'b0;
                    we_2 <= 1'b0;
                    we_3 <= 1'b1;
                end
            end
        end
        else
        begin
            if(flag_valid_in == 1'b1)
            begin
                we_1     <= 1'b0;
                we_2     <= 1'b0;
                we_3     <= 1'b0;
                finished <= 1'b0;
                counter  <= 2'b00; 
                if(enable == 1'b1)
                begin
                    re <= 1'b1;
                end
                if(valid_out == 1'b1) flag_valid_out <= 1'b1;
                if((valid_out == 1'b0) && (flag_valid_out==1'b1))
                begin
                    flag_valid_out <= 1'b0;
                    flag_valid_in  <= 1'b0;
                    finished       <= 1'b1;
                    re             <= 1'b0;
                end
            end 
        end
    end
end
//-----------------------------------------------------------
endmodule
