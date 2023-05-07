if (-not $env:PATH.contains('VirtualBox')) {
    Write-Output "Adding VirtualBox binaries to the PATH"
    $env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox"
}

[String]$ScriptFolder = Split-Path ($MyInvocation.MyCommand.Path)

# Setup port mapping
$Found = (VBoxManage showvminfo Cloudy | Select-String -Pattern 'SSH')
if ($Found.Length -eq 0) {
    Write-Output "Adding portmapping: SSH"
    VBoxManage modifyvm "Cloudy" --natpf1 "SSH,tcp,,22,,22"
}

& ${ScriptFolder}/create-share.ps1 -name workspace -hostPath "$HOME"
Exit 0

# Setup shared folder
$Found = (VBoxManage showvminfo Cloudy | Select-String -Pattern 'volume_workspace')
if ($Found.Length -eq 0) {
    Write-Output "Adding volume: volume_workspace"
    VBoxManage sharedfolder add "Cloudy" --name volume_workspace --hostpath $HOME
}