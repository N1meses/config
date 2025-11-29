{pkgs, config, lib, ...}:
{
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
            type = lib.types.bool;
            default = true;
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

  config = lib.mkIf config.my.system.boot.enable {
    boot = {
      inherit (config.my.system.boot) kernelPackages supportedFilesystems;

      plymouth.enable = config.my.system.boot.plymouth;

      loader = {
        grub.enable = lib.mkForce false;
        systemd-boot = {
          enable = lib.mkForce config.my.system.boot.loader.systemd-boot.enable;
          inherit (config.my.system.boot.loader.systemd-boot) editor configurationLimit;
        };
        efi = {
          canTouchEfiVariables = config.my.system.boot.loader.canTouchEfiVariables;
        };
      };
      # Assuming initrd.systemd.enable and initrd.verbose are desired defaults if boot.enable
      initrd.systemd.enable = true;
      initrd.verbose = false;
    };
  };
}

# {
#   boot = {

#     kernelPackages = pkgs.linuxPackages_latest;
    
#     loader = {
#       systemd-boot.enable = true;
#       systemd-boot.editor = false;
#       systemd-boot.configurationLimit = 10;

#       efi.canTouchEfiVariables = true;
#     };

#     supportedFilesystems = [ "ntfs" ];
    
#     initrd.systemd.enable = true;

#     initrd.verbose = false;

#     plymouth.enable = true;
#   };
# }
  
