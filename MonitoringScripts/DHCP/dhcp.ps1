#######################################
# adconnect.ps1                      #
# version : 0.1                       #
#######################################
<#
Author: Reece McDowell
Scope: This was created to check the availability of adconnect  
#>

$checkname = "DHCP"
$cfgfile = "C:\Program Files (x86)\BBWin\etc\$checkname\"
$outputfile = "C:\Program Files (x86)\BBWin\tmp\$checkname"
$tmpfile = "C:\Program Files (x86)\BBWin\tmp\$checkname.txt"
$result = "<table border='1' CELLPADDING='5'>`n<tr><th>Time Created</th><th>Event ID</th><th>Event Message</th><th>alert reason</th><th>Alert Color</tr>`n"
$color = "green"
$currentdate = Get-Date
$issue = ""

$Logname = "Microsoft-Windows-Dhcp-Client/Admin"

$yellowcfg = $cfgfile + 'yellow.txt'
$Yellow = @(Get-Content $yellowcfg)
$Redcfg = $cfgfile + 'red.txt'
$Red = @(Get-Content $Redcfg)

foreach ($y in $Yellow){
    $TempEventYellow = Get-winevent -LogName $Logname | where-object  ID -eq $y 
        foreach ($eventY in $TempEventYellow){
            If ($null -ne $event){
                $ID = $Event.ID
                $Message = $Event.Message
                $Time = $Event.TimeCreated
                $tmpcolor = "yellow"
                $issue = "Possible issue with DHCP due to event $y"
                $result += "<tr><td>$Time</td><td>$ID</td><td>$message</td><td>$issue</td><td>$tmpcolor</td></tr>`n"
                $YAlertCheck = "true"
                if ($color -eq "green") {
                    $color = "yellow"
                }
            }
        }
    }
if ($null -eq $YAlertCheck){
    $tmpcolor = "green"
    $result += "<tr><td>Null</td><td>Null</td><td>Null</td><td>No warning events found</td><td>$tmpcolor</td></tr>`n"
}

foreach ($r in $Red){
    $TempEventRed = Get-winevent -LogName $Logname | Where-Object ID -eq $r
        foreach ($eventR in $TempEventRed){
            If ($null -ne $eventr){
                $ID = $eventR.ID
                $Message = $eventR.Message
                $Time = $Eventr.TimeCreated
                $tmpcolor = "red"
                $issue = "Possible issue with DHCP due to event $y"
                $result += "<tr><td>$Time</td><td>$ID</td><td>$message</td><td>$issue</td><td>$tmpcolor</td></tr>`n"
                $RAlertCheck = "true"
                if ($color -eq "green") {
                    $color = "red"
                }
                elseif ($color -eq "yellow"){
                    $color = "red"
                }
            }
        }
}
if ($null -eq $RAlertCheck){
    $tmpcolor = "green"
    $result += "<tr><td>Null</td><td>Null</td><td>Null</td><td>No critical events found</td><td>$tmpcolor</td></tr>`n"
}

$result += "</table>`n"
$result = "$color $currentdate - $checkname is $color
`n$result 
`n
`n To remove alarm for event, Delete the event from $Logname"
$result | Out-File $outputfile -Encoding ASCII