module VITERBIDECODER(
    Reset, 
    CLOCK, 
    Active, 
    Code, 
    DecodeOut,
    valid_out,
    valid_in,
    TB_enable,
    ACS_counter,
    TB_stop
    );
//-----------------------------------------------------------------------------------------//		       
input Reset; 
input CLOCK; 
input Active;
input [1:0] Code;
output DecodeOut;
output valid_out;
input valid_in;
output TB_enable;
output [3:0] ACS_counter;
output TB_stop;
//----------------------------------------------------------------------------------------//
// BMG
wire [15:0] Distance;    	
// Control Unit
wire [3:0] ACSSegment;            	
wire [5:0] ACSPage;			
wire Hold, Init,TB_EN,TB_stop;			
// ACS Unit
wire [27:0] Survivors;		
// Metric Memory
wire [95:0] MMPathMetric;
wire [47:0] MMMetric;
wire [2:0] MMReadAddress;
wire [3:0] MMWriteAddress;
wire MMBlockSelect;
wire[6:0] a_least,b_least;
wire[6:0] least;
reg valid_in_reg;
// Survivoir Memory
wire RE;
wire[7:0] TB_least,re_state;
wire[5:0] re_page;
wire valid_out_survivor;
// Traceback unit
//---------------------------------------------------------------------------------------------------//
assign ACS_counter=ACSSegment;
assign TB_enable=TB_EN; 
//---------------------------------------------------------------------------------------------------//
control ctl (Reset, CLOCK, Active,  ACSPage, ACSSegment, Hold, Init, TB_EN ,TB_stop);
BMG bmg (ACSSegment, Code, Distance); 
ACSUNIT acs (Reset, CLOCK, Active, Hold, ACSSegment, Distance, Survivors,MMReadAddress, MMWriteAddress, MMBlockSelect, MMMetric, MMPathMetric);
//----------------------------------------------------------------------------------------------------//
METRICMEMORY metric_memory (
    .Reset(Reset), 
    .Clock1(CLOCK), 
    .Active(valid_in_reg), 
    .MMBlockSelect(MMBlockSelect), 
    .MMMetric(MMMetric), 
    .MMWriteAddress(MMWriteAddress), 
    .MMReadAddress(MMReadAddress), 
    .Page(ACSPage),
    .MMPathMetric(MMPathMetric), 
    .a_least(a_least), 
    .b_least(b_least),
	 .least(least)
);
//-----------------------------------------------------------------------------------------------------//
 ram_survivor_decoder_wifi survivor_memory (
    .clk(CLOCK), 
    .reset(Reset), 
    .data_in(Survivors), 
    .page(ACSPage), 
    .WR(valid_in_reg), 
    .enable(valid_in_reg), 
    .RE(RE),
    .re_page(re_page),
    .re_state(re_state),
    .valid_out(valid_out_survivor),
    .least(TB_least)
    );
//----------------------------------------------------------------------------------------------------//
traceback_decoder_wifi tbu (
    .clk(CLOCK), 
    .reset(Reset), 
    .valid_in(TB_EN), 
    .WE_in(valid_out_survivor),
    .least_PM(least), 
    .least_SM(TB_least),
    .read_enable(RE), 
    .address_read(re_state), 
    .re_page(re_page),
    .decoded_data(DecodeOut), 
    .valid_out(valid_out)
    );
//-------------------------------------------------------------------------------------------------//
always @ (posedge CLOCK or negedge Reset)
begin
    if (!Reset)
    begin
        valid_in_reg<=0;
    end
    else
    begin
        valid_in_reg<=valid_in;
    end
end
  
endmodule
