# Declare variable

# Declare function
function action {
    echo -e "\033[36mAlgorithm list:\033[0m"
    for file in $(find ${APP_A_DIR} -type f -iname "*.py");
    do
        algo=${file##*/}
        echo ${algo%.*}
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
