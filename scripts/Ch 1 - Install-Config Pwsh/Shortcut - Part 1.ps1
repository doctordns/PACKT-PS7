# mondo script to setup a VM - Part 1
#
# run IN the VM inside an elevated powershell ISE Console



# 1. Set Execution Policy for Windows PowerShell
Write-Host "Setting Execution Policy"
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

# 2. Install the latest versions of Nuget and PowerShellGet
Write-Host "Updating PowerShellGet and Nuget"
Install-PackageProvider Nuget -MinimumVersion 2.8.5.201 -Force |
  Out-Null
Install-Module -Name PowerShellGet -Force -AllowClobber 

# 3. Ensure the C:\Foo Folder exists
Write-Host "Creating C:\Foo"
$LFHT = @{
  ItemType    = 'Directory'
  ErrorAction = 'SilentlyContinue' # should it already exist
}
New-Item -Path C:\Foo @LFHT | Out-Null

# 4. Download PowerShell 7 installation script
Write-Host "Downloading Pwsh 7 installation script"
Set-Location C:\Foo
$URI = 'https://aka.ms/install-powershell.ps1'
Invoke-RestMethod -Uri $URI | 
  Out-File -FilePath C:\Foo\Install-PowerShell.ps1

# 5. Install PowerShell 7
Write-Host "Instal Pwsh 7.1"
$EXTHT = @{
  UseMSI                 = $true
  Quiet                  = $true 
  AddExplorerContextMenu = $true
  EnablePSRemoting       = $true
}
C:\Foo\Install-PowerShell.ps1 @EXTHT | Out-Null

# 6. For the Adventurous - install the preview and daily builds as well
Write-Host "Install Pwsh 7.1 preview"
C:\Foo\Install-PowerShell.ps1 -Preview -Destination c:\PSPreview |
  Out-Null
Write-Host "Install Pwsh 7.1 Daily Build"
C:\Foo\Install-PowerShell.ps1 -Daily   -Destination c:\PSDailyBuild |
  Out-Null

# 7. Create Windows PowerShell default Profiles
Write-Host "Create Default profiles"
$URI = 'https://raw.githubusercontent.com/doctordns/Wiley20/master/' +
       'Goodies/Microsoft.PowerShell_Profile.ps1'
$ProfileFile = $Profile.CurrentUserCurrentHost
New-Item $ProfileFile -Force -WarningAction SilentlyContinue |
   Out-Null
(Invoke-WebRequest -Uri $uri -UseBasicParsing).Content | 
  Out-File -FilePath  $ProfileFile
$ProfilePath = Split-Path -Path $ProfileFile
$ConsoleProfile = Join-Path -Path $ProfilePath -ChildPath 'Microsoft.PowerShell_profile.ps1'
(Invoke-WebRequest -Uri $URI -UseBasicParsing).Content | 
  Out-File -FilePath  $ConsoleProfile

# 8. Download the VS Code installation script from PS Gallery
Write-Host "Download VS Code Installation Script"
$VSCPATH = 'C:\Foo'
Save-Script -Name Install-VSCode -Path $VSCPATH
Set-Location -Path $VSCPATH

# 9. Run the installation script and add in some popular extensions
Write-Host "Installing VS Code"
$Extensions =  'Streetsidesoftware.code-spell-checker',
               'yzhang.markdown-all-in-one',
               'hediet.vscode-drawio'
$InstallHT = @{
  BuildEdition         = 'Stable-System'
  AdditionalExtensions = $Extensions
  LaunchWhenDone       = $true
}             
.\Install-VSCode.ps1 @InstallHT -ea 0 | Out-Null

# 10. All done with Windows PowerShell
Write-Host "Close VS code, restart as admin and do part 2 inside VS Code"
Write-Host "Make sure you use an elevated VS CODE!!"



$pseditor | fc -Depth 3
