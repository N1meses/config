{pkgs, ...}:


pkgs.mkShell {
  name = "python-dev";
  buildInputs = with pkgs; [
    python313
    uv
 ];

  shellHook = ''
    echo "📈 Lets make some stonks 📈"
  '';
}
