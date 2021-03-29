# Recipe 12.3 - Using PS Direct with Hyper-V

# Run on HV1

# 1. Creating a credential object for Reskit\Administrator
$Admin = 'Administrator'
$PS    = 'Pa$$w0rd'
$RKP   = ConvertTo-SecureString -String $PS -AsPlainText -Force
$Cred  = [System.Management.Automation.PSCredential]::New(
          $Admin, $RKP)

# 2. Viewing the PSDirect VM
Get-VM -Name PSDirect

# 3. Invoking a command on the VM specifying VM name
$SBHT = @{
  VMName      = 'PSDirect'
  Credential  = $Cred
  ScriptBlock = {HOSTNAME.EXE}
}
Invoke-Command @SBHT

# 4. Invoking a command based on VMID
$VMID = (Get-VM -VMName PSDirect).VMId.Guid
Invoke-Command -VMid $VMID -Credential $RKCred  -ScriptBlock {ipconfig}

# 5. Entering a PS remoting session with the psdirect VM
Enter-PSSession -VMName PSDirect -Credential $Cred
Get-CimInstance -Class Win32_ComputerSystem
Exit-PSSession


### run the rest of this recipe from DC1


# 6. Creating a remoting session to HV1 (Hyper-V Host)
$RS = New-PSSession -ComputerName HV1

# 7. Entering an interactive session with HV1
Enter-PSSession $RS
$PSDRS = New-PSSession -VMName PSDirect

# 8. Entering and using the remoting session inside PSDirect
Enter-PSSession -Session $PSDRS
HOSTNAME.EXE

# 9. Creating credential for PSDirect inside HV1
$Admin = 'Administrator'
$PS    = 'Pa$$w0rd'
$RKP   = ConvertTo-SecureString -String $PS -AsPlainText -Force
$Cred  = [System.Management.Automation.PSCredential]::New(
          $Admin, $RKP)

# 10. Using PS Direct session to the VM
Enter-PSSession -VMName PSDirect -Credential $Cred
HOSTNAME.EXE

# 11. Closing sessions
Exit-PSSession  # exits from session to PSDirect
Exit-PSSession  # exits from session to HV1
