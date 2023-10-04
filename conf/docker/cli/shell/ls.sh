#@STOP-CLI-PARSER

# Declare variable

# Declare function
function action {
    echo-c "\033[36m" "\033[0m" Algorithm list:
    ## Search all python file in application directories
    for file in $(find ${APP_A_DIR} -maxdepth 1 -type f -iname "*.py");
    do
        algo=${file##*/}
        echo ${algo%.*}
    done
    ## Search all main.py in application sub-directories
    for dir in $(find ${APP_A_DIR} -maxdepth 2 -type f -iname "main.py");
    do
        algo=${dir##*${APP_A_DIR}\/}
        algo=${algo%\/main.py*}
        echo ${algo}
    done
}

function args {
    return 0
}

function short {
    echo "List algorithm"
}

function help {
    echo "List all algorithm script in '${APP_A_DIR}'"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
