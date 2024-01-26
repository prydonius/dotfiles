if status is-interactive
    # Commands to run in interactive sessions can go here
end
eval "$(/opt/homebrew/bin/brew shellenv)"

if test -e /opt/homebrew/opt/asdf/libexec/asdf.fish
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
end

# fnm node
if type -q fnm
    fnm env --use-on-cd | source
end

# SDKMan
function sdk
    bash -c "source '$HOME/.sdkman/bin/sdkman-init.sh'; sdk $argv[1..]"
end

if test -d $HOME/.sdkman
    fish_add_path (find $HOME/.sdkman/candidates/*/current/bin -maxdepth 0)
end
fish_add_path /opt/homebrew/opt/python@3.10/libexec/bin
fish_add_path "/Users/adnan/Library/Application Support/JetBrains/Toolbox/scripts"

abbr --add k kubectl
abbr --add kctx kubectx
abbr --add kns kubens
