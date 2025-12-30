# shellcheck shell=bash
# ~/.bashrc - Ubuntu 24.04 LTS Configuration

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Enable recursive globbing with **
shopt -s globstar 2>/dev/null

# Autocorrect typos in cd
shopt -s cdspell 2>/dev/null

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
fi

# Aliases - File operations
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -ltrh'
alias lsize='ls -lSrh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Aliases - Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gpl='git pull'
alias gst='git stash'
alias lg='lazygit'

# Aliases - Editor
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# Aliases - System
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'

# Aliases - Utilities
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias myip='curl -s ifconfig.me'

# Custom PATH
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Default editor
export EDITOR='nvim'
export VISUAL='nvim'

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# FZF configuration (if installed)
if command -v fzf >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --border
        --info=inline
        --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
        --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
        --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
        --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a'
    
    # Load FZF keybindings if available
    [ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Enable bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom prompt with git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Colorful prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]\$ '

# Better man pages with colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Quick directory navigation
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}