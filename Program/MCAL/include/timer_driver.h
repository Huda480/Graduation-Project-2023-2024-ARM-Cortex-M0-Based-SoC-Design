#pragma once

#ifdef __cplusplus
 extern "C" {
#endif


#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h"

#include "system_macros.h"


//////////////////////////////////Register layering of timer


typedef struct
{
  __IO   uint32_t  CTRL;          /*!< Offset: 0x000 Control Register (R/W) */
  __IO   uint32_t  VALUE;         /*!< Offset: 0x004 Current Value Register (R/W) */
  __IO   uint32_t  RELOAD;        /*!< Offset: 0x008 Reload Value Register  (R/W) */
  union {
    __I    uint32_t  INTSTATUS;   /*!< Offset: 0x00C Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;    /*!< Offset: 0x00C Interrupt Clear Register ( /W) */
    };

} timer_typedef;

typedef struct
{
      uint32_t irq_en;
      uint32_t enable;
      uint32_t extin;
      uint32_t extinclk;
} timer_configuration;

#define TICK_MS 25

//////////////////////////////////Timer fucntion driver

//Timer enable interrupt
/*
    desc : Enables the interrupt for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_en_interrupt(timer_typedef *TIMER);


//Timer disable interrupt
/*
    desc : Disables the interrupt for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_dis_interrupt(timer_typedef *TIMER);


//Timer enable
/*
    desc : Enables the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_en(timer_typedef *TIMER);


//Timer disable
/*
    desc : Disables the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_dis(timer_typedef *TIMER);


//Timer enable extin as enable
/*
    desc : Enables the external input as an enable for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_extin_en (timer_typedef *TIMER);


//Timer disable extin as enable
/*
    desc : Disables the external input as an enable for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_extin_dis (timer_typedef *TIMER);


//Timer enable extin as clock
/*
    desc : Enables the external input as a clock for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_extin_en_clk (timer_typedef *TIMER);


//Timer disable extin as clock
/*
    desc : Disables the external input as a clock for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_extin_dis_clk (timer_typedef *TIMER);


//Timer return control register configuration
/*
    desc : Reads the control settings of the timer.
    args : Pointer to timer structure.
    return : The combined control settings (external input as a clock, external input as an enable, timer enable, interrupt enable).
*/
uint32_t timer_read_ctrl (timer_typedef *TIMER);


//Timer set value register
/*
    desc : Sets the value for the timer.
    args : Pointer to timer structure.
           value: The value to set.
    return : None
*/
void timer_set_value(timer_typedef *TIMER, uint32_t value);


//Timer read value register
/*
    desc : Reads the current value from the timer.
    args : Pointer to timer structure.
    return : The current value read from the timer.
*/
uint32_t timer_read_value(timer_typedef *TIMER);


//Timer set reload register
/*
    desc : Sets the reload value for the timer.
    args : Pointer to timer structure.
           value: The reload value to set.
    return : None
*/
void timer_set_reload(timer_typedef *TIMER, uint32_t value);


//Timer read reload register
/*
    desc : Reads the reload value from the timer.
    args : Pointer to timer structure.
    return : The reload value read from the timer.
*/
uint32_t timer_read_reload(timer_typedef *TIMER);


//Timer clear interrupt
/*
    desc : Clears the interrupt for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_clr_interrupt(timer_typedef *TIMER);


//Timer read interrupt status
/*
    desc : read the interrupt status of the  timer.
    args : Pointer to timer structure.
    return : The interrupt status (32-bit value).
*/
uint32_t  timer_interrupt_status(timer_typedef *TIMER);


//Timer full configuration
/*
    desc : Configure the  timer based on the provided configuration.
    args : Pointer to timer structure.
           CONFIG: Pointer to the timer Configuration structure containing configuration options.
    return : None
*/
void timer_config (timer_typedef *TIMER , timer_configuration *CONFIG);


//Timer IRQ handler
/*
    desc : Handle the interrupt for the timer(clear the interrupt and set reload and set value).
    args : None
    return : None
*/
void timer_irq_handler (void);

//Software timer initialization
/*
    desc : Configures timer to work as software timer.
    args : None
    return : None
*/
void software_timer_init (void);

#ifdef __cplusplus
}
#endif