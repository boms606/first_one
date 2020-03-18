#!/bin/bash

exec 2> errors

#usernam=$(whoami)
usernam=$1

#create directories 
mkdir /home/$usernam/scripts
mkdir /home/$usernam/scripts/bash

#copy scripts
cp scrip/* /home/$usernam/scripts/bash/

#install some stuff
apt update
apt upgrade
apt update
apt install tmux htop snapd screenfetch
apt update

#set path to accept own scripts globally
echo "" >> /etc/profile
echo "export PATH=$PATH:/home/$usernam/scripts/bash/" >> /etc/profile
export PATH=$PATH:/home/$usernam/scripts/bash/

#set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf

#to be continued later
