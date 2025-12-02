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
    ../../modules/system/shell
  ];
  
  config = {
    nix.package = pkgs.nix;
    
    my.system = {
      host = {
        userName = "nimeses";
        hostName = "nimeses";
      };

      boot.enable = true;

      localization.enable = true;

      security.enable = true;

      shell.enable = true;
      
      networking = {
        enable = true;
        firewall.trustedInterfaces = ["tailscale0"];
      };

      services = {
          enable = true;
          bluetooth.enable = true;
          audio.enable = true;
          mysql.enable = true;
          tailscale.enable = true;
          power.enable = true;
          displayManager.enable = true;
          gnomeKeyring.enable = true;
          udisks.enable = true;
          xserver.enable = false;
      };

      virtualisation = {
        enable = true;
        virtManager.enable = true;
        TPM.enable = true;
      };

      hyprland.enable = true;

      niri.enable = true;

      settings = {
        enable = true;
        nix-ld.enable = true;
        garbageCollector.enable = true;
      };

      xdg.portal.enable = true;
    };

    users.users.nimeses = {
      isNormalUser = true;
      description = "Nimeses";
      home = "/home/nimeses";
      extraGroups = [ "networkmanager" "wheel"];
    };

    environment = {
      variables.QT_QPA_PLATFORMTHEME = "qt6ct";
            
      systemPackages = with pkgs;[
        brave
        ntfs3g
        git
        networkmanager
        pipewire
        wget
      ];
    };
    
    system.stateVersion = "25.05";
  };
}
