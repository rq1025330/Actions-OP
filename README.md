# Actions-OpenWrt

+ 使用GitHub Actions 构建 OpenWrt 镜像 [P3TERX大佬的中文教程](https://p3terx.com/archives/build-openwrt-with-github-actions.html)

+ 感谢 ***HoldOnBro***、***P3TERX*** 和 ***flippy***

## How to Use
+ 你需要添加4个（至少第一个）secrets 才能使 Actions 正常工作

+ **RELEASES_TOKEN** 这是你 Github 的 **Personal Access Token** 至少选择 *public_repo*

+  **Telegram notify secrets** (可选，但记得在 ymls 中注释掉相关 action )， **TELEGRAM_TOKEN** 你的 bot token 和 **TELEGRAM_TO** 你的个人 id [点击查看更多信息](https://github.com/marketplace/actions/telegram-notify)

## Some Hints

### NetData
+ 如果 NetData 不能正常工作，以N1为例:

+ SSH 进入容器并运行命令 :``chown -R root:root /usr/share/netdata/``

+ 然后刷新``IP:19999``，它应该可以正常工作
  
### IP and Password
+ 默认 IP 为``192.168.123.1``
  
+ 默认密码为``password``

## Luci插件或脚本命令操作方法
    在系统——晶晨宝盒——在线下载更新——插件更新,（更新固件/内核,备份恢复配置,快照管理等脚本）
      
    ssh中使用命令操作,方法如下：
    安装openwrt命令：
    1.amlogic s9xxx 系列盒子安装命令：openwrt-install-amlogic
          
    更新openwrt命令：
    1.先上传盒子对应的openwrt固件、openwrt-update-*到/mnt/mmcblk*p4/目录下,支持直接上传并使用压缩文件
    格式支持：img / .img.gz / img.xz / .7z / .zip
    2. amlogic s9xxx 系列盒子更新命令：openwrt-update-amlogic
    3. Chainedbox L1Pro和BeikeYun盒子更新命令：openwrt-update-rockchip
    4.v-plus盒子更新命令：openwrt-update-allwinner
          
    更新内核命令：
    1.先上传盒子对应的相关内核的3个文件到/mnt/mmcblk*p4/目录下
    2.更新命令：openwrt-kernel
          
    备份/恢复配置，快照管理命令：flippy 或 openwrt-backup 根据菜单提示选择相关操作