{
  config,
  lib,
  ...
}: let
  cfg = config.my.system.security;
in {
  options.my.system.security = {
    enable = lib.mkEnableOption "Enable security settings";

    Rtkit.enable = lib.mkEnableOption "Enable RealtimeKit for audio priority";

    GnomeKeyring = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable GNOME Keyring integration with SDDM";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = cfg.Rtkit.enable;
    security.pam.services.sddm = {
      enableGnomeKeyring = cfg.GnomeKeyring.enable;
      unixAuth = lib.mkDefault true;
    };
  };
}
