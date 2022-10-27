#!/bin/bash

cd /opt/openwrt_packit
cp make.env makebasic.env
cp make.env makeplus.env
cp make.env makeplusplus.env

#sync the kernel version
BV=$(find /opt/kernel/ -name "boot*+o.tar.gz" | awk -F '[-.]' '{print $2"."$3"."$4"-"$5"-"$6}')
#PV=$(find /opt/kernel/ -name "boot*5\.15*+.tar.gz" | awk -F '[-.]' '{print $2"."$3"."$4"-"$5"-"$6}')
PPV=$(find /opt/kernel/ -name "boot*6\.0*+.tar.gz" | awk -F '[-.]' '{print $2"."$3"."$4"-"$5"-"$6}')

echo "$BV" > BV.txt
#echo "$PV" > PV.txt
echo "$PPV" > PPV.txt

#KBV=$(sed -n '1p' BV.txt)
#KPV=$(awk 'NR==1 {print}' PV.txt)
#KPPV=$(head -n 1 PPV.txt)

KBV=$(sed -n '1p' BV.txt)
#KPV=$(sed -n '1p' PV.txt)
KPPV=$(sed -n '1p' PPV.txt)

sed -i "s/^    KERNEL_VERSION.*/    KERNEL_VERSION=\"$KBV\"/" makebasic.env
#sed -i "s/^    KERNEL_VERSION.*/    KERNEL_VERSION=\"$KPV\"/" makeplus.env
sed -i "s/^    KERNEL_VERSION.*/    KERNEL_VERSION=\"$KPPV\"/" makeplusplus.env

#修改默认DTB文件（HK1），分隔符 "/" 替换成 "?"
sed -i 's?FDT=/dtb/amlogic/meson-sm1-x96-max-plus-100m.dtb?#FDT=/dtb/amlogic/meson-sm1-x96-max-plus-100m.dtb?g' mk_s905x3_multi.sh
sed -i 's?#FDT=/dtb/amlogic/meson-sm1-hk1box-vontar-x3.dtb?FDT=/dtb/amlogic/meson-sm1-hk1box-vontar-x3.dtb?g' mk_s905x3_multi.sh

for F in *.sh ; do cp $F ${F%.sh}_basic.sh && cp $F ${F%.sh}_plus.sh && cp $F ${F%.sh}_plusplus.sh;done
find ./* -maxdepth 1 -path "*_basic.sh" | xargs -i sed -i 's/make\.env/makebasic\.env/g' {}
#find ./* -maxdepth 1 -path "*_plus.sh" | xargs -i sed -i 's/make\.env/makeplus\.env/g' {}
find ./* -maxdepth 1 -path "*_plusplus.sh" | xargs -i sed -i 's/make\.env/makeplusplus\.env/g' {}

#统一用Full打包
find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"Full-openwrt/g' {}
find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_Full\.img/g' {}


#旧内核新内核分开打包，修改后缀
#12以后内核无法使用SFE，使用仅含FOL的固件进行打包
#find ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"F-openwrt/g' {}
#find ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_FOL\.img/g' {}
#所有内核均已支持SFE，使用含SFE和FOL的固件进行打包
#find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"SF-openwrt/g' {}
#find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_FOL\+SFE\.img/g' {}

#旧内核新内核分开打包，修改前缀
#12以后内核无法使用SFE，使用仅含FOL的固件进行打包
#find ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"F-openwrt/g' {}
#find ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/TGT_IMG=\"\${WORK_DIR}\/openwrt/TGT_IMG=\"\${WORK_DIR}\/F-openwrt/g' {}
#旧内核支持SFE，使用含SFE和FOL的固件进行打包
#find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"SF-openwrt/g' {}
#find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/TGT_IMG=\"\${WORK_DIR}\/openwrt/TGT_IMG=\"\${WORK_DIR}\/SF-openwrt/g' {}

echo "mk_files respawned."
