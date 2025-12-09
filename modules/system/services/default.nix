{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.system.services;
in {
  options.my.system.services = {
    bluetooth.enable = lib.mkEnableOption "Bluetooth support";

    audio.enable = lib.mkEnableOption "PipeWire audio system";

    mysql.enable = lib.mkEnableOption "MySQL/MariaDB database";

    tailscale.enable = lib.mkEnableOption "Tailscale VPN";

    power.enable = lib.mkEnableOption "power management services";

    displayManager.enable = lib.mkEnableOption "greetd display Manager with tuigreet";

    gnomeKeyring.enable = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "enable gnome keyring for credential storage";
    };

    udisks.enable = lib.mkEnableOption "disk management services";

    xserver.enable = lib.mkEnableOption "Xserver for compatibility";
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.gnomeKeyring.enable != null;
          message = ''
            You have to explicitly set Gnome Keyring for Credential Storage
            set it per: my.system.services.gnomeKeyring = true | false
          '';
        }
      ];
    }
    {
      hardware.bluetooth = lib.mkIf cfg.bluetooth.enable {
        enable = true;
        powerOnBoot = true;
        settings.General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };

      environment.systemPackages = with pkgs;
        []
        ++ lib.optional cfg.tailscale.enable tailscale
        ++ lib.optional cfg.audio.enable pipewire;

      services = {
        blueman.enable = cfg.bluetooth.enable;

        pulseaudio.enable = false;

        pipewire = lib.mkIf cfg.audio.enable {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
        };

        mysql = lib.mkIf cfg.mysql.enable {
          enable = true;
          package = pkgs.mariadb;
        };

        tailscale.enable = cfg.tailscale.enable;

        power-profiles-daemon.enable = cfg.power.enable;

        upower.enable = cfg.power.enable;

        greetd = lib.mkIf cfg.displayManager.enable {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd Hyprland";
              user = "greeter";
            };
          };
        };

        gnome.gnome-keyring.enable = cfg.gnomeKeyring.enable;

        udisks2.enable = cfg.udisks.enable;

        xserver = lib.mkIf cfg.xserver.enable {
          enable = true;
          videoDrivers = ["modesetting"];
          xkb = {
            layout = "de";
            variant = "";
          };
        };
      };
    }
  ];
}
