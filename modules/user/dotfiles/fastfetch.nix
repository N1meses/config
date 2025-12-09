{
  config,
  lib,
  ...
}: let
  cfg = config.my.user.dotfiles.fastfetch;
in {
  options.my.user.dotfiles = {
    fastfetch.enable = lib.mkEnableOption "enable custom fastfetch option";
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
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

    xdg.configFile = lib.optionalAttrs cfg.enable {
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
