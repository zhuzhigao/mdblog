<!--
title: RabbitMQ
date: 2016-12-16 13:19:19
tags:
- Message Queue
- RabbitMQ
-->
### RabbitMQ
Date: 2016-12-16 13:19:19
## Basic
- Sender opens connection, connection creates the channel, channel declares queue, and channel publishes message.
- Receiver opens connection, connection creates the channel, creates consumer from channel, consume declares event handler, channel consumes message from queue.
<!-- more -->

## Work Queues
- Round-robin dispatching, load balance
- Message acknowledgment, make sure it is precessed.
- Message durability, make sure no message loss even the RabbitMQ server is down
- Fair dispatch, limits the prefetch of the messages to make sure client only receive messages once the current message is processed. 

## Publish/Subscribe
### Exchanges
The core idea in the messaging model in RabbitMQ is that the producer never sends any messages directly to a queue. Actually, quite often the producer doesn't even know if a message will be delivered to any queue at all.

*direct, topic, headers and fanout*
- direct:  delivers messages to queues based on the message routing key
- topic: route messages to one or many queues based on matching between a message routing key and the pattern that was used to bind a queue to an exchange. The topic exchange type is often used to implement various publish/subscribe pattern variations
- fallout:  routes messages to all of the queues that are bound to it and the routing key is ignored. 
- headers:  route on multiple attributes that are more easily expressed as message headers than a routing key. Headers exchanges ignore the routing key attribute. Instead, the attributes used for routing are taken from the headers attribute

### Bindings
 A binding is a relationship between an exchange and a queue. This can be simply read as: the queue is interested in messages from this exchange.

## Routing
It is perfectly legal to bind multiple queues with the same binding key.
### Subscribing
```cs
foreach(var severity in args)
{
    channel.QueueBind(queue: queueName,
    exchange: "direct_logs",
     routingKey: severity);
}

```

## Topics
Messages sent to a topic exchange can't have an arbitrary routing_key - it must be a list of words, delimited by dots. A few valid routing key examples: "stock.usd.nyse", "nyse.vmw", "quick.orange.rabbit". There can be as many words in the routing key as you like, up to the limit of 255 bytes.
- \* (star) can substitute for exactly one word.
- \# (hash) can substitute for zero or more words.
![image](https://www.rabbitmq.com/img/tutorials/python-five.png)
- Q1 is interested in all the orange animals.
- Q2 wants to hear everything about rabbits, and everything about lazy animals.

Routing key can be "quick.orange.rabbit" or "lazy.orange.male.rabbit".

## Remote procedure call (RPC)
### Callback queue
In general doing RPC over RabbitMQ is easy. A client sends a request message and a server replies with a response message. In order to receive a response we need to send a 'callback' queue address with the request
```cs
var props = channel.CreateBasicProperties();
props.ReplyTo = replyQueueName;
```

### Correlation Id
For creating a single callback queue per client. Having received a response in that queue it's not clear to which request the response belongs. That's when the correlationId property is used. We're going to set it to a unique value for every request. 

![image](https://www.rabbitmq.com/img/tutorials/python-six.png)


## Reference
[RabbitMQ Tutorials](https://www.rabbitmq.com/getstarted.html)
