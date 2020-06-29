#######################################
# FileServer.ps1                      #
# version : 0.2                       #
#######################################
<#
Author: Reece McDowell
Scope: This was created to check the availability of files servers  
#>
$checkname = "fileserver"
$cfgfile = "C:\Program Files (x86)\BBWin\etc\$checkname.cfg"
$outputfile = "C:\Program Files (x86)\BBWin\tmp\$checkname"
$result = "<table border='1' CELLPADDING='5'>`n<tr><th>Sever Name</th><th>Details</th><th>Status</th></tr>`n"
$color = "green"
$currentdate = Get-Date
$issue = ""
Function Get-Bits(){
    Switch ([System.Runtime.InterOpServices.Marshal]::SizeOf([System.IntPtr]::Zero)) {
        4 {
            Return "32-bit"
        }

        8 {
            Return "64-bit"
        }

        default {
            Return "Unknown Type"
        }
    }
}
$bit = (Get-Bits)
Try{
Import-Module FailoverClusters -ErrorAction Stop
}
Catch {
$tmpcolor = "red"
    $issue = "$bit : Not able to import cmdelts : `n $_"
    if ($color -eq "green") {
        $color = "Red"
    $result += "<tr><td>$Env:COMPUTERNAME</td><td>$issue</td><td>$tmpcolor</td></tr>`n"
    $failure = $true
    }
}


Try{Get-ClusterResource | Where-Object ResourceType -eq 'File server'
}
catch {
    $tmpcolor = "red"
    $issue = "Not able to get cluster details on $server : `n $_"
    if ($color -eq "green") {
        $color = "Red"
    $result += "<tr><td>$Env:COMPUTERNAME</td><td>$issue</td><td>$tmpcolor</td></tr>`n"
    $failure = $true
    }
}
$fileserverdetails = (Get-ClusterResource | Where-Object ResourceType -eq 'File server')
$Resourcename = ($fileservicedetails.name)
$Resroucestate = ($fileserverdetails.state)
if ($Resroucestate -eq "Online" ){
    $tmpcolor = "green"
    $issue = "No issue, resource $Resourcename is $Resroucestate"
    $color = "green"
    $result += "<tr><td>$Env:COMPUTERNAME</td><td>$issue</td><td>$tmpcolor</td></tr>`n"
}
elseif ($failure -eq $false){
    $issue = "possibly offline, resource $Resourcename is $Resroucestate"
    if ($color -eq "green") {
        $color = "Red"
        }
    $tmpcolor = "Red"
    $result += "<tr><td>$Env:COMPUTERNAME</td><td>$issue</td><td>$tmpcolor</td></tr>`n"
}

$result += "</table>`n"
$result = "$color $currentdate - $checkname is $color
`n$result"
$result | Out-File $outputfile -Encoding ASCII