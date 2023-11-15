#!/bin/bash
start () {
   sudo nohup ./markdown-blog web --title "一个略懂石油的广告码农的日常" --port 80  > out.log 2>err.log &
   sleep 1
   echo "started"
}

stop () {
	sudo kill $(ps aux | grep 'markdown-blog' | awk '{print $2}')
	sleep 1
	echo "stopped"
}

if [ "$1" = "start" ];
then
	start
fi

if [ "$1" = "stop" ];
then
	stop
fi

if [ "$1" = "restart" ];
then
	stop
	start
fi

