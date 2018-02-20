$Url = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.70-installer.msi"
Invoke-WebRequest -Uri "$Url" -OutFile "C:\Packages\putty-64bit-0.70-installer.msi"
msiexec.exe /i C:\Packages\putty-64bit-0.70-installer.msi  /qn | Out-Null

$Url = "https://spektraazurelabs.blob.core.windows.net/saplabs/WinSCP-5.13-Setup.exe"
Invoke-WebRequest -Uri "$Url" -OutFile "C:\Packages\WinSCP-5.13-Setup.exe"
C:\Packages\WinSCP-5.13-Setup.exe  /VERYSILENT | Out-Null
