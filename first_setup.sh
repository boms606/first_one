#! /bin/bash

# todo: - add timestamps to errors.log logs
#       - find ppas to install stuff without snap or flatpak
#       - add install 'sensors'
#       - startup script to mount wherever datafive is:
#           -> drive letter (e.g sdA or sdB) can be obtained like this:  
#               drive=/dev/sd$(cat /proc/mounts | grep -i "/dev/sd" | grep " / " | cut -f3 -d"d" | cut -f1 -d" " | sed 's/[0-9]//g')2
#                   -> $drive=/dev/sdc2 or $drive=/dev/sdd2
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
    make -C /home/$usernam/tools/g810/g810-led-master/ bin LIB=libusb
    make -C /home/$usernam/tools/g810/g810-led-master/ install

    chown -R $usernam:$usernam /home/$usernam/tools/
}

i3izda(){
    cinstall nitrogen
    cinstall glances
    cinstall xfce4-terminal
    cinstall thunar
    mkdir -p /home/$usernam/.config/i3 && cp i3back/config /home/$usernam/.config/i3/
    cp -r i3back/scripts /home/$usernam/.config/i3/
    cp i3back/i3blocks.conf /etc/
    chown -R $usernam:$usernam /home/$usernam/.config/i3/
    cinstall awesome-terminal-fonts || cinstall fonts-font-awesome
    
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
cinstall git
cinstall g++ 
cinstall make
cinstall libusb || cinstall libusb-1.0-0 
cinstall perl 
cinstall unzip
cinstall g810-led
logiinstall=$?
cinstall imagemagick
cinstall gimp
cinstall skypeforlinux
cinstall vlc
cinstall obs-studio
cinstall code
cupdate

[[ $logiinstall -ne 0 ]] && instLogi

# check whether systemd is present
#pidof systemd && systemdizda || echo "No systemd active, thus snapd not necessary!"
###


# set path to accept own scripts globally
export PATH=$PATH:/home/$usernam/scripts/bash && #pathtobeadded+=:/home/$usernam/scripts/bash

# set personalisation variables
echo "set -g default-terminal \"screen-256color\"" > /etc/tmux.conf
echo -e "a 00006f\ng logo 6f0000\ng multimedia 006f00\ng indicators 006f00\nc" > /etc/g810-led/profile
echo "export PS1='\[$(tput setaf 6)\][\[$(tput setaf 2)\]\u\[$(tput setaf 6)\]@\[$(tput setaf 2)\]\h \[$(tput setaf 3)\]\w\[$(tput setaf 6)\]] \$ \[$(tput sgr0)\]\[$(tput sgr0)\]' >> /home/$usernam/.bashrc

echo " " >> /home/$usernam/.bashrc
echo "LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=34;40:ow=34;40:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*.heic=01;35:*.HEIC=01;35:';" >> /home/$usernam/.bashrc
echo "export LS_COLORS" >> /home/$usernam/.bashrc

echo " " >> /home/$usernam/.bashrc
export HISTCONTROL=ignorespace
echo "export HISTCONTROL=ignorespace" >> /home/$usernam/.bashrc

# get icons and themes
#for i in icons/*.tar.xz; do  sudo tar xvf $i -C /usr/share/icons/; done
#for i in themes/*.tar.xz; do  sudo tar xvf $i -C /usr/share/themes/; done
#for i in themes/*.tar.gz; do  sudo tar xvf $i -C /usr/share/themes/; done
for i in icons/*.tar.*; do  sudo tar xvf $i -C /usr/share/icons/; done
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
