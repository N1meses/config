{config, lib, pkgs, ...}:
let
  mss = config.my.system.shell;
  userName = config.my.system.host.userName;

  shellPackage = if (mss.defaultShell == "zsh") then pkgs.zsh else pkgs.bashInteractive;
in {
  options.my.system.shell = {
    enable = lib.mkEnableOption "Enable system-level shell configuration";

    defaultShell = lib.mkOption {
      type = lib.types.enum ["bash" "zsh"];
      default = "zsh";
      description = "Default shell for the user";
    };
  };

  config = lib.mkIf mss.enable {
    # Set the user's default shell
    users.users.${userName}.shell = shellPackage;

    # Ensure the shell package is available system-wide
    environment.shells = [ shellPackage ];

    # Enable the shell program system-wide
    programs.zsh.enable = lib.mkIf (mss.defaultShell == "zsh") true;
    programs.bash.enableCompletion = lib.mkIf (mss.defaultShell == "bash") true;
  };
}
