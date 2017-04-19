param([string]$inputFileName, 
      [string]$outputFileName,
      [int]$records = 1000,
	  [boolean]$skipFirstRecord = $true)
$ElapsedTime = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "Input File Name: $inputFileName" -foregroundcolor "magenta"
Write-Host "Output File Name: $outputFileName" -foregroundcolor "magenta"
Write-Host "Number of Records: $records records" -foregroundcolor "magenta"

# Make sure that the input and output file names are specified
if (-Not ($inputFileName)) 
{ 
	Throw "You must specify an input file name" 
}

if (-Not ($outputFileName)) 
{ 
	Throw "You must specify an output file name" 
}

# Get the full input and output paths
$fullInputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($inputFileName)
$fullOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($outputFileName)

# Make sure that the input file exists
if (-Not (Test-Path $fullInputPath))
{
	Throw "File $inputFileName does not exist!"
	exit
}
# Remove the output file if it already exists
if (Test-Path $fullOutputPath)
{
	Remove-Item $fullOutputPath
}
try
{
	$reader = [System.IO.File]::OpenText($fullInputPath)
	$writer = New-Object System.IO.StreamWriter($fullOutputPath)
	# Skip over first line since it contains headers
	$currentRecord = 0
	if ($skipFirstRecord)
	{
		$line = $reader.ReadLine()
		Write-Host $skipFirstRecord
		$currentRecord = 1
	}

	for (; $currentRecord -le $records; $currentRecord++)
	{
		$line = $reader.ReadLine()
		if ($null -eq $line)
		{
			break;
		}
		$writer.WriteLine($line);
	}
}
finally
{
	Write-Host "Completed, wrote: $($currentRecord - 1) records to $outputFileName..."
	if ($reader -ne $NULL)
	{
		$reader.Dispose();
	}
	if ($writer -ne $NULL)
	{
		$writer.Dispose();
	}
}
Write-Host $ElapsedTime.Elapsed.ToString()
