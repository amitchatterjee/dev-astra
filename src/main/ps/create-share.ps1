Param(
    [String]$name,
    [String]$hostPath
)

if (-not $name -or -not $hostPath) {
    Write-Error "name and/or hostpath not specified"
    Exit(1)
}

if (-not $env:PATH.contains('VirtualBox')) {
    Write-Output "Adding VirtualBox binaries to the PATH"
    $env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox"
}

$QualifiedName = "volume_${name}" 
# Setup shared folder
$Found = (VBoxManage showvminfo Cloudy | Select-String -Pattern $QualifiedName)
if ($Found.Length -eq 0) {
    Write-Output "Adding volume: $QualifiedName"
    VBoxManage sharedfolder add "Cloudy" --name $QualifiedName --hostpath $hostPath
}