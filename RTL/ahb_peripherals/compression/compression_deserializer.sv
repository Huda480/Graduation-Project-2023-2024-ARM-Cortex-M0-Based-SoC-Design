//===========================================================
// Purpose: Aligns Data for Compression_Memory
// Used in: Compression_TOP
//===========================================================
module compression_deserializer 
#(
    parameter int WIDTH = 16,
    parameter int AHB_WIDTH = 32
) 
(
    //=======================================================
	// Controls
	//=======================================================
    input wire logic clk,
    input wire logic rst,
    input wire logic valid_in_thresholding,
    input wire logic valid_in_compression,
    //=======================================================
	// Inputs
	//=======================================================
    input wire logic [11:0] data_in,
    input wire logic signed [WIDTH-1:0] dc_value_in,
    input wire logic counter_zero,
    //=======================================================
	// Outputs
	//=======================================================
    output logic [AHB_WIDTH-1:0] data_out,
    output logic valid_out
);

    //=======================================================
	// Internals
	//=======================================================
    logic alignment;
    logic [2:0] valid_counter;
    logic valid_counter_reg;
    logic [7:0] mem;
    logic take_data;
    logic [3:0]shifted_counter;

    //=======================================================
	// Data out aligning & Valid Out
	//=======================================================
    always_ff @ (posedge clk or negedge rst)
    begin
        if (!rst)
        begin
            data_out <= 'b0;
            valid_out <= 1'b0; 
        end
        else
        begin   
            if (valid_in_thresholding)
            begin
                if (~alignment)
                begin
                    data_out <= dc_value_in;
                    valid_out <= 1'b0; 
                end
                else
                begin
                    data_out <= (data_out << 16) | dc_value_in;
                    valid_out <= 1'b1; 
                end
            end

            else if (valid_in_compression)
            begin
                if(valid_counter == 3'd6)
                begin
                    data_out <= (data_out << 8) | data_in[11:4];
                    valid_out <= 1'b1; 
                end
                else if(valid_counter == 3'd7)
                begin
                    data_out <= (data_out << 4) | data_in[11:8]; 
                    valid_out <= 1'b1; 
                end
                else
                begin
                    if(take_data)
                    begin
                        valid_out <= 1'b0; 
                        if(valid_counter == 3'd1)
                        begin
                            data_out <= {mem[3 : 0],data_in};
                        end
                        else if(valid_counter == 3'd2)
                        begin
                            data_out <= {mem[7 : 0],data_in};
                        end
                        
                    end
                    else
                    begin
                        data_out <= (data_out << 12) | data_in;
                        if(valid_counter == 3'd5)
                        begin
                            valid_out <= 1'b1;
                        end
                        else 
                        begin
                            valid_out <= 1'b0;
                        end 
                    end 
                end
            end
        end
    end

    //=======================================================
    // Memory Registering
    //=======================================================
    always_ff @ (posedge clk or negedge rst)
    begin
        if (!rst)
        begin
            mem <= 'b0;
            take_data <= 1'b0;
        end
        else if (valid_in_compression)
        begin
            if(valid_counter == 3'd6)
            begin
                mem[3:0] <= data_in[3:0];
                take_data <= 1'b1;
            end
            else if(valid_counter == 3'd7)
            begin
                mem <= data_in[7:0];
                take_data <= 1'b1;
            end
            else
            begin    
                take_data <= 1'b0;
            end
        end
    end
                    
    //=======================================================
	// Alignment to handle both dc_value cases
	//=======================================================
    always_ff @(posedge clk or negedge rst)
    begin
        if (!rst)
            alignment <= 1'b0;
        else if (valid_in_compression && ~counter_zero)
            alignment <= ~alignment; 
    end

    //=======================================================
	// Counter Registering
	//=======================================================
    always_ff @ (posedge clk or negedge rst)
    begin
        if (!rst)
            valid_counter <= 'b0;
        else
        begin
            if (valid_in_thresholding)
                valid_counter <= valid_counter + 3'd4;
            else if (valid_in_compression)
                valid_counter <= valid_counter + 3'd3;
        end
    end

endmodule