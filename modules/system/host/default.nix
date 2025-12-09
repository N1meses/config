{
  config,
  lib,
  ...
}: let
  cfg = config.my.system.host;
in {
  options.my.system.host = {
    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "which user this is for";
    };

    hostName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Hostname of this machine";
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.userName != null;
        message = "you must set my.system.host.userName";
      }
      {
        assertion = cfg.hostName != null;
        message = "you must set my.system.host.hostName";
      }
    ];
  };
}
