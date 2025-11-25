{pkgs}:
pkgs.mkShell {
  name = "django-dev";
  buildInputs = with pkgs; [
    python313
    uv
  ];

  shellHook = ''
    echo "DJ Welcome to the Django ssshell"
    cd ~/nixconfig/home/nimeses/devshells/django/
    '';
}
