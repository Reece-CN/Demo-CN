#######################################
# adconnect.ps1                      #
# version : 0.1                       #
#######################################
<#
Author: Reece McDowell
Scope: This was created to check the availability of adconnect  
#>
$checkname = "adconnect"
$outputfile = "C:\temp\$checkname.html"
$tmpfile = "C:\Program Files (x86)\BBWin\tmp\$checkname.txt"
$result = "<table border='1' CELLPADDING='5'>`n<tr><th>Connector name</th><th>Details</th><th>Status</th></tr>`n"
$color = "green"
$currentdate = Get-Date
$issue = ""


$connectors = @(Get-ADSyncConnector).name
foreach ($connector in $connectors){
    $Connectordetails = (Get-ADSyncRunProfileResult | Where-Object connectorName -eq $connector | Select-Object -last 1)
    $ConLastconnection = $Connectordetails.enddate
    $ConResults = $Connectordetails.result
    $ConName = $Connectordetails.connectorName
    $tmpcolor = "green"
    $issue = "no issues"
    if ($null -eq $ConLastconnection){
        $tmpcolor = "Yellow"
        $issue = "Not able to get Sync Details"
        if ($color -eq "green") {
            $color = "Yellow"
    }
    elseif ($ConLastconnection -lt $currentdate.addhours(-24)){
            $tmpcolor = "red"
            $issue = "Last sync result was more then 24 hours ago : $conLastconnection"
        if ($color -eq "green") {
            $color = "Red"
        }
    }
    }
    $result += "<tr><td>$conName</td><td>$issue</td><td>$tmpcolor</td></tr>`n"
}

$result += "</table>`n"
$result = "$color $currentdate - $checkname is $color
`n$result"
$result | Out-File $outputfile -Encoding ASCII