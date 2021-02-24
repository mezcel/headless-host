<#
    interface_con.ps1

    About: 
        Turn on wifi and connect to an SSID for internet.
        Or Turn off wifi
    Git: 
        https://gist.github.com/mezcel/34895a5ae768873a26e762e068394a84#file-interface_con-ps1
#>

function testPing {
    $pingAddr = "google.com"
    Write-Host "`nPinging $pingAddr ...`n" -ForegroundColor Cyan
    $pingPass = Test-Connection -ComputerName $pingAddr -Count 3 -Quiet
    
    if ( $pingPass ) {
        Write-Host " Ping Pass`n" -ForegroundColor Green
    } else {
        Write-Host " Ping Fail`n" -ForegroundColor Red
    }

    return $pingPass
}

function connman {

    Write-Host "Activating the Wi-Fi Network Adapter ..." -ForegroundColor Cyan
    Enable-NetAdapter -Name "Wi-Fi" -Confirm:$false
    
    ## grep and select a deteted ssid    
    Write-Host "`nAvailable SSID's:`n" -ForegroundColor DarkYellow
    $ssidList = netsh wlan show network | Select-String "SSID"
    $listLength = $ssidList.length
    
    for ($i=1; $i -le $listLength; $i++) {
        Write-Host $ssidList[$i-1]  -ForegroundColor Yellow
    }

    $idx = Read-Host "`nSelect an SSID No [ 1 - $listLength ] "
    $idx=$idx-1

    $selectedSsid = $ssidList[$idx]
    $selectedSsid = ($selectedSsid -split ": ")[1]

    Write-Host "`nYou selected: $selectedSsid" -ForegroundColor Green
    Write-Host " Connecting ...`n" -ForegroundColor Cyan
    
    netsh wlan connect name=$selectedSsid
    testPing
}

function greeting {
    Write-Host "`nConnect or disconnect to/from Wifi internet."
}

function main {
    greeting

    $testNet = testPing
    if ( $testNet -ne "True" ) {
        ## connect
        connman
    } else {
        Write-Host "You are connected to wifi internet." -ForegroundColor DarkYellow
        $yn = Read-Host "Disconnect from wifi? [ y/N ]"
    
        if ( $yn -eq "y" ) {
            ## disconnect
            netsh wlan disconnect interface="Wi-Fi"
            Disable-NetAdapter -Name "Wi-Fi" -Confirm:$false

            Write-Host "Wi-fi should be off now.`n" -ForegroundColor Green
        } else {
            Write-Host "You entered $yn, nothing will be done.`n" -ForegroundColor Red
        }
    }
}

##############
## Run
##############

main