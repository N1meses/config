{pkgs, ...}:


pkgs.mkShell {
  name = "python-dev";
  buildInputs = with pkgs; [
    black
    python313
    uv
    python313Packages.yfinance
    python313Packages.pandas
    python313Packages.numpy
    python313Packages.multiprocess
    (callPackage ../../self_packages/ta.nix {})
  ];

  shellHook = ''
    echo "📈 Lets make some stonks 📈"
  '';
}