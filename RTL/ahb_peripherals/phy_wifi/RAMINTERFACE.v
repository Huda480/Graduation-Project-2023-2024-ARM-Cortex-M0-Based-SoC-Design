module RAMINTERFACE (
    Reset, 
    Clock2, 
    Hold, 
    ACSSegment, 
    Metric, 
    PathMetric,
    MMReadAddress, 
    MMWriteAddress, 
    MMBlockSelect, 
    MMMetric, 
    MMPathMetric
    );
//--------------------------------------------------------------------------------------------//
// ACS Unit interface
input Reset;
input Clock2; 
input Hold;
input [3:0] ACSSegment;
input [47:0] Metric;
input [95:0] MMPathMetric;
output [95:0] PathMetric;
// Metric Memory interface
output [47:0] MMMetric;
output [2:0] MMReadAddress;
output [3:0] MMWriteAddress;
output MMBlockSelect;
//--------------------------------------------------------------------------------------------------//
reg [2:0] MMReadAddress;
reg MMBlockSelect;
//-------------------------------------------------------------------------------------------------//
always @(ACSSegment or Reset) 
    if (~Reset) MMReadAddress <= 0;
    else MMReadAddress <= ACSSegment [3:1];

always @(posedge Clock2 or negedge Reset)
begin
    if (~Reset) MMBlockSelect <=0;
    else if (Hold) MMBlockSelect <= ~MMBlockSelect;
end
//-------------------------------------------------------------------------------------------------//
assign PathMetric = MMPathMetric;
assign MMMetric = Metric;
assign MMWriteAddress = ACSSegment;  
endmodule
