////////////////////////////////////////////////////////////////////////////////
// Author: Marwan Ahmed
// Title: MR AMD
////////////////////////////////////////////////////////////////////////////////
module FIFO_dma
#(
	parameter int FIFO_WIDTH = 16,
	parameter int FIFO_DEPTH = 8,
	parameter int FALL_THROUGH = 0
)
(	
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
	input clk, rst_n,
	//==========================================================================
    // Control signals
    //==========================================================================
	input [FIFO_WIDTH-1:0] data_in, 
	input wire logic wr_en, rd_en,
	input wire logic response,

	output reg [FIFO_WIDTH-1:0] data_out
);
 
localparam int max_fifo_addr = $clog2(FIFO_DEPTH);


logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;

initial 
begin
	foreach(mem[i])
	begin
		mem [i] = 'b0;
	end
end

always_ff @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
		wr_ptr <= 0;
	end
	else if (response)
	begin
		wr_ptr <= 0;
	end
	else if (wr_en) 
	begin
		wr_ptr <= wr_ptr + 1;
	end
end


always @(posedge clk)
begin
	if (wr_en) begin
		mem[wr_ptr] <= data_in;
	end
end

always_ff @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
		rd_ptr <= 0;
	end
	else if (response)
		begin
			rd_ptr <= 0;
		end
	else if (rd_en) 
	begin
		rd_ptr <= rd_ptr + 1;
	end
end


generate if (FALL_THROUGH ==1) 
begin
	always_comb
	begin
		data_out = mem[rd_ptr];
	end

end
else
begin
	always_ff @(posedge clk or negedge rst_n) 
	begin
		if(!rst_n)
			data_out<=0;
		else if (rd_en) 
		begin
			data_out <= mem[rd_ptr];
	    end
	end 
end
	
endgenerate



endmodule

