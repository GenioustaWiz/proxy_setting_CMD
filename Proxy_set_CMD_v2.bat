@echo off
setlocal

:: Prompt user to input the proxy variable
set /p proxy_variable="Please enter the proxy variable (e.g., 136.4): "

:: Confirm the input
echo You entered: %proxy_variable%

:: Ask if the user wants to set a custom proxy port
set "proxy_port=8080"
set /p choice="The default proxy port is 8080. Would you like to change it? (y/n): "
if /i "%choice%"=="y" (
    set /p proxy_port="Please enter the new proxy port: "
)

:: Confirm the proxy and port
echo Proxy IP will be: 192.168.%proxy_variable%
echo Proxy Port will be: %proxy_port%

:: Set Git proxy
echo Setting Git proxy...
git config --global http.proxy http://192.168.%proxy_variable%:%proxy_port%
git config --global https.proxy https://192.168.%proxy_variable%:%proxy_port%

:: Update environment variables (system-level)
echo Updating environment variables...
setx HTTP_PROXY "192.168.%proxy_variable%:%proxy_port%" /M
setx HTTPS_PROXY "192.168.%proxy_variable%:%proxy_port%" /M

:: Update system network proxy settings using PowerShell
echo Updating system proxy settings...

:: This part opens PowerShell to configure the system-wide proxy settings
powershell -Command ^
    "$proxyAddress = '192.168.%proxy_variable%';" ^
    "$proxyPort = '%proxy_port%';" ^
    "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value ($proxyAddress + ':' + $proxyPort);" ^
    "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value 1;" ^
    "Write-Host 'Proxy settings updated.'"

echo All tasks completed.

:: Display the final proxy settings to the user
echo.
echo Proxy settings currently set:
echo Proxy IP: 192.168.%proxy_variable%
echo Proxy Port: %proxy_port%
echo.
pause
endlocal
