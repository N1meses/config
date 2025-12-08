{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.system.xdg.portal;
in {
  options.my.system.xdg.portal = {
    enable = lib.mkEnableOption "Enable Portals for Wayland compositor";

    terminal-filechooser.enable = lib.mkEnableOption "make yazi the default filechooser";
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

    environment.systemPackages = with pkgs;
      lib.optionals cfg.terminal-filechooser.enable [
        yazi
      ];

    home-manager.users.${config.my.system.host.userName}.home.packages = with pkgs;
      lib.optionals cfg.terminal-filechooser.enable [
        xdg-desktop-portal-termfilechooser
        xdg-terminal-exec
      ];

    environment.etc."xdg/xdg-desktop-portal-termfilechooser/config".text = lib.mkIf cfg.terminal-filechooser.enable ''
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

    xdg.portal = {
      enable = cfg.enable;

      # Use regular packages, not override, to ensure they're in user profile
      extraPortals = with pkgs;
        [
          xdg-desktop-portal-gtk
        ]
        ++ lib.optional config.my.system.niri.enable xdg-desktop-portal-gnome
        ++ lib.optional config.my.system.hyprland.enable xdg-desktop-portal-hyprland
        ++ lib.optional cfg.terminal-filechooser.enable xdg-desktop-portal-termfilechooser;

      config = {
        common =
          {
            default = ["gtk"];
            "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          }
          // lib.optionalAttrs cfg.terminal-filechooser.enable {
            "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
          };

        hyprland = lib.mkIf config.my.system.hyprland.enable (
          {
            default = lib.mkForce [
              "hyprland"
              "gtk"
            ];
          }
          // lib.optionalAttrs cfg.terminal-filechooser.enable {
            "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
          }
        );

        niri = lib.mkIf config.my.system.niri.enable (
          {
            default = lib.mkForce [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
            "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
          }
          // lib.optionalAttrs cfg.terminal-filechooser.enable {
            "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
          }
        );
      };
    };
  };
}
