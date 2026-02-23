#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h" 

#include "system_macros.h"

#include <stdio.h>
#include <string.h>
#include <stdarg.h> 
#include "stdbool.h"


//Register layering of BLE

typedef struct 
{
    __IO   uint32_t  CTRL;          // Offset: 0x000 Control Register (R/W) 
    __IO   uint32_t  INTENABLE;     // Offset: 0x004 Interrupt Status Register (R/W) 
    __IO   uint32_t  INTCLEAR;      // Offset: 0x008 Interrupt Status Register (R/W) 

    __IO   uint32_t  reserved;      /*! RESERVED */

    __IO   uint32_t  DATA[256];     // Offset: 0x010 Data Memory (R/W) 
}  ble_typedef;


typedef struct 
{
    bool enable;
    bool mode;
    bool tx_irq_en;
    bool rx_irq_en;
    bool dma_mode;
}  ble_configuration;




void ble_set_tx_irq( ble_typedef *BLE);



void ble_set_rx_irq( ble_typedef *BLE);


void ble_clear_irq( ble_typedef *BLE, bool tx_irq, bool rx_irq);




void ble_config( ble_typedef *BLE,  ble_configuration *CONFIG);

void ble_send_data( ble_typedef *BLE,  uint32_t* data, int size);

void ble_receive_data( ble_typedef *BLE,  uint32_t* data, int size); 

#ifdef __cplusplus
}
#endif
