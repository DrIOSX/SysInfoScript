#!/bin/bash

set -euo pipefail

display_help() {
    echo "Usage: $0 [options] [output_file]"
    echo "Options:"
    echo "  -d, --disk            Show disk usage, sorted by usage percentage"
    echo "  -m, --memory          Display memory usage in a human-readable format"
    echo "  -p, --process         Show the top 10 CPU-consuming processes"
    echo "  -h, --help            Display this help message and exit"
    echo "output_file:            Optional parameter specifying the file to which the output will be saved"
    echo ""
    echo "Enhancements:"
    echo "  - Disk usage is sorted by usage percentage in descending order for easier readability"
    echo "  - Memory and process information are presented in a user-friendly format"
    exit 0
}

command_exists() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "$1 command is not installed."
        exit 1
    }
}

display_sys_info() {
    exec &>"${output_file:-/dev/stdout}"

    GREEN="\033[0;32m"
    RED="\033[0;31m"
    YELLOW="\033[0;33m"
    NC="\033[0m"

    if [ "$show_disk" = "true" ]; then
        command_exists df
        echo "=== Disk Usage (df -h) ==="
        df -h | awk 'NR==1; NR>1 {print $0 | "sort -k5,5 -rn"}'
    fi

    if [ "$show_memory" = "true" ]; then
        command_exists free
        echo -e "${GREEN}=== Memory Usage (free -h) ===${NC}"
        free -h | awk 'NR==1{print $0} NR==2{print $0} NR==3{print $0}'
    fi

    if [ "$show_processes" = "true" ]; then
        command_exists ps
        echo -e "${GREEN}=== Running Processes (ps aux --sort=-%cpu | head) ===${NC}"
        ps aux --sort=-%cpu | awk 'NR==1{print $0} NR>1{print $0}' | head -10
    fi
}

show_disk="false"
show_memory="false"
show_processes="false"
output_file=""

while (("$#")); do
    case "$1" in
    -d | --disk)
        show_disk="true"
        shift
        ;;
    -m | --memory)
        show_memory="true"
        shift
        ;;
    -p | --process)
        show_processes="true"
        shift
        ;;
    -h | --help)
        display_help
        ;;
    --)
        shift
        break
        ;;
    -*)
        flags=${1#-}
        for ((i = 0; i < ${#flags}; i++)); do
            flag=${flags:$i:1}
            case "$flag" in
            d)
                show_disk="true"
                ;;
            m)
                show_memory="true"
                ;;
            p)
                show_processes="true"
                ;;
            *)
                echo "Unknown option: -$flag" >&2
                exit 1
                ;;
            esac
        done
        shift
        ;;
    *)
        output_file="$1"
        shift
        ;;
    esac
done

display_sys_info
