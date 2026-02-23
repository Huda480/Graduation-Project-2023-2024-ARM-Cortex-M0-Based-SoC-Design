module ENC (
    PolyA, 
    PolyB,
    BranchID, 
    EncOut
    );
//------------------------------------------------------------------------------------//
input [6:0] PolyA,PolyB;
input [6:0] BranchID;
output [1:0] EncOut;
//------------------------------------------------------------------------------------//
wire [6:0] wA, wB;
//-----------------------------------------------------------------------------------//
assign wA = PolyA & BranchID;
assign wB = PolyB & BranchID;
assign EncOut[1] = wA[0]^wA[1]^wA[2]^wA[3]^wA[4]^wA[5]^wA[6]; 
assign EncOut[0] = wB[0]^wB[1]^wB[2]^wB[3]^wB[4]^wB[5]^wB[6]; 

endmodule 