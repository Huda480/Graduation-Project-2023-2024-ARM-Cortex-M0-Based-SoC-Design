/*
=========================================================================================
				Standard :	WIFI
				Block name :	Short preamble
=========================================================================================
*/
//=======================================================================================
module WIFI_TX_short_preabmle 
(
	valid_in,
	clk,
	valid_out,
	pre_re,
	pre_im,
	done,
	reset,
	enable_ifft
);
	//===============================================================================	
	input valid_in;
	input clk;
	input reset;
	output reg [11:0] pre_re;
	output reg [11:0] pre_im;
	output reg valid_out;
	output reg done;
	output reg enable_ifft;
	//===============================================================================	
	wire [11:0] data_re [0:160];
	wire [11:0] data_im [0:160];
	//===============================================================================	
	assign data_re [0] = 12'b000000001100;
	assign data_im [0] = 12'b000000001100;

	assign data_re [1] = 12'b111110111100;
	assign data_im [1] = 12'b000000000001;

	assign data_re [2] = 12'b111111111001;
	assign data_im [2] = 12'b111111011000;

	assign data_re [3] = 12'b000001001001;
	assign data_im [3] = 12'b111111111001;

	assign data_re [4] = 12'b000000101111;
	assign data_im [4] = 12'b000000000000;

	assign data_re [5] = 12'b000001001001;
	assign data_im [5] = 12'b111111111001;

	assign data_re [6] = 12'b111111111001;
	assign data_im [6] = 12'b111111011000;

	assign data_re [7] = 12'b111110111100;
	assign data_im [7] = 12'b000000000001;

	assign data_re [8] = 12'b000000011000;
	assign data_im [8] = 12'b000000011000;

	assign data_re [9] = 12'b000000000001;
	assign data_im [9] = 12'b111110111100;

	assign data_re [10] = 12'b111111011000;
	assign data_im [10] = 12'b111111111001;

	assign data_re [11] = 12'b111111111001;
	assign data_im [11] = 12'b000001001001;

	assign data_re [12] = 12'b000000000000;
	assign data_im [12] = 12'b000000101111;

	assign data_re [13] = 12'b111111111001;
	assign data_im [13] = 12'b000001001001;

	assign data_re [14] = 12'b111111011000;
	assign data_im [14] = 12'b111111111001;

	assign data_re [15] = 12'b000000000001;
	assign data_im [15] = 12'b111110111100;

	assign data_re [16] = 12'b000000011000;
	assign data_im [16] = 12'b000000011000;

	assign data_re [17] = 12'b111110111100;
	assign data_im [17] = 12'b000000000001;

	assign data_re [18] = 12'b111111111001;
	assign data_im [18] = 12'b111111011000;

	assign data_re [19] = 12'b000001001001;
	assign data_im [19] = 12'b111111111001;

	assign data_re [20] = 12'b000000101111;
	assign data_im [20] = 12'b000000000000;

	assign data_re [21] = 12'b000001001001;
	assign data_im [21] = 12'b111111111001;

	assign data_re [22] = 12'b111111111001;
	assign data_im [22] = 12'b111111011000;

	assign data_re [23] = 12'b111110111100;
	assign data_im [23] = 12'b000000000001;

	assign data_re [24] = 12'b000000011000;
	assign data_im [24] = 12'b000000011000;

	assign data_re [25] = 12'b000000000001;
	assign data_im [25] = 12'b111110111100;

	assign data_re [26] = 12'b111111011000;
	assign data_im [26] = 12'b111111111001;

	assign data_re [27] = 12'b111111111001;
	assign data_im [27] = 12'b000001001001;

	assign data_re [28] = 12'b000000000000;
	assign data_im [28] = 12'b000000101111;

	assign data_re [29] = 12'b111111111001;
	assign data_im [29] = 12'b000001001001;

	assign data_re [30] = 12'b111111011000;
	assign data_im [30] = 12'b111111111001;

	assign data_re [31] = 12'b000000000001;
	assign data_im [31] = 12'b111110111100;

	assign data_re [32] = 12'b000000011000;
	assign data_im [32] = 12'b000000011000;

	assign data_re [33] = 12'b111110111100;
	assign data_im [33] = 12'b000000000001;

	assign data_re [34] = 12'b111111111001;
	assign data_im [34] = 12'b111111011000;

	assign data_re [35] = 12'b000001001001;
	assign data_im [35] = 12'b111111111001;

	assign data_re [36] = 12'b000000101111;
	assign data_im [36] = 12'b000000000000;

	assign data_re [37] = 12'b000001001001;
	assign data_im [37] = 12'b111111111001;

	assign data_re [38] = 12'b111111111001;
	assign data_im [38] = 12'b111111011000;

	assign data_re [39] = 12'b111110111100;
	assign data_im [39] = 12'b000000000001;

	assign data_re [40] = 12'b000000011000;
	assign data_im [40] = 12'b000000011000;

	assign data_re [41] = 12'b000000000001;
	assign data_im [41] = 12'b111110111100;

	assign data_re [42] = 12'b111111011000;
	assign data_im [42] = 12'b111111111001;

	assign data_re [43] = 12'b111111111001;
	assign data_im [43] = 12'b000001001001;

	assign data_re [44] = 12'b000000000000;
	assign data_im [44] = 12'b000000101111;

	assign data_re [45] = 12'b111111111001;
	assign data_im [45] = 12'b000001001001;

	assign data_re [46] = 12'b111111011000;
	assign data_im [46] = 12'b111111111001;

	assign data_re [47] = 12'b000000000001;
	assign data_im [47] = 12'b111110111100;

	assign data_re [48] = 12'b000000011000;
	assign data_im [48] = 12'b000000011000;

	assign data_re [49] = 12'b111110111100;
	assign data_im [49] = 12'b000000000001;

	assign data_re [50] = 12'b111111111001;
	assign data_im [50] = 12'b111111011000;

	assign data_re [51] = 12'b000001001001;
	assign data_im [51] = 12'b111111111001;

	assign data_re [52] = 12'b000000101111;
	assign data_im [52] = 12'b000000000000;

	assign data_re [53] = 12'b000001001001;
	assign data_im [53] = 12'b111111111001;

	assign data_re [54] = 12'b111111111001;
	assign data_im [54] = 12'b111111011000;

	assign data_re [55] = 12'b111110111100;
	assign data_im [55] = 12'b000000000001;

	assign data_re [56] = 12'b000000011000;
	assign data_im [56] = 12'b000000011000;

	assign data_re [57] = 12'b000000000001;
	assign data_im [57] = 12'b111110111100;

	assign data_re [58] = 12'b111111011000;
	assign data_im [58] = 12'b111111111001;

	assign data_re [59] = 12'b111111111001;
	assign data_im [59] = 12'b000001001001;

	assign data_re [60] = 12'b000000000000;
	assign data_im [60] = 12'b000000101111;

	assign data_re [61] = 12'b111111111001;
	assign data_im [61] = 12'b000001001001;

	assign data_re [62] = 12'b111111011000;
	assign data_im [62] = 12'b111111111001;

	assign data_re [63] = 12'b000000000001;
	assign data_im [63] = 12'b111110111100;

	assign data_re [64] = 12'b000000011000;
	assign data_im [64] = 12'b000000011000;

	assign data_re [65] = 12'b111110111100;
	assign data_im [65] = 12'b000000000001;

	assign data_re [66] = 12'b111111111001;
	assign data_im [66] = 12'b111111011000;

	assign data_re [67] = 12'b000001001001;
	assign data_im [67] = 12'b111111111001;

	assign data_re [68] = 12'b000000101111;
	assign data_im [68] = 12'b000000000000;

	assign data_re [69] = 12'b000001001001;
	assign data_im [69] = 12'b111111111001;

	assign data_re [70] = 12'b111111111001;
	assign data_im [70] = 12'b111111011000;

	assign data_re [71] = 12'b111110111100;
	assign data_im [71] = 12'b000000000001;

	assign data_re [72] = 12'b000000011000;
	assign data_im [72] = 12'b000000011000;

	assign data_re [73] = 12'b000000000001;
	assign data_im [73] = 12'b111110111100;

	assign data_re [74] = 12'b111111011000;
	assign data_im [74] = 12'b111111111001;

	assign data_re [75] = 12'b111111111001;
	assign data_im [75] = 12'b000001001001;

	assign data_re [76] = 12'b000000000000;
	assign data_im [76] = 12'b000000101111;

	assign data_re [77] = 12'b111111111001;
	assign data_im [77] = 12'b000001001001;

	assign data_re [78] = 12'b111111011000;
	assign data_im [78] = 12'b111111111001;

	assign data_re [79] = 12'b000000000001;
	assign data_im [79] = 12'b111110111100;

	assign data_re [80] = 12'b000000011000;
	assign data_im [80] = 12'b000000011000;

	assign data_re [81] = 12'b111110111100;
	assign data_im [81] = 12'b000000000001;

	assign data_re [82] = 12'b111111111001;
	assign data_im [82] = 12'b111111011000;

	assign data_re [83] = 12'b000001001001;
	assign data_im [83] = 12'b111111111001;

	assign data_re [84] = 12'b000000101111;
	assign data_im [84] = 12'b000000000000;

	assign data_re [85] = 12'b000001001001;
	assign data_im [85] = 12'b111111111001;

	assign data_re [86] = 12'b111111111001;
	assign data_im [86] = 12'b111111011000;

	assign data_re [87] = 12'b111110111100;
	assign data_im [87] = 12'b000000000001;

	assign data_re [88] = 12'b000000011000;
	assign data_im [88] = 12'b000000011000;

	assign data_re [89] = 12'b000000000001;
	assign data_im [89] = 12'b111110111100;

	assign data_re [90] = 12'b111111011000;
	assign data_im [90] = 12'b111111111001;

	assign data_re [91] = 12'b111111111001;
	assign data_im [91] = 12'b000001001001;

	assign data_re [92] = 12'b000000000000;
	assign data_im [92] = 12'b000000101111;

	assign data_re [93] = 12'b111111111001;
	assign data_im [93] = 12'b000001001001;

	assign data_re [94] = 12'b111111011000;
	assign data_im [94] = 12'b111111111001;

	assign data_re [95] = 12'b000000000001;
	assign data_im [95] = 12'b111110111100;

	assign data_re [96] = 12'b000000011000;
	assign data_im [96] = 12'b000000011000;

	assign data_re [97] = 12'b111110111100;
	assign data_im [97] = 12'b000000000001;

	assign data_re [98] = 12'b111111111001;
	assign data_im [98] = 12'b111111011000;

	assign data_re [99] = 12'b000001001001;
	assign data_im [99] = 12'b111111111001;

	assign data_re [100] = 12'b000000101111;
	assign data_im [100] = 12'b000000000000;

	assign data_re [101] = 12'b000001001001;
	assign data_im [101] = 12'b111111111001;

	assign data_re [102] = 12'b111111111001;
	assign data_im [102] = 12'b111111011000;

	assign data_re [103] = 12'b111110111100;
	assign data_im [103] = 12'b000000000001;

	assign data_re [104] = 12'b000000011000;
	assign data_im [104] = 12'b000000011000;

	assign data_re [105] = 12'b000000000001;
	assign data_im [105] = 12'b111110111100;

	assign data_re [106] = 12'b111111011000;
	assign data_im [106] = 12'b111111111001;

	assign data_re [107] = 12'b111111111001;
	assign data_im [107] = 12'b000001001001;

	assign data_re [108] = 12'b000000000000;
	assign data_im [108] = 12'b000000101111;

	assign data_re [109] = 12'b111111111001;
	assign data_im [109] = 12'b000001001001;

	assign data_re [110] = 12'b111111011000;
	assign data_im [110] = 12'b111111111001;

	assign data_re [111] = 12'b000000000001;
	assign data_im [111] = 12'b111110111100;

	assign data_re [112] = 12'b000000011000;
	assign data_im [112] = 12'b000000011000;

	assign data_re [113] = 12'b111110111100;
	assign data_im [113] = 12'b000000000001;

	assign data_re [114] = 12'b111111111001;
	assign data_im [114] = 12'b111111011000;

	assign data_re [115] = 12'b000001001001;
	assign data_im [115] = 12'b111111111001;

	assign data_re [116] = 12'b000000101111;
	assign data_im [116] = 12'b000000000000;

	assign data_re [117] = 12'b000001001001;
	assign data_im [117] = 12'b111111111001;

	assign data_re [118] = 12'b111111111001;
	assign data_im [118] = 12'b111111011000;

	assign data_re [119] = 12'b111110111100;
	assign data_im [119] = 12'b000000000001;

	assign data_re [120] = 12'b000000011000;
	assign data_im [120] = 12'b000000011000;

	assign data_re [121] = 12'b000000000001;
	assign data_im [121] = 12'b111110111100;

	assign data_re [122] = 12'b111111011000;
	assign data_im [122] = 12'b111111111001;

	assign data_re [123] = 12'b111111111001;
	assign data_im [123] = 12'b000001001001;

	assign data_re [124] = 12'b000000000000;
	assign data_im [124] = 12'b000000101111;

	assign data_re [125] = 12'b111111111001;
	assign data_im [125] = 12'b000001001001;

	assign data_re [126] = 12'b111111011000;
	assign data_im [126] = 12'b111111111001;

	assign data_re [127] = 12'b000000000001;
	assign data_im [127] = 12'b111110111100;

	assign data_re [128] = 12'b000000011000;
	assign data_im [128] = 12'b000000011000;

	assign data_re [129] = 12'b111110111100;
	assign data_im [129] = 12'b000000000001;

	assign data_re [130] = 12'b111111111001;
	assign data_im [130] = 12'b111111011000;

	assign data_re [131] = 12'b000001001001;
	assign data_im [131] = 12'b111111111001;

	assign data_re [132] = 12'b000000101111;
	assign data_im [132] = 12'b000000000000;

	assign data_re [133] = 12'b000001001001;
	assign data_im [133] = 12'b111111111001;

	assign data_re [134] = 12'b111111111001;
	assign data_im [134] = 12'b111111011000;

	assign data_re [135] = 12'b111110111100;
	assign data_im [135] = 12'b000000000001;

	assign data_re [136] = 12'b000000011000;
	assign data_im [136] = 12'b000000011000;

	assign data_re [137] = 12'b000000000001;
	assign data_im [137] = 12'b111110111100;

	assign data_re [138] = 12'b111111011000;
	assign data_im [138] = 12'b111111111001;

	assign data_re [139] = 12'b111111111001;
	assign data_im [139] = 12'b000001001001;

	assign data_re [140] = 12'b000000000000;
	assign data_im [140] = 12'b000000101111;

	assign data_re [141] = 12'b111111111001;
	assign data_im [141] = 12'b000001001001;

	assign data_re [142] = 12'b111111011000;
	assign data_im [142] = 12'b111111111001;

	assign data_re [143] = 12'b000000000001;
	assign data_im [143] = 12'b111110111100;

	assign data_re [144] = 12'b000000011000;
	assign data_im [144] = 12'b000000011000;

	assign data_re [145] = 12'b111110111100;
	assign data_im [145] = 12'b000000000001;

	assign data_re [146] = 12'b111111111001;
	assign data_im [146] = 12'b111111011000;

	assign data_re [147] = 12'b000001001001;
	assign data_im [147] = 12'b111111111001;

	assign data_re [148] = 12'b000000101111;
	assign data_im [148] = 12'b000000000000;

	assign data_re [149] = 12'b000001001001;
	assign data_im [149] = 12'b111111111001;

	assign data_re [150] = 12'b111111111001;
	assign data_im [150] = 12'b111111011000;

	assign data_re [151] = 12'b111110111100;
	assign data_im [151] = 12'b000000000001;

	assign data_re [152] = 12'b000000011000;
	assign data_im [152] = 12'b000000011000;

	assign data_re [153] = 12'b000000000001;
	assign data_im [153] = 12'b111110111100;

	assign data_re [154] = 12'b111111011000;
	assign data_im [154] = 12'b111111111001;

	assign data_re [155] = 12'b111111111001;
	assign data_im [155] = 12'b000001001001;

	assign data_re [156] = 12'b000000000000;
	assign data_im [156] = 12'b000000101111;

	assign data_re [157] = 12'b111111111001;
	assign data_im [157] = 12'b000001001001;

	assign data_re [158] = 12'b111111011000;
	assign data_im [158] = 12'b111111111001;

	assign data_re [159] = 12'b000000000001;
	assign data_im [159] = 12'b111110111100;

	assign data_re [160] = 12'b000000001100;
	assign data_im [160] = 12'b000000001100;
	//===============================================================================	
	reg [8:0]counter=161;
	reg flag;
	//===============================================================================	
	always @(posedge clk or  negedge reset) 
	begin
		//=======================================================================
		if(reset == 0)
		begin
			enable_ifft	<=0;
			done		<=0;
			flag		<=0;
			valid_out	<=0;
			pre_re		<=0;
			pre_im		<=0;
		end
		//=======================================================================
		else if(done ==1)
		begin
			valid_out	<=0;
			done		<=0;
			flag		<=0;
			pre_re		<=0;
			pre_im		<=0;
			
		end
		//=======================================================================
		else if(flag==1)
		begin
			valid_out	<=1;
			pre_re		<=data_re[161-counter];
			pre_im		<=data_im[161-counter];
			counter		<=counter-1;

			if(counter ==1) 
				done=1;
			if(counter ==49)
				enable_ifft	<=1;
			if(counter==0)   
			begin
				valid_out	<=0;
				flag		<=0;
			end
		end	
		//=======================================================================
		else if(valid_in==1)
		begin
			valid_out	<=1;
			flag		<=1;
			pre_re		<=data_re[0];
			pre_im		<=data_im[0];
			counter		<=counter-1;
		end
		//=======================================================================
		else 
		begin 
			pre_re		<=0;
			pre_im		<=0;
			valid_out	<=0;
			done		<=0;
			flag		<=0;
			counter		<=161;
		end
		//=======================================================================
	end
	//===============================================================================	
endmodule
