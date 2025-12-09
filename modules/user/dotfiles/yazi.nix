{
  config,
  lib,
  ...
}: let
  cfg = config.my.user.dotfiles.yazi;
in {
  options.my.user.dotfiles = {
    yazi.enable = lib.mkEnableOption "enable custom configuration of yazi";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
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
          image_alloc = 536870912; # 512MB max memory for decoding
          image_bound = [65535 65535]; # Max image dimensions (u16 limit)
        };
      };
    };
  };
}
