# Flake-Parts Migration Guide for Your NixOS Config

## Current State Analysis

Your flake (`/home/nimeses/nixconfig/flake.nix`) is 140 lines and manages:
- **3 hosts**: nimeses, prometheus, hephaistos
- **9 flake inputs**: nixpkgs, home-manager, hyprland, niri, quickshell, noctalia, nixvim, nix-index-database, blocklist-hosts
- **2 configuration types**: nixosConfigurations + homeConfigurations (duplicate module lists)
- **5 devShells**: python, java, stock-analysis, chat, django
- **Custom modules**: 14 system modules (`my.system.*`) + 8 user modules (`my.user.*`)
- **Single system**: x86_64-linux only

## Pain Points in Your Current Flake

### 1. **Duplicate Home Manager Integration** (Lines 76-96 and 104-114)
You repeat the same home-manager module imports for both `nixosConfigurations` and `homeConfigurations`:
- `niri.homeModules.niri`
- `nixvim.homeModules.nixvim`
- `nix-index-database.homeModules.nix-index`
- `programs.nix-index-database.comma.enable = true`

This is **duplicated across 6 places** (3 hosts × 2 config types).

### 2. **Hard-Coded System String** (Lines 59, 78, 117)
`system = "x86_64-linux"` is manually defined and passed around. Adding ARM support would require significant refactoring.

### 3. **Manual devShell Imports** (Lines 117-137)
Each devShell requires boilerplate: `import ./devShells/name { inherit pkgs; }`. Adding a new devShell means editing the flake.

### 4. **specialArgs/extraSpecialArgs Repetition** (Lines 95, 98, 114)
You pass `{inherit quickshell inputs;}` three times manually.

### 5. **Monolithic Flake File**
All configuration lives in one 140-line file. Related concerns (nixos configs, home-manager, devshells) are intermingled.

### 6. **No Type Checking**
If you accidentally set `packages.foo = "not-a-package"`, you won't know until evaluation fails with a cryptic error.

## What Flake-Parts Would Give You

### Benefits Specific to Your Config

#### 1. **Eliminate Home Manager Duplication**
Extract the repeated home-manager module list into a single flake module:

```nix
# flake-modules/home-manager.nix
{ inputs, ... }: {
  flake.homeModules.common = {
    imports = [
      inputs.niri.homeModules.niri
      inputs.nixvim.homeModules.nixvim
      inputs.nix-index-database.homeModules.nix-index
      {
        programs.nix-index-database.comma.enable = true;
        programs.command-not-found.enable = false;
      }
    ];
  };
}
```

Now referenced once, used everywhere.

#### 2. **Automatic System Handling**
```nix
systems = [ "x86_64-linux" ];  # Add "aarch64-linux" later if needed

perSystem = { pkgs, ... }: {
  devShells = {
    python = import ./devShells/python { inherit pkgs; };
    java = import ./devShells/java { inherit pkgs; };
    stock-analysis = import ./devShells/stock_analysis { inherit pkgs; };
    chat = import ./devShells/chat { inherit pkgs; };
    django = import ./devShells/django { inherit pkgs; };
  };
};
```

No more manual `devShells.${system}`. Adding ARM? Just add to `systems` list.

#### 3. **Type-Safe Configurations**
flake-parts validates:
- `nixosConfigurations` are proper NixOS systems
- `homeConfigurations` are proper Home Manager configs
- `packages` are actual derivations
- Options have correct types

#### 4. **Split Your 140-Line Flake**
```
nixconfig/
├── flake.nix                    # ~30 lines (just mkFlake + imports)
├── flake-modules/
│   ├── nixos-hosts.nix         # NixOS configurations
│   ├── home-manager.nix        # Home Manager integration
│   ├── devshells.nix           # Development shells
│   └── overlays.nix            # Niri overlay
```

Each module focuses on one concern.

#### 5. **Conditional Configuration**
Want to enable development tools only on your main machine?

```nix
{ config, lib, ... }: {
  options.isDevelopmentHost = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  perSystem = { pkgs, ... }: {
    devShells = lib.mkIf config.isDevelopmentHost {
      python = ...;
      # Only created on dev hosts
    };
  };
}
```

#### 6. **Access Ecosystem Modules**

**treefmt-nix**: Auto-format your Nix files
```nix
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs.alejandra.enable = true;  # Nix formatter
    };
  };
}
```

**pre-commit-hooks-nix**: Run checks before commits
```nix
{
  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem = {
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      statix.enable = true;
    };
  };
}
```

#### 7. **Use `inputs'` for Cleaner References**
Instead of `inputs.hyprland.packages.${system}.hyprland`, use:
```nix
perSystem = { inputs', ... }: {
  packages.myHyprlandWrapper = inputs'.hyprland.packages.hyprland;
};
```

System is automatically selected.

#### 8. **Module System Features**
Your `my.system.*` and `my.user.*` modules already use the module system. Now your **flake itself** can use:
- `lib.mkIf` for conditional outputs
- `lib.mkMerge` to combine configurations
- `lib.mkDefault` for overridable defaults
- Options with types and validation

## Migration Path

### Phase 1: Basic Adoption (Minimal Changes)

**Step 1: Add flake-parts input**
```nix
inputs.flake-parts.url = "github:hercules-ci/flake-parts";
```

**Step 2: Wrap existing outputs**
```nix
outputs = inputs @ { flake-parts, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];

    flake = {
      # Your current nixosConfigurations
      nixosConfigurations = inputs.nixpkgs.lib.genAttrs ["nimeses" "prometheus" "hephaistos"] (hostName:
        inputs.nixpkgs.lib.nixosSystem {
          # ... existing config
        }
      );

      # Your current homeConfigurations
      homeConfigurations = inputs.nixpkgs.lib.genAttrs ["nimeses" "prometheus" "hephaistos"] (hostName:
        inputs.home-manager.lib.homeManagerConfiguration {
          # ... existing config
        }
      );
    };

    perSystem = { pkgs, ... }: {
      devShells = {
        python = import ./devShells/python { inherit pkgs; };
        java = import ./devShells/java { inherit pkgs; };
        stock-analysis = import ./devShells/stock_analysis { inherit pkgs; };
        chat = import ./devShells/chat { inherit pkgs; };
        django = import ./devShells/django { inherit pkgs; };
      };
    };
  };
```

**Benefit**: Automatic system handling for devShells, familiar structure otherwise.

### Phase 2: Extract Modules (Better Organization)

**Step 3: Create `flake-modules/` directory**
```bash
mkdir /home/nimeses/nixconfig/flake-modules
```

**Step 4: Extract devShells**
```nix
# flake-modules/devshells.nix
{ ... }: {
  perSystem = { pkgs, ... }: {
    devShells = {
      python = import ../devShells/python { inherit pkgs; };
      java = import ../devShells/java { inherit pkgs; };
      stock-analysis = import ../devShells/stock_analysis { inherit pkgs; };
      chat = import ../devShells/chat { inherit pkgs; };
      django = import ../devShells/django { inherit pkgs; };
    };
  };
}
```

**Step 5: Extract NixOS configurations**
```nix
# flake-modules/nixos-hosts.nix
{ inputs, ... }: {
  flake.nixosConfigurations = inputs.nixpkgs.lib.genAttrs
    ["nimeses" "prometheus" "hephaistos"] (hostName:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [ inputs.niri.overlays.niri ];
        };
        modules = [
          ./hosts/${hostName}/default.nix
          inputs.home-manager.nixosModules.home-manager
          {
            environment.systemPackages = [
              inputs.home-manager.packages.x86_64-linux.home-manager
            ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${hostName} = {
              imports = [
                inputs.niri.homeModules.niri
                inputs.nixvim.homeModules.nixvim
                inputs.nix-index-database.homeModules.nix-index
                {
                  programs.nix-index-database.comma.enable = true;
                  programs.command-not-found.enable = false;
                }
                ./hosts/${hostName}/${hostName}.nix
              ];
            };
            home-manager.extraSpecialArgs = {
              inherit (inputs) quickshell;
              inherit inputs;
            };
          }
        ];
        specialArgs = {
          inherit (inputs) quickshell;
          inherit inputs;
        };
      }
    );
}
```

**Step 6: Update main flake.nix**
```nix
{
  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./flake-modules/nixos-hosts.nix
        ./flake-modules/home-configs.nix
        ./flake-modules/devshells.nix
      ];
    };
}
```

**Benefit**: Your main flake.nix becomes ~20 lines. Each concern in its own file.

### Phase 3: Advanced (DRY Improvements)

**Step 7: Create common home-manager module**
```nix
# flake-modules/home-manager-common.nix
{ inputs, ... }: {
  flake.homeModules.common = {
    imports = [
      inputs.niri.homeModules.niri
      inputs.nixvim.homeModules.nixvim
      inputs.nix-index-database.homeModules.nix-index
    ];

    programs.nix-index-database.comma.enable = true;
    programs.command-not-found.enable = false;
  };
}
```

**Step 8: Reference in host configs**
Update your host home-manager imports to:
```nix
home-manager.users.${hostName} = {
  imports = [
    inputs.self.homeModules.common  # Single source of truth
    ./hosts/${hostName}/${hostName}.nix
  ];
};
```

**Benefit**: Home manager modules defined once, no duplication across 6 places.

**Step 9: Add ecosystem modules**
```nix
# flake.nix
{
  inputs = {
    # ... existing inputs
    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks.flakeModule
        ./flake-modules/nixos-hosts.nix
        ./flake-modules/devshells.nix
        ./flake-modules/formatting.nix
      ];

      systems = [ "x86_64-linux" ];
    };
}
```

```nix
# flake-modules/formatting.nix
{ ... }: {
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs.alejandra.enable = true;
    };

    pre-commit.settings.hooks = {
      alejandra.enable = true;
      statix.enable = true;
    };
  };
}
```

**Benefit**: `nix fmt` automatically formats your code. Git hooks run checks before commits.

## Comparison: Before & After

### Before (Current)
```nix
# flake.nix - 140 lines, monolithic
{
  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; ... };
  in {
    nixosConfigurations.nimeses = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [
        ./hosts/nimeses/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.nimeses = {
            imports = [
              niri.homeModules.niri
              nixvim.homeModules.nixvim
              nix-index-database.homeModules.nix-index
              { programs.nix-index-database.comma.enable = true; }
              ./hosts/nimeses/nimeses.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations.prometheus = /* repeat everything */;
    nixosConfigurations.hephaistos = /* repeat everything */;

    homeConfigurations.nimeses = /* repeat module imports */;
    homeConfigurations.prometheus = /* repeat module imports */;
    homeConfigurations.hephaistos = /* repeat module imports */;

    devShells.${system} = {
      python = import ./devShells/python { inherit pkgs; };
      java = import ./devShells/java { inherit pkgs; };
      # ... manual imports
    };
  };
}
```

**Issues:**
- 6 places with duplicate home-manager imports
- Manual system handling
- Monolithic file
- No type checking

### After (With Flake-Parts)
```nix
# flake.nix - ~20 lines
{
  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./flake-modules/nixos-hosts.nix
        ./flake-modules/home-configs.nix
        ./flake-modules/devshells.nix
        ./flake-modules/formatting.nix
      ];
    };
}
```

```nix
# flake-modules/home-manager-common.nix - Define once
{
  flake.homeModules.common = {
    imports = [
      inputs.niri.homeModules.niri
      inputs.nixvim.homeModules.nixvim
      inputs.nix-index-database.homeModules.nix-index
    ];
    programs.nix-index-database.comma.enable = true;
  };
}
```

```nix
# flake-modules/devshells.nix - Automatic system
{
  perSystem = { pkgs, ... }: {
    devShells = {
      python = import ../devShells/python { inherit pkgs; };
      java = import ../devShells/java { inherit pkgs; };
      stock-analysis = import ../devShells/stock_analysis { inherit pkgs; };
      chat = import ../devShells/chat { inherit pkgs; };
      django = import ../devShells/django { inherit pkgs; };
    };
  };
}
```

**Benefits:**
- Single source of truth for home-manager imports
- Automatic system handling (easy to add ARM later)
- Modular structure (~20 lines per module)
- Type-checked outputs

## Recommended First Steps

### 1. Quick Win: Just Add perSystem for DevShells
**Time**: 10 minutes
**Benefit**: Automatic system handling, cleaner devShells

```bash
# Add to flake.nix inputs
flake-parts.url = "github:hercules-ci/flake-parts";
```

Wrap outputs with `mkFlake` and move devShells to `perSystem`. No other changes needed.

### 2. Medium Effort: Split Into Modules
**Time**: 30 minutes
**Benefit**: Better organization, easier to maintain

Create `flake-modules/` and extract nixos-hosts, home-configs, devshells into separate files.

### 3. Full Migration: DRY Everything
**Time**: 1-2 hours
**Benefit**: Eliminate all duplication, type safety, ecosystem access

Extract common home-manager module, add formatting/pre-commit hooks, use `inputs'` everywhere.

## When NOT to Use Flake-Parts

- **You're happy with current structure**: Your flake is already well-organized at 140 lines
- **No plans to expand**: If you won't add more hosts/systems/devshells
- **Learning overhead**: If you're still learning Nix basics, this adds complexity

## When You SHOULD Use Flake-Parts

- **Adding more hosts**: You're duplicating config for 3 hosts already
- **Want better organization**: Split 140 lines into focused modules
- **Need type safety**: Catch errors before `nixos-rebuild`
- **Want ecosystem tools**: treefmt, pre-commit, hercules-ci, etc.
- **Future ARM support**: Just add to `systems` list
- **Publishing modules**: Share your `my.system.*` modules with others

## Ecosystem Modules Relevant to You

### Immediate Value
- **treefmt-nix**: Auto-format Nix files (`nix fmt`)
- **pre-commit-hooks-nix**: Run checks before commits

### Future Value
- **nixos-unified**: Cleaner NixOS + home-manager integration
- **hercules-ci-effects**: CI/CD for your flake
- **devenv**: Enhanced development environments (more powerful than devShells)

## Your Specific Wins

Based on your current config structure:

1. **Eliminate 5 duplications** of home-manager module imports (lines 84-92 repeated across hosts)
2. **Reduce flake.nix from 140 to ~20 lines** by extracting modules
3. **Type-check your 3 nixosConfigurations** to catch errors early
4. **Auto-format your codebase** with treefmt (all your modules/system/* and modules/user/*)
5. **Easier to add 4th host**: Just add to genAttrs list, all config reused
6. **Publish your module system**: Your `my.system.*` and `my.user.*` could become reusable flake modules

## The Bottom Line

**You already embrace modularity** with your `modules/system/` and `modules/user/` structure. Flake-parts brings that same modularity to your flake itself.

**Your pain point**: Duplicating home-manager imports 6 times (3 hosts × 2 config types)
**Flake-parts solution**: Define once in `flake.homeModules.common`, reference everywhere

**Worth migrating?**
- **Yes, if**: You'll add more hosts, want better organization, or plan to use ecosystem modules
- **Maybe, if**: You're happy with current structure but curious about flake-parts features
- **No, if**: You're satisfied and don't see value in the benefits above

## Resources

- **Official docs**: https://flake.parts/
- **Module arguments**: https://flake.parts/module-arguments.html
- **Options reference**: https://flake.parts/options/flake-parts.html
- **Ecosystem modules**: https://github.com/wearetechnative/awesome-flake-parts
- **Example flakes**: https://flake.parts/ (Examples section)

## Next Steps

1. Review this guide
2. Decide which phase to attempt (1, 2, or 3)
3. Backup your current flake: `cp flake.nix flake.nix.backup`
4. Try Phase 1 migration (minimal changes, big benefits)
5. Test with: `nix flake check /home/nimeses/nixconfig`
6. Rebuild: `sudo nixos-rebuild test --flake /home/nimeses/nixconfig#nimeses`
7. If satisfied, commit and proceed to Phase 2
