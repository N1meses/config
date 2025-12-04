{config, lib, pkgs, ...}:
let 
  mue = config.my.user.editor;
in {
  imports = [
    ./options.nix
    ./vscode.nix
    ./nixvim.nix
    ./helix.nix
  ];

  config = lib.mkIf mue.enable {
    home.sessionVariables = {
      EDITOR = 
        if (mue.defaultEditor == "code") then "code --wait"
        else if (mue.defaultEditor == "nvim") then "nvim"
        else if (mue.defaultEditor == "helix") then "hx"
        else if (mue.defaultEditor == "vi") then "vi"
        else "nano";

      VISUAL = 
        if (mue.defaultEditor == "code") then "code --wait"
        else if (mue.defaultEditor == "nvim") then "nvim"
        else if (mue.defaultEditor == "helix") then "hx"
        else if (mue.defaultEditor == "vi") then "vi"
        else "nano"; 
    };
    
    xdg.mimeApps = 
      let
        editorDesktop =
          if mue.defaultEditor == "code" then "code.desktop"
          else if mue.defaultEditor == "nvim" then "nvim.desktop"
          else if mue.defaultEditor == "helix" then "helix.desktop"
          else if mue.defaultEditor == "vi" then "vi.desktop"
          else "nano.desktop";
      in {

      enable = true;

      defaultApplications = {
        "text/x-nix" = [ editorDesktop ];
        "text/plain" = [ editorDesktop ];
      };

      associations.added = {
        "text/x-nix" = [ editorDesktop ];
        "text/plain" = [ editorDesktop ];
      };
    };
    
    home.packages = with pkgs; []

     ###     editors     ###
      ++ lib.optional mue.vi.enable vi

     ###       lsp       ###
      ++ lib.optionals mue.lsp.nix.enable [
        nixd
        alejandra]
      ++ lib.optional mue.lsp.bash.enable bash-language-server
      ++ lib.optional mue.lsp.go.enable gopls
      ++ lib.optional mue.lsp.java.enable jdt-language-server
      ++ lib.optional mue.lsp.c.enable clang-tools
      ++ lib.optional mue.lsp.yaml.enable yaml-language-server
      ++ lib.optional mue.lsp.markdown.enable marksman
      ++ lib.optionals mue.lsp.python.enable [
        python3Packages.python-lsp-server
        ruff ]
      ++ lib.optionals mue.lsp.rust.enable [
        rust-analyzer
        cargo
        rustc
        rustfmt ]
      ++ lib.optionals mue.lsp.javascript.enable [
        typescript-language-server
        nodePackages.vscode-langservers-extracted ]

     ###     tools     ###
      ++ lib.optionals mue.tools.enable [
        ripgrep
        fd ];
    };
  }
