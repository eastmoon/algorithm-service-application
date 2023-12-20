#!/bin/bash

# Declare variable
MQ_LOG_DIR=/var/log/climq

#
[ ! -d ${MQ_LOG_DIR} ] && mkdir ${MQ_LOG_DIR}
[ $(find /tmp -type f -iname "cli.mq*" | wc -l) -gt 0 ] && rm /tmp/cli.mq*
[ $(find /var/log/climq -type f -iname "access.*" | wc -l) -gt 0 ] && rm /var/log/climq/access.*
for num in $(eval echo "{0..${NGINX_MAX_CGI_SOCK}}"); do
    CLI_WORKER=/usr/local/src/asa/cli-worker.sh
    if [ -e ${CLI_WORKER} ];
    then
      chmod 766 ${CLI_WORKER}
      bash ${CLI_WORKER} ${num} > ${MQ_LOG_DIR}/access.${num}.log 2>&1 &
    fi
done
