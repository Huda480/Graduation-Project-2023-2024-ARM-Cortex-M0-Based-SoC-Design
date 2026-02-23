#include "watchdog_driver.h"


//////////////////////////////////Watchdog fucntion driver

//Watchdog set load
/*
    desc : Sets the load value for the watchdog timer.
    args : Pointer to watchdog structure..
           value: The load value to set.
    return : None
*/
void watchdog_set_load(watchdog_typedef *WATCHDOG , uint32_t value){
	WATCHDOG -> LOAD = value ;
}

//Watchdog read load
/*
    desc : Reads the load value from the watchdog timer.
    args : Pointer to watchdog structure..
    return : The load value read from the watchdog timer load register.
*/
uint32_t watchdog_read_load(watchdog_typedef *WATCHDOG){
	return WATCHDOG -> LOAD ;
}

//Watchdog return value
/*
    desc : Reads the current value from the watchdog timer.
    args : Pointer to watchdog structure..
    return : The current value read from the watchdog timer value register.
*/
uint32_t watchdog_read_value(watchdog_typedef *WATCHDOG){
	return WATCHDOG -> VALUE ;
}

//Watchdog enable interrupt
/*
    desc : Enables the interrupt for the watchdog timer.
    args : Pointer to watchdog structure..
    return : None
*/
void watchdog_en_interrupt (watchdog_typedef *WATCHDOG){
	WATCHDOG -> CTRL |= WATCHDOG_CTRL_INTEN_Msk ;
}

//Watchdog interrupt disable
/*
    desc : Disables the interrupt for the watchdog timer.
    args : Pointer to watchdog structure..
    return : None
*/
void watchdog_dis_interrupt (watchdog_typedef *WATCHDOG){
	WATCHDOG -> CTRL &= ~WATCHDOG_CTRL_INTEN_Msk ;
}

//Watchdog reset enable
/*
    desc : Enables the reset for the watchdog timer.
    args : Pointer to watchdog structure..
    return : None
*/
void watchdog_en_reset (watchdog_typedef *WATCHDOG){
	WATCHDOG -> CTRL |= WATCHDOG_CTRL_RESEN_Msk ;
}

//Watchdog reset disable
/*
    desc : Disables the reset for the watchdog timer.
    args : Pointer to watchdog structure..
    return : None
*/
void watchdog_dis_reset (watchdog_typedef *WATCHDOG){
	WATCHDOG -> CTRL &= ~ WATCHDOG_CTRL_RESEN_Msk ;
}

//Watchdog read interrupt enable
/*
    desc : Reads the interrupt enable bit from the watchdog timer control register.
    args : Pointer to watchdog structure..
    return : The interrupt enable bit value (0 or 1) from the control register.
*/
uint32_t watchdog_read_cntrl_interrupt (watchdog_typedef *WATCHDOG){
	return WATCHDOG -> CTRL &=  WATCHDOG_CTRL_INTEN_Msk ;
}

//Watchdog read reset enable
/*
    desc : Reads the reset enable bit from the watchdog timer control register.
    args : Pointer to watchdog structure..
    return : The reset enable bit value (0 or 1) from the control register.
*/
uint32_t watchdog_read_cntrl_reset(watchdog_typedef *WATCHDOG){
	return WATCHDOG -> CTRL &=  WATCHDOG_CTRL_RESEN_Msk ;
}

//Watchdog interrupt clear
/*
    desc : Clears the interrupt for the watchdog timer.
    args : Pointer to watchdog structure..
    return : None
*/
void watchdog_clear_interrupt(watchdog_typedef *WATCHDOG){
	WATCHDOG -> INTCLR = WATCHDOG_INTCLR_Msk ;
}

//Watchdog read raw interrupt status
/*
    desc : Reads the raw interrupt status from the watchdog timer.
    args : Pointer to watchdog structure..
    return : The raw interrupt status value from the watchdog timer.
*/
uint32_t watchdog_read_ris(watchdog_typedef *WATCHDOG){
	return WATCHDOG -> RAWINTSTAT ;
}

//Watchdog read masked interrupt status
/*
    desc : Reads the mask interrupt status from the watchdog timer.
    args : Pointer to watchdog structure..
    return : The mask interrupt status value from the watchdog timer.
*/
uint32_t watchdog_read_mis(watchdog_typedef *WATCHDOG){
	return WATCHDOG -> MASKINTSTAT ;
}

//Watchdog unlock registers
/*
    desc : Unlocks the watchdog timer.
    args : Pointer to watchdog structure..
    return : None
*/
void watchdog_unlock(watchdog_typedef *WATCHDOG){
	WATCHDOG -> LOCK = WATCHDOG_LOCK_Msk ;
}

//Watchdog read lock register
/*
    desc : Reads the lock status from the watchdog timer.
    args : Pointer to watchdog structure..
    return : The lock status value (0: unlocked(default) or 1 : locked) from the control register.
*/
uint32_t watchdog_read_lock(watchdog_typedef *WATCHDOG){
	return WATCHDOG -> LOCK &= 0x1ul ;
}

//Watchdog full configuration
/*
    desc : Configures the watchdog timer based on the provided configuration.
    args : Pointer to watchdog structure..
           CONFIG: Pointer to a CMSDK_WATCHDOG_Configuration structure containing configuration options.
                  - irq_en: Set to 1 to enable interrupt, 0 to disable.
                  - resen: Set to 1 to enable reset, 0 to disable.
    return : None
*/
void watchdog_config (watchdog_typedef *WATCHDOG , watchdog_configuration* CONFIG){
	  uint32_t cntrl = 0;
      if(CONFIG->irq_en == 1) {cntrl |= WATCHDOG_CTRL_INTEN_Msk;}
      if(CONFIG->resen== 1) {cntrl |= WATCHDOG_CTRL_RESEN_Msk;}
	  WATCHDOG -> CTRL = cntrl ;

}

//Watchdog IRQ handler
/*
    desc : Interrupt handler for the watchdog timer (clear the interrupt and set load value).
    args : None
    return : None
*/
void WATCHDOG_DRIVER_IRQ_HANDLER (void){
    watchdog_clear_interrupt (CMSDK_WATCHDOG);
    watchdog_set_load (CMSDK_WATCHDOG ,RELOAD_32);
}
