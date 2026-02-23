#include "uart_driver.h"




/*
 desc :  Returns whether the RX buffer is full
 args : *UART , A pointer to the  uart_typedef structure representing the UART interface.
 return : RxBufferFull 
 */

uint32_t uart_rx_state_full( uart_typedef *UART)
{
      return ((UART->STATE & UART_STATE_RX_BF_Msk)>> UART_STATE_RX_BF_Pos);
}





/*
 desc :  Returns whether the TX buffer is full.
 args : *UART Pointer
 return :TxBufferFull
 */

uint32_t uart_tx_state_full( uart_typedef *UART)
{
      return ((UART->STATE & UART_STATE_TX_BF_Msk)>> UART_STATE_TX_BF_Pos);
}





/*
 desc :  returns the current overrun status of both the RX & TX buffers.
 args :  *UART Pointer
 return 0 : - No overrun
 return 1 : - TX overrun
 return 2 : - RX overrun
 return 3 : - TX & RX overrun
 */

uint32_t uart_overrun_status( uart_typedef *UART)
{
      return ((UART->STATE & (UART_CTRL_RX_OV_IRQ_EN_Msk | UART_CTRL_TX_OV_IRQ_EN_Msk))>>UART_CTRL_TX_OV_IRQ_EN_Pos);
}





/*
 desc :  Clears the overrun status of both the RX & TX buffers and then returns the current overrun status.
 args :  *UART Pointer
 return 0 : - No overrun
 return 1 : - TX overrun
 return 2 : - RX overrun
 return 3 : - TX & RX overrun
 */

uint32_t uart_clear_overrun_status( uart_typedef *UART)
{
      UART->STATE = (UART_CTRL_TX_OV_IRQ_EN_Msk | UART_CTRL_RX_OV_IRQ_EN_Msk);
      return ((UART->STATE & (UART_CTRL_TX_OV_IRQ_EN_Msk | UART_CTRL_RX_OV_IRQ_EN_Msk)) >> UART_CTRL_TX_OV_IRQ_EN_Pos);
}





/*
 desc :  Returns the current UART Baud rate divider.
 args :  *UART Pointer
 return : BaudDiv
 */

uint32_t uart_get_bauddivider( uart_typedef *UART)
{
      return UART->BAUDDIV;
}

/*
 desc :  Set the current UART Baud rate divider.
 args :  *UART Pointer
 args :  divider , The value to which the UART baud rate divider is to be set
 return : none
 */


void uart_set_bauddivider( uart_typedef *UART, uint32_t divider)
{
UART->BAUDDIV = divider;
}





/*
 desc :  Returns the TX interrupt status.
 args : *UART Pointer
 return : TXStatus
 */

uint32_t uart_tx_irq_status( uart_typedef *UART)
{
      return ((UART->INTSTATUS & UART_INTCLEAR_TX_IRQ_Msk ) >> UART_INTCLEAR_TX_IRQ_Pos);
}





/*
 desc :  Returns the RX interrupt status.
 args : *UART Pointer
 return : RXStatus
 */

uint32_t uart_rx_irq_status( uart_typedef *UART)
{
      return ((UART->INTSTATUS & UART_INTCLEAR_RX_IRQ_Msk) >>UART_INTCLEAR_RX_IRQ_Pos);
}





/*
 desc :  Clears the TX buffer full interrupt status. 
 args : *UART Pointer
 return : none
 */

void uart_clear_tx_irq( uart_typedef *UART)
{
      UART->INTCLEAR = UART_INTCLEAR_TX_IRQ_Msk;
}





/**
 desc :  Clears the RX interrupt status.
 args : *UART Pointer
 return : none
 */

void uart_clear_rx_irq( uart_typedef *UART)
{
      UART->INTCLEAR = UART_INTCLEAR_RX_IRQ_Msk;
}





/*
 desc : Initialises the UART specifying the UART Baud rate divider value and whether the send and recieve functionality is enabled. It also specifies which of the various interrupts are enabled.
 args : *UART Pointer
 args :   UART_Configuration a structure that contains the follow :
       ( divider : The value to which the UART baud rate divider is to be set
         tx_en :  Defines whether the UART transmit is to be enabled
         rx_en :  Defines whether the UART receive is to be enabled
         tx_irq_en : Defines whether the UART transmit buffer full interrupt is to be enabled
         rx_irq_en : Defines whether the UART receive buffer full interrupt is to be enabled
         tx_ovrirq_en : Defines whether the UART transmit buffer overrun interrupt is to be enabled
         rx_ovrirq_en : Defines whether the UART receive buffer overrun interrupt is to be enabled
 return : 1 if initialisation failed, 0 if successful.
 */

uint32_t uart_config( uart_typedef *UART,  uart_configuration *CONFIG)
{
      uint32_t new_ctrl=0;

      if (CONFIG->tx_en!=0)        new_ctrl |= UART_CTRL_TX_EN_Msk;
      if (CONFIG->rx_en!=0)        new_ctrl |= UART_CTRL_RX_EN_Msk;
      if (CONFIG->tx_irq_en!=0)    new_ctrl |= UART_CTRL_TX_IRQ_EN_Msk;
      if (CONFIG->rx_irq_en!=0)    new_ctrl |= UART_CTRL_RX_IRQ_EN_Msk;
      if (CONFIG->tx_ovrirq_en!=0) new_ctrl |= UART_CTRL_TX_OV_IRQ_EN_Msk;
      if (CONFIG->rx_ovrirq_en!=0) new_ctrl |= UART_CTRL_RX_OV_IRQ_EN_Msk;
      if (CONFIG->dma_mode!=0)     new_ctrl |= (1 << 7);
      if (CONFIG->tx_fifo_mode!=0)     new_ctrl |= (1 << 8);
      if (CONFIG->rx_fifo_mode!=0)     new_ctrl |= (1 << 9);

      UART->CTRL = 0;         
      UART->BAUDDIV = CONFIG->divider;
      UART->CTRL = new_ctrl;  

      if((UART->STATE & (UART_CTRL_TX_OV_IRQ_EN_Msk | UART_CTRL_RX_OV_IRQ_EN_Msk))) return 1;
      else return 0;
}





/*
 desc : Sends a character to the TX buffer for transmission.
 args : *UART Pointer
 args : txchar Character to be sent
 return : none
 */

void uart_send_char( uart_typedef *UART, char txchar)   
{
      UART->DATA = (uint32_t)txchar;
}





/*
 desc : returns the character from the RX buffer which has been received.
 args : *UART Pointer
 return : rxchar
 */

char uart_receive_char( uart_typedef *UART)  
{
      return (char)(UART->DATA);
}
