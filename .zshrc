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
# history
bindkey -M emacs \
    "^[p"   .history-search-backward \
    "^[n"   .history-search-forward \
    "^P"    .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "^N"    .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \
#    "^R"    .history-incremental-search-backward \
#    "^S"    .history-incremental-search-forward \
    #
bindkey -a \
    "^P"    .up-history \
    "^N"    .down-history \
    "k"     .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "j"     .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \
    "/"     .vi-history-search-backward \
    "?"     .vi-history-search-forward \
    #

# aliases
alias vi="nvim"
alias vim="nvim"
alias cat="bat"
#alias pc="process-compose"
alias fixssh='eval $(tmux showenv -s SSH_AUTH_SOCK)'

# abbrs
abbr -q gco="git checkout"
abbr -q gup="git pull --rebase"
abbr -q gst="git status"
abbr -q pc="process-compose"
abbr -q pcg="process-compose -p 11100"
abbr -q pcf="process-compose -p 11000"
