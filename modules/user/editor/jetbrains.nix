{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user.editor.jetbrains;
in {
  options.my.user.editor.jetbrains = {
    enable = lib.mkEnableOption "Enable the option for Jetbrains IDE's";

    pycharm.enable = lib.mkEnableOption "Enable and install Pycharm";

    intellij.enable = lib.mkEnableOption "Enable and install Intellij";

    datagrip.enable = lib.mkEnableOption "Enable and install Datagrip";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      []
      ++ lib.optional cfg.pycharm.enable jetbrains.pycharm-professional
      ++ lib.optional cfg.intellij.enable jetbrains.idea-ultimate
      ++ lib.optional cfg.datagrip.enable jetbrains.datagrip;
  };
}
