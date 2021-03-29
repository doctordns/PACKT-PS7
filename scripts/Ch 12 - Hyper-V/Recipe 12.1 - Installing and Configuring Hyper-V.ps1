# Recipe 12.1 - Installing and configuring Hyper-V

# Run on HV1

# 1. Installing the Hyper-V feature on HV1, HV2
$SB = {
  Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
}
Invoke-Command -ComputerName HV1, HV2 -ScriptBlock $Sb

# 2. Rebooting the servers to complete the installation
Restart-Computer -ComputerName HV2 -Force 
Restart-Computer -ComputerName HV1 -Force 

# 3. Creating a PSSession with both HV Servers (after reboot)
$S = New-PSSession HV1, HV2

# 4. Creating and setting the location for VMs and VHDs on HV1 and HV2
$SB = {
    New-Item -Path C:\Vm -ItemType Directory -Force |
        Out-Null
    New-Item -Path C:\Vm\Vhds -ItemType Directory -Force |
        Out-Null
    New-Item -Path C:\Vm\VMs -ItemType Directory -force |
        Out-Null
Invoke-Command -ScriptBlock $Sb -Session $S | Out-Null

# 5. Setting default paths for Hyper-V VM disk/config information
$SB = {
  $VMs  = 'C:\Vm\Vhds'
  $VHDs = 'C:\Vm\VMsV'
  Set-VMHost -ComputerName Localhost -VirtualHardDiskPath $VMs
  Set-VMHost -ComputerName Localhost -VirtualMachinePath $VHDs
}
Invoke-Command -ScriptBlock $SB -Session $S

# 6. Seting NUMA spanning
$SB = {
  Set-VMHost -NumaSpanningEnabled $true
}
Invoke-Command -ScriptBlock $SB -Session $S

# 7. Settting EnhancedSessionMode
$SB = {
 Set-VMHost -EnableEnhancedSessionMode $true
}
Invoke-Command -ScriptBlock $SB -Session $S

# 8. Setting host resource metering on HV1, HV2
$SB = {
 $RMInterval = New-TimeSpan -Hours 0 -Minutes 15
 Set-VMHost -ResourceMeteringSaveInterval $RMInterval
}
Invoke-Command -ScriptBlock $SB -Session $S

# 9. Reviewing key VMHost settings:
$SB = {
  Get-VMHost 
}
$P = 'Name', 'V*Path','Numasp*', 'Ena*','RES*'
Invoke-Command -Scriptblock $SB -Session $S |
  Format-Table -Property $P