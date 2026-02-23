#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h" 

#include "system_macros.h"


//////////////////////////////////Register layering of watchdog

typedef struct
{

  __IO    uint32_t  LOAD;          // <h> Watchdog Load Register </h>
  __I     uint32_t  VALUE;         // <h> Watchdog Value Register </h>
  __IO    uint32_t  CTRL;          // <h> Watchdog Control Register
                                   //   <o.1>    RESEN: Reset enable
                                   //   <o.0>    INTEN: Interrupt enable
                                   // </h>
  __O     uint32_t  INTCLR;        // <h> Watchdog Clear Interrupt Register </h>
  __I     uint32_t  RAWINTSTAT;    // <h> Watchdog Raw Interrupt Status Register </h>
  __I     uint32_t  MASKINTSTAT;   // <h> Watchdog Interrupt Status Register </h>
        uint32_t  RESERVED0[762];
  __IO    uint32_t  LOCK;          // <h> Watchdog Lock Register </h>
        uint32_t  RESERVED1[191];
  __IO    uint32_t  ITCR;          // <h> Watchdog Integration Test Control Register </h>
  __O     uint32_t  ITOP;          // <h> Watchdog Integration Test Output Set Register </h>

}watchdog_typedef;


//////////////////////////////////Watchdog configurations
typedef struct 
{
      uint32_t irq_en;
      uint32_t resen;

}watchdog_configuration;


//////////////////////////////////Watchdog fucntion driver

//Watchdog set load
/*
    desc : Sets the load value for the watchdog timer.
    args : Pointer to watchdog structure.
           value: The load value to set.
    return : None
*/
void watchdog_set_load(watchdog_typedef *WATCHDOG , uint32_t value);


//Watchdog read load
/*
    desc : Reads the load value from the watchdog timer.
    args : Pointer to watchdog structure.
    return : The load value read from the watchdog timer load register.
*/
uint32_t watchdog_read_load(watchdog_typedef *WATCHDOG);


//Watchdog return value
/*
    desc : Reads the current value from the watchdog timer.
    args : Pointer to watchdog structure.
    return : The current value read from the watchdog timer value register.
*/
uint32_t watchdog_read_value(watchdog_typedef *WATCHDOG);


//Watchdog enable interrupt
/*
    desc : Enables the interrupt for the watchdog timer.
    args : Pointer to watchdog structure.
    return : None
*/
void watchdog_en_interrupt (watchdog_typedef *WATCHDOG);


//Watchdog interrupt disable
/*
    desc : Disables the interrupt for the watchdog timer.
    args : Pointer to watchdog structure.
    return : None
*/
void watchdog_dis_interrupt (watchdog_typedef *WATCHDOG);


//Watchdog reset enable
/*
    desc : Enables the reset for the watchdog timer.
    args : Pointer to watchdog structure.
    return : None
*/
void watchdog_en_reset (watchdog_typedef *WATCHDOG);


//Watchdog reset disable
/*
    desc : Disables the reset for the watchdog timer.
    args : Pointer to watchdog structure.
    return : None
*/
void watchdog_dis_reset (watchdog_typedef *WATCHDOG);


//Watchdog read interrupt enable
/*
    desc : Reads the interrupt enable bit from the watchdog timer control register.
    args : Pointer to watchdog structure.
    return : The interrupt enable bit value (0 or 1) from the control register.
*/
uint32_t watchdog_read_cntrl_interrupt (watchdog_typedef *WATCHDOG);


//Watchdog read reset enable
/*
    desc : Reads the reset enable bit from the watchdog timer control register.
    args : Pointer to watchdog structure.
    return : The reset enable bit value (0 or 1) from the control register.
*/
uint32_t watchdog_read_cntrl_reset(watchdog_typedef *WATCHDOG);


//Watchdog interrupt clear
/*
    desc : Clears the interrupt for the watchdog timer.
    args : Pointer to watchdog structure.
    return : None
*/
void watchdog_clear_interrupt(watchdog_typedef *WATCHDOG);


//Watchdog read raw interrupt status
/*
    desc : Reads the raw interrupt status from the watchdog timer.
    args : Pointer to watchdog structure.
    return : The raw interrupt status value from the watchdog timer.
*/
uint32_t watchdog_read_ris(watchdog_typedef *WATCHDOG);


//Watchdog read masked interrupt status
/*
    desc : Reads the mask interrupt status from the watchdog timer.
    args : Pointer to watchdog structure.
    return : The mask interrupt status value from the watchdog timer.
*/
uint32_t watchdog_read_mis(watchdog_typedef *WATCHDOG);


//Watchdog unlock registers
/*
    desc : Unlocks the watchdog timer.
    args : Pointer to watchdog structure.
    return : None
*/
void watchdog_unlock(watchdog_typedef *WATCHDOG);


//Watchdog read lock register
/*
    desc : Reads the lock status from the watchdog timer.
    args : Pointer to watchdog structure.
    return : The lock status value (0: unlocked(default) or 1 : locked) from the control register.
*/
uint32_t watchdog_read_lock(watchdog_typedef *WATCHDOG);


//Watchdog full configuration
/*
    desc : Configures the watchdog timer based on the provided configuration.
    args : Pointer to watchdog structure.
           CONFIG: Pointer to a CMSDK_watchdog_configuration structure containing configuration options.
                  - irq_en: Set to 1 to enable interrupt, 0 to disable.
                  - resen: Set to 1 to enable reset, 0 to disable.
    return : None
*/
void watchdog_config (watchdog_typedef *WATCHDOG , watchdog_configuration* CONFIG);


//Watchdog IRQ handler
/*
    desc : Interrupt handler for the watchdog timer (clear the interrupt and set load value).
    args : None
    return : None
*/
void watchdog_irq_handler (void);

#ifdef __cplusplus
}
#endif
