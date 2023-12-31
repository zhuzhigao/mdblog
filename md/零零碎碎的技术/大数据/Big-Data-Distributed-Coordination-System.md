<!--
title: 分布式协调系统
date: 2016-12-28 20:43:50
tags:
- Big Data
- Chubby
- ZooKeeper
-->
### 分布式协调系统
Date: 2016-12-28 20:43:50
## Chubby
分布式系统的粗粒度锁服务。让众多客户间相互同步，并对系统唤醒或者资源达成一致。粗粒度指锁存在时间比较长。

### 系统架构
一个数据中心一个Chubby单元，含5台服务器，一台主服务器与四台内存与主服务器一致的备份服务器。主控服务器间隔几秒选举产生。读写都由主控服务器负责。

![image](http://www.habadog.com/wp-content/uploads/2011/06/chubby.jpg)

<!-- more -->

### 数据模型
Chubby本质上是一个分布式文件系统，存储大量小文件。每个文件就代表一个锁，并且可以保存一些 应用层面的小规模数据。用户通过打开、关闭、读取文件来获取共享锁或者独占锁；并通过通信机制，向用户发送更新信息。主要存储一些管理信息和基础数据。树形目录结构提供了很多管理功能，比如对文件加锁。

Chubby Master与 client通过周期性握手定时(keep alive消息)维系会话。

客户端缓存部分数据，主控服务器记录那些数据被缓存。当跟新数据时，主控服务器先将客户端数据无效。

每几个小树Chubby单元备份自己的内存快照。

## ZooKeeper
可扩展高吞吐分布式协调系统，得到广泛应用。

### 架构
由若干台服务器组成，每个服务器维护相同的类似文件系统的树形数据结构。一台为主控服务器，其他作为从属服务器。客户端可以连接任意一台服务器。如果读，可以由任意一台服务器响应，如果写，只能由主控服务器更新，从属服务器将更新请求转发到主服务器。

![image](http://img.blog.csdn.net/20160421085006204)
- 每个Server 在内存中存储了一份数据。
- ZooKeeper 启动时，将从实例中选举一个leader
- Leader 负责处理数据更新等操作
- 一个更新操作成功的标志是当且仅当大多数Server在内存中成功修改数据。

ZooKeeper保证最终一致性，期间可能会有数据不一致。可以通过调用Sync函数强制让从属服务器从主服务器更新数据。每次请求都会给客户一个zxid编号，如果服务器切换，zookeeper保证客户从新服务器请求到的数据版本不比之前客户看到的低（每次请求带上zxid).

ZooKeeper通过重放日志 + 模糊快照（快照写出时不加锁）对服务器故障进行容错。

### 数据模型
ZooKeeper包含持久节点（需要显式删除）或临时节点（绘画解说或故障时自动清除）。客户端可以检测节点内容变化。

### 应用
#### 领导者选举
将某临时ZNode设置为领导者专用节点，存储领导者地址等辅助信息。每个进程读取内容并设置观察标志，如果读取成功，说明有邻导者，如果失败，则试图在领导者专用节点中写入自己信息，写入成功则成为领导者，并通过观察标志通知其他进程。如果领导者失效，ZNode会被删除，剩余进程得到通知后继续选举。

#### 配置管理
配置文件存储在某个znode中，客户端进程设置观察标记。如果配置被改，所有客户端得到更新
![image](http://img.blog.csdn.net/20160421094844961)

#### 组成员管理
动态监控组成员变化。使用一个节点来进行组成员管理，其下的子节点为组成员，某个组成员的变化反映在子节点上，其他节点都通过观察标志得到更新。
![image](http://img.blog.csdn.net/20160421095301115)


#### 任务分配
所有任务都在Tasks管理节点下创建子节点。监控进程观察Tasks管理节点的变化。同时有Machines机器节点代表所有机器，每个机器是一个子节点。如果任务分配给某个机器，在该机器节点下创建任务子节点，则机器得到通知并开始执行。执行完后，将机器节点和任务节点下的任务子节点删除。监控进程通过监听Machines机器节点和Tasks任务节点得到任务和机器的状况。

#### 锁管理
每个锁请求在锁节点下创建子节点，每个子节点带一个自增的序列号。每个锁请求客户查看剩余节点状态，如果自己的节点是序号最小的节点，则得到锁。释放锁删除节点即可。

#### 双向路障同步
某个节点用来作为路障。每个进程在路障节点下创建子节点表示自己已经达到同步点。如果要同步进程开始时间，就查看子节点个数是否到达同步阈值。如果要同步进程结束时间，则删除子节点，当没有子节点剩余时，表示所有进程已准备好离开。








