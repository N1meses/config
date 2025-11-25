# let
#   matugenConfigPath = "quickshell/noctalia-shell/matugen/config.toml";
#   gtkTemplatePath   = "${config.xdg.configHome}/quickshell/noctalia-shell/matugen/gtk-template.css";
#   ghosttyTemplatePath = "${config.xdg.configHome}/quickshell/noctalia-shell/matugen/ghostty-template";
# in



  # # 1. WATCHER
  # systemd.user.paths.watch-ghostty-theme = {
  #   Unit.Description = "Watch for Ghostty theme changes";
  #   Install.WantedBy = [ "default.target" ];
  #   Path = {
  #     PathChanged = "%h/.config/ghostty/themes/noctalia";
  #     Unit = "sync-look.service";
  #   };
  # };

  # # 2. SYNC SERVICE
  # systemd.user.services.sync-look = {
  #   Unit.Description = "Sync GTK theme from Ghostty color";
  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = let
  #       # Paths
  #       ghosttyTheme = "${config.xdg.configHome}/ghostty/themes/noctalia";
  #       matugenConfig = "${config.xdg.configHome}/quickshell/noctalia-shell/matugen/config.toml";
  #       schemaDir = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
        
  #       script = pkgs.writeShellScript "sync-look" ''
  #         # 1. Extract Color (Anchor to start of line ^)
  #         HEX_COLOR=$(grep "^background =" "${ghosttyTheme}" | head -n 1 | cut -d'=' -f2 | tr -d ' ')
          
  #         if [ -z "$HEX_COLOR" ]; then exit 1; fi
          
  #         # 2. Run Matugen (With 'hex' keyword)
  #         ${pkgs.matugen}/bin/matugen color hex "$HEX_COLOR" --config "${matugenConfig}"

  #         # 3. Refresh GTK
  #         export GSETTINGS_SCHEMA_DIR="${schemaDir}"
  #         ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'HighContrast'
  #         sleep 0.2
  #         ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
  #       '';
  #     in "${script}";
  #   };
  # };

  # xdg.configFile."${matugenConfigPath}".text = ''
  #   [config]
  #   reload_on_change = true

  #   # --- GTK 4 / Libadwaita ---
  #   [templates.gtk4]
  #   input_path = "${gtkTemplatePath}"
  #   output_path = "${config.xdg.configHome}/gtk-4.0/colors.css"

  #   # --- GTK 3 ---
  #   [templates.gtk3]
  #   input_path = "${gtkTemplatePath}"
  #   output_path = "${config.xdg.configHome}/gtk-3.0/colors.css"

  #   # --- Keep Ghostty Working (Re-add this!) ---
  #   [templates.ghostty]
  #   input_path = "${ghosttyTemplatePath}" 
  #   output_path = "${config.xdg.configHome}/ghostty/themes/noctalia"
  # '';

  # xdg.configFile."quickshell/noctalia-shell/matugen/gtk-template.css".text = ''
  #   /* Main Accent Colors */
  #   @define-color accent_color {{colors.primary.default.hex}};
  #   @define-color accent_bg_color {{colors.primary.default.hex}};
  #   @define-color accent_fg_color {{colors.on_primary.default.hex}};

  #   /* Window & View Backgrounds */
  #   @define-color window_bg_color {{colors.surface.default.hex}};
  #   @define-color window_fg_color {{colors.on_surface.default.hex}};
  #   @define-color view_bg_color {{colors.surface.default.hex}};
  #   @define-color view_fg_color {{colors.on_surface.default.hex}};

  #   /* Header Bars */
  #   @define-color headerbar_bg_color {{colors.surface.default.hex}};
  #   @define-color headerbar_fg_color {{colors.on_surface.default.hex}};
  #   @define-color headerbar_border_color {{colors.outline.default.hex}};
  #   @define-color headerbar_backdrop_color @window_bg_color;
  #   @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);

  #   /* Cards & Popovers */
  #   @define-color card_bg_color {{colors.surface_container_lowest.default.hex}};
  #   @define-color card_fg_color {{colors.on_surface.default.hex}};
  #   @define-color card_shade_color rgba(0, 0, 0, 0.07);
  #   @define-color popover_bg_color {{colors.surface_container_lowest.default.hex}};
  #   @define-color popover_fg_color {{colors.on_surface.default.hex}};
  #   @define-color dialog_bg_color {{colors.surface_container.default.hex}};
  #   @define-color dialog_fg_color {{colors.on_surface.default.hex}};

  #   /* Sidebars */
  #   @define-color sidebar_bg_color {{colors.surface_container_low.default.hex}};
  #   @define-color sidebar_fg_color {{colors.on_surface.default.hex}};
  #   @define-color secondary_sidebar_bg_color {{colors.surface_container_lowest.default.hex}};

  #   /* Misc */
  #   @define-color thumbnail_bg_color {{colors.surface_container_highest.default.hex}};
  #   @define-color shade_color rgba(0,0,0,0.07);
  #   @define-color scrollbar_outline_color {{colors.outline.default.hex}};
  # '';

  # xdg.configFile."quickshell/noctalia-shell/matugen/ghostty-template".text = ''
  #   background = {{colors.surface.default.hex}}
  #   foreground = {{colors.on_surface.default.hex}}
  #   cursor-color = {{colors.on_surface.default.hex}}
  #   selection-background = {{colors.primary.default.hex}}
  #   selection-foreground = {{colors.on_primary.default.hex}}
    
  #   # Normal Colors
  #   palette = 0={{colors.surface_container.default.hex}}
  #   palette = 1={{colors.error.default.hex}}
  #   palette = 2={{colors.primary.default.hex}}
  #   palette = 3={{colors.tertiary.default.hex}}
  #   palette = 4={{colors.primary.default.hex}}
  #   palette = 5={{colors.secondary.default.hex}}
  #   palette = 6={{colors.tertiary.default.hex}}
  #   palette = 7={{colors.on_surface.default.hex}}
    
  #   # Bright Colors
  #   palette = 8={{colors.surface_container_high.default.hex}}
  #   palette = 9={{colors.error.default.hex}}
  #   palette = 10={{colors.primary.default.hex}}
  #   palette = 11={{colors.tertiary.default.hex}}
  #   palette = 12={{colors.primary.default.hex}}
  #   palette = 13={{colors.secondary.default.hex}}
  #   palette = 14={{colors.tertiary.default.hex}}
  #   palette = 15={{colors.on_surface.default.hex}}
  # '';

  # xdg.configFile."gtk-4.0/gtk.css" = {
  #   force = true;
  #   text = ''@import "${config.xdg.configHome}/gtk-4.0/colors.css"; '';
  # };

  # xdg.configFile."gtk-3.0/gtk.css" ={
  #   force = true;
  #   text = ''@import "${config.xdg.configHome}/gtk-3.0/colors.css";'';
  # };

    # 1. Create the ASCII file in ~/.config/fastfetch/nixowos.txt