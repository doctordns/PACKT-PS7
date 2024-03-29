# Recipe 16.3 - Deploy IIS in a container
#
# Run from CH1 after 16.1
# Also Run inside the console, NOT the ISE

# 1.  Creating ReskitApp folder:
$EA = @{ErrorAction='SilentlyContinue'}
New-Item -Path C:\ReskitApp -ItemType Directory @EA

#  2. Create a web page:
$Fn = 'C:\Reskitapp\Index.htm'
$Index = @"
<!DOCTYPE html>
<html><head><title>
ReskitApp Container Application</title></head>
<body><p><center><b>
HOME PAGE FOR RESKITAPP APPLICATION</b></p>
Running in a container in Windows Server 2019<p>
</center><br><hr></body></html>
"@
$Index | Out-File -FilePath $Fn

# 3. Get a server core with IIS image from the Docker registry:
docker pull mcr.microsoft.com/windows/iis:latest

# 4. Now run the image as a container named rkwebc:
$image = 'mcr.microsoft.com/windows/servercore/iis'
docker run --isolation=hyperv -d -p80:80 --name rkwebc "$image" --mount 'type=bind,source="C:/ReskitApp/",target="C:/Inetpub/wwwroot/ReskitApp"'

#  5.Copy our file into the container:
Set-Location -Path C:\Reskitapp
docker cp .\index.htm rkwebc:c:\inetpub\wwwroot\index.htm

# 6. View the page:
Start-Process "Http://CH1.Reskit.Org/ReskitApp/Index.htm"

# 7. Clean up:
docker rm rkwebc -f | Out-Null
docker image rm  mcr.microsoft.com/windows/servercore/iis | 
  Out-Null