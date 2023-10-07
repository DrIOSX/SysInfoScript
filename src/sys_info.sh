#!/bin/bash
# This line specifies that the script should be executed using the Bash shell interpreter.

##############################################
# Bash Script - System Information
##############################################

# Introduction:
# This Bash script is designed to gather and display various system information, such as disk usage, memory usage,
# and CPU-consuming processes. It provides a flexible command-line interface to allow users to select the information
# they want to view.

# Assumptions:
# 1. This script assumes that it will be executed in a Bash shell environment.
# 2. The script assumes that the required utilities ('df', 'free', 'ps') are available on the system.
# 3. It assumes that the user has basic familiarity with the Bash scripting language.
# 4. The script expects valid input parameters and options. It does not extensively validate user input.

# Strict Mode:
# The script employs strict mode for error handling, which includes the following options:
# -e: Ensures the script exits immediately if any command within it exits with a non-zero status.
# -u: Causes the script to exit if any variable is used before being set.
# -o pipefail: Makes the script exit with the status of the last command in the pipe to fail or zero if all commands exit successfully.

# Function Definitions:
# The script defines several functions to modularize the code and enhance readability.
# These functions include 'display_help', 'command_exists', and 'display_sys_info'.

# Usage:
# To use this script, execute it in a terminal with appropriate options and parameters.
# The available options are '-d' or '--disk', '-m' or '--memory', '-p' or '--process', and '-h' or '--help'.
# An optional 'output_file' parameter can be provided to redirect the output to a file.

# Enhancements:
# The script has been enhanced to provide a better user experience:
# - Disk usage information is sorted by usage percentage in descending order for easier readability.
# - Memory and process information are presented in a human-readable format.
# - Error handling and validation are incorporated to handle various scenarios.

## Script:

# Enable strict mode for enhanced error handling:
# -e: Exits the script immediately if any command fails (returns non-zero status).
# -u: Exits the script if a variable is used before being set.
# -o pipefail: Makes the script exit with the status of the last command in a pipe to fail, if any, or zero if all succeed.
set -euo pipefail

# Function to display the built-in help message
display_help() {
    # Display usage instructions and available options
    echo "Usage: $0 [options] [output_file]"
    echo "Options:"
    echo "  -d, --disk            Show disk usage, sorted by usage percentage"
    echo "  -m, --memory          Display memory usage in a human-readable format"
    echo "  -p, --process         Show the top 10 CPU-consuming processes"
    echo "  -h, --help            Display this help message and exit"
    echo "output_file:            Optional parameter specifying the file to which the output will be saved"

    # Describe script enhancements over the basic version
    echo ""
    echo "Enhancements:"
    echo "  - Disk usage is sorted by usage percentage in descending order for easier readability"
    echo "  - Memory and process information are presented in a user-friendly format"

    exit 0 # Exit the script after displaying the help message
}

# Function to validate that a required command exists on the system
command_exists() {
    # Check if a given command exists on the system
    # Redirect any output to /dev/null to suppress it.
    # If the command doesn't exist, print an error message and exit with a status code of 1.
    command -v "$1" >/dev/null 2>&1 || {
        echo "$1 command is not installed."
        exit 1
    }
}

# Main function to display various system information based on user-selected options
display_sys_info() {
    # Redirect all output (stdout and stderr) to the file specified in 'output_file' or to stdout by default.
    exec &>"${output_file:-/dev/stdout}"

    # Define ANSI escape codes for text coloring.
    GREEN="\033[0;32m"   # Green text
    RED="\033[0;31m"     # Red text
    YELLOW="\033[0;33m"  # Yellow text
    NC="\033[0m"          # Reset color

    # Check if disk information should be displayed.
    if [ "$show_disk" = "true" ]; then
        # Validate that the 'df' command is available on the system.
        command_exists df
        # Display disk usage using 'df -h' for human-readable format.
        echo "=== Disk Usage (df -h) ==="
        # Use 'awk' to keep the header in the first line and sort the rest by the 5th column (Usage %) in descending order.
        df -h | awk 'NR==1; NR>1 {print $0 | "sort -k5,5 -rn"}'
        # Explanation of the pipeline:
        # - The 'df -h' command retrieves disk usage information in a human-readable format.
        # - The '|' symbol pipes the output of 'df -h' to the 'awk' command for further processing.
        # - In 'awk', 'NR==1' selects the first line (the header), and 'NR>1' selects all other lines.
        # - The '{print $0 | "sort -k5,5 -rn"}' part prints each line and pipes it to 'sort' to sort by the 5th column (Usage %) in descending order.
    fi

    # Check if memory usage information should be displayed.
    if [ "$show_memory" = "true" ]; then
        # Validate that the 'free' command is available on the system.
        command_exists free
        # Display memory usage using 'free -h' for human-readable format.
        # Color code the header for emphasis.
        echo -e "${GREEN}=== Memory Usage (free -h) ===${NC}"
        # Use 'awk' to format the output of 'free -h'.
        free -h | awk 'NR==1{print $0} NR==2{print $0} NR==3{print $0}'
        # Explanation of the pipeline:
        # - The 'free -h' command retrieves memory usage information in a human-readable format.
        # - The '|' symbol pipes the output of 'free -h' to the 'awk' command for further processing.
        # - In 'awk', 'NR==1', 'NR==2', and 'NR==3' select the first three lines (header and two data lines).
    fi # End of the memory information block.

    # Check if information about CPU-consuming processes should be displayed.
    if [ "$show_processes" = "true" ]; then
        # Validate that the 'ps' command is available on the system.
        command_exists ps
        # Display the top 10 CPU-consuming processes using 'ps aux --sort=-%cpu | head'.
        # Color code the header for emphasis.
        echo -e "${GREEN}=== Running Processes (ps aux --sort=-%cpu | head) ===${NC}"
        # Use 'awk' to format the output of 'ps aux'.
        ps aux --sort=-%cpu | awk 'NR==1{print $0} NR>1{print $0}' | head -10
        # Explanation of the pipeline:
        # - The 'ps aux --sort=-%cpu' command lists all processes and sorts them by CPU usage percentage in descending order.
        # - The '|' symbol pipes the output to 'awk' for further processing.
        # - In 'awk', 'NR==1' selects the first line (header), and 'NR>1' selects all other lines.
        # - Finally, 'head -10' limits the output to the top 10 CPU-consuming processes.
    fi # End of the process information block.
}


# Initialize flags to control the display of system information.
# All flags are set to "false" by default, meaning no information will be displayed unless specified.
show_disk="false"      # Flag to control disk usage display.
show_memory="false"    # Flag to control memory usage display.
show_processes="false" # Flag to control process information display.

# Initialize a variable to hold the output file name.
# By default, this is empty, directing output to stdout.
output_file=""

# Parse command-line options using a while loop.
# The loop iterates through each argument passed to the script.
while (("$#")); do
    # Use a case statement to handle each type of option.
    case "$1" in
    -d | --disk)
        show_disk="true" # Set the flag to display disk usage.
        shift            # Move to the next argument.
        ;;
    -m | --memory)
        show_memory="true" # Set the flag to display memory usage.
        shift              # Move to the next argument.
        ;;
    -p | --process)
        show_processes="true" # Set the flag to display process information.
        shift                 # Move to the next argument.
        ;;
    -h | --help)
        display_help # Call the function to display the help text.
        ;;
    --)
        shift # Move past the '--' argument.
        break # End option parsing.
        ;;
    -*)
        # Handle chained options like -dmp.
        # Extract individual flags from the chain.
        flags=${1#-}                          # Remove the leading dash.
        for ((i = 0; i < ${#flags}; i++)); do # Iterate through each flag.
            flag=${flags:$i:1}                # Extract a single flag from the chain.
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
                echo "Unknown option: -$flag" >&2 # Output an error message.
                exit 1                            # Exit the script with a non-zero status code.
                ;;
            esac
        done
        shift # Move to the next argument.
        ;;
    *)
        output_file="$1" # Assume any other argument is the output file name.
        shift            # Move to the next argument.
        ;;
    esac
done

# Call the function to display the selected system information.
# The flags set earlier will determine what information is displayed.
display_sys_info