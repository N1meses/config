{pkgs, lib, ...}:
{
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-termfilechooser
      ];
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser"];
        };
        hyprland = {
          default = lib.mkForce [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
        niri = {
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
