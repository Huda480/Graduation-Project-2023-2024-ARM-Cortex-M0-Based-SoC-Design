#include "comp_driver.h"


void comp_set_received_irq ( comp_typedef *COMP) {
    COMP->INTENABLE |= 0x1;
}



void comp_set_full_irq ( comp_typedef *COMP) {
    COMP->INTENABLE |= 0x2;
}


void comp_clear_irq( comp_typedef *COMP, bool received_irq, bool full_irq) {
    uint32_t new_irq=0;

    if (received_irq!=0)    new_irq |= 0x1;
    if (full_irq!=0)        new_irq |= 0x2;

    COMP->INTCLEAR = new_irq;
}



void comp_config( comp_typedef *COMP,  comp_configuration *CONFIG) {
    uint32_t new_ctrl=0;
    uint32_t new_irq=0;

    if (CONFIG->enable!=0)       new_ctrl |= 0x1;

    if (CONFIG->received_irq_en!=0)    new_irq |= 0x1;
    if (CONFIG->full_irq_en!=0)        new_irq |= 0x2;

    COMP->CTRL = new_ctrl;
    COMP->INTENABLE = new_irq;
}


void comp_receive_data( comp_typedef *COMP,  uint32_t* data, int size) {
    for (int i = 0; i < size; i++) {
        data[i] = COMP->DATA[i];
    }
}




