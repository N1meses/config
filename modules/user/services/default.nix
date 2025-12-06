{
  config,
  lib,
  pkgs,
  ...
}: let
  mus = config.my.user.services;
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

  config = lib.mkIf mus.enable {
    home.packages = with pkgs;
      []
      ++ lib.optional mus.clipboard.wl-clip-persist.enable wl-clipboard;

    services = {
      gnome-keyring.enable = mus.gnomeKeyring.enable;

      wl-clip-persist.enable = mus.clipboard.wl-clip-persist.enable;

      # GPG Agent
      gpg-agent = lib.mkIf mus.security.gpg-agent.enable {
        enable = true;
        enableSshSupport = mus.security.gpg-agent.enableSshSupport;
        pinentry.package = lib.mkDefault pkgs.pinentry-gnome3;
      };

      # SSH Agent (only if not using GPG for SSH)
      ssh-agent.enable = mus.security.ssh-agent.enable;

      # Udiskie (automount)
      udiskie = lib.mkIf mus.storage.udiskie.enable {
        enable = true;
        notify = mus.storage.udiskie.notify;
        automount = mus.storage.udiskie.automount;
        tray = "never";
      };
    };

    programs.direnv = lib.mkIf mus.development.direnv.enable {
      enable = true;
      nix-direnv.enable = mus.development.direnv.nix-direnv.enable;
    };
  };
}
