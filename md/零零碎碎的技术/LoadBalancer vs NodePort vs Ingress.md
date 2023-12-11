### LoadBalancer vs NodePort vs Ingress

Date: 12/11/2023

这两天在琢磨能否摒弃NLB而在AWS上采用自建LB的方式(比如MetalLB)来节省cost。期间忽然想到一个问题，通过nodeport也可以把服务暴露出去啊，Ingress也可以做类似load balance的功能，如果Ingress + NodePort是不是就可达到目的了呢。于是思考了下各自不同的定位，记录一下，未必非常正确。

LoadBalancer: LB如其名字，就是用来做服务之间的负载均衡的，保证压力在不同的服务节点之间按需分配。讲到LB的时候，往往说的是接集群外部流量的LB，这个用NodePort是比较难以达到的，毕竟NodePort是直接把服务暴露了，怎么连，压力怎么分布就看DNS和客户端的心情了。LB的手段也可以很多，协议上二层的，三层的，四层的，七层的，方法上RR, WRR, Hash等等。LB应该也包括一些动态功能的支持，比如探活，比如支持后台服务的自动扩容。

NodePort: NodePort本质上就是把K8S服务通过宿主机端口的方式暴露出去。这种方式简单明了，对于小型服务和不需要动态扩容的服务很方便。但显然灵活性比较差，而且有一定的安全风险。相对来说，通过NodePort对外暴露Ingress会比较常见。

Ingress: Ingress主要是用来处理外部到内部的连接的，通常是在应用层（HTTP/HTTPS)。Ingress本身是可以做7层LoadBalancer的，但通常是在集群内部做。最常见的莫过于Nginx来做Ingress，它的强大功能自然不必多说，Traffic routing, filtering, TLS termination, etc...&#x20;

这些本身技术并不是互斥的，往往一起存在，比如我们现在就是NLB->Ingress->ClusterIP。

