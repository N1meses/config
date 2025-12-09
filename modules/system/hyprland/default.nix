{
  config,
  lib,
  ...
}: let
  cfg = config.my.system.hyprland;
in {
  options.my.system.hyprland.enable = lib.mkEnableOption "enable the hyprland window manager";

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = cfg.enable;
  };
}
