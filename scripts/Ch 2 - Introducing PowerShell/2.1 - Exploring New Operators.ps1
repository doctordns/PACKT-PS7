# 2.1 Exploring New Operators

# Run on SRV1 after installing PowerShell 7 and VS C0de

# Pipeline chain operators && and ||

# 1. Checking results traditionally
Write-Output 'Something that succeeds'
if ($?) {Write-Output 'It worked'}

# 2. Check results With Pipeline operator &&
Write-Output 'Something that succeeds' && Write-Output 'It worked'

# 3. Using Pipeline chain operator  ||
Write-Output 'Something that succeeds' || 
  Write-Output 'You do not see this message'

# 4. Define a simple function
function Install-CacadiaPLFont{
  Write-Host 'Installing Cascadia PL font...'
}

# 5. Demonstrate || operator
$OldErrorAction        = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
Get-ChildItem -Path C:\FOO\CASCADIAPL.TTF | OUT-NULL || 
   Install-CacadiaPLFont
$ErrorActionPreference = $OldErrorAction

# Null Coalescing

# 6. Create a function to test null handling
Function Test-NCO {
  if ($args -eq '42') {
    Return 'Test-NCO returned a result'
  }
}

# 7.	Test null results traditionally
$Result1 = Test-NCO    # no parameter
if ($null -eq $Result1) {
    'Function returned no value'
} else {
    $Result1
}
$Result2 = Test-NCO 42  # using a parameter
if ($null -eq $Result2) { 
    'Function returned no value'
} else {
    $Result2
}

# 8. Test using Null Coalescing operator ??
$Result3 =  Test-NCO
$Result3 ?? 'Function returned no value'
$Result4 =  Test-NCO 42
$Result4 ?? 'This is not output, but result is'

# 9. Demonstrate Null Conditional Assignment Operator
$Result5 = Test-NCO
$Result5 ?? 'Result is is null'
$Result5 ??= Test-NCO 42
$Result5

# Null Conditional Operators

# 10. Test running an method on a null object Traditionally
$BitService.Stop()

# 11. Show Null conditional operator for a method
${BitService}?.Stop()

# 12. Test Null property name access
$x = $null
${x}?.propname
$x = @{Propname=42}
${x}?.propname

# 13. Test array member access if a null object
$y = $null
${y}?[0]
$y = 1,2,3
${y}?[0]

# 14. Use Background processing operator &
Get-CimClass -ClassName Win32_Bios &

# 15. Get the results of the job
$JobId = (Get-Job | Select -last 1).Id
Wait-Job -id $JobId
$Results = Receive-Job -Id $JobId
$Results | 
  Get-Member | 
    Select-Object -First 1

# 16. View the output
$Results

