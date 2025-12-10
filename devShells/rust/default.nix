{pkgs, ...}:
pkgs.mkShell {
  name = "rust-dev";

  buildInputs = with pkgs; [
    cargo
  ];
}
