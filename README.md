# RDS-AllowNewConnections
A simple PowerShell script to automate pulling all session hosts within each of your Remote Desktop Services collections that have the "AllowNewConnections" attribute set to false, setting it back to True and restarting the host.


# What this script does:
   - Grabs the date/time in which the script started running
   - Iterates through your RDS colletions running the Get-RDSessionHost cmdlet to pull back all session hosts
   - Filters out all the connetion hosts that don't have the "AllowNewConnections" attribute set to False into a second array
     - If no session hosts have the "AllowNewConnections" attribute set to **False** then the script will end itself
     - Will write the output to a file called "NoRestart.log" on the C: drive
   - Iterates through each server and checks for logged in users
     - If there are users loggged into the session host when the script runs, the script will end itself and write the error to the "NoRestart.log" file on the C: drive.
       - Uses query.exe to check for logged in users
   - If no users are logged on, AllowNewConnections will:
     - Use the Set-RDSessionHost cmdlet to set the AllowNewConnections attribute back to True
     - Restart the session host

# Requirements:
  - This script must be run on a server that has an active RDS deployment installed
  - This script must be run with an account that has sufficient permissions to both interact with RDS deployments, and restart domain computer objects remotely.
  - RemoteDesktop Powershell Module installed
  - You'll need to edit:
    - The $collections array
      - Input your collection names
    - Specify the Connection Broker argument in the Set-RDSessionHost cmdlet command.
