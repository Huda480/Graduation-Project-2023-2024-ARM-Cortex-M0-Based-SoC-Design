module CLKDIV 
#(
  parameter int width=6
) 
(
  //============================================================================
  // I/Os
  //============================================================================
    //==========================================================================
    // Clocks & Resets
    //==========================================================================
    input wire logic REF_CLK,RST,
    //==========================================================================
    // Control signals
    //==========================================================================  
    input wire logic [width-1:0] DIV_RATIO,
    //==========================================================================
    // Output
    //==========================================================================
    output wire  OUT_CLK);
  
  logic [width-2:0] counter;
  logic div_clk;
  wire CLK_DIV_EN;
  wire [width-2:0] divide;
  wire half_done;
  wire done;
  wire [width-1:0] EVEN_RATIO; //We can only accept even dividers
  wire out_clock_internal;
  //If division ration is odd we remove the most significant bit and change the value to even
  
  assign CLK_DIV_EN = (DIV_RATIO !=1'b0) && (DIV_RATIO !=1'b1); //0 and 1 dividers are not accepter
  assign divide = DIV_RATIO[width-1:1]; //Half division ratio
  assign EVEN_RATIO = {DIV_RATIO[width-1:1],1'b0}; //Changing div_ratio to even
  assign half_done = (counter == (divide-1)); 
  assign done = (counter == (EVEN_RATIO -1));
  assign out_clock_internal = (CLK_DIV_EN) ? div_clk:REF_CLK ;
  assign OUT_CLK = out_clock_internal;
  //BUFG clock_buffer (OUT_CLK,out_clock_internal);
  
      
    always_ff @(posedge REF_CLK or negedge RST)
    begin
      if(!RST)
        begin
          counter <='b0;
          div_clk <=1'b1;
        end 
      else if(CLK_DIV_EN)
        begin
          if(half_done)
          begin
              counter <=counter + 1'b1;
              div_clk <= !div_clk;
          end
          else if(done)
            begin
              div_clk <= !div_clk;
              counter <= 'b0;
            end
          else if (counter > (EVEN_RATIO -1'b1))
          begin
              counter <= 'b0;
              div_clk <= !div_clk;
          end
          else
          begin
              counter <=counter+1;
          end
        end
    end
endmodule