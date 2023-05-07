#!/usr/bin/env bash

usage() { 
    echo "Usage: $(dirname $0) -n <SHARE_NAME> [-p <MOUNT_PATH>]"
}

name=
path=
while getopts ":n:p:" o; do
    case "$o" in
        n)
            name=${OPTARG}
            ;;
        p)
            path=${OPTARG}
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$name" ]; then
    echo "Share name not specified"
    exit 1
fi

if [ -z "$path" ]; then
    path=$HOME/$name
fi

name="volume_${name}"
echo "Creating empty directory: $path"
mkdir -p $path

found=$(grep $name /etc/fstab)
if [ -z "$found" ]; then
    echo "Adding entry to /etc/fstab"
    cp /etc/fstab $HOME
    cp $HOME/fstab $HOME/fstab.bak
    echo """
$name $path vboxsf  defaults,uid=1000,gid=1000,umask=0022  0 0
""" >> $HOME/fstab
    sudo cp $HOME/fstab /etc/
    sudo mount -a
fi
