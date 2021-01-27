# 8.5 - Configuring Script Block Logging

# Run on SRV1

# 1. Clear PowerShell Core operational log
WevtUtil cl 'PowerShellCore/Operational'

# 2. Enabling script block logging
$SBLPath = 'HKLM:\Software\Policies\Microsoft\Windows' +
             '\PowerShell\ScriptBlockLogging'
if (-not (Test-Path $SBLPath))  {
        $null = New-Item $SBLPath -Force
    }
Set-ItemProperty $SBLPath -Name EnableScriptBlockLogging -Value "1"

# 3. Examining logs for 4104 events
Get-Winevent -LogName 'PowerShellCore/Operational' |
  Where-Object id -eq 4104 | 
    Select-Object -First 1 |
      Format-List -Property ID, Logname, Message

# 4. Creating another script block that is not logged
$SBtolog = {Get-CimInstance -Class Win32_ComputerSystem | Out-Null}   
$Before = Get-WinEvent -LogName 'PowerShellCore/Operational'
Invoke-Command -ScriptBlock $SBtolog
$After = Get-WinEvent -LogName 'PowerShellCore/Operational'

# 5. Comparing before and after
"Before:  $($Before.Count) events"
"After :  $($After.Count) events"

