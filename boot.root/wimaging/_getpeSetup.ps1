## START 

# warning: this script has been written by a complete moron.
## Disable the firewall
Wpeutil disablefirewall

## Set the path of curl (GPL distribuited)
$curlex="x:\windows\system32\curl.exe"
$options="--silent --connect-timeout 5"
$curl="$curlex $options"
Start-Sleep -s 30
$nets=$(Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.DHCPEnabled -eq $true -and $_.DHCPServer -ne $null})
$nets | ForEach-Object {
	$mac=$($_.macaddress  -replace ":", "-").Tolower()
	$foremanproxy=$_.DHCPServer
	Test-Connection $foremanproxy -Count 5
	$URL='tftp://' + $foremanproxy + '/pxelinux.cfg/01-' + $mac
	$cmdline=$(echo "$curl $URL -o pxeconf.tmp")
	echo "Processing $mac"
	invoke-Expression -Command:$cmdline;	$res=$lastexitcode
	
	if ($res -eq 0) {
		echo "allora tiro fuori il file di configurazione"
		$URL=$($(cat .\pxeconf.tmp|findstr.exe URL) -replace '.# URL=','' -replace ' ','')
		echo $URL
		$cmdline=$(echo "$curl $URL -o peSetup.cmd")
		invoke-Expression -Command:$cmdline;	$res=$lastexitcode
		if ($res -eq 0) {
			echo "Found the configuration on interface $mac for $URL"
			exit 0
		}
	} else {
		echo "MAC:${mac} exit code:${res}. Proceeding with next interface."
	}

}
echo "CRITICAL: No configuration found refusing to continue  Reboot in 5min"
Start-Sleep -s 300
Wpeutil Reboot
exit 100

## END
