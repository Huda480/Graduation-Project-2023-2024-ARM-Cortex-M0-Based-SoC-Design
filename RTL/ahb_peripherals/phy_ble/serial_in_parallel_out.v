/*
======================================================================================
				Standard   : Bluetooth 
				Block name : De-Serializer
				Modified By: Abdulrahman Galal and Habiba Hassan
				Last Edited: 7/7/2024
======================================================================================
*/
module serial_in_parallel_out_ble #(parameter DATA=32) (
    input 					clk,
    input 					reset, 
    input 	             	data_in, 
    input 					we,
    output reg [DATA-1:0]	data_out,
    output reg              done
    );
	//============================================================================
    reg [$clog2(DATA)-1:0] counter;
	//============================================================================
    always @(posedge clk or negedge reset)
    begin
    if (~reset) begin
        data_out <= 0;
        counter <= 0;
        done <= 1'b0;
    end
    else if (we) begin
        //as long there is valid_in from the chain keep writing in the reg
        ////data_in is a single bit written in different reg each cycle 
        data_out[counter] <= data_in;

        //when reaches the final bit, reset counter and assert the done signal
        if(counter == DATA-1) begin
            counter <= 0;
            done <= 1'b1;        
        end

        else begin
            counter <= counter + 1;
            done <= 1'b0;
        end
        
    end
    end
	//============================================================================
endmodule
