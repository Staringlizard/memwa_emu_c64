ARCH_FLAGS=-mcpu=cortex-m7
CC = arm-none-eabi-gcc
AR = arm-none-eabi-gcc-ar

# Remove at least flto and add -g when debugging
EMUCC_CFLAGS = $(ARCH_FLAGS) $(EMUCC_INCLUDE_FILES) -mthumb -g -Wall -ffunction-sections -Ofast -c
EMUCC_LFLAGS = $(ARCH_FLAGS) --specs=nosys.specs -mthumb  -g  -Wl,-Map=./out_libemucc/libemucc.map,--gc-section

EMUDD_CFLAGS = $(ARCH_FLAGS) $(EMUDD_INCLUDE_FILES) -mthumb -g  -Wall -ffunction-sections -Ofast -c
EMUDD_LFLAGS = $(ARCH_FLAGS) --specs=nosys.specs -mthumb -g   -Wl,-Map=./out_libemudd/libemudd.map,--gc-section

EMUCC_INCLUDE_FILES := \
	-I./if \
	-I./emucc

EMUCC_LINK_FILES := \
	./out_libemucc/bus.o \
	./out_libemucc/cia.o \
	./out_libemucc/cpu.o \
	./out_libemucc/joy.o \
	./out_libemucc/sid.o \
	./out_libemucc/emuccif.o \
	./out_libemucc/tap.o \
	./out_libemucc/vic.o \
	./out_libemucc/key.o

EMUDD_INCLUDE_FILES := \
	-I./if \
	-I./emudd

EMUDD_LINK_FILES := \
	./out_libemudd/bus.o \
	./out_libemudd/via.o \
	./out_libemudd/cpu.o \
	./out_libemudd/fdd.o \
	./out_libemudd/emuddif.o \

EMUCC = libemucc
EMUDD = libemudd

all: $(EMUCC) $(EMUDD)

$(EMUCC):
	@mkdir ./out_libemucc 2>/dev/null; true
	@echo Compiling emucc...
	$(CC) $(EMUCC_CFLAGS) -o out_libemucc/emuccif.o ./emucc/emuccif.c
	$(CC) $(EMUCC_CFLAGS) -o out_libemucc/bus.o ./emucc/bus.c
	$(CC) $(EMUCC_CFLAGS) -o out_libemucc/cia.o ./emucc/cia.c
	$(CC) $(EMUCC_CFLAGS) -o out_libemucc/cpu.o ./emucc/cpu.c
	$(CC) $(EMUCC_CFLAGS) -o out_libemucc/joy.o ./emucc/joy.c
	$(CC) $(EMUCC_CFLAGS) -o out_libemucc/sid.o ./emucc/sid.c
	$(CC) $(EMUCC_CFLAGS) -o out_libemucc/tap.o ./emucc/tap.c
	$(CC) $(EMUCC_CFLAGS) -DSCREEN_X2 -DHAVE_BORDERS -o out_libemucc/vic.o ./emucc/vic.c
	$(CC) $(EMUCC_CFLAGS) -o out_libemucc/key.o ./emucc/key.c

	@echo Linking...
	$(AR) rcs out_libemucc/libemucc.a $(EMUCC_LINK_FILES)

$(EMUDD):
	@mkdir ./out_libemudd 2>/dev/null; true
	@echo Compiling emudd...
	$(CC) $(EMUDD_CFLAGS) -o out_libemudd/bus.o ./emudd/bus.c
	$(CC) $(EMUDD_CFLAGS) -o out_libemudd/via.o ./emudd/via.c
	$(CC) $(EMUDD_CFLAGS) -o out_libemudd/cpu.o ./emudd/cpu.c
	$(CC) $(EMUDD_CFLAGS) -o out_libemudd/fdd.o ./emudd/fdd.c
	$(CC) $(EMUDD_CFLAGS) -o out_libemudd/emuddif.o ./emudd/emuddif.c

	@echo Linking...
	$(AR) rcs out_libemudd/libemudd.a $(EMUDD_LINK_FILES)

clean:
	rm -rf ./out_libemucc ./out_libemudd

