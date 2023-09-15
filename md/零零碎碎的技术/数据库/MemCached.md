<!--
title: Redis vs MemCached
date: 2017-02-14 14:00:43
tags:
- Redis
- MemCached
-->
Quoted from [StackOverflow](http://stackoverflow.com/questions/10558465/memcached-vs-redis).

As of today every major feature and strength memcached offers are now a subset of redis' features and strengths. Any use case you might use memcached for redis can solve equally well. They are both lightning fast as volatile caches. While that's all that memcached is its only the tip of the redis iceberg.

<!-- more -->

Memcached is a volatile in-memory key/value store. Redis can act like one (and do that job as well as memcached), but it is a data structure server.

Here are a few of the features that redis offers which memcached doesn't and allows redis to be used as a "real" data store instead of just a cache.

Powerful data types and powerful commands to leverage them. Hashes, Sorted Sets, Lists, and more.
Persistence to disk, by default.
Transactions with optimistic locking (WATCH/MULTI/EXEC)
Pub/sub. Extremely fast.
Values up to 512MB in size (memcached limited to 1MB per key)
Lua scripting (as of 2.6)
Built in clustering (as of 3.0)
Extremely fast at everything. Benchmarks are often conflicting, but this much is clear: when used like memcached Redis falls somewhere between nearly as fast or maybe even a little faster. Like memcached it is often bound by available network or memory bandwidth instead of CPU or other bottlenecks and will rarely be the culprit when your app is slowing down.
The powerful data types are particularly important. They allow redis to provide a fantastic shared queue (lists), a great messaging solution (pub/sub), a good place for storing sessions (hashes), and a compelling place for high score tracking (sorted sets). These are just a few examples that scratch the surface.

Conclusion

To answer your original question: The performance and memory usage of Redis compared to memcached should be relatively similar. Close enough that for most uses any performance difference in either direction is academic as neither is likely to be the bottleneck.

Unless you already have a large investment in memcached, going forward redis is the obvious solution. For solutions both tools would solve, go with the one that offers more flexibility for new use cases and also provides better out-of-the-box availability, scalability, and administration: redis.

Not only is redis the better option for places you might use memcached, it enables whole new types of use cases and usage patterns.

Memcached is a fine piece of software that is stable and hardened. If you already have a large investment in memcached then you may want to stick with it. There are many use cases where redis is as-good-as memcached but isn't better. Evaluate the benefits of redis (if any) and compare that to the cost of switching. Make your own determination if moving to redis is worth your time.
