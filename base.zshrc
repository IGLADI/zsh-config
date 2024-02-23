# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'
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
# remove duplicates in history
setopt histignoredups
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

# Load zplug
source ~/.zplug/init.zsh

# add p10k theme
zplug romkatv/powerlevel10k, as:theme, depth:1
# zsh plugins for auto suggestion and autofill with right arrow
zplug "zsh-users/zsh-autosuggestions"
# ! seems to lag with this one activated in wsl2 without desactivating windows path in /etc/wsl.conf or ZSH_HIGHLIGHT_DIRS_BLACKLIST+=("/cygdrive" "/mnt/c" "/mnt/d" "/mnt/e")
zplug "zsh-users/zsh-syntax-highlighting"
# unlag zsh-syntax-highlighting (ignore windows path) but still not perfect
# ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c)
# faster version of this plugin found:
# source ~/config/fsh/fast-syntax-highlighting.plugin.zsh
# don't remeber what this did
zplug "zsh-users/zsh-completions"
# gives the menu underneath while typting
zplug "marlonrichert/zsh-autocomplete"
# # better history search with upper arrow
# zplug "zsh-users/zsh-history-substring-search"
# # for wsl add notify-send
# notify-send() { wsl-notify-send.exe --category $WSL_DISTRO_NAME "${@}"; }
# little notif box when a long running task is done
zplug "MichaelAquilina/zsh-auto-notify"
# # add notify-send to wsl path
# export PATH=$PATH:~/wsl-notify-send_windows_amd64
# auto set } with { like an IDE would
zplug "hlissner/zsh-autopair"
# little "you should use..." when an alias exist for your command
zplug "MichaelAquilina/zsh-you-should-use"
# auto sudo previous cmd with dubbel esc
zplug "ohmyzsh/ohmyzsh", use:"plugins/sudo"

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
# TODO select with shift+arrows
# Delete complete word using Ctrl+Backspace & Ctrl+Delete
bindkey -M main -M viins -M vicmd -M emacs '^H' backward-kill-word
bindkey -M main -M viins -M vicmd -M emacs '^[[3;5~' kill-word

# fzf for history search with ctrl r
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# use RTX instead of intel GPU
export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA

# use vscode as default editor
export EDITOR="code --wait"

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

# set bat as cat
alias cat='batcat'

# get z command (better cd)
export PATH=$PATH:~/.local/bin
eval "$(zoxide init zsh)"

# when explicitly typing cd
cd() {
    # zoxide to cd
    __zoxide_z "$@"
    # display the new directory
    lsipmle
}

# autocd from uses _cd, so when not explicitly typing cd
_cd() {
    # zoxide to cd
    __zoxide_z "$@"
    # display the new directory
    lsipmle
}

# set vscode as default editor
export EDITOR='code --wait'

# get color on all ip commands
alias ip='ip -c'

# better ls
alias l='exa -l -F --icons --git --sort extension --group-directories-first'
alias lsimple='exa -F --icons --git --sort extension --group-directories-first'
alias ll='exa -la -F --icons --git --sort extension --group-directories-first'
alias la='exa -la -F --icons --git --sort extension --group-directories-first'
alias lst='exa --tree -F --icons --git --sort extension --group-directories-first'
alias tree='exa --tree -F --icons --git --sort extension --group-directories-first'
alias lst1='exa --tree -L1 -F --icons --git --sort extension --group-directories-first'
alias lst2='exa --tree -L2 -F --icons --git --sort extension --group-directories-first'
alias lst3='exa --tree -L3 -F --icons --git --sort extension --group-directories-first'
alias lst4='exa --tree -L4 -F --icons --git --sort extension --group-directories-first'
alias lst5='exa --tree -L5 -F --icons --git --sort extension --group-directories-first'
alias ls.='exa -dl .*'
alias ls='l' || alias ls='ls --color --group-directories-first --sort=extension'

# when explicitly typing cd
cd() {
    # zoxide to cd
    __zoxide_z "$@"
}


# TODO open files (vscode/run) & z into dir & remove prefix $ and retry
# aka autoz for autocd
# when not explicitly typing cd
# command_not_found_handler () {
# }

# hook to ls on dir change
chpwd() {
    lsimple
}

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