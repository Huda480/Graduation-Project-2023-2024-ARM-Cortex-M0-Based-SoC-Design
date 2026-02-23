#include "../include/dualtimer_driver.h"


//////////////////////////////////Dualtimer driver

//Dual timer 1 set load register
/*
    desc : Set the load value for Timer 1 in the  Dual Timer.
    args : pointer to dualtimer struct
           value: The value to set as the load value for Timer 1.
    return : None
*/
void dualtimer_set_timer1_load (dualtimer_typedef *dualtimer ,uint32_t value){
	dualtimer -> Timer1Load = value ;
}

//Dual timer 1 read load register
/*
    desc : Read the load value for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The load value for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_load (dualtimer_typedef *dualtimer ){
	return dualtimer -> Timer1Load ;
}

//Dual timer 1 read value register
/*
    desc : Read the current value of Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The current value of Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_value (dualtimer_typedef *dualtimer ){
	return dualtimer -> Timer1Value ;
}


//Dual timer 1 set one shoot mode
/*
    desc : Enable the one-shot mode for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer1_oneshot (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control |= DUALTIMER1_CTRL_ONESHOOT_Msk  ;
}


//Dual timer 1 set wrapping mode
/*
    desc : Disable the one-shot mode for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer1_oenshot (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control &= ~DUALTIMER1_CTRL_ONESHOOT_Msk  ;
}

//Dual timer 1 set to 32 bits
/*
    desc : Set the  size for Timer 1 to 32bits in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_32 (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control |= DUALTIMER1_CTRL_SIZE_Msk  ;
}


//Dual timer 1 set to 16 bits
/*
    desc : Set the  size for Timer 1 to 16 bits in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_16 (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control &= ~ DUALTIMER1_CTRL_SIZE_Msk  ;
}

//Dual timer 1 enable interrupt
/*
    desc : Enable the interrupt for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer1_interrupt (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control |=  DUALTIMER1_CTRL_INTEN_Msk  ;
}


//Dual timer 1 disable interrupt
/*
    desc : Disable the interrupt for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer1_interrupt (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control &= ~  DUALTIMER1_CTRL_INTEN_Msk  ;
}

//Dual timer 1 set prescale to 256
/*
    desc : Set the prescale value to 256 for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_prescale_256 (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control |= (0b10 << DUALTIMER1_CTRL_PRESCALE_Pos)  ;
}

//Dual timer 1 set prescale to 16
/*
    desc : Set the prescale value to 16 for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_prescale_16 (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control |= (0b01 << DUALTIMER1_CTRL_PRESCALE_Pos)  ;
}


//Dual timer 1 disable prescale
/*
    desc : Set the prescale value to 1 for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer1_prescale (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control &= (0b00 << DUALTIMER1_CTRL_PRESCALE_Pos)  ;
}

//Dual timer 1 set periodic mode
/*
    desc : Set the periodic mode for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_periodic (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control |= DUALTIMER1_CTRL_ONESHOOT_Msk  ;
}


//Dual timer 1 set free running mode
/*
    desc : Set the free running mode for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_freerunning (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control |= DUALTIMER1_CTRL_MODE_Msk  ;
}

//Dual timer 1 enable timer
/*
    desc : Enable Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer1 (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control &= ~DUALTIMER1_CTRL_MODE_Msk  ;
}

//Dual timer 1 disable timer
/*
    desc : Disable Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer1 (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1Control &= ~DUALTIMER1_CTRL_EN_Msk  ;
}


//Dual timer 1 read control bits
/*
    desc : Read the control register value for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The control register value for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_cntrl (dualtimer_typedef *dualtimer ){
	return dualtimer -> Timer1Control ;
}

//Dual timer 1 interrupt clear
/*
    desc : Clear the interrupt for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_clear_timer1_interrupt (dualtimer_typedef *dualtimer ){
	dualtimer -> Timer1IntClr = DUALTIMER1_INTCLR_Msk  ;
}

//Dual timer 1 read raw interrupt status
/*
    desc : Read the raw interrupt status for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The raw interrupt status for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_ris (dualtimer_typedef *dualtimer ){
	return dualtimer -> Timer1RIS & DUALTIMER1_RAWINTSTAT_Msk  ;
}

//Dual timer 1 read masked interrupt status
/*
    desc : Read the masked interrupt status for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The masked interrupt status for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_mis (dualtimer_typedef *dualtimer ){
	return dualtimer -> Timer1MIS & DUALTIMER1_MASKINTSTAT_Msk  ;
}

//Dual timer 1 set back ground load
/*
    desc : Set the background load value for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
           value: The value to set as the background load value for Timer 1.
    return : None
*/
void dualtimer_set_timer1_bgload (dualtimer_typedef *dualtimer ,uint32_t value ){
	dualtimer -> Timer1BGLoad = value ;
}

//Dual timer 1 read background load
/*
    desc : Read the background load value for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The background load value for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_bgload (dualtimer_typedef *dualtimer ){
	return dualtimer -> Timer1BGLoad;
}

// Dual timer 2 set load register
/*
    desc : Set the load value for Timer 2 in the  Dual Timer.
    args : pointer to dualtimer struct
           value: The value to set as the load value for Timer 2.
    return : None
*/
void dualtimer_set_timer2_load(dualtimer_typedef *dualtimer, uint32_t value){
    dualtimer->Timer2Load = value;
}

// Dual timer 2 read load register
/*
    desc : Read the load value for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The load value for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_load(dualtimer_typedef *dualtimer){
    return dualtimer->Timer2Load;
}

// Dual timer 2 read value register
/*
    desc : Read the current value of Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The current value of Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_value(dualtimer_typedef *dualtimer){
    return dualtimer->Timer2Value;
}

// Dual timer 2 set one-shot mode
/*
    desc : Enable the one-shot mode for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer2_oneshot(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control |= DUALTIMER2_CTRL_ONESHOOT_Msk;
}

// Dual timer 2 set wrapping mode
/*
    desc : Disable the one-shot mode for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer2_oneshot(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control &= ~DUALTIMER2_CTRL_ONESHOOT_Msk;
}

// Dual timer 2 set to 32 bits
/*
    desc : Set the  size for Timer 2 to 32 bits in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_32(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control |= DUALTIMER2_CTRL_SIZE_Msk;
}

// Dual timer 2 set to 16 bits
/*
    desc : Set the  size for Timer 2 to 16 bits in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_16(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control &= ~DUALTIMER2_CTRL_SIZE_Msk;
}

// Dual timer 2 enable interrupt
/*
    desc : Enable the interrupt for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer2_interrupt(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control |= DUALTIMER2_CTRL_INTEN_Msk;
}

// Dual timer 2 disable interrupt
/*
    desc : Disable the interrupt for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer2_interrupt(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control &= ~DUALTIMER2_CTRL_INTEN_Msk;
}

// Dual timer 2 set prescale to 256
/*
    desc : Set the prescale value to 256 for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_prescale_256(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control |= (0b10 << DUALTIMER2_CTRL_PRESCALE_Pos);
}

// Dual timer 2 set prescale to 16
/*
    desc : Set the prescale value to 16 for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_prescale_16(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control |= (0b01 << DUALTIMER2_CTRL_PRESCALE_Pos);
}

// Dual timer 2 disable prescale
/*
    desc : Set the prescale value to 1 for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer2_prescale(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control &= ~(0b11 << DUALTIMER2_CTRL_PRESCALE_Pos);
}

// Dual timer 2 set periodic mode
/*
    desc : Set the periodic mode for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_periodic(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control |= DUALTIMER2_CTRL_MODE_Msk;
}

// Dual timer 2 set free running mode
/*
    desc : Set the free running mode for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_freerunning(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control &=~ DUALTIMER2_CTRL_MODE_Msk;
}

// Dual timer 2 enable timer
/*
    desc : Enable Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer2(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control |= DUALTIMER2_CTRL_EN_Msk;
}

// Dual timer 2 disable timer
/*
    desc : Disable Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer2(dualtimer_typedef *dualtimer){
    dualtimer->Timer2Control &= ~DUALTIMER2_CTRL_EN_Msk;
}

// Dual timer 2 read control bits
/*
    desc : Read the control register value for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The control register value for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_cntrl(dualtimer_typedef *dualtimer){
    return dualtimer->Timer2Control;
}

// Dual timer 2 interrupt clear
/*
    desc : Clear the interrupt for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_clear_timer2_interrupt(dualtimer_typedef *dualtimer){
    dualtimer->Timer2IntClr = DUALTIMER2_INTCLR_Msk;
}

// Dual timer 2 read raw interrupt status
/*
    desc : Read the raw interrupt status for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The raw interrupt status for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_ris(dualtimer_typedef *dualtimer){
    return dualtimer->Timer2RIS & DUALTIMER2_RAWINTSTAT_Msk;
}

// Dual timer 2 read masked interrupt status
/*
    desc : Read the masked interrupt status for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The masked interrupt status for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_mis(dualtimer_typedef *dualtimer){
    return dualtimer->Timer2MIS & DUALTIMER2_MASKINTSTAT_Msk;
}

// Dual timer 2 set background load
/*
    desc : Set the background load value for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
           value: The value to set as the background load value for Timer 2.
    return : None
*/
void dualtimer_set_timer2_bgload(dualtimer_typedef *dualtimer, uint32_t value){
    dualtimer->Timer2BGLoad = value;
}

// Dual timer 2 read background load
/*
    desc : Read the background load value for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The background load value for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_bgload(dualtimer_typedef *dualtimer){
    return dualtimer->Timer2BGLoad;
}


//Dual timer full configuration
/*
    desc : Configure the Dual Timer based on the provided configuration.
    args : pointer to dualtimer struct
           CONFIG: Pointer to struct
    return : None
*/

void dualtimer_config (dualtimer_typedef *dualtimer,  dualtimer_configuration *CONFIG)
{

    uint32_t cntrl_a = 0; //Timer 1 control signal
    
    if(CONFIG->irq_en1 == 1) {cntrl_a |= DUALTIMER1_CTRL_INTEN_Msk;}
    if(CONFIG->enable1 ==1  ) {cntrl_a |= DUALTIMER1_CTRL_EN_Msk;}
    if(CONFIG->oneshot1 == 1) {cntrl_a |= DUALTIMER1_CTRL_ONESHOOT_Msk;}
    if(CONFIG->freerunning1 == 1) {cntrl_a |= DUALTIMER1_CTRL_MODE_Msk;}
    if(CONFIG->prescale1 == 2) {cntrl_a |=0b10 << DUALTIMER1_CTRL_PRESCALE_Pos;}
    else if (CONFIG->prescale1 == 1) {cntrl_a |=0b01 << DUALTIMER1_CTRL_PRESCALE_Pos;}
    else {cntrl_a |=0b00 << DUALTIMER1_CTRL_PRESCALE_Pos;}
    if(CONFIG->bits1 == 1) {cntrl_a |= DUALTIMER1_CTRL_SIZE_Msk;}

    dualtimer -> Timer1Control = cntrl_a ;

    uint32_t cntrl_b = 0; //Timer 2 control signal

    if(CONFIG->irq_en2 == 1) {cntrl_b |= DUALTIMER2_CTRL_INTEN_Msk;}
    if(CONFIG->oneshot2 == 1) {cntrl_b |= DUALTIMER2_CTRL_ONESHOOT_Msk;}
    if(CONFIG->enable2 ==1  ) {cntrl_b |= DUALTIMER2_CTRL_EN_Msk;}
    if(CONFIG->freerunning2 == 1) {cntrl_b |= DUALTIMER2_CTRL_MODE_Msk;}
    if(CONFIG->prescale2 == 2) {cntrl_b |=0b10 << DUALTIMER2_CTRL_PRESCALE_Pos;}
    else if (CONFIG->prescale2 == 1) {cntrl_b |=0b01 << DUALTIMER2_CTRL_PRESCALE_Pos;}
    else {cntrl_b |=0b00 << DUALTIMER2_CTRL_PRESCALE_Pos;}
    if(CONFIG->bits2 == 1) {cntrl_b |= DUALTIMER2_CTRL_SIZE_Msk;}

    dualtimer -> Timer2Control = cntrl_b ;
}


//Dual timer combined IRQ handler
/*
    desc : Combined interrupt handler for Timer 1 and Timer 2 in the Dual Timer(clear the interrupt and set the load and background load values for timer 1 and timer 2).
    args : None
    return : None
*/
void DUALTIMER_DRIVER_IRQ_HANDLER_COMBINED (void){
    if(dualtimer_read_timer1_mis (DUALTIMER) == 1){
        dualtimer_clear_timer1_interrupt (DUALTIMER);
        dualtimer_set_timer1_load (DUALTIMER , RELOAD_16);
        dualtimer_set_timer1_bgload (DUALTIMER , RELOAD_16);  
    }
     if(dualtimer_read_timer2_mis (DUALTIMER) == 1){
        dualtimer_clear_timer2_interrupt (DUALTIMER);
        dualtimer_set_timer2_load (DUALTIMER , RELOAD_16);
        dualtimer_set_timer2_bgload (DUALTIMER , RELOAD_16);  
    }
}









