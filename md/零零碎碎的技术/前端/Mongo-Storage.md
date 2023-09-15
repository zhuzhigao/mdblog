<!--
title: Mongo 存储结构
date: 2017-08-09 15:18:16
tags:
- MongoDB
-->
网上一篇挺好的[MongoDB存储结构的介绍](http://www.mongoing.com/blog/file-storage)，摘录一些重点。从文章来看，不像Cassandra, Mongo的存储的数据不是有序的，以B树存储的索引对提升查询效率必不可少。

## 数据库文件类型

MongoDB的数据库文件主要有3种：

- journal 日志文件
- namespace 表名文件
- data 数据及索引文件
<!-- more -->

**日志文件**

跟一些传统数据库不同，MongoDB的日志文件只是用来在系统出现宕机时候恢复尚未来得及同步到硬盘的内存数据。日志文件会存放在一个分开的目录下面。启动时候MongoDB会自动预先创建3个每个为1G的日志文件（初始为空）。除非你真的有持续海量数据并发写入，一般来说3个G已经足够。

**命名文件 dbname.ns**

这个文件用来存储整个数据库的集合以及索引的名字。这个文件不大，默认16M，可以存储24000个集合或者索引名以及那些集合和索引在数据文件中得具体位置。通过这个文件MongoDB可以知道从哪里去开始寻找或插入集合的数据或者索引数据。这个值可以通过参数调整至2G。

**数据文件 dbname.0, dbname.1,… dbname.n**

MongoDB的数据以及索引都存放在一个或者多个MongoDB数据文件里。第一个数据文件会以“数据库名.0”命名，如 my-db.0。这个文件默认大小是64M，在接近用完这个64M之前，MongoDB 会提前生成下一个数据文件如my-db.1。数据文件的大小会2倍递增。第二个数据文件的大小为128M，第三个为256M。一直到了2G以后就会停止，一直按这个2G这个大小增加新的文件。

Extent

在每一个数据文件内，MongoDB把所存储的BSON文档的数据和B树索引组织到逻辑容器“Extent”里面。如下图所示（my-db.1和my-db.2 是数据库的两个数据文件）：
![image](http://mongoing.com/wp-content/uploads/2014/07/f7a837a42e980ceb1323cd4cf0555cc3.png)
- 一个文件可以有多个Extent
- 每一个Extent只会包含一个集合的数据或者索引
- 同一个集合的数据或索引可以分布在多个Extent内。这几个Extent也可以分步于多个文件内
- 同一个Extent不会又有数据又有索引

## Record 记录

在每个Extent里面存放有多个”Record“, 每一个记录里包含一个记录头以及MongoDB的BSON文档，以及一些额外的padding空间。Padding是MongoDB在插入记录时额外分配一些未用空间，这样将来文档变大的时候不至于需要把文档迁移到别处。 记录头以整个记录的大小开始，包括该记录自己的位置以及前一个记录和后一个记录的位置。可以想象成一个Double Linked List。
![image](http://mongoing.com/wp-content/uploads/2014/07/3984a14b1c62b53d6d320643d2f667b5.png)


附另外一些不错的介绍。

- https://www.slideshare.net/mdirolf/inside-mongodb-the-internals-of-an-opensource-database

- https://www.slideshare.net/mongodb/mongodb-london-2013understanding-mongodb-storage-for-performance-and-data-safety-by-christian-kvalheim-10gen
