#!/bin/bash

OpVersion=$(echo "$(cat /workdir/openwrt/package/lean/default-settings/files/zzz-default-settings)" | grep -Po "DISTRIB_REVISION=\'\K[^\']*")

echo $OpVersion

sed -i "s/OPENWRT_VER=.*/OPENWRT_VER=\"$OpVersion\"/" `grep OPENWRT_VER=.* -rl /opt/openwrt/`
