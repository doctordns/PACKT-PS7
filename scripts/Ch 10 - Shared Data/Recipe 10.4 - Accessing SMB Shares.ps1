# Recipe 5.3 - Accessing SMB shares
#
# Run from SRV1 - Uses the ITShare share on SRV2 created earlier
# Run in an elevated console

# 1. Examining the SMB client's configuration on SRV2
Get-SmbClientConfiguration

# 2. Setting Signing of SMB packets
$CHT = @{Confirm=$false}
Set-SmbClientConfiguration -RequireSecuritySignature $True @CHT

# 3. Examine SMB client's network interface
Get-SmbClientNetworkInterface |
    Format-Table

# 4. Examining the shares provided by SRV2
net view \\SRV2

# 5. Creating a drive mapping, mapping the R: to the share on server SRV2
New-SmbMapping -LocalPath R: -RemotePath \\SRV2\ITShare

# 6. Viewing the shared folder mapping
Get-SmbMapping

# 7. View the shared folder contents
Get-ChildItem -Path R:

# 8. Viewing existing connections 
Get-SmbConnection
