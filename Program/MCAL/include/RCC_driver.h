#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_macros.h"
#include "math.h"

typedef struct
{
   __IO   uint32_t  scales_config;    /*!< Offset: 0x000 cofigrationregister Register (R/W) */
}rcc_typedef;


/*
    desc: Sets the configuration register for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.
        - PCLK_divider: The desired value for the peripheral clock (PCLK) divider.
        - TIMCLK_divider: The desired value for the timer clock (TIMCLK) divider.
        - WDOGCLK_divider: The desired value for the watchdog clock (WDOGCLK) divider.

    return: None (void)
*/

void rcc_set_config(rcc_typedef *RCC ,uint8_t PCLK_divider ,uint8_t TIMCLK_divider ,uint8_t WDOGCLK_divider);



/*
    desc: Sets the configuration register for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.
        - PCLK_divider: The desired value for the peripheral clock (PCLK) divider.

    return: None (void)
*/

void rcc_set_pclk_config(rcc_typedef *RCC ,uint8_t PCLK_divider)  ;




/*
    desc: Sets the configuration register for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.
        - TIMCLK_divider: The desired value for the timer clock (TIMCLK) divider.

    return: None (void)
*/

void rcc_set_timclk_config(rcc_typedef *RCC ,uint8_t TIMCLK_divider) ;



/*
    desc: Sets the configuration register for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.
        - WDOGCLK_divider: The desired value for the watchdog clock (WDOGCLK) divider.

    return: None (void)
*/

void rcc_set_wdogclk_config(rcc_typedef *RCC ,uint8_t WDOGCLK_divider) ;





/*
    desc: Reads the configuration register value for a specific peripheral.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.

    return:
        - The value of the scales_config register.
*/

uint32_t rcc_read_config(rcc_typedef *RCC);


#ifdef __cplusplus
}
#endif