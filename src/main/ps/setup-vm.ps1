
[String]$ScriptFolder = Split-Path ($MyInvocation.MyCommand.Path)

# Setup port mapping for SSH
& ${ScriptFolder}/create-portmap.ps1 -name SSH -hostPort 22

# Setup workspace sharing
& ${ScriptFolder}/create-share.ps1 -name workspace -hostPath "$HOME"
