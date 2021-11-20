# Actions-OpenWrt

使用GitHub Actions 构建 OpenWrt 镜像 （注：此仓库FOK于 [HoldOnBro大佬](https://github.com/HoldOnBro/Actions-OpenWrt)）[P3TERX大佬的中文教程](https://p3terx.com/archives/build-openwrt-with-github-actions.html)

感谢 ***HoldOnBro***、***P3TERX*** 和 ***flippy***，这只是他们工作的结合。

发布的固件适用于S9xxx设备、amd64设备。

## How to Use
你需要添加5个（至少第一个）secrets 才能使 Actions 正常工作。

1. **RELEASES_TOKEN** ，这是你 Github 的 **Personal Access Token** 至少选择 *public_repo* 。
2. **DOCKER_USERNAME** (可选，如果您不需要 aarch64 docker img)是你的 dockerhub 用户名.
3. **DOCKER_PASSWORD** (可选，如果您不需要 aarch64 docker img)，这实际上不是你 dockerhub 帐户的密码，而是从 dockerhub 帐户设置生成的 **Access Token** 。
4. **Telegram notify secrets** (可选，但记得在 ymls 中注释掉相关 action )， **TELEGRAM_TOKEN** 你的 bot token 和 **TELEGRAM_TO** 你的个人 id。[点击查看更多信息](https://github.com/marketplace/actions/telegram-notify)

## Some Hints

### NetData
  如果 NetData 不能正常工作，以N1为例:

  SSH 进入容器并运行命令 :``chown -R root:root /usr/share/netdata/``

  然后刷新``IP:19999``，它应该可以正常工作了。
  
### IP and Password
  这些设备的默认 IP 可以在与它们关联的 ymls 中找到。
  
  默认密码为``password``。
  
### aarch64
这些arch有三个版本的固件。
  
命名没有前缀的不包含 Acc 应用程序。
  
名为 ``SF-*`` 是SFE和FOL类型，内核版本为``5.4.*``、``5.10.*``。
  
名为 ``F-*`` 是FOL型，内核版本为``5.13.*``。
  
如果您喜欢稳定，请选择 ``SF-*`` 类型。