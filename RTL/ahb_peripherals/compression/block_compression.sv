//===========================================================
// Purpose: Compression 
// Used in: Compression_TOP
//===========================================================
import compression_package::* ;
module block_compression 
#(
	parameter int WIDTH 			= 16, 
	parameter int DEPTH 			= 12 ,
	parameter int COL_COUNTER_WIDTH = 8,
	parameter int ROW_COUNTER_WIDTH = $clog2(COL_COUNTER_WIDTH),
	parameter int INDEX_WIDTH 		= ROW_COUNTER_WIDTH <<1
)
(
	//=======================================================
	// Controls
	//=======================================================
	input wire logic clk,
	input wire logic rst,
	input wire logic valid_in,
	//=======================================================
	// Inputs
	//=======================================================
	input wire logic signed [WIDTH-1:0] data_in [4],
	input wire logic [INDEX_WIDTH-1:0]  index_in [4],
	//=======================================================
	// Outputs
	//=======================================================
	output logic [DEPTH-1:0] 		data_out,
	output logic					counter_reduction,
	output reg 						valid_out
	//=======================================================	
);	  
	//=======================================================
	// Constant function
	//=======================================================
	function logic signed [WIDTH-1:0] data_value (input logic signed [WIDTH-1:0] a , input logic signed [1:0] b);
		if(b[1] & b[0])
			return -a;
		else if (b[1])
		 	return ({(-a[WIDTH-2:0]),1'b0});
		else if(b[0])
			return a;
		else
			return 'b0;
	endfunction
	//=======================================================
	// Internals
	//=======================================================
	logic signed [WIDTH+1:0]  mult_output[DEPTH];
	logic signed [WIDTH:0]  mult_temp1 [DEPTH];
	logic signed [WIDTH:0] mult_temp2 [DEPTH];
	logic [2:0] counter;
	logic [6:0] next_count_index;
	//=======================================================
	// Data out registering
	//=======================================================
	generate
		genvar l;
		for (l = 0; l < DEPTH; l++)
		begin
			always_ff @(posedge clk or negedge rst)
			begin
				if(!rst)
				begin
					data_out[l] <= 'b0;
				end
				else
					data_out[l] <= mult_output[l][WIDTH+1];
			end
		end
	endgenerate	
	//=======================================================
	// Counter operations
	//=======================================================
	assign next_count_index = (counter << 3) + (counter << 2);
	assign counter_reduction = |counter;
	//=======================================================
	// Valid out registering
	//=======================================================
	always_ff @(posedge clk or negedge rst)
	begin
		if(!rst)
			valid_out <= 1'b0;
		else
		begin
			if(valid_in)
				valid_out <= 1'b1;
			else if(!counter_reduction)
				valid_out <= 1'b0;
		end
	end
	//=======================================================
	// Counter registering
	//=======================================================
	always_ff @(posedge clk or negedge rst)
	begin
		if(!rst)
			counter <= 'b0;
		else if(valid_in || counter_reduction) 
		begin
			counter <= counter + 1'b1;
		end
	end
	//=======================================================
	// Matrix multiplication
	//=======================================================
	always_comb
	begin
		for (bit [3:0] k = 0; k < DEPTH; k++)
		begin
			mult_temp1[k] =   data_value(data_in[0] , Phi_var[k + next_count_index][index_in[0]])
							+ data_value(data_in[1] , Phi_var[k + next_count_index][index_in[1]]);

			mult_temp2[k] =    data_value(data_in[2] , Phi_var[k + next_count_index][index_in[2]])
							 + data_value(data_in[3] , Phi_var[k + next_count_index][index_in[3]]);
			
			mult_output[k] = mult_temp1[k] + mult_temp2[k];
		end
	end
	//=======================================================
endmodule
