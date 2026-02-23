module input_segmentation_ble #(parameter DATA=32)
(
    clk,
    reset,
    valid_in,
    enable_chain,
    data_in,
    header_size,
    payload_size,
    valid_in_header,
    valid_in_payload,
    data_out,
    done_piso,
    start_rd_pulse,
    enable
);
//----------------------------------------------------------------------
input clk;
input reset;
input valid_in;
input enable_chain;
input [DATA-1:0] data_in;
input [15:0] header_size;
input [15:0] payload_size;

output valid_in_header;
output valid_in_payload;
output data_out;
output done_piso;
output start_rd_pulse;
output enable;
//----------------------------------------------------------------------
wire valid_out_serial;
// Wait counter to seperate headers for payload. The Guard time should be within the interval [4.75, 5.25]us. 
////wait counter can adjusted according to clk 
reg [7:0] wait_counter;
reg [16:0] output_counter;
reg re; 
reg header;
reg valid_in_happened;
//----------------------------------------------------------------------
reg enable;
reg start_rd;
reg start_rd_reg;
wire start_rd_pulse;
//----------------------------------------------------------------------
 (* keep_hierarchy = "yes" *) 

parallel_in_serial_out_ble #(DATA) piso 
        (
            .clk(clk),
            .reset(reset), 
            .data_in(data_in), 
            .data_out(data_out),
            .done(done_piso),
            .re(enable),
			.valid_out_serial(valid_out_serial)
        );    
//----------------------------------------------------------------------
assign valid_in_header =(header==1'b1)? valid_out_serial:1'b0;
assign valid_in_payload=(header==1'b0)? valid_out_serial:1'b0;
//----------------------------------------------------------------------
//start_rd_pulse is a pulse indicates that the reading from the RAM to the serializer has started
////we need this signal to read the 1st located data in the RAM
////start_rd AND ~start_rd_reg are used to generate the pulse
assign start_rd_pulse = start_rd & (~start_rd_reg);
//----------------------------------------------------------------------

always @(posedge clk or negedge reset)
begin
    if(reset==1'b0)
    begin
        re                  <= 1'b0;
        header              <= 1'b0;
        wait_counter        <= 8'd17;
        output_counter      <= 17'd0;
        valid_in_happened   <= 1'b0;
        start_rd            <= 1'b0;
        start_rd_reg        <= 1'b0;
    end
    else
    begin
        if(valid_in==1'b1 && valid_in_happened==1'b0)
        begin
            valid_in_happened   <= 1'b1;            
        end
        else
        begin
            if(valid_in_happened==1'b1 && enable_chain)
        //checks if there's data written in the memory & the master enabled the chain
            begin
                start_rd           <= 1'b1;
                start_rd_reg       <= start_rd;
                if(output_counter < header_size)
                begin
                    re             <= 1'b1;
                    header         <= 1'b1;
                    output_counter <= output_counter+17'd1;
                end
                else
                begin
                    if(wait_counter > 8'd0)
                    begin
                        re              <= 1'b0;
                        output_counter  <= output_counter;
                        wait_counter    <= wait_counter -8'd1;
                    end
                    else
                    begin
                        re              <= 1'b1;
                        header          <= 1'b0;
                        output_counter  <= output_counter + 17'd1;
                        if(output_counter == header_size+payload_size)
                        begin
                            re                  <= 1'b0;
                            header              <= 1'b0;
                            wait_counter        <= 8'd17;
                            output_counter      <= 17'd0;
                            valid_in_happened   <= 1'b0;
                            start_rd            <= 1'b0;                       
                            start_rd_reg        <= 1'b0;                       
                        end
                    end
                end
            end
        end
    end
end
//============================================================================
	//re indicates the reading mode
	//// will kept high till the whole header and payload are read from the memory
	//// (check the input segmentation block)
	//enable signal will be high as long the re is high (registering re)
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
			enable	<= 0;
		else
		begin
			if(re==1)
				enable	<= 1;
			else
				enable	<= 0;
		end
	end
	//============================================================================
endmodule
