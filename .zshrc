#Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/code/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
eval "$(starship init zsh)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  
alias ls='ls --color=auto'
alias ll='ls -la'
alias vim='nvim'
# fnm
FNM_PATH="/home/code/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
    eval "`fnm env`"
    fi
. "$HOME/.local/bin/env"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/usr/local/gh/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.local/bin"
alias neovide="/mnt/c/Program\ Files/Neovide/neovide.exe --wsl --neovim-bin $(which nvim)"

