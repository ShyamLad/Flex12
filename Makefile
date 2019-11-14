#Makefile based off of NSExceptional's: https://github.com/NSExceptional/FLEXing/blob/master/Makefile


#change the target, but you might lose NSLog in console
export TARGET = iphone:13.2:13.2
export ARCHS = arm64 arm64e
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FLEX12

# FULL PATH of the FLEX repo on your own machine
FLEX_ROOT = ./

# Function to convert /foo/bar to -I/foo/bar
dtoim = $(foreach d,$(1),-I$(d))

# Gather FLEX sources
SOURCES = $(shell find $(FLEX_ROOT)/Classes -name '*.m')
SOURCES += $(shell find $(FLEX_ROOT)/Classes -name '*.mm')
# Gather FLEX headers for search paths
_IMPORTS =  $(shell /bin/ls -d $(FLEX_ROOT)/Classes/*/)
_IMPORTS += $(shell /bin/ls -d $(FLEX_ROOT)/Classes/*/*/)
IMPORTS = -I$(FLEX_ROOT)/Classes/ $(call dtoim, $(_IMPORTS))

FLEX12_FRAMEWORKS = CoreGraphics UIKit ImageIO QuartzCore
FLEX12_FILES = Tweak.xm $(SOURCES)
FLEX12_LIBRARIES = sqlite3 z
FLEX12_CFLAGS += -fobjc-arc -w $(IMPORTS)

include $(THEOS_MAKE_PATH)/tweak.mk


after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += flex12prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
