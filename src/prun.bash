#!/usr/bin/env bash
#
# prun (Parallel Runner)
#
# Copyright (c) 2023 vorakl and the prun contributors
# SPDX-License-Identifier: Apache-2.0
#

version="{{version}}"
date="{{date}}"

start()
{
    : ${PRUN_DEBUG:=0}
    : ${PRUN_DEBUG_FMT:="DEBUG: %s\n"}
    : ${PRUN_DEBUG_START_FMT:="DEBUG: process started: pid=%s command='%s'\n"}
    : ${PRUN_DEBUG_WAIT_FMT:="DEBUG: wating for: pids=%s\n"}
    : ${PRUN_DEBUG_STOP_FMT:="DEBUG: process finished: pid=%s exit_code=%s command='%s'\n"}
    : ${PRUN_REPORT:=1}
    : ${PRUN_REPORT_SEP:=$'\t'}
    : ${PRUN_REPORT_FMT:="REPORT:\nexit_codes=%s\ncommands=%s\n"}

    declare -a exitcodes=()
    declare -a processes=()

    check_params "$@"
    case $? in
        0)  commands=("$@")
            ;;
        1)  IFS=$'\n' read -d '' -r -a commands
            ;;
        2)  IFS=$'\n' read -d '' -r -a commands < "$2"
            ;;
        3)  version >&2
            exit 1
            ;;
        *)  usage >&2
            exit 1
            ;;
    esac

    run_parallel commands processes
    wait_pids processes exitcodes commands
    report exitcodes commands
}

run_parallel()
{
    declare -n cmds=$1
    declare -n pids=$2
    local cmd
    local pid

    for cmd in "${cmds[@]}"
    do
        (eval "${cmd}")&
        pid=$!
        PRUN_DEBUG_FMT="${PRUN_DEBUG_START_FMT}" debug "${pid}" "${cmd}"
        pids+=(${pid})
    done
}

wait_pids()
{
    declare -n pids=$1
    declare -n codes=$2
    declare -n cmds=$3
    local pid
    local idx
    local rc

    while [[ -n "${pids[*]}" ]]
    do
        PRUN_DEBUG_FMT="${PRUN_DEBUG_WAIT_FMT}" debug "${pids[*]}"
        wait -np pid ${pids[*]}
        rc=$?

        if idx="$(arr_idx processes ${pid})"
        then
            codes[${idx}]=${rc}
            PRUN_DEBUG_FMT="${PRUN_DEBUG_STOP_FMT}" debug "${pid}" "${rc}" "${cmds[${idx}]}"
            unset pids[${idx}]
        fi
    done
}

arr_idx()
{
    declare -n arr=$1
    declare val=$2
    local i

    # loop only over existing indexes as there might be gaps in Bash arrays
    for i in "${!arr[@]}"
    do
        if [[ "${arr[i]}" == "${val}" ]]
        then
            # the output will contain an index if a return stature is 0
            echo "${i}"
            return 0
        fi
    done

    # check return status and don't consider an output ifit failed
    return 1
}

check_params()
{
    if [[ -z "$1" ]]
    then
        return 255
    elif [[ "$1" == "-f" ]]
    then
        [[ "$2" == "-" ]] && return 1 || :
        return 2
    elif [[ "$1" == "-v" ]]
    then
        return 3
    fi
    return 0
}

debug()
{
    if (( PRUN_DEBUG ))
    then
        printf "${PRUN_DEBUG_FMT}" "$@" >&2
    fi
}

report()
{
    declare -n codes=$1
    declare -n cmds=$2

    if (( PRUN_REPORT ))
    then
        (
            IFS=${PRUN_REPORT_SEP}
            printf "${PRUN_REPORT_FMT}" "${codes[*]}" "${cmds[*]}"
        )
    fi
}

usage()
{
    echo -e "Usage:\n\tprun ['command' ['command' [...]]]"
    echo -e "\tprun -f file|-"
    echo -e "\tprun -v"
    echo -e "\nTo get more detailed information, run 'man prun'"
}

version()
{
    echo "prun version ${version} commited on ${date}"
}

start "$@"
