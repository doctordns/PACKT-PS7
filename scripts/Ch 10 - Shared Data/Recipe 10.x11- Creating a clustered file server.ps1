# Recipe 10.7 - Create a clustered file server 

# Run this recipe is run on SRV1
#
# ISCSI Target setukp up on ss1 and the nitiator is setup on SRV1


# 1. Setup SRV2 to be an iSCSI initiator against SS1
$SB = {
  #  Start iSCSI service
    Set-Service MSiSCSI -StartupType 'Automatic'
    Start-Service MSiSCSI
  # Setup iSCSI portal on SRV2
    $PHT = @{
      TargetPortalAddress     = 'SS1.Reskit.Org'
      TargetPortalPortNumber  = 3260
    }
    New-IscsiTargetPortal @PHT
  # Find and connect to Target disk
    $Target  = Get-IscsiTarget | 
    Where-Object NodeAddress -Match 'ITTarget'
    $CHT = @{
      TargetPortalAddress = 'SS1.Reskit.Org'
      NodeAddress         = $Target.NodeAddress
    }
    Connect-IscsiTarget  @CHT
  # Set Ddisk to be online:
   $Disk = Get-Disk | Where-Object Bustype -eq 'ISCSI'
   $Disk | Set-Disk -IsOffline  $False
   $Disk | Set-Disk -Isreadonly $False 
  # Set target to be I: in SRV2
   $Part = GET-PARTITION -DiskNumber $DISK.NUMBER | 
   Select-Object -Last 1
   $PART | SET-PARTITION -NewDriveLetter I
}
Invoke-Command -ComputerName SRV2 -ScriptBlock  $SB

# 2. Adding clustering and file server features to SRV1
$SB = {
  $IHT = @{
    Name                   = 'Failover-Clustering','FS-FileServer'
    IncludeManagementTools = $True
  }
  Install-WindowsFeature @IHT
}
Invoke-Command -ScriptBlock $SB

# 3. Adding clustering and file server features to SRV2
Invoke-Command -ScriptBlock $SB -ComputerName SRV2

# 4. Ensuring SRV1 and SRV2 are in the IT OU
$SB2 = {
  Get-ADComputer -Identity SRV1 | 
    Move-ADObject -TargetPath "OU=IT,DC=Reskit,DC=Org"
  Get-ADComputer -Identity SRV2 | 
    Move-ADObject -TargetPath "OU=IT,DC=Reskit,DC=Org"
}
Invoke-Command -ComputerName DC1 -ScriptBlock $SB2

# 5. Testing the cluster nodes
$CheckOutput = 'C:\Foo\ClusterCheck'
$Results = Test-Cluster  -Node SRV1, SRV2  -ReportName $CheckOutput

# 6. Viewing Validation test results
Invoke-Item  -Path $Results.FullName

# 7. Creating The Cluster
$NCHT = @{
  Node          = ('SRV1.Reskit.Org','SRV2.Reskit.Org')
  StaticAddress = '10.10.10.55'
  Name          = 'SRVCLUSTER'
}
New-Cluster @NCHT

# 8. Configure to have no quorum witness
Set-ClusterQuorum –Cluster SRVCLUSTER -NodeMajority

# 9. Add the clustered file server role
$CRHT = @{
  Name          = 'ITFS' 
  Storage       = 'Cluster Disk 1'
  StaticAddress = '10.10.10.54'
}
Add-ClusterFileServerRole @CRHT


# 7 add a normal share
$SdFolder = 'S:\SalesData'
New-SMBShare -Name SalesD     ata  `
             -Path $SdFolder `
             -Description 'SalesData'

# 8. Add a Continously Avaliable share
$HvFolder = 'C:\ClusterStorage\Volume1\HVData'
New-Item -Path $HvFolder -ItemType Directory |
              Out-Null
New-SMBShare -Name SalesHV -Path $HvFolder `
             -Description 'Sales HV (CA)' `
             -FullAccess 'Reskit\IT Team' `
             -ContinuouslyAvailable:$true 

# 9. View Shares
Get-SmbShare


<#  Remove it
Get-SMBShare -name SalesData | Remove-SMBShare -Confirm:$False
Get-SMBShare -name HVShare | Remove-SMBShare -Confirm:$False

Get-ClusterSharedVolume | Remove-ClusterSharedVolume
Get-Clusterresource | stop-clusterresource
Get-ClusterGroup -Name ITFS| remove-clusterresource
Get-ClusterResource | remove-clusterresource -Force
Remove-Cluster  -force -cleanupad
#>

# later
Add-ClusterSharedVolume -Name HVCSV
