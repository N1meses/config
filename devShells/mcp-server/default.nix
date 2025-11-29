{pkgs, ...}:
pkgs.mkShell {
  name = "mcp-server development shell";
  buildInputs = with pkgs;[
    python314
    uv
  ];

  shellHook = ''
    echo "Model Conetxt Protocol SHell activ"
  '';
}