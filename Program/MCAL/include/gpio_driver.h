#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_macros.h"
#include "math.h"

#define PORTWIDTH  16
#define ALTFUNC     4
#define SEL_BITS   ceil(log2(ALTFUNC)) 
#define total_bits  PORTWIDTH * SEL_BITS
#define num_registers ((int)(total_bits + 31 / 32))
#define addr  (num_registers *2)  

//////////////////////////////////Register layering of gpio
typedef struct
{
  __IO   uint32_t  DATA;             /*!< Offset: 0x000 DATA Register (R/W) */
  __IO   uint32_t  DATAOUT;          /*!< Offset: 0x004 Data Output Latch Register (R/W) */
         uint32_t  RESERVED0[2];
  __IO   uint32_t  OUTENABLESET;     /*!< Offset: 0x010 Output Enable Set Register  (R/W) */
  __IO   uint32_t  OUTENABLECLR;     /*!< Offset: 0x014 Output Enable Clear Register  (R/W) */
  __IO   uint32_t  ALTFUNCSET;       /*!< Offset: 0x018 Alternate Function Set Register  (R/W) */
  __IO   uint32_t  ALTFUNCCLR;       /*!< Offset: 0x01C Alternate Function Clear Register  (R/W) */
  __IO   uint32_t  INTENSET;         /*!< Offset: 0x020 Interrupt Enable Set Register  (R/W) */
  __IO   uint32_t  INTENCLR;         /*!< Offset: 0x024 Interrupt Enable Clear Register  (R/W) */
  __IO   uint32_t  INTTYPESET;       /*!< Offset: 0x028 Interrupt Type Set Register  (R/W) */
  __IO   uint32_t  INTTYPECLR;       /*!< Offset: 0x02C Interrupt Type Clear Register  (R/W) */
  __IO   uint32_t  INTPOLSET;        /*!< Offset: 0x030 Interrupt Polarity Set Register  (R/W) */
  __IO   uint32_t  INTPOLCLR;        /*!< Offset: 0x034 Interrupt Polarity Clear Register  (R/W) */
  union {
    __I    uint32_t  INTSTATUS;      /*!< Offset: 0x038 Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;       /*!< Offset: 0x038 Interrupt Clear Register ( /W) */
    };
  __O    uint32_t ALTFUNCS;          /*!< Offset: 0x03C/0x040 Alternate Function Select and Clear Register ( /W) */
         uint32_t RESERVED1[240]; 
  __IO   uint32_t LB_MASKED[256];    /*!< Offset: 0x400 - 0x7FC Lower byte Masked Access Register (R/W) */
  __IO   uint32_t UB_MASKED[256];    /*!< Offset: 0x800 - 0xBFC Upper byte Masked Access Register (R/W) */
} gpio_typedef;


typedef struct 
{
  uint32_t outenableset;
  uint32_t type;
  uint32_t int_num;
  uint32_t alt_func_sel_num;
  uint32_t alt_func_num;
} gpio_configuration;

////////////////////////////////// Gpio Function Driver

// gpio set output enable
/*
    desc : Sets the pins as output.
    args : Pointer to GPIO structure and the output enable set value.
    return : None
*/
void gpio_set_out_enable(gpio_typedef *GPIO, uint32_t outenableset);

// gpio set input pins
/*
    desc : Sets pins as input.
    args : Pointer to GPIO structure and the output enable clear value.
    return : None
*/
void gpio_clr_out_enable(gpio_typedef *GPIO, uint32_t outenableclr);

// gpio read pin
/*
    desc : Reads the data from the pin.
    args : Pointer to GPIO structure.
    return : Returns the data read from the pin.
*/
uint32_t gpio_read_pin(gpio_typedef *GPIO);

// gpio get pin direction
/*
    desc : Returns the direction of the pin (input or output).
    args : Pointer to GPIO structure.
    return : Returns the direction of the pin.
*/
uint32_t gpio_get_pin_direction(gpio_typedef *GPIO);

// gpio write output data
/*
    desc : Writes output data.
    args : Pointer to GPIO structure and the output data value.
    return : None
*/
void gpio_write_out_data(gpio_typedef *GPIO, uint32_t output_data);

// gpio set alternate function
/*
    desc : Enables alternate function.
    args : Pointer to GPIO structure and the alternate function set value.
    return : None
*/
void gpio_set_alt_func(gpio_typedef *GPIO, uint32_t altfuncset);

// gpio clear alternate function
/*
    desc : Disables alternate function.
    args : Pointer to GPIO structure and the alternate function clear value.
    return : None
*/
void gpio_clr_alt_func(gpio_typedef *GPIO, uint32_t altfuncclr);

// gpio alternate function selector set
/*
    desc : Selects desired alternate function for each pin
    args : Pointer to GPIO structure and the alternate function selection set value.
    return : None
*/
void gpio_set_alt_func_sel(gpio_typedef *GPIO, uint32_t altfuncselset);

// gpio alternate function selector clear
/*
    desc : Clears selector for alternate function
    args : Pointer to GPIO structure and the alternate function selection clear value.
    return : None
*/
void gpio_clr_alt_func_sel(gpio_typedef *GPIO, uint32_t altfuncselclr);

// gpio read alternate function
/*
    desc : Returns whether the pin is enabled as gpio or alternate function.
    args : Pointer to GPIO structure.
    return : Returns the state of the pin (normal or alternate function).
*/
uint32_t gpio_read_alt_func(gpio_typedef *GPIO);

// gpio clear interrupt
/*
    desc : Clears the interrupt and verifies that it is cleared.
    args : Pointer to GPIO structure and the interrupt value.
    return : Returns the interrupt status.
*/
void gpio_clear_interrupt(gpio_typedef *GPIO, uint32_t value);
// gpio read interrupt
/*
    desc : Reads interrupt status.
    args : Pointer to GPIO structure
    return : Returns the interrupt status.
*/
uint32_t gpio_read_interrupt(gpio_typedef *GPIO);
// gpio enable interrupt
/*
    desc : Enables interrupt.
    args : Pointer to GPIO structure and the interrupt value.
    return : Returns the set interrupt status.
*/
uint32_t gpio_en_interrupt(gpio_typedef *GPIO, uint32_t value);

// gpio disable interrupt
/*
    desc : Disables interrupt.
    args : Pointer to GPIO structure and the interrupt value.
    return : Returns the cleared interrupt status.
*/
uint32_t gpio_dis_interrupt(gpio_typedef *GPIO, uint32_t value);

// gpio enable high level interrupt
/*
    desc : Changes the interrupt type to high level.
    args : Pointer to GPIO structure and the interrupt value.
    return : None
*/
void gpio_high_level_interrupt(gpio_typedef *GPIO, uint32_t value);

// gpio enable rising edge interrupt
/*
    desc : Changes the interrupt type to rising edge.
    args : Pointer to GPIO structure and the interrupt value.
    return : None
*/
void gpio_rising_edge_interrupt(gpio_typedef *GPIO, uint32_t value);

//  gpio enable low level interrupt
/*
    desc : Changes the interrupt type to low level.
    args : Pointer to GPIO structure and the interrupt value.
    return : None
*/
void gpio_low_level_interrupt(gpio_typedef *GPIO, uint32_t Num);

//  gpio enable falling edge interrupt
/*
    desc : Changes the interrupt type to falling edge.
    args : Pointer to GPIO structure and the interrupt value.
    return : None
*/
void gpio_falling_edge_interrupt(gpio_typedef *GPIO, uint32_t Num);

// gpio masked access
/*
    desc : Outputs the specified value on the desired port using a user-defined mask for masked access.
    args : Pointer to GPIO structure, value to be output, and mask.
    return : None
*/
void gpio_masked_write(gpio_typedef *GPIO, uint32_t value, uint32_t mask);

// gpio full configuration
/*
    desc : Configures the GPIO settings.
    args : Pointer to GPIO structure and GPIO configuration structure.
    return : None
*/
void gpio_config(gpio_typedef *GPIO, gpio_configuration *CONFIG);
//GPIO IRQ handlers
/*
    desc : Interrupt handler for the gpio ports (clear the interrupt).
    args : None
    return : None
*/
void gpio_irq_handler(uint32_t pin);


  
#ifdef __cplusplus
}
#endif


