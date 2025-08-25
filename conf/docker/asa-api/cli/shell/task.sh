#@STOP-CLI-PARSER

# Declare function
function action {
    # Declare variable
    EXEC_COMMAND=(${@})
    EXEC_TASK=${EXEC_COMMAND[0]}
    EXEC_ALOG_PATH=
    ## Check target algorithm is exist.
    if [ $(find ${APP_T_DIR} -type f -iname "${EXEC_TASK}.*" | wc -l) -gt 0 ];
    then
        EXEC_ALOG_PATH=$(find ${APP_T_DIR} -type f -iname "${EXEC_TASK}.*" | tail -n 1)
    fi
    ## If algorithm exist, execute python file with EXEC_ALOG_PATH variable
    if [ ! -z ${EXEC_ALOG_PATH} ];
    then
        desc="Exec task : ${EXEC_TASK}"
        echo-i "${desc}"
        python ${CLI_SHELL_DIRECTORY}/task/run.py ${EXEC_ALOG_PATH} ${CLI_DISABLE_COLOR}
    else
        echo-w "Target task ${EXEC_ALOG} was not find."
    fi
}

function args {
    return 0
}

function short {
    echo "Execute task file"
}

function help {
    echo "Execute file in '${APP_T_DIR}'"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
