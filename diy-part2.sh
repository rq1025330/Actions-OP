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

# Default theme
sed -i 's/luci-theme-bootstrap/luci-theme-opentomcat/g' feeds/luci/collections/luci/Makefile

# Delete default password
#sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

# Readd cpufreq for aarch64 & Change to system
#sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(aarch64\|\|arm\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile
#sed -i 's/services/system/g' feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua #CPU性能调节-->系统

#replace coremark.sh with the new one
#cp -f $GITHUB_WORKSPACE/general/coremark.sh feeds/packages/utils/coremark/

# Autocore
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile

# OpenConnect Change to system
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-ocserv/luasrc/controller/ocserv.lua #OpenConnect VPN-->VPN

# ruby
#rm -rf feeds/packages/lang/ruby
#svn co https://github.com/openwrt/packages/trunk/lang/ruby feeds/packages/lang/ruby

# 移除不用软件包
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-pptp-server
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/smartdns
rm -rf feeds/packages/utils/syncthing

# 添加额外软件包
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset
git clone https://github.com/sirpdboy/luci-app-netdata package/luci-app-netdata #lean中包含,修改中文
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/iwrt/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
#git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
svn co https://github.com/sundaqiang/openwrt-packages/trunk/luci-app-wolplus package/luci-app-wolplus
#svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser
svn co https://github.com/xiaozhuai/luci-app-filebrowser/branches/18.06 package/luci-app-filebrowser #lienol源码改进而来
sed -i 's/services/nas/g' package/luci-app-filebrowser/luasrc/controller/filebrowser.lua #文件浏览器-->网络存储
#svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-ipsec-server package/luci-app-ipsec-server #已同步Lienol
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-pptp-server package/luci-app-pptp-server #lean中包含
#svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-socat package/luci-app-socat #已同步Lienol
#svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-socat package/luci-app-socat #lean中包含
svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-fileassistant package/luci-app-fileassistant
svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-gost package/luci-app-gost
svn co https://github.com/immortalwrt/packages/trunk/net/gost package/gost
svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-ssr-mudb-server package/luci-app-ssr-mudb-server
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-mosdns package/luci-app-mosdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/mosdns package/mosdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/luci-app-smartdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/smartdns package/smartdns #lean中包含,feeds/packages/net
#svn co https://github.com/kenzok8/jell/trunk/luci-app-syncthing package/luci-app-syncthing
#svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-syncthing package/luci-app-syncthing
svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-syncthing package/luci-app-syncthing
cp -r package/luci-app-syncthing/po/zh_Hans/ package/luci-app-syncthing/po/zh-cn/
svn co https://github.com/immortalwrt/packages/trunk/utils/syncthing package/syncthing

#添加易有云 DDNSTO istore
git clone https://github.com/linkease/nas-packages.git package/nas-packages
git clone https://github.com/linkease/nas-packages-luci.git package/nas-packages-luci
git clone https://github.com/linkease/istore-ui.git package/istore-ui
git clone https://github.com/linkease/istore.git package/istore
sed -i 's/luci-lib-ipkg/luci-base/g' package/istore/luci/luci-app-store/Makefile

# 其他软件包

#git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot #lean中包含
#git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan #lean中包含
#svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt package/aliyundrive-webdav #lean中包含
#svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-rebootschedule package/luci-app-rebootschedule #未使用
#svn co https://github.com/halldong/luci-app-speederv2/trunk package/luci-app-speederv2 #未使用

# Amlogic Service
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
# Modify the default configuration of Amlogic Box
# 1.Set the download repository of the OpenWrt files to your github.com（OpenWrt 文件的下载仓库）
sed -i "s|https.*/OpenWrt|https://github.com/rq1025330/Actions-OP|g" package/luci-app-amlogic/root/etc/config/amlogic
# 2.Set the keywords of Tags in your github.com Releases（Releases 里 Tags 的关键字）
#sed -i "s|ARMv8|ARMv8|g" package/luci-app-amlogic/root/etc/config/amlogic
# 3.Set the suffix of the OPENWRT files in your github.com Releases（Releases 里 OpenWrt 文件的后缀）
sed -i "s|.img.gz|_Full.img.gz|g" package/luci-app-amlogic/root/etc/config/amlogic
# 4.Set the download path of the kernel in your github.com repository（OpenWrt 内核的下载路径）
sed -i "s|opt/kernel|BuildARMv8|g" package/luci-app-amlogic/root/etc/config/amlogic

svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
#pushd package/luci-app-openclash/tools/po2lmo
#make && sudo make install
#popd

# 添加vssr&ssr-plus&passwall
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb #vssr 依赖 

svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
#svn co https://github.com/fw876/helloworld/trunk/dns2tcp package/dns2tcp
#svn co https://github.com/fw876/helloworld/trunk/hysteria package/hysteria
#svn co https://github.com/fw876/helloworld/trunk/naiveproxy package/naiveproxy #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/sagernet-core package/sagernet-core #替换passwall
#svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/shadowsocks-rust #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/shadowsocksr-libev package/shadowsocksr-libev #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/simple-obfs package/simple-obfs #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/tcping package/tcping
#svn co https://github.com/fw876/helloworld/trunk/trojan package/trojan #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/v2ray-core package/v2ray-core #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/v2ray-geodata package/v2ray-geodata #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/v2ray-plugin package/v2ray-plugin #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/xray-core package/xray-core #可替换passwall
#svn co https://github.com/fw876/helloworld/trunk/xray-plugin package/xray-plugin #替换passwall

#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall2/trunk//luci-app-passwall2 package/luci-app-passwall2
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook package/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng package/chinadns-ng
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/dns2socks package/dns2socks #与lean重复feeds/packages/net
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/dns2tcp package/dns2tcp
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/hysteria package/hysteria
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ipt2socks package/ipt2socks #与lean重复
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/microsocks package/microsocks #与lean重复
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/naiveproxy package/naiveproxy
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/pdnsd-alt package/pdnsd-alt #与lean重复
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/sagernet-core package/sagernet-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocks-rust package/shadowsocks-rust
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocksr-libev package/shadowsocksr-libev
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/simple-obfs package/simple-obfs
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ssocks package/ssocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/tcping package/tcping
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus package/trojan-plus
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan package/trojan
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-core package/v2ray-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-geodata package/v2ray-geodata
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-plugin package/v2ray-plugin
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core package/xray-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-plugin package/xray-plugin

# 添加argon-config 最新argon v1.x.x 适配18.06和Lean Openwrt
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
svn co https://github.com/jerrykuku/luci-theme-argon/branches/18.06 package/luci-theme-argon

# 添加themes
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-atmaterial_new package/luci-theme-atmaterial_new
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-ifit package/luci-theme-ifit
svn co https://github.com/Leo-Jo-My/luci-theme-opentomato/trunk package/luci-theme-opentomato
svn co https://github.com/Leo-Jo-My/luci-theme-opentomcat/trunk package/luci-theme-opentomcat
# fix luci-theme-opentomcat dockerman icon missing
rm -f package/luci-theme-opentomcat/files/htdocs/fonts/advancedtomato.woff
cp $GITHUB_WORKSPACE/general/advancedtomato.woff package/luci-theme-opentomcat/files/htdocs/fonts
sed -i 's/e025/e02c/g' package/luci-theme-opentomcat/files/htdocs/css/style.css
sed -i 's/66CC00/00b2ee/g' package/luci-theme-opentomcat/files/htdocs/css/style.css
svn co https://github.com/sirpdboy/luci-theme-opentopd/trunk package/luci-theme-opentopd
svn co https://github.com/apollo-ng/luci-theme-darkmatter/trunk/luci/themes/luci-theme-darkmatter package/luci-theme-darkmatter
svn co https://github.com/rosywrt/luci-theme-rosy/trunk/luci-theme-rosy package/luci-theme-rosy

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}

#find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
#find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-alt/shadowsocksr-libev-ssr-redir/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-server/shadowsocksr-libev-ssr-server/g' {}

./scripts/feeds update -a
./scripts/feeds install -a
