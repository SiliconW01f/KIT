@ECHO OFF

TITLE 591SU COMPUTER TRIAGE TOOL
CLS
COLOR 0A

SET "DD=%DATE:~0,2%"
SET "MM=%DATE:~3,2%"
SET "YY=%DATE:~8,2%"
SET "HR=%TIME:~0,2%"
SET "MIN=%TIME:~3,2%"
SET "SEC=%TIME:~6,2%

IF "%DD:~0,1%" == " " SET DD=0%DD:~1,1%
IF "%MM:~0,1%" == " " SET MM=0%MM:~1,1%
IF "%HR:~0,1%" == " " SET HR=0%HR:~1,1%
IF "%MIN:~0,1%" == " " SET MIN=0%MIN:~1,1%
IF "%SEC:~0,1%" == " " SET SEC=0%SEC:~1,1%

SET "DTG=%YY%%MM%%DD%_%HR%%MIN%"

ECHO ----------------------------
ECHO  591SU COMPUTER TRIAGE TOOL
ECHO ----------------------------
ECHO.

CD %~dp0

MKDIR OUTPUT 2>NUL& CD OUTPUT
MKDIR %COMPUTERNAME% 2>NUL& CD %COMPUTERNAME%
MKDIR %DTG% 2>NUL

NET session >nul 2>&1
IF %ERRORLEVEL% == 0 GOTO STAGE1

CHOICE /C CE /N /T 30 /D C /M "Without Administrative permissions memory dump and IOC scan will not be available. [C]ontinue or [E]xit?: "

IF "%ERRORLEVEL%" == "2" EXIT

CLS
ECHO -----------------------
ECHO  COMPUTER TRIAGE TOOL
ECHO -----------------------
ECHO.
TIMEOUT /T 1 >NUL
ECHO Stage 1 of 3 - Memory Dump - Failed (Cannot dump memory without administrative permissions)
ECHO.
TIMEOUT /T 1 >NUL
ECHO Stage 2 of 3 - IOC Scan - Failed (Cannot scan for IOCs without administrative permissions)
ECHO.
TIMEOUT /T 1 >NUL
GOTO STAGE3

:STAGE1
CD %~dp0\bin

ECHO Stage 1 of 3 - Memory Dump
ECHO.

ECHO %DATE% %TIME% - Scan Started by %USERNAME% > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\11_Scan_Log.txt
ECHO %DATE% %TIME% - Memory Dump Started >> %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\11_Scan_Log.txt
DumpIt.exe /Q /O %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\Memory_Dump_%COMPUTERNAME%_%DTG%.dmp >NUL 2>NUL
ECHO %DATE% %TIME% - Memory Dump Finished >> %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\11_Scan_Log.txt

CD loki
ECHO Stage 2 of 3 - IOC Scan
ECHO.
ECHO %DATE% %TIME% - IOC Scan Started >> %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\11_Scan_Log.txt
loki.exe --onlyrelevant --dontwait --nofilescan --noindicator -l %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\00_Loki.txt >NUL 2>NUL
REM loki.exe --onlyrelevant --dontwait --intense --noindicator -l %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\00_Loki.txt >NUL 2>NUL
ECHO %DATE% %TIME% - IOC Scan Finished >> %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\11_Scan_Log.txt

:STAGE3
CD %~dp0\bin
ECHO Stage 3 of 3 - Data Collection
ECHO.
ECHO %DATE% %TIME% - System Data Collection Started >> %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\11_Scan_Log.txt
systeminfo > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\01_SystemInfo.txt 2>NUL
wmic useraccount list full > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\02_Local_User_Accounts.txt
autorunsc.exe -nobanner > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\03_Autoruns.txt
pslist -t -nobanner > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\04_Process_List.txt
tasklist /v >> %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\04_Process_List.txt
PsService.exe query -s active -nobanner > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\05_Services.txt 2>NUL
psloglist.exe > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\06_Event_Log.txt 2>NUL
Tcpvcon.exe -a > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\07_TCP_Connections.txt 2>NUL
ipconfig /displaydns > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\08_DNS_Cache.txt
route print > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\09_Routing_Table.txt
driverquery > %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\10_Drivers.txt

ECHO %DATE% %TIME% - System Data Collection Ended >> %~dp0OUTPUT\%COMPUTERNAME%\%DTG%\11_Scan_Log.txt

pause
explorer %~dp0OUTPUT\%COMPUTERNAME%\%DTG%
