# 2.6 - Exploring Error view and Get-Error
#
# Run in SRV1 after loading 

# 1. Create a simple script
$SCRIPT = @'
  # divide by zero
  42/0  
'@
$SCRIPTFILENAME = 'C:\Foo\ZeroDivError.ps1'
$SCRIPT | Out-File -Path $SCRIPTFILENAME

# 2. Run the script and see the default error view
& $SCRIPTFILENAME

# 3. Run the same line from the console
42/0  

# 4. View $ErrorView variable
$ErrorView 

# 5. View Potential values of Error View
$Type = $ErrorView.GetType().FullName
[System.Enum]::GetNames($Type)

# 6. Set Value to Normal View and re-create the error
$ErrorView = 'NormalView'
& $SCRIPTFILENAME

# 7. Set value to Category View and re-create the error
$ErrorView = 'CategoryView'
& $SCRIPTFILENAME

# 8. Set back to ConciseView (default)
$ErrorView = 'ConciseView'
