# 1.2 Using the PowerShell 7 Console
#
# Run on SRV1 after you install PowerShell
# Run in elevated con sole

# 1. Run PowerShell 7 From the Command Line
$PSVersionTable

# 2. View the $Host variable
$Host

# 3. Look at the PowerShell Process
Get-Process -Id $Pid | 
  Format-Custom MainModule -Depth 1

# 4. Look at usage stats
Get-Process -Id $Pid | 
  Format-List *cpu,*memory* 

# 5. Upadate Help
$Before = Get-Help -Name about_*
Update-Help -Force | Out-Null
$After = Get-Help -Name aboout_*