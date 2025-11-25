{pkgs, ...}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services = {
    blueman.enable = true;

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;  # Session manager for PipeWire, needed for screencasting
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    tailscale.enable = true;

    power-profiles-daemon.enable =true;

    upower.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
    };

    gnome.gnome-keyring.enable = true;

    udisks2.enable = true;

    xserver = {
      enable = true;

      videoDrivers = [ "modesetting" ];

      xkb = {
        # Configure keymap in X11
        layout = "de";
        variant = "";
      };
    };
  };
}