#!/bin/zsh

# The file to modify
ZSHRC_FILE=~/.zshrc

# The incorrect path pattern to find and remove
BAD_FZF_PATH="/usr/share/doc/fzf/examples/"

# The correct line that fzf's installer adds
CORRECT_FZF_LINE='[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'

# --- SCRIPT STARTS HERE ---

echo "Attempting to fix fzf configuration in $ZSHRC_FILE..."

# Check if the bad lines exist
if grep -q "$BAD_FZF_PATH" "$ZSHRC_FILE"; then
  # Create a backup and remove the incorrect lines using sed
  # The .bak extension creates a backup file (e.g., .zshrc.bak)
  sed -i.bak "\|$BAD_FZF_PATH|d" "$ZSHRC_FILE"
  echo "✅ Found and removed old fzf lines. Backup created at $ZSHRC_FILE.bak"
else
  echo "➡️ No incorrect fzf lines found to remove."
fi

# Check if the correct line is already present
if grep -q "source ~/.fzf.zsh" "$ZSHRC_FILE"; then
  echo "➡️ Correct fzf configuration already exists."
else
  # If not, add the correct line to the end of the file
  echo "\n# Added by fzf-fix script\n$CORRECT_FZF_LINE" >> "$ZSHRC_FILE"
  echo "✅ Added the correct fzf configuration."
fi

echo "\nDone! Restart your terminal or run 'source ~/.zshrc' to apply changes."
