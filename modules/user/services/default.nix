{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user.services;
in {
  options.my.user.services = {
    enable = lib.mkEnableOption "Enable user services";

    gnomeKeyring.enable = lib.mkEnableOption "GNOME Keyring";

    clipboard.wl-clip-persist.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Wayland clipboard persistence";
    };

    security = {
      gpg-agent = {
        enable = lib.mkEnableOption "GPG agent for key management";
        enableSshSupport = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use GPG agent for SSH keys";
        };
      };

      ssh-agent.enable = lib.mkEnableOption "SSH agent (disable if using GPG agent for SSH)";
    };

    storage.udiskie = {
      enable = lib.mkEnableOption "auto-mount removable drives";
      notify = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show notifications for mount/unmount";
      };
      automount = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically mount new devices";
      };
    };

    development.direnv = {
      enable = lib.mkEnableOption "directory-based environment management";
      nix-direnv.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable nix-direnv integration for better Nix shell caching";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      []
      ++ lib.optional cfg.clipboard.wl-clip-persist.enable wl-clipboard;

    services = {
      gnome-keyring.enable = cfg.gnomeKeyring.enable;

      wl-clip-persist.enable = cfg.clipboard.wl-clip-persist.enable;

      # GPG Agent
      gpg-agent = lib.mkIf cfg.security.gpg-agent.enable {
        enable = true;
        enableSshSupport = cfg.security.gpg-agent.enableSshSupport;
        pinentry.package = lib.mkDefault pkgs.pinentry-gnome3;
      };

      # SSH Agent (only if not using GPG for SSH)
      ssh-agent.enable = cfg.security.ssh-agent.enable;

      # Udiskie (automount)
      udiskie = lib.mkIf cfg.storage.udiskie.enable {
        enable = true;
        notify = cfg.storage.udiskie.notify;
        automount = cfg.storage.udiskie.automount;
        tray = "never";
      };
    };

    programs.direnv = lib.mkIf cfg.development.direnv.enable {
      enable = true;
      nix-direnv.enable = cfg.development.direnv.nix-direnv.enable;
    };
  };
}
