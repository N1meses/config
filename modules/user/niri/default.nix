{pkgs, ...}:
let
  noctalia = cmd: [
    "noctalia-shell" "ipc" "call"
  ] ++ (pkgs.lib.splitString " " cmd);
in { 
  # -------------------------------------------------------------------
  # 1. Packages
  # -------------------------------------------------------------------

  home.packages = with pkgs; [
    xwayland-satellite
  ];

  systemd.user.services.libinput-gestures = {
    gestures = {
      "swipe left 3" = "niri msg action focus-column-left-or-last";
      "swipe right 3" = "niri msg action focus-column-right-or-first";
      "swipe up 3" = "niri msg action focus-column-prev";
      "swipe down 3" = "niri msg action focus-column-next";
    };
  };

  # -------------------------------------------------------------------
  # 2. Niri Settings
  # -------------------------------------------------------------------
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;

    settings = {
      animations.enable = true; 

      xwayland-satellite = {
        enable = true;
        path = "lib.getExe pkgs.xwayland-satellite";
      };

      environment = {
        _JAVA_AWT_WM_NONREPARENTING = "1";
        AWT_TOOLKIT = "MToolkit";
        NIXOS_OZONE_WL = "1"; 
        MOZ_ENABLE_WAYLAND = "1";
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland";
        DISPLAY = ":0";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER="wayland";
      };

      prefer-no-csd = true;
      
      spawn-at-startup = [
        { argv = [ "mako" ]; }
        { command = ["noctalia-shell"]; }
        { argv = [ "libinput-gestures-start" ]; }
        { sh = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"; }
        { sh = "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite"; }
      ];

      outputs = {
        "eDP-1" = {
          scale = 1.6;
          variable-refresh-rate = true;
          mode = {
            width = 2880;
            height = 1920;
            refresh = 120.0;
          };
        };
      };

      layout = {
        gaps = 8;
        border = {
          enable = true;
          width = 2;
          active.color = "#50C878";
        };  
        focus-ring.enable = false;
        shadow.enable = true;
        background-color = "rgba(107, 229, 91, 0)";
        center-focused-column = "never";
        default-column-display = "normal";
        default-column-width = { proportion = 1.0; };
      };

      layer-rules = [
        {
          matches = [ { namespace = "^noctalia-wallpaper.*"; } ];
          place-within-backdrop = true;
        }
        
      ];

      window-rules = [

        { 
          geometry-corner-radius = {
            top-left = 16.0;
            top-right = 16.0;
            bottom-left = 16.0;
            bottom-right = 16.0;
          };
          clip-to-geometry = true;

          draw-border-with-background = false;
        }

        { matches = [ { is-focused = false; } ];
          opacity = 0.9;
        }
        
        { matches = [ { is-focused = true; } ];
          opacity = 0.98;
        }
        
        { 
          matches = [ { app-id = "^com\.mitchellh\.ghostty$"; } ];
          default-column-width = { proportion = 0.5; };
        }

        { matches = [
            { app-id = "^com\.mitchellh\.ghostty$"; is-focused = true; }
          ];
          opacity = 0.95;
          default-column-width = { proportion = 0.55; };
        }

        { matches = [
            { app-id = "^com\.brave\.Browser$"; is-focused = true; }
            { app-id = "^brave-browser$"; is-focused = true; }
          ];
          opacity = 1.0;
        }
      ];

      overview.workspace-shadow.enable = false;

      input = {
        keyboard.xkb.layout = "de";
        focus-follows-mouse.enable = true;
        touchpad = {
          natural-scroll = true;
          dwt = true;
          tap = true;
          middle-emulation = true;
          scroll-factor = 1.0;
        };
      };
      
      cursor = {
        hide-when-typing = true;
        hide-after-inactive-ms = 3000;
      };

      binds = {
        
        "Mod+Return".action.spawn = [ "ghostty" ];
        "Mod+e".action.spawn = [ "ghostty" "-e" "yazi" ];
        "Mod+o".action.toggle-overview = [];

        # --- Window Management ---
        "Mod+q".action.close-window = [];
        "Mod+j".action.focus-window-down = [];
        "Mod+k".action.focus-window-up = [];
        "Mod+h".action.focus-column-left-or-last = [];
        "Mod+l".action.focus-column-right-or-first = [];

        "Mod+Shift+j".action.move-window-down = [];
        "Mod+Shift+k".action.move-window-up = [];
        "Mod+Shift+h".action.move-column-left-or-to-monitor-left = [];
        "Mod+Shift+l".action.move-column-right-or-to-monitor-right = [];

        # "Consume": Pull the window from the right into the current column (Stacking it)
        "Mod+Comma".action.consume-window-into-column = []; 

        # "Expel": Kick the focused window out of the stack into its own column
        "Mod+Period".action.expel-window-from-column = [];

        # --- Resizing ---
        "Mod+Control+l".action.set-column-width = "+10%";
        "Mod+Control+h".action.set-column-width = "-10%";
        "Mod+Control+k".action.set-window-height = "+10%";
        "Mod+Control+j".action.set-window-height = "-10%";

        # --- Fullscreen / Maximize ---
        "Mod+Space".action.maximize-column = [];
        "Mod+f".action.maximize-window-to-edges = [];
        "Mod+Escape".action.quit = [];

        # --- Noctalia Binds (Using your helper) ---
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
        "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
        "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
        "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";
        
        "Mod+s".action.spawn = noctalia "lockScreen lock";
        "Mod+m".action.spawn = noctalia "launcher toggle";
        "Mod+b".action.spawn = noctalia "bar toggle";

        # --- Screenshots ---
        # Full screen to clipboard
        "Print".action.spawn = [ "sh" "-c" "grim - | wl-copy" ];

        # Full screen to file
        "Shift+Print".action.spawn = [ "sh" "-c" "grim ~/pictures/screenshot-$(date +%Y%m%d-%H%M%S).png" ];

        # Select area to clipboard
        "Mod+Print".action.spawn = [ "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy" ];

        # Select area to file
        "Mod+Shift+Print".action.spawn = [ "sh" "-c" "grim -g \"$(slurp)\" ~/pictures/screenshot-$(date +%Y%m%d-%H%M%S).png" ];

        # Select area and annotate with swappy
        "Control+Print".action.spawn = [ "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -" ];

        # Switch to workspace
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        # Move active window to workspace
        "Mod+Shift+1".action.move-window-to-workspace = 1;
        "Mod+Shift+2".action.move-window-to-workspace = 2;
        "Mod+Shift+3".action.move-window-to-workspace = 3;
        "Mod+Shift+4".action.move-window-to-workspace = 4;
        "Mod+Shift+5".action.move-window-to-workspace = 5;
        "Mod+Shift+6".action.move-window-to-workspace = 6;
        "Mod+Shift+7".action.move-window-to-workspace = 7;
        "Mod+Shift+8".action.move-window-to-workspace = 8;
        "Mod+Shift+9".action.move-window-to-workspace = 9;
      };
    };
  };
}
