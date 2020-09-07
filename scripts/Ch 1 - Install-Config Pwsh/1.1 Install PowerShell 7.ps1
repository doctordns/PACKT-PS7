# 1.1 Install PowerSHell 77

# Run on SRV1
# Run using an elevated Windows PowerShell 5.1 host

# 1. Enable scripts to be run
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

# 2. Install latest versions of Nuget and PowerShellGet
Install-PackageProvider Nuget -MinimumVersion 2.8.5.201 -Force |
  Out-Null
Install-Module -Name PowerShellGet -Force -AllowClobber 

# 3. Ensure the C:\Foo Folder exists
$LFHT = @{
  ItemType    = 'Directory'
  ErrorAction = 'SilentlyContinue' # should it already exist
}
New-Item -Path C:\Foo @LFHT | Out-Null

# 4. Download PowerShell 7 installation script
Set-Location C:\Foo
$URI = "https://aka.ms/install-powershell.ps1"
Invoke-RestMethod -Uri $URI | 
  Out-File -FilePath C:\Foo\Install-PowerShell.ps1

# 5. View Installation Script Help
Get-Help -Name C:\Foo\Install-PowerShell.ps1

# 6. Install PowerShell 7
$EXTHT = @{
  UseMSI                 = $true
  Quiet                  = $true 
  AddExplorerContextMenu = $true
  EnablePSRemoting       = $true
}
C:\Foo\Install-PowerShell.ps1 @EXTHT | Out-Null

# 7. For the Adventerous - install the preview and daily builds as well
C:\Foo\Install-PowerShell.ps1 -Preview -Destination c:\PWSHPreview
C:\Foo\Install-PowerShell.ps1 -Daily   -Destination c:\PWSHDailBuild

# 13. Create Current user/Current host profile
$URI = 'https://raw.githubusercontent.com/doctordns/Wiley20/master/' +
       'Goodies/Microsoft.PowerShell_Profile.ps1'
$ProfileFile = $Profile.CurrentUserCurrentHost
New-Item $ProfileFile -Force -WarningAction SilentlyContinue |
   Out-Null
(Invoke-WebRequest -Uri $uri -UseBasicParsing).Content | 
  Out-File -FilePath  $ProfileFile

