<!--
title: 大数据日知录 - 批处理系统
date: 2017-02-25 19:57:26
tags:
- Big Data
- MapReduce
- Hadoop
- DAG
-->
### 大数据日知录 - 批处理系统
Date: 2017-02-25 19:57:26

++ Map-Reduce框架:
Map-Reduce过程:
- Data Preparation (Splitting)
- Map (Mapper)
- Partition (Partitioner)
- Combine (Combiner)
- Merge
- Reduce (Reducer)

一些笔记参见[这里](https://zhuzhigao.github.io/2016/11/19/Hadoop/).

<!-- more-->
A sample.
![image](http://cdn.guru99.com/images/Big_Data/061114_0930_Introductio1.png)

一些具体的应用:
- 求和
- 过滤
- 数据分片(利用Partitioner)
- 全局排序(利用Partitioner)
- Join (Reduce-side Join, Map-side Join (仅当某表比较小时))

++ DAG计算框架
三层体系结构：
- 应用表达成，描述业务逻辑
- 执行引擎层，将业务逻辑描述转换和映射到具体任务和物理机
- 物理机集群

微软的Dryad是较早的DAG系统。有自己的DAG结构描述。Google的FlumeJava和Apache Tez也较为有名，底层使用改良的Map-Reduce框架.
