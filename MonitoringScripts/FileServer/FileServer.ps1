#######################################
# FileServer.ps1                      #
# version : 0.1                       #
#######################################
<#
Author: Reece McDowell
Scope: This was created to check the availability of files servers  
#>
$checkname = "fileserver"
$cfgfile = "C:\Program Files (x86)\BBWin\etc\$checkname.cfg"
$outputfile = "C:\Program Files (x86)\BBWin\tmp\$checkname"
$tmpfile = "C:\Program Files (x86)\BBWin\tmp\$checkname.txt"
$result = "<table border='1' CELLPADDING='5'>`n<tr><th>Sever Name</th><th>Details</th><th>Status</th></tr>`n"
$color = "green"
$currentdate = Get-Date
$testfile = "C$\Program Files (x86)\BBWin\Licence.txt"
$issue = ""

$cfgfilecontent = ""
if (Test-Path $cfgfile) {
    $cfgfilecontent = Get-Content $cfgfile | Where-Object {$_ -notmatch '^$'} | Where-Object { !$_.StartsWith("#") } | Where-Object { $_ -notmatch $env:COMPUTERNAME }
}

ForEach ($server in $cfgfilecontent) {
    $tmpcolor = "green"
    $issue = "no issues"
    if (Test-Connection $server ) {
        try {
            $test = (Get-Content -Path "\\$server\$testfile" -ErrorAction Stop )
        }
        catch {
            $tmpcolor = "red"
            $issue = "Not able to get reach $testfile on $server : `n $_"
            if ($color -eq "green") {
                $color = "Red"
            }
        }
        
    } else {
        $tmpcolor = "red"
        $issue = "Not able to connect to $server"
        if ($color -eq "green") {
            $color = "Red"
        }
    }
    $result += "<tr><td>$server</td><td>$issue</td><td>$tmpcolor</td></tr>`n"
}
$result += "</table>`n"
$result = "$color $currentdate - $checkname is $color
`n$result"
$result | Out-File $outputfile -Encoding ASCII