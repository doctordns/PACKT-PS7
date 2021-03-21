# Recipe 12.1 - Setting up a container host

# Run on CH1 after adding PowerSHell and VS Code

# 1. Installling the Docker provider
$IHT1 = @{
  Name       = 'DockerMSFTProvider'
  Repository = 'PSGallery'
  Force      = $True
}
Install-Module @IHT1

# 2. Installing the latest version of the docker package
#    This also enables the continers feature in Windows Server
$IHT2 = @{
  Name         = 'Docker'
  ProviderName = 'DockerMSFTProvider' 
  Force        = $True
}
Install-Package @IHT2

# 3. Adding Hyper-V and related tools
Add-WindowsFeature -Name Hyper-V -IncludeManagementTools | 
  Out-Null

# 4. Removing Defender as it interferes with Docker
Remove-WindowsFeature -Name Windows-Defender |
  Out-Null

# 5. Restarting the computer to enable docker and containers
Restart-Computer 

# 6. Checking Windows containers and Hyper-V features are installed on CH1
Get-WindowsFeature -Name Containers, Hyper-V

# 7. Checking Docker service
Get-Service -Name Docker   

# 8. Viewsing Docker version information
docker version             

# 9. Displaying docker configuration information
docker info
