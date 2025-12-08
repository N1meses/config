{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user.browser;
  browserApp =
    if (cfg.defaultBrowser == "chromium")
    then "chromium-browser.desktop"
    else if (cfg.defaultBrowser == "firefox")
    then "firefox.desktop"
    else "brave-browser.desktop";
in {
  options.my.user.browser = {
    enable = lib.mkEnableOption "Enable custom browser config";

    defaultBrowser = lib.mkOption {
      type = lib.types.enum ["brave" "firefox" "chromium"];
      default = "brave";
      description = "which browser to use by default";
    };

    brave.enable = lib.mkEnableOption "enable brave browser";

    firefox.enable = lib.mkEnableOption "enable firefox browser";

    chromium.enable = lib.mkEnableOption "enable chromium browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      []
      ++ lib.optional ((cfg.defaultBrowser == "brave") || cfg.brave.enable) brave
      ++ lib.optional ((cfg.defaultBrowser == "firefox") || cfg.firefox.enable) firefox
      ++ lib.optional ((cfg.defaultBrowser == "chromium") || cfg.chromium.enable) chromium;

    xdg = {
      mimeApps = {
        enable = true;

        defaultApplications = {
          "text/html" = [browserApp];
          "x-scheme-handler/http" = [browserApp];
          "x-scheme-handler/https" = [browserApp];
          "x-scheme-handler/about" = [browserApp];
          "x-scheme-handler/unknown" = [browserApp];
        };

        associations.added = {
          "text/html" = [browserApp];
        };
      };
    };
  };
}
