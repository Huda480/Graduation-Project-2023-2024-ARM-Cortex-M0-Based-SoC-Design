#include "spi_serial.h"


/*
 desc : Receive a string from spi using polling.
 args : *SPI , A pointer to the  spi_typedef structure representing the spi interface.
 return : none.
 */

void serial_spi_receive_string_poll( spi_typedef *SPI , char* Str) 
{
	uint8_t i = 0;
     //char *Str = "1" ;
	Str[i] = spi_read_data(SPI); 
      
	while(Str[i] != '\0')
	{	
            while(!(SPI->STATE_REG & 2)) {};
            i++;
		Str[i] = spi_read_data(SPI);  
	}
      //return Str ;
         
}




/*
 desc : Receive a string from spi using interrupts.
 args : *SPI Pointer
 return : none.
 */

void serial_spi_receive_string_int( spi_typedef *SPI , char* Str)   
{
	uint8_t i = 0;
    //  char *Str = "1" ;
	Str[i] = spi_read_data(SPI); 
      
	while(Str[i] != '\0')
	{	
            while (semaphore_rx_spi != 1);
            i++;
            semaphore_rx_spi = 0;
		Str[i] = spi_read_data(SPI);  
	}       
}




/*
 desc :  Transmit a string via spi using polling.
 args :  *SPI Pointer
 args :  text The string to be transmitted.
 return : none.
 */

void serial_spi_transmit_string_poll(spi_typedef *SPI, char* text)  
{
      while (*text != '\0')
            {

                  if ((SPI->STATE_REG & 1) == 0) {
                         spi_send_data(SPI,*text);
                         spi_enable(SPI);
                        text++;
                  }  
            }
}




/*
 desc : Transmit a string via SPI using interrupts.
 args :  *SPI Pointer
 args :  text The string to be transmitted.
 return : none.
 */

void serial_spi_transmit_string_int( spi_typedef *SPI, char* text)  
{
     
      while (*text != '\0')
            {
                  while (semaphore_spi != 1);
                  spi_send_data(SPI,*text);
                  text++;
                  semaphore_spi = 0;
            }
}


void serial_spi_printf(const char *format, ...) 
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
  serial_spi_transmit_string_int( SPI0,buffer);
}