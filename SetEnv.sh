#!bin/bash

# Colors
NC="\e[0m"    #No Color
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
CYAN='\e[1;36m'

# Function
error   () { echo -e "${RED}${*}${NC}";exit 1;:; }
warning () { echo -e "${YELLOW}${*}${NC}";:; }
info    () { echo -e "${GREEN}======";echo -e "# ${*}";echo -e "======${NC}";:; }
log     () { echo -e "${CYAN}${*}${NC}";:; }

info "Set repository & Package"
#mv "$HOME/.termux" "$HOMW/.termux.bak.$(date +%Y.%m.%d)" #-%H:%M
#cp -R ./.termux $HOME/.termux
cp $HOME/.termux/termux.properties $HOME/.termux/termux.properties.bak.$(date +%Y.%m.%d)

cp ~/../usr/etc/apt/sources.list ~/../usr/etc/apt/sources.list.$(date +%Y.%m.%d)

apt install -y nano git zsh screenfetch neofetch openssh sshpass net-tools htop wget

echo -e "deb https://packages-cf.termux.dev/apt/termux-main stable main\ndeb https://packages-cf.termux.dev/apt/termux-root root stable\ndeb https://packages-cf.termux.dev/apt/termux-x11 x11 main" > ~/../usr/etc/apt/sources.list

log "apt update & upgrade, Install Package"

apt update -y && apt upgrade -y

cp $HOME/.zshrc $HOME/.zshrc.bak.$(date +%Y.%m.%d)

info "For x11"

log "Install Package"
apt install -y proot-distro pulseaudio vim x11-repo && apt install -y termux-x11-nightly xwayland xorg-server-xvfb

info "install zsh & Setting"

log "Install oh-my-zsh"

git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --depth 1
mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)"
cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

# Change theme to agnoster
log "Change theme to agnoster"

sed -i 's/robbyrussell/agnoster/' ~/.zshrc

# Install oh-my-zsh plugins
info "Install oh-my-zsh plugins"

log "zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting --depth 1

log "zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions --depth 1

log "zsh-completions"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions --depth 1

log "fzf"
git clone https://github.com/junegunn/fzf.git ~/.fzf --depth 1
~/.fzf/install --all

# Use plugins
info "Use plugins"

log "sed -i 's/(git)/(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions kubectl)/' ~/.zshrc"
sed -i 's/(git)/(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions kubectl)/' ~/.zshrc

# Change shell to zsh
info "Change shell to zsh"

log "chsh -s zsh"
chsh -s zsh

# Copy git config
info "Copy git config"

log "cp .gitconfig '$HOME'"
cp .gitconfig "$HOME"
