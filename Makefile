# Makefile adapted from: https://vivonomicon.com/2018/04/20/bare-metal-stm32-programming-part-2-making-it-to-main/
TARGET = main

# Define the linker script location and chip architecture.
LD_SCRIPT = STM32G474RETX_FLASH.ld
STARTUP_FILE = startup_stm32g474xx.s
MCU_SPEC  = cortex-m4
CHIP_NUMBER = STM32G474xx
# Find the Chip Number in inc/stm32g4xx.h lines 106-125

# Toolchain definitions (ARM bare metal defaults)
TOOLCHAIN = /usr
CC = $(TOOLCHAIN)/bin/arm-none-eabi-gcc
AS = $(TOOLCHAIN)/bin/arm-none-eabi-as
LD = $(TOOLCHAIN)/bin/arm-none-eabi-ld
OC = $(TOOLCHAIN)/bin/arm-none-eabi-objcopy
OD = $(TOOLCHAIN)/bin/arm-none-eabi-objdump
OS = $(TOOLCHAIN)/bin/arm-none-eabi-size

# Assembly directives.
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall

# C compilation directives
CFLAGS += -mcpu=$(MCU_SPEC)
CFLAGS += -mthumb
CFLAGS += -Wall
CFLAGS += -g
CFLAGS += -specs=nano.specs
CFLAGS += -mfpu=fpv4-sp-d16
CFLAGS += -mfloat-abi=hard

# Linker directives.
LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += -specs=nano.specs
LFLAGS += -specs=nosys.specs
LFLAGS += -lnosys
LFLAGS += -lc
LFLAGS += -lgcc
LFLAGS += -mfpu=fpv4-sp-d16
LFLAGS += -mfloat-abi=hard
LFLAGS += -T$(LSCRIPT)

INCLUDE = ./inc/

AS_SRC   = $(STARTUP_FILE)
C_SRC    = ./src/main.c
C_SRC   += ./src/system_stm32g4xx.c

OBJS += $(AS_SRC:.s=.o)
OBJS += $(C_SRC:.c=.o)

.PHONY: all
all: $(TARGET).bin

%.o: %.s
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) -I$(INCLUDE) -D$(CHIP_NUMBER) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<

.PHONY: clean flash
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf
	rm -f $(TARGET).bin

flash:
	st-flash --reset write main.bin 0x08000000
