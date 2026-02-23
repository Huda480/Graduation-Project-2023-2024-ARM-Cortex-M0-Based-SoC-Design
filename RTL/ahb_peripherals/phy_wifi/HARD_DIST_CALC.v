module HARD_DIST_CALC (
    InputSymbol, 
    BranchOutput, 
    OutputDistance
    );
//----------------------------------------------------------------------//
input [1:0] InputSymbol; 
input [1:0] BranchOutput; 
output reg [1:0] OutputDistance;
//---------------------------------------------------------------------//
wire MS,LS;
//--------------------------------------------------------------------//
assign MS = (InputSymbol[1] ^ BranchOutput[1]);
assign LS = (InputSymbol[0] ^ BranchOutput[0]);
//--------------------------------------------------------------------//
always @(MS or LS )
begin
    OutputDistance[1] <= (MS & LS) ;    
    OutputDistance[0] <= MS ^LS;    
end

endmodule

