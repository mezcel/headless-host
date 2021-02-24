## Run installation executables from a known Vst Directory

## Generic standard location
$userName = $env:username
$sourceDir = "C:\Users\$userName\Documents\Image-Line\myVstBundle"

write-host "Installing vsts
"

function performEXE {

	Param ( [string] $sourceFile )

	## if file exists, then do the do
	if ( Test-Path -Path $sourceFile -PathType Leaf ) {
		write-host "installing $sourceFile ..."
		
		Start-Process -FilePath $sourceFile
		
		write-host "
		Starting installation of: $sourceFile
		
		Press any key to continue..."
		[void][System.Console]::ReadKey($true)
	} else {
		write-host "	could not find the file: $sourceFile"
	}

}

if ( Test-Path -Path $sourceDir -PathType Container ) {

	$sourceFile = "$sourceDir\iZotope_Vinyl_v1_80.exe"
	performEXE -sourceFile $sourceFile
	
	$sourceFile = "$sourceDir\Bark_of_Dog_1.2.1_Windows.exe"
	performEXE -sourceFile $sourceFile
	
	$sourceFile = "$sourceDir\BlueCatFreqAnalystVST-x64Setup.exe"
	performEXE -sourceFile $sourceFile
	
} else { 

	write-host "Did not find dir: $sourceDir
	nothing was installed
	"
}

write-host "
Done.

Press any key to continue..."
[void][System.Console]::ReadKey($true)