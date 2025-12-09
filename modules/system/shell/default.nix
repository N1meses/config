{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.system.shell;
  userName = config.my.system.host.userName;

  shellPackage =
    if (cfg.defaultShell == "zsh")
    then pkgs.zsh
    else pkgs.bashInteractive;
in {
  options.my.system.shell = {
    enable = lib.mkEnableOption "Enable system-level shell configuration";

    defaultShell = lib.mkOption {
      type = lib.types.enum ["bash" "zsh"];
      default = "zsh";
      description = "Default shell for the user";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${userName}.shell = shellPackage;

    environment.shells = [shellPackage];

    programs.zsh.enable = lib.mkIf (cfg.defaultShell == "zsh") true;

    programs.bash = lib.mkIf (cfg.defaultShell == "bash") {
      enable = true;
      enableCompletion = true;
    };
  };
}
