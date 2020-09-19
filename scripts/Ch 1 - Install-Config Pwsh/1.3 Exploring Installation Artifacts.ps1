# 1.3 Exploring PWSH 7 Installation Artifacts
#
# Run in PWSH 7 Console

# 1. Check Version Number
$PSVersionTable

# 2. Examine the installation folder
Get-Childitem -Path $env:ProgramFiles\PowerShell\7 -Recurse |
  Measure-Object -Property Length -Sum

# 3. Look at PowerShell Configuration JSON file
Get-ChildItem -Path $env:ProgramFiles\PowerShell\7\powershell*.json | 
  Get-Content

# 4. Check Execution Policy
Get-ExecutionPolicy  

# 5. View Module folders
$I = 0
$ModPath = $env:PSModulePath -split ';'
$ModPath |
  Foreach-Object {
    "[{0:N0}]   {1}" -f $I++, $_
  }

# 6. View the Modules
$TotalCommands = 0
$TotalModules  = 0
Foreach ($Path in $ModPath){
  Try { $Modules = Get-ChildItem -Path $Path -Directory -ErrorAction Stop 
        "Checking Module Path:  [$Path]"
  }
  Catch [System.Management.Automation.ItemNotFoundException] {
    "Module path [$path] DOES NOT EXIST ON $(hostname)"
  }
  Foreach ($Module in $Modules) {
    # "Module [$($module.name)] - Commands: [$($Cmds.Count)]"
    $TotalCommands += $Cmds.Count
    $TotalModules ++
  }
  ""
}

# 7. View totals of command and modules
Get-Module * | Measure-Object
"{0} commands in {1} modules" -f $TotalCommands, $TotalModules



