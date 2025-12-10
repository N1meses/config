{
  inputs,
  withSystem,
  ...
}: {
  flake.homeConfigurations = let
    mkHomeConfiguration = hostName: system:
      withSystem system (
        {pkgs, ...}:
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              inputs.niri.homeModules.niri
              inputs.nixvim.homeModules.nixvim
              inputs.nix-index-database.homeModules.nix-index
              {
                programs.nix-index-database.comma.enable = true;
                programs.command-not-found.enable = false;
              }
              ../hosts/${hostName}/${hostName}.nix
            ];
            extraSpecialArgs = {
              inherit (inputs) quickshell;
              inherit inputs;
            };
          }
      );
  in {
    nimeses = mkHomeConfiguration "nimeses" "x86_64-linux";
    # prometheus = mkHomeConfiguration "prometheus" "x86_64-linux";
    # hephaistos = mkHomeConfiguration "hephaistos" "x86_64-linux";
  };
}
