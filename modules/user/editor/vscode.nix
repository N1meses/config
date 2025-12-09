{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user.editor.vscode;
in {
  options.my.user.editor.vscode = {
    enable = lib.mkEnableOption "VSCode editor";

    font = lib.mkOption {
      type = lib.types.str;
      default = "IBM Plex Mono";
      description = "Editor font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 14;
      description = "Editor font size";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "Nox Default";
      description = "VSCode color theme";
    };

    formatOnSave = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto-format on save";
    };

    extraExtensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional VSCode extensions";
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional VSCode settings";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      mutableExtensionsDir = true;

      profiles.default = {
        extensions = with pkgs.vscode-extensions;
          [
            jnoortheen.nix-ide
            ms-python.python
            ms-python.debugpy
            ms-python.black-formatter
            asvetliakov.vscode-neovim
          ]
          ++ [
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
              }
            )
          ]
          ++ cfg.extraExtensions;

        userSettings =
          {
            ############
            "python.formatting.provider" = "black";
            "python.formatting.blackArgs" = ["--line-length" "88"];
            "[python]" = {
              "editor.defaultFormatter" = "ms-python.black-formatter";
            };

            ##############
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
            "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";

            "editor.formatOnSave" = cfg.formatOnSave;
            "security.workspace.trust.enabled" = false;

            "editor.fontFamily" = cfg.font;
            "editor.fontSize" = cfg.fontSize;

            # File associations for QML syntax highlighting
            "files.associations" = {
              "*.qml" = "qml";
              "*.qmldir" = "qml";
              "*.js" = "javascript";
            };

            "extensions.experimental.affinity" = {
              "asvetliakov.vscode-neovim" = 1;
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

            "workbench.colorTheme" = cfg.theme;

            "workbench.colorCustomizations" = {
              # The background color you found
              "statusBar.background" = "#0D0D0D";
              "statusBar.noFolderBackground" = "#0D0D0D";

              # Optional: Match the foreground text color you found too
              "statusBar.foreground" = "#D4D4D4";

              # Optional: Remove the border for a completely seamless look
              "statusBar.border" = "#0D0D0D";
            };
          }
          // cfg.extraSettings;
      };
    };
  };
}
