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
		username = "hephaistos";
		homeDirectory = "/home/hephaistos";
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
			# Minimal placeholder package list
			dbus
			wayland-utils
			fastfetch
			btop
			ghostty
			wl-clipboard
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
