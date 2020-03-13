#!/bin/bash

usernam=$(whoami)


#create directories and set path to accept own scripts globally
mkdir ~/scripts
mkdir ~/scripts/bash
export PATH=$PATH:/home/$usernam/scripts/bash/ 
sudo echo "" >> /etc/profile
sudo echo "export PATH=$PATH:/home/$usernam/scripts/bash/" >> /etc/profile

#copy scripts
cp scrip/* ~/scripts/bash/

#install some stuff
sudo apt update
sudo apt upgrade
sudo apt update
sudo apt install tmux htop snapd
sudo apt update

#set personalisation variables
sudo echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf

to be continued later
