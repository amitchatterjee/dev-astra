Param(
    [String]$name,
    [Int]$hostPort,
    [Int]$guestPort
)

if (-not $name -or -not $hostPort) {
    Write-Error "name and/or hostPort not specified"
    Exit(1)
}

if ( -not $guestPort) {
    $guestPort = $hostPort
}

if (-not $env:PATH.contains('VirtualBox')) {
    Write-Output "Adding VirtualBox binaries to the PATH"
    $env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox"
}

$QualifiedName = "port_${name}" 
# Setup shared folder
$Found = (VBoxManage showvminfo Cloudy | Select-String -Pattern $QualifiedName)
if ($Found.Length -eq 0) {
    Write-Output "Adding port: $QualifiedName"
    VBoxManage modifyvm "Cloudy" --natpf1 "${QualifiedName},tcp,,${hostPort},,${guestPort}"
}