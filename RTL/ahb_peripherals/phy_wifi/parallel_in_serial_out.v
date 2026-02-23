module parallel_in_serial_out #(parameter DATA_WIDTH=32) (
    input 					clk,
    input 					reset, 
    input 	   [DATA_WIDTH-1:0]	data_in, 
    input 					re_32,
    input 					re_24,
    output reg 				data_out,
    output reg 				done,
    output reg 				valid_out
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
        valid_out <= 0;
    end
    else if (re_32) begin
        //multi-bit data_in is written bit by bit into data_out single bit reg
        data_out <= data_in[counter];
        //valid_out_serial is asserted as long as the data is written in the reg
        valid_out <= 1;
        //when counter reaches the last bit it begins again from 0 and the done signal is deasserted
        if(counter == DATA_WIDTH-1) begin
            counter <= 0;
            done <= 1'b0;     
        end
        //when counter is near the last bit
        //done signal is asserted to give signal to the memory the write the data
        else if (counter == DATA_WIDTH-2) begin
            done <= 1'b1;        
            counter <= counter + 1;
    
        end
        else begin
            counter <= counter + 1;
            done <= 1'b0;
        end
    end
    else if (re_24) begin
        data_out <= data_in[counter];
        valid_out <= 1;
        if(counter == 6'd22) begin
            done <= 1'b1;
        end
        else begin
            done <= 1'b0;
        end
        
        if(counter == 6'd23) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
    else 
        valid_out <= 0;
    //====================================================================================
    end
//====================================================================================
endmodule