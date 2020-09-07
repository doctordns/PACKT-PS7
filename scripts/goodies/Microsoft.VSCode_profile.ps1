# VSCode 

"In Customisations for [$($Host.Name)]"
"On $(hostname)"


# Setup console and window

#Set Me
$me = whoami

# Set Format enum limit
$FormatEnumerationLimit = 99

# Set some command Defaults
$PSDefaultParameterValues = @{
  "*:autosize"       = $true
  'Receive-Job:keep' = $true
  '*:Wrap'           = $true
}

# Set home to C:\Foo for ~, then go there
New-Item C:\Foo -ItemType Directory -Force -EA 0 | out-null
$provider = get-psprovider filesystem
$provider.home = 'C:\Foo'
Set-Location ~
Write-Host 'Setting home to C:\Foo'

# Add a new function Get-HelpDetailed an
Function Get-HelpDetailed { 
    Get-Help $args[0] -Detailed
} # END Get-HelpDetailed Function

# Set aliases
Set-Alias gh    Get-Help
Set-Alias ghd   Get-HelpDetailed

# Reskit Credential
$Urk = 'Reskit\Administrator'
$Prk = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$Credrk = New-Object system.management.automation.PSCredential $Urk, $Prk
"`$Credrk created for $($credrk.username)"

# Fix colour scheme if VS COde is using Solarlized Light
If ($Theme -eq 'Solarized Light') {
  Set-PSReadLineOption -Colors @{
    Emphasis  = "`e[33m"
    Number    = "`e[34m"
    Parameter = "`e[35m"
    Variable  = "`e[34m"      
  }
}

# All done
Write-Host "Completed Customisations to $(hostname)"
