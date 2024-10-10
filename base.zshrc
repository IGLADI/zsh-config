# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
# don't put duplicate lines or lines starting with space in the history.
HISTDUP=erase
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'
# completion between lower and upper case
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# completion with EZA colors
export EZA_COLORS="$(vivid generate molokai)"
EZA_COLORS="$(vivid generate molokai)"
zstyle ':completion:*' list-colors ${(s.:.)EZA_COLORS}
autoload -Uz compinit
compinit
# End of lines added by compinstall

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# remove no prompt during init error
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

### OPTIONS (`man zshoptions`)
# enable extended globbing 
setopt extendedglob
# tries to correct typos in commands
setopt correct
# I am scared of "no matches found"
setopt nonomatch
# cd without typing cd
setopt autocd
# complete while the cursor is inside a word
setopt completeinword
# remove duplicates&spaces in history
setopt histignoredups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt histignorespace
# remove excessive whitespace from history
setopt histreduceblanks
# enable comments on commandline
setopt interactive_comments
# say status of bg jobs immediately
setopt notify
# disable bell on error
setopt no_beep
# don't have annoying windows beeeeppppp destroying ears just in case as I hate it
unsetopt beep
# apend instead of overwrite history
setopt appendhistory
# live share history between shells
setopt sharehistory

# open tmux
# tmux
# fixes bug between already existing tmux session and p10k
# if [ -z "$TMUX" ]; then
#     exec tmux new-session -A -s main
# fi

# Load zplug
source ~/.zplug/init.zsh

# colorize multiple things
zplug zpm-zsh/colorize
# add p10k theme
zplug romkatv/powerlevel10k, as:theme, depth:1
# zsh plugins for auto suggestion and autofill with right arrow
zplug "zsh-users/zsh-autosuggestions"
# seems to lag with this one activated in wsl2 without desactivating windows path in /etc/wsl.conf or ZSH_HIGHLIGHT_DIRS_BLACKLIST+=("/cygdrive" "/mnt/c" "/mnt/d" "/mnt/e")
zplug "zsh-users/zsh-syntax-highlighting"
# unlag zsh-syntax-highlighting (ignore windows path) but still not perfect
# ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c)
# faster version of this plugin found:
# source ~/config/fsh/fast-syntax-highlighting.plugin.zsh
# don't remeber what this did
zplug "zsh-users/zsh-completions"
# gives the completion menu underneath while typting
zplug "marlonrichert/zsh-autocomplete"
# # better history search with upper arrow
# zplug "zsh-users/zsh-history-substring-search"
# # for wsl add notify-send
# notify-send() { wsl-notify-send.exe --category $WSL_DISTRO_NAME "${@}"; }
# little notif box when a long running task is done
# only set on personal linux machines, not needed with warp
# zplug "MichaelAquilina/zsh-auto-notify"
# # add notify-send to wsl path
# export PATH=$PATH:~/wsl-notify-send_windows_amd64
# auto set } with { like an IDE would
zplug "hlissner/zsh-autopair"
# # little "you should use..." when an alias exist for your command
# zplug "MichaelAquilina/zsh-you-should-use"
# auto sudo previous cmd with dubbel esc
zplug "ohmyzsh/ohmyzsh", use:"plugins/sudo"
zplug "jirutka/zsh-shift-select"

# fzf on arrow up
# not used anymore as I use zi/cdi
# eval "$(fzf --zsh)"
# fzf for completion
# zplug "Aloxaf/fzf-tab"
# source ~/zsh-fzf-tab/fzf-tab.plugin.zsh
# zplug "AntonKozikov/fzf-tab"
# zstyle ':completion:*' menu no
# little previeuw of folder content
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -l -F --icons --git --sort extension --group-directories-first --color=always $realpath'
# TODO maybe add cat/nano/vim/... to previeuw bat files hovering/typing

# always show completion menu from fzf-tab


# Install plugins if not already installed
if ! zplug check --verbose; then
    printf "Installing zplug plugins...\n"
    zplug install
fi
# Then, source zplug in your shell configuration
zplug load

# if there is no match in history previeuw standard completion
export ZSH_AUTOSUGGEST_STRATEGY=(
    history
    completion
)

# # bindkey '^I' expand-or-complete-prefix
# # ! need to FIX dubbel space/one space but not showing suggestion let me navigate with tab into the menu if there are multiple choices
# bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
# bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# Move between words with Ctrl+Arrows
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
# Delete complete word using Ctrl+Backspace & Ctrl+Delete
bindkey -M main -M viins -M vicmd -M emacs '^H' backward-kill-word
bindkey -M main -M viins -M vicmd -M emacs '^[[3;5~' kill-word

# fzf for history search with ctrl r
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# use RTX instead of intel GPU
export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA

# use vscode as default editor when available
which code > /dev/null 2>&1 && export EDITOR="code --wait"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# # disable auto new line on long commands
# setterm -linewrap off

# easy temp dir
alias tmpd='cd $(mktemp -d)'

# double esc doesn't work in warp, fallback to please
alias please="sudo !!"

# set bat as cat
which bat > /dev/null 2>&1 && alias cat='bat --paging=never --style=plain'
# interactive search w zoxide
which zoxide > /dev/null 2>&1 && alias cdi='zi'

# set fzf to use eza and bat
fzf_cd() {
  # not the best implementaiton as I already alias this later
  if command -v eza > /dev/null 2>&1; then
    local list_cmd='eza -l -F --icons --git --sort extension --group-directories-first --color=always'
  else
    local list_cmd='ls -l --color --group-directories-first --sort=extension'
  fi
  
  # get selection + preview
  local selected=$(eval "$list_cmd" | fzf \
    --preview '{
        preview=$(echo {} | awk "{print \$NF}" | xargs -I{} sh -c "bat --color=always --style=numbers --line-range :500 {} 2>/dev/null")
        if [ $? -ne 0 ]; then
            echo {} | awk "{print \$NF}" | xargs eza -l -F --icons --git --sort extension --group-directories-first --color=always
        else
            echo "$preview"
        fi
    }' \
    --ansi --preview-window=right:60% \
    --height=100% \
    --border=rounded \
    --header='Select a file or directory'
  )
  
  # check if a selection was made, think this will me let ctrl+c out of the selection where I'm at my destination
  if [ -z "$selected" ]; then
    echo "No selection made."
    return 1
  fi

  # get the path
  local selected_path=$(echo "$selected" | awk '{print $NF}')
  
  # change directory or open file
  if [ -d "$selected_path" ]; then
    cd "$selected_path" && fzf_cd || return
  elif [ -f "$selected_path" ]; then
    nano "$selected_path" 
  else
    echo "Selected item is neither a file nor a directory."
  fi
}
alias cdf='fzf_cd'

# auto retry ssh
sshretry() {
    while ! \ssh "$@"; do
        sleep 1
        echo "Retrying..."
    done
}
alias sshr='sshretry'

# get z command (better cd)
export PATH=$PATH:~/.local/bin
eval "$(zoxide init zsh)"

# get color on all ip commands
alias ip='ip -c'

# better ls
if command -v eza &> /dev/null; then
    alias l='eza -l -F --icons --git --sort extension --group-directories-first'
    alias lsa='eza -la -F --icons --git --sort extension --group-directories-first'
    alias lsimple='eza -F --icons --git --sort extension --group-directories-first'
    alias ll='eza -la -F --icons --git --sort extension --group-directories-first'
    alias la='eza -la -F --icons --git --sort extension --group-directories-first'
    alias lst='eza --tree -F --icons --git --sort extension --group-directories-first'
    alias tree='eza --tree -F --icons --git --sort extension --group-directories-first'
    alias lst1='eza --tree -L1 -F --icons --git --sort extension --group-directories-first'
    alias lst2='eza --tree -L2 -F --icons --git --sort extension --group-directories-first'
    alias lst3='eza --tree -L3 -F --icons --git --sort extension --group-directories-first'
    alias lst4='eza --tree -L4 -F --icons --git --sort extension --group-directories-first'
    alias lst5='eza --tree -L5 -F --icons --git --sort extension --group-directories-first'
    alias ls.='eza -dl .*'
    alias ls='l'
else
    alias l='ls -l --color --group-directories-first --sort=extension'
    alias lsa='ls -la --color --group-directories-first --sort=extension'
    alias lsimple='ls --color --group-directories-first --sort=extension'
    alias ll='ls -la --color --group-directories-first --sort=extension'
    alias la='ls -la --color --group-directories-first --sort=extension'
    alias lst='ls --color --group-directories-first --sort=extension | tree'
    alias tree='ls --color --group-directories-first --sort=extension | tree'
    alias lst1='ls --color --group-directories-first --sort=extension | tree -L 1'
    alias lst2='ls --color --group-directories-first --sort=extension | tree -L 2'
    alias lst3='ls --color --group-directories-first --sort=extension | tree -L 3'
    alias lst4='ls --color --group-directories-first --sort=extension | tree -L 4'
    alias lst5='ls --color --group-directories-first --sort=extension | tree -L 5'
    alias ls.='ls -d .* --color'
    alias ls='ls --color --group-directories-first --sort=extension'
fi


# when explicitly typing cd, no compdef as cd completion is better rn
cd() {
    # zoxide to cd
    __zoxide_z "$@"
}

# ls when changing directory
my_chpwd_hook() lsimple
chpwd_functions+=(my_chpwd_hook)

# TODO open files (vscode/run) & z into dir & remove prefix $ and retry
# aka autoz for autocd
# when not explicitly typing cd
# command_not_found_handler () {
# }

# ? open vscode projects in wsl

# ! uncomment for ros2
# # robotics
# export ROS_DOMAIN_ID=30 #TURTLEBOT3, waffle=115, burger=30, verandert met irl robbot die je wilt controlleren
# export TURTLEBOT3_MODEL=burger
# #source for robotics
# source /opt/ros/humble/setup.zsh
# # ! not sure if needed
# source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.zsh
# source ~/ros2_ws/install/setup.zsh
# source ~/turtlebot3_ws/install/setup.zsh
# # working zsh completion for ros2
# complete -o default -F _python_argcomplete "ros2"
# eval "$(register-python-argcomplete3 colcon)"
# complete -o default -F _python_argcomplete "colcon"

# # add basic pip completion (won't complete packages)
# eval "$(register-python-argcomplete3 pip)"

# when opening a new terminal show the folder content
# lsimple

# color for man pages
# Requires colors autoload.
# See termcap(5).

# Set up once, and then reuse. This way it supports user overrides after the
# plugin is loaded.
typeset -AHg less_termcap

# bold & blinking mode
less_termcap[mb]="${fg_bold[red]}"
less_termcap[md]="${fg_bold[red]}"
less_termcap[me]="${reset_color}"
# standout mode
less_termcap[so]="${fg_bold[yellow]}${bg[blue]}"
less_termcap[se]="${reset_color}"
# underlining
less_termcap[us]="${fg_bold[green]}"
less_termcap[ue]="${reset_color}"

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Absolute path to this file's directory.
typeset -g __colored_man_pages_dir="${0:A:h}"

function colored() {
  local -a environment

  # Convert associative array to plain array of NAME=VALUE items.
  local k v
  for k v in "${(@kv)less_termcap}"; do
    environment+=( "LESS_TERMCAP_${k}=${v}" )
  done

  # Prefer `less` whenever available, since we specifically configured
  # environment for it.
  environment+=( PAGER="${commands[less]:-$PAGER}" )
  environment+=( GROFF_NO_SGR=1 )

  # See ./nroff script.
  if [[ "$OSTYPE" = solaris* ]]; then
    environment+=( PATH="${__colored_man_pages_dir}:$PATH" )
  fi

  command env $environment "$@"
}

# Colorize man and dman/debman (from debian-goodies)
function man {\
  dman \
  debman {
  colored $0 "$@"
}