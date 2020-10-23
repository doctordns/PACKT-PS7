# 2.3 - Exploring Performance Improvements

# run on SRV1 after installing pwsh 7
# run elevated


# 1. Create a remoting connection to the local host
Import-Module -Name ServerManager -UseWindowsPowerShell 

# 2. Get remoting session
$Session = Get-PSSession -Name 'WinPSCompatSession'

# 3. Check Version of PowerShell in the remoting session
Invoke-Command -Session $Session  -ScriptBlock {$PSVersionTable}

# 4. Define a long running script block using ForEach-Object
$SB1 = {
  $Array  = (1..10000000)
  (Measure-Command {
    $Array | ForEach-Object {$_}}).TotalSeconds
}

# 5. Run The script block locally
[gc]::Collect()
$TimeInP7 = Invoke-Command -ScriptBlock $SB1 
"Foreach-Object in PowerShell 7.1: [{0:n4}] seconds" -f $TimeInP7

# 6. Run it in PowerShell 5.1 
[gc]::Collect()
$TimeInWP  = Invoke-Command -ScriptBlock $SB1 -Session $Session
"ForEach-Object in Windows PowerShell 5.1: [{0:n4}] seconds" -f $TimeInWP

# 7. Define another long running script block using ForEach
$SB2 = {
    $Array  = (1..10000000)
    (Measure-Command {
      ForEach ($Member in $Array) {$Member}}).TotalSeconds
}

# 8. Run it locally in PowerShell 7
[gc]::Collect()
$TimeInP72 = Invoke-Command -ScriptBlock $SB2 
"Foreach in PowerShell 7.1: [{0:n4}] seconds" -f $TimeInP72
  
# 9. Run it in Windows PowerShell 5.1 
[gc]::Collect()
$TimeInWP2  = Invoke-Command -ScriptBlock $SB2 -Session $Session
"Foreach in Windows PowerShell 5.1: [{0:n4}] seconds" -f $TimeInWP2
