/*
======================================================================================
				Standard   : WIFI
				Block name : Generic serializer
======================================================================================
*/
//====================================================================================
module WIFI_TX_scrambler_serializer #(parameter DATA_WIDTH = 32)
(
	clk,
	reset,
	enable,
	valid_in,
	data_in,
	data_size,
	data_out,
	valid_out,
	done_PISO,
    start_rd_pulse,
	done
);
//============================================================================
input clk, reset;
input enable, valid_in;
input [DATA_WIDTH - 1 : 0] data_in, data_size;
output data_out, valid_out;
output done_PISO, start_rd_pulse; 
output reg done;
//============================================================================
reg [DATA_WIDTH - 1 : 0] counter;
reg re_32, re_24;
reg enable_32, enable_24;
reg start_rd;
reg start_rd_reg;
reg valid_in_happened;
wire start_rd_pulse;
//============================================================================
(* keep_hierarchy = "yes" *) 
parallel_in_serial_out #(DATA_WIDTH) piso 
(
    .clk(clk),
    .reset(reset), 
    .data_in(data_in), 
    .data_out(data_out),
    .done(done_PISO),
    .re_32(re_32  && enable),
	.re_24(re_24  && enable),
    .valid_out(valid_out)
);  
assign start_rd_pulse = start_rd & (~start_rd_reg);

always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        re_32               <= 1'b0;
		re_24				<= 1'b0;
        counter        		<= 32'd0;
        valid_in_happened   <= 1'b0;
        start_rd            <= 1'b0;
    end
    else
    begin
        if(valid_in==1'b1 && valid_in_happened==1'b0)
        begin
            valid_in_happened   <= 1'b1;
			    start_rd           	<= 1'b1;          
        end
        else
        begin
            if(valid_in_happened==1'b1)
            begin
                if(counter < data_size)
                begin
					if ((data_size - counter) > 24)
					begin
					    re_32          	<= 1'b1;
						re_24			<= 1'b0;
                    	counter 	<= counter+32'd1;	
					end
					else
					begin
                    re_32          	<= 1'b0;
					re_24			<= 1'b1;
                    counter <= counter+32'd1;
					end 
                end
                else
                begin   
        			re_32               <= 1'b0;
					re_24				<= 1'b0;
        			counter        		<= 32'd0;
        			valid_in_happened   <= 1'b0;
        			start_rd            <= 1'b0;                      
                end
            end
        end
    end
end
	//============================================================================
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			enable_32	<= 0;
			enable_24	<= 0;
			done		<= 0;
		end
		else
		begin
			if(re_32  && enable)
			begin
				done		<= 1;
				enable_32	<= 1;
				enable_24	<= 0;
			end
			else if(re_24  && enable)
			begin
				done		<= 1;
				enable_32	<= 0;
				enable_24	<= 1;
			end
			else
			begin
				done		<= 0;
				enable_32	<= 0;
				enable_24	<= 0;
			end
		end
	end
	//============================================================================

	always @(posedge clk or negedge reset)
	begin
		if(~reset)
		begin
			start_rd_reg <= 0;
		end
		else
		begin
			start_rd_reg <= start_rd;
		end
	end
endmodule
//====================================================================================
