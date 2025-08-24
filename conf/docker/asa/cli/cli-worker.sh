#!/bin/bash
set +e

# Declare variable
MQ_NUM=${1}
MQ_FILE="/tmp/cli.mq.${MQ_NUM}.sock"
MQ_LOG_DIR="/var/log/climq"
# Initial Message Queue
[ ! -e ${MQ_FILE} ] && touch ${MQ_FILE}
[ ! -d ${MQ_LOG_DIR} ] && mkdir ${MQ_LOG_DIR}
# Start worker
while true;
do
    if [ $(cat ${MQ_FILE} | wc -l) -gt 0 ];
    then
        # 取回一個命令
        CMD=$(head -n 1 ${MQ_FILE})
        # 執行命令
        eval ${CMD} > ${MQ_LOG_DIR}/mq.${MQ_NUM}.`date +%Y%m%d%s`.log 2>&1 || echo "[`date`] mq:${MQ_NUM}:error: ${CMD}"
        # 自柱列移除命令
        sed -i "1d" ${MQ_FILE}
    else
        # 沒有命令，等待 1 秒
        sleep 0.5
    fi
done
