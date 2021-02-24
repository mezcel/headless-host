#
# copy soulstrom mods to steam
#

## check if path exists
function isPathExist  {

    Param ( [string] $dirString )

    if ( Test-Path -Path $dirString -PathType Container ) {
        return $true
    } else {
        return $false
    }
}

function copyMods {

    Param ( [string] $sourceDir, [string] $destinationDir )
    
    $isSourcePath = isPathExist -dirString $sourceDir
    $isDestinationPath = isPathExist -dirString $destinationDir

    if ( ([boolean] $isSourcePath) -and ([boolean] $isDestinationPath) ) {
        write-host "
            copying files within $sourceDir to $destinationDir
            please wait ...
            "

        Copy-Item $sourceDir\* $destinationDir

        write-host "
            Done.
            "

    } else {
        if ($isSourcePath -ne $true) {
            write-host "
            source dir does not exist
                $sourceDir
            "
        }
        if ($destinationDir -ne $true) {
            write-host "
            destination dir does not exist
                $destinationDir
            "
        }
    }

}

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

## source directory path variables

$steamRootDir = 'C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm'
$steamMapsDir = "$steamRootDir\DXP2\Data\Scenarios\mp"
$mezcelDownloads = "~\Downloads"

## destination dir paths
$sourceSoulstormRoot = 'D:\Software DL\DOW Soulstorm MOD'
$extrtactedRacesDir = "$sourceSoulstormRoot\Additional-Races\Extracted-Races-Curated"
$executableRacesDir = "$sourceSoulstormRoot\Additional Race\Compressed-Races"
$mapAddons = "$sourceSoulstormRoot\Addons\Maps-Curated"

Clear-Host

copyMods -sourceDir $extrtactedRacesDir -destinationDir $steamRootDir
copyMods -sourceDir $mapAddons -destinationDir $steamMapsDir
copyMods -sourceDir $executableRacesDir -destinationDir $mezcelDownloads

performEXE -sourceFile "$mezcelDownloads\Steel Legions 1.00.00 Final For Soulstorm.exe"
performEXE -sourceFile "$mezcelDownloads\The_Dance_Macabre_Public_Beta_1.exe"
performEXE -sourceFile "$mezcelDownloads\RAGE2.exe"
performEXE -sourceFile "$mezcelDownloads\DOW_SS_Salamanders_mod_1_1.exe"
performEXE -sourceFile "$mezcelDownloads\Black_Templars_Kaurava_Crusade_beta-5.exe"

write-host "
Press any key to continue..."
[void][System.Console]::ReadKey($true)
