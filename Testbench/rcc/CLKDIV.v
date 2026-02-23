module CLKDIV #(parameter width=6) (
  input REF_CLK,RST,
  input [width-1:0] DIV_RATIO,
  output reg  OUT_CLK);
  
  wire CLK_DIV_EN;
  wire [width-2:0] divide;
  reg [width-2:0] counter='b0;
  reg div_clk=1'b1;
  wire half_done;
  wire done;
  wire [width-1:0] EVEN_RATIO; //We can only accept even dividers
  //If division ration is odd we remove the most significant bit and change the value to even
  
  assign CLK_DIV_EN = (DIV_RATIO !=1'b0) && (DIV_RATIO !=1'b1); //0 and 1 dividers are not accepter
  assign divide = DIV_RATIO[width-1:1]; //Half division ratio
  assign EVEN_RATIO = {DIV_RATIO[width-1:1],1'b0}; //Changing div_ratio to even
  assign half_done = (counter == (divide-1)); 
  assign done = (counter == (EVEN_RATIO -1));
    
    always @(*)
    begin
      if(CLK_DIV_EN)
        OUT_CLK = div_clk;
      else
        OUT_CLK = REF_CLK;
    end
      
    always @(posedge REF_CLK or negedge RST)
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
            counter <=counter+1;
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