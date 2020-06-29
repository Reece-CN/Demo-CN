#######################################
# localcert.ps1                       #
# version : 1.0                       #
#######################################

$checkname = "localcert"
$cfgfile = "C:\Program Files (x86)\BBWin\etc\$checkname.cfg"
$outputfile = "C:\Program Files (x86)\BBWin\tmp\$checkname"
$tmpfile = "C:\Program Files (x86)\BBWin\tmp\$checkname.txt"
$result = "<table border='1' CELLPADDING='5'>`n<tr><th>Subject</th><th>Issuer</th><th>NotBefore</th><th>NotAfter</th><th>Days remaining</th><th>Thresholds</th></tr>`n"
$color = "green"
$warningthresdefault = 30
$criticalthresdefault = 15
$tmpfile

$cfgfilecontent = ""
if (Test-Path $cfgfile) {
    $cfgfilecontent = Get-Content $cfgfile | Where-Object {$_ -notmatch '^$'} | Where-Object { !$_.StartsWith("#") }
}
$currentdate = Get-Date
$certs = Get-ChildItem -Path cert:\LocalMachine\ -recurse | Format-Table
foreach ($cert in $certs) {
    $subject = $cert.Subject
    $issuer = $cert.Issuer
    $notbefore = $cert.NotBefore
    $notafter = $cert.NotAfter
    $thumbprint = $cert.Thumbprint
    $days = 0
    $warningthres = $warningthresdefault
    $criticalthres = $criticalthresdefault
    $tmpcolor = "green"
    $ignore = 0
    foreach ($linecfg in $cfgfilecontent) {
        if ($linecfg -match $thumbprint) {
            if ($linecfg -match "IGNORE") {
                $ignore = 1
            } else {
                $arrayline = $linecfg.split(';')
                if ($arrayline[1] -ne "" -and $arrayline[2] -ne "" -and $arrayline.Count -gt 2) {
                    $warningthres = $arrayline[1]
                    $criticalthres = $arrayline[2]
                }
            } 
        }
    }
    if (($notafter -as [DateTime]) -and ($notafter -as [DateTime])) {
        $notafterdate = Get-date -Date "$notafter"
        $notafterdiff = New-TimeSpan -Start $currentdate -End $notafterdate
        $days = $notafterdiff.Days
        if ($ignore -eq 1) {
            $tmpcolor = "blue"
        } else {
            if ([int]$days -lt [int]$criticalthres) {
                $tmpcolor = "red"
                $color = "red"
            } elseif ([int]$days -lt [int]$warningthres) {
                $tmpcolor = "yellow"
                if ($color -eq "green") {
                    $color = "yellow"
                }
            }
        }
    } else {
        $tmpcolor = "red"
        $color = "red"
        $days = "no date"
    }
    $result += "<tr><td>$subject</td><td>$issuer</td><td>$notbefore</td><td>$notafter</td><td>&$tmpcolor $days</td><td>$warningthres / $criticalthres</td></tr>`n"
}$Coloy
$result += "</table>`n"
$result = "$color+4h $currentdate - $checkname is $color
`n$result"
#$result
$result | Out-File $outputfile -Encoding ASCII
