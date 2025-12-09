{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.system.niri;
in {
  options.my.system.niri = {
    enable = lib.mkEnableOption "enable the niri window manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.niri-unstable;
      description = "which packages and version of niri to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = cfg.enable;
      package = cfg.package;
    };
  };
}
