COMPONENT=mymainC

TINYOS_ROOT_DIR?=/home/johlab/Videos/lol/tinyos-main
#CFLAGS += -I$(TINYOS_OS_DIR)/lib/printf
CFLAGS += -DTOSH_DATA_LENGTH=110 #defines allowed packet payload size over radio or serial, don't make larger than 110 bytes
#CFLAGS += -DRF230_DEF_CHANNEL=26 #26 is the default radio channel, typically don't change this
include $(TINYOS_ROOT_DIR)/Makefile.include

