<#
.SYNOPSIS
   PowerShell Script - System Information
.DESCRIPTION
   This PowerShell script is designed to gather and display various system information, such as disk usage,
   memory usage, and CPU-consuming processes. It provides a flexible command-line interface to allow users
   to select the information they want to view.
.NOTES
   File Name      : SystemInfo.ps1
   Author         : Your Name
   Prerequisite   : PowerShell 5.1 or higher
#>

# Function to display the built-in help message
function Show-Help {
    Write-Host "Usage: ./SystemInfo.ps1 [-ShowDisk] [-ShowMemory] [-ShowProcesses] [-OutputFile <output_file>]"
    Write-Host "Options:"
    Write-Host "  -ShowDisk            Show disk usage, sorted by usage percentage"
    Write-Host "  -ShowMemory          Display memory usage in a human-readable format"
    Write-Host "  -ShowProcesses       Show the top 10 CPU-consuming processes"
    Write-Host "  -OutputFile          Optional parameter specifying the file to which the output will be saved"
    Write-Host ""
    Write-Host "Enhancements:"
    Write-Host "  - Disk usage is sorted by usage percentage in descending order for easier readability"
    Write-Host "  - Memory and process information are presented in a user-friendly format"
}

# Function to display disk usage information
function Show-DiskUsage {
    Write-Host "=== Disk Usage (Get-WmiObject -Class Win32_LogicalDisk | Sort-Object -Property FreeSpacePercentage -Descending) ==="
    Get-WmiObject -Class Win32_LogicalDisk | Sort-Object -Property FreeSpacePercentage -Descending | Format-Table -AutoSize
}

# Function to display memory usage information
function Show-MemoryUsage {
    Write-Host "=== Memory Usage (Get-WmiObject -Class Win32_OperatingSystem) ==="
    Get-WmiObject -Class Win32_OperatingSystem | Format-Table -Property TotalVisibleMemorySize, FreePhysicalMemory, FreeVirtualMemory -AutoSize
}

# Function to display top CPU-consuming processes
function Show-Processes {
    Write-Host "=== Running Processes (Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10) ==="
    Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 | Format-Table -Property Id, ProcessName, CPU -AutoSize
}

# Parse command-line options
$ShowDisk = $false
$ShowMemory = $false
$ShowProcesses = $false
$OutputFile = $null

# Check command-line arguments
foreach ($arg in $args) {
    switch ($arg) {
        '-ShowDisk' { $ShowDisk = $true }
        '-ShowMemory' { $ShowMemory = $true }
        '-ShowProcesses' { $ShowProcesses = $true }
        '-OutputFile' { $OutputFile = $args[($args.IndexOf($arg) + 1)] }
    }
}

# Call the appropriate functions based on user-selected options
if ($ShowDisk) {
    Show-DiskUsage
}

if ($ShowMemory) {
    Show-MemoryUsage
}

if ($ShowProcesses) {
    Show-Processes
}
