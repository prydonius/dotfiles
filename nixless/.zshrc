# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history
setopt hist_ignore_all_dups


export EDITOR="vim"
export VISUAL="vim"
bindkey -e # disable vi-keybindings in prompt

# better left<->right navigation
autoload -U select-word-style
select-word-style bash

# mac specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH=/opt/homebrew/share/google-cloud-sdk/bin:"$PATH"
elif [[ -d /etc/nixos ]]; then
  # manually managed completions dir
  fpath=("/home/adnan/.site-functions" $fpath)
  export PATH=$HOME/go/bin:"$PATH"
  # fix ssh agent forwarding - symlink setup in sshrc
  export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
fi

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
source <(fzf --zsh)
eval "$(sheldon source)"

# zsh-autocomplete
# Tab and Shift-tab go to the menu and cycle
bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select
bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

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
abbr -q ga="git add"
abbr -q gco="git checkout"
abbr -q gup="git pull --rebase"
abbr -q gst="git status"
abbr -q gcom="git checkout main"
abbr -q gfom="git fetch origin main:main"
abbr -q gcmod="git commit -a --amend"
abbr -q gcam="git commit -am"
abbr -q -g ggp="git push"

abbr -q pc="process-compose -p 11000"
abbr -q pcls="process-compose -p 11000 list -o wide"
abbr -q pcl="process-compose -p 11000 process logs"
abbr -q pcr="process-compose -p 11000 process restart"

abbr -q k="kubectl"
abbr -q kpf="kubectl port-forward"
abbr -q kns="kubens"
abbr -q kctx="kubectx"
abbr -q -g bml="bat -l yaml"
