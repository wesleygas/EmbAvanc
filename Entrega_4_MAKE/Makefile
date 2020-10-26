#
TARGET = hps_gpio
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall   -D$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY)   -I$(HWLIBS_ROOT)/include/
LDFLAGS =  -g -Wall 
CC = $(CROSS_COMPILE)gcc
ARCH= arm
SOC_IP = 192.168.0.24
SOC_PORT = 37485
SOC_DIR = /home/root/$(TARGET)

build: $(TARGET)

$(TARGET): main.o 
	$(CC) $(LDFLAGS)   $^ -o $@ 

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean: stop
	rm -f $(TARGET) *.a *.o *~
	ssh root@$(SOC_IP) rm $(TARGET)

deploy: build
	scp $(TARGET) root@$(SOC_IP):$(SOCDIR)


run: deploy
	ssh root@$(SOC_IP) ./$(TARGET)

stop:
	ssh root@$(SOC_IP) killall $(TARGET) || killall gdbserver

gdbserver: deploy
	ssh root@$(SOC_IP) gdbserver --multi PORT:$(SOC_PORT)

debug:
	exec arm-linux-gnueabihf-gdb -ex=r --args upgdb.sh $(SOC_IP):$(SOC_PORT) $(SOCDIR)
