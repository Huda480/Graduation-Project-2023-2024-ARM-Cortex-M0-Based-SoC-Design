/*
======================================================================================
				Standard   : WIFI
				Block name : RAM for pilots
======================================================================================
*/
//====================================================================================
module rom_pilotsGenerator_wifi
(
	address,
	read_enable,
	data_out
);
	//============================================================================
	input [6:0] address;
	input read_enable; 
	output data_out;
	//============================================================================
	wire [0:0] mem [0:126] ;  
	//============================================================================
	//00001110
	assign mem[0] = 0;
	assign mem[1] = 0;
	assign mem[2] = 0;
	assign mem[3] = 0;
	assign mem[4] = 1;
	assign mem[5] = 1;
	assign mem[6] = 1;
	assign mem[7] = 0;
	//11110010
	assign mem[8] = 1;
	assign mem[9] = 1;
	assign mem[10] = 1;
	assign mem[11] = 1;
	assign mem[12] = 0;
	assign mem[13] = 0;
	assign mem[14] = 1;
	assign mem[15] = 0;
	//11001001 
	assign mem[16] = 1;
	assign mem[17] = 1;
	assign mem[18] = 0;
	assign mem[19] = 0;
	assign mem[20] = 1;
	assign mem[21] = 0;
	assign mem[22] = 0;
	assign mem[23] = 1;
	//00000010
	assign mem[24] = 0;
	assign mem[25] = 0;
	assign mem[26] = 0;
	assign mem[27] = 0;
	assign mem[28] = 0;
	assign mem[29] = 0;
	assign mem[30] = 1;
	assign mem[31] = 0;
	//00100110 
	assign mem[32] = 0;
	assign mem[33] = 0;
	assign mem[34] = 1;
	assign mem[35] = 0;
	assign mem[36] = 0;
	assign mem[37] = 1;
	assign mem[38] = 1;
	assign mem[39] = 0;
	//00101110
	assign mem[40] = 0;
	assign mem[41] = 0;
	assign mem[42] = 1;
	assign mem[43] = 0;
	assign mem[44] = 1;
	assign mem[45] = 1;
	assign mem[46] = 1;
	assign mem[47] = 0;
	//10110110 
	assign mem[48] = 1;
	assign mem[49] = 0;
	assign mem[50] = 1;
	assign mem[51] = 1;
	assign mem[52] = 0;
	assign mem[53] = 1;
	assign mem[54] = 1;
	assign mem[55] = 0;
	//00001100 
	assign mem[56] = 0;
	assign mem[57] = 0;
	assign mem[58] = 0;
	assign mem[59] = 0;
	assign mem[60] = 1;
	assign mem[61] = 1;
	assign mem[62] = 0;
	assign mem[63] = 0;
	//11010100 
	assign mem[64] = 1;
	assign mem[65] = 1;
	assign mem[66] = 0;
	assign mem[67] = 1;
	assign mem[68] = 0;
	assign mem[69] = 1;
	assign mem[70] = 0;
	assign mem[71] = 0;
	//11100111
	assign mem[72] = 1;
	assign mem[73] = 1;
	assign mem[74] = 1;
	assign mem[75] = 0;
	assign mem[76] = 0;
	assign mem[77] = 1;
	assign mem[78] = 1;
	assign mem[79] = 1;
	//10110100
	assign mem[80] = 1;
	assign mem[81] = 0;
	assign mem[82] = 1;
	assign mem[83] = 1;
	assign mem[84] = 0;
	assign mem[85] = 1;
	assign mem[86] = 0;
	assign mem[87] = 0;
	//00101010 
	assign mem[88] = 0;
	assign mem[89] = 0;
	assign mem[90] = 1;
	assign mem[91] = 0;
	assign mem[92] = 1;
	assign mem[93] = 0;
	assign mem[94] = 1;
	assign mem[95] = 0;
	//11111010
	assign mem[96] = 1;
	assign mem[97] = 1;
	assign mem[98] = 1;
	assign mem[99] = 1;
	assign mem[100] = 1;
	assign mem[101] = 0;
	assign mem[102] = 1;
	assign mem[103] = 0;
	//01010001 
	assign mem[104] = 0;
	assign mem[105] = 1;
	assign mem[106] = 0;
	assign mem[107] = 1;
	assign mem[108] = 0;
	assign mem[109] = 0;
	assign mem[110] = 0;
	assign mem[111] = 1;
	//10111000 
	assign mem[112] = 1;
	assign mem[113] = 0;
	assign mem[114] = 1;
	assign mem[115] = 1;
	assign mem[116] = 1;
	assign mem[117] = 0;
	assign mem[118] = 0;
	assign mem[119] = 0;
	//1111 111
	assign mem[120] = 1;
	assign mem[121] = 1;
	assign mem[122] = 1;
	assign mem[123] = 1;
	assign mem[124] = 1;
	assign mem[125] = 1;
	assign mem[126] = 1;
	//============================================================================
	assign data_out = (read_enable) ? mem[address] : 5'b0;
	//============================================================================
endmodule
