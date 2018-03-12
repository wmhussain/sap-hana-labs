$Url = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.70-installer.msi"
Invoke-WebRequest -Uri "$Url" -OutFile "C:\Packages\putty-64bit-0.70-installer.msi"
msiexec.exe /i C:\Packages\putty-64bit-0.70-installer.msi  /qn | Out-Null

$Url = "https://spektraazurelabs.blob.core.windows.net/saplabs/WinSCP-5.13-Setup.exe"
Invoke-WebRequest -Uri "$Url" -OutFile "C:\Packages\WinSCP-5.13-Setup.exe"
C:\Packages\WinSCP-5.13-Setup.exe  /VERYSILENT | Out-Null

$URL = "https://saphanalabseastus.blob.core.windows.net/saplabs/HDB_STUDIO_WINDOWS_X86_64.zip"
Invoke-WebRequest -Uri "$URL" -OutFile "C:\Packages\HDB_STUDIO_WINDOWS_X86_64.zip" | Out-Null
Expand-Archive -Path C:\Packages\HDB_STUDIO_WINDOWS_X86_64.zip -DestinationPath C:\Packages\ | Out-Null

$Url = "https://saphanalabseastus.blob.core.windows.net/saplabs/SAPHANAonAzure_Lab_Commands_v1.0.txt"
Invoke-WebRequest -Uri "$Url" -OutFile "C:\Users\Public\Desktop\SAPHANAonAzure_Lab_Commands.txt"
