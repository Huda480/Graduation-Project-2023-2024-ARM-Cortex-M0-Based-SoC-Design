#include "../include/gpio_driver.h"

////////////////////////////////// Gpio Function Driver

// gpio set output enable
/*
    desc : Sets the pins as output.
    args : Pointer to GPIO structure and the output enable set value.
    return : None
*/
void gpio_set_out_enable(gpio_typedef *GPIO, uint32_t outenableset) {
    GPIO->OUTENABLESET = outenableset;
}

// gpio set input pins
/*
    desc : Sets pins as input.
    args : Pointer to GPIO structure and the output enable clear value.
    return : None
*/
void gpio_clr_out_enable(gpio_typedef *GPIO, uint32_t outenableclr) {
    GPIO->OUTENABLECLR = outenableclr;
}

// gpio read pin
/*
    desc : Reads the data from the pin.
    args : Pointer to GPIO structure.
    return : Returns the data read from the pin.
*/
uint32_t gpio_read_pin(gpio_typedef *GPIO) {
    return GPIO->DATA;
}

// gpio get pin direction
/*
    desc : Returns the direction of the pin (input or output).
    args : Pointer to GPIO structure.
    return : Returns the direction of the pin.
*/
uint32_t gpio_get_pin_direction(gpio_typedef *GPIO) {
    return GPIO->OUTENABLESET;
}

// gpio write output data
/*
    desc : Writes output data.
    args : Pointer to GPIO structure and the output data value.
    return : None
*/
void gpio_write_out_data(gpio_typedef *GPIO, uint32_t output_data) {
    GPIO->DATAOUT = output_data;
}

// gpio set alternate function
/*
    desc : Enables alternate function.
    args : Pointer to GPIO structure and the alternate function set value.
    return : None
*/
void gpio_set_alt_func(gpio_typedef *GPIO, uint32_t altfuncset) {
    GPIO->ALTFUNCSET = altfuncset;
}

// gpio clear alternate function
/*
    desc : Disables alternate function.
    args : Pointer to GPIO structure and the alternate function clear value.
    return : None
*/
void gpio_clr_alt_func(gpio_typedef *GPIO, uint32_t altfuncclr) {
    GPIO->ALTFUNCCLR = altfuncclr;
}

// gpio alternate function selector set
/*
    desc : Selects desired alternate function for each pin
    args : Pointer to GPIO structure and the alternate function selection set value.
    return : None
*/
void gpio_set_alt_func_sel(gpio_typedef *GPIO, uint32_t altfuncselset) {
    GPIO->ALTFUNCS = altfuncselset;
}

// gpio alternate function selector clear
/*
    desc : Clears selector for alternate function
    args : Pointer to GPIO structure and the alternate function selection clear value.
    return : None
*/
void gpio_clr_alt_func_sel(gpio_typedef *GPIO, uint32_t altfuncselclr) {
    GPIO->ALTFUNCS
     = altfuncselclr;
}

// gpio read alternate function
/*
    desc : Returns whether the pin is enabled as gpio or alternate function.
    args : Pointer to GPIO structure.
    return : Returns the state of the pin (normal or alternate function).
*/
uint32_t gpio_read_alt_func(gpio_typedef *GPIO) {
    return GPIO->ALTFUNCSET;
}

// gpio clear interrupt
/*
    desc : Clears the interrupt .
    args : Pointer to GPIO structure and the interrupt value.
    return : none.
*/
void gpio_clear_interrupt(gpio_typedef *GPIO, uint32_t value) {
    GPIO->INTCLEAR = (1 << value);
}
// gpio read interrupt
/*
    desc : Reads interrupt status.
    args : Pointer to GPIO structure
    return : Returns the interrupt status.
*/
uint32_t gpio_read_interrupt(gpio_typedef *GPIO) {
    return GPIO->INTSTATUS;
}
// gpio enable interrupt
/*
    desc : Enables interrupt.
    args : Pointer to GPIO structure and the interrupt value.
    return : Returns the set interrupt status.
*/
uint32_t gpio_en_interrupt(gpio_typedef *GPIO, uint32_t value) {
    GPIO->INTENSET = (1 << value);
    return GPIO->INTENSET;
}

// gpio disable interrupt
/*
    desc : Disables interrupt.
    args : Pointer to GPIO structure and the interrupt value.
    return : Returns the cleared interrupt status.
*/
uint32_t gpio_dis_interrupt(gpio_typedef *GPIO, uint32_t value) {
    GPIO->INTENCLR = (1 << value);
    return GPIO->INTENCLR;
}

// gpio enable high level interrupt
/*
    desc : Changes the interrupt type to high level.
    args : Pointer to GPIO structure and the interrupt value.
    return : None
*/
void gpio_high_level_interrupt(gpio_typedef *GPIO, uint32_t value) {
    GPIO->INTTYPECLR = (1 << value); /* Clear INT TYPE bit */
    GPIO->INTPOLSET = (1 << value);  /* Set INT POLarity bit */
}

// gpio enable rising edge interrupt
/*
    desc : Changes the interrupt type to rising edge.
    args : Pointer to GPIO structure and the interrupt value.
    return : None
*/
void gpio_rising_edge_interrupt(gpio_typedef *GPIO, uint32_t value) {
    GPIO->INTTYPESET = (1 << value); /* Set INT TYPE bit */
    GPIO->INTPOLSET = (1 << value);  /* Set INT POLarity bit */
}

//  gpio enable low level interrupt
/*
    desc : Changes the interrupt type to low level.
    args : Pointer to GPIO structure and the interrupt value.
    return : None
*/
void gpio_low_level_interrupt(gpio_typedef *GPIO, uint32_t value) {
    GPIO->INTTYPECLR = (1 << value); /* Clear INT TYPE bit */
    GPIO->INTPOLCLR = (1 << value); /* Clear INT POLarity bit */
}

//  gpio enable falling edge interrupt
/*
    desc : Changes the interrupt type to falling edge.
    args : Pointer to GPIO structure and the interrupt value.
    return : None
*/
void gpio_falling_edge_interrupt(gpio_typedef *GPIO, uint32_t value) {
    GPIO->INTTYPESET = (1 << value); /* Set INT TYPE bit */
    GPIO->INTPOLCLR = (1 << value); /* Clear INT POLarity bit */
}

// gpio masked access
/*
    desc : Outputs the specified value on the desired port using a user-defined mask for masked access.
    args : Pointer to GPIO structure, value to be output, and mask.
    return : None
*/
void gpio_masked_write(gpio_typedef *GPIO, uint32_t value, uint32_t mask) {
    GPIO->LB_MASKED[0x00FF & mask] = value;
    GPIO->UB_MASKED[((0xFF00 & mask) >> 8)] = value;
}

// gpio full configuration
/*
    desc : Configures the GPIO settings.
    args : Pointer to GPIO structure and GPIO configuration structure.
    return : None
*/
void gpio_config(gpio_typedef *GPIO, gpio_configuration *CONFIG) {
    GPIO->OUTENABLESET = CONFIG->outenableset & GPIO_OUTENSET_Msk;
    GPIO->INTENSET = CONFIG->int_num & GPIO_INTTYPESET_Msk;
    if ((CONFIG->type == 0) | (CONFIG->type == 1)) {
        GPIO->INTPOLSET = CONFIG->int_num & GPIO_INTPOLSET_Msk;
    }
    if ((CONFIG->type == 2) | (CONFIG->type == 3)) {
        GPIO->INTPOLCLR = CONFIG->int_num & GPIO_INTPOLCLR_Msk;
    }
    if ((CONFIG->type == 1) | (CONFIG->type == 3)) {
        GPIO->INTTYPESET = CONFIG->int_num & GPIO_INTTYPESET_Msk;
    }
    if ((CONFIG->type == 0) | (CONFIG->type == 2)) {
        GPIO->INTTYPECLR = CONFIG->int_num & GPIO_INTTYPECLR_Msk;
    }
    GPIO->ALTFUNCSET = CONFIG->alt_func_num & GPIO_ALTFUNCSET_Msk;
    GPIO->ALTFUNCS = CONFIG->alt_func_sel_num;
}
//GPIO IRQ handlers
/*
    desc : Interrupt handler for the gpio ports (clear the interrupt).
    args : None
    return : None
*/
void gpio_irq_handler(uint32_t pin) {
    gpio_clear_interrupt(GPIO0, pin);
}
