{config, lib, pkgs, ...}:
let 
  msn = config.my.system.niri;
in {
  options.my.system.niri = {
    enable = lib.mkEnableOption "enable the niri window manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.niri-unstable;
      description = "which packages and version of niri to use";
    };
  };

  config = lib.mkIf msn.enable {
    programs.niri = {
      enable = msn.enable;
      package = msn.package;
    };
  };
}
