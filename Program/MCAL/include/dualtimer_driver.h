#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h" 

#include "system_macros.h"


//////////////////////////////////Register layering of dualtimer

typedef struct
{
  __IO uint32_t Timer1Load;   // <h> Timer 1 Load </h>
  __I  uint32_t Timer1Value;  // <h> Timer 1 Counter Current Value <r></h>
  __IO uint32_t Timer1Control;// <h> Timer 1 Control
                              //   <o.7> TimerEn: Timer Enable
                              //   <o.6> TimerMode: Timer Mode
                              //     <0=> Freerunning-mode
                              //     <1=> Periodic mode
                              //   <o.5> IntEnable: Interrupt Enable
                              //   <o.2..3> TimerPre: Timer Prescale
                              //     <0=> / 1
                              //     <1=> / 16
                              //     <2=> / 256
                              //     <3=> Undefined!
                              //   <o.1> TimerSize: Timer Size
                              //     <0=> 16-bit counter
                              //     <1=> 32-bit counter
                              //   <o.0> OneShot: One-shoot mode
                              //     <0=> Wrapping mode
                              //     <1=> One-shot mode
                              // </h>
  __O  uint32_t Timer1IntClr; // <h> Timer 1 Interrupt Clear <w></h>
  __I  uint32_t Timer1RIS;    // <h> Timer 1 Raw Interrupt Status <r></h>
  __I  uint32_t Timer1MIS;    // <h> Timer 1 Masked Interrupt Status <r></h>
  __IO uint32_t Timer1BGLoad; // <h> Background Load Register </h>
       uint32_t RESERVED0;
  __IO uint32_t Timer2Load;   // <h> Timer 2 Load </h>
  __I  uint32_t Timer2Value;  // <h> Timer 2 Counter Current Value <r></h>
  __IO uint32_t Timer2Control;// <h> Timer 2 Control
                              //   <o.7> TimerEn: Timer Enable
                              //   <o.6> TimerMode: Timer Mode
                              //     <0=> Freerunning-mode
                              //     <1=> Periodic mode
                              //   <o.5> IntEnable: Interrupt Enable
                              //   <o.2..3> TimerPre: Timer Prescale
                              //     <0=> / 1
                              //     <1=> / 16
                              //     <2=> / 256
                              //     <3=> Undefined!
                              //   <o.1> TimerSize: Timer Size
                              //     <0=> 16-bit counter
                              //     <1=> 32-bit counter
                              //   <o.0> OneShot: One-shoot mode
                              //     <0=> Wrapping mode
                              //     <1=> One-shot mode
                              // </h>
  __O  uint32_t Timer2IntClr; // <h> Timer 2 Interrupt Clear <w></h>
  __I  uint32_t Timer2RIS;    // <h> Timer 2 Raw Interrupt Status <r></h>
  __I  uint32_t Timer2MIS;    // <h> Timer 2 Masked Interrupt Status <r></h>
  __IO uint32_t Timer2BGLoad; // <h> Background Load Register </h>
       uint32_t RESERVED1[945];
  __IO uint32_t ITCR;         // <h> Integration Test Control Register </h>
  __O  uint32_t ITOP;         // <h> Integration Test Output Set Register </h>
} dualtimer_typedef;



typedef struct 
{
     uint32_t irq_en1;
     uint32_t oneshot1;
     uint32_t freerunning1; 
     uint32_t prescale1;
     uint32_t enable1; 
     uint32_t bits1; 
     uint32_t irq_en2;
     uint32_t oneshot2;
     uint32_t freerunning2; 
     uint32_t prescale2;
     uint32_t enable2; 
     uint32_t bits2;
} dualtimer_configuration;




//////////////////////////////////Dualtimer driver

//Dual timer 1 set load register
/*
    desc : Set the load value for Timer 1 in the  Dual Timer.
    args : pointer to dualtimer struct
           value: The value to set as the load value for Timer 1.
    return : None
*/
void dualtimer_set_timer1_load (dualtimer_typedef *dualtimer ,uint32_t value);


//Dual timer 1 read load register
/*
    desc : Read the load value for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The load value for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_load (dualtimer_typedef *dualtimer );


//Dual timer 1 read value register
/*
    desc : Read the current value of Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The current value of Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_value (dualtimer_typedef *dualtimer );


//Dual timer 1 set one shoot mode
/*
    desc : Enable the one-shot mode for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer1_oneshot (dualtimer_typedef *dualtimer );


//Dual timer 1 set wrapping mode
/*
    desc : Disable the one-shot mode for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer1_oenshot (dualtimer_typedef *dualtimer );


//Dual timer 1 set to 32 bits
/*
    desc : Set the  size for Timer 1 to 32bits in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_32 (dualtimer_typedef *dualtimer );


//Dual timer 1 set to 16 bits
/*
    desc : Set the  size for Timer 1 to 16 bits in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_16 (dualtimer_typedef *dualtimer );


//Dual timer 1 enable interrupt
/*
    desc : Enable the interrupt for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer1_interrupt (dualtimer_typedef *dualtimer );


//Dual timer 1 disable interrupt
/*
    desc : Disable the interrupt for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer1_interrupt (dualtimer_typedef *dualtimer );


//Dual timer 1 set prescale to 256
/*
    desc : Set the prescale value to 256 for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_prescale_256 (dualtimer_typedef *dualtimer );


//Dual timer 1 set prescale to 16
/*
    desc : Set the prescale value to 16 for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_prescale_16 (dualtimer_typedef *dualtimer );


//Dual timer 1 disable prescale
/*
    desc : Set the prescale value to 1 for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer1_prescale (dualtimer_typedef *dualtimer );


//Dual timer 1 set periodic mode
/*
    desc : Set the periodic mode for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_periodic (dualtimer_typedef *dualtimer );


//Dual timer 1 set free running mode
/*
    desc : Set the free running mode for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer1_freerunning (dualtimer_typedef *dualtimer );


//Dual timer 1 enable timer
/*
    desc : Enable Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer1 (dualtimer_typedef *dualtimer );


//Dual timer 1 disable timer
/*
    desc : Disable Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer1 (dualtimer_typedef *dualtimer );


//Dual timer 1 read control bits
/*
    desc : Read the control register value for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The control register value for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_cntrl (dualtimer_typedef *dualtimer );


//Dual timer 1 interrupt clear
/*
    desc : Clear the interrupt for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_clear_timer1_interrupt (dualtimer_typedef *dualtimer );


//Dual timer 1 read raw interrupt status
/*
    desc : Read the raw interrupt status for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The raw interrupt status for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_ris (dualtimer_typedef *dualtimer );


//Dual timer 1 read masked interrupt status
/*
    desc : Read the masked interrupt status for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The masked interrupt status for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_mis (dualtimer_typedef *dualtimer );


//Dual timer 1 set back ground load
/*
    desc : Set the background load value for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
           value: The value to set as the background load value for Timer 1.
    return : None
*/
void dualtimer_set_timer1_bgload (dualtimer_typedef *dualtimer ,uint32_t value );


//Dual timer 1 read background load
/*
    desc : Read the background load value for Timer 1 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The background load value for Timer 1 (32-bit value).
*/
uint32_t dualtimer_read_timer1_bgload (dualtimer_typedef *dualtimer );


// Dual timer 2 set load register
/*
    desc : Set the load value for Timer 2 in the  Dual Timer.
    args : pointer to dualtimer struct
           value: The value to set as the load value for Timer 2.
    return : None
*/
void dualtimer_set_timer2_load(dualtimer_typedef *dualtimer, uint32_t value);


// Dual timer 2 read load register
/*
    desc : Read the load value for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The load value for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_load(dualtimer_typedef *dualtimer);


// Dual timer 2 read value register
/*
    desc : Read the current value of Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The current value of Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_value(dualtimer_typedef *dualtimer);


// Dual timer 2 set one-shot mode
/*
    desc : Enable the one-shot mode for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer2_oneshot(dualtimer_typedef *dualtimer);


// Dual timer 2 set wrapping mode
/*
    desc : Disable the one-shot mode for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer2_oneshot(dualtimer_typedef *dualtimer);


// Dual timer 2 set to 32 bits
/*
    desc : Set the  size for Timer 2 to 32 bits in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_32(dualtimer_typedef *dualtimer);


// Dual timer 2 set to 16 bits
/*
    desc : Set the  size for Timer 2 to 16 bits in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_16(dualtimer_typedef *dualtimer);


// Dual timer 2 enable interrupt
/*
    desc : Enable the interrupt for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer2_interrupt(dualtimer_typedef *dualtimer);


// Dual timer 2 disable interrupt
/*
    desc : Disable the interrupt for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer2_interrupt(dualtimer_typedef *dualtimer);


// Dual timer 2 set prescale to 256
/*
    desc : Set the prescale value to 256 for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_prescale_256(dualtimer_typedef *dualtimer);


// Dual timer 2 set prescale to 16
/*
    desc : Set the prescale value to 16 for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_prescale_16(dualtimer_typedef *dualtimer);


// Dual timer 2 disable prescale
/*
    desc : Set the prescale value to 1 for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer2_prescale(dualtimer_typedef *dualtimer);


// Dual timer 2 set periodic mode
/*
    desc : Set the periodic mode for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_periodic(dualtimer_typedef *dualtimer);


// Dual timer 2 set free running mode
/*
    desc : Set the free running mode for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_set_timer2_freerunning(dualtimer_typedef *dualtimer);


// Dual timer 2 enable timer
/*
    desc : Enable Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_en_timer2(dualtimer_typedef *dualtimer);


// Dual timer 2 disable timer
/*
    desc : Disable Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_dis_timer2(dualtimer_typedef *dualtimer);


// Dual timer 2 read control bits
/*
    desc : Read the control register value for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The control register value for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_cntrl(dualtimer_typedef *dualtimer);


// Dual timer 2 interrupt clear
/*
    desc : Clear the interrupt for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : None
*/
void dualtimer_clear_timer2_interrupt(dualtimer_typedef *dualtimer);


// Dual timer 2 read raw interrupt status
/*
    desc : Read the raw interrupt status for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The raw interrupt status for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_ris(dualtimer_typedef *dualtimer);


// Dual timer 2 read masked interrupt status
/*
    desc : Read the masked interrupt status for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The masked interrupt status for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_mis(dualtimer_typedef *dualtimer);


// Dual timer 2 set background load
/*
    desc : Set the background load value for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
           value: The value to set as the background load value for Timer 2.
    return : None
*/
void dualtimer_set_timer2_bgload(dualtimer_typedef *dualtimer, uint32_t value);


// Dual timer 2 read background load
/*
    desc : Read the background load value for Timer 2 in the Dual Timer.
    args : pointer to dualtimer struct
    return : The background load value for Timer 2 (32-bit value).
*/
uint32_t dualtimer_read_timer2_bgload(dualtimer_typedef *dualtimer);


//Dual timer full configuration
/*
    desc : Configure the Dual Timer based on the provided configuration.
    args : pointer to dualtimer struct
           CONFIG: Pointer to the CMSDK_dualtimer_configuration structure containing configuration options.
    return : None
*/
void dualtimer_config (dualtimer_typedef *dualtimer, dualtimer_configuration *CONFIG);


//Dual timer combined IRQ handler
/*
    desc : Combined interrupt handler for Timer 1 and Timer 2 in the Dual Timer(clear the interrupt and set the load and background load values for timer 1 and timer 2).
    args : None
    return : None
*/
void dualtimer_irq_handler_combined (void);;

#ifdef __cplusplus
}
#endif











