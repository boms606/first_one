#!/bin/bash

# todo: - find a way to check whether working directory is first_one/
#       - add timestamps to errors.log logs
#       - troubleshooting for apt install g810 for older debian versions (install via git)

#redirect errors to logfile named "errors"
exec 2> errors.log

systemdizda() {
    apt install snapd -y && apt update
    # bug on debian not adding snap to $PATH
    [[ -z $(echo $PATH | grep -q "/snap/bin") ]] && export PATH=$PATH:/snap/bin && pathtobeadded+=":/snap/bin"
    snap install code --classic
    snap install teams-for-linux
    [[ -z $(dpkg -l | grep -qi vlc) ]] snap install vlc
    snap install spotify
    snap install obs-studio
    [[ -z $(dpkg -l | grep -qi skype) ]] && snap install skype --classic
}

cleanafterwards() {
    [[ -z $(cat errors.log) ]] && rm errors.log && echo "script finished without errors" || echo "errors occured"
}

#usernam=$(whoami)
usernam=$1

[ -z "$usernam" ]  && echo "Please specify a user" && cleanafterwards && exit 1

#create directories 
mkdir /home/$usernam/scripts
mkdir /home/$usernam/scripts/bash

#copy scripts
cp scrip/* /home/$usernam/scripts/bash/

#install some stuff
apt update
apt upgrade -y && apt update
apt install tmux htop screenfetch g++ make -y
apt install g810-led -y # || git install ..
# https://github.com/MatMoul/g810-led/blob/master/INSTALL.md
apt install skypeforlinux -y
apt install vlc -y
apt update

# check whether systemd is present
pidof systemd && systemdizda || echo "No systemd active, thus snapd not necessary!"


#set path to accept own scripts globally
export PATH=$PATH:/home/$usernam/scripts/bash && pathtobeadded+=:/home/$usernam/scripts/bash

#set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf
echo -e "a 00006f\ng logo 6f0000\ng multimedia 006f00\ng indicators 006f00\nc" > /etc/g810-led/profile

#load settings from backup if necessary
[[ -n $(screenfetch | grep -qi 'budgie') ]] && dconf load / < bckpfiles/budgie-backup && echo "budgie-backup loaded" || echo "no budgie backup" 
    # "-n" means "if not empty string", "&&" means "on success"
    # "-z" means "if empty string",     "||" means "on fail"

#handover to new user
chown -R $usernam:$usernam ../first_one/
chown -R $usernam:$usernam /home/$usernam/scripts/

echo "" >> /etc/profile
echo "export PATH=$PATH$pathtobeadded" >> /etc/profile

#remove errors.log when file is empty
cleanafterwards

#to be continued later 

exit 0