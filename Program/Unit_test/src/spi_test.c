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
#include "system_macros.h"
#include "gpio_driver.h"
#include "uart_driver.h"
#include "spi_driver.h"
#include "dma_driver.h"


extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;


dma_ch_csr_config DMA_Config_SPI_RX;
dma_ch_csr_config DMA_Config_UART_TX;
spi_configuration SPI0_Config;
uart_configuration UART0_Config;
gpio_configuration GPIO_Config;

char string [20];
uint32_t address;

char data [8];


void SystemInit(void) {


    GPIO_Config.outenableset = 0x0000;
    GPIO_Config.type = 0;
    GPIO_Config.int_num = 0;
    GPIO_Config.alt_func_num = 0xFFFF;      // alt_func
    GPIO_Config.alt_func_sel_num = 0; //selector 
    gpio_config(GPIO0, &GPIO_Config);

    /////////////////////////////////////////////////////

    SPI0_Config.clock_div = 0;
    SPI0_Config.slave_select = 0;
    SPI0_Config.clock_mode = 0;
    SPI0_Config.spi_mode = 1;
    SPI0_Config.duplex_type = 0;
    SPI0_Config.tx_int_en = 1;
    SPI0_Config.rx_int_en = 1;
    SPI0_Config.dma_mode = 1;
    SPI0_Config.tx_fifo_mode = 1;
    SPI0_Config.rx_fifo_mode = 1;
    spi_config( SPI0, &SPI0_Config);

    UART0_Config.divider = 16;      
    UART0_Config.tx_en = 1;
    UART0_Config.rx_en = 0;
    UART0_Config.tx_irq_en = 1;
    UART0_Config.rx_irq_en = 0;
    UART0_Config.tx_ovrirq_en = 1;
    UART0_Config.rx_ovrirq_en = 0;
    UART0_Config.dma_mode = 1;
    uart_config( UART0, &UART0_Config);
    

    //////////////////////////////////////////////////////

    //DMA_Config_SPI_RX.INE_CHK_DONE = 0;
    DMA_Config_SPI_RX.INE_DONE = 1;
    DMA_Config_SPI_RX.INE_ERROR = 1;
    DMA_Config_SPI_RX.REST_EN = 0;
    DMA_Config_SPI_RX.CHANNEL_PRIORITY = 0;
    //DMA_Config_SPI_RX.STOP = 0;
    DMA_Config_SPI_RX.HSIZE = 0;
    DMA_Config_SPI_RX.ARS = 0;
    DMA_Config_SPI_RX.MODE = 1;
    DMA_Config_SPI_RX.INC_SRC = 0;
    DMA_Config_SPI_RX.INC_DST = 1;
    DMA_Config_SPI_RX.CH_EN = 1;

    DMA_enable(CMSDK_DMA, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config_SPI_RX, 0);
    DMA_CH_setSZ(CMSDK_DMA, 4, 8, 0);
    DMA_CH_setA0(CMSDK_DMA, 0x40003004UL, 0);
    //DMA_CH_setAM0(CMSDK_DMA, 0x40003004UL, 0);
    DMA_CH_setA1(CMSDK_DMA, (uint32_t)string, 0);
    //DMA_CH_setAM1(CMSDK_DMA, (uint32_t)string, 0);


    //DMA_Config_UART_TX.INE_CHK_DONE = 0;
    DMA_Config_UART_TX.INE_DONE = 1;
    DMA_Config_UART_TX.INE_ERROR = 1;
    DMA_Config_UART_TX.REST_EN = 0;
    DMA_Config_UART_TX.CHANNEL_PRIORITY = 0;
    //DMA_Config_UART_TX.STOP = 0;
    DMA_Config_UART_TX.HSIZE = 0;
    DMA_Config_UART_TX.ARS = 0;
    DMA_Config_UART_TX.MODE = 1;
    DMA_Config_UART_TX.INC_SRC = 1;
    DMA_Config_UART_TX.INC_DST = 0;
    DMA_Config_UART_TX.CH_EN = 1;

    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config_UART_TX, 4);
    DMA_CH_setSZ(CMSDK_DMA, 4, 8, 4);
    DMA_CH_setA0(CMSDK_DMA, (uint32_t)string, 4);
    //DMA_CH_setAM0(CMSDK_DMA, (uint32_t)string, 4);
    DMA_CH_setA1(CMSDK_DMA, 0x40000000UL, 4);
    //DMA_CH_setAM1(CMSDK_DMA, 0x40000000UL, 4);
}


int main(void) {
    
    for (int i = 0; i < 8; i++) {
        data[i] = 2*i;

        spi_send_data(SPI0,data[i]);
    }
        spi_enable(SPI0);

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


