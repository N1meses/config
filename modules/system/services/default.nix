{config, lib, pkgs, ...}:
let 
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
    hardware.bluetooth = lib.mkIf config.my.system.services.bluetooth.enable {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    services = {
      blueman.enable = config.my.system.services.bluetooth.enable;

      pulseaudio.enable = false;
      pipewire = lib.mkIf config.my.system.services.audio.enable {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      mysql = lib.mkIf config.my.system.services.mysql.enable {
        enable = true;
        package = pkgs.mariadb;
      };

      tailscale.enable = config.my.system.services.tailscale.enable;

      power-profiles-daemon.enable = config.my.system.services.power.enable;

      upower.enable = config.my.system.services.power.enable;

      greetd = lib.mkIf config.my.system.services.displayManager.enable {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd Hyprland";
            user = "greeter";
          };
        };
      };

      gnome.gnome-keyring.enable = config.my.system.services.gnomeKeyring.enable;

      udisks2.enable = config.my.system.services.udisks.enable;

      xserver = lib.mkIf config.my.system.services.xserver.enable {
        enable = true;
        videoDrivers = [ "modesetting" ];
        xkb = {
          layout = "de";
          variant = "";
        };
      };
    };
  };
}
