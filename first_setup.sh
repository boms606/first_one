#! /bin/bash

# todo: - add timestamps to errors.log logs
#       - find ppas to install stuff without snap or flatpak
#       - startup scripts to start up automatically under different circumstances (rc.local, systemd, ".config/autostart", ...)
#       - include "./config/picom.conf" and "/usr/share/rofi/themes/newDefault.rasi" in i3/picom
#               

dolla1=$1
dolla2=$2

[[ "$(whoami)" == "root" ]] || { echo "Please run as root!" && exit 1; }

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
            echo ""
            echo "You will need sudo privileges"
            echo ""
            exit 0
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
        dolla2="deb"
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

# check whether working directory is first_one/
[[ -z $(echo $PWD | grep -i /first_one) ]] && echo "Please run the script from within the folder 'first_one/'" && exit 1

cyayc(){
    [[ "$dolla2" == "arch" ]] && echo "Skipping '$1'. Install using yay if neccessary."
    [[ "$dolla2" == "deb" ]] && cinstall $1 
}

systemdizda() {
    cinstall snapd && cupdate
    # bug on debian not adding snap to $PATH
    [[ -z $(echo $PATH | grep "/snap/bin") ]] && export PATH=$PATH:/snap/bin #&& pathtobeadded+=":/snap/bin"
    [[ -z $(dpkg -l | grep -i code) ]] && snap install code --classic
    snap install teams-for-linux
    [[ -z $(dpkg -l | grep -i vlc) ]] && snap install vlc
    snap install spotify
    [[ -z $(dpkg -l | grep -i obs-studio) ]] && snap install obs-studio
    [[ -z $(dpkg -l | grep -i skype) ]] && snap install skype --classic
}

# install logitech g810 keyboard drivers from git (repo already saved locally)
instLogi(){
    mkdir -p /home/$usernam/tools/
    unzip bckpfiles/g810-led-master.zip -d /home/$usernam/tools/
    make -C /home/$usernam/tools/g810-led-master/ bin LIB=libusb
    make -C /home/$usernam/tools/g810-led-master/ install

    chown -R $usernam:$usernam /home/$usernam/tools/
    echo -e "a 00006f\ng logo 6f0000\ng multimedia 006f00\ng indicators 006f00\nc" > /etc/g810-led/profile
}

i3izda(){
    cinstall nitrogen
    cinstall glances
    cinstall xfce4-terminal
    cinstall thunar
    cinstall awesome-terminal-fonts || cinstall fonts-font-awesome
    cinstall adobe-source-code-pro-fonts
    cinstall rofi
    cinstall numlockx
    cinstall xed
    cinstall cool-retro-term
    cinstall acpi
    cinstall scrot
    cinstall picom

    mkdir -p /home/$usernam/.config/i3 && cp i3back/config /home/$usernam/.config/i3/
    cp -r i3back/scripts /home/$usernam/.config/i3/
    cp i3back/i3blocks.conf /home/$usernam/.config/i3/
    cp i3back/newDefault.rasi /usr/share/rofi/themes/
    cp i3back/picom.conf /home/$usernam/.config/
    chown -R $usernam:$usernam /home/$usernam/.config/i3/
    chown $usernam:$usernam /home/$usernam/.config/picom.conf
    xfce4-terminal -e 'echo -e "You will have to:\n    yay -S nerd-fonts-hack\nin order to be able to display the polybar properly :)"' --hold &
#    cinstall ttf-nerd-fonts-symbols
#    cinstall ttf-iosevka-nerd
}

cleanafterwards() {
    # remove errors.log when file is empty 
    [[ -z $(cat errors.log) ]] && rm errors.log && echo "script finished without errors" || echo "errors occured. Read \"errors.log\""
}

# create directories 
mkdir /home/$usernam/scripts
mkdir /home/$usernam/scripts/bash

# copy scripts
cp scrip/* /home/$usernam/scripts/bash/

# install some stuff

[[ "$dolla2" == "deb" ]] && cupgrade
cinstall tmux 
cinstall htop 
cinstall screenfetch 
cinstall git
cinstall g++ 
cinstall make
cinstall libusb 
cinstall libusb-1.0-0-dev 
cinstall perl 
cinstall unzip
cinstall imagemagick
cinstall xclip
cinstall gimp
cinstall skypeforlinux
cinstall vlc
cinstall obs-studio
cinstall lm_sensors
cyayc code
cyayc gdebi
cyayc gparted
cupdate

#instLogi

# check whether systemd is present
#pidof systemd && systemdizda || echo "No systemd active, thus snapd not necessary!"
###


# set path to accept own scripts globally
export PATH=$PATH:/home/$usernam/scripts/bash #&& pathtobeadded+=:/home/$usernam/scripts/bash

# set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf
echo "set-option -g default-command '/bin/bash'" >> /etc/tmux.conf

# append bckpfiles/profileAppend to /home/$usernam/.bashrc
cat bckpfiles/profileAppend | tee -a /home/$usernam/.bashrc

# make changes to .bashrc immediate
export LS_COLORS
export HISTCONTROL=ignorespace

# get icons and themes
for i in icons/*.tar.*; do  sudo tar xvf $i -C /usr/share/icons/; done
for i in icons/*.zip; do  sudo unzip $i -d /usr/share/icons/; done
for i in themes/*.tar.*; do  sudo tar xvf $i -C /usr/share/themes/; done
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

# make changes to path permanent
echo "" >> /home/$usernam/.bashrc
echo "" >> /etc/profile
echo "export PATH=$PATH" >> /home/$usernam/.bashrc
#echo "export PATH=$PATH$pathtobeadded" >> /etc/profile
echo "export PATH=$PATH" >> /etc/profile

# handover to new user
chown -R $usernam:$usernam ../first_one/
chown -R $usernam:$usernam /home/$usernam/scripts/
chown $usernam:$usernam /home/$usernam/.bashrc
#chown -R $usernam:$usernam /usr/share/wallpapers/  #its root anyway

cleanafterwards

# to be continued later 

exit 0
