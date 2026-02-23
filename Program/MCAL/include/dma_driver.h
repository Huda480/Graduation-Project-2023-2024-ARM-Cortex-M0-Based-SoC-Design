#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h"
#include "system_macros.h"
#include "stdbool.h"

#define numChannels 5

//  Register Mapping for each Channel's registers
typedef struct
{
  __IO   uint32_t  CH_CSR;            /*!< Channel CSR Configuration Register         (R/W) */
  __IO   uint32_t  CH_REQ;
  __IO   uint32_t  CH_INTENABLE;
  __IO   uint32_t  CH_INTSTATUS;
  __IO   uint32_t  CH_SZ;             /*!< Channel Transfer Size Register             (R/W) */
  __IO   uint32_t  CH_A0;             /*!< Channel Source Address Register            (R/W) */
  __IO   uint32_t  CH_A1;             /*!< Channel Destination Address Register       (R/W) */
  __IO   uint32_t  CH_DESC;           /*!< Channel Linked List Descriptor Register    (R/W) */
} dma_channel_configuration;

//  Register mapping for entire DMA
typedef struct
{
  __IO   uint32_t  CSR;             	/*!< Offset: 0x00 Main Configuration & Status Register  (R/W) */
  __IO   uint32_t  INT_MSK_A;           /*!< Offset: 0x04 Interrupt Mask for INTA_O output      (R/W) */
  __IO   uint32_t  INT_SRC_A;           /*!< Offset: 0x0c Interrupt Mask for INTA_O output      (RO)  */
  __IO   uint32_t  reserved[5];         /*! RESERVED */
  __IO   dma_channel_configuration ChannelsConfig[numChannels]; /*!< Offset: 0x20-0x3E0 Channel CSR Configurations  (R/W) */
} dma_typedef;


//  Struct containing Channel CSR Configuration bit fields
typedef struct 
{ 
    bool INE_DONE;
    bool INE_ERROR;
    bool P2P;
    uint8_t HBURST;           // 3 Bits.
    bool KEEP_REGS;
    uint8_t HSIZE;            // 3 Bits.
    bool REST_EN;
    uint8_t CHANNEL_PRIORITY; // 3 Bits.
    bool USE_ED;
    bool ARS;
    bool MODE;
    bool INC_SRC;
    bool INC_DST;
    bool CH_EN;
} dma_ch_csr_config;



/*
    desc : Enables or disables the DMA controller by changing the STOP bit.

    args : 
        DMA : Pointer to the DMA controller.
        enable : Boolean indicating whether to enable (true) or disable (false) the DMA controller.

    return : void
*/
void DMA_enable(dma_typedef *DMA, bool enable);


void DMA_CH_enable(dma_typedef *DMA, bool enable, int channelNum);

//void DMA_CH_setINTENABLE(dma_typedef *DMA, , int channelNum);

/*
    desc : Sets the interrupt mask for interrupt A of the DMA controller.

    args :
        DMA : Pointer to the DMA controller.
        interrupt_mask : Interrupt mask value to be set for interrupt A.

    return : void
*/
void DMA_CH_setINT_MSK_A(dma_typedef *DMA, uint32_t interrupt_mask);


/*
    desc : Retrieves the interrupt mask for interrupt A of the DMA controller.

    args :
        DMA : Pointer to the DMA controller.

    return : uint32_t : Interrupt mask value for interrupt A.
*/
uint32_t DMA_CH_getINT_MSK_A(dma_typedef *DMA);

uint32_t DMA_CH_getINT_SRC_A(dma_typedef *DMA);

//////////////////
uint32_t DMA_CH_getINTSTATUS(dma_typedef *DMA, int channelNum);

uint32_t DMA_CH_getCSR(dma_typedef *DMA, int channelNum);
//////////////////

/*
    desc : Sets the control and status register (CSR) configuration for a specific channel.

    args :
        DMA : Pointer to the DMA controller.
        CH_CSR_Config : Pointer to the structure containing CSR configuration.
        channelNum : Channel number for which CSR configuration is to be set.

    return : void
*/
void DMA_CH_setCSR(dma_typedef *DMA, dma_ch_csr_config *CH_CSR_Config, int channelNum);


/////////////
void DMA_CH_setReq(dma_typedef *DMA, uint8_t src_req_no, uint8_t dest_req_no, int channelNum);

/////////////

/*
    desc : Sets the transfer size for a specific channel.

    args :
        DMA : Pointer to the DMA controller.
        chk_size : Size of each chunk.
        total_size : Total size of the transfer.
        channelNum : Channel number for which transfer size is to be set.

    return : void
*/
void DMA_CH_setSZ(dma_typedef *DMA, uint8_t chk_size, uint16_t total_size, int channelNum);

/*
    desc : Sets the source address for a specific channel.

    args :
        DMA : Pointer to the DMA controller.
        address : Source address for the transfer.
        channelNum : Channel number for which source address is to be set.

    return : void
*/
void DMA_CH_setA0(dma_typedef *DMA, uint32_t address, int channelNum);



/*
    desc : Sets the destination address for a specific channel.

    args :
        DMA : Pointer to the DMA controller.
        address : Destination address for the transfer.
        channelNum : Channel number for which destination address is to be set.

    return : void
*/
void DMA_CH_setA1(dma_typedef *DMA, uint32_t address, int channelNum);


/*
    desc : Sets the Linked List descriptor address for a specific channel.

    args :
        DMA : Pointer to the DMA controller.
        address : Linked List address for the channel.
        channelNum : Channel number for which descriptor address is to be set.

    return : void
*/
void DMA_CH_setDESC(dma_typedef *DMA, uint32_t address, int channelNum);

/*
    desc : Sets the software pointer mode for a specific channel.

    args :
        DMA : Pointer to the DMA controller.
        enable : Boolean indicating whether to enable (true) or disable (false) software pointer mode.
        address : Address to be used as the software pointer.
        channelNum : Channel number for which software pointer mode is to be set.

    return : void
*/
///void DMA_CH_setSWPTR(dma_typedef *DMA, bool enable, uint32_t address, int channelNum);




  
#ifdef __cplusplus
}
#endif


