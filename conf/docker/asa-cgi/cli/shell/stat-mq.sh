# Declare function
function action {
    # Declare variable
    EXEC_COMMAND=(${@})
    REQ_MIN_VALUE=0
    REQ_MIN_MQ=
    #for file in $(find /tmp -type f -iname "cli.mq*"); do

    #done
    while read -r line; do
        v=$(echo ${line} | awk '{print $1}')
        f=$(echo ${line} | awk '{print $2}')
        if [ -e ${f} ];
        then
            echo ${v}, ${f}
        fi
    done < <(wc -l /tmp/cli.mq* | sort)
}

function args {
    return 0
}

function short {
    echo "List all message queue status."
}

function help {
    echo "List all message queue status."
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
