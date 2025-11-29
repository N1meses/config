{pkgs, ... }:{

  imports = [
    ./hardware-configuration.nix
    ../../modules/system/boot
    ../../modules/system/localization
    ../../modules/system/hyprland
    ../../modules/system/services
    ../../modules/system/xdg
    ../../modules/system/networking
    ../../modules/system/settings
    ../../modules/system/security
    ../../modules/system/virtualisation
    ../../modules/system/host
    ../../modules/system/niri
  ];

  config = {
    my.system = {
        host = {
          userName = "hephaistos";
          hostName = "hephaistos";
        };

        boot.enable = true;
        localization.enable = true;
        xdg.portal.enable = true;
    };

    users.users.hephaistos = {
      isNormalUser = true;
      description = "Hephaistos";
      home = "/home/hephaistos";
      extraGroups = [ "networkmanager" "wheel"];
      shell = pkgs.bashInteractive;
    };

    console.keyMap = "de";

    environment = {
      variables.QT_QPA_PLATFORMTHEME = "qt6ct";

      sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      systemPackages = with pkgs;[
        brave
        ntfs3g
        git
        networkmanager
        pipewire
        wget
      ];
    };

    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    system.stateVersion = "25.05";
  };
}
