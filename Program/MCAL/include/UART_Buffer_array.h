//#ifdef Bluetooth
/*
 * [FILE NAME]: UART_Buffer_array.h
 * [AUTHOR(S)]: Mostafa Ghazolley
 * [DATE CREATED]: 28/06/2021
 * [DESCRIPTION]: Header File
 *
 */

#ifndef UART_BUFFER_ARRAY_H_
#define UART_BUFFER_ARRAY_H_
#include <stdint.h>
#include <stdbool.h>

/* ******************************************************************************* *
 *                              Defines                                            *
 * ******************************************************************************* */
#define BUFFER_MAX_INDEX    (uint8_t)100    //starting from 0 to 99 (100)
#define BUFFER_MIN_INDEX    (uint8_t)0      //Least index of array!
#define INCREMENT_BY_ONE    (uint8_t)1
#define TAIL_VALUE          (uint8_t)0xEE   //indication to the end of packet
#define ERROR_MESSAGE       (uint8_t)0xCA   //indication to an error occurrence

//#define VALID_PACKETS_NUMBER (uint8_t)13    ///number of cases in RF_Command - HEAD!

/* ******************************************************************************* *
 *                                 Enumeration                                     *
 * ******************************************************************************* */
typedef enum {
    BufferSize_SendConsumption=0,

    BufferSize_initValveControl= 1,

    BufferSize_initTotalConsumption= 4,

    BufferSize_calibrateNumperOfPulsesPerM3=2,

    BufferSize_addCredit=6,

    BufferSize_initCredit=4,

    BufferSize_initMaxDebit=4,

    BufferSize_updateTimeandDate=8,

    BufferSize_initHolidays=3,

    BufferSize_initTariffs=13,  //+2 U16 -> Tariff Version

    BufferSize_initUnitActivity=1,

    BufferSize_initUserCode=4,

    BufferSize_initCreditWarningLimit=4,

    BufferSize_initTaxesCharge=4, ////// MG so far i need 4 bytes from the user to init Taxes Charge in piasters

    BufferSize_SendUserID=0,                        //MG

    BufferSize_initCurrentPulses=2,                 //MG

    BufferSize_SendUserCreditInPiasters=0,          //MG

    BufferSize_SendUserDebitInPiasters=0,           //MG

    BufferSize_SendValveStatus=0,                   //MG

    BufferSize_SendCurrentTariffNumber=0,           //MG

    BufferSize_SendConsumptionHistory_12Months=0,   //MG

    BufferSize_SendLastChargeTimeandDate=0,          //MG

    BufferSize_SendLastChargePiastersAndCreditCode=0,   //MG 8/11/21

    BufferSize_SendLeakageFlag=0,                   //MG 8/11/21

    BufferSize_SendFraudFlag=0,                     //MG 8/11/21

    BufferSize_SendFraudTimeAndDate=0,              //MG 8/11/21

    BufferSize_SendDailyConsumption=0,            //MG 8/11/21

    /*BufferSize_SendDailyConsumptionP1=0,            //MG 8/11/21

    BufferSize_SendDailyConsumptionP2=0,            //MG 8/11/21

    BufferSize_SendDailyConsumptionP3=0,            //MG 8/11/21*/

    BufferSize_initLeakageFlag=1,                   //MG 8/11/21

    BufferSize_initFraudFlag=1,                     //MG 8/11/21

    BufferSize_SendStartCurrentMonthConsumption=0,   //MG 8/19/21

    BufferSize_tariffVersion=0,

    BufferSize_RefNumPulsesM3=5                     //MG 1/11/21


}PacketSizeByBytes;

/* ******************************************************************************* *
 *                              Functions Prototypes                               *
 * ******************************************************************************* */

/* **********************************************************************************
[Function Name] : UART_RECEIVE_INTO_BUFFER
[Description]   : This function is responsible for Receiving data bytes and save them
                    into UARTBufferarray that is has ring feature, which mean when go to the
                    max index it overwrite on the first index, making the max size of the buffer
                    equal to the array size [changeable in #define BUFFER_MAX_INDEX]
[Args]          : uint8_t Received_Byte : taking the received byte to the function.
[Returns]       : N/A
*************************************************************************************/
volatile void UART_RECEIVE_INTO_BUFFER(uint8_t);
/* **********************************************************************************
[Function Name] : Read_1_Byte
[Description]   : This function is responsible for Reading 1 Bytes from the UARTBufferArray[]
                    and +1 to the global ReadingBufferIndex
[Args]          : N/A
[Returns]       : uint8_t
*************************************************************************************/
uint8_t     Read_1_Byte(void);
/* **********************************************************************************
[Function Name] : Read_2_Bytes
[Description]   : This function is responsible for Reading 2 Bytes from the UARTBufferArray[]
                    and +2 to the global ReadingBufferIndex
[Args]          : N/A
[Returns]       : uint16_t
*************************************************************************************/
uint16_t    Read_2_Bytes(void);
/* **********************************************************************************
[Function Name] : Read_4_Bytes
[Description]   : This function is responsible for Reading 4 Bytes from the UARTBufferArray[]
                    and +4 to the global ReadingBufferIndex
[Args]          : N/A
[Returns]       : uint32_t
*************************************************************************************/
uint32_t    Read_4_Bytes(void);
/* **********************************************************************************
[Function Name] : Reading_UART_Buffer
[Description]   : This function is responsible for Reading the successful
[Args]          : N/A.
[Returns]       : N/A.
*************************************************************************************/
#if CC1350_RF || Bluetooth
void Reading_UART_Buffer(void);
#endif
/* **********************************************************************************
[Function Name] : Increment_Buffer_IND
[Description]   : This function is responsible for increment the second arg. to the
                    first arg. with respect to the size of Array buffer returning
                    the new value
[Args]          : uint16_t Current_IND, uint8_t Number_of_Inc.
[Returns]       : uint8_t
*************************************************************************************/
uint8_t Increment_Buffer_IND(uint16_t,uint8_t);
/* **********************************************************************************
[Function Name] : Decrement_Buffer_IND
[Description]   : This function is responsible for decrement the second arg. to the
                    first arg. with respect to the size of Array buffer returning
                    the new value
[Args]          : uint16_t Current_IND, uint8_t Number_of_Decc.
[Returns]       : uint8_t
*************************************************************************************/
/*uint8_t Decrement_Buffer_IND(uint16_t Current_IND,uint8_t Number_of_Dec);*/



#endif /* UART_BUFFER_ARRAY_H_ */
