#!/bin/bash

cd /opt/openwrt_packit
cp make.env makeplus.env
cp make.env makeplusplus.env
#cp make.env makeplusplusplus.env

#sync the kernel version
KV=$(find /opt/kernel/ -name "boot*+o.tar.gz" | awk -F '[-.]' '{print $2"."$3"."$4"-"$5"-"$6}')
KPV=$(find /opt/kernel/ -name "boot*5\.10*+.tar.gz" | awk -F '[-.]' '{print $2"."$3"."$4"-"$5"-"$6}')
KPPV=$(find /opt/kernel/ -name "boot*5\.15*+.tar.gz" | awk -F '[-.]' '{print $2"."$3"."$4"-"$5"-"$6}')
#KPPPV=$(find /opt/kernel/ -name "boot*5\.16*+.tar.gz" | awk -F '[-.]' '{print $2"."$3"."$4"-"$5"-"$6}')
sed -i "s/^    KERNEL_VERSION.*/KERNEL_VERSION=\"$KV\"/" make.env
sed -i "s/^    KERNEL_VERSION.*/KERNEL_VERSION=\"$KPV\"/" makeplus.env
sed -i "s/^    KERNEL_VERSION.*/KERNEL_VERSION=\"$KPPV\"/" makeplusplus.env
#sed -i "s/^    KERNEL_VERSION.*/KERNEL_VERSION=\"$KPPPV\"/" makeplusplusplus.env

#修改默认DTB文件，分隔符 "/" 替换成 "?"
sed -i 's?FDT=/dtb/amlogic/meson-sm1-x96-max-plus-100m.dtb?#FDT=/dtb/amlogic/meson-sm1-x96-max-plus-100m.dtb?g' mk_s905x3_multi.sh
sed -i 's?#FDT=/dtb/amlogic/meson-sm1-hk1box-vontar-x3.dtb?FDT=/dtb/amlogic/meson-sm1-hk1box-vontar-x3.dtb?g' mk_s905x3_multi.sh

#for F in *.sh ; do cp $F ${F%.sh}_basic.sh && cp $F ${F%.sh}_plus.sh && cp $F ${F%.sh}_plusplus.sh && cp $F ${F%.sh}_plusplusplus.sh;done
for F in *.sh ; do cp $F ${F%.sh}_basic.sh && cp $F ${F%.sh}_plus.sh && cp $F ${F%.sh}_plusplus.sh;done
find ./* -maxdepth 1 -path "*_plus.sh" | xargs -i sed -i 's/make\.env/makeplus\.env/g' {}
find ./* -maxdepth 1 -path "*_plusplus.sh" | xargs -i sed -i 's/make\.env/makeplusplus\.env/g' {}
#find ./* -maxdepth 1 -path "*_plusplusplus.sh" | xargs -i sed -i 's/make\.env/makeplusplusplus\.env/g' {}

#统一用Full打包
find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"Full-openwrt/g' {}
find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_Full\.img/g' {}

#find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh ./*_plusplusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"Full-openwrt/g' {}
#find ./*_basic.sh ./*_plus.sh ./*_plusplus.sh ./*_plusplusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_Full\.img/g' {}

#旧内核新内核分开打包
#12以后内核无法使用SFE，使用仅含FOL的固件进行打包
#find ./*_plusplus.sh ./*_plusplusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"F-openwrt/g' {}
#find ./*_plusplus.sh ./*_plusplusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_F\.img/g' {}
#旧内核支持SFE，使用含SFE和FOL的固件进行打包
#find ./*_basic.sh ./*_plus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"SF-openwrt/g' {}
#find ./*_basic.sh ./*_plus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_F\+SF\.img/g' {}

#修改后缀
#旧内核新内核分开打包
#12以后内核无法使用SFE，使用仅含FOL的固件进行打包
#find ./*_plusplus.sh ./*_plusplusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"F-openwrt/g' {}
#find ./*_plusplus.sh ./*_plusplusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_FOL\.img/g' {}
#旧内核支持SFE，使用含SFE和FOL的固件进行打包
#find ./*_basic.sh ./*_plus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"SF-openwrt/g' {}
#find ./*_basic.sh ./*_plus.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_FOL\+SFE\.img/g' {}
#用Full打包
#find ./mk_s905d_n1.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"Full-openwrt/g' {}
#find ./mk_s905d_n1.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_FOL\+SFE-Full\.img/g' {}
#find ./mk_s905x3_multi.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"Full-openwrt/g' {}
#find ./mk_s905x3_multi.sh -maxdepth 1 -path "*" | xargs -i sed -i '/^TGT_IMG.*img\"$/s/\.img/\_FOL\+SFE-Full\.img/g' {}

#修改前缀
#旧内核新内核分开打包
#12以后内核无法使用SFE，使用仅含FOL的固件进行打包
#find ./*_plusplus.sh ./*_plusplusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"F-openwrt/g' {}
#find ./*_plusplus.sh ./*_plusplusplus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/TGT_IMG=\"\${WORK_DIR}\/openwrt/TGT_IMG=\"\${WORK_DIR}\/F-openwrt/g' {}
#旧内核支持SFE，使用含SFE和FOL的固件进行打包
#find ./*_basic.sh ./*_plus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"SF-openwrt/g' {}
#find ./*_basic.sh ./*_plus.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/TGT_IMG=\"\${WORK_DIR}\/openwrt/TGT_IMG=\"\${WORK_DIR}\/SF-openwrt/g' {}
#用Full打包
#find ./mk_s905d_n1.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"Full-openwrt/g' {}
#find ./mk_s905d_n1.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/TGT_IMG=\"\${WORK_DIR}\/openwrt/TGT_IMG=\"\${WORK_DIR}\/Full-openwrt/g' {}
#find ./mk_s905x3_multi.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/OP_ROOT_TGZ=\"openwrt/OP_ROOT_TGZ=\"Full-openwrt/g' {}
#find ./mk_s905x3_multi.sh -maxdepth 1 -path "*" | xargs -i sed -i 's/TGT_IMG=\"\${WORK_DIR}\/openwrt/TGT_IMG=\"\${WORK_DIR}\/Full-openwrt/g' {}

#sudo ./mk_rk3328_beikeyun.sh
#sudo ./mk_rk3328_beikeyun_basic.sh
#sudo ./mk_rk3328_beikeyun_plus.sh
#sudo ./mk_rk3328_beikeyun_plusplus.sh
#sudo ./mk_rk3328_beikeyun_plusplusplus.sh
#sudo ./mk_rk3328_l1pro.sh
#sudo ./mk_rk3328_l1pro_basic.sh
#sudo ./mk_rk3328_l1pro_plus.sh
#sudo ./mk_rk3328_l1pro_plusplus.sh
#sudo ./mk_rk3328_l1pro_plusplusplus.sh
#sudo ./mk_s905d_n1.sh
#sudo ./mk_s905d_n1_basic.sh
#sudo ./mk_s905d_n1_plus.sh
#sudo ./mk_s905d_n1_plusplus.sh
#sudo ./mk_s905d_n1_plusplusplus.sh
#sudo ./mk_s905x2_x96max.sh
#sudo ./mk_s905x2_x96max_basic.sh
#sudo ./mk_s905x2_x96max_plus.sh
#sudo ./mk_s905x2_x96max_plusplus.sh
#sudo ./mk_s905x2_x96max_plusplusplus.sh
#sudo ./mk_s905x3_multi.sh
#sudo ./mk_s905x3_multi_basic.sh
#sudo ./mk_s905x3_multi_plus.sh
#sudo ./mk_s905x3_multi_plusplus.sh
#sudo ./mk_s905x3_multi_plusplusplus.sh
#sudo ./mk_s912_zyxq.sh
#sudo ./mk_s912_zyxq_basic.sh
#sudo ./mk_s912_zyxq_plus.sh
#sudo ./mk_s912_zyxq_plusplus.sh
#sudo ./mk_s912_zyxq_plusplusplus.sh
#sudo ./mk_s922x_gtking.sh
#sudo ./mk_s922x_gtking_basic.sh
#sudo ./mk_s922x_gtking_plus.sh
#sudo ./mk_s922x_gtking_plusplus.sh
#sudo ./mk_h6_vplus.sh
#sudo ./mk_h6_vplus_basic.sh
#sudo ./mk_h6_vplus_plus.sh
#sudo ./mk_h6_vplus_plusplus.sh
#sudo ./mk_h6_vplus_plusplusplus.sh


echo "mk_files respawned."
