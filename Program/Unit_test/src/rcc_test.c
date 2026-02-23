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
/*
#include "dma_driver.h"
#include "gpio_driver.h"
#include "watchdog_driver.h"
#include "timer_driver.h"
#include "dualtimer_driver.h"
#include "serial.h"
#include "spi_serial.h"
#include "RCC_driver.h"*/


extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;


uint8_t source_array[4] = {0x11, 0x22, 0x33, 0x44};
uint8_t dest_array[4];

//rcc_typedef RCC_Config;

void SystemInit(void) {



}

int main(void) {
    //rcc_set_config(RCC0, 3, 8, 4);
    __asm volatile (
        "LDRB r2, [%[src], #0]      \n" // Load byte 0 from source_array into r2
        "LDRB r3, [%[src], #1]      \n" // Load byte 1 from source_array into r3
        "LDRB r4, [%[src], #2]      \n" // Load byte 2 from source_array into r4
        "LDRB r5, [%[src], #3]      \n" // Load byte 3 from source_array into r5

        "STRB r2, [%[dst], #0]      \n" // Store byte 0 from r2 into dest_array[0]
        "STRB r3, [%[dst], #1]      \n" // Store byte 1 from r3 into dest_array[1]
        "STRB r4, [%[dst], #2]      \n" // Store byte 2 from r4 into dest_array[2]
        "STRB r5, [%[dst], #3]      \n" // Store byte 3 from r5 into dest_array[3]
        :
        : [src] "r" (source_array), [dst] "r" (dest_array) // Input operands
        : "r2", "r3", "r4", "r5" // Clobbered registers
    );
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


