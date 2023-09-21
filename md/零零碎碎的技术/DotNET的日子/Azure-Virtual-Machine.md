<!--
title: Azure Virtual Machine!
date: 2016-11-29 20:15:24
tags: 
- Azure
- Ubuntu
- Shadowsocks
-->
### Azure Virtual Machine!
Date: 2016-11-29 20:15:24

昨天经同时提醒，发现Azure账户里每月有50$的余额，足够创一个虚拟机了，果断动手。

Azure虚拟机的创建还是很简单的, 20多刀每月的配置看上去还是很丰盛的.
- 30GB SSD
- 1.75GB Mem
- 1 Core
- Unlimited Network 

直接选了Ubuntu LTS 16.04 64Bit的模板, Prevision，就可以该是折腾了。

代理是必须的，跟随[同事的总结]( http://fresky.github.io/2015/12/19/setup-shadowsocks-on-azure/),几下搞定。试了下，速度杠杠的，从此不再需要梯子了。

本着物尽其用的原则，装上了.NET Core, Docker，接下来就可以完成我的Docker试验了。

黑乎乎的terminal界面不喜欢，咋整. 再次跟随[别人的脚步](https://www.linode.com/docs/applications/remote-desktop/install-vnc-on-ubuntu-16-04/)，虽然速度慢了点，不过至少比terminal强了。

大玩具已经准备好，我是不是该把自己的网站部署上去呢？这是个问题。
<!-- more -->
