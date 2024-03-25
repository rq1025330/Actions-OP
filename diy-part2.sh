#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/bin/config_generate

# Delete default password
#sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

# Default theme
sed -i 's/luci-theme-bootstrap/luci-theme-opentomcat/g' feeds/luci/collections/luci/Makefile

# Autocore
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile

# Replace coremark.sh with the new one
#cp -f $GITHUB_WORKSPACE/general/coremark.sh feeds/packages/utils/coremark/

# OpenConnect Change to system
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-ocserv/luasrc/controller/ocserv.lua #OpenConnect VPN-->VPN

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 更改 Argon 主题背景
#cp -f $GITHUB_WORKSPACE/general/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 移除不用软件包
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-pptp-server
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/packages/net/smartdns
rm -rf feeds/packages/utils/syncthing

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Golang 1.18.x -> 1.19.x
#sed -i 's/GO_VERSION_MAJOR_MINOR:=.*/GO_VERSION_MAJOR_MINOR:=1.19/g' feeds/packages/lang/golang/golang/Makefile
#sed -i 's/GO_VERSION_PATCH:=.*/GO_VERSION_PATCH:=2/g' feeds/packages/lang/golang/golang/Makefile
#sed -i 's/PKG_HASH:=.*/PKG_HASH:=2ce930d70a931de660fdaf271d70192793b1b240272645bf0275779f6704df6b/g' feeds/packages/lang/golang/golang/Makefile

# libxml2
#git clone --depth=1 https://github.com/immortalwrt/immortalwrt.git
#rm -rf feeds/packages/libs/libxml2
#cp -rf immortalwrt/package/libs/libxml2 feeds/packages/libs/libxml2

# libxslt
git clone --depth=1 https://github.com/Lienol/openwrt-packages.git
rm -rf feeds/packages/libs/libxslt
cp -rf openwrt-packages/libs/libxslt feeds/packages/libs/libxslt
rm -rf openwrt-packages

# elfutils
rm -rf package/libs/elfutils
git clone --depth=1 https://github.com/Lienol/openwrt.git
cp -rf openwrt/package/libs/elfutils package/libs/elfutils
rm -rf openwrt

# python-yaml
rm -rf feeds/packages/lang/python/python-yaml
git clone --depth=1 https://github.com/Lienol/openwrt-packages.git
cp -rf openwrt-packages/lang/python/python-yaml feeds/packages/lang/python/python-yaml
rm -rf openwrt-packages


# 添加额外软件包
git clone --depth=1 https://github.com/sbwml/luci-app-alist.git  package/alist
git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone --depth=1 https://github.com/sirpdboy/luci-app-autotimeset.git  package/luci-app-autotimeset
git clone --depth=1 https://github.com/sirpdboy/luci-app-netdata.git  package/luci-app-netdata #lean中包含,修改中文
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
git clone --depth=1 https://github.com/iwrt/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
#svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser
git clone -b 18.06 https://github.com/xiaozhuai/luci-app-filebrowser package/luci-app-filebrowser #lienol源码改进而来
sed -i 's/services/nas/g' package/luci-app-filebrowser/luasrc/controller/filebrowser.lua #文件浏览器-->网络存储
git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-pptp-server #lean中包含
git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-ssr-mudb-server

git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-fileassistant #lean中包含
git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-syncthing
cp -r package/luci-app-syncthing/po/zh_Hans/ package/luci-app-syncthing/po/zh-cn/

git_sparse_clone master https://github.com/immortalwrt/packages utils/syncthing
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-smartdns
git_sparse_clone master https://github.com/kenzok8/openwrt-packages smartdns #lean中包含,feeds/packages/net
git_sparse_clone master https://github.com/sundaqiang/openwrt-packages luci-app-wolplus

# 添加Amlogic Service
git_sparse_clone main https://github.com/ophub/luci-app-amlogic luci-app-amlogic
# Modify the default configuration of Amlogic Box
# 1.Set the download repository of the OpenWrt files to your github.com（OpenWrt 文件的下载仓库）
sed -i "s|https.*/OpenWrt|https://github.com/rq1025330/Actions-OP|g" package/luci-app-amlogic/root/etc/config/amlogic
# 2.Set the keywords of Tags in your github.com Releases（Releases 里 Tags 的关键字）
sed -i "s|ARMv8|ARMv8_Full|g" package/luci-app-amlogic/root/etc/config/amlogic
# 3.Set the suffix of the OPENWRT files in your github.com Releases（Releases 里 OpenWrt 文件的后缀）
#sed -i "s|.img.gz|_Full.img.gz|g" package/luci-app-amlogic/root/etc/config/amlogic
# 4.Set the download path of the kernel in your github.com repository（OpenWrt 内核的下载路径）
sed -i "s|opt/kernel|https://github.com/breakings/OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic

#添加易有云 DDNSTO istore
git clone --depth=1 https://github.com/linkease/nas-packages.git package/nas-packages
git clone --depth=1 https://github.com/linkease/nas-packages-luci.git package/nas-packages-luci
git clone --depth=1 https://github.com/linkease/istore-ui.git package/istore-ui
git clone --depth=1 https://github.com/linkease/istore.git package/istore
sed -i 's/luci-lib-ipkg/luci-base/g' package/istore/luci/luci-app-store/Makefile

git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# 添加vssr&ssr-plus&passwall
git_sparse_clone master https://github.com/xiangfeidexiaohuo/extra-ipk patch/wall-luci/luci-app-vssr
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb #vssr 依赖

git clone --depth=1 https://github.com/fw876/helloworld.git
cp -rf helloworld/luci-app-ssr-plus package/luci-app-ssr-plus
#cp -rf helloworld/chinadns-ng package/chinadns-ng
#cp -rf helloworld/dns2socks package/dns2socks
#cp -rf helloworld/dns2tcp package/dns2tcp
#cp -rf helloworld/gn package/gn
#cp -rf helloworld/hysteria package/hysteria
#cp -rf helloworld/ipt2socks package/ipt2socks
cp -rf helloworld/lua-neturl package/lua-neturl
#cp -rf helloworld/microsocks package/microsocks
#cp -rf helloworld/naiveproxy package/naiveproxy
cp -rf helloworld/redsocks2 package/redsocks2
cp -rf helloworld/shadow-tls package/shadow-tls
#cp -rf helloworld/shadowsocks-rust package/shadowsocks-rust
#cp -rf helloworld/shadowsocksr-libev package/shadowsocksr-libev
#cp -rf helloworld/simple-obfs package/simple-obfs
#cp -rf helloworld/tcping package/tcping
#cp -rf helloworld/trojan package/trojan
cp -rf helloworld/tuic-client package/tuic-client
#cp -rf helloworld/v2ray-core package/v2ray-core
#cp -rf helloworld/v2ray-geodata package/v2ray-geodata
#cp -rf helloworld/v2ray-plugin package/v2ray-plugin
#cp -rf helloworld/v2raya package/v2raya
#cp -rf helloworld/xray-core package/xray-core
#cp -rf helloworld/xray-plugin package/xray-plugin
rm -rf helloworld

git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git  package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git  package/luci-app-passwall2

git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git
cp -rf openwrt-passwall-packages/brook package/brook
cp -rf openwrt-passwall-packages/chinadns-ng package/chinadns-ng
cp -rf openwrt-passwall-packages/dns2socks package/dns2socks
cp -rf openwrt-passwall-packages/dns2tcp package/dns2tcp
cp -rf openwrt-passwall-packages/gn package/gn
cp -rf openwrt-passwall-packages/hysteria package/hysteria
cp -rf openwrt-passwall-packages/ipt2socks package/ipt2socks
cp -rf openwrt-passwall-packages/microsocks package/microsocks
cp -rf openwrt-passwall-packages/naiveproxy package/naiveproxy
#cp -rf openwrt-passwall-packages/pdnsd-alt package/pdnsd-alt #与lean重复feeds/packages/net
cp -rf openwrt-passwall-packages/shadowsocks-rust package/shadowsocks-rust
cp -rf openwrt-passwall-packages/shadowsocksr-libev package/shadowsocksr-libev
cp -rf openwrt-passwall-packages/simple-obfs package/simple-obfs
cp -rf openwrt-passwall-packages/sing-box package/sing-box
cp -rf openwrt-passwall-packages/ssocks package/ssocks
cp -rf openwrt-passwall-packages/tcping package/tcping
cp -rf openwrt-passwall-packages/trojan-go package/trojan-go
cp -rf openwrt-passwall-packages/trojan-plus package/trojan-plus
cp -rf openwrt-passwall-packages/trojan package/trojan
cp -rf openwrt-passwall-packages/tuic-client package/tuic-client
cp -rf openwrt-passwall-packages/v2ray-core package/v2ray-core
#cp -rf openwrt-passwall-packages/v2ray-geodata package/v2ray-geodata #与lean重复feeds/packages/net
cp -rf openwrt-passwall-packages/v2ray-plugin package/v2ray-plugin
cp -rf openwrt-passwall-packages/xray-core package/xray-core
cp -rf openwrt-passwall-packages/xray-plugin package/xray-plugin
rm -rf openwrt-passwall-packages

# 添加themes
git clone --depth=1 https://github.com/kenzok78/luci-app-argonne-config.git  package/luci-app-argonne-config
git clone --depth=1 https://github.com/kenzok78/luci-theme-argonne.git  package/luci-theme-argonne
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-theme-atmaterial_new
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-theme-ifit
git clone --depth=1 https://github.com/thinktip/luci-theme-neobird.git package/luci-theme-neobird
git clone --depth=1 https://github.com/Leo-Jo-My/luci-theme-opentomato.git package/luci-theme-opentomato
git clone --depth=1 https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
# fix luci-theme-opentomcat dockerman icon missing
#rm -f package/luci-theme-opentomcat/files/htdocs/fonts/advancedtomato.woff
cp -rf $GITHUB_WORKSPACE/general/advancedtomato.woff package/luci-theme-opentomcat/files/htdocs/fonts
sed -i 's/e025/e02c/g' package/luci-theme-opentomcat/files/htdocs/css/style.css
sed -i 's/66CC00/00b2ee/g' package/luci-theme-opentomcat/files/htdocs/css/style.css
git clone --depth=1 https://github.com/sirpdboy/luci-theme-opentopd.git package/luci-theme-opentopd
git_sparse_clone master https://github.com/apollo-ng/luci-theme-darkmatter luci/themes/luci-theme-darkmatter
git_sparse_clone openwrt-18.06 https://github.com/rosywrt/luci-theme-rosy luci-theme-rosy

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}

#find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
#find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-alt/shadowsocksr-libev-ssr-redir/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-server/shadowsocksr-libev-ssr-server/g' {}

./scripts/feeds update -a
./scripts/feeds install -a