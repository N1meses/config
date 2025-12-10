{pkgs, ...}:
pkgs.mkShell {
  name = "python-dev";
  buildInputs = with pkgs; [
    black
    python313
    uv
  ];

  shellHook = ''
    echo "🐍 Welcome to the Python ssshell 🐍"
  '';
}
