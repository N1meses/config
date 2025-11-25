{pkgs, ... }:

{
  stylix = {
    enable = true;

    base16Scheme = ../themes/nord.yaml;

    fonts = {
      serif = { package = pkgs.ibm-plex; name = "IBM Plex Serif"; };
      sansSerif = { package = pkgs.ibm-plex; name = "IBM Plex Sans"; };
      monospace = { package = pkgs.ibm-plex; name = "IBM Plex Mono"; };
      sizes = { applications = 10; terminal = 11; desktop = 10; };
    };

    cursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors-white";
      size = 24;
    };
  };

}  