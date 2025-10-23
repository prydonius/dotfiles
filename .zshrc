# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history

export EDITOR="vim"
export VISUAL="vim"
bindkey -e # disable vi-keybindings in prompt

# mac specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH=/opt/homebrew/share/google-cloud-sdk/bin:"$PATH"
fi

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
source <(fzf --zsh)
eval "$(sheldon source)"

# zsh-autocomplete
# cycle through completions
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# aliases
alias vi="nvim"
alias vim="nvim"
alias cat="bat"
alias pc="process-compose"
alias fixssh='eval $(tmux showenv -s SSH_AUTH_SOCK)'
