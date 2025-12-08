{pkgs, ...}: {
  imports = [
    ../../modules/user/shell
    ../../modules/user/editor
    ../../modules/user/browser
    ../../modules/user/hyprland
    ../../modules/user/noctalia
    ../../modules/user/niri
    ../../modules/user/dotfiles
    ../../modules/user/services
    ../../modules/user/starship
  ];

  config = {
    home = {
      username = "nimeses";
      homeDirectory = "/home/nimeses";
      stateVersion = "25.05";

      sessionVariables = {
        GDK_SCALE = "1";
        GDK_DPI_SCALE = "1";
        QT_SCALE_FACTOR = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "0";
        HYPRLAND_NO_DPMS = "1";
        TERMCMD = "ghostty -e";
      };

      packages = with pkgs; [
        dbus
        wayland-utils
        hyprland-qtutils

        #cli
        fastfetch
        btop
        ani-cli
        libreoffice-qt6-fresh
        mpv
        claude-code
        cbonsai
        croc
        ghostty
        gemini-cli
        trash-cli
        parted
        imv
        grim
        swappy
        wf-recorder
        todo
        nh
        nom
        nvd
        nix-tree
        starship
        tldr

        #themeing
        ibm-plex
        nerd-fonts.symbols-only
        material-symbols
        qt6.qtdeclarative
        google-fonts
        matugen
        adw-gtk3
        nwg-look
        gnome-themes-extra
        gucharmap
        glib

        #applications
        jetbrains.idea-ultimate
        jetbrains.pycharm-professional
        jetbrains.datagrip
        discord
        obsidian
        gimp
        zathura
        file-roller
        galculator
        slurp
      ];
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
    };

    my.user = {
      shell = {
        enable = true;
        zoxide.enable = true;
        eza.enable = true;
        lazygit.enable = true;
        zellij.enable = false;
        payRespects.enable = false;
      };

      editor = {
        enable = true;
        defaultEditor = "helix";

        vscode.enable = true;
        nixvim.enable = true;
        helix = {
          enable = true;
          theme = "nox-default";
        };
        vi.enable = false;

        lsp = {
          nix.enable = true;
          bash.enable = true;
          python.enable = true;
          rust.enable = false;
          javascript.enable = false;
          go.enable = false;
          java.enable = false;
          c.enable = false;
          yaml.enable = false;
          markdown.enable = false;
        };
        tools.enable = true;
      };

      services = {
        enable = true;
        gnomeKeyring.enable = true;
        clipboard.wl-clip-persist.enable = true;
        security.gpg-agent.enable = true;
        storage.udiskie.enable = true;
        development.direnv.enable = true;
      };

      browser = {
        enable = true;
        brave.enable = true;
        defaultBrowser = "brave";
      };

      dotfiles = {
        enable = true;
        home-manager.enable = true;
        ghostty.enable = true;
        yazi.enable = true;
        nh.enable = true;
        fastfetch.enable = true;
        gtk.enable = true;
      };

      hyprland = {
        monitor = ["eDP-1,2880x1920@120,0x0,1.6"];

        settings = {
          gapSize = 4;
          borderSize = 2;
        };
      };
    };
  };
}
