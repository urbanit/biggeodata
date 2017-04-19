param([string]$inputFileName)
$ElapsedTime = [System.Diagnostics.Stopwatch]::StartNew()
if (-Not ($inputFileName)) 
{ 
	Throw "You must specify an input file name" 
}
$fullInputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($inputFileName)
if (-Not (Test-Path $fullInputPath))
{
	Throw "File $inputFileName does not exist!"
	exit
}
$c = 0
Get-Content $fullInputPath -ReadCount 1000 | % {$c += $_.Length}
Write-Host "Rows: " $c
# Get-Content $fullInputPath | Measure-Object -line xxx
Write-Host $ElapsedTime.Elapsed.ToString()
