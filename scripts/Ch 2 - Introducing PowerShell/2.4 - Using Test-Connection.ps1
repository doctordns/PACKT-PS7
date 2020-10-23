# 2.4 - Using Test-Connection

# run on SRV1 after installing PowerShell 7

# 1. Use -Target Parameter Name 
Test-Connection -TargetName www.packt.com -Count 1

# 2. Explicitly use an IPv4 Address
Test-Connection -TargetName www.packt.com -Count 1 -IPv4

# 3. Resolving destination address
$IPs = (Resolve-DnsName -Name Dns.Google -Type A).IPAddress
$IPs | 
  Test-Connection -Count 1 -ResolveDestination

# 4. Resolve destination and trace route
Test-Connection -TargetName 8.8.8.8 -ResolveDestination -Traceroute |
  Where-Object Ping -eq 1

# 5. Use Infinate Ping (stop with Ctrl-C)  
Test-Connection -TargetName www.reskit.net -Repeat

# 6. Show speed of TestConnection in PowerShell 7
Measure-Command -Expression {
  Test-Connection -TargetName  8.8.8.8 -count 1}

# 7. Test in Windows PowerShell
Import-Module -Name ServerManager -WarningAction SilentlyContinue
$Session = Get-PSSession -Name WinPSCompatSession
Invoke-Command -Session $Session -Scriptblock {
    Measure-Command -Expression {
      Test-Connection -TargetName 8.8.8.8 -Count 1}
}
