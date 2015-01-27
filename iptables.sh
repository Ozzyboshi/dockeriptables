#!/bin/bash
iptables -F FORWARD
CONTAINERS=$(docker ps -q)
for i in $CONTAINERS; do
	IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $i)
	NAME=$(docker inspect -f '{{ .Name }}' $i)
	NAMEDIR=$(docker inspect -f '{{ .Name }}' $i | awk -F "_" '{print $1}')
	TAG=$(docker inspect -f '{{ .Name }}' $i | awk -F "_" '{print $2}')
	EXPOSED_PORT=$(docker port $i | awk -F "/" '{print $1}')
	EXPOSED_PROTO=$(docker port $i | awk -F "/" '{print $2}' | awk  '{print $1}')
	HOST_PORT=$(docker port $i | awk -F "/" '{print $2}' | awk  -F ":" '{print $2}')
	echo "************************************ START IPTABLES FOR $NAME ($i) *****************"
	echo "Ip container : $IP"
	echo "Porta esposta dal container : $EXPOSED_PORT"
	echo "Protocollo esposto dal container : " $EXPOSED_PROTO
	echo $HOST_PORT
	FILEIPTABLES=$HOME$NAMEDIR/$TAG.iptables
	echo $FILEIPTABLES
	if [ -f $FILEIPTABLES ];
	then
		$FILEIPTABLES $IP $EXPOSED_PROTO $EXPOSED_PORT
	else
		echo "file $FILEIPTABLES inesistente"
	fi
done