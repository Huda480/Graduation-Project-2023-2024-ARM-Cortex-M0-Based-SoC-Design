/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Intermediate RAM top
				Modified By: Abdulrahman Galal 
				Last Edited: 24/6/2024
======================================================================================
*/
module inter_ram_top_ble #(parameter AD=13, DATA=12, MEM=8192)(
    clk,
    reset,
    tx_finished,
    data_in_count_header,
    data_in_count_payload,
    tx_valid_out,
    data_in,
    valid_out,
    data_out
    );
    
    input clk;
    input reset;
    input tx_finished;
    input [11:0] data_in_count_header;
    input [11:0] data_in_count_payload;
    input tx_valid_out;
    input [DATA-1:0] data_in;
    output valid_out;
    output [DATA-1:0] data_out;
    
    wire [AD-1:0] read_address;
    wire [AD-1:0] write_address;
    
    reg [7:0] wait_counter;
    reg [11:0] data_counter;
    reg rx_valid_in;
    reg tx_finished_happened;
    //============================================================================
    //we need the RX to read the data from the intermediate RAM as the TX read it from the FIFO
    ////CHECK DATA SEGMENTATION CODE FIRST
    ////when tx finishes writing rx_valid_in is asserted till the header is read
    ////now we need to deassert the valid signal and wait then read the payload
    ////this way will assuers the stability of the chain, as it is expected to get the data in this way
    //WE COULD MODIFY IT A LTTLE TO START READING WHEN THE WRITTING REACHES HALF THE PAYLOAD SIZE,
    //THIS WILL AVOID MISS READING AND REDUCES LATENCY
    //============================================================================
    always @(posedge clk or negedge reset) begin
        if(~reset) begin
            tx_finished_happened    <= 0;
            rx_valid_in             <= 0;
            wait_counter            <= 17;
            data_counter            <= 0;
        end
        else begin
           // if((wait_counter >= data_in_count) && (read_address != write_address)) begin
            if(tx_finished==1 ) begin
                tx_finished_happened    <=1;
            end
            else begin
                //if( (tx_finished_happened) == 1 && (read_address != write_address) ) begin
                if( (tx_finished_happened) == 1) begin
                    if (data_counter < data_in_count_header) begin
                        rx_valid_in     <= 1'b1;
                        data_counter    <= data_counter + 1;
                    end
                    else begin
                        if(wait_counter > 8'd0)
                        begin
                            rx_valid_in             <= 1'b0;
                            data_counter            <= data_counter;
                            wait_counter            <= wait_counter -8'd1;
                        end
                        else begin
                            rx_valid_in     <= 1'b1;
                            data_counter    <= data_counter + 1;
                            if (data_counter == data_in_count_header+data_in_count_payload) begin
                                rx_valid_in             <= 0;
                                tx_finished_happened    <= 0;
                                data_counter            <= 0;
                                wait_counter            <= 8'd17;
                            end
                        end //else wait is finished
                        end //else header is sent                   
                    end //if tx_finished_happened == 1
               end//else tx_finished != 1
        end//else not in reset mode
    end//always 
  
    //============================================================================    
        inter_ram_counter_bt_ble #(AD) inter_ram_counter_bt_inst
        (
            .clk(clk),
            .reset(reset),
            .re(rx_valid_in),
            .we(tx_valid_out),
            .read_address(read_address),
            .write_address(write_address)
        );
     //============================================================================       
        inter_ram_bt_ble #(AD,DATA,MEM) inter_ram_bt_inst 
        (
            .clk(clk),
            .reset(reset),
            .re(rx_valid_in),
            .we(tx_valid_out),
            .read_address(read_address),
            .write_address(write_address),
            .data_in(data_in),
            .valid_out_mem(valid_out),
            .data_out(data_out)
        );     
    //============================================================================
endmodule
//============================================================================
//Intermediate RAM counter
//============================================================================
module inter_ram_counter_bt_ble #(parameter AD=7)
(
	clk,
	reset,
	re,
	we,
	read_address,
	write_address
);
	//============================================================================
	input clk;
	input reset;
	input re;
	input we;
	output [AD-1:0] read_address;
	output [AD-1:0] write_address;
	//============================================================================
	reg [AD-1:0] read_address;
	reg [AD-1:0] write_address;
	//============================================================================
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if (!reset)
		begin
			write_address	<= 0;
		end
		//====================================================================
		else
		begin
			if (we)	write_address 	<= write_address +1;
		end
		//====================================================================
	end
	
	always @(posedge clk or negedge reset)
	begin
		//====================================================================
		if (!reset)
		begin
            read_address  	<= 0;
		end
		//====================================================================
		else
		begin
			if (re) read_address  	<= read_address  +1;
		end
		//====================================================================
	end
	
endmodule
/*
============================================================================
Intermediate RAM
TX writes and RX reads
============================================================================
*/	
module inter_ram_bt_ble #(parameter AD=14, DATA=12, MEM=16384) 
(
	clk,
	reset,
	re,
	we,
	read_address,
	write_address,
	data_in,
	valid_out_mem,
	data_out
);
	//============================================================================
	input              clk;
	input              reset;
	input              re;
	input              we;
	input [AD-1:0]     read_address;
	input [AD-1:0]     write_address;
	input [DATA-1:0]   data_in;
	output reg         valid_out_mem;
	output [DATA-1:0]  data_out;
	//============================================================================
	reg [DATA-1:0] ram [MEM-1:0];
	reg [DATA-1:0] data_out;
	//============================================================================
	always @(posedge clk) if (we)	ram[write_address] <= data_in;
	always @(posedge clk or negedge reset)
	begin 
		if (!reset) begin	
		      data_out 	      <= 0;
		      valid_out_mem   <= 1'b0;
		end
		else if (re) begin
			  data_out       <= ram[read_address];
			  valid_out_mem  <= 1'b1;
		end	
		else begin
		      valid_out_mem   <= 1'b0;
		end
	end
	//============================================================================
endmodule