# 15.1 -= Exploring WMI in Windows 

# Run on SRV1

# 1. Viewing the WBEM Folder
$WBEMFOLDER = "$Env:windir\system32\wbem"
Get-ChildItem -Path $WBEMFOLDER |
  Select-Object -First 20

# 2. Viewing the WMI repository folder  
Get-ChildItem -Path $WBEMFOLDER\Repository

# 3. Viewing the WMI Service details
Get-Service -Name Winmgmt  | 
  Format-List -Property *

# 4. Getting Process details
$S = tasklist /svc /fi "SERVICES eq winmgmt" |
       Select-Object -Last 1
$P = [int] ($S.Substring(30,4))
Get-Process -Id $P 

# 5. Examine DLLs loaded by the WMI Service Process
Get-Process -Id $P | 
  Select-Object -ExpandProperty modules | 
    Where-Object ModuleName -match 'wmi' |
      Format-Table -Property FileName, Description, FileVersion

# 6. Discovering WMI Providers
Get-ChildItem -Path $WBEMFOLDER\*.dll | 
  Select-Object -ExpandProperty Versioninfo | 
    Where-Object FileDescription -match 'prov' |
      Format-Table -Property Internalname, 
                             FileDescription, 
                             ProductVersion
  
# 6. Finding the WMI event log
$Log = Get-WinEvent -ListLog *wmi*
$Log

# 7. Looking at the Eventg Types in the WMI log
$Events = Get-WinEvent -LogName $Log.LogName
$Events| Group-Object -Property LevelDisplayName

# 8. Examining WMI event log entries|
$Events |
  Select-Object -First 5 |
    Format-Table -Wrap

# 9.Viewing executable programds in WBEM folder
$Files = Get-ChildItem -Path $WBEMFOLDER\*.exe
"{0,15}  {1,-40}" -f 'File Name','Description'
Foreach ($File in $Files){
 $Name = $File.Name
 $Desc = ($File | 
          Select-Object -ExpandProperty VersionInfo).FileDescription
"{0,15}  {1,-40}" -f $Name,$Desc
}
