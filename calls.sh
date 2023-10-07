#!/bin/bash

# Display Help
./sys_info.sh -h

# Show Disk Usage
./sys_info.sh -d

# Show Memory Usage
./sys_info.sh -m

# Show Running Processes
./sys_info.sh -p

# Show Disk and Memory Usage
./sys_info.sh -d -m

# Show All Information
./sys_info.sh -d -m -p

# Export Disk Usage to File
./sys_info.sh -d > output.txt

# Export All Information to File
./sys_info.sh -d -m -p > output.txt

# Invalid Option
./sys_info.sh --invalid

# Pipeline Examples:

# Example 1: Filter Disk Usage Information
# Explanation: This command filters the output of 'sys_info.sh -d' to display partitions with usage above 50%.
# Parameters:
# - '$5 > 50': Condition that checks if the 5th column (Usage %) is greater than 50%.
# - '{print}': Print the entire line that meets the condition.
# - '| grep -v "Filesystem"': Exclude lines containing "Filesystem" (header).
./sys_info.sh -d | awk '$5 > 50 {print}' | grep -v "Filesystem"

# Example 2: Calculate Total Memory Usage
# Explanation: This command extracts and displays the total memory used from 'sys_info.sh -m' output.
# Parameters:
# - '/Mem:/': Pattern to search for lines containing "/Mem: ".
# - '{print "Total Memory Used: " $3}': Print the text "Total Memory Used:" followed by the 3rd column (used memory).
./sys_info.sh -m | awk '/Mem:/ {print "Total Memory Used: " $3}'

# Example 3: Find Top CPU-Consuming Process
# Explanation: This command extracts the PID and command of the top CPU-consuming process from 'sys_info.sh -p' output.
# Parameters:
# - 'NR>1': Skip the first line (header).
# - '{print $2, $11}': Print the 2nd column (PID) and 11th column (command).
# - '| head -1': Select only the first line (top CPU-consuming process).
./sys_info.sh -p | awk 'NR>1 {print $2, $11}' | head -1

# Example 4: Redirect Output to a File
# Explanation: This command redirects the output of 'sys_info.sh -dmp' to a file named 'system_info.txt'.
./sys_info.sh -dmp > system_info.txt

# Example 5: Combine Multiple Commands
# Explanation: This command finds the top CPU-consuming process using 'sys_info.sh -p', then checks its memory usage.
# Parameters:
# - 'NR>1': Skip the first line (header) in 'sys_info.sh -p' output.
# - '{print $2, $11}': Print the 2nd column (PID) and 11th column (command).
# - '| head -1': Select only the first line (top CPU-consuming process).
# - '| xargs ps -p': Pass the PID to the 'ps' command to get details of the process.
# - '| ./sys_info.sh -m': Check memory usage of the process using 'sys_info.sh -m'.
./sys_info.sh -p | awk 'NR>1 {print $2, $11}' | head -1 | xargs ps -p | ./sys_info.sh -m
