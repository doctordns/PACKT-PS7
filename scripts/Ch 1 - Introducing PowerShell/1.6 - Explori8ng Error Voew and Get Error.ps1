# 1.6 - Exploring Error view and Get-Error
#
# Run in Elevated shell on DC1

# 1. Create a session to PowerSHell 5.1
$COMPNAME = 'DC1'
$SESSION  = New-PSSession -ComputerName $COMPNAME -Name Ch1.6

# 2. Invoke a script in PowerShell 5.1
$SCRIPT = {
  # divide by zero
  gps pwshx
}
Invoke-Command -ScriptBlock $SCRIPT -Session $SESSION

