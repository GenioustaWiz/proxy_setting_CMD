@echo off
setlocal

:: Prompt user to input the proxy variable
set /p proxy_variable="Please enter the proxy variable (e.g., 136.4): "

:: Confirm the input
echo You entered: %proxy_variable%

:: Set Git proxy
echo Setting Git proxy...
git config --global http.proxy http://192.168.%proxy_variable%:8080

:: Update environment variables (system-level)
echo Updating environment variables...
setx HTTP_PROXY "192.168.%proxy_variable%:8080" /M
setx HTTPS_PROXY "192.168.%proxy_variable%:8080" /M

:: Update system network proxy settings using PowerShell
echo Updating system proxy settings...

:: This part opens PowerShell to configure the system-wide proxy settings
powershell -Command ^
    "$proxyAddress = '192.168.%proxy_variable%';" ^
    "$proxyPort = '8080';" ^
    "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value ($proxyAddress + ':' + $proxyPort);" ^
    "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value 1;" ^
    "Write-Host 'Proxy settings updated.'"

echo All tasks completed.

endlocal
pause
