cd
# 6. View the disk
$NewDisk1

# 7. Now setup a mirrored drive in the xame poolo
$NEWVOLHT2 = @{
  StoragePoolFriendlyName = 'RKSP1'
  FriendlyName            = 'RKVD2'
  Size                    = 20GB
  ProvisioningType        = 'Thin'
  ResiliencySettingName       = 'Mirror'

}
$NewDisk2 = New-VirtualDisk @NEWVOLHT2 
$NewDisk2

