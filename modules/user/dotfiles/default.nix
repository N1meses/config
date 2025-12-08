{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user.dotfiles;
in {
  options.my.user.dotfiles = {
    enable = lib.mkEnableOption "enable personalized configurations";

    home-manager.enable = lib.mkEnableOption "enable home-manager";

    ghostty.enable = lib.mkEnableOption "enable configuration of ghostty";

    yazi.enable = lib.mkEnableOption "enable custom configuration of yazi";

    nh.enable = lib.mkEnableOption "enable custom options for nix-helper";

    fastfetch.enable = lib.mkEnableOption "enable custom fastfetch option";

    gtk.enable = lib.mkEnableOption "enable gtk customization";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      home-manager.enable = cfg.home-manager.enable;

      ghostty = {
        enable = cfg.ghostty.enable;
        settings = {
          config-file = ["~/.config/ghostty/themes/noctalia"];
          font-size = 12;
          font-family = "IBM Plex Mono";
        };
      };

      nh = {
        enable = cfg.nh.enable;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 5";
        };
        flake = "/home/nimeses/nixconfig";
      };

      yazi = {
        enable = cfg.yazi.enable;
        enableBashIntegration = true;
        settings = {
          mgr = {
            show_hidden = true;
            sort_by = "natural";
          };
          preview = {
            image_quality = 80;
            max_width = 10000;
            max_height = 10000;
          };
          tasks = {
            image_alloc = 536870912; # 512MB max memory for decoding
            image_bound = [65535 65535]; # Max image dimensions (u16 limit)
          };
        };
      };

      fastfetch = {
        enable = cfg.fastfetch.enable;
        settings = {
          logo = {
            source = "${config.xdg.configHome}/fastfetch/nixowos.txt";
            type = "file";
            padding = {
              top = 1;
              left = 2;
            };
            color = {
              "1" = "#5277C3"; # Deep Blue
              "2" = "#7EBAE4"; # Light Blue
              "3" = "#DF90AF"; # Pink (The Blush ///)
              "4" = "#2D789E"; # Darker Blue
              "5" = "#5F92D3"; # Medium Blue
            };
          };
          modules = [
            "title"
            "separator"
            "os"
            "host"
            "kernel"
            "packages"
            "shell"
            "display"
            "wm"
            "font"
            "terminal"
            "terminalfont"
            "cpu"
            "gpu"
            "memory"
            "swap"
            "disk"
            "localip"
            "battery"
            "break"
            "colors"
          ];
        };
      };
    };
    gtk = {
      enable = cfg.gtk.enable;
      font = {
        name = "IBM Plex Sans";
        size = 10;
      };

      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        extraCss = ''
          @import "${config.xdg.configHome}/gtk-3.0/colors.css";
        '';
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        extraCss = ''
          @import "${config.xdg.configHome}/gtk-4.0/colors.css";
        '';
      };
    };

    xdg.configFile = lib.optionalAttrs cfg.fastfetch.enable {
      "fastfetch/nixowos.txt".text = ''
        $1           ▗▄▄▄       $2▗▄▄▄▄    ▄▄▄▖
        $1           ▜███▙       $2▜███▙  ▟███▛
        $1            ▜███▙       $2▜███▙▟███▛       $1▗
        $1     ▐▄      ▜███▙       $2▜██████▛    $1▄▄▞▀▛
        $1      ▜▀▀▀▄▄  ▜█████████▙ $2▜████▛  $1▄█▛▀  ▗▘
        $1       ▌   ▀█▄▟██████████▙ $2▜███▙$1▟█▛    ▗▞
        $1       ▐  ▙▖▟$2▙▄▄▖           $2▜████$1▙▄▟▘  ▟▘
        $1        ▜▖▝█$2███▛             $2▜██▛$1██▄▄▄▞▘
        $1         ▝$2▟███▛ $4▀▚▄       ▄▞▀ $2▜▛ $1▟███▛
        $2 ▟███████████▛ $4▗▄▄▞▘     ▝▚▄▄▖  $1▟██████████▙
        $2 ▜██████████▛  $3/// $4▟▘ ▄ ▝▙ $3/// $1▟███████████▛
        $2       ▟███▛ $1▟▙    $4▜▄▟▀▙▄▛    $1▟███▛
        $2      ▟███▛ $1▟██▙             $1▟███▛      $5▄
        $2     ▟███▛  $1▜███▙           $1▝▀▀▀▀  $5▗▄▛▀▀
        $2     ▜██▛  ▗▌$1▜███▙ $2▜██████████████████▛
        $2      ▜▛  ▗▛ $1▟████▙ $2▜████████████████▛
        $2          ▝▌$1▟██████▙     $5▄▄$2▜███▙
        $1           ▟███▛▜███▙$2▄▄▟$5▀▘  $2▜███▙
        $1          ▟███▛$2▄▄$1▜███▙       $2▜███▙
        $1          ▝▀▀▀    ▀▀▀▀▘       $2▀▀▀▘
      '';
    };
  };
}
