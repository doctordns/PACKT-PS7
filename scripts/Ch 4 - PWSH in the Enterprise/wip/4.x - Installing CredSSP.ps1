# 4.6 - Installing CredSSP

# Run on SRV1 from an elevated console

# 1. Getting CredSSP default installation
Get-WSManCredSSP 


# 2. Creating a credential
$USER = 'Administrator'
$PW   = 'Pa$$w0rd'
$PWSS = ConvertTo-SecureString -String $PW -AsPlainText -Force 
$CREDSRV1 = [pscredential]::new($USER, $PWSS)

# 3. Displaying the credential
$CREDSRV1.GetNetworkCredential() |
  Format-List *

# 4. Using the credential
$S1HT = @{
  ComputerName   = 'SRV2'
  Authentication = 'CredSSP'
  Credential     = $CREDSRV1
}
$S1  = New-PSSession @S1HT

# 5. Enable SRV1 to use CredSSP as a client
Set-Item -Path wsman:localhost\client\trustedhosts -Value '*' -Force
Enable-WSManCredSSP -Role Client -DelegateComputer * -Force

# 6. Enable SRV1 to use CredSSP as a Server
Enable-WSManCredSSP -Role Server -Force

# 7. Getting updated CredSSP installation
Get-WSManCredSSP 

# 8. Restarting WinRM service with CredSSP enabled
Restart-Service -Name WinRM 

# 9. Using CredSSP
$S1  = New-PSSession @S1HT



# 10. checking it
$Ccgiuce - 
$SB = {
  Write-Host ("hello, world: {0}, {1}" -f $env:USERNAME, (hostname))
}
$USER   = 'SRV1\Administrator'
$PASS   = '$Pa$$w0rd'
$PASSSS = $PASS | 
            ConvertTo-SecureString -asPlainText -Force
$Cred = (New-Object System.Management.Automation.PSCredential($username,$adjPwd))    

switch ($choice)
  {
    "basic"       { Invoke-Command $block }
    "remote"      { Invoke-Command $block -computername $serverName }
    "credentialA" { Invoke-Command $block -computername $serverName -credential $testCred  }
    "credentialB" { Invoke-Command $block -computername $serverName -credential $testCred  -Authentication Credssp}
    "session"     { 
        $testSession = New-PSSession -computername $serverName -credential $testCred -Authentication Credssp
        if ($testSession) { Invoke-Command $block -Session $testSession; Remove-PSSession $testSession }
        }
  }


