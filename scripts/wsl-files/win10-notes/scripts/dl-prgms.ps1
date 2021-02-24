# Download some of my daily-ish go-to apps

function desktopApps {
    start "https://www.mozilla.org/en-US/firefox/download/thanks/"
    start "https://www.libreoffice.org/donate/dl/win-x86_64/6.2.5/en-US/LibreOffice_6.2.5_Win_x64.msi"
    start "https://get.videolan.org/vlc/3.0.7.1/win32/vlc-3.0.7.1-win32.exe"
    write-host "
    Paused to prevent overloading your web browser.

    Press any key to continue...
    "
    [void][System.Console]::ReadKey($true)
    start "https://sourceforge.net/projects/dia-installer/files/dia-win32-installer/0.97.2/dia-setup-0.97.2-2-unsigned.exe/download"
    start "https://sourceforge.net/projects/freemind/files/latest/download"
    start "https://www.dotpdn.com/files/paint.net.4.2.install.zip"
}

function appUtils {
    start "https://git-scm.com/download/win"
    start "https://www.7-zip.org/a/7z1900-x64.exe"
}

function texteditorIDEs {
    start "https://code.visualstudio.com/docs/?dv=win"
    start "https://ftp.nluug.nl/pub/vim/pc/gvim81.exe"
    start "https://notepad-plus-plus.org/download/"
}

function developerPlatforms {
    start "https://www.python.org/ftp/python/3.7.4/python-3.7.4.exe"
    start "https://www.python.org/downloads/release/python-2716/"
    start "https://nodejs.org/dist/v10.16.0/node-v10.16.0-x64.msi"
    write-host "
    Paused to prevent overloading your web browser.

    Press any key to continue...
    "
    [void][System.Console]::ReadKey($true)
    start "https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16"
    start "https://osdn.net/projects/mingw/downloads/68260/mingw-get-setup.exe/"
    start "https://cygwin.com/setup-x86_64.exe"
}

function openTabedWebPages {
    # open download pages in a web browser
    
    Clear-Host

    write-host "
    Your default browser is about to blow-up with tabs and download prompts.

    Unless you are on a mobile phone or an oldschool computer, this should not crash your browser.
    Anyway... this is about to happen.

    Press any key to continue..."

    appUtils

    write-host "
    Go to your web browser taps to download suggested apps.

    Press any key to continue with the next wave of popus... "
    [void][System.Console]::ReadKey($true)

    desktopApps

    write-host "
    Go to your web browser taps to download suggested apps.

    Press any key to continue with the next wave of popus... "
    [void][System.Console]::ReadKey($true)

    developerPlatforms

    write-host "
    Go to your web browser taps to download suggested apps.

    Press any key to continue with the next wave of popus... "
    [void][System.Console]::ReadKey($true)

    texteditorIDEs

}

function getPipLibraries {
    write-host ""
    
    $confirmation = Read-Host "Do you want to install Python pip libraries at this time:"
    if ($confirmation -eq 'y') {
        $p = &{python -V} 2>&1
        $version = if($p -is [System.Management.Automation.ErrorRecord]) {
            # grab the version string from the error message
            $p.Exception.Message
        }  else {
            # otherwise return as is
            $p
            pip install --upgrade pip
            python -m pip install windows-curses
            python -m pip install pylint
        }
    }
}

openTabedWebPages
getPipLibraries

write-host "
Done.

Press any key to continue..."
[void][System.Console]::ReadKey($true)
