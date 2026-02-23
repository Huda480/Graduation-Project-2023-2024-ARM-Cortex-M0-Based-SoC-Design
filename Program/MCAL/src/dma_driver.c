#include "../include/dma_driver.h"

void DMA_enable(dma_typedef *DMA, bool stop) {
    if (stop)
        DMA->CSR |= 1;
    else
        DMA->CSR &= 0;
}

void DMA_CH_setINT_MSK_A(dma_typedef *DMA, uint32_t interrupt_mask) {
    DMA->INT_MSK_A = interrupt_mask;
}


uint32_t DMA_CH_getINT_MSK_A(dma_typedef *DMA) {
    return DMA->INT_MSK_A;
}

uint32_t DMA_CH_getINT_SRC_A(dma_typedef *DMA) {
    return DMA->INT_SRC_A;
}

//void DMA_CH_setINTENABLE(dma_typedef *DMA, uint8_t enable, int channelNum) {
//
//}

uint32_t DMA_CH_getINTSTATUS(dma_typedef *DMA, int channelNum) {
    return DMA->ChannelsConfig[channelNum].CH_INTSTATUS;
}

uint32_t DMA_CH_getCSR(dma_typedef *DMA, int channelNum) {
    return DMA->ChannelsConfig[channelNum].CH_CSR;
}

void DMA_CH_setCSR(dma_typedef *DMA, dma_ch_csr_config *CH_CSR_Config, int channelNum) {
    uint32_t config = 0;
    uint8_t new_irq = 0;

    config |= (CH_CSR_Config->P2P << 24) |
              ((CH_CSR_Config->HBURST & 0x07) << 21) | (CH_CSR_Config->KEEP_REGS << 20) | ((CH_CSR_Config->HSIZE & 0x07) << 17) |
              (CH_CSR_Config->REST_EN << 16) | ((CH_CSR_Config->CHANNEL_PRIORITY & 0x07) << 13) |
              (CH_CSR_Config->USE_ED << 7) | (CH_CSR_Config->ARS << 6) | (CH_CSR_Config->MODE << 5) |
              (CH_CSR_Config->INC_SRC << 4) | (CH_CSR_Config->INC_DST << 3) | (CH_CSR_Config->CH_EN);

    if (CH_CSR_Config->INE_DONE!=0)     new_irq |= 0x2;
    if (CH_CSR_Config->INE_ERROR!=0)    new_irq |= 0x1;

    DMA->ChannelsConfig[channelNum].CH_CSR = config;
    DMA->ChannelsConfig[channelNum].CH_INTENABLE = new_irq;
}

void DMA_CH_setReq(dma_typedef *DMA, uint8_t src_req_no, uint8_t dest_req_no, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_REQ = ((dest_req_no << 5) & 0x3E0) | (src_req_no & 0x1F);
}

void DMA_CH_enable(dma_typedef *DMA, bool enable, int channelNum) {
    if (enable)
        DMA->ChannelsConfig[channelNum].CH_CSR |= 1;
    else
        DMA->ChannelsConfig[channelNum].CH_CSR &= ~1;
}

void DMA_CH_setSZ(dma_typedef *DMA, uint8_t chk_size, uint16_t total_size, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_SZ = (chk_size << 16) | (total_size & 0xFFF);
}

void DMA_CH_setA0(dma_typedef *DMA, uint32_t address, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_A0 = address;
}


void DMA_CH_setA1(dma_typedef *DMA, uint32_t address, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_A1 = address;
}


void DMA_CH_setDESC(dma_typedef *DMA, uint32_t address, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_DESC = address;
}

/*void DMA_CH_setSWPTR(dma_typedef *DMA, bool enable, uint32_t address, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_SWPTR = (enable << 31) | (address & 0x7FFFFFFF); 
}*/
