#pragma once

#include <stdio.h>
#include <stdlib.h>

typedef enum {timer1,timer2,timer3,timer4,timer5,timer6,timer7,timer8,timer9,timer10,timer11,timer12,timer13,timer14,timer15,timer16} timer_id;

typedef struct Timer{
    int period ;
    timer_id ID;
    void (*callback_ptr)(void); 
    struct Timer* next ;
} Timer ;



void add_timer (Timer** head,int period , timer_id ID,void (*func_ptr));

void update_timer(Timer** head);


void print_node( Timer* root);
