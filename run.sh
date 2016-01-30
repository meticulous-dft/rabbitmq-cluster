#!/bin/bash

set -m

# make rabbit own its own files
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq

if [ -z "$CLUSTER_WITH" ] ; then
    rabbitmq-plugins enable --offline rabbitmq_management rabbitmq_mqtt
    /usr/sbin/rabbitmq-server
else
    if [ -f /.CLUSTERED ] ; then
    /usr/sbin/rabbitmq-server
    else
        rabbitmq-plugins enable --offline rabbitmq_management_agent rabbitmq_mqtt
        touch /.CLUSTERED
        /usr/sbin/rabbitmq-server &
        sleep $SLEEP
        rabbitmqctl stop_app
        rabbitmqctl join_cluster rabbit@$CLUSTER_WITH
        rabbitmqctl start_app
        fg
    fi
fi
