#!/bin/bash

sudo dnf update -y
sudo dnf upgrade -y

echo "\033[34mInstalling git...\033[0m"
sudo dnf install git -y

echo "\033[34mInstalling curl...\033[0m"
sudo dnf install curl -y

sudo dnf groupinstall "Development Tools" -y

echo "\033[34mInstalling python&pip...\033[0m"
sudo dnf install python3 python3-pip -y
sudo dnf install python3-argcomplete -y
pip3 install argcomplete
activate-global-python-argcomplete -y

echo "\033[34mUpdating and upgrading the system...\033[0m"
sudo dnf update -y && dnf upgrade -y

echo "\033[34mInstalling bat...\033[0m"
sudo dnf install bat -y

echo "\033[34mInstalling vivid colorscheme...\033[0m"
wget "https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_amd64.rpm"
sudo dnf install vivid_0.8.0_amd64.rpm -y

echo
git clone https://github.com/Aloxaf/fzf-tab ~/zsh-fzf-tab

echo "==================================================================="
echo "\033[34mCopying the base config files...\033[0m"
cp ./base.zshrc ~/.zshrc
cp base.p10k.zsh ~/.p10k.zsh
echo "\033[34mConfig files copied.\033[0m"

echo "\033[34mInstalling fzf...\033[0m"
sudo dnf install fzf -y
sudo mkdir /usr/share/doc/fzf/examples
sudo cp /usr/share/fzf/shell/* /usr/share/doc/fzf/examples

echo "\033[34mInstalling Zsh...\033[0m"
sudo dnf install zsh -y

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
sudo dnf install tmux -y

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
sudo dnf install eza -y
echo "\033[34meza installed.\033[0m"

echo "\033[34mInstalling vivid...\033[0m"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
zsh
cargo install vivid
echo "\033[34mvivid installed.\033[0m"

sudo dnf autoremove -y
echo "\033[34mDone, please restart the terminal.\033[0m"
zsh
