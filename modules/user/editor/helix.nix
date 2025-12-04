{config, lib, pkgs, ...}:
let
  mue = config.my.user.editor;
  noxTheme = import ./themes/nox-default.nix;
in {

  config = lib.mkIf mue.helix.enable {
    programs.helix = {
      enable = true;

      themes = noxTheme;

      settings = {
        theme = mue.helix.theme;

        editor = {
          line-number = "relative";
          mouse = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          file-picker.hidden = false;
          indent-guides.render = true;
        } // mue.helix.extraConfig;

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
            };
          })
          (lib.mkIf mue.lsp.rust.enable {
            rust-analyzer = {
              command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
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
            };
          })
          mue.helix.extraLanguages
        ];

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.alejandra}/bin/alejandra";
            language-servers = lib.optional mue.lsp.nix.enable "nixd";
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
          }
          {
            name = "rust";
            auto-format = true;
            language-servers = lib.optional mue.lsp.rust.enable "rust-analyzer";
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
            language-servers = lib.optional mue.lsp.javascript.enable
        "typescript-language-server";
          }
          {
            name = "typescript";
            auto-format = true;
            language-servers = lib.optional mue.lsp.javascript.enable
        "typescript-language-server";
          }
        ];
      };
    };
  };
}
