#@STOP-CLI-PARSER

# Declare variable

# Declare function
function show {
    ALGO_NAME=${1}
    FILE_PATH=${2}
    if [ $(grep "#@PARAME" ${FILE_PATH} | wc -l) -eq 0 ];
    then
        echo "${ALGO_NAME}"
    else
        str=$(grep "#@PARAME" ${FILE_PATH} | sed -e "s/#@PARAME//g" | sed -e "s/^ //g")
        echo "${ALGO_NAME} (${str})"
    fi
    if [ $(grep "#@DESC" ${FILE_PATH} | wc -l) -gt 0 ];
    then
        while read line; do
            desc=${line##*@DESC }
            echo "  ${desc}"
        done < <(grep "#@DESC" ${FILE_PATH})
    fi
}
function action {
    echo-c "\033[36m" "\033[0m" Algorithm list:
    ## Search all python file in application directories
    for file in $(find ${APP_A_DIR} -maxdepth 1 -type f -iname "*.py");
    do
        algo=${file##*/}
        algo=${algo%.*}
        show ${algo} ${file}
    done
    ## Search all main.py in application sub-directories
    for dir in $(find ${APP_A_DIR} -maxdepth 2 -type f -iname "main.py");
    do
        algo=${dir##*${APP_A_DIR}\/}
        algo=${algo%\/main.py*}
        show ${algo} ${dir}
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
