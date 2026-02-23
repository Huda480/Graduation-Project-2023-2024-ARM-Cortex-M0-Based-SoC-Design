#include "serial.h"


/*
 desc : Receive a string from UART using polling.
 args : *UART , A pointer to the  uart_typedef structure representing the UART interface.
 return : none.
 */

void serial_uart_receive_string_poll( uart_typedef *UART , char* Str) 
{
	uint8_t i = 0;
     //char *Str = "1" ;
      while(!(UART->STATE & UART_STATE_RX_BF_Msk)) {};
	Str[i] = uart_receive_char(UART); 
      
	while(Str[i] != '\0')
	{	
            while(!(UART->STATE & UART_STATE_RX_BF_Msk)) {};
            i++;
		Str[i] = uart_receive_char(UART);  
	}
      //return Str ;
         
}




/*
 desc : Receive a string from UART using interrupts.
 args : *UART Pointer
 return : none.
 */

void serial_uart_receive_string_int( uart_typedef *UART , char* Str)   
{
	uint8_t i = 0;
    //  char *Str = "1" ;
	Str[i] = uart_receive_char(UART); 
      
	while(Str[i] != '\0')
	{	
            while (semaphore_rx != 1);
            i++;
            semaphore_rx = 0;
		Str[i] = uart_receive_char(UART);  
	}       
}




/*
 desc :  Transmit a string via UART using polling.
 args :  *UART Pointer
 args :  text The string to be transmitted.
 return : none.
 */

void serial_uart_transmit_string_poll( uart_typedef *UART, char* text)  
{
      while (*text != '\0')
            {
                  if ((UART->STATE & 1) == 0) {
                         uart_send_char(UART,*text);
                        text++;
                  }  
            }
}




/*
 desc : Transmit a string via UART using interrupts.
 args :  *UART Pointer
 args :  text The string to be transmitted.
 return : none.
 */

void serial_uart_transmit_string_int( uart_typedef *UART, char* text)  
{
     
      while (*text != '\0')
            {
                  while (semaphore != 1);
                  uart_send_char(UART,*text);
                  text++;
                  semaphore = 0;
            }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void serial_uart_printf(const char *format, ...) 
{
    char buffer[256]; // Buffer to hold formatted string
    va_list args;     // Variable argument list
    
    // Initialize variable argument list
    va_start(args, format);
    
    // Format the string using vsnprintf
    vsnprintf(buffer, sizeof(buffer), format, args);
    
    // Terminate variable argument list
    va_end(args);
    
    // Transmit the formatted string via UART
  serial_uart_transmit_string_poll( UART0,buffer);
}