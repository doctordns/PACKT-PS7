# 2.2 - Testing Network Connectivity

# Run this on SRV2, after setting a static IP address
# Static IP address was set in 7.1

# 1. Verify SRV2 itself is up and that loopback is working
Test-Connection -ComputerName SRV2 -Count 1 -IPv4

# 2. Test connection to local host's WinRM port
Test-NetConnection -ComputerName SRV2 -CommonTCPPort WinRM

# 3. Test Basic Connectivity to DC1
Test-Connection -ComputerName DC1.Reskit.Org -Count 1

# 4. Check Connectivity to SMB port on DC1
Test-NetConnection -ComputerName DC1.Reskit.Org -CommonTCPPort SMB

# 5. Check Connectivity to the LDAP port on DC1
Test-NetConnection -ComputerName DC1.Reskit.Org -Port 389

# 6. Examine path to a remote server on the Internet
$NCHT = @{
  ComputerName     = 'WWW.Packt.Com'
  TraceRoute       = $true
  InformationLevel = 'Detailed'
}
Test-NetConnection @NCHT    # Check our wonderful publisher
