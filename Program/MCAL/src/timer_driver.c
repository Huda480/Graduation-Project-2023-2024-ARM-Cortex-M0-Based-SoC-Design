#include "../include/timer_driver.h"


//////////////////////////////////Timer fucntion driver

//Timer enable interrupt
/*
    desc : Enables the interrupt for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_en_interrupt(timer_typedef *TIMER)
{
      TIMER->CTRL |= TIMER_CTRL_IRQEN_Msk;
}


//Timer disable interrupt
/*
    desc : Disables the interrupt for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_dis_interrupt(timer_typedef *TIMER)
{
      TIMER->CTRL &= ~TIMER_CTRL_IRQEN_Msk;
}

//Timer enable
/*
    desc : Enables the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_en(timer_typedef *TIMER)
{
      TIMER->CTRL |= TIMER_CTRL_EN_Msk;
}

//Timer disable
/*
    desc : Disables the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_dis(timer_typedef *TIMER)
{
      TIMER->CTRL &= ~TIMER_CTRL_EN_Msk;
}

//Timer enable extin as enable
/*
    desc : Enables the external input as an enable for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_extin_en (timer_typedef *TIMER){
      TIMER->CTRL |= TIMER_CTRL_SELEXTEN_Msk;
}

//Timer disable extin as enable
/*
    desc : Disables the external input as an enable for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_extin_dis (timer_typedef *TIMER){
      TIMER->CTRL &= ~TIMER_CTRL_SELEXTEN_Msk;
}

//Timer enable extin as clock
/*
    desc : Enables the external input as a clock for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_extin_en_clk (timer_typedef *TIMER){
      TIMER->CTRL |= TIMER_CTRL_SELEXTCLK_Msk;
}

//Timer disable extin as clock
/*
    desc : Disables the external input as a clock for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_extin_dis_clk (timer_typedef *TIMER){
      TIMER->CTRL &= ~TIMER_CTRL_SELEXTCLK_Msk;
}


//Timer return control register configuration
/*
    desc : Reads the control settings of the timer.
    args : Pointer to timer structure.
    return : The combined control settings (external input as a clock, external input as an enable, timer enable, interrupt enable).
*/
uint32_t timer_read_ctrl (timer_typedef *TIMER){
      return TIMER->CTRL &= (TIMER_CTRL_SELEXTCLK_Msk | TIMER_CTRL_SELEXTEN_Msk | TIMER_CTRL_EN_Msk |TIMER_CTRL_IRQEN_Msk);
}

//Timer set value register
/*
    desc : Sets the value for the timer.
    args : Pointer to timer structure.
           value: The value to set.
    return : None
*/
void timer_set_value(timer_typedef *TIMER, uint32_t value)
{
      TIMER->VALUE = value;
}


//Timer read value register
/*
    desc : Reads the current value from the timer.
    args : Pointer to timer structure.
    return : The current value read from the timer.
*/
uint32_t timer_read_value(timer_typedef *TIMER)
{
      return TIMER->VALUE;
}


//Timer set reload register
/*
    desc : Sets the reload value for the timer.
    args : Pointer to timer structure.
           value: The reload value to set.
    return : None
*/
void timer_set_reload(timer_typedef *TIMER, uint32_t value)
{
      TIMER->RELOAD = value;
}

//Timer read reload register
/*
    desc : Reads the reload value from the timer.
    args : Pointer to timer structure.
    return : The reload value read from the timer.
*/
uint32_t timer_read_reload(timer_typedef *TIMER)
{
      return TIMER->RELOAD;
}


//Timer clear interrupt
/*
    desc : Clears the interrupt for the timer.
    args : Pointer to timer structure.
    return : None
*/
void timer_clr_interrupt(timer_typedef *TIMER)
{
      TIMER->INTCLEAR = TIMER_INTCLEAR_Msk;
}


//Timer read interrupt status
/*
    desc : read the interrupt status of the  timer.
    args : Pointer to timer structure.
    return : The interrupt status (32-bit value).
*/
uint32_t  timer_interrupt_status(timer_typedef *TIMER)
{
      return TIMER->INTSTATUS;
}


//Timer full configuration
/*
    desc : Configure the  timer based on the provided configuration.
    args : Pointer to timer structure.
           CONFIG: Pointer to the timer Configuration structure containing configuration options.
    return : None
*/
void timer_config (timer_typedef *TIMER , timer_configuration *CONFIG)
{     
      uint32_t cntrl = 0;
      if(CONFIG->irq_en == 1)   {cntrl |= TIMER_CTRL_IRQEN_Msk;}
      if(CONFIG->enable==1)     {cntrl |=TIMER_CTRL_EN_Msk;}
      if(CONFIG->extin==1)      {cntrl |=TIMER_CTRL_SELEXTEN_Msk;}
      if(CONFIG->extinclk==1)   {cntrl |=TIMER_CTRL_SELEXTEN_Msk;}
      TIMER->CTRL = cntrl;
}


//Timer IRQ handler
/*
    desc : Handle the interrupt for the timer(clear the interrupt and set reload and set value).
    args : None
    return : None
*/
void timer_irq_handler (void) {
      timer_clr_interrupt     (TIMER0);
      timer_set_reload        (TIMER0,RELOAD_32);
      timer_set_value         (TIMER0,RELOAD_32);
}

void software_timer_init (void){
    timer_configuration configure;
    configure.irq_en = 1;
    configure.enable = 1;
    configure.extin = 0;
    configure.extinclk = 0;
    timer_config(TIMER0,&configure);
    timer_set_reload(TIMER0,TICK_MS);
} 
