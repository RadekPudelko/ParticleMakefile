# PARTICLE_MAKEFILE is an env var set in.zshrc file and points to the make file used by particle
# EX:/Users/radek/.particle/toolchains/buildscripts/1.10.0/Makefile
# PARTICLE_CLI is an env var set in .zshrc and points to the particle cli binary
# EX /Users/radek/.vscode/extensions/particle.particle-vscode-core-1.15.9/src/cli/bin/darwin/amd64/particle
# PARTICLE_CC is an env var set in .zshrc the arm compiler used by particle
# EX: /Users/radek/.particle/toolchains/gcc-arm/10.2.1/bin/arm-none-eabi-gcc

OS_VERSION=4.0.2
DEVICE_OS_PATH=/Users/radek/.particle/toolchains/deviceOS/$(OS_VERSION)
APPDIR=$(shell pwd)
PLATFORM=bsom
#PLATFORM_ID=23 # Alt to PLATFORM
# Optional device id 
#PARTICLE_DEVICE_ID=

all: compile

compile:
	make -f $(PARTICLE_MAKEFILE) -s compile-user PARTICLE_CLI_PATH=$(PARTICLE_CLI) DEVICE_OS_PATH=$(DEVICE_OS_PATH) APPDIR=$(APPDIR) PLATFORM=$(PLATFORM) CC=$(PARTICLE_CC)

compile2: clean
	CC=$(PARTICLE_CC) bear -- make -f $(PARTICLE_MAKEFILE) -s compile-user PARTICLE_CLI_PATH=$(PARTICLE_CLI) DEVICE_OS_PATH=$(DEVICE_OS_PATH) APPDIR=$(APPDIR) PLATFORM=$(PLATFORM) CC=$(PARTICLE_CC)

compile-all:
	cd $(DEVICE_OS_PATH)/modules && make clean -s PLATFORM=$(PLATFORM)
	CC=$(PARTICLE_CC) cd $(DEVICE_OS_PATH)/modules && bear -- make all -s PLATFORM=$(PLATFORM)

link-os:
	ln -s $(DEVICE_OS_PATH)/modules/compile_commands.json $(DEVICE_OS_PATH)/compile_commands.json

dfu:
	make -f $(PARTICLE_MAKEFILE) -s dfu PARTICLE_DEVICE_ID=$(PARTICLE_DEVICE_ID)

flash:
	make -f $(PARTICLE_MAKEFILE) -s flash-user PARTICLE_CLI_PATH=$(PARTICLE_CLI) DEVICE_OS_PATH=$(DEVICE_OS_PATH) APPDIR=$(APPDIR) PLATFORM=$(PLATFORM) PARTICLE_DEVICE_ID=$(PARTICLE_DEVICE_ID) CC=$(PARTICLE_CC)

clean:
	make -f '$(PARTICLE_MAKEFILE)' clean-all -s DEVICE_OS_PATH=$(DEVICE_OS_PATH) PLATFORM=$(PLATFORM) APPDIR=$(APPDIR)

.PHONY: all compile1 compile2 compile-all dfu flash clean
