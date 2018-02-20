$Url = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.70-installer.msi"
Invoke-WebRequest -Uri "$Url" -OutFile "C:\Packages\putty-64bit-0.70-installer.msi"
msiexec.exe /i C:\Packages\putty-64bit-0.70-installer.msi  /qn

$Url = "https://winscp.net/download/WinSCP-5.13-Setup.exe"
Invoke-WebRequest -Uri "$Url" -OutFile "C:\Packages\WinSCP-5.13-Setup.exe"
msiexec.exe /i C:\Packages\WinSCP-5.13-Setup.exe  /qn
