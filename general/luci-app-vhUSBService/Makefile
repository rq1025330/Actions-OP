#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

# PAK NAME ����Ͱ������ļ���һ��.
PKG_NAME:=luci-app-vhUSBService

# �����������������д.
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=20240409

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
include $(INCLUDE_DIR)/package.mk

# ��������ʾ��menuconfig�еĲ˵�·��
define Package/$(PKG_NAME)
 	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=VirtualHere USB Service for LuCI
	DEPENDS:=@(i386||x86_64||arm||aarch64||mipsel)
	PKGARCH:=all
endef

# ������˵��,��Ҫ������.
define Package/$(PKG_NAME)/description
    This package contains LuCI configuration pages for VH USB Service.
endef

#preinst : ��װǰִ�� , һ����������½�Ŀ¼,
#����ļ�������һ�������ڵ�Ŀ¼�����,������Щ��Ҫ��װǰ�½�Ŀ¼.���ߴ���һЩ�ļ���ͻ,��ԭ�����ļ�����.
define Package/$(PKG_NAME)/preinst
endef

#postinst : ��װ���ִ�� ,һ����ǰ�װ���Ȩ��,����ֱ������.
# ��װ��ִ�еĽű�
# ���������þ��ǰ�װ���./root/etc/init.d ./usr/bin/vhusbd���ִ��Ȩ��.

define Package/$(PKG_NAME)/postinst
#!/bin/sh
wget --no-check-certificate --user-agent="VH/OpenWRT" "https://www.virtualhere.com/sites/default/files/usbserver/$(EXE_FILE)" -O $(1)/usr/bin/vhusbd
if [ -z "$${IPKG_INSTROOT}" ]; then
	chmod 755 "$${IPKG_INSTROOT}/root/etc/init.d/vhusbd" >/dev/null 2>&1
	chmod 755 "$${IPKG_INSTROOT}/usr/bin/vhusbd" >/dev/null 2>&1
fi
exit 0
endef

#prerm : ж��ǰִ��
define Build/Prepare
endef

#postrm : ж�����ִ��
define Build/Compile
endef

ifeq ($(ARCH),i386)
	EXE_FILE:=vhusbdi386
endif
ifeq ($(ARCH),x86_64)
	EXE_FILE:=vhusbdx86_64
endif
ifeq ($(ARCH),mipsel)
	EXE_FILE:=vhusbdmipsel
endif
ifeq ($(ARCH),arm)
	EXE_FILE:=vhusbdarm
endif
ifeq ($(ARCH),aarch64)
	EXE_FILE:=vhusbdarm64
endif

# ��װ��ҵ
# ����һ����Ǹ����ļ�������и����ļ�ֱ�Ӳο��޸�.

define Package/$(PKG_NAME)/install

#	��������һ��
#	��һ����ָ�����Ƶ���Ŀ¼
#	�ڶ����ǿ����ļ�.
 
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
#	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/ $(1)/usr/lib/lua/luci
	
	$(INSTALL_DIR) $(1)/
#	cp -pR ./root/* $(1)/
	$(CP) ./root/* $(1)
  
	$(INSTALL_DIR) $(1)/usr/bin
#	cp -pR ./bin/$(EXE_FILE) $(1)/usr/bin/vhusbd
	$(CP) ./bin/$(EXE_FILE) $(1)/usr/bin/vhusbd

endef

$(eval $(call BuildPackage,$(PKG_NAME)))

# call BuildPackage - OpenWrt buildroot signature
