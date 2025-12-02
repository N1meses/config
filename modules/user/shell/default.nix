{config, lib, pkgs,...}:
let 
  mus = config.my.user.shell;
  hasEza = builtins.elem pkgs.eza config.home.packages;
  hasZellij = builtins.elem pkgs.zellij config.home.packages;
  hasPayRespects = builtins.elem pkgs.pay-respects config.home.packages;
  hasLazyGit = builtins.elem pkgs.lazygit config.home.packages;

  defaultAliases = {
    # NixOS management with nh (replaces nixos-rebuild & home-manager)
    # hs = "nh home switch";       # Home Manager switch with visual output /doesnt work currently
    hs = "home-manager switch --flake /home/nimeses/nixconfig#nimeses";
    # snr = "nh os switch";             # NixOS switch with visual output /doesnt work currently
    snr = "sudo nixos-rebuild switch --flake /home/nimeses/nixconfig#nimeses";
    snr-up = "nh os switch --update"; # Update flake inputs and rebuild
    snr-ask = "nh os switch --ask";   # Show diff before applying
    clean = "nh clean all --keep 5";  # Garbage collect, keep 5 generations

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
    nb = "nom build";                                          # Build with visual output
    diff = "nvd diff /run/booted-system /run/current-system";  # See what changed
    diff-gen = "nvd diff";                                     # Compare any two generations
    
    # Dependency exploration
    tree-sys = "nix-tree /nix/var/nix/profiles/system";    # Explore system dependencies
    tree-home = "nix-tree";                                 # Explore home profile
    tree-pkg = "nix-tree nixpkgs#";                         # Explore package (append name)
  };

  ezaAliases = lib.optionalAttrs hasEza {  
    # File listing (eza)
    ls = "eza --icons=auto --git";
    ll = "eza -l --icons=auto --git --header";
    la = "eza -la --icons=auto --git --header";
    lt = "eza --tree --level=2 --icons=auto";
    lt3 = "eza --tree --level=3 --icons=auto";
    llm = "eza -l --sort=modified --icons=auto --git";     # Sort by modified time
    lls = "eza -l --sort=size --icons=auto --git";         # Sort by size
  };
  
  lazyGitAliases = lib.optionalAttrs hasLazyGit {
    # Git workflow
    lg = "lazygit";                                         # Visual git interface
  };

  zellijAliases = lib.optionalAttrs hasZellij {  
    # Terminal multiplexing
    zj = "zellij";                                          # Start zellij
    zj-attach = "zellij attach";                            # Attach to session
    zj-list = "zellij list-sessions";                       # List sessions
  };    

   payRespectsAliases = lib.optionalAttrs hasPayRespects { 
    # Utilities
    f = "eval \"$(pay-respects bash)\"";
  };

  mergedAliases = defaultAliases 
    // mus.shellAliases
    // ezaAliases
    // nixhelpersAliases
    // lazyGitAliases
    // zellijAliases
    // payRespectsAliases;
in {
  options.my.user.shell = {
    enable = lib.mkEnableOption "Enable shell configuration";

    shellType = lib.mkOption {
      type = lib.types.enum ["bash" "zsh"];
      default = "zsh";
      description = "Which shell to use (zsh or bash)";
    };

    zoxide.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Zoxide integration";
    };
      
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
  
  config = lib.mkIf mus.enable {

    programs.bash = lib.mkIf (mus.shellType == "bash") {
      enable = true;

      enableCompletion = mus.bash.enableCompletion;

      profileExtra = ''[ -f ~/.bashrc ] && . ~/.bashrc''; 

      bashrcExtra =
        ''
        # show fastfetch only in interactive terminals
        case $- in
        *i*) command -v fastfetch >/dev/null && fastfetch ;;
        esac
        '';
      shellAliases = mergedAliases;
    };

    programs.zsh = lib.mkIf (mus.shellType == "zsh") {
        enable = true;

        enableCompletion = mus.zsh.enableCompletion;
        autosuggestion.enable = mus.zsh.enableAutosuggestions;
        syntaxHighlighting.enable = mus.zsh.enableSyntaxHighlighting;

        shellAliases = mergedAliases;

        initContent =
          ''
            # show fastfetch only in interactive terminals
            [[ $- == *i* ]] && command -v fastfetch >/dev/null && fastfetch
          '';
      };

      programs.zoxide = lib.mkIf mus.zoxide.enable {
        enable = true;
        enableBashIntegration = (mus.shellType == "bash");
        enableZshIntegration = (mus.shellType == "zsh");
      };
    };
  }
