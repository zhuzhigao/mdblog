<!--
title: Angular2初试
date: 2017-04-17 10:38:41
tags:
- Angular2
- AngularJS
-->
### Angular2初试
Date: 2017-04-17 10:38:41

好久没有更新了。最近刚好写了第一个比较完备的Angular2的程序，就简单写一点，总结一下。
Ng2 相对于Ng1来说，基本上除了概念还有些并保留外，基本上就是一个全新的Web框架了。几点我比较喜欢的。
<!-- More -->
- 去除了Ng1的Controller。Controller在Ng1中是一个比较尴尬的存在，很容易导致在Controller中直接处理DOM和业务逻辑，变成一个大杂烩。Scope和Digest也被去除，开发者不用去担心Scope和Digest带来的效率问题和副作用。
- 引入了Module和Component的概念。每个Module和Component自组织，整个程序的结构变得比以前更加清晰和易于管理。
- 使用TypeScript作为默认语言，强类型，又不失灵活性，易于与JS集成与过度
- Directive, Service等的定义更加简单，Dependency Injection也更加直观。
- RxJS的引入，极大的节省了代码量和提高了数据处理的灵活性
- 性能据说有所提升，在View之间切换的时候似乎不会重新创建Component。这块需要继续验证。

和Ng1一样，Ng2的上手也是比较慢的。Ng2的功能比较完备庞杂， 不过可能是因为有了Ng1的基础，感觉没有那么困难。小坑还是很多，往往需要耽搁不少时间。比如*ngFor这个directive，太常用了相当然认为肯定能用，却各种运行时错误，google了才知道需要Import CommonModule。在比如Root Route如果用的是LoadChildren话，每个module都需要写Route 来Route自己的component。而LoadComponent直接只要在Root Route写Component就可以了。

Ng2 Component非常利于Smart Component与Dump Component的开发。下一步就是实验下Ng2+Redux来实现Smart Component和Dumb Component。到时再来更新。
