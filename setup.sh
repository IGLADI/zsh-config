if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root, try again using sudo."
    exit 1
fi

echo "Updating and upgrading the system..."
apt update -y && apt upgrade -y

echo "Installing Zsh..."
apt install zsh -y

echo "Setting Zsh as the default shell..."
usermod -s /usr/bin/zsh $(whoami)
chsh -s $(which zsh) 

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Done"
