{config, lib, pkgs, ...}:
let 
  mue = config.my.user.editor;
in {
  config = lib.mkIf mue.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      mutableExtensionsDir = true;

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
        ] ++ mue.vscode.extraExtensions;

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

          "editor.formatOnSave" = mue.vscode.formatOnSave;
          "security.workspace.trust.enabled" = false;

          "editor.fontFamily" = mue.vscode.font;
          "editor.fontSize" = mue.vscode.fontSize;
          
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
          
          "workbench.colorTheme"= mue.vscode.theme;

          "workbench.colorCustomizations" = {
            # The background color you found
            "statusBar.background" = "#0D0D0D"; 
            "statusBar.noFolderBackground" = "#0D0D0D"; 
            
            # Optional: Match the foreground text color you found too
            "statusBar.foreground" = "#D4D4D4"; 
            
            # Optional: Remove the border for a completely seamless look
            "statusBar.border" = "#0D0D0D"; 
          }; 
        } // mue.vscode.extraSettings;
      };
    };
  };
}
