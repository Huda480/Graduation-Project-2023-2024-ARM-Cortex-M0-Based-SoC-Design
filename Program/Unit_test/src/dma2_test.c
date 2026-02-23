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

#include "dma_driver.h"



extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;


dma_ch_csr_config DMA_Config;


uint32_t words [512];
uint16_t halfwords [1024];
char bytes [2048];
uint32_t words_out [512];
uint16_t halfwords_out [1024];
char bytes_out [2048];


void SystemInit(void) {



    DMA_enable(CMSDK_DMA, 0);

    //////////////////////////////////////////////////////

    for (int i = 0; i < 512; i++) {
        words[i] = 5*i;
    }


    DMA_Config.HBURST = 1;
    DMA_Config.KEEP_REGS = 1;
    DMA_Config.HSIZE = 2;
    DMA_Config.REST_EN = 0;
    DMA_Config.CHANNEL_PRIORITY = 0;
    DMA_Config.ARS = 0;
    DMA_Config.MODE = 0;
    DMA_Config.INC_SRC = 1;
    DMA_Config.INC_DST = 1;
    DMA_Config.USE_ED = 0;
    DMA_Config.CH_EN = 0;
    DMA_Config.INE_DONE = 0;
    DMA_Config.INE_ERROR = 0;

    DMA_enable(CMSDK_DMA, 0);
    DMA_CH_setSZ(CMSDK_DMA, 0, 512, 0);
    DMA_CH_setA0(CMSDK_DMA, (uint32_t)words , 0);
    DMA_CH_setA1(CMSDK_DMA, (uint32_t)words_out, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config, 0);
    DMA_CH_enable(CMSDK_DMA, 1, 0);

    /////////////////////////////////////////////////////////////
        while ((DMA_CH_getCSR(CMSDK_DMA, 0) & 1) != 0);
    /////////////////////////////////////////////////////////////

    for (int i = 0; i < 1024; i++) {
        halfwords[i] = 2*i;
    }


    DMA_Config.HBURST = 1;
    DMA_Config.KEEP_REGS = 1;
    DMA_Config.HSIZE = 1;
    DMA_Config.REST_EN = 0;
    DMA_Config.CHANNEL_PRIORITY = 0;
    DMA_Config.ARS = 0;
    DMA_Config.MODE = 0;
    DMA_Config.INC_SRC = 1;
    DMA_Config.INC_DST = 1;
    DMA_Config.USE_ED = 0;
    DMA_Config.CH_EN = 0;
    DMA_Config.INE_DONE = 0;
    DMA_Config.INE_ERROR = 0;

    DMA_CH_setSZ(CMSDK_DMA, 0, 1024, 0);
    DMA_CH_setA0(CMSDK_DMA, (uint32_t)halfwords , 0);
    DMA_CH_setA1(CMSDK_DMA, (uint32_t)halfwords_out, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config, 0);
    DMA_CH_enable(CMSDK_DMA, 1, 0);

    /////////////////////////////////////////////////////////////
        while ((DMA_CH_getCSR(CMSDK_DMA, 0) & 1) != 0);
    /////////////////////////////////////////////////////////////

    for (int i = 0; i < 2048; i++) {
        bytes[i] = i%256;
    }


    DMA_Config.HBURST = 1;
    DMA_Config.KEEP_REGS = 1;
    DMA_Config.HSIZE = 0;
    DMA_Config.REST_EN = 0;
    DMA_Config.CHANNEL_PRIORITY = 0;
    DMA_Config.ARS = 0;
    DMA_Config.MODE = 0;
    DMA_Config.INC_SRC = 1;
    DMA_Config.INC_DST = 1;
    DMA_Config.USE_ED = 0;
    DMA_Config.CH_EN = 0;
    DMA_Config.INE_DONE = 0;
    DMA_Config.INE_ERROR = 0;

    DMA_CH_setSZ(CMSDK_DMA, 0, 2048, 0);
    DMA_CH_setA0(CMSDK_DMA, (uint32_t)bytes , 0);
    DMA_CH_setA1(CMSDK_DMA, (uint32_t)bytes_out, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config, 0);
    DMA_CH_enable(CMSDK_DMA, 1, 0);

    /////////////////////////////////////////////////////////////
        while ((DMA_CH_getCSR(CMSDK_DMA, 0) & 1) != 0);
    /////////////////////////////////////////////////////////////

}


int main(void) {


    // First Descriptor (L1)  
    uint32_t* memory_address = (uint32_t*)0x20005000;

    (*memory_address) = (1<<19) | (1<<18) | 8;      //  CSR
    (*(memory_address + 1)) = (uint32_t)words;      //  ADR0
    (*(memory_address + 2)) = (uint32_t)words_out;  //  ADR1
    (*(memory_address + 3)) = 0x20005100;           //  NEXT


    memory_address = (uint32_t*)0x20005100;
    
    (*memory_address) = (1<<20) | (1<<19) | (1<<18) | 12;   //  CSR
    (*(memory_address + 1)) = (uint32_t)words;              //  ADR0
    (*(memory_address + 2)) = (uint32_t)words_out;          //  ADR1
    (*(memory_address + 3)) = 0;                            //  NEXT
    
    //////////////////////////////////////////////////////

    DMA_Config.HBURST = 0;
    DMA_Config.KEEP_REGS = 1;
    DMA_Config.HSIZE = 2;
    DMA_Config.REST_EN = 0;
    DMA_Config.CHANNEL_PRIORITY = 0;
    DMA_Config.ARS = 0;
    DMA_Config.MODE = 0;
    DMA_Config.INC_SRC = 1;
    DMA_Config.INC_DST = 1;
    DMA_Config.USE_ED = 1;
    DMA_Config.CH_EN = 0;
    DMA_Config.INE_DONE = 0;
    DMA_Config.INE_ERROR = 0;

    DMA_CH_setSZ(CMSDK_DMA, 4, 4, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config, 0);
    DMA_CH_setDESC(CMSDK_DMA, 0x20005000, 0);
    DMA_CH_enable(CMSDK_DMA, 1, 0);

    /////////////////////////////////////////////////////////////
        while ((DMA_CH_getCSR(CMSDK_DMA, 0) & 1) != 0);
    /////////////////////////////////////////////////////////////

    DMA_Config.HBURST = 1;
    DMA_Config.KEEP_REGS = 1;
    DMA_Config.HSIZE = 2;
    DMA_Config.REST_EN = 0;
    DMA_Config.CHANNEL_PRIORITY = 0;
    DMA_Config.ARS = 0;
    DMA_Config.MODE = 0;
    DMA_Config.INC_SRC = 1;
    DMA_Config.INC_DST = 1;
    DMA_Config.USE_ED = 1;
    DMA_Config.CH_EN = 0;
    DMA_Config.INE_DONE = 0;
    DMA_Config.INE_ERROR = 0;

    DMA_CH_setSZ(CMSDK_DMA, 4, 4, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config, 0);
    DMA_CH_setDESC(CMSDK_DMA, 0x20005000, 0);
    DMA_CH_enable(CMSDK_DMA, 1, 0);

    //while (1);

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
    /*if (spi_get_irq_status(SPI0) & (1 << 3)) { 
        spi_disable(SPI0);
    }*/
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


