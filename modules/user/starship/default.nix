# ~/.config/home-manager/starship-enhanced.nix
# Starship with functional improvements (no color changes)
# Use this alongside your existing noctalia theming
{lib, ...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      # ═══════════════════════════════════════════════════════════
      # PERFORMANCE OPTIMIZATION
      # ═══════════════════════════════════════════════════════════
      scan_timeout = 30; # Faster directory scanning
      command_timeout = 500; # Timeout for slow commands
      add_newline = true;

      # ═══════════════════════════════════════════════════════════
      # ADVANCED DIRECTORY HANDLING
      # ═══════════════════════════════════════════════════════════
      directory = {
        # Fish-style path abbreviation: ~/Projects/myproject/src → ~/P/m/src
        fish_style_pwd_dir_length = 3;

        # Truncation settings
        truncation_length = 3; # Show 3 parent directories max
        truncate_to_repo = true; # Truncate to git root
        truncation_symbol = "…/";

        # Home symbol
        home_symbol = "󰋜 ~";

        # Read-only indicator
        read_only = " 󰌾";

        # Path substitutions - replace long paths with icons
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "nixconfig" = "";
          "~/.config" = " ";
        };

        # Highlight git repo root
        repo_root_style = "bold underline";
        repo_root_format = lib.concatStrings [
          "[$before_root_path]($before_repo_root_style)"
          "[$repo_root]($repo_root_style)"
          "[$path]($style)"
          "[$read_only]($read_only_style)"
        ];
      };

      # ═══════════════════════════════════════════════════════════
      # COMPREHENSIVE GIT STATUS WITH COUNTS
      # ═══════════════════════════════════════════════════════════

      git_branch = {
        symbol = " ";
        truncation_length = 25; # Longer branch names
        truncation_symbol = "…";
        only_attached = false; # Show detached HEAD
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        # Show counts for everything
        ahead = "⇡\${count} ";
        behind = "⇣\${count} ";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count} ";

        # File status with counts
        conflicted = "󰅖 \${count} "; # Merge conflicts
        stashed = "󰋻 \${count} "; # Stashed changes
        staged = "󰸞 \${count} "; # Staged files
        modified = "󰏫 \${count} "; # Modified files
        renamed = "󱀱 \${count} "; # Renamed files
        deleted = "󰅙 \${count} "; # Deleted files
        untracked = "󰓾 \${count} "; # Untracked files

        format = "[$all_status$ahead_behind]($style) ";
      };

      # Show commit hash when in detached HEAD
      git_commit = {
        commit_hash_length = 7;
        format = "[$hash$tag]($style) ";
        only_detached = true;
        tag_symbol = " 󰓹 ";
        tag_disabled = false;
      };

      # Show git state (rebasing, merging, etc.)
      git_state = {
        format = "[$state( $progress_current/$progress_total)]($style) ";
        rebase = "󰳖 REBASING";
        merge = " MERGING";
        revert = " REVERTING";
        cherry_pick = " PICKING";
        bisect = " BISECTING";
        am = " AM";
        am_or_rebase = " AM/REBASE";
      };

      # Show lines added/deleted in commits
      git_metrics = {
        disabled = false; # Enable (off by default)
        format = "([+$added]($added_style)[-$deleted]($deleted_style) )";
        only_nonzero_diffs = true; # Only show when there are changes
      };

      # ═══════════════════════════════════════════════════════════
      # PYTHON/DJANGO OPTIMIZATIONS
      # ═══════════════════════════════════════════════════════════

      python = {
        symbol = "🐍 ";
        format = "[$symbol$pyenv_prefix($version )(\\($virtualenv\\) )]($style)";

        # Better detection including Django
        detect_extensions = ["py" "ipynb"];
        detect_files = [
          "requirements.txt"
          "pyproject.toml"
          "Pipfile"
          "setup.py"
          "manage.py"
          "tox.ini"
          ".python-version"
        ];

        pyenv_version_name = false;
        python_binary = ["python3" "python"];
      };

      # Custom Django indicator
      custom.django = {
        detect_files = ["manage.py"];
        symbol = "🎸";
        format = "[$symbol]($style) ";
        disabled = false;
        description = "Django project indicator";
      };

      # ═══════════════════════════════════════════════════════════
      # NIX SHELL INDICATOR (important for NixOS workflow)
      # ═══════════════════════════════════════════════════════════

      nix_shell = {
        symbol = "❄️ ";
        format = "[$symbol$state(\\($name\\))]($style) ";
        impure_msg = "impure";
        pure_msg = "pure";
        heuristic = true; # Better detection
      };

      # ═══════════════════════════════════════════════════════════
      # OS SYMBOL (useful when SSH-ing between systems)
      # ═══════════════════════════════════════════════════════════

      os = {
        disabled = false;
        format = "[$symbol]($style) ";
      };

      os.symbols = {
        NixOS = "";
        Arch = "󰣇";
        Debian = "󰣚";
        Fedora = "󰣛";
        Linux = "";
        Macos = "";
        Ubuntu = "";
        Windows = "";
      };

      # ═══════════════════════════════════════════════════════════
      # COMMAND DURATION (show how long commands took)
      # ═══════════════════════════════════════════════════════════

      cmd_duration = {
        min_time = 2000; # Show after 2 seconds
        format = "[ 󱎫 $duration]($style) ";
        show_milliseconds = false;
      };

      # ═══════════════════════════════════════════════════════════
      # IMPROVED CHARACTER (prompt symbol)
      # ═══════════════════════════════════════════════════════════

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";

        # Vi mode indicators (if you use vi mode in bash/zsh)
        vimcmd_symbol = "[❮](bold green)";
        vimcmd_replace_one_symbol = "[❮](bold purple)";
        vimcmd_replace_symbol = "[❮](bold purple)";
        vimcmd_visual_symbol = "[❮](bold yellow)";
      };

      # ═══════════════════════════════════════════════════════════
      # PERFORMANCE: DISABLE UNUSED MODULES
      # These slow down the prompt but aren't typically needed
      # ═══════════════════════════════════════════════════════════

      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = true;
      docker_context.disabled = true;
      package.disabled = true; # Package version in project files
      battery.disabled = true; # Battery status

      # Optional: Enable if you need these
      # nodejs.disabled = false;
      # rust.disabled = false;
      # golang.disabled = false;
    };
  };
}
