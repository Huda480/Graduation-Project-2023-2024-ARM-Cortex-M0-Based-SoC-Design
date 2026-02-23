//===========================================================
// Purpose: Adaptive Thresholding Mechanism
// Used in: Compression_TOP
//===========================================================
module adaptive_thresholding
#(
	parameter int WIDTH = 16, 
	parameter int DEPTH = 8 ,
	parameter int COL_COUNTER_WIDTH = $clog2(DEPTH),
	parameter int INDEX_WIDTH = COL_COUNTER_WIDTH <<1
)
(
	//=======================================================
	// Controls
	//=======================================================
    input wire logic 				clk,
    input wire logic 				rst,
	input wire logic 				valid_in,
	//=======================================================
	// Inputs
	//=======================================================	
    input wire signed [WIDTH-1:0] 	data_in [DEPTH],
	//=======================================================
	// Outputs	
	//=======================================================
    output reg signed [WIDTH-1:0] 	max_values [4],
    output reg [INDEX_WIDTH-1:0] 	index [4],
    output reg signed [WIDTH-1:0] 	dc_value,
    output reg 						valid_out
);
	//=======================================================
	// Constant functions
	//=======================================================

		//===================================================
		// Absolute
		//===================================================
		function logic unsigned [WIDTH-1:0] abs (input logic signed [WIDTH-1:0] x);
			if (x[WIDTH-1])
				return -x;
			else
				return x;
		endfunction

		//===================================================
		// Min Value
		//===================================================
		function logic unsigned [WIDTH:0] calc_min (input logic unsigned [WIDTH-1:0] A, input logic unsigned [WIDTH-1:0] B);
			logic [WIDTH-1:0] min;
			logic index;
			if(A > B)
			begin
				min = B;
				index = 1'b1;
			end
			else
			begin
				min = A;
				index = 1'b0;
			end
			return {index, min};
		endfunction

	//=======================================================
	// Local Parameters
	//=======================================================
    localparam HALF_DEPTH = DEPTH/2;

	//=======================================================
	// Internals
	//=======================================================    
    logic [COL_COUNTER_WIDTH-1:0] col_counter;
    logic [COL_COUNTER_WIDTH+2:0] col_counter_reshaped;
    
    logic [WIDTH-1:0] 			  maximum;
    logic [1:0] 				  minimum;
	logic [15:0]				  min_value;
    
    logic signed [WIDTH-1:0] 	  data_in_cut [HALF_DEPTH];
    
    logic signed [WIDTH-1:0] 	  max_values_comb[4];
    logic signed [WIDTH-1:0] 	  max_values_temp[4];
	logic signed [WIDTH-1:0] 	  max_values_final[4];
    logic [INDEX_WIDTH-1:0] 	  index_comb[4];
	logic [INDEX_WIDTH-1:0] 	  index_temp[4];
    
    logic signed [WIDTH-1:0] 	  dc_value_reg;
    logic 						  done;
	logic [15:0] min1,min2;
	logic index1,index2,index0,flag;

	logic [WIDTH-1:0] largest_removed_value;
	logic [WIDTH-1:0] largest_removed_value_reg;


	//=======================================================	
    assign col_counter_reshaped = col_counter << 3;

	//=======================================================
	// Zeroing and DC extraction
	//=======================================================	
    always_comb
    begin
		//===================================================
		// Defaults
		//===================================================
        maximum = 0;
		data_in_cut = '{default: 0};
		
		//===================================================
		// Valid in
		//===================================================
        if(valid_in)
        begin
			//===============================================
			// zero_upper_right_quadrant
			//===============================================
            if(col_counter < HALF_DEPTH)
            begin
				//===========================================
				// take_dc_value
				//===========================================
                if(~(|col_counter))
                begin
                    data_in_cut[0] = 'b0;	// remove DC
                    data_in_cut[1:(HALF_DEPTH-1)] = data_in[1:(HALF_DEPTH-1)]; // rest
                    maximum = data_in[0];
                end
                else
                    data_in_cut = data_in[0:(HALF_DEPTH-1)];
            end
			//===============================================
			// zero_lower_left_quadrant
			//===============================================
            else
                data_in_cut = data_in[HALF_DEPTH:DEPTH-1];
			//===============================================				
        end
		//===================================================
    end
	//=======================================================
	// Min value extraction
	//=======================================================
    always_comb
    begin
		//===================================================
		// Defaults
		//===================================================	
        max_values_comb = max_values_temp;
        index_comb = index_temp;
		minimum = 2'b0;
		flag = 1'b0;
		min1 = 'b0;
		min2 = 'b0;
		min_value = 'b0;
		index0 = 1'b0;
		index1 = 1'b0;
		index2 = 1'b0;
		largest_removed_value = largest_removed_value_reg;
		//===================================================
		// Valid in
		//===================================================
        if(valid_in)
        begin
			//===============================================
			// looping_input
			//===============================================
            foreach(data_in_cut[i])
            begin
				{index0, min1} = calc_min(abs(max_values_comb[0]),abs(max_values_comb[1]));
				{index1, min2} = calc_min(abs(max_values_comb[2]),abs(max_values_comb[3]));
				{index2, min_value} = calc_min(min1, min2);
				flag = index2 ? index1 : index0;
				minimum = {index2,flag};
				//===========================================
				// change_max_value
				//===========================================				
                if(abs(data_in_cut[i]) > min_value)
                begin
                    max_values_comb[minimum] = data_in_cut[i];
					
					if (min_value > largest_removed_value)
						largest_removed_value = min_value;

					if(col_counter < HALF_DEPTH)
						index_comb[minimum] = col_counter_reshaped + i;
					else if (col_counter >= HALF_DEPTH)
						index_comb[minimum] = col_counter_reshaped + (i + HALF_DEPTH);
                end
				else if (abs(data_in_cut[i]) > largest_removed_value)
					largest_removed_value = abs(data_in_cut[i]);
				//===========================================
            end
			//===============================================
        end
		//===================================================
    end

	//=======================================================
	// Generate
	//=======================================================
	generate
		//===================================================
		// For generate
		//===================================================
		genvar m;
		for (m = 0; m < HALF_DEPTH; m++)
		begin
			//===============================================
			// max_values
			//===============================================
			always_ff @(posedge clk or negedge rst)
			begin
				if (!rst) 
				begin
					max_values[m] <= 'b0;
					index[m]	  <= 'b0;
				end
				else if (done) 
				begin
					max_values[m] <= max_values_final[m];
					index[m]	  <= index_comb[m];
				end
			end
			//===============================================
			// max_values_temp and index
			//===============================================
			always_ff @(posedge clk or negedge rst)
			begin
				if (!rst)
				begin
					max_values_temp[m] 	<= 'b0;
					index_temp[m]		<= 'b0;
				end
				else
				begin
					if (done) 
					begin
						max_values_temp[m] <= 'b0;
					end
					else
					begin
						max_values_temp[m] <= max_values_comb[m];
						index_temp[m] 	   <= index_comb[m];
					end
				end
			end
			//===============================================
			// max_values_final
			//===============================================
			always_comb 
			begin
				max_values_final[m] = max_values_comb[m];
				if ((abs(max_values_final[m]) == largest_removed_value) && done)
					max_values_final[m] = 0;
			end
			//===============================================
		end
		//===================================================
	endgenerate
	//=======================================================
	// valid_out
	//=======================================================	
    always_ff @(posedge clk or negedge rst)
    begin
        if (!rst)
            valid_out <= 'b0;
        else
        begin
            if(done)
                valid_out <= 'b1;
            else 
                valid_out <= 'b0;
        end
    end
	//=======================================================
	// done
	//=======================================================	
    always_ff @(posedge clk or negedge rst)
    begin
        if (!rst)
            done <= 1'b0;
        else
        begin
            if(valid_in)
            begin
                done <= 1'b0;
                if(col_counter == (DEPTH-2))
                    done <= 1'b1;
            	else
                	done <= 1'b0;
        	end
		end
    end
	//=======================================================
	// col_counter
	//=======================================================	
    always_ff @(posedge clk or negedge rst)
    begin
        if (!rst)
            col_counter <= 0;
        else
        begin
            if(valid_in)
            begin
                col_counter <= col_counter + 1;
                if(col_counter == (DEPTH-1))
                    col_counter <= 0;
            end
        end
    end	
	//=======================================================
	// dc_value
	//=======================================================
    always_ff @(posedge clk or negedge rst)
    begin
        if (!rst)
            dc_value	<= 'b0;
        else if (done)
			dc_value 	<= dc_value_reg;
    end
	//=======================================================
	// dc_value_reg
	//=======================================================	
    always_ff @(posedge clk or negedge rst)
    begin
        if (!rst)
            dc_value_reg <= 'b0;
        else if((~(|col_counter)) && valid_in)
            dc_value_reg <= maximum;
    end
	//=======================================================
	// largest_removed_value_reg
	//=======================================================
	always_ff @ (posedge clk or negedge rst)
	begin
		if (!rst)
			largest_removed_value_reg <= 'b0;
		else
		begin
			if (done)
				largest_removed_value_reg <= 'b0;
			else
				largest_removed_value_reg <= largest_removed_value;
		end
	end	
	//=======================================================	
endmodule