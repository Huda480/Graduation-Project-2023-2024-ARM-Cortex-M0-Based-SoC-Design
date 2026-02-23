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
#include "ble_driver.h"
#include "dma_driver.h"



extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;


ble_configuration BLE_Config;
dma_ch_csr_config DMA_Config_BLE_TX;
dma_ch_csr_config DMA_Config_BLE_RX;


uint32_t data [140];
uint32_t data_out [140];

uint32_t wordArray[138] = {
    0xB6FC3E85,
    0xE7D0F45A,
    0xD9CF8320,
    0x80EF986E,
    0x8988F66F,
    0x463191F4,
    0xF9DC21A2,
    0x24724986,
    0xA4C9DEC4,
    0xFC0EF895,
    0x120433FD,
    0xDE12CBBE,
    0xA502095F,
    0xCCDD6A15,
    0x2776B264,
    0xC9CD4F59,
    0xC5FDE38D,
    0x7158C47F,
    0xF86D4C35,
    0x8EB03F80,
    0x5EF39205,
    0xD8BF9812,
    0x61F202E1,
    0x9ADA0A3E,
    0x83533CE1,
    0x57D37D22,
    0x09487CC3,
    0x8BF72F4D,
    0x97B3290A,
    0xD8E00AED,
    0x857B5A19,
    0x264DCEF2,
    0xF915557E,
    0x8C7BD7D6,
    0xF87C1813,
    0x47071E88,
    0x1D7489BD,
    0x35D6E7F0,
    0xE9E16882,
    0xED4CB8F6,
    0x6EB63248,
    0x917B39E5,
    0xB55A3622,
    0x7D380895,
    0xF002B8F0,
    0xF316E159,
    0xD6342EB1,
    0x42D77DEE,
    0xC26D6F4D,
    0xD2CF4489,
    0x32E2BAAF,
    0xDB464BE5,
    0xC90F8F59,
    0x1132502A,
    0xD43CC06C,
    0xED4CD9D7,
    0x0AB67BEF,
    0xDA8E3CB0,
    0x209B8086,
    0x7049CBFE,
    0x6073E0BA,
    0xCCA17809,
    0xFE30294A,
    0x849C5EF4,
    0xBE1BDA14,
    0xA528F58A,
    0x252103BC,
    0xB87B9C94,
    0x66080041,
    0x40FA1F61,
    0x42C20D35,
    0x34BAB8A5,
    0x40CEC1AC,
    0x7601DFFC,
    0x4CE0F1C3,
    0x2ECAEE4B,
    0x8DE8D5FA,
    0x18773BF7,
    0x73D7F55C,
    0x677CEDA1,
    0xECDB5A41,
    0x523D00D8,
    0x641565E4,
    0x66CBE155,
    0x1A89AC1F,
    0x2FB842D9,
    0xBDB4E671,
    0x3E0D7C2F,
    0x8B8FC423,
    0xC50E310F,
    0x9BC28C0D,
    0x0E669792,
    0xFF2726B3,
    0x8FFFA42C,
    0x7E37429B,
    0x6B903092,
    0xDD451586,
    0xB5EA19A9,
    0xD1BCA67D,
    0x98EC8CB2,
    0x14DA05CD,
    0xCC2AE7BC,
    0xAC0CD82D,
    0x0EFBF78B,
    0xB94DD3F6,
    0xA08B7C21,
    0x3C715DE2,
    0x4072B17F,
    0x67369AAF,
    0x50635E5A,
    0x79F3257D,
    0x875B2C6A,
    0x3F36865A,
    0xCC576FC1,
    0x10316B04,
    0x74C22787,
    0xF4BB1E3A,
    0x03C0C69A,
    0x5DC7F393,
    0xB23EF02B,
    0xD9E36E12,
    0xBFAAA54A,
    0xF36A8FA9,
    0x420788BA,
    0xFFDA9958,
    0xE1C22357,
    0xE100001D
};

void SystemInit(void) {

    NVIC_EnableIRQ(1);
    NVIC_EnableIRQ(2);

    BLE_Config.enable = 1;
    BLE_Config.mode = 1;
    BLE_Config.tx_irq_en = 1;
    BLE_Config.rx_irq_en = 1;
    BLE_Config.dma_mode = 1;

    ble_config(BLE0, &BLE_Config);

    DMA_enable(CMSDK_DMA, 0);

    for (int i = 127; i < 138; i++) {
        wordArray[i] = 2*i;
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
    DMA_CH_setA0(CMSDK_DMA, (uint32_t)wordArray, 0);
    DMA_CH_setA1(CMSDK_DMA, 0X40020010, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config_BLE_TX, 0);

    DMA_Config_BLE_RX.HBURST = 1;
    DMA_Config_BLE_RX.KEEP_REGS = 1;
    DMA_Config_BLE_RX.HSIZE = 2;
    DMA_Config_BLE_RX.REST_EN = 0;
    DMA_Config_BLE_RX.CHANNEL_PRIORITY = 0;
    DMA_Config_BLE_RX.ARS = 0;
    DMA_Config_BLE_RX.MODE = 1;
    DMA_Config_BLE_RX.INC_SRC = 1;
    DMA_Config_BLE_RX.INC_DST = 1;
    DMA_Config_BLE_RX.CH_EN = 0;
    DMA_Config_BLE_RX.INE_DONE = 0;
    DMA_Config_BLE_RX.INE_ERROR = 0;


    DMA_CH_setReq(CMSDK_DMA, 7, 1);
    DMA_CH_setSZ(CMSDK_DMA, 0, 138, 1);
    DMA_CH_setA0(CMSDK_DMA, 0X40020010, 1);
    DMA_CH_setA1(CMSDK_DMA, (uint32_t)data_out, 1);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config_BLE_RX, 1); 
}


int main(void) {
    
    
    //ble_send_data(BLE0, data, 138);


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
    
    BLE_Config.enable = 1;
    BLE_Config.mode = 0;
    BLE_Config.tx_irq_en = 1;
    BLE_Config.rx_irq_en = 1;
    BLE_Config.dma_mode = 1;

    ble_config(BLE0, &BLE_Config);

}

void __attribute__((used)) GPIO_INT_02_Handler(void)
{
    ble_clear_irq(BLE0, 0, 1);
    DMA_CH_enable(CMSDK_DMA, 1, 1);
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


