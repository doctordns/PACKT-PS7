# 1.4 - Build Profile files

# Run on SRV1 after installing PowerShell 7

# 1. Discover the profile file names
$ProfileFiles = $profile |  Get-Member -MemberType NoteProperty
$ProfileFiles | Format-Table -Property Name, Definition

# 2. Check for Existence of each PowerShell Profile Files
Foreach ($ProfileFile in $ProfileFiles){
  "Testing $($ProfileFile.Name)"
  $ProfilePath = $ProfileFile.Definition.split('=')[1]
  If (Test-Path $ProfilePath){
    "$($ProfileFile.Name) DOES EXIST"
    "At $ProfilePath"
  }
  Else {
    "$($ProfileFile.Name) DOES NOT EXIST"
  }
  ""
}  

# 3. Discover Current User Current Host Profile
$CUCHProfile = $profile.CurrentUserCurrentHost
"Current user, current host profile path: [$CUCHPROFILE]"

# 4. Create Current user/Current host profile
$URI = 'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master/' +
       'scripts/goodies/Microsoft.PowerShell_Profile.ps1'
New-Item $CUCHProfile -Force -WarningAction SilentlyContinue |
   Out-Null
(Invoke-WebRequest -Uri $URI -UseBasicParsing).Content | 
  Out-File -FilePath  $CUCHProfile

# 5. Existing from PowerShell 7 console  
Exit-PSHostProcess

# 6. After Restarting PowerShell 7
Get-ChildItem -Path $Profile
