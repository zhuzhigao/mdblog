<!--
title: 大数据日知录 - 分布式文件系统 - 1
date: 2017-01-11 17:53:45
tags:
- Big Data
- GFS
- HDFS
-->
### 大数据日知录 - 分布式文件系统 - 1
Date: 2017-01-11 17:53:45
## GFS
特点：采用PC存储，大文件，大量追加写，顺序读为主。

三个组成部分:
- 唯一主控服务器，管理
- 众多的Chunk服务器，存储与响应读写
- GFS客户端

通常Chunk大小是64MB,每根文件由若干个相同大小的chunk组成，每个chunk被分割成多个block，每次读取至少是一个block. 
<!-- more -->

GFS使用树形结构的GFS命名空间。
![image](http://redundancy-and-recovery-saas.wikispaces.asu.edu/file/view/gfs.png/282503792/gfs.png)

### 主控服务器
主控服务器管理一下信息。前两类信息写在日志中。
- GFS命名空间
- 文件到Chunk的对应
- Chunk的分布信息。

主控服务器同时负责负载均和和文件迁移等。主控节点容易成为瓶颈和导致单点失效。每个主控服务器有一个影子服务器（非热备份）。


每个Chunck有3个备份，一个主备份，两个次级备份。写入时客户端先将数据推入到所欲备份的缓存，所有备份推送成果后，通知主备份写入，主备份通知次级备份写入并接收写入完成消息，所有备份写入完毕，通知客户端写入成功。

Colossus是下一代GFS，使用多主控服务器，使用纠删码来减少备份，客户端可以管理备份数据存储地点。

## HDFS
与GFS类似，适合大文件，顺序读写。
![image](https://hadoop.apache.org/docs/r1.2.1/images/hdfsarchitecture.gif)
- NameNode: 主控服务器
- DataNode: Chunk服务器
 
NameNode记录fsimage(文件结构内存镜像)与editlog，可以重建内容文件结构。 Secondary NameNode会定期拉取fsimage与editlog，合并并返回给NameNode。相当于checkpoint服务器。

HDFS支持多个客户的并发追加写，GFS不支持。

HA方案：Hadoop 2.0提出了NameNode热备份Secondary NameNode. 需要随之保证只有一个NN能写入和删除数据副本。

### NameNode联盟
单一NN扩展性，性能和隔离性差。Hadoop 2.0引入NameNode联盟。将一个大的命名空间切割成多个子命名空间，每个子空间由一个NN负责。多有DataNode被NN共享。
