# NixOS Configuration

Personal NixOS configuration using Flakes, Home Manager, and flake-parts.

## Structure

```
nixconfig/
├── flake.nix              # Main flake entry point
├── flake-modules/         # Flake-parts modules (see flake-modules/README.md)
├── hosts/                 # Per-host configurations
│   └── nimeses/
│       ├── default.nix           # System config
│       ├── nimeses.nix           # Home Manager config
│       └── hardware-configuration.nix
├── modules/
│   ├── system/            # NixOS modules (my.system.*)
│   └── user/              # Home Manager modules (my.user.*)
├── devShells/             # Development environments
└── assets/                # Icons, wallpapers, themes
```

## Basic Commands

### System
```bash
sudo nixos-rebuild switch --flake .#nimeses
sudo nixos-rebuild test --flake .#nimeses
```

### Home Manager
```bash
home-manager switch --flake .#nimeses
```

### Development Shells
```bash
nix develop .#python
nix develop .#java
nix develop .#rust
nix develop .#django
```

### Maintenance
```bash
nix flake update         # Update inputs
nix flake check          # Check for errors
nix flake show           # Show outputs
nix fmt                  # Format with alejandra
nix-collect-garbage -d   # Clean old generations
```

## Module System

Configuration uses custom namespaces:
- `my.system.*` for NixOS system configuration
- `my.user.*` for Home Manager user configuration

## Window Managers

- **Hyprland** - Tiling compositor with vim-style keybindings
- **Niri** - Scrollable-tiling compositor
- **Noctalia** - Shell interface (bar, launcher, control center)

## Keybindings

- `Super + Return` - Terminal
- `Super + E` - File manager
- `Super + M` - Launcher
- `Super + Q` - Close window
- `Super + H/J/K/L` - Navigate (vim-style)
- `Super + 1-9` - Switch workspace

## Adding a Host

1. Create `hosts/hostname/` directory
2. Add `default.nix` (system) and `hostname.nix` (home)
3. Uncomment in `flake-modules/nixos-configurations.nix` and `flake-modules/home-configurations.nix`
4. Rebuild: `sudo nixos-rebuild switch --flake .#hostname`

## Documentation

- [modules/README.md](./modules/README.md) - Module system structure
- [flake-modules/README.md](./flake-modules/README.md) - Flake-parts organization
- [devShells/README.md](./devShells/README.md) - Development environments
