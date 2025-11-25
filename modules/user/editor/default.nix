{pkgs, ...}:
{
  home = {
    sessionVariables = {
      EDITOR = "code --wait";
			VISUAL = "code --wait";
    };
  };

  programs = {
    vscode = {
		enable = true;
		package = pkgs.vscode;                # not flatpak/snap
		mutableExtensionsDir = false;         # enforce HM-managed extensions


		profiles.default = {
			extensions = with pkgs.vscode-extensions;[
				jnoortheen.nix-ide
				ms-python.python
				ms-python.debugpy
				ms-python.black-formatter
			] ++ [
				# QML Language Support

				(pkgs.vscode-utils.buildVscodeMarketplaceExtension {
					mktplcRef = {
						name = "felgo";
						version = "2.0.1";
						publisher = "felgo";
						sha256 = "sha256-5bPbnDduGDAOU56TYRaWM1jxu1D7eczxCX1+xjwkTP8=";
					};
				})

				(
					pkgs.vscode-utils.buildVscodeMarketplaceExtension {
					mktplcRef = {
						name = "nox-theme";
						version = "1.0.4";
						publisher = "Agamjot-Singh";
						sha256 = "1iklybhfj5jhbj6y5vqjylv6236lzz4cr99vcdqwmp0gxyzxscpx";
					};
				})
			];	

			userSettings = {
				############
				"python.formatting.provider" = "black";
				"python.formatting.blackArgs" = [ "--line-length" "88" ];
				"[python]" = {
					"editor.defaultFormatter" = "ms-python.black-formatter";
				};
				
				##############
				"nix.enableLanguageServer" = true;
				"nix.serverPath" = "${pkgs.nixd}/bin/nixd";
				"nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";

				"editor.formatOnSave" = true;
				"security.workspace.trust.enabled" = false;

				"editor.fontFamily" = "IBM Plex Mono";
				"editor.fontSize" = 14;
				
				# File associations for QML syntax highlighting
				"files.associations" = {
					"*.qml" = "qml";
					"*.qmldir" = "qml";
					"*.js" = "javascript";
				};
				
				# QML-specific settings
				"[qml]" = {
					"editor.tabSize" = 4;
					"editor.insertSpaces" = true;
					"editor.autoIndent" = "advanced";
					"editor.bracketPairColorization.enabled" = true;
				};
				
				# Force file type detection
				"files.autoGuessEncoding" = true;
				
				"workbench.colorTheme"= "Nox Default";

				"workbench.colorCustomizations" = {
					# The background color you found
					"statusBar.background" = "#0D0D0D"; 
					"statusBar.noFolderBackground" = "#0D0D0D"; 
					
					# Optional: Match the foreground text color you found too
					"statusBar.foreground" = "#D4D4D4"; 
					
					# Optional: Remove the border for a completely seamless look
					"statusBar.border" = "#0D0D0D"; 
				};
			};
		};
	};
		
	nixvim = {
		enable = true;

		# Set <Space> as the leader key
		globals.mapleader = " ";

		# Basic editor options
		opts = {
			number = true;
			relativenumber = true;
			shiftwidth = 2;
			tabstop = 2;
			expandtab = true;
			clipboard = "unnamedplus"; # Use system clipboard
		};

		# Enable plugins
		plugins = {

			# File explorer
			neo-tree = {
				enable = true;
				settings.window.mappings = {
					"l" = "open";
					"h" = "close_node";
					"o" = "open"; # Make 'o' and 'l' behave the same
				};
			};

			web-devicons.enable = true;

			# Fuzzy finder
			telescope.enable = true;

			# Better syntax highlighting
			treesitter.enable = true;

			# Status line
			lualine.enable = true;

			# LSP (Language Server Protocol)
			lsp = {
				enable = true;
				servers = {
					# Add servers for languages you use
					nil_ls.enable = true;    # Nix
					bashls.enable = true;    # Bash
					pyright.enable = true;   # Python
					rust_analyzer = {
						enable = true; # Rust
						installCargo = true;
						installRustc = true;
					};
				};
			};

			# Auto-completion
			cmp.enable = true;
		};

		# Keymaps
		keymaps = [
			{
				mode = "n";
				key = "<leader>ff";
				action = "<cmd>Telescope find_files<cr>";
				options.desc = "Find Files";
			}
			{
				mode = "n";
				key = "<leader>fg";
				action = "<cmd>Telescope live_grep<cr>";
				options.desc = "Live Grep";
			}
			{
				mode = "n";
				key = "<leader>e";
				action = "<cmd>Neotree toggle<cr>";
				options.desc = "Toggle File Tree";
			}
		];
	};
  };
}