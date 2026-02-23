module ACS (
    Distance1, 
    Distance0, 
    PathMetric1, 
	PathMetric0, 
	Survivor, 
	Metric0,
	Metric1
	);
//-------------------------------------------------------------------------------------------------------------------------------//
input [1:0] Distance1;
input [1:0] Distance0;
input [5:0] PathMetric1;
input [5:0] PathMetric0;
output Survivor;
output [5:0] Metric0;
output [5:0] Metric1;
//-------------------------------------------------------------------------------------------------------------------------------//
wire [5:0] ADD0, ADD1;
wire Survivor;
wire [5:0] Temp_Metric, Metric;
//-------------------------------------------------------------------------------------------------------------------------------//
assign ADD0 =  PathMetric0;
assign ADD1 =  PathMetric1;
COMPARATOR C1(ADD1, ADD0, Survivor);
assign Temp_Metric = (Survivor)? ADD1: ADD0;
assign Metric0 =Distance0 +Temp_Metric;
assign Metric1 =Distance1 +Temp_Metric;
endmodule


 