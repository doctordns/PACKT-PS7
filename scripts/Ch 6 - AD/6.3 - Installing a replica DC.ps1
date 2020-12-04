# 6.3 - Installing a Replica DC

# Run this recipe on DC2 once it has been promoted
# Login as Reskit\Administrator

# Run on DC2 - a domain server in the reskit domain
# DC1 is the forest root DC

# 1. Import the Server Manager Module
Import-Module -Name ServerManager -WarningAction SilentlyContinue

# 2. Check DC1 can be resolved 
Resolve-DnsName -Name DC1.Reskit.Org -Type A

# 3. Testing Net Connection to DC1
Test-NetConnection -ComputerName DC1.Reskit.Org -Port 445
Test-NetConnection -ComputerName DC1.Reskit.Org -Port 389

# 4. Add the AD DS features on DC2
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# 5. Promote DC2 to be a DC
Import-Module -Name ADDSDeployment -WarningAction SilentlyContinue
$URK    = "Administrator@Reskit.Org" 
$PW     = 'Pa$$w0rd'
$PSS    = ConvertTo-SecureString -String $PW -AsPlainText -Force
$CredRK = [PSCredential]::New($URK,$PSS)
$INSTALLHT = @{
  DomainName                    = 'Reskit.Org'
  SafeModeAdministratorPassword = $PSS
  SiteName                      = 'Default-First-Site-Name'
  NoRebootOnCompletion          = $true
  InstallDNS                    = $false
  Credential                    = $CredRK
  Force                         = $true
  } 
Install-ADDSDomainController @INSTALLHT | Out-Null


# 6. Checking the Computer objects in AD
Get-ADComputer -Filter * | 
  Format-Table DNSHostname, DistinguishedName

# 7. Reboot manually
Restart-Computer -Force

###  DC2 reboots at this point
### Relogon as Adminstrator@reskit.org

# 8. Check DCs in Reskit.Org
$SB = 'OU=Domain Controllers,DC=Reskit,DC=Org'
Get-ADComputer -Filter * -SearchBase $SB |
  Format-Table -Property DNSHostname, Enabled

# 9. View Reskit.Org Domain DCs
Get-ADDomain |
  Format-Table -Property Forest, Name, Replica*
. 