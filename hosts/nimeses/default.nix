{pkgs, ...}: {
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
    ../../modules/system/performance
  ];

  # these modules are found unser /modules/system/
  config = {
    nix.package = pkgs.nix;

    my.system = {
      host = {
        userName = "nimeses";
        hostName = "nimeses";
      };

      boot = {
        enable = true;
        loader.canTouchEfiVariables = true;
      };

      localization.enable = true;

      security.enable = true;

      shell.enable = true;

      networking = {
        enable = true;
        firewall = {
          enable = true;
          trustedInterfaces = ["tailscale0"];
        };
      };

      services = {
        bluetooth.enable = true;
        audio.enable = true;
        mysql.enable = false;
        tailscale.enable = true;
        power.enable = true;
        displayManager.enable = true;
        gnomeKeyring.enable = true;
        udisks.enable = true;
      };

      virtualisation = {
        enable = true;
        virtManager.enable = true;
        TPM.enable = true;
      };

      hyprland.enable = true;

      niri.enable = true;

      xdg.portal = {
        enable = true;
        terminal-filechooser.enable = true;
      };

      settings = {
        enable = true;
        nix-ld.enable = true;
        garbageCollector.enable = true;
      };

      performance = {
        enable = true;
        cpuGovernor = "schedutil"; # Balanced performance/battery
        swappiness = 10; # Reduce aggressive swapping (you have 30GB RAM)
      };
    };

    users.users.nimeses = {
      isNormalUser = true;
      description = "Nimeses";
      home = "/home/nimeses";
      extraGroups = ["networkmanager" "wheel"];
    };

    environment = {
      variables.QT_QPA_PLATFORMTHEME = "qt6ct";

      systemPackages = with pkgs; [
        ntfs3g
        git
        wget
      ];
    };

    system.stateVersion = "25.05";
  };
}
