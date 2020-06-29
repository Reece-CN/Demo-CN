#Get all windows OS servers , exports name,DistinguishedName,OperatingSystem,Description,Enabled

# CSS style sheet for output
$header = @"
<style>

    h1 {

        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 28px;

    }

    
    h2 {

        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;

    }

    
    
    table {
		font-size: 12px;
		border: 0px; 
		font-family: Arial, Helvetica, sans-serif;
	} 
	
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}
	
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}

    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }

        #CreationDate {

        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;

    }
    



</style>
"@

#CreationDate Style 
{
    font-family: Arial, Helvetica, sans-serif;
    color: #ff3300;
    font-size: 12px;
}

#Get all the data for each section of the report
$Title = "<H1>"Customer Report</h1>"
$DomainControlers = get-adcomputer -Filter { name -like "*DC*" } -Properties * | Where-Object {$_.DistinguishedName -like "*OU=Domain*"} |ConvertTo-Html name,DistinguishedName,OperatingSystem,Description,Enabled -Fragment -PreContent "<H2>Infra Core Apps	Manage - Active Directory</h2>"
$DHCPServers = get-adcomputer -Filter { name -like "*DH*" } -Properties * | Where-Object {$_.DistinguishedName -like "*OU=DHCP*"} | ConvertTo-Html name,DistinguishedName,OperatingSystem,Description,Enabled -Fragment -PreContent "<H2>Infra Core Apps	Manage - DHCP</h2>"
$Fileservers = Get-ADComputer -Filter { name -like "*FS*" } -Properties * | Where-Object {$_.DistinguishedName -like "*OU=File Servers*"} | ConvertTo-Html name,DistinguishedName,OperatingSystem,Description,Enabled -Fragment -PreContent "<H2>Infra Core Apps	Manage - File Servers</h2>"
$InternalDNS = Resolve-DnsName "<#DNS NAME#>" -type NS | Where-Object name -ne "<#DomainName#>" |ConvertTo-Html Name, IP4Address -Fragment -PreContent "<H2> Infra Core Apps	Manage - Internal DNS</h2>"
$PAMServers = Get-ADComputer -Filter { name -like "*IPAM*" } -Properties * | Where-Object {$_.DistinguishedName -like "*OU=IPAM*"} | ConvertTo-Html name,DistinguishedName,OperatingSystem,Description,Enabled -Fragment -PreContent "<H2>Infra Core Apps	Manage - Location IPAM</h2>"
#Puts report together and exports it.
$Report = ConvertTo-HTML -Body "$Title $DomainControlers $DHCPServers $Fileservers $InternalDNS $PAMServers" -Title $Title -Head $header -PostContent "<p id='CreationDate'>Creation Date: $(Get-Date)</p>"
$Report | Out-File .\Customer_Report.html

Sub-Package/Tower	Item
Infra Core Apps	Manage - Active Directory  CHECK
Infra Core Apps	Manage - DHCP CHECK 
Infra Core Apps	Manage - File Servers Check
Infra Core Apps	Manage - Internal DNS CHECK 
Infra Core Apps	Manage - Location IPAM CHECK
Print	Manage - MFP Secure XT Software License 10 units
Print	Manage - MFP Secure Print and Scan Software License 50 units
EUC Management	Operation - Shared Remote Desktop Session
