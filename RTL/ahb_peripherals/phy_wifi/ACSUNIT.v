module ACSUNIT (
    Reset, 
    Clock, 
    Active, 
    Hold, 
  	ACSSegment, 
  	Distance, 
  	Survivors,  
    MMReadAddress, 
    MMWriteAddress, 
    MMBlockSelect, 
    MMMetric, 
    MMPathMetric
    );
//-------------------------------------------------------------------------------------------------------------------------//
input Reset; 
input Clock; 
input Active; 
input Hold;
input [3:0] ACSSegment;
input [15:0] Distance;
// to Survivor Memory
output [27:0] Survivors;
// to Metric Memory
output [2:0] MMReadAddress;
output [3:0] MMWriteAddress;
output MMBlockSelect;
output [47:0] MMMetric;
// from Metric Memory
input [95:0] MMPathMetric;
//---------------------------------------------------------------------------------------------------------------------------//
// BMG interface
wire [1:0] Distance7,Distance6,Distance5,Distance4,Distance3,Distance2,Distance1,Distance0;
// Metric Memory interface
wire [47:0] Metric;
wire [5:0] Metric0, Metric1, Metric2, Metric3,Metric4, Metric5, Metric6, Metric7;
wire [95:0] PathMetric;
wire [5:0] PathMetric7,PathMetric6,PathMetric5,PathMetric4,PathMetric3,PathMetric2,PathMetric1,PathMetric0;
wire ACSData0,ACSData1,ACSData2,ACSData3;
//--------------------------------------------------------------------------------------------------------------------------//
assign {Distance7,Distance6,Distance5,Distance4,Distance3,Distance2,Distance1,Distance0} = Distance;
assign PathMetric0 =(ACSSegment[0])? PathMetric[29:24]:PathMetric[5:0];
assign PathMetric1 =(ACSSegment[0])? PathMetric[35:30]:PathMetric[11:6];
assign PathMetric2 =(ACSSegment[0])? PathMetric[41:36]:PathMetric[17:12];
assign PathMetric3 =(ACSSegment[0])? PathMetric[47:42]:PathMetric[23:18];
assign PathMetric4 =(ACSSegment[0])? PathMetric[77:72]:PathMetric[53:48];
assign PathMetric5 =(ACSSegment[0])? PathMetric[83:78]:PathMetric[59:54];
assign PathMetric6 =(ACSSegment[0])? PathMetric[89:84]:PathMetric[65:60];
assign PathMetric7 =(ACSSegment[0])? PathMetric[95:90]:PathMetric[71:66];
assign Metric = {Metric7, Metric6, Metric5, Metric4,Metric3, Metric2, Metric1, Metric0};
assign Survivors = {ACSData3,ACSSegment,2'b11,ACSData2,ACSSegment,2'b10,ACSData1,ACSSegment,2'b01,ACSData0,ACSSegment,2'b00};
//------------------------------------------------------------------------------------------------------------------------//
ACS acs0 (Distance1,Distance0,PathMetric4,PathMetric0,ACSData0, Metric0,Metric1);
ACS acs1 (Distance3,Distance2,PathMetric5,PathMetric1,ACSData1, Metric2,Metric3);
ACS acs2 (Distance5,Distance4,PathMetric6,PathMetric2,ACSData2, Metric4,Metric5);
ACS acs3 (Distance7,Distance6,PathMetric7,PathMetric3,ACSData3, Metric6,Metric7);
//----------------------------------------------------------------------------------------------------------------------//
RAMINTERFACE ri (Reset, Clock, Hold, ACSSegment, Metric, PathMetric,MMReadAddress, MMWriteAddress, MMBlockSelect, MMMetric,MMPathMetric);
endmodule


 
  
