IPOD_UI_VERSION = 1.0
IPOD_UI_SITE = $(BR2_EXTERNAL_IPOD_PATH)/ui/ipod-js
IPOD_UI_SITE_METHOD = local

define IPOD_UI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/opt/ipod
	cp -r $(@D)/* $(TARGET_DIR)/opt/ipod/
endef

$(eval $(generic-package))
