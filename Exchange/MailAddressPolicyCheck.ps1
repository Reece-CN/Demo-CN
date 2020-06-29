
$ExSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://URGCCOREEXC001.gccore.getronicscore.com/PowerShell/ -Authentication NegotiateWithImplicitCredential
Import-PSSession $ExSession -DisableNameChecking

#Gets current mailboxes that have no address book policy and exports to CSV
Get-Mailbox -ResultSize Unlimited | Where-Object {$_.AddressBookPolicy -eq $Null} | Select-Object name | export-csv -Path C:\Temp\Current-list.csv
$Currentlist = Get-Content C:\Temp\Current-list.csv

#Approved list of mailboxes Manually written
$list = Get-Content C:\Temp\allowedlist.csv

#compares approved list and the current list and looks for items that are unapproved. 
$ProblemMailboxes = $Currentlist | Where-Object {$list -notcontains $_}

$HouseKeeping = "UKWindows.Housekeeping@Getronics.com"
$GetronicsSD = "service.desk@getronics.com"
$smtpServer = "URGCCOREEXC001.gccore.getronicscore.com"
$from = "Stask@getronicscore.com"
$textEncoding =[System.Text.Encoding]::UTF8

#details for no ticket needing logged
$noticket_emailaddress = $HouseKeeping
$noticket_subject = "GCCORE addressbook policy check"
$noticket_body ="
<font face=""verdana"">
Intednded for Wintel Houskeeping,
<p> All mailboxes in GCCORE have a address book policy<br>

<p> This is an automated email created by Reece McDowell, no action required.  <br>

<p>Regards<br> 
</P>
Wintel Schedualed task
</font>"



#Details for when a ticket needs logged
$logticket_emailaddress = "'$GetronicsSD, '$HouseKeeping'"
$logticket_subject ="GCCORE Mailboxes Incorrectly Created - Security Issue "
$logticket_body ="
<font face=""verdana"">
Intednded for Internal Servicedesk,
<p> The following Users mailboxes where created incorrectly. Please log a P2 ticket for GTN Portakabin 2nd line team.<br>

<p> $ProblemMailboxes <br>

<p> This is a security concern please also notify Colin Shand and Dale Colson <br>

<p> If the 2nd line team think this account should be added to the approve list of accounts please pass to GTN Wintel <BR>


<p>Regards<br> 
</P>
Wintel Schedualed task
</font>"

if($null -eq $ProblemMailboxes)
    {
        Send-Mailmessage -smtpServer $smtpServer -from $from -to $noticket_emailaddress -subject $noticket_subject -body $noticket_body -bodyasHTML -priority High -Encoding $textEncoding -ErrorAction Stop
    }
    else 
    {
        Send-Mailmessage -smtpServer $smtpServer -from $from -to $logticket_emailaddress -subject $logticket_subject -body $logticket_body -bodyasHTML -priority High -Encoding $textEncoding -ErrorAction Stop
    }
