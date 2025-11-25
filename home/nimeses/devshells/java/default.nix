{ pkgs, ... }:

pkgs.mkShell {
  name = "python-dev";
  buildInputs = with pkgs; [
    jdk21
  ];

  shellHook = ''
    echo "☕ Welcome to the Java Shell ☕"
  '';
}


