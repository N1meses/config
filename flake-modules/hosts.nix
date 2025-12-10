{...}: {
  flake.hosts = {
    nimeses = {
      hostName = "nimeses";
      system = "x86_64-linux";
    };

    # Uncomment when ready:
    # prometheus = {
    #   hostName = "prometheus";
    #   system = "x86_64-linux";
    # };

    # hephaistos = {
    #   hostName = "hephaistos";
    #   system = "x86_64-linux";
    # };
  };
}
