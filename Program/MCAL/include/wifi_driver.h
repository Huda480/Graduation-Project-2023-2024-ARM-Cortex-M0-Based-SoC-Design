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


//Register layering of WIFI

typedef struct 
{
    __IO   uint32_t  CTRL;          // Offset: 0x000 Control Register (R/W) 
    __IO   uint32_t  INTENABLE;     // Offset: 0x004 Interrupt Status Register (R/W) 
    __IO   uint32_t  INTCLEAR;      // Offset: 0x008 Interrupt Status Register (R/W) 

    __IO   uint32_t  reserved;      /*! RESERVED */

    __IO   uint32_t  DATA[256];     // Offset: 0x010 Data Memory (R/W) 
}  wifi_typedef;


typedef struct 
{
    bool enable;
    bool mode;
    bool tx_irq_en;
    bool rx_irq_en;
    bool dma_mode;
}  wifi_configuration;




void wifi_set_tx_irq( wifi_typedef *WIFI);



void wifi_set_rx_irq( wifi_typedef *WIFI);


void wifi_clear_irq( wifi_typedef *WIFI, bool tx_irq, bool rx_irq);



void wifi_config( wifi_typedef *WIFI,  wifi_configuration *CONFIG);


void wifi_send_data( wifi_typedef *WIFI,  uint32_t* data, int size);

void wifi_receive_data( wifi_typedef *WIFI,  uint32_t* data, int size); 


#ifdef __cplusplus
}
#endif
