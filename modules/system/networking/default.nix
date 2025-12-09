{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.system.networking;
in {
  options.my.system.networking = {
    enable = lib.mkEnableOption "Enable custom Network Settings";

    networkManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable NetworkManager";
      };
    };

    firewall = {
      enable = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = "Enable Firewall";
      };

      trustedInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Trusted network Interfaces";
      };
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable -> cfg.firewall.enable != null;
          message = ''
            You must explicitly set my.system.networking.firewall.enable.
            This controls whether the system firewall is active - a critical security
            setting.
          '';
        }
      ];
    }

    (lib.mkIf config.my.system.networking.enable {
      networking = {
        hostName = config.my.system.host.hostName;
        networkmanager.enable = cfg.networkManager.enable;
        firewall = {
          enable = cfg.firewall.enable;
          trustedInterfaces = cfg.firewall.trustedInterfaces;
        };
      };
      environment.systemPackages = with pkgs;
        []
        ++ lib.optional cfg.networkManager.enable networkmanager;
    })
  ];
}
