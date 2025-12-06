{
  config,
  lib,
  pkgs,
  ...
}: let
  mys = config.my.system.networking;
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
        type = lib.types.bool;
        default = true;
        description = "Enable Firewall";
      };

      trustedInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Trusted network Interfaces";
      };
    };
  };

  config = lib.mkIf config.my.system.networking.enable {
    networking = {
      hostName = config.my.system.host.hostName;
      networkmanager.enable = mys.networkManager.enable;
      firewall = {
        enable = mys.firewall.enable;
        trustedInterfaces = mys.firewall.trustedInterfaces;
      };
    };
    environment.systemPackages = with pkgs;
      []
      ++ lib.optional mys.networkManager.enable networkmanager;
  };
}
