# Modules

Custom NixOS and Home Manager modules using `my.system.*` and `my.user.*` namespaces.

## Namespaces

- `my.system.*` - NixOS system modules in `modules/system/`
- `my.user.*` - Home Manager user modules in `modules/user/`

Custom namespaces prevent conflicts with upstream options.

## System Modules

Located in `modules/system/`:

- `boot/` - Bootloader, Plymouth, kernel
- `host/` - userName, hostName
- `hyprland/` - Hyprland system setup
- `localization/` - Timezone, locale, keyboard
- `networking/` - NetworkManager, firewall
- `niri/` - Niri system setup
- `security/` - RTKit, PAM, GNOME Keyring
- `services/` - Bluetooth, audio, MySQL, Tailscale, etc.
- `settings/` - Nix daemon, experimental features, cachix
- `shell/` - Default shell configuration
- `virtualisation/` - Libvirt, QEMU, virt-manager
- `xdg/` - XDG portals for Wayland

### Usage

```nix
# In hosts/hostname/default.nix
{
  my.system.boot.enable = true;
  my.system.networking.enable = true;
  my.system.services.audio.enable = true;
}
```

## User Modules

Located in `modules/user/`:

- `browser/` - Browser configuration
- `dotfiles/` - App configs (ghostty, yazi, gtk, starship)
- `editor/` - VSCode, NixVim, Helix, JetBrains IDEs
- `hyprland/` - Hyprland user config, keybindings
- `niri/` - Niri user config, layout
- `noctalia/` - Noctalia shell interface
- `services/` - User services (clipboard, GPG, udiskie, direnv)
- `shell/` - Shell config (Bash/Zsh, aliases)

### Usage

```nix
# In hosts/hostname/hostname.nix
{
  my.user.editor.enable = true;
  my.user.editor.defaultEditor = "vscode";
  my.user.shell.enable = true;
}
```

## Module Pattern

```nix
{config, lib, pkgs, ...}:
{
  options.my.system.modulename = {
    enable = lib.mkEnableOption "description";
  };

  config = lib.mkIf config.my.system.modulename.enable {
    # configuration
  };
}
```

## Adding a Module

1. Create `modules/system/myfeature/default.nix` or `modules/user/myfeature/default.nix`
2. Define options under `my.system.myfeature` or `my.user.myfeature`
3. Use in host configuration

## Notes

- Some modules have parent `enable` options (boot, editor)
- Some are just categories (services, dotfiles) - enable each independently
- Critical modules use assertions to enforce explicit configuration
