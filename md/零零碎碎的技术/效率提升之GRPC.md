### 效率提升之GRPC

团队最近在推GRPC，想把这个作为内部服务之间交互的Default协议。相比于HTTP，GRPC基于HTTP/2，其优势网上有很多的文章，搜就是了。这里想结合我们自己的应用，来分享几个一处。

第一是交互效率的提升。相比于HTTP，HTTP/2多路复用，共享一个connection，减少了connection的创建，除了效率，也降低了系统的压力。至于更好的压缩，服务器推送等高级功能，我们倒是关注不多，深入挖掘或许可以有更多惊喜。

第二是自主控制力的提升。连接数的服用让我们比较容易的开发了GRPC的客户端，内嵌了4层负载均衡。负载均衡算法并不复杂，roundrobin, 但是避免了我们需要加一个中间Load Balancer层。对于连接，我们有足够的控制力，后续也会进一步优化。通过全链路上做了打点和监控，对交互的状态也有了全面的认知和把控。

第三是成本的优化，没有了Load Blancer，减少了大量的类似于AWS NLB之类的Cost。在我们超高并发的场景下，这个生下来的钱不可小觑。

当然，想要用GRPC得到好的效果，前期的投入是比较大的。且不说各种调研，开发的成本，光是服务的适配就花了很大的功夫。多路复用带来的一些挑战，比如信息传递的优先级，连接失效的快速failover等等，也依然存在，只是在我们的场景下不是那么严重。总的来说，很好的技术探索，效果也很不错。
