# Recipe 13.2 - Creating Azure Assets
#
# Run on SRV1

# 1. Setting key variables
$Locname    = 'uksouth'     # Location name
$RgName     = 'packt_rg'    # Resource group we are using
$SAName     = 'packt42sa'   # Storage account name

# 2. Logging into your Azure Account

$CredAZ  = Get-Credential     # Enter your Azure Credential details
$Account = Connect-AzAccount -Credential $CredAZ

# 3. Creating a resource group and tagging it
$RGTag  = [Ordered] @{Publisher='Packt'}
$RGTag +=           @{Author='Thomas Lee'}
$RGHT = @{
    Name     = $RgName
    Location = $Locname
    Tag      = $RGTag
}
$RG = New-AzResourceGroup @RGHT

# 4. Viewing RG with Tags
Get-AzResourceGroup -Name $RGName |
    Format-List -Property *

# 5. Testing to see if an SA name is taken
Get-AzStorageAccountNameAvailability $SAName

# 6. Creating a new Storage Account
$SAHT = @{
  Name              = $SAName
  SkuName           = 'Standard_LRS'
  ResourceGroupName = $RgName
  Tag               = $RGTag
  Location          = $Locname

}
New-AzStorageAccount @SAHT | Format-List

# 7. Getting an overview of the SA in this Resource group
$SA = Get-AzStorageAccount -ResourceGroupName $RgName
$SA |
  Format-List -Property *


# 8. Getting primary endpoints for the SA
$SA.PrimaryEndpoints

# 9. Reviewing the SKU
$SA.Sku

# 10. View Storage Account's Context property
$SA.Context