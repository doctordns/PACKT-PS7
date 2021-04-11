# 14.1 Using PS Script Analyzer

# Run on SRV1

# 1. Discover PS Script Analyzer
Find-Module -Name PSScriptAnalyzer |
  Format-List Name, Type, Desc*, Author, Company*, *Date, *URI*
  
# 2. Installing the script analyzer module
Install-Module -Name PSScriptAnalyzer -Force

# 3. Discovering the commands in this module
Get-Command -Module PSScriptAnalyzer

# 4. Discovering analyizer rules
Get-ScriptAnalyzerRule | 
  Group-Object -Property Severity 
    Sort-Object -Property Count -Descending

# 5. Examining a rule
Get-ScriptAnalyzerRule | 
  Select-Object -First 1 |
    Format-List

# 6. Creating a file with issues
@'
# Bad.ps1
# A file to demonstrate Script Analyzer
#
### Uses an alias
$Procs = gps
### Uses positional parameters
$Services = Get-Service 'foo' 21
### Uses poor function header
Function foo {"Foo"}
### Function redefines a built in command
Function Get-ChildItem {"Sorry Dave I can not do that"}
### Command uses a hard codeed compueter name
Test-Connection -ComputerName DC1
### A line that has trailing whiteace
$foobar ="foobar"                                                                                       
### A line using a global variable
$Global:foo
'@ | Out-File -FilePath "C:\Foo\Bad.ps1"

# 7. Checking the file
Get-ChildItem C:\Foo\Bad.ps1


# 8. Analyzing Bad.ps1
Invoke-ScriptAnalyzer -Path C:\Foo\Bad.ps1 |
  Sort-Object -Property Line
