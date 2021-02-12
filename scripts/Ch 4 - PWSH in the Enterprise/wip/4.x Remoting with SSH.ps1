# 4.7 Remoting with SSH

# Run on SRV1

# 1. Finding OpenSSH on SRV1
$Features = Get-WindowsCapability -Online |
             Where-Object Name -match  'OpenSSH'
$CLI = $Features | Where-Object Name -Match 'Client'
$SRV = $Features | Where-Object Name -Match 'Server'

# 2. Ensure SSH Client is installed
If ($CLI.State -eq 'Installed') {
  "OpenSSH Client already installed"    
}
Else {
    Add-WindowsCapability -Online -Name 'OpenSSH.Client~~~~0.0.1.0'
    "OpenSSH Client Installed"    
}

# 3. Ensure SSH Client is installed  
If ($SRV.State -eq 'Installed') {
    "OpenSSH Server already installed"    
  }
Else {
  Add-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0'
  "OpenSSH Server Installed"    
}
  

Function Get-ShortName {
  BEGIN { 
    $FSO = New-Object -ComObject Scripting.FileSystemObject 
  }
  PROCESS {
    If ($_.PSIsContainer) {
      $FSO.GetFolder($_.FullName).ShortName
    }
  ELSE {
    $FSO.GetFile($_.FullName).ShortName} 
  } 
}
             
