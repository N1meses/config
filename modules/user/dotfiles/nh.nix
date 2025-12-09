{
  config,
  lib,
  ...
}: let
  cfg = config.my.user.dotfiles.nh;
in {
  options.my.user.dotfiles = {
    nh.enable = lib.mkEnableOption "enable custom options for nix-helper";
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
      flake = "/home/nimeses/nixconfig";
    };
  };
}
