{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.system.performance;
in {
  options.my.system.performance = {
    enable = lib.mkEnableOption "performance optimizations";

    cpuGovernor = lib.mkOption {
      type = lib.types.enum ["performance" "powersave" "ondemand" "schedutil"];
      default = "schedutil";
      description = ''
        CPU frequency scaling governor:
        - performance: Maximum performance, higher power usage
        - powersave: Battery saving, lower performance
        - schedutil: Balanced, adapts to load (recommended)
        - ondemand: Similar to schedutil but older
      '';
    };

    swappiness = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = ''
        Swappiness value (0-100). Lower = less aggressive swapping.
        Recommended: 10 for systems with 8GB+ RAM
      '';
    };

    enableZramSwap = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable compressed RAM swap (faster than disk swap)";
    };
  };

  config = lib.mkIf cfg.enable {
    # CPU frequency scaling
    powerManagement.cpuFreqGovernor = cfg.cpuGovernor;

    # Memory management
    boot.kernel.sysctl = {
      # Reduce swappiness for better performance with sufficient RAM
      "vm.swappiness" = cfg.swappiness;

      # Improve I/O performance
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;

      # Network performance
      "net.core.netdev_max_backlog" = 16384;
      "net.core.somaxconn" = 8192;
      "net.core.rmem_default" = 1048576;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_default" = 1048576;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.tcp_fastopen" = 3;

      # File system performance
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
    };

    # Optional: zram swap for faster compressed swap
    zramSwap = lib.mkIf cfg.enableZramSwap {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    # Nix daemon performance
    nix.daemonCPUSchedPolicy = "batch";
    nix.daemonIOSchedClass = "idle";
    nix.daemonIOSchedPriority = 7;
  };
}
