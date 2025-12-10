# Flake Modules

Flake-parts modules that organize flake outputs.

## Structure

```
flake-modules/
├── common.nix                # Shared pkgs with overlays
├── formatter.nix             # Alejandra formatter
├── nixos-configurations.nix  # NixOS system configs
├── home-configurations.nix   # Home Manager configs
├── hosts.nix                 # Host configs
└── dev-shells.nix           # Development environments
```

## Modules

### common.nix

Defines shared `pkgs` instance with:
- `allowUnfree = true`
- Niri overlay applied
- Used by all other modules via `withSystem`

Eliminates duplicate pkgs creation.

### formatter.nix

Enables `nix fmt` using alejandra:
```bash
nix fmt                 # Format all files
nix fmt -- --version    # Check version
```

### nixos-configurations.nix

Creates `nixosConfigurations` output for each host:
- Uses shared pkgs via `withSystem`
- Integrates Home Manager
- Imports from `hosts/`

### home-configurations.nix

Creates `homeConfigurations` for standalone Home Manager:
- Uses shared pkgs via `withSystem`
- Enables `home-manager switch --flake .#hostname`

### dev-shells.nix

Registers development shells from `devShells/`:
- python, java, rust
- django, chat, mcp-server, stock-analysis

## Key Concepts

### perSystem

Runs for each system in `systems` list:
```nix
perSystem = {pkgs, system, ...}: {
  devShells.python = pkgs.mkShell { ... };
};
```

### withSystem

Access perSystem context from flake outputs:
```nix
flake.nixosConfigurations = {
  host = withSystem "x86_64-linux" ({pkgs, ...}:
    # pkgs available here
  );
};
```

### flake.*

Define non-perSystem outputs:
```nix
flake.nixosModules.default = { ... };
```

## Architecture

```
flake.nix
├── systems = ["x86_64-linux"]
└── imports = [
    ├── common.nix              → pkgs (perSystem)
    ├── formatter.nix           → alejandra (perSystem)
    ├── nixos-configurations.nix → uses pkgs (withSystem)
    ├── home-configurations.nix  → uses pkgs (withSystem)
    └── dev-shells.nix          → shells (perSystem)
    ]
```

## Before/After

**Before**: 137 lines in flake.nix, duplicate pkgs in 3 places
**After**: 62 lines in flake.nix, single pkgs definition

## Adding a Module

1. Create `flake-modules/mymodule.nix`
2. Add to `imports` in `flake.nix`
3. Use `perSystem` for system-specific outputs
4. Use `flake.*` for system-agnostic outputs
