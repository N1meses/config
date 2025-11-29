{config, lib, ...}:
{
  options.my.system.hyprland.enable = lib.mkEnableOption "enable the hyprland window manager";

  config = lib.mkIf config.my.system.hyprland.enable {
    programs.hyprland.enable = config.my.system.hyprland.enable;
  };
}
