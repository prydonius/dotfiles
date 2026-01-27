{ config, pkgs, lib, system, username, ... }:

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
        # zsh-abbr fetched from GitHub to avoid unfree nixpkgs version
        name = "zsh-abbr";
        src = pkgs.fetchFromGitHub {
          owner = "olets";
          repo = "zsh-abbr";
          rev = "v6.4.0";
          sha256 = "sha256-lJnJ5H0j/ZEX3CVdfaVo+6eowOS28MIL0ykbjmEmXw4=";
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
    
    # Plugins managed by Nix (optional - you can also keep vim-plug)
    plugins = with pkgs.vimPlugins; [
      # Uncomment to have Nix manage plugins instead of vim-plug:
      # vim-sleuth
      # Add more plugins here
    ];
  };



  #
  # === Git ===
  #
  programs.git.enable = true;

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
}
