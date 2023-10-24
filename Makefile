### MY_PARTICLE_MAKEFILE

# Vars
TOOLCHAIN_DIR:=$(shell readlink -f ~/.particle/toolchains)

MY_ENV:=/Users/radek/code/scripts/ParticleMakefile/.env
ifneq (,$(wildcard $(MY_ENV)))
    include $(MY_ENV)
    export
endif

# Overide global env with locals
# override DEVICE_OS_VERSION:=4.2.0
# override BUILDSCRIPT_VERSION:=1.15.0
# override ARM_VERSION=10.2.1

DEVICE_OS_PATH:=$(TOOLCHAIN_DIR)/deviceOS/$(DEVICE_OS_VERSION)
PARTICLE_MAKEFILE:=$(TOOLCHAIN_DIR)/buildscripts/$(BUILDSCRIPT_VERSION)/Makefile
ARM_DIR:=$(TOOLCHAIN_DIR)/gcc-arm/$(ARM_VERSION)/bin
# PATH is only changed for the duation of this Makefile
PATH:=$(ARM_DIR):$(PATH)
PARTICLE_CLI:=$(shell find ~/.vscode/extensions -type f -name 'particle' | grep darwin | sort --version-sort | tail -n 1)

# Platforms: https://docs.particle.io/firmware/best-practices/firmware-build-options/
PLATFORM:=bsom
PLATFORM_ID:=23
APPDIR:=$(shell pwd)

# Optional vars
# PARTICLE_DEVICE_ID=
# EXTRA_CFLAGS="-DFLAG_ONE=abc -DFLAG_TWO=123"
#
# Comment this in to flash locally compiled device os instead of downloaded binary
# for buildscript 1.15.0 onward
# override DEVICE_OS_VERSION:=source


# Targets
all: compile-user
compile: compile-user
compileb: compile-userb
flash: flash-user
clean: clean-user

compile-user:
	@bear --append -- make -f $(PARTICLE_MAKEFILE) -s compile-user PARTICLE_CLI_PATH=$(PARTICLE_CLI) DEVICE_OS_PATH=$(DEVICE_OS_PATH) APPDIR=$(APPDIR) PLATFORM=$(PLATFORM) PLATFORM_ID=$(PLATFORM_ID) EXTRA_CFLAGS=$(EXTRA_CFLAGS)

# Builds user firmware after clean with bear interception
compile-userb: clean-user
	@bear -- make -f $(PARTICLE_MAKEFILE) -s compile-user  PARTICLE_CLI_PATH=$(PARTICLE_CLI) DEVICE_OS_PATH=$(DEVICE_OS_PATH) APPDIR=$(APPDIR) PLATFORM=$(PLATFORM) PLATFORM_ID=$(PLATFORM_ID) EXTRA_CFLAGS=$(EXTRA_CFLAGS)

# Builds device os and user firmware after clean with bear interception
compile-all: clean-all
	@cd $(DEVICE_OS_PATH)/modules && bear -- make -s all PLATFORM=$(PLATFORM) PLATFORM_ID=$(PLATFORM_ID) EXTRA_CFLAGS=$(EXTRA_CFLAGS)
	@$(MAKE) link-os
	@bear -- make -s all PLATFORM=$(PLATFORM)

flash-user:
	@make -f $(PARTICLE_MAKEFILE) -s flash-user PARTICLE_CLI_PATH=$(PARTICLE_CLI) DEVICE_OS_PATH=$(DEVICE_OS_PATH) APPDIR=$(APPDIR) PLATFORM=$(PLATFORM) PARTICLE_DEVICE_ID=$(PARTICLE_DEVICE_ID) EXTRA_CFLAGS=$(EXTRA_CFLAGS)

# Note, buildscript 1.15.0 onward do not use your locally compiled device os, they use a download binary, so set 
# DEVICE_OS_VERSION var to the literal string source
flash-all:
	@make -f $(PARTICLE_MAKEFILE) flash-all PARTICLE_CLI_PATH=$(PARTICLE_CLI) DEVICE_OS_PATH=$(DEVICE_OS_PATH) APPDIR=$(APPDIR) PLATFORM=$(PLATFORM) PARTICLE_DEVICE_ID=$(PARTICLE_DEVICE_ID) DEVICE_OS_VERSION=$(DEVICE_OS_VERSION) EXTRA_CFLAGS=$(EXTRA_CFLAGS)

clean-all:
	@make -f '$(PARTICLE_MAKEFILE)' -s clean-all  DEVICE_OS_PATH=$(DEVICE_OS_PATH) PLATFORM=$(PLATFORM) PLATFORM_ID=$(PLATFORM_ID) APPDIR=$(APPDIR)

clean-user:
	@make -f '$(PARTICLE_MAKEFILE)' -s clean-user DEVICE_OS_PATH=$(DEVICE_OS_PATH) PLATFORM=$(PLATFORM) PLATFORM_ID=$(PLATFORM_ID) APPDIR=$(APPDIR)

# Links the compile commands json to the base device os directory, happens once
link-os:
ifeq (,$(wildcard $(DEVICE_OS_PATH)/compile_commands.json))
	@ln -s $(DEVICE_OS_PATH)/modules/compile_commands.json $(DEVICE_OS_PATH)/compile_commands.json
endif

dfu:
	@make -f $(PARTICLE_MAKEFILE) -s dfu PARTICLE_DEVICE_ID=$(PARTICLE_DEVICE_ID)

env:
	@echo "Device OS Version: $(DEVICE_OS_VERSION)"
	@echo "Device OS Path: $(DEVICE_OS_PATH)"
	@echo "PLATFORM: $(PLATFORM)"
	@echo "PLATFORM_ID: $(PLATFORM_ID)"
	@echo "APP Directory: $(APPDIR)"
	@echo "Arm version: $(ARM_VERSION)"
	@echo "Arm binaries: $(ARM_DIR)"
	@echo "Buildscript version: $(BUILDSCRIPT_VERSION)"
	@echo "Buildscript path: $(PARTICLE_MAKEFILE)"

.PHONY: all compile-user compile-userb compile-all compile compileb flash-user flash-all flash clean all clean-user link-os dfu env

