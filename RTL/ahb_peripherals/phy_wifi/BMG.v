module BMG (
    ACSSegment, 
    Code, 
    Distance
    );
//---------------------------------------------------------------------------------------------------//
input [3:0] ACSSegment;
input [1:0] Code;
output [15:0] Distance;
//--------------------------------------------------------------------------------------------------//
wire  [6:0] PolyA, PolyB; 
wire [6:0] B0,B1,B2,B3,B4,B5,B6,B7;    				      
wire [1:0] G0,G1,G2,G3,G4,G5,G6,G7;   				   
wire [1:0] D0,D1,D2,D3,D4,D5,D6,D7;   
//-------------------------------------------------------------------------------------------------//
assign PolyA = 7'b1_101_101;  
assign PolyB = 7'b1_001_111; 
assign B0 = {ACSSegment,3'b000};  
assign B1 = {ACSSegment,3'b001};   
assign B2 = {ACSSegment,3'b010};
assign B3 = {ACSSegment,3'b011};
assign B4 = {ACSSegment,3'b100};
assign B5 = {ACSSegment,3'b101};
assign B6 = {ACSSegment,3'b110};
assign B7 = {ACSSegment,3'b111};
assign Distance = {D7,D6,D5,D4,D3,D2,D1,D0}; 
//---------------------------------------------------------------------------------------------------//
ENC EN0(PolyA,PolyB,B0,G0);  
ENC EN1(PolyA,PolyB,B1,G1);
ENC EN2(PolyA,PolyB,B2,G2);
ENC EN3(PolyA,PolyB,B3,G3);	
ENC EN4(PolyA,PolyB,B4,G4); 
ENC EN5(PolyA,PolyB,B5,G5); 
ENC EN6(PolyA,PolyB,B6,G6);
ENC EN7(PolyA,PolyB,B7,G7); 	
//----------------------------------------------------------------------------------------------------//      
HARD_DIST_CALC HD0(Code,G0,D0);   
HARD_DIST_CALC HD1(Code,G1,D1);   
HARD_DIST_CALC HD2(Code,G2,D2); 
HARD_DIST_CALC HD3(Code,G3,D3); 
HARD_DIST_CALC HD4(Code,G4,D4); 
HARD_DIST_CALC HD5(Code,G5,D5); 
HARD_DIST_CALC HD6(Code,G6,D6); 
HARD_DIST_CALC HD7(Code,G7,D7);      
endmodule


 