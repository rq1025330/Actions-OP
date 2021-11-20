#!/bin/bash

OpVersion=$(echo "$(cat /workdir/openwrt/package/lean/default-settings/files/zzz-default-settings)" | grep -Po "DISTRIB_REVISION=\'\K[^\']*")

echo $OpVersion
echo $PWD

sed -i "s/OPENWRT_VER=.*/OPENWRT_VER=\"$OpVersion\"/" /home/runner/work/Actions-OpenWrt/Actions-OpenWrt/scripts/whoami