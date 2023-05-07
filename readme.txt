
# Setup appropriate permissions to execute powershell scripts
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install chocolatey (as non Admin user)
src/main/ps/install_choco.ps1

# Setup password-less VM accessible
src/main/ps/setup-nopasswd-access.ps1

# Start/stop/sh on the VM
src/main/ps/vmctl start/stop/sh
