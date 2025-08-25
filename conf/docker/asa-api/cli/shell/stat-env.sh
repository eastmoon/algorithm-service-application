#@STOP-CLI-PARSER

# Declare variable
CLI_APP_VAR_FILE=${CLI_DIRECTORY}/conf/attributes.sh
CLI_STATUS_ENV_TMP_FILE=${CLI_DIRECTORY}/.statusenvtmp
[ -z ${STATUS_ENV_FORMAT} ] && STATUS_ENV_FORMAT="text"

# Declare function

# Declare CLI function
function action {
    try-file ${CLI_APP_VAR_FILE} && {
        case ${STATUS_ENV_FORMAT} in
            "text")
                while read line
                do
                    if [[ ${line} =~ '#' ]]
                    then
                        echo-c "\033[36m" "\033[0m" ${line}
                    else
                        ev=${line%=*}
                        printf "%-20s=  %-60s\n" ${line%=*} ${!ev}
                    fi
                done < ${CLI_APP_VAR_FILE}
                ;;
            "json")
                # Generate tmp file
                [ -e ${CLI_STATUS_ENV_TMP_FILE} ] && rm ${CLI_STATUS_ENV_TMP_FILE}
                touch ${CLI_STATUS_ENV_TMP_FILE}
                while read line
                do
                    if [[ ! ${line} =~ '#' ]]
                    then
                        ev=${line%=*}
                        printf "\"%s\": \"%s\",\n" ${line%=*} ${!ev} >> ${CLI_STATUS_ENV_TMP_FILE}
                    fi
                done < ${CLI_APP_VAR_FILE}
                # Print json format with tmp file
                echo "{"
                ll=$(wc -l < ${CLI_STATUS_ENV_TMP_FILE})
                cl=0
                while read line
                do
                    cl=$(($cl + 1))
                    [[ ${cl} -eq ${ll} ]] && line=${line//,/}
                    echo "  ${line}"
                done < ${CLI_STATUS_ENV_TMP_FILE}
                echo "}"
                rm ${CLI_STATUS_ENV_TMP_FILE}
                ;;
        esac
    }
}

function args {
    key=${1}
    value=${2}
    case ${key} in
        "--json")
            STATUS_ENV_FORMAT="json"
            ;;
    esac
}

function short {
    echo "Show environment variable"
}

function help {
    echo "Show command line interface environment variable"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    echo "    --json            Show with JSON format."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
