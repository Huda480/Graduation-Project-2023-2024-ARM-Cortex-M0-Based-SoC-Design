#include "../include/RCC_driver.h"


/*
    desc: Sets the configuration register for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.
        - PCLK_divider: The desired value for the peripheral clock (PCLK) divider.
        - TIMCLK_divider: The desired value for the timer clock (TIMCLK) divider.
        - WDOGCLK_divider: The desired value for the watchdog clock (WDOGCLK) divider.

    return: None (void)
*/

void rcc_set_config(rcc_typedef *RCC ,uint8_t PCLK_divider ,uint8_t TIMCLK_divider ,uint8_t WDOGCLK_divider) {
    RCC->scales_config = (PCLK_divider) | (TIMCLK_divider << 8) | (WDOGCLK_divider << 16) ;
}



/*
    desc: Sets the configuration register for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.
        - PCLK_divider: The desired value for the peripheral clock (PCLK) divider.

    return: None (void)
*/

void rcc_set_pclk_config(rcc_typedef *RCC ,uint8_t PCLK_divider) {
    RCC->scales_config &= ~(0xFF);
    RCC->scales_config |= (PCLK_divider) ;
}



/*
    desc: Sets the configuration register for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.
        - TIMCLK_divider: The desired value for the timer clock (TIMCLK) divider.

    return: None (void)
*/

void rcc_set_timclk_config(rcc_typedef *RCC ,uint8_t TIMCLK_divider) {
    RCC->scales_config &= ~(0xFF << 8);
    RCC->scales_config |= (TIMCLK_divider << 8);
}



/*
    desc: Sets the configuration register for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.
        - WDOGCLK_divider: The desired value for the watchdog clock (WDOGCLK) divider.

    return: None (void)
*/

void rcc_set_wdogclk_config(rcc_typedef *RCC ,uint8_t WDOGCLK_divider) {
    RCC->scales_config &= ~(0xFF << 16);
    RCC->scales_config |= (WDOGCLK_divider << 16) ;
}


/*
    desc: Reads the configuration register value for RCC.

    args:
        - RCC: A pointer to the RCC (Reset and Clock Control) peripheral structure.

    return:
        - The value of the scales_config register.
*/

uint32_t rcc_read_config(rcc_typedef *RCC) {
    return RCC->scales_config;
}