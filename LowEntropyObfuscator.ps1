<#
.SYNOPSIS
    PowerShell script used to implement low-entropy strings obfuscation.
.DESCRIPTION
    This script allows to obfuscate a given string using arbitrary wordlist. The resulting list can be fed to a de-obfuscator script based on the same wordlist to retrieve the original string.
    This obfuscation method can be useful when dealing with entropy-based malware detection tools.
#>
param (
    [string]$wordListPath,
    [string]$inputString
)
if ((-not $wordListPath) -or (-not $inputString)) {
    Write-Host "Usage: LowEntropyObfuscator.ps1 -wordListPath <path> -inputString <string>"
    exit
}
# read unique words from file
$uniqueWords = $(Get-Content $wordListPath | Sort-Object | Get-Unique | Select-Object -First 256)
# create an empty list
$wordList = @()
# add each word to the list
foreach ($word in $uniqueWords) {
    $wordList += $word
}
# Convert the input string to bytes
$bytes = [System.Text.Encoding]::UTF8.GetBytes($inputString)
$output = @(0) * $bytes.Length
# convert each byte into a word
$iterator = 0
foreach ($byte in $bytes) {
    $output[$iterator] = $wordList[$byte]
    $iterator++
}
# display the result to the screen
Write-Output ('("{0}")' -f ($output -join '","'))
