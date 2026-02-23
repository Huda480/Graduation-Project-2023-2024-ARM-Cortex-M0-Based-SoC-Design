//////////////////////////////////Memory addresses for our system



/* Peripheral and SRAM base address */
#define CMSDK_FLASH_BASE        (0x00000000UL)  /*!< (FLASH     ) Base Address */
#define CMSDK_SRAM_BASE         (0x20000000UL)  /*!< (SRAM      ) Base Address */
#define CMSDK_PERIPH_BASE       (0x40000000UL)  /*!< (Peripheral) Base Address */

#define CMSDK_RAM_BASE          (0x20000000UL)
#define CMSDK_APB_BASE          (0x40000000UL)
#define CMSDK_AHB_BASE          (0x40010000UL)

/* APB peripherals                                                           */
#define CMSDK_TIMER0_BASE       (CMSDK_APB_BASE + 0x2000UL)
//#define CMSDK_TIMER1_BASE       (CMSDK_APB_BASE + 0x8000UL)
#define CMSDK_DUALTIMER_BASE    (CMSDK_APB_BASE + 0x5000UL)
#define CMSDK_DUALTIMER_1_BASE  (CMSDK_DUALTIMER_BASE)
#define CMSDK_DUALTIMER_2_BASE  (CMSDK_DUALTIMER_BASE + 0x20UL)
#define  UART1_BASE        (CMSDK_APB_BASE + 0x4000UL)
#define  UART2_BASE        (CMSDK_APB_BASE + 0x6000UL)
// Uart 3 is fitted to FPGA build for Arduino support
#define  UART3_BASE        (CMSDK_APB_BASE + 0x7000UL)
#define CMSDK_WATCHDOG_BASE     (CMSDK_APB_BASE + 0x1000UL)
// Uart 4 is fitted to FPGA build for Arduino support
#define  UART4_BASE        (CMSDK_APB_BASE + 0x9000UL)

// SPI0
#define SPI0_BASE               (CMSDK_APB_BASE + 0x3000UL)
#define RCC_BASE                (CMSDK_APB_BASE + 0x8000UL)

/* AHB peripherals                                                           */
#define GPIO0_BASE        (CMSDK_AHB_BASE + 0x0000UL)
#define DMA_BASE                (CMSDK_AHB_BASE + 0x1000UL)

#define BLE_BASE                 (CMSDK_AHB_BASE + 0x10000UL)
#define WIFI_BASE                (CMSDK_AHB_BASE + 0x11000UL)

#define COMP_BASE                (CMSDK_AHB_BASE + 0x20000UL)

#define CMSDK_GPIO1_BASE        (CMSDK_AHB_BASE + 0x3000UL)
#define CMSDK_SYSCTRL_BASE      (CMSDK_AHB_BASE + 0xF000UL)


//////////////////////////////////Define used pointers

#define  UART0_BASE        (CMSDK_APB_BASE)
#define  UART0             (( uart_typedef   *)  UART0_BASE   )

#define  UART1             (( uart_typedef   *)  UART1_BASE   )
#define  UART2             (( uart_typedef   *)  UART2_BASE   )
#define  UART3             (( uart_typedef   *)  UART3_BASE   )

#define  UART4             (( uart_typedef   *)  UART4_BASE   )
#define TIMER0            ((timer_typedef  *) CMSDK_TIMER0_BASE  )

#define TIMER1            ((timer_typedef  *) CMSDK_TIMER1_BASE  )
#define DUALTIMER         ((dualtimer_typedef  *) CMSDK_DUALTIMER_BASE )

#define CMSDK_DUALTIMER1        ((CMSDK_DUALTIMER_SINGLE_TypeDef  *) CMSDK_DUALTIMER_1_BASE )
#define CMSDK_DUALTIMER2        ((CMSDK_DUALTIMER_SINGLE_TypeDef  *) CMSDK_DUALTIMER_2_BASE )

#define CMSDK_WATCHDOG          ((watchdog_typedef  *) CMSDK_WATCHDOG_BASE   )

#define CMSDK_DMA               ((dma_typedef  *) DMA_BASE)
#define CMSDK_DMA_CHANNELS      ((dma_typedef  *) DMA_BASE + 0x20)

#define BLE0                     ((ble_typedef  *) BLE_BASE)
#define WIFI0                    ((wifi_typedef  *) WIFI_BASE)
#define COMP0                    ((comp_typedef  *) COMP_BASE)

#define GPIO0                   ((gpio_typedef   *) GPIO0_BASE   )
#define CMSDK_GPIO1             ((gpio_typedef   *) CMSDK_GPIO1_BASE   )

#define SPI0                    ((spi_typedef       *) SPI0_BASE )

#define RCC0                     ((rcc_typedef       *) RCC_BASE )

#define CMSDK_SYSCON            ((CMSDK_SYSCON_TypeDef *) CMSDK_SYSCTRL_BASE )



//////////////////////////////////General reload macros

#define RELOAD_16                            0xFFFFul
#define RELOAD_32                            0xFFFFFFFFul

//////////////////////////////////Watchdog value register definitions

#define WATCHDOG_LOAD_Pos                     0                                              //Watchdog load position
#define WATCHDOG_LOAD_Msk                   (0xFFFFFFFFul << WATCHDOG_LOAD_Pos)              //Watchdog load register value  

#define WATCHDOG_VALUE_Pos                    0                                              //Watchdog value position
#define WATCHDOG_VALUE_Msk                  (0xFFFFFFFFul << WATCHDOG_VALUE_Pos)             //Watchdog value register value     

#define WATCHDOG_CTRL_RESEN_Pos               1                                              //Watchdog reset enable position
#define WATCHDOG_CTRL_RESEN_Msk             (0x1ul << WATCHDOG_CTRL_RESEN_Pos)               //Watchdog control register reset enable

#define WATCHDOG_CTRL_INTEN_Pos               0                                              //Wathdog interrupt enable position
#define WATCHDOG_CTRL_INTEN_Msk             (0x1ul << WATCHDOG_CTRL_INTEN_Pos)               //Watchdog control register interrupt enable

#define WATCHDOG_INTCLR_Pos                   0                                              //Watchdog interrupt clear position
#define WATCHDOG_INTCLR_Msk                 (0x1ul << WATCHDOG_INTCLR_Pos)                   //Watchdog interrupt clear register interrupt clear value

#define WATCHDOG_RAWINTSTAT_Pos               0                                              //Watchdog raw interrupt status position
#define WATCHDOG_RAWINTSTAT_Msk             (0x1ul << WATCHDOG_RAWINTSTAT_Pos)               //Watchdog raw interrupt status register raw interrupt value

#define WATCHDOG_MASKINTSTAT_Pos              0                                              //Watchdog masked interrupt status position
#define WATCHDOG_MASKINTSTAT_Msk            (0x1ul << WATCHDOG_MASKINTSTAT_Pos)              //Watchdog masked interrupt status register masked interrupt value

#define WATCHDOG_LOCK_Pos                     0                                              //Watchdog lock position
#define WATCHDOG_LOCK_Msk                   (0x1ACCE551ul << WATCHDOG_LOCK_Pos)              //Watchdog lock register value

#define WATCHDOG_INTEGTESTEN_Pos              0                                              //Watchdog integration test postion
#define WATCHDOG_INTEGTESTEN_Msk            (0x1ul << WATCHDOG_INTEGTESTEN_Pos)              //Watchdog integration test register value

#define WATCHDOG_INTEGTESTOUTSET_Pos          1                                              //Watchdog integration test output position
#define WATCHDOG_INTEGTESTOUTSET_Msk        (0x1ul << WATCHDOG_INTEGTESTOUTSET_Pos)          //Watchdog integration test output register value

//////////////////////////////////Timer value register definitions

#define TIMER_CTRL_IRQEN_Pos            3                                      //Timer interrupt enable position
#define TIMER_CTRL_IRQEN_Msk          (0x01ul << TIMER_CTRL_IRQEN_Pos)         //Timer control register interrupt enable

#define TIMER_CTRL_SELEXTCLK_Pos        2                                      //Timer select extin as clock postion
#define TIMER_CTRL_SELEXTCLK_Msk      (0x01ul << TIMER_CTRL_SELEXTCLK_Pos)     //Timer control register select extin clock

#define TIMER_CTRL_SELEXTEN_Pos         1                                      //Timer select extin as enable position
#define TIMER_CTRL_SELEXTEN_Msk       (0x01ul << TIMER_CTRL_SELEXTEN_Pos)      //Timer control register select extin as enable

#define TIMER_CTRL_EN_Pos               0                                      //Timer enable position
#define TIMER_CTRL_EN_Msk             (0x01ul << TIMER_CTRL_EN_Pos)            //Timer control register enable value

#define TIMER_VAL_CURRENT_Pos           0                                      //Timer value position
#define TIMER_VAL_CURRENT_Msk         (0xFFFFFFFFul << TIMER_VAL_CURRENT_Pos)  //Timer value register posioin

#define TIMER_RELOAD_VAL_Pos            0                                      //Timer reload position
#define TIMER_RELOAD_VAL_Msk          (0xFFFFFFFFul << TIMER_RELOAD_VAL_Pos)   //Timer reload register value

#define TIMER_INTSTATUS_Pos             0                                      //Timer interrupt status position
#define TIMER_INTSTATUS_Msk           (0x01ul << TIMER_INTSTATUS_Pos)          //Timer interrupt status value

#define TIMER_INTCLEAR_Pos              0                                      //Timer interrupt clear position
#define TIMER_INTCLEAR_Msk            (0x01ul << TIMER_INTCLEAR_Pos)           //Timer interrupt clear value

//////////////////////////////////Dualtimer value register definitions

#define DUALTIMER1_LOAD_Pos            0                                                //Dual timer 1 load position
#define DUALTIMER1_LOAD_Msk            (0xFFFFFFFFul << DUALTIMER1_LOAD_Pos)      //Dual timer 1 load register value

#define DUALTIMER1_VALUE_Pos           0                                                //Dual timer 1 value position
#define DUALTIMER1_VALUE_Msk           (0xFFFFFFFFul << DUALTIMER1_VALUE_Pos)     //Dual timer 1 value register value

#define DUALTIMER1_CTRL_EN_Pos         7                                                //Dual timer 1 enable position
#define DUALTIMER1_CTRL_EN_Msk         (0x1ul << DUALTIMER1_CTRL_EN_Pos)          //Dual timer 1 enable register value

#define DUALTIMER1_CTRL_MODE_Pos       6                                                //Dual timer 1 mode position
#define DUALTIMER1_CTRL_MODE_Msk       (0x1ul << DUALTIMER1_CTRL_MODE_Pos)        //Dual timer 1 mode control register value

#define DUALTIMER1_CTRL_INTEN_Pos      5                                                //Dual timer 1 interrupt enable position
#define DUALTIMER1_CTRL_INTEN_Msk      (0x1ul << DUALTIMER1_CTRL_INTEN_Pos)       //Dual timer 1 control register interrupt value

#define DUALTIMER1_CTRL_PRESCALE_Pos   2                                                //Dual timer 1 prescale position

#define DUALTIMER1_CTRL_SIZE_Pos       1                                                //Dual timer 1 size enable position
#define DUALTIMER1_CTRL_SIZE_Msk       (0x1ul << DUALTIMER1_CTRL_SIZE_Pos)        //Dual timer 1 control register size value

#define DUALTIMER1_CTRL_ONESHOOT_Pos   0                                                //Dual timer 1 one shoot mode position
#define DUALTIMER1_CTRL_ONESHOOT_Msk   (0x1ul << DUALTIMER1_CTRL_ONESHOOT_Pos)    //Dual timer 1 control register one shoot mode

#define DUALTIMER1_INTCLR_Pos          0                                                //Dual timer 1 interrupt clear position
#define DUALTIMER1_INTCLR_Msk          (0x1ul << DUALTIMER1_INTCLR_Pos)           //Dual timer 1 interrupt register clear

#define DUALTIMER1_RAWINTSTAT_Pos      0                                                //Dual timer 1 raw interrupt status register
#define DUALTIMER1_RAWINTSTAT_Msk      (0x1ul << DUALTIMER1_RAWINTSTAT_Pos)       //Dual timer 1 raw interrupt register value

#define DUALTIMER1_MASKINTSTAT_Pos     0                                                //Dual timer 1 masked interrupt position
#define DUALTIMER1_MASKINTSTAT_Msk     (0x1ul << DUALTIMER1_MASKINTSTAT_Pos)      //Dual timer 1 masked interrupt register value

#define DUALTIMER1_BGLOAD_Pos          0                                                //Dual timer 1 background load position
#define DUALTIMER1_BGLOAD_Msk          (0xFFFFFFFFul << DUALTIMER1_BGLOAD_Pos)    //Dual timer 1 background load register value

#define DUALTIMER2_LOAD_Pos            0                                                //Dual timer 2 load position
#define DUALTIMER2_LOAD_Msk            (0xFFFFFFFFul << DUALTIMER2_LOAD_Pos)      //Dual timer 2 load register value

#define DUALTIMER2_VALUE_Pos           0                                                //Dual timer 2 value position
#define DUALTIMER2_VALUE_Msk           (0xFFFFFFFFul << DUALTIMER2_VALUE_Pos)     //Dual timer 2 value register value

#define DUALTIMER2_CTRL_EN_Pos         7                                                //Dual timer 2 enable position
#define DUALTIMER2_CTRL_EN_Msk         (0x1ul << DUALTIMER2_CTRL_EN_Pos)          //Dual timer 2 enable register value

#define DUALTIMER2_CTRL_MODE_Pos       6                                                //Dual timer 2 mode position
#define DUALTIMER2_CTRL_MODE_Msk       (0x1ul << DUALTIMER2_CTRL_MODE_Pos)        //Dual timer 2 mode control register value

#define DUALTIMER2_CTRL_INTEN_Pos      5                                                //Dual timer 2 interrupt enable position
#define DUALTIMER2_CTRL_INTEN_Msk      (0x1ul << DUALTIMER2_CTRL_INTEN_Pos)       //Dual timer 2 control register interrupt value

#define DUALTIMER2_CTRL_PRESCALE_Pos   2                                                //Dual timer 2 prescale position

#define DUALTIMER2_CTRL_SIZE_Pos       1                                                //Dual timer 2 size enable position
#define DUALTIMER2_CTRL_SIZE_Msk       (0x1ul << DUALTIMER2_CTRL_SIZE_Pos)        //Dual timer 2 control register size value

#define DUALTIMER2_CTRL_ONESHOOT_Pos   0                                                //Dual timer 2 one shoot mode position
#define DUALTIMER2_CTRL_ONESHOOT_Msk   (0x1ul << DUALTIMER2_CTRL_ONESHOOT_Pos)    //Dual timer 2 control register one shoot mode

#define DUALTIMER2_INTCLR_Pos          0                                                //Dual timer 2 interrupt clear position
#define DUALTIMER2_INTCLR_Msk          (0x1ul << DUALTIMER2_INTCLR_Pos)           //Dual timer 2 interrupt register clear

#define DUALTIMER2_RAWINTSTAT_Pos      0                                                //Dual timer 2 raw interrupt status register
#define DUALTIMER2_RAWINTSTAT_Msk      (0x1ul << DUALTIMER2_RAWINTSTAT_Pos)       //Dual timer 2 raw interrupt register value

#define DUALTIMER2_MASKINTSTAT_Pos     0                                                //Dual timer 2 masked interrupt position
#define DUALTIMER2_MASKINTSTAT_Msk     (0x1ul << DUALTIMER2_MASKINTSTAT_Pos)      //Dual timer 2 masked interrupt register value

#define DUALTIMER2_BGLOAD_Pos          0                                                //Dual timer 2 background load position
#define DUALTIMER2_BGLOAD_Msk          (0xFFFFFFFFul << DUALTIMER2_BGLOAD_Pos)    //Dual timer 2 background load register value



//////////////////////////////////Uart value register definitions
#define UART_DATA_Pos                     0                                         // UART DATA register position 
#define UART_DATA_Msk                    (0xFFul << UART_DATA_Pos)                  // UART DATA register mask 

#define UART_STATE_RX_BF_OV_Pos           3                                         // UART STATE register , RX buffer overrun bit posistion 
#define UART_STATE_RX_BF_OV_Msk          (0x1ul << UART_STATE_RX_BF_OV_Pos)         // UART STATE register RX buffer overrun mask 

#define UART_STATE_TX_BF_OV_Pos           2                                         // UART STATE register , TX buffer overrun bit position 
#define UART_STATE_TX_BF_OV_Msk          (0x1ul << UART_STATE_TX_BF_OV_Pos)         // UART STATE register TX buffer overrun mask 

#define UART_STATE_RX_BF_Pos              1                                         // UART STATE register , RX buffer state bit position 
#define UART_STATE_RX_BF_Msk             (0x1ul << UART_STATE_RX_BF_Pos)            // UART STATE register RX buffer state bit mask 

#define UART_STATE_TX_BF_Pos              0                                         // UART STATE register , TX buffer state bit position 
#define UART_STATE_TX_BF_Msk             (0x1ul << UART_STATE_TX_BF_Pos)            // UART STATE register TX buffer state bit position

#define UART_CTRL_HSTM_Pos                6                                         // UART CTRL register , High Speed Test Mode bit position
#define UART_CTRL_HSTM_Msk               (0x01ul << UART_CTRL_HSTM_Pos)             // UART CTRL register High Speed Test Mode bit mask

#define UART_CTRL_RX_OV_IRQ_EN_Pos        5                                         // UART CTRL register , RX overrun interrupt enable bit position 
#define UART_CTRL_RX_OV_IRQ_EN_Msk       (0x01ul << UART_CTRL_RX_OV_IRQ_EN_Pos)     // UART CTRL register RX overrun interrupt enable bit mask

#define UART_CTRL_TX_OV_IRQ_EN_Pos        4                                         // UART CTRL register , TX overrun interrupt enable bit position 
#define UART_CTRL_TX_OV_IRQ_EN_Msk       (0x01ul << UART_CTRL_TX_OV_IRQ_EN_Pos)     // UART CTRL register TX overrun interrupt enable bit mask

#define UART_CTRL_RX_IRQ_EN_Pos           3                                         // UART CTRL register , RX interrupt enable bit position
#define UART_CTRL_RX_IRQ_EN_Msk          (0x01ul << UART_CTRL_RX_IRQ_EN_Pos)        // UART CTRL register RX interrupt enable bit mask 

#define UART_CTRL_TX_IRQ_EN_Pos           2                                         // UART CTRL register , TX interrupt enable bit position
#define UART_CTRL_TX_IRQ_EN_Msk          (0x01ul << UART_CTRL_TX_IRQ_EN_Pos)        // UART CTRL register TX interrupt enable bit mask 

#define UART_CTRL_RX_EN_Pos               1                                         // UART CTRL register , RX enable bit position
#define UART_CTRL_RX_EN_Msk              (0x01ul << UART_CTRL_RX_EN_Pos)            // UART CTRL register RX enable bit mask

#define UART_CTRL_TX_EN_Pos               0                                         // UART CTRL register , TX enable bit position 
#define UART_CTRL_TX_EN_Msk              (0x01ul << UART_CTRL_TX_EN_Pos)            // UART CTRL register  TX enable bit mask 

#define UART_INTCLEAR_RX_OV_IRQ_Pos       3                                         // UART INTCLEAR/INTSTATUS register RX overrun interrupt bit position 
#define UART_INTCLEAR_RX_OV_IRQ_Msk      (0x01ul << UART_INTCLEAR_RX_OV_IRQ_Pos)    // UART INTCLEAR/INTSTATUS register RX overrun interrupt bit mask to clear it 

#define UART_INTCLEAR_TX_OV_IRQ_Pos       2                                         // UART INTCLEAR/INTSTATUS register TX overrun interrupt bit position
#define UART_INTCLEAR_TX_OV_IRQ_Msk      (0x01ul << UART_INTCLEAR_TX_OV_IRQ_Pos)    // UART INTCLEAR/INTSTATUS register TX overrun interrupt bit mask to clear it 

#define UART_INTCLEAR_RX_IRQ_Pos          1                                         // UART INTCLEAR/INTSTATUS register RX interrupt bit position  
#define UART_INTCLEAR_RX_IRQ_Msk         (0x01ul << UART_INTCLEAR_RX_IRQ_Pos)       // UART INTCLEAR/INTSTATUS register RX interrupt bit mask to clear it

#define UART_INTCLEAR_TX_IRQ_Pos          0                                         // UART INTCLEAR/INTSTATUS register TX interrupt bit position   
#define UART_INTCLEAR_TX_IRQ_Msk         (0x01ul << UART_INTCLEAR_TX_IRQ_Pos)       // UART INTCLEAR/INTSTATUS register TX interrupt bit mask to clear it 

#define UART_BAUDDIV_Pos                  0                                         // UART BAUDDIV register position 
#define UART_BAUDDIV_Msk                 (0xFFFFFul << UART_BAUDDIV_Pos)            // UART BAUDDIV register mask 


//////////////////////////////////Gpio register value

#define GPIO_DATA_Pos            0                                    // Gpio Data position 
#define GPIO_DATA_Msk            (0xFFFFul << GPIO_DATA_Pos)          // Gpio Register reads at input and writes on output 

#define GPIO_DATAOUT_Pos         0                                    //  Gpio Dataout position
#define GPIO_DATAOUT_Msk         (0xFFFFul << GPIO_DATAOUT_Pos)       //  Gpio Register for changing output pin value

#define GPIO_OUTENSET_Pos        0                                    //  Gpio outenset position
#define GPIO_OUTENSET_Msk        (0xFFFFul << GPIO_OUTENSET_Pos)      //  Gpio Register for configurating pin to be output

#define GPIO_OUTENCLR_Pos        0                                    //  Gpio outenclr position
#define GPIO_OUTENCLR_Msk        (0xFFFFul << GPIO_OUTENCLR_Pos )     //  Gpio Register for clearing output pin configuration

#define GPIO_ALTFUNCSET_Pos      0                                    //  Gpio Altfuncset position
#define GPIO_ALTFUNCSET_Msk      (0xFFFFul << GPIO_ALTFUNCSET_Pos )   //  Gpio Register for enabling alternate function

#define GPIO_ALTFUNCCLR_Pos      0                                    //  Gpio Altfuncclr position
#define GPIO_ALTFUNCCLR_Msk      (0xFFFFul << GPIO_ALTFUNCCLR_Pos )   //  Gpio Register for disabling alternate function

#define GPIO_INTENSET_Pos        0                                    //  Gpio Intenset position
#define GPIO_INTENSET_Msk        (0xFFFFul << GPIO_INTENSET_Pos )     //  Gpio Register for enabling interrupt

#define GPIO_INTENCLR_Pos        0                                    //  Gpio Intenclr position
#define GPIO_INTENCLR_Msk        (0xFFFFul << GPIO_INTENCLR_Pos )     //  Gpio Register for disabling interrupt

#define GPIO_INTTYPESET_Pos      0                                    //  Gpio Inttypeset position
#define GPIO_INTTYPESET_Msk      (0xFFFFul << GPIO_INTTYPESET_Pos  )  //  Gpio Register for configurating interrupt to be high or low level

#define GPIO_INTTYPECLR_Pos      0                                    //  Gpio Inttypeclr position
#define GPIO_INTTYPECLR_Msk      (0xFFFFul << GPIO_INTTYPECLR_Pos )   //  Gpio Register for clearing interrupt type

#define GPIO_INTPOLSET_Pos       0                                    //  Gpio Intpolset position
#define GPIO_INTPOLSET_Msk       (0xFFFFul << GPIO_INTPOLSET_Pos)     //  Gpio Register for configurating interrupt to be rising or falling edge

#define GPIO_INTPOLCLR_Pos       0                                    //  Gpio Intpolclr position
#define GPIO_INTPOLCLR_Msk       (0xFFFFul << GPIO_INTPOLCLR_Pos)     //  Gpio Register for clearing interrupt polarity

#define GPIO_INTSTATUS_Pos        0                                   //  Gpio Instatus position
#define GPIO_INTSTATUS_Msk        (0xFFul << GPIO_INTSTATUS_Pos  )    //  Gpio Register for reading interrupt

#define GPIO_INTCLEAR_Pos        0                                    //  Gpio Intclear position
#define GPIO_INTCLEAR_Msk        (0xFFul << GPIO_INTCLEAR_Pos)        //  Gpio Register for clearing interrupt 

#define GPIO_MASKLOWBYTE_Pos     0                                    //  Gpio Masklowbyte position
#define GPIO_MASKLOWBYTE_Msk     (0x00FFul << GPIO_MASKLOWBYTE_Pos )  //  Gpio Register for masking lower 8 bits of gpio registers

#define GPIO_MASKHIGHBYTE_Pos    0                                    //  Gpio Maskhighbyte position
#define GPIO_MASKHIGHBYTE_Msk    (0xFF00ul << GPIO_MASKHIGHBYTE_Pos)  //  Gpio Register for masking higher 8 bits of gpio registers

//////////////////////////////////SPI register value

#define SPI_CLK_DIV_Pos                 0                                     // SPI clock divider position 
#define SPI_CLK_DIV_Msk                 (0x3ul << SPI_CLK_DIV_Pos)            // SPI Register for configurating clock divider value  
        
#define SPI_SLAVE_SEL_Pos               2                                     //  SPI Slave Select position
#define SPI_SLAVE_SEL_Msk               (0x3ul << SPI_SLAVE_SEL_Pos)          //  SPI Register for selecting SPI slave
        
#define SPI_CLK_MODE_Pos                4                                     //  SPI clock configuration position
#define SPI_CLK_MODE_Msk                (0x3ul << SPI_CLK_MODE_Pos)           //  SPI Register for configurating the phase and polarity of the clock
        
#define SPI_MODE_Pos                    6                                     //  SPI mode position
#define SPI_MODE_Msk                    (0x1ul << SPI_MODE_Pos)               //  SPI Register for configurating the SPI as a Master or a SLave
        
#define SPI_DUPLEX_TYPE_Pos             7                                     //  SPI Duplex Type position
#define SPI_DUPLEX_TYPE_Msk             (0x1ul << SPI_DUPLEX_TYPE_Pos)        //  SPI Register for determining the Duplex type (Full or Half)
        
#define SPI_TX_INT_EN_Pos               8                                     //  SPI TX Interrupt Enable position
#define SPI_TX_INT_EN_Msk               (0x1ul <<  SPI_TX_INT_EN_Pos)         //  SPI Register for enabling tx interrupt
        
#define SPI_RX_INT_EN_Pos               9                                     //  SPI RX Interrupt Enable position
#define SPI_RX_INT_EN_Msk               (0x1ul <<  SPI_RX_INT_EN_Pos)         //  SPI Register for enabling rx interrupt
        
#define SPI_EN_Pos                      10                                    //  SPI Enable position
#define SPI_EN_Msk                     (0x1ul <<  SPI_EN_Pos)                 //  SPI Register for enabling SPI operation

#define SPI_DATA_Pos                    0                                     //  SPI Data position
#define SPI_DATA_Msk                    (0xFFul <<  SPI_DATA_Pos)             //  SPI Register for Transmited and received Data
        
#define SPI_INTCLEAR_TX_IRQ_Pos         0                                     // SPI INTCLEAR/INTSTATUS register TX interrupt bit position   
#define SPI_INTCLEAR_TX_IRQ_Msk         (0x1ul << SPI_INTCLEAR_TX_IRQ_Pos)   // SPI INTCLEAR/INTSTATUS register TX interrupt bit mask to clear or read it

#define SPI_INTCLEAR_RX_IRQ_Pos         1                                     // SPI INTCLEAR/INTSTATUS register RX interrupt bit position  
#define SPI_INTCLEAR_RX_IRQ_Msk         (0x1ul << SPI_INTCLEAR_RX_IRQ_Pos)   // SPI INTCLEAR/INTSTATUS register RX interrupt bit mask to clear or read it