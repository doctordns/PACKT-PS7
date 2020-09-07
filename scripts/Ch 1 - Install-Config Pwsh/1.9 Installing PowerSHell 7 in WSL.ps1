# 1.9 Installing PowerSHell 7 in WSL
#
#  Run on SRV1 after installing PowerShell 7 etc
#  Run in an elevated console

# 0. Ensure virtualisation is enable in SRV1
#    Run this on VM Host
Stop-VM -VMName SRV1
Set-VMProcessor -VMName SRV1 -ExposeVirtualizationExtensions $true
Start-VM -VMName SRV1

# 1. On SRV1 install Hyper-V
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools

#  2. Install WSL 
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
wsl.exe --install

# 2. Restart to complete installing WSL on SRV1
Restart-Computer

# 3. Examine wsl
wsl -l -v

# 4. Download Ubuntu 20.04
# goto https://docs.microsoft.com/en-us/windows/wsl/install-manual to see how to dowunoad other distros
$Source = 'https://aka.ms/wslubuntu2004'
$Target = 'c:\foo\wslubuntu2004.zip'
Start-BitsTransfer -Source $Source -Destination $Target  -verbose

# 5. Expand the download into c:\Ubuntu
$Ubuntu = 'C:\Ubuntu'
Expand-Archive  -Path $Target -DestinationPath $Ubuntu
Get-ChildItem -Path $Ubuntu

# 6. Run the installation
C:\Ubuntu\Ubuntu2004.exe

#  hmmm - failing at the moment