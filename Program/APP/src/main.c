/**************************************************************************//**
 * @file     blinky.c
 * @brief    Demonstrate minimum program blinking LED1
 * @date     12. August 2018
 ******************************************************************************/
/*
 * Copyright (c) 2018 Milosch Meriac <milosch@meriac.com>. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the License); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#include <stdint.h>
#include <stdio.h>

#include "system_macros.h"
#include "dma_driver.h"
#include "gpio_driver.h"
#include "watchdog_driver.h"
#include "timer_driver.h"
#include "dualtimer_driver.h"
#include "serial.h"
#include "spi_serial.h"
#include "RCC_driver.h"

#define TICK_HS 12500000

extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;


/// global flags for interrupt functions
int semaphore = 0;
int semaphore_rx = 0;
int semaphore_spi = 0;

char buffer[150]; // Adjust the size according to your needs
char character;

char rx_command[200];

uint32_t str_size;
int i;

watchdog_configuration WDog_Config;
//timer_configuration Timer_Config;
uart_configuration UART0_Config;
uart_configuration UART1_Config;
//dma_ch_csr_config DMA_Config;
gpio_configuration GPIO_Config;
spi_configuration SPI_Config;

void uart_transmit_string_poll( uart_typedef *UART, char* text)  
{
    //gpio_write_out_data(GPIO0, *text << 8);
      while (*text != '\0')
            {
                  if ((UART->STATE & 1) == 0) {
                        gpio_write_out_data(GPIO0, *text << 8);
                         uart_send_char(UART,*text);
                        while ((gpio_read_pin(GPIO0) & 0x00FF) != *text) {};
                        text++;
                  }  
            }
}

void uart_receive_string_poll( uart_typedef *UART , char* Str) 
{
    gpio_write_out_data(GPIO0, (0x1) << 8); // xxxxxxxx 00000001
    while ((gpio_read_pin(GPIO0) & 0x00FF) < 1){};

    gpio_write_out_data(GPIO0, (0xA) << 8);

	uint8_t i = 0;
     //char *Str = "1" ;
    while(!(UART->STATE & UART_STATE_RX_BF_Msk)) {};

    gpio_write_out_data(GPIO0, (0xB) << 8);

	Str[i] = uart_receive_char(UART); 

    gpio_write_out_data(GPIO0, (0xC) << 8);
      
	while(Str[i] != '\0')
	{	
        gpio_write_out_data(GPIO0, Str[i] << 8);
            while(!(UART->STATE & UART_STATE_RX_BF_Msk)) {};
            i++;
		Str[i] = uart_receive_char(UART);  
	}
    //gpio_write_out_data(GPIO0, Str[i] << 8);
      //return Str ;
         
}

void spi_transmit_string_poll(spi_typedef *SPI, char* text)  
{
      while (*text != '\0')
            {
                  if ((SPI->STATE_REG & 1) == 0) {

                        spi_send_data(SPI,*text);
                        gpio_write_out_data(GPIO0, (0x9 << 8));
                        while ((gpio_read_pin(GPIO0) & 0x00FF) != 0x9) {};

                        spi_enable(SPI);
                        text++;
                        //gpio_write_out_data(GPIO0, (0x7 << 8));
                  }  
            }
}

void parseCommand(char *command) {
    if (strstr(command, "UART") == command) {
        sscanf(command, "UART(%99[^)])", buffer);
        buffer[strlen(buffer)] = '\0';
        
        gpio_write_out_data(GPIO0, (0x2 << 8));
        while ((gpio_read_pin(GPIO0) & 0x00FF) != 0xA) {};

        uart_transmit_string_poll(UART0, buffer);
    } 
    else if (strstr(command, "SPI") == command) {
        sscanf(command, "SPI(%99[^)])", buffer);
        buffer[strlen(buffer)] = '\0';
        
        gpio_write_out_data(GPIO0, (0x3 << 8));
        while ((gpio_read_pin(GPIO0) & 0x00FF) != 0xB) {};

        spi_transmit_string_poll(SPI0, buffer);
    } 
    else if (strstr(command, "GPIO") == command) {
        sscanf(command, "GPIO(%c)", &character);


        gpio_write_out_data(GPIO0, (0x4 << 8));
        while ((gpio_read_pin(GPIO0) & 0x00FF) != 0xC) {};

        gpio_write_out_data(GPIO0, character << 8);
        while ((gpio_read_pin(GPIO0) & 0x00FF) != 0xE) {};
    } 
    else {
        gpio_write_out_data(GPIO0, (0x5 << 8));
        while ((gpio_read_pin(GPIO0) & 0x00FF) != 0xD) {};
        uart_transmit_string_poll(UART0, "Unknown Command.");
    }
}


void SystemInit(void) {

    //NVIC_EnableIRQ(8);  //GPIO Pin 8 Interrupt enable 
    NVIC_EnableIRQ(1); //TX0 Interrupt enable 
    NVIC_EnableIRQ(2); //RX1 Interrupt enable 
    NVIC_EnableIRQ(5); //TX0 Interrupt enable 
    NVIC_EnableIRQ(6); //RX1 Interrupt enable 

    UART0_Config.divider = 16;      
    UART0_Config.tx_en = 1;
    UART0_Config.rx_en = 0;
    UART0_Config.tx_irq_en = 0;
    UART0_Config.rx_irq_en = 0;
    UART0_Config.tx_ovrirq_en = 1;
    UART0_Config.rx_ovrirq_en = 0;
    uart_config( UART0, &UART0_Config);
    
    UART1_Config.divider = 16;
    UART1_Config.tx_en = 0;
    UART1_Config.rx_en = 1;
    UART1_Config.tx_irq_en = 0;
    UART1_Config.rx_irq_en = 0;
    UART1_Config.tx_ovrirq_en = 0;
    UART1_Config.rx_ovrirq_en = 1;
    uart_config( UART1, &UART1_Config);

    //DMA_enable(CMSDK_DMA, 0);


    GPIO_Config.outenableset = 0xFF00;
    GPIO_Config.type = 0;
    GPIO_Config.int_num = 0x0;
    GPIO_Config.alt_func_num = 0;      // alt_func
    GPIO_Config.alt_func_sel_num = 0; //selector 
    gpio_config(GPIO0, &GPIO_Config);

    //Timer_Config.irq_en=1;
    //Timer_Config.enable=1;
    //Timer_Config.extin=0;
    //Timer_Config.extinclk=0;

    //timer_config(TIMER0,&Timer_Config);
    //timer_set_value(TIMER0,TICK_HS);
    //timer_set_reload(TIMER0,TICK_HS);

    SPI_Config.clock_div    = 0 ;
    SPI_Config.slave_select = 0 ;
    SPI_Config.clock_mode   = 0 ;
    SPI_Config.spi_mode     = 1 ; // master
    SPI_Config.duplex_type  = 0 ;
    SPI_Config.tx_int_en    = 1 ;
    SPI_Config.rx_int_en    = 1 ;
    spi_config(SPI0, &SPI_Config); 


    rcc_set_config(RCC0, 3, 4, 3);

}

int main(void) {
    //  1 - Receive string from Uart (interrupt) into str1.

    serial_uart_printf("AAA");
    
    while (1) {
        serial_uart_printf("\nInput command\nUART_Transmit (string) or \nSPI_Transmit (string) or \nGPIO_Set (characte\n");

        //gpio_write_out_data(GPIO0, (0xFF << 8));
        //while ((gpio_read_pin(GPIO0) & 0x00FF) != 0xFF) {};

        uart_receive_string_poll(UART1 , rx_command);
        parseCommand(rx_command);
    }
    
        

    //  2 - DMA Transfer from str1 to str2.
    /*uint32_t str_size = 0;
    int i = 0;
    while(str1[i] != '\0')
	{	
        str_size++;
        i++;
    }
    str_size = str_size / 4;

    DMA_CH_setSZ(CMSDK_DMA, str_size, str_size, 0);
    DMA_CH_setA0(CMSDK_DMA, (uint32_t)&str1, 0);
    DMA_CH_setA1(CMSDK_DMA, (uint32_t)str2, 0);

    DMA_Config.INE_CHK_DONE = 0;
    DMA_Config.INE_DONE = 0;
    DMA_Config.INE_ERROR = 0;
    DMA_Config.REST_EN = 0;
    DMA_Config.ChannelPriority = 0;
    DMA_Config.STOP = 0;
    DMA_Config.SZ_WB = 0;
    DMA_Config.ARS = 0;
    DMA_Config.MODE = 0;
    DMA_Config.INC_SRC = 1;
    DMA_Config.INC_DST = 1;
    DMA_Config.CH_EN = 1;

    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config, 0);*/

    //uint32_t* memory_address = (uint32_t *)(0x40011020);
    //uint32_t data_to_write = 0x819;
    //*memory_address = data_to_write;
    //uint32_t d = CMSDK_DMA->ChannelsConfig[0].CH_CSR;

    //for(int i = 0; i < 50; i++) {};
    //CMSDK_DMA->ChannelsConfig[0].CH_CSR = d | 1;


    //  3 - Transmit str2 through SPI.
   
    //serial_spi_transmit_string_poll(SPI0, str2);

    //  4 - Set Timer to 1s.
    //  5 - In Timer IRQ blink LED using GPIO.
}




void __attribute__((used)) Reset_Handler(void)
{
     /* Copy init values from text to data */
    uint32_t *init_values_ptr = &_etext;
    uint32_t *data_ptr = &_sdata;

    if (init_values_ptr != data_ptr) {
        for (; data_ptr < &_edata;) {
            *data_ptr++ = *init_values_ptr++;
        }
    }

    /* Clear the zero segment */
    for (uint32_t *bss_ptr = &_sbss; bss_ptr < &_ebss;) {
        *bss_ptr++ = 0;
    }

    /* Initialize System */
    SystemInit();

    /* Branch to main function */
    main();

    /* Infinite loop */
    while (1);

}




//  Watchdog Interrupt
void __attribute__((used)) NMI_Handler(void)
{

}


void __attribute__((used)) HardFault_Handler(void)
{

}




void __attribute__((used)) SVC_Handler(void)
{


}


// Handler for PendSV (Context Switching)
void __attribute__((used)) PendSV_Handler(void) {

}


void __attribute__((used)) Systick_Handler(void)
{

}


void __attribute__((used)) GPIO_INT_00_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_01_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_02_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_03_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_04_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_05_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_06_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_07_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_08_Handler(void)
{
    
}

void __attribute__((used)) GPIO_INT_09_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_10_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_11_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_12_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_13_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_14_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_15_Handler(void)
{

}

void __attribute__((used)) GPIO_COMB_INT_Handler(void)
{

}


void __attribute__((used)) UART0_RX_INT_Handler(void)
{

}

void __attribute__((used)) UART0_TX_INT_Handler(void)
{
   uart_clear_tx_irq( UART0);
   semaphore = 1;
}

void __attribute__((used)) UART0_RXOV_INT_Handler(void)
{

}


void __attribute__((used)) UART0_TXOV_INT_Handler(void)
{

}


void __attribute__((used)) UART0_COMB_INT_Handler(void)
{
    
}

void __attribute__((used)) UART1_RX_INT_Handler(void)
{
    uart_clear_rx_irq( UART1);
    semaphore_rx = 1;
}

void __attribute__((used)) UART1_TX_INT_Handler(void)
{

}

void __attribute__((used)) UART1_RXOV_INT_Handler(void)
{
  
}

void __attribute__((used)) UART1_TXOV_INT_Handler(void)
{

}


void __attribute__((used)) UART1_COMB_INT_Handler(void)
{

}

void __attribute__((used)) TIMER_INT_Handler(void)
{

}

void __attribute__((used)) DUALTIMER_INT1_Handler(void)
{

}

void __attribute__((used)) DUALTIMER_INT2_Handler(void)
{

}

void __attribute__((used)) DUALTIMER_COMB_INT_Handler(void)
{
   
}

void __attribute__((used)) Default_Handler(void)
{

}


/* declare vector table */
const void* VectorTable[] __attribute__ ((section(".vtor"), used)) = {
    &StackTop,  

    Reset_Handler,     /* -15: Reset_IRQn              */
    NMI_Handler,
    HardFault_Handler,

    Default_Handler,
    Default_Handler,
    Default_Handler,
    Default_Handler,
    Default_Handler,
    Default_Handler,
    Default_Handler,

    SVC_Handler,

    Default_Handler,
    Default_Handler,

    PendSV_Handler,
    Systick_Handler,

    GPIO_INT_00_Handler,
    GPIO_INT_01_Handler,
    GPIO_INT_02_Handler,
    GPIO_INT_03_Handler,
    GPIO_INT_04_Handler,
    GPIO_INT_05_Handler,
    GPIO_INT_06_Handler,
    GPIO_INT_07_Handler,
    GPIO_INT_08_Handler,
    GPIO_INT_09_Handler,
    GPIO_INT_10_Handler,
    GPIO_INT_11_Handler,
    GPIO_INT_12_Handler,
    GPIO_INT_13_Handler,
    GPIO_INT_14_Handler,
    GPIO_INT_15_Handler,
    GPIO_COMB_INT_Handler,

    TIMER_INT_Handler,
    DUALTIMER_INT1_Handler,
    DUALTIMER_INT2_Handler,
    DUALTIMER_COMB_INT_Handler,

    UART0_TX_INT_Handler,
    UART0_RX_INT_Handler,
    UART0_TXOV_INT_Handler,
    UART0_RXOV_INT_Handler,
    UART0_COMB_INT_Handler,

    UART1_TX_INT_Handler,
    UART1_RX_INT_Handler,
    UART1_TXOV_INT_Handler,
    UART1_RXOV_INT_Handler,
    UART1_COMB_INT_Handler,

    Default_Handler   
};


