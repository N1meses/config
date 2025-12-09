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
  ];
}
