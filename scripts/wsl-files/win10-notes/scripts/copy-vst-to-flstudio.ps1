3
## Used for auto configureing my Win10 after a fresh re-install
#
# Set-ExecutionPolicy RemoteSigned
# Unless you’re running a signed script, make sure you to set the correct execution policy using Set-ExecutionPolicy.

## Copy from a known externl Drive
$sourceDir = 'D:\Software DL\VSTi\myVstBundle'
$userName = $env:username
$destinationDir = "C:\Users\$userName\Documents\Image-Line"

function copyMyVstDir {

	Param ( [string] $sourceDir, [string] $destinationDir )
	
	"attempting to copy files ...
	this will take a moment. just chill :)"

	Copy-Item -Path $sourceDir -Recurse -Destination $destinationDir -Container

	"done. check directory ...

	source directory: $sourceDir
	destination: $destinationDir
	"
}

write-host "Copy my vsts to FL Studio
"

if ( Test-Path -Path $sourceDir -PathType Container ) {

	## copy if both source and destination exists
	if ( Test-Path -Path $destinationDir -PathType Container ) { 
		copyMyVstDir -sourceDir $sourceDir -destinationDir $destinationDir
		
    } else {
        "
		No destination dir: $destinationDir
		attempting to make it
		"
		New-Item -ItemType Directory -Force -Path $destinationDir
		
		if ( Test-Path -Path $destinationDir -PathType Container ) {		
			copyMyVstDir -sourceDir $sourceDir -destinationDir $destinationDir
		} else {
			write-host "No directory to copy to
			$destinationDir
			"
		}
	}

} else {
    "
	No source directory detected: $sourceDir
	"
}

write-host "

Press any key to continue..."
[void][System.Console]::ReadKey($true)
