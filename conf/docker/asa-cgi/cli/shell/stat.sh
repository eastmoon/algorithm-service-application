# Declare variable

# Declare function
function action {
    help
}

function args {
    return 0
}

function short {
    echo "Show algorithm service appliction infromation"
}

function help {
    echo "Show algorithm service appliction infromation"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
