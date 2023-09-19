<!--
title: 大数据日知录 - 列式数据库 - BigTable
date: 2017-02-16 07:24:03
tags:
- Big Data
- BigTable
-->
### 大数据日知录 - 列式数据库 - BigTable
Date: 2017-02-16 07:24:03

列式数据库兼具传统数据库与NoSQL的特点，在数据表达能力上强于KV数据库。
- 分布式部署
- TB级别数据支持
- 低读写延迟
- 类SQL操作
- 分布式事务
<!-- more -->
## BigTable
海量数据的结构化或者半结构化存储，基于GFS.

行主键，列主键，时间（版本）三维定位存储单元。

BigTable将相邻的行主键组成的若干个行数据作为存储单元，称为子表，表格由子表组成，子表由子表服务器管理。一个子表由多个SSTable组成。
![image](https://www.researchgate.net/profile/Rabi_Padhy/publication/265062016/figure/fig2/AS:295840460623875@1447545270890/Figure-5-Google-BigTable-Architecture-BigTable-has-three-different-types-of-servers.png)

三级查询
![image](https://kradnangel.gitbooks.io/operating-system/content/Tablet%20location%20hierarchy.png)

主控服务器利用Chubby管理子表服务器，子表服务器管理和存储子表数据。

子表服务器使用LSM树管理数据. MemTable->SSTable.一个字比较数据由多个从MemTable生成的SSTable构成。CommitLog用于Down机时的数据恢复。MemTable和SSTable按照行主键排序。使用块索引和布隆过滤器来加快读取速度。 SSTable会定期合并。

数据更新：先删除再插入新的？

Apache HBase可以认为是BigTable的开源版本。

Ref: [http://www.jianshu.com/p/a42dbbdf9706](http://www.jianshu.com/p/a42dbbdf9706)
