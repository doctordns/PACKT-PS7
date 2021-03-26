# Recipe 8.2 - Deploying sample containers
#
#  Run on CH1


# 1. Find hello-world containers at the Docker Hub
docker search hello-world

# 2. Pull the Docker official hello-world image
docker pull hello-world

# 3. Checking available images
docker image ls

# 4. Running the official hello-world container image
docker run --isolation=hyperv hello-world 

# 5. Looking for Microsoft images on the Docker Hub
docker search microsoft

# 6. Getting server core server base image
docker image pull mcr.microsoft.com/windows/servercore:ltsc2019

# 7. Running the nanoserver base image
docker run --isolation=hyperv mcr.microsoft.com/windows/servercore:ltsc2019

# 8. Checking the images available now on CH1
docker image ls

# 9. Inspect the first image
$Images = docker image ls 
$Rxs = '(\w+)  +(\w+)  +(\w+)  '
$OK = $Images[3] -Match $Rxs
$Image = $Matches[3]  # grab the image name
docker inspect $image | ConvertFrom-Json

# 10. Get another (older) image and try to run it
docker image pull microsoft/nanoserver | Out-Null
docker run microsoft/nanoserver 

# 11. Running it with isolation
docker run --isolation=hyperv microsoft/nanoserver 

# 12. looking at differences in run times with Hyper-V
# run with no isolation
$S1 = Get-Date
docker run hello-world |
    Out-Null
$E1 = Get-Date
$T1 = ($E1-$S1).TotalMilliseconds
# run with isolation
$S2 = Get-Date
docker run --isolation=hyperv hello-world | Out-Null
$E2 = get-date
$T2 = ($E2-$S2).TotalMilliseconds
"Without isolation, took : $T1 milliseconds"
"With isolation, took    : $T2 milliseconds"

# 13. Run a detached container
docker image pull microsoft/iis | Out-Null
docker run --isolation=hyperv -d -p 80:80 microsoft/iis ping -t localhost |
  Out-Null
  
# 14. Useing IIS
Start-Process http://CH1.Reskit.Org
   
# 15. Checking web server Windows feature inside CH1
Get-Windowsfeature -Name Web-Server

# 16. Checking the container
docker container ls

# 17. Killing the continer
$CS = (docker container ls)[1] | 
        Where-Object {$_ -match '(  \w+$)'}
$CN = $Matches[0].trim()
docker container stop ($CN) | Out-Null

# 18. Removing docker images
docker rmi $(docker images -q) -f | out-Null

# 19. Viewing docker status
docker image ls
docker container ls

