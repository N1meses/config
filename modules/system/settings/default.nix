{config, lib, pkgs,...}:
let 
  mss = config.my.system.settings;
in{
  options.my.system.settings = {

    enable = lib.mkEnableOption "Enable custom settings like downloading from caches and other things";

    experimental-features = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["nix-command" "flakes"];
      description = "list of experimental features to enable";
    };

    nix-ld.enable = lib.mkEnableOption "Enable nix-ld";

    garbageCollector = {
      enable = lib.mkEnableOption "Enable automatic garbage collection";
      
      dates = lib.mkOption {
        type = lib.types.str;
        default = "daily";
        description = "how often to grabage collect";
      };
    };

    trusted-users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["@wheel" "root"];
      description = "List of names with additional rights";
    };

    auto-optimise-store = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "detects duplicates and makes hardlinks if set to true";
    };

    download-buffer-size = lib.mkOption {
      type = lib.types.int;
      default = 524288000;
      description = "size of the downlaod buffer";
    };

    http-connections = lib.mkOption {
      type = lib.types.int;
      default = 50;
      description = "how many http-connections can be utilised";
    };

    max-substitution-jobs = lib.mkOption {
      type = lib.types.int;
      default = 16;
      description = "how many substitution jobs are available";
    }; 
  };

  config = lib.mkIf mss.enable {
    nix.settings = {
      experimental-features = mss.experimental-features;

      trusted-users = mss.trusted-users ++ [config.my.system.host.userName];

      auto-optimise-store = mss.auto-optimise-store;

      download-buffer-size = mss.download-buffer-size;

      http-connections = mss.http-connections;

      max-substitution-jobs = mss.max-substitution-jobs;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ] ++ lib.optional config.my.system.niri.enable "https://niri.cachix.org"
        ++ lib.optional config.my.system.hyprland.enable "https://hyprland.cachix.org";


      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ] ++ lib.optional config.my.system.niri.enable "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        ++ lib.optional config.my.system.hyprland.enable "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";     
    };

    nix.gc = lib.mkIf mss.garbageCollector.enable {
      automatic = mss.garbageCollector.enable;
      dates = mss.garbageCollector.dates;
      options = "--delete-older-than 7d";
    };

    programs.nix-ld = {
      enable = mss.nix-ld.enable;


      libraries = with pkgs;[
        curl
        stdenv.cc.cc
        zlib
        fuse3
        icu
        nss
        openssl 
        expat 
        xorg.libX11
        vulkan-headers 
        vulkan-loader
        vulkan-tools
      ];
    };
  };
}
