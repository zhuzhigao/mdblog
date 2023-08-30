---
title: 大数据日知录 - 流式计算
date: 2017-02-27 20:41:28
tags:
- Big Data
- Stream Processing
- Storm
---
流式计算满足高计算时效性，高性能，低延迟，高扩展。

流式计算系统架构分为两种，主从模式和P2P模式。

Twitter的Storm使用主从模式。
![image](http://openbus.readthedocs.io/en/latest/_images/DiagramStorm.png)

<!-- more -->

Nimbus分发任务，Supervisor负责DAG计算任务。ZooKeeper保存状态信息，Nimbus和Supervisor无状态。

流式计算的拓扑结构都是由计算节点和流式数据构成的DAG有向无环图。DAG中的节点一般完成计算任务所需要的处理功能，如过滤，数据累加等。
![image](http://www.ibm.com/developerworks/library/os-twitterstorm/figure1.gif)

输入节点(Spout)，计算节点(Bolt). 实现特定的API就可以完成计算节点的处理逻辑。数据一般为KV+TimeStamp.

拓扑结构
- 流水线
- 乱序分组，随机分发到下游节点
- 定向分组，根据特定属性的哈希分配到下游节点
- 广播模式，向所有下游节点分发一次

送达保证
- 至少送达一次
- 至多送达一次
- 恰好送达一次，很多情况下是必须的要求。

Storm提供恰好送达一次，通过送达保证机制和事务拓扑联合完成。 XOR, XOR, XOR...每个数据的ID在上游被XOR一次，在下游处理完后再XOR一次，最后为0代表处理结束。如果处理失败, XOR结果不为零。Storm采用全局表记录数据的XOR处理结果，处理完毕的定期清理。 

容错的三种方式: 
- 备用服务，易丢失状态，不适合有状态的计算节点
- 热备，消耗额外硬件资源
- 检查点，大多数系统使用，必须平衡检查点备份频率

状态持久化。Storm通过将数据封装成批数据，每批数据绑定一个增长的事务ID，如果事务成功结束，各计算节点备份数据。所有数据按照顺序通过并行流水线处理。




