#@STOP-CLI-PARSER

# Declare function
function send2mq {
    ARGV=(${@})
    MQ=${ARGV[0]}
    CMD=${ARGV[@]:1}
    echo "${CMD}" to ${MQ}
    echo "asa exec ${CMD}" >> ${MQ}
}
function action {
    # Declare variable
    REQ_MIN_VALUE=
    REQ_MIN_MQ=
    REQ_SEND=
    ##
    desc="Push algorithm in message queue : ${EXEC_ALOG}"
    [ "${EXEC_PARAM}" != "" ] && desc="${desc} ( ${EXEC_PARAM} )"
    #echo-i ${desc}
    # 1. send to the MQ which not have request at work
    while read -r line; do
        v=$(echo ${line} | awk '{print $1}')
        f=$(echo ${line} | awk '{print $2}')
        if [ -e ${f} ] && [ -z ${REQ_SEND} ];
        then
            if [ ${v} -eq 0 ];
            then
                REQ_SEND=1
                send2mq ${f} ${@}
            elif [ -z ${REQ_MIN_VALUE} ] || [ ${v} -lt ${REQ_MIN_VALUE} ];
            then
                REQ_MIN_VALUE=${v}
                REQ_MIN_MQ=${f}
            fi
        fi
    done < <(wc -l /tmp/cli.mq* | sort)
    # 2. When all MQ at work, send to the MQ have least request or return error message.
    if [ -z ${REQ_SEND} ];
    then
        #send2mq ${REQ_MIN_MQ} ${EXEC_COMMAND}
        echo-e "All CLI worker at work"
    fi
}

function args {
    return 0
}

function short {
    echo "Pull algorithm request in message queue."
}

function help {
    echo "Pull algorithm request in message queue."
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
