{config, lib, ...}:
let 
  mue = config.my.user.editor;
in {
  config =  lib.mkIf mue.nixvim.enable {
    programs.nixvim = {
      enable = true;

      # Set <Space> as the leader key
      globals.mapleader = mue.nixvim.leaderKey;

      # Basic editor options
      opts = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
        clipboard = "unnamedplus"; # Use system clipboard
        completeopt = ["menu" "menuone" "noselect"];
      };

      # Enable plugins
      plugins = {

        # UI improvements
        lspkind = {
          enable = true;
          settings.cmp = {
            enable = true;
            menu = {
              nvim_lsp = "[LSP]";
              luasnip = "[snip]";
              buffer = "[buf]";
              path = "[path]";
            };
          };
        };
        fidget.enable = true; # LSP progress notifications

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
            nixd.enable = mue.lsp.nix.enable;      # Nix
            bashls.enable = mue.lsp.bash.enable;    # Bash
            gopls.enable = mue.lsp.go.enable;         # Go
            jdtls.enable = mue.lsp.java.enable;       # Java
            clangd.enable = mue.lsp.c.enable;         # C/C++
            yamlls.enable = mue.lsp.yaml.enable;      # YAML
            marksman.enable = mue.lsp.markdown.enable; # Markdown
            ts_ls.enable = mue.lsp.javascript.enable;  # TypeScript/JavaScript
            pyright = {
              enable = mue.lsp.python.enable;
              settings.pyright.disableOrganizeImports = true; # Let Ruff handle imports
            };
            ruff.enable = mue.lsp.python.enable;      # Python linting/formatting
            rust_analyzer = {
              enable = mue.lsp.rust.enable; # Rust
              installCargo = true;
              installRustc = true;
            };
          };
        };

        # Auto-completion
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            snippet.expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';

            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-e>" = "cmp.mapping.close()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            };

            sources = [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "buffer"; }
              { name = "path"; }
            ];
          };
        };

        # Snippet engine (required for cmp)
        luasnip.enable = true;

        # Autopairs
        nvim-autopairs.enable = true;
      };

      # Auto-formatting
      autoCmd = [
        {
          event = "BufWritePre";
          pattern = "*.py";
          command = "lua vim.lsp.buf.format({ name = 'ruff', async = false })";
        }
      ];

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
