@echo off

setlocal EnableExtensions EnableDelayedExpansion

color 0a

cd /d %~dp0\config
for /f "delims=:" %%a in (EventLog.cfg) do (
set /a c+=1
set x[!c!]=%%a
)
set x > nul
set eventid=%x[1]%
set eventtime=%x[2]%

:setdtg

FOR /F "tokens=1*" %%A IN ('REG.EXE QUERY 
"HKLM\SYSTEM\CURRENTCONTROLSET\CONTROL\TIMEZONEINFORMATION" 
/V ACTIVETIMEBIAS') DO FOR %%C IN (%%B) DO SET HEXOFFSET=%%C


IF %HEXOFFSET%==0xfffffcb8 SET DECIMALOFFSET=-840
IF %HEXOFFSET%==0xfffffcf4 SET DECIMALOFFSET=-780
IF %HEXOFFSET%==0xfffffd30 SET DECIMALOFFSET=-720
IF %HEXOFFSET%==0xfffffd6c SET DECIMALOFFSET=-660	
IF %HEXOFFSET%==0xfffffda8 SET DECIMALOFFSET=-600	
IF %HEXOFFSET%==0xfffffde4 SET DECIMALOFFSET=-540
IF %HEXOFFSET%==0xfffffe20 SET DECIMALOFFSET=-480
IF %HEXOFFSET%==0xfffffe5c SET DECIMALOFFSET=-420
IF %HEXOFFSET%==0xfffffe98 SET DECIMALOFFSET=-360
IF %HEXOFFSET%==0xfffffed4 SET DECIMALOFFSET=-300
IF %HEXOFFSET%==0xffffff10 SET DECIMALOFFSET=-240
IF %HEXOFFSET%==0xffffff2e SET DECIMALOFFSET=-210
IF %HEXOFFSET%==0xffffff4c SET DECIMALOFFSET=-180
IF %HEXOFFSET%==0xffffff88 SET DECIMALOFFSET=-120
IF %HEXOFFSET%==0xffffffc4 SET DECIMALOFFSET=-60
IF %HEXOFFSET%==0x0 SET DECIMALOFFSET=0
IF %HEXOFFSET%==0x3c SET DECIMALOFFSET=60
IF %HEXOFFSET%==0x78 SET DECIMALOFFSET=120
IF %HEXOFFSET%==0xb4 SET DECIMALOFFSET=180
IF %HEXOFFSET%==0xd2 SET DECIMALOFFSET=210
IF %HEXOFFSET%==0xf0 SET DECIMALOFFSET=240
IF %HEXOFFSET%==0x10e SET DECIMALOFFSET=270
IF %HEXOFFSET%==0x12c SET DECIMALOFFSET=300
IF %HEXOFFSET%==0x14a SET DECIMALOFFSET=330
IF %HEXOFFSET%==0x159 SET DECIMALOFFSET=345
IF %HEXOFFSET%==0x168 SET DECIMALOFFSET=360
IF %HEXOFFSET%==0x186 SET DECIMALOFFSET=390
IF %HEXOFFSET%==0x1a4 SET DECIMALOFFSET=420
IF %HEXOFFSET%==0x1e0 SET DECIMALOFFSET=480
IF %HEXOFFSET%==0x21c SET DECIMALOFFSET=540
IF %HEXOFFSET%==0x23a SET DECIMALOFFSET=570
IF %HEXOFFSET%==0x258 SET DECIMALOFFSET=600
IF %HEXOFFSET%==0x294 SET DECIMALOFFSET=660
IF %HEXOFFSET%==0x2d0 SET DECIMALOFFSET=720
IF %HEXOFFSET%==0x30c SET DECIMALOFFSET=780

set /a UTCOffset=%DECIMALOFFSET% / 60
set hour=%time:~0,2%
set /a hour=%hour%+%UTCOffset%
set minute=%time:~3,2%

if %hour% LSS 0 set /a hour = 24+%hour%& set /a day=-1&gotodatechange
if %hour% GTR 23 set /a hour = %hour%-24& set /a day=1&gotodatechange
set day=0

:datechange
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,now) : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "result=%%a"
del "%temp%\%~n0.vbs"
set "YY=%result:~2,2%"
set "MM=%result:~4,2%"
set "DD=%result:~6,2%"
set "data=%yyyy%-%mm%-%dd%"
set year=%YY%
set month-num=%MM%
set day=%DD%

IF %hour% LSS 10 SET hour=0%hour%
rem IF %day% LSS 10 SET day=0%day%


if %month-num%==01 set month=JAN
if %month-num%==02 set month=FEB
if %month-num%==03 set month=MAR
if %month-num%==04 set month=APR
if %month-num%==05 set month=MAY
if %month-num%==06 set month=JUN
if %month-num%==07 set month=JUL
if %month-num%==08 set month=AUG
if %month-num%==09 set month=SEP
if %month-num%==10 set month=OCT
if %month-num%==11 set month=NOV
if %month-num%==12 set month=DEC

:checklocal

if "%~1"=="" call :localhost

:start
set logname=%day%%hour%%minute%Z%month%%year%-%~1%scantype%-%computername%.log

del /q "%~dp0\loki\scancomplete-*.tmp" 2>nul >nul

echo 1. IPConfig >> "%~dp0\datacollect-%~2%UID%.tmp"
echo 2. PSLogList >> "%~dp0\datacollect-%~2%UID%.tmp"
echo 3. PSList%3 >> "%~dp0\datacollect-%~2%UID%.tmp"
echo 4. AutoRuns%3 >> "%~dp0\datacollect-%~2%UID%.tmp"
echo 5. PsService%3 >> "%~dp0\datacollect-%~2%UID%.tmp"
echo 6. TCPView >> "%~dp0\datacollect-%~2%UID%.tmp"

echo. >> "%~dp0\datacollect-%2%UID%.tmp"
echo -----1. IPConfig----- >> "%~dp0\datacollect-%~2%UID%.tmp"
echo. >> "%~dp0\datacollect-%2%UID%.tmp"

ipconfig | findstr /R /C:"IPv4 Address" >> "%~dp0\datacollect-%2%UID%.tmp"
ipconfig | findstr /R /C:"IP Address" >> "%~dp0\datacollect-%2%UID%.tmp"

cd /d %~dp0\bin

echo. >> "%~dp0\datacollect-%2%UID%.tmp"
echo -----2. PSLogList----- >> "%~dp0\datacollect-%2%UID%.tmp"
echo. >> "%~dp0\datacollect-%2%UID%.tmp"
psloglist -accepteula -h %eventtime% -i %eventid% >> "%~dp0\datacollect-%2%UID%.tmp"

echo. >> "%~dp0\datacollect-%2%UID%.tmp"
echo -----3. PSList%3----- >> "%~dp0\datacollect-%2%UID%.tmp"
echo. >> "%~dp0\datacollect-%2%UID%.tmp"
pslist%3%osarchitecture% -t -accepteula -nobanner >> "%~dp0\datacollect-%2%UID%.tmp"

echo. >> "%~dp0\datacollect-%2%UID%.tmp"
echo -----4. AutoRuns%3%osarchitecture%----- >> "%~dp0\datacollect-%2%UID%.tmp"
echo. >> "%~dp0\datacollect-%2%UID%.tmp"
autorunsc%3%osarchitecture%.exe -nobanner -accepteula > "%~dp0\autorunsc-%2%UID%.tmp"
type "%~dp0\autorunsc-%2%UID%.tmp" >> "%~dp0\datacollect-%2%UID%.tmp"
del /q "%~dp0\autorunsc-%2%UID%.tmp"

echo. >> "%~dp0\datacollect-%2%UID%.tmp"
echo -----5. PsService%3%osarchitecture%----- >> "%~dp0\datacollect-%2%UID%.tmp"
echo. >> "%~dp0\datacollect-%2%UID%.tmp"
PsService%3%osarchitecture%.exe query -s active -accepteula >> "%~dp0\datacollect-%2%UID%.tmp"

echo. >> "%~dp0\datacollect-%2%UID%.tmp"
echo -----6. TCPView----- >> "%~dp0\datacollect-%2%UID%.tmp"
echo. >> "%~dp0\datacollect-%2%UID%.tmp"
tcpvcon.exe -n -a -accepteula >> "%~dp0\datacollect-%2%UID%.tmp"
type "%~dp0\datacollect-%2%UID%.tmp" > "%~dp0\datacollect-%2%UID%.txt"

del /q "%~dp0\datacollect-%2%UID%.tmp"

if "%~1"=="Full" "%~dp0\loki\loki.exe" --onlyrelevant --dontwait --intense --noindicator -l "%~dp0\logs\%logname%"

if "%scantype%"=="Full" "%~dp0\loki\loki.exe" --onlyrelevant --dontwait --intense --noindicator -l "%~dp0\logs\%logname%"

if "%~1"=="Proc_Only" "%~dp0\loki\loki.exe" --onlyrelevant --dontwait --nofilescan --noindicator -l "%~dp0\logs\%logname%"

if "%scantype%"=="Proc_Only" "%~dp0\loki\loki.exe" --onlyrelevant --dontwait --nofilescan --noindicator -l "%~dp0\logs\%logname%"

if %errorlevel%==-1 "echo Error Running Loki Scan. This version of Windows may not be compatible" >> "%~dp0\logs\%logname%"

echo. >> "%~dp0\logs\%logname%"
echo -----Data Collection----- >> "%~dp0\logs\%logname%"

type "%~dp0\datacollect-%2%UID%.txt" >> "%~dp0\logs\%logname%"

del /q "%~dp0\datacollect-%2%UID%.txt"

echo. > "%~dp0\loki\scancomplete-%2%UID%.tmp"

exit

:localhost

:checkadminlocal
call :banner
net session >nul 2>&1
    if %errorLevel% == 0 (
        goto checkinternetlocal
    ) else (
        echo *** Script Requires Admin Permissions ***&timeout /t 5 > nul&goto eof
    )

:checkinternetlocal
call :banner
ping 8.8.8.8 -n 1 | find /i "bytes=" > nul
if errorlevel 1 goto runlocal

echo Running on Localhost
echo.
choice /c YN /n /t 10 /d N /m "Update Loki Signatures? [Y/N]: "

if "%errorlevel%" == "2" goto runlocal
if "%errorlevel%" == "1" "%~dp0/loki\loki-upgrader.exe"

:runlocal
call :banner
echo Running on Localhost
echo.
echo [P] - Process Only IOC Scan
echo [F] - Full IOC Scan
echo.
choice /c PF /n /t 10 /d P /m ": "

if "%errorlevel%" == "2" set scantype=Full
if "%errorlevel%" == "1" set scantype=Proc_Only

echo.
set time0=%TIME: =0%
set hour=%time0:~0,2%
set minute=%time0:~3,2%
set second=%time0:~6,2%
set millisecond=%time0:~9,2%

set UID=%hour%%minute%%second%%millisecond%

wmic os get osarchitecture  | find /i "64" > nul
if errorlevel 1 (set osarchitecture=
) else (
set osarchitecture=64
)

:banner

cls
title Kingfisher Investigation Toolkit
echo               .     .--.          
echo             .'^|     ^|__^|          
echo           .'  ^|     .--.     .^|   
echo          ^<    ^|     ^|  ^|   .' ^|_  
echo           ^|   ^| ____^|  ^| .'     ^| 
echo           ^|   ^| \ .'^|  ^|'--.  .-' 
echo           ^|   ^|/  . ^|  ^|   ^|  ^|   
echo           ^|    /\  \^|__^|   ^|  ^|   
echo           ^|   ^|  \  \      ^|  '.' 
echo           '    \  \  \     ^|   /  
echo          '------'  '---'   `'-'   
echo.
echo    ---Kingfisher Investigation Toolkit---
echo.