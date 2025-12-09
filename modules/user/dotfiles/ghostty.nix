{
  config,
  lib,
  ...
}: let
  cfg = config.my.user.dotfiles.ghostty;
in {
  options.my.user.dotfiles = {
    ghostty.enable = lib.mkEnableOption "enable configuration of ghostty";
  };

  config = lib.mkIf cfg.enable {
    ghostty = {
      enable = true;
      settings = {
        config-file = ["~/.config/ghostty/themes/noctalia"];
        font-size = 12;
        font-family = "IBM Plex Mono";
      };
    };
  };
}
