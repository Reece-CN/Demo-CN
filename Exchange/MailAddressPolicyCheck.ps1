
$ExSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://"EXCHANGE URL"/PowerShell/ -Authentication NegotiateWithImplicitCredential
Import-PSSession $ExSession -DisableNameChecking

#Gets current mailboxes that have no address book policy and exports to CSV
Get-Mailbox -ResultSize Unlimited | Where-Object {$_.AddressBookPolicy -eq $Null} | Select-Object name | export-csv -Path C:\Temp\Current-list.csv
$Currentlist = Get-Content C:\Temp\Current-list.csv

#Approved list of mailboxes Manually written
$list = Get-Content C:\Temp\allowedlist.csv

#compares approved list and the current list and looks for items that are unapproved. 
$ProblemMailboxes = $Currentlist | Where-Object {$list -notcontains $_}

$HouseKeeping = "<# Housekeeping mailbox #>"
$CompanySD = "<#SD mailbox #>"
$smtpServer = "<# SMTP Server #>"
$from = "Stask@<#enter domain#>"
$textEncoding =[System.Text.Encoding]::UTF8

#details for no ticket needing logged
$noticket_emailaddress = $HouseKeeping
$noticket_subject = "addressbook policy check"
$noticket_body ="
<font face=""verdana"">
Intednded for Wintel Houskeeping,
<p> All mailboxes in "DomainName" have a address book policy<br>

<p> This is an automated email created by Reece McDowell, no action required.  <br>

<p>Regards<br> 
</P>
Wintel Schedualed task
</font>"



#Details for when a ticket needs logged
$logticket_emailaddress = "'$CompanySD, '$HouseKeeping'"
$logticket_subject =" Mailboxes Incorrectly Created - Security Issue "
$logticket_body ="
<font face=""verdana"">
Intednded for Internal Servicedesk,
<p> The following Users mailboxes where created incorrectly. Please log a P2 ticket for GTN "Customer" 2nd line team.<br>

<p> $ProblemMailboxes <br>

<p> This is a security concern please also notify "managment"<br>

<p> If the 2nd line team think this account should be added to the approve list of accounts please pass to  Wintel <BR>


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
