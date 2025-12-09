{
  config,
  lib,
  pkgs,
  ...
}: let
  mue = config.my.user.editor;
  cfg = config.my.user.editor.helix;
  noxTheme = import ./themes/nox-default.nix;
in {
  options.my.user.editor.helix = {
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

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;

      themes = noxTheme;

      settings = {
        theme = cfg.theme;

        editor =
          {
            line-number = "relative";
            mouse = true;
            clipboard-provider = "wayland";
            default-yank-register = "+";
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
            file-picker.hidden = false;
            indent-guides.render = true;
          }
          // cfg.extraConfig;

        keys.normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          esc = ["collapse_selection" "keep_primary_selection"];
        };
      };

      languages = {
        language-server = lib.mkMerge [
          (lib.mkIf mue.lsp.nix.enable {
            nixd = {
              command = "${pkgs.nixd}/bin/nixd";
              config.nixd = {
                formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
                options = {
                  nixos.expr = "(builtins.getFlake \"/home/nimeses/nixconfig\").nixosConfigurations.nimeses.options";
                  home-manager.expr = "(builtins.getFlake \"/home/nimeses/nixconfig\").homeConfigurations.nimeses.options";
                };
              };
            };
          })
          (lib.mkIf mue.lsp.bash.enable {
            bash-language-server = {
              command = "${pkgs.bash-language-server}/bin/bash-language-server";
              args = ["start"];
            };
          })
          (lib.mkIf mue.lsp.python.enable {
            pylsp = {
              command = "${pkgs.python3Packages.python-lsp-server}/bin/pylsp";
              config.pylsp = {
                plugins = {
                  ruff.enabled = true;
                  pycodestyle.enabled = false; # ruff handles this
                  pyflakes.enabled = false; # ruff handles this
                  autopep8.enabled = false; # use ruff
                  yapf.enabled = false; # use ruff
                };
              };
            };
          })
          (lib.mkIf mue.lsp.rust.enable {
            rust-analyzer = {
              command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
              config.rust-analyzer = {
                check.command = "clippy"; # Use clippy instead of check
                cargo.loadOutDirsFromCheck = true;
                procMacro.enable = true;
              };
            };
          })
          (lib.mkIf mue.lsp.go.enable {
            gopls = {
              command = "${pkgs.gopls}/bin/gopls";
            };
          })
          (lib.mkIf mue.lsp.java.enable {
            jdtls = {
              command = "${pkgs.jdt-language-server}/bin/jdtls";
            };
          })
          (lib.mkIf mue.lsp.c.enable {
            clangd = {
              command = "${pkgs.clang-tools}/bin/clangd";
              args = [
                "--background-index"
                "--clang-tidy"
                "--completion-style=detailed"
                "--header-insertion=iwyu"
              ];
            };
          })
          (lib.mkIf mue.lsp.yaml.enable {
            yaml-language-server = {
              command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
              args = ["--stdio"];
            };
          })
          (lib.mkIf mue.lsp.markdown.enable {
            marksman = {
              command = "${pkgs.marksman}/bin/marksman";
              args = ["server"];
            };
          })
          (lib.mkIf mue.lsp.javascript.enable {
            typescript-language-server = {
              command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
              args = ["--stdio"];
              config.typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all";
                  includeInlayFunctionParameterTypeHints = true;
                  includeInlayVariableTypeHints = true;
                };
              };
            };
          })
          cfg.extraLanguages
        ];

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.alejandra}/bin/alejandra";
            language-servers = lib.optional mue.lsp.nix.enable "nixd";
            roots = ["flake.nix" "flake.lock" ".git"];
          }
          {
            name = "bash";
            auto-format = true;
            language-servers = lib.optional mue.lsp.bash.enable "bash-language-server";
          }
          {
            name = "python";
            auto-format = true;
            language-servers = lib.optional mue.lsp.python.enable "pylsp";
            roots = ["pyproject.toml" "setup.py" "requirements.txt" ".git"];
          }
          {
            name = "rust";
            auto-format = true;
            language-servers = lib.optional mue.lsp.rust.enable "rust-analyzer";
            roots = ["Cargo.toml" "Cargo.lock" ".git"];
          }
          {
            name = "go";
            auto-format = true;
            language-servers = lib.optional mue.lsp.go.enable "gopls";
          }
          {
            name = "java";
            auto-format = true;
            language-servers = lib.optional mue.lsp.java.enable "jdtls";
          }
          {
            name = "c";
            auto-format = true;
            language-servers = lib.optional mue.lsp.c.enable "clangd";
          }
          {
            name = "cpp";
            auto-format = true;
            language-servers = lib.optional mue.lsp.c.enable "clangd";
          }
          {
            name = "yaml";
            auto-format = true;
            language-servers = lib.optional mue.lsp.yaml.enable "yaml-language-server";
          }
          {
            name = "markdown";
            auto-format = true;
            language-servers = lib.optional mue.lsp.markdown.enable "marksman";
          }
          {
            name = "javascript";
            auto-format = true;
            language-servers =
              lib.optional mue.lsp.javascript.enable
              "typescript-language-server";
          }
          {
            name = "typescript";
            auto-format = true;
            language-servers =
              lib.optional mue.lsp.javascript.enable
              "typescript-language-server";
          }
        ];
      };
    };
  };
}
