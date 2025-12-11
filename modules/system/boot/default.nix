{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.my.system.boot;
in {
  options.my.system.boot = {
    enable = lib.mkEnableOption "Enable custom bootloader";

    kernelPackages = lib.mkOption {
      type = lib.types.raw;
      default = pkgs.linuxPackages_latest;
      description = "The kernel package set to use.";
    };

    plymouth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Plymouth splash screen.";
    };

    loader = lib.mkOption {
      type = lib.types.submodule {
        options = {
          systemd-boot = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Enable systemd";
                };

                editor = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable systemd boot editor";
                };

                configurationLimit = lib.mkOption {
                  type = lib.types.int;
                  default = 10;
                  description = "How many configurations are available in the efi";
                };
              };
            };
            default = {};
          };

          canTouchEfiVariables = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
            description = "Allow new generation entries in the efi";
          };
        };
      };
      default = {};
    };

    supportedFilesystems = lib.mkOption {
      type = with lib.types; listOf str;
      default = ["ntfs3"];
      description = "List of additionally supported filesystems.";
    };

    luks = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable LUKS encryption support in initrd";
          };

          devices = lib.mkOption {
            type = with lib.types; attrsOf (submodule {
              options = {
                device = lib.mkOption {
                  type = str;
                  description = "Path to the encrypted device (e.g., /dev/disk/by-uuid/...)";
                };

                keyFile = lib.mkOption {
                  type = nullOr str;
                  default = null;
                  description = "Path to key file for automatic unlocking (stored on /boot)";
                };

                keyFileSize = lib.mkOption {
                  type = nullOr int;
                  default = null;
                  description = "Size of the key file in bytes";
                };

                allowDiscards = lib.mkOption {
                  type = bool;
                  default = false;
                  description = "Enable TRIM/discard support for SSDs";
                };
              };
            });
            default = {};
            description = "LUKS encrypted devices configuration";
          };
        };
      };
      default = {};
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable -> cfg.loader.canTouchEfiVariables != null;
          message = ''
            You must explicitly set my.system.boot.loader.canTouchEfiVariables.
            Setting this to true allows the bootloader to modify EFI firmware variables.
            This is required for most UEFI systems but can be dangerous if misconfigured.
          '';
        }
      ];
    }

    (lib.mkIf cfg.enable {
      boot = {
        inherit (cfg) kernelPackages supportedFilesystems;

        plymouth.enable = cfg.plymouth;

        loader = {
          grub.enable = lib.mkForce false;
          systemd-boot = {
            enable = lib.mkForce cfg.loader.systemd-boot.enable;
            inherit (cfg.loader.systemd-boot) editor configurationLimit;
          };
          efi = {
            canTouchEfiVariables = cfg.loader.canTouchEfiVariables;
          };
        };
        # Assuming initrd.systemd.enable and initrd.verbose are desired defaults if boot.enable
        initrd.systemd.enable = true;
        initrd.verbose = false;
      };
    })

    (lib.mkIf (cfg.enable && cfg.luks.enable) {
      boot.initrd.luks.devices = lib.mapAttrs (name: luksOpts: {
        device = luksOpts.device;
        keyFile = lib.mkIf (luksOpts.keyFile != null) luksOpts.keyFile;
        keyFileSize = lib.mkIf (luksOpts.keyFileSize != null) luksOpts.keyFileSize;
        allowDiscards = luksOpts.allowDiscards;
      }) cfg.luks.devices;
    })
  ];
}
