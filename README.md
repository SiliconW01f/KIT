# Kingfisher Investigation Toolkit

Scripted method for undertaking basic incident response investigative tasks on a domain.

Works on Vista and Newer Operating Systems. XP not supported due to the limitations of dependencies.

Download and unzip KIT
Download latest release from https://github.com/Neo23x0/Loki/releases and unzip into the loki directory
Download the Sysinternals files from https://docs.microsoft.com/en-us/sysinternals/downloads/pstools and copy the tools to the locations detailed below

\script_tools

PsExec.exe
PsExec64.exe
psshutdown.exe

\client\script_tools\

autorunsc.exe
autorunsc64.exe
pskill.exe
pskill64.exe
pslist.exe
pslist64.exe
psloglist.exe
PsService.exe
PsService64.exe
Tcpvcon.exe

If creating install, compile from KIT Installer.nsi

If not create folders:

C:\ProgramData\Kingfisher Investigation Toolkit (copy Target_Host_List.txt)
C:\ProgramData\Kingfisher Investigation Toolkit\config (Copy the EventLog.cfg and LogStore.cfg)
C:\ProgramData\Kingfisher Investigation Toolkit\logs


Setup Instructions:

Edit the first line of "C:\ProgramData\Kingfisher Investigation Toolkit\Config\EventLog.cfg" with required Windows Event IDs seperated by commas(,).

Edit the first line of "C:\ProgramData\Kingfisher Investigation Toolkit\Config\EventLog.cfg" with the number of hours of Windows Event Logs to Search.

Edit "C:\ProgramData\Kingfisher Investigation Toolkit\Config\LogStore.cfg" with the location logs will be stored. This can be a network share or a local path.
By default logs will be stored to the installation directory in a logs subfolder.

Edit "C:\ProgramData\Kingfisher Investigation Toolkit\Target_Host_List.txt" with a list of the IP addresses or hostnames of target hosts (User must be able to access the remote devices with current credentials).
