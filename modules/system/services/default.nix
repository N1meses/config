{
  config,
  lib,
  pkgs,
  ...
}: let
  mss = config.my.system.services;
in {
  options.my.system.services = {
    enable = lib.mkEnableOption "Enable system services";

    bluetooth.enable = lib.mkEnableOption "Bluetooth support";

    audio.enable = lib.mkEnableOption "PipeWire audio system";

    mysql.enable = lib.mkEnableOption "MySQL/MariaDB database";

    tailscale.enable = lib.mkEnableOption "Tailscale VPN";

    power.enable = lib.mkEnableOption "power managment services";

    displayManager.enable = lib.mkEnableOption "greetd display Manager with tuigreet";

    gnomeKeyring.enable = lib.mkEnableOption "GNOME Keyring";

    udisks.enable = lib.mkEnableOption "disk managment services";

    xserver.enable = lib.mkEnableOption "Xserver for compatibility";
  };

  config = lib.mkIf mss.enable {
    hardware.bluetooth = lib.mkIf config.mss.bluetooth.enable {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    environment.systemPackages = with pkgs;
      []
      ++ lib.optional mss.tailscale.enable tailscale
      ++ lib.optional mss.audio.enable pipewire;

    services = {
      blueman.enable = config.mss.bluetooth.enable;

      pulseaudio.enable = false;

      pipewire = lib.mkIf config.mss.audio.enable {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      mysql = lib.mkIf config.mss.mysql.enable {
        enable = true;
        package = pkgs.mariadb;
      };

      tailscale.enable = config.mss.tailscale.enable;

      power-profiles-daemon.enable = config.mss.power.enable;

      upower.enable = config.mss.power.enable;

      greetd = lib.mkIf config.mss.displayManager.enable {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd Hyprland";
            user = "greeter";
          };
        };
      };

      gnome.gnome-keyring.enable = config.mss.gnomeKeyring.enable;

      udisks2.enable = config.mss.udisks.enable;

      xserver = lib.mkIf config.mss.xserver.enable {
        enable = true;
        videoDrivers = ["modesetting"];
        xkb = {
          layout = "de";
          variant = "";
        };
      };
    };
  };
}
