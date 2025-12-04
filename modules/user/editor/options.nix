{lib, ...}:
{
  options.my.user.editor = {
    enable = lib.mkEnableOption "enable editor configuration";

    defaultEditor = lib.mkOption {
      type = lib.types.enum ["code" "nvim" "vi" "helix" "nano"];
      default = "nvim";
      description = "Which editor to choose be default";
    };

    lsp = {
      nix.enable = lib.mkOption { type = lib.types.bool; default = true; };
      bash.enable = lib.mkOption { type = lib.types.bool; default = true; };
      python.enable = lib.mkOption { type = lib.types.bool; default = true; };
      rust.enable = lib.mkOption { type = lib.types.bool; default = false; };
      javascript.enable = lib.mkOption { type = lib.types.bool; default = false; };
      go.enable = lib.mkOption { type = lib.types.bool; default = false; };
      java.enable = lib.mkOption { type = lib.types.bool; default = false; };
      c.enable = lib.mkOption { type = lib.types.bool; default = false; };
      yaml.enable = lib.mkOption { type = lib.types.bool; default = false; };
      markdown.enable = lib.mkOption { type = lib.types.bool; default = false; };
    };

    tools.enable = lib.mkEnableOption "Enable tools for specific editors";

    vscode = {
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

    nixvim = {
      enable = lib.mkEnableOption "NixVim (Neovim)" // { default = true; };

      leaderKey = lib.mkOption {
        type = lib.types.str;
        default = " ";
        description = "Leader key for keybindings";
      };

    };

    helix = {
      enable = lib.mkEnableOption "Helix editor";

      theme = lib.mkOption {
        type = lib.types.str;
        default = "dark_plus";
        description = "Helix color theme";
      };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Additional Helix configuration";
      };

      extraLanguages = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Additional language server configurations";
      };
    };
    
    vi.enable = lib.mkEnableOption "enable vi as an editor";
  };
}
