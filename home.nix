{ config, pkgs, lib, system, username, jj-github-pkg, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  
  # Path to this dotfiles directory (where this file lives)
  dotfilesDir = ./.;
in
{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = username;
  home.homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Set zsh as default shell
  # Note: On NixOS, also set `users.users.adnan.shell = pkgs.zsh;` in configuration.nix
  # On macOS/other systems, run: chsh -s $(which zsh)
  home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

  # Packages to install
  home.packages = with pkgs; [
    # Core utilities
    bat
    ripgrep
    fd
    jq
    yq-go
    htop
    tree
    
    # Development tools
    git
    gh
    
    # Go
    go
    
    # Kubernetes tools
    kubectl
    kubectx
    
    # Other
    jujutsu  # jj version control
    jj-github-pkg  # jj GitHub integration
  ];

  #
  # === ZSH Configuration ===
  #
  programs.zsh = {
    enable = true;
    
    # History settings
    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
    };
    
    # Shell options
    autocd = true;
    
    # Environment variables
    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };
    
    # Aliases
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      cat = "bat";
      fixssh = "eval $(tmux showenv -s SSH_AUTH_SOCK)";
    };
    
    # Init content (runs at the end of .zshrc)
    initContent = ''
      # Disable vi-keybindings in prompt (use emacs mode)
      bindkey -e
      
      # Better left<->right word navigation (bash-style)
      autoload -U select-word-style
      select-word-style bash
      
      ${lib.optionalString isDarwin ''
      # macOS specific
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH=/opt/homebrew/share/google-cloud-sdk/bin:"$PATH"
      ''}
      
      ${lib.optionalString isLinux ''
      # Linux specific
      # Manually managed completions dir
      fpath=("$HOME/.site-functions" $fpath)
      export PATH=$HOME/go/bin:"$PATH"
      # Fix SSH agent forwarding - symlink setup in sshrc
      export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
      ''}
      
      # zsh-autocomplete keybindings
      # Tab and Shift-tab go to the menu and cycle
      bindkey              '^I' menu-select
      bindkey "$terminfo[kcbt]" menu-select
      bindkey -M menuselect              '^I'         menu-complete
      bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
      
      # History search keybindings
      bindkey -M emacs \
          "^[p"   .history-search-backward \
          "^[n"   .history-search-forward \
          "^P"    .up-line-or-history \
          "^[OA"  .up-line-or-history \
          "^[[A"  .up-line-or-history \
          "^N"    .down-line-or-history \
          "^[OB"  .down-line-or-history \
          "^[[B"  .down-line-or-history
      
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
          "?"     .vi-history-search-forward
      
      # Abbreviations (using zsh-abbr plugin)
      # These expand when you press space
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
    '';
    

    
    # Syntax highlighting
    syntaxHighlighting.enable = true;
    
    # Autosuggestions
    autosuggestion.enable = true;
    
    # Enable completions
    enableCompletion = true;
    
    # Plugins (for those not natively supported by home-manager)
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "24.09.04";
          sha256 = "sha256-o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w=";
        };
      }
      {
        # zsh-abbr fetched from GitHub with submodules (includes zsh-job-queue dependency)
        name = "zsh-abbr";
        src = pkgs.fetchgit {
          url = "https://github.com/olets/zsh-abbr.git";
          rev = "v6.4.0";
          sha256 = "sha256-nfkXtRZ7CB/MnmzMe1ivKz26Vv5duP4zTAv7EZwpMTM=";
          fetchSubmodules = true;
        };
      }
    ];
  };

  #
  # === Autojump ===
  #
  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  #
  # === FZF ===
  #
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  #
  # === Direnv ===
  #
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  #
  # === Starship Prompt ===
  #
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # Use existing TOML config file
  };
  
  # Symlink starship config
  xdg.configFile."starship.toml".source = ./starship/starship.toml;

  #
  # === Tmux ===
  #
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    # Additional tmux config can be added here
    extraConfig = ''
      # Add any extra tmux configuration here
    '';
  };

  #
  # === Neovim ===
  #
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Read the existing init.vim configuration
    extraConfig = builtins.readFile ./nvim/init.vim;
    
    # Plugins managed by Nix
    plugins = with pkgs.vimPlugins; [
      vim-sleuth
      NeoSolarized
    ];
  };



  #
  # === Git ===
  #
  programs.git.enable = true;

  #
  # === Jujutsu ===
  #
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Adnan Abdulhussein";
        email = if username == "developer" then "adnan.abdulhussein@repl.it" else "adnan@prydoni.us";
      };
      aliases = {
        gh = ["util" "exec" "--" "jj-github"];
        up = ["edit" "@-"];
        down = ["edit" "@+"];
      };
      ui = {
        conflict-marker-style = "git";
      };
      templates = {
        git_push_bookmark = ''"adnan/push-" ++ change_id.short()'';
      };
    };
  };

  programs.jjui = {
    enable = true;
    settings = {
      ui.colors = {
        "selected" = { bg = "#002f3c"; fg = "#fdf6e3"; };
        "revisions selected" = { bg = "#002f3c"; fg = "#fdf6e3"; };
        "revisions details selected" = { bg = "#002f3c"; fg = "#fdf6e3"; };
        "menu selected" = { bg = "#002f3c"; fg = "#fdf6e3"; };
        "confirmation selected" = { bg = "#002f3c"; fg = "#fdf6e3"; };
        "undo confirmation selected" = { bg = "#002f3c"; fg = "#fdf6e3"; };
        "revset completion selected" = { bg = "#002f3c"; fg = "#fdf6e3"; };
        "evolog selected" = { bg = "#002f3c"; fg = "#fdf6e3"; };
      };
    };
  };

  #
  # === Symlinks for other config files ===
  #
  
  # OpenCode configuration
  xdg.configFile."opencode" = {
    source = ./opencode;
    recursive = true;
  };

  # SSH agent forwarding fix for tmux
  # Creates a stable symlink so tmux sessions can find the agent socket
  home.file.".ssh/rc" = {
    text = ''
      #!/bin/bash

      # Fix SSH auth socket location so agent forwarding works with tmux.
      if test "$SSH_AUTH_SOCK" ; then
        ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
      fi
    '';
    executable = true;
  };

  #
  # === DevVM Configuration (developer user on Linux only) ===
  #
  
  # Activation script to deploy config to /etc/nixos and rebuild DevVM when changed
  home.activation.rebuildDevvm = lib.mkIf (username == "developer" && isLinux) (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      SOURCE_CONFIG="${./devvm/configuration.nix}"
      TARGET_CONFIG="/etc/nixos/configuration.nix"
      HASH_FILE="$HOME/.local/state/devvm-last-rebuild-hash"
      DEVVM_FLAKE="/etc/nixos"

      # Only proceed if /etc/nixos exists (we're on a devvm)
      if [ -d "$DEVVM_FLAKE" ] && [ -f "$TARGET_CONFIG" ]; then
        CURRENT_HASH=$(${pkgs.coreutils}/bin/sha256sum "$SOURCE_CONFIG" | ${pkgs.coreutils}/bin/cut -d' ' -f1)
        LAST_HASH=""
        if [ -f "$HASH_FILE" ]; then
          LAST_HASH=$(${pkgs.coreutils}/bin/cat "$HASH_FILE")
        fi

        if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
          echo "DevVM config changed, updating /etc/nixos/configuration.nix..."
          /run/wrappers/bin/sudo ${pkgs.coreutils}/bin/cp "$SOURCE_CONFIG" "$TARGET_CONFIG"
          
          echo "Rebuilding NixOS..."
          if /run/wrappers/bin/sudo PATH="/run/current-system/sw/bin:$PATH" /run/current-system/sw/bin/nixos-rebuild switch --flake "$DEVVM_FLAKE#replit-devvm" > /tmp/devvm-rebuild.log 2>&1; then
            ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$HASH_FILE")"
            echo "$CURRENT_HASH" > "$HASH_FILE"
            echo "DevVM rebuild complete."
          else
            echo "DevVM rebuild failed. Check /tmp/devvm-rebuild.log for details."
            ${pkgs.coreutils}/bin/cat /tmp/devvm-rebuild.log
          fi
        fi
      fi
    ''
  );
}
