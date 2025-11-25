{pkgs, ... }:
{

	imports = [
		../../modules/user/bash
		../../modules/user/editor
		../../modules/user/preferences
		../../modules/user/hyprland
		../../modules/user/noctalia
		../../modules/user/niri
		../../modules/user/dotfiles
		../../modules/user/services
		../../modules/user/starship
	];

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
			xdg-desktop-portal-termfilechooser

			#cli
			fastfetch
			btop
			ani-cli
			libreoffice-qt6-fresh
			mpv
			claude-code
			cbonsai
			croc
			tmux
			ghostty
			gemini-cli
			zoxide
			trash-cli
			parted
			imv
			wl-clipboard
			grim
			swappy
			wf-recorder
			pay-respects
			todo
			nh
			nom
			nvd
			nix-tree
			eza
			lazygit
			zellij
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
}
