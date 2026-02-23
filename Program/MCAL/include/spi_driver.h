#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h"
#include "system_macros.h"

#include <stdio.h>
#include <string.h>
#include <stdarg.h> 
#include "stdbool.h"


//////////////////////////////////Register layering of spi
typedef struct
{
  __IO   uint32_t   CONFIG_REG;             /*!< Offset: 0x000 Configuration Register (R/W) */
  union 
    {
    __I    uint32_t  RX_REG;               /*!< Offset: 0x004 Receivied Data Register (R/ ) */
    __O    uint32_t  DATA_SHIFT_REG;       /*!< Offset: 0x004 Transmitted Data Register ( /W) */
    };
  __I      uint32_t   STATE_REG;           /*!< Offset: 0x008 SPI TX and RX Buffer Status (R/W) */
  union 
    {
    __I    uint32_t  INTSTATUS;           /*!< Offset: 0x00C Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;            /*!< Offset: 0x00C Interrupt Clear Register ( /W) */
    };
} spi_typedef;


//////////////////////////////////spi configurations

typedef struct 
{
  uint32_t clock_div;
  uint32_t slave_select;
  uint32_t clock_mode;
  uint32_t spi_mode;
  uint32_t duplex_type;
  uint32_t tx_int_en;
  uint32_t rx_int_en;
  bool     dma_mode;
  bool     tx_fifo_mode;
  bool     rx_fifo_mode;
} spi_configuration;

//////////////////////////////////spi fucntion driver

// Slave Select value for SPI
/*
    desc: Selects the slave device for SPI communication.
    args: Pointer to the SPI structure, slave index.
    return: None
*/
void spi_slave_select(spi_typedef *SPI, uint32_t slave);


// Enable SPI
/*
    desc: Enables the SPI for communication.
    args: Pointer to the SPI structure.
    return: None
*/
void spi_enable(spi_typedef *SPI);

void spi_disable(spi_typedef *SPI);

// Returns SPI configuration data
/*
    desc: Reads the configuration data of the SPI.
    args: Pointer to the SPI structure.
    return: SPI configuration data.
*/
uint32_t spi_read_configuration(spi_typedef *SPI);


// Transmit character via SPI
/*
    desc: Transmits a character via SPI.
    args: Pointer to the SPI structure, character to be transmitted.
    return: None
*/
void spi_send_data(spi_typedef *SPI, char transmitted_data);


// Read character via SPI
/*
    desc: Reads a character received via SPI.
    args: Pointer to the SPI structure.
    return: Received character.
*/
uint32_t spi_read_data(spi_typedef *SPI);


// Check SPI buffer status
/*
    desc: Checks the status of the SPI buffer.
    args: Pointer to the SPI structure.
    return: SPI buffer status.
*/
uint32_t spi_status(spi_typedef *SPI);


// Clear transmission interrupt
/*
    desc: Clears the transmission interrupt of the SPI.
    args: Pointer to the SPI structure.
    return: None
*/
void spi_clear_tx_irq(spi_typedef *SPI);


// Clear receive interrupt
/*
    desc: Clears the receive interrupt of the SPI.
    args: Pointer to the SPI structure.
    return: None
*/
void spi_clear_rx_irq(spi_typedef *SPI);

void spi_clear_fifo_tx_irq(spi_typedef *SPI);
void spi_clear_fifo_rx_irq(spi_typedef *SPI);


// Get TX interrupt status
/*
    desc: Gets the status of the transmission interrupt of the SPI.
    args: Pointer to the SPI structure.
    return: TX interrupt status.
*/
uint32_t spi_get_tx_irq_status(spi_typedef *SPI);


// Get RX interrupt status
/*
    desc: Gets the status of the receive interrupt of the SPI.
    args: Pointer to the SPI structure.
    return: RX interrupt status.
*/
uint32_t spi_get_rx_irq_status(spi_typedef *SPI);

uint32_t spi_get_irq_status(spi_typedef *SPI);


// Initialize SPI configuration
/*
    desc: Initializes the configuration of the SPI.
    args: Pointer to the SPI structure, pointer to SPI configuration structure.
    return: None
*/
void spi_config(spi_typedef *SPI, spi_configuration *config);


// SPI TX interrupt handler
/*
    desc: Handles the transmission interrupt of the SPI.
    args: None
    return: None
*/
void spi_tx_irq_handler(void);


// SPI RX interrupt handler
/*
    desc: Handles the receive interrupt of the SPI.
    args: None
    return: None
*/
void spi_rx_irq_handler(void);


// Combined SPI interrupt handler
/*
    desc: Handles combined interrupts of the SPI.
    args: None
    return: None
*/
void spi_irq_handler_combined(void);


#ifdef __cplusplus
}
#endif