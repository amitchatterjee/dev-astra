# TODO - explain the purpose of the project :-)


# Setup appropriate permissions to execute powershell scripts
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install chocolatey (as non Admin user)
install_choco.ps1

# Setup VM
setup-vm

# Start/stop/sh on the VM
vmctl start/stop/sh

# Setup password-less VM accessible
setup-nopasswd-access.ps1

# Create a new share
vmctl stop
create-share -name <NAME> -hostPath <WINDOWS_PATH>
vmctl start
vmctl sh
    # Run the script (TODO need to add the script to the VM path)
    mount_host_volume.sh -n <NAME (same name as above)>