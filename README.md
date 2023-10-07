# System Information Script

## Overview

This Bash script allows you to quickly gather system information such as disk usage, memory usage, and CPU-consuming processes. It comes with an easy-to-use interface that accepts command-line options to specify what information to display. The script also offers the ability to export the output to a file.

## Features

- Show disk usage sorted by usage percentage in descending order.
- Display memory usage in a human-readable format.
- Show the top 10 CPU-consuming processes.
- Supports both short-form and long-form command-line options.
- Optional output redirection to a file.

## Prerequisites

- Bash Shell Interpreter
- `df`, `free`, and `ps` utilities should be installed on the system.

## Usage

Run the script using the following syntax:

./sys_info.sh [options] [output_file]


### Options

- `-d, --disk` : Show disk usage, sorted by usage percentage.
- `-m, --memory` : Display memory usage in a human-readable format.
- `-p, --process` : Show the top 10 CPU-consuming processes.
- `-h, --help` : Display the help message and exit.

### Output File

- `output_file`: Optional parameter specifying the file to which the output will be saved. If not provided, output will be displayed on the terminal.

## Examples

### Display Help

./sys_info.sh -h


### Show Disk Usage

To display disk usage sorted by usage percentage in descending order, use the following command:

./sys_info.sh -d

### Display Memory Usage

To display memory usage in a human-readable format, use the following command:

./sys_info.sh -m

### Show Top CPU-Consuming Processes

To show the top 10 CPU-consuming processes, use the following command:

./sys_info.sh -p

### Redirect Output to a File

You can redirect the output to a file by providing the output_file parameter. For example, to save disk usage information to a file named "disk_usage.txt," you can use the following command:

./sys_info.sh -d disk_usage.txt

### License
This script is provided under the MIT License.

### Author
DrIOSx



