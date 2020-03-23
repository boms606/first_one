#!/bin/bash

# todo: - find a way to check whether working directory is first_one/
#       - add timestamps to errors.log logs
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
apt install g810-led -y
apt update

#set path to accept own scripts globally
echo "" >> /etc/profile
echo "export PATH=$PATH:/home/$usernam/scripts/bash/" >> /etc/profile
export PATH=$PATH:/home/$usernam/scripts/bash/

#set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf
echo -e "a 00006f\ng logo 6f0000\ng multimedia 006f00\ng indicators 006f00\nc" > /etc/g810-led/profile

#load settings from backup if necessary
[[ -n $(uname -a | grep -i 'budgie') ]] && dconf load / < bckpfiles/budgie-backup  
    # "-n" means "if not empty string", "&&" means "on success"
    # "-z" means "if empty string", "||" means "on fail"

#handover to new user
chown -R $usernam:$usernam ../first_one/
chown -R $usernam:$usernam /home/$usernam/scripts/

#to be continued later
