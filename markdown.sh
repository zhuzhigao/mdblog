#!/bin/bash
start () {
   sudo nohup ./markdown-blog web --port 80  > out.log 2>err.log &
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
