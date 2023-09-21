<!--
title: 大数据日知录 - 数据通道
date: 2017-01-05 18:09:00
tags:
- Big Data
-->
### 大数据日知录 - 数据通道
Date: 2017-01-05 18:09:00
## Log数据收集系统
- 低延迟，但不要求实时
- 高扩展
- 容错性
<!-- more -->
 
### Chukwa
基于Hadoop的Log分析与收集系统。通过MR对Log数据进行提取成为结构化或者半结构化的数据。MR部分是瓶颈。
![image](https://chukwa.apache.org/docs/r0.5.0/images/chukwa_architecture.png)
### Scribe
Facebook的开源分布式日志收集系统。通过Thrift

## 数据总线
LAMP (Linux, Apache, MySQL, PHP).
数据总线的作用是能够形成数据变化的通知通道。
- 近实时性
- 数据回溯能力，支持获取从指定时刻的数据变化情况。
- 主题订阅能力

两种实现方式，比较常见的是数据日志挖掘
- 双写：同时写DB(实时)和MessageQueue(接近实时)
- 数据库日志挖掘。数据更新先写入数据库，数据总线挖掘数据变化信息，并通知各个应用。

![image](http://images.cnitblog.com/blog/312753/201303/05181646-d47c2acb5fe84a5985f5bd79caad4d95.png)
### LinkedIn Databus
使用中继器(Ralay)加快数据通知。中继器监控DB数据变化，并存储在环状buffer中，buffer中的旧变化会缓存到Bootstrap中。如果客户处理较慢(pull模式)，数据变化已经不在buffer，可以继续从Bootstrap中获取。Bootstrap trace数据变化，为数据总线服务，它本身并不是主数据存储。
![image](http://cdn.infoqstatic.com/statics_s2_20170104-0355/resource/news/2013/03/linkedin-databus/zh/resources/databus-as-a-service.png)

### Wormhole
Facebook的消息队列，采用pub-sub架构，支持数据分片。

## 数据导出
Sqoop:数据导入导出系统，支持SQL/NOSQL.
