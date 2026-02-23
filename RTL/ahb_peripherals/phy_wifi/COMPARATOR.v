module COMPARATOR (
    Metric1, 
    Metric0, 
    Survivor
    );
//------------------------------------------------------------------------------------------------------//
input [5:0] Metric1;
input [5:0] Metric0;
output Survivor;
//-----------------------------------------------------------------------------------------------------//
assign Survivor = (Metric1  > Metric0 )? 0:1;
endmodule
