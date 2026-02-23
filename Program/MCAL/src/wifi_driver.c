#include "wifi_driver.h"


void wifi_set_tx_irq( wifi_typedef *WIFI) {
    WIFI->INTENABLE |= 0x1;
}



void wifi_set_rx_irq( wifi_typedef *WIFI) {
    WIFI->INTENABLE |= 0x2;
}


void wifi_clear_irq( wifi_typedef *WIFI, bool tx_irq, bool rx_irq) {
    uint32_t new_irq=0;

    if (tx_irq!=0)    new_irq |= 0x1;
    if (rx_irq!=0)    new_irq |= 0x2;

    WIFI->INTCLEAR = new_irq;
}



void wifi_config( wifi_typedef *WIFI,  wifi_configuration *CONFIG) {
    uint32_t new_ctrl=0;
    uint32_t new_irq=0;

    if (CONFIG->enable!=0)       new_ctrl |= 0x1;
    if (CONFIG->mode!=0)         new_ctrl |= 0x2;
    if (CONFIG->dma_mode!=0)     new_ctrl |= 0x4;

    if (CONFIG->tx_irq_en!=0)    new_irq |= 0x1;
    if (CONFIG->rx_irq_en!=0)    new_irq |= 0x2;

    WIFI->CTRL = new_ctrl;
    WIFI->INTENABLE = new_irq;
}



void wifi_send_data( wifi_typedef *WIFI,  uint32_t* data, int size) {
    for (int i = 0; i < size; i++) {
        WIFI->DATA[i] = data[i];
    }
}


void wifi_receive_data( wifi_typedef *WIFI,  uint32_t* data, int size) {
    for (int i = 0; i < size; i++) {
        data[i] = WIFI->DATA[i];
    }
}


