{lib, ...}:
{
  options.my.system.host = {
    userName = lib.mkOption {
      type = lib.types.str;
      description = "which user this is for";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of this machine";
    };
  };
}
