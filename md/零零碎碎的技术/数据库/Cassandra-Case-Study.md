<!--
title: 一次（失败的）Cassandra数据读取异常的排错
date: 2017-09-06 14:12:54
tags:
- Cassandra
-->
### 一次（失败的）Cassandra数据读取异常的排错
Date: 2017-09-06 14:12:54

前两天公司的某个数据服务出现了很多Server Internal Error和反馈时间过长的问题，特别是在load比较大的时候频繁出现。花了一些时间调查，有些还是值得记一笔的。

数据服务本身Host在Windows Azure Service Fabric上，有多个实例，后台用的数据库是Cassandra，也是部署在Azure上的VM. 从ELK的日志来看，大量的Internal Error是因为"Cassandra timeout exception: Cassandra.ReadTimeoutException: Cassandra timeout during read query at consistency..."。显然, Cassandra在表示抗议了。

<!-- More-->

最近更新：事实证明上次的现象没有错，但是解决方案并没有解决问题。Cassandra在环境中表现的非常不稳定，误以为方案工作，结果被打脸了:-(.

Debug了下Cassandra的驱动，确定了是服务器端而不是客户端的问题。比较迷茫，目前有一些可能的方案，需要一一验证。。。
- 数据平衡，避免过大的partition.
- 避免使用limit.降低预编译cache
- 使用静态列保存uri等静态信息。减少列字段长度
- 根据查询方式定义存储结构
- 不使用过大的java heap
- disable tracing
- 关闭不需要的功能，如支持大数据分析个与文件存储功能

==================================================================================================

上去查看Cassandra的状态，貌似还不错。

$nodetool tablestats XXXXXX
Keyspace : XXXXXX
- Read Count: ......
- Read Latency: 0.8011925441485689 ms.
- Write Count: ......
- Write Latency: 0.033835041368079764 ms.

各种内存, CPU, Cache的使用也还算靠谱，貌似Cassandra自己还是比较Happy的。

客户端连接不畅导致的Timeout？用DevCenter在本地机上跑跑CQL看看。流畅，查询的速度哗哗的，秒级搞定。

这个就有点奇怪了，为啥在数据服务在某些情况下查询效率这么低？


好吧，写测试代码，重现下数据服务的情况。把服务搞成命令行，使用一模一样的数据访问代码。慢，果然慢，一个查询花了我100秒。

CQL基本一样的啊，凭啥DevCenter这么快？仔细一瞅，果然不一样。 DevCenter最大的Limit是1000，也就是每次最多1000行，而数据服务的代码好几十个1000. 难不成是因为数据占用了太多时间了？

好吧，改代码，改用CQL访问数据，把CQL执行跟数据获取分开CQL的执行花了不到2秒(跟DevCenter接近)，看来问题在数据传输上。DevCenter它返回了1000行这么快，我也只返回一千行呢？不出意料，我也快。查看了Available Rows，原来查询完成过后Available Rows只有一个Page, 而default page size是5000。也就是说即使我要了好多数据，实际上准备好的只有5000（还没到客户端。。。），获取剩余的数据，我还要跟Cassandra聊好多次。尝试把数据一页一页的那会来，一脑袋包，花了80多秒(感谢破网络把问题放大了，实际上数据服务和Cassandra在同一个Azure DataCenter，估计还一下看不出来这么慢)。

Good, 效率低的问题貌似有眉目了。接下来就是想办法看看咋提升数据传输效率了。无非就是减少不必要的数据，增加带宽，改善Cassandra与数据服务之间以及Cassandra节点之间（因为每次查询通常需要经过多个节点，除非PartitionKey刚好把数据分到一个节点，并且这个节点还是当次查询的协调节点）的部署拓扑。。。说着容易，做起来就未必了:-).

不过事情还没完，Timout的原因还是没有找到。在验证的过程中多次出现了效率低的问题，但是绝大多数查询都能够完成，尽管很慢。的确在请求量大的时候（比如用10个进程通过是跑10个大数据查询）有可能出现异常: HostNoResponse，但是这个跟ELK里面的ReadTimeOut是不一样的，尽管背后的原因可能都是服务器太忙了。

换种思路，我真的重现了某个数据服务接口的运行时行为吗？假设多个客户同时向数据服务请求出具，单个数据服务可能同时收到多个Web Request，对于单个Web Request的处理，都会跑一次Cassandra数据查询；同时每个WebRequest会被独立的线程处理。换言之，当多个Request同时来的时候，在一个数据服务实例中，会有多个线程在同时进行Cassandra查询。OK，改代码，每个进程内部同时跑10个线程，每个线程都进行一次大数据量的Cassandra查询。Bingo, 只需要一个进程，ReadTimeOut Exceptiton!

Timeout的问题重现了，但是原因是什么，为什么同样10次查询你在不同进程里就不出现Timoout Exception，同一个进程内部就出现？再次回到代码。原来在一个进程内部，所有的查询都是用了同一个Cassandra Session （单例），也就是所有的查询都会通过这一个长连接。在这个长链接中，如果某个查询的耗时过长（主要是数据传输的时间，会占据这个长连接），其他查询急不可耐就直接报告TimeOut了。

这个问题解决起来相对比较棘手。一个思路是减少每次查询的数据量，保证单个查询能够较快完成，其他查询能较快得到响应。另外一个思路就是限制同时进行的查询的个数（同时测试，同时跑3个查询Timeout Exception的概率很低），或者使用一个队列对多有查询排序，顺序处理。使用多个Cassandra Session或许也可行，但是长时间保持多个长连接对Cassandra服务器可能是个负担。前面提到的减少数据传输量也肯定能加快查询时间，减少异常。买买买（更多的服务器和带宽）当然也会有所帮助，不过老板们的银子也是银子啊。前面提到的Cassandra服务器的改进的手段，比如改善PartitionKey和Clustering，让数据分布更均匀，更适合特定的查询；改善部署，增加带宽等等，对这个问题也会有所帮助。
