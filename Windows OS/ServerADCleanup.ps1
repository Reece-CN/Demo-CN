
$DNSZone = "DNSZone"
$servers = (Get-Content "server list path")
$currentdate = (Get-Date -format FileDateTime)
$Outputfile = $currentdate + "-issues.txt"
$DNSserver = "Server.FQDN"


Foreach($server in $Servers){
    Try{
        Remove-ADComputer -Identity $server  -erroraction stop
    }
    Catch{
        $issue += "Not able to remove $Server from AD : `n $_"
    }

    $serverIP = (Resolve-DnsName $server)

    try {
        Remove-DnsServerResourceRecord -computername $DNSserver-zonename $Dnszone -ipaddress $serverIP -rrtype A -erroraction stop
    }
    Catch{
        $issue += "Not able to remove $Server from DNS : `n $_"
    }
}

$issue | Out-File "C:\temp\$outputfile"-Encoding ASCII
