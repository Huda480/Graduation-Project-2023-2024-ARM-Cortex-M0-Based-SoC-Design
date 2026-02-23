//==========================================================================================
// Purpose: Address and select decoder
// Used in: cmsdk_apb_subsystem
//==========================================================================================
module APB_decoder 
#(
  parameter int Include_dual_timer = 1, 
  parameter int Include_SPI = 1
) 
  (
    input PSEL,
    input [3:0] PADDR,  
    output reg UART0_PSEL, WDOG_PSEL, TIMER_PSEL, DUAL_TIMER_PSEL,UART1_PSEL,SPI_PSEL
  );


always_comb
begin
  UART0_PSEL = 'b0 ;
  WDOG_PSEL = 'b0 ;
  TIMER_PSEL = 'b0 ;
  DUAL_TIMER_PSEL = 'b0 ;
  SPI_PSEL  = 'b0;
  UART1_PSEL = 'b0 ;
  if(PSEL)
  begin
    case(PADDR)
        4'b0000 : UART0_PSEL = 'b1 ;
        4'b0001 : WDOG_PSEL = 'b1 ;
        4'b0010 : TIMER_PSEL = 'b1 ;
        4'b0100 : UART1_PSEL = 'b1 ;
        4'b0101 : begin
          if(Include_dual_timer)
          DUAL_TIMER_PSEL = 'b1;
          else
          DUAL_TIMER_PSEL = 'b0;
        end

        4'b0011 : begin
          if(Include_SPI)
          SPI_PSEL = 'b1;
          else
          SPI_PSEL = 'b0;
        end

        default :
        begin
          UART0_PSEL = 'b0 ;
          WDOG_PSEL = 'b0 ;
          UART1_PSEL = 'b0 ;
          TIMER_PSEL = 'b0 ;
          DUAL_TIMER_PSEL = 'b0 ;
          SPI_PSEL  = 'b0;
        end
    endcase
  end
  else
  begin
    UART0_PSEL = 'b0 ;
    UART1_PSEL = 'b0 ;
    WDOG_PSEL = 'b0 ;
    TIMER_PSEL = 'b0 ;
    DUAL_TIMER_PSEL = 'b0 ;
    SPI_PSEL  = 'b0;
  end

end

endmodule