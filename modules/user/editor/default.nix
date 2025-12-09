{
  config,
  lib,
  pkgs,
  ...
}: let
  mue = config.my.user.editor;
in {
  imports = [
    ./vscode.nix
    ./nixvim.nix
    ./helix.nix
    ./jetbrains.nix
    ./vi.nix
  ];

  options.my.user.editor = {
    enable = lib.mkEnableOption "enable editor configuration";

    defaultEditor = lib.mkOption {
      type = lib.types.enum ["code" "nvim" "vi" "helix" "nano"];
      default = "nvim";
      description = "Which editor to choose be default";
    };

    lsp = {
      nix.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      bash.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      python.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      rust.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      javascript.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      go.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      java.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      c.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      yaml.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      markdown.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };

    tools.enable = lib.mkEnableOption "Enable tools for specific editors";
  };

  config = lib.mkIf mue.enable {
    home.sessionVariables = {
      EDITOR =
        if (mue.defaultEditor == "code")
        then "code --wait"
        else if (mue.defaultEditor == "nvim")
        then "nvim"
        else if (mue.defaultEditor == "helix")
        then "hx"
        else if (mue.defaultEditor == "vi")
        then "vi"
        else "nano";

      VISUAL =
        if (mue.defaultEditor == "code")
        then "code --wait"
        else if (mue.defaultEditor == "nvim")
        then "nvim"
        else if (mue.defaultEditor == "helix")
        then "hx"
        else if (mue.defaultEditor == "vi")
        then "vi"
        else "nano";
    };

    xdg.mimeApps = let
      editorDesktop =
        if mue.defaultEditor == "code"
        then "code.desktop"
        else if mue.defaultEditor == "nvim"
        then "nvim.desktop"
        else if mue.defaultEditor == "helix"
        then "helix.desktop"
        else if mue.defaultEditor == "vi"
        then "vi.desktop"
        else "nano.desktop";
    in {
      enable = true;

      defaultApplications = {
        "text/x-nix" = [editorDesktop];
        "text/plain" = [editorDesktop];
      };

      associations.added = {
        "text/x-nix" = [editorDesktop];
        "text/plain" = [editorDesktop];
      };
    };

    home.packages = with pkgs;
      []
      ###       lsp       ###
      ++ lib.optionals mue.lsp.nix.enable [
        nixd
        alejandra
      ]
      ++ lib.optional mue.lsp.bash.enable bash-language-server
      ++ lib.optional mue.lsp.go.enable gopls
      ++ lib.optional mue.lsp.java.enable jdt-language-server
      ++ lib.optional mue.lsp.c.enable clang-tools
      ++ lib.optional mue.lsp.yaml.enable yaml-language-server
      ++ lib.optional mue.lsp.markdown.enable marksman
      ++ lib.optionals mue.lsp.python.enable [
        python3Packages.python-lsp-server
        ruff
      ]
      ++ lib.optionals mue.lsp.rust.enable [
        rust-analyzer
        cargo
        rustc
        rustfmt
      ]
      ++ lib.optionals mue.lsp.javascript.enable [
        typescript-language-server
        nodePackages.vscode-langservers-extracted
      ]
      ###     tools     ###
      ++ lib.optionals mue.tools.enable [
        ripgrep
        fd
      ];
  };
}
