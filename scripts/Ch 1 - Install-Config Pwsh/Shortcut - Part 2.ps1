﻿# Short cut Part 2

# Run inside Elevated VS Code



# 1 Using VS Code, create a Sample Profile File for VS Code
$SAMPLE = 
  'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master/' +
  'scripts/goodies/Microsoft.VSCode_profile.ps1'
(Invoke-WebRequest -Uri $Sample).Content |
  Out-File $Profile


# 2. Update Local User Settings for VS Code
$JSON = @'
{
  "workbench.colorTheme": "Visual Studio Light",
  "powershell.codeFormatting.useCorrectCasing": true,
  "files.autoSave": "onWindowChange",
  "files.defaultLanguage": "powershell",
  "editor.fontFamily": "'Cascadia Code',Consolas,'Courier New'",
  "workbench.editor.highlightModifiedTabs": true,
  "window.zoomLevel": 1,
  "terminal.integrated.shell.windows": "C:\\Program Files\\PowerShell\\7\\pwsh.exe",
  "powershell.powerShellAdditionalExePaths": [
    {
        "exePath": "C:\\PSDailyBuild\\pwsh.exe",
        "versionName": "PowerShell 7.1 Daily Build"
    },
    {
        "exePath": "C:\\PSPreview\\pwsh.exe",
        "versionName": "PowerSHell 7.1 Preview Latest"
    }
  ]
}
'@
$JHT = ConvertFrom-Json -InputObject $JSON -AsHashtable

$Path = $Env:APPDATA
$CP   = '\Code\User\Settings.json'
$Settings = Join-Path  $Path -ChildPath $CP
$JHT |
  ConvertTo-Json  |
    Out-File -FilePath $Settings

# 3. Create a short cut to VSCode
$SourceFileLocation  = "$env:ProgramFiles\Microsoft VS Code\Code.exe"
$ShortcutLocation    = "C:\foo\vscode.lnk"
# Create a  new wscript.shell object
$WScriptShell        = New-Object -ComObject WScript.Shell
$Shortcut            = $WScriptShell.CreateShortcut($ShortcutLocation)
$Shortcut.TargetPath = $SourceFileLocation
#Save the Shortcut to the TargetPath
$Shortcut.Save()

# 4. Create a short cuts to PowerShell 7
$SourceFileLocation  = "$env:ProgramFiles\PowerShell\7\pwsh.exe"
$ShortcutLocation    = 'C:\Foo\pwsh.lnk'
# Create a  new wscript.shell object
$WScriptShell        = New-Object -ComObject WScript.Shell
$Shortcut            = $WScriptShell.CreateShortcut($ShortcutLocation)
$Shortcut.TargetPath = $SourceFileLocation
#Save the Shortcut to the TargetPath
$Shortcut.Save()
# daily build
$DBSourceFileLocation  = 'C:\PSDailyBuild\pwsh.exe'
$ShortcutLocation      = 'C:\Foo\pwshdaily.lnk'
$WScriptShell          = New-Object -ComObject WScript.Shell
$ShortcutDB            = $WScriptShell.CreateShortcut($ShortcutLocation)
$ShortcutDB.TargetPath = $DBSourceFileLocation
#Save the Shortcut to the TargetPath
$ShortcutDB.Save()
# Preview
$PSourceFileLocation   = 'C:\PSPreview\pwsh.exe'
$ShortcutLocation      = 'C:\Foo\pwshpreview.lnk'
$WScriptShell          = New-Object -ComObject WScript.Shell
$ShortcutP             = $WScriptShell.CreateShortcut($ShortcutLocation)
$ShortcutP.TargetPath  = $PSourceFileLocation
#Save the Shortcut to the TargetPath
$ShortcutP.Save()


# 5. Build Updated Layout XML
$XML = @'
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
  xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
  xmlns:defaultlayout=
    "http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
  xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
  xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
  Version="1">
<CustomTaskbarLayoutCollection>
<defaultlayout:TaskbarLayout>
<taskbar:TaskbarPinList>
 <taskbar:DesktopApp DesktopApplicationLinkPath="C:\Foo\vscode.lnk" />
 <taskbar:DesktopApp DesktopApplicationLinkPath="C:\Foo\pwsh.lnk" />

 <taskbar:DesktopApp DesktopApplicationLinkPath="C:\Foo\pwshpreview.lnk" />
 <taskbar:DesktopApp DesktopApplicationLinkPath="C:\Foo\pwshdaily.lnk" />

 </taskbar:TaskbarPinList>
</defaultlayout:TaskbarLayout>
</CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
'@
$XML | Out-File -FilePath C:\Foo\Layout.Xml

# 6. Import the  start layout XML file
#     You get an error if this is not run in an elevated session
Import-StartLayout -LayoutPath C:\Foo\Layout.Xml -MountPath C:\

# 7. Create VSCode Profile for PowerShell 7
Write-Host 'Creating PowerShell 7 VS Code Profile'
$CUCHProfile   = $profile.CurrentUserCurrentHost
$ProfileFolder = Split-Path -Path $CUCHProfile 
$ProfileFile   = 'Microsoft.VSCode_profile.ps1'
$VSProfile     = Join-Path -Path $ProfileFolder -ChildPath $ProfileFile
$URI = 'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master/' +
       "scripts/goodies/$ProfileFile"
New-Item $VSProfile -Force -WarningAction SilentlyContinue |
   Out-Null
(Invoke-WebRequest -Uri $URI -UseBasicParsing).Content | 
  Out-File -FilePath  $VSProfile

# 8. Create Console profile
Write-Host 'Creating PowerShell 7 Console Profile'
$ProfileFile2   = 'Microsoft.PowerShell_Profile.ps1'  
$ConsoleProfile = Join-Path -Path $ProfileFolder -ChildPath $ProfileFile2
New-Item $ConsoleProfile -Force -WarningAction SilentlyContinue |
   Out-Null
$URI2 = 'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master/' +
        "scripts/goodies/$ProfileFile2"    
(Invoke-WebRequest -Uri $URI2 -UseBasicParsing).Content | 
  Out-File -FilePath  $ConsoleProfile

  (Invoke-WebRequest -uri `
  'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master
  /scripts/goodies/Microsoft.PowerShell_Profile.ps1').content
  

# 8. Install Cascadia Code
$CascadiaFont    = 'Cascadia.ttf'    # font file name
$CascadiaRelURL  = 'https://github.com/microsoft/cascadia-code/releases'
$CascadiaRelease = Invoke-WebRequest -Uri $CascadiaRelURL # Get all of them
$CascadiaPath    = "https://github.com" + ($CascadiaRelease.Links.href | 
                      Where-Object { $_ -match "($CascadiaFont)" } | 
                        Select-Object -First 1)
$CascadiaFile   = "C:\Foo\$CascadiaFont"
Invoke-WebRequest -Uri $CascadiaPath -OutFile $CascadiaFile
$FontShellApp = New-Object -Com Shell.Application
$FontShellNamespace = $FontShellApp.Namespace(0x14)
$FontShellNamespace.CopyHere($CascadiaFile, 0x10)


# 13. Now - logoff
logoff.exe

# 14. Relogin and observe the task bar

# 15. Run PowerShell console and observe the profile file running

# 16. Run VS Code from shortcut and observe the profile file running.
