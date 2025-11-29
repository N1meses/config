{config, pkgs, lib, ...}:
{
  options.my.system.xdg.portal = {
    enable = lib.mkEnableOption "Enable Protals for Wayland comositor";
  };

  config = lib.mkIf config.my.system.xdg.portal.enable {
    xdg.portal = {
      enable = config.my.system.xdg.portal.enable;

      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-gtk
      ] ++ lib.optional config.my.system.niri.enable xdg-desktop-portal-gnome
        ++ lib.optional config.my.system.hyprland.enable xdg-desktop-portal-hyprland;

      config = {
        common = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser"];
        };

        hyprland = lib.mkIf config.my.system.hyprland.enable {
          default = lib.mkForce [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };

        niri = lib.mkIf config.my.system.niri.enable {
          default = lib.mkForce [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
    };
  };
}
