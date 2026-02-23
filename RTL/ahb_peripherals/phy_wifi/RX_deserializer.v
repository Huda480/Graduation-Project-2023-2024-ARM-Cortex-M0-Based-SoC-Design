`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2024 12:56:21 PM
// Design Name: 
// Module Name: RX_deserializer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module RX_deserializer #(parameter DATA_WIDTH =32) (
    clk,
	reset,
	we,
	data_in,
	data_out,
	clear_Rx_irq,
	en_Rx_irq,
	rx_irq,
	clear_rx,
	valid_out
);

//============================================================================
	input                   clk;
	input                   reset;
	input                   we;
	input                   data_in;
	input                   clear_Rx_irq;
	input                   en_Rx_irq;
	output                   rx_irq;
	output [DATA_WIDTH - 1:0]   data_out;
	output                  valid_out;
	output                 clear_rx;
//============================================================================
wire clk;
wire reset;
wire we;
wire data_in;
wire [DATA_WIDTH-1:0] data_out;
wire valid_out;


	
//============================================================================

reg_32 #( DATA_WIDTH) reg_32 (
    .clk(clk),
    .reset(reset), 
    .valid_in(we),
    .data_in(data_in), 
    .data_out(data_out),
    .rx_irq(rx_irq),
    .en_Rx_irq(en_Rx_irq), 
	.clear_Rx_irq(clear_Rx_irq),
	.clear_rx(clear_rx),
    .valid_out(valid_out)
);
	

//============================================================================
  
endmodule



//============================================================================
module reg_32 #(parameter  DATA=32) (
input 					clk,
input 					reset, 
input                   valid_in,
input 	            	data_in,
input                    clear_Rx_irq,
input                    en_Rx_irq,
output reg [DATA-1:0]   data_out,
output reg                 rx_irq,
(* dont_touch = "true" *) output reg                  clear_rx,
output reg 				valid_out
);

reg [4:0] counter;
reg last_output;
always @(posedge clk or negedge reset)
begin
//============================================================================
if (~reset) begin
	data_out <= 0;
	counter <= 0;
	valid_out <= 1'b0;
	last_output <= 0;
	rx_irq <= 1'b0;
    clear_rx <= 1'b0;
end
//============================================================================
else begin
    //============================================================================
    if(valid_in)begin
        data_out[counter] <= data_in;
        last_output <= 1;
         clear_rx <= 1'b0;
	    if(counter == 5'd31) begin
		    counter <= 0;
	    	valid_out <= 1'b1;
	    end
	    else begin
		    counter <= counter + 1'b1;
		    valid_out <= 1'b0;
	    end
    end
    //============================================================================
    else begin
        if ( last_output == 1 )
        begin
         clear_rx <= 1'b0;
	    	counter <= counter + 1'b1;
        if (counter == 'd24) begin
            valid_out <= 1'b1;
            last_output <= 0;
            data_out <= data_out[23:0];
            counter <= counter + 1'b1; 
        end
	    end
	    else
	    begin
	   // rx_irq <= 1'b0; 
	    if (counter == 'd25 && en_Rx_irq) begin 
	       rx_irq <= 1'b1;
	       end
	    else if (clear_Rx_irq) begin
	        rx_irq <= 1'b0;
	        clear_rx <= 1'b1; 
	    end 
	    else begin
	         rx_irq <= 1'b0;
	        clear_rx <= 1'b0; 
	    end
	       last_output <= 0;
	       valid_out <= 1'b0;
	       data_out <= 0;
	       counter <= 0;
	       
	    end
    end

end
end
endmodule