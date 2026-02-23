#include "../include/spi_driver.h"
#include <stdio.h>

////////////////////////////////// SPI Function Driver  

// Slave Select value for SPI
/*
    desc: Selects the slave device for SPI communication.
    args: Pointer to the SPI structure, slave index.
    return: None
*/
void spi_slave_select(spi_typedef *SPI, uint32_t slave) 
{
    uint32_t x;
    x = spi_read_configuration(SPI0);
    SPI->CONFIG_REG  = ( x & 0xFFF3) | (slave << SPI_SLAVE_SEL_Pos);
}


// Enable SPI
/*
    desc: Enables the SPI for communication.
    args: Pointer to the SPI structure.
    return: None
*/
void spi_enable(spi_typedef *SPI) {
    SPI->CONFIG_REG |= SPI_EN_Msk;
}

void spi_disable(spi_typedef *SPI) {
    SPI->CONFIG_REG &= ~SPI_EN_Msk;
}

// Returns SPI configuration data
/*
    desc: Reads the configuration data of the SPI.
    args: Pointer to the SPI structure.
    return: SPI configuration data.
*/
uint32_t spi_read_configuration(spi_typedef *SPI) {
    return SPI->CONFIG_REG;
}

// Transmit character via SPI
/*
    desc: Transmits a character via SPI.
    args: Pointer to the SPI structure, character to be transmitted.
    return: None
*/
void spi_send_data(spi_typedef *SPI, char transmitted_data) {
    SPI->DATA_SHIFT_REG = (uint32_t)transmitted_data;
}

// Read character via SPI
/*
    desc: Reads a character received via SPI.
    args: Pointer to the SPI structure.
    return: Received character.
*/
uint32_t spi_read_data(spi_typedef *SPI) {
    return (char)(SPI->RX_REG);
}

// Check SPI buffer status
/*
    desc: Checks the status of the SPI buffer.
    args: Pointer to the SPI structure.
    return: SPI buffer status.
*/
uint32_t spi_status(spi_typedef *SPI) {
    return SPI->STATE_REG;
}

// Clear transmission interrupt
/*
    desc: Clears the transmission interrupt of the SPI.
    args: Pointer to the SPI structure.
    return: None
*/
void spi_clear_tx_irq(spi_typedef *SPI) {
    SPI->INTCLEAR |= SPI_INTCLEAR_TX_IRQ_Msk;
}

// Clear receive interrupt
/*
    desc: Clears the receive interrupt of the SPI.
    args: Pointer to the SPI structure.
    return: None
*/
void spi_clear_rx_irq(spi_typedef *SPI) {
    SPI->INTCLEAR |= SPI_INTCLEAR_RX_IRQ_Msk;
}

void spi_clear_fifo_tx_irq(spi_typedef *SPI) {
    SPI->INTCLEAR |= 0x4;
}

void spi_clear_fifo_rx_irq(spi_typedef *SPI) {
    SPI->INTCLEAR |= 0x8;
}

// Get TX interrupt status
/*
    desc: Gets the status of the transmission interrupt of the SPI.
    args: Pointer to the SPI structure.
    return: TX interrupt status.
*/
uint32_t spi_get_tx_irq_status(spi_typedef *SPI) {
    return (SPI->INTSTATUS & SPI_INTCLEAR_TX_IRQ_Msk);
}

// Get RX interrupt status
/*
    desc: Gets the status of the receive interrupt of the SPI.
    args: Pointer to the SPI structure.
    return: RX interrupt status.
*/
uint32_t spi_get_rx_irq_status(spi_typedef *SPI) {
    return (SPI->INTSTATUS & SPI_INTCLEAR_RX_IRQ_Msk);
}

uint32_t spi_get_irq_status(spi_typedef *SPI) {
    return (SPI->INTSTATUS);
}


// Initialize SPI configuration
/*
    desc: Initializes the configuration of the SPI.
    args: Pointer to the SPI structure, pointer to SPI configuration structure.
    return: None
*/
void spi_config(spi_typedef *SPI, spi_configuration *config) {
    uint32_t new_ctrl = 0;

    if (config->clock_div != 0) new_ctrl |= config->clock_div << SPI_CLK_DIV_Pos;
    if (config->slave_select != 0) new_ctrl |= config->slave_select << SPI_SLAVE_SEL_Pos;
    if (config->clock_mode != 0) new_ctrl  |= config->clock_mode << SPI_CLK_MODE_Pos;
    if (config->spi_mode != 0) new_ctrl |= SPI_MODE_Msk;
    if (config->duplex_type != 0) new_ctrl |= SPI_DUPLEX_TYPE_Msk;

    if (config->tx_int_en != 0) new_ctrl |= SPI_TX_INT_EN_Msk;
    if (config->rx_int_en != 0) new_ctrl |= SPI_RX_INT_EN_Msk;

    if (config->dma_mode != 0) new_ctrl |= (1 << 12) ;
    if (config->tx_fifo_mode != 0) new_ctrl |= (1 << 13);
    if (config->rx_fifo_mode != 0) new_ctrl |= (1 << 14);

    SPI->CONFIG_REG = new_ctrl;
}

// SPI TX interrupt handler
/*
    desc: Handles the transmission interrupt of the SPI.
    args: None
    return: None
*/
void spi_tx_irq_handler(void) {
    spi_clear_tx_irq(SPI0);
}

// SPI RX interrupt handler
/*
    desc: Handles the receive interrupt of the SPI.
    args: None
    return: None
*/
void spi_rx_irq_handler(void) {
    spi_read_data(SPI0);
    spi_clear_rx_irq(SPI0);
}

// Combined SPI interrupt handler
/*
    desc: Handles combined interrupts of the SPI.
    args: None
    return: None
*/
void spi_irq_handler_combined(void) {
    if (spi_get_tx_irq_status(SPI0) == 1) {
        spi_clear_tx_irq(SPI0);
    }
    if (spi_get_rx_irq_status(SPI0) == 1) {
        spi_read_data(SPI0);
        spi_clear_rx_irq(SPI0);
    }
}
