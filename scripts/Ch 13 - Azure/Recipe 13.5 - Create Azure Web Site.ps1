# Recipe 13.5 - Create an Azure Web App

# Run on SRV1



# 1.  Defining Variables
$Locname    = 'uksouth'     # location name
$RgName     = 'packt_rg'    # resource group we are using
$SAName     = 'packt42sa'   # storage account name
$AppSrvName = 'packt42'
$AppName    = 'packt42website'

# 2. Logging in to your Azure Account
$CredAZ = Get-Credential
Login-AzAccount -Credential $CredAz

# 3. Ensuring Resource Group is created
$RGHT1 = @{
  Name        = $RgName
  ErrorAction = 'Silentlycontinue'
}
$RG = Get-AzResourceGroup @RGHT1
if (-not $RG) {
  $RGTag  = [Ordered] @{Publisher='Packt'}
  $RGTag +=           @{Author='Thomas Lee'}
  $RGHT2 = @{
    Name     = $RgName
    Location = $Locname
    Tag      = $RGTag
  }
  $RG = New-AzResourceGroup @RGHT2
  Write-Host "RG $RgName created"
}

# 4.  Ensuring the Stoage Account is created
$SAHT = @{
  Name              = $SAName
  ResourceGroupName = $RgName 
  ErrorAction       = 'SilentlyContinue'
}
$SA = Get-AzStorageAccount @SAHT
if (-not $SA) {
  $SATag  = [Ordered] @{Publisher='Packt'}
  $SATag +=           @{Author='Thomas Lee'}
  $SAHT = @{
    Name              = $SAName
    ResourceGroupName = $RgName
    Location          = $Locname
    Tag               = $SATag
    SkuName           = 'Standard_LRS'
  }
  $SA = New-AStorageAccount @SAHT
  "SA $SAName created"
}

# 5. Creating application service plan
$SPHT = @{
     ResourceGroupName   = $RgName
     Name                = $AppSrvName
     Location            = $Locname
     Tier               =  'Free'
}
New-AzAppServicePlan @SPHT |  Out-Null

# 6. Viewing the service plan
$PHT = @{
  ResourceGroupName = $RGname 
  Name              = $AppSrvName
}
Get-AzAppServicePlan @PHT

# 7. Creating the new Azure webapp
$WAHT = @{
  ResourceGroupName = $RgName 
  Name              = $AppName
  AppServicePlan    = $AppSrvName
  Location          = $Locname
}
New-AzWebApp @WAHT |  Out-Null

# 8. Viewing application details
$WebApp = Get-AzWebApp -ResourceGroupName $RgName -Name $AppName
$WebApp | 
  Format-Table -Property Name, State, Hostnames, Location

# 9.  Checking the web site
$SiteUrl = "https://$($WebApp.DefaultHostName)"
Start-Process -FilePath $SiteUrl

# 10. Installing the PSFTP module
Install-Module PSFTP -Force | Out-Null
Import-Module PSFTP

# 11.  Getting publishing profile XML and extracting FTP upload details
$APHT = @{
  ResourceGroupName = $RgName
  Name              = $AppName  
  OutputFile        = 'C:\Foo\pdata.txt'
}
$X = [xml] (Get-AzWebAppPublishingProfile @APHT)
$X.publishData.publishProfile[1]

# 12. Extracting crededentials and site details
$UserName = $X.publishData.publishProfile[1].userName
$UserPwd  = $X.publishData.publishProfile[1].userPWD
$Site     = $X.publishData.publishProfile[1].publishUrl

# 13. Setting the FTP connection
$FTPSN  = 'FTPtoAzure'
$PS     = ConvertTo-SecureString $UserPWD -AsPlainText -Force
$T      = 'System.Management.automation.PSCredentiaL'
$Cred   = New-Object -TypeName $T -ArgumentList $UserName,$PS
$FTPHT  = @{
  Credentials = $Cred 
  Server      = $Site 
  Session     = $FTPSN
  UsePassive  = $true
}
Set-FTPConnection @FTPHT

# 14. Opening an FTP session
$Session = Get-FTPConnection -Session $FTPSN
$Session

# 15. Creating a web page and uploading it
'My First Azure Web Site' | Out-File -FilePath C:\Foo\Index.Html
$Filename = 'C:\foo\index.html'
$IHT = @{
  Path       = '/'
  LocalPath  = 'C:\foo\index.html'
  Session    = $FTPSN
}
Add-FTPItem @IHT


# 16. NoW look at the site using default browser 
$SiteUrl = "https://$($WebApp.DefaultHostName)"
Start-Process -FilePath $SiteUrl