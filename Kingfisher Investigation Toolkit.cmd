@echo off

setlocal EnableExtensions EnableDelayedExpansion

color 0a
del /q "%~dp0\tmp\*.txt" 2>nul >nul
cd /d "C:\ProgramData\Kingfisher Investigation Toolkit\Config"
for /f "delims=" %%a in (LogStore.cfg) do (
set /a c+=1
set x[!c!]=%%a
)
set x > nul
set logs=%x[1]%

xcopy /y /i /d *.cfg "%~dp0\client\config"

call :banner

:checkcompatibility

choice /? 2>nul >nul
if "%errorlevel%" == "9009" echo.&echo This version of Windows is not supported&echo.&pause&exit
timeout /? 2>nul >nul
if "%errorlevel%" == "9009" echo.&echo This version of Windows is not supported&echo.&pause&exit

:checkadmin

net session >nul 2>&1
    if %errorLevel% == 0 (
        goto checkinternet
    ) else (
        echo *** This Program Requires Admin Permissions ***&timeout /t 5 > nul&goto eof
    )

:checkinternet

ping 8.8.8.8 -n 1 | find /i "bytes=" > nul
if errorlevel 1 goto start

choice /c YN /n /t 10 /d N /m "Update Loki Signatures? [Y/N]: "

if "%errorlevel%" == "2" goto start
if "%errorlevel%" == "1" "%~dp0\client\loki\loki-upgrader.exe"

:start

call :banner
echo.
echo [P] - Process Only IOC Scan
echo [F] - Full IOC Scan
echo [M] - Memory Dump
echo [R] - Reboot Host
echo [K] - Kill Processes
echo [S] - Manage Services
echo [T] - Continuous Host Availability Test
echo [O] - Open Log Repository
echo [E] - Exit
echo.
choice /c PFMRKSTOE /n /m ": "
if "%errorlevel%" == "9" exit
if "%errorlevel%" == "8" start /max explorer "%logs%"&goto :start
if "%errorlevel%" == "7" goto availabilitytest
if "%errorlevel%" == "6" goto servicesmenu
if "%errorlevel%" == "5" goto processmenu
if "%errorlevel%" == "4" goto rebootmenu
if "%errorlevel%" == "3" goto memdumpmenu
if "%errorlevel%" == "2" set scantype=Full
if "%errorlevel%" == "1" set scantype=Proc_Only

echo.
call :banner
echo IOC Scan
echo.
echo [S] - Single Remote Host
echo [T] - Target Host List
echo [L] - Localhost
echo [B] - Back
echo.

choice /c STLB /n /m ": "
if "%errorlevel%" == "4" goto start
if "%errorlevel%" == "3" set host=localhost&goto localhost
if "%errorlevel%" == "2" goto multiplehosts
if "%errorlevel%" == "1" goto singlehost

:singlehost

echo.

set /p host=Enter the IP address or hostname: 

ping -n 1 %host%|find "Reply from " >nul
if errorlevel 1 echo.&echo %host% is not currently accessible&echo.&timeout /t 3 > nul&goto start

:localhost

set time0=%TIME: =0%
set hour=%time0:~0,2%
set minute=%time0:~3,2%
set second=%time0:~6,2%
set millisecond=%time0:~9,2%

set UID=%hour%%minute%%second%%millisecond%

wmic /node: %host% os get osarchitecture  | find /i "64" > nul
if errorlevel 1 (set osarchitecture=
) else (
set osarchitecture=64
)

xcopy /e /y /i /d "%~dp0client" "\\%host%\c$\KIT"
cd /d %~dp0/bin
start psexec%osarchitecture%.exe -h -nobanner -accepteula \\%host% cmd /c "echo. | c:\kit\Client.cmd %scantype% %uid% %osarchitecture%"

call :banner
echo Wating for Data collect to complete on %host%

:datacollect
timeout /t 5 > nul
xcopy /y "\\%host%\c$\kit\datacollect-%uid%.txt" "%~dp0\tmp" 2>nul >nul

if exist "%~dp0\tmp\datacollect-%uid%.txt" (start /max notepad "%~dp0\tmp\datacollect-%uid%.txt"
) else (
goto datacollect
)

:txlogs
call :banner
echo Wating for Loki Scan to complete on %host%
timeout /t 5 > nul
xcopy /y "\\%host%\c$\kit\loki\scancomplete-%uid%.tmp" "%~dp0\tmp" 2>nul >nul
if exist "%~dp0\tmp\scancomplete-%uid%.tmp" (xcopy /y /i /d "\\%host%\c$\kit\logs" "%logs%"
) else (
goto txlogs
)

del /q "%~dp0\tmp\scancomplete-%uid%.tmp"

goto start

:multiplehosts
cd /d "%APPDATA%\Kingfisher Investigation Toolkit"
for /F "delims=" %%a in (Target_Host_List.txt) do (
set time0=!TIME: =0!
set hour=!time0:~0,2!
set minute=!time0:~3,2!
set second=!time0:~6,2!
set millisecond=!time0:~9,2!
set UID=!hour!!minute!!second!!millisecond!
xcopy /e /y /i /d "%~dp0client" \\%%a\c$\KIT
wmic /node: %%a os get osarchitecture  | find /i "64" > nul
if errorlevel 1 (set osarchitecture=
) else (
set osarchitecture=64
)
cd /d "%~dp0/bin"
start psexec!osarchitecture!.exe -h -nobanner -accepteula \\%%a cmd /c "echo. | c:\kit\Client.cmd !scantype! !uid! !osarchitecture!"
call :banner
echo Wating for Data collect to complete on %%a
call :datacollect-multi %%a !uid!
del /q "%~dp0\tmp\scancomplete-!uid!.tmp"

)

goto start

:datacollect-multi

timeout /t 5 > nul
xcopy /y "\\%1\c$\kit\datacollect-%2.txt" "%~dp0\tmp" 2>nul >nul
call :banner
echo Waiting for Loki Scan to complete on %1
if exist "%~dp0\tmp\datacollect-%2.txt" (start /max notepad "%~dp0\tmp\datacollect-%uid%.txt"
) else (
goto datacollect-multi
)

:txlogs-multi
timeout /t 5 > nul
xcopy /y "\\%1\c$\kit\loki\scancomplete-%2.tmp" "%~dp0\tmp" 2>nul >nul
if exist "%~dp0\tmp\scancomplete-%2.tmp" (call :banner&echo Transferring log files to repository&xcopy /y /i /d "\\%1\c$\kit\logs" "%logs%" 2>nul >nul
) else (
goto txlogs-multi
)

goto eof 2>nul

:memdumpmenu
call :banner
echo Process Memory Dump
echo.
set host=""
set /p host="Enter Hostname or IP Address (Leave Blank to Go Back): "
echo.

if %host%=="" (goto start)

ping -n 1 %host%|find "Reply from " >nul
if errorlevel 1 echo %host% is not currently accessible&echo.&timeout /t 3 > nul&goto start
xcopy /e /y /i /d "%~dp0client\bin" "\\%host%\c$\KIT\bin" 2>nul >nul
wmic /node: %host% os get osarchitecture  | find /i "64" > nul
if errorlevel 1 (set osarchitecture=
) else (
set osarchitecture=64
)

cd /d %~dp0\bin
psexec%osarchitecture%.exe -h -nobanner -accepteula "\\%host%" cmd /c "echo. | c:\kit\bin\pslist%osarchitecture%.exe -t -accepteula -nobanner"
echo.
set /p pid="Enter PID or Task Name: "
echo.

cd /d %~dp0\bin
psexec%osarchitecture%.exe -s -nobanner -accepteula "\\%host%" cmd /c "echo. | mkdir c:\kit\memdump&c:\kit\bin\procdump -ma %pid% -accepteula c:\kit\memdump\%computername%_PROCESSNAME_YYMMDD_HHMMSS.dmp"

xcopy /i /y /d /e "\\%host%\c$\kit\memdump" "%logs%\memdump" 2>nul >nul

timeout /t 5 > nul
goto start


:rebootmenu
call :banner
set host=""
echo Reboot Remote Hosts
echo.
set /p host="Enter Hostname or IP Address to Reboot (Leave Blank to Go Back): "
echo.

if %host%=="" (goto start)

ping -n 1 %host%|find "Reply from " >nul
if errorlevel 1 echo %host% is not currently accessible&echo.&timeout /t 3 > nul&goto start

cd /d %~dp0\bin
psshutdown.exe -e u:5:19 -f -r -t 0 -accepteula \\%host%

:testping
ping -n 1 %host%|find "Reply from " >nul
if errorlevel 1 echo.&echo %host% has rebooted&echo.&echo %date%-%time%: Host %host% rebooted>> %~dp0\..\Restart_Kill.log&timeout /t 3 > nul&goto start
echo %host% is still up. Retesting in 5 seconds...
timeout /t 5 > nul
goto testping

:processmenu
call :banner
set host=""
echo Manage Processes
echo.

set /p host="Enter Hostname or IP Address (Leave Blank to Go Back): "
echo.

if %host%=="" (goto start)

ping -n 1 %host%|find "Reply from " >nul
if errorlevel 1 echo %host% is not currently accessible&echo.&timeout /t 3 > nul&goto start

xcopy /e /y /i /d "%~dp0client\bin" "\\%host%\c$\KIT\bin" 2>nul >nul

wmic /node: %host% os get osarchitecture  | find /i "64" > nul
if errorlevel 1 (set osarchitecture=
) else (
set osarchitecture=64
)

cd /d %~dp0\bin
psexec%osarchitecture%.exe -h -nobanner -accepteula "\\%host%" cmd /c "echo. | c:\kit\bin\pslist%osarchitecture%.exe -t -accepteula -nobanner"
echo.
set /p pid="Enter PID or Task Name to Kill: "
echo.

cd /d %~dp0\bin
psexec%osarchitecture%.exe -h -nobanner -accepteula "\\%host%" cmd /c "echo. | c:\kit\bin\pskill%osarchitecture%.exe -t -accepteula -nobanner %pid%"

echo %date%-%time%: Task %pid% killed on %host% >> %~dp0\Manage_Processes.log

timeout /t 5 > nul

goto start

:servicesmenu
call :banner
set host=""
echo Manage Services
echo.

set /p host="Enter Hostname or IP Address (Leave Blank to Go Back): "
echo.

if %host%=="" (goto start)

ping -n 1 %host%|find "Reply from " >nul
if errorlevel 1 echo %host% is not currently accessible&echo.&timeout /t 3 > nul&goto start

echo [S] - Stop Service
echo [R] - Restart Service
echo [B] - Back
echo.
choice /c SRB /n /m ": "

if "%errorlevel%" == "3" goto start
if "%errorlevel%" == "2" set servaction=Restart
if "%errorlevel%" == "1" set servaction=Stop

xcopy /e /y /i /d "%~dp0client\bin" "\\%host%\c$\KIT\bin" 2>nul >nul

cd /d %~dp0\bin
psexec%osarchitecture%.exe -h -nobanner -accepteula "\\%host%" cmd /c "echo. | c:\kit\bin\PsService%osarchitecture%.exe query -s active | findstr /R /C:"SERVICE_NAME:"

echo.
set /p serv="Enter Service to %servaction%: "
echo.

psexec%osarchitecture%.exe -h -nobanner -accepteula "\\%host%" cmd /c "echo. | c:\kit\bin\PsService%osarchitecture%.exe %servaction% %serv%"

timeout /t 5 > nul
goto start

:availabilitytest
call :banner
echo Testing connectivity of hosts in Target_Host_List.txt
echo CTRL + C to Exit
echo.

:teststart
cd /d "%APPDATA%\Kingfisher Investigation Toolkit"
for /F "delims=" %%a in (Target_Host_List.txt) do (
ping %%a -n 1 | find /i "bytes=" > nul
if errorlevel 1 echo %time% - %%a is down&timeout /t 5 > nul
)
goto teststart

:banner
title Kingfisher Investigation Toolkit
cls
echo                    .     .--.          
echo                  .'^|     ^|__^|          
echo                .'  ^|     .--.     .^|   
echo               ^<    ^|     ^|  ^|   .' ^|_  
echo                ^|   ^| ____^|  ^| .'     ^| 
echo                ^|   ^| \ .'^|  ^|'--.  .-' 
echo                ^|   ^|/  . ^|  ^|   ^|  ^|   
echo                ^|    /\  \^|__^|   ^|  ^|   
echo                ^|   ^|  \  \      ^|  '.' 
echo                '    \  \  \     ^|   /  
echo               '------'  '---'   `'-'   
echo.
echo         ---Kingfisher Investigation Toolkit---
echo.