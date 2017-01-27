#!/bin/bash

# starts consul on several nodes

dm_node="$1"
consul_mode="$2"
resolver="8.8.4.4"


[ -z "$dm_node" ] && (\
	echo "I need one of the running docker-machine names as argument:"; \
	docker-machine ls --format "\t{{.Name}} {{.State}}"; \
	echo Exiting...) && exit 1

# client by default
[ -z "$consul_mode" ] && consul_mode='client'

[ "$consul_mode" != "client" -a "$consul_mode" != "server" ] && \
	echo 'The second argument must be "client" or "server". Exiting...' && \
	exit 1

docker-machine ip $dm_node > /dev/null
[ $? -ne 0 ] && echo "Can't find node ${dm_node}. Exiting..." && exit 1

# adding some env varibles for docker-compose
export HOSTNAME=`docker-machine ip $dm_node`
#FIXME check if HOSTNAME is IP
export EXTERNAL_IP=`dig @${resolver} $HOSTNAME +short`
[ -z "$EXTERNAL_IP" ] && echo "Can't define external ip for node ${dm_node}. Exiting..." && exit 1

[ "$consul_mode" = "client" ] && export CONSUL_MODE=''
[ "$consul_mode" = "server" ] && export CONSUL_MODE='-server'

eval $(docker-machine env $dm_node)
docker-compose up -d consul

