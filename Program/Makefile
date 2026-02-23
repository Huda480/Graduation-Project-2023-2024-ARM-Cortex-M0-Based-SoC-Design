PROJECT:=main

# Define the output directory
BUILD_DIR := build
BIN_DIR := $(BUILD_DIR)/bin
OBJ_DIR := $(BUILD_DIR)/obj

MODULES := MCAL HAL Common
SRC_DIRS := $(addsuffix /src/,$(MODULES))
INC_PATHS := $(addsuffix /include/,$(MODULES))
INCDIRS := $(addprefix -I,$(INC_PATHS))


ifneq ($(BUILD_DIR),)
  $(shell [ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR))
  $(shell [ -d $(OBJ_DIR) ] || mkdir -p $(OBJ_DIR))
  $(shell [ -d $(BIN_DIR) ] || mkdir -p $(BIN_DIR))
endif

DMA_TEST := Unit_test/src/dma_test.c
SERIAL_TEST := Unit_test/src/serial_test.c
TIMER_TEST := Unit_test/src/timer_test.c
GPIO_TEST := Unit_test/src/gpio_test.c
UART_TEST := Unit_test/src/uart_test.c
SPI_TEST := Unit_test/src/spi_test.c
DUALTIMER_TEST := Unit_test/src/dualtimer_test.c
WATCHDOG_TEST := Unit_test/src/watchdog_test.c
RCC_TEST := Unit_test/src/rcc_test.c

COMP_TEST := Unit_test/src/comp_test.c

BLE_TEST := Unit_test/src/ble_test.c
WIFI_TEST := Unit_test/src/wifi_test.c

SYS1_TEST := Unit_test/src/sys1_test.c
SYS2_TEST := Unit_test/src/sys2_test.c

DMA2_TEST := Unit_test/src/dma2_test.c
DMA3_TEST := Unit_test/src/dma3_test.c



ifdef SELECTED_TEST
    ifeq ($(SELECTED_TEST),DMA)
        SELECTED_SRC := $(DMA_TEST)
    else ifeq ($(SELECTED_TEST),SERIAL)
        SELECTED_SRC := $(SERIAL_TEST)
    else ifeq ($(SELECTED_TEST),TIMER)
        SELECTED_SRC := $(TIMER_TEST)
    else ifeq ($(SELECTED_TEST),GPIO)
        SELECTED_SRC := $(GPIO_TEST)
	else ifeq ($(SELECTED_TEST),UART)
        SELECTED_SRC := $(UART_TEST)
    else ifeq ($(SELECTED_TEST),SPI)
        SELECTED_SRC := $(SPI_TEST)
	else ifeq ($(SELECTED_TEST),DUALTIMER)
        SELECTED_SRC := $(DUALTIMER_TEST)
	else ifeq ($(SELECTED_TEST),GPIO)
        SELECTED_SRC := $(WATCHDOG_TEST)
	else ifeq ($(SELECTED_TEST),RCC)
        SELECTED_SRC := $(RCC_TEST)
    else ifeq ($(SELECTED_TEST),BLE)
        SELECTED_SRC := $(BLE_TEST)
    else ifeq ($(SELECTED_TEST),WIFI)
        SELECTED_SRC := $(WIFI_TEST)
    else ifeq ($(SELECTED_TEST),SYS1)
        SELECTED_SRC := $(SYS1_TEST)
    else ifeq ($(SELECTED_TEST),SYS2)
        SELECTED_SRC := $(SYS2_TEST)
    else ifeq ($(SELECTED_TEST),DMA2)
        SELECTED_SRC := $(DMA2_TEST)
    else ifeq ($(SELECTED_TEST),DMA3)
        SELECTED_SRC := $(DMA3_TEST)
    else ifeq ($(SELECTED_TEST),COMP)
        SELECTED_SRC := $(COMP_TEST)
    else
        $(error Unknown test selected: $(SELECTED_TEST))
    endif
else
    SELECTED_SRC := APP/src/main.c
endif



SRCS := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)*.c))
SRCS += $(SELECTED_SRC)
OBJS := $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(SRCS)))

$(info SRC_DIRS: $(SRC_DIRS))
$(info INC_DIRS: $(INC_PATHS))
$(info SRCS: $(SRCS))
$(info OBJS: $(OBJS))

# Output files
TARGET := $(notdir $(basename $(SELECTED_SRC)))
ELF := $(BIN_DIR)/$(TARGET).elf
BIN := $(BIN_DIR)/$(TARGET).bin
HEX := $(BIN_DIR)/$(TARGET).hex
ASM := $(BIN_DIR)/$(TARGET).asm

# toolchain settings
CROSS:=arm-none-eabi-
CC:=$(CROSS)gcc
OBJDUMP:=$(CROSS)objdump
OBJCOPY:=$(CROSS)objcopy

# gcc & ld compiler flags
OPT:=-Og
#	"Optimize for Debugging." It enables optimizations that don't interfere with debugging.

FLAGS:=-mcpu=cortex-m0 -mthumb
#	Cortex M0 with Thumb instructions.

CFLAGS:=$(FLAGS) $(OPT) -fno-common -g3 -Wall -Werror -Wextra -MD $(INCDIRS) -flto
#	-fno-common: specifies that the compiler places uninitialized global variables in the BSS section of the object file.
#	-g3: includes debugging information in the generated object files at the highest level (level 3).
#	-Wall -Werror -Wextra:  enable additional warning messages during compilation and treat them as errors (-Werror).
#	 						-Wall enables most warning messages, -Wextra enables additional warnings beyond those enabled by -Wall.

LDFLAGS:=$(FLAGS) -TlinkerScript.ld -Wl,-Map=output.map -nostartfiles --specs=nosys.specs -lnosys -flto
#	-Tminimal.ld: This flag specifies the linker script (minimal.ld).
#	-nostartfiles: Tells the linker not to use the standard system startup files.
#	-nostdlib: Instructs the linker not to use the standard system libraries.
#	-lnosys: Specifies a library (nosys) to link, which provides implementation for some system calls implemented as stubs that return errors when called.


.PHONY: all post_process clean


all: $(ELF) $(BIN) $(HEX) $(ASM)


$(ELF): $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
#	python .\insert_newlines.py $(BIN) $(BIN)

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

$(ASM): $(ELF)
	$(OBJDUMP) -S $< > $@

$(OBJ_DIR)/%.o: $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)*.c)) $(SELECTED_SRC)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $(filter %/$(notdir $(basename $@)).c,$^) -o $@

# n.o is made automatically from n.c with a recipe of the form ‘$(CC) $(CPPFLAGS) $(CFLAGS) -c’.


.depend: $(SRCS)
	$(CC) $(CFLAGS) -MM $^ > .depend;

# Post-processing step: run Python scripts on the generated .bin file 
post_process: $(BIN) 
	python3 insert_newlines.py $(BIN) temp.txt 
	python3 separate_files.py temp.txt 
	rm temp.txt

clean:
	rm -rf $(BUILD_DIR)
	rm output.map

#-include $(DEPS)
