#!/bin/bash

# todo: - find a way to check whether working directory is first_one/
#       - add timestamps to error.log logs
#       - delete errors.log when no error or prevent it from being created

#redirect errors to logfile named "errors"
exec 2> errors.log

#usernam=$(whoami)
usernam=$1

#create directories 
mkdir /home/$usernam/scripts
mkdir /home/$usernam/scripts/bash

#copy scripts
cp scrip/* /home/$usernam/scripts/bash/

#install some stuff
apt update
apt upgrade -y
apt update
apt install tmux htop snapd screenfetch -y
apt update

#set path to accept own scripts globally
echo "" >> /etc/profile
echo "export PATH=$PATH:/home/$usernam/scripts/bash/" >> /etc/profile
export PATH=$PATH:/home/$usernam/scripts/bash/

#set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf

#handover to new user
chown -R $usernam:$usernam ../first_one/
chown -R $usernam:$usernam /home/$usernam/scripts/

#to be continued later
