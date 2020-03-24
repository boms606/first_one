#!/bin/bash

# todo: - find a way to check whether working directory is first_one/
#       - add timestamps to errors.log logs

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
apt upgrade -y && apt update
apt install tmux htop screenfetch -y
apt install g810-led -y
apt install skypeforlinux -y && apt update

systemdizda() {
    apt install snapd -y && apt update
    snap install code --classic
    snap install teams-for-linux
    snap install vlc
    snap install spotify
    snap install obs-studio
}

pidof systemd && systemdizda || echo "No systemd active, thus snapd not necessary!"


#set path to accept own scripts globally
echo "" >> /etc/profile
echo "export PATH=$PATH:/home/$usernam/scripts/bash/" >> /etc/profile
export PATH=$PATH:/home/$usernam/scripts/bash/

#set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf
echo -e "a 00006f\ng logo 6f0000\ng multimedia 006f00\ng indicators 006f00\nc" > /etc/g810-led/profile

#load settings from backup if necessary
[[ -n $(screenfetch | grep -i 'budgie') ]] && dconf load / < bckpfiles/budgie-backup && echo "budgie-backup loaded" || echo "no budgie backup" 
    # "-n" means "if not empty string", "&&" means "on success"
    # "-z" means "if empty string",     "||" means "on fail"

#remove errors.log when file is empty
[[ -z $(cat errors.log) ]] && rm errors.log && echo "script finished without errors"

#handover to new user
chown -R $usernam:$usernam ../first_one/
chown -R $usernam:$usernam /home/$usernam/scripts/

#to be continued later 
