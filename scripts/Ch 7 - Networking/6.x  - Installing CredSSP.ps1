# 4.6 - Installing CredSSP

# Run on SRV1 from an elevated console

# 1. Getting CredSSP default installation on SRV1
Get-WSManCredSSP 

# 2. Get CredSSP default installation on DC1
Invoke-Command -ComputerName DC1 -ScriptBlock {Get-WSManCredSSP}

# 3. Creating a credential
$USER = 'Reskit\Administrator'
$PW   = 'Pa$$w0rd'
$PWSS = ConvertTo-SecureString -String $PW -AsPlainText -Force 
$CREDRK = [pscredential]::new($USER, $PWSS)

# 4. Displaying the credential
$CREDRK.GetNetworkCredential() |
  Format-List -Property *

# 5. Using the credential and creating a normal session on DC1
$S1HT = @{
  ComputerName   = 'DC1'
  Credential     = $CREDRK
}
$S1 = New-PSSession @S1HT

# 6. Enabling SRV1 to use CredSSP as a client for all remoting
Set-Item -Path WSMan:\localhost\client\trustedhosts -Value '*' -Force
Enable-WSManCredSSP -Role Client -DelegateComputer * -Force

# 7. Enable DC1 to use CredSSP as a Server
$SB = {Enable-WSManCredSSP -Role Server -Force }
Invoke-Command -Session $S1 -ScriptBlock $SB 

# 8. Check local CredSSP status
"On SRV1"
Get-WSManCredSSP

# 9. Get Remote CredSSP status
"On DC1"
Invoke-Command -Session $S1 -ScriptBlock {Get-WSManCredSSP}

# 10. Using the credential to create a CredSSP session (and failing)
$S2HT = @{
  ComputerName   = 'DC1.Reskit.Org'
  Authentication = 'CredSSP'
  Credential     = $CREDRK
}
New-PSSession @S2HT

# 11. Setting a key in the remote registry on DC1
$SB2 = {
  $KEY = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\"+
         "AllowFreshCredentialsWhenNTLMOnly"
  If (-not (test-path $key)) {
    New-Item -Path $KEY -Force
  }
  Set-ItemProperty -Path $KEY -Name 1 -Value "WSMAN/*"
  'Done'
}
Invoke-Command -ComputerName DC1 -ScriptBLock $SB2


# 10. Using the credential to create a CredSSP session (and failing)
$S3HT = @{
  ComputerName   = 'DC1.Reskit.Org'
  Authentication = 'CredSSP'
  Credential     = $CREDRK
}
$S3 = New-PSSession @S3HT



