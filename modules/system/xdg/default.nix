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

    home-manager.users.${config.my.system.host.userName} = lib.mkIf cfg.terminal-filechooser.enable {
      home.packages = [
        pkgs.xdg-desktop-portal-termfilechooser
        pkgs.xdg-terminal-exec
      ];

      xdg.configFile."xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
        executable = true;
        text = ''
          #!${pkgs.bash}/bin/bash
          set -e
          multiple="$1"
          directory="$2"
          save="$3"
          path="$4"
          out="$5"

          # Use current directory if path is empty
          if [ -z "$path" ]; then
            path="."
          fi

          if [ "$save" = "1" ]; then
            exec ${pkgs.ghostty}/bin/ghostty --title=termfilechooser -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
          elif [ "$directory" = "1" ]; then
            exec ${pkgs.ghostty}/bin/ghostty --title=termfilechooser -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" --cwd-file="$out.1" "$path"
          elif [ "$multiple" = "1" ]; then
            exec ${pkgs.ghostty}/bin/ghostty --title=termfilechooser -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
          else
            exec ${pkgs.ghostty}/bin/ghostty --title=termfilechooser -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
          fi
        '';
      };

      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=/home/${config.my.system.host.userName}/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      '';
    };

    xdg.portal = {
      enable = cfg.enable;

      # Use regular packages, not override, to ensure they're in user profile
      extraPortals =
        [
          pkgs.xdg-desktop-portal-gtk
        ]
        ++ lib.optional config.my.system.niri.enable pkgs.xdg-desktop-portal-gnome
        ++ lib.optional config.my.system.hyprland.enable pkgs.xdg-desktop-portal-hyprland;

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
