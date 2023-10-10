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

info "Set Termux external Storage"
termux-setup-storage

sleep 1

info "Set repository & Package"
#mv "$HOME/.termux" "$HOMW/.termux.bak.$(date +%Y.%m.%d)" #-%H:%M
#cp -R ./.termux $HOME/.termux
cp $HOME/.termux/termux.properties $HOME/.termux/termux.properties.bak.$(date +%Y.%m.%d)

cp ~/../usr/etc/apt/sources.list ~/../usr/etc/apt/sources.list.$(date +%Y.%m.%d)

log "apt update & upgrade, Install Package"
apt update -y && apt upgrade -y
apt install -y nano git zsh screenfetch neofetch openssh sshpass net-tools htop wget proot-distro pulseaudio vim
#echo -e "deb https://packages-cf.termux.dev/apt/termux-main stable main\ndeb https://packages-cf.termux.dev/apt/termux-root root stable\ndeb https://packages-cf.termux.dev/apt/termux-x11 x11 main" > ~/../usr/etc/apt/sources.list

cp $HOME/.zshrc $HOME/.zshrc.bak.$(date +%Y.%m.%d)

info "For x11"

log "Install Package"
apt install -y x11-repo && apt install -y termux-x11-nightly xwayland xorg-server-xvfb

info "install zsh & Setting"

log "Install oh-my-zsh"
git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --depth 1
mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y.%m.%d)" #-%H:%M:%S)"
cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

log "Change theme to agnoster"
sed -i 's/robbyrussell/agnoster/' ~/.zshrc

log "plugin > zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting --depth 1

log "plugin > zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions --depth 1

log "plugin > zsh-completions"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions --depth 1

log "plugin > fzf"
git clone https://github.com/junegunn/fzf.git ~/.fzf --depth 1
~/.fzf/install --all

log "Use plugins"
sed -i 's/(git)/(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions kubectl)/' ~/.zshrc

log "Change shell to zsh"
chsh -s zsh

log "Copy git config"
cp .gitconfig "$HOME"

log "Change prompt_context"
echo -e '\nprompt_context() {\nif [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then\nprompt_segment black default "%(!.%{%F{yellow}%}.)$USER"\nfi\nemojis=("⚡️" "🔥" "🇰  " "👑" "😎" "🐸" "🐵" "🦄" "🌈" "🍻" "🚀" "💡" "🎉" "🔑" "🚦" "🌙")\nRAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1))\nprompt_segment black default " [ KKus($(whoami)) ] ${emojis[$RAND_EMOJI_N]} "\n}' >> ~/.zshrc
