{pkgs, ...}:
{
  nix = {
    
    package = pkgs.nix;

    settings = {

      experimental-features = ["nix-command" "flakes"];

      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
      trusted-users = [ "@wheel" "root" "nimeses"];
      auto-optimise-store = true;
      download-buffer-size = 500000000;
      http-connections = 50;
      max-substitution-jobs = 16;
    };
  };

  programs.nix-ld = {
    enable = true;

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
}