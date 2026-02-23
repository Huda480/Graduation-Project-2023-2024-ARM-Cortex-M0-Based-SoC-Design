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
#include "watchdog_driver.h"
#include "timer_driver.h"
#include "dualtimer_driver.h"
#include "dma_driver.h"
#include "spi_driver.h"
#include "wifi_driver.h"
#include "ble_driver.h"


extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;


dma_ch_csr_config DMA_Config_BLE_TX;
dma_ch_csr_config DMA_Config_BLE_RX;
dma_ch_csr_config DMA_Config_WIFI_RX;


wifi_configuration WIFI_Config;
ble_configuration BLE_Config;

uint32_t data_out [140];
uint32_t data_out_ble [140];

uint32_t data [140];

void SystemInit(void) {

    //  BLE Interrupts.
    NVIC_EnableIRQ(1);
    NVIC_EnableIRQ(2);

    //  WiFi Interrupts.
    NVIC_EnableIRQ(3);
    NVIC_EnableIRQ(4);


    WIFI_Config.enable = 1;
    WIFI_Config.mode = 1;
    WIFI_Config.tx_irq_en = 1;
    WIFI_Config.rx_irq_en = 1;
    WIFI_Config.dma_mode = 1;

    wifi_config(WIFI0, &WIFI_Config);

    BLE_Config.enable = 1;
    BLE_Config.mode = 0;
    BLE_Config.tx_irq_en = 1;
    BLE_Config.rx_irq_en = 1;
    BLE_Config.dma_mode = 1;

    ble_config(BLE0, &BLE_Config);

   
    DMA_enable(CMSDK_DMA, 0);

    //////////////////////////////////////////////////////

    /*for (int i = 0; i < 138; i++) {
        data[i] = 2*i;
    }

    DMA_Config_BLE_TX.HBURST = 1;
    DMA_Config_BLE_TX.KEEP_REGS = 1;
    DMA_Config_BLE_TX.HSIZE = 2;
    DMA_Config_BLE_TX.REST_EN = 0;
    DMA_Config_BLE_TX.CHANNEL_PRIORITY = 0;
    DMA_Config_BLE_TX.ARS = 0;
    DMA_Config_BLE_TX.MODE = 1;
    DMA_Config_BLE_TX.INC_SRC = 1;
    DMA_Config_BLE_TX.INC_DST = 1;
    DMA_Config_BLE_TX.CH_EN = 1;
    DMA_Config_BLE_TX.INE_DONE = 0;
    DMA_Config_BLE_TX.INE_ERROR = 0;

    DMA_CH_setReq(CMSDK_DMA, 6, 0);
    DMA_CH_setSZ(CMSDK_DMA, 0, 138, 0);
    DMA_CH_setA0(CMSDK_DMA, (uint32_t)data, 0);
    DMA_CH_setA1(CMSDK_DMA, 0X40020010, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config_BLE_TX, 0);*/

    //////////////////////////////

    DMA_Config_BLE_RX.HBURST = 1;
    DMA_Config_BLE_RX.KEEP_REGS = 1;
    DMA_Config_BLE_RX.HSIZE = 2;
    DMA_Config_BLE_RX.REST_EN = 0;
    DMA_Config_BLE_RX.CHANNEL_PRIORITY = 0;
    DMA_Config_BLE_RX.ARS = 0;
    DMA_Config_BLE_RX.MODE = 1;
    DMA_Config_BLE_RX.INC_SRC = 1;
    DMA_Config_BLE_RX.INC_DST = 1;
    DMA_Config_BLE_RX.CH_EN = 1;
    DMA_Config_BLE_RX.INE_DONE = 0;
    DMA_Config_BLE_RX.INE_ERROR = 0;


    DMA_CH_setReq(CMSDK_DMA, 7,0, 1);
    DMA_CH_setSZ(CMSDK_DMA, 0, 127, 1);
    DMA_CH_setA0(CMSDK_DMA, 0X40020010, 1);
    DMA_CH_setA1(CMSDK_DMA, 0X40021010, 1);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config_BLE_RX, 1); 
    

    /////////////////////////////////////////////////

    DMA_Config_WIFI_RX.HBURST = 0;
    DMA_Config_WIFI_RX.KEEP_REGS = 1;
    DMA_Config_WIFI_RX.HSIZE = 2;
    DMA_Config_WIFI_RX.REST_EN = 0;
    DMA_Config_WIFI_RX.CHANNEL_PRIORITY = 0;
    DMA_Config_WIFI_RX.ARS = 0;
    DMA_Config_WIFI_RX.MODE = 1;
    DMA_Config_WIFI_RX.INC_SRC = 1;
    DMA_Config_WIFI_RX.INC_DST = 1;
    DMA_Config_WIFI_RX.CH_EN = 0;
    DMA_Config_WIFI_RX.INE_DONE = 0;
    DMA_Config_WIFI_RX.INE_ERROR = 0;

    DMA_CH_setReq(CMSDK_DMA, 9,0, 0);
    DMA_CH_setSZ(CMSDK_DMA, 0, 127, 0);
    DMA_CH_setA0(CMSDK_DMA, 0X40021010, 0);
    DMA_CH_setA1(CMSDK_DMA, (uint32_t)data_out, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config_WIFI_RX, 0);
}


int main(void) {
    
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
    ble_clear_irq(BLE0, 1, 0);
    
    /*BLE_Config.enable = 1;
    BLE_Config.mode = 0;
    BLE_Config.tx_irq_en = 1;
    BLE_Config.rx_irq_en = 1;

    ble_config(BLE0, &BLE_Config); */
}

void __attribute__((used)) GPIO_INT_02_Handler(void)
{
    ble_clear_irq(BLE0, 0, 1);
    
    //DMA_CH_enable(CMSDK_DMA, 1, 1);

}


void __attribute__((used)) GPIO_INT_03_Handler(void)
{
    wifi_clear_irq(WIFI0, 1, 0);
    
    WIFI_Config.enable = 1;
    WIFI_Config.mode = 0;
    WIFI_Config.tx_irq_en = 1;
    WIFI_Config.rx_irq_en = 1;

    wifi_config(WIFI0, &WIFI_Config);
}

void __attribute__((used)) GPIO_INT_04_Handler(void)
{
    wifi_clear_irq(WIFI0, 0, 1);
    
    DMA_CH_enable(CMSDK_DMA, 1, 0);
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


