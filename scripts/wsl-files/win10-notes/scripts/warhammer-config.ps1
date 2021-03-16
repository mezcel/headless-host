<#
    Warhammer 40K: Soulstorm Mods (Tested in Winter 2021)

    Enable Poswershell Script: 
    Current instance only:  "Set-ExecutionPolicy Bypass -Scope Process -Force"
    Current User:           "Set-ExecutionPolicy Bypass -Scope CurrentUser -Force"
    Current Machine:        "Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force"

    Mod Homepages:
    * Ultimate Appocalypse: https://www.moddb.com/mods/ultimate-apocalypse-mod
                            https://www.mediafire.com/file/kuivpyohwhacm0m/Ultimate_Apocalypse_1.89_Full_-_Unpack_&_Play.rar/file
    * Unification Mod:      https://www.moddb.com/mods/unification-mod-dawn-of-war-soulstorm/
    * Dark Prophecy:        https://www.gamefront.com/games/dawn-of-war-soulstorm/file/dark-prophecy-0-4-8
                            https://www.gamefront.com/games/dawn-of-war-soulstorm/file/dark-prophecy
    * Tyranids:             https://www.moddb.com/mods/tyranid-mod/downloads/tyranid-mod-v05b2-for-soulstorm
                            https://www.moddb.com/mods/tyranid-mod/downloads/tyranid-mod-v05b3
    * Chaos Daemons:        https://www.moddb.com/mods/daemons-mod/
    * FreeUI:               https://www.moddb.com/mods/unification-mod-dawn-of-war-soulstorm/downloads/freeui
    * objective_points_SS:  https://www.moddb.com/mods/unification-mod-dawn-of-war-soulstorm/downloads/objective-points-ss-v1742020-for-dowdc-and-dowss

    ## Conflicts:
        You can add UM to DA, but not the other way arround
        Tyranids v0.5.2 works on UA but not UM
        Tyranids v0.5.3 works on UM but not UA

    ## Personalized Race Hacks: *.ai (Lua script)
        Manually edit unit stats. I like to make the dreadnoughts, basic grey knights, and rhinos more durable.
        C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\UltimateApocalypse_THB\data\ai\races\<YOUR_RACE>\
        C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\Unification_Bugfix\Data\ai\races\<YOUR_RACE>\
#>

function InitializeGlobalVariables {
    ## Declare file path variable in an object
    
    ## Steam Soulstorm directory
    $global:SSPaths = [PSCustomObject] @{
        Tyranids = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\Tyranids"
        Tyranids_Art = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\Tyranids_Art"
        Tyranids_module = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\Tyranids.module"
        Tyranids_Art_module = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\Tyranids_Art.module"
        Tyranid_Mod_Uninstall = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\Tyranid_Mod-Uninstall.exe"
        TyranidsUninstall = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\TyranidsUninstall.exe"
        SteamName = "steam"
        SteamExe = "C:\Program Files (x86)\Steam\Steam.exe"
        SoulstormName = "soulstorm"
        SoulstormExe = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\Soulstorm.exe"
        AiUa = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\UltimateApocalypse_THB\data\ai\races\"
        AiUm = "C:\Program Files (x86)\Steam\steamapps\common\Dawn of War Soulstorm\Unification_Bugfix\Data\ai\races\"
    }

    ## My external storage containing Soulstorm mods
    $global:DefaultModPaths = [PSCustomObject] @{
        Tyranid_Mod_0_5b2 = "D:\Software DL\DOW Soulstorm MOD\Additional-Races\Race-Executables\Tyranid_Mod_0.5b2_Installer.exe"
        Tyranid_Mod_0_5b3 = "D:\Software DL\DOW Soulstorm MOD\Additional-Races\Race-Executables\Tyranid_Mod_v0.5b3.exe"
    }
}

function EditSourcePath {

    [bool] $isTyranid_Mod_0_5b2 = IsPath $DefaultModPaths.Tyranid_Mod_0_5b2
    [bool] $isTyranid_Mod_0_5b3 = IsPath $DefaultModPaths.Tyranid_Mod_0_5b3

    if ( !$isTyranid_Mod_0_5b2 -and !$isTyranid_Mod_0_5b3 ) {
        
        Write-Host " ## Modify Tyranid Mod installer path" -ForegroundColor Blue 
        Write-Host "`tDefault directory set by script:"
        Write-Host "`t- Tyranid_Mod_0.5b2_Installer.exe`n`t"$DefaultModPaths.Tyranid_Mod_0_5b2""
        Write-Host "`t- Tyranid_Mod_v0.5b3.exe`n`t"$DefaultModPaths.Tyranid_Mod_0_5b3""
        Write-Host ""

        [string] $promptString = " Enter the parent directory path for Tyranid_Mod_0.5b2_Installer.exe"
        [string] $parentTyranid_Mod_0_5b2 = Read-Host -Prompt $promptString
        #$parentTyranid_Mod_0_5b2 = "D:\Software DL\DOW Soulstorm MOD\Additional-Races\Race-Executables"

        $promptString = " Enter the parent directory path for Tyranid_Mod_v0.5b3.exe`n`t[ $parentTyranid_Mod_0_5b2 ]"
        [string] $parentTyranid_Mod_0_5b3 = Read-Host -Prompt $promptString
        #$parentTyranid_Mod_0_5b3 = "D:\Software DL\DOW Soulstorm MOD\Additional-Races\Race-Executables"

        # Redefine variables
        $DefaultModPaths.Tyranid_Mod_0_5b2 = "$parentTyranid_Mod_0_5b2\Tyranid_Mod_0.5b2_Installer.exe"
        $DefaultModPaths.Tyranid_Mod_0_5b3 = "$parentTyranid_Mod_0_5b3\Tyranid_Mod_v0.5b3.exe"
        
        Write-Host ""

        Remove-Variable -Name parentTyranid_Mod_0_5b2
        Remove-Variable -Name parentTyranid_Mod_0_5b3
    }

    Remove-Variable -Name isTyranid_Mod_0_5b2
    Remove-Variable -Name isTyranid_Mod_0_5b3
}

function About {

    [bool] $isSteam = Test-Path $SSPaths.SteamExe
    [bool] $isSS = Test-Path $SSPaths.SoulstormExe
    [bool] $is5_2 = Test-Path $DefaultModPaths.Tyranid_Mod_0_5b2
    [bool] $is5_3 = Test-Path $DefaultModPaths.Tyranid_Mod_0_5b3

    Write-Host "---" -ForegroundColor Magenta 
    Write-Host " ## About" -ForegroundColor Blue 
    Write-Host "    This is a script used to automate the Install/Uninstall configuration of the Tyranids Mod for `"Warhammer 40,000: Soulstorm`"." -ForegroundColor Magenta 
    Write-Host "    Existing versions of the Tyrandids mod will be uninstalled before installing a Tyranid mod." -ForegroundColor Magenta 
    Write-Host " ## Dependencies:" -ForegroundColor Blue 
    
    ## Flag true flase
    if ( !$isSteam -or !$isSS ) {
        Write-Host "    Install necessary programs." -ForegroundColor DarkYellow 
    } else {
        Write-Host "    Steam dependency satisfied." -ForegroundColor DarkYellow 

    }

    Write-Host "    This script assume you have both Steam [$isSteam], and `"Warhammer 40,000: Soulstorm`" [$isSS], installed." -ForegroundColor Magenta 
    Write-Host "    This script assume you have the Tyranid Mod installer." -ForegroundColor Magenta 
    Write-Host "        [$is5_2] "$DefaultModPaths.Tyranid_Mod_0_5b2"" -ForegroundColor Magenta 
    Write-Host "        [$is5_3] "$DefaultModPaths.Tyranid_Mod_0_5b3"" -ForegroundColor Magenta 
    
    ## Flag true flase
    if ( !$is5_2 -or !$is5_3 ) {
        Write-Host "    Modify file paths as necessary." -ForegroundColor DarkYellow 
    } else {
        Write-Host "    Tyranid dependency satisfied." -ForegroundColor DarkYellow 

    }

    Write-Host "---" -ForegroundColor Magenta 
    Write-Host ""

    Remove-Variable -Name isSteam
    Remove-Variable -Name isSS
    Remove-Variable -Name is5_2
    Remove-Variable -Name is5_3
}

function IsPath {
    param  ( [string] $dirPath )
	
	[bool] $isDir = $false

	if ( $dirPath ) {
		$isDir = Test-Path "$dirPath"
	} else {
		Write-Host "Path does `"$dirPath`" not exist." -ForegroundColor Red
	}
 
    return $isDir
}

<# Lanuch *.exe file #>
function RunExecutable {	
    param ( [string] $ExePath )

    [bool] $isFile = IsPath $ExePath
    if ( $isFile -eq $true ) {
        Write-Host " Launch $ExePath" -ForegroundColor Cyan

        Write-Host ""
        Start-Process -wait $ExePath -ErrorVariable ErrorFlag -ErrorAction SilentlyContinue -Verb RunAs

        ## Quit installer is installer was canceld by user or there was an administator privalege block.
        if ( $ErrorFlag ) {
            Write-Host "Canceled Tyranid modification because you aborted the following executable." -BackgroundColor Red -ForegroundColor Black
            Write-Host "  $ExePath" -BackgroundColor Red -ForegroundColor Black
            Exit
        }

    } else {
        Write-Host ""
        Write-Host " Can't launch $ExePath`n`tFile path does not exist.`n" -ForegroundColor Red
    }
    
    Write-Host " 3 sec. pause ...`n" -ForegroundColor Blue
    Start-Sleep 3

    Remove-Variable -Name isFile
}

function MenuPrompt {

    ## Is the tyranids mod installed
    [bool] $isTyranids = IsPath $SSPaths.Tyranids
    [bool] $isTyranids_Art = IsPath $SSPaths.Tyranids_Art

    if ( $isTyranids_Art ) {
        Write-Host " Tyranid_Mod_v0.5b3 is installed.`n`tCurrently UM compatible, yet not UA compatible.`n" -ForegroundColor Green
        [string] $defaulAnswer = "1"
    } elseif ( $isTyranids ) {
        Write-Host " Tyranid_Mod_v0.5b2 is installed.`n`tCurrently UA compatible, yet not UM compatible.`n" -ForegroundColor Green
        [string] $defaulAnswer = "2"
    } else {
        Write-Host "The Tyranid Mod is not installed.`n" -ForegroundColor Red
        [string] $defaulAnswer = "1"
    }

    [string] $promptString = " Select modification option:`n  1.`t`tInstall Tyranid_Mod_v0.5b2 [UA]`n  2.`t`tInstall Tyranid_Mod_v0.5b3 [UM]`n  edit.`t`tOpen race *.ai Lua for editing.`n  no.`t`tCancel installer`n`n Enter selection value ( 1, 2, edit, no ) [ default = $defaulAnswer ]"

    ## Prompt to switch tyranid installation    
	$promptAnswer = Read-Host -Prompt "$promptString"

    if ( $promptAnswer -eq "" ) {
        $promptAnswer = $defaulAnswer.Substring(0, 1).ToLower()
    } else {
        $promptAnswer = $promptAnswer.Substring(0, 1).ToLower()
    }

    Write-Host ""
    
    Remove-Variable -Name isTyranids
    Remove-Variable -Name isTyranids_Art
    Remove-Variable -Name defaulAnswer
    Remove-Variable -Name promptString

    return $promptAnswer
}

function TerminateSoulstorm {
    param ( [string] $processName )

    $runningProcess = Get-Process -Name "$processName" -ErrorAction SilentlyContinue

    if ( $runningProcess ) {
        $runningProcess.CloseMainWindow()
        
        Write-Host " 3 sec. pause ...`n" -ForegroundColor Blue
        Start-Sleep 3
    }

    if ( !$runningProcess.HasExited ) {
        $runningProcess | Stop-Process -Force
    } else {
        Write-Host " Killed $processName ..." -ForegroundColor Yellow
    }

    Remove-Variable -Name runningProcess
}

function OpenLuaDir {
    
    [bool] $isTyranids = IsPath $SSPaths.Tyranids
    [bool] $isTyranids_Art = IsPath $SSPaths.Tyranids_Art

    if ( $isTyranids_Art ) {
        Write-Host " Opening Lua script directory for UM." -ForegroundColor Black -BackgroundColor Cyan
        Invoke-Item $SSPaths.AiUm
    } elseif ( $isTyranids ) {
        Write-Host " Opening Lua script directory for UA." -ForegroundColor Black -BackgroundColor Cyan
        Invoke-Item $SSPaths.AiUa
    } else {
        Write-Host " Missing Tyranid dependencies for both UA and UM." -Red
    }

    Remove-Variable -Name isTyranids
    Remove-Variable -Name isTyranids_Art
}

function IsTyranidRemoved {
    # Confirm deletion of old Tyranic mod
    [bool] $isTyranids = IsPath $SSPaths.Tyranids
    [bool] $isTyranids_Art = IsPath $SSPaths.Tyranids_Art
    [bool] $isTyranids_Art_module = IsPath $SSPaths.Tyranids_Art_module

    if ( $isTyranids -or $isTyranids_Art -or $isTyranids_Art_module ) {
        Write-Host " Previous Tyranids files still exist in Soulstorm directory.`n" -ForegroundColor Red
        [bool] $IsRemoved = $false
    } else {
        Write-Host " No Tyranid Mod in Soulstorm directory.`n" -ForegroundColor Green
        [bool] $IsRemoved = $true

    }

    Remove-Variable -Name isTyranids
    Remove-Variable -Name isTyranids_Art
    Remove-Variable -Name isTyranids_Art_module
    
    Return $IsRemoved
}

function InstallTyrandsUM {

    [string] $installPath = $DefaultModPaths.Tyranid_Mod_0_5b3

    ## Terminate Steam Game
    TerminateSoulstorm $SSPaths.SoulstormName
    TerminateSoulstorm $SSPaths.SteamName

    # Uninstall
    Write-Host " Uninstalling Tyranids" -BackgroundColor Yellow -ForegroundColor Black
    RunExecutable $SSPaths.Tyranid_Mod_Uninstall
    RunExecutable $SSPaths.TyranidsUninstall

    # Confirm deletion of old Tyranic mod
    [bool] $isUninstalled = IsTyranidRemoved

    # Install Tyranid_Mod_v0.5b3
    if ( $isUninstalled ) {
        [string] $installPath = $DefaultModPaths.Tyranid_Mod_0_5b3
        Write-Host " Installing Tyranids > $installPath" -BackgroundColor Green -ForegroundColor Black
        RunExecutable "$installPath"
    } else {
        Write-Host " Script aborted.`n`tPrevious Tryanid files still exist in Soulstorm directory." -BackgroundColor Red -ForegroundColor White
    }

    Remove-Variable -Name installPath
    Remove-Variable -Name isUninstalled
}

function InstallTyrandsUA {
    [string] $installPath = $DefaultModPaths.Tyranid_Mod_0_5b2

    ## Terminate Steam Game
    TerminateSoulstorm $SSPaths.SoulstormName
    TerminateSoulstorm $SSPaths.SteamName

    # Uninstall
    Write-Host " Uninstalling Tyranids" -BackgroundColor Yellow -ForegroundColor Black
    RunExecutable $SSPaths.Tyranid_Mod_Uninstall
    RunExecutable $SSPaths.TyranidsUninstall
    
    # Confirm deletion of old Tyranic mod
    [bool] $isUninstalled = IsTyranidRemoved

    # Install Tyranid_Mod_v0.5b2
    if ( $isUninstalled ) {
        Write-Host " Installing Tyranids > $installPath" -BackgroundColor Green -ForegroundColor Black
        RunExecutable "$installPath"
    } else {
        Write-Host " Script aborted.`n`tPrevious Tryanid files still exist in Soulstorm directory." -BackgroundColor Red -ForegroundColor White
    }

    Remove-Variable -Name installPath
    Remove-Variable -Name isUninstalled
}

<# Main() #>
function Main {
    Clear-Host

    # Declare global file path variables
    InitializeGlobalVariables

    # Display about message
    About

    # Edit Tyranid installer path if necessary
    EditSourcePath

    ## Menu Prompt Input
    $promptAnswer = MenuPrompt

    ## Perform menu option
    switch ( $promptAnswer ) {
        1 { # Install Tyranid_Mod_v0.5b2
            InstallTyrandsUA }

        2 { # Install Tyranid_Mod_v0.5b3
            InstallTyrandsUM }

        "e" { # Open Lua *.ai directory
            OpenLuaDir }

        default { # Cancel
            Write-Host " Canceled Tyranid modification." -ForegroundColor Red }
    }

    Write-Host "`n Done.`n" -ForegroundColor DarkYellow
}

<# Run #>
Main