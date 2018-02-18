                   .     .--.
                 .'|     |__|
               .'  |     .--.     .|
              <    |     |  |   .' |_
               |   | ____|  | .'     |
               |   | \ .'|  |'--.  .-'
               |   |/  . |  |   |  |
               |    /\  \|__|   |  |
               |   |  \  \      |  '.'
               '    \  \  \     |   /
              '------'  '---'   `'-'

        ---Kingfisher Investigation Toolkit---

## Setup Instructions ##

Edit the first line of "C:\ProgramData\Kingfisher Investigation Toolkit\Config\EventLog.cfg" with required Windows Event IDs separated by commas(,).

Edit the first line of "C:\ProgramData\Kingfisher Investigation Toolkit\Config\EventLog.cfg" with the number of hours of Windows Event Logs to Search.

Edit "C:\ProgramData\Kingfisher Investigation Toolkit\Config\LogStore.cfg" with the location logs will be stored. This can be a network share or a local path. By default logs will be stored to the installation directory in a logs subfolder.

Edit "C:\ProgramData\Kingfisher Investigation Toolkit\Target_Host_List.txt" with a list of the IP addresses or hostnames of target hosts (User must be able to access the remote devices with current credentials).

## User Instructions ##

Note: If network devices or host firewall is set to drop ICMP, PING tests will fail and should be removed from the script before running
Requires Admin permissions (Right-click run as administrator)

If an internet connection is detected you will be asked if you want to update the Loki signatures

The two IOC scan options collects data from the targeted host using inbuilt Windows functions and Sysinternals tools:

* Current IP addresses
* Windows log events defined by a configuration file
* Current running processes
* Autorun locations to check for persistence techniques
* Active services
* TCP connections

Options:

[P] - Process Only IOC Scan (Perform data collection and a process only Loki scan excluding the file system)
 + [S] - Single Remote Host (Run on single remote host, you will be prompted for the IP or hostname)
 + [T] - Target Host List (Run on all hosts listed in the Target Host List file)
 + [L] - Localhost (Run on local host)
 + [B] - Back (Back to main menu)

[F] - Full IOC Scan (Perform data collection and a full Loki scan including the file system)
 + [S] - Single Remote Host (Run on single remote host, you will be prompted for the IP or hostname)
 + [T] - Target Host List (Run on all hosts listed in the Target Host List file)
 + [L] - Localhost (Run on local host)
 + [B] - Back (Back to main menu)

[M] - Memory Dump (Dump memory of a specific process, running process list will be displayed)

[R] - Reboot Host (Reboot a remote host)

[K] - Kill Processes (Kill a specific process, running process list will be displayed)

[S] - Manage Services (Either restart or stop a service, active service list will be displayed)
 + [S] - Stop Service
 + [R] - Restart Service
 + [B] - Back

[T] - Continuous Host Availability Test (Continually test connectivity using PING on the hosts listed in the Target Host List file)
Note: this will only display failed PINGs

[O] - Open Log Repository (Open the location of the log store in explorer

[E] - Exit