
New-Item -Path ${HOME}/.ssh -ItemType Directory -Force
ssh-keygen -t rsa -f ${HOME}/.ssh/id_rsa_cloudy -q -N '""'

ssh developer@localhost 'mkdir -p /home/developer/.ssh; chmod 700 /home/developer/.ssh'
scp ${HOME}/.ssh/id_rsa_cloudy.pub developer@localhost:/home/developer/.ssh/authorized_keys
ssh developer@localhost 'chmod 600 /home/developer/.ssh/authorized_keys'

$VMEntry = @"

Host cloudy
    HostName localhost
    User developer
    Port 22
    IdentityFile ${HOME}/.ssh/id_rsa_cloudy

"@
Add-Content "${HOME}/.ssh/config" $VMEntry
