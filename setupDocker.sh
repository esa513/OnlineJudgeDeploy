#!/bin/bash

help() {
    echo "This script should not be run as the root user."
    echo "Please execute it as a non-root user using the following command:"
    echo "cat setupDocker.sh | sudo sh"
    exit
}

while getopts 'hH?' opt
do
    case $opt in
        h|H|\?)
            help
            ;;
    esac
done

# Check if the script is being run by the root user.
if [ -z "$SUDO_USER" ] || [ "$SUDO_USER" = "root" ]; then
    help
fi

# Set up the repository
# 1. Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt -y update
apt -y install ca-certificates curl gnupg
# 2. Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
# 3. Use the following command to set up the repository:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
# 4. Update the apt package index:
apt -y update

# Install Docker Engine
apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Manage Docker as a non-root user
# 1. Create the docker group.
groupadd docker
# 2. Add your user to the docker group.
usermod -aG docker $SUDO_USER

# 3. Activate the changes to groups.(sometime not working so don't use this)
# newgrp docker

# Logout and Relogin

cat << "EOF"

 _                            _
| |    ___   __ _  ___  _   _| |_
| |   / _ \ / _` |/ _ \| | | | __|
| |__| (_) | (_| | (_) | |_| | |_
|_____\___/ \__, |\___/ \__,_|\__|
            |___/
                       _
        __ _ _ __   __| |
       / _` | '_ \ / _` |
      | (_| | | | | (_| |
       \__,_|_| |_|\__,_|
 ____      _             _
|  _ \ ___| | ___   __ _(_)_ __
| |_) / _ \ |/ _ \ / _` | | '_ \
|  _ <  __/ | (_) | (_| | | | | |
|_| \_\___|_|\___/ \__, |_|_| |_|
                   |___/

EOF
