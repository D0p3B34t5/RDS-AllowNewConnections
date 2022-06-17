$date = $(get-date -Format "MM/dd/yyyy HH:MM")

$collections = ""
function Get-OffConnections {
    foreach ($shost in $collections) {
        Get-RDSessionHost $shost
    }
}

$OffCons = $(Get-OffConnections | findstr "No")

If ($OffCons -eq $null) {
    "======================================================================================" >> C:\NoRestart.log
    "No Session Hosts were set to deny connections when this script ran at $date" >> C:\NoRestart.log
    exit
} else {
    $Servers = $($OffCons.SubString(31) | foreach {
        write-output $_.Replace("No", "")
    }
    )
}

function AllowNewConns_Restart {
    foreach ($serv in $Servers.TrimEnd()) {
        $loggedon = $(query.exe user /server:$serv)
        If ($loggedon -eq $null) {
            Set-RDSessionHost -SessionHost $serv -NewConnectionAllowed Yes -ConnectionBroker ""
            Restart-Computer $serv            
        }
        else {
            "======================================================================================" >> C:\NoRestart.log
            "$serv had logged on users when attempting to restart at $date. Session Host did not restart." >> C:\NoRestart.log     
        }
    }
}

AllowNewConns_Restart
Exit



#ezlife