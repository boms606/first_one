#!/bin/bash

usernam=$(whoami)


#create directories and set path to accept own scripts globally
mkdir ~/scripts
mkdir ~/scripts/bash
export PATH=$PATH:/home/$usernam/scripts/bash/ 
echo "" >> /etc/profile
echo "export PATH=$PATH:/home/$usernam/scripts/bash/" >> /etc/profile

#copy scripts
cp scrip/* ~/scripts/bash/

#install some stuff
apt update
apt upgrade
apt update
apt install tmux htop snapd
apt update

#set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf

#to be continued later
