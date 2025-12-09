{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user.dotfiles;
in {
  imports = [
    ./gtk.nix
    ./yazi.nix
    ./nh.nix
    ./fastfetch.nix
    ./starship.nix
    ./ghostty.nix
  ];
}
