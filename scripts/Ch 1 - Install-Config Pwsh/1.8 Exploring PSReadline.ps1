# 1.8 Exploring PSReadLine
#
#  Run on SRV1, in PowerShell 7 Console

# 1. Get Commands in the PSReadline module
Get-Command -Module PSReadLine

# 2. Get the PSRealine key handelres
Get-PSReadLineKeyHandler

# 3. Get-the PSReadline options
Get-PSReadLineOption

# 4. Get json config
$Path       = $Env:APPDATA
$CP         = '\Code\User\Settings.json'
$JsonConfig = Join-Path  $Path -ChildPath $CP
$ConfigJSON = Get-Content $JsonConfig

# 5. Get Theme 
$Theme = $ConfigJson | 
           ConvertFrom-Json | Select-Object -ExpandProperty 'workbench.colorTheme'

# 6. If theme solarized light, change the color scheme in Profile          
If ($Theme -eq 'Solarized Light') {
  Set-PSReadLineOption -Colors @{
    Emphasis  = "`e[33m"
    Number    = "`e[34m"
    Parameter = "`e[35m"
    Variable  = "`e[34m"      
  }
}


$CUCHProfile   = $profile.CurrentUserCurrentHost
$ProfileFolder = Split-Path -Path $CUCHProfile 
$ProfileFile   = 'Microsoft.VSCode_profile.ps1'
$VSProfile     = Join-Path -Path $ProfileFolder -ChildPath $ProfileFile


Get-PSReadLineOption




