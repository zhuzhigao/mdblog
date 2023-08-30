---
title: 大数据日知录 - 算法与数据结构 - 2
date: 2016-12-23 13:18:05
tags:
- Big Data
- Algorithm
- Data Structure
---
## Merkle Hash Tree
主要用来在海联不过数据下快速确定啥流量变化的数据内容，应用如比特币，BitTorrent等。
![image](http://images2015.cnblogs.com/blog/834896/201605/834896-20160527163537178-321412097.png)
<!-- more -->
叶子节点是数据项的哈希值，父节点是子节点哈希值的哈希值，一直到根。底层某个数据变化时，变化会一直传递到根。

在Dynamo中用来进行数据同步。比特币中用来进行交易验证。

Merkle Tree 的明显的一个好处是可以单独拿出一个分支来（作为一个小树）对部分数据进行校验。

## Cuckoo哈希
有效解y决哈希冲突。o(1)查找和删除，常数时间插入，50%左右的空间利用率。

使用两个不同的哈希桶 h1(x), h2(x). 如果任意一个桶为空，将x放入，不然选择一个桶，将原值y踢出去。对y重复这个过程。设最大次数防止死循环.

Cuckoo哈希省去了哈希冲突的解决过程。

常见变体， 增加哈希个数或者每个桶可存放的值的个数。

## SILT (Single Index Large Table) and Partially Cuckoo
To solve this costly displacement problem, our partial-key cuckoo hashing algorithm stores the index of the alternative bucket as the
 lash reads for non-existent key loo alternative bucket index to perform cuckoo displacement without any flash reads. For example, if a key x is assigned to bucket h1(x), the other hash value h2(x) will become its tag stored in bucket h1(x), and vice versa (see Figure 3). Therefore, when a key is displaced from the bucket a, SILT reads the tag (value: b) at this bucket, and
moves the key to the bucket b without needing to read from flash. Then it sets the tag at the bucket b to value a.

Note even there are two possible buckets, only one bucket is used which stores the hash index in another bucket.