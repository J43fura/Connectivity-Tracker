@echo off
setlocal enabledelayedexpansion

set LOG_FILE=ping_log.txt
set DEFAULT_HOST=google.tn
set DEFAULT_POLLING_TIMER=5

echo.
echo  ____                                        
echo /\  _`\   __                                 
echo \ \ \L\ \/\_\    ___      __      __   _ __  
echo  \ \ ,__/\/\ \ /' _ `\  /'_ `\  /'__`\/\`'__\
echo   \ \ \/  \ \ \/\ \/\ \/\ \L\ \/\  __/\ \ \/ 
echo    \ \_\   \ \_\ \_\ \_\ \____ \ \____\\ \_\ 
echo     \/_/    \/_/\/_/\/_/\/___L\ \/____/ \/_/ 
echo                           /\____/            
echo                           \_/__/             
echo.
echo Welcome to Connectivity tracker (Pinger).
echo Connectivity tracker (Pinger) tracks internet connectivity and logs when it is cut off or restored, resulting in distinct periods.
echo.

set /p HOST=Enter the host to ping (press Enter for default, %DEFAULT_HOST%): 
if "!HOST!"=="" set "HOST=!DEFAULT_HOST!"

set /p POLLING_TIMER=Enter the polling time interval (press Enter for default, %DEFAULT_POLLING_TIMER% seconds): 
if "!POLLING_TIMER!"=="" set "POLLING_TIMER=!DEFAULT_POLLING_TIMER!"

echo Pinging !HOST! and logging to %LOG_FILE%...
echo.

:PING_LOOP
set "PING_SUCCESS=0"
for /f "tokens=*" %%a in ('ping !HOST! -n 1 ^| findstr "TTL="') do (
    set "PING_RESULT=%%a"
    set "PING_SUCCESS=1"
)

if !PING_SUCCESS! equ 1 (
    for /f "tokens=*" %%a in ('echo !PING_RESULT! ^| findstr "TTL="') do (
        call :log_message "Internet connection to !HOST! is up. %%a" !PING_SUCCESS!
    )
) else (
    call :log_message "Internet connection to !HOST! failed." !PING_SUCCESS!
)
timeout /t !POLLING_TIMER! >NUL
goto PING_LOOP



:log_message
if "%2" neq "!LAST_PINGLEVEL!" (
    echo %date% %time% - %~1
    echo %date% %time% - %~1 >> %LOG_FILE%
    set "LAST_PINGLEVEL=%2"
)
exit /b