include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FLEX12prefs
FLEX12prefs_FILES = $(wildcard *.m)
FLEX12prefs_INSTALL_PATH = /Library/PreferenceBundles
FLEX12prefs_FRAMEWORKS = UIKit
FLEX12prefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FLEX12prefs.plist$(ECHO_END)
