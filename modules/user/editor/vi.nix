{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user.editor.vi;
in {
  options.my.user.editor.vi = {
    enable = lib.mkEnableOption "enbale and install the vi editor";
  };

  config = cfg.enable {
    home.packages = with pkgs;
      []
      ++ lib.optional cfg.enable vi;
  };
}
