{config, lib, ...}:
{
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

  config = lib.mkIf config.my.system.security.enable {
    security.rtkit.enable = config.my.system.security.Rtkit.enable;
    security.pam.services.sddm = {
      enableGnomeKeyring = config.my.system.security.GnomeKeyring.enable;
      # Ensure SDDM can authenticate with yescrypt password hashes
      unixAuth = lib.mkDefault true;
    };
  };
}
