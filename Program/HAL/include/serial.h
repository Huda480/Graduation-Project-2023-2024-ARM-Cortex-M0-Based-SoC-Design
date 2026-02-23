#include "uart_driver.h"


extern int semaphore;
extern int semaphore_rx;


void serial_uart_receive_string_poll( uart_typedef *UART , char *Str);

void serial_uart_receive_string_int( uart_typedef *UART , char *Str);

void serial_uart_transmit_string_poll( uart_typedef *UART, char* text);

void serial_uart_transmit_string_int( uart_typedef *UART, char* text);

void serial_uart_printf(const char *format, ...);

