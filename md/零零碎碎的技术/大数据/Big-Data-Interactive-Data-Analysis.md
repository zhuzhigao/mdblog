---
title: 大数据日知录 - 交互式数据分析与数据仓库
date: 2017-03-08 20:54:24
tags:
- Big Data
- Data Warehouse
- Hive
---
交互式数据分析的几大类型：
- Hive系. Sql-on-Hadoop.
- Shark系, Spark上的数据仓库系统
- Dremel系, 加入了并行数据库的思想
- 混合系. Hadoop + 关系数据库

<!-- more -->

++ Hive系
Hadoop上的数据仓库解决方案。为Hadoop的存储数据增加Schema，并且支持类SQL的查询语言，SQL会转换为一系列MR任务。效率较低，主要是因为MR的特性导致。

Hive数据为层级结构DB->Table->Partition->Bucket. 每个Table在HDFS的一个目录下，Partition将数据分片，放在子目录总， Bucket是文件，存放根据某列值哈希而来的数据。
创建时可以指定PartitionBy. SerDe接口可以定制数据的序列化。
![image](https://cdn.edureka.co/blog/wp-content/uploads/2016/12/Hive-Partitions-Buckets-Hive-Tutorial-Edureka.png)

HiveQL编译成MR任务构成的DAG图，并进行了优化：
- 列过滤，只取相关的列
- 数据分片过滤，只筛选谓词相关的数据
- 谓词下推， 在数据扫描是尽量过滤数据。
- Map Join，特别是内存Join

Hive效率较低的原因有：中间结果持久化到内存，　MR任务的同步，MR任务的启动开销等。

++ Shark系
基于Spark，比较适合迭代式机器学习。兼容Hive. 
效率提升的原因：
- 基于内存的列簇式存储
- 部分DAG执行引擎，本质上是对查询的动态优化，动态收据数据和中间结果的信息，动态改写DAG.
- 数据共同分片，需要进行Join操作的列尽量把相同的Key的数据放到一台机器上，减少Shuffle的开销。


++ Dremel系
Google的超大规模数据分析系统，性能高。
- 多级服务树，通常为三级。每一级改写上层过来的查询，并传到下一级，指导叶节点。数据返回后，在每层进行局部聚合，最终在根服务器返回结果。
![image](http://attachbak.dataguru.cn/attachments/forum/201208/24/093455hf0qh4o0yle31ldd.jpg)
- 使用类似MPP并行数据库的方式对存储在磁盘中的任务进行处理，不使用MR.
- 嵌套的行列式混合存储.


++ 混合型数据仓库
HadoopDB.SQL转换为MR任务， 关系数据库执行SQL语句并将结果以KV形式返回做后续处理。尽量改写SQL让更多的任务可以在关系数据库中执行。因为MR任务的存在，性能一般。


