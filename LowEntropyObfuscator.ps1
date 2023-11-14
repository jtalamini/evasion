<#
.SYNOPSIS
    PowerShell script used to implement low-entropy strings obfuscation.
.DESCRIPTION
    This script allows to obfuscate a given string using arbitrary wordlist. The resulting list can be fed to a deobfuscator based on the same wordlist to retrieve the original string.
    This obfuscation method can be useful when dealing with entropy-based malware detection tools.
#>
param (
    [string]$wordFile,
    [string]$inputString
)
if ((-not $wordFile) -or (-not $inputString)) {
    Write-Host "Usage: obfuscator.ps1 -wordFile <path> -inputString <path>"
    exit
}
# read unique words from file
$uniqueWords = $(Get-Content $wordFile | Sort-Object | Get-Unique | Select-Object -First 256)
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
