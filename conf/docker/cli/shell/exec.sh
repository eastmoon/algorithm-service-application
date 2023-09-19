#@STOP-CLI-PARSER

# Declare function
function action {
    # Declare variable
    EXEC_COMMAND=(${@})
    EXEC_ALOG=${EXEC_COMMAND[0]}
    EXEC_PARAM=${EXEC_COMMAND[@]:1}
    if [ -e ${APP_A_DIR}/${EXEC_ALOG}.py ];
    then
        desc="Exec algorithm : ${EXEC_ALOG}"
        [ "${EXEC_PARAM}" != "" ] && desc="${desc} ( ${EXEC_PARAM} )"
        echo-i "${desc}"
        python ${APP_A_DIR}/${EXEC_ALOG}.py ${EXEC_PARAM}
    else
        echo-w "Target algorithm ${EXEC_ALOG} is not exit."
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
