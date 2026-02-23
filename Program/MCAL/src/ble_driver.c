#include "ble_driver.h"


void ble_set_tx_irq( ble_typedef *BLE) {
    BLE->INTENABLE |= 0x1;
}



void ble_set_rx_irq( ble_typedef *BLE) {
    BLE->INTENABLE |= 0x2;
}


void ble_clear_irq( ble_typedef *BLE, bool tx_irq, bool rx_irq) {
    uint32_t new_irq=0;

    if (tx_irq!=0)    new_irq |= 0x1;
    if (rx_irq!=0)    new_irq |= 0x2;

    BLE->INTCLEAR = new_irq;
}





void ble_config( ble_typedef *BLE,  ble_configuration *CONFIG) {
    uint32_t new_ctrl=0;
    uint32_t new_irq=0;

    if (CONFIG->enable!=0)       new_ctrl |= 0x1;
    if (CONFIG->mode!=0)         new_ctrl |= 0x2;
    if (CONFIG->dma_mode!=0)     new_ctrl |= 0x4;

    if (CONFIG->tx_irq_en!=0)    new_irq |= 0x1;
    if (CONFIG->rx_irq_en!=0)    new_irq |= 0x2;

    BLE->CTRL = new_ctrl;
    BLE->INTENABLE = new_irq;
}

void ble_send_data( ble_typedef *BLE,  uint32_t* data, int size) {
    for (int i = 0; i < size; i++) {
        BLE->DATA[i] = data[i];
    }
}

void ble_receive_data( ble_typedef *BLE,  uint32_t* data, int size) {
    for (int i = 0; i < size; i++) {
        data[i] = BLE->DATA[i];
    }
}




