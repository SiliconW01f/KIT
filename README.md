# Kingfisher Investigation Toolkit

Scripted method for undertaking basic incident response investigative tasks on a domain.

Works on Vista and Newer Operating Systems. XP not supported due to the limitations of dependencies.

Download and unzip KIT<br />
Download latest release from https://github.com/Neo23x0/Loki/releases and unzip into the loki directory<br />
Download the Sysinternals files from https://docs.microsoft.com/en-us/sysinternals/downloads/pstools and copy the tools to the locations detailed below

\script_tools

PsExec.exe<br />
PsExec64.exe<br />
psshutdown.exe<br />

\client\script_tools\

autorunsc.exe<br />
autorunsc64.exe<br />
pskill.exe<br />
pskill64.exe<br />
pslist.exe<br />
pslist64.exe<br />
psloglist.exe<br />
PsService.exe<br />
PsService64.exe<br />
Tcpvcon.exe

If creating install, compile from KIT Installer.nsi

If not create folders:

C:\ProgramData\Kingfisher Investigation Toolkit (copy Target_Host_List.txt)<br />
C:\ProgramData\Kingfisher Investigation Toolkit\config (Copy the EventLog.cfg and LogStore.cfg)<br />
C:\ProgramData\Kingfisher Investigation Toolkit\logs


Setup Instructions:

Edit the first line of "C:\ProgramData\Kingfisher Investigation Toolkit\Config\EventLog.cfg" with required Windows Event IDs seperated by commas(,).

Edit the first line of "C:\ProgramData\Kingfisher Investigation Toolkit\Config\EventLog.cfg" with the number of hours of Windows Event Logs to Search.

Edit "C:\ProgramData\Kingfisher Investigation Toolkit\Config\LogStore.cfg" with the location logs will be stored. This can be a network share or a local path.
By default logs will be stored to the installation directory in a logs subfolder.

Edit "C:\ProgramData\Kingfisher Investigation Toolkit\Target_Host_List.txt" with a list of the IP addresses or hostnames of target hosts (User must be able to access the remote devices with current credentials).
