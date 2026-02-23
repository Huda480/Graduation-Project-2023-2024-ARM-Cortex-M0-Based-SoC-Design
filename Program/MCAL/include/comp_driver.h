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


//Register layering of COMP

typedef struct 
{
    __IO   uint32_t  CTRL;          // Offset: 0x000 Control Register (R/W) 
    __IO   uint32_t  INTENABLE;     // Offset: 0x004 Interrupt Status Register (R/W) 
      
    union {
    __I    uint32_t  INTSTATUS;     /*!< Offset: 0x008 Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;      /*!< Offset: 0x008 Interrupt Clear Register ( /W) */
    };

    __IO   uint32_t  reserved;      /*! RESERVED */

    __I    uint32_t  DATA[2560];    // Offset: 0x010 Data Memory (R/W) 
}  comp_typedef;


typedef struct 
{
    bool enable;
    bool received_irq_en;
    bool full_irq_en;
}  comp_configuration;



void comp_set_received_irq( comp_typedef *COMP);

void comp_set_full_irq( comp_typedef *COMP);

void comp_clear_irq( comp_typedef *COMP, bool received_irq, bool full_irq);

void comp_config( comp_typedef *COMP,  comp_configuration *CONFIG);

void comp_receive_data( comp_typedef *COMP,  uint32_t* data, int size); 


#ifdef __cplusplus
}
#endif
