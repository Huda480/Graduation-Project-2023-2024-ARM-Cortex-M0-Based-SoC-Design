module METRICMEMORY(
    input Reset, 
    input Clock1, 
    input Active, 
    input MMBlockSelect,
    input [47:0] MMMetric,
    input [3:0] MMWriteAddress,
    input [2:0] MMReadAddress,
    input [5:0] Page,
    output [95:0] MMPathMetric,
    output reg[6:0] a_least,
    output reg[6:0] b_least,
    output [6:0] least
    );
//--------------------------------------------------------------------------------------------------------------------//
wire flag,page_no;
reg[0:5] tempa_least;
reg[0:5] tempb_least;
// Interfaces with Memblock
wire [6:0] write1,write2,write3,write4,write5,write6,write7,write8,S;
wire [3:0] read1,read2;
wire [95:0] MMPathMetricA,MMPathMetricB;
wire [5:0] M;
//-------------------------------------------------------------------------------------------------------------------//
Memblock Memory_A(
.clk(Clock1),            
.reset(Reset), 
.MMMetric(MMMetric),
.write1(MMWriteAddress),
.read1(read1),
.read2(read2),
.rw(!MMBlockSelect),
.MMPathMetric(MMPathMetricA)
);
//--------------------------------------------------------------------------------------------------------------//
Memblock Memory_B(
.clk(Clock1),            
.reset(Reset), 
.MMMetric(MMMetric),
.write1(MMWriteAddress),
.read1(read1),
.read2(read2),
.rw(MMBlockSelect),
.MMPathMetric(MMPathMetricB)
);
//-------------------------------------------------------------------------------------------------------//
Pick_Lowest Metric_Select(
.M0(MMMetric[5:0]),
.M1(MMMetric[11:6]),
.M2(MMMetric[17:12]),
.M3(MMMetric[23:18]),
.M4(MMMetric[29:24]),
.M5(MMMetric[35:30]),
.M6(MMMetric[41:36]),
.M7(MMMetric[47:42]),
.S0(write1),
.S1(write2),
.S2(write3),
.S3(write4),
.S4(write5),
.S5(write6),
.S6(write7),
.S7(write8),
.M(M),
.S(S)
 );
//-------------------------------------------------------------------------------------------------------//
M2x1 Path_mux(
.PathA(MMPathMetricA),
.PathB(MMPathMetricB),
.S_line({page_no,MMBlockSelect}),
.Path_out(MMPathMetric)
);
//-------------------------------------------------------------------------------------------------------//    
assign read1={1'b0,MMReadAddress};
assign read2=8+MMReadAddress;
assign page_no=Page[0] | Page[1] | Page[2] | Page[3] | Page[4] | Page[5] ; 
assign write1=8*MMWriteAddress;
assign write2=8*MMWriteAddress+1;
assign write3=8*MMWriteAddress+2;
assign write4=8*MMWriteAddress+3;
assign write5=8*MMWriteAddress+4;
assign write6=8*MMWriteAddress+5;
assign write7=8*MMWriteAddress+6;
assign write8=8*MMWriteAddress+7;
//----------------------------------------------------------------------------------------------------------//
assign least= (tempa_least==6'hff) ? b_least : a_least;
assign flag=Active;
//--------------------------------------------------------------------------------------------------------//
always @ ( posedge Clock1 )
begin
    if (Reset==0)
    begin
        a_least<=0;
		b_least<=0;
	    tempa_least<=6'hff;
	    tempb_least<=6'hff; 
    end
    else if (Active==1)
    begin
        if (MMBlockSelect==0)
	    begin  
	       tempb_least<=6'hff;
	       if (tempa_least>M)
           begin
            tempa_least<=M;
            a_least<=S;
           end					 
	    end
//----------------------------------------------------------------------------------------------------------------------//					 
        else
        begin
       	    tempa_least<=6'hff;
       	    if (tempb_least>M)
            begin
                tempb_least<=M;
                b_least<=S;
            end                     
        end	
    end        
end
//---------------------------------------------------------------------------------------------------------------------------------------//
        
endmodule

//=======================================================================================================================================//
module Memblock (
    input clk,            //the clock of the input signal
    input reset , 
    input [47:0] MMMetric,
    input [3:0]  write1, 
    input [3:0] read1,
    input [3:0] read2,
    input rw,
    output [95:0] MMPathMetric
    );
//-----------------------------------------------------------------------------------------------------------------------------//
reg [47:0] M_REG_A [15:0];
//----------------------------------------------------------------------------------------------------------------------------//
always @ (posedge clk )
begin
    if(rw)
        M_REG_A [write1] <= MMMetric;
end 
//----------------------------------------------------------------------------------------------------------------------------//
 assign MMPathMetric= {M_REG_A[read2],M_REG_A[read1]};
//-------------------------------------------------------------------------------------------------------------------//
endmodule
//===========================================================================================================================//
module Pick_Lowest(
    input [5:0] M0,
    input [5:0] M1,
    input [5:0] M2,
    input [5:0] M3,
    input [5:0] M4,
    input [5:0] M5,
    input [5:0] M6,
    input [5:0] M7,
    input [6:0] S0,
    input [6:0] S1,
    input [6:0] S2,
    input [6:0] S3,
    input [6:0] S4,
    input [6:0] S5,
    input [6:0] S6,
    input [6:0] S7,
    output [5:0] M,
    output [6:0] S
    );
//----------------------------------------------------------------------------------------------------------------------------//
// First Stage
wire [5:0] M00,M01,M02,M03;
wire [6:0] S00,S01,S02,S03;
wire Sr00,Sr01,Sr02,Sr03;
// Second Stage
wire [5:0] M10,M11;
wire [6:0] S10,S11;
wire Sr10,Sr11,Sr;
//------------------------------------------------------------------------------------------------------------------------------//
COMPARATOR C00 (M1, M0, Sr00);
assign M00 = (Sr00)? M1: M0;
assign S00 = (Sr00)? S1: S0;
COMPARATOR C01 (M3, M2, Sr01);
assign M01 = (Sr01)? M3: M2;
assign S01 = (Sr01)? S3: S2;
COMPARATOR C02 (M5, M4, Sr02);
assign M02 = (Sr02)? M5: M4;
assign S02 = (Sr02)? S5: S4;
COMPARATOR C03 (M7, M6, Sr03);
assign M03 = (Sr03)? M7: M6;
assign S03 = (Sr03)? S7: S6;    
//----------------------------------------------------------//
COMPARATOR C10 (M01, M00, Sr10);
assign M10 = (Sr10)? M01: M00;
assign S10 = (Sr10)? S01: S00;
COMPARATOR C11 (M03, M02, Sr11);
assign M11 = (Sr11)? M03: M02;
assign S11 = (Sr11)? S03: S02;
//--------------------------------------------------------//
COMPARATOR C (M11, M10, Sr);
assign M = (Sr)? M11: M10;
assign S = (Sr)? S11: S10;
//-------------------------------------------------------//
endmodule
//==================================================================================================//
module M2x1(
    PathA,
    PathB,
    S_line,
    Path_out
    );
//-------------------------------------------------------------------------------------------//
input [95:0] PathA;
input [95:0] PathB;
input [1:0] S_line;
output [95:0] Path_out;
//-----------------------------------------------------------------------------------------//
assign Path_out= (S_line==0)? 96'b0:
                 (S_line==1)? 96'b0:
                 (S_line==2)? PathB :
                              PathA ;
endmodule   
