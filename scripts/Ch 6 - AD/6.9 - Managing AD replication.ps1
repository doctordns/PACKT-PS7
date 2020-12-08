

# Check replication
Get-ADReplicationPartnerMetadata -Target DC1.Reskit.Org -PartnerType Both


Get-ADReplicationPartnerMetadata -Target Reskit.Org -Scope Domain




## Active Directory Domain Controller Replication Status##
$Domaincontroller = 'DC1'

## Define Objects ##

$report = New-Object PSObject -Property @{
  ReplicationPartners = $null
  LastReplication = $null
  FailureCount = $null
  FailureType = $null
  FirstFailure = $null
}

## Replication Partners ##
$ReplMeta                   = Get-ADReplicationPartnerMetadata -Target $domaincontroller
$report.ReplicationPartners = $ReplMeta.Partner
$report.LastReplication     = $ReplMeta.LastReplicationSuccess
## Replication Failures ##
$REPLF = Get-ADReplicationFailure -Target $domaincontroller
$report.FailureCount  = $REPLF.FailureCount
$report.FailureType   = $REPLF.FailureType
$report.FirstFailure  = $REPLF.FirstFailureTime
## Format Output ##
$report | select ReplicationPartners,LastReplication,FirstFailure,FailureCount,FailureType


# Simulate an issue
Stop-computer DC2  -Force




Get-ADReplicationPartnerMetadata -Target UKDC1 -Partition Schema