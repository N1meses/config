{
  config,
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.my.user.hyprland;

  # --- Workspace Bindings (1-9) ---
  workspace_binds = [
    "SUPER,1,workspace,1"
    "SUPER,2,workspace,2"
    "SUPER,3,workspace,3"
    "SUPER,4,workspace,4"
    "SUPER,5,workspace,5"
    "SUPER,6,workspace,6"
    "SUPER,7,workspace,7"
    "SUPER,8,workspace,8"
    "SUPER,9,workspace,9"

    "SUPERSHIFT,1,movetoworkspace,1"
    "SUPERSHIFT,2,movetoworkspace,2"
    "SUPERSHIFT,3,movetoworkspace,3"
    "SUPERSHIFT,4,movetoworkspace,4"
    "SUPERSHIFT,5,movetoworkspace,5"
    "SUPERSHIFT,6,movetoworkspace,6"
    "SUPERSHIFT,7,movetoworkspace,7"
    "SUPERSHIFT,8,movetoworkspace,8"
    "SUPERSHIFT,9,movetoworkspace,9"
  ];

  # --- Window Management (Vim-style HJKL, matching Niri) ---
  window_binds = [
    "SUPER,Q,killactive"
    "SUPER,F,fullscreen,0" # Maximize window (like Niri's maximize-window-to-edges)
    "SUPER,Space,fullscreen,1" # Fullscreen (like Niri's maximize-column)
    "SUPER,ESC,exit"

    # Focus (matching Niri)
    "SUPER,H,movefocus,l"
    "SUPER,J,movefocus,d"
    "SUPER,K,movefocus,u"
    "SUPER,L,movefocus,r"

    # Move (matching Niri)
    "SUPERSHIFT,H,movewindow,l"
    "SUPERSHIFT,J,movewindow,d"
    "SUPERSHIFT,K,movewindow,u"
    "SUPERSHIFT,L,movewindow,r"

    # Resize (matching Niri's percentage-based resizing)
    "SUPERCTRL,H,resizeactive,-10% 0"
    "SUPERCTRL,L,resizeactive,10% 0"
    "SUPERCTRL,K,resizeactive,0 -10%"
    "SUPERCTRL,J,resizeactive,0 10%"
  ];

  # --- App Launching ---
  launching_binds = [
    "SUPER,Return,exec, ghostty" # Updated to Ghostty
    "SUPER,E,exec, ghostty -e yazi" # Updated to Nautilus (per Niri config)
  ];

  # --- Noctalia Integration ---
  noctalia_binds = [
    ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
    ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
    ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
    ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
    ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"

    "SUPER, S, exec, noctalia-shell ipc call lockScreen lock"
    "SUPER, M, exec, noctalia-shell ipc call launcher toggle"
    "SUPER, B, exec, noctalia-shell ipc call bar toggle"
  ];
in {
  options.my.user.hyprland = {
    monitor = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Monitor configuration in hyprland format";
      example = [
        "eDP-1,2880x1920@120,0x0,1.6"
        "HDMI-A-1,1920x1080@60,2880x0,1.0"
      ];
    };

    keybinds = {
      mod = lib.mkOption {
        type = lib.types.str;
        default = "SUPER";
        description = "which key modifies windows";
      };
    };

    settings = {
      layout = lib.mkOption {
        type = lib.types.enum ["dwindle" "master"];
        default = "dwindle";
        description = "which window layout to use";
      };

      gapSize = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "size of gaps for windows";
      };

      borderSize = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "size of border";
      };
    };
  };

  config = lib.mkIf osConfig.my.system.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

      settings = {
        monitor = cfg.monitor;

        env = [
          "NIXOS_OZONE_WL,1"
          "MOZ_ENABLE_WAYLAND,1"
          "GDK_BACKEND,wayland,x11"
          "QT_QPA_PLATFORM,wayland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "SDL_VIDEODRIVER,wayland"
          "_JAVA_AWT_WM_NONREPARENTING,1"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        ];

        # --- Startup ---
        exec-once = [
          "noctalia-shell"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        ];

        general = {
          layout = cfg.settings.layout;
          gaps_in = cfg.settings.gapSize;
          gaps_out = cfg.settings.gapSize * 2;
          border_size = cfg.settings.borderSize;

          # Emerald Green (Active) / Grey (Inactive)
          "col.active_border" = "rgb(50C878)";
          "col.inactive_border" = "rgb(595959)";

          resize_on_border = true;
        };

        gesture = "3, horizontal, workspace";

        decoration = {
          rounding = 16;

          # Opacity managed via windowrule for dynamic control (matching Niri)
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 8;
            render_power = 2;
          };
        };

        # --- Animations ---
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        # --- Input ---
        input = {
          kb_layout = "de";
          follow_mouse = 1; # Focus follows mouse

          touchpad = {
            natural_scroll = true; #
            disable_while_typing = true;
            clickfinger_behavior = true;
            scroll_factor = 1.0; # Adjust if sticky
          };
        };

        # --- Cursor (Matching Niri) ---
        cursor = {
          hide_on_touch = true;
          inactive_timeout = 3; # Hide after 3 seconds like Niri
        };

        debug = {
          disable_logs = false;
        };

        misc = {
          disable_hyprland_logo = true;
          focus_on_activate = true;
          disable_hyprland_guiutils_check = true;
        };

        # --- Window & Layer Rules ---
        windowrule = [
          # Dynamic opacity rules (matching Niri behavior)
          # Format: "opacity [focused] [unfocused]"

          # Default for all windows: 0.98 focused, 0.90 unfocused
          "opacity 0.98 0.90"

          # Brave: always 1.0 (both focused and unfocused)
          "opacity 1.0 0.9, match:class ^com\\.brave\\.Browser$"
          "opacity 1.0 0.9, match:class ^brave-browser$"

          # Ghostty: 0.95 focused, 0.90 unfocused (matching Niri)
          "opacity 0.95 0.90, match:class ^com\\.mitchellh\\.ghostty$"
        ];

        # --- Keybind List ---
        bind =
          []
          ++ window_binds
          ++ workspace_binds
          ++ launching_binds
          ++ noctalia_binds;
      };
    };
  };
}
