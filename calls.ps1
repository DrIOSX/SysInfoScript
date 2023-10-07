# Display Help:
./SystemInfo.ps1 -ShowHelp

# Show Disk Usage:
./SystemInfo.ps1 -ShowDisk

# Show Memory Usage:
./SystemInfo.ps1 -ShowMemory

# Show Running Processes:
./SystemInfo.ps1 -ShowProcesses

# Show Disk and Memory Usage:
./SystemInfo.ps1 -ShowDisk -ShowMemory

# Show All Information:
./SystemInfo.ps1 -ShowDisk -ShowMemory -ShowProcesses

# Export Disk Usage to File:
./SystemInfo.ps1 -ShowDisk > output.txt

# Export All Information to File:
./SystemInfo.ps1 -ShowDisk -ShowMemory -ShowProcesses > output.txt

# Invalid Option:
./SystemInfo.ps1 --invalid
