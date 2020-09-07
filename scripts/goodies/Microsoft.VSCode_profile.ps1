# VSCode Profile Sample
# Created 14 Aug 2020
# tfl@psp.co.uk

# Wreite details
"In Customisations for [$($Host.Name)]"
"On $(hostname)"

#Set Me
$ME = whoami
Write-Host "Logged on as $ME"

# Set Format enumeration limit
$FormatEnumerationLimit = 99

# Set some command Defaults
$PSDefaultParameterValues = @{
  "*:autosize"       = $true
  'Receive-Job:keep' = $true
  '*:Wrap'           = $true
}

# Set home to C:\Foo for ~, then go there
New-Item C:\Foo -ItemType Directory -Force -EA 0 | Out-Null
$Provider = Get-PSProvider -PSProvider Filesystem
$Provider.Home = 'C:\Foo'
Set-Location -Path ~
Write-Host 'Setting home to C:\Foo'

# Add a new function Get-HelpDetailed an
Function Get-HelpDetailed { 
    Get-Help $args[0] -Detailed
} # End Get-HelpDetailed Function

# Set aliases
Set-Alias gh    Get-Help
Set-Alias ghd   Get-HelpDetailed

# Reskit Credential
$Urk = 'Reskit\Administrator'
$Prk = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$Credrk = New-Object System.Management.Automation.PSCredential $Urk, $Prk
Write-Host "`$Credrk created for $($Credrk.Username)"

# Fix colour scheme if VS Code is using Solarlized Light
$Path       = $Env:APPDATA
$CP         = '\Code\User\Settings.json'
$JsonConfig = Join-Path  $Path -ChildPath $CP
$ConfigJSON = Get-Content $JsonConfig
$Theme = $ConfigJson | 
           ConvertFrom-Json | Select-Object -ExpandProperty 'workbench.colorTheme'
If ($Theme -eq 'Solarized Light') {
  Write-Host "Updating Solarlized Light Color Scheme"
  Set-PSReadLineOption -Colors @{
    Emphasis  = "`e[33m"
    Number    = "`e[34m"
    Parameter = "`e[35m"
    Variable  = "`e[33m"  
    Member    = "`e[34m"      
  }
}

# All done
Write-Host "Completed Customisations to $(hostname)"