#@STOP-CLI-PARSER

# Declare function
function action {
    # Declare variable
    EXEC_COMMAND=(${@})
    EXEC_ALOG=${EXEC_COMMAND[0]}
    EXEC_PARAM=${EXEC_COMMAND[@]:1}
    EXEC_ALOG_PATH=
    ## Check target algorithm is exist.
    if [ -e ${APP_A_DIR}/${EXEC_ALOG}.py ];
    then
        EXEC_ALOG_PATH=${APP_A_DIR}/${EXEC_ALOG}.py
    elif [ -e ${APP_A_DIR}/${EXEC_ALOG}/main.py ];
    then
        EXEC_ALOG_PATH=${APP_A_DIR}/${EXEC_ALOG}/main.py
    fi
    ## If algorithm exist, execute python file with EXEC_ALOG_PATH variable
    if [ ! -z ${EXEC_ALOG_PATH} ];
    then
        desc="Exec algorithm : ${EXEC_ALOG}"
        [ "${EXEC_PARAM}" != "" ] && desc="${desc} ( ${EXEC_PARAM} )"
        echo-i "${desc}"
        python ${EXEC_ALOG_PATH} ${EXEC_PARAM}
    else
        echo-w "Target algorithm ${EXEC_ALOG} was not find."
    fi
}

function args {
    return 0
}

function short {
    echo "Execute algorithm"
}

function help {
    echo "Execute algorithm in '${APP_A_DIR}'"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
