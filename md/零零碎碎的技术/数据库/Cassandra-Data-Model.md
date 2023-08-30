---
title: Cassandra Data Model
date: 2017-07-24 16:38:51
tags:
- Cassandra
- Big Data
---
Cassandra use Log-Structured Merge Tree (LSM) for data storage. Column Data Sort guaranteed by Memtable and SSTable (Sorted String Table).SSTable files of a column family are stored in its respective column family directory.

![image](https://image.slidesharecdn.com/cassandradatamodelingbestpractices-130513210233-phpapp02-130514120020-phpapp01/95/cassandra-data-modeling-best-practices-datastax-cassandra-south-bay-meetup-may-2013-8-638.jpg?cb=1368532875)

http://distributeddatastore.blogspot.hk/2013/08/cassandra-sstable-storage-format.html

Primary Key = (Partition Key, [Clusting Key]*)
Partition Key = Key | (Key*)

