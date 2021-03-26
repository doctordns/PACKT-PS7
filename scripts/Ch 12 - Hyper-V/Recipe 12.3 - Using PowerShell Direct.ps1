# Recipe 12.3 - Using PS Direct with Hyper-V

# Run on HV1

# 1. Creating a credential object for Reskit\Administrator
$RKAn = 'Administrator'
$PS   = 'Pa$$w0rd'
$RKP  = ConvertTo-SecureString -String $PS -AsPlainText -Force
$T = 'System.Management.Automation.PSCredential'
$RKCred = New-Object -TypeName $T -ArgumentList $RKAn,$RKP

# 2. Viewing the PSDirect VM
Get-VM -Name PSDirect

# 3. Invoking a command on the VM specifying VM name
$SBHT = @{
  VMName      = 'PSDirect'
  Credential  = $RKCred
  ScriptBlock = {hostname}
}
Invoke-Command @SBHT

# 4. Invoking a command based on VMID
$VMID = (Get-VM -VMName PSDirect).VMId.Guid
Invoke-Command -VMid $VMID -Credential $RKCred  -ScriptBlock {ipconfig}

# 5. Entering a PS remoting session with the psdirect VM
Enter-PSSession -VMName PSDirect -Credential $RKCred
Get-CimInstance -Class Win32_ComputerSystem
Exit-PSSession