module ram_survivor_decoder_wifi( 
   input clk,      
   input reset,      
   input [27:0] data_in,    
   input [5:0] page, 
   input WR,
   input enable,
   input RE,
   input [5:0] re_page,
   input [7:0] re_state,
   output valid_out,
   output [7:0] least       
   );
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
reg [127:0] mem [0:63];
reg [1:0] address_write ;
wire WE_mem,dataout_in;
wire [6:0] S0,S1,S2,S3;
wire [7:0] State0,State1;
wire [127:0] we,re;
wire [127:0] datain,dataout;
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
Address_shifter Shifter (clk,reset,re_state,valid_out,State0,State1);
Dataout_selection Select (clk,reset,dataout_in,State1,RE,valid_out,least);
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
Surv_RAM Surv_Mem(
.clk(clk),
.reset(reset),
.we(we),
.re(re),
.enable(1),
.repage({1'b0,1'b0,1'b0,1'b0,re_page}),
.page({1'b0,1'b0,1'b0,1'b0,page}),
.datain(datain),
.data(dataout)
);
//--------------------------------------------------------------------------------------------------------------------//
inwe_generator we_gen(
    .WR(WE_mem),
    .S0(S0),
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .datain(datain),
    .we(we)
    );
//--------------------------------------------------------------------------------------------------------------------//
MUX_128x1 dataout_mux(
    .s(State1[7:1]), 
    .a(dataout),  
    .y(dataout_in)
    );
//---------------------------------------------------------------------------------------------------------------------//    
assign {S3,S2,S1,S0}=data_in;
assign WE_mem = WR & enable;
assign re [0]=valid_out;
assign re [1]=valid_out;
assign re [2]=valid_out;
assign re [3]=valid_out;
assign re [4]=valid_out;
assign re [5]=valid_out;
assign re [6]=valid_out;
assign re [7]=valid_out;
assign re [8]=valid_out;
assign re [9]=valid_out;
assign re [10]=valid_out;
assign re [11]=valid_out;
assign re [12]=valid_out;
assign re [13]=valid_out;
assign re [14]=valid_out;
assign re [15]=valid_out;
assign re [16]=valid_out;
assign re [17]=valid_out;
assign re [18]=valid_out;
assign re [19]=valid_out;
assign re [20]=valid_out;
assign re [21]=valid_out;
assign re [22]=valid_out;
assign re [23]=valid_out;
assign re [24]=valid_out;
assign re [25]=valid_out;
assign re [26]=valid_out;
assign re [27]=valid_out;
assign re [28]=valid_out;
assign re [29]=valid_out;
assign re [30]=valid_out;
assign re [31]=valid_out;
assign re [32]=valid_out;
assign re [33]=valid_out;
assign re [34]=valid_out;
assign re [35]=valid_out;
assign re [36]=valid_out;
assign re [37]=valid_out;
assign re [38]=valid_out;
assign re [39]=valid_out;
assign re [40]=valid_out;
assign re [41]=valid_out;
assign re [42]=valid_out;
assign re [43]=valid_out;
assign re [44]=valid_out;
assign re [45]=valid_out;
assign re [46]=valid_out;
assign re [47]=valid_out;
assign re [48]=valid_out;
assign re [49]=valid_out;
assign re [50]=valid_out;
assign re [51]=valid_out;
assign re [52]=valid_out;
assign re [53]=valid_out;
assign re [54]=valid_out;
assign re [55]=valid_out;
assign re [56]=valid_out;
assign re [57]=valid_out;
assign re [58]=valid_out;
assign re [59]=valid_out;
assign re [60]=valid_out;
assign re [61]=valid_out;
assign re [62]=valid_out;
assign re [63]=valid_out;
assign re [64]=valid_out;
assign re [65]=valid_out;
assign re [66]=valid_out;
assign re [67]=valid_out;
assign re [68]=valid_out;
assign re [69]=valid_out;
assign re [70]=valid_out;
assign re [71]=valid_out;
assign re [72]=valid_out;
assign re [73]=valid_out;
assign re [74]=valid_out;
assign re [75]=valid_out;
assign re [76]=valid_out;
assign re [77]=valid_out;
assign re [78]=valid_out;
assign re [79]=valid_out;
assign re [80]=valid_out;
assign re [81]=valid_out;
assign re [82]=valid_out;
assign re [83]=valid_out;
assign re [84]=valid_out;
assign re [85]=valid_out;
assign re [86]=valid_out;
assign re [87]=valid_out;
assign re [88]=valid_out;
assign re [89]=valid_out;
assign re [90]=valid_out;
assign re [91]=valid_out;
assign re [92]=valid_out;
assign re [93]=valid_out;
assign re [94]=valid_out;
assign re [95]=valid_out;
assign re [96]=valid_out;
assign re [97]=valid_out;
assign re [98]=valid_out;
assign re [99]=valid_out;
assign re [100]=valid_out;
assign re [101]=valid_out;
assign re [102]=valid_out;
assign re [103]=valid_out;
assign re [104]=valid_out;
assign re [105]=valid_out;
assign re [106]=valid_out;
assign re [107]=valid_out;
assign re [108]=valid_out;
assign re [109]=valid_out;
assign re [110]=valid_out;
assign re [111]=valid_out;
assign re [112]=valid_out;
assign re [113]=valid_out;
assign re [114]=valid_out;
assign re [115]=valid_out;
assign re [116]=valid_out;
assign re [117]=valid_out;
assign re [118]=valid_out;
assign re [119]=valid_out;
assign re [120]=valid_out;
assign re [121]=valid_out;
assign re [122]=valid_out;
assign re [123]=valid_out;
assign re [124]=valid_out;
assign re [125]=valid_out;
assign re [126]=valid_out;
assign re [127]=valid_out;
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
endmodule
//================================================================================================================================================================================================================//

module Address_shifter(
    input clk,
    input reset,
    input [7:0] least,
    input valid_out,
    output   [7:0] Previous_state0,
    output   reg [7:0] Previous_state1
    );
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//    
always @(posedge clk or negedge reset ) 
begin
    if (!reset)
	begin
	   Previous_state1<=8'hff;
	end
	else
	begin
       if(valid_out==1)
        Previous_state1<={1'b0,least[7:2],least[0]}; 
	end
end	
    assign Previous_state0={1'b0,least[7:2],least[0]};

endmodule
//================================================================================================================================================================================================================//

module Dataout_selection(
    input clk,
    input reset,
    input Datain,
    input [7:0] State0,
    input RE,
    output reg valid_out,
    output reg [7:0] Least
    );
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//    
always @(posedge clk or negedge reset ) 
begin
    if (!reset)
	begin
	   Least<=8'hff;
	   valid_out<=0;
	end
	else
	begin
	   valid_out <=RE;
	   if(RE!=1)
	   begin
	   if (Datain==State0[1]) 
	   begin
	     Least<= {State0[7:1],(State0[0])};
	   end
	   else
	   begin
	     Least<={1'b1,State0[6:1],(State0[0])};
	   end 
	   end
	end
end

endmodule

//=======================================================================================================//
module Survivoir_RAM(
clk,
reset,
we,
re,
enable,
re_page,
page,
datain,
dataout
);
//------------------------------------------------------------------//
input clk;
input reset;
input we;
input re;
input enable;
input [9:0] re_page;
input [9:0] page;
input  datain;
output reg  dataout;
//-------------------------------------------------------------------//
reg [0:0] mem [63:0];
//-------------------------------------------------------------------//
always @(posedge clk) 
begin
        if (we==1'b1)
            mem[page]<=datain;
        if(re)    
            dataout<=mem[re_page];	   
end
endmodule
//==========================================================================================================================================//
module Surv_RAM(
input clk,
input reset,
input [127:0] we,
input [127:0] re,
input enable,
input [9:0] repage,
input [9:0] page,
input  [127:0]datain,
output [127:0] data);
//----------------------------------------------------------------------------------------------------------------------------------------------------------------//
Survivoir_RAM R0 ( .clk(clk), .reset(reset), .we(we[0]), .re(re[0]), .enable(enable), .re_page(repage), .page(page), .datain(datain[0]), .dataout(data[0]) );
Survivoir_RAM R1 ( .clk(clk), .reset(reset), .we(we[1]), .re(re[1]), .enable(enable), .re_page(repage), .page(page), .datain(datain[1]), .dataout(data[1]) );
Survivoir_RAM R2 ( .clk(clk), .reset(reset), .we(we[2]), .re(re[2]), .enable(enable), .re_page(repage), .page(page), .datain(datain[2]), .dataout(data[2]) );
Survivoir_RAM R3 ( .clk(clk), .reset(reset), .we(we[3]), .re(re[3]), .enable(enable), .re_page(repage), .page(page), .datain(datain[3]), .dataout(data[3]) );
Survivoir_RAM R4 ( .clk(clk), .reset(reset), .we(we[4]), .re(re[4]), .enable(enable), .re_page(repage), .page(page), .datain(datain[4]), .dataout(data[4]) );
Survivoir_RAM R5 ( .clk(clk), .reset(reset), .we(we[5]), .re(re[5]), .enable(enable), .re_page(repage), .page(page), .datain(datain[5]), .dataout(data[5]) );
Survivoir_RAM R6 ( .clk(clk), .reset(reset), .we(we[6]), .re(re[6]), .enable(enable), .re_page(repage), .page(page), .datain(datain[6]), .dataout(data[6]) );
Survivoir_RAM R7 ( .clk(clk), .reset(reset), .we(we[7]), .re(re[7]), .enable(enable), .re_page(repage), .page(page), .datain(datain[7]), .dataout(data[7]) );
Survivoir_RAM R8 ( .clk(clk), .reset(reset), .we(we[8]), .re(re[8]), .enable(enable), .re_page(repage), .page(page), .datain(datain[8]), .dataout(data[8]) );
Survivoir_RAM R9 ( .clk(clk), .reset(reset), .we(we[9]), .re(re[9]), .enable(enable), .re_page(repage), .page(page), .datain(datain[9]), .dataout(data[9]) );
Survivoir_RAM R10 ( .clk(clk), .reset(reset), .we(we[10]), .re(re[10]), .enable(enable), .re_page(repage), .page(page), .datain(datain[10]), .dataout(data[10]) );
Survivoir_RAM R11 ( .clk(clk), .reset(reset), .we(we[11]), .re(re[11]), .enable(enable), .re_page(repage), .page(page), .datain(datain[11]), .dataout(data[11]) );
Survivoir_RAM R12 ( .clk(clk), .reset(reset), .we(we[12]), .re(re[12]), .enable(enable), .re_page(repage), .page(page), .datain(datain[12]), .dataout(data[12]) );
Survivoir_RAM R13 ( .clk(clk), .reset(reset), .we(we[13]), .re(re[13]), .enable(enable), .re_page(repage), .page(page), .datain(datain[13]), .dataout(data[13]) );
Survivoir_RAM R14 ( .clk(clk), .reset(reset), .we(we[14]), .re(re[14]), .enable(enable), .re_page(repage), .page(page), .datain(datain[14]), .dataout(data[14]) );
Survivoir_RAM R15 ( .clk(clk), .reset(reset), .we(we[15]), .re(re[15]), .enable(enable), .re_page(repage), .page(page), .datain(datain[15]), .dataout(data[15]) );
Survivoir_RAM R16 ( .clk(clk), .reset(reset), .we(we[16]), .re(re[16]), .enable(enable), .re_page(repage), .page(page), .datain(datain[16]), .dataout(data[16]) );
Survivoir_RAM R17 ( .clk(clk), .reset(reset), .we(we[17]), .re(re[17]), .enable(enable), .re_page(repage), .page(page), .datain(datain[17]), .dataout(data[17]) );
Survivoir_RAM R18 ( .clk(clk), .reset(reset), .we(we[18]), .re(re[18]), .enable(enable), .re_page(repage), .page(page), .datain(datain[18]), .dataout(data[18]) );
Survivoir_RAM R19 ( .clk(clk), .reset(reset), .we(we[19]), .re(re[19]), .enable(enable), .re_page(repage), .page(page), .datain(datain[19]), .dataout(data[19]) );
Survivoir_RAM R20 ( .clk(clk), .reset(reset), .we(we[20]), .re(re[20]), .enable(enable), .re_page(repage), .page(page), .datain(datain[20]), .dataout(data[20]) );
Survivoir_RAM R21 ( .clk(clk), .reset(reset), .we(we[21]), .re(re[21]), .enable(enable), .re_page(repage), .page(page), .datain(datain[21]), .dataout(data[21]) );
Survivoir_RAM R22 ( .clk(clk), .reset(reset), .we(we[22]), .re(re[22]), .enable(enable), .re_page(repage), .page(page), .datain(datain[22]), .dataout(data[22]) );
Survivoir_RAM R23 ( .clk(clk), .reset(reset), .we(we[23]), .re(re[23]), .enable(enable), .re_page(repage), .page(page), .datain(datain[23]), .dataout(data[23]) );
Survivoir_RAM R24 ( .clk(clk), .reset(reset), .we(we[24]), .re(re[24]), .enable(enable), .re_page(repage), .page(page), .datain(datain[24]), .dataout(data[24]) );
Survivoir_RAM R25 ( .clk(clk), .reset(reset), .we(we[25]), .re(re[25]), .enable(enable), .re_page(repage), .page(page), .datain(datain[25]), .dataout(data[25]) );
Survivoir_RAM R26 ( .clk(clk), .reset(reset), .we(we[26]), .re(re[26]), .enable(enable), .re_page(repage), .page(page), .datain(datain[26]), .dataout(data[26]) );
Survivoir_RAM R27 ( .clk(clk), .reset(reset), .we(we[27]), .re(re[27]), .enable(enable), .re_page(repage), .page(page), .datain(datain[27]), .dataout(data[27]) );
Survivoir_RAM R28 ( .clk(clk), .reset(reset), .we(we[28]), .re(re[28]), .enable(enable), .re_page(repage), .page(page), .datain(datain[28]), .dataout(data[28]) );
Survivoir_RAM R29 ( .clk(clk), .reset(reset), .we(we[29]), .re(re[29]), .enable(enable), .re_page(repage), .page(page), .datain(datain[29]), .dataout(data[29]) );
Survivoir_RAM R30 ( .clk(clk), .reset(reset), .we(we[30]), .re(re[30]), .enable(enable), .re_page(repage), .page(page), .datain(datain[30]), .dataout(data[30]) );
Survivoir_RAM R31 ( .clk(clk), .reset(reset), .we(we[31]), .re(re[31]), .enable(enable), .re_page(repage), .page(page), .datain(datain[31]), .dataout(data[31]) );
Survivoir_RAM R32 ( .clk(clk), .reset(reset), .we(we[32]), .re(re[32]), .enable(enable), .re_page(repage), .page(page), .datain(datain[32]), .dataout(data[32]) );
Survivoir_RAM R33 ( .clk(clk), .reset(reset), .we(we[33]), .re(re[33]), .enable(enable), .re_page(repage), .page(page), .datain(datain[33]), .dataout(data[33]) );
Survivoir_RAM R34 ( .clk(clk), .reset(reset), .we(we[34]), .re(re[34]), .enable(enable), .re_page(repage), .page(page), .datain(datain[34]), .dataout(data[34]) );
Survivoir_RAM R35 ( .clk(clk), .reset(reset), .we(we[35]), .re(re[35]), .enable(enable), .re_page(repage), .page(page), .datain(datain[35]), .dataout(data[35]) );
Survivoir_RAM R36 ( .clk(clk), .reset(reset), .we(we[36]), .re(re[36]), .enable(enable), .re_page(repage), .page(page), .datain(datain[36]), .dataout(data[36]) );
Survivoir_RAM R37 ( .clk(clk), .reset(reset), .we(we[37]), .re(re[37]), .enable(enable), .re_page(repage), .page(page), .datain(datain[37]), .dataout(data[37]) );
Survivoir_RAM R38 ( .clk(clk), .reset(reset), .we(we[38]), .re(re[38]), .enable(enable), .re_page(repage), .page(page), .datain(datain[38]), .dataout(data[38]) );
Survivoir_RAM R39 ( .clk(clk), .reset(reset), .we(we[39]), .re(re[39]), .enable(enable), .re_page(repage), .page(page), .datain(datain[39]), .dataout(data[39]) );
Survivoir_RAM R40 ( .clk(clk), .reset(reset), .we(we[40]), .re(re[40]), .enable(enable), .re_page(repage), .page(page), .datain(datain[40]), .dataout(data[40]) );
Survivoir_RAM R41 ( .clk(clk), .reset(reset), .we(we[41]), .re(re[41]), .enable(enable), .re_page(repage), .page(page), .datain(datain[41]), .dataout(data[41]) );
Survivoir_RAM R42 ( .clk(clk), .reset(reset), .we(we[42]), .re(re[42]), .enable(enable), .re_page(repage), .page(page), .datain(datain[42]), .dataout(data[42]) );
Survivoir_RAM R43 ( .clk(clk), .reset(reset), .we(we[43]), .re(re[43]), .enable(enable), .re_page(repage), .page(page), .datain(datain[43]), .dataout(data[43]) );
Survivoir_RAM R44 ( .clk(clk), .reset(reset), .we(we[44]), .re(re[44]), .enable(enable), .re_page(repage), .page(page), .datain(datain[44]), .dataout(data[44]) );
Survivoir_RAM R45 ( .clk(clk), .reset(reset), .we(we[45]), .re(re[45]), .enable(enable), .re_page(repage), .page(page), .datain(datain[45]), .dataout(data[45]) );
Survivoir_RAM R46 ( .clk(clk), .reset(reset), .we(we[46]), .re(re[46]), .enable(enable), .re_page(repage), .page(page), .datain(datain[46]), .dataout(data[46]) );
Survivoir_RAM R47 ( .clk(clk), .reset(reset), .we(we[47]), .re(re[47]), .enable(enable), .re_page(repage), .page(page), .datain(datain[47]), .dataout(data[47]) );
Survivoir_RAM R48 ( .clk(clk), .reset(reset), .we(we[48]), .re(re[48]), .enable(enable), .re_page(repage), .page(page), .datain(datain[48]), .dataout(data[48]) );
Survivoir_RAM R49 ( .clk(clk), .reset(reset), .we(we[49]), .re(re[49]), .enable(enable), .re_page(repage), .page(page), .datain(datain[49]), .dataout(data[49]) );
Survivoir_RAM R50 ( .clk(clk), .reset(reset), .we(we[50]), .re(re[50]), .enable(enable), .re_page(repage), .page(page), .datain(datain[50]), .dataout(data[50]) );
Survivoir_RAM R51 ( .clk(clk), .reset(reset), .we(we[51]), .re(re[51]), .enable(enable), .re_page(repage), .page(page), .datain(datain[51]), .dataout(data[51]) );
Survivoir_RAM R52 ( .clk(clk), .reset(reset), .we(we[52]), .re(re[52]), .enable(enable), .re_page(repage), .page(page), .datain(datain[52]), .dataout(data[52]) );
Survivoir_RAM R53 ( .clk(clk), .reset(reset), .we(we[53]), .re(re[53]), .enable(enable), .re_page(repage), .page(page), .datain(datain[53]), .dataout(data[53]) );
Survivoir_RAM R54 ( .clk(clk), .reset(reset), .we(we[54]), .re(re[54]), .enable(enable), .re_page(repage), .page(page), .datain(datain[54]), .dataout(data[54]) );
Survivoir_RAM R55 ( .clk(clk), .reset(reset), .we(we[55]), .re(re[55]), .enable(enable), .re_page(repage), .page(page), .datain(datain[55]), .dataout(data[55]) );
Survivoir_RAM R56 ( .clk(clk), .reset(reset), .we(we[56]), .re(re[56]), .enable(enable), .re_page(repage), .page(page), .datain(datain[56]), .dataout(data[56]) );
Survivoir_RAM R57 ( .clk(clk), .reset(reset), .we(we[57]), .re(re[57]), .enable(enable), .re_page(repage), .page(page), .datain(datain[57]), .dataout(data[57]) );
Survivoir_RAM R58 ( .clk(clk), .reset(reset), .we(we[58]), .re(re[58]), .enable(enable), .re_page(repage), .page(page), .datain(datain[58]), .dataout(data[58]) );
Survivoir_RAM R59 ( .clk(clk), .reset(reset), .we(we[59]), .re(re[59]), .enable(enable), .re_page(repage), .page(page), .datain(datain[59]), .dataout(data[59]) );
Survivoir_RAM R60 ( .clk(clk), .reset(reset), .we(we[60]), .re(re[60]), .enable(enable), .re_page(repage), .page(page), .datain(datain[60]), .dataout(data[60]) );
Survivoir_RAM R61 ( .clk(clk), .reset(reset), .we(we[61]), .re(re[61]), .enable(enable), .re_page(repage), .page(page), .datain(datain[61]), .dataout(data[61]) );
Survivoir_RAM R62 ( .clk(clk), .reset(reset), .we(we[62]), .re(re[62]), .enable(enable), .re_page(repage), .page(page), .datain(datain[62]), .dataout(data[62]) );
Survivoir_RAM R63 ( .clk(clk), .reset(reset), .we(we[63]), .re(re[63]), .enable(enable), .re_page(repage), .page(page), .datain(datain[63]), .dataout(data[63]) );
Survivoir_RAM R64 ( .clk(clk), .reset(reset), .we(we[64]), .re(re[64]), .enable(enable), .re_page(repage), .page(page), .datain(datain[64]), .dataout(data[64]) );
Survivoir_RAM R65 ( .clk(clk), .reset(reset), .we(we[65]), .re(re[65]), .enable(enable), .re_page(repage), .page(page), .datain(datain[65]), .dataout(data[65]) );
Survivoir_RAM R66 ( .clk(clk), .reset(reset), .we(we[66]), .re(re[66]), .enable(enable), .re_page(repage), .page(page), .datain(datain[66]), .dataout(data[66]) );
Survivoir_RAM R67 ( .clk(clk), .reset(reset), .we(we[67]), .re(re[67]), .enable(enable), .re_page(repage), .page(page), .datain(datain[67]), .dataout(data[67]) );
Survivoir_RAM R68 ( .clk(clk), .reset(reset), .we(we[68]), .re(re[68]), .enable(enable), .re_page(repage), .page(page), .datain(datain[68]), .dataout(data[68]) );
Survivoir_RAM R69 ( .clk(clk), .reset(reset), .we(we[69]), .re(re[69]), .enable(enable), .re_page(repage), .page(page), .datain(datain[69]), .dataout(data[69]) );
Survivoir_RAM R70 ( .clk(clk), .reset(reset), .we(we[70]), .re(re[70]), .enable(enable), .re_page(repage), .page(page), .datain(datain[70]), .dataout(data[70]) );
Survivoir_RAM R71 ( .clk(clk), .reset(reset), .we(we[71]), .re(re[71]), .enable(enable), .re_page(repage), .page(page), .datain(datain[71]), .dataout(data[71]) );
Survivoir_RAM R72 ( .clk(clk), .reset(reset), .we(we[72]), .re(re[72]), .enable(enable), .re_page(repage), .page(page), .datain(datain[72]), .dataout(data[72]) );
Survivoir_RAM R73 ( .clk(clk), .reset(reset), .we(we[73]), .re(re[73]), .enable(enable), .re_page(repage), .page(page), .datain(datain[73]), .dataout(data[73]) );
Survivoir_RAM R74 ( .clk(clk), .reset(reset), .we(we[74]), .re(re[74]), .enable(enable), .re_page(repage), .page(page), .datain(datain[74]), .dataout(data[74]) );
Survivoir_RAM R75 ( .clk(clk), .reset(reset), .we(we[75]), .re(re[75]), .enable(enable), .re_page(repage), .page(page), .datain(datain[75]), .dataout(data[75]) );
Survivoir_RAM R76 ( .clk(clk), .reset(reset), .we(we[76]), .re(re[76]), .enable(enable), .re_page(repage), .page(page), .datain(datain[76]), .dataout(data[76]) );
Survivoir_RAM R77 ( .clk(clk), .reset(reset), .we(we[77]), .re(re[77]), .enable(enable), .re_page(repage), .page(page), .datain(datain[77]), .dataout(data[77]) );
Survivoir_RAM R78 ( .clk(clk), .reset(reset), .we(we[78]), .re(re[78]), .enable(enable), .re_page(repage), .page(page), .datain(datain[78]), .dataout(data[78]) );
Survivoir_RAM R79 ( .clk(clk), .reset(reset), .we(we[79]), .re(re[79]), .enable(enable), .re_page(repage), .page(page), .datain(datain[79]), .dataout(data[79]) );
Survivoir_RAM R80 ( .clk(clk), .reset(reset), .we(we[80]), .re(re[80]), .enable(enable), .re_page(repage), .page(page), .datain(datain[80]), .dataout(data[80]) );
Survivoir_RAM R81 ( .clk(clk), .reset(reset), .we(we[81]), .re(re[81]), .enable(enable), .re_page(repage), .page(page), .datain(datain[81]), .dataout(data[81]) );
Survivoir_RAM R82 ( .clk(clk), .reset(reset), .we(we[82]), .re(re[82]), .enable(enable), .re_page(repage), .page(page), .datain(datain[82]), .dataout(data[82]) );
Survivoir_RAM R83 ( .clk(clk), .reset(reset), .we(we[83]), .re(re[83]), .enable(enable), .re_page(repage), .page(page), .datain(datain[83]), .dataout(data[83]) );
Survivoir_RAM R84 ( .clk(clk), .reset(reset), .we(we[84]), .re(re[84]), .enable(enable), .re_page(repage), .page(page), .datain(datain[84]), .dataout(data[84]) );
Survivoir_RAM R85 ( .clk(clk), .reset(reset), .we(we[85]), .re(re[85]), .enable(enable), .re_page(repage), .page(page), .datain(datain[85]), .dataout(data[85]) );
Survivoir_RAM R86 ( .clk(clk), .reset(reset), .we(we[86]), .re(re[86]), .enable(enable), .re_page(repage), .page(page), .datain(datain[86]), .dataout(data[86]) );
Survivoir_RAM R87 ( .clk(clk), .reset(reset), .we(we[87]), .re(re[87]), .enable(enable), .re_page(repage), .page(page), .datain(datain[87]), .dataout(data[87]) );
Survivoir_RAM R88 ( .clk(clk), .reset(reset), .we(we[88]), .re(re[88]), .enable(enable), .re_page(repage), .page(page), .datain(datain[88]), .dataout(data[88]) );
Survivoir_RAM R89 ( .clk(clk), .reset(reset), .we(we[89]), .re(re[89]), .enable(enable), .re_page(repage), .page(page), .datain(datain[89]), .dataout(data[89]) );
Survivoir_RAM R90 ( .clk(clk), .reset(reset), .we(we[90]), .re(re[90]), .enable(enable), .re_page(repage), .page(page), .datain(datain[90]), .dataout(data[90]) );
Survivoir_RAM R91 ( .clk(clk), .reset(reset), .we(we[91]), .re(re[91]), .enable(enable), .re_page(repage), .page(page), .datain(datain[91]), .dataout(data[91]) );
Survivoir_RAM R92 ( .clk(clk), .reset(reset), .we(we[92]), .re(re[92]), .enable(enable), .re_page(repage), .page(page), .datain(datain[92]), .dataout(data[92]) );
Survivoir_RAM R93 ( .clk(clk), .reset(reset), .we(we[93]), .re(re[93]), .enable(enable), .re_page(repage), .page(page), .datain(datain[93]), .dataout(data[93]) );
Survivoir_RAM R94 ( .clk(clk), .reset(reset), .we(we[94]), .re(re[94]), .enable(enable), .re_page(repage), .page(page), .datain(datain[94]), .dataout(data[94]) );
Survivoir_RAM R95 ( .clk(clk), .reset(reset), .we(we[95]), .re(re[95]), .enable(enable), .re_page(repage), .page(page), .datain(datain[95]), .dataout(data[95]) );
Survivoir_RAM R96 ( .clk(clk), .reset(reset), .we(we[96]), .re(re[96]), .enable(enable), .re_page(repage), .page(page), .datain(datain[96]), .dataout(data[96]) );
Survivoir_RAM R97 ( .clk(clk), .reset(reset), .we(we[97]), .re(re[97]), .enable(enable), .re_page(repage), .page(page), .datain(datain[97]), .dataout(data[97]) );
Survivoir_RAM R98 ( .clk(clk), .reset(reset), .we(we[98]), .re(re[98]), .enable(enable), .re_page(repage), .page(page), .datain(datain[98]), .dataout(data[98]) );
Survivoir_RAM R99 ( .clk(clk), .reset(reset), .we(we[99]), .re(re[99]), .enable(enable), .re_page(repage), .page(page), .datain(datain[99]), .dataout(data[99]) );
Survivoir_RAM R100 ( .clk(clk), .reset(reset), .we(we[100]), .re(re[100]), .enable(enable), .re_page(repage), .page(page), .datain(datain[100]), .dataout(data[100]) );
Survivoir_RAM R101 ( .clk(clk), .reset(reset), .we(we[101]), .re(re[101]), .enable(enable), .re_page(repage), .page(page), .datain(datain[101]), .dataout(data[101]) );
Survivoir_RAM R102 ( .clk(clk), .reset(reset), .we(we[102]), .re(re[102]), .enable(enable), .re_page(repage), .page(page), .datain(datain[102]), .dataout(data[102]) );
Survivoir_RAM R103 ( .clk(clk), .reset(reset), .we(we[103]), .re(re[103]), .enable(enable), .re_page(repage), .page(page), .datain(datain[103]), .dataout(data[103]) );
Survivoir_RAM R104 ( .clk(clk), .reset(reset), .we(we[104]), .re(re[104]), .enable(enable), .re_page(repage), .page(page), .datain(datain[104]), .dataout(data[104]) );
Survivoir_RAM R105 ( .clk(clk), .reset(reset), .we(we[105]), .re(re[105]), .enable(enable), .re_page(repage), .page(page), .datain(datain[105]), .dataout(data[105]) );
Survivoir_RAM R106 ( .clk(clk), .reset(reset), .we(we[106]), .re(re[106]), .enable(enable), .re_page(repage), .page(page), .datain(datain[106]), .dataout(data[106]) );
Survivoir_RAM R107 ( .clk(clk), .reset(reset), .we(we[107]), .re(re[107]), .enable(enable), .re_page(repage), .page(page), .datain(datain[107]), .dataout(data[107]) );
Survivoir_RAM R108 ( .clk(clk), .reset(reset), .we(we[108]), .re(re[108]), .enable(enable), .re_page(repage), .page(page), .datain(datain[108]), .dataout(data[108]) );
Survivoir_RAM R109 ( .clk(clk), .reset(reset), .we(we[109]), .re(re[109]), .enable(enable), .re_page(repage), .page(page), .datain(datain[109]), .dataout(data[109]) );
Survivoir_RAM R110 ( .clk(clk), .reset(reset), .we(we[110]), .re(re[110]), .enable(enable), .re_page(repage), .page(page), .datain(datain[110]), .dataout(data[110]) );
Survivoir_RAM R111 ( .clk(clk), .reset(reset), .we(we[111]), .re(re[111]), .enable(enable), .re_page(repage), .page(page), .datain(datain[111]), .dataout(data[111]) );
Survivoir_RAM R112 ( .clk(clk), .reset(reset), .we(we[112]), .re(re[112]), .enable(enable), .re_page(repage), .page(page), .datain(datain[112]), .dataout(data[112]) );
Survivoir_RAM R113 ( .clk(clk), .reset(reset), .we(we[113]), .re(re[113]), .enable(enable), .re_page(repage), .page(page), .datain(datain[113]), .dataout(data[113]) );
Survivoir_RAM R114 ( .clk(clk), .reset(reset), .we(we[114]), .re(re[114]), .enable(enable), .re_page(repage), .page(page), .datain(datain[114]), .dataout(data[114]) );
Survivoir_RAM R115 ( .clk(clk), .reset(reset), .we(we[115]), .re(re[115]), .enable(enable), .re_page(repage), .page(page), .datain(datain[115]), .dataout(data[115]) );
Survivoir_RAM R116 ( .clk(clk), .reset(reset), .we(we[116]), .re(re[116]), .enable(enable), .re_page(repage), .page(page), .datain(datain[116]), .dataout(data[116]) );
Survivoir_RAM R117 ( .clk(clk), .reset(reset), .we(we[117]), .re(re[117]), .enable(enable), .re_page(repage), .page(page), .datain(datain[117]), .dataout(data[117]) );
Survivoir_RAM R118 ( .clk(clk), .reset(reset), .we(we[118]), .re(re[118]), .enable(enable), .re_page(repage), .page(page), .datain(datain[118]), .dataout(data[118]) );
Survivoir_RAM R119 ( .clk(clk), .reset(reset), .we(we[119]), .re(re[119]), .enable(enable), .re_page(repage), .page(page), .datain(datain[119]), .dataout(data[119]) );
Survivoir_RAM R120 ( .clk(clk), .reset(reset), .we(we[120]), .re(re[120]), .enable(enable), .re_page(repage), .page(page), .datain(datain[120]), .dataout(data[120]) );
Survivoir_RAM R121 ( .clk(clk), .reset(reset), .we(we[121]), .re(re[121]), .enable(enable), .re_page(repage), .page(page), .datain(datain[121]), .dataout(data[121]) );
Survivoir_RAM R122 ( .clk(clk), .reset(reset), .we(we[122]), .re(re[122]), .enable(enable), .re_page(repage), .page(page), .datain(datain[122]), .dataout(data[122]) );
Survivoir_RAM R123 ( .clk(clk), .reset(reset), .we(we[123]), .re(re[123]), .enable(enable), .re_page(repage), .page(page), .datain(datain[123]), .dataout(data[123]) );
Survivoir_RAM R124 ( .clk(clk), .reset(reset), .we(we[124]), .re(re[124]), .enable(enable), .re_page(repage), .page(page), .datain(datain[124]), .dataout(data[124]) );
Survivoir_RAM R125 ( .clk(clk), .reset(reset), .we(we[125]), .re(re[125]), .enable(enable), .re_page(repage), .page(page), .datain(datain[125]), .dataout(data[125]) );
Survivoir_RAM R126 ( .clk(clk), .reset(reset), .we(we[126]), .re(re[126]), .enable(enable), .re_page(repage), .page(page), .datain(datain[126]), .dataout(data[126]) );
Survivoir_RAM R127 ( .clk(clk), .reset(reset), .we(we[127]), .re(re[127]), .enable(enable), .re_page(repage), .page(page), .datain(datain[127]), .dataout(data[127]) );
endmodule
//========================================================================================================================================================================//
module inwe_generator(
    input WR,
    input [6:0] S0,
    input [6:0] S1,
    input [6:0] S2,
    input [6:0] S3,
    output [127:0] datain,
    output [127:0] we
    );   
//---------------------------------------------------------------------------------------------//
wire [15:0] temp_we;
wire B0,B1,B2,B3,B4,B5,B6,B7;
//---------------------------------------------------------------------------------------------//
decoder_4x16 Dec ( .d_out(temp_we),  .d_in({WR,S0[5:2]}) );
assign {we [67],we[66],we [65],we[64],we [3],we[2],we [1],we[0]}={temp_we[0],temp_we[0],temp_we[0],temp_we[0],temp_we[0],temp_we[0],temp_we[0],temp_we[0]};
assign {we [71],we[70],we [69],we[68], we [7],we[6],we [5],we[4]}={temp_we[1],temp_we[1],temp_we[1],temp_we[1],temp_we[1],temp_we[1],temp_we[1],temp_we[1]};
assign {we [75],we[74],we [73],we[72] ,we [11],we[10],we [9],we[8]}={temp_we[2],temp_we[2],temp_we[2],temp_we[2],temp_we[2],temp_we[2],temp_we[2],temp_we[2]};
assign {we [79],we[78],we [77],we[76],we [15],we[14],we [13],we[12]}={temp_we[3],temp_we[3],temp_we[3],temp_we[3],temp_we[3],temp_we[3],temp_we[3],temp_we[3]};
assign {we [83],we[82],we [81],we[80],we [19],we[18],we [17],we[16]}={temp_we[4],temp_we[4],temp_we[4],temp_we[4],temp_we[4],temp_we[4],temp_we[4],temp_we[4]};
assign {we [87],we[86],we [85],we[84],we [23],we[22],we [21],we[20]}={temp_we[5],temp_we[5],temp_we[5],temp_we[5],temp_we[5],temp_we[5],temp_we[5],temp_we[5]};
assign {we [91],we[90],we [89],we[88],we [27],we[26],we [25],we[24]}={temp_we[6],temp_we[6],temp_we[6],temp_we[6],temp_we[6],temp_we[6],temp_we[6],temp_we[6]};
assign {we [95],we[94],we [93],we[92],we [31],we[30],we [29],we[28]}={temp_we[7],temp_we[7],temp_we[7],temp_we[7],temp_we[7],temp_we[7],temp_we[7],temp_we[7]};
assign {we [99],we[98],we [97],we[96],we [35],we[34],we [33],we[32]}={temp_we[8],temp_we[8],temp_we[8],temp_we[8],temp_we[8],temp_we[8],temp_we[8],temp_we[8]};
assign {we [103],we[102],we [101],we[100],we [39],we[38],we [37],we[36]}={temp_we[9],temp_we[9],temp_we[9],temp_we[9],temp_we[9],temp_we[9],temp_we[9],temp_we[9]};
assign {we [107],we[106],we [105],we[104],we [43],we[42],we [41],we[40]}={temp_we[10],temp_we[10],temp_we[10],temp_we[10],temp_we[10],temp_we[10],temp_we[10],temp_we[10]};   
assign {we [111],we[110],we [109],we[108],we [47],we[46],we [45],we[44]}={temp_we[11],temp_we[11],temp_we[11],temp_we[11],temp_we[11],temp_we[11],temp_we[11],temp_we[11]};
assign {we [115],we[114],we [113],we[112],we [51],we[50],we [49],we[48]}={temp_we[12],temp_we[12],temp_we[12],temp_we[12],temp_we[12],temp_we[12],temp_we[12],temp_we[12]};       
assign {we [119],we[118],we [117],we[116],we [55],we[54],we [53],we[52]}={temp_we[13],temp_we[13],temp_we[13],temp_we[13],temp_we[13],temp_we[13],temp_we[13],temp_we[13]};
assign {we [123],we[122],we [121],we[120],we [59],we[58],we [57],we[56]}={temp_we[14],temp_we[14],temp_we[14],temp_we[14],temp_we[14],temp_we[14],temp_we[14],temp_we[14]};
assign {we [127],we[126],we [125],we[124],we [63],we[62],we [61],we[60]}={temp_we[15],temp_we[15],temp_we[15],temp_we[15],temp_we[15],temp_we[15],temp_we[15],temp_we[15]};
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
assign B0=S0[6]^S0[0]; assign B4=!B0;
assign B1=S1[6]^S1[0]; assign B5=!B1;
assign B2=S2[6]^S2[0]; assign B6=!B2;
assign B3=S3[6]^S3[0]; assign B7=!B3;
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//assign {datain [67],datain [71],datain [75],datain [79],datain [83],datain [87],datain [91],datain [95],datain [99],datain [103],datain [107],datain [111],datain [115],datain [119],datain [123],datain [127]}=(B7)? 16'b1:16'b0;
//assign {datain [66],datain [70],datain [74],datain [78],datain [82],datain [86],datain [90],datain [94],datain [98],datain [102],datain [106],datain [110],datain [114],datain [118],datain [122],datain [126]}=(B6)? 16'b1:16'b0;
//assign {datain [65],datain [69],datain [73],datain [77],datain [81],datain [85],datain [89],datain [93],datain [97],datain [101],datain [105],datain [109],datain [113],datain [117],datain [121],datain [125]}=(B5)? 16'b1:16'b0;
//assign {datain [64],datain [68],datain [72],datain [76],datain [80],datain [84],datain [88],datain [92],datain [96],datain [100],datain [104],datain [108],datain [112],datain [116],datain [120],datain [124]}=(B4)? 16'b1:16'b0;  
//assign {datain [3],datain [7],datain [11],datain [15],datain [19],datain [23],datain [27],datain [31],datain [35],datain [39],datain [43],datain [47],datain [51],datain [55],datain [59],datain [63]}=(B3)? 16'b1:16'b0;
//assign {datain [2],datain [6],datain [10],datain [14],datain [18],datain [22],datain [26],datain [30],datain [34],datain [38],datain [42],datain [46],datain [50],datain [54],datain [58],datain [62]}=(B2)? 16'b1:16'b0;
//assign {datain [1],datain [5],datain [9] ,datain [13],datain [17],datain [21],datain [25],datain [29],datain [33],datain [37],datain [41],datain [45],datain [49],datain [53],datain [57],datain [61]}=(B1)? 16'b1:16'b0;
//assign {/*datain [0],datain [4],datain [8] ,*/datain [12],datain [16],datain [20],datain [24],datain [28],datain [32],datain [36],datain [40],datain [44],datain [48],datain [52],datain [56],datain [60]}=(B0)? 16'b1:16'b0;
assign datain [0]=B0;
assign datain [1]=B1;
assign datain [2]=B2;
assign datain [3]=B3;
assign datain [4]=B0;
assign datain [5]=B1;
assign datain [6]=B2;
assign datain [7]=B3;
assign datain [8]=B0;
assign datain [9]=B1;
assign datain [10]=B2;
assign datain [11]=B3;
assign datain [12]=B0;
assign datain [13]=B1;
assign datain [14]=B2;
assign datain [15]=B3;
assign datain [16]=B0;
assign datain [17]=B1;
assign datain [18]=B2;
assign datain [19]=B3;
assign datain [20]=B0;
assign datain [21]=B1;
assign datain [22]=B2;
assign datain [23]=B3;
assign datain [24]=B0;
assign datain [25]=B1;
assign datain [26]=B2;
assign datain [27]=B3;
assign datain [28]=B0;
assign datain [29]=B1;
assign datain [30]=B2;
assign datain [31]=B3;
assign datain [32]=B0;
assign datain [33]=B1;
assign datain [34]=B2;
assign datain [35]=B3;
assign datain [36]=B0;
assign datain [37]=B1;
assign datain [38]=B2;
assign datain [39]=B3;
assign datain [40]=B0;
assign datain [41]=B1;
assign datain [42]=B2;
assign datain [43]=B3;
assign datain [44]=B0;
assign datain [45]=B1;
assign datain [46]=B2;
assign datain [47]=B3;
assign datain [48]=B0;
assign datain [49]=B1;
assign datain [50]=B2;
assign datain [51]=B3;
assign datain [52]=B0;
assign datain [53]=B1;
assign datain [54]=B2;
assign datain [55]=B3;
assign datain [56]=B0;
assign datain [57]=B1;
assign datain [58]=B2;
assign datain [59]=B3;
assign datain [60]=B0;
assign datain [61]=B1;
assign datain [62]=B2;
assign datain [63]=B3;
assign datain [64]=B4;
assign datain [65]=B5;
assign datain [66]=B6;
assign datain [67]=B7;
assign datain [68]=B4;
assign datain [69]=B5;
assign datain [70]=B6;
assign datain [71]=B7;
assign datain [72]=B4;
assign datain [73]=B5;
assign datain [74]=B6;
assign datain [75]=B7;
assign datain [76]=B4;
assign datain [77]=B5;
assign datain [78]=B6;
assign datain [79]=B7;
assign datain [80]=B4;
assign datain [81]=B5;
assign datain [82]=B6;
assign datain [83]=B7;
assign datain [84]=B4;
assign datain [85]=B5;
assign datain [86]=B6;
assign datain [87]=B7;
assign datain [88]=B4;
assign datain [89]=B5;
assign datain [90]=B6;
assign datain [91]=B7;
assign datain [92]=B4;
assign datain [93]=B5;
assign datain [94]=B6;
assign datain [95]=B7;
assign datain [96]=B4;
assign datain [97]=B5;
assign datain [98]=B6;
assign datain [99]=B7;
assign datain [100]=B4;
assign datain [101]=B5;
assign datain [102]=B6;
assign datain [103]=B7;
assign datain [104]=B4;
assign datain [105]=B5;
assign datain [106]=B6;
assign datain [107]=B7;
assign datain [108]=B4;
assign datain [109]=B5;
assign datain [110]=B6;
assign datain [111]=B7;
assign datain [112]=B4;
assign datain [113]=B5;
assign datain [114]=B6;
assign datain [115]=B7;
assign datain [116]=B4;
assign datain [117]=B5;
assign datain [118]=B6;
assign datain [119]=B7;
assign datain [120]=B4;
assign datain [121]=B5;
assign datain [122]=B6;
assign datain [123]=B7;
assign datain [124]=B4;
assign datain [125]=B5;
assign datain [126]=B6;
assign datain [127]=B7;
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
endmodule 
//============================================================================================//
module decoder_4x16 (
    d_out, 
    d_in
    );
//-----------------------------------------------------------------------------------------//
input  [4:0]  d_in;
output [15:0] d_out;
//----------------------------------------------------------------------------------------//
parameter tmp = 16'b0000_0000_0000_0001;
//----------------------------------------------------------------------------------------//   
assign d_out = (d_in == 5'b10000) ? tmp   :
               (d_in == 5'b10001) ? tmp<<1:
               (d_in == 5'b10010) ? tmp<<2:
               (d_in == 5'b10011) ? tmp<<3:
               (d_in == 5'b10100) ? tmp<<4:
               (d_in == 5'b10101) ? tmp<<5:
               (d_in == 5'b10110) ? tmp<<6:
               (d_in == 5'b10111) ? tmp<<7:
               (d_in == 5'b11000) ? tmp<<8:
               (d_in == 5'b11001) ? tmp<<9:
               (d_in == 5'b11010) ? tmp<<10:
               (d_in == 5'b11011) ? tmp<<11:
               (d_in == 5'b11100) ? tmp<<12:
               (d_in == 5'b11101) ? tmp<<13:
               (d_in == 5'b11110) ? tmp<<14:
               (d_in == 5'b11111) ? tmp<<15: 
                    16'b0000_0000_0000_0000;
//-------------------------------------------------------------------------------//             
endmodule
//============================================================================================//
module MUX_128x1(
    input [6:0] s, 
    input [127:0] a,  
    output y
    );
//-----------------------------------------------------------------------// 
 assign y=(s==0)?  a[0] :
          (s==1)?  a[1] :
          (s==2)?  a[2] :
          (s==3)?  a[3] :
          (s==4)?  a[4] :
          (s==5)?  a[5] :
          (s==6)?  a[6] :
          (s==7)?  a[7] :
          (s==8)?  a[8] :
          (s==9)?  a[9] :
          (s==10)? a[10]:
          (s==11)? a[11]:
          (s==12)? a[12]:
          (s==13)? a[13]:
          (s==14)? a[14]:
          (s==15)? a[15]:
          (s==16)? a[16]:
          (s==17)? a[17]:
          (s==18)? a[18]:
          (s==19)? a[19]:          
          (s==20)? a[20]:
          (s==21)? a[21]:
          (s==22)? a[22]:
          (s==23)? a[23]:
          (s==24)? a[24]:
          (s==25)? a[25]:
          (s==26)? a[26]:
          (s==27)? a[27]:
          (s==28)? a[28]:
          (s==29)? a[29]:
          (s==30)? a[30]:
          (s==31)? a[31]:
          (s==32)? a[32]:
          (s==33)? a[33]:
          (s==34)? a[34]:
          (s==35)? a[35]:
          (s==36)? a[36]:
          (s==37)? a[37]:
          (s==38)? a[38]:
          (s==39)? a[39]:
          (s==40)? a[40]:
          (s==41)? a[41]:
          (s==42)? a[42]:
          (s==43)? a[43]:
          (s==44)? a[44]:
          (s==45)? a[45]:
          (s==46)? a[46]:
          (s==47)? a[47]:
          (s==48)? a[48]:
          (s==49)? a[49]:
          (s==50)? a[50]:
          (s==51)? a[51]:
          (s==52)? a[52]:
          (s==53)? a[53]:
          (s==54)? a[54]:
          (s==55)? a[55]:
          (s==56)? a[56]:
          (s==57)? a[57]:
          (s==58)? a[58]:
          (s==59)? a[59]:
          (s==60)? a[60]:
          (s==61)? a[61]:
          (s==62)? a[62]:
          (s==63)? a[63]:
          (s==64)? a[64]:
          (s==65)? a[65]:
          (s==66)? a[66]:
          (s==67)? a[67]:
          (s==68)? a[68]:
          (s==69)? a[69]:
          (s==70)? a[70]:
          (s==71)? a[71]:
          (s==72)? a[72]:
          (s==73)? a[73]:
          (s==74)? a[74]:
          (s==75)? a[75]:
          (s==76)? a[76]:
          (s==77)? a[77]:
          (s==78)? a[78]:
          (s==79)? a[79]:
          (s==80)? a[80]:
          (s==81)? a[81]:
          (s==82)? a[82]:
          (s==83)? a[83]:
          (s==84)? a[84]:
          (s==85)? a[85]:
          (s==86)? a[86]:
          (s==87)? a[87]:
          (s==88)? a[88]:
          (s==89)? a[89]:
          (s==90)? a[90]:
          (s==91)? a[91]:
          (s==92)? a[92]:
          (s==93)? a[93]:
          (s==94)? a[94]:
          (s==95)? a[95]:
          (s==96)? a[96]:
          (s==97)? a[97]:
          (s==98)? a[98]:
          (s==99)? a[99]:
          (s==100)? a[100]:
          (s==101)? a[101]:
          (s==102)? a[102]:
          (s==103)? a[103]:
          (s==104)? a[104]:
          (s==105)? a[105]:
          (s==106)? a[106]:
          (s==107)? a[107]:
          (s==108)? a[108]:
          (s==109)? a[109]:
          (s==110)? a[110]:
          (s==111)? a[111]:
          (s==112)? a[112]:
          (s==113)? a[113]:
          (s==114)? a[114]:
          (s==115)? a[115]:
          (s==116)? a[116]:
          (s==117)? a[117]:
          (s==118)? a[118]:
          (s==119)? a[119]:
          (s==120)? a[120]:
          (s==121)? a[121]:
          (s==122)? a[122]:
          (s==123)? a[123]:
          (s==124)? a[124]:
          (s==125)? a[125]:
          (s==126)? a[126]:
                    a[127];          
//-------------------------------------------------------------------------//
endmodule


