#!/bin/bash

# A script to set up a development environment on macOS.

# --- Helper function for colored output ---
print_info() {
    echo "\033[34m$1\033[0m"
}

# --- 1. Install Homebrew and Xcode Command Line Tools ---

# Check for Homebrew and install if not found
if ! command -v brew &> /dev/null; then
    print_info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_info "Homebrew is already installed."
fi

# Check for Xcode Command Line Tools and install if not found
if ! xcode-select -p &> /dev/null; then
  print_info "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
else
  print_info "Xcode Command Line Tools are already installed."
fi

# --- 2. Update Homebrew and Install Packages ---

print_info "Updating and upgrading Homebrew packages..."
brew update
brew upgrade

print_info "Installing core packages..."
# git and curl are pre-installed, but brew ensures they are up-to-date.
# zsh is also pre-installed, but the Homebrew version is typically newer.
brew install git curl zsh fzf bat vivid eza tmux grc zoxide python

# --- 3. Configure Shell and Tools ---

print_info "Cloning fzf-tab for Zsh..."
git clone https://github.com/Aloxaf/fzf-tab ~/zsh-fzf-tab

print_info "Copying base config files..."
# Make sure these files are in the same directory as the script
cp ./base.zshrc ~/.zshrc
cp ./base.p10k.zsh ~/.p10k.zsh
print_info "Config files copied."

print_info "Setting Zsh as the default shell..."
# Add the Homebrew Zsh to the list of allowed shells if it's not there
BREW_ZSH_PATH=$(which zsh)
if ! grep -Fxq "$BREW_ZSH_PATH" /etc/shells; then
  print_info "Adding Homebrew Zsh to /etc/shells..."
  sudo sh -c "echo $BREW_ZSH_PATH >> /etc/shells"
fi
# Set the default shell
chsh -s "$BREW_ZSH_PATH"

print_info "Installing zplug plugin manager..."
rm -rf ~/.zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

print_info "Installing Powerlevel10k theme..."
# This clones p10k to a standard location. Your .zshrc should source it.
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# --- 4. Install Fonts ---

print_info "Installing MesloLGS NF fonts..."
FONT_URLS=(
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)

# On macOS, fonts are installed in ~/Library/Fonts
FONT_DIR="$HOME/Library/Fonts"
mkdir -p "$FONT_DIR"

for FONT_URL in "${FONT_URLS[@]}"; do
    FILENAME=$(basename "$FONT_URL")
    print_info "Downloading and installing $FILENAME..."
    curl -o "$FONT_DIR/$FILENAME" -L "$FONT_URL"
done

print_info "Fonts installed. Please set 'MesloLGS NF' manually in your terminal's preferences."

# --- 5. Configure Tmux ---

print_info "Installing tmux plugin manager (tpm)..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

print_info "Copying the base tmux config file..."
cp ./base.tmux.conf ~/.tmux.conf

# --- 6. Final Cleanup ---

print_info "Cleaning up Homebrew cache..."
brew cleanup

print_info "Done! Please restart your terminal for all changes to take effect."
