/*
======================================================================================
				Standard   : Bluetooth 
				Block name : Serializer
				Modified By: Abdulrahman Galal and Habiba Hassan
				Last Edited: 23/6/2024
======================================================================================
*/
module parallel_in_serial_out_ble #(parameter DATA=32) (
    input 					clk,
    input 					reset, 
    input 	   [DATA-1:0]	data_in, 
    input 					re,
    output reg 				data_out,
    output reg 				done,
    output reg 				valid_out_serial
    );
    //====================================================================================
    reg [5:0] counter;
    //====================================================================================
    always @(posedge clk or negedge reset)
    begin
    //====================================================================================
    if (~reset) begin
        data_out <= 0;
        counter <= 0;
        done <= 1'b0;
        valid_out_serial <= 0;
    end
    //====================================================================================
    else if (re) begin
        //multi-bit data_in is written bit by bit into data_out single bit reg
        data_out <= data_in[counter];
        //valid_out_serial is asserted as long as the data is written in the reg
        valid_out_serial <= 1;

       //when counter is near the last bit DATA-2
        //done signal is asserted to give signal to the memory the write the data
        if(counter == DATA-2) begin
            done <= 1'b1;     
        end
        else begin
            done <= 1'b0;
        end

        //when counter reaches the last bit it begins again from 0 and the done signal is deasserted
        if (counter == DATA-1) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
    //====================================================================================
    else 
        valid_out_serial <= 0;
    end
//====================================================================================
endmodule