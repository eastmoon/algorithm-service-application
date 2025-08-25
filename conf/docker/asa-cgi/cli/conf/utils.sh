## Colorful echo
function echo-a() {
    [ -z ${CLI_DISABLE_COLOR} ] && echo -e "\033[90m[`date -Iseconds`]\033[0m ${@}" || echo -e "[`date -Iseconds`] ${@}"
    if [ ! -z ${CLI_LOG_FILE_ERR} ] && [ -e ${CLI_LOG_FILE_ERR} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_ERR}
    fi
    if [ ! -z ${CLI_LOG_FILE_INFO} ] && [ -e ${CLI_LOG_FILE_INFO} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_INFO}
    fi
    if [ ! -z ${CLI_LOG_FILE_WARN} ] && [ -e ${CLI_LOG_FILE_WARN} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_WARN}
    fi
}

function echo-c() {
    cs=${1}
    ce=${2}
    msg=(${@})
    msg=${msg[@]:2}
    [ -z ${CLI_DISABLE_COLOR} ] && echo -e "${cs}${msg}${ce}" || echo -e "${msg}"

}

function echo-i() {
    [ -z ${CLI_DISABLE_COLOR} ] && echo -e "\033[32m[`date -Iseconds`]\033[0m ${@}" || echo -e "[`date -Iseconds`] ${@}"
    if [ ! -z ${CLI_LOG_FILE_INFO} ] && [ -e ${CLI_LOG_FILE_INFO} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_INFO}
    fi
}

function echo-w() {
    [ -z ${CLI_DISABLE_COLOR} ] && echo -e "\033[33m[`date -Iseconds`]\033[0m ${@}" || echo -e "[`date -Iseconds`] ${@}"
    if [ ! -z ${CLI_LOG_FILE_WARN} ] && [ -e ${CLI_LOG_FILE_WARN} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_WARN}
    fi
}

function echo-e() {
    [ -z ${CLI_DISABLE_COLOR} ] && echo -e "\033[31m[`date -Iseconds`]\033[0m ${@}" || echo -e "[`date -Iseconds`] ${@}"
    if [ ! -z ${CLI_LOG_FILE_ERR} ] && [ -e ${CLI_LOG_FILE_ERR} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_ERR}
    fi
}

## File operation
function fadd() {
    ADD_STR=${1}
    TARGET_FILE=${2}
    if [ -e ${TARGET_FILE} ];
    then
        if [ $(grep "${ADD_STR}" ${TARGET_FILE} | wc -l) -eq 0 ];
        then
            echo "${ADD_STR}" >> ${TARGET_FILE}
        else
            echo-w "\"${ADD_STR}\" was exist in ${TARGET_FILE}"
        fi
    else
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${TARGET_FILE} not exist"
    fi
}

function freplace() {
    ORIGINAL_STR=${1}
    REPLACE_STR=${2}
    TARGET_FILE=${3}
    if [ -e ${TARGET_FILE} ];
    then
        if [ $(grep "${REPLACE_STR}" ${TARGET_FILE} | wc -l) -eq 0 ];
        then
            sed -i "s/${ORIGINAL_STR}/${REPLACE_STR}/g" ${TARGET_FILE}
        else
            echo-w "\"${REPLACE_STR}\" was exist in ${TARGET_FILE}"
        fi
    else
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${TARGET_FILE} not exist"
    fi
}

function fempty() {
    TARGET_FILE=${1}
    if [ -e ${TARGET_FILE} ];
    then
        sed -i '$ d' ${TARGET_FILE}
    else
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${TARGET_FILE} not exist"
    fi
}

## OS system operation
function system-runner() {
    SERVICE_NAME=${1}
    EXEC_COMMAND=${2}
    if [ $( systemctl status "${SERVICE_NAME}.service" 2>&1 1>/dev/null | wc -l ) -gt 0 ];
    then
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${SERVICE_NAME} not find in systemctl"
        return 1
    fi
    if [ $( systemctl list-units --full -all | grep "${SERVICE_NAME}.service" | wc -l ) -eq 0 ];
    then
        echo-w "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${SERVICE_NAME} not enable in systemctl"
    fi
    return 0
}

function command-runner() {
    COMMAND_NAME=${1}
    EXEC_COMMAND=${2}
    if [ $(command -v ${COMMAND_NAME} | wc -l) -eq 0 ];
    then
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${COMMAND_NAME} is not exist"
        return 1
    fi
    return 0
}

function try-file() {
    if [ ! -e ${1} ];
    then
        msg="[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${IOT_SERVICE_FILE} not exist"
        if [ ! -z ${2} ] && [ "${2}" == "err" ];
        then
            echo-e ${msg}
        else
            echo-w ${msg}
        fi
        return 1
    fi
    return 0
}

## try-catch script
function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

function catch()
{
    export ex_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}

function throw()
{
    exit $1
}

function throwWarn()
{
    if [ -z ${@} ];
    then
        echo-w "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] $(tail -n 1 ~/.runerr)"
    else
        echo-w "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${@}"
    fi
}

function throwErrors()
{
    set -e
}

function ignoreErrors()
{
    set +e
}
