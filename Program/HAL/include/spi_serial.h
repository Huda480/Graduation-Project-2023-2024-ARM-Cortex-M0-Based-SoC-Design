#include "spi_driver.h"


extern int semaphore_spi ;
extern int semaphore_rx_spi;


void serial_spi_receive_string_poll( spi_typedef *SPI , char *Str);

void serial_spi_receive_string_int( spi_typedef *SPI , char *Str);

void serial_spi_transmit_string_poll( spi_typedef *SPI, char* text);

void serial_spi_transmit_string_int( spi_typedef *SPI, char* text);

void serial_spi_printf(const char *format, ...);
