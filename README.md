# Kingfisher Investigation Toolkit

Scripted method for undertaking basic incident response investigative tasks on a domain.

##### Works on Vista and Newer Operating Systems. XP not supported due to the limitations of dependencies.

1. Download and unzip KIT<br />
1. Download latest release of Loki from https://github.com/Neo23x0/Loki/releases/latest and unzip into the loki directory<br />
1. Download the Sysinternals files from https://docs.microsoft.com/en-us/sysinternals/downloads/pstools and copy the tools to the locations detailed below

\bin

  * PsExec.exe  
  * PsExec64.exe  
  * psshutdown.exe  

\client\bin\

  * autorunsc.exe  
  * autorunsc64.exe  
  * pskill.exe  
  * pskill64.exe  
  * pslist.exe  
  * pslist64.exe  
  * psloglist.exe  
  * PsService.exe  
  * PsService64.exe  
  * Tcpvcon.exe  

If creating installer, download NSIS from http://nsis.sourceforge.net/Download and compile from KIT Installer.nsi

If not create folders:

  * C:\ProgramData\Kingfisher Investigation Toolkit (copy Target_Host_List.txt)  
  * C:\ProgramData\Kingfisher Investigation Toolkit\config (Copy the EventLog.cfg and LogStore.cfg)  
  * C:\ProgramData\Kingfisher Investigation Toolkit\logs  

Custom signature files can be generated using https://github.com/SiliconW01f/bash_scripts/blob/master/yarGen.sh and https://github.com/SiliconW01f/KIT/blob/master/tools/IOC_to_Loki.xlsx

### Setup Instructions:

1. Edit the first line of "C:\ProgramData\Kingfisher Investigation Toolkit\Config\EventLog.cfg" with required Windows Event IDs seperated by commas(,).

1. Edit the first line of "C:\ProgramData\Kingfisher Investigation Toolkit\Config\EventLog.cfg" with the number of hours of Windows Event Logs to Search.

1. Edit "C:\ProgramData\Kingfisher Investigation Toolkit\Config\LogStore.cfg" with the location logs will be stored. This can be a network share or a local path.
By default logs will be stored to the installation directory in a logs subfolder.

1. Edit "C:\ProgramData\Kingfisher Investigation Toolkit\Target_Host_List.txt" with a list of the IP addresses or hostnames of target hosts (User must be able to access the remote devices with current credentials).

### User Instructions:

##### Note: If network devices or host firewall is set to drop ICMP, PING tests will fail and should be removed from the script before running

Requires Admin permissions (Right-click run as administrator)

If an internet connection is detected you will be asked if you want to update the Loki signatures

### Options:

[P] - Process Only IOC Scan (Perfom data collection and a process only Loki scan excluding the file system)  
  * [S] - Single Remote Host (Run on single remote host, you will be prompted for the IP or hostname)  
  * [T] - Target Host List (Run on all hosts listed in the Target Host List file)  
  * [L] - Localhost (Run on local host)  
  * [B] - Back (Back to main menu)  

[F] - Full IOC Scan (Perfom data collection and a full Loki scan including the file system)  
  * [S] - Single Remote Host (Run on single remote host, you will be prompted for the IP or hostname)  
  * [T] - Target Host List (Run on all hosts listed in the Target Host List file)  
  * [L] - Localhost (Run on local host)  
  * [B] - Back (Back to main menu)  
  
[M] - Memory Dump (Dump memory of a specific process, running process list will be displayed)

[R] - Reboot Host (Reboot a remote host)

[K] - Kill Processes(Kill a specific process, running process list will be displayed)

[S] - Manage Services (Either restart or stop a service, active service list will be displayed)  
  * [S] - Stop Service  
  * [R] - Restart Service  
  * [B] - Back  

[T] - Continuous Host Availability Test (Continually test connectivity using PING on the hosts listed in the Target Host List file)<br />
Note: this will only display failed PINGs

[O] - Open Log Repository (Open the location of the log store in explorer

[E] - Exit
