module RESET_SYNC #(parameter NUM_STAGES = 2) (
  input                    RESET ,
  input                    CLK ,
  output  reg              SYNC_RESET 
  );
  
  reg    [NUM_STAGES - 2 : 0]    shifter ;
  integer i;
  
  always@(posedge CLK or negedge RESET)
  begin
    if(!RESET)
      begin
        SYNC_RESET <= 1'b0 ;
        shifter <= 'b0 ;
      end
    else
      begin
        shifter[0] <= RESET ;
        for(i=1;i<NUM_STAGES-1;i=i+1)
        begin
          shifter[i] <= shifter[i-1] ;
        end
        SYNC_RESET <= shifter[NUM_STAGES-2] ;
      end
    end
  endmodule
       
  
