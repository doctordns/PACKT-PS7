8.4a - setting GP settings in the registry

$OldVerbose = $VerbosePreference
$VerbosePreference = 'Continue'

# 1. Set Execution Policy
# Create Key
$KEYEP = 'HKCU:\Software\Policies\Microsoft\PowerShellCore'
if (Test-Path $KEYEP) {
  Write-Verbose "Registry Key exists [$KEYEP]"
}
Else {
  Write-Verbose "Creating registry key [$KEYEP]"
  New-Item -Path $KEYEP | Out-Null
}
# Set value for execution policy 
Write-Verbose 'Setting Execution Policy On'
$CVHT1   = @{ Path  = $KEYEP
              Name  = 'EnableScripts'
              Type  = 'Dword'
              Value = 1 }
Set-ItemProperty @CVHT1 | Out-Null
Write-Verbose 'Setting Execution Policy to Unrestricted'
$CVHT2   = @{ Path  = $KEYEP
              Name  = 'ExecutionPolicy'
              Type  = 'String'
              Value = 'Unrestricted'}
Set-ItemProperty @CVHT2 | Out-Null

# 2. Set Module Logging
$KEYML1 = 
  'HKCU:\Software\Policies\Microsoft\PowerShellCore\ModuleLogging'
$KEYML2 = "$KEYML1\ModuleNames"
if (Test-Path $KEYML1) {
  Write-Verbose "Registry Key exists [$KEYML1]"
}
Else {
  Write-Verbose "Creating registry key [$KEYML1]"
  New-Item -Path $KEYML1 | Out-Null
}
if (Test-Path $KEYML2) {
  Write-Verbose "Registry Key exists [$KEYML2]"
}
Else {
  Write-Verbose "Creating registry key [$KEYML2]"
  New-Item -Path $KEYML2 | Out-Null
}
# Set Module Logging ON
Write-Verbose 'Setting Module Logging On'
$MLHT1   = @{ Path  = $KEYML1
              Name  = 'EnableModuleLogging'
              Type  = 'Dword'
              Value = 1 }
Set-ItemProperty @MLHT1 | Out-Null

# Set module names to log
$Modules = 'ITModule1','ITModule2'
Write-Verbose "Setting $($modules.count) modules to log"
foreach ($Module in $Modules){
  Write-Verbose "Adding Value for module [$Module]"    
  $MLHT2   = @{ Path  = $KEYML2
                Name  = $Module
                Type  = 'String'
                Value = $Module}
  Set-ItemProperty @MLHT2 | Out-Null
}


# 3. Set Script Block Logging
if (Test-Path $KEYSBL) {
  Write-Verbose "Registry Key exists [$KEYSBL]"
}
Else {
  Write-Verbose "Creating registry key [$KEYSBL]"
  New-Item -Path $KEYSBL | Out-Null
}
Write-Verbose 'Setting Script Block Logging Policy On'
$SBLHT1   = @{ Path  = $KEYSBL
              Name  = 'EnableScriptBlockLogging'
              Type  = 'Dword'
              Value = 1 }
Set-ItemProperty @SBLHT1 | Out-Null

# 4. Set Transcription Policy 
$KEYTP = 
  'HKCU:\Software\Policies\Microsoft\PowerShellCore\Transcription'
if (Test-Path $KEYTP) {
    Write-Verbose "Registry Key exists [$KEYSTP]"
}
Else {
  Write-Verbose "Creating registry key [$KEYTP]"
  New-Item -Path $KEYTP | Out-Null
}
Write-Verbose 'Setting Transcripting On'
$TPHT1   = @{ Path  = $KEYTP
              Name  = 'EnableTranscripting'
              Type  = 'Dword'
              Value = 1 }
Set-ItemProperty @TPHT1 | Out-Null
$TPPath = 'C:\Transcripts'
Write-Verbose "Setting Transcripts to [$TPPath]"
$TPHT2   = @{ Path  = $KEYTP
               Name  = 'OutputDirectory'
               Type  = 'String'
               Value = $TPPath }
Set-ItemProperty @TPHT2 | Out-Null

# 5. Updateable Help policy
$KEYUH = 
  'HKCU:\Software\Policies\Microsoft\PowerShellCore\UpdatableHelp'
if (Test-Path $KEYUH) {
    Write-Verbose "Registry Key exists [$KEYUH]"
}
Else {
  Write-Verbose "Creating registry key [$KEYUH]"
  New-Item -Path $KEYUH | Out-Null
}  
# Enable Source Path
Write-Verbose 'Enable Update Help Default Source Path'
$HTUH1   = @{ Path  = $KEYUH
              Name  = 'EnableUpdateHelpDefaultSourcePath'
              Type  = 'Dword'
              Value = 1 }
Set-ItemProperty @HTUH1 | Out-Null
# Set DefaultSourcePath
$DefaultPath = '\\DC1\Help'
Write-Verbose "Default Source Path: [$DefaultPath]"
$HTUH2   = @{ Path  = $KEYUH
    Name  = 'DefaultSourcePath'
    Type  = 'String'
    Value = $DefaultPath }
Set-ItemProperty @HTUH2 | Out-Null

# 6. Console Session Configuration Policy
$KEYSCP = 
  'HKCU:Software\Policies\Microsoft\PowerShellCore\' +
  'ConsoleSessionConfiguration'
  if (Test-Path $KEYSCP) {
    Write-Verbose "Registry Key exists [$KEYSCP]"
}
Else {
  Write-Verbose "Creating registry key [$KEYSCP]"
  New-Item -Path $KEYSCP | Out-Null
}

EnableConsoleSessionConfiguration