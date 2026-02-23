module control (
    Reset, 
    CLOCK, 
    Active, 
    ACSPage, 
    ACSSegment, 
    Hold, 
    Init, 
    TB_EN , 
    TB_stop
    );
//----------------------------------------------------------------------------------------------//
input Reset; 
input CLOCK; 
input Active;
output [5:0] ACSPage;
output [3:0] ACSSegment;
output Hold;
output Init;
output TB_EN;
output TB_stop;
//--------------------------------------------------------------------------------------------//
reg [3:0] ACSSegment;
reg [5:0] ACSPage;
reg Init,Hold;
wire EVENT_1,EVENT_0;
reg TB_EN;
reg TB_en;
reg TB_stop;
//--------------------------------------------------------------------------------------------//
assign EVENT_1 = (ACSSegment == 14);
assign EVENT_0 = (ACSSegment == 15);
//-------------------------------------------------------------------------------------------//
always @(posedge CLOCK or negedge Reset)
begin
    if (~Reset) 
    begin
        {ACSPage,ACSSegment} <= 'hFFFFF;
        Init <=0;
        Hold <= 0;
        TB_EN <= 0;
        TB_en <= 0;
        TB_stop <=0;
    end     
    else if (Active) 
    begin
        TB_EN <= TB_en;
        {ACSPage,ACSSegment} <= {ACSPage,ACSSegment} + 1;  
        if (EVENT_1) 
        begin 
            Init <= 0; 
            Hold <= 1; 
        end 
        else if (EVENT_0) 
        begin 
            Init <= 1; 
            Hold <= 0; 
        end 
        else 
        begin 
            {Init,Hold} <= 0; 
        end
        if ((ACSSegment == 14) && (ACSPage == 63)) TB_en <= 1;
        if(ACSPage==63) TB_stop<=1;
        else TB_stop<=0;
    end
end
//--------------------------------------------------------------------------------------//

endmodule
