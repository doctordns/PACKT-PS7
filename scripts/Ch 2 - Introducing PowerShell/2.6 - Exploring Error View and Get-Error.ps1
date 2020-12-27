# 2.6 - Exploring Error view and Get-Error
#
# Run on SRV1 after installing PS 7 and VS Code

# 1. Creating a simple script
$SCRIPT = @'
  # divide by zero
  42/0  
'@
$SCRIPTFILENAME = 'C:\Foo\ZeroDivError.ps1'
$SCRIPT | Out-File -Path $SCRIPTFILENAME

# 2. Running the script and see the default error view
& $SCRIPTFILENAME

# 3. Running the same line from the console
42/0  

# 4. Viewing $ErrorView variable
$ErrorView 

# 5. Viewing Potential values of Error View
$Type = $ErrorView.GetType().FullName
[System.Enum]::GetNames($Type)

# 6. Setting Value to Normal View and re-create the error
$ErrorView = 'NormalView'
& $SCRIPTFILENAME

# 7. Setting value to Category View and re-create the error
$ErrorView = 'CategoryView'
& $SCRIPTFILENAME

# 8. Setting back to ConciseView (default)
$ErrorView = 'ConciseView'
