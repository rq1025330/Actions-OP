#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-virtualhere
LUCI_PKGARCH:=all
PKG_VERSION:=2.0.2
PKG_RELEASE:=20210917

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
 	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=VirtualHere USB Service for LuCI
	DEPENDS:=@(i386||x86_64||arm||mipsel)
	PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
    This package contains LuCI configuration pages for VirtualHere USB Service.
endef

define Build/Prepare
endef

define Build/Compile
endef

ifeq ($(ARCH),x86_64)
	EXE_FILE:=vhusbdx86
endif
ifeq ($(ARCH),i386)
	EXE_FILE:=vhusbdx86
endif
ifeq ($(ARCH),mipsel)
	EXE_FILE:=vhusbdmipsel
endif
ifeq ($(ARCH),arm)
	EXE_FILE:=vhusbdarm
endif

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/bin
	cp -pR ./bin/$(EXE_FILE) $(1)/usr/bin/vhusbd
endef


$(eval $(call BuildPackage,$(PKG_NAME)))

# call BuildPackage - OpenWrt buildroot signature
