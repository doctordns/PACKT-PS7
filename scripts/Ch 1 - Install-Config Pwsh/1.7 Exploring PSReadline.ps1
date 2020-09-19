# 1.7 Exploring PSReadLine
#
#  Run on SRV1

# 1. Get Commands in the PSReadline module
Get-Command -Module PSReadLine

# 2. Get the first 10 PSReadline key handlers
Get-PSReadLineKeyHandler |
  Select-Object -First 10
    Sort-Object -Property Key |
      Format-Table -Property Key, Function, Description

# 3. Discover a count of unbound key handlers
$Unbound = (Get-PSReadLineKeyHandler -Unbound).count
"$Unbound unbound key handlers"

# 4. Get the PSReadline options
Get-PSReadLineOption 

# 5.	Determine VS Code theme name
$Path       = $Env:APPDATA
$CP         = '\Code\User\Settings.json'
$JsonConfig = Join-Path  $Path -ChildPath $CP
$ConfigJSON = Get-Content $JsonConfig
$Theme = $ConfigJson | 
           ConvertFrom-Json |
             Select-Object -ExpandProperty 'workbench.colorTheme'

# 6. If the theme name is the Visual Studio Light, 
#    change the color scheme
If ($Theme -eq 'Visual Studio Light') {
  Set-PSReadLineOption -Colors @{
    Member    = "`e[33m"
    Number    = "`e[34m"
    Parameter = "`e[35m"
    Command   = "`e[34m"      
  }
}



