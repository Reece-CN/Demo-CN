
$hostname = $env:computername
$Readhost = Read-Host "The name of this computer is $hostname. Would you like to change it? ( y / n )" 
Switch ($ReadHost) 
{ 
    Y { 
    $newname = Read-Host "Please enter the computers new name"
    Rename-Computer -NewName "$newname" 
    write-host "Please restart the device, Press any key to exit"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")|out-null
    Exit
    } 
    N { break } 
    Default { "break" }
}

Get-DnsClient | Format-List | Write-Output
$hostname = $env:computername
$Interfaceindex = Read-Host "Please select an interface indedx form the list displayed"
$DnsServers1 = read-host "Please enter primary DNS servers IP address"
$DnsServers2 = read-host "Please enter secondary DNS servers IP address"
$domain = Read-Host "Please enter full domain name"
if (Test-Connection -ComputerName $DnsServers1, $DnsServers2 -Count 1 -ErrorAction SilentlyContinue) {
    try {
    Write-Host "Setting DNS servers for computer"
    Set-DnsClientServerAddress -InterfaceIndex $Interfaceindex -ServerAddresses ($DnsServers1, $DnsServers2) 
    Write-Host "Trying to add Device to domain $domain"
        try{
            Add-Computer -DomainName $domain -PassThru -Verbose
            Write-Host "$hostname has been added to $domain. Please move the device to the correct OU. Press any key to exit"
            $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")|out-null 
        }
        catch{
            $errorMessage = $_.Exception.Message
            Write-Output $errorMessage
            } 
    }
    catch {
    $errorMessage = $_.Exception.Message
        Write-Output $errorMessage
    } 
} else {
    write-error "Dns servers are not reachable, Not able to add DNS servers."
}
