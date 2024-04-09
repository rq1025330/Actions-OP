#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

# PAK NAME 必须和包所在文件夹一样.
PKG_NAME:=luci-app-vhUSBService

# 下面三个参数随便填写.
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=20240409

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
include $(INCLUDE_DIR)/package.mk

# 下面是显示在menuconfig中的菜单路径
define Package/$(PKG_NAME)
 	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=VirtualHere USB Service for LuCI
	DEPENDS:=@(i386||x86_64||arm||aarch64||mipsel)
	PKGARCH:=all
endef

# 包介绍说明,不要用中文.
define Package/$(PKG_NAME)/description
    This package contains LuCI configuration pages for VH USB Service.
endef

#preinst : 安装前执行 , 一般可以用来新建目录,
#如果文件拷贝到一个不存在的目录会出错,所以有些需要安装前新建目录.或者处理一些文件冲突,将原来的文件备份.
define Package/$(PKG_NAME)/preinst
endef

#postinst : 安装完成执行 ,一般就是安装后给权限,或者直接启动.
# 安装后执行的脚本
# 这里大概作用就是安装后给./root/etc/init.d ./usr/bin/vhusbd添加执行权限.

define Package/$(PKG_NAME)/postinst
#!/bin/sh
wget --no-check-certificate --user-agent="VH/OpenWRT" "https://www.virtualhere.com/sites/default/files/usbserver/$(EXE_FILE)" -O $(1)/usr/bin/vhusbd
if [ -z "$${IPKG_INSTROOT}" ]; then
	chmod 755 "$${IPKG_INSTROOT}/root/etc/init.d/vhusbd" >/dev/null 2>&1
	chmod 755 "$${IPKG_INSTROOT}/usr/bin/vhusbd" >/dev/null 2>&1
fi
exit 0
endef

#prerm : 卸载前执行
define Build/Prepare
endef

#postrm : 卸载完成执行
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

# 安装作业
# 这里一般就是复制文件，如果有更多文件直接参考修改.

define Package/$(PKG_NAME)/install

#	两条命令一组
#	第一条是指定复制到的目录
#	第二条是拷贝文件.
 
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
