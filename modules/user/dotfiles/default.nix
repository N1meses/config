{pkgs, config, ...}:
{
  programs = {

    home-manager.enable = true;

    ghostty = {
      enable = true;
      settings = {
        config-file = [ "~/.config/ghostty/themes/noctalia" ];
        font-size = 12;
        font-family = "IBM Plex Mono";
      };
    };

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
      flake = "/home/nimeses/nixconfig";
    };

    chromium = {
      enable = true;
      package = pkgs.brave;
    };

    yazi = {
      enable = true;
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
          image_alloc = 536870912;  # 512MB max memory for decoding
          image_bound = [65535 65535];  # Max image dimensions (u16 limit)
        };
      };
    };
    
    fastfetch = {
      enable = true;
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
		enable = true;
		font = {
			name = "IBM Plex Sans";
			size = 10;
		};

    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      extraCss = ''
        @import "${config.xdg.configHome}/gtk-3.0/colors.css";
      '';
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      extraCss = ''
        @import "${config.xdg.configHome}/gtk-4.0/colors.css";
      '';
    };
	};

  # Configure xdg-desktop-portal-termfilechooser to use yazi
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${pkgs.writeShellScript "yazi-filechooser.sh" ''
      set -e
      multiple="$1"
      directory="$2"
      save="$3"
      path="$4"
      out="$5"

      if [ "$save" = "1" ]; then
        exec ghostty --title=termfilechooser -e yazi --chooser-file="$out" "$path"
      elif [ "$directory" = "1" ]; then
        exec ghostty --title=termfilechooser -e yazi --chooser-file="$out" --cwd-file="$out.1" "$path"
      elif [ "$multiple" = "1" ]; then
        exec ghostty --title=termfilechooser -e yazi --chooser-file="$out" "$path"
      else
        exec ghostty --title=termfilechooser -e yazi --chooser-file="$out" "$path"
      fi
    ''}
  '';

  xdg.configFile."fastfetch/nixowos.txt".text = ''
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
}
