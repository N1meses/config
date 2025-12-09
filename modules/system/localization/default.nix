{
  config,
  lib,
  ...
}: let
  cfg = config.my.system.localization;
in {
  options.my.system.localization = {
    enable = lib.mkEnableOption "Enable system localization settings (timezone and locale: default = Germany) .";

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Berlin";
      description = "The timezone for the system";
    };

    console.keyMap = lib.mkOption {
      type = lib.types.str;
      default = "de";
      description = "the layout of your keyboard";
    };

    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The default locale for the system.";
    };

    extraLocaleSettings = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
      description = "Extra locale settings for specific categories.";
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.timeZone;

    i18n = {
      inherit (cfg) defaultLocale extraLocaleSettings;
    };

    console.keyMap = cfg.console.keyMap;
  };
}
