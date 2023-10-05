#!bin/bash

# Colors
NC="\e[0m"    #No Color
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'

# Function
error   () { echo -e "${RED}${*}${NC}";exit 1;:; }
warning () { echo -e "${YELLOW}${*}${NC}";:; }
info    () { echo -e "${GREEN} ------";echo -e "# ${*}";echo -e "------${NC}";:; }

info "Package Update & Upgrade"
apt update -y && apt upgrade -y

apt install -y dialog apt-utils

info "Install Firefox"

add-apt-repository ppa:mozillateam/ppa
apt update
apt install -y firefox-esr

info "Create Group & Set Group with Grant "
groupadd storage
groupadd wheel
groupadd video

info "Create User"
echo -n "Enter  User Name > "
read text
_user=$text

useradd -m -g users -G wheel,audio,video,storage -s /bin/bash $_user
echo $_user ALL=\(root\) ALL > /etc/sudoers.d/$_user;chmod 0440 /etc/sudoers.d/$_user
echo "Create User:$_user"

info "Set Root Password"
passwd

info "Set User[ $_user ] Password"
passwd $_user

info "Connect User & Instal Package"
su - $_user -c "apt install -y fcitx fcitx-hangul fonts-noto-cjk locales language-pack-ko fonts-nanum* fonts-roboto;echo -e '#!/bin/bash\n\nexport QT_IM_MODULE=fcitx\nexport GTK_IM_MODULE=fcitx\nexport XMODIFIER>

info "Finished Set Ubuntu"
