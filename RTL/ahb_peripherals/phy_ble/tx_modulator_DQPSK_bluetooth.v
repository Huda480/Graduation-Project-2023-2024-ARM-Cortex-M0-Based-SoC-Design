/*
======================================================================================
				Standard   : Bluetooth 
				Block name : DQPSK Modulator
				Created By : Eslam Elnader
======================================================================================
*/
module QPSK_ble #(parameter RE_IM_SIZE=12)
(
    clk,
    reset,
    valid_in,
    data_in,
    enable,
    valid_out,
    data_out_re,
    data_out_im,
    finished
);
//-----------------------------------------------------------
input clk;
input reset;
input valid_in;
input data_in;
input enable;
output valid_out;
output [RE_IM_SIZE-1:0] data_out_re;
output [RE_IM_SIZE-1:0] data_out_im;
output finished;
//-----------------------------------------------------------
reg we_1;
reg we_2;
reg re;
reg data_in_delayed;
reg counter;
reg flag_valid_in;
reg flag_valid_out;
reg finished;
//-----------------------------------------------------------
wire [1:0] data_out_ram;
wire [1:0] data_out_differential;
//-----------------------------------------------------------
mapper_ram_bt_ble ram1
(
	.clk(clk),
	.reset(reset),
	.re(re),
	.we(we_1),
	.data_in(data_in_delayed),
	.data_out(data_out_ram[0]),
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
quadrature_differential_encoder_ble QPSK_differential_encoder
(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_out),
    .data_in(data_out_ram),
    .valid_out(),
    .data_out(data_out_differential)
);
//-----------------------------------------------------------
assign data_out_re = (data_out_differential[1] == 1'b0)? 12'b000101101010 : 12'b111010010110;
assign data_out_im = (data_out_differential[0] == 1'b0)? 12'b000101101010 : 12'b111010010110;
//-----------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset == 1'b0)
    begin
        data_in_delayed <= 1'b0;
        counter         <= 1'b0;
        we_1            <= 1'b0;
        we_2            <= 1'b0;
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
            counter         <= counter + 1'b1;
            if(counter == 1'b0)
            begin
                we_1 <= 1'b1;
                we_2 <= 1'b0;
            end
            else
            begin
                we_1 <= 1'b0;
                we_2 <= 1'b1;
            end
        end
        else
        begin
            if(flag_valid_in == 1'b1)
            begin
                we_1     <= 1'b0;
                we_2     <= 1'b0;
                finished <= 1'b0;
                counter  <= 1'b0; 
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
//=================================================================================================
module quadrature_differential_encoder_ble
(
    clk,
    reset,
    valid_in,
    data_in,
    valid_out,
    data_out
);
//------------------------------------------------------------
input clk;
input reset;
input valid_in;
input [1:0] data_in;
output valid_out;
output [1:0] data_out;
//-------------------------------------------------------------
reg [1:0] previous_input;
wire [1:0] data_out_temp_1;
wire [1:0] data_out_temp_2;
wire [1:0] data_out_temp_3;
wire [1:0] data_out_temp_4;
//-------------------------------------------------------------
assign valid_out = valid_in;
assign data_out_temp_1=(previous_input==2'b00)? 2'b00:
                       (previous_input==2'b01)? 2'b01:
                       (previous_input==2'b11)? 2'b11:
                                                2'b10;
//______________________________________________________
assign data_out_temp_2=(previous_input==2'b00)? 2'b01:
                       (previous_input==2'b01)? 2'b11:
                       (previous_input==2'b11)? 2'b10:
                                                2'b00;
//______________________________________________________
assign data_out_temp_3=(previous_input==2'b00)? 2'b11:
                       (previous_input==2'b01)? 2'b10:
                       (previous_input==2'b11)? 2'b00:
                                                2'b01;
//______________________________________________________
assign data_out_temp_4=(previous_input==2'b00)? 2'b10:
                       (previous_input==2'b01)? 2'b00:
                       (previous_input==2'b11)? 2'b01:
                                                2'b11;
//______________________________________________________                                                                                                
assign data_out=(data_in==2'b00)? data_out_temp_1:
                (data_in==2'b01)? data_out_temp_2:
                (data_in==2'b11)? data_out_temp_3:
                                  data_out_temp_4;                                                                                            
//-------------------------------------------------------------
always @(posedge clk or negedge reset)
begin
    if(reset == 1'b0)
    begin
        previous_input <= 2'b00;
    end
    else
    begin
        if(valid_in==1'b1)
        begin
            previous_input <= data_out;
        end
        else
        begin
            previous_input <= 2'b00;
        end
    end
end
//-------------------------------------------------------------
endmodule
