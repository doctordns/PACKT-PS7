# 2.1 Exploring New Operators

# Run on SRV1 after installing PowerShell 7 and VS C0de

# Pipeline chain operators && and ||

# 1. Do it traditionly
Write-Output 'Something that succeeds'
if ($?) {Write-Output 'It worked'}

# 2. With Pipeline chain using &&
Write-Output 'Something that succeeds' && Write-Output 'It worked'

#. 3 With Pipeline chain using ||
Write-Output 'Something that succeeds' || 
  Write-Output 'You do not see this message'

# 4. Define a function
function Install-CacadiaPLFont{
  Write-Host 'Installing Cascadia PL font...'
}

# 5. Demonstrate || operator
$OldErrorAction        = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
Get-ChildItem -Path C:\FOO\CASCADIAPL.TTF | OUT-NULL || 
   Install-CacadiaPLFont
$ErrorActionPreference = $OldErrorAction

# 5. Null Coalescing operator
Function Test-NCO {
 if ($args ='42') {
   Return 'The Meaning of life, the Universe, and Everything'
 }
}
$Result1 = Test-NCO
if ($null -eq $Result1) {
    'Find a better quote'
} else {
    $Result1
}
#   
$Result2 = Test-NCO 42
if ($null -eq $Result2) {
    'Find a better quote'
} else {
    $Result2
}
# using Null Coalescing operator ??
$Result3 =  Test-NCO
$Result3 ?? 'Function did not return a value'
#
$Result4 =  Test-NCO 42
$Result4 ?? 'This is not output, but result is'

# 6. Null Conditional Assignment Operator
$Result5 = Test-NCO
$Result5 ?? 'Result is is null'
$Result5 ??= Test-NCO 42
$Result5



# 7. Null Conditional Operators
$BitService.Stop()

${BitsService}?.Stop()