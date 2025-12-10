{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user.shell;

  defaultAliases = {
    # NixOS management with nh (replaces nixos-rebuild & home-manager)
    # hs = "nh home switch";       # Home Manager switch with visual output /doesnt work currently
    hs = "home-manager switch --flake /home/nimeses/nixconfig#nimeses";
    # snr = "nh os switch";             # NixOS switch with visual output /doesnt work currently
    snr = "sudo nixos-rebuild switch --flake /home/nimeses/nixconfig#nimeses";
    snr-up = "nh os switch --update"; # Update flake inputs and rebuild
    snr-ask = "nh os switch --ask"; # Show diff before applying
    clean = "nh clean all --keep 5"; # Garbage collect, keep 5 generations

    # Navigation
    cd-nixos = "cd /home/nimeses/nixconfig";
    cd-modules = "cd /home/nimeses/nixconfig/modules";
    cd-system = "cd /home/nimeses/nixconfig/modules/system";
    cd-user = "cd /home/nimeses/nixconfig/modules/user";
    # Development shellAliases

    develop-python = "nix develop /home/nimeses/nixconfig#python";
    develop-java = "nix develop /home/nimeses/nixconfig#java";
    develop-stock-analysis = "nix develop #stock-analysis";
    develop-django = "nix develop /home/nimeses/nixconfig#django";
    develop-chat = "nix develop /home/nimeses/nixconfig#chat";
    develop-qml = "nix develop /home/nimeses/nixconfig#qml";

    please = "sudo";
    chat = "nix run /home/nimeses/nixconfig/home/nimeses/devshells/chat";
    re = "exec $SHELL -l";
  };

  nixhelpersAliases = {
    # Build monitoring and diffs
    nb = "nom build"; # Build with visual output
    diff = "nvd diff /run/booted-system /run/current-system"; # See what changed
    diff-gen = "nvd diff"; # Compare any two generations

    # Dependency exploration
    tree-sys = "nix-tree /nix/var/nix/profiles/system"; # Explore system dependencies
    tree-home = "nix-tree"; # Explore home profile
    tree-pkg = "nix-tree nixpkgs#"; # Explore package (append name)
  };

  ezaAliases = lib.optionalAttrs cfg.eza.enable {
    # File listing (eza)
    ls = "eza --icons=auto --git";
    ll = "eza -l --icons=auto --git --header";
    la = "eza -la --icons=auto --git --header";
    lt = "eza --tree --level=2 --icons=auto";
    lt3 = "eza --tree --level=3 --icons=auto";
    llm = "eza -l --sort=modified --icons=auto --git"; # Sort by modified time
    lls = "eza -l --sort=size --icons=auto --git"; # Sort by size
  };

  lazyGitAliases = lib.optionalAttrs cfg.lazygit.enable {
    # Git workflow
    lg = "lazygit"; # Visual git interface
  };

  zellijAliases = lib.optionalAttrs cfg.zellij.enable {
    # Terminal multiplexing
    zj = "zellij"; # Start zellij
    zj-attach = "zellij attach"; # Attach to session
    zj-list = "zellij list-sessions"; # List sessions
  };

  payRespectsAliases = lib.optionalAttrs cfg.payRespects.enable {
    # Utilities
    f = "eval \"$(pay-respects bash)\"";
  };

  fastFetchAliases = lib.optionalAttrs config.my.user.dotfiles.fastfetch.enable {
    ff = "fastfetch";
  };

  mergedAliases =
    defaultAliases
    // cfg.shellAliases
    // ezaAliases
    // nixhelpersAliases
    // lazyGitAliases
    // zellijAliases
    // payRespectsAliases
    // fastFetchAliases;
in {
  options.my.user.shell = {
    enable = lib.mkEnableOption "Enable shell configuration";

    shellType = lib.mkOption {
      type = lib.types.enum ["bash" "zsh"];
      default = "zsh";
      description = "Which shell to use (zsh or bash)";
    };

    zoxide.enable = lib.mkEnableOption "Enable Zoxide integration";

    eza.enable = lib.mkEnableOption "eza file listing tool";

    zellij.enable = lib.mkEnableOption "zellij terminal multiplexer";

    payRespects.enable = lib.mkEnableOption "pay-respects (fuck replacement)";

    lazygit.enable = lib.mkEnableOption "lazygit TUI";

    shellAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Extra shell aliases added to defaults";
    };

    bash = {
      enableCompletion = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable bash autocompletion";
      };
    };

    zsh = {
      enableCompletion = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable zsh autocompletion";
      };

      enableAutosuggestions = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable zsh autosuggestions (greyed out suggestions)";
      };

      enableSyntaxHighlighting = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable zsh syntax highlighting";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      []
      ++ lib.optional cfg.eza.enable eza
      ++ lib.optional cfg.zellij.enable zellij
      ++ lib.optional cfg.payRespects.enable pay-respects
      ++ lib.optional cfg.lazygit.enable lazygit
      ++ lib.optional cfg.zoxide.enable zoxide;

    programs.bash = lib.mkIf (cfg.shellType == "bash") {
      enable = true;

      enableCompletion = cfg.bash.enableCompletion;

      profileExtra = ''[ -f ~/.bashrc ] && . ~/.bashrc'';

      bashrcExtra = ''
        # show fastfetch only in interactive terminals
        case $- in
        *i*) command -v fastfetch >/dev/null && fastfetch ;;
        esac
      '';
      shellAliases = mergedAliases;
    };

    programs.zsh = lib.mkIf (cfg.shellType == "zsh") {
      enable = true;

      enableCompletion = cfg.zsh.enableCompletion;
      autosuggestion.enable = cfg.zsh.enableAutosuggestions;
      syntaxHighlighting = {
        enable = cfg.zsh.enableSyntaxHighlighting;
        # Optimize syntax highlighting for performance
        highlighters = ["main"]; # Only use main highlighter, skip brackets/pattern/cursor
      };

      # Use completion cache to speed up compinit
      completionInit = ''
        autoload -Uz compinit
        # Only regenerate compdump once a day
        if [[ -n ~/.zcompdump(#qNmh+24) ]]; then
          compinit
        else
          compinit -C
        fi
      '';

      shellAliases = mergedAliases;

      # Load heavy tools asynchronously where possible
      initContent = ''
        # show fastfetch only in login shells, not every shell
        if [[ -o login ]] && command -v fastfetch >/dev/null; then
          fastfetch
        fi

        # Set history options for better performance
        setopt HIST_FCNTL_LOCK
        setopt HIST_IGNORE_DUPS
        setopt SHARE_HISTORY
      '';

      history = {
        size = 10000;
        save = 10000;
        path = "$HOME/.zsh_history";
        ignoreAllDups = false;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
      };
    };

    programs.zoxide = lib.mkIf cfg.zoxide.enable {
      enable = true;
      enableBashIntegration = cfg.shellType == "bash";
      enableZshIntegration = cfg.shellType == "zsh";
    };
  };
}
