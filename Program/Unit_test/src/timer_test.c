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
 //#include "STD_TYPES.h"
 //#include "BIT_MATH.h"
 //#include <stdbool.h>
 //#include <stdio.h>
 //#include "CMSDK_CM0.h"

 //#include "watchdog driver.c"

#include <stdint.h>
#include "system_macros.h"
#include "gpio_driver.h"
#include "uart_driver.h"
#include "watchdog_driver.h"
#include "timer_driver.h"
#include "dualtimer_driver.h"


extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;

timer_configuration timer_conf;

void SystemInit(void) {
      timer_conf.irq_en=1;
      timer_conf.enable=1;
      timer_conf.extin=0;
      timer_conf.extinclk=0;

      timer_config(TIMER0,&timer_conf);
}

int main(void) {
      timer_set_value(TIMER0,10000);
      timer_set_reload(TIMER0,9070);
}

void Reset_Handler(void)
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
void NMI_Handler(void)
{

}


void HardFault_Handler(void)
{

}

//void HardFault_Handle_Main (uint32_t * hardfault_args, uint32_t lr_value)
//{
//
//}



void SVC_Handler(void)
{


}

//void SVC_Handler_Main( unsigned int *svc_args )
//{
//
//}


// Handler for PendSV (Context Switching)
void PendSV_Handler(void) {

}


void Systick_Handler(void)
{

}


void GPIO_INT_00_Handler(void)
{

}

void GPIO_INT_01_Handler(void)
{

}

void GPIO_INT_02_Handler(void)
{

}

void GPIO_INT_03_Handler(void)
{

}

void GPIO_INT_04_Handler(void)
{

}

void GPIO_INT_05_Handler(void)
{

}

void GPIO_INT_06_Handler(void)
{

}

void GPIO_INT_07_Handler(void)
{

}

void GPIO_INT_08_Handler(void)
{

}

void GPIO_INT_09_Handler(void)
{

}

void GPIO_INT_10_Handler(void)
{

}

void GPIO_INT_11_Handler(void)
{

}

void GPIO_INT_12_Handler(void)
{

}

void GPIO_INT_13_Handler(void)
{

}

void GPIO_INT_14_Handler(void)
{

}

void GPIO_INT_15_Handler(void)
{

}

void GPIO_INT_C_Handler(void)
{

}


void UART0_RX_INT_Handler(void)
{

}

void UART0_TX_INT_Handler(void)
{
}


void UART0_TX_OV_INT_Handler(void)
{

}

void UART0_RX_OV_INT_Handler(void)
{

}

void UART0_C_INT_Handler(void)
{

}

void UART1_RX_INT_Handler(void)
{

}

void UART1_TX_INT_Handler(void)
{

}


void UART1_TX_OV_INT_Handler(void)
{

}

void UART1_RX_OV_INT_Handler(void)
{

}

void UART1_C_INT_Handler(void)
{

}



void TIMER_INT_Handler(void)
{
      timer_irq_handler();
}

void DAUL_TIMER1_INT_Handler(void)
{

}

void DAUL_TIMERC_INT_Handler(void)
{
}

void DUAL_TIMER2_INT_Handler(void)
{

}

void Default_Handler(void)
{

}


/* declare vector table */



const void* VectorTable[] __attribute__ ((section(".vtor"))) = {
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
    GPIO_INT_C_Handler,
    
    TIMER_INT_Handler,

    DAUL_TIMER1_INT_Handler,
    DUAL_TIMER2_INT_Handler,
    DAUL_TIMERC_INT_Handler,
    
    UART0_TX_INT_Handler,
    UART0_RX_INT_Handler,
    UART0_TX_OV_INT_Handler,
    UART0_RX_OV_INT_Handler,
    UART0_C_INT_Handler,

    UART1_TX_INT_Handler,
    UART1_RX_INT_Handler,
    UART1_TX_OV_INT_Handler,
    UART1_RX_OV_INT_Handler,
    UART1_C_INT_Handler,

    Default_Handler
};


