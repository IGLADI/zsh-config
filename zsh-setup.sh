#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

echo "\033[34mInstalling git...\033[0m"
sudo apt install git -y

echo "\033[34mInstalling curl...\033[0m"
sudo apt install curl -y

sudo apt install build-essential -ys

echo "\033[34mInstalling python&pip...\033[0m"
sudo apt install python3 python3-pip -y
sudo apt install argcomplete3 -y
pip install argcomplete
activate-global-python-argcomplete -y

echo "\033[34mUpdating and upgrading the system...\033[0m"
sudo apt update -y && apt upgrade -y

echo "\033[34mInstalling bat...\033[0m"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "\033[31mIf on debian/ubuntu please use dpkg per the official docs instead\033[0m"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo apt install bat -y

echo "\033[34mInstalling vivid colorscheme...\033[0m"
wget "https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_amd64.deb"
sudo dpkg -i vivid_0.8.0_amd64.deb

echo
git clone https://github.com/Aloxaf/fzf-tab ~/zsh-fzf-tab

echo "==================================================================="
echo "\033[34mCopying the base config files...\033[0m"
cp ./base.zshrc ~/.zshrc
cp base.p10k.zsh ~/.p10k.zsh
echo "\033[34mConfig files copied.\033[0m"

echo "\033[34mInstalling fzf...\033[0m"
sudo apt install fzf -y

echo "\033[34mInstalling Zsh...\033[0m"
sudo apt install zsh -y

echo "\033[34mSetting Zsh as the default shell...\033[0m"
sudo chsh -s $(which zsh)
chsh -s $(which zsh)

echo "\033[34mInstalling zplug...\033[0m"
rm -rf ~/.zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

echo "\033[34mInstalling Powerlevel10k theme...\033[0m"
# rm -rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || echo "Powerlevel10k already installed."

echo "\033[34mInstalling MesloLGS NF fonts...\033[0m"
echo $FONT_URLS
FONT_URLS=(
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

for FONT_URL in "${FONT_URLS[@]}"; do
    FILENAME=$(basename "$FONT_URL")
    curl -o "$FONT_DIR/$FILENAME" -L "$FONT_URL"
    # Install the font
    echo "Installing $FILENAME..."
    fc-cache -f "$FONT_DIR"
done

echo "\033[34mSetting MesloLGS NF font for the terminal...\033[0m"
gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS NF Regular 11'
echo "\033[34mFont installation and configuration complete.\033[0m"

echo "\033[34mInstalling tmux...\033[0m"
sudo apt install tmux -y

echo "\033[34mInstalling tmux plugin manager...\033[0m"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "\033[34mCopying the base tmux config file...\033[0m"
cp ./base.tmux.conf ~/.tmux.conf

echo "\033[34mInstalling zoxide...\033[0m"
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
export PATH="$PATH:/root/.local/bin"
zoxide init zsh --cmd cd
echo "\033[34mzoxide installed.\033[0m"

echo "\033[34mAdding user's local bin to PATH...\033[0m"
USER_HOME=$(getent passwd $(whoami) | cut -d: -f6)
export PATH="$PATH:$USER_HOME/.local/bin"
echo "\033[34mPATH updated.\033[0m"

echo "\033[34mInstalling eza...\033[0m"
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
echo "\033[34mexa installed.\033[0m"

echo "\033[34mInstalling grc for colored commands...\033[0m"
sudo apt install grc -y
echo "\033[34mgrc installed.\033[0m"

sudo apt autoremove -y
echo "\033[34Done, please restart the terminal.\033[0m"
zsh
