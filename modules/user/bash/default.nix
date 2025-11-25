{...}:		
{
  # set aliases and other things for the born again shell
  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = true; # Defaults to true, but good to be explicit
    };
    bash = { 
        enable = true;
          enableCompletion = true;
          profileExtra = ''[ -f ~/.bashrc ] && . ~/.bashrc'';
      bashrcExtra = ''
        # show fastfetch only in interactive terminals
        case $- in
        *i*) command -v fastfetch >/dev/null && fastfetch ;;
        esac
      '';
      shellAliases = {
        # NixOS management with nh (replaces nixos-rebuild & home-manager)
        # hs = "nh home switch";            # Home Manager switch with visual output /doesnt work currently
        hs = "home-manager switch --flake /home/nimeses/nixconfig#nimeses";
        # snr = "nh os switch";             # NixOS switch with visual output /doesnt work currently
        snr = "sudo nixos-rebuild switch --flake /home/nimeses/nixconfig#nimeses";
        snr-up = "nh os switch --update"; # Update flake inputs and rebuild
        snr-ask = "nh os switch --ask";   # Show diff before applying
        clean = "nh clean all --keep 5";  # Garbage collect, keep 5 generations
        
        # Build monitoring and diffs
        nb = "nom build";                                          # Build with visual output
        diff = "nvd diff /run/booted-system /run/current-system";  # See what changed
        diff-gen = "nvd diff";                                     # Compare any two generations
        
        # Dependency exploration
        tree-sys = "nix-tree /nix/var/nix/profiles/system";    # Explore system dependencies
        tree-home = "nix-tree";                                 # Explore home profile
        tree-pkg = "nix-tree nixpkgs#";                         # Explore package (append name)
        
        # File listing (eza)
        ls = "eza --icons=auto --git";
        ll = "eza -l --icons=auto --git --header";
        la = "eza -la --icons=auto --git --header";
        lt = "eza --tree --level=2 --icons=auto";
        lt3 = "eza --tree --level=3 --icons=auto";
        llm = "eza -l --sort=modified --icons=auto --git";     # Sort by modified time
        lls = "eza -l --sort=size --icons=auto --git";         # Sort by size
        
        # Git workflow
        lg = "lazygit";                                         # Visual git interface
        
        # Terminal multiplexing
        zj = "zellij";                                          # Start zellij
        zj-attach = "zellij attach";                            # Attach to session
        zj-list = "zellij list-sessions";                       # List sessions
        
        # Navigation
        cd-nixos = "cd /home/nimeses/nixconfig";
        cd-modules = "cd /home/nimeses/nixconfig/modules";
        cd-system = "cd /home/nimeses/nixconfig/modules/system";
        cd-user = "cd /home/nimeses/nixconfig/modules/user";
        
        # Development shells
        develop-python = "nix develop /home/nimeses/nixconfig#python";
        develop-java = "nix develop /home/nimeses/nixconfig#java";
        develop-stock-analysis = "nix develop #stock-analysis";
        develop-django = "nix develop /home/nimeses/nixconfig#django";
        develop-chat = "nix develop /home/nimeses/nixconfig#chat";
        develop-qml = "nix develop /home/nimeses/nixconfig#qml";
        
        # Utilities
        re = "exec $SHELL -l";
        f = "eval \"$(pay-respects bash)\"";
        please = "sudo";
        chat = "nix run /home/nimeses/nixconfig/home/nimeses/devshells/chat";
      };
    };
  };
}
