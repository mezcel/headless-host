Clear-History

## Stop-Process -name firefox
$ff = Get-Process 'WindowsTerminal' -ErrorAction SilentlyContinue
if ( $ff ) {
	Write-Host "Closing firefox" -ForegroundColor Magenta
	## try to close gracefully first
	$ff.CloseMainWindow()

	## Redundant retry
	Start-Sleep 5
	if ( !$ff.HasExited ) {
		$ff | Stop-Process -Force
	}
}

Remove-Variable ff

## Shutdown Win10	
Stop-Computer