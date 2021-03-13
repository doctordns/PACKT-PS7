# Recipe 10.9 - Configuring a DFS Namespace
#
# Run on SRV1


# 1. Installing DFS Namespace and the related management tools
$IHT = @{
  Name                   = 'FS-DFS-Namespace'
  IncludeManagementTools = $True
}
Install-WindowsFeature @IHT -ComputerName SRV1
Install-WindowsFeature @IHT -ComputerName SRV2
Install-WindowsFeature @IHT -ComputerName DC1
Install-WindowsFeature @IHT -ComputerName DC2

# 2. Viewing the DFSN module on SRV1
Get-Module -Name DFSN -ListAvailable

# 3. Creating folders and shares for DFS Root on SRV1, SRV2
$SB = {
  New-Item -Path C:\ShareData -ItemType Directory -Force |
    Out-Null
  New-SmbShare -Name ShareData -Path C:\ShareData -FullAccess Everyone
}
Invoke-Command -ComputerName SRV1, SRV2 -ScriptBlock $SB |
  Out-Null

# 4. Creating DFS Namespace root pointing to ShareData on SRV1
$NSHT1 = @{
  Path        = '\\Reskit.Org\ShareData'
  TargetPath  = '\\SRV1\ShareData'
  Type        = 'DomainV2'
  Description = 'Reskit IT Shared Data DFS Root'
}    
New-DfsnRoot @NSHT1

# 5. Adding a second target for ShareData
$NSHT2 = @{
  Path       = '\\Reskit.Org\ShareData'
  TargetPath = '\\SRV2\ShareData'
}
New-DfsnRootTarget @NSHT2 

# 6. Viewing DFS namespace targets
Get-DfsnRootTarget -Path \\Reskit.Org\ShareData

# 7. Creating ITData shares on SRV1, SRV2
$SB = {
  New-Item -Path C:\ITD -ItemType Directory | Out-Null
  New-SmbShare -Name 'ITData' -Path C:\ITD -FullAccess Everyone
  'Root ITD' | Out-File -Filepath C:\ITD\Root.Txt
}
Invoke-Command -ScriptBlock $SB -Computer SRV1 | Out-Null
Invoke-Command -ScriptBlock $SB -Computer SRV2 | Out-Null

# 8. Create DFS Namespace and set DFS targets
$NSHT1 = @{
 Path                 = '\\Reskit\ShareData\ITData'
 TargetPath           = '\\SRV1\ITData'
 EnableTargetFailback = $true
 Description          = 'General IT Data'
}
New-DfsnFolder @NSHT1 | Out-Null
$NSHT2 = @{
  Path       = '\\Reskit\ShareData\ITData' 
  TargetPath = '\\SRV2\ITData'
} 
New-DfsnFolderTarget @NSHT2 | Out-Null

# 9. Creating IT Management shares on DC1, DC2
$SB = {
  New-Item -Path C:\ITM -ItemType Directory | Out-Null
  New-SmbShare -Name 'ITManagement' -Path C:\ITM -FullAccess Everyone
  'Root ITM' | Out-File -Filepath C:\ITM\Root.Txt
}
Invoke-Command -ScriptBlock $SB -Computer DC1 | Out-Null
Invoke-Command -ScriptBlock $SB -Computer DC2 | Out-Null


# 10. Create DFS Namespace and set DFS targets
$NSHT3 = @{
   Path                 = '\\Reskit\ShareData\ITManagement'
   TargetPath           = '\\DC1\ITManagement'
   EnableTargetFailback = $true
   Description          = 'IT Management Data'
}
New-DfsnFolder @NSHT3 | Out-Null
$NSHT4 = @{
    Path       = '\\Reskit\ShareData\ITManagement' 
    TargetPath = '\\DC2\ITManagememnt'
} 
New-DfsnFolderTarget @NSHT4 | Out-Null

# 11. Viewing the files in the namespace hierarchy
Get-ChildItem -Path \\Reskit.Org\ShareData\ -Recurse




$sb = {get-WindowsFeature 'FS-DFS-Namespace' | remove-windowsfeature}
$S = 'dc1','dc2','srv1', 'srv2'
$s | foreach {icm -ScriptBlock $SB -computername $_  }