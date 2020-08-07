# 1.6 - Exploring Error view and Get-Error
#
# Run in DC1

# 1. Create a simple script
$SCRIPT = @'
  # divide by zero
  1/0  
'@
$SCRIPT | Out-File -Path C:\Foo\DivByZero.ps1

# 2. Run it
C:\foo\DivByZero.ps1

# 3. View Error VIew
$ErrorView 

# 4. View Potential values of Error View
[System.Enum]::GetNames('System.Management.Automation.ErrorView')

# 5. Set Value to Normal View and re-create the error
$ErrorView = 'NormalView'
C:\Foo\DivByZero.ps1

# 6. Set value to Category View and re-create the error
$ErrorView = 'CategoryView'
C:\Foo\DivByZero.ps1

# 7. Set back to ConciseView (default)
$ErrorView = 'ConciseView'
