#!/bin/bash

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
sudo apt install bat -y

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

echo "\033[34mInstalling zoxide...\033[0m"
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
export PATH="$PATH:/root/.local/bin"
zoxide init zsh --cmd cd
echo "\033[34mzoxide installed.\033[0m"

echo "\033[34mAdding user's local bin to PATH...\033[0m"
USER_HOME=$(getent passwd $(whoami) | cut -d: -f6)
export PATH="$PATH:$USER_HOME/.local/bin"
echo "\033[34mPATH updated.\033[0m"

echo "\033[34mInstalling exa...\033[0m"
curl https://sh.rustup.rs -sSf | sh
# reload path
source $HOME/.cargo/env
source $HOME/.cargo/bin
rustup default stable
cargo install exa
echo "\033[34mexa installed.\033[0m"

sudo apt autoremove -y
echo "\033[34Done, please restart the terminal.\033[0m"
zsh
