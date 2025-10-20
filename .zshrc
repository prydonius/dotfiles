# mac specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH=/opt/homebrew/share/google-cloud-sdk/bin:"$PATH"
fi

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"

# aliases
alias vi="nvim"
alias vim="nvim"
alias cat="bat"
alias pc="process-compose"
