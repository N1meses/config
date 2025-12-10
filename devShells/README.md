# Development Shells

Reproducible development environments using Nix.

## Available Shells

| Shell | Language | Version | Tools |
|-------|----------|---------|-------|
| python | Python | 3.13 | uv, black |
| java | Java | 21 | JDK |
| rust | Rust | stable | cargo, rustc |
| django | Python | 3.13 | uv, Django |
| chat | Python | 3.13 | uv, OpenAI SDK |
| stock-analysis | Python | 3.13 | uv, analysis libs |
| mcp-server | Python | 3.14 | uv, MCP SDK |

## Usage

```bash
# Enter a shell
nix develop .#python

# Run command without entering
nix develop .#python --command python script.py

# List all shells
nix flake show | grep devShells
```

## Structure

Each shell is in `devShells/<name>/default.nix`:

```nix
{pkgs, ...}:
pkgs.mkShell {
  name = "shell-name";

  buildInputs = with pkgs; [
    package1
    package2
  ];

  shellHook = ''
    echo "Shell activated"
  '';
}
```

## Adding a Shell

1. Create `devShells/myshell/default.nix`:

```nix
{pkgs, ...}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs
    yarn
  ];
}
```

2. Register in `flake-modules/dev-shells.nix`:

```nix
myshell = import ../devShells/myshell {
  inherit pkgs;
};
```

3. Test:
```bash
git add devShells/myshell flake-modules/dev-shells.nix
nix develop .#myshell
```

## Notes

- **chat** shell loads OpenAI API key from `~/.openai-key`
- Shells work offline after first build
- Use direnv for automatic activation (add `.envrc` with `use flake .#shell`)
