<!--
title: 大数据日知录 - 内存KV数据库
date: 2017-01-16 21:36:18
tags:
- Big Data
-->
### 大数据日知录 - 内存KV数据库
Date: 2017-01-16 21:36:18

多个内存备份（高可用，高成本，简单）vs 单个内存备份（低成本）
## Redis
著名内存KV数据库。支持复杂类型。更强调读写性能和使用便捷性，高可用性一般。经常用作Cache.

唯一Master负责读写，多个Slave存储副本。Slave只读。Master在T时刻将数据写入快照文件，通知开始在内存记录新增的数据操作。快照生成后，传输给Slave, Slave将其加载入内存。


Master与Slave之间有时间差，Master故障时会导致数据丢失。

可以通过KeepAlived来将多台服务器IP映射为虚拟IP，由KeepAlived来进行故障。仍然存在异步导致的数据丢失问题。
<!-- more -->

## RAMCloud
只在内存中放一份原始数据，数据备份在外村中。

每台存储器包括一个Master和Backup。 Master负责内存，Backup负责外存。使用中心协调器记录集群信息以及存储对象是放在哪个服务器。

存储单位是子表。客户端存储字表与存储服务器的映射表。当客户端读取数据失败时，认为映射表失效，更新映射表。有效减少中心协调器压力。

数据备份采用了LSM Tree. Log被切换成8M大小的数据片段。崩溃时从Log恢复： 通过将数据备份分散恢复到多个服务器中来增加并发性。


## MemBase/CouchBase
高写操作性能，多个内存备份，高可用，成本较高。

通过虚拟桶对数据进行分片，映射到4K个桶中。在虚拟桶映射表中记录虚拟桶主数据与副本数据的机器地址。
![image](https://regmedia.co.uk/2012/12/13/couchbase_xdcr_diagram.jpg)

对虚拟桶表的更改通过两阶段协议来保证。所有服务器地位平等。所有读取由主服务器响应，写通过主服务区同步到所有备份。

