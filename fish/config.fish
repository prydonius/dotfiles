if status is-interactive
    # Commands to run in interactive sessions can go here
end
eval "$(/opt/homebrew/bin/brew shellenv)"
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# fnm node
fnm env --use-on-cd | source

# SDKMan
function sdk
    bash -c "source '$HOME/.sdkman/bin/sdkman-init.sh'; sdk $argv[1..]"
end

fish_add_path (find $HOME/.sdkman/candidates/*/current/bin -maxdepth 0)
fish_add_path /opt/homebrew/opt/python@3.10/libexec/bin
fish_add_path "/Users/adnan/Library/Application Support/JetBrains/Toolbox/scripts"

# Enable git plugin
__git.reset

abbr --add k kubectl
abbr --add kctx kubectx
abbr --add kns kubens
