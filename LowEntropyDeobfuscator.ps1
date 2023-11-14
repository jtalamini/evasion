<#
.SYNOPSIS
    PowerShell script used to implement low-entropy strings de-obfuscation.
.DESCRIPTION
    This script allows to de-obfuscate a string based on a given wordlist. The script must be executed on the same wordlist used to obfuscate the string.
    This obfuscation method can be useful when dealing with entropy-based malware detection tools.
#>

param (
    [string]$wordListPath
)
if (-not $wordListPath) {
    Write-Host "Usage: LowEntropyDeobfuscator.ps1 -wordListPath <path>"
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
# obfuscated list
# YOUR OBFUSCATED PAYLOAD GOES HERE
$obfuscated =@("avvicinare","battaglia","bestia","bambino","bestia","azione","avvicinare","battere","avvocato","biondo","badare","badare","baciare","bere")
# convert each byte into a word
$output = ""
foreach ($element in $obfuscated) {
    $index = $wordList.IndexOf($element)
    $output += [System.Text.Encoding]::UTF8.GetString($index)
}
# execute the result
$output
