#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h" 

#include "system_macros.h"

#include <stdio.h>
#include <string.h>
#include <stdarg.h> 
#include "stdbool.h"


//Register layering of uart

typedef struct 
{
  __IO   uint32_t  DATA;          //Offset: 0x000 Data Register    (R/W) 
  __IO   uint32_t  STATE;         // Offset: 0x004 Status Register  (R/W) 
  __IO   uint32_t  CTRL;          // Offset: 0x008 Control Register (R/W) 
  union {
    __I    uint32_t  INTSTATUS;   // Offset: 0x00C Interrupt Status Register (R/ ) 
    __O    uint32_t  INTCLEAR;    // Offset: 0x00C Interrupt Clear Register ( /W) 
    };
  __IO   uint32_t  BAUDDIV;       // Offset: 0x010 Baudrate Divider Register (R/W) 

}  uart_typedef;

typedef struct 
{
  uint32_t divider;
  uint32_t tx_en;
  uint32_t rx_en;
  uint32_t tx_irq_en;
  uint32_t rx_irq_en;
  uint32_t tx_ovrirq_en;
  uint32_t rx_ovrirq_en;
  bool dma_mode;
  bool tx_fifo_mode;
  bool rx_fifo_mode;
}  uart_configuration;

/*
 desc :  Returns whether the RX buffer is full
 args : *UART , A pointer to the  uart_typedef structure representing the UART interface.
 return : RxBufferFull 
 */

uint32_t uart_rx_state_full( uart_typedef *UART);

/*
 desc :  Returns whether the TX buffer is full.
 args : *UART Pointer
 return :TxBufferFull
 */

uint32_t uart_tx_state_full( uart_typedef *UART);

/*
 desc :  returns the current overrun status of both the RX & TX buffers.
 args :  *UART Pointer
 return 0 : - No overrun
 return 1 : - TX overrun
 return 2 : - RX overrun
 return 3 : - TX & RX overrun
 */

uint32_t uart_overrun_status( uart_typedef *UART);

/*
 desc :  Clears the overrun status of both the RX & TX buffers and then returns the current overrun status.
 args :  *UART Pointer
 return 0 : - No overrun
 return 1 : - TX overrun
 return 2 : - RX overrun
 return 3 : - TX & RX overrun
 */


uint32_t uart_clear_overrun_status( uart_typedef *UART);

/*
 desc :  Returns the current UART Baud rate divider.
 args :  *UART Pointer
 return : BaudDiv
 */

uint32_t uart_get_bauddivider( uart_typedef *UART);

/*
 desc :  Set the current UART Baud rate divider.
 args :  *UART Pointer
 args :  divider , The value to which the UART baud rate divider is to be set
 return : none
 */


void uart_set_bauddivider( uart_typedef *UART, uint32_t divider);

/*
 desc :  Returns the TX interrupt status.
 args : *UART Pointer
 return : TXStatus
 */


uint32_t uart_tx_irq_status( uart_typedef *UART);

/*
 desc :  Returns the RX interrupt status.
 args : *UART Pointer
 return : RXStatus
 */

uint32_t uart_rx_irq_status( uart_typedef *UART);

/*
 desc :  Clears the TX buffer full interrupt status. 
 args : *UART Pointer
 return : none
 */

void uart_clear_tx_irq( uart_typedef *UART);

/**
 desc :  Clears the RX interrupt status.
 args : *UART Pointer
 return : none
 */

void uart_clear_rx_irq( uart_typedef *UART);

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

uint32_t uart_config( uart_typedef *UART,  uart_configuration *CONFIG);

/*
 desc : Sends a character to the TX buffer for transmission.
 args : *UART Pointer
 args : txchar Character to be sent
 return : none
 */

void uart_send_char( uart_typedef *UART, char txchar);

/*
 desc : returns the character from the RX buffer which has been received.
 args : *UART Pointer
 return : rxchar
 */


char uart_receive_char( uart_typedef *UART);

#ifdef __cplusplus
}
#endif
