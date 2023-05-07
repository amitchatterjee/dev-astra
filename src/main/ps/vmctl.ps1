Param (
    [Parameter(Position = 0)]
    [String]$command = 'start'
)

if (-not $env:PATH.contains('VirtualBox')) {
    Write-Output "Adding VirtualBox binaries to the PATH"
    $env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox"
}

if ('start' -eq $command) {
    Write-Output "Starting up the VM"
    VBoxManage startvm Cloudy --type headless
    if (-not $?) {
        Write-Error "Could not start VM"
        Exit(1)
    }

    VBoxManage list runningvms | Select-String 'Cloudy'

    Write-Output "Waiting for the VM to be ready"
    [int]$Count = 10

    $Connected = $False
    while ($Count -gt 0) {
        [string]$Connected = ((Test-NetConnection localhost -Port 22).TcpTestSucceeded)
        if ($Connected) {
            & ssh -o "ConnectTimeout=1" -o "ConnectionAttempts=10" developer@cloudy 'touch /tmp/ping'
            if ($?) {
                Write-Output "Connected"
                $Connected = $True
                Break
            }
        }
        $Count--
        Start-Sleep -s 5
    }

    if (-not $Connected) {
        Write-Error "Could not startup the VM within specified time"
        Exit(1)
    }
}
elseif (('stop' -eq $command)) {
    Write-Output "Shutting down the VM"
    & ssh developer@cloudy 'sudo shutdown -h +1'
    if (-not $?) {
        Write-Error "Could not send shutdown command to the VM"
        Exit(1)
    }

    Write-Output "Sent shutdown command. Waiting for the VM to stop"
    Start-Sleep -s 60

    [int]$Count = 10
    while ($Count -gt 0) {
        $Running = (VBoxManage list runningvms | Select-String 'Cloudy')
        if ($Running.Length -eq 0) {
            Write-Output "VM stopped successfully"
            Break
        }
        Start-Sleep -s 5
        $Count--
    }
}
elseif (('sh' -eq $command)) {
    ssh developer@cloudy
}
