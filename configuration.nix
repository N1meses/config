{pkgs, ...}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/hyprland
    ./modules/system/boot 
    ./modules/system/services
    ./modules/system/xdg
    ./modules/system/networking
    ./modules/system/timezone
    ./modules/system/settings
    ./modules/system/security
    ./modules/system/virtualisation
    ./modules/system/niri
  ];
  
  users.users.nimeses = {
    isNormalUser = true;
    description = "Nimeses";
    home = "/home/nimeses";
    extraGroups = [ "networkmanager" "wheel"];
    shell = pkgs.bashInteractive;
  };

  console.keyMap = "de";

  environment = {
    variables.QT_QPA_PLATFORMTHEME = "qt6ct";

    sessionVariables = {
    NIXOS_OZONE_WL = "1";     # Electron/Chromium
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    #GDK_BACKEND = "wayland,x11";
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
}
