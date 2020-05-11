#! /bin/bash

# todo: - add timestamps to errors.log logs
#       - troubleshooting for apt install g810 for older debian versions 
#                             and pacman -S for arch based distros        (maybe install via git)
#       - find ppas to install stuff without snap or flatpak

dolla1=$1
dolla2=$2

goDollarOne(){
    case "$1" in
        --help)
            echo "This script is not finished yet!!"
            echo ""
            echo "It just provides some basic configuration"
            echo "that I dont want to do manually every time I"
            echo "install a new system"
            echo ""
            echo "---- Usage ----"
            echo ""
            echo "./firsttry [user name] [debian/arch]"
            echo "              (you) (default is debian)"
            echo "You will need sudo privileges"
            echo ""
            ;;
        *)
            usernam=$1
            echo "$usernam is the user"
            ;;
    esac
}

# usernam=$(whoami)
[[ -z $dolla1 ]] && { usernam=$USER && echo "No user specified, supposing '$usernam' ?" && exit 1; } || { goDollarOne $dolla1; }

# be able to add distro specific install methods 
    # aptitude  for debian  based distributions
    # pacman    for arch    based distributions
case "$dolla2" in
    arch)
        echo "using 'pacman' while on arch-based distro"

        cinstall(){
            pacman -Q $1        # query from installed packages
            statcode=$?         # get error code: 0 -> found in local library
            [[ $statcode -ne 0 ]] && yes | pacman -S $1 || echo "$1 already installed"
            # -ne means 'not equal' -> if not 0 then not installed -> install
        }

        cupdate(){
            yes | pacman -Syy   # is 'yes' even neccessary?!
        }

        cupgrade(){
            yes | pacman -Syu   # 'yes' could cause problems with certain updates.. :/
        }
	    ;;
    *)
        echo "supposing debian-based distro. Using 'aptitude'"

        cinstall(){
            apt install $1 -y
        }

        cupdate(){
            apt update
        }

        cupgrade(){
            apt update && apt upgrade -y
        }
        ;;
esac

# redirect errors to logfile named "errors.log"
exec 2> errors.log

# check whether working directory first_one/
[[ -z $(echo $PWD | grep -i /first_one) ]] && echo "Please run the script from within the folder 'first_setup/'" && exit 1

systemdizda() {
    cinstall snapd && cupdate
    # bug on debian not adding snap to $PATH
    [[ -z $(echo $PATH | grep "/snap/bin") ]] && export PATH=$PATH:/snap/bin #&& pathtobeadded+=":/snap/bin"
    snap install code --classic
    snap install teams-for-linux
    [[ -z $(dpkg -l | grep -i vlc) ]] && snap install vlc
    snap install spotify
    [[ -z $(dpkg -l | grep -i obs-studio) ]] && snap install obs-studio
    [[ -z $(dpkg -l | grep -i skype) ]] && snap install skype --classic
}

i3izda(){
    cinstall nitrogen
    mkdir -p /home/$usernam/.config/i3 && cp i3back/config /home/$usernam/.config/i3/
    cp -r i3back/scripts /home/$usernam/.config/i3/
    cp i3back/i3blocks.conf /etc/
    chown -R $usernam:$usernam /home/$usernam/.config/i3/
    cinstall awesome-terminal-fonts 
    cinstall fonts-font-awesome
    
}

cleanafterwards() {
    # remove errors.log when file is empty 
    [[ -z $(cat errors.log) ]] && rm errors.log && echo "script finished without errors" || echo "errors occured"
}

# create directories 
mkdir /home/$usernam/scripts
mkdir /home/$usernam/scripts/bash

# copy scripts
cp scrip/* /home/$usernam/scripts/bash/

# install some stuff
cupgrade
cinstall tmux 
cinstall htop 
cinstall screenfetch 
cinstall g++ 
cinstall make 
cinstall perl 
cinstall unzip
cinstall g810-led # || git install ..
# https://github.com/MatMoul/g810-led/blob/master/INSTALL.md
cinstall skypeforlinux
cinstall vlc
cinstall obs-studio
cinstall code
cupdate

# check whether systemd is present
#pidof systemd && systemdizda || echo "No systemd active, thus snapd not necessary!"
###


# set path to accept own scripts globally
export PATH=$PATH:/home/$usernam/scripts/bash && #pathtobeadded+=:/home/$usernam/scripts/bash

# set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf
echo -e "a 00006f\ng logo 6f0000\ng multimedia 006f00\ng indicators 006f00\nc" > /etc/g810-led/profile

# get icons and themes
for i in icons/*.tar.xz; do  sudo tar xvf $i -C /usr/share/icons/; done
for i in themes/*.tar.xz; do  sudo tar xvf $i -C /usr/share/themes/; done
for i in themes/*.tar.gz; do  sudo tar xvf $i -C /usr/share/themes/; done
for i in themes/*.zip; do  sudo unzip $i -d /usr/share/themes/; done
mkdir -p /usr/share/wallpapers && cp wallpapers/* /usr/share/wallpapers/

# load settings from backup if necessary            [backups obsolete]
#[[ -n $(screenfetch | grep -i 'budgie') ]] && sudo -u $usernam dconf load / < bckpfiles/budgie-backup && echo "budgie-backup loaded" || echo "no budgie backup" 
#[[ -n $(echo $DESKTOP_SESSION | grep -i "mate") ]] && sudo -u $usernam dconf load / < bckpfiles/mate-backup && 
#    echo "mate-backup loaded" && 
#    sudo -u $usernam gsettings set org.gnome.desktop.session idle-delay 0 || echo "no mate backup"
 
    # "-n" means "if not empty string", "&&" means "on success"
    # "-z" means "if empty string",     "||" means "on fail"
    # mate-bckp: && sudo -u $usernam dconf write /net/launchpad/plank/docks/dock1/show-dock-item false 

#ubuntumate: dconf write /net/launchpad/plank/docks/dock1/show-dock-item false
#            gsettings set org.gnome.desktop.session idle-delay 0

[[ -n $(screenfetch | grep -i wm | grep i3) ]] && { i3izda && echo "i3-backup loaded"; } || echo "no i3 backup"

# handover to new user
chown -R $usernam:$usernam ../first_one/
chown -R $usernam:$usernam /home/$usernam/scripts/
#chown -R $usernam:$usernam /usr/share/wallpapers/  #its root anyway

# make changes to path permanent
echo "" >> /etc/profile
#echo "export PATH=$PATH$pathtobeadded" >> /etc/profile
echo "export PATH=$PATH" >> /etc/profile

cleanafterwards

# to be continued later 

exit 0
