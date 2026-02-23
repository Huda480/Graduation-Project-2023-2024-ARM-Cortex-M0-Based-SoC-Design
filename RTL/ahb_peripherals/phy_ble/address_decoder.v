/*
======================================================================================
				Standard   :    Bluetooth 
				Block name :    Address Decoder
				Created By :    Habiba Hassan
				Last Modified:  7/7/2024
======================================================================================
*/
module address_decoder_ble #(parameter AD = 12, OFFSET = 'h10)(
	address,
	wenable,
	renable,
	memory_address,
	reg_address,
	read_en_mem,
	write_en_mem,
	read_en_reg,
	write_en_reg
	);

input [AD-1:0] address;
input wenable, renable;
//memory_address has size of the input address minus the 2 decoding bits
output reg [AD-3:0] memory_address; 
output reg [1:0] reg_address;
output reg read_en_mem, write_en_mem;
output reg read_en_reg, write_en_reg;

always @(*) begin
	if ( (address >= 0) && (address < 'h10) ) begin
	    //the two decoding bits are bit(3) and (2), 
	    //                             bit no
	    //                           "3 2 1 0"
	    /// first location     (0) -> 0 0 0 0 -> 00|00
	    /// second location    (1) -> 0 1 0 0 -> 01|00
	    /// third location     (2) -> 1 0 0 0 -> 10|00
	    /// fourth location    (3) -> 1 1 0 0 -> 11|00
		reg_address = address[3:2];
		memory_address = 0;
		//Is renable (from AHB) enabling reading from the reg file or from the memory?
		if (renable) begin
			read_en_reg = 1'b1;
			write_en_reg =1'b0;
			read_en_mem = 1'b0;
			write_en_mem = 1'b0;
		end
		//Is wenable (from AHB) enabling writing in the reg file or in the memory?
		else if (wenable) begin
			write_en_reg =1'b1;
			read_en_reg = 1'b0;
			read_en_mem = 1'b0;
			write_en_mem = 1'b0;
		end
		else begin
			write_en_reg =1'b0;
			read_en_reg = 1'b0;
			read_en_mem = 1'b0;
			write_en_mem = 1'b0;	
		end
	end
	else begin
		memory_address = address[AD-2:0] - OFFSET;
		reg_address = 0;
		//Is wenable (from AHB) enabling reading from the mem or reg file?
		if (renable) begin
			read_en_mem = 1'b1;
			write_en_mem = 1'b0;
			read_en_reg = 1'b0;
			write_en_reg =1'b0;
		end
		//Is wenable (from AHB) enabling writing in the mem or reg file?
		else if (wenable) begin
			write_en_mem = 1'b1;
			read_en_mem = 1'b0;
			write_en_reg =1'b0;
			read_en_reg = 1'b0;
		end
		else begin
			write_en_reg =1'b0;
			read_en_reg = 1'b0;
			read_en_mem = 1'b0;
			write_en_mem = 1'b0;	
		end

	end

end
endmodule